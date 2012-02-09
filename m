Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2BIUMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:12:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58054 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932240Ab2BIUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:26 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/IFox4p0bIzsoE8SRcuiBmyviEr+n/eaxySCCxvO
	YK5XJhQ7FhsPrR
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 5/7] staging/xgifb: Rename XGI specific initdef.h defines
Date: Thu,  9 Feb 2012 21:11:47 +0100
Message-Id: <1328818309-5103-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
References: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames some of the defines that exist in the sis initdef.h
but seem to have a different value.
In order to preserve the functionality of the driver, we simply prepend
these defines with XGI_ (for now) to resolve conflicts and review them
later on.

Renames:
SetCRT2ToLCDA -> XGI_SetCRT2ToLCDA
LCDVESATiming -> XGI_LCDVESATiming
EnableLVDSDDA -> XGI_EnableLVDSDDA
LCDDualLink  -> XGI_LCDDualLink
ModeSwitchStatus  -> XGI_ModeSwitchStatus
YPbPr750pVCLK  -> XGI_YPbPr750pVCLK

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h     |   12 ++--
 drivers/staging/xgifb/vb_setmode.c |  148 ++++++++++++++++++------------------
 drivers/staging/xgifb/vb_table.h   |    8 +-
 3 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 12454c5..a4fedbd 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -109,7 +109,7 @@
 #define SetCRT2ToSCART      0x0010
 #define SetCRT2ToLCD        0x0020
 #define SetCRT2ToRAMDAC     0x0040
-#define SetCRT2ToLCDA       0x0100
+#define XGI_SetCRT2ToLCDA   0x0100
 #define SetInSlaveMode      0x0200
 #define SetNotSimuMode      0x0400
 #define LoadDACFlag         0x1000
@@ -131,8 +131,8 @@
 #define NTSC1024x768         0x2000
 #define SetTVLockMode        0x4000
 
-#define LCDVESATiming        0x0001 /* LCD Info/CR37 */
-#define EnableLVDSDDA        0x0002
+#define XGI_LCDVESATiming    0x0001 /* LCD Info/CR37 */
+#define XGI_EnableLVDSDDA    0x0002
 #define EnableScalingLCD     0x0008
 #define SetPWDEnable         0x0004
 #define SetLCDtoNonExpanding 0x0010
@@ -145,7 +145,7 @@
 #define EnableLCD24bpp       0x0004 /* default */
 #define DisableLCD24bpp      0x0000
 #define LCDPolarity          0x00c0 /* default: SyncNN */
-#define LCDDualLink          0x0100
+#define XGI_LCDDualLink      0x0100
 #define EnableSpectrum       0x0200
 #define PWDEnable            0x0400
 #define EnableVBCLKDRVLOW    0x4000
@@ -191,7 +191,7 @@
 #define DisplayDeviceFromCMOS 0x10
 
 /* ---------------------- HK Evnet Definition */
-#define ModeSwitchStatus      0xf0
+#define XGI_ModeSwitchStatus  0xf0
 #define ActiveCRT1            0x10
 #define ActiveLCD             0x0020
 #define ActiveTV              0x40
@@ -286,7 +286,7 @@
 #define VCLK125_999          0x51
 #define VCLK148_5            0x52
 #define VCLK217_325          0x55
-#define YPbPr750pVCLK        0x57
+#define XGI_YPbPr750pVCLK    0x57
 
 #define TVVCLKDIV2           0x3A
 #define TVVCLK               0x3B
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index ab2157c..42eaec7 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -208,8 +208,8 @@ static void XGI_SetSeqRegs(unsigned short ModeNo,
 	xgifb_reg_set(pVBInfo->P3c4, 0x00, 0x03); /* Set SR0 */
 	tempah = pVBInfo->StandTable[StandTableIndex].SR[0];
 
-	i = SetCRT2ToLCDA;
-	if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+	i = XGI_SetCRT2ToLCDA;
+	if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 		tempah |= 0x01;
 	} else {
 		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD)) {
@@ -263,7 +263,7 @@ static void XGI_SetATTRegs(unsigned short ModeNo,
 		ARdata = pVBInfo->StandTable[StandTableIndex].ATTR[i];
 		if (modeflag & Charx8Dot) { /* ifndef Dot9 */
 			if (i == 0x13) {
-				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 					ARdata = 0;
 				} else {
 					if (pVBInfo->VBInfo & (SetCRT2ToTV
@@ -356,7 +356,7 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		}
 
 		/* 301b */
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 			tempax |= SupportLCD;
 
 			if (pVBInfo->LCDResInfo != Panel_1280x1024) {
@@ -1266,7 +1266,7 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 
 	if (pVBInfo->IF_DEF_LVDS == 0) {
 		CRT2Index = CRT2Index >> 6; /*  for LCD */
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) { /*301b*/
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) { /*301b*/
 			if (pVBInfo->LCDResInfo != Panel_1024x768)
 				VCLKIndex = LCDXlat2VCLK[CRT2Index];
 			else
@@ -1294,7 +1294,7 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			if ((pVBInfo->VBType & VB_SIS301LV) &&
 			    !(pVBInfo->VBExtInfo == VB_YPbPr1080i)) {
 				if (pVBInfo->VBExtInfo == YPbPr750p)
-					VCLKIndex = YPbPr750pVCLK;
+					VCLKIndex = XGI_YPbPr750pVCLK;
 				else if (pVBInfo->VBExtInfo == YPbPr525p)
 					VCLKIndex = YPbPr525pVCLK;
 				else if (pVBInfo->SetFlag & RPLLDIV2XO)
@@ -1362,7 +1362,7 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo,
 		xgifb_reg_set(pVBInfo->P3c4, 0x2D, 0x01);
 	} else if ((pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
 			| VB_SIS302LV | VB_XGI301C)) && (pVBInfo->VBInfo
-			& SetCRT2ToLCDA)) {
+			& XGI_SetCRT2ToLCDA)) {
 		vclkindex = XGI_GetVCLK2Ptr(ModeNo, ModeIdIndex,
 				RefreshRateTableIndex, HwDeviceExtension,
 				pVBInfo);
@@ -1801,7 +1801,7 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 					Ext_CRT2CRTC;
 		}
 
-		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+		if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 			if (ModeNo <= 0x13)
 				tempal = pVBInfo->SModeIDTable[ModeIdIndex].
 						St_CRT2CRTC2;
@@ -2364,7 +2364,7 @@ static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempbx = 2;
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 		LCDPtr = (struct XGI330_LVDSDataStruct *) XGI_GetLcdPtr(tempbx,
 				ModeNo, ModeIdIndex, RefreshRateTableIndex,
 				pVBInfo);
@@ -2374,7 +2374,7 @@ static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 		pVBInfo->VT = LCDPtr->LCDVT;
 	}
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 		if (!(pVBInfo->LCDInfo & (SetLCDtoNonExpanding
 				| EnableScalingLCD))) {
 			if ((pVBInfo->LCDResInfo == Panel_1024x768) ||
@@ -2415,7 +2415,7 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempbx = 0;
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 		LCDPtr = (struct XGI_LVDSCRT1HDataStruct *)
 				XGI_GetLcdPtr(tempbx, ModeNo,
 					      ModeIdIndex,
@@ -2430,7 +2430,7 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempbx = 1;
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 		LCDPtr1 = (struct XGI_LVDSCRT1VDataStruct *)
 				XGI_GetLcdPtr(
 					tempbx,
@@ -2682,7 +2682,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (tempbx != pVBInfo->VDE)
 		tempax |= 0x40;
 
-	if (pVBInfo->LCDInfo & EnableLVDSDDA)
+	if (pVBInfo->LCDInfo & XGI_EnableLVDSDDA)
 		tempax |= 0x40;
 
 	xgifb_reg_and_or(pVBInfo->Part1Port, 0x1a, 0x07,
@@ -2800,7 +2800,7 @@ static void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
 {
 	unsigned short index;
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 		index = XGI_GetLCDCapPtr1(pVBInfo);
 
 		if (pVBInfo->VBInfo & SetCRT2ToLCD) { /* LCDB */
@@ -2834,7 +2834,7 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 		index = XGI_GetLCDCapPtr(pVBInfo);
 		tempal = pVBInfo->LCDCapList[index].LCD_VCLK;
 
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA))
 			return tempal;
 
 		/* {TV} */
@@ -2858,7 +2858,7 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 			}
 
 			if (pVBInfo->TVInfo & TVSetYPbPr750p) {
-				tempal = YPbPr750pVCLK;
+				tempal = XGI_YPbPr750pVCLK;
 				return tempal;
 			}
 
@@ -2900,7 +2900,7 @@ static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
 {
 	if (pVBInfo->VBType & (VB_SIS301 | VB_SIS301B | VB_SIS302B
 			| VB_SIS301LV | VB_SIS302LV | VB_XGI301C)) {
-		if ((!(pVBInfo->VBInfo & SetCRT2ToLCDA)) && (pVBInfo->SetFlag
+		if ((!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)) && (pVBInfo->SetFlag
 				& ProgrammingCRT2)) {
 			*di_0 = (unsigned char) XGI_VBVCLKData[tempal].SR2B;
 			*di_1 = XGI_VBVCLKData[tempal].SR2C;
@@ -2926,7 +2926,7 @@ static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	for (i = 0; i < 4; i++) {
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x31, ~0x30,
 				(unsigned short) (0x10 * i));
-		if ((!(pVBInfo->VBInfo & SetCRT2ToLCDA))
+		if ((!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA))
 				&& (!(pVBInfo->VBInfo & SetInSlaveMode))) {
 			xgifb_reg_set(pVBInfo->P3c4, 0x2e, di_0);
 			xgifb_reg_set(pVBInfo->P3c4, 0x2f, di_1);
@@ -3014,7 +3014,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 			}
 		}
 		temp = tempcl;
-		tempbl = ~ModeSwitchStatus;
+		tempbl = ~XGI_ModeSwitchStatus;
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x3d, tempbl, temp);
 
 		if (!(pVBInfo->SetFlag & ReserveTVOption))
@@ -3090,7 +3090,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		push = push << 8;
 		tempax = temp << 8;
 		tempbx = tempbx | tempax;
-		temp = (SetCRT2ToDualEdge | SetCRT2ToYPbPr525750 | SetCRT2ToLCDA
+		temp = (SetCRT2ToDualEdge | SetCRT2ToYPbPr525750 | XGI_SetCRT2ToLCDA
 				| SetInSlaveMode | DisableCRT2Display);
 		temp = 0xFFFF ^ temp;
 		tempbx &= temp;
@@ -3113,7 +3113,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 							if (temp & SetToLCDA)
 								tempbx |=
-								  SetCRT2ToLCDA;
+								  XGI_SetCRT2ToLCDA;
 						}
 					}
 				}
@@ -3172,7 +3172,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		if (pVBInfo->IF_DEF_LCDA == 1) { /* Select Display Device */
 			if (!(pVBInfo->VBType & VB_NoLCD)) {
-				if (tempbx & SetCRT2ToLCDA) {
+				if (tempbx & XGI_SetCRT2ToLCDA) {
 					if (tempbx & SetSimuScanMode)
 						tempbx &= (~(SetCRT2ToLCD |
 							   SetCRT2ToRAMDAC |
@@ -3246,7 +3246,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if ((!(tempbx & DriverMode)) ||
 			    (!(modeflag & CRT2Mode))) {
 				if (pVBInfo->IF_DEF_LCDA == 1) {
-					if (!(tempbx & SetCRT2ToLCDA))
+					if (!(tempbx & XGI_SetCRT2ToLCDA))
 						tempbx |= (SetInSlaveMode |
 							   SetSimuScanMode);
 				}
@@ -3255,9 +3255,9 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			/* LCD+TV can't support in slave mode
 			 * (Force LCDA+TV->LCDB) */
 			if ((tempbx & SetInSlaveMode) &&
-			    (tempbx & SetCRT2ToLCDA)) {
+			    (tempbx & XGI_SetCRT2ToLCDA)) {
 				tempbx ^= (SetCRT2ToLCD |
-					  SetCRT2ToLCDA |
+					  XGI_SetCRT2ToLCDA |
 					  SetCRT2ToDualEdge);
 				pVBInfo->SetFlag |= ReserveTVOption;
 			}
@@ -3392,7 +3392,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 	if ((tempbx == Panel_1024x768) || (tempbx == Panel_1280x1024)) {
 		if (pVBInfo->VBInfo & DriverMode) {
 			tempax = xgifb_reg_get(pVBInfo->P3d4, 0x33);
-			if (pVBInfo->VBInfo & SetCRT2ToLCDA)
+			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)
 				tempax &= 0x0F;
 			else
 				tempax = tempax >> 4;
@@ -3411,7 +3411,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 
 	/* End of LCD75 */
 
-	if (!(pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)))
+	if (!(pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
 		return 0;
 
 	tempbx = 0;
@@ -3428,7 +3428,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 
 	if (pVBInfo->IF_DEF_LVDS == 0) { /* shampoo */
 		if (((pVBInfo->VBType & VB_SIS302LV) || (pVBInfo->VBType
-				& VB_XGI301C)) && (tempax & LCDDualLink)) {
+				& VB_XGI301C)) && (tempax & XGI_LCDDualLink)) {
 			tempbx |= SetLCDDualLink;
 		}
 	}
@@ -3444,13 +3444,13 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 	if (pVBInfo->IF_DEF_ExpLink == 1) {
 		if (modeflag & HalfDCLK) {
 			if (!(tempbx & SetLCDtoNonExpanding)) {
-				tempbx |= EnableLVDSDDA;
+				tempbx |= XGI_EnableLVDSDDA;
 			} else {
 				if (ModeNo > 0x13) {
 					if (pVBInfo->LCDResInfo
 							== Panel_1024x768) {
 						if (resinfo == 4) {/* 512x384 */
-							tempbx |= EnableLVDSDDA;
+							tempbx |= XGI_EnableLVDSDDA;
 						}
 					}
 				}
@@ -3460,9 +3460,9 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 
 	if (pVBInfo->VBInfo & SetInSlaveMode) {
 		if (pVBInfo->VBInfo & SetNotSimuMode)
-			tempbx |= LCDVESATiming;
+			tempbx |= XGI_LCDVESATiming;
 	} else {
-		tempbx |= LCDVESATiming;
+		tempbx |= XGI_LCDVESATiming;
 	}
 
 	pVBInfo->LCDInfo = tempbx;
@@ -3477,7 +3477,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 							  SetInSlaveMode |
 							  SetCRT2ToLCD);
 						pVBInfo->VBInfo |=
-							SetCRT2ToLCDA |
+							XGI_SetCRT2ToLCDA |
 							SetCRT2ToDualEdge;
 					}
 				}
@@ -3802,7 +3802,7 @@ static void XGI_GetCRT2ResInfo(unsigned short ModeNo,
 	if (pVBInfo->VBInfo & SetCRT2ToLCD) {
 		if (pVBInfo->IF_DEF_LVDS == 0) {
 			if (pVBInfo->LCDResInfo == Panel_1600x1200) {
-				if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
+				if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
 					if (yres == 1024)
 						yres = 1056;
 				}
@@ -3814,14 +3814,14 @@ static void XGI_GetCRT2ResInfo(unsigned short ModeNo,
 				else if (yres == 350)
 					yres = 360;
 
-				if (pVBInfo->LCDInfo & LCDVESATiming) {
+				if (pVBInfo->LCDInfo & XGI_LCDVESATiming) {
 					if (yres == 360)
 						yres = 375;
 				}
 			}
 
 			if (pVBInfo->LCDResInfo == Panel_1024x768) {
-				if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
+				if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
 					if (!(pVBInfo->LCDInfo
 							& LCDNonExpanding)) {
 						if (yres == 350)
@@ -3848,7 +3848,7 @@ static void XGI_GetCRT2ResInfo(unsigned short ModeNo,
 static unsigned char XGI_IsLCDDualLink(struct vb_device_info *pVBInfo)
 {
 
-	if ((pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) &&
+	if ((pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) &&
 			(pVBInfo->LCDInfo & SetLCDDualLink)) /* shampoo0129 */
 		return 1;
 
@@ -3942,7 +3942,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempbx = 4;
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 		LCDPtr = (struct SiS_LCDData *) XGI_GetLcdPtr(tempbx,
 				ModeNo, ModeIdIndex, RefreshRateTableIndex,
 				pVBInfo);
@@ -3958,7 +3958,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 			tempax = 1024;
 			tempbx = 768;
 
-			if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
+			if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
 				if (pVBInfo->VGAVDE == 357)
 					tempbx = 527;
 				else if (pVBInfo->VGAVDE == 420)
@@ -4008,7 +4008,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 		} else if (pVBInfo->LCDResInfo == Panel_1600x1200) {
 			tempax = 1600;
 			tempbx = 1200; /* alan 10/14/2003 */
-			if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
+			if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
 				if (pVBInfo->VGAVDE == 350)
 					tempbx = 875;
 				else if (pVBInfo->VGAVDE == 400)
@@ -4620,7 +4620,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->VBInfo & SetCRT2ToLCD) {
 		if (pVBInfo->LCDResInfo == Panel_1024x768) {
-			if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
+			if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
 				if (tempbx == 350)
 					tempbx += 5;
 				if (tempbx == 480)
@@ -5271,7 +5271,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->ModeType == ModeEGA) {
 			if (pVBInfo->VGAHDE >= 1024) {
 				temp = 0x02;
-				if (pVBInfo->LCDInfo & LCDVESATiming)
+				if (pVBInfo->LCDInfo & XGI_LCDVESATiming)
 					temp = 0x01;
 			}
 		}
@@ -5422,7 +5422,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = tempcx & 0x00FF; /* RHSYEXP2S=lcdhre */
 	xgifb_reg_set(pVBInfo->Part2Port, 0x21, temp);
 
-	if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
+	if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
 		if (pVBInfo->VGAVDE == 525) {
 			if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
 					| VB_SIS301LV | VB_SIS302LV
@@ -6145,10 +6145,10 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 		tempah = 0x3F;
 		if (!(pVBInfo->VBInfo &
 		    (DisableCRT2Display | SetSimuScanMode))) {
-			if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
 					tempah = 0x7F; /* Disable Channel A */
-					if (!(pVBInfo->VBInfo & SetCRT2ToLCDA))
+					if (!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA))
 						/* Disable Channel B */
 						tempah = 0xBF;
 
@@ -6167,7 +6167,7 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 		xgifb_reg_and(pVBInfo->Part4Port, 0x1F, tempah);
 
 		if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
-			if (((pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)))
+			if (((pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
 					|| (XGI_DisableChISLCD(pVBInfo))
 					|| (XGI_IsLCDON(pVBInfo)))
 				/* LVDS Driver power down */
@@ -6175,16 +6175,16 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 		}
 
 		if ((pVBInfo->SetFlag & DisableChA) || (pVBInfo->VBInfo
-				& (DisableCRT2Display | SetCRT2ToLCDA
+				& (DisableCRT2Display | XGI_SetCRT2ToLCDA
 						| SetSimuScanMode))) {
 			if (pVBInfo->SetFlag & GatingCRT)
 				XGI_EnableGatingCRT(HwDeviceExtension, pVBInfo);
 			XGI_DisplayOff(xgifb_info, HwDeviceExtension, pVBInfo);
 		}
 
-		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+		if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 			if ((pVBInfo->SetFlag & DisableChA) || (pVBInfo->VBInfo
-					& SetCRT2ToLCDA))
+					& XGI_SetCRT2ToLCDA))
 				/* Power down */
 				xgifb_reg_and(pVBInfo->Part1Port, 0x1e, 0xdf);
 		}
@@ -6198,7 +6198,7 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 		if ((pVBInfo->SetFlag & DisableChB) ||
 		    (pVBInfo->VBInfo &
 			(DisableCRT2Display | SetSimuScanMode)) ||
-		    ((!(pVBInfo->VBInfo & SetCRT2ToLCDA)) &&
+		    ((!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)) &&
 		    (pVBInfo->VBInfo &
 			(SetCRT2ToRAMDAC | SetCRT2ToLCD | SetCRT2ToTV))))
 			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80);
@@ -6206,7 +6206,7 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 		if ((pVBInfo->SetFlag & DisableChB) ||
 		    (pVBInfo->VBInfo &
 			(DisableCRT2Display | SetSimuScanMode)) ||
-		    (!(pVBInfo->VBInfo & SetCRT2ToLCDA)) ||
+		    (!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)) ||
 		    (pVBInfo->VBInfo &
 			(SetCRT2ToRAMDAC | SetCRT2ToLCD | SetCRT2ToTV))) {
 			/* save Part1 index 0 */
@@ -6227,7 +6227,7 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 			xgifb_reg_and(pVBInfo->P3c4, 0x32, 0xDF);
 		}
 
-		if (pVBInfo->VBInfo & (DisableCRT2Display | SetCRT2ToLCDA
+		if (pVBInfo->VBInfo & (DisableCRT2Display | XGI_SetCRT2ToLCDA
 				| SetSimuScanMode))
 			XGI_DisplayOff(xgifb_info, HwDeviceExtension, pVBInfo);
 	}
@@ -6330,7 +6330,7 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 
 	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
 			| VB_SIS302LV | VB_XGI301C)) {
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA
 				| SetCRT2ToTV | SetCRT2ToRAMDAC)) {
 			tempbl = 0;
 			tempbh = 0;
@@ -6345,13 +6345,13 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 
 			if (pVBInfo->VBInfo & SetCRT2ToDualEdge)
 				tempbl = tempbl >> 4;
-			if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+			if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 				/* Get LCD Delay */
 				index = XGI_GetLCDCapPtr(pVBInfo);
 				tempbh = pVBInfo->LCDCapList[index].
 						LCD_DelayCompensation;
 
-				if (!(pVBInfo->VBInfo & SetCRT2ToLCDA))
+				if (!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA))
 					tempbl = tempbh;
 			}
 
@@ -6365,7 +6365,7 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 				tempah |= tempbl;
 			}
 
-			if (pVBInfo->VBInfo & SetCRT2ToLCDA) { /* Channel A */
+			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) { /* Channel A */
 				tempah &= 0x0F;
 				tempah |= tempbh;
 			}
@@ -6497,7 +6497,7 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 			| VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->VBInfo & SetCRT2ToLCD)
 			XGI_SetLCDCap_B(tempcx, pVBInfo);
-		else if (pVBInfo->VBInfo & SetCRT2ToLCDA)
+		else if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)
 			XGI_SetLCDCap_A(tempcx, pVBInfo);
 
 		if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
@@ -6668,7 +6668,7 @@ static void XGI_OEM310Setting(unsigned short ModeNo,
 {
 	XGI_SetDelayComp(pVBInfo);
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA))
 		XGI_SetLCDCap(pVBInfo);
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
@@ -6732,15 +6732,15 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 		tempbl = 0xff;
 
 		if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV
-				| SetCRT2ToLCD | SetCRT2ToLCDA)) {
-			if ((pVBInfo->VBInfo & SetCRT2ToLCDA) &&
+				| SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
+			if ((pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) &&
 			    (!(pVBInfo->VBInfo & SetSimuScanMode))) {
 				tempbl &= 0xf7;
 				tempah |= 0x01;
 				xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e,
 						tempbl, tempah);
 			} else {
-				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 					tempbl &= 0xf7;
 					tempah |= 0x01;
 				}
@@ -6780,7 +6780,7 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	}
 
 	if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV | SetCRT2ToLCD
-			| SetCRT2ToLCDA)) {
+			| XGI_SetCRT2ToLCDA)) {
 		tempah &= (~0x08);
 		if ((pVBInfo->ModeType == ModeVGA) && (!(pVBInfo->VBInfo
 				& SetInSlaveMode))) {
@@ -6824,7 +6824,7 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 
 		if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
 			tempbl = 0xff;
-			if (pVBInfo->VBInfo & SetCRT2ToLCDA)
+			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)
 				tempah |= 0x04; /* shampoo 0129 */
 		}
 
@@ -6849,7 +6849,7 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 
 	tempah = 0;
 	tempbl = 0x7f;
-	if (!(pVBInfo->VBInfo & SetCRT2ToLCDA)) {
+	if (!(pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)) {
 		tempbl = 0xff;
 		if (!(pVBInfo->VBInfo & SetCRT2ToDualEdge))
 			tempah |= 0x80;
@@ -6872,7 +6872,7 @@ static void XGI_CloseCRTC(struct xgi_hw_device_info *HwDeviceExtension,
 
 	tempbx = 0;
 
-	if (pVBInfo->VBInfo & SetCRT2ToLCDA)
+	if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)
 		tempbx = 0x08A0;
 
 }
@@ -6937,7 +6937,7 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 		index--;
 
 	if (pVBInfo->SetFlag & ProgrammingCRT2) {
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 			if (pVBInfo->IF_DEF_LVDS == 0) {
 				if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
 						| VB_SIS301LV | VB_SIS302LV
@@ -7211,7 +7211,7 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 				if (!XGI_DisableChISLCD(pVBInfo)) {
 					if (XGI_EnableChISLCD(pVBInfo) ||
 					    (pVBInfo->VBInfo &
-					    (SetCRT2ToLCD | SetCRT2ToLCDA)))
+					    (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
 						/* LVDS PLL power on */
 						xgifb_reg_and(
 							pVBInfo->Part4Port,
@@ -7229,12 +7229,12 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 			tempah = 0xc0;
 
 			if (!(pVBInfo->VBInfo & SetSimuScanMode)) {
-				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 					if (pVBInfo->VBInfo &
 					    SetCRT2ToDualEdge) {
 						tempah = tempah & 0x40;
 						if (pVBInfo->VBInfo &
-						    SetCRT2ToLCDA)
+						    XGI_SetCRT2ToLCDA)
 							tempah = tempah ^ 0xC0;
 
 						if (pVBInfo->SetFlag &
@@ -7271,7 +7271,7 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 	} /* 301 */
 	else { /* LVDS */
 		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD
-				| SetCRT2ToLCDA))
+				| XGI_SetCRT2ToLCDA))
 			/* enable CRT2 */
 			xgifb_reg_or(pVBInfo->Part1Port, 0x1E, 0x20);
 
@@ -7313,7 +7313,7 @@ static void XGI_SetCRT1Group(struct xgifb_video_info *xgifb_info,
 
 	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
 			| VB_SIS302LV | VB_XGI301C)) {
-		if (pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToLCDA
+		if (pVBInfo->VBInfo & (SetSimuScanMode | XGI_SetCRT2ToLCDA
 				| SetInSlaveMode)) {
 			pVBInfo->SetFlag |= ProgrammingCRT2;
 		}
@@ -7452,11 +7452,11 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 		XGI_GetLCDInfo(ModeNo, ModeIdIndex, pVBInfo);
 		XGI_DisableBridge(xgifb_info, HwDeviceExtension, pVBInfo);
 
-		if (pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToLCDA)) {
+		if (pVBInfo->VBInfo & (SetSimuScanMode | XGI_SetCRT2ToLCDA)) {
 			XGI_SetCRT1Group(xgifb_info, HwDeviceExtension, ModeNo,
 					ModeIdIndex, pVBInfo);
 
-			if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 				XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
 						HwDeviceExtension, pVBInfo);
 			}
@@ -7465,7 +7465,7 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 				XGI_SetCRT1Group(xgifb_info,
 						HwDeviceExtension, ModeNo,
 						ModeIdIndex, pVBInfo);
-				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 					XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
 							HwDeviceExtension,
 							pVBInfo);
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 4f803b6..dddf261 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -2505,17 +2505,17 @@ static struct XGI330_LCDCapStruct  XGI_LCDDLCapList[] = {
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024 */
-	{Panel_1280x1024, LCDDualLink+DefaultLCDCap, StLCDBToA,
+	{Panel_1280x1024, XGI_LCDDualLink+DefaultLCDCap, StLCDBToA,
 	0x012, 0x70, 0x03, VCLK108_2_315,
 	0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1400x1050 */
-	{Panel_1400x1050, LCDDualLink+DefaultLCDCap, StLCDBToA,
+	{Panel_1400x1050, XGI_LCDDualLink+DefaultLCDCap, StLCDBToA,
 	0x012, 0x70, 0x03, VCLK108_2_315,
 	 0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1600x1200 */
-	{Panel_1600x1200, LCDDualLink+DefaultLCDCap, LCDToFull,
+	{Panel_1600x1200, XGI_LCDDualLink+DefaultLCDCap, LCDToFull,
 	0x012, 0xC0, 0x03, VCLK162,
 	 0x43, 0x22, 0x70, 0x24, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
@@ -2524,7 +2524,7 @@ static struct XGI330_LCDCapStruct  XGI_LCDDLCapList[] = {
 	 0x2B, 0x61, 0x2B, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024x75 */
-	{Panel_1280x1024x75, LCDDualLink+DefaultLCDCap, StLCDBToA,
+	{Panel_1280x1024x75, XGI_LCDDualLink+DefaultLCDCap, StLCDBToA,
 	0x012, 0x90, 0x03, VCLK135_5,
 	 0x54, 0x42, 0x4A, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
-- 
1.7.3.4

