Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2EWFWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:22:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51215 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2EWFWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:22:36 -0400
Date: Wed, 23 May 2012 01:22:36 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [PATCH] Add human-readable units modifier to vsnprintf()
Message-ID: <20120523052236.GA14312@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337744190.13111.33.camel@joe2Laptop>
 <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337749848.13111.40.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337749848.13111.40.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:10:48PM -0700, Joe Perches wrote:
> On Wed, 2012-05-23 at 00:50 -0400, Kent Overstreet wrote:
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -1002,6 +1023,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
> >  		case ' ': spec->flags |= SPACE;   break;
> >  		case '#': spec->flags |= SPECIAL; break;
> >  		case '0': spec->flags |= ZEROPAD; break;
> > +		case 'h': spec->flags |= HUNITS;  break;
> >  		default:  found = false;
> >  		}
> >  
> 
> I think that doesn't work well because
> gcc __attribute__((format(printf, x, y)))
> verification fails.

Yeah, I already ran into that. I was looking through the gcc docs to see
if there was a way to add modifiers (how is it done for the other kernel
specific format strings?) but I haven't found anything yet

> It's also possible
> to confuse it with printf's own 'h' / 
> integer precision use.

Well, that's annoying. Any suggestions?

> 
> $ cat h.c
> #include <stdio.h>
> #include <stdlib.h>
> 
> int main(int argc, char** argv)
> {
>   printf("%h02u\n", 1);
>   return 0;
> }
> 
> $ gcc h.c
> h.c: In function ‘main’:
> h.c:6:3: warning: unknown conversion type character ‘0’ in format [-Wformat]
> 
> 
