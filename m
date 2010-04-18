Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0DRSWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:22:34 -0400
Received: from tex.lwn.net ([70.33.254.29]:35374 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392Ab0DRSVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:21:34 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 08/11] viafb: Add 1200x900 DCON/LCD panel modes for OLPC XO-1.5
Date: Sun, 18 Apr 2010 12:21:10 -0600
Message-Id: <1271614873-5952-9-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271614873-5952-1-git-send-email-corbet@lwn.net>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

[jc: extensive merge conflict fixes]
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: ScottFang@viatech.com.cn
Cc: JosephChan@via.com.tw
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/video/via/hw.c      |    1 +
 drivers/video/via/ioctl.h   |    2 +-
 drivers/video/via/lcd.c     |    9 +++++++++
 drivers/video/via/lcd.h     |    2 ++
 drivers/video/via/share.h   |    7 +++++++
 drivers/video/via/viamode.c |   14 ++++++++++++++
 6 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index d893695..4aff0f7 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -63,6 +63,7 @@ static struct pll_map pll_value[] = {
 	 CX700_52_977M,	VX855_52_977M},
 	{CLK_56_250M, CLE266_PLL_56_250M, K800_PLL_56_250M,
 	 CX700_56_250M, VX855_56_250M},
+	{CLK_57_275M, 0, 0, 0, VX855_57_275M},
 	{CLK_60_466M, CLE266_PLL_60_466M, K800_PLL_60_466M,
 	 CX700_60_466M, VX855_60_466M},
 	{CLK_61_500M, CLE266_PLL_61_500M, K800_PLL_61_500M,
diff --git a/drivers/video/via/ioctl.h b/drivers/video/via/ioctl.h
index de89980..c430fa2 100644
--- a/drivers/video/via/ioctl.h
+++ b/drivers/video/via/ioctl.h
@@ -75,7 +75,7 @@
 /*SAMM operation flag*/
 #define OP_SAMM            0x80
 
-#define LCD_PANEL_ID_MAXIMUM	22
+#define LCD_PANEL_ID_MAXIMUM	23
 
 #define STATE_ON            0x1
 #define STATE_OFF           0x0
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 79c8c9d..b656e59 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -399,6 +399,15 @@ static void fp_id_to_vindex(int panel_id)
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
+	case 0x17:
+		/* OLPC XO-1.5 panel */
+		viaparinfo->lvds_setting_info->lcd_panel_hres = 1200;
+		viaparinfo->lvds_setting_info->lcd_panel_vres = 900;
+		viaparinfo->lvds_setting_info->lcd_panel_id =
+			LCD_PANEL_IDD_1200X900;
+		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
+		viaparinfo->lvds_setting_info->LCDDithering = 0;
+		break;
 	default:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 800;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 600;
diff --git a/drivers/video/via/lcd.h b/drivers/video/via/lcd.h
index 071f47c..9762ec6 100644
--- a/drivers/video/via/lcd.h
+++ b/drivers/video/via/lcd.h
@@ -60,6 +60,8 @@
 #define     LCD_PANEL_IDB_1360X768     0x0B
 /* Resolution: 480x640,  Channel: single, Dithering: Enable */
 #define     LCD_PANEL_IDC_480X640      0x0C
+/* Resolution: 1200x900,  Channel: single, Dithering: Disable */
+#define     LCD_PANEL_IDD_1200X900      0x0D
 
 
 extern int viafb_LCD2_ON;
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index d55aaa7..f974c73 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -570,6 +570,10 @@
 #define M1200X720_R60_HSP       NEGATIVE
 #define M1200X720_R60_VSP       POSITIVE
 
+/* 1200x900@60 Sync Polarity (DCON) */
+#define M1200X900_R60_HSP       NEGATIVE
+#define M1200X900_R60_VSP       NEGATIVE
+
 /* 1280x600@60 Sync Polarity (GTF Mode) */
 #define M1280x600_R60_HSP       NEGATIVE
 #define M1280x600_R60_VSP       POSITIVE
@@ -651,6 +655,7 @@
 #define CLK_52_406M     52406000
 #define CLK_52_977M     52977000
 #define CLK_56_250M     56250000
+#define CLK_57_275M     57275000
 #define CLK_60_466M     60466000
 #define CLK_61_500M     61500000
 #define CLK_65_000M     65000000
@@ -939,6 +944,7 @@
 #define VX855_52_406M     0x00580C03
 #define VX855_52_977M     0x00940C05
 #define VX855_56_250M     0x009D0C05
+#define VX855_57_275M     0x009D8C85    /* Used by XO panel */
 #define VX855_60_466M     0x00A90C05
 #define VX855_61_500M     0x00AC0C05
 #define VX855_65_000M     0x006D0C03
@@ -1065,6 +1071,7 @@
 #define RES_1600X1200_60HZ_PIXCLOCK  6172
 #define RES_1600X1200_75HZ_PIXCLOCK  4938
 #define RES_1280X720_60HZ_PIXCLOCK   13426
+#define RES_1200X900_60HZ_PIXCLOCK   17459
 #define RES_1920X1080_60HZ_PIXCLOCK  5787
 #define RES_1400X1050_60HZ_PIXCLOCK  8214
 #define RES_1400X1050_75HZ_PIXCLOCK  6410
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index af50e24..6f3bcda 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -66,6 +66,7 @@ struct res_map_refresh res_map_refresh_tbl[] = {
 	{1088, 612, RES_1088X612_60HZ_PIXCLOCK, 60},
 	{1152, 720, RES_1152X720_60HZ_PIXCLOCK, 60},
 	{1200, 720, RES_1200X720_60HZ_PIXCLOCK, 60},
+	{1200, 900, RES_1200X900_60HZ_PIXCLOCK, 60},
 	{1280, 600, RES_1280X600_60HZ_PIXCLOCK, 60},
 	{1280, 720, RES_1280X720_50HZ_PIXCLOCK, 50},
 	{1280, 768, RES_1280X768_50HZ_PIXCLOCK, 50},
@@ -759,6 +760,16 @@ struct crt_mode_table CRTM1200x720[] = {
 	 {1568, 1200, 1200, 368, 1256, 128, 746, 720, 720, 26, 721, 3} }
 };
 
+/* 1200x900 (DCON) */
+struct crt_mode_table DCON1200x900[] = {
+	/* r_rate,          vclk,               hsp,               vsp   */
+	{REFRESH_60, CLK_57_275M, M1200X900_R60_HSP, M1200X900_R60_VSP,
+	/* The correct htotal is 1240, but this doesn't raster on VX855. */
+	/* Via suggested changing to a multiple of 16, hence 1264.       */
+	/*  HT,   HA,  HBS, HBE,  HSS, HSE,  VT,  VA, VBS, VBE, VSS, VSE */
+	 {1264, 1200, 1200,  64, 1211,  32, 912, 900, 900,  12, 901, 10} }
+};
+
 /* 1280x600 (GTF) */
 struct crt_mode_table CRTM1280x600[] = {
 	/* r_rate,          vclk,              hsp,             vsp   */
@@ -937,6 +948,9 @@ struct VideoModeTable viafb_modes[] = {
 	/* Display : 1200x720 (GTF) */
 	{CRTM1200x720, ARRAY_SIZE(CRTM1200x720)},
 
+	/* Display : 1200x900 (DCON) */
+	{DCON1200x900, ARRAY_SIZE(DCON1200x900)},
+
 	/* Display : 1280x600 (GTF) */
 	{CRTM1280x600, ARRAY_SIZE(CRTM1280x600)},
 
-- 
1.7.0.1

