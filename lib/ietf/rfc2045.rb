require 'ietf/rfc822'
module IETF
  module RFC2045
    def self.parse_rfc2045_from(raw)
      headers, raw = IETF::RFC822.parse_rfc822_from(raw)

      if headers['content-type'] =~ /multipart\/(\w+); boundary=(.*)/
        content = {}
        content[:type] = $1
        content[:boundary] = $2
        content[:content] = IETF::RFC2045.parse_rfc2045_content_from(raw, content[:boundary])
      else
        content = raw
      end

      return [headers, content]
    end

    def self.parse_rfc2045_content_from(raw, boundary)
      raw.split(/#{CRLF.source}--#{boundary}(?:--)?(?:#{CRLF.source}|$)/).collect {|part|
        IETF::RFC2045.parse_rfc2045_from(part)
      }
    end
  end
end
