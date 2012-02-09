Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2BIUMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:12:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57237 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932107Ab2BIUMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:19 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19YT8IxtB1YS8+JoEKweW4hFgj1mll7ZePy1s9Gn6
	dDxwBsV4pWZnFI
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/7] staging/xgifb: Rename panel defines and remove duplicated defines
Date: Thu,  9 Feb 2012 21:11:44 +0100
Message-Id: <1328818309-5103-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
References: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the Panel* defines and their usage to the naming
convention of the sis initdef.h and removes the now duplicated defines.

Renames:
Panel320x480 -> Panel_320x480
Panel800x600 -> Panel_800x600
Panel1024x768 -> Panel_1024x768
Panel1024x768x75 -> Panel_1024x768x75
Panel1280x1024 -> Panel_1280x1024
Panel1280x1024x75 -> Panel_1280x1024x75
Panel1280x960 -> Panel_1280x960
Panel1400x1050 -> Panel_1400x1050
Panel1600x1200 -> Panel_1600x1200

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h     |   13 +--
 drivers/staging/xgifb/vb_setmode.c |   94 ++++++++++----------
 drivers/staging/xgifb/vb_table.h   |  168 ++++++++++++++++++------------------
 3 files changed, 134 insertions(+), 141 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 0472c86..9b2937c 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -19,18 +19,11 @@
 #define PanelRGB18Bit           0x0100
 #define PanelRGB24Bit           0x0000
 
-#define Panel320x480            0x07 /*fstn*/
+#define Panel_320x480            0x07 /*fstn*/
 /* [ycchen] 02/12/03 Modify for Multi-Sync. LCD Support */
 #define PanelResInfo            0x1F /* CR36 Panel Type/LCDResInfo */
-#define Panel800x600            0x01
-#define Panel1024x768           0x02
-#define Panel1024x768x75        0x22
-#define Panel1280x1024          0x03
-#define Panel1280x1024x75       0x23
-#define Panel640x480            0x04
-#define Panel1280x960           0x07
-#define Panel1400x1050          0x09
-#define Panel1600x1200          0x0B
+#define Panel_1024x768x75        0x22
+#define Panel_1280x1024x75       0x23
 
 #define PanelRef60Hz            0x00
 #define PanelRef75Hz            0x20
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index fad144c..25c647b 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -359,8 +359,8 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
 			tempax |= SupportLCD;
 
-			if (pVBInfo->LCDResInfo != Panel1280x1024) {
-				if (pVBInfo->LCDResInfo != Panel1280x960) {
+			if (pVBInfo->LCDResInfo != Panel_1280x1024) {
+				if (pVBInfo->LCDResInfo != Panel_1280x960) {
 					if (pVBInfo->LCDInfo &
 					    LCDNonExpanding) {
 						if (resinfo >= 9) {
@@ -436,7 +436,7 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 			if (resinfo > 0x08)
 				return 0; /* 1024x768 */
 
-			if (pVBInfo->LCDResInfo < Panel1024x768) {
+			if (pVBInfo->LCDResInfo < Panel_1024x768) {
 				if (resinfo > 0x07)
 					return 0; /* 800x600 */
 
@@ -1267,7 +1267,7 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 	if (pVBInfo->IF_DEF_LVDS == 0) {
 		CRT2Index = CRT2Index >> 6; /*  for LCD */
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) { /*301b*/
-			if (pVBInfo->LCDResInfo != Panel1024x768)
+			if (pVBInfo->LCDResInfo != Panel_1024x768)
 				VCLKIndex = LCDXlat2VCLK[CRT2Index];
 			else
 				VCLKIndex = LCDXlat1VCLK[CRT2Index];
@@ -1329,11 +1329,11 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			VCLKIndex = CRT2Index;
 
 		VCLKIndex = VCLKIndex >> 6;
-		if ((pVBInfo->LCDResInfo == Panel800x600) ||
-		    (pVBInfo->LCDResInfo == Panel320x480))
+		if ((pVBInfo->LCDResInfo == Panel_800x600) ||
+		    (pVBInfo->LCDResInfo == Panel_320x480))
 			VCLKIndex = LVDSXlat1VCLK[VCLKIndex];
-		else if ((pVBInfo->LCDResInfo == Panel1024x768) ||
-			 (pVBInfo->LCDResInfo == Panel1024x768x75))
+		else if ((pVBInfo->LCDResInfo == Panel_1024x768) ||
+			 (pVBInfo->LCDResInfo == Panel_1024x768x75))
 			VCLKIndex = LVDSXlat2VCLK[VCLKIndex];
 		else
 			VCLKIndex = LVDSXlat3VCLK[VCLKIndex];
@@ -2377,15 +2377,15 @@ static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
 		if (!(pVBInfo->LCDInfo & (SetLCDtoNonExpanding
 				| EnableScalingLCD))) {
-			if ((pVBInfo->LCDResInfo == Panel1024x768) ||
-			    (pVBInfo->LCDResInfo == Panel1024x768x75)) {
+			if ((pVBInfo->LCDResInfo == Panel_1024x768) ||
+			    (pVBInfo->LCDResInfo == Panel_1024x768x75)) {
 				pVBInfo->HDE = 1024;
 				pVBInfo->VDE = 768;
-			} else if ((pVBInfo->LCDResInfo == Panel1280x1024) ||
-				   (pVBInfo->LCDResInfo == Panel1280x1024x75)) {
+			} else if ((pVBInfo->LCDResInfo == Panel_1280x1024) ||
+				   (pVBInfo->LCDResInfo == Panel_1280x1024x75)) {
 				pVBInfo->HDE = 1280;
 				pVBInfo->VDE = 1024;
-			} else if (pVBInfo->LCDResInfo == Panel1400x1050) {
+			} else if (pVBInfo->LCDResInfo == Panel_1400x1050) {
 				pVBInfo->HDE = 1400;
 				pVBInfo->VDE = 1050;
 			} else {
@@ -2496,7 +2496,7 @@ static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo)
 	}
 
 	if (tempbl == 0xFF) {
-		pVBInfo->LCDResInfo = Panel1024x768;
+		pVBInfo->LCDResInfo = Panel_1024x768;
 		pVBInfo->LCDTypeInfo = 0;
 		i = 0;
 	}
@@ -2556,15 +2556,15 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	push2 = tempax;
 
 	/* GetLCDResInfo */
-	if ((pVBInfo->LCDResInfo == Panel1024x768) ||
-	    (pVBInfo->LCDResInfo == Panel1024x768x75)) {
+	if ((pVBInfo->LCDResInfo == Panel_1024x768) ||
+	    (pVBInfo->LCDResInfo == Panel_1024x768x75)) {
 		tempax = 1024;
 		tempbx = 768;
-	} else if ((pVBInfo->LCDResInfo == Panel1280x1024) ||
-		   (pVBInfo->LCDResInfo == Panel1280x1024x75)) {
+	} else if ((pVBInfo->LCDResInfo == Panel_1280x1024) ||
+		   (pVBInfo->LCDResInfo == Panel_1280x1024x75)) {
 		tempax = 1280;
 		tempbx = 1024;
-	} else if (pVBInfo->LCDResInfo == Panel1400x1050) {
+	} else if (pVBInfo->LCDResInfo == Panel_1400x1050) {
 		tempax = 1400;
 		tempbx = 1050;
 	} else {
@@ -2768,7 +2768,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp1 = temp1 / push3;
 	tempbx = (unsigned short) (temp1 & 0xffff);
 
-	if (pVBInfo->LCDResInfo == Panel1024x768)
+	if (pVBInfo->LCDResInfo == Panel_1024x768)
 		tempbx -= 1;
 
 	tempax = ((tempbx >> 8) & 0xff) << 3;
@@ -3386,10 +3386,10 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 	tempbx = temp & 0x0F;
 
 	if (tempbx == 0)
-		tempbx = Panel1024x768; /* default */
+		tempbx = Panel_1024x768; /* default */
 
 	/* LCD75 [2003/8/22] Vicent */
-	if ((tempbx == Panel1024x768) || (tempbx == Panel1280x1024)) {
+	if ((tempbx == Panel_1024x768) || (tempbx == Panel_1280x1024)) {
 		if (pVBInfo->VBInfo & DriverMode) {
 			tempax = xgifb_reg_get(pVBInfo->P3d4, 0x33);
 			if (pVBInfo->VBInfo & SetCRT2ToLCDA)
@@ -3434,10 +3434,10 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 	}
 
 	if (pVBInfo->IF_DEF_LVDS == 0) {
-		if ((pVBInfo->LCDResInfo == Panel1400x1050) && (pVBInfo->VBInfo
+		if ((pVBInfo->LCDResInfo == Panel_1400x1050) && (pVBInfo->VBInfo
 				& SetCRT2ToLCD) && (ModeNo > 0x13) && (resinfo
 				== 9) && (!(tempbx & EnableScalingLCD)))
-			/* set to center in 1280x1024 LCDB for Panel1400x1050 */
+			/* set to center in 1280x1024 LCDB for Panel_1400x1050 */
 			tempbx |= SetLCDtoNonExpanding;
 	}
 
@@ -3448,7 +3448,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 			} else {
 				if (ModeNo > 0x13) {
 					if (pVBInfo->LCDResInfo
-							== Panel1024x768) {
+							== Panel_1024x768) {
 						if (resinfo == 4) {/* 512x384 */
 							tempbx |= EnableLVDSDDA;
 						}
@@ -3801,14 +3801,14 @@ static void XGI_GetCRT2ResInfo(unsigned short ModeNo,
 
 	if (pVBInfo->VBInfo & SetCRT2ToLCD) {
 		if (pVBInfo->IF_DEF_LVDS == 0) {
-			if (pVBInfo->LCDResInfo == Panel1600x1200) {
+			if (pVBInfo->LCDResInfo == Panel_1600x1200) {
 				if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
 					if (yres == 1024)
 						yres = 1056;
 				}
 			}
 
-			if (pVBInfo->LCDResInfo == Panel1280x1024) {
+			if (pVBInfo->LCDResInfo == Panel_1280x1024) {
 				if (yres == 400)
 					yres = 405;
 				else if (yres == 350)
@@ -3820,7 +3820,7 @@ static void XGI_GetCRT2ResInfo(unsigned short ModeNo,
 				}
 			}
 
-			if (pVBInfo->LCDResInfo == Panel1024x768) {
+			if (pVBInfo->LCDResInfo == Panel_1024x768) {
 				if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
 					if (!(pVBInfo->LCDInfo
 							& LCDNonExpanding)) {
@@ -3954,7 +3954,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 		pVBInfo->HT = LCDPtr->LCDHT;
 		pVBInfo->VT = LCDPtr->LCDVT;
 
-		if (pVBInfo->LCDResInfo == Panel1024x768) {
+		if (pVBInfo->LCDResInfo == Panel_1024x768) {
 			tempax = 1024;
 			tempbx = 768;
 
@@ -3971,10 +3971,10 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 					tempbx = 768;
 			} else
 				tempbx = 768;
-		} else if (pVBInfo->LCDResInfo == Panel1024x768x75) {
+		} else if (pVBInfo->LCDResInfo == Panel_1024x768x75) {
 			tempax = 1024;
 			tempbx = 768;
-		} else if (pVBInfo->LCDResInfo == Panel1280x1024) {
+		} else if (pVBInfo->LCDResInfo == Panel_1280x1024) {
 			tempax = 1280;
 			if (pVBInfo->VGAVDE == 360)
 				tempbx = 768;
@@ -3984,10 +3984,10 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 				tempbx = 864;
 			else
 				tempbx = 1024;
-		} else if (pVBInfo->LCDResInfo == Panel1280x1024x75) {
+		} else if (pVBInfo->LCDResInfo == Panel_1280x1024x75) {
 			tempax = 1280;
 			tempbx = 1024;
-		} else if (pVBInfo->LCDResInfo == Panel1280x960) {
+		} else if (pVBInfo->LCDResInfo == Panel_1280x960) {
 			tempax = 1280;
 			if (pVBInfo->VGAVDE == 350)
 				tempbx = 700;
@@ -3997,7 +3997,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 				tempbx = 960;
 			else
 				tempbx = 960;
-		} else if (pVBInfo->LCDResInfo == Panel1400x1050) {
+		} else if (pVBInfo->LCDResInfo == Panel_1400x1050) {
 			tempax = 1400;
 			tempbx = 1050;
 
@@ -4005,7 +4005,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 				tempax = 1280;
 				tempbx = 1024;
 			}
-		} else if (pVBInfo->LCDResInfo == Panel1600x1200) {
+		} else if (pVBInfo->LCDResInfo == Panel_1600x1200) {
 			tempax = 1600;
 			tempbx = 1200; /* alan 10/14/2003 */
 			if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
@@ -4513,19 +4513,19 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			}
 		} else if (!(modeflag & HalfDCLK)) {
 			temp -= 4;
-			if (pVBInfo->LCDResInfo != Panel1280x960 &&
+			if (pVBInfo->LCDResInfo != Panel_1280x960 &&
 			    pVBInfo->VGAHDE >= 800) {
 				temp -= 7;
 				if (pVBInfo->ModeType == ModeEGA &&
 				    pVBInfo->VGAVDE == 1024) {
 					temp += 15;
 					if (pVBInfo->LCDResInfo !=
-						Panel1280x1024)
+						Panel_1280x1024)
 						temp += 7;
 				}
 
 				if (pVBInfo->VGAHDE >= 1280 &&
-				    pVBInfo->LCDResInfo != Panel1280x960 &&
+				    pVBInfo->LCDResInfo != Panel_1280x960 &&
 				    (pVBInfo->LCDInfo & LCDNonExpanding))
 					temp += 28;
 			}
@@ -4619,7 +4619,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	push2 = tempbx;
 
 	if (pVBInfo->VBInfo & SetCRT2ToLCD) {
-		if (pVBInfo->LCDResInfo == Panel1024x768) {
+		if (pVBInfo->LCDResInfo == Panel_1024x768) {
 			if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
 				if (tempbx == 350)
 					tempbx += 5;
@@ -5267,7 +5267,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x2B, 0x0F, temp);
 	temp = 0x01;
 
-	if (pVBInfo->LCDResInfo == Panel1280x1024) {
+	if (pVBInfo->LCDResInfo == Panel_1280x1024) {
 		if (pVBInfo->ModeType == ModeEGA) {
 			if (pVBInfo->VGAHDE >= 1024) {
 				temp = 0x02;
@@ -5305,14 +5305,14 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempah = pVBInfo->LCDResInfo;
 	tempah &= PanelResInfo;
 
-	if ((tempah == Panel1024x768) || (tempah == Panel1024x768x75)) {
+	if ((tempah == Panel_1024x768) || (tempah == Panel_1024x768x75)) {
 		tempbx = 1024;
 		tempcx = 768;
-	} else if ((tempah == Panel1280x1024) ||
-		   (tempah == Panel1280x1024x75)) {
+	} else if ((tempah == Panel_1280x1024) ||
+		   (tempah == Panel_1280x1024x75)) {
 		tempbx = 1280;
 		tempcx = 1024;
-	} else if (tempah == Panel1400x1050) {
+	} else if (tempah == Panel_1400x1050) {
 		tempbx = 1400;
 		tempcx = 1050;
 	} else {
@@ -6807,11 +6807,11 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 				tempah |= 0x40;
 		}
 
-		if ((pVBInfo->LCDResInfo == Panel1280x1024)
-				|| (pVBInfo->LCDResInfo == Panel1280x1024x75))
+		if ((pVBInfo->LCDResInfo == Panel_1280x1024)
+				|| (pVBInfo->LCDResInfo == Panel_1280x1024x75))
 			tempah |= 0x80;
 
-		if (pVBInfo->LCDResInfo == Panel1280x960)
+		if (pVBInfo->LCDResInfo == Panel_1280x960)
 			tempah |= 0x80;
 
 		xgifb_reg_set(pVBInfo->Part4Port, 0x0C, tempah);
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 217fb87..c587d41 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -2353,109 +2353,109 @@ static struct XGI_LVDSCRT1VDataStruct XGI_LVDSCRT11280x1024_2_Vx75[] = {
 
 /*add for new UNIVGABIOS*/
 static struct XGI330_LCDDataTablStruct XGI_LCDDataTable[] = {
-	{Panel1024x768, 0x0019, 0x0001, 0}, /* XGI_ExtLCD1024x768Data */
-	{Panel1024x768, 0x0019, 0x0000, 1}, /* XGI_StLCD1024x768Data */
-	{Panel1024x768, 0x0018, 0x0010, 2}, /* XGI_CetLCD1024x768Data */
-	{Panel1280x1024, 0x0019, 0x0001, 3}, /* XGI_ExtLCD1280x1024Data */
-	{Panel1280x1024, 0x0019, 0x0000, 4}, /* XGI_StLCD1280x1024Data */
-	{Panel1280x1024, 0x0018, 0x0010, 5}, /* XGI_CetLCD1280x1024Data */
-	{Panel1400x1050, 0x0019, 0x0001, 6}, /* XGI_ExtLCD1400x1050Data */
-	{Panel1400x1050, 0x0019, 0x0000, 7}, /* XGI_StLCD1400x1050Data */
-	{Panel1400x1050, 0x0018, 0x0010, 8}, /* XGI_CetLCD1400x1050Data */
-	{Panel1600x1200, 0x0019, 0x0001, 9}, /* XGI_ExtLCD1600x1200Data */
-	{Panel1600x1200, 0x0019, 0x0000, 10}, /* XGI_StLCD1600x1200Data */
+	{Panel_1024x768, 0x0019, 0x0001, 0}, /* XGI_ExtLCD1024x768Data */
+	{Panel_1024x768, 0x0019, 0x0000, 1}, /* XGI_StLCD1024x768Data */
+	{Panel_1024x768, 0x0018, 0x0010, 2}, /* XGI_CetLCD1024x768Data */
+	{Panel_1280x1024, 0x0019, 0x0001, 3}, /* XGI_ExtLCD1280x1024Data */
+	{Panel_1280x1024, 0x0019, 0x0000, 4}, /* XGI_StLCD1280x1024Data */
+	{Panel_1280x1024, 0x0018, 0x0010, 5}, /* XGI_CetLCD1280x1024Data */
+	{Panel_1400x1050, 0x0019, 0x0001, 6}, /* XGI_ExtLCD1400x1050Data */
+	{Panel_1400x1050, 0x0019, 0x0000, 7}, /* XGI_StLCD1400x1050Data */
+	{Panel_1400x1050, 0x0018, 0x0010, 8}, /* XGI_CetLCD1400x1050Data */
+	{Panel_1600x1200, 0x0019, 0x0001, 9}, /* XGI_ExtLCD1600x1200Data */
+	{Panel_1600x1200, 0x0019, 0x0000, 10}, /* XGI_StLCD1600x1200Data */
 	{PanelRef60Hz, 0x0008, 0x0008, 11}, /* XGI_NoScalingData */
-	{Panel1024x768x75, 0x0019, 0x0001, 12}, /* XGI_ExtLCD1024x768x75Data */
-	{Panel1024x768x75, 0x0019, 0x0000, 13}, /* XGI_StLCD1024x768x75Data */
-	{Panel1024x768x75, 0x0018, 0x0010, 14}, /* XGI_CetLCD1024x768x75Data */
-	{Panel1280x1024x75, 0x0019, 0x0001, 15}, /* XGI_ExtLCD1280x1024x75Data*/
-	{Panel1280x1024x75, 0x0019, 0x0000, 16}, /* XGI_StLCD1280x1024x75Data */
-	{Panel1280x1024x75, 0x0018, 0x0010, 17}, /* XGI_CetLCD1280x1024x75Data*/
+	{Panel_1024x768x75, 0x0019, 0x0001, 12}, /* XGI_ExtLCD1024x768x75Data */
+	{Panel_1024x768x75, 0x0019, 0x0000, 13}, /* XGI_StLCD1024x768x75Data */
+	{Panel_1024x768x75, 0x0018, 0x0010, 14}, /* XGI_CetLCD1024x768x75Data */
+	{Panel_1280x1024x75, 0x0019, 0x0001, 15}, /* XGI_ExtLCD1280x1024x75Data*/
+	{Panel_1280x1024x75, 0x0019, 0x0000, 16}, /* XGI_StLCD1280x1024x75Data */
+	{Panel_1280x1024x75, 0x0018, 0x0010, 17}, /* XGI_CetLCD1280x1024x75Data*/
 	{PanelRef75Hz, 0x0008, 0x0008, 18}, /* XGI_NoScalingDatax75 */
 	{0xFF, 0x0000, 0x0000, 0} /* End of table */
 };
 
 static struct XGI330_LCDDataTablStruct XGI_LCDDesDataTable[] = {
-	{Panel1024x768, 0x0019, 0x0001, 0}, /* XGI_ExtLCDDes1024x768Data */
-	{Panel1024x768, 0x0019, 0x0000, 1}, /* XGI_StLCDDes1024x768Data */
-	{Panel1024x768, 0x0018, 0x0010, 2}, /* XGI_CetLCDDes1024x768Data */
-	{Panel1280x1024, 0x0019, 0x0001, 3}, /* XGI_ExtLCDDes1280x1024Data */
-	{Panel1280x1024, 0x0019, 0x0000, 4}, /* XGI_StLCDDes1280x1024Data */
-	{Panel1280x1024, 0x0018, 0x0010, 5}, /* XGI_CetLCDDes1280x1024Data */
-	{Panel1400x1050, 0x0019, 0x0001, 6}, /* XGI_ExtLCDDes1400x1050Data */
-	{Panel1400x1050, 0x0019, 0x0000, 7}, /* XGI_StLCDDes1400x1050Data */
-	{Panel1400x1050, 0x0418, 0x0010, 8}, /* XGI_CetLCDDes1400x1050Data */
-	{Panel1400x1050, 0x0418, 0x0410, 9}, /* XGI_CetLCDDes1400x1050Data2 */
-	{Panel1600x1200, 0x0019, 0x0001, 10}, /* XGI_ExtLCDDes1600x1200Data */
-	{Panel1600x1200, 0x0019, 0x0000, 11}, /* XGI_StLCDDes1600x1200Data */
+	{Panel_1024x768, 0x0019, 0x0001, 0}, /* XGI_ExtLCDDes1024x768Data */
+	{Panel_1024x768, 0x0019, 0x0000, 1}, /* XGI_StLCDDes1024x768Data */
+	{Panel_1024x768, 0x0018, 0x0010, 2}, /* XGI_CetLCDDes1024x768Data */
+	{Panel_1280x1024, 0x0019, 0x0001, 3}, /* XGI_ExtLCDDes1280x1024Data */
+	{Panel_1280x1024, 0x0019, 0x0000, 4}, /* XGI_StLCDDes1280x1024Data */
+	{Panel_1280x1024, 0x0018, 0x0010, 5}, /* XGI_CetLCDDes1280x1024Data */
+	{Panel_1400x1050, 0x0019, 0x0001, 6}, /* XGI_ExtLCDDes1400x1050Data */
+	{Panel_1400x1050, 0x0019, 0x0000, 7}, /* XGI_StLCDDes1400x1050Data */
+	{Panel_1400x1050, 0x0418, 0x0010, 8}, /* XGI_CetLCDDes1400x1050Data */
+	{Panel_1400x1050, 0x0418, 0x0410, 9}, /* XGI_CetLCDDes1400x1050Data2 */
+	{Panel_1600x1200, 0x0019, 0x0001, 10}, /* XGI_ExtLCDDes1600x1200Data */
+	{Panel_1600x1200, 0x0019, 0x0000, 11}, /* XGI_StLCDDes1600x1200Data */
 	{PanelRef60Hz, 0x0008, 0x0008, 12}, /* XGI_NoScalingDesData */
-	{Panel1024x768x75, 0x0019, 0x0001, 13}, /*XGI_ExtLCDDes1024x768x75Data*/
-	{Panel1024x768x75, 0x0019, 0x0000, 14}, /* XGI_StLCDDes1024x768x75Data*/
-	{Panel1024x768x75, 0x0018, 0x0010, 15}, /*XGI_CetLCDDes1024x768x75Data*/
+	{Panel_1024x768x75, 0x0019, 0x0001, 13}, /*XGI_ExtLCDDes1024x768x75Data*/
+	{Panel_1024x768x75, 0x0019, 0x0000, 14}, /* XGI_StLCDDes1024x768x75Data*/
+	{Panel_1024x768x75, 0x0018, 0x0010, 15}, /*XGI_CetLCDDes1024x768x75Data*/
 	/* XGI_ExtLCDDes1280x1024x75Data */
-	{Panel1280x1024x75, 0x0019, 0x0001, 16},
+	{Panel_1280x1024x75, 0x0019, 0x0001, 16},
 	/* XGI_StLCDDes1280x1024x75Data */
-	{Panel1280x1024x75, 0x0019, 0x0000, 17},
+	{Panel_1280x1024x75, 0x0019, 0x0000, 17},
 	/* XGI_CetLCDDes1280x1024x75Data */
-	{Panel1280x1024x75, 0x0018, 0x0010, 18},
+	{Panel_1280x1024x75, 0x0018, 0x0010, 18},
 	{PanelRef75Hz, 0x0008, 0x0008, 19}, /* XGI_NoScalingDesDatax75 */
 	{0xFF, 0x0000, 0x0000, 0}
 };
 
 static struct XGI330_LCDDataTablStruct xgifb_epllcd_crt1[] = {
-	{Panel1024x768, 0x0018, 0x0000, 0}, /* XGI_LVDSCRT11024x768_1 */
-	{Panel1024x768, 0x0018, 0x0010, 1}, /* XGI_LVDSCRT11024x768_2 */
-	{Panel1280x1024, 0x0018, 0x0000, 2}, /* XGI_LVDSCRT11280x1024_1 */
-	{Panel1280x1024, 0x0018, 0x0010, 3}, /* XGI_LVDSCRT11280x1024_2 */
-	{Panel1400x1050, 0x0018, 0x0000, 4}, /* XGI_LVDSCRT11400x1050_1 */
-	{Panel1400x1050, 0x0018, 0x0010, 5}, /* XGI_LVDSCRT11400x1050_2 */
-	{Panel1600x1200, 0x0018, 0x0000, 6}, /* XGI_LVDSCRT11600x1200_1 */
-	{Panel1024x768x75, 0x0018, 0x0000, 7}, /* XGI_LVDSCRT11024x768_1x75 */
-	{Panel1024x768x75, 0x0018, 0x0010, 8}, /* XGI_LVDSCRT11024x768_2x75 */
-	{Panel1280x1024x75, 0x0018, 0x0000, 9}, /*XGI_LVDSCRT11280x1024_1x75*/
-	{Panel1280x1024x75, 0x0018, 0x0010, 10},/*XGI_LVDSCRT11280x1024_2x75*/
+	{Panel_1024x768, 0x0018, 0x0000, 0}, /* XGI_LVDSCRT11024x768_1 */
+	{Panel_1024x768, 0x0018, 0x0010, 1}, /* XGI_LVDSCRT11024x768_2 */
+	{Panel_1280x1024, 0x0018, 0x0000, 2}, /* XGI_LVDSCRT11280x1024_1 */
+	{Panel_1280x1024, 0x0018, 0x0010, 3}, /* XGI_LVDSCRT11280x1024_2 */
+	{Panel_1400x1050, 0x0018, 0x0000, 4}, /* XGI_LVDSCRT11400x1050_1 */
+	{Panel_1400x1050, 0x0018, 0x0010, 5}, /* XGI_LVDSCRT11400x1050_2 */
+	{Panel_1600x1200, 0x0018, 0x0000, 6}, /* XGI_LVDSCRT11600x1200_1 */
+	{Panel_1024x768x75, 0x0018, 0x0000, 7}, /* XGI_LVDSCRT11024x768_1x75 */
+	{Panel_1024x768x75, 0x0018, 0x0010, 8}, /* XGI_LVDSCRT11024x768_2x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0000, 9}, /*XGI_LVDSCRT11280x1024_1x75*/
+	{Panel_1280x1024x75, 0x0018, 0x0010, 10},/*XGI_LVDSCRT11280x1024_2x75*/
 	{0xFF, 0x0000, 0x0000, 0}
 };
 
 static struct XGI330_LCDDataTablStruct XGI_EPLLCDDataPtr[] = {
-	{Panel1024x768, 0x0018, 0x0000, 0}, /* XGI_LVDS1024x768Data_1 */
-	{Panel1024x768, 0x0018, 0x0010, 1}, /* XGI_LVDS1024x768Data_2 */
-	{Panel1280x1024, 0x0018, 0x0000, 2}, /* XGI_LVDS1280x1024Data_1 */
-	{Panel1280x1024, 0x0018, 0x0010, 3}, /* XGI_LVDS1280x1024Data_2 */
-	{Panel1400x1050, 0x0018, 0x0000, 4}, /* XGI_LVDS1400x1050Data_1 */
-	{Panel1400x1050, 0x0018, 0x0010, 5}, /* XGI_LVDS1400x1050Data_2 */
-	{Panel1600x1200, 0x0018, 0x0000, 6}, /* XGI_LVDS1600x1200Data_1 */
+	{Panel_1024x768, 0x0018, 0x0000, 0}, /* XGI_LVDS1024x768Data_1 */
+	{Panel_1024x768, 0x0018, 0x0010, 1}, /* XGI_LVDS1024x768Data_2 */
+	{Panel_1280x1024, 0x0018, 0x0000, 2}, /* XGI_LVDS1280x1024Data_1 */
+	{Panel_1280x1024, 0x0018, 0x0010, 3}, /* XGI_LVDS1280x1024Data_2 */
+	{Panel_1400x1050, 0x0018, 0x0000, 4}, /* XGI_LVDS1400x1050Data_1 */
+	{Panel_1400x1050, 0x0018, 0x0010, 5}, /* XGI_LVDS1400x1050Data_2 */
+	{Panel_1600x1200, 0x0018, 0x0000, 6}, /* XGI_LVDS1600x1200Data_1 */
 	{PanelRef60Hz, 0x0008, 0x0008, 7}, /* XGI_LVDSNoScalingData */
-	{Panel1024x768x75, 0x0018, 0x0000, 8}, /* XGI_LVDS1024x768Data_1x75 */
-	{Panel1024x768x75, 0x0018, 0x0010, 9}, /* XGI_LVDS1024x768Data_2x75 */
-	{Panel1280x1024x75, 0x0018, 0x0000, 10}, /* XGI_LVDS1280x1024Data_1x75*/
-	{Panel1280x1024x75, 0x0018, 0x0010, 11},  /*XGI_LVDS1280x1024Data_2x75*/
+	{Panel_1024x768x75, 0x0018, 0x0000, 8}, /* XGI_LVDS1024x768Data_1x75 */
+	{Panel_1024x768x75, 0x0018, 0x0010, 9}, /* XGI_LVDS1024x768Data_2x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0000, 10}, /* XGI_LVDS1280x1024Data_1x75*/
+	{Panel_1280x1024x75, 0x0018, 0x0010, 11},  /*XGI_LVDS1280x1024Data_2x75*/
 	{PanelRef75Hz, 0x0008, 0x0008, 12}, /* XGI_LVDSNoScalingDatax75 */
 	{0xFF, 0x0000, 0x0000, 0}
 };
 
 static struct XGI330_LCDDataTablStruct XGI_EPLLCDDesDataPtr[] = {
-	{Panel1024x768, 0x0018, 0x0000, 0}, /* XGI_LVDS1024x768Des_1 */
-	{Panel1024x768, 0x0618, 0x0410, 1}, /* XGI_LVDS1024x768Des_3 */
-	{Panel1024x768, 0x0018, 0x0010, 2}, /* XGI_LVDS1024x768Des_2 */
-	{Panel1280x1024, 0x0018, 0x0000, 3}, /* XGI_LVDS1280x1024Des_1 */
-	{Panel1280x1024, 0x0018, 0x0010, 4}, /* XGI_LVDS1280x1024Des_2 */
-	{Panel1400x1050, 0x0018, 0x0000, 5}, /* XGI_LVDS1400x1050Des_1 */
-	{Panel1400x1050, 0x0018, 0x0010, 6}, /* XGI_LVDS1400x1050Des_2 */
-	{Panel1600x1200, 0x0018, 0x0000, 7}, /* XGI_LVDS1600x1200Des_1 */
+	{Panel_1024x768, 0x0018, 0x0000, 0}, /* XGI_LVDS1024x768Des_1 */
+	{Panel_1024x768, 0x0618, 0x0410, 1}, /* XGI_LVDS1024x768Des_3 */
+	{Panel_1024x768, 0x0018, 0x0010, 2}, /* XGI_LVDS1024x768Des_2 */
+	{Panel_1280x1024, 0x0018, 0x0000, 3}, /* XGI_LVDS1280x1024Des_1 */
+	{Panel_1280x1024, 0x0018, 0x0010, 4}, /* XGI_LVDS1280x1024Des_2 */
+	{Panel_1400x1050, 0x0018, 0x0000, 5}, /* XGI_LVDS1400x1050Des_1 */
+	{Panel_1400x1050, 0x0018, 0x0010, 6}, /* XGI_LVDS1400x1050Des_2 */
+	{Panel_1600x1200, 0x0018, 0x0000, 7}, /* XGI_LVDS1600x1200Des_1 */
 	{PanelRef60Hz, 0x0008, 0x0008, 8},  /* XGI_LVDSNoScalingDesData */
-	{Panel1024x768x75, 0x0018, 0x0000, 9}, /* XGI_LVDS1024x768Des_1x75 */
-	{Panel1024x768x75, 0x0618, 0x0410, 10}, /* XGI_LVDS1024x768Des_3x75 */
-	{Panel1024x768x75, 0x0018, 0x0010, 11}, /* XGI_LVDS1024x768Des_2x75 */
-	{Panel1280x1024x75, 0x0018, 0x0000, 12}, /* XGI_LVDS1280x1024Des_1x75 */
-	{Panel1280x1024x75, 0x0018, 0x0010, 13}, /* XGI_LVDS1280x1024Des_2x75 */
+	{Panel_1024x768x75, 0x0018, 0x0000, 9}, /* XGI_LVDS1024x768Des_1x75 */
+	{Panel_1024x768x75, 0x0618, 0x0410, 10}, /* XGI_LVDS1024x768Des_3x75 */
+	{Panel_1024x768x75, 0x0018, 0x0010, 11}, /* XGI_LVDS1024x768Des_2x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0000, 12}, /* XGI_LVDS1280x1024Des_1x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0010, 13}, /* XGI_LVDS1280x1024Des_2x75 */
 	{PanelRef75Hz, 0x0008, 0x0008, 14}, /* XGI_LVDSNoScalingDesDatax75 */
 	{0xFF, 0x0000, 0x0000, 0}
 };
 
 static struct XGI330_LCDDataTablStruct XGI_EPLCHLCDRegPtr[] = {
-	{Panel1024x768, 0x0000, 0x0000, 0}, /* XGI_CH7017LV1024x768 */
-	{Panel1400x1050, 0x0000, 0x0000, 1}, /* XGI_CH7017LV1400x1050 */
+	{Panel_1024x768, 0x0000, 0x0000, 0}, /* XGI_CH7017LV1024x768 */
+	{Panel_1400x1050, 0x0000, 0x0000, 1}, /* XGI_CH7017LV1400x1050 */
 	{0xFF, 0x0000, 0x0000, 0}
 };
 
@@ -2501,30 +2501,30 @@ static unsigned short LCDLenList[] = {
 /* Dual link only */
 static struct XGI330_LCDCapStruct  XGI_LCDDLCapList[] = {
 /* LCDCap1024x768 */
-	{Panel1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
+	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024 */
-	{Panel1280x1024, LCDDualLink+DefaultLCDCap, StLCDBToA,
+	{Panel_1280x1024, LCDDualLink+DefaultLCDCap, StLCDBToA,
 	0x012, 0x70, 0x03, VCLK108_2,
 	0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1400x1050 */
-	{Panel1400x1050, LCDDualLink+DefaultLCDCap, StLCDBToA,
+	{Panel_1400x1050, LCDDualLink+DefaultLCDCap, StLCDBToA,
 	0x012, 0x70, 0x03, VCLK108_2,
 	 0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1600x1200 */
-	{Panel1600x1200, LCDDualLink+DefaultLCDCap, LCDToFull,
+	{Panel_1600x1200, LCDDualLink+DefaultLCDCap, LCDToFull,
 	0x012, 0xC0, 0x03, VCLK162,
 	 0x43, 0x22, 0x70, 0x24, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1024x768x75 */
-	{Panel1024x768x75, DefaultLCDCap, 0, 0x012, 0x60, 0, VCLK78_75,
+	{Panel_1024x768x75, DefaultLCDCap, 0, 0x012, 0x60, 0, VCLK78_75,
 	 0x2B, 0x61, 0x2B, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024x75 */
-	{Panel1280x1024x75, LCDDualLink+DefaultLCDCap, StLCDBToA,
+	{Panel_1280x1024x75, LCDDualLink+DefaultLCDCap, StLCDBToA,
 	0x012, 0x90, 0x03, VCLK135_5,
 	 0x54, 0x42, 0x4A, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
@@ -2536,30 +2536,30 @@ static struct XGI330_LCDCapStruct  XGI_LCDDLCapList[] = {
 
 static struct XGI330_LCDCapStruct  XGI_LCDCapList[] = {
 /* LCDCap1024x768 */
-	{Panel1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
+	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024 */
-	{Panel1280x1024, DefaultLCDCap, StLCDBToA,
+	{Panel_1280x1024, DefaultLCDCap, StLCDBToA,
 	0x012, 0x70, 0x03, VCLK108_2,
 	0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1400x1050 */
-	{Panel1400x1050, DefaultLCDCap, StLCDBToA,
+	{Panel_1400x1050, DefaultLCDCap, StLCDBToA,
 	0x012, 0x70, 0x03, VCLK108_2,
 	 0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1600x1200 */
-	{Panel1600x1200, DefaultLCDCap, LCDToFull,
+	{Panel_1600x1200, DefaultLCDCap, LCDToFull,
 	0x012, 0xC0, 0x03, VCLK162,
 	 0x5A, 0x23, 0x5A, 0x23, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1024x768x75 */
-	{Panel1024x768x75, DefaultLCDCap, 0, 0x012, 0x60, 0, VCLK78_75,
+	{Panel_1024x768x75, DefaultLCDCap, 0, 0x012, 0x60, 0, VCLK78_75,
 	 0x2B, 0x61, 0x2B, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024x75 */
-	{Panel1280x1024x75, DefaultLCDCap, StLCDBToA,
+	{Panel_1280x1024x75, DefaultLCDCap, StLCDBToA,
 	0x012, 0x90, 0x03, VCLK135_5,
 	 0x54, 0x42, 0x4A, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
-- 
1.7.3.4

