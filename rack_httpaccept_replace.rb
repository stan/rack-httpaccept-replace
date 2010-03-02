# The MIT License
#
# Copyright (c) 2009 Stanislas Mazurek
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Notes for the wise
#
# IE8 on Windows Vista (Compatibility View) : Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Trident/4.0)
# IE8 on Windows Vista : Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)
# 
# usage:
# config.middleware.use Rack::HttpacceptReplace
# 
# eventually:
# config.middleware.use Rack::HttpacceptReplace, :target => /abc/, :replace_with => "xyz"

module Rack

  class HttpacceptReplace

    def initialize(app, options = {})
      @app = app
      @regex_ua_target = options[:target] || /MSIE [7|8].0/i
      @replace_with = options[:replace_with] || "*/*"
    end

    # Because the web app may be multithreaded, this method must
    # create new Regexp instances to ensure thread safety.
    def call(env)
      env['HTTP_ACCEPT'] = @replace_with if Regexp.new(@regex_ua_target).match(env.fetch('HTTP_USER_AGENT', ''))
      @app.call(env)
    end

  end

end