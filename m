Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1CMK0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:26:43 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39889 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1CMK0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:20 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 05/24] staging: xgifb: delete dead code for chip types < XG40
Date: Sun, 13 Mar 2011 12:26:09 +0200
Message-Id: <1300011988-2109-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XG40 is the first supported chip, so the code for earlier chips can
be dropped.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c    |    9 +--
 drivers/staging/xgifb/vb_setmode.c |  216 +-----------------------------------
 2 files changed, 3 insertions(+), 222 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 7b8e00d..10c0a3b 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1409,9 +1409,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 	 if (HwDeviceExtension->jChipType >= XG40)
 	 XGINew_RAMType = (int)XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
-
-	 if (HwDeviceExtension->jChipType < XG40)
-	 XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);  */
+	*/
 
 	printk("11");
 
@@ -1494,9 +1492,6 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 				XGINew_SetReg1(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
 		}
 		printk("14");
-
-		if (HwDeviceExtension->jChipType < XG40)
-			XGINew_SetReg1(pVBInfo->P3d4, 0x49, pVBInfo->CR49[0]);
 	} /* != XG20 */
 
 	/* Set PCI */
@@ -1552,8 +1547,6 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	} /* != XG20 */
 	printk("18");
 
-	if (HwDeviceExtension->jChipType < XG40)
-		XGINew_SetReg1(pVBInfo->P3d4, 0x83, 0x00);
 	printk("181");
 
 	printk("182");
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 693be07..4d56963 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -6280,47 +6280,6 @@ static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 	return;
 }
 
-/* --------------------------------------------------------------------- */
-/* Function : XGI_BacklightByDrv */
-/* Input : */
-/* Output : 1 -> Skip backlight control */
-/* Description : */
-/* --------------------------------------------------------------------- */
-static unsigned char XGI_BacklightByDrv(struct vb_device_info *pVBInfo)
-{
-	unsigned char tempah;
-
-	tempah = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x3A);
-	if (tempah & BacklightControlBit)
-		return 1;
-	else
-		return 0;
-}
-
-/* --------------------------------------------------------------------- */
-/* Function : XGI_FirePWDDisable */
-/* Input : */
-/* Output : */
-/* Description : Turn off VDD & Backlight : Fire disable procedure */
-/* --------------------------------------------------------------------- */
-/*
-void XGI_FirePWDDisable(struct vb_device_info *pVBInfo)
-{
-	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x26, 0x00, 0xFC);
-}
-*/
-
-/* --------------------------------------------------------------------- */
-/* Function : XGI_FirePWDEnable */
-/* Input : */
-/* Output : */
-/* Description : Turn on VDD & Backlight : Fire enable procedure */
-/* --------------------------------------------------------------------- */
-static void XGI_FirePWDEnable(struct vb_device_info *pVBInfo)
-{
-	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x26, 0x03, 0xFC);
-}
-
 static void XGI_EnableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -6334,54 +6293,6 @@ static void XGI_DisableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x63, 0xBF, 0x00);
 }
 
-/* --------------------------------------------------------------------- */
-/* Function : XGI_SetPanelDelay */
-/* Input : */
-/* Output : */
-/* Description : */
-/* I/P : bl : 1 ; T1 : the duration between CPL on and signal on */
-/* : bl : 2 ; T2 : the duration signal on and Vdd on */
-/* : bl : 3 ; T3 : the duration between CPL off and signal off */
-/* : bl : 4 ; T4 : the duration signal off and Vdd off */
-/* --------------------------------------------------------------------- */
-static void XGI_SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo)
-{
-	unsigned short index;
-
-	index = XGI_GetLCDCapPtr(pVBInfo);
-
-	if (tempbl == 1)
-		mdelay(pVBInfo->LCDCapList[index].PSC_S1);
-
-	if (tempbl == 2)
-		mdelay(pVBInfo->LCDCapList[index].PSC_S2);
-
-	if (tempbl == 3)
-		mdelay(pVBInfo->LCDCapList[index].PSC_S3);
-
-	if (tempbl == 4)
-		mdelay(pVBInfo->LCDCapList[index].PSC_S4);
-}
-
-/* --------------------------------------------------------------------- */
-/* Function : XGI_SetPanelPower */
-/* Input : */
-/* Output : */
-/* Description : */
-/* I/O : ah = 0011b = 03h ; Backlight on, Power on */
-/* = 0111b = 07h ; Backlight on, Power off */
-/* = 1011b = 0Bh ; Backlight off, Power on */
-/* = 1111b = 0Fh ; Backlight off, Power off */
-/* --------------------------------------------------------------------- */
-static void XGI_SetPanelPower(unsigned short tempah, unsigned short tempbl,
-		struct vb_device_info *pVBInfo)
-{
-	if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C))
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x26, tempbl, tempah);
-	else
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x11, tempbl, tempah);
-}
-
 /*----------------------------------------------------------------------------*/
 /* input                                                                      */
 /*      bl[5] : 1;LVDS signal on                                              */
@@ -6951,29 +6862,6 @@ static unsigned char XGI_IsLCDON(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
-static void XGI_EnablePWD(struct vb_device_info *pVBInfo)
-{
-	unsigned short index, temp;
-
-	index = XGI_GetLCDCapPtr(pVBInfo);
-	temp = pVBInfo->LCDCapList[index].PWD_2B;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x2B, temp);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x2C,
-			pVBInfo->LCDCapList[index].PWD_2C);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x2D,
-			pVBInfo->LCDCapList[index].PWD_2D);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x2E,
-			pVBInfo->LCDCapList[index].PWD_2E);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x2F,
-			pVBInfo->LCDCapList[index].PWD_2F);
-	XGINew_SetRegOR(pVBInfo->Part4Port, 0x27, 0x80); /* enable PWD */
-}
-
-static void XGI_DisablePWD(struct vb_device_info *pVBInfo)
-{
-	XGINew_SetRegAND(pVBInfo->Part4Port, 0x27, 0x7F); /* disable PWD */
-}
-
 /* --------------------------------------------------------------------- */
 /* Function : XGI_DisableChISLCD */
 /* Input : */
@@ -7031,37 +6919,11 @@ static unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo)
 void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short tempax, tempbx, tempah = 0, tempbl = 0;
+	unsigned short tempah = 0;
 
 	if (pVBInfo->SetFlag == Win9xDOSMode)
 		return;
 
-	if (HwDeviceExtension->jChipType < XG40) {
-		if ((!(pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)))
-				|| (XGI_DisableChISLCD(pVBInfo))) {
-			if (!XGI_IsLCDON(pVBInfo)) {
-				if (pVBInfo->LCDInfo & SetPWDEnable)
-					XGI_EnablePWD(pVBInfo);
-				else {
-					pVBInfo->LCDInfo &= ~SetPWDEnable;
-					XGI_DisablePWD(pVBInfo);
-					if (pVBInfo->VBType & (VB_XGI301LV
-							| VB_XGI302LV
-							| VB_XGI301C)) {
-						tempbx = 0xFE; /* not 01h */
-						tempax = 0;
-					} else {
-						tempbx = 0xF7; /* not 08h */
-						tempax = 0x08;
-					}
-					XGI_SetPanelPower(tempax, tempbx,
-							pVBInfo);
-					XGI_SetPanelDelay(3, pVBInfo);
-				}
-			} /* end if (!XGI_IsLCDON(pVBInfo)) */
-		}
-	}
-
 	/*
 	if (CH7017) {
 		if (!(pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2toLCDA)) || (XGI_DisableChISLCD(pVBInfo))) {
@@ -7155,28 +7017,6 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 				| SetSimuScanMode))
 			XGI_DisplayOff(HwDeviceExtension, pVBInfo);
 	}
-
-	if (HwDeviceExtension->jChipType < XG40) {
-		if (!(pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))
-				|| (XGI_DisableChISLCD(pVBInfo))
-				|| (XGI_IsLCDON(pVBInfo))) {
-			if (pVBInfo->LCDInfo & SetPWDEnable) {
-				if (pVBInfo->LCDInfo & SetPWDEnable)
-					XGI_BacklightByDrv(pVBInfo);
-				else {
-					XGI_SetPanelDelay(4, pVBInfo);
-					if (pVBInfo->VBType & VB_XGI301LV) {
-						tempbl = 0xFD;
-						tempah = 0x00;
-					} else {
-						tempbl = 0xFB;
-						tempah = 0x04;
-					}
-				}
-			}
-			XGI_SetPanelPower(tempah, tempbl, pVBInfo);
-		}
-	}
 }
 
 /* --------------------------------------------------------------------- */
@@ -8220,7 +8060,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short tempbl, tempah;
+	unsigned short tempah;
 
 	if (pVBInfo->SetFlag == Win9xDOSMode) {
 		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
@@ -8232,32 +8072,6 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			return;
 	}
 
-	if (HwDeviceExtension->jChipType < XG40) {
-		if (!XGI_DisableChISLCD(pVBInfo)) {
-			if ((XGI_EnableChISLCD(pVBInfo)) || (pVBInfo->VBInfo
-					& (SetCRT2ToLCD | SetCRT2ToLCDA))) {
-				if (pVBInfo->LCDInfo & SetPWDEnable) {
-					XGI_EnablePWD(pVBInfo);
-				} else {
-					pVBInfo->LCDInfo &= (~SetPWDEnable);
-					if (pVBInfo->VBType & (VB_XGI301LV
-							| VB_XGI302LV
-							| VB_XGI301C)) {
-						tempbl = 0xFD;
-						tempah = 0x02;
-					} else {
-						tempbl = 0xFB;
-						tempah = 0x00;
-					}
-
-					XGI_SetPanelPower(tempah, tempbl,
-							pVBInfo);
-					XGI_SetPanelDelay(1, pVBInfo);
-				}
-			}
-		}
-	} /* Not 340 */
-
 	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
 			| VB_XGI302LV | VB_XGI301C)) {
 		if (!(pVBInfo->SetFlag & DisableChA)) {
@@ -8376,32 +8190,6 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F);
 		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
 	} /* End of VB */
-
-	if (HwDeviceExtension->jChipType < XG40) {
-		if (!XGI_EnableChISLCD(pVBInfo)) {
-			if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-				if (XGI_BacklightByDrv(pVBInfo))
-					return;
-			} else
-				return;
-		}
-
-		if (pVBInfo->LCDInfo & SetPWDEnable) {
-			XGI_FirePWDEnable(pVBInfo);
-			return;
-		}
-
-		XGI_SetPanelDelay(2, pVBInfo);
-
-		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
-			tempah = 0x01;
-			tempbl = 0xFE; /* turn on backlght */
-		} else {
-			tempbl = 0xF7;
-			tempah = 0x00;
-		}
-		XGI_SetPanelPower(tempah, tempbl, pVBInfo);
-	}
 }
 
 static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
-- 
1.5.6.5

