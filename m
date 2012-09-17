Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab2IQOL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:11:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40904 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab2IQOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:11:22 -0400
Date: Mon, 17 Sep 2012 07:11:19 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (arm-soc
 tree related)
Message-ID: <20120917141119.GA18715@quad.lixom.net>
References: <20120917212615.91bc134d237dcd5968f9f549@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917212615.91bc134d237dcd5968f9f549@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 17, 2012 at 09:26:15PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mfd/twl-core.c:49:22: fatal error: plat/cpu.h: No such file or directory
> 
> Caused by commit 7d7e1eba7e92 ("ARM: OMAP2+: Prepare for irqs.h removal").
> 
> I have added the following patch to restrict this driver to ARM until it
> is fixed:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 17 Sep 2012 21:18:21 +1000
> Subject: [PATCH] ARM: retrict TWL4030_CORE to ARM while it is broken
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index df850c4..af5e5b7 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -257,6 +257,7 @@ config MENELAUS
>  config TWL4030_CORE
>  	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
>  	depends on I2C=y && GENERIC_HARDIRQS
> +	depends on ARM
>  	select IRQ_DOMAIN
>  	help
>  	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.

Gack. This will break on non-OMAP ARM platforms now too, so it needs to be
depends on ARCH_OMAP instead of ARM.

Tony, can I get an Acked-by so I can apply this to next/cleanup? Sam, if
you prefer to apply it yourself, let me know.


-Olof

>From 571a231c7f38b720001e1c7c3d5fb08fe265d03b Mon Sep 17 00:00:00 2001
From: Olof Johansson <olof@lixom.net>
Date: Mon, 17 Sep 2012 07:05:04 -0700
Subject: [PATCH] MFD: make TWL4030_CORE depend on ARCH_OMAP

It uses OMAP-only header files, and since it's an OMAP companion chip
it doesn't really make sense to enable on other platforms.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..d48083b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -256,7 +256,7 @@ config MENELAUS
 
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y && GENERIC_HARDIRQS && ARCH_OMAP
 	select IRQ_DOMAIN
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
-- 
1.7.10.1.488.g05fbf7a

