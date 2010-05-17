Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0EQKFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:05:38 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50225 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab0EQKFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:05:33 -0400
From: felipe.balbi@nokia.com
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 5/5] arm: omap: move all gpio defines to plat/gpio.h
Date: Mon, 17 May 2010 13:02:34 +0300
Message-Id: <1274090554-19420-6-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 17 May 2010 10:04:40.0780 (UTC) FILETIME=[5DA3B0C0:01CAF5A8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

move everything to a common location. No functional
changes.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 arch/arm/plat-omap/gpio.c              |  143 --------------------------------
 arch/arm/plat-omap/include/plat/gpio.h |  143 ++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 143 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 95f92b0..b4ff1a4 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -28,149 +28,6 @@
 #include <mach/gpio.h>
 #include <asm/mach/irq.h>
 
-/*
- * OMAP1510 GPIO registers
- */
-#define OMAP1510_GPIO_BASE		0xfffce000
-#define OMAP1510_GPIO_DATA_INPUT	0x00
-#define OMAP1510_GPIO_DATA_OUTPUT	0x04
-#define OMAP1510_GPIO_DIR_CONTROL	0x08
-#define OMAP1510_GPIO_INT_CONTROL	0x0c
-#define OMAP1510_GPIO_INT_MASK		0x10
-#define OMAP1510_GPIO_INT_STATUS	0x14
-#define OMAP1510_GPIO_PIN_CONTROL	0x18
-
-#define OMAP1510_IH_GPIO_BASE		64
-
-/*
- * OMAP1610 specific GPIO registers
- */
-#define OMAP1610_GPIO1_BASE		0xfffbe400
-#define OMAP1610_GPIO2_BASE		0xfffbec00
-#define OMAP1610_GPIO3_BASE		0xfffbb400
-#define OMAP1610_GPIO4_BASE		0xfffbbc00
-#define OMAP1610_GPIO_REVISION		0x0000
-#define OMAP1610_GPIO_SYSCONFIG		0x0010
-#define OMAP1610_GPIO_SYSSTATUS		0x0014
-#define OMAP1610_GPIO_IRQSTATUS1	0x0018
-#define OMAP1610_GPIO_IRQENABLE1	0x001c
-#define OMAP1610_GPIO_WAKEUPENABLE	0x0028
-#define OMAP1610_GPIO_DATAIN		0x002c
-#define OMAP1610_GPIO_DATAOUT		0x0030
-#define OMAP1610_GPIO_DIRECTION		0x0034
-#define OMAP1610_GPIO_EDGE_CTRL1	0x0038
-#define OMAP1610_GPIO_EDGE_CTRL2	0x003c
-#define OMAP1610_GPIO_CLEAR_IRQENABLE1	0x009c
-#define OMAP1610_GPIO_CLEAR_WAKEUPENA	0x00a8
-#define OMAP1610_GPIO_CLEAR_DATAOUT	0x00b0
-#define OMAP1610_GPIO_SET_IRQENABLE1	0x00dc
-#define OMAP1610_GPIO_SET_WAKEUPENA	0x00e8
-#define OMAP1610_GPIO_SET_DATAOUT	0x00f0
-
-/*
- * OMAP7XX specific GPIO registers
- */
-#define OMAP7XX_GPIO1_BASE		0xfffbc000
-#define OMAP7XX_GPIO2_BASE		0xfffbc800
-#define OMAP7XX_GPIO3_BASE		0xfffbd000
-#define OMAP7XX_GPIO4_BASE		0xfffbd800
-#define OMAP7XX_GPIO5_BASE		0xfffbe000
-#define OMAP7XX_GPIO6_BASE		0xfffbe800
-#define OMAP7XX_GPIO_DATA_INPUT		0x00
-#define OMAP7XX_GPIO_DATA_OUTPUT	0x04
-#define OMAP7XX_GPIO_DIR_CONTROL	0x08
-#define OMAP7XX_GPIO_INT_CONTROL	0x0c
-#define OMAP7XX_GPIO_INT_MASK		0x10
-#define OMAP7XX_GPIO_INT_STATUS		0x14
-
-#define OMAP1_MPUIO_VBASE		OMAP1_MPUIO_BASE
-
-/*
- * omap24xx specific GPIO registers
- */
-#define OMAP242X_GPIO1_BASE		0x48018000
-#define OMAP242X_GPIO2_BASE		0x4801a000
-#define OMAP242X_GPIO3_BASE		0x4801c000
-#define OMAP242X_GPIO4_BASE		0x4801e000
-
-#define OMAP243X_GPIO1_BASE		0x4900C000
-#define OMAP243X_GPIO2_BASE		0x4900E000
-#define OMAP243X_GPIO3_BASE		0x49010000
-#define OMAP243X_GPIO4_BASE		0x49012000
-#define OMAP243X_GPIO5_BASE		0x480B6000
-
-#define OMAP24XX_GPIO_REVISION		0x0000
-#define OMAP24XX_GPIO_SYSCONFIG		0x0010
-#define OMAP24XX_GPIO_SYSSTATUS		0x0014
-#define OMAP24XX_GPIO_IRQSTATUS1	0x0018
-#define OMAP24XX_GPIO_IRQSTATUS2	0x0028
-#define OMAP24XX_GPIO_IRQENABLE2	0x002c
-#define OMAP24XX_GPIO_IRQENABLE1	0x001c
-#define OMAP24XX_GPIO_WAKE_EN		0x0020
-#define OMAP24XX_GPIO_CTRL		0x0030
-#define OMAP24XX_GPIO_OE		0x0034
-#define OMAP24XX_GPIO_DATAIN		0x0038
-#define OMAP24XX_GPIO_DATAOUT		0x003c
-#define OMAP24XX_GPIO_LEVELDETECT0	0x0040
-#define OMAP24XX_GPIO_LEVELDETECT1	0x0044
-#define OMAP24XX_GPIO_RISINGDETECT	0x0048
-#define OMAP24XX_GPIO_FALLINGDETECT	0x004c
-#define OMAP24XX_GPIO_DEBOUNCE_EN	0x0050
-#define OMAP24XX_GPIO_DEBOUNCE_VAL	0x0054
-#define OMAP24XX_GPIO_CLEARIRQENABLE1	0x0060
-#define OMAP24XX_GPIO_SETIRQENABLE1	0x0064
-#define OMAP24XX_GPIO_CLEARWKUENA	0x0080
-#define OMAP24XX_GPIO_SETWKUENA		0x0084
-#define OMAP24XX_GPIO_CLEARDATAOUT	0x0090
-#define OMAP24XX_GPIO_SETDATAOUT	0x0094
-
-#define OMAP4_GPIO_REVISION		0x0000
-#define OMAP4_GPIO_SYSCONFIG		0x0010
-#define OMAP4_GPIO_EOI			0x0020
-#define OMAP4_GPIO_IRQSTATUSRAW0	0x0024
-#define OMAP4_GPIO_IRQSTATUSRAW1	0x0028
-#define OMAP4_GPIO_IRQSTATUS0		0x002c
-#define OMAP4_GPIO_IRQSTATUS1		0x0030
-#define OMAP4_GPIO_IRQSTATUSSET0	0x0034
-#define OMAP4_GPIO_IRQSTATUSSET1	0x0038
-#define OMAP4_GPIO_IRQSTATUSCLR0	0x003c
-#define OMAP4_GPIO_IRQSTATUSCLR1	0x0040
-#define OMAP4_GPIO_IRQWAKEN0		0x0044
-#define OMAP4_GPIO_IRQWAKEN1		0x0048
-#define OMAP4_GPIO_SYSSTATUS		0x0104
-#define OMAP4_GPIO_CTRL			0x0130
-#define OMAP4_GPIO_OE			0x0134
-#define OMAP4_GPIO_DATAIN		0x0138
-#define OMAP4_GPIO_DATAOUT		0x013c
-#define OMAP4_GPIO_LEVELDETECT0		0x0140
-#define OMAP4_GPIO_LEVELDETECT1		0x0144
-#define OMAP4_GPIO_RISINGDETECT		0x0148
-#define OMAP4_GPIO_FALLINGDETECT	0x014c
-#define OMAP4_GPIO_DEBOUNCENABLE	0x0150
-#define OMAP4_GPIO_DEBOUNCINGTIME	0x0154
-#define OMAP4_GPIO_CLEARDATAOUT		0x0190
-#define OMAP4_GPIO_SETDATAOUT		0x0194
-/*
- * omap34xx specific GPIO registers
- */
-
-#define OMAP34XX_GPIO1_BASE		0x48310000
-#define OMAP34XX_GPIO2_BASE		0x49050000
-#define OMAP34XX_GPIO3_BASE		0x49052000
-#define OMAP34XX_GPIO4_BASE		0x49054000
-#define OMAP34XX_GPIO5_BASE		0x49056000
-#define OMAP34XX_GPIO6_BASE		0x49058000
-
-/*
- * OMAP44XX  specific GPIO registers
- */
-#define OMAP44XX_GPIO1_BASE             0x4a310000
-#define OMAP44XX_GPIO2_BASE             0x48055000
-#define OMAP44XX_GPIO3_BASE             0x48057000
-#define OMAP44XX_GPIO4_BASE             0x48059000
-#define OMAP44XX_GPIO5_BASE             0x4805B000
-#define OMAP44XX_GPIO6_BASE             0x4805D000
-
 struct gpio_bank {
 	unsigned long pbase;
 	void __iomem *base;
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index de7c547..b444f5f 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -71,6 +71,149 @@
 				 IH_MPUIO_BASE + ((nr) & 0x0f) : \
 				 IH_GPIO_BASE + (nr))
 
+/*
+ * OMAP1510 GPIO registers
+ */
+#define OMAP1510_GPIO_BASE		0xfffce000
+#define OMAP1510_GPIO_DATA_INPUT	0x00
+#define OMAP1510_GPIO_DATA_OUTPUT	0x04
+#define OMAP1510_GPIO_DIR_CONTROL	0x08
+#define OMAP1510_GPIO_INT_CONTROL	0x0c
+#define OMAP1510_GPIO_INT_MASK		0x10
+#define OMAP1510_GPIO_INT_STATUS	0x14
+#define OMAP1510_GPIO_PIN_CONTROL	0x18
+
+#define OMAP1510_IH_GPIO_BASE		64
+
+/*
+ * OMAP1610 specific GPIO registers
+ */
+#define OMAP1610_GPIO1_BASE		0xfffbe400
+#define OMAP1610_GPIO2_BASE		0xfffbec00
+#define OMAP1610_GPIO3_BASE		0xfffbb400
+#define OMAP1610_GPIO4_BASE		0xfffbbc00
+#define OMAP1610_GPIO_REVISION		0x0000
+#define OMAP1610_GPIO_SYSCONFIG		0x0010
+#define OMAP1610_GPIO_SYSSTATUS		0x0014
+#define OMAP1610_GPIO_IRQSTATUS1	0x0018
+#define OMAP1610_GPIO_IRQENABLE1	0x001c
+#define OMAP1610_GPIO_WAKEUPENABLE	0x0028
+#define OMAP1610_GPIO_DATAIN		0x002c
+#define OMAP1610_GPIO_DATAOUT		0x0030
+#define OMAP1610_GPIO_DIRECTION		0x0034
+#define OMAP1610_GPIO_EDGE_CTRL1	0x0038
+#define OMAP1610_GPIO_EDGE_CTRL2	0x003c
+#define OMAP1610_GPIO_CLEAR_IRQENABLE1	0x009c
+#define OMAP1610_GPIO_CLEAR_WAKEUPENA	0x00a8
+#define OMAP1610_GPIO_CLEAR_DATAOUT	0x00b0
+#define OMAP1610_GPIO_SET_IRQENABLE1	0x00dc
+#define OMAP1610_GPIO_SET_WAKEUPENA	0x00e8
+#define OMAP1610_GPIO_SET_DATAOUT	0x00f0
+
+/*
+ * OMAP7XX specific GPIO registers
+ */
+#define OMAP7XX_GPIO1_BASE		0xfffbc000
+#define OMAP7XX_GPIO2_BASE		0xfffbc800
+#define OMAP7XX_GPIO3_BASE		0xfffbd000
+#define OMAP7XX_GPIO4_BASE		0xfffbd800
+#define OMAP7XX_GPIO5_BASE		0xfffbe000
+#define OMAP7XX_GPIO6_BASE		0xfffbe800
+#define OMAP7XX_GPIO_DATA_INPUT		0x00
+#define OMAP7XX_GPIO_DATA_OUTPUT	0x04
+#define OMAP7XX_GPIO_DIR_CONTROL	0x08
+#define OMAP7XX_GPIO_INT_CONTROL	0x0c
+#define OMAP7XX_GPIO_INT_MASK		0x10
+#define OMAP7XX_GPIO_INT_STATUS		0x14
+
+#define OMAP1_MPUIO_VBASE		OMAP1_MPUIO_BASE
+
+/*
+ * omap24xx specific GPIO registers
+ */
+#define OMAP242X_GPIO1_BASE		0x48018000
+#define OMAP242X_GPIO2_BASE		0x4801a000
+#define OMAP242X_GPIO3_BASE		0x4801c000
+#define OMAP242X_GPIO4_BASE		0x4801e000
+
+#define OMAP243X_GPIO1_BASE		0x4900C000
+#define OMAP243X_GPIO2_BASE		0x4900E000
+#define OMAP243X_GPIO3_BASE		0x49010000
+#define OMAP243X_GPIO4_BASE		0x49012000
+#define OMAP243X_GPIO5_BASE		0x480B6000
+
+#define OMAP24XX_GPIO_REVISION		0x0000
+#define OMAP24XX_GPIO_SYSCONFIG		0x0010
+#define OMAP24XX_GPIO_SYSSTATUS		0x0014
+#define OMAP24XX_GPIO_IRQSTATUS1	0x0018
+#define OMAP24XX_GPIO_IRQSTATUS2	0x0028
+#define OMAP24XX_GPIO_IRQENABLE2	0x002c
+#define OMAP24XX_GPIO_IRQENABLE1	0x001c
+#define OMAP24XX_GPIO_WAKE_EN		0x0020
+#define OMAP24XX_GPIO_CTRL		0x0030
+#define OMAP24XX_GPIO_OE		0x0034
+#define OMAP24XX_GPIO_DATAIN		0x0038
+#define OMAP24XX_GPIO_DATAOUT		0x003c
+#define OMAP24XX_GPIO_LEVELDETECT0	0x0040
+#define OMAP24XX_GPIO_LEVELDETECT1	0x0044
+#define OMAP24XX_GPIO_RISINGDETECT	0x0048
+#define OMAP24XX_GPIO_FALLINGDETECT	0x004c
+#define OMAP24XX_GPIO_DEBOUNCE_EN	0x0050
+#define OMAP24XX_GPIO_DEBOUNCE_VAL	0x0054
+#define OMAP24XX_GPIO_CLEARIRQENABLE1	0x0060
+#define OMAP24XX_GPIO_SETIRQENABLE1	0x0064
+#define OMAP24XX_GPIO_CLEARWKUENA	0x0080
+#define OMAP24XX_GPIO_SETWKUENA		0x0084
+#define OMAP24XX_GPIO_CLEARDATAOUT	0x0090
+#define OMAP24XX_GPIO_SETDATAOUT	0x0094
+
+#define OMAP4_GPIO_REVISION		0x0000
+#define OMAP4_GPIO_SYSCONFIG		0x0010
+#define OMAP4_GPIO_EOI			0x0020
+#define OMAP4_GPIO_IRQSTATUSRAW0	0x0024
+#define OMAP4_GPIO_IRQSTATUSRAW1	0x0028
+#define OMAP4_GPIO_IRQSTATUS0		0x002c
+#define OMAP4_GPIO_IRQSTATUS1		0x0030
+#define OMAP4_GPIO_IRQSTATUSSET0	0x0034
+#define OMAP4_GPIO_IRQSTATUSSET1	0x0038
+#define OMAP4_GPIO_IRQSTATUSCLR0	0x003c
+#define OMAP4_GPIO_IRQSTATUSCLR1	0x0040
+#define OMAP4_GPIO_IRQWAKEN0		0x0044
+#define OMAP4_GPIO_IRQWAKEN1		0x0048
+#define OMAP4_GPIO_SYSSTATUS		0x0104
+#define OMAP4_GPIO_CTRL			0x0130
+#define OMAP4_GPIO_OE			0x0134
+#define OMAP4_GPIO_DATAIN		0x0138
+#define OMAP4_GPIO_DATAOUT		0x013c
+#define OMAP4_GPIO_LEVELDETECT0		0x0140
+#define OMAP4_GPIO_LEVELDETECT1		0x0144
+#define OMAP4_GPIO_RISINGDETECT		0x0148
+#define OMAP4_GPIO_FALLINGDETECT	0x014c
+#define OMAP4_GPIO_DEBOUNCENABLE	0x0150
+#define OMAP4_GPIO_DEBOUNCINGTIME	0x0154
+#define OMAP4_GPIO_CLEARDATAOUT		0x0190
+#define OMAP4_GPIO_SETDATAOUT		0x0194
+
+/*
+ * omap34xx specific GPIO registers
+ */
+#define OMAP34XX_GPIO1_BASE		0x48310000
+#define OMAP34XX_GPIO2_BASE		0x49050000
+#define OMAP34XX_GPIO3_BASE		0x49052000
+#define OMAP34XX_GPIO4_BASE		0x49054000
+#define OMAP34XX_GPIO5_BASE		0x49056000
+#define OMAP34XX_GPIO6_BASE		0x49058000
+
+/*
+ * OMAP44XX  specific GPIO registers
+ */
+#define OMAP44XX_GPIO1_BASE             0x4a310000
+#define OMAP44XX_GPIO2_BASE             0x48055000
+#define OMAP44XX_GPIO3_BASE             0x48057000
+#define OMAP44XX_GPIO4_BASE             0x48059000
+#define OMAP44XX_GPIO5_BASE             0x4805B000
+#define OMAP44XX_GPIO6_BASE             0x4805D000
+
 extern int omap_gpio_init(void);	/* Call from board init only */
 extern void omap2_gpio_prepare_for_retention(void);
 extern void omap2_gpio_resume_after_retention(void);
-- 
1.7.1

