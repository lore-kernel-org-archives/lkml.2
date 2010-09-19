Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0ISHPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:15:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57704 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752195Ab0ISHP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:15:28 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+9mfBcRey93Vo+1/3sazqQ3eF67RLn54WmNqJNx1
	IyuHDfw8+hwgN6
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 04/12] viafb: vt1636 cleanup
Date: Sun, 19 Sep 2010 07:26:09 +0000
Message-Id: <70dca952fa9f3594d20e8ea63e88b69482fe3847.1284879532.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: vt1636 cleanup

This patch merges tbl1636 into vt1636 and cleans it up as the data was
only used there anyway. No runtime changes are expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/Makefile  |    2 +-
 drivers/video/via/global.h  |    1 -
 drivers/video/via/tbl1636.c |   71 -------------------------------------------
 drivers/video/via/tbl1636.h |   34 --------------------
 drivers/video/via/vt1636.c  |   65 +++++++++++++++++++++++++--------------
 5 files changed, 42 insertions(+), 131 deletions(-)
 delete mode 100644 drivers/video/via/tbl1636.c
 delete mode 100644 drivers/video/via/tbl1636.h

diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
index d496adb..96f01ee 100644
--- a/drivers/video/via/Makefile
+++ b/drivers/video/via/Makefile
@@ -5,5 +5,5 @@
 obj-$(CONFIG_FB_VIA) += viafb.o
 
 viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o \
-	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o \
+	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o \
 	via-core.o via-gpio.o via_modesetting.o
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index 28221a0..38ef5ac 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -48,7 +48,6 @@
 #include "via_utility.h"
 #include "vt1636.h"
 #include "tblDPASetting.h"
-#include "tbl1636.h"
 
 /* External struct*/
 
diff --git a/drivers/video/via/tbl1636.c b/drivers/video/via/tbl1636.c
deleted file mode 100644
index 2d84534..0000000
--- a/drivers/video/via/tbl1636.c
+++ /dev/null
@@ -1,71 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#include "global.h"
-struct IODATA COMMON_INIT_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	/* Set panel power sequence timing */
-	{0x10, 0xC0, 0x00},
-	/* T1: VDD on - Data on. Each increment is 1 ms. (50ms = 031h) */
-	{0x0B, 0xFF, 0x40},
-	/* T2: Data on - Backlight on. Each increment is 2 ms. (210ms = 068h) */
-	{0x0C, 0xFF, 0x31},
-	/* T3: Backlight off -Data off. Each increment is 2 ms. (210ms = 068h)*/
-	{0x0D, 0xFF, 0x31},
-	/* T4: Data off - VDD off. Each increment is 1 ms. (50ms = 031h) */
-	{0x0E, 0xFF, 0x68},
-	/* T5: VDD off - VDD on. Each increment is 100 ms. (500ms = 04h) */
-	{0x0F, 0xFF, 0x68},
-	/* LVDS output power up */
-	{0x09, 0xA0, 0xA0},
-	/* turn on back light */
-	{0x10, 0x33, 0x13}
-};
-
-struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x08, 0xF0, 0xE0}	/* Input Data Mode Select */
-};
-
-struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x08, 0xF0, 0x00}	/* Input Data Mode Select */
-};
-
-struct IODATA DITHERING_ENABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x0A, 0x70, 0x50}
-};
-
-struct IODATA DITHERING_DISABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x0A, 0x70, 0x00}
-};
-
-struct IODATA VDD_ON_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x10, 0x20, 0x20}
-};
-
-struct IODATA VDD_OFF_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x10, 0x20, 0x00}
-};
diff --git a/drivers/video/via/tbl1636.h b/drivers/video/via/tbl1636.h
deleted file mode 100644
index d906055..0000000
--- a/drivers/video/via/tbl1636.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef _TBL1636_H_
-#define _TBL1636_H_
-#include "hw.h"
-
-extern struct IODATA COMMON_INIT_TBL_VT1636[8];
-extern struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[1];
-extern struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[1];
-extern struct IODATA DITHERING_ENABLE_TBL_VT1636[1];
-extern struct IODATA DITHERING_DISABLE_TBL_VT1636[1];
-extern struct IODATA VDD_ON_TBL_VT1636[1];
-extern struct IODATA VDD_OFF_TBL_VT1636[1];
-
-#endif /* _VIA_TBL1636_H_ */
diff --git a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
index 90aad12..60e4192 100644
--- a/drivers/video/via/vt1636.c
+++ b/drivers/video/via/vt1636.c
@@ -23,6 +23,34 @@
 #include <linux/via_i2c.h>
 #include "global.h"
 
+static const struct IODATA common_init_data[] = {
+/*  Index, Mask, Value */
+	/* Set panel power sequence timing */
+	{0x10, 0xC0, 0x00},
+	/* T1: VDD on - Data on. Each increment is 1 ms. (50ms = 031h) */
+	{0x0B, 0xFF, 0x40},
+	/* T2: Data on - Backlight on. Each increment is 2 ms. (210ms = 068h) */
+	{0x0C, 0xFF, 0x31},
+	/* T3: Backlight off -Data off. Each increment is 2 ms. (210ms = 068h)*/
+	{0x0D, 0xFF, 0x31},
+	/* T4: Data off - VDD off. Each increment is 1 ms. (50ms = 031h) */
+	{0x0E, 0xFF, 0x68},
+	/* T5: VDD off - VDD on. Each increment is 100 ms. (500ms = 04h) */
+	{0x0F, 0xFF, 0x68},
+	/* LVDS output power up */
+	{0x09, 0xA0, 0xA0},
+	/* turn on back light */
+	{0x10, 0x33, 0x13}
+};
+
+/* Index, Mask, Value */
+static const struct IODATA dual_channel_enable_data = {0x08, 0xF0, 0xE0};
+static const struct IODATA single_channel_enable_data = {0x08, 0xF0, 0x00};
+static const struct IODATA dithering_enable_data = {0x0A, 0x70, 0x50};
+static const struct IODATA dithering_disable_data = {0x0A, 0x70, 0x00};
+static const struct IODATA vdd_on_data = {0x10, 0x20, 0x20};
+static const struct IODATA vdd_off_data = {0x10, 0x20, 0x00};
+
 u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info,
 	u8 index)
@@ -55,52 +83,41 @@ void viafb_init_lvds_vt1636(struct lvds_setting_information
 	int reg_num, i;
 
 	/* Common settings: */
-	reg_num = ARRAY_SIZE(COMMON_INIT_TBL_VT1636);
-
-	for (i = 0; i < reg_num; i++) {
+	reg_num = ARRAY_SIZE(common_init_data);
+	for (i = 0; i < reg_num; i++)
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 COMMON_INIT_TBL_VT1636[i]);
-	}
+			plvds_chip_info, common_init_data[i]);
 
 	/* Input Data Mode Select */
-	if (plvds_setting_info->device_lcd_dualedge) {
+	if (plvds_setting_info->device_lcd_dualedge)
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 DUAL_CHANNEL_ENABLE_TBL_VT1636[0]);
-	} else {
+			plvds_chip_info, dual_channel_enable_data);
+	else
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 SINGLE_CHANNEL_ENABLE_TBL_VT1636[0]);
-	}
+			plvds_chip_info, single_channel_enable_data);
 
-	if (plvds_setting_info->LCDDithering) {
+	if (plvds_setting_info->LCDDithering)
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 DITHERING_ENABLE_TBL_VT1636[0]);
-	} else {
+			plvds_chip_info, dithering_enable_data);
+	else
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 DITHERING_DISABLE_TBL_VT1636[0]);
-	}
+			plvds_chip_info, dithering_disable_data);
 }
 
 void viafb_enable_lvds_vt1636(struct lvds_setting_information
 			*plvds_setting_info,
 			struct lvds_chip_information *plvds_chip_info)
 {
-
 	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
-				 VDD_ON_TBL_VT1636[0]);
+		vdd_on_data);
 }
 
 void viafb_disable_lvds_vt1636(struct lvds_setting_information
 			 *plvds_setting_info,
 			 struct lvds_chip_information *plvds_chip_info)
 {
-
 	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
-				 VDD_OFF_TBL_VT1636[0]);
+		vdd_off_data);
 }
 
 bool viafb_lvds_identify_vt1636(u8 i2c_adapter)
-- 
1.6.3.2

