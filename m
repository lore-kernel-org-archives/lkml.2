Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1CMK12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:28 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39909 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1CMK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:26 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 19/24] staging: xgifb: rename XGINew_GetReg1() to xgifb_reg_get()
Date: Sun, 13 Mar 2011 12:26:23 +0200
Message-Id: <1300011988-2109-20-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename XGINew_GetReg1() to xgifb_reg_get().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.c     |   28 +++---
 drivers/staging/xgifb/vb_init.c    |   98 +++++++++---------
 drivers/staging/xgifb/vb_setmode.c |  200 ++++++++++++++++++------------------
 drivers/staging/xgifb/vb_util.c    |    8 +-
 drivers/staging/xgifb/vb_util.h    |    2 +-
 5 files changed, 168 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index a299864..3a37105 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -18,7 +18,7 @@ static unsigned char XGINew_Is301B(struct vb_device_info *pVBInfo)
 {
 	unsigned short flag;
 
-	flag = XGINew_GetReg1(pVBInfo->Part4Port, 0x01);
+	flag = xgifb_reg_get(pVBInfo->Part4Port, 0x01);
 
 	if (flag > 0x0B0)
 		return 0; /* 301b */
@@ -40,7 +40,7 @@ static unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx,
 		XGI_LongWait(pVBInfo);
 
 	tempch = (tempcx & 0x7F00) >> 8;
-	temp = XGINew_GetReg1(pVBInfo->Part4Port, 0x03);
+	temp = xgifb_reg_get(pVBInfo->Part4Port, 0x03);
 	temp = temp ^ (0x0E);
 	temp &= tempch;
 
@@ -114,7 +114,7 @@ static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 	unsigned short tempax, tempbx, temp;
 	/* unsigned short return_flag; */
 
-	tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x1A);
+	tempax = xgifb_reg_get(pVBInfo->P3c4, 0x1A);
 	tempbx = tempax & 0x1E;
 
 	if (tempax == 0)
@@ -124,7 +124,7 @@ static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 		if (!(tempax & 0x10)) {
 			if (pVBInfo->IF_DEF_LVDS == 1) {
 				tempbx = 0;
-				temp = XGINew_GetReg1(pVBInfo->P3c4, 0x38);
+				temp = xgifb_reg_get(pVBInfo->P3c4, 0x38);
 				if (temp & 0x40)
 					tempbx |= 0x08;
 				if (temp & 0x20)
@@ -132,7 +132,7 @@ static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 				if (temp & 0x01)
 					tempbx |= 0x01;
 
-				temp = XGINew_GetReg1(pVBInfo->P3c4, 0x39);
+				temp = xgifb_reg_get(pVBInfo->P3c4, 0x39);
 				if (temp & 0x80)
 					tempbx |= 0x04;
 			 } else {
@@ -159,7 +159,7 @@ static unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *HwDeviceEx
 	unsigned short flag;
 
 	if (XGI_BridgeIsOn(pVBInfo) == 0) {
-		flag = XGINew_GetReg1(pVBInfo->Part1Port, 0x0);
+		flag = xgifb_reg_get(pVBInfo->Part1Port, 0x0);
 
 		if (flag & 0x050)
 			return 1;
@@ -188,7 +188,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 		XGI_LongWait(pVBInfo);
 
 	tempch = (tempcx & 0xFF00) >> 8;
-	temp = XGINew_GetReg1(pVBInfo->Part4Port, 0x03);
+	temp = xgifb_reg_get(pVBInfo->Part4Port, 0x03);
 	temp = temp ^ (0x0E);
 	temp &= tempch;
 
@@ -208,7 +208,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 		XGI_LongWait(pVBInfo);
 
 	tempch = (tempcx & 0xFF00) >> 8;
-	temp = XGINew_GetReg1(pVBInfo->Part4Port, 0x03);
+	temp = xgifb_reg_get(pVBInfo->Part4Port, 0x03);
 	temp = temp ^ (0x0E);
 	temp &= tempch;
 
@@ -227,7 +227,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 			XGI_LongWait(pVBInfo);
 
 		tempch = (tempcx & 0xFF00) >> 8;
-		temp = XGINew_GetReg1(pVBInfo->Part4Port, 0x03);
+		temp = xgifb_reg_get(pVBInfo->Part4Port, 0x03);
 		temp = temp ^ (0x0E);
 		temp &= tempch;
 
@@ -245,8 +245,8 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
 
 	if (pVBInfo->IF_DEF_LVDS == 1) {
-		tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x1A); /* ynlai 02/27/2002 */
-		tempbx = XGINew_GetReg1(pVBInfo->P3c4, 0x1B);
+		tempax = xgifb_reg_get(pVBInfo->P3c4, 0x1A); /* ynlai 02/27/2002 */
+		tempbx = xgifb_reg_get(pVBInfo->P3c4, 0x1B);
 		tempax = ((tempax & 0xFE) >> 1) | (tempbx << 8);
 		if (tempax == 0x00) { /* Get Panel id from DDC */
 			temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
@@ -266,14 +266,14 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, tempbx, temp);
 	} else { /* for 301 */
 		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) { /* for HiVision */
-			tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x38);
+			tempax = xgifb_reg_get(pVBInfo->P3c4, 0x38);
 			temp = tempax & 0x01;
-			tempax = XGINew_GetReg1(pVBInfo->P3c4, 0x3A);
+			tempax = xgifb_reg_get(pVBInfo->P3c4, 0x3A);
 			temp = temp | (tempax & 0x02);
 			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xA0, temp);
 		} else {
 			if (XGI_BridgeIsOn(pVBInfo)) {
-				P2reg0 = XGINew_GetReg1(pVBInfo->Part2Port, 0x00);
+				P2reg0 = xgifb_reg_get(pVBInfo->Part2Port, 0x00);
 				if (!XGINew_BridgeIsEnable(HwDeviceExtension, pVBInfo)) {
 					SenseModeNo = 0x2e;
 					/* xgifb_reg_set(pVBInfo->P3d4, 0x30, 0x41); */
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 07fa73d..7138a24 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -49,10 +49,10 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 			data = *pVBInfo->pSoftSetting & 0x07;
 			return data;
 		} else {
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x39) & 0x02;
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x39) & 0x02;
 
 			if (data == 0)
-				data = (XGINew_GetReg1(pVBInfo->P3c4, 0x3A) & 0x02) >> 1;
+				data = (xgifb_reg_get(pVBInfo->P3c4, 0x3A) & 0x02) >> 1;
 
 			return data;
 		}
@@ -61,7 +61,7 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 			data = *pVBInfo->pSoftSetting & 0x07;
 			return data;
 		}
-		temp = XGINew_GetReg1(pVBInfo->P3c4, 0x3B);
+		temp = xgifb_reg_get(pVBInfo->P3c4, 0x3B);
 
 		if ((temp & 0x88) == 0x80) /* SR3B[7][3]MAA15 MAA11 (Power on Trapping) */
 			data = 0; /* DDR */
@@ -72,7 +72,7 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 		XGINew_SetRegAND(pVBInfo->P3d4, 0xB4, ~0x02); /* Independent GPIO control */
 		udelay(800);
 		XGINew_SetRegOR(pVBInfo->P3d4, 0x4A, 0x80); /* Enable GPIOH read */
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48); /* GPIOF 0:DVI 1:DVO */
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x48); /* GPIOF 0:DVI 1:DVO */
 		/* HOTPLUG_SUPPORT */
 		/* for current XG20 & XG21, GPIOH is floating, driver will fix DDR temporarily */
 		if (temp & 0x01) /* DVI read GPIOH */
@@ -83,7 +83,7 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 		XGINew_SetRegOR(pVBInfo->P3d4, 0xB4, 0x02);
 		return data;
 	} else {
-		data = XGINew_GetReg1(pVBInfo->P3d4, 0x97) & 0x01;
+		data = xgifb_reg_get(pVBInfo->P3d4, 0x97) & 0x01;
 
 		if (data == 1)
 			data++;
@@ -143,7 +143,7 @@ static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))
 					|| ((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x22)
 						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))))
-			xgifb_reg_set(pVBInfo->P3c4, 0x32, ((unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
+			xgifb_reg_set(pVBInfo->P3c4, 0x32, ((unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
 	}
 }
 
@@ -327,15 +327,15 @@ static void XGINew_DDR1x_DefaultRegister(
 		default:
 			xgifb_reg_set(P3d4, 0x82, 0x88);
 			xgifb_reg_set(P3d4, 0x86, 0x00);
-			XGINew_GetReg1(P3d4, 0x86); /* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x86); /* Insert read command for delay */
 			xgifb_reg_set(P3d4, 0x86, 0x88);
-			XGINew_GetReg1(P3d4, 0x86);
+			xgifb_reg_get(P3d4, 0x86);
 			xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]);
 			xgifb_reg_set(P3d4, 0x82, 0x77);
 			xgifb_reg_set(P3d4, 0x85, 0x00);
-			XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
 			xgifb_reg_set(P3d4, 0x85, 0x88);
-			XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
 			xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
 			xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
 			break;
@@ -357,15 +357,15 @@ static void XGINew_DDR2_DefaultRegister(
 	/* keep following setting sequence, each setting in the same reg insert idle */
 	xgifb_reg_set(P3d4, 0x82, 0x77);
 	xgifb_reg_set(P3d4, 0x86, 0x00);
-	XGINew_GetReg1(P3d4, 0x86); /* Insert read command for delay */
+	xgifb_reg_get(P3d4, 0x86); /* Insert read command for delay */
 	xgifb_reg_set(P3d4, 0x86, 0x88);
-	XGINew_GetReg1(P3d4, 0x86); /* Insert read command for delay */
+	xgifb_reg_get(P3d4, 0x86); /* Insert read command for delay */
 	xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
 	xgifb_reg_set(P3d4, 0x82, 0x77);
 	xgifb_reg_set(P3d4, 0x85, 0x00);
-	XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
+	xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
 	xgifb_reg_set(P3d4, 0x85, 0x88);
-	XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
+	xgifb_reg_get(P3d4, 0x85); /* Insert read command for delay */
 	xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
 	if (HwDeviceExtension->jChipType == XG27)
 		xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
@@ -400,7 +400,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
 			temp2 |= temp1;
 			xgifb_reg_set(P3d4, 0x6B, temp2);
-			XGINew_GetReg1(P3d4, 0x6B); /* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x6B); /* Insert read command for delay */
 			temp2 &= 0xF0;
 			temp2 += 0x10;
 		}
@@ -413,7 +413,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
 			temp2 |= temp1;
 			xgifb_reg_set(P3d4, 0x6E, temp2);
-			XGINew_GetReg1(P3d4, 0x6E); /* Insert read command for delay */
+			xgifb_reg_get(P3d4, 0x6E); /* Insert read command for delay */
 			temp2 &= 0xF0;
 			temp2 += 0x10;
 		}
@@ -429,7 +429,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 				temp1 = (temp >> (2 * j)) & 0x03;
 				temp2 |= temp1;
 				xgifb_reg_set(P3d4, 0x6F, temp2);
-				XGINew_GetReg1(P3d4, 0x6F); /* Insert read command for delay */
+				xgifb_reg_get(P3d4, 0x6F); /* Insert read command for delay */
 				temp2 &= 0xF8;
 				temp2 += 0x08;
 			}
@@ -446,7 +446,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 		temp1 = (temp >> (2 * j)) & 0x03;
 		temp2 |= temp1;
 		xgifb_reg_set(P3d4, 0x89, temp2);
-		XGINew_GetReg1(P3d4, 0x89); /* Insert read command for delay */
+		xgifb_reg_get(P3d4, 0x89); /* Insert read command for delay */
 		temp2 &= 0xF0;
 		temp2 += 0x10;
 	}
@@ -530,7 +530,7 @@ static unsigned short XGINew_SetDRAMSizeReg(int index,
 	unsigned char ChannelNo;
 
 	RankSize = DRAMTYPE_TABLE[index][3] * XGINew_DataBusWidth / 32;
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x13);
+	data = xgifb_reg_get(pVBInfo->P3c4, 0x13);
 	data &= 0x80;
 
 	if (data == 0x80)
@@ -550,7 +550,7 @@ static unsigned short XGINew_SetDRAMSizeReg(int index,
 		memsize = data >> 4;
 
 		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
-		xgifb_reg_set(pVBInfo->P3c4, 0x14, (XGINew_GetReg1(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
+		xgifb_reg_set(pVBInfo->P3c4, 0x14, (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
 
 		/* data |= XGINew_ChannelAB << 2; */
 		/* data |= (XGINew_DataBusWidth / 64) << 1; */
@@ -571,7 +571,7 @@ static unsigned short XGINew_SetDRAMSize20Reg(int index,
 	unsigned char ChannelNo;
 
 	RankSize = DRAMTYPE_TABLE[index][3] * XGINew_DataBusWidth / 8;
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x13);
+	data = xgifb_reg_get(pVBInfo->P3c4, 0x13);
 	data &= 0x80;
 
 	if (data == 0x80)
@@ -591,7 +591,7 @@ static unsigned short XGINew_SetDRAMSize20Reg(int index,
 		memsize = data >> 4;
 
 		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
-		xgifb_reg_set(pVBInfo->P3c4, 0x14, (XGINew_GetReg1(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
+		xgifb_reg_set(pVBInfo->P3c4, 0x14, (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
 		udelay(15);
 
 		/* data |= XGINew_ChannelAB << 2; */
@@ -636,10 +636,10 @@ static unsigned char XGINew_CheckFrequence(struct vb_device_info *pVBInfo)
 {
 	unsigned char data;
 
-	data = XGINew_GetReg1(pVBInfo->P3d4, 0x97);
+	data = xgifb_reg_get(pVBInfo->P3d4, 0x97);
 
 	if ((data & 0x10) == 0) {
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x39);
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x39);
 		data = (data & 0x02) >> 1;
 		return data;
 	} else {
@@ -655,7 +655,7 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 	switch (HwDeviceExtension->jChipType) {
 	case XG20:
 	case XG21:
-		data = XGINew_GetReg1(pVBInfo->P3d4, 0x97);
+		data = xgifb_reg_get(pVBInfo->P3d4, 0x97);
 		data = data & 0x01;
 		XGINew_ChannelAB = 1; /* XG20 "JUST" one channel */
 
@@ -952,15 +952,15 @@ static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 
 	XGISetModeNew(HwDeviceExtension, 0x2e);
 
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
+	data = xgifb_reg_get(pVBInfo->P3c4, 0x21);
 	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF)); /* disable read cache */
 	XGI_DisplayOff(HwDeviceExtension, pVBInfo);
 
-	/* data = XGINew_GetReg1(pVBInfo->P3c4, 0x1); */
+	/* data = xgifb_reg_get(pVBInfo->P3c4, 0x1); */
 	/* data |= 0x20 ; */
 	/* xgifb_reg_set(pVBInfo->P3c4, 0x01, data); *//* Turn OFF Display */
 	XGINew_DDRSizing340(HwDeviceExtension, pVBInfo);
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
+	data = xgifb_reg_get(pVBInfo->P3c4, 0x21);
 	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
 }
 
@@ -1059,7 +1059,7 @@ static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 {
 	unsigned short tempbx = 0, temp, tempcx, CR3CData;
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x32);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x32);
 
 	if (temp & Monitor1Sense)
 		tempbx |= ActiveCRT1;
@@ -1081,11 +1081,11 @@ static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 			tempbx |= (ActiveYPbPr << 8);
 	}
 
-	tempcx = XGINew_GetReg1(pVBInfo->P3d4, 0x3d);
-	tempcx |= (XGINew_GetReg1(pVBInfo->P3d4, 0x3e) << 8);
+	tempcx = xgifb_reg_get(pVBInfo->P3d4, 0x3d);
+	tempcx |= (xgifb_reg_get(pVBInfo->P3d4, 0x3e) << 8);
 
 	if (tempbx & tempcx) {
-		CR3CData = XGINew_GetReg1(pVBInfo->P3d4, 0x3c);
+		CR3CData = xgifb_reg_get(pVBInfo->P3d4, 0x3c);
 		if (!(CR3CData & DisplayDeviceFromCMOS)) {
 			tempcx = 0x1FF0;
 			if (*pVBInfo->pSoftSetting & ModeSoftSetting)
@@ -1107,9 +1107,9 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 {
 	unsigned short temp, tempcl = 0, tempch = 0, CR31Data, CR38Data;
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x3d);
-	temp |= XGINew_GetReg1(pVBInfo->P3d4, 0x3e) << 8;
-	temp |= (XGINew_GetReg1(pVBInfo->P3d4, 0x31) & (DriverMode >> 8)) << 8;
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x3d);
+	temp |= xgifb_reg_get(pVBInfo->P3d4, 0x3e) << 8;
+	temp |= (xgifb_reg_get(pVBInfo->P3d4, 0x31) & (DriverMode >> 8)) << 8;
 
 	if (pVBInfo->IF_DEF_CRT2Monitor == 1) {
 		if (temp & ActiveCRT2)
@@ -1168,7 +1168,7 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 		tempcl ^= (SetSimuScanMode | SwitchToCRT2);
 	xgifb_reg_set(pVBInfo->P3d4, 0x30, tempcl);
 
-	CR31Data = XGINew_GetReg1(pVBInfo->P3d4, 0x31);
+	CR31Data = xgifb_reg_get(pVBInfo->P3d4, 0x31);
 	CR31Data &= ~(SetNotSimuMode >> 8);
 	if (!(temp & ActiveCRT1))
 		CR31Data |= (SetNotSimuMode >> 8);
@@ -1177,7 +1177,7 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 		CR31Data |= (DisableCRT2Display >> 8);
 	xgifb_reg_set(pVBInfo->P3d4, 0x31, CR31Data);
 
-	CR38Data = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
+	CR38Data = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 	CR38Data &= ~SetYPbPr;
 	CR38Data |= tempch;
 	xgifb_reg_set(pVBInfo->P3d4, 0x38, CR38Data);
@@ -1201,12 +1201,12 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 	} else {
 #endif
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* Enable GPIOA/B read  */
-		Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48) & 0xC0;
+		Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0xC0;
 		if (Temp == 0xC0) { /* DVI & DVO GPIOA/B pull high */
 			XGINew_SenseLCD(HwDeviceExtension, pVBInfo);
 			XGINew_SetRegOR(pVBInfo->P3d4, 0x32, LCDSense);
 			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x20, 0x20); /* Enable read GPIOF */
-			Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48) & 0x04;
+			Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x04;
 			if (!Temp)
 				XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0x80); /* TMDS on chip */
 			else
@@ -1224,9 +1224,9 @@ static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
 	unsigned char Temp, bCR4A;
 
 	pVBInfo->IF_DEF_LVDS = 0;
-	bCR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	bCR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x07, 0x07); /* Enable GPIOA/B/C read  */
-	Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48) & 0x07;
+	Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x07;
 	xgifb_reg_set(pVBInfo->P3d4, 0x4A, bCR4A);
 
 	if (Temp <= 0x02) {
@@ -1244,12 +1244,12 @@ static unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR38, CR4A, temp;
 
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x10, 0x10); /* enable GPIOE read */
-	CR38 = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
+	CR38 = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 	temp = 0;
 	if ((CR38 & 0xE0) > 0x80) {
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 		temp &= 0x08;
 		temp >>= 3;
 	}
@@ -1263,9 +1263,9 @@ static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR4A, temp;
 
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x03, 0x03); /* enable GPIOA/B/C read */
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 	if (temp <= 2)
 		temp &= 0x03;
 	else
@@ -1424,7 +1424,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
 		/* Set AGP Rate */
 		/*
-		temp1 = XGINew_GetReg1(pVBInfo->P3c4, 0x3B);
+		temp1 = xgifb_reg_get(pVBInfo->P3c4, 0x3B);
 		temp1 &= 0x02;
 		if (temp1 == 0x02) {
 			outl(0x80000000, 0xcf8);
@@ -1492,7 +1492,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
 		XGINew_SetRegANDOR(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00); /* alan, disable VideoCapture */
 		xgifb_reg_set(pVBInfo->Part1Port, 0x00, 0x00);
-		temp1 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x7B); /* chk if BCLK>=100MHz */
+		temp1 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x7B); /* chk if BCLK>=100MHz */
 		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
 
 		xgifb_reg_set(pVBInfo->Part1Port, 0x02, (*pVBInfo->pCRT2Data_1_2));
@@ -1577,7 +1577,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	/* SetDefExt2Regs begin */
 	/*
 	AGP = 1;
-	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x3A);
+	temp = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x3A);
 	temp &= 0x30;
 	if (temp == 0x30)
 		AGP = 0;
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 4cca02d..cef0cf7 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -274,7 +274,7 @@ static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	unsigned char CRTCdata;
 	unsigned short i;
 
-	CRTCdata = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
+	CRTCdata = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	CRTCdata &= 0x7f;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, CRTCdata); /* Unlock CRTC */
 
@@ -345,7 +345,7 @@ static void XGI_SetGRCRegs(unsigned short StandTableIndex,
 	}
 
 	if (pVBInfo->ModeType > ModeVGA) {
-		GRdata = (unsigned char) XGINew_GetReg1(pVBInfo->P3ce, 0x05);
+		GRdata = (unsigned char) xgifb_reg_get(pVBInfo->P3ce, 0x05);
 		GRdata &= 0xBF; /* 256 color disable */
 		xgifb_reg_set(pVBInfo->P3ce, 0x05, GRdata);
 	}
@@ -538,7 +538,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	/* xgifb_reg_set(pVBInfo->P3d4, 0x56, 0); */
 	/* XGINew_SetRegANDOR(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
 
-	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11); /* unlock cr0-7 */
+	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11); /* unlock cr0-7 */
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data);
 
@@ -555,7 +555,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 		xgifb_reg_set(pVBInfo->P3c4, (unsigned short) (i + 6), data);
 	}
 
-	j = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x0e);
+	j = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x0e);
 	j &= 0x1F;
 	data = pVBInfo->TimingH[0].data[7];
 	data &= 0xE0;
@@ -563,16 +563,16 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	xgifb_reg_set(pVBInfo->P3c4, 0x0e, data);
 
 	if (HwDeviceExtension->jChipType >= XG20) {
-		data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x04);
+		data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x04);
 		data = data - 1;
 		xgifb_reg_set(pVBInfo->P3d4, 0x04, data);
-		data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x05);
+		data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x05);
 		data1 = data;
 		data1 &= 0xE0;
 		data &= 0x1F;
 		if (data == 0) {
 			pushax = data;
-			data = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4,
+			data = (unsigned char) xgifb_reg_get(pVBInfo->P3c4,
 					0x0c);
 			data &= 0xFB;
 			xgifb_reg_set(pVBInfo->P3c4, 0x0c, data);
@@ -581,7 +581,7 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 		data = data - 1;
 		data |= data1;
 		xgifb_reg_set(pVBInfo->P3d4, 0x05, data);
-		data = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x0e);
+		data = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x0e);
 		data = data >> 5;
 		data = data + 3;
 		if (data > 7)
@@ -616,7 +616,7 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeN
 		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 0x11), data);
 	}
 
-	j = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x0a);
+	j = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x0a);
 	j &= 0xC0;
 	data = pVBInfo->TimingV[0].data[6];
 	data &= 0x3F;
@@ -636,7 +636,7 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeN
 	if (i)
 		data |= 0x80;
 
-	j = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x09);
+	j = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x09);
 	j &= 0x5F;
 	data |= j;
 	xgifb_reg_set(pVBInfo->P3d4, 0x09, data);
@@ -653,7 +653,7 @@ static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC; /* Get index */
 	index = index & IndexMask;
 
-	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
+	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
 
@@ -955,7 +955,7 @@ static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 		xgifb_reg_set(pVBInfo->P3d4, 0x47, *pVBInfo->pCR47);
 	}
 
-	Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37);
+	Temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
 
 	if (Temp & 0x01) {
 		XGINew_SetRegOR(pVBInfo->P3c4, 0x06, 0x40); /* 18 bits FP */
@@ -995,7 +995,7 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 	xgifb_reg_set(pVBInfo->P3d4, 0x46, 0x00);
 	xgifb_reg_set(pVBInfo->P3d4, 0x47, 0x00);
 
-	Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37);
+	Temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
 	if ((Temp & 0x03) == 0) { /* dual 12 */
 		xgifb_reg_set(pVBInfo->P3d4, 0x46, 0x13);
 		xgifb_reg_set(pVBInfo->P3d4, 0x47, 0x13);
@@ -1122,8 +1122,8 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 	tempax -= 1;
 	tempbx -= 1;
 	tempcx = tempax;
-	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
-	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
+	temp = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
+	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
 	xgifb_reg_set(pVBInfo->P3d4, 0x01, (unsigned short) (tempcx & 0xff));
@@ -1140,7 +1140,7 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 		tempax |= 0x40;
 
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x42, tempax);
-	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x07);
+	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x07);
 	data &= 0xFF;
 	tempax = 0;
 
@@ -1216,7 +1216,7 @@ static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp2 = temp;
 	temp = temp >> 8; /* ah */
 	temp &= 0x0F;
-	i = XGINew_GetReg1(pVBInfo->P3c4, 0x0E);
+	i = xgifb_reg_get(pVBInfo->P3c4, 0x0E);
 	i &= 0xF0;
 	i |= temp;
 	xgifb_reg_set(pVBInfo->P3c4, 0x0E, i);
@@ -1429,7 +1429,7 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->IF_DEF_LVDS == 1) {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x31) & 0xCF;
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x31) & 0xCF;
 		xgifb_reg_set(pVBInfo->P3c4, 0x31, data);
 		xgifb_reg_set(pVBInfo->P3c4, 0x2B,
 				pVBInfo->VCLKData[index].SR2B);
@@ -1442,7 +1442,7 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		vclkindex = XGI_GetVCLK2Ptr(ModeNo, ModeIdIndex,
 				RefreshRateTableIndex, HwDeviceExtension,
 				pVBInfo);
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x31) & 0xCF;
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x31) & 0xCF;
 		xgifb_reg_set(pVBInfo->P3c4, 0x31, data);
 		data = pVBInfo->VBVCLKData[vclkindex].Part4_A;
 		xgifb_reg_set(pVBInfo->P3c4, 0x2B, data);
@@ -1451,7 +1451,7 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		xgifb_reg_set(pVBInfo->P3c4, 0x2D, 0x01);
 	} else {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x31) & 0xCF;
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x31) & 0xCF;
 		xgifb_reg_set(pVBInfo->P3c4, 0x31, data);
 		xgifb_reg_set(pVBInfo->P3c4, 0x2B,
 				pVBInfo->VCLKData[index].SR2B);
@@ -1462,9 +1462,9 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (HwDeviceExtension->jChipType >= XG20) {
 		if (pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag & HalfDCLK) {
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x2B);
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x2B);
 			xgifb_reg_set(pVBInfo->P3c4, 0x2B, data);
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x2C);
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x2C);
 			index = data;
 			index &= 0xE0;
 			data &= 0x1F;
@@ -1482,27 +1482,27 @@ static void XGI_SetCRT1FIFO(unsigned short ModeNo,
 {
 	unsigned short data;
 
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x3D);
+	data = xgifb_reg_get(pVBInfo->P3c4, 0x3D);
 	data &= 0xfe;
 	xgifb_reg_set(pVBInfo->P3c4, 0x3D, data); /* diable auto-threshold */
 
 	if (ModeNo > 0x13) {
 		xgifb_reg_set(pVBInfo->P3c4, 0x08, 0x34);
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x09);
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x09);
 		data &= 0xC0;
 		xgifb_reg_set(pVBInfo->P3c4, 0x09, data | 0x30);
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x3D);
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x3D);
 		data |= 0x01;
 		xgifb_reg_set(pVBInfo->P3c4, 0x3D, data);
 	} else {
 		if (HwDeviceExtension->jChipType == XG27) {
 			xgifb_reg_set(pVBInfo->P3c4, 0x08, 0x0E);
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x09);
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x09);
 			data &= 0xC0;
 			xgifb_reg_set(pVBInfo->P3c4, 0x09, data | 0x20);
 		} else {
 			xgifb_reg_set(pVBInfo->P3c4, 0x08, 0xAE);
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x09);
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x09);
 			data &= 0xF0;
 			xgifb_reg_set(pVBInfo->P3c4, 0x09, data);
 		}
@@ -1529,7 +1529,7 @@ static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
 		VCLK = pVBInfo->VCLKData[index].CLOCK;
 	}
 
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x32);
+	data = xgifb_reg_get(pVBInfo->P3c4, 0x32);
 	data &= 0xf3;
 	if (VCLK >= 200)
 		data |= 0x0c; /* VCLK > 200 */
@@ -1540,7 +1540,7 @@ static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
 	xgifb_reg_set(pVBInfo->P3c4, 0x32, data);
 
 	if (HwDeviceExtension->jChipType < XG20) {
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
+		data = xgifb_reg_get(pVBInfo->P3c4, 0x1F);
 		data &= 0xE7;
 		if (VCLK < 200)
 			data |= 0x10;
@@ -1580,7 +1580,7 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	} else
 		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ModeFlag */
 
-	if (XGINew_GetReg1(pVBInfo->P3d4, 0x31) & 0x01)
+	if (xgifb_reg_get(pVBInfo->P3d4, 0x31) & 0x01)
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1F, 0x3F, 0x00);
 
 	if (ModeNo > 0x13)
@@ -1654,7 +1654,7 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	/* if (XGINew_IF_DEF_NEW_LOWRES) */
 	/* XGI_VesaLowResolution(ModeNo, ModeIdIndex); //030305 fix lowresolution bug */
 
-	data = XGINew_GetReg1(pVBInfo->P3d4, 0x31);
+	data = xgifb_reg_get(pVBInfo->P3d4, 0x31);
 
 	if (HwDeviceExtension->jChipType == XG27) {
 		if (data & 0x40)
@@ -2668,7 +2668,7 @@ static unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo)
 {
 	unsigned char tempal, tempah, tempbl, i;
 
-	tempah = XGINew_GetReg1(pVBInfo->P3d4, 0x36);
+	tempah = xgifb_reg_get(pVBInfo->P3d4, 0x36);
 	tempal = tempah & 0x0F;
 	tempah = tempah & 0xF0;
 	i = 0;
@@ -3276,22 +3276,22 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 			| VB_XGI302LV | VB_XGI301C)) {
 		tempcl = 0;
 		tempch = 0;
-		temp = XGINew_GetReg1(pVBInfo->P3c4, 0x01);
+		temp = xgifb_reg_get(pVBInfo->P3c4, 0x01);
 
 		if (!(temp & 0x20)) {
-			temp = XGINew_GetReg1(pVBInfo->P3d4, 0x17);
+			temp = xgifb_reg_get(pVBInfo->P3d4, 0x17);
 			if (temp & 0x80) {
-				temp = XGINew_GetReg1(pVBInfo->P3d4, 0x53);
+				temp = xgifb_reg_get(pVBInfo->P3d4, 0x53);
 				if (!(temp & 0x40))
 					tempcl |= ActiveCRT1;
 			}
 		}
 
-		temp = XGINew_GetReg1(pVBInfo->Part1Port, 0x2e);
+		temp = xgifb_reg_get(pVBInfo->Part1Port, 0x2e);
 		temp &= 0x0f;
 
 		if (!(temp == 0x08)) {
-			tempax = XGINew_GetReg1(pVBInfo->Part1Port, 0x13); /* Check ChannelA by Part1_13 [2003/10/03] */
+			tempax = xgifb_reg_get(pVBInfo->Part1Port, 0x13); /* Check ChannelA by Part1_13 [2003/10/03] */
 			if (tempax & 0x04)
 				tempcl = tempcl | ActiveLCD;
 
@@ -3305,7 +3305,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 				tempcl |= ActiveLCD;
 
 			if (temp == 0x05) {
-				temp = XGINew_GetReg1(pVBInfo->Part2Port, 0x00);
+				temp = xgifb_reg_get(pVBInfo->Part2Port, 0x00);
 
 				if (!(temp & 0x08))
 					tempch |= ActiveAVideo;
@@ -3322,7 +3322,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 				}
 
 				if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
-					temp = XGINew_GetReg1(
+					temp = xgifb_reg_get(
 							pVBInfo->Part2Port,
 							0x4d);
 
@@ -3335,7 +3335,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 			}
 		}
 
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x3d);
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x3d);
 		if (tempcl & ActiveLCD) {
 			if ((pVBInfo->SetFlag & ReserveTVOption)) {
 				if (temp & ActiveTV)
@@ -3376,10 +3376,10 @@ void XGI_GetVBType(struct vb_device_info *pVBInfo)
 	}
 	if (pVBInfo->IF_DEF_LVDS == 0) {
 		tempbx = VB_XGI302B;
-		flag = XGINew_GetReg1(pVBInfo->Part4Port, 0x00);
+		flag = xgifb_reg_get(pVBInfo->Part4Port, 0x00);
 		if (flag != 0x02) {
 			tempbx = VB_XGI301;
-			flag = XGINew_GetReg1(pVBInfo->Part4Port, 0x01);
+			flag = xgifb_reg_get(pVBInfo->Part4Port, 0x01);
 			if (flag >= 0xB0) {
 				tempbx = VB_XGI301B;
 				if (flag >= 0xC0) {
@@ -3389,7 +3389,7 @@ void XGI_GetVBType(struct vb_device_info *pVBInfo)
 						if (flag >= 0xE0) {
 							tempbx = VB_XGI302LV;
 							tempah
-									= XGINew_GetReg1(
+									= xgifb_reg_get(
 											pVBInfo->Part4Port,
 											0x39);
 							if (tempah != 0xFF)
@@ -3400,7 +3400,7 @@ void XGI_GetVBType(struct vb_device_info *pVBInfo)
 				}
 
 				if (tempbx & (VB_XGI301B | VB_XGI302B)) {
-					flag = XGINew_GetReg1(
+					flag = xgifb_reg_get(
 							pVBInfo->Part4Port,
 							0x23);
 
@@ -3436,9 +3436,9 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx = 0;
 
 	if (pVBInfo->VBType & 0xFFFF) {
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x30); /* Check Display Device */
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x30); /* Check Display Device */
 		tempbx = tempbx | temp;
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x31);
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x31);
 		push = temp;
 		push = push << 8;
 		tempax = temp << 8;
@@ -3448,7 +3448,7 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = 0xFFFF ^ temp;
 		tempbx &= temp;
 
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 
 		if (pVBInfo->IF_DEF_LCDA == 1) {
 
@@ -3497,7 +3497,7 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 									& VB_CH7007))) { /* [Billy] 07/05/04 */
 				if (temp & SetYPbPr) { /* temp = CR38 */
 					if (pVBInfo->IF_DEF_HiVision == 1) {
-						temp = XGINew_GetReg1(
+						temp = xgifb_reg_get(
 								pVBInfo->P3d4,
 								0x35); /* shampoo add for new scratch */
 						temp &= YPbPrMode;
@@ -3685,7 +3685,7 @@ void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 
 		if (pVBInfo->VBInfo & SetCRT2ToTV) {
-			temp = XGINew_GetReg1(pVBInfo->P3d4, 0x35);
+			temp = xgifb_reg_get(pVBInfo->P3d4, 0x35);
 			tempbx = temp;
 			if (tempbx & SetPALTV) {
 				tempbx &= (SetCHTVOverScan | SetPALMTV
@@ -3697,7 +3697,7 @@ void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 						| SetPALTV);
 			/*
 			if (pVBInfo->IF_DEF_LVDS == 0) {
-				index1 = XGINew_GetReg1(pVBInfo->P3d4, 0x38); //PAL-M/PAL-N Info
+				index1 = xgifb_reg_get(pVBInfo->P3d4, 0x38); //PAL-M/PAL-N Info
 				temp2 = (index1 & 0xC0) >> 5; //00:PAL, 01:PAL-M, 10:PAL-N
 				tempbx |= temp2;
 				if (temp2 & 0x02)          //PAL-M
@@ -3707,14 +3707,14 @@ void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 
 		if (pVBInfo->IF_DEF_CH7017 == 1) {
-			tempbx = XGINew_GetReg1(pVBInfo->P3d4, 0x35);
+			tempbx = xgifb_reg_get(pVBInfo->P3d4, 0x35);
 
 			if (tempbx & TVOverScan)
 				tempbx |= SetCHTVOverScan;
 		}
 
 		if (pVBInfo->IF_DEF_CH7007 == 1) { /* [Billy] 07/05/04 */
-			tempbx = XGINew_GetReg1(pVBInfo->P3d4, 0x35);
+			tempbx = xgifb_reg_get(pVBInfo->P3d4, 0x35);
 
 			if (tempbx & TVOverScan)
 				tempbx |= SetCHTVOverScan;
@@ -3727,7 +3727,7 @@ void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
 			if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
-				index1 = XGINew_GetReg1(pVBInfo->P3d4, 0x35);
+				index1 = xgifb_reg_get(pVBInfo->P3d4, 0x35);
 				index1 &= YPbPrMode;
 
 				if (index1 == YPbPrMode525i)
@@ -3791,7 +3791,7 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO; /* si+Ext_ResInfo // */
 	}
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x36); /* Get LCD Res.Info */
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x36); /* Get LCD Res.Info */
 	tempbx = temp & 0x0F;
 
 	if (tempbx == 0)
@@ -3800,7 +3800,7 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	/* LCD75 [2003/8/22] Vicent */
 	if ((tempbx == Panel1024x768) || (tempbx == Panel1280x1024)) {
 		if (pVBInfo->VBInfo & DriverMode) {
-			tempax = XGINew_GetReg1(pVBInfo->P3d4, 0x33);
+			tempax = xgifb_reg_get(pVBInfo->P3d4, 0x33);
 			if (pVBInfo->VBInfo & SetCRT2ToLCDA)
 				tempax &= 0x0F;
 			else
@@ -3828,7 +3828,7 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempbx = 0;
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
 
 	temp &= (ScalingLCD | LCDNonExpanding | LCDSyncBit | SetPWDEnable);
 
@@ -3998,7 +3998,7 @@ static unsigned char XGINew_CheckMemorySize(
 	memorysize = memorysize > MemorySizeShift;
 	memorysize++; /* Get memory size */
 
-	temp = XGINew_GetReg1(pVBInfo->P3c4, 0x14); /* Get DRAM Size */
+	temp = xgifb_reg_get(pVBInfo->P3c4, 0x14); /* Get DRAM Size */
 	tmp = temp;
 
 	if (HwDeviceExtension->jChipType == XG40) {
@@ -4038,17 +4038,17 @@ void XGINew_IsLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, u
 	unsigned short data ;
 	unsigned short ModeFlag ;
 
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x0F);
+	data = xgifb_reg_get(pVBInfo->P3c4, 0x0F);
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3c4, 0x0F, data);
 
 	if (ModeNo > 0x13) {
 		ModeFlag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		if ((ModeFlag & HalfDCLK) && (ModeFlag & DoubleScanMode)) {
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x0F);
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x0F);
 			data |= 0x80;
 			xgifb_reg_set(pVBInfo->P3c4, 0x0F, data);
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x01);
+			data = xgifb_reg_get(pVBInfo->P3c4, 0x01);
 			data &= 0xF7;
 			xgifb_reg_set(pVBInfo->P3c4, 0x01, data);
 		}
@@ -4080,10 +4080,10 @@ static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR4A, temp;
 
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x23); /* enable GPIO write */
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 
 	temp = XG21GPIODataTransfer(temp);
 	temp &= 0x23;
@@ -4101,15 +4101,15 @@ static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR4A, CRB4, temp;
 
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x0C); /* enable GPIO write */
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 
 	temp &= 0x0C;
 	temp >>= 2;
 	xgifb_reg_set(pVBInfo->P3d4, 0x4A, CR4A);
-	CRB4 = XGINew_GetReg1(pVBInfo->P3d4, 0xB4);
+	CRB4 = xgifb_reg_get(pVBInfo->P3d4, 0xB4);
 	temp |= ((CRB4 & 0x04) << 3);
 	return temp;
 }
@@ -5637,7 +5637,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	xgifb_reg_set(pVBInfo->Part2Port, 0x4d, temp);
-	temp = XGINew_GetReg1(pVBInfo->Part2Port, 0x43); /* 301b change */
+	temp = xgifb_reg_get(pVBInfo->Part2Port, 0x43); /* 301b change */
 	xgifb_reg_set(pVBInfo->Part2Port, 0x43, (unsigned short) (temp - 3));
 
 	if (!(pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p))) {
@@ -5659,7 +5659,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	if (pVBInfo->TVInfo & SetPALMTV) {
-		tempax = (unsigned char) XGINew_GetReg1(pVBInfo->Part2Port,
+		tempax = (unsigned char) xgifb_reg_get(pVBInfo->Part2Port,
 				0x01);
 		tempax--;
 		XGINew_SetRegAND(pVBInfo->Part2Port, 0x01, tempax);
@@ -6289,7 +6289,7 @@ void XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 {
 	unsigned char CR4A, temp;
 
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	tempbh &= 0x23;
 	tempbl &= 0x23;
 	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~tempbh); /* enable GPIO write */
@@ -6301,7 +6301,7 @@ void XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 
 	}
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 
 	temp = XG21GPIODataTransfer(temp);
 	temp &= ~tempbh;
@@ -6330,7 +6330,7 @@ void XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	}
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0xB4, ~tempbh0, tempbl0);
 
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	tempbh &= 0x03;
 	tempbl &= 0x03;
 	tempbh <<= 2;
@@ -6344,7 +6344,7 @@ unsigned short XGI_GetLVDSOEMTableIndex(struct vb_device_info *pVBInfo)
 {
 	unsigned short index;
 
-	index = XGINew_GetReg1(pVBInfo->P3d4, 0x36);
+	index = xgifb_reg_get(pVBInfo->P3d4, 0x36);
 	if (index < sizeof(XGI21_LCDCapList)
 			/ sizeof(struct XGI21_LVDSCapStruct))
 		return index;
@@ -6437,7 +6437,7 @@ void XGI_SetXG21FPBits(struct vb_device_info *pVBInfo)
 {
 	unsigned char temp;
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37); /* D[0] 1: 18bit */
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37); /* D[0] 1: 18bit */
 	temp = (temp & 1) << 6;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x06, ~0x40, temp); /* SR06[6] 18bit Dither */
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: dual 12bits */
@@ -6448,7 +6448,7 @@ void XGI_SetXG27FPBits(struct vb_device_info *pVBInfo)
 {
 	unsigned char temp;
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37); /* D[1:0] 01: 18bit, 00: dual 12, 10: single 24 */
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37); /* D[1:0] 01: 18bit, 00: dual 12, 10: single 24 */
 	temp = (temp & 3) << 6;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x06, ~0xc0, temp & 0x80); /* SR06[7]0: dual 12/1: single 24 [6] 18bit Dither <= 0 h/w recommend */
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: 24bits */
@@ -6535,7 +6535,7 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	LVDSVBE = LVDSVBS + LVDSVT
 			- pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE;
 
-	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
+	temp = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
 
 	if (!(modeflag & Charx8Dot))
@@ -6720,7 +6720,7 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	LVDSVBE = LVDSVBS + LVDSVT
 			- pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE;
 
-	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
+	temp = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
 
 	if (!(modeflag & Charx8Dot))
@@ -6855,7 +6855,7 @@ static unsigned char XGI_DisableChISLCD(struct vb_device_info *pVBInfo)
 	unsigned short tempbx, tempah;
 
 	tempbx = pVBInfo->SetFlag & (DisableChA | DisableChB);
-	tempah = ~((unsigned short) XGINew_GetReg1(pVBInfo->Part1Port, 0x2E));
+	tempah = ~((unsigned short) xgifb_reg_get(pVBInfo->Part1Port, 0x2E));
 
 	if (tempbx & (EnableChA | DisableChA)) {
 		if (!(tempah & 0x08)) /* Chk LCDA Mode */
@@ -6882,7 +6882,7 @@ static unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo)
 	unsigned short tempbx, tempah;
 
 	tempbx = pVBInfo->SetFlag & (EnableChA | EnableChB);
-	tempah = ~((unsigned short) XGINew_GetReg1(pVBInfo->Part1Port, 0x2E));
+	tempah = ~((unsigned short) xgifb_reg_get(pVBInfo->Part1Port, 0x2E));
 
 	if (tempbx & (EnableChA | DisableChA)) {
 		if (!(tempah & 0x08)) /* Chk LCDA Mode */
@@ -6983,7 +6983,7 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 				|| (!(pVBInfo->VBInfo & SetCRT2ToLCDA))
 				|| (pVBInfo->VBInfo & (SetCRT2ToRAMDAC
 						| SetCRT2ToLCD | SetCRT2ToTV))) {
-			tempah = XGINew_GetReg1(pVBInfo->Part1Port, 0x00); /* save Part1 index 0 */
+			tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x00); /* save Part1 index 0 */
 			XGINew_SetRegOR(pVBInfo->Part1Port, 0x00, 0x10); /* BTDAC = 1, avoid VB reset */
 			XGINew_SetRegAND(pVBInfo->Part1Port, 0x1E, 0xDF); /* disable CRT2 */
 			xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah); /* restore Part1 index 0 */
@@ -7129,7 +7129,7 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 
 			tempbl &= 0x0F;
 			tempbh &= 0xF0;
-			tempah = XGINew_GetReg1(pVBInfo->Part1Port, 0x2D);
+			tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x2D);
 
 			if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToLCD
 					| SetCRT2ToTV)) { /* Channel B */
@@ -7162,7 +7162,7 @@ static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInf
 {
 	unsigned short temp;
 
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37);
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
 
 	if (temp & LCDRGB18Bit) {
 		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, 0x0F,
@@ -7465,7 +7465,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	/* xgifb_reg_set(pVBInfo->Part1Port, 0x03, 0x00); // fix write part1 index 0 BTDRAM bit Bug */
 	tempah = 0;
 	if (!(pVBInfo->VBInfo & DisableCRT2Display)) {
-		tempah = XGINew_GetReg1(pVBInfo->Part1Port, 0x00);
+		tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x00);
 		tempah &= ~0x10; /* BTRAMDAC */
 		tempah |= 0x40; /* BTRAM */
 
@@ -7700,7 +7700,7 @@ unsigned char XGI_BridgeIsOn(struct vb_device_info *pVBInfo)
 	if (pVBInfo->IF_DEF_LVDS == 1) {
 		return 1;
 	} else {
-		flag = XGINew_GetReg1(pVBInfo->Part4Port, 0x00);
+		flag = xgifb_reg_get(pVBInfo->Part4Port, 0x00);
 		if ((flag == 1) || (flag == 2))
 			return 1; /* 301b */
 		else
@@ -7712,7 +7712,7 @@ void XGI_LongWait(struct vb_device_info *pVBInfo)
 {
 	unsigned short i;
 
-	i = XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
+	i = xgifb_reg_get(pVBInfo->P3c4, 0x1F);
 
 	if (!(i & 0xC0)) {
 		for (i = 0; i < 0xFFFF; i++) {
@@ -7784,7 +7784,7 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 	if (ModeNo < 0x14)
 		return 0xFFFF;
 
-	index = XGINew_GetReg1(pVBInfo->P3d4, 0x33);
+	index = xgifb_reg_get(pVBInfo->P3d4, 0x33);
 	index = index >> pVBInfo->SelectCRT2Rate;
 	index &= 0x0F;
 
@@ -7950,25 +7950,25 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 
 	/* [2004/05/06] Vicent to fix XG42 single LCD sense to CRT+LCD */
 	xgifb_reg_set(pVBInfo->P3d4, 0x57, 0x4A);
-	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
+	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (xgifb_reg_get(
 			pVBInfo->P3d4, 0x53) | 0x02));
 
-	SR31 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x31);
-	CR63 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x63);
-	SR01 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x01);
+	SR31 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x31);
+	CR63 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x63);
+	SR01 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x01);
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x01, (unsigned char) (SR01 & 0xDF));
 	xgifb_reg_set(pVBInfo->P3d4, 0x63, (unsigned char) (CR63 & 0xBF));
 
-	CR17 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x17);
+	CR17 = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x17);
 	xgifb_reg_set(pVBInfo->P3d4, 0x17, (unsigned char) (CR17 | 0x80));
 
-	SR1F = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
+	SR1F = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x1F);
 	xgifb_reg_set(pVBInfo->P3c4, 0x1F, (unsigned char) (SR1F | 0x04));
 
-	SR07 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x07);
+	SR07 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x07);
 	xgifb_reg_set(pVBInfo->P3c4, 0x07, (unsigned char) (SR07 & 0xFB));
-	SR06 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x06);
+	SR06 = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x06);
 	xgifb_reg_set(pVBInfo->P3c4, 0x06, (unsigned char) (SR06 & 0xC3));
 
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, 0x00);
@@ -8031,7 +8031,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	xgifb_reg_set(pVBInfo->P3c4, 0x31, SR31);
 
 	/* [2004/05/11] Vicent */
-	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
+	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (xgifb_reg_get(
 			pVBInfo->P3d4, 0x53) & 0xFD));
 	xgifb_reg_set(pVBInfo->P3c4, 0x1F, (unsigned char) SR1F);
 }
@@ -8068,7 +8068,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			if ((pVBInfo->SetFlag & EnableChB) || (pVBInfo->VBInfo
 					& (SetCRT2ToLCD | SetCRT2ToTV
 							| SetCRT2ToRAMDAC))) {
-				tempah = (unsigned char) XGINew_GetReg1(
+				tempah = (unsigned char) xgifb_reg_get(
 						pVBInfo->P3c4, 0x32);
 				tempah &= 0xDF;
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
@@ -8078,7 +8078,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 				xgifb_reg_set(pVBInfo->P3c4, 0x32, tempah);
 				XGINew_SetRegOR(pVBInfo->P3c4, 0x1E, 0x20);
 
-				tempah = (unsigned char) XGINew_GetReg1(
+				tempah = (unsigned char) xgifb_reg_get(
 						pVBInfo->Part1Port, 0x2E);
 
 				if (!(tempah & 0x80))
@@ -8161,7 +8161,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 				| SetCRT2ToLCDA))
 			XGINew_SetRegOR(pVBInfo->Part1Port, 0x1E, 0x20); /* enable CRT2 */
 
-		tempah = (unsigned char) XGINew_GetReg1(pVBInfo->Part1Port,
+		tempah = (unsigned char) xgifb_reg_get(pVBInfo->Part1Port,
 				0x2E);
 		if (!(tempah & 0x80))
 			XGINew_SetRegOR(pVBInfo->Part1Port, 0x2E, 0x80); /* BVBDOENABLE = 1 */
@@ -8239,7 +8239,7 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 
 	if (HwDeviceExtension->jChipType >= XG21) {
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 		if (temp & 0xA0) {
 
 			/* XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); *//* Enable write GPIOF */
@@ -8335,12 +8335,12 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
 
 	if (HwDeviceExtension->jChipType == XG21) { /* for x86 Linux, XG21 LVDS */
-		if ((XGINew_GetReg1(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0)
+		if ((xgifb_reg_get(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0)
 			pVBInfo->IF_DEF_LVDS = 1;
 	}
 	if (HwDeviceExtension->jChipType == XG27) {
-		if ((XGINew_GetReg1(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0) {
-			if (XGINew_GetReg1(pVBInfo->P3d4, 0x30) & 0x20)
+		if ((xgifb_reg_get(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0) {
+			if (xgifb_reg_get(pVBInfo->P3d4, 0x30) & 0x20)
 				pVBInfo->IF_DEF_LVDS = 1;
 		}
 	}
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index f7cad57..65f1349 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -15,7 +15,7 @@ void xgifb_reg_set(unsigned long port, unsigned short index,
 	outb(data, port + 1);
 }
 
-unsigned char XGINew_GetReg1(unsigned long port, unsigned short index)
+unsigned char xgifb_reg_get(unsigned long port, unsigned short index)
 {
 	unsigned char data;
 
@@ -29,7 +29,7 @@ void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
 {
 	unsigned short temp;
 
-	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
+	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
 	temp = (temp & (DataAND)) | DataOR;
 	xgifb_reg_set(Port, Index, temp);
 }
@@ -39,7 +39,7 @@ void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
 {
 	unsigned short temp;
 
-	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
+	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
 	temp &= DataAND;
 	xgifb_reg_set(Port, Index, temp);
 }
@@ -49,7 +49,7 @@ void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
 {
 	unsigned short temp;
 
-	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
+	temp = xgifb_reg_get(Port, Index); /* XGINew_Part1Port index 02 */
 	temp |= DataOR;
 	xgifb_reg_set(Port, Index, temp);
 }
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index c99592a..6332d4c 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -1,7 +1,7 @@
 #ifndef _VBUTIL_
 #define _VBUTIL_
 extern void xgifb_reg_set(unsigned long, unsigned short, unsigned short);
-extern    unsigned char     XGINew_GetReg1(unsigned long, unsigned short);
+extern unsigned char xgifb_reg_get(unsigned long, unsigned short);
 extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
 extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
 extern   void     XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,unsigned short DataAND,unsigned short DataOR);
-- 
1.5.6.5

