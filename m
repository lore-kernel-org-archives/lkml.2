Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589Ab0HFB1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:27:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61688 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934287Ab0HFB1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wMc3mlZo0au+1PiCf7cM3T9C0ra5+gbC0wUiMhxj+EuVYkrBQJFBMmVfc1qmkIHn0v
         cj4Zo3+/BDMotkuNToYJfM7mogYIM+Ao/rDtIWcW6YJxIBqgAOfpSnyLEVFChIagnYCQ
         k/1C9GRW18Ki/rg0+1OdzpeKIVXWpOoAN2+jg=
Subject: Re: [PATCH 3/3] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Alex Dubov <oakad@yahoo.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281057246.19943.20.camel@Joe-Laptop.home>
References: <1281018316-1466-1-git-send-email-maximlevitsky@gmail.com>
	 <1281018316-1466-4-git-send-email-maximlevitsky@gmail.com>
	 <1281057246.19943.20.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 04:27:26 +0300
Message-ID: <1281058046.3513.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 18:14 -0700, Joe Perches wrote: 
> On Thu, 2010-08-05 at 17:25 +0300, Maxim Levitsky wrote:
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> Trivial comments:
> 
> > ---
> >  MAINTAINERS                    |    6 +
> > +RICOH R5C592 MEMORYSTICK DRIVER
> > +M:	Maxim Levitsky <maximlevitsky@gmail.com>
> > +S:	Maintained
> > +F:	drivers/memstick/host/r592.c
> > +F:	drivers/memstick/host/r592.h
> 
> Patterns in maintainers can use wildcards
Didn't know about that, thanks! 
> 
> F:	drivers/memstick/host/r592*
> 
> > --- /dev/null
> > +++ b/drivers/memstick/host/r592.c
> > @@ -0,0 +1,889 @@
> []
> > +static char *tpc_names[] = {
> 
> const ?
Sure 
> 
> > +	"MS_TPC_READ_MG_STATUS",
> > +	"MS_TPC_READ_LONG_DATA",
> 
> []
> 
> > +#define dbg(format, ...) \
> > +	if (debug) \
> > +		printk(KERN_DEBUG DRV_NAME ": " format "\n", ## __VA_ARGS__)
> > +
> > +#define dbg_verbose(format, ...) \
> > +	if (debug > 1) \
> > +		printk(KERN_DEBUG DRV_NAME ": " format "\n", ## __VA_ARGS__)
> > +
> > +#define dbg_reg(format, ...) \
> > +	if (debug > 2) \
> > +		printk(KERN_DEBUG DRV_NAME ": " format "\n", ## __VA_ARGS__)
> > +
> 
> These style macros should use do { if (test) print(); } while (9)
> so they could be used without problems in if/else blocks.
>  
> Maybe it'd be better to have and use 1 macro with a level passed:
> 
> #define dbg(level, format, ...)						\
> do {									\
> 	if (debug > level)						\
> 		printk(KERN_DEBUG pr_fmt(format), ##__VA_ARGS__);	\
> } while (0)
Thinking again about that, why not...



> 
> > +#define message(format, ...) \
> > +	printk(KERN_INFO DRV_NAME ": " format "\n", ## __VA_ARGS__)
> 
> Why not just use pr_info?
Will look at that.

Best regards,
Maxim Levitsky



