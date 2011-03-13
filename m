Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1CMK1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:40 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39909 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab1CMK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:28 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 21/24] staging: xgifb: rename XGINew_SetRegANDOR() to xgifb_reg_and_or()
Date: Sun, 13 Mar 2011 12:26:25 +0200
Message-Id: <1300011988-2109-22-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename XGINew_SetRegANDOR() to xgifb_reg_and_or().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.c     |   24 ++--
 drivers/staging/xgifb/vb_init.c    |   34 ++--
 drivers/staging/xgifb/vb_setmode.c |  338 ++++++++++++++++++------------------
 drivers/staging/xgifb/vb_util.c    |    2 +-
 drivers/staging/xgifb/vb_util.h    |    2 +-
 5 files changed, 200 insertions(+), 200 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index c24ece2..d7c1b2e 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -34,7 +34,7 @@ static unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx,
 	xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp |= (tempcx & 0x00FF);
-	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
+	xgifb_reg_and_or(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
 
 	for (i = 0; i < 10; i++)
 		XGI_LongWait(pVBInfo);
@@ -87,7 +87,7 @@ static unsigned char XGINew_GetLCDDDCInfo(struct xgi_hw_device_info *HwDeviceExt
 		default:
 			break;
 		}
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x36, 0xF0, temp);
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x36, 0xF0, temp);
 		return 1;
 	}
 }
@@ -148,7 +148,7 @@ static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 		tempbx = PanelTypeTable[tempbx];
 
 		temp = (tempbx & 0xFF00) >> 8;
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~(LCDSyncBit
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x37, ~(LCDSyncBit
 				| LCDRGB18Bit), temp);
 		return 1;
 	}
@@ -182,7 +182,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 	xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp |= (tempcx & 0x00FF);
-	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
+	xgifb_reg_and_or(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
 
 	for (i = 0; i < 10; i++)
 		XGI_LongWait(pVBInfo);
@@ -202,7 +202,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 	xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp |= (tempcx & 0x00FF);
-	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
+	xgifb_reg_and_or(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
 
 	for (i = 0; i < 10; i++)
 		XGI_LongWait(pVBInfo);
@@ -221,7 +221,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 		xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 		temp = (tempbx & 0xFF00) >> 8;
 		temp |= (tempcx & 0x00FF);
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
+		xgifb_reg_and_or(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
 
 		for (i = 0; i < 10; i++)
 			XGI_LongWait(pVBInfo);
@@ -251,8 +251,8 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 		if (tempax == 0x00) { /* Get Panel id from DDC */
 			temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
 			if (temp == 1) { /* LCD connect */
-				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x39, 0xFF, 0x01); /* set CR39 bit0="1" */
-				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, 0xEF, 0x00); /* clean CR37 bit4="0" */
+				xgifb_reg_and_or(pVBInfo->P3d4, 0x39, 0xFF, 0x01); /* set CR39 bit0="1" */
+				xgifb_reg_and_or(pVBInfo->P3d4, 0x37, 0xEF, 0x00); /* clean CR37 bit4="0" */
 				temp = LCDSense;
 			} else { /* LCD don't connect */
 				temp = 0;
@@ -263,14 +263,14 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 		}
 
 		tempbx = ~(LCDSense | AVIDEOSense | SVIDEOSense);
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, tempbx, temp);
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, tempbx, temp);
 	} else { /* for 301 */
 		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) { /* for HiVision */
 			tempax = xgifb_reg_get(pVBInfo->P3c4, 0x38);
 			temp = tempax & 0x01;
 			tempax = xgifb_reg_get(pVBInfo->P3c4, 0x3A);
 			temp = temp | (tempax & 0x02);
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xA0, temp);
+			xgifb_reg_and_or(pVBInfo->P3d4, 0x32, 0xA0, temp);
 		} else {
 			if (XGI_BridgeIsOn(pVBInfo)) {
 				P2reg0 = xgifb_reg_get(pVBInfo->Part2Port, 0x00);
@@ -291,7 +291,7 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 					XGI_SetCRT2Group301(SenseModeNo, HwDeviceExtension, pVBInfo);
 					XGI_SetCRT2ModeRegs(0x2e, HwDeviceExtension, pVBInfo);
 					/* XGI_DisableBridge( HwDeviceExtension, pVBInfo ) ; */
-					XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xDF, 0x20); /* Display Off 0212 */
+					xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xDF, 0x20); /* Display Off 0212 */
 					for (i = 0; i < 20; i++)
 						XGI_LongWait(pVBInfo);
 				}
@@ -365,7 +365,7 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 			tempcx = 0;
 			XGINew_Sense(tempbx, tempcx, pVBInfo);
 
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~0xDF, tempax);
+			xgifb_reg_and_or(pVBInfo->P3d4, 0x32, ~0xDF, tempax);
 			xgifb_reg_set(pVBInfo->Part2Port, 0x00, P2reg0);
 
 			if (!(P2reg0 & 0x20)) {
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 46b8ebd..45491be 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -421,7 +421,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 
 	temp3 = 0;
 	for (k = 0; k < 4; k++) {
-		XGINew_SetRegANDOR(P3d4, 0x6E, 0xFC, temp3); /* CR6E_D[1:0] select channel */
+		xgifb_reg_and_or(P3d4, 0x6E, 0xFC, temp3); /* CR6E_D[1:0] select channel */
 		temp2 = 0;
 		for (i = 0; i < 8; i++) {
 			temp = pVBInfo->CR6F[XGINew_RAMType][8 * k + i]; /* CR6F DQ fine tune delay */
@@ -516,7 +516,7 @@ static void XGINew_SetDRAMSizingType(int index,
 	unsigned short data;
 
 	data = DRAMTYPE_TABLE[index][4];
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x13, 0x80, data);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x13, 0x80, data);
 	udelay(15);
 	/* should delay 50 ns */
 }
@@ -1197,20 +1197,20 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 	if ((pVideoMemory[0x65] & 0x01)) { /* For XG21 LVDS */
 		pVBInfo->IF_DEF_LVDS = 1;
 		xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS on chip */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS on chip */
 	} else {
 #endif
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* Enable GPIOA/B read  */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* Enable GPIOA/B read  */
 		Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0xC0;
 		if (Temp == 0xC0) { /* DVI & DVO GPIOA/B pull high */
 			XGINew_SenseLCD(HwDeviceExtension, pVBInfo);
 			xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x20, 0x20); /* Enable read GPIOF */
+			xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x20, 0x20); /* Enable read GPIOF */
 			Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x04;
 			if (!Temp)
-				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0x80); /* TMDS on chip */
+				xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0x80); /* TMDS on chip */
 			else
-				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* Only DVO on chip */
+				xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* Only DVO on chip */
 			XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); /* Disable read GPIOF */
 		}
 #if 1
@@ -1225,16 +1225,16 @@ static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
 
 	pVBInfo->IF_DEF_LVDS = 0;
 	bCR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x07, 0x07); /* Enable GPIOA/B/C read  */
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x07, 0x07); /* Enable GPIOA/B/C read  */
 	Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x07;
 	xgifb_reg_set(pVBInfo->P3d4, 0x4A, bCR4A);
 
 	if (Temp <= 0x02) {
 		pVBInfo->IF_DEF_LVDS = 1;
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS setting */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS setting */
 		xgifb_reg_set(pVBInfo->P3d4, 0x30, 0x21);
 	} else {
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* TMDS/DVO setting */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* TMDS/DVO setting */
 	}
 	xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
 
@@ -1245,7 +1245,7 @@ static unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo)
 	unsigned char CR38, CR4A, temp;
 
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x10, 0x10); /* enable GPIOE read */
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x10, 0x10); /* enable GPIOE read */
 	CR38 = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 	temp = 0;
 	if ((CR38 & 0xE0) > 0x80) {
@@ -1264,7 +1264,7 @@ static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
 	unsigned char CR4A, temp;
 
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* enable GPIOA/B/C read */
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* enable GPIOA/B/C read */
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 	if (temp <= 2)
 		temp &= 0x03;
@@ -1490,7 +1490,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
 		/* Set VB */
 		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
-		XGINew_SetRegANDOR(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00); /* alan, disable VideoCapture */
+		xgifb_reg_and_or(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00); /* alan, disable VideoCapture */
 		xgifb_reg_set(pVBInfo->Part1Port, 0x00, 0x00);
 		temp1 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x7B); /* chk if BCLK>=100MHz */
 		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
@@ -1551,16 +1551,16 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	if (HwDeviceExtension->jChipType == XG21) {
 		printk("186");
 
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
 		temp = GetXG21FPBits(pVBInfo);
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x01, temp);
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x37, ~0x01, temp);
 		printk("187");
 
 	}
 	if (HwDeviceExtension->jChipType == XG27) {
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
 		temp = GetXG27FPBits(pVBInfo);
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x03, temp);
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x37, ~0x03, temp);
 	}
 	printk("19");
 
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 2dc8a1f..49791c4 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -362,11 +362,11 @@ static void XGI_ClearExt1Regs(struct vb_device_info *pVBInfo)
 static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo)
 {
 
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, 0x20);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x31, ~0x30, 0x20);
 	xgifb_reg_set(pVBInfo->P3c4, 0x2B, pVBInfo->VCLKData[0].SR2B);
 	xgifb_reg_set(pVBInfo->P3c4, 0x2C, pVBInfo->VCLKData[0].SR2C);
 
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, 0x10);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x31, ~0x30, 0x10);
 	xgifb_reg_set(pVBInfo->P3c4, 0x2B, pVBInfo->VCLKData[1].SR2B);
 	xgifb_reg_set(pVBInfo->P3c4, 0x2C, pVBInfo->VCLKData[1].SR2C);
 
@@ -536,7 +536,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 
 	/* xgifb_reg_set(pVBInfo->P3d4, 0x51, 0); */
 	/* xgifb_reg_set(pVBInfo->P3d4, 0x56, 0); */
-	/* XGINew_SetRegANDOR(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
+	/* xgifb_reg_and_or(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
 
 	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11); /* unlock cr0-7 */
 	data &= 0x7F;
@@ -587,7 +587,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 		if (data > 7)
 			data = data - 7;
 		data = data << 5;
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0e, ~0xE0, data);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x0e, ~0xE0, data);
 	}
 }
 
@@ -599,7 +599,7 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeN
 
 	/* xgifb_reg_set(pVBInfo->P3d4, 0x51, 0); */
 	/* xgifb_reg_set(pVBInfo->P3d4, 0x56, 0); */
-	/* XGINew_SetRegANDOR(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
+	/* xgifb_reg_and_or(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
 
 	for (i = 0x00; i <= 0x01; i++) {
 		data = pVBInfo->TimingV[0].data[i];
@@ -699,7 +699,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 			Tempdx |= 0x20; /* Tempdx: HRE = HRE + 0x20 */
 		Tempdx <<= 2; /* Tempdx << 2 */
 		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16]; /* Tempax: CR16 VRS */
 		Tempbx = Tempax; /* Tempbx=Tempax */
@@ -767,7 +767,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempdx >>= 6; /* Tempdx[7:6]->[1:0] HRS[9:8] */
 		Tempax |= Tempdx; /* HRE[5:0]HRS[9:8] */
 		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F D[7:2]->HRE, D[1:0]->HRS */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10]; /* CR10 VRS */
 		Tempbx = Tempax; /* Tempbx: VRS */
@@ -836,7 +836,7 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 			Tempdx |= 0x20; /* Tempdx: HRE = HRE + 0x20 */
 		Tempdx <<= 2; /* Tempdx << 2 */
 		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16]; /* Tempax: CR10 VRS */
 		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS */
@@ -845,7 +845,7 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempbx = Tempax; /* Tempbx=CR07 */
 		Tempax &= 0x04; /* Tempax[2]: CR07[2] VRS[8] */
 		Tempax >>= 2;
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x01, Tempax); /* SR35 D[0]->VRS D[8] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x01, Tempax); /* SR35 D[0]->VRS D[8] */
 		Tempcx |= (Tempax << 8); /* Tempcx[8] |= VRS[8] */
 		Tempcx |= (Tempbx & 0x80) << 2; /* Tempcx[9] |= VRS[9] */
 
@@ -859,8 +859,8 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax = (unsigned char) Tempbx & 0xFF; /* Tempax[7:0]: VRE[7:0] */
 		Tempax <<= 2; /* Tempax << 2: VRE[5:0] */
 		Tempcx = (Tempcx & 0x600) >> 8; /* Tempcx VRS[10:9] */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax); /* SR3F D[7:2]->VRE D[5:0] */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x06, Tempcx); /* SR35 D[2:1]->VRS[10:9] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax); /* SR3F D[7:2]->VRE D[5:0] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x06, Tempcx); /* SR35 D[2:1]->VRS[10:9] */
 	} else {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3]; /* Tempax: CR4 HRS */
@@ -893,7 +893,7 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax >>= 6; /* Tempax[1:0]: HRS[9:8]*/
 		Tempax |= ((Tempbx << 2) & 0xFF); /* Tempax[7:2]: HRE[5:0] */
 		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F [7:2][1:0]: HRE[5:0]HRS[9:8] */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10]; /* CR10 VRS */
 		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS[7:0] */
@@ -903,7 +903,7 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempbx = Tempax; /* Tempbx <= CR07[7:0] */
 		Tempax = Tempax & 0x04; /* Tempax[2]: CR7[2]: VRS[8] */
 		Tempax >>= 2; /* Tempax[0]: VRS[8] */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x01, Tempax); /* SR35[0]: VRS[8] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x01, Tempax); /* SR35[0]: VRS[8] */
 		Tempcx |= (Tempax << 8); /* Tempcx <= VRS[8:0] */
 		Tempcx |= ((Tempbx & 0x80) << 2); /* Tempcx <= VRS[9:0] */
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[14]; /* Tempax: SR0A */
@@ -924,9 +924,9 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 			Tempbx |= 0x20; /* VRE + 0x20 */
 
 		Tempax = (Tempbx << 2) & 0xFF; /* Tempax: Tempax[7:0]; VRE[5:0]00 */
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax); /* SR3F[7:2]:VRE[5:0] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax); /* SR3F[7:2]:VRE[5:0] */
 		Tempax = Tempcx >> 8;
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x07, Tempax); /* SR35[2:0]:VRS[10:8] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x07, Tempax); /* SR35[2:0]:VRS[10:8] */
 	}
 }
 
@@ -1127,7 +1127,7 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
 	xgifb_reg_set(pVBInfo->P3d4, 0x01, (unsigned short) (tempcx & 0xff));
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x0b, ~0x0c,
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x0b, ~0x0c,
 			(unsigned short) ((tempcx & 0x0ff00) >> 10));
 	xgifb_reg_set(pVBInfo->P3d4, 0x12, (unsigned short) (tempbx & 0xff));
 	tempax = 0;
@@ -1139,7 +1139,7 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 	if (tempbx & 0x02)
 		tempax |= 0x40;
 
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x42, tempax);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x42, tempax);
 	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x07);
 	data &= 0xFF;
 	tempax = 0;
@@ -1147,7 +1147,7 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 	if (tempbx & 0x04)
 		tempax |= 0x02;
 
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x0a, ~0x02, tempax);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x0a, ~0x02, tempax);
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp);
 }
 
@@ -1559,9 +1559,9 @@ static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
 	*/
 	data2 = 0x00;
 
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x07, 0xFC, data2);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x07, 0xFC, data2);
 	if (HwDeviceExtension->jChipType >= XG27)
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x40, 0xFC, data2 & 0x03);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x40, 0xFC, data2 & 0x03);
 
 }
 
@@ -1581,7 +1581,7 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ModeFlag */
 
 	if (xgifb_reg_get(pVBInfo->P3d4, 0x31) & 0x01)
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1F, 0x3F, 0x00);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x1F, 0x3F, 0x00);
 
 	if (ModeNo > 0x13)
 		data = infoflag;
@@ -1604,7 +1604,7 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	if (data)
 		data2 |= 0x20;
 
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x06, ~0x3F, data2);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x06, ~0x3F, data2);
 	/* xgifb_reg_set(pVBInfo->P3c4,0x06,data2); */
 	resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
 	if (ModeNo <= 0x13)
@@ -1621,12 +1621,12 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 
 	data2 = data & 0x00FF;
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x19, 0xFF, data2);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFF, data2);
 	data2 = (data & 0xFF00) >> 8;
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x19, 0xFC, data2);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFC, data2);
 
 	if (modeflag & HalfDCLK)
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xF7, 0x08);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xF7, 0x08);
 
 	data2 = 0;
 
@@ -1638,14 +1638,14 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 			data2 |= 0x40;
 	}
 
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0F, ~0x48, data2);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0F, ~0x48, data2);
 	data = 0x60;
 	if (pVBInfo->ModeType != ModeText) {
 		data = data ^ 0x60;
 		if (pVBInfo->ModeType != ModeEGA)
 			data = data ^ 0xA0;
 	}
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x21, 0x1F, data);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x21, 0x1F, data);
 
 	XGI_SetVCLKState(HwDeviceExtension, ModeNo, RefreshRateTableIndex,
 			pVBInfo);
@@ -1696,19 +1696,19 @@ void XGI_VesaLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, st
 				if (pVBInfo->VBType & VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
 					if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
 						if (pVBInfo->VBInfo & SetInSlaveMode) {
-							XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xf7, 0x00);
-							XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0f, 0x7f, 0x00);
+							xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xf7, 0x00);
+							xgifb_reg_and_or(pVBInfo->P3c4, 0x0f, 0x7f, 0x00);
 							return;
 						}
 					}
 				}
-				XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0f, 0xff, 0x80);
-				XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xf7, 0x00);
+				xgifb_reg_and_or(pVBInfo->P3c4, 0x0f, 0xff, 0x80);
+				xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xf7, 0x00);
 				return;
 			}
 		}
 	}
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0f, 0x7f, 0x00);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0f, 0x7f, 0x00);
 }
 */
 
@@ -2653,7 +2653,7 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		XGI_SetCRT1Timing_V(ModeIdIndex, ModeNo, pVBInfo);
 
 		if (pVBInfo->IF_DEF_CH7007 == 1) {
-			XGINew_SetRegANDOR(pVBInfo->P3c4, 0x33, ~0x01,
+			xgifb_reg_and_or(pVBInfo->P3c4, 0x33, ~0x01,
 					CH7007TV_TimingVPtr[0].data[7] & 0x01);
 			xgifb_reg_set(pVBInfo->P3c4, 0x34,
 					CH7007TV_TimingVPtr[0].data[8]);
@@ -2914,7 +2914,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 			xgifb_reg_set(pVBInfo->Part1Port, 0x18,
 					(unsigned short) (tempbx & 0xff));
-			XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, ~0x0f,
+			xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, ~0x0f,
 					(unsigned short) (tempcx & 0x0f));
 
 			tempax = ((tempbx >> 8) & 0x07) << 3;
@@ -2926,7 +2926,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (pVBInfo->LCDInfo & EnableLVDSDDA)
 				tempax |= 0x40;
 
-			XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x1a, 0x07,
+			xgifb_reg_and_or(pVBInfo->Part1Port, 0x1a, 0x07,
 					tempax);
 
 			tempcx = pVBInfo->VGAVT;
@@ -2967,17 +2967,17 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 						(unsigned short) ((temp2 >> 8)
 								& 0xff));
 				tempbx = (unsigned short) (temp2 >> 16);
-				XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x3a,
+				xgifb_reg_and_or(pVBInfo->Part4Port, 0x3a,
 						~0xc0,
 						(unsigned short) ((tempbx
 								& 0xff) << 6));
 
 				tempcx = pVBInfo->VGAVDE;
 				if (tempcx == pVBInfo->VDE)
-					XGINew_SetRegANDOR(pVBInfo->Part4Port,
+					xgifb_reg_and_or(pVBInfo->Part4Port,
 							0x30, ~0x0c, 0x00);
 				else
-					XGINew_SetRegANDOR(pVBInfo->Part4Port,
+					xgifb_reg_and_or(pVBInfo->Part4Port,
 							0x30, ~0x0c, 0x08);
 			}
 
@@ -3251,7 +3251,7 @@ static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGI_GetLCDVCLKPtr(&di_0, &di_1, pVBInfo);
 
 	for (i = 0; i < 4; i++) {
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x31, ~0x30,
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x31, ~0x30,
 				(unsigned short) (0x10 * i));
 		if (pVBInfo->IF_DEF_CH7007 == 1) {
 			xgifb_reg_set(pVBInfo->P3c4, 0x2b, di_0);
@@ -3344,7 +3344,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 		}
 		temp = tempcl;
 		tempbl = ~ModeSwitchStatus;
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x3d, tempbl, temp);
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x3d, tempbl, temp);
 
 		if (!(pVBInfo->SetFlag & ReserveTVOption))
 			xgifb_reg_set(pVBInfo->P3d4, 0x3e, tempch);
@@ -4118,7 +4118,7 @@ void XGI_DisplayOn(struct xgi_hw_device_info *pXGIHWDE,
 		struct vb_device_info *pVBInfo)
 {
 
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xDF, 0x00);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xDF, 0x00);
 	if (pXGIHWDE->jChipType == XG21) {
 		if (pVBInfo->IF_DEF_LVDS == 1) {
 			if (!(XGI_XG21GetPSCValue(pVBInfo) & 0x1)) {
@@ -4185,7 +4185,7 @@ void XGI_DisplayOff(struct xgi_hw_device_info *pXGIHWDE,
 			XGI_XG27BLSignalVDD(0x20, 0x00, pVBInfo); /* DVO/DVI signal off */
 	}
 
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xDF, 0x20);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xDF, 0x20);
 }
 
 static void XGI_WaitDisply(struct vb_device_info *pVBInfo)
@@ -4218,7 +4218,7 @@ static void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBIn
 	xgifb_reg_set(pVBInfo->P3d4, 0x34, ModeNo); /* reserve CR34 for CRT1 Mode No */
 	temp1 = (pVBInfo->VBInfo & SetInSlaveMode) >> 8;
 	temp2 = ~(SetInSlaveMode >> 8);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x31, temp2, temp1);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x31, temp2, temp1);
 }
 
 static void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -4658,7 +4658,7 @@ static void XGI_SetCRT2Offset(unsigned short ModeNo,
 static void XGI_SetCRT2FIFO(struct vb_device_info *pVBInfo)
 {
 	xgifb_reg_set(pVBInfo->Part1Port, 0x01, 0x3B); /* threshold high ,disable auto threshold */
-	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x02, ~(0x3F), 0x04); /* threshold low default 04h */
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x02, ~(0x3F), 0x04); /* threshold low default 04h */
 }
 
 static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -4710,7 +4710,7 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = (pVBInfo->VGAHT / 2 - 1) & 0x0FF; /* BTVGA2HT 0x08,0x09 */
 		xgifb_reg_set(pVBInfo->Part1Port, 0x08, temp);
 		temp = (((pVBInfo->VGAHT / 2 - 1) & 0xFF00) >> 8) << 4;
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
 		temp = (pVBInfo->VGAHDE / 2 + 16) & 0x0FF; /* BTVGA2HDEE 0x0A,0x0C */
 		xgifb_reg_set(pVBInfo->Part1Port, 0x0A, temp);
 		tempcx = ((pVBInfo->VGAHT - pVBInfo->VGAHDE) / 2) >> 2;
@@ -4744,7 +4744,7 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = (pVBInfo->VGAHT - 1) & 0x0FF; /* BTVGA2HT 0x08,0x09 */
 		xgifb_reg_set(pVBInfo->Part1Port, 0x08, temp);
 		temp = (((pVBInfo->VGAHT - 1) & 0xFF00) >> 8) << 4;
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
 		temp = (pVBInfo->VGAHDE + 16) & 0x0FF; /* BTVGA2HDEE 0x0A,0x0C */
 		xgifb_reg_set(pVBInfo->Part1Port, 0x0A, temp);
 		tempcx = (pVBInfo->VGAHT - pVBInfo->VGAHDE) >> 2; /* cx */
@@ -4836,7 +4836,7 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (modeflag & HalfDCLK)
 		tempax |= 0x40;
 
-	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2C, ~0x0C0, tempax);
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x2C, ~0x0C0, tempax);
 }
 
 static unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo)
@@ -5052,7 +5052,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	xgifb_reg_set(pVBInfo->Part1Port, 0x18, 0x03); /* 0x18 SR0B */
-	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, 0xF0, 0x00);
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0xF0, 0x00);
 	xgifb_reg_set(pVBInfo->Part1Port, 0x09, 0xFF); /* 0x09 Set Max VT */
 
 	tempbx = pVBInfo->VGAVT;
@@ -5183,7 +5183,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx |= 0x0008;
 
 	if (tempbx & 0x0200)
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x0B, 0x0FF, 0x20);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x0B, 0x0FF, 0x20);
 
 	tempbx++;
 
@@ -5311,11 +5311,11 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		xgifb_reg_set(pVBInfo->Part2Port, i, TimingPoint[j]); /* di->temp2[j] */
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV)
-		XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x3A, 0x1F, 0x00);
+		xgifb_reg_and_or(pVBInfo->Part2Port, 0x3A, 0x1F, 0x00);
 
 	temp = pVBInfo->NewFlickerMode;
 	temp &= 0x80;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x0A, 0xFF, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0A, 0xFF, temp);
 
 	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
 		tempax = 950;
@@ -5379,7 +5379,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part2Port, 0x1B, temp);
 
 	temp = (tempcx & 0xFF00) >> 8;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x1D, ~0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x1D, ~0x0F, temp);
 
 	tempcx = pVBInfo->HT >> 1;
 	push1 = tempcx; /* push cx */
@@ -5390,7 +5390,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	temp = tempcx & 0x00FF;
 	temp = temp << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x22, 0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x22, 0x0F, temp);
 
 	tempbx = TimingPoint[j] | ((TimingPoint[j + 1]) << 8);
 	tempbx += tempcx;
@@ -5399,7 +5399,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part2Port, 0x24, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp = temp << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x25, 0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x25, 0x0F, temp);
 
 	tempbx = push2;
 	tempbx = tempbx + 8;
@@ -5409,14 +5409,14 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	temp = (tempbx & 0x00FF) << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x29, 0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x29, 0x0F, temp);
 
 	j += 2;
 	tempcx += (TimingPoint[j] | ((TimingPoint[j + 1]) << 8));
 	temp = tempcx & 0x00FF;
 	xgifb_reg_set(pVBInfo->Part2Port, 0x27, temp);
 	temp = ((tempcx & 0xFF00) >> 8) << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x28, 0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x28, 0x0F, temp);
 
 	tempcx += 8;
 	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
@@ -5424,7 +5424,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	temp = tempcx & 0xFF;
 	temp = temp << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x2A, 0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x2A, 0x0F, temp);
 
 	tempcx = push1; /* pop cx */
 	j += 2;
@@ -5432,7 +5432,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempcx -= temp;
 	temp = tempcx & 0x00FF;
 	temp = temp << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x2D, 0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x2D, 0x0F, temp);
 
 	tempcx -= 11;
 
@@ -5599,7 +5599,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	xgifb_reg_set(pVBInfo->Part2Port, 0x44, temp);
 	temp = (tempbx & 0xFF00) >> 8;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x45, ~0x03F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x45, ~0x03F, temp);
 	temp = tempcx & 0x00FF;
 
 	if (tempbx & 0x2000)
@@ -5608,7 +5608,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (!(pVBInfo->VBInfo & SetCRT2ToLCD))
 		temp |= 0x18;
 
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x46, ~0x1F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x46, ~0x1F, temp);
 	if (pVBInfo->TVInfo & SetPALTV) {
 		tempbx = 0x0382;
 		tempcx = 0x007e;
@@ -5654,7 +5654,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	/* [ycchen] 01/14/03 Modify for 301C PALM Support */
 	if (pVBInfo->VBType & VB_XGI301C) {
 		if (pVBInfo->TVInfo & SetPALMTV)
-			XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x4E, ~0x08,
+			xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x08,
 					0x08); /* PALM Mode */
 	}
 
@@ -5711,7 +5711,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part2Port, 0x2C, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp = temp << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x2B, 0x0F, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x2B, 0x0F, temp);
 	temp = 0x01;
 
 	if (pVBInfo->LCDResInfo == Panel1280x1024) {
@@ -5731,7 +5731,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = tempbx & 0x00FF;
 	xgifb_reg_set(pVBInfo->Part2Port, 0x03, temp);
 	temp = ((tempbx & 0xFF00) >> 8) & 0x07;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x0C, ~0x07, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0C, ~0x07, temp);
 
 	tempcx = pVBInfo->VT - 1;
 	push2 = tempcx + 1;
@@ -5740,10 +5740,10 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = (tempcx & 0xFF00) >> 8;
 	temp = temp << 5;
 	xgifb_reg_set(pVBInfo->Part2Port, 0x1A, temp);
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x09, 0xF0, 0x00);
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x0A, 0xF0, 0x00);
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x17, 0xFB, 0x00);
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x18, 0xDF, 0x00);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x09, 0xF0, 0x00);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0A, 0xF0, 0x00);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x17, 0xFB, 0x00);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x18, 0xDF, 0x00);
 
 	/* Customized LCDB Des no add */
 	tempbx = 5;
@@ -5867,7 +5867,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	temp = (tempbx & 0xFF00) >> 8;
 	temp = temp << 4;
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x1D, ~0x0F0, temp);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x1D, ~0x0F0, temp);
 	temp = tempcx & 0x00FF; /* RHSYEXP2S=lcdhre */
 	xgifb_reg_set(pVBInfo->Part2Port, 0x21, temp);
 
@@ -5972,9 +5972,9 @@ static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 	}
 
 	if ((pVBInfo->VBInfo & SetCRT2ToTV) && (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)))
-		XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x4E, ~0x14, 0x04); /* Enable V.Scaling */
+		xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x14, 0x04); /* Enable V.Scaling */
 	else
-		XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x4E, ~0x14, 0x10); /* Enable H.Scaling */
+		xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x14, 0x10); /* Enable H.Scaling */
 #endif
 }
 
@@ -6109,7 +6109,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->VGAHDE == 1024)
 			temp = 0x20;
 	}
-	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x0E, ~0xEF, temp);
+	xgifb_reg_and_or(pVBInfo->Part4Port, 0x0E, ~0xEF, temp);
 
 	tempebx = pVBInfo->VDE;
 
@@ -6223,13 +6223,13 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 			}
 		}
 
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x1F, 0x00C0, temp);
+		xgifb_reg_and_or(pVBInfo->Part4Port, 0x1F, 0x00C0, temp);
 		tempbx = pVBInfo->HT;
 		if (XGI_IsLCDDualLink(pVBInfo))
 			tempbx = tempbx >> 1;
 		tempbx = (tempbx >> 1) - 2;
 		temp = ((tempbx & 0x0700) >> 8) << 3;
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x21, 0x00C0, temp);
+		xgifb_reg_and_or(pVBInfo->Part4Port, 0x21, 0x00C0, temp);
 		temp = tempbx & 0x00FF;
 		xgifb_reg_set(pVBInfo->Part4Port, 0x22, temp);
 	}
@@ -6242,7 +6242,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo)
 {
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1E, 0xFF, 0x20);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x1E, 0xFF, 0x20);
 }
 
 static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -6265,14 +6265,14 @@ static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 static void XGI_EnableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x63, 0xBF, 0x40);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x63, 0xBF, 0x40);
 }
 
 static void XGI_DisableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x63, 0xBF, 0x00);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x63, 0xBF, 0x00);
 }
 
 /*----------------------------------------------------------------------------*/
@@ -6297,7 +6297,7 @@ void XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	if (tempbh & 0x20) {
 		temp = (tempbl >> 4) & 0x02;
 
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0xB4, ~0x02, temp); /* CR B4[1] */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~0x02, temp); /* CR B4[1] */
 
 	}
 
@@ -6325,10 +6325,10 @@ void XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	if (tempbh & 0x20) {
 		temp = (tempbl >> 4) & 0x02;
 
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0xB4, ~0x02, temp); /* CR B4[1] */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~0x02, temp); /* CR B4[1] */
 
 	}
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0xB4, ~tempbh0, tempbl0);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~tempbh0, tempbl0);
 
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	tempbh &= 0x03;
@@ -6336,7 +6336,7 @@ void XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	tempbh <<= 2;
 	tempbl <<= 2; /* GPIOC,GPIOD */
 	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~tempbh); /* enable GPIO write */
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x48, ~tempbh, tempbl);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x48, ~tempbh, tempbl);
 }
 
 /* --------------------------------------------------------------------- */
@@ -6439,8 +6439,8 @@ void XGI_SetXG21FPBits(struct vb_device_info *pVBInfo)
 
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37); /* D[0] 1: 18bit */
 	temp = (temp & 1) << 6;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x06, ~0x40, temp); /* SR06[6] 18bit Dither */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: dual 12bits */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x06, ~0x40, temp); /* SR06[6] 18bit Dither */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: dual 12bits */
 
 }
 
@@ -6450,8 +6450,8 @@ void XGI_SetXG27FPBits(struct vb_device_info *pVBInfo)
 
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37); /* D[1:0] 01: 18bit, 00: dual 12, 10: single 24 */
 	temp = (temp & 3) << 6;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x06, ~0xc0, temp & 0x80); /* SR06[7]0: dual 12/1: single 24 [6] 18bit Dither <= 0 h/w recommend */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: 24bits */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x06, ~0xc0, temp & 0x80); /* SR06[7]0: dual 12/1: single 24 [6] 18bit Dither <= 0 h/w recommend */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: 24bits */
 
 }
 
@@ -6475,8 +6475,8 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
 					& LCDPolarity);
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80); /* SR35[7] FP VSync polarity */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1); /* SR30[5] FP HSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80); /* SR35[7] FP VSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1); /* SR30[5] FP HSync polarity */
 
 	XGI_SetXG21FPBits(pVBInfo);
 	resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
@@ -6543,81 +6543,81 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 	/* HT SR0B[1:0] CR00 */
 	value = (LVDSHT >> 3) - 5;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x03, (value & 0x300) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0B, ~0x03, (value & 0x300) >> 8);
 	xgifb_reg_set(pVBInfo->P3d4, 0x0, (value & 0xFF));
 
 	/* HBS SR0B[5:4] CR02 */
 	value = (LVDSHBS >> 3) - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x30, (value & 0x300) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0B, ~0x30, (value & 0x300) >> 4);
 	xgifb_reg_set(pVBInfo->P3d4, 0x2, (value & 0xFF));
 
 	/* HBE SR0C[1:0] CR05[7] CR03[4:0] */
 	value = (LVDSHBE >> 3) - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0C, ~0x03, (value & 0xC0) >> 6);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x05, ~0x80, (value & 0x20) << 2);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x03, ~0x1F, value & 0x1F);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0C, ~0x03, (value & 0xC0) >> 6);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x05, ~0x80, (value & 0x20) << 2);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x03, ~0x1F, value & 0x1F);
 
 	/* HRS SR0B[7:6] CR04 */
 	value = (LVDSHRS >> 3) + 2;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0xC0, (value & 0x300) >> 2);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0B, ~0xC0, (value & 0x300) >> 2);
 	xgifb_reg_set(pVBInfo->P3d4, 0x4, (value & 0xFF));
 
 	/* Panel HRS SR2F[1:0] SR2E[7:0]  */
 	value--;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x2F, ~0x03, (value & 0x300) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x2F, ~0x03, (value & 0x300) >> 8);
 	xgifb_reg_set(pVBInfo->P3c4, 0x2E, (value & 0xFF));
 
 	/* HRE SR0C[2] CR05[4:0] */
 	value = (LVDSHRE >> 3) + 2;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0C, ~0x04, (value & 0x20) >> 3);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x05, ~0x1F, value & 0x1F);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0C, ~0x04, (value & 0x20) >> 3);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x05, ~0x1F, value & 0x1F);
 
 	/* Panel HRE SR2F[7:2]  */
 	value--;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x2F, ~0xFC, value << 2);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x2F, ~0xFC, value << 2);
 
 	/* VT SR0A[0] CR07[5][0] CR06 */
 	value = LVDSVT - 2;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x01, (value & 0x400) >> 10);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x20, (value & 0x200) >> 4);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x01, (value & 0x100) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x01, (value & 0x400) >> 10);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x20, (value & 0x200) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x01, (value & 0x100) >> 8);
 	xgifb_reg_set(pVBInfo->P3d4, 0x06, (value & 0xFF));
 
 	/* VBS SR0A[2] CR09[5] CR07[3] CR15 */
 	value = LVDSVBS - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x04, (value & 0x400) >> 8);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x09, ~0x20, (value & 0x200) >> 4);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x08, (value & 0x100) >> 5);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x04, (value & 0x400) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x09, ~0x20, (value & 0x200) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x08, (value & 0x100) >> 5);
 	xgifb_reg_set(pVBInfo->P3d4, 0x15, (value & 0xFF));
 
 	/* VBE SR0A[4] CR16 */
 	value = LVDSVBE - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x10, (value & 0x100) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x10, (value & 0x100) >> 4);
 	xgifb_reg_set(pVBInfo->P3d4, 0x16, (value & 0xFF));
 
 	/* VRS SR0A[3] CR7[7][2] CR10 */
 	value = LVDSVRS - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x08, (value & 0x400) >> 7);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x80, (value & 0x200) >> 2);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x04, (value & 0x100) >> 6);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x08, (value & 0x400) >> 7);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x80, (value & 0x200) >> 2);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x04, (value & 0x100) >> 6);
 	xgifb_reg_set(pVBInfo->P3d4, 0x10, (value & 0xFF));
 
 	/* Panel VRS SR3F[1:0] SR34[7:0] SR33[0] */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x3F, ~0x03, (value & 0x600) >> 9);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0x03, (value & 0x600) >> 9);
 	xgifb_reg_set(pVBInfo->P3c4, 0x34, (value >> 1) & 0xFF);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x33, ~0x01, value & 0x01);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x33, ~0x01, value & 0x01);
 
 	/* VRE SR0A[5] CR11[3:0] */
 	value = LVDSVRE - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x20, (value & 0x10) << 1);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x11, ~0x0F, value & 0x0F);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x20, (value & 0x10) << 1);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x11, ~0x0F, value & 0x0F);
 
 	/* Panel VRE SR3F[7:2] *//* SR3F[7] has to be 0, h/w bug */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x3F, ~0xFC, (value << 2) & 0x7C);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, (value << 2) & 0x7C);
 
 	for (temp = 0, value = 0; temp < 3; temp++) {
 
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, value);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x31, ~0x30, value);
 		xgifb_reg_set(pVBInfo->P3c4,
 				0x2B,
 				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData1);
@@ -6660,8 +6660,8 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
 					& LCDPolarity);
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80); /* SR35[7] FP VSync polarity */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1); /* SR30[5] FP HSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80); /* SR35[7] FP VSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1); /* SR30[5] FP HSync polarity */
 
 	XGI_SetXG27FPBits(pVBInfo);
 	resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
@@ -6728,80 +6728,80 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 	/* HT SR0B[1:0] CR00 */
 	value = (LVDSHT >> 3) - 5;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x03, (value & 0x300) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0B, ~0x03, (value & 0x300) >> 8);
 	xgifb_reg_set(pVBInfo->P3d4, 0x0, (value & 0xFF));
 
 	/* HBS SR0B[5:4] CR02 */
 	value = (LVDSHBS >> 3) - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x30, (value & 0x300) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0B, ~0x30, (value & 0x300) >> 4);
 	xgifb_reg_set(pVBInfo->P3d4, 0x2, (value & 0xFF));
 
 	/* HBE SR0C[1:0] CR05[7] CR03[4:0] */
 	value = (LVDSHBE >> 3) - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0C, ~0x03, (value & 0xC0) >> 6);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x05, ~0x80, (value & 0x20) << 2);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x03, ~0x1F, value & 0x1F);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0C, ~0x03, (value & 0xC0) >> 6);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x05, ~0x80, (value & 0x20) << 2);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x03, ~0x1F, value & 0x1F);
 
 	/* HRS SR0B[7:6] CR04 */
 	value = (LVDSHRS >> 3) + 2;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0xC0, (value & 0x300) >> 2);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0B, ~0xC0, (value & 0x300) >> 2);
 	xgifb_reg_set(pVBInfo->P3d4, 0x4, (value & 0xFF));
 
 	/* Panel HRS SR2F[1:0] SR2E[7:0]  */
 	value--;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x2F, ~0x03, (value & 0x300) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x2F, ~0x03, (value & 0x300) >> 8);
 	xgifb_reg_set(pVBInfo->P3c4, 0x2E, (value & 0xFF));
 
 	/* HRE SR0C[2] CR05[4:0] */
 	value = (LVDSHRE >> 3) + 2;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0C, ~0x04, (value & 0x20) >> 3);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x05, ~0x1F, value & 0x1F);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0C, ~0x04, (value & 0x20) >> 3);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x05, ~0x1F, value & 0x1F);
 
 	/* Panel HRE SR2F[7:2]  */
 	value--;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x2F, ~0xFC, value << 2);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x2F, ~0xFC, value << 2);
 
 	/* VT SR0A[0] CR07[5][0] CR06 */
 	value = LVDSVT - 2;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x01, (value & 0x400) >> 10);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x20, (value & 0x200) >> 4);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x01, (value & 0x100) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x01, (value & 0x400) >> 10);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x20, (value & 0x200) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x01, (value & 0x100) >> 8);
 	xgifb_reg_set(pVBInfo->P3d4, 0x06, (value & 0xFF));
 
 	/* VBS SR0A[2] CR09[5] CR07[3] CR15 */
 	value = LVDSVBS - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x04, (value & 0x400) >> 8);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x09, ~0x20, (value & 0x200) >> 4);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x08, (value & 0x100) >> 5);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x04, (value & 0x400) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x09, ~0x20, (value & 0x200) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x08, (value & 0x100) >> 5);
 	xgifb_reg_set(pVBInfo->P3d4, 0x15, (value & 0xFF));
 
 	/* VBE SR0A[4] CR16 */
 	value = LVDSVBE - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x10, (value & 0x100) >> 4);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x10, (value & 0x100) >> 4);
 	xgifb_reg_set(pVBInfo->P3d4, 0x16, (value & 0xFF));
 
 	/* VRS SR0A[3] CR7[7][2] CR10 */
 	value = LVDSVRS - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x08, (value & 0x400) >> 7);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x80, (value & 0x200) >> 2);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x04, (value & 0x100) >> 6);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x08, (value & 0x400) >> 7);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x80, (value & 0x200) >> 2);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x04, (value & 0x100) >> 6);
 	xgifb_reg_set(pVBInfo->P3d4, 0x10, (value & 0xFF));
 
 	/* Panel VRS SR35[2:0] SR34[7:0] */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x07, (value & 0x700) >> 8);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x07, (value & 0x700) >> 8);
 	xgifb_reg_set(pVBInfo->P3c4, 0x34, value & 0xFF);
 
 	/* VRE SR0A[5] CR11[3:0] */
 	value = LVDSVRE - 1;
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x20, (value & 0x10) << 1);
-	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x11, ~0x0F, value & 0x0F);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x0A, ~0x20, (value & 0x10) << 1);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x11, ~0x0F, value & 0x0F);
 
 	/* Panel VRE SR3F[7:2] */
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x3F, ~0xFC, (value << 2) & 0xFC);
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, (value << 2) & 0xFC);
 
 	for (temp = 0, value = 0; temp < 3; temp++) {
 
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, value);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x31, ~0x30, value);
 		xgifb_reg_set(pVBInfo->P3c4,
 				0x2B,
 				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData1);
@@ -7152,7 +7152,7 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 							pVBInfo)].LCD_DelayCompensation; /* / Get LCD Delay */
 			tempah &= 0x0f;
 			tempah = tempah << 4;
-			XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2D, 0x0f,
+			xgifb_reg_and_or(pVBInfo->Part1Port, 0x2D, 0x0f,
 					tempah);
 		}
 	}
@@ -7165,22 +7165,22 @@ static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInf
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
 
 	if (temp & LCDRGB18Bit) {
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, 0x0F,
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F,
 				(unsigned short) (0x20 | (tempcx & 0x00C0))); /* Enable Dither */
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x1A, 0x7F, 0x80);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x1A, 0x7F, 0x80);
 	} else {
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, 0x0F,
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F,
 				(unsigned short) (0x30 | (tempcx & 0x00C0)));
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x1A, 0x7F, 0x00);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x1A, 0x7F, 0x00);
 	}
 
 	/*
 	if (tempcx & EnableLCD24bpp) {	// 24bits
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, 0x0F, (unsigned short)(0x30 | (tempcx&0x00C0)));
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x1A, 0x7F, 0x00);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F, (unsigned short)(0x30 | (tempcx&0x00C0)));
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x1A, 0x7F, 0x00);
 	} else {
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, 0x0F, (unsigned short)(0x20 | (tempcx&0x00C0))); // Enable Dither
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x1A, 0x7F, 0x80);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F, (unsigned short)(0x20 | (tempcx&0x00C0))); // Enable Dither
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x1A, 0x7F, 0x80);
 	}
 	*/
 }
@@ -7194,11 +7194,11 @@ static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInf
 static void XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo)
 {
 	if (tempcx & EnableLCD24bpp) /* 24bits */
-		XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x1A, 0xE0,
+		xgifb_reg_and_or(pVBInfo->Part2Port, 0x1A, 0xE0,
 				(unsigned short) (((tempcx & 0x00ff) >> 6)
 						| 0x0c));
 	else
-		XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x1A, 0xE0,
+		xgifb_reg_and_or(pVBInfo->Part2Port, 0x1A, 0xE0,
 				(unsigned short) (((tempcx & 0x00ff) >> 6)
 						| 0x18)); /* Enable Dither */
 }
@@ -7240,7 +7240,7 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 					(unsigned char) (tempcx & 0x1F));
 		}
 		/* VB Driving */
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x0D,
+		xgifb_reg_and_or(pVBInfo->Part4Port, 0x0D,
 				~((EnableVBCLKDRVLOW | EnablePLLSPLOW) >> 8),
 				(unsigned short) ((tempcx & (EnableVBCLKDRVLOW
 						| EnablePLLSPLOW)) >> 8));
@@ -7291,7 +7291,7 @@ static void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex
 	tempah = TVAntiFlickList[tempbx];
 	tempah = tempah << 4;
 
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x0A, 0x8F, tempah);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0A, 0x8F, tempah);
 }
 
 static void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -7313,7 +7313,7 @@ static void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex
 	tempah = TVEdgeList[tempbx];
 	tempah = tempah << 5;
 
-	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x3A, 0x1F, tempah);
+	xgifb_reg_and_or(pVBInfo->Part2Port, 0x3A, 0x1F, tempah);
 }
 
 static void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo)
@@ -7518,7 +7518,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	tempbl = 0xf0;
 
 	if (pVBInfo->VBInfo & DisableCRT2Display) {
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2e, tempbl, tempah);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e, tempbl, tempah);
 	} else {
 		tempah = 0x00;
 		tempbl = 0xff;
@@ -7529,7 +7529,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 					&& (!(pVBInfo->VBInfo & SetSimuScanMode))) {
 				tempbl &= 0xf7;
 				tempah |= 0x01;
-				XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2e,
+				xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e,
 						tempbl, tempah);
 			} else {
 				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
@@ -7555,15 +7555,15 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 					if (!(pVBInfo->VBInfo
 							& SetCRT2ToDualEdge))
 						tempah |= 0x08;
-					XGINew_SetRegANDOR(pVBInfo->Part1Port,
+					xgifb_reg_and_or(pVBInfo->Part1Port,
 							0x2e, tempbl, tempah);
 				} else {
-					XGINew_SetRegANDOR(pVBInfo->Part1Port,
+					xgifb_reg_and_or(pVBInfo->Part1Port,
 							0x2e, tempbl, tempah);
 				}
 			}
 		} else {
-			XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2e, tempbl,
+			xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e, tempbl,
 					tempah);
 		}
 	}
@@ -7587,7 +7587,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 			/* } */
 		}
 
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x0D, ~0x0BF, tempah);
+		xgifb_reg_and_or(pVBInfo->Part4Port, 0x0D, ~0x0BF, tempah);
 		tempah = 0;
 
 		if (pVBInfo->LCDInfo & SetLCDDualLink)
@@ -7621,7 +7621,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 				tempah |= 0x04; /* shampoo 0129 */
 		}
 
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x13, tempbl, tempah);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x13, tempbl, tempah);
 		tempah = 0x00;
 		tempbl = 0xcf;
 		if (!(pVBInfo->VBInfo & DisableCRT2Display)) {
@@ -7629,7 +7629,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 				tempah |= 0x30;
 		}
 
-		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2c, tempbl, tempah);
+		xgifb_reg_and_or(pVBInfo->Part1Port, 0x2c, tempbl, tempah);
 		tempah = 0;
 		tempbl = 0x3f;
 
@@ -7637,7 +7637,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 			if (pVBInfo->VBInfo & SetCRT2ToDualEdge)
 				tempah |= 0xc0;
 		}
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x21, tempbl, tempah);
+		xgifb_reg_and_or(pVBInfo->Part4Port, 0x21, tempbl, tempah);
 	}
 
 	tempah = 0;
@@ -7648,7 +7648,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 			tempah |= 0x80;
 	}
 
-	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x23, tempbl, tempah);
+	xgifb_reg_and_or(pVBInfo->Part4Port, 0x23, tempbl, tempah);
 
 	if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
 		if (pVBInfo->LCDInfo & SetLCDDualLink) {
@@ -7681,7 +7681,7 @@ void XGI_UnLockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 
-	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2f, 0xFF, 0x01);
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x2f, 0xFF, 0x01);
 
 }
 
@@ -7689,7 +7689,7 @@ void XGI_LockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 
-	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2F, 0xFE, 0x00);
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x2F, 0xFE, 0x00);
 
 }
 
@@ -8013,9 +8013,9 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	temp = inb(pVBInfo->P3c2);
 
 	if (temp & 0x10)
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x20);
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, 0xDF, 0x20);
 	else
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x00);
+		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, 0xDF, 0x00);
 
 	/* alan, avoid display something, set BLACK DAC if not restore DAC */
 	outb(0x00, pVBInfo->P3c8);
@@ -8091,7 +8091,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 
 		if ((pVBInfo->SetFlag & (EnableChA | EnableChB))
 				|| (!(pVBInfo->VBInfo & DisableCRT2Display))) {
-			XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x00, ~0xE0,
+			xgifb_reg_and_or(pVBInfo->Part2Port, 0x00, ~0xE0,
 					0x20); /* shampoo 0129 */
 			if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
 				if (!XGI_DisableChISLCD(pVBInfo)) {
@@ -8442,7 +8442,7 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
 		/*
 		if (HwDeviceExtension->jChipType == XG21)
-			XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0x80, 0x80);
+			xgifb_reg_and_or(pVBInfo->P3c4, 0x09, ~0x80, 0x80);
 		*/
 	}
 
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index f9605dd..9eb8060 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -24,7 +24,7 @@ unsigned char xgifb_reg_get(unsigned long port, unsigned short index)
 	return data;
 }
 
-void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
+void xgifb_reg_and_or(unsigned long Port, unsigned short Index,
 		unsigned short DataAND, unsigned short DataOR)
 {
 	unsigned short temp;
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 6bcdca8..e8e36a2 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -4,6 +4,6 @@ extern void xgifb_reg_set(unsigned long, unsigned short, unsigned short);
 extern unsigned char xgifb_reg_get(unsigned long, unsigned short);
 extern void xgifb_reg_or(unsigned long, unsigned short, unsigned short);
 extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
-extern   void     XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,unsigned short DataAND,unsigned short DataOR);
+extern void xgifb_reg_and_or(unsigned long, unsigned short, unsigned short, unsigned short);
 #endif
 
-- 
1.5.6.5

