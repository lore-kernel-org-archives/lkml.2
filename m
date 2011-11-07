Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1KGB1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 20:27:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:58282 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab1KGB1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 20:27:07 -0500
Date: Sun, 6 Nov 2011 20:26:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: <linux-mtd@lists.infradead.org>, David Woodhouse <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>, Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH] MTD: MAPS: bcm963xx-flash.c: explicitly include module.h
Message-ID: <20111107012643.GG30282@windriver.com>
References: <1320580651-4860-1-git-send-email-jonas.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320580651-4860-1-git-send-email-jonas.gorski@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH] MTD: MAPS: bcm963xx-flash.c: explicitly include module.h] On 06/11/2011 (Sun 12:57) Jonas Gorski wrote:

> module.h was previously implicitly included through mtd/mtd.h.
> 
> Fixes the following build failure after the module.h cleanup:
> 
>   CC      drivers/mtd/maps/bcm963xx-flash.o
> drivers/mtd/maps/bcm963xx-flash.c: In function 'bcm963xx_probe':
> drivers/mtd/maps/bcm963xx-flash.c:208:29: error: 'THIS_MODULE' undeclared (first use in this function)
> drivers/mtd/maps/bcm963xx-flash.c:208:29: note: each undeclared identifier is reported only once for each function it appears in
> drivers/mtd/maps/bcm963xx-flash.c: At top level:
> drivers/mtd/maps/bcm963xx-flash.c:255:12: error: 'THIS_MODULE' undeclared here (not in a function)
> drivers/mtd/maps/bcm963xx-flash.c:272:16: error: expected declaration specifiers or '...' before string constant
> drivers/mtd/maps/bcm963xx-flash.c:272:1: warning: data definition has no type or storage class
> drivers/mtd/maps/bcm963xx-flash.c:272:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/mtd/maps/bcm963xx-flash.c:272:16: warning: function declaration isn't a prototype
> drivers/mtd/maps/bcm963xx-flash.c:273:20: error: expected declaration specifiers or '...' before string constant
> drivers/mtd/maps/bcm963xx-flash.c:273:1: warning: data definition has no type or storage class
> drivers/mtd/maps/bcm963xx-flash.c:273:1: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
> drivers/mtd/maps/bcm963xx-flash.c:273:20: warning: function declaration isn't a prototype
> drivers/mtd/maps/bcm963xx-flash.c:274:15: error: expected declaration specifiers or '...' before string constant
> drivers/mtd/maps/bcm963xx-flash.c:274:1: warning: data definition has no type or storage class
> drivers/mtd/maps/bcm963xx-flash.c:274:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/mtd/maps/bcm963xx-flash.c:274:15: warning: function declaration isn't a prototype
> drivers/mtd/maps/bcm963xx-flash.c:275:15: error: expected declaration specifiers or '...' before string constant
> drivers/mtd/maps/bcm963xx-flash.c:275:1: warning: data definition has no type or storage class
> drivers/mtd/maps/bcm963xx-flash.c:275:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/mtd/maps/bcm963xx-flash.c:275:15: warning: function declaration isn't a prototype
> drivers/mtd/maps/bcm963xx-flash.c:276:15: error: expected declaration specifiers or '...' before string constant
> drivers/mtd/maps/bcm963xx-flash.c:276:1: warning: data definition has no type or storage class
> drivers/mtd/maps/bcm963xx-flash.c:276:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/mtd/maps/bcm963xx-flash.c:276:15: warning: function declaration isn't a prototype
> make[7]: *** [drivers/mtd/maps/bcm963xx-flash.o] Error 1
> 
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
> ---
> 
> This patch is based on next-20111104 and probably should go through Paul's module.h cleanup tree.

I can put it in the module.h tree, but for files that are using module.h
stuff, they can simply add it via the normal maintainer flow, since
files that use modular stuff should include module.h regardless and
there are no dependencies on the module.h content for things like this.

Thanks,
Paul.

> 
>  drivers/mtd/maps/bcm963xx-flash.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/maps/bcm963xx-flash.c b/drivers/mtd/maps/bcm963xx-flash.c
> index 608967f..736ca10 100644
> --- a/drivers/mtd/maps/bcm963xx-flash.c
> +++ b/drivers/mtd/maps/bcm963xx-flash.c
> @@ -21,6 +21,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> +#include <linux/module.h>
>  #include <linux/mtd/map.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
> -- 
> 1.7.2.5
> 
