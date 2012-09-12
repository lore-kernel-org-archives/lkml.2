Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab2ILRM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:12:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710Ab2ILRMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:12:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH 02/16] ARM: davinci: move platform_data definitions
Date: Wed, 12 Sep 2012 17:11:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Dooks <ben-linux@fluff.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-2-git-send-email-arnd@arndb.de> <1BAFE6F6C881BF42822005164F1491C33EA802EC@DBDE01.ent.ti.com>
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA802EC@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209121711.10715.arnd@arndb.de>
X-Provags-ID: V02:K0:ISJ49ihkpLdrWZjlv7xY3CGtPW1C36WwwVytAd73VEk
 KCrov4+Zb+6ECed3pJtMORQk71zYyTfmyX9LeTNTd+ZDFugTNH
 bkTUEj13eL6Jwy+eg7aoqs7DEjLspqHh4JgYzn+POUvlmnSz3S
 s/RjB1DymzdqIdLnB0RKg3WGjBxSOYhQ6o/z1iZ73R/2G/cqwK
 JGISN9V4f1QzckAg2Klo1lRs/95PWlbDr/dg1DaGeQXIEa2szz
 oUUp03M7d8szXYcp1fusUcIM855wMVAwpKe/jHpUExQLpgOipk
 TZ4BaSqCYhLt3Vn33N1sn4Q/7XBsh5X4eXam97lps/fUHk2lxN
 27O8Ft9HeQOcKsyVkUak=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2012, Hebbar, Gururaja wrote:
> On Tue, Sep 11, 2012 at 18:29:36, Arnd Bergmann wrote:

> >  drivers/usb/musb/da8xx.c                                     |    2 +-
> 
> 
> >  .../asp.h => include/linux/platform_data/asoc-davinci-evm.h  |    0
> 
> 
> This will clash with patch "ASoC/ARM: Davinci: McASP: split asp header into 
> platform and audio specific" queued in ASoC tree by Mark
> 

Ok, I've taken out that hunk, this is the remaining patch. There will
still be minor conflicts though, because it changes some adjacent lines.

	Arnd


>From d017cbf690ccbaf8561a83a0b3156f0921807939 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 24 Aug 2012 15:11:34 +0200
Subject: [PATCH] ARM: davinci: move platform_data definitions

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the davinci include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: "Ben Dooks" <ben-linux@fluff.org>
Cc: "Wolfram Sang" <w.sang@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Liam Girdwood <lrg@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com

diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
index 1ce70a9..f091a90 100644
--- a/arch/arm/mach-davinci/aemif.c
+++ b/arch/arm/mach-davinci/aemif.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 
-#include <mach/aemif.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
 
 /* Timing value configuration */
 
diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 0031864..95b5e10 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -28,11 +28,11 @@
 
 #include <mach/cp_intc.h>
 #include <mach/mux.h>
-#include <mach/nand.h>
+#include <linux/platform_data/mtd-davinci.h>
 #include <mach/da8xx.h>
-#include <mach/usb.h>
-#include <mach/aemif.h>
-#include <mach/spi.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/spi-davinci.h>
 
 #define DA830_EVM_PHY_ID		""
 /*
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 0149fb4..1295e61 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -40,10 +40,10 @@
 
 #include <mach/cp_intc.h>
 #include <mach/da8xx.h>
-#include <mach/nand.h>
+#include <linux/platform_data/mtd-davinci.h>
 #include <mach/mux.h>
-#include <mach/aemif.h>
-#include <mach/spi.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/spi-davinci.h>
 
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
 #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 1c7b1f4..88ebea8 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -26,11 +26,11 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index 8e77032..2f88103 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -23,11 +23,11 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 688a9c5..1b4a8ad 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -33,11 +33,11 @@
 
 #include <mach/mux.h>
 #include <mach/common.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
-#include <mach/mmc.h>
-#include <mach/nand.h>
-#include <mach/keyscan.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/keyscan-davinci.h>
 
 #include <media/tvp514x.h>
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index d34ed55..ca72fc4 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -31,13 +31,13 @@
 #include <asm/mach/arch.h>
 
 #include <mach/common.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
 #include <mach/mux.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
-#include <mach/aemif.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 958679a..9944367 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -38,11 +38,11 @@
 
 #include <mach/common.h>
 #include <mach/serial.h>
-#include <mach/i2c.h>
-#include <mach/nand.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
 #include <mach/clock.h>
 #include <mach/cdce949.h>
-#include <mach/aemif.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index beecde3..43e4a0d 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -26,9 +26,9 @@
 #include <mach/common.h>
 #include <mach/cp_intc.h>
 #include <mach/da8xx.h>
-#include <mach/nand.h>
+#include <linux/platform_data/mtd-davinci.h>
 #include <mach/mux.h>
-#include <mach/spi.h>
+#include <linux/platform_data/spi-davinci.h>
 
 #define MITYOMAPL138_PHY_ID		""
 
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index f6b9fc7..144bf31 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -31,12 +31,12 @@
 #include <asm/mach/arch.h>
 
 #include <mach/common.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
 #include <mach/mux.h>
-#include <mach/nand.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
index 9078acf..6957787 100644
--- a/arch/arm/mach-davinci/board-sffsdr.c
+++ b/arch/arm/mach-davinci/board-sffsdr.c
@@ -36,10 +36,10 @@
 #include <asm/mach/flash.h>
 
 #include <mach/common.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 #include <mach/serial.h>
 #include <mach/mux.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 8db0fc6..a37fc44 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -24,7 +24,7 @@
 #include <linux/spi/spi.h>
 
 #include <mach/asp.h>
-#include <mach/keyscan.h>
+#include <linux/platform_data/keyscan-davinci.h>
 #include <mach/hardware.h>
 
 #include <media/davinci/vpfe_capture.h>
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index d2f96662..3a42b6f 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -15,12 +15,12 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 #include <mach/irqs.h>
 #include <mach/cputype.h>
 #include <mach/mux.h>
 #include <mach/edma.h>
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-davinci.h>
 #include <mach/time.h>
 
 #include "davinci.h"
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 678cd99..adbde33 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -27,7 +27,7 @@
 #include <mach/serial.h>
 #include <mach/common.h>
 #include <mach/asp.h>
-#include <mach/spi.h>
+#include <linux/platform_data/spi-davinci.h>
 #include <mach/gpio-davinci.h>
 
 #include "davinci.h"
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index a50d49de..719e22f 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -30,8 +30,8 @@
 #include <mach/serial.h>
 #include <mach/common.h>
 #include <mach/asp.h>
-#include <mach/keyscan.h>
-#include <mach/spi.h>
+#include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_data/spi-davinci.h>
 #include <mach/gpio-davinci.h>
 
 #include "davinci.h"
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index a2f1f27..33e78ae 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -19,12 +19,12 @@
 
 #include <mach/serial.h>
 #include <mach/edma.h>
-#include <mach/i2c.h>
 #include <mach/asp.h>
-#include <mach/mmc.h>
-#include <mach/usb.h>
 #include <mach/pm.h>
-#include <mach/spi.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_data/spi-davinci.h>
 
 extern void __iomem *da8xx_syscfg0_base;
 extern void __iomem *da8xx_syscfg1_base;
diff --git a/arch/arm/mach-davinci/include/mach/tnetv107x.h b/arch/arm/mach-davinci/include/mach/tnetv107x.h
index 83e5926..1656a02 100644
--- a/arch/arm/mach-davinci/include/mach/tnetv107x.h
+++ b/arch/arm/mach-davinci/include/mach/tnetv107x.h
@@ -36,8 +36,8 @@
 #include <linux/input/matrix_keypad.h>
 #include <linux/mfd/ti_ssp.h>
 
-#include <mach/mmc.h>
-#include <mach/nand.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
 #include <mach/serial.h>
 
 struct tnetv107x_device_info {
diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
index 23d2b6d..f77b953 100644
--- a/arch/arm/mach-davinci/usb.c
+++ b/arch/arm/mach-davinci/usb.c
@@ -10,7 +10,7 @@
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/cputype.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-davinci.h>
 
 #define DAVINCI_USB_OTG_BASE	0x01c64000
 
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 79b4bcb..79a2542 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -40,7 +40,7 @@
 #include <linux/gpio.h>
 
 #include <mach/hardware.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 
 /* ----- global defines ----------------------------------------------- */
 
diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
index 9d82b3a..d5bacbb 100644
--- a/drivers/input/keyboard/davinci_keyscan.c
+++ b/drivers/input/keyboard/davinci_keyscan.c
@@ -36,7 +36,7 @@
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
-#include <mach/keyscan.h>
+#include <linux/platform_data/keyscan-davinci.h>
 
 /* Key scan registers */
 #define DAVINCI_KEYSCAN_KEYCTRL		0x0000
diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/video/davinci/vpbe_venc.c
index b21ecc8..0302669 100644
--- a/drivers/media/video/davinci/vpbe_venc.c
+++ b/drivers/media/video/davinci/vpbe_venc.c
@@ -27,7 +27,7 @@
 
 #include <mach/hardware.h>
 #include <mach/mux.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-davinci.h>
 
 #include <linux/io.h>
 
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 7cf6c62..3dfd347 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -33,7 +33,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/mmc/mmc.h>
 
-#include <mach/mmc.h>
+#include <linux/platform_data/mmc-davinci.h>
 #include <mach/edma.h>
 
 /*
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index d94b03c..f1deb1e 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -34,8 +34,8 @@
 #include <linux/mtd/partitions.h>
 #include <linux/slab.h>
 
-#include <mach/nand.h>
-#include <mach/aemif.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
 
 /*
  * This is a device driver for the NAND flash controller found on the
diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 9b2901f..3afe2f4 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -30,7 +30,7 @@
 #include <linux/spi/spi_bitbang.h>
 #include <linux/slab.h>
 
-#include <mach/spi.h>
+#include <linux/platform_data/spi-davinci.h>
 #include <mach/edma.h>
 
 #define SPI_NO_RESOURCE		((resource_size_t)-1)
diff --git a/drivers/usb/host/ohci-da8xx.c b/drivers/usb/host/ohci-da8xx.c
index 269b1e0..0b815a8 100644
--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -17,7 +17,7 @@
 #include <linux/clk.h>
 
 #include <mach/da8xx.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-davinci.h>
 
 #ifndef CONFIG_ARCH_DAVINCI_DA8XX
 #error "This file is DA8xx bus glue.  Define CONFIG_ARCH_DAVINCI_DA8XX."
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 0f9fcec..15a2627 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -35,7 +35,7 @@
 #include <linux/dma-mapping.h>
 
 #include <mach/da8xx.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-davinci.h>
 
 #include "musb_core.h"
 
diff --git a/arch/arm/mach-davinci/include/mach/i2c.h b/include/linux/platform_data/i2c-davinci.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/i2c.h
rename to include/linux/platform_data/i2c-davinci.h
diff --git a/arch/arm/mach-davinci/include/mach/keyscan.h b/include/linux/platform_data/keyscan-davinci.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/keyscan.h
rename to include/linux/platform_data/keyscan-davinci.h
diff --git a/arch/arm/mach-davinci/include/mach/mmc.h b/include/linux/platform_data/mmc-davinci.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/mmc.h
rename to include/linux/platform_data/mmc-davinci.h
diff --git a/arch/arm/mach-davinci/include/mach/aemif.h b/include/linux/platform_data/mtd-davinci-aemif.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/aemif.h
rename to include/linux/platform_data/mtd-davinci-aemif.h
diff --git a/arch/arm/mach-davinci/include/mach/nand.h b/include/linux/platform_data/mtd-davinci.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/nand.h
rename to include/linux/platform_data/mtd-davinci.h
diff --git a/arch/arm/mach-davinci/include/mach/spi.h b/include/linux/platform_data/spi-davinci.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/spi.h
rename to include/linux/platform_data/spi-davinci.h
diff --git a/arch/arm/mach-davinci/include/mach/usb.h b/include/linux/platform_data/usb-davinci.h
similarity index 100%
rename from arch/arm/mach-davinci/include/mach/usb.h
rename to include/linux/platform_data/usb-davinci.h
