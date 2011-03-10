Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1CJVCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:02:54 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:60503 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab1CJVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:52 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 20/22] staging: xgifb: rename XGINew_SetRegOR() to xgifb_reg_or()
Date: Thu, 10 Mar 2011 23:02:45 +0200
Message-Id: <1299790967-7135-21-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename XGINew_SetRegOR() to xgifb_reg_or().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.c     |    2 +-
 drivers/staging/xgifb/vb_init.c    |   12 +++---
 drivers/staging/xgifb/vb_setmode.c |   72 ++++++++++++++++++------------------
 drivers/staging/xgifb/vb_util.c    |   11 ++---
 drivers/staging/xgifb/vb_util.h    |    2 +-
 5 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 3a37105..c24ece2 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -309,7 +309,7 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 				}
 
 				if (pVBInfo->VBType & VB_XGI301C)
-					XGINew_SetRegOR(pVBInfo->Part4Port, 0x0d, 0x04);
+					xgifb_reg_or(pVBInfo->Part4Port, 0x0d, 0x04);
 
 				if (XGINew_SenseHiTV(HwDeviceExtension, pVBInfo)) { /* add by kuku for Multi-adapter sense HiTV */
 					tempax |= HiTVSense;
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 7138a24..46b8ebd 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -71,7 +71,7 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 	} else if (HwDeviceExtension->jChipType == XG21) {
 		XGINew_SetRegAND(pVBInfo->P3d4, 0xB4, ~0x02); /* Independent GPIO control */
 		udelay(800);
-		XGINew_SetRegOR(pVBInfo->P3d4, 0x4A, 0x80); /* Enable GPIOH read */
+		xgifb_reg_or(pVBInfo->P3d4, 0x4A, 0x80); /* Enable GPIOH read */
 		temp = xgifb_reg_get(pVBInfo->P3d4, 0x48); /* GPIOF 0:DVI 1:DVO */
 		/* HOTPLUG_SUPPORT */
 		/* for current XG20 & XG21, GPIOH is floating, driver will fix DDR temporarily */
@@ -80,7 +80,7 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 		else
 			data = 0; /* DDR */
 		/* ~HOTPLUG_SUPPORT */
-		XGINew_SetRegOR(pVBInfo->P3d4, 0xB4, 0x02);
+		xgifb_reg_or(pVBInfo->P3d4, 0xB4, 0x02);
 		return data;
 	} else {
 		data = xgifb_reg_get(pVBInfo->P3d4, 0x97) & 0x01;
@@ -462,7 +462,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 	temp3 = temp & 0x80;
 	xgifb_reg_set(P3d4, 0x45, temp1); /* CR45 */
 	xgifb_reg_set(P3d4, 0x99, temp2); /* CR99 */
-	XGINew_SetRegOR(P3d4, 0x40, temp3); /* CR40_D[7] */
+	xgifb_reg_or(P3d4, 0x40, temp3); /* CR40_D[7] */
 	xgifb_reg_set(P3d4, 0x41, pVBInfo->CR40[0][XGINew_RAMType]); /* CR41 */
 
 	if (HwDeviceExtension->jChipType == XG27)
@@ -1196,7 +1196,7 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 #if 1
 	if ((pVideoMemory[0x65] & 0x01)) { /* For XG21 LVDS */
 		pVBInfo->IF_DEF_LVDS = 1;
-		XGINew_SetRegOR(pVBInfo->P3d4, 0x32, LCDSense);
+		xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS on chip */
 	} else {
 #endif
@@ -1204,7 +1204,7 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 		Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0xC0;
 		if (Temp == 0xC0) { /* DVI & DVO GPIOA/B pull high */
 			XGINew_SenseLCD(HwDeviceExtension, pVBInfo);
-			XGINew_SetRegOR(pVBInfo->P3d4, 0x32, LCDSense);
+			xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
 			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x20, 0x20); /* Enable read GPIOF */
 			Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x04;
 			if (!Temp)
@@ -1236,7 +1236,7 @@ static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
 	} else {
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* TMDS/DVO setting */
 	}
-	XGINew_SetRegOR(pVBInfo->P3d4, 0x32, LCDSense);
+	xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
 
 }
 
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index cef0cf7..2dc8a1f 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -704,7 +704,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16]; /* Tempax: CR16 VRS */
 		Tempbx = Tempax; /* Tempbx=Tempax */
 		Tempax &= 0x01; /* Tempax: VRS[0] */
-		XGINew_SetRegOR(pVBInfo->P3c4, 0x33, Tempax); /* SR33[0]->VRS */
+		xgifb_reg_or(pVBInfo->P3c4, 0x33, Tempax); /* SR33[0]->VRS */
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[7]; /* Tempax: CR7 VRS */
 		Tempdx = Tempbx >> 1; /* Tempdx: VRS[7:1] */
 		Tempcx = Tempax & 0x04; /* Tempcx: CR7[2] */
@@ -772,7 +772,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10]; /* CR10 VRS */
 		Tempbx = Tempax; /* Tempbx: VRS */
 		Tempax &= 0x01; /* Tempax[0]: VRS[0] */
-		XGINew_SetRegOR(pVBInfo->P3c4, 0x33, Tempax); /* SR33[0]->VRS[0] */
+		xgifb_reg_or(pVBInfo->P3c4, 0x33, Tempax); /* SR33[0]->VRS[0] */
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[9]; /* CR7[2][7] VRE */
 		Tempcx = Tempbx >> 1; /* Tempcx[6:0]: VRS[7:1] */
 		Tempdx = Tempax & 0x04; /* Tempdx[2]: CR7[2] */
@@ -958,11 +958,11 @@ static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 	Temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
 
 	if (Temp & 0x01) {
-		XGINew_SetRegOR(pVBInfo->P3c4, 0x06, 0x40); /* 18 bits FP */
-		XGINew_SetRegOR(pVBInfo->P3c4, 0x09, 0x40);
+		xgifb_reg_or(pVBInfo->P3c4, 0x06, 0x40); /* 18 bits FP */
+		xgifb_reg_or(pVBInfo->P3c4, 0x09, 0x40);
 	}
 
-	XGINew_SetRegOR(pVBInfo->P3c4, 0x1E, 0x01); /* Negative blank polarity */
+	xgifb_reg_or(pVBInfo->P3c4, 0x1E, 0x01); /* Negative blank polarity */
 
 	XGINew_SetRegAND(pVBInfo->P3c4, 0x30, ~0x20);
 	XGINew_SetRegAND(pVBInfo->P3c4, 0x35, ~0x80);
@@ -970,15 +970,15 @@ static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 	if (ModeNo <= 0x13) {
 		b3CC = (unsigned char) inb(XGI_P3cc);
 		if (b3CC & 0x40)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
 		if (b3CC & 0x80)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
 	} else {
 		Data = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
 		if (Data & 0x4000)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
 		if (Data & 0x8000)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
 	}
 }
 
@@ -1010,7 +1010,7 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 
 	XGI_SetXG27FPBits(pVBInfo);
 
-	XGINew_SetRegOR(pVBInfo->P3c4, 0x1E, 0x01); /* Negative blank polarity */
+	xgifb_reg_or(pVBInfo->P3c4, 0x1E, 0x01); /* Negative blank polarity */
 
 	XGINew_SetRegAND(pVBInfo->P3c4, 0x30, ~0x20); /* Hsync polarity */
 	XGINew_SetRegAND(pVBInfo->P3c4, 0x35, ~0x80); /* Vsync polarity */
@@ -1018,15 +1018,15 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 	if (ModeNo <= 0x13) {
 		b3CC = (unsigned char) inb(XGI_P3cc);
 		if (b3CC & 0x40)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
 		if (b3CC & 0x80)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
 	} else {
 		Data = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
 		if (Data & 0x4000)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
 		if (Data & 0x8000)
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
 	}
 }
 
@@ -1662,7 +1662,7 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 		else
 			data = 0x6c;
 		xgifb_reg_set(pVBInfo->P3d4, 0x52, data);
-		XGINew_SetRegOR(pVBInfo->P3d4, 0x51, 0x10);
+		xgifb_reg_or(pVBInfo->P3d4, 0x51, 0x10);
 	} else if (HwDeviceExtension->jChipType >= XG20) {
 		if (data & 0x40)
 			data = 0x33;
@@ -4208,7 +4208,7 @@ static void XGI_WaitDisplay(struct vb_device_info *pVBInfo)
 static void XGI_AutoThreshold(struct vb_device_info *pVBInfo)
 {
 	if (!(pVBInfo->SetFlag & Win9xDOSMode))
-		XGINew_SetRegOR(pVBInfo->Part1Port, 0x01, 0x40);
+		xgifb_reg_or(pVBInfo->Part1Port, 0x01, 0x40);
 }
 
 static void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo)
@@ -4573,9 +4573,9 @@ static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part4Port, 0x00, 0x12);
 
 	if (pVBInfo->VBInfo & SetCRT2ToRAMDAC)
-		XGINew_SetRegOR(pVBInfo->Part4Port, 0x12, 0x28);
+		xgifb_reg_or(pVBInfo->Part4Port, 0x12, 0x28);
 	else
-		XGINew_SetRegOR(pVBInfo->Part4Port, 0x12, 0x08);
+		xgifb_reg_or(pVBInfo->Part4Port, 0x12, 0x08);
 }
 
 static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
@@ -6073,7 +6073,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part4Port, 0x17, temp);
 	temp = temp2 | ((tempcx & 0xFF00) >> 8);
 	xgifb_reg_set(pVBInfo->Part4Port, 0x15, temp);
-	XGINew_SetRegOR(pVBInfo->Part4Port, 0x0D, 0x08);
+	xgifb_reg_or(pVBInfo->Part4Port, 0x0D, 0x08);
 	tempcx = pVBInfo->VBInfo;
 	tempbx = pVBInfo->VGAHDE;
 
@@ -6206,7 +6206,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToHiVisionTV)) {
 			if (pVBInfo->VGAHDE > 800)
-				XGINew_SetRegOR(pVBInfo->Part4Port, 0x1E, 0x08);
+				xgifb_reg_or(pVBInfo->Part4Port, 0x1E, 0x08);
 
 		}
 		temp = 0x0036;
@@ -6539,7 +6539,7 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
 
 	if (!(modeflag & Charx8Dot))
-		XGINew_SetRegOR(pVBInfo->P3c4, 0x1, 0x1);
+		xgifb_reg_or(pVBInfo->P3c4, 0x1, 0x1);
 
 	/* HT SR0B[1:0] CR00 */
 	value = (LVDSHT >> 3) - 5;
@@ -6724,7 +6724,7 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
 
 	if (!(modeflag & Charx8Dot))
-		XGINew_SetRegOR(pVBInfo->P3c4, 0x1, 0x1);
+		xgifb_reg_or(pVBInfo->P3c4, 0x1, 0x1);
 
 	/* HT SR0B[1:0] CR00 */
 	value = (LVDSHT >> 3) - 5;
@@ -6947,7 +6947,7 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			if (((pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)))
 					|| (XGI_DisableChISLCD(pVBInfo))
 					|| (XGI_IsLCDON(pVBInfo)))
-				XGINew_SetRegOR(pVBInfo->Part4Port, 0x30, 0x80); /* LVDS Driver power down */
+				xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x80); /* LVDS Driver power down */
 		}
 
 		if ((pVBInfo->SetFlag & DisableChA) || (pVBInfo->VBInfo
@@ -6976,7 +6976,7 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 								& (SetCRT2ToRAMDAC
 										| SetCRT2ToLCD
 										| SetCRT2ToTV))))
-			XGINew_SetRegOR(pVBInfo->Part1Port, 0x00, 0x80); /* BScreenOff=1 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80); /* BScreenOff=1 */
 
 		if ((pVBInfo->SetFlag & DisableChB) || (pVBInfo->VBInfo
 				& (DisableCRT2Display | SetSimuScanMode))
@@ -6984,13 +6984,13 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 				|| (pVBInfo->VBInfo & (SetCRT2ToRAMDAC
 						| SetCRT2ToLCD | SetCRT2ToTV))) {
 			tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x00); /* save Part1 index 0 */
-			XGINew_SetRegOR(pVBInfo->Part1Port, 0x00, 0x10); /* BTDAC = 1, avoid VB reset */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x10); /* BTDAC = 1, avoid VB reset */
 			XGINew_SetRegAND(pVBInfo->Part1Port, 0x1E, 0xDF); /* disable CRT2 */
 			xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah); /* restore Part1 index 0 */
 		}
 	} else { /* {301} */
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToTV)) {
-			XGINew_SetRegOR(pVBInfo->Part1Port, 0x00, 0x80); /* BScreenOff=1 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80); /* BScreenOff=1 */
 			XGINew_SetRegAND(pVBInfo->Part1Port, 0x1E, 0xDF); /* Disable CRT2 */
 			XGINew_SetRegAND(pVBInfo->P3c4, 0x32, 0xDF); /* Disable TV asPrimary VGA swap */
 		}
@@ -7211,7 +7211,7 @@ static void SetSpectrum(struct vb_device_info *pVBInfo)
 
 	XGINew_SetRegAND(pVBInfo->Part4Port, 0x30, 0x8F); /* disable down spectrum D[4] */
 	XGI_LongWait(pVBInfo);
-	XGINew_SetRegOR(pVBInfo->Part4Port, 0x30, 0x20); /* reset spectrum */
+	xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x20); /* reset spectrum */
 	XGI_LongWait(pVBInfo);
 
 	xgifb_reg_set(pVBInfo->Part4Port, 0x31,
@@ -7223,7 +7223,7 @@ static void SetSpectrum(struct vb_device_info *pVBInfo)
 	xgifb_reg_set(pVBInfo->Part4Port, 0x34,
 			pVBInfo->LCDCapList[index].Spectrum_34);
 	XGI_LongWait(pVBInfo);
-	XGINew_SetRegOR(pVBInfo->Part4Port, 0x30, 0x40); /* enable spectrum */
+	xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x40); /* enable spectrum */
 }
 
 static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
@@ -7652,8 +7652,8 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 
 	if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
 		if (pVBInfo->LCDInfo & SetLCDDualLink) {
-			XGINew_SetRegOR(pVBInfo->Part4Port, 0x27, 0x20);
-			XGINew_SetRegOR(pVBInfo->Part4Port, 0x34, 0x10);
+			xgifb_reg_or(pVBInfo->Part4Port, 0x27, 0x20);
+			xgifb_reg_or(pVBInfo->Part4Port, 0x34, 0x10);
 		}
 	}
 }
@@ -8076,13 +8076,13 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 						tempah |= 0x20;
 				}
 				xgifb_reg_set(pVBInfo->P3c4, 0x32, tempah);
-				XGINew_SetRegOR(pVBInfo->P3c4, 0x1E, 0x20);
+				xgifb_reg_or(pVBInfo->P3c4, 0x1E, 0x20);
 
 				tempah = (unsigned char) xgifb_reg_get(
 						pVBInfo->Part1Port, 0x2E);
 
 				if (!(tempah & 0x80))
-					XGINew_SetRegOR(pVBInfo->Part1Port,
+					xgifb_reg_or(pVBInfo->Part1Port,
 							0x2E, 0x80); /* BVBDOENABLE = 1 */
 
 				XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F); /* BScreenOFF = 0 */
@@ -8140,7 +8140,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			}
 		}
 
-		XGINew_SetRegOR(pVBInfo->Part4Port, 0x1F, tempah); /* EnablePart4_1F */
+		xgifb_reg_or(pVBInfo->Part4Port, 0x1F, tempah); /* EnablePart4_1F */
 
 		if (pVBInfo->SetFlag & Win9xDOSMode) {
 			XGI_DisplayOn(HwDeviceExtension, pVBInfo);
@@ -8159,12 +8159,12 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 	else { /* LVDS */
 		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD
 				| SetCRT2ToLCDA))
-			XGINew_SetRegOR(pVBInfo->Part1Port, 0x1E, 0x20); /* enable CRT2 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x1E, 0x20); /* enable CRT2 */
 
 		tempah = (unsigned char) xgifb_reg_get(pVBInfo->Part1Port,
 				0x2E);
 		if (!(tempah & 0x80))
-			XGINew_SetRegOR(pVBInfo->Part1Port, 0x2E, 0x80); /* BVBDOENABLE = 1 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x2E, 0x80); /* BVBDOENABLE = 1 */
 
 		XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F);
 		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
@@ -8270,7 +8270,7 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 					XGI_SetXG21LVDSPara(ModeNo,
 							ModeIdIndex, pVBInfo);
 			}
-			/* XGINew_SetRegOR(pVBInfo->P3d4, 0x48, 0x20); *//* P. ON */
+			/* xgifb_reg_or(pVBInfo->P3d4, 0x48, 0x20); *//* P. ON */
 		}
 	}
 
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 2dcbb63..6c0c801 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -43,12 +43,11 @@ void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
 	xgifb_reg_set(Port, Index, temp);
 }
 
-void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
-		unsigned short DataOR)
+void xgifb_reg_or(unsigned long port, u8 index, unsigned data_or)
 {
-	unsigned short temp;
+	u8 temp;
 
-	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
-	temp |= DataOR;
-	xgifb_reg_set(Port, Index, temp);
+	temp = xgifb_reg_get(port, index); /* XGINew_Part1Port index 02 */
+	temp |= data_or;
+	xgifb_reg_set(port, index, temp);
 }
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 70d6ac0..655755e 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -2,7 +2,7 @@
 #define _VBUTIL_
 extern void xgifb_reg_set(unsigned long, u8, u8);
 extern u8 xgifb_reg_get(unsigned long, u8);
-extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
+extern void xgifb_reg_or(unsigned long, u8, unsigned);
 extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
 extern   void     XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,unsigned short DataAND,unsigned short DataOR);
 #endif
-- 
1.5.6.5

