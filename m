Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1CLVIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:08:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44408 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755527Ab1CLVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:07:46 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+vLvh+/3ivFjGEGGZrdWFZI+szjvEvLHLpYPSjgH
	ZD2TkcHEhWi3LG
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/4] viafb: kill lcd_panel_id
Date: Sat, 12 Mar 2011 21:22:56 +0000
Message-Id: <1299964979-3391-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all internal uses of another mostly artificial
value. It does duplicate the information of the maximum resolution and
it is not flexible as only a few resolutions exist. Hence it is better
to remove it and clean the mess up.
No runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h          |    2 -
 drivers/video/via/lcd.c           |   50 -------------------------------------
 drivers/video/via/tblDPASetting.c |   23 -----------------
 drivers/video/via/tblDPASetting.h |    2 -
 drivers/video/via/vt1636.c        |   43 +++++++++----------------------
 5 files changed, 13 insertions(+), 107 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index 48f1342..a2f6200 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -163,7 +163,6 @@ struct lvds_setting_information {
 	int v_active;
 	int bpp;
 	int refresh_rate;
-	int lcd_panel_id;
 	int lcd_panel_hres;
 	int lcd_panel_vres;
 	int display_method;
@@ -188,7 +187,6 @@ struct GFX_DPA_SETTING {
 };
 
 struct VT1636_DPA_SETTING {
-	int PanelSizeID;
 	u8 CLK_SEL_ST1;
 	u8 CLK_SEL_ST2;
 };
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 2ca3bb8..d75e3f8 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -97,8 +97,6 @@ void __devinit viafb_init_lcd_size(void)
 	DEBUG_MSG(KERN_INFO "viafb_init_lcd_size()\n");
 
 	fp_id_to_vindex(viafb_lcd_panel_id);
-	viaparinfo->lvds_setting_info2->lcd_panel_id =
-		viaparinfo->lvds_setting_info->lcd_panel_id;
 	viaparinfo->lvds_setting_info2->lcd_panel_hres =
 		viaparinfo->lvds_setting_info->lcd_panel_hres;
 	viaparinfo->lvds_setting_info2->lcd_panel_vres =
@@ -205,176 +203,132 @@ static void __devinit fp_id_to_vindex(int panel_id)
 	case 0x0:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 640;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 480;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID0_640X480;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x1:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 800;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 600;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID1_800X600;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x2:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x3:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x4:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 1024;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID4_1280X1024;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x5:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1400;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 1050;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID5_1400X1050;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x6:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1600;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 1200;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID6_1600X1200;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x8:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 800;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 480;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_IDA_800X480;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x9:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0xA:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0xB:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0xC:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0xD:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 1024;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID4_1280X1024;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0xE:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1400;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 1050;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID5_1400X1050;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0xF:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1600;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 1200;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID6_1600X1200;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0x10:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1366;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID7_1366X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0x11:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 600;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID8_1024X600;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x12:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x13:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 800;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID9_1280X800;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
 	case 0x14:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1360;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_IDB_1360X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0x15:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 768;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	case 0x16:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 480;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 640;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_IDC_480X640;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 		break;
@@ -382,16 +336,12 @@ static void __devinit fp_id_to_vindex(int panel_id)
 		/* OLPC XO-1.5 panel */
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1200;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 900;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_IDD_1200X900;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
 		break;
 	default:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 800;
 		viaparinfo->lvds_setting_info->lcd_panel_vres = 600;
-		viaparinfo->lvds_setting_info->lcd_panel_id =
-			LCD_PANEL_ID1_800X600;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
 	}
diff --git a/drivers/video/via/tblDPASetting.c b/drivers/video/via/tblDPASetting.c
index 0c4c8cc..73bb554 100644
--- a/drivers/video/via/tblDPASetting.c
+++ b/drivers/video/via/tblDPASetting.c
@@ -20,17 +20,6 @@
  */
 
 #include "global.h"
-/* For VT3324: */
-struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3324[] = {
-	/* Panel ID,       CLK_SEL_ST1[09],    CLK_SEL_ST2[08] */
-	{LCD_PANEL_ID0_640X480, 0x00, 0x00},	/* For 640x480   */
-	{LCD_PANEL_ID1_800X600, 0x00, 0x00},	/* For 800x600   */
-	{LCD_PANEL_ID2_1024X768, 0x00, 0x00},	/* For 1024x768  */
-	{LCD_PANEL_ID3_1280X768, 0x00, 0x00},	/* For 1280x768  */
-	{LCD_PANEL_ID4_1280X1024, 0x00, 0x00},	/* For 1280x1024 */
-	{LCD_PANEL_ID5_1400X1050, 0x00, 0x00},	/* For 1400x1050 */
-	{LCD_PANEL_ID6_1600X1200, 0x0B, 0x03}	/* For 1600x1200 */
-};
 
 struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3324[] = {
 /*  ClkRange, DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
@@ -57,18 +46,6 @@ struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3324[] = {
 	 0x00},
 };
 
-/* For VT3327: */
-struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3327[] = {
-	/* Panel ID,       CLK_SEL_ST1[09],    CLK_SEL_ST2[08] */
-	{LCD_PANEL_ID0_640X480, 0x00, 0x00},	/* For 640x480   */
-	{LCD_PANEL_ID1_800X600, 0x00, 0x00},	/* For 800x600   */
-	{LCD_PANEL_ID2_1024X768, 0x00, 0x00},	/* For 1024x768  */
-	{LCD_PANEL_ID3_1280X768, 0x00, 0x00},	/* For 1280x768  */
-	{LCD_PANEL_ID4_1280X1024, 0x00, 0x00},	/* For 1280x1024 */
-	{LCD_PANEL_ID5_1400X1050, 0x00, 0x00},	/* For 1400x1050 */
-	{LCD_PANEL_ID6_1600X1200, 0x00, 0x00}	/* For 1600x1200 */
-};
-
 struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3327[] = {
 /*  ClkRange,DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
 					DVP1Driving, DFPHigh,   DFPLow */
diff --git a/drivers/video/via/tblDPASetting.h b/drivers/video/via/tblDPASetting.h
index b065a83..6db6151 100644
--- a/drivers/video/via/tblDPASetting.h
+++ b/drivers/video/via/tblDPASetting.h
@@ -38,9 +38,7 @@ enum DPA_RANGE {
 	DPA_CLK_RANGE_150M
 };
 
-extern struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3324[7];
 extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3324[6];
-extern struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3327[7];
 extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3327[];
 extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3364[6];
 
diff --git a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
index 60e4192..ee2903b 100644
--- a/drivers/video/via/vt1636.c
+++ b/drivers/video/via/vt1636.c
@@ -167,22 +167,6 @@ static int get_clk_range_index(u32 Clk)
 		return DPA_CLK_RANGE_150M;
 }
 
-static int get_lvds_dpa_setting_index(int panel_size_id,
-			     struct VT1636_DPA_SETTING *p_vt1636_dpasetting_tbl,
-			       int tbl_size)
-{
-	int i;
-
-	for (i = 0; i < tbl_size; i++) {
-		if (panel_size_id == p_vt1636_dpasetting_tbl->PanelSizeID)
-			return i;
-
-		p_vt1636_dpasetting_tbl++;
-	}
-
-	return 0;
-}
-
 static void set_dpa_vt1636(struct lvds_setting_information
 	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info,
 		    struct VT1636_DPA_SETTING *p_vt1636_dpa_setting)
@@ -206,7 +190,9 @@ void viafb_vt1636_patch_skew_on_vt3324(
 	struct lvds_setting_information *plvds_setting_info,
 	struct lvds_chip_information *plvds_chip_info)
 {
-	int index, size;
+	struct VT1636_DPA_SETTING dpa = {0x00, 0x00}, dpa_16x12 = {0x0B, 0x03},
+		*pdpa;
+	int index;
 
 	DEBUG_MSG(KERN_INFO "viafb_vt1636_patch_skew_on_vt3324.\n");
 
@@ -216,19 +202,21 @@ void viafb_vt1636_patch_skew_on_vt3324(
 		    &GFX_DPA_SETTING_TBL_VT3324[index]);
 
 	/* LVDS Transmitter DPA settings: */
-	size = ARRAY_SIZE(VT1636_DPA_SETTING_TBL_VT3324);
-	index =
-	    get_lvds_dpa_setting_index(plvds_setting_info->lcd_panel_id,
-				       VT1636_DPA_SETTING_TBL_VT3324, size);
-	set_dpa_vt1636(plvds_setting_info, plvds_chip_info,
-		       &VT1636_DPA_SETTING_TBL_VT3324[index]);
+	if (plvds_setting_info->lcd_panel_hres == 1600 &&
+		plvds_setting_info->lcd_panel_vres == 1200)
+		pdpa = &dpa_16x12;
+	else
+		pdpa = &dpa;
+
+	set_dpa_vt1636(plvds_setting_info, plvds_chip_info, pdpa);
 }
 
 void viafb_vt1636_patch_skew_on_vt3327(
 	struct lvds_setting_information *plvds_setting_info,
 	struct lvds_chip_information *plvds_chip_info)
 {
-	int index, size;
+	struct VT1636_DPA_SETTING dpa = {0x00, 0x00};
+	int index;
 
 	DEBUG_MSG(KERN_INFO "viafb_vt1636_patch_skew_on_vt3327.\n");
 
@@ -238,12 +226,7 @@ void viafb_vt1636_patch_skew_on_vt3327(
 		    &GFX_DPA_SETTING_TBL_VT3327[index]);
 
 	/* LVDS Transmitter DPA settings: */
-	size = ARRAY_SIZE(VT1636_DPA_SETTING_TBL_VT3327);
-	index =
-	    get_lvds_dpa_setting_index(plvds_setting_info->lcd_panel_id,
-				       VT1636_DPA_SETTING_TBL_VT3327, size);
-	set_dpa_vt1636(plvds_setting_info, plvds_chip_info,
-		       &VT1636_DPA_SETTING_TBL_VT3327[index]);
+	set_dpa_vt1636(plvds_setting_info, plvds_chip_info, &dpa);
 }
 
 void viafb_vt1636_patch_skew_on_vt3364(
-- 
1.6.3.2

