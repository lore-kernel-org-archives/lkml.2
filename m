Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1IVCIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 22:08:20 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49797 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1IVCIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 22:08:19 -0400
Date: Thu, 22 Sep 2011 12:08:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20110922120817.e0ede0d26dddca1ad0332264@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
drivers/gpio/Makefile between commit 2428835fc6a5 ("ARM: 7049/1:
mach-sa1100: move SA1100 GPIO driver to GPIO subsystem") from the arm
tree and commit 1b39d5f2cc5c ("gpio/samsung: gpio-samsung.c to support
Samsung GPIOs") from the s5p tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/Makefile
index 84bc738,62db458..0000000
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@@ -14,14 -14,10 +14,13 @@@ obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5
  obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
  obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
  obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 +obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
  obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
- obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
  obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
  obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
 +obj-$(CONFIG_MACH_KS8695)	+= gpio-ks8695.o
  obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
 +obj-$(CONFIG_ARCH_LPC32XX)	+= gpio-lpc32xx.o
  obj-$(CONFIG_GPIO_MAX730X)	+= gpio-max730x.o
  obj-$(CONFIG_GPIO_MAX7300)	+= gpio-max7300.o
  obj-$(CONFIG_GPIO_MAX7301)	+= gpio-max7301.o
@@@ -41,11 -37,7 +40,8 @@@ obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf8
  obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
  obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
  obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
- 
- obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
- obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
- obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
 +obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
+ obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
  obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
  obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
  obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
