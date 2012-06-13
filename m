Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2FMWWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:22:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44659 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754949Ab2FMWWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:10 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19wvUBnrwdwlT5R9i+fumOKpBb1IfNkK7TEQWORQ1
	jq7LMqs+JQ5wh5
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] staging/xgifb: Use SiS structs
Date: Thu, 14 Jun 2012 00:21:51 +0200
Message-Id: <1339626112-20671-13-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces some of the XGI internal structs by their
counterparts in the SiS driver.
XGI330_LVDSDataStruct -> SiS_LVDSData
XGI330_LCDDataStruct -> SiS_LCDData
XGI330_CHTVDataStruct -> SiS_LVDSData

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |    4 +-
 drivers/staging/xgifb/vb_struct.h  |   28 ----------
 drivers/staging/xgifb/vb_table.h   |   96 ++++++++++++++++++------------------
 3 files changed, 50 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index c6c6843..183afe4 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1980,12 +1980,12 @@ static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx;
-	struct XGI330_LVDSDataStruct *LCDPtr = NULL;
+	struct SiS_LVDSData *LCDPtr = NULL;
 
 	tempbx = 2;
 
 	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
-		LCDPtr = (struct XGI330_LVDSDataStruct *) XGI_GetLcdPtr(tempbx,
+		LCDPtr = (struct SiS_LVDSData *)XGI_GetLcdPtr(tempbx,
 				ModeNo, ModeIdIndex, RefreshRateTableIndex,
 				pVBInfo);
 		pVBInfo->VGAHT = LCDPtr->VGAHT;
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index b954971..b54488b 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -51,13 +51,6 @@ struct XGI_LCDDataTablStruct {
 	unsigned short DATAPTR;
 };
 
-struct XGI330_LVDSDataStruct {
-	unsigned short VGAHT;
-	unsigned short VGAVT;
-	unsigned short LCDHT;
-	unsigned short LCDVT;
-};
-
 struct XGI330_LCDDataDesStruct2 {
 	unsigned short LCDHDES;
 	unsigned short LCDHRS;
@@ -67,15 +60,6 @@ struct XGI330_LCDDataDesStruct2 {
 	unsigned short LCDVSync;
 };
 
-struct XGI330_LCDDataStruct {
-	unsigned short RVBHCMAX;
-	unsigned short RVBHCFACT;
-	unsigned short VGAHT;
-	unsigned short VGAVT;
-	unsigned short LCDHT;
-	unsigned short LCDVT;
-};
-
 
 struct XGI330_TVDataStruct {
 	unsigned short RVBHCMAX;
@@ -103,13 +87,6 @@ struct XGI330_TVDataTablStruct {
 };
 
 
-struct XGI330_CHTVDataStruct {
-	unsigned short VGAHT;
-	unsigned short VGAVT;
-	unsigned short LCDHT;
-	unsigned short LCDVT;
-};
-
 struct XGI_TimingHStruct {
 	unsigned char data[8];
 };
@@ -173,11 +150,6 @@ struct XGI_CRT1TableStruct {
 };
 
 
-struct XGI330_VCLKDataStruct {
-	unsigned char SR2B, SR2C;
-	unsigned short CLOCK;
-};
-
 struct XGI301C_Tap4TimingStruct {
 	unsigned short DE;
 	unsigned char  Reg[64];   /* C0-FF */
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 50ef885..16bb831 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -420,7 +420,7 @@ static unsigned char XGI_CH7017LV1400x1050[] = {
 	0xAD, 0xDB, 0xF6, 0xAC, 0xE0, 0x02};
 
 /*add for new UNIVGABIOS*/
-static struct XGI330_LCDDataStruct  XGI_StLCD1024x768Data[] = {
+static struct SiS_LCDData  XGI_StLCD1024x768Data[] = {
 	{62,  25, 800,  546, 1344, 806},
 	{32,  15, 930,  546, 1344, 806},
 	{62,  25, 800,  546, 1344, 806}, /*chiawenfordot9->dot8*/
@@ -430,7 +430,7 @@ static struct XGI330_LCDDataStruct  XGI_StLCD1024x768Data[] = {
 	{1,   1,  1344, 806, 1344, 806}
 };
 
-static struct XGI330_LCDDataStruct  XGI_ExtLCD1024x768Data[] = {
+static struct SiS_LCDData  XGI_ExtLCD1024x768Data[] = {
 	/* { 12, 5, 896, 512,1344, 806}, // alan 09/12/2003 */
 	{42, 25, 1536, 419, 1344, 806},
 	/* { 12, 5, 896, 510,1344, 806}, // alan 09/12/2003 */
@@ -450,7 +450,7 @@ static struct XGI330_LCDDataStruct  XGI_ExtLCD1024x768Data[] = {
 	{1,  1,  1344, 806, 1344, 806}
 };
 
-static struct XGI330_LCDDataStruct  XGI_CetLCD1024x768Data[] = {
+static struct SiS_LCDData  XGI_CetLCD1024x768Data[] = {
 	{1, 1, 1344, 806, 1344, 806}, /* ; 00 (320x200,320x400,
 					       640x200,640x400) */
 	{1, 1, 1344, 806, 1344, 806}, /* 01 (320x350,640x350) */
@@ -461,7 +461,7 @@ static struct XGI330_LCDDataStruct  XGI_CetLCD1024x768Data[] = {
 	{1, 1, 1344, 806, 1344, 806}  /* 06 (1024x768x60Hz) */
 };
 
-static struct XGI330_LCDDataStruct  XGI_StLCD1280x1024Data[] = {
+static struct SiS_LCDData  XGI_StLCD1280x1024Data[] = {
 	{22,  5,  800,  510,  1650, 1088},
 	{22,  5,  800,  510,  1650, 1088},
 	{176, 45, 900,  510,  1650, 1088},
@@ -472,7 +472,7 @@ static struct XGI330_LCDDataStruct  XGI_StLCD1280x1024Data[] = {
 	{1,   1,  1688, 1066, 1688, 1066}
 };
 
-static struct XGI330_LCDDataStruct  XGI_ExtLCD1280x1024Data[] = {
+static struct SiS_LCDData  XGI_ExtLCD1280x1024Data[] = {
 	{211, 60,  1024, 501,  1688, 1066},
 	{211, 60,  1024, 508,  1688, 1066},
 	{211, 60,  1024, 501,  1688, 1066},
@@ -483,7 +483,7 @@ static struct XGI330_LCDDataStruct  XGI_ExtLCD1280x1024Data[] = {
 	{1,   1,   1688, 1066, 1688, 1066}
 };
 
-static struct XGI330_LCDDataStruct  XGI_CetLCD1280x1024Data[] = {
+static struct SiS_LCDData  XGI_CetLCD1280x1024Data[] = {
 	{1, 1, 1688, 1066, 1688, 1066}, /* 00 (320x200,320x400,
 					       640x200,640x400) */
 	{1, 1, 1688, 1066, 1688, 1066}, /* 01 (320x350,640x350) */
@@ -496,7 +496,7 @@ static struct XGI330_LCDDataStruct  XGI_CetLCD1280x1024Data[] = {
 	{1, 1, 1688, 1066, 1688, 1066}  /* 08 (1400x1050x60Hz) */
 };
 
-static struct XGI330_LCDDataStruct xgifb_lcd_1400x1050[] = {
+static struct SiS_LCDData xgifb_lcd_1400x1050[] = {
 	{211, 100, 2100, 408,  1688, 1066}, /* 00 (320x200,320x400,
 						   640x200,640x400) */
 	{211, 64,  1536, 358,  1688, 1066}, /* 01 (320x350,640x350) */
@@ -510,7 +510,7 @@ static struct XGI330_LCDDataStruct xgifb_lcd_1400x1050[] = {
 	{1,   1,   1688, 1066, 1688, 1066}  /* 08 (1400x1050x60Hz) */
 };
 
-static struct XGI330_LCDDataStruct  XGI_ExtLCD1600x1200Data[] = {
+static struct SiS_LCDData  XGI_ExtLCD1600x1200Data[] = {
 	{4,  1,  1620, 420,  2160, 1250}, /* { 3,1,2160,425,2160,1250 },
 					  // 00 (320x200,320x400,
 					  //	 640x200,640x400)
@@ -528,7 +528,7 @@ static struct XGI330_LCDDataStruct  XGI_ExtLCD1600x1200Data[] = {
 	{1,  1,  2160, 1250, 2160, 1250}  /* 09 (1600x1200x60Hz) ;302lv */
 };
 
-static struct XGI330_LCDDataStruct  XGI_StLCD1600x1200Data[] = {
+static struct SiS_LCDData  XGI_StLCD1600x1200Data[] = {
 	{27,  4,  800,  500,  2160, 1250}, /* 00 (320x200,320x400,
 						  640x200,640x400) */
 	{27,  4,  800,  500,  2160, 1250}, /* 01 (320x350,640x350) */
@@ -542,7 +542,7 @@ static struct XGI330_LCDDataStruct  XGI_StLCD1600x1200Data[] = {
 	{1,   1,  2160, 1250, 2160, 1250}  /* 09 (1600x1200) */
 };
 
-static struct XGI330_LCDDataStruct  XGI_CetLCD1400x1050Data[] = {
+static struct SiS_LCDData  XGI_CetLCD1400x1050Data[] = {
 	{1, 1, 1688, 1066, 1688, 1066}, /* 00 (320x200,320x400,
 					       640x200,640x400) */
 	{1, 1, 1688, 1066, 1688, 1066}, /* 01 (320x350,640x350) */
@@ -555,7 +555,7 @@ static struct XGI330_LCDDataStruct  XGI_CetLCD1400x1050Data[] = {
 	{1, 1, 1688, 1066, 1688, 1066}  /* 08 (1400x1050x60Hz) */
 };
 
-static struct XGI330_LCDDataStruct  XGI_NoScalingData[] = {
+static struct SiS_LCDData  XGI_NoScalingData[] = {
 	{1, 1, 800,  449,  800,  449},
 	{1, 1, 800,  449,  800,  449},
 	{1, 1, 900,  449,  900,  449},
@@ -566,7 +566,7 @@ static struct XGI330_LCDDataStruct  XGI_NoScalingData[] = {
 	{1, 1, 1688, 1066, 1688, 1066}
 };
 
-static struct XGI330_LCDDataStruct  XGI_ExtLCD1024x768x75Data[] = {
+static struct SiS_LCDData  XGI_ExtLCD1024x768x75Data[] = {
 	{42, 25, 1536, 419, 1344, 806}, /* ; 00 (320x200,320x400,
 						 640x200,640x400) */
 	{48, 25, 1536, 369, 1344, 806}, /* ; 01 (320x350,640x350) */
@@ -577,7 +577,7 @@ static struct XGI330_LCDDataStruct  XGI_ExtLCD1024x768x75Data[] = {
 	{1,  1,  1312, 800, 1312, 800}  /* ; 06 (1024x768x75Hz) */
 };
 
-static struct XGI330_LCDDataStruct  XGI_CetLCD1024x768x75Data[] = {
+static struct SiS_LCDData  XGI_CetLCD1024x768x75Data[] = {
 	{1, 1, 1312, 800, 1312, 800}, /* ; 00 (320x200,320x400,
 					       640x200,640x400) */
 	{1, 1, 1312, 800, 1312, 800}, /* ; 01 (320x350,640x350) */
@@ -588,7 +588,7 @@ static struct XGI330_LCDDataStruct  XGI_CetLCD1024x768x75Data[] = {
 	{1, 1, 1312, 800, 1312, 800}  /* ; 06 (1024x768x75Hz) */
 };
 
-static struct XGI330_LCDDataStruct xgifb_lcd_1280x1024x75[] = {
+static struct SiS_LCDData xgifb_lcd_1280x1024x75[] = {
 	{211, 60,  1024, 501,  1688, 1066}, /* ; 00 (320x200,320x400,
 						     640x200,640x400) */
 	{211, 60,  1024, 508,  1688, 1066}, /* ; 01 (320x350,640x350) */
@@ -600,7 +600,7 @@ static struct XGI330_LCDDataStruct xgifb_lcd_1280x1024x75[] = {
 	{1,   1,   1688, 1066, 1688, 1066}  /* ; 07 (1280x1024x75Hz) */
 };
 
-static struct XGI330_LCDDataStruct  XGI_CetLCD1280x1024x75Data[] = {
+static struct SiS_LCDData  XGI_CetLCD1280x1024x75Data[] = {
 	{1, 1, 1688, 1066, 1688, 1066}, /* ; 00 (320x200,320x400,
 						 640x200,640x400) */
 	{1, 1, 1688, 1066, 1688, 1066}, /* ; 01 (320x350,640x350) */
@@ -612,7 +612,7 @@ static struct XGI330_LCDDataStruct  XGI_CetLCD1280x1024x75Data[] = {
 	{1, 1, 1688, 1066, 1688, 1066}  /* ; 07 (1280x1024x75Hz) */
 };
 
-static struct XGI330_LCDDataStruct  XGI_NoScalingDatax75[] = {
+static struct SiS_LCDData  XGI_NoScalingDatax75[] = {
 	{1, 1, 800,  449,  800,  449},  /* ; 00 (320x200, 320x400,
 						 640x200, 640x400) */
 	{1, 1, 800,  449,  800,  449},  /* ; 01 (320x350, 640x350) */
@@ -1222,7 +1222,7 @@ static unsigned char XGI330_Ren750pGroup3[] = {
 	0x18, 0x1D, 0x23, 0x28, 0x4C, 0xAA, 0x01
 };
 
-static struct XGI330_LVDSDataStruct  XGI_LVDS1024x768Data_1[] = {
+static struct SiS_LVDSData  XGI_LVDS1024x768Data_1[] = {
 	{ 960, 438, 1344, 806},	/* 00 (320x200,320x400,640x200,640x400) */
 	{ 960, 388, 1344, 806},	/* 01 (320x350,640x350) */
 	{1040, 438, 1344, 806},	/* 02 (360x400,720x400) */
@@ -1233,7 +1233,7 @@ static struct XGI330_LVDSDataStruct  XGI_LVDS1024x768Data_1[] = {
 };
 
 
-static struct XGI330_LVDSDataStruct  XGI_LVDS1024x768Data_2[] = {
+static struct SiS_LVDSData  XGI_LVDS1024x768Data_2[] = {
 	{1344, 806, 1344, 806},
 	{1344, 806, 1344, 806},
 	{1344, 806, 1344, 806},
@@ -1245,7 +1245,7 @@ static struct XGI330_LVDSDataStruct  XGI_LVDS1024x768Data_2[] = {
 	{800,  525, 1280, 813}
 };
 
-static struct XGI330_LVDSDataStruct  XGI_LVDS1280x1024Data_1[] = {
+static struct SiS_LVDSData  XGI_LVDS1280x1024Data_1[] = {
 	{1048, 442,  1688, 1066},
 	{1048, 392,  1688, 1066},
 	{1048, 442,  1688, 1066},
@@ -1256,7 +1256,7 @@ static struct XGI330_LVDSDataStruct  XGI_LVDS1280x1024Data_1[] = {
 	{1688, 1066, 1688, 1066}
 };
 
-static struct XGI330_LVDSDataStruct  XGI_LVDS1280x1024Data_2[] = {
+static struct SiS_LVDSData  XGI_LVDS1280x1024Data_2[] = {
 	{1344, 806, 1344, 806},
 	{1344, 806, 1344, 806},
 	{1344, 806, 1344, 806},
@@ -1268,7 +1268,7 @@ static struct XGI330_LVDSDataStruct  XGI_LVDS1280x1024Data_2[] = {
 	{800,  525, 1280, 813}
 };
 
-static struct XGI330_LVDSDataStruct  XGI_LVDS1400x1050Data_1[] = {
+static struct SiS_LVDSData  XGI_LVDS1400x1050Data_1[] = {
 	{928,   416, 1688, 1066},
 	{928,   366, 1688, 1066},
 	{928,   416, 1688, 1066},
@@ -1280,7 +1280,7 @@ static struct XGI330_LVDSDataStruct  XGI_LVDS1400x1050Data_1[] = {
 	{1688, 1066, 1688, 1066}
 };
 
-static struct XGI330_LVDSDataStruct  XGI_LVDS1400x1050Data_2[] = {
+static struct SiS_LVDSData  XGI_LVDS1400x1050Data_2[] = {
 	{1688, 1066, 1688, 1066},
 	{1688, 1066, 1688, 1066},
 	{1688, 1066, 1688, 1066},
@@ -1293,7 +1293,7 @@ static struct XGI330_LVDSDataStruct  XGI_LVDS1400x1050Data_2[] = {
 };
 
 /* ;;[ycchen] 12/05/02 LCDHTxLCDVT=2048x1320 */
-static struct XGI330_LVDSDataStruct XGI_LVDS1600x1200Data_1[] = {
+static struct SiS_LVDSData XGI_LVDS1600x1200Data_1[] = {
 	{1088, 520,  2048, 1320}, /* 00 (320x200,320x400,640x200,640x400) */
 	{1088, 470,  2048, 1320}, /* 01 (320x350,640x350) */
 	{1088, 520,  2048, 1320}, /* 02 (360x400,720x400) */
@@ -1306,7 +1306,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1600x1200Data_1[] = {
 	{2048, 1320, 2048, 1320}  /* 09 (1600x1200) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDSNoScalingData[] = {
+static struct SiS_LVDSData XGI_LVDSNoScalingData[] = {
 	{ 800,  449,  800,  449}, /* 00 (320x200,320x400,640x200,640x400) */
 	{ 800,  449,  800,  449}, /* 01 (320x350,640x350) */
 	{ 800,  449,  800,  449}, /* 02 (360x400,720x400) */
@@ -1320,7 +1320,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDSNoScalingData[] = {
 	{1688,  806, 1688,  806}  /* 0A (1280x768x60Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Data_1x75[] = {
+static struct SiS_LVDSData XGI_LVDS1024x768Data_1x75[] = {
 	{ 960, 438, 1312, 800}, /* 00 (320x200,320x400,640x200,640x400) */
 	{ 960, 388, 1312, 800}, /* 01 (320x350,640x350) */
 	{1040, 438, 1312, 800}, /* 02 (360x400,720x400) */
@@ -1331,7 +1331,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Data_1x75[] = {
 };
 
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Data_2x75[] = {
+static struct SiS_LVDSData XGI_LVDS1024x768Data_2x75[] = {
 	{1312, 800, 1312, 800}, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{1312, 800, 1312, 800}, /* ; 01 (320x350,640x350) */
 	{1312, 800, 1312, 800}, /* ; 02 (360x400,720x400) */
@@ -1341,7 +1341,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Data_2x75[] = {
 	{1312, 800, 1312, 800}, /* ; 06 (512x384,1024x768) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Data_1x75[] = {
+static struct SiS_LVDSData XGI_LVDS1280x1024Data_1x75[] = {
 	{1048,  442, 1688, 1066  }, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{1048,  392, 1688, 1066  }, /* ; 01 (320x350,640x350) */
 	{1128,  442, 1688, 1066  }, /* ; 02 (360x400,720x400) */
@@ -1352,7 +1352,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Data_1x75[] = {
 	{1688, 1066, 1688, 1066 },  /* ; 06; 07 (640x512,1280x1024) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Data_2x75[] = {
+static struct SiS_LVDSData XGI_LVDS1280x1024Data_2x75[] = {
 	{1688, 1066, 1688, 1066 }, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{1688, 1066, 1688, 1066 }, /* ; 01 (320x350,640x350) */
 	{1688, 1066, 1688, 1066 }, /* ; 02 (360x400,720x400) */
@@ -1363,7 +1363,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Data_2x75[] = {
 	{1688, 1066, 1688, 1066 }, /* ; 06; 07 (640x512,1280x1024) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDSNoScalingDatax75[] = {
+static struct SiS_LVDSData XGI_LVDSNoScalingDatax75[] = {
 	{ 800,  449,  800, 449},  /* ; 00 (320x200,320x400,640x200,640x400) */
 	{ 800,  449,  800, 449},  /* ; 01 (320x350,640x350) */
 	{ 900,  449,  900, 449},  /* ; 02 (360x400,720x400) */
@@ -1378,7 +1378,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDSNoScalingDatax75[] = {
 	{1688,  806, 1688, 806},  /* ; 0A (1280x768x75Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_1[] = {
+static struct SiS_LVDSData XGI_LVDS1024x768Des_1[] = {
 	{0, 1048,   0, 771}, /* 00 (320x200,320x400,640x200,640x400) */
 	{0, 1048,   0, 771}, /* 01 (320x350,640x350) */
 	{0, 1048,   0, 771}, /* 02 (360x400,720x400) */
@@ -1388,7 +1388,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_1[] = {
 	{0, 1048, 805, 770}  /* 06 (1024x768x60Hz) */
 } ;
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_2[] = {
+static struct SiS_LVDSData XGI_LVDS1024x768Des_2[] = {
 	{1142,  856, 622, 587}, /* 00 (320x200,320x400,640x200,640x400) */
 	{1142,  856, 597, 562}, /* 01 (320x350,640x350) */
 	{1142,  856, 622, 587}, /* 02 (360x400,720x400) */
@@ -1398,7 +1398,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_2[] = {
 	{   0, 1048, 805, 771}  /* 06 (1024x768x60Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_3[] = {
+static struct SiS_LVDSData XGI_LVDS1024x768Des_3[] = {
 	{320, 24, 622, 587}, /* 00 (320x200,320x400,640x200,640x400) */
 	{320, 24, 597, 562}, /* 01 (320x350,640x350) */
 	{320, 24, 622, 587}, /* 02 (360x400,720x400) */
@@ -1406,7 +1406,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_3[] = {
 	{320, 24, 722, 687}  /* 04 (640x480x60Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Des_1[] = {
+static struct SiS_LVDSData XGI_LVDS1280x1024Des_1[] = {
 	{0, 1328,    0, 1025}, /* 00 (320x200,320x400,640x200,640x400) */
 	{0, 1328,    0, 1025}, /* 01 (320x350,640x350) */
 	{0, 1328,    0, 1025}, /* 02 (360x400,720x400) */
@@ -1418,7 +1418,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Des_1[] = {
 };
 
  /* The Display setting for DE Mode Panel */
-static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Des_2[] = {
+static struct SiS_LVDSData XGI_LVDS1280x1024Des_2[] = {
 	{1368, 1008, 752, 711}, /* 00 (320x200,320x400,640x200,640x400) */
 	{1368, 1008, 729, 688}, /* 01 (320x350,640x350) */
 	{1408, 1048, 752, 711}, /* 02 (360x400,720x400) */
@@ -1429,7 +1429,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Des_2[] = {
 	{0000, 1328,   0, 1025} /* 07 (1280x1024x60Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1400x1050Des_1[] = {
+static struct SiS_LVDSData XGI_LVDS1400x1050Des_1[] = {
 	{0, 1448, 0, 1051}, /* 00 (320x200,320x400,640x200,640x400) */
 	{0, 1448, 0, 1051}, /* 01 (320x350,640x350) */
 	{0, 1448, 0, 1051}, /* 02 (360x400,720x400) */
@@ -1441,7 +1441,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1400x1050Des_1[] = {
 	{0, 1448, 0, 1051}  /* 08 (1400x1050x60Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1400x1050Des_2[] = {
+static struct SiS_LVDSData XGI_LVDS1400x1050Des_2[] = {
 	{1308, 1068,  781,  766}, /* 00 (320x200,320x400,640x200,640x400) */
 	{1308, 1068,  781,  766}, /* 01 (320x350,640x350) */
 	{1308, 1068,  781,  766}, /* 02 (360x400,720x400) */
@@ -1453,7 +1453,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1400x1050Des_2[] = {
 	{   0, 1448,    0, 1051}  /* 08 (1400x1050x60Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1600x1200Des_1[] = {
+static struct SiS_LVDSData XGI_LVDS1600x1200Des_1[] = {
 	{0, 1664, 0, 1201}, /* 00 (320x200,320x400,640x200,640x400) */
 	{0, 1664, 0, 1201}, /* 01 (320x350,640x350) */
 	{0, 1664, 0, 1201}, /* 02 (360x400,720x400) */
@@ -1483,7 +1483,7 @@ static struct XGI330_LCDDataDesStruct2  XGI_LVDSNoScalingDesData[] = {
 };
 
 /* ; 1024x768 Full-screen */
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_1x75[] = {
+static struct SiS_LVDSData XGI_LVDS1024x768Des_1x75[] = {
 	{0, 1040, 0, 769}, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{0, 1040, 0, 769}, /* ; 01 (320x350,640x350) */
 	{0, 1040, 0, 769}, /* ; 02 (360x400,720x400) */
@@ -1494,7 +1494,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_1x75[] = {
 };
 
 /* ; 1024x768 center-screen (Enh. Mode) */
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_2x75[] = {
+static struct SiS_LVDSData XGI_LVDS1024x768Des_2x75[] = {
 	{1142,  856, 622, 587}, /* 00 (320x200,320x400,640x200,640x400) */
 	{1142,  856, 597, 562}, /* 01 (320x350,640x350) */
 	{1142,  856, 622, 587}, /* 02 (360x400,720x400) */
@@ -1505,7 +1505,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_2x75[] = {
 };
 
 /* ; 1024x768 center-screen (St.Mode) */
-static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_3x75[] =  {
+static struct SiS_LVDSData XGI_LVDS1024x768Des_3x75[] =  {
 	{320, 24, 622, 587}, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{320, 24, 597, 562}, /* ; 01 (320x350,640x350) */
 	{320, 24, 622, 587}, /* ; 02 (360x400,720x400) */
@@ -1513,7 +1513,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1024x768Des_3x75[] =  {
 	{320, 24, 722, 687}  /* ; 04 (640x480x60Hz) */
 };
 
-static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Des_1x75[] = {
+static struct SiS_LVDSData XGI_LVDS1280x1024Des_1x75[] = {
 	{0, 1296, 0, 1025}, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{0, 1296, 0, 1025}, /* ; 01 (320x350,640x350) */
 	{0, 1296, 0, 1025}, /* ; 02 (360x400,720x400) */
@@ -1526,7 +1526,7 @@ static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Des_1x75[] = {
 
 /* The Display setting for DE Mode Panel */
 /* [ycchen] 02/18/03 Set DE as default */
-static struct XGI330_LVDSDataStruct XGI_LVDS1280x1024Des_2x75[] = {
+static struct SiS_LVDSData XGI_LVDS1280x1024Des_2x75[] = {
 	{1368,  976, 752,  711}, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{1368,  976, 729,  688}, /* ; 01 (320x350,640x350) */
 	{1408,  976, 752,  711}, /* ; 02 (360x400,720x400) */
@@ -1554,7 +1554,7 @@ static struct XGI330_LCDDataDesStruct2 XGI_LVDSNoScalingDesDatax75[] = {
 	{0, 1328,   0,  771, 112, 6}  /* ; 0A (1280x768x75Hz) */
 };
 
-static struct XGI330_CHTVDataStruct  XGI_CHTVUNTSCData[] = {
+static struct SiS_LVDSData  XGI_CHTVUNTSCData[] = {
 	{ 840, 600,  840, 600},
 	{ 840, 600,  840, 600},
 	{ 840, 600,  840, 600},
@@ -1563,7 +1563,7 @@ static struct XGI330_CHTVDataStruct  XGI_CHTVUNTSCData[] = {
 	{1064, 750, 1064, 750}
 };
 
-static struct XGI330_CHTVDataStruct  XGI_CHTVONTSCData[] = {
+static struct SiS_LVDSData  XGI_CHTVONTSCData[] = {
 	{ 840, 525,  840, 525},
 	{ 840, 525,  840, 525},
 	{ 840, 525,  840, 525},
@@ -1572,7 +1572,7 @@ static struct XGI330_CHTVDataStruct  XGI_CHTVONTSCData[] = {
 	{1040, 700, 1040, 700}
 };
 
-static struct XGI330_CHTVDataStruct  XGI_CHTVUPALData[] = {
+static struct SiS_LVDSData  XGI_CHTVUPALData[] = {
 	{1008, 625, 1008, 625},
 	{1008, 625, 1008, 625},
 	{1008, 625, 1008, 625},
@@ -1581,7 +1581,7 @@ static struct XGI330_CHTVDataStruct  XGI_CHTVUPALData[] = {
 	{ 936, 836,  936, 836}
 };
 
-static struct XGI330_CHTVDataStruct  XGI_CHTVOPALData[] = {
+static struct SiS_LVDSData  XGI_CHTVOPALData[] = {
 	{1008, 625, 1008, 625},
 	{1008, 625, 1008, 625},
 	{1008, 625, 1008, 625},
@@ -2297,7 +2297,7 @@ static unsigned char XG27_SR41 = 0x00 ;
 
 static unsigned char Z11m_CR97 = 0x80 ;
 
-static struct XGI330_VCLKDataStruct XGI_VCLKData[] = {
+static struct SiS_VCLKData XGI_VCLKData[] = {
 	/* SR2B,SR2C,SR2D */
 	{0x1B, 0xE1,  25}, /* 00 (25.175MHz) */
 	{0x4E, 0xE4,  28}, /* 01 (28.322MHz) */
@@ -2390,7 +2390,7 @@ static struct XGI330_VCLKDataStruct XGI_VCLKData[] = {
 	{0xFF, 0x00,   0}  /* End mark */
 };
 
-static struct XGI330_VCLKDataStruct XGI_VBVCLKData[] = {
+static struct SiS_VCLKData XGI_VBVCLKData[] = {
 	{0x1B, 0xE1,  25}, /* 00 (25.175MHz) */
 	{0x4E, 0xE4,  28}, /* 01 (28.322MHz) */
 	{0x57, 0xE4,  31}, /* 02 (31.500MHz) */
-- 
1.7.3.4

