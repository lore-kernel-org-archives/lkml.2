Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2EWFKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:10:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59631 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974Ab2EWFKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:10:53 -0400
Message-ID: <1337749848.13111.40.camel@joe2Laptop>
Subject: Re: [PATCH] Add human-readable units modifier to vsnprintf()
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Date: Tue, 22 May 2012 22:10:48 -0700
In-Reply-To: <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
	 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	 <20120522211706.GH14339@google.com>
	 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337744190.13111.33.camel@joe2Laptop>
	 <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 00:50 -0400, Kent Overstreet wrote:
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1002,6 +1023,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
>  		case ' ': spec->flags |= SPACE;   break;
>  		case '#': spec->flags |= SPECIAL; break;
>  		case '0': spec->flags |= ZEROPAD; break;
> +		case 'h': spec->flags |= HUNITS;  break;
>  		default:  found = false;
>  		}
>  

I think that doesn't work well because
gcc __attribute__((format(printf, x, y)))
verification fails.  It's also possible
to confuse it with printf's own 'h' / 
integer precision use.

$ cat h.c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
  printf("%h02u\n", 1);
  return 0;
}

$ gcc h.c
h.c: In function ‘main’:
h.c:6:3: warning: unknown conversion type character ‘0’ in format [-Wformat]


