Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab1FGBMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:12:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53487 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1FGBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=mC7aZCcI4qWkKRSzpDq1/vPwzXQ/0gq+QfZFwMUjnLOMZJnv+49fM+8SsHEuWPEArJ
         9zuuJhyenVVyDkYWNZJYp0ntnE5f75scFgjwGQwESRHzRiT/DI8GBAYOTEaZHxrQHa5T
         a38alx09c4MSmCnVlu3PKJRAcn+7bKO8nJRdY=
Date: Tue, 7 Jun 2011 09:12:02 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Remove a warning for drivers/edac/i82975x_edac.c
Message-ID: <20110607011200.GC8892@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20110604022151.GA2475@gmail.com>
 <20110606133652.1d146bba.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110606133652.1d146bba.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:36:52PM -0700, Randy Dunlap wrote:
> On Sat, 4 Jun 2011 10:22:21 +0800 Harry Wei wrote:
> 
> > From: Harry Wei <harryxiyou@gmail.com>
> > 
> > When i compile 2.6.39.1, a warning shows like below.
> > This patch can fix the warning. And i works well with
> > my PC.
> 
> Hi Harry,
> 
> Does "works well with my PC" mean that you boot-tested this patch
> or just compile-tested it?
No, i just test with the following codes.

#include <stdio.h>

int main(void)
{
	unsigned long a;

	a = 0x100000000ul;
	printf("%lu\n", a);
	return 0;
}
jiawei@jiawei-laptop:~/GTK$ gcc 5.c -Wall -o 1
5.c: In function ‘main’:
5.c:7: warning: integer constant is too large for ‘unsigned long’ type
5.c:7: warning: large integer implicitly truncated to unsigned type

But if you program it like below, it is well for us.

#include <stdio.h>

int main(void)
{
	unsigned long long a;

	a = 0x100000000ull;

	printf("%llu\n", a);
	return 0;
}

> 
> and if you boot-tested it, do you have hardware that actually
> exercises this code path?
> 
> > [...]
> > CC [M]  drivers/edac/e752x_edac.o
> > CC [M]  drivers/edac/i82875p_edac.o
> > CC [M]  drivers/edac/i82975x_edac.o
> > drivers/edac/i82975x_edac.c: In function ?????????i82975x_process_error_info?????????:
> > drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for ?????????unsigned long????????? type
> > CC [M]  drivers/edac/i3000_edac.o
> > CC [M]  drivers/edac/i3200_edac.o
> > CC [M]  drivers/edac/x38_edac.o
> > CC [M]  drivers/edac/i82860_edac.o
> > [...]
> > 
> > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> > 
> > Index: prj/drivers/edac/i82975x_edac.c
> > ===================================================================
> > --- prj.orig/drivers/edac/i82975x_edac.c	2011-06-04 10:09:55.351174516 +0800
> > +++ prj/drivers/edac/i82975x_edac.c	2011-06-04 10:10:30.875168437 +0800
> > @@ -293,9 +293,9 @@
> >  		info->errsts = info->errsts2;
> >  	}
> >  
> > -	page = (unsigned long) info->eap;
> > +	page = (unsigned long long) info->eap;
> 
> but page is still declared as unsigned long.  should it be unsigned long long?
I think it should be unsigned long long, unsigned long can not store 
0x100000000. It has been beyond its reach. So unsigned long long is
well for us.
> 
> >  	if (info->xeap & 1)
> > -		page |= 0x100000000ul;
> > +		page |= 0x100000000ull;
> >  	chan = page & 1;
> >  	page >>= 1;
> >  	offst = page & ((1 << PAGE_SHIFT) - 1);
> 
> 
