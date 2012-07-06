Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200Ab2GFKmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:42:14 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:58350 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964811Ab2GFKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCKNIR5gRIDlTeQA4Jh
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130717"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 18/19 v2] Staging: xgifb: Fix coding style.
Date: Fri,  6 Jul 2012 12:40:53 +0200
Message-Id: <88bb3909f0b5c6c01602de4f8d420cd3c22252ef.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
 <cover.1341569486.git.magomez@igalia.com>
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341569486.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix small coding style warnings in several files.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    3 +-
 drivers/staging/xgifb/vb_init.c     |    3 +-
 drivers/staging/xgifb/vb_setmode.c  |   59 +++++++++++++++++++++--------------
 drivers/staging/xgifb/vb_table.h    |   30 ++++++++++++------
 4 files changed, 58 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index e5657ff..0f49a21 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -590,7 +590,8 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 						<= 2) && (XGIfb_vrate[i].idx
 						!= 1)) {
 					pr_debug("Adjusting rate from %d down to %d\n",
-						 rate, XGIfb_vrate[i-1].refresh);
+						 rate,
+						 XGIfb_vrate[i-1].refresh);
 					xgifb_info->rate_idx =
 						XGIfb_vrate[i - 1].idx;
 					xgifb_info->refresh_rate =
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index ae10153..80dba6a 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1042,9 +1042,8 @@ static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 
 	if (tempbx & tempcx) {
 		CR3CData = xgifb_reg_get(pVBInfo->P3d4, 0x3c);
-		if (!(CR3CData & DisplayDeviceFromCMOS)) {
+		if (!(CR3CData & DisplayDeviceFromCMOS))
 			tempcx = 0x1FF0;
-		}
 	} else {
 		tempcx = 0x1FF0;
 	}
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 01a3ef3..e81149f 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -945,23 +945,26 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 
 	if (pVBInfo->IF_DEF_LVDS == 0) {
 		CRT2Index = CRT2Index >> 6; /*  for LCD */
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) { /*301b*/
+		if (pVBInfo->VBInfo &
+		    (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) { /*301b*/
 			if (pVBInfo->LCDResInfo != Panel_1024x768)
-				VCLKIndex =  VCLK108_2_315 + 5; /* LCDXlat2VCLK */
+				/* LCDXlat2VCLK */
+				VCLKIndex = VCLK108_2_315 + 5;
 			else
 				VCLKIndex = VCLK65_315 + 2; /* LCDXlat1VCLK */
 		} else if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
-			if (pVBInfo->SetFlag & RPLLDIV2XO) {
+			if (pVBInfo->SetFlag & RPLLDIV2XO)
 				VCLKIndex = TVCLKBASE_315_25 + HiTVVCLKDIV2;
-			} else {
+			else
 				VCLKIndex = TVCLKBASE_315_25 + HiTVVCLK;
-			}
 
 			if (pVBInfo->SetFlag & TVSimuMode) {
 				if (modeflag & Charx8Dot) {
-					VCLKIndex = TVCLKBASE_315_25 + HiTVSimuVCLK;
+					VCLKIndex = TVCLKBASE_315_25 +
+							HiTVSimuVCLK;
 				} else {
-					VCLKIndex = TVCLKBASE_315_25 + HiTVTextVCLK;
+					VCLKIndex = TVCLKBASE_315_25 +
+							HiTVTextVCLK;
 				}
 			}
 
@@ -978,11 +981,10 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 					VCLKIndex = YPbPr525iVCLK;
 			}
 		} else if (pVBInfo->VBInfo & SetCRT2ToTV) {
-			if (pVBInfo->SetFlag & RPLLDIV2XO) {
+			if (pVBInfo->SetFlag & RPLLDIV2XO)
 				VCLKIndex = TVCLKBASE_315_25 + TVVCLKDIV2;
-			} else {
+			else
 				VCLKIndex = TVCLKBASE_315_25 + TVVCLK;
-			}
 		} else { /* for CRT2 */
 			/* di+Ext_CRTVCLK */
 			VCLKIndex = pVBInfo->RefIndex[RefreshRateTableIndex].
@@ -994,7 +996,8 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 		    (pVBInfo->LCDResInfo == Panel_320x480))
 			VCLKIndex = VCLK40; /* LVDSXlat1VCLK */
 		else
-			VCLKIndex = VCLK65_315 + 2; /* LVDSXlat2VCLK, LVDSXlat3VCLK  */
+			VCLKIndex = VCLK65_315 + 2; /* LVDSXlat2VCLK,
+						       LVDSXlat3VCLK  */
 	}
 
 	return VCLKIndex;
@@ -1928,7 +1931,8 @@ static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 				pVBInfo->HDE = 1024;
 				pVBInfo->VDE = 768;
 			} else if ((pVBInfo->LCDResInfo == Panel_1280x1024) ||
-				   (pVBInfo->LCDResInfo == Panel_1280x1024x75)) {
+				   (pVBInfo->LCDResInfo ==
+					Panel_1280x1024x75)) {
 				pVBInfo->HDE = 1280;
 				pVBInfo->VDE = 1024;
 			} else if (pVBInfo->LCDResInfo == Panel_1400x1050) {
@@ -2385,7 +2389,8 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 				if (pVBInfo->TVInfo & TVSimuMode) {
 					tempal = TVCLKBASE_315 + HiTVSimuVCLK;
 					if (!(modeflag & Charx8Dot))
-						tempal = TVCLKBASE_315 + HiTVTextVCLK;
+						tempal = TVCLKBASE_315 +
+								HiTVTextVCLK;
 
 				}
 				return tempal;
@@ -2431,8 +2436,8 @@ static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
 {
 	if (pVBInfo->VBType & (VB_SIS301 | VB_SIS301B | VB_SIS302B
 			| VB_SIS301LV | VB_SIS302LV | VB_XGI301C)) {
-		if ((!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)) && (pVBInfo->SetFlag
-				& ProgrammingCRT2)) {
+		if ((!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)) &&
+		    (pVBInfo->SetFlag & ProgrammingCRT2)) {
 			*di_0 = (unsigned char) XGI_VBVCLKData[tempal].SR2B;
 			*di_1 = XGI_VBVCLKData[tempal].SR2C;
 		}
@@ -2948,7 +2953,10 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 		if ((pVBInfo->LCDResInfo == Panel_1400x1050) && (pVBInfo->VBInfo
 				& SetCRT2ToLCD) && (resinfo == 9) &&
 				(!(tempbx & EnableScalingLCD)))
-			/* set to center in 1280x1024 LCDB for Panel_1400x1050 */
+			/*
+			 * set to center in 1280x1024 LCDB
+			 * for Panel_1400x1050
+			 */
 			tempbx |= SetLCDtoNonExpanding;
 	}
 
@@ -5451,7 +5459,8 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
 					tempah = 0x7F; /* Disable Channel A */
-					if (!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA))
+					if (!(pVBInfo->VBInfo &
+					      XGI_SetCRT2ToLCDA))
 						/* Disable Channel B */
 						tempah = 0xBF;
 
@@ -5470,9 +5479,10 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 		xgifb_reg_and(pVBInfo->Part4Port, 0x1F, tempah);
 
 		if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
-			if (((pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
-					|| (XGI_DisableChISLCD(pVBInfo))
-					|| (XGI_IsLCDON(pVBInfo)))
+			if (((pVBInfo->VBInfo &
+			      (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
+			    || (XGI_DisableChISLCD(pVBInfo))
+			    || (XGI_IsLCDON(pVBInfo)))
 				/* LVDS Driver power down */
 				xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x80);
 		}
@@ -5638,7 +5648,8 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 
 			if (pVBInfo->VBInfo & SetCRT2ToDualEdge)
 				tempbl = tempbl >> 4;
-			if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
+			if (pVBInfo->VBInfo &
+			    (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 				tempbh = XGI301LCDDelay;
 
 				if (!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA))
@@ -5655,7 +5666,8 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 				tempah |= tempbl;
 			}
 
-			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) { /* Channel A */
+			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
+				/* Channel A */
 				tempah &= 0x0F;
 				tempah |= tempbh;
 			}
@@ -6723,9 +6735,8 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 
 	XGI_UpdateModeInfo(HwDeviceExtension, pVBInfo);
 
-	if (HwDeviceExtension->jChipType < XG20) {
+	if (HwDeviceExtension->jChipType < XG20)
 		XGI_LockCRT2(HwDeviceExtension, pVBInfo);
-	}
 
 	return 1;
 }
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index ca8c68d..1c16846 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -1838,9 +1838,12 @@ static struct XGI330_LCDDataTablStruct XGI_LCDDataTable[] = {
 	{Panel_1024x768x75, 0x0019, 0x0001, 12}, /* XGI_ExtLCD1024x768x75Data */
 	{Panel_1024x768x75, 0x0019, 0x0000, 13}, /* XGI_StLCD1024x768x75Data */
 	{Panel_1024x768x75, 0x0018, 0x0010, 14}, /* XGI_CetLCD1024x768x75Data */
-	{Panel_1280x1024x75, 0x0019, 0x0001, 15}, /* XGI_ExtLCD1280x1024x75Data*/
-	{Panel_1280x1024x75, 0x0019, 0x0000, 16}, /* XGI_StLCD1280x1024x75Data */
-	{Panel_1280x1024x75, 0x0018, 0x0010, 17}, /* XGI_CetLCD1280x1024x75Data*/
+	/* XGI_ExtLCD1280x1024x75Data */
+	{Panel_1280x1024x75, 0x0019, 0x0001, 15},
+	/* XGI_StLCD1280x1024x75Data */
+	{Panel_1280x1024x75, 0x0019, 0x0000, 16},
+	/* XGI_CetLCD1280x1024x75Data */
+	{Panel_1280x1024x75, 0x0018, 0x0010, 17},
 	{PanelRef75Hz, 0x0008, 0x0008, 18}, /* XGI_NoScalingDatax75 */
 	{0xFF, 0x0000, 0x0000, 0} /* End of table */
 };
@@ -1859,9 +1862,12 @@ static struct XGI330_LCDDataTablStruct XGI_LCDDesDataTable[] = {
 	{Panel_1600x1200, 0x0019, 0x0001, 10}, /* XGI_ExtLCDDes1600x1200Data */
 	{Panel_1600x1200, 0x0019, 0x0000, 11}, /* XGI_StLCDDes1600x1200Data */
 	{PanelRef60Hz, 0x0008, 0x0008, 12}, /* XGI_NoScalingDesData */
-	{Panel_1024x768x75, 0x0019, 0x0001, 13}, /*XGI_ExtLCDDes1024x768x75Data*/
-	{Panel_1024x768x75, 0x0019, 0x0000, 14}, /* XGI_StLCDDes1024x768x75Data*/
-	{Panel_1024x768x75, 0x0018, 0x0010, 15}, /*XGI_CetLCDDes1024x768x75Data*/
+	/* XGI_ExtLCDDes1024x768x75Data */
+	{Panel_1024x768x75, 0x0019, 0x0001, 13},
+	/* XGI_StLCDDes1024x768x75Data */
+	{Panel_1024x768x75, 0x0019, 0x0000, 14},
+	/* XGI_CetLCDDes1024x768x75Data */
+	{Panel_1024x768x75, 0x0018, 0x0010, 15},
 	/* XGI_ExtLCDDes1280x1024x75Data */
 	{Panel_1280x1024x75, 0x0019, 0x0001, 16},
 	/* XGI_StLCDDes1280x1024x75Data */
@@ -1898,8 +1904,10 @@ static struct XGI330_LCDDataTablStruct XGI_EPLLCDDataPtr[] = {
 	{PanelRef60Hz, 0x0008, 0x0008, 7}, /* XGI_LVDSNoScalingData */
 	{Panel_1024x768x75, 0x0018, 0x0000, 8}, /* XGI_LVDS1024x768Data_1x75 */
 	{Panel_1024x768x75, 0x0018, 0x0010, 9}, /* XGI_LVDS1024x768Data_2x75 */
-	{Panel_1280x1024x75, 0x0018, 0x0000, 10}, /* XGI_LVDS1280x1024Data_1x75*/
-	{Panel_1280x1024x75, 0x0018, 0x0010, 11},  /*XGI_LVDS1280x1024Data_2x75*/
+	/* XGI_LVDS1280x1024Data_1x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0000, 10},
+	/* XGI_LVDS1280x1024Data_2x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0010, 11},
 	{PanelRef75Hz, 0x0008, 0x0008, 12}, /* XGI_LVDSNoScalingDatax75 */
 	{0xFF, 0x0000, 0x0000, 0}
 };
@@ -1917,8 +1925,10 @@ static struct XGI330_LCDDataTablStruct XGI_EPLLCDDesDataPtr[] = {
 	{Panel_1024x768x75, 0x0018, 0x0000, 9}, /* XGI_LVDS1024x768Des_1x75 */
 	{Panel_1024x768x75, 0x0618, 0x0410, 10}, /* XGI_LVDS1024x768Des_3x75 */
 	{Panel_1024x768x75, 0x0018, 0x0010, 11}, /* XGI_LVDS1024x768Des_2x75 */
-	{Panel_1280x1024x75, 0x0018, 0x0000, 12}, /* XGI_LVDS1280x1024Des_1x75 */
-	{Panel_1280x1024x75, 0x0018, 0x0010, 13}, /* XGI_LVDS1280x1024Des_2x75 */
+	/* XGI_LVDS1280x1024Des_1x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0000, 12},
+	/* XGI_LVDS1280x1024Des_2x75 */
+	{Panel_1280x1024x75, 0x0018, 0x0010, 13},
 	{PanelRef75Hz, 0x0008, 0x0008, 14}, /* XGI_LVDSNoScalingDesDatax75 */
 	{0xFF, 0x0000, 0x0000, 0}
 };
-- 
1.7.9.5

