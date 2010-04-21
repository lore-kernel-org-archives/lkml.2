Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0DUPNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:13:42 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:52906 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab0DUPNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:13:39 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv7 2.6.34-rc5 1/5] mxc: Update GPIO for USB support on Freescale MX51 Babbage HW
Date: Wed, 21 Apr 2010 10:13:11 -0500
Message-Id: <1271862795-7986-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

This patch is part of enabling USB for Freescale MX51 Babbage HW. This
patch updates the iomux pins for USB, and gpio line for reset the
USB hub on the MX51 Babbage HW.

NOTE: This 5-patch series for enabling USB is functionally dependent
on this patch:
"mx5: Add registration of GPIOs for MX51 Babbage board"

This patch applies to 2.6.34-rc5.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/plat-mxc/include/mach/iomux-mx51.h |   33 ++++++++++++++++----------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
index b4f975e..80528cc 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2009-2010 Amit Kucheria <amit.kucheria@canonical.com>
+ * Copyright (C) 2010 Freescale Semiconductor, Inc.
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
@@ -37,6 +38,11 @@ typedef enum iomux_config {
 				PAD_CTL_SRE_FAST)
 #define MX51_UART3_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_DSE_HIGH | \
 				PAD_CTL_SRE_FAST)
+#define MX51_USBH1_PAD_CTRL	(PAD_CTL_SRE_FAST | PAD_CTL_DSE_HIGH | \
+				PAD_CTL_PUS_100K_UP | PAD_CTL_PUE | \
+				PAD_CTL_PKE | PAD_CTL_HYS)
+#define MX51_GPIO_PAD_CTRL		(PAD_CTL_DSE_HIGH | PAD_CTL_PKE | \
+				PAD_CTL_SRE_FAST)
 
 /*
  * The naming convention for the pad modes is MX51_PAD_<padname>__<padmode>
@@ -208,18 +214,19 @@ typedef enum iomux_config {
 #define MX51_PAD_KEY_COL3__KEY_COL3	IOMUX_PAD(0x658, 0x268, 0, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_KEY_COL4__KEY_COL4	IOMUX_PAD(0x65C, 0x26C, 0, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_KEY_COL5__KEY_COL5	IOMUX_PAD(0x660, 0x270, 0, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_25__USBH1_CLK	IOMUX_PAD(0x678, 0x278, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_26__USBH1_DIR	IOMUX_PAD(0x67C, 0x27C, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_27__USBH1_STP	IOMUX_PAD(0x680, 0x280, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_28__USBH1_NXT	IOMUX_PAD(0x684, 0x284, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_11__USBH1_DATA0	IOMUX_PAD(0x688, 0x288, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_12__USBH1_DATA1	IOMUX_PAD(0x68C, 0x28C, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_13__USBH1_DATA2	IOMUX_PAD(0x690, 0x290, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_14__USBH1_DATA3	IOMUX_PAD(0x694, 0x294, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_15__USBH1_DATA4	IOMUX_PAD(0x698, 0x298, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_16__USBH1_DATA5	IOMUX_PAD(0x69C, 0x29C, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_17__USBH1_DATA6	IOMUX_PAD(0x6A0, 0x2A0, 2, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_18__USBH1_DATA7	IOMUX_PAD(0x6A4, 0x2A4, 2, 0x0, 0, NO_PAD_CTRL)
+#define MX51_PAD_USBH1_CLK__USBH1_CLK	IOMUX_PAD(0x678, 0x278, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DIR__USBH1_DIR	IOMUX_PAD(0x67C, 0x27C, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_STP__USBH1_STP	IOMUX_PAD(0x680, 0x280, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_STP__GPIO_1_27	IOMUX_PAD(0x680, 0x280, IOMUX_CONFIG_GPIO, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_NXT__USBH1_NXT	IOMUX_PAD(0x684, 0x284, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA0__USBH1_DATA0	IOMUX_PAD(0x688, 0x288, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA1__USBH1_DATA1	IOMUX_PAD(0x68C, 0x28C, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA2__USBH1_DATA2	IOMUX_PAD(0x690, 0x290, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA3__USBH1_DATA3	IOMUX_PAD(0x694, 0x294, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA4__USBH1_DATA4	IOMUX_PAD(0x698, 0x298, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA5__USBH1_DATA5	IOMUX_PAD(0x69C, 0x29C, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA6__USBH1_DATA6	IOMUX_PAD(0x6A0, 0x2A0, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
+#define MX51_PAD_USBH1_DATA7__USBH1_DATA7	IOMUX_PAD(0x6A4, 0x2A4, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
 #define MX51_PAD_GPIO_3_0__DI1_PIN11	IOMUX_PAD(0x6A8, 0x2A8, 4, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_3_1__DI1_PIN12	IOMUX_PAD(0x6AC, 0x2AC, 4, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_3_2__DI1_PIN13	IOMUX_PAD(0x6B0, 0x2B0, 4, 0x0, 0, NO_PAD_CTRL)
@@ -299,7 +306,7 @@ typedef enum iomux_config {
 #define MX51_PAD_GPIO_1_4__GPIO1_4	IOMUX_PAD(0x804, 0x3D8, 0, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_1_5__GPIO1_5	IOMUX_PAD(0x808, 0x3DC, 0, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_1_6__GPIO1_6	IOMUX_PAD(0x80C, 0x3E0, 0, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_1_7__GPIO1_7	IOMUX_PAD(0x810, 0x3E4, 0, 0x0, 0, NO_PAD_CTRL)
+#define MX51_PAD_GPIO_1_7__GPIO1_7	IOMUX_PAD(0x810, 0x3E4, 0, 0x0, 0, MX51_GPIO_PAD_CTRL)
 #define MX51_PAD_GPIO_1_8__GPIO1_8	IOMUX_PAD(0x814, 0x3E8, 0, 0x0, 1, \
 						(PAD_CTL_SRE_SLOW | PAD_CTL_DSE_MED | PAD_CTL_PUS_100K_UP |  PAD_CTL_HYS))
 #define MX51_PAD_GPIO_1_9__GPIO1_9	IOMUX_PAD(0x818, 0x3EC, 0, 0x0, 0, NO_PAD_CTRL)
-- 
1.6.0.4

