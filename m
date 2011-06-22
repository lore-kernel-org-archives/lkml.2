Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab1FVDwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:52:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48995 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab1FVDwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:52:05 -0400
Date: Wed, 22 Jun 2011 13:51:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Margarita Olaya <magi@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Subject: linux-next: manual merge of the gpio tree with the mfd tree
Message-Id: <20110622135158.3ec1e6d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
drivers/gpio/Makefile between commit d4739bbd20ec ("tps65912: gpio: add
gpio driver") from the mfd tree and commit c103de240439 ("gpio:
reorganize drivers") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/Makefile
index 78aed0e,0fbdd75..0000000
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@@ -14,40 -38,20 +38,21 @@@ obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc3
  obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
  obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
  obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
- obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
- obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
- obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
- obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
- obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
- obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
- obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
- obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
- obj-$(CONFIG_ARCH_OMAP)         += gpio-omap.o
- obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
- obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
- obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
- obj-$(CONFIG_GPIO_PL061)	+= pl061.o
- obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
- obj-$(CONFIG_GPIO_TC3589X)	+= tc3589x-gpio.o
- obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
- obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
+ 
+ obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
+ obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
+ obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
+ obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
+ obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
+ obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
+ obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 +obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
- obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
- obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
- obj-$(CONFIG_GPIO_CS5535)	+= cs5535-gpio.o
- obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
- obj-$(CONFIG_GPIO_IT8761E)	+= it8761e_gpio.o
- obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
- obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
- obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
- obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
- obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
+ obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
  obj-$(CONFIG_MACH_U300)		+= gpio-u300.o
- obj-$(CONFIG_PLAT_NOMADIK)	+= gpio-nomadik.o
- obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
- obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
- obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
- obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
- obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
- obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
- obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
+ obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
+ obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
+ obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
+ obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
+ obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
+ obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
+ obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
