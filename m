Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2BIUM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:12:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57461 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932120Ab2BIUMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:21 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/V2yxOadrVy3jvWEsqbUKvWRM7jNZF80zi6ycTmO
	RUaj36YRYK2zYj
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/7] staging/xgifb: Rename Set* defines and remove duplicated defines
Date: Thu,  9 Feb 2012 21:11:45 +0100
Message-Id: <1328818309-5103-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
References: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the Set* defines and their usage to the naming
convention of the sis initdef.h and removes the now duplicated defines.

Renames:
SetCRT2ToHiVisionTV -> SetCRT2ToHiVision
SetCRT2ToYPbPr -> SetCRT2ToYPbPr525750

SetNTSCJ -> TVSetNTSCJ
SetPALMTV -> TVSetPALM
SetPALNTV -> TVSetPALN
SetPALTV -> TVSetPAL

SetYPbPrMode1080i -> TVSetHiVision
SetYPbPrMode525i -> TVSetYPbPr525i
SetYPbPrMode525p -> TVSetYPbPr525p
SetYPbPrMode750p -> TVSetYPbPr750p

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h     |   10 --
 drivers/staging/xgifb/vb_init.c    |    4 +-
 drivers/staging/xgifb/vb_setmode.c |  244 ++++++++++++++++++------------------
 3 files changed, 124 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 9b2937c..c368322 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -131,11 +131,9 @@
 #define SetCRT2ToSCART      0x0010
 #define SetCRT2ToLCD        0x0020
 #define SetCRT2ToRAMDAC     0x0040
-#define SetCRT2ToHiVisionTV 0x0080
 #define SetCRT2ToLCDA       0x0100
 #define SetInSlaveMode      0x0200
 #define SetNotSimuMode      0x0400
-#define SetCRT2ToYPbPr      0x0800
 #define LoadDACFlag         0x1000
 #define DisableCRT2Display  0x2000
 #define DriverMode          0x4000
@@ -150,14 +148,6 @@
 #define EnableChA           0x8000
 
 #define SetNTSCTV           0x0000 /* TV Info */
-#define SetPALTV            0x0001
-#define SetNTSCJ            0x0002
-#define SetPALMTV           0x0004
-#define SetPALNTV           0x0008
-#define SetYPbPrMode525i     0x0020
-#define SetYPbPrMode525p     0x0040
-#define SetYPbPrMode750p     0x0080
-#define SetYPbPrMode1080i    0x0100
 #define SetTVLowResolution   0x0400
 #define TVSimuMode           0x0800
 #define RPLLDIV2XO           0x1000
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index a53a097..4c54568 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1268,7 +1268,7 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 
 				if (pVBInfo->IF_DEF_HiVision == 1) {
 					if ((temp >> 8) & ActiveHiTV)
-						tempcl |= SetCRT2ToHiVisionTV;
+						tempcl |= SetCRT2ToHiVision;
 				}
 
 				if (pVBInfo->IF_DEF_YPbPr == 1) {
@@ -1287,7 +1287,7 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 
 		if (pVBInfo->IF_DEF_HiVision == 1) {
 			if ((temp >> 8) & ActiveHiTV)
-				tempcl |= SetCRT2ToHiVisionTV;
+				tempcl |= SetCRT2ToHiVision;
 		}
 
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 25c647b..ea142e9 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -372,7 +372,7 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 			}
 		}
 
-		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) { /* for HiTV */
+		if (pVBInfo->VBInfo & SetCRT2ToHiVision) { /* for HiTV */
 			if ((pVBInfo->VBType & VB_XGI301LV) &&
 			    (pVBInfo->VBExtInfo == VB_YPbPr1080i)) {
 				tempax |= SupportYPbPr;
@@ -406,8 +406,8 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 			if (pVBInfo->VBInfo & (SetCRT2ToAVIDEO |
 					       SetCRT2ToSVIDEO |
 					       SetCRT2ToSCART |
-					       SetCRT2ToYPbPr |
-					       SetCRT2ToHiVisionTV)) {
+					       SetCRT2ToYPbPr525750 |
+					       SetCRT2ToHiVision)) {
 				tempax |= SupportTV;
 
 				if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
@@ -416,7 +416,7 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 					tempax |= SupportTV1024;
 				}
 
-				if (!(pVBInfo->VBInfo & SetPALTV)) {
+				if (!(pVBInfo->VBInfo & TVSetPAL)) {
 					if (modeflag & NoSupportSimuTV) {
 						if (pVBInfo->VBInfo &
 						    SetInSlaveMode) {
@@ -1271,7 +1271,7 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 				VCLKIndex = LCDXlat2VCLK[CRT2Index];
 			else
 				VCLKIndex = LCDXlat1VCLK[CRT2Index];
-		} else if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+		} else if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 			if (pVBInfo->SetFlag & RPLLDIV2XO) {
 				VCLKIndex = HiTVVCLKDIV2;
 				VCLKIndex += 25;
@@ -2844,7 +2844,7 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 		     VB_XGI301LV |
 		     VB_XGI302LV |
 		     VB_XGI301C)) {
-			if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+			if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 				tempal = HiTVVCLKDIV2;
 				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
 					tempal = HiTVVCLK;
@@ -2857,12 +2857,12 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 				return tempal;
 			}
 
-			if (pVBInfo->TVInfo & SetYPbPrMode750p) {
+			if (pVBInfo->TVInfo & TVSetYPbPr750p) {
 				tempal = YPbPr750pVCLK;
 				return tempal;
 			}
 
-			if (pVBInfo->TVInfo & SetYPbPrMode525p) {
+			if (pVBInfo->TVInfo & TVSetYPbPr525p) {
 				tempal = YPbPr525pVCLK;
 				return tempal;
 			}
@@ -2987,12 +2987,12 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 				if (temp & 0x02)
 					tempch |= ActiveSCART;
 
-				if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+				if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 					if (temp & 0x01)
 						tempch |= ActiveHiTV;
 				}
 
-				if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
+				if (pVBInfo->VBInfo & SetCRT2ToYPbPr525750) {
 					temp = xgifb_reg_get(
 							pVBInfo->Part2Port,
 							0x4d);
@@ -3090,7 +3090,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		push = push << 8;
 		tempax = temp << 8;
 		tempbx = tempbx | tempax;
-		temp = (SetCRT2ToDualEdge | SetCRT2ToYPbPr | SetCRT2ToLCDA
+		temp = (SetCRT2ToDualEdge | SetCRT2ToYPbPr525750 | SetCRT2ToLCDA
 				| SetInSlaveMode | DisableCRT2Display);
 		temp = 0xFFFF ^ temp;
 		tempbx &= temp;
@@ -3134,13 +3134,13 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 								pVBInfo->P3d4,
 								0x35);
 						temp &= YPbPrMode;
-						tempbx |= SetCRT2ToHiVisionTV;
+						tempbx |= SetCRT2ToHiVision;
 
 						if (temp != YPbPrMode1080i) {
 							tempbx &=
-							 (~SetCRT2ToHiVisionTV);
+							 (~SetCRT2ToHiVision);
 							tempbx |=
-							 SetCRT2ToYPbPr;
+							 SetCRT2ToYPbPr525750;
 						}
 					}
 				}
@@ -3195,7 +3195,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 						   SetCRT2ToRAMDAC |
 						   SwitchToCRT2 |
 						   SetSimuScanMode);
-					tempbx &= (0x00FF | (~SetCRT2ToYPbPr));
+					tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 				}
 			} else {
 				tempbx &= (~(SetCRT2ToRAMDAC |
@@ -3210,7 +3210,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 					   SetCRT2ToLCD |
 					   SwitchToCRT2 |
 					   SetSimuScanMode);
-				tempbx &= (0x00FF | (~SetCRT2ToYPbPr));
+				tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 			}
 		}
 
@@ -3219,20 +3219,20 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 				   SetCRT2ToSCART |
 				   SwitchToCRT2 |
 				   SetSimuScanMode);
-			tempbx &= (0x00FF | (~SetCRT2ToYPbPr));
+			tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 		}
 
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
-			if (tempbx & SetCRT2ToYPbPr)
+			if (tempbx & SetCRT2ToYPbPr525750)
 				tempbx &= (0xFF00 |
 					   SwitchToCRT2 |
 					   SetSimuScanMode);
 		}
 
 		if (pVBInfo->IF_DEF_HiVision == 1) {
-			if (tempbx & SetCRT2ToHiVisionTV)
+			if (tempbx & SetCRT2ToHiVision)
 				tempbx &= (0xFF00 |
-					   SetCRT2ToHiVisionTV |
+					   SetCRT2ToHiVision |
 					   SwitchToCRT2 |
 					   SetSimuScanMode);
 		}
@@ -3291,43 +3291,43 @@ static void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->VBInfo & SetCRT2ToTV) {
 			temp = xgifb_reg_get(pVBInfo->P3d4, 0x35);
 			tempbx = temp;
-			if (tempbx & SetPALTV) {
+			if (tempbx & TVSetPAL) {
 				tempbx &= (SetCHTVOverScan |
-					   SetPALMTV |
-					   SetPALNTV |
-					   SetPALTV);
-				if (tempbx & SetPALMTV)
+					   TVSetPALM |
+					   TVSetPALN |
+					   TVSetPAL);
+				if (tempbx & TVSetPALM)
 					/* set to NTSC if PAL-M */
-					tempbx &= ~SetPALTV;
+					tempbx &= ~TVSetPAL;
 			} else
 				tempbx &= (SetCHTVOverScan |
-					   SetNTSCJ |
-					   SetPALTV);
+					   TVSetNTSCJ |
+					   TVSetPAL);
 		}
 
 		if (pVBInfo->IF_DEF_LVDS == 0) {
 			if (pVBInfo->VBInfo & SetCRT2ToSCART)
-				tempbx |= SetPALTV;
+				tempbx |= TVSetPAL;
 		}
 
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
-			if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
+			if (pVBInfo->VBInfo & SetCRT2ToYPbPr525750) {
 				index1 = xgifb_reg_get(pVBInfo->P3d4, 0x35);
 				index1 &= YPbPrMode;
 
 				if (index1 == YPbPrMode525i)
-					tempbx |= SetYPbPrMode525i;
+					tempbx |= TVSetYPbPr525i;
 
 				if (index1 == YPbPrMode525p)
-					tempbx = tempbx | SetYPbPrMode525p;
+					tempbx = tempbx | TVSetYPbPr525p;
 				if (index1 == YPbPrMode750p)
-					tempbx = tempbx | SetYPbPrMode750p;
+					tempbx = tempbx | TVSetYPbPr750p;
 			}
 		}
 
 		if (pVBInfo->IF_DEF_HiVision == 1) {
-			if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
-				tempbx = tempbx | SetYPbPrMode1080i | SetPALTV;
+			if (pVBInfo->VBInfo & SetCRT2ToHiVision)
+				tempbx = tempbx | TVSetHiVision | TVSetPAL;
 		}
 
 		if (pVBInfo->IF_DEF_LVDS == 0) { /* shampoo */
@@ -3335,19 +3335,19 @@ static void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			    (!(pVBInfo->VBInfo & SetNotSimuMode)))
 				tempbx |= TVSimuMode;
 
-			if (!(tempbx & SetPALTV) &&
+			if (!(tempbx & TVSetPAL) &&
 			    (modeflag > 13) &&
 			    (resinfo == 8)) /* NTSC 1024x768, */
 				tempbx |= NTSC1024x768;
 
 			tempbx |= RPLLDIV2XO;
 
-			if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+			if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 				if (pVBInfo->VBInfo & SetInSlaveMode)
 					tempbx &= (~RPLLDIV2XO);
 			} else {
 				if (tempbx &
-				    (SetYPbPrMode525p | SetYPbPrMode750p))
+				    (TVSetYPbPr525p | TVSetYPbPr750p))
 					tempbx &= (~RPLLDIV2XO);
 				else if (!(pVBInfo->VBType &
 					 (VB_XGI301B |
@@ -4041,7 +4041,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 		pVBInfo->RVBHRS = TVPtr->RVBHRS;
 		pVBInfo->NewFlickerMode = TVPtr->FlickerMode;
 
-		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+		if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 			if (resinfo == 0x08)
 				pVBInfo->NewFlickerMode = 0x40;
 			else if (resinfo == 0x09)
@@ -4066,16 +4066,16 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 					}
 				}
 			}
-		} else if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
-			if (pVBInfo->TVInfo & SetYPbPrMode750p) {
+		} else if (pVBInfo->VBInfo & SetCRT2ToYPbPr525750) {
+			if (pVBInfo->TVInfo & TVSetYPbPr750p) {
 				tempax = YPbPrTV750pHT; /* Ext750pTVHT */
 				tempbx = YPbPrTV750pVT; /* Ext750pTVVT */
 			}
 
-			if (pVBInfo->TVInfo & SetYPbPrMode525p) {
+			if (pVBInfo->TVInfo & TVSetYPbPr525p) {
 				tempax = YPbPrTV525pHT; /* Ext525pTVHT */
 				tempbx = YPbPrTV525pVT; /* Ext525pTVVT */
-			} else if (pVBInfo->TVInfo & SetYPbPrMode525i) {
+			} else if (pVBInfo->TVInfo & TVSetYPbPr525i) {
 				tempax = YPbPrTV525iHT; /* Ext525iTVHT */
 				tempbx = YPbPrTV525iVT; /* Ext525iTVVT */
 				if (pVBInfo->TVInfo & NTSC1024x768)
@@ -4084,7 +4084,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 		} else {
 			tempax = PALHT;
 			tempbx = PALVT;
-			if (!(pVBInfo->TVInfo & SetPALTV)) {
+			if (!(pVBInfo->TVInfo & TVSetPAL)) {
 				tempax = NTSCHT;
 				tempbx = NTSCVT;
 				if (pVBInfo->TVInfo & NTSC1024x768)
@@ -4455,7 +4455,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 				| VB_XGI302LV | VB_XGI301C)))
 			temp += 2;
 
-		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+		if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 			if (pVBInfo->VBType & VB_XGI301LV) {
 				if (pVBInfo->VBExtInfo == VB_YPbPr1080i) {
 					if (resinfo == 7)
@@ -4487,7 +4487,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempax = (tempax / tempcx) - 5;
 	tempcx = tempax; /* 20030401 0x07 horizontal Retrace Start */
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 		temp = (tempbx & 0x00FF) - 1;
 		if (!(modeflag & HalfDCLK)) {
 			temp -= 6;
@@ -4669,19 +4669,19 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempbx += tempax;
 	}
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 		if (pVBInfo->VBType & VB_XGI301LV) {
-			if (pVBInfo->TVInfo & SetYPbPrMode1080i) {
+			if (pVBInfo->TVInfo & TVSetHiVision) {
 				tempbx -= 10;
 			} else {
 				if (pVBInfo->TVInfo & TVSimuMode) {
-					if (pVBInfo->TVInfo & SetPALTV) {
+					if (pVBInfo->TVInfo & TVSetPAL) {
 						if (pVBInfo->VBType &
 						    VB_XGI301LV) {
 							if (!(pVBInfo->TVInfo &
-							    (SetYPbPrMode525p |
-							    SetYPbPrMode750p |
-							    SetYPbPrMode1080i)))
+							    (TVSetYPbPr525p |
+							    TVSetYPbPr750p |
+							    TVSetHiVision)))
 								tempbx += 40;
 						} else {
 							tempbx += 40;
@@ -4694,12 +4694,12 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	} else {
 		if (pVBInfo->TVInfo & TVSimuMode) {
-			if (pVBInfo->TVInfo & SetPALTV) {
+			if (pVBInfo->TVInfo & TVSetPAL) {
 				if (pVBInfo->VBType & VB_XGI301LV) {
 					if (!(pVBInfo->TVInfo &
-					    (SetYPbPrMode525p |
-					     SetYPbPrMode750p |
-					     SetYPbPrMode1080i)))
+					    (TVSetYPbPr525p |
+					     TVSetYPbPr750p |
+					     TVSetHiVision)))
 						tempbx += 40;
 				} else {
 					tempbx += 40;
@@ -4713,7 +4713,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempax += tempbx;
 	push1 = tempax; /* push ax */
 
-	if ((pVBInfo->TVInfo & SetPALTV)) {
+	if ((pVBInfo->TVInfo & TVSetPAL)) {
 		if (tempbx <= 513) {
 			if (tempax >= 513)
 				tempbx = 513;
@@ -4813,13 +4813,13 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (pVBInfo->VBInfo & SetCRT2ToSCART)
 		tempax |= 0x0200;
 
-	if (!(pVBInfo->TVInfo & SetPALTV))
+	if (!(pVBInfo->TVInfo & TVSetPAL))
 		tempax |= 0x1000;
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision)
 		tempax |= 0x0100;
 
-	if (pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p))
+	if (pVBInfo->TVInfo & (TVSetYPbPr525p | TVSetYPbPr750p))
 		tempax &= 0xfe00;
 
 	tempax = (tempax & 0xff00) >> 8;
@@ -4827,10 +4827,10 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part2Port, 0x0, tempax);
 	TimingPoint = pVBInfo->NTSCTiming;
 
-	if (pVBInfo->TVInfo & SetPALTV)
+	if (pVBInfo->TVInfo & TVSetPAL)
 		TimingPoint = pVBInfo->PALTiming;
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 		TimingPoint = pVBInfo->HiTVExtTiming;
 
 		if (pVBInfo->VBInfo & SetInSlaveMode)
@@ -4843,14 +4843,14 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 			TimingPoint = pVBInfo->HiTVTextTiming;
 	}
 
-	if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
-		if (pVBInfo->TVInfo & SetYPbPrMode525i)
+	if (pVBInfo->VBInfo & SetCRT2ToYPbPr525750) {
+		if (pVBInfo->TVInfo & TVSetYPbPr525i)
 			TimingPoint = pVBInfo->YPbPr525iTiming;
 
-		if (pVBInfo->TVInfo & SetYPbPrMode525p)
+		if (pVBInfo->TVInfo & TVSetYPbPr525p)
 			TimingPoint = pVBInfo->YPbPr525pTiming;
 
-		if (pVBInfo->TVInfo & SetYPbPrMode750p)
+		if (pVBInfo->TVInfo & TVSetYPbPr750p)
 			TimingPoint = pVBInfo->YPbPr750pTiming;
 	}
 
@@ -4868,10 +4868,10 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp &= 0x80;
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0A, 0xFF, temp);
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision)
 		tempax = 950;
 
-	if (pVBInfo->TVInfo & SetPALTV)
+	if (pVBInfo->TVInfo & TVSetPAL)
 		tempax = 520;
 	else
 		tempax = 440;
@@ -4888,11 +4888,11 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 				| VB_XGI302LV | VB_XGI301C)) {
 			if (pVBInfo->VBInfo & (SetCRT2ToAVIDEO
 					| SetCRT2ToSVIDEO | SetCRT2ToSCART
-					| SetCRT2ToYPbPr)) {
+					| SetCRT2ToYPbPr525750)) {
 				tempcx = pVBInfo->VGAHDE;
 				if (tempcx >= 1024) {
 					temp = 0x17; /* NTSC */
-					if (pVBInfo->TVInfo & SetPALTV)
+					if (pVBInfo->TVInfo & TVSetPAL)
 						temp = 0x19; /* PAL */
 				}
 			}
@@ -4907,11 +4907,11 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 				| VB_XGI302LV | VB_XGI301C)) {
 			if ((pVBInfo->VBInfo & (SetCRT2ToAVIDEO
 					| SetCRT2ToSVIDEO | SetCRT2ToSCART
-					| SetCRT2ToYPbPr))) {
+					| SetCRT2ToYPbPr525750))) {
 				tempcx = pVBInfo->VGAHDE;
 				if (tempcx >= 1024) {
 					temp = 0x1D; /* NTSC */
-					if (pVBInfo->TVInfo & SetPALTV)
+					if (pVBInfo->TVInfo & TVSetPAL)
 						temp = 0x52; /* PAL */
 				}
 			}
@@ -4936,7 +4936,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	push1 = tempcx; /* push cx */
 	tempcx += 7;
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision)
 		tempcx -= 4;
 
 	temp = tempcx & 0x00FF;
@@ -4954,7 +4954,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempbx = push2;
 	tempbx = tempbx + 8;
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 		tempbx = tempbx - 4;
 		tempcx = tempbx;
 	}
@@ -4970,7 +4970,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x28, 0x0F, temp);
 
 	tempcx += 8;
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision)
 		tempcx -= 4;
 
 	temp = tempcx & 0xFF;
@@ -5007,7 +5007,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->VBType &
 		    (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
 			if (!(pVBInfo->TVInfo &
-			    (SetYPbPrMode525p | SetYPbPrMode750p)))
+			    (TVSetYPbPr525p | TVSetYPbPr750p)))
 				tempbx = tempbx >> 1;
 		} else
 			tempbx = tempbx >> 1;
@@ -5016,9 +5016,9 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx -= 2;
 	temp = tempbx & 0x00FF;
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 		if (pVBInfo->VBType & VB_XGI301LV) {
-			if (pVBInfo->TVInfo & SetYPbPrMode1080i) {
+			if (pVBInfo->TVInfo & TVSetHiVision) {
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
 					if (ModeNo == 0x2f)
 						temp += 1;
@@ -5037,9 +5037,9 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = (tempcx & 0xFF00) >> 8;
 	temp |= ((tempbx & 0xFF00) >> 8) << 6;
 
-	if (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)) {
+	if (!(pVBInfo->VBInfo & SetCRT2ToHiVision)) {
 		if (pVBInfo->VBType & VB_XGI301LV) {
-			if (pVBInfo->TVInfo & SetYPbPrMode1080i) {
+			if (pVBInfo->TVInfo & TVSetHiVision) {
 				temp |= 0x10;
 
 				if (!(pVBInfo->VBInfo & SetCRT2ToSVIDEO))
@@ -5060,8 +5060,8 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx = tempbx - 2;
 
 		if (pVBInfo->VBInfo & SetCRT2ToTV) {
-			if (!(pVBInfo->TVInfo & (SetYPbPrMode525p
-					| SetYPbPrMode750p)))
+			if (!(pVBInfo->TVInfo & (TVSetYPbPr525p
+					| TVSetYPbPr750p)))
 				tempbx = tempbx >> 1;
 		}
 
@@ -5161,7 +5161,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp |= 0x18;
 
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x46, ~0x1F, temp);
-	if (pVBInfo->TVInfo & SetPALTV) {
+	if (pVBInfo->TVInfo & TVSetPAL) {
 		tempbx = 0x0382;
 		tempcx = 0x007e;
 	} else {
@@ -5178,13 +5178,13 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = temp << 2;
 	temp |= ((tempbx & 0xFF00) >> 8) & 0x03;
 
-	if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
+	if (pVBInfo->VBInfo & SetCRT2ToYPbPr525750) {
 		temp |= 0x10;
 
-		if (pVBInfo->TVInfo & SetYPbPrMode525p)
+		if (pVBInfo->TVInfo & TVSetYPbPr525p)
 			temp |= 0x20;
 
-		if (pVBInfo->TVInfo & SetYPbPrMode750p)
+		if (pVBInfo->TVInfo & TVSetYPbPr750p)
 			temp |= 0x60;
 	}
 
@@ -5192,7 +5192,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = xgifb_reg_get(pVBInfo->Part2Port, 0x43); /* 301b change */
 	xgifb_reg_set(pVBInfo->Part2Port, 0x43, (unsigned short) (temp - 3));
 
-	if (!(pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p))) {
+	if (!(pVBInfo->TVInfo & (TVSetYPbPr525p | TVSetYPbPr750p))) {
 		if (pVBInfo->TVInfo & NTSC1024x768) {
 			TimingPoint = XGI_NTSC1024AdjTime;
 			for (i = 0x1c, j = 0; i <= 0x30; i++, j++) {
@@ -5205,12 +5205,12 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	/* [ycchen] 01/14/03 Modify for 301C PALM Support */
 	if (pVBInfo->VBType & VB_XGI301C) {
-		if (pVBInfo->TVInfo & SetPALMTV)
+		if (pVBInfo->TVInfo & TVSetPALM)
 			xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x08,
 					0x08); /* PALM Mode */
 	}
 
-	if (pVBInfo->TVInfo & SetPALMTV) {
+	if (pVBInfo->TVInfo & TVSetPALM) {
 		tempax = (unsigned char) xgifb_reg_get(pVBInfo->Part2Port,
 				0x01);
 		tempax--;
@@ -5219,7 +5219,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		xgifb_reg_and(pVBInfo->Part2Port, 0x00, 0xEF);
 	}
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 		if (!(pVBInfo->VBInfo & SetInSlaveMode))
 			xgifb_reg_set(pVBInfo->Part2Port, 0x0B, 0x00);
 	}
@@ -5473,18 +5473,18 @@ static struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx,
 	else
 		Tap4TimingPtr = xgifb_ntsc_525_tap4_timing; /* NTSC */
 
-	if (pVBInfo->TVInfo & SetPALTV)
+	if (pVBInfo->TVInfo & TVSetPAL)
 		Tap4TimingPtr = PALTap4Timing;
 
-	if (pVBInfo->VBInfo & SetCRT2ToYPbPr) {
-		if ((pVBInfo->TVInfo & SetYPbPrMode525i) ||
-			(pVBInfo->TVInfo & SetYPbPrMode525p))
+	if (pVBInfo->VBInfo & SetCRT2ToYPbPr525750) {
+		if ((pVBInfo->TVInfo & TVSetYPbPr525i) ||
+			(pVBInfo->TVInfo & TVSetYPbPr525p))
 			Tap4TimingPtr = xgifb_ntsc_525_tap4_timing;
-		if (pVBInfo->TVInfo & SetYPbPrMode750p)
+		if (pVBInfo->TVInfo & TVSetYPbPr750p)
 			Tap4TimingPtr = YPbPr750pTap4Timing;
 	}
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV)
+	if (pVBInfo->VBInfo & SetCRT2ToHiVision)
 		Tap4TimingPtr = xgifb_tap4_timing;
 
 	i = 0;
@@ -5510,7 +5510,7 @@ static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 		xgifb_reg_set(pVBInfo->Part2Port, i, Tap4TimingPtr->Reg[j]);
 
 	if ((pVBInfo->VBInfo & SetCRT2ToTV) &&
-	    (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV))) {
+	    (!(pVBInfo->VBInfo & SetCRT2ToHiVision))) {
 		/* Set Vertical Scaling */
 		Tap4TimingPtr = XGI_GetTap4Ptr(1, pVBInfo);
 		for (i = 0xC0, j = 0; i < 0xFF; i++, j++)
@@ -5520,7 +5520,7 @@ static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 	}
 
 	if ((pVBInfo->VBInfo & SetCRT2ToTV) &&
-	    (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)))
+	    (!(pVBInfo->VBInfo & SetCRT2ToHiVision)))
 		/* Enable V.Scaling */
 		xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x14, 0x04);
 	else
@@ -5543,7 +5543,7 @@ static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
 	xgifb_reg_set(pVBInfo->Part3Port, 0x00, 0x00);
-	if (pVBInfo->TVInfo & SetPALTV) {
+	if (pVBInfo->TVInfo & TVSetPAL) {
 		xgifb_reg_set(pVBInfo->Part3Port, 0x13, 0xFA);
 		xgifb_reg_set(pVBInfo->Part3Port, 0x14, 0xC8);
 	} else {
@@ -5554,15 +5554,15 @@ static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (!(pVBInfo->VBInfo & SetCRT2ToTV))
 		return;
 
-	if (pVBInfo->TVInfo & SetPALMTV) {
+	if (pVBInfo->TVInfo & TVSetPALM) {
 		xgifb_reg_set(pVBInfo->Part3Port, 0x13, 0xFA);
 		xgifb_reg_set(pVBInfo->Part3Port, 0x14, 0xC8);
 		xgifb_reg_set(pVBInfo->Part3Port, 0x3D, 0xA8);
 	}
 
-	if ((pVBInfo->VBInfo & SetCRT2ToHiVisionTV) || (pVBInfo->VBInfo
-			& SetCRT2ToYPbPr)) {
-		if (pVBInfo->TVInfo & SetYPbPrMode525i)
+	if ((pVBInfo->VBInfo & SetCRT2ToHiVision) || (pVBInfo->VBInfo
+			& SetCRT2ToYPbPr525750)) {
+		if (pVBInfo->TVInfo & TVSetYPbPr525i)
 			return;
 
 		tempdi = pVBInfo->HiTVGroup3Data;
@@ -5572,17 +5572,17 @@ static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 				tempdi = pVBInfo->HiTVGroup3Text;
 		}
 
-		if (pVBInfo->TVInfo & SetYPbPrMode525p)
+		if (pVBInfo->TVInfo & TVSetYPbPr525p)
 			tempdi = pVBInfo->Ren525pGroup3;
 
-		if (pVBInfo->TVInfo & SetYPbPrMode750p)
+		if (pVBInfo->TVInfo & TVSetYPbPr750p)
 			tempdi = pVBInfo->Ren750pGroup3;
 
 		for (i = 0; i <= 0x3E; i++)
 			xgifb_reg_set(pVBInfo->Part3Port, i, tempdi[i]);
 
 		if (pVBInfo->VBType & VB_XGI301C) { /* Marcovision */
-			if (pVBInfo->TVInfo & SetYPbPrMode525p)
+			if (pVBInfo->TVInfo & TVSetYPbPr525p)
 				xgifb_reg_set(pVBInfo->Part3Port, 0x28, 0x3f);
 		}
 	}
@@ -5637,7 +5637,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (XGI_IsLCDDualLink(pVBInfo))
 		tempbx = tempbx >> 1;
 
-	if (tempcx & SetCRT2ToHiVisionTV) {
+	if (tempcx & SetCRT2ToHiVision) {
 		temp = 0;
 		if (tempbx <= 1024)
 			temp = 0xA0;
@@ -5656,7 +5656,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	if (pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p)) {
+	if (pVBInfo->TVInfo & (TVSetYPbPr525p | TVSetYPbPr750p)) {
 		temp = 0x00;
 		if (pVBInfo->VGAHDE == 1280)
 			temp = 0x40;
@@ -5667,7 +5667,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempebx = pVBInfo->VDE;
 
-	if (tempcx & SetCRT2ToHiVisionTV) {
+	if (tempcx & SetCRT2ToHiVision) {
 		if (!(temp & 0xE000))
 			tempbx = tempbx >> 1;
 	}
@@ -5735,7 +5735,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = (tempax & 0x00FF);
 		xgifb_reg_set(pVBInfo->Part4Port, 0x1D, temp);
 
-		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToHiVisionTV)) {
+		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToHiVision)) {
 			if (pVBInfo->VGAHDE > 800)
 				xgifb_reg_or(pVBInfo->Part4Port, 0x1E, 0x08);
 
@@ -5744,8 +5744,8 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		if (pVBInfo->VBInfo & SetCRT2ToTV) {
 			if (!(pVBInfo->TVInfo & (NTSC1024x768
-					| SetYPbPrMode525p | SetYPbPrMode750p
-					| SetYPbPrMode1080i))) {
+					| TVSetYPbPr525p | TVSetYPbPr750p
+					| TVSetHiVision))) {
 				temp |= 0x0001;
 				if ((pVBInfo->VBInfo & SetInSlaveMode)
 						&& (!(pVBInfo->TVInfo
@@ -6254,15 +6254,15 @@ static unsigned short XGI_GetTVPtrIndex(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx = 0;
 
-	if (pVBInfo->TVInfo & SetPALTV)
+	if (pVBInfo->TVInfo & TVSetPAL)
 		tempbx = 2;
-	if (pVBInfo->TVInfo & SetYPbPrMode1080i)
+	if (pVBInfo->TVInfo & TVSetHiVision)
 		tempbx = 4;
-	if (pVBInfo->TVInfo & SetYPbPrMode525i)
+	if (pVBInfo->TVInfo & TVSetYPbPr525i)
 		tempbx = 6;
-	if (pVBInfo->TVInfo & SetYPbPrMode525p)
+	if (pVBInfo->TVInfo & TVSetYPbPr525p)
 		tempbx = 8;
-	if (pVBInfo->TVInfo & SetYPbPrMode750p)
+	if (pVBInfo->TVInfo & TVSetYPbPr750p)
 		tempbx = 10;
 	if (pVBInfo->TVInfo & TVSimuMode)
 		tempbx++;
@@ -6293,18 +6293,18 @@ static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
 	*tempcl = 0;
 	*tempch = 0;
 
-	if (pVBInfo->TVInfo & SetPALTV)
+	if (pVBInfo->TVInfo & TVSetPAL)
 		*tempbx = 1;
 
-	if (pVBInfo->TVInfo & SetPALMTV)
+	if (pVBInfo->TVInfo & TVSetPALM)
 		*tempbx = 2;
 
-	if (pVBInfo->TVInfo & SetPALNTV)
+	if (pVBInfo->TVInfo & TVSetPALN)
 		*tempbx = 3;
 
 	if (pVBInfo->TVInfo & NTSC1024x768) {
 		*tempbx = 4;
-		if (pVBInfo->TVInfo & SetPALMTV)
+		if (pVBInfo->TVInfo & TVSetPALM)
 			*tempbx = 5;
 	}
 
@@ -6524,7 +6524,7 @@ static void XGI_SetAntiFlicker(unsigned short ModeNo,
 
 	unsigned char tempah;
 
-	if (pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p))
+	if (pVBInfo->TVInfo & (TVSetYPbPr525p | TVSetYPbPr750p))
 		return;
 
 	tempbx = XGI_GetTVPtrIndex(pVBInfo);
-- 
1.7.3.4

