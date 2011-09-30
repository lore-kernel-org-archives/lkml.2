Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1I3EUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:20:33 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48222 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1I3EUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:20:31 -0400
Date: Fri, 30 Sep 2011 14:20:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@yxit.co.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the pinctrl tree with the arm and
 arm-soc trees
Message-Id: <20110930142026.b76dca0c94a2dd5116fbed5f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Today's linux-next merge of the pinctrl tree got conflicts in
arch/arm/mach-u300/Kconfig and arch/arm/mach-u300/core.c between commit
cc890cd78acd ("ARM: 7083/1: rewrite U300 GPIO to use gpiolib") from the
arm tree, commits c21d2319efcd ("mach-u300: retire AVE device") and
d70a5969e9d5 ("ARM: mach-u300: Setup consistent dma size at boot time")
from the arm-soc tree and commit bb41f2392a5a ("pinmux: add a driver for
the U300 pinmux") from the pinctrl tree.

I did the obvious (but maybe wrong - see below) fixups and can carry the
fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-u300/Kconfig
index 39e077e,449fd6a..0000000
--- a/arch/arm/mach-u300/Kconfig
+++ b/arch/arm/mach-u300/Kconfig
@@@ -6,7 -6,8 +6,9 @@@ comment "ST-Ericsson Mobile Platform Pr
  
  config MACH_U300
  	bool "U300"
 +	select GPIO_U300
+ 	select PINCTRL
+ 	select PINMUX_U300
  
  comment "ST-Ericsson U300/U330/U335/U365 Feature Selections"
  
diff --cc arch/arm/mach-u300/core.c
index 2f1d758,2f5929b..0000000
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@@ -25,7 -25,8 +25,9 @@@
  #include <linux/err.h>
  #include <linux/mtd/nand.h>
  #include <linux/mtd/fsmc.h>
 +#include <linux/dma-mapping.h>
+ #include <linux/pinctrl/machine.h>
+ #include <linux/pinctrl/pinmux.h>
  
  #include <asm/types.h>
  #include <asm/setup.h>
@@@ -1600,6 -1719,8 +1676,7 @@@ static struct platform_device *platform
  	&gpio_device,
  	&nand_device,
  	&wdog_device,
 -	&ave_device,
+ 	&pinmux_device,
  };
  
  /*
