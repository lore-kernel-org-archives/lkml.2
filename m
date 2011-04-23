Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1DWLhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 07:37:21 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63848 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1DWLhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 07:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Bg6HFUwPx9dNs1nP5qt2fga5x/2xzcRS/1L2RoGO5pF1eZF92wqoRj3f5SgH1uenzx
         K4Sp8MW+efke6g5dt0dO2oVCxDDI+23ofJeN5l6TEqrHrbea9T5kmRdGjuM07Z2qLXmv
         lWKyt4v5UOUnMlJQY+t/wufoiGAB371DkQt60=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, aaro.koskinen@iki.fi
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 5/5] Staging: xgifb: Fixed lots of coding style issues.
Date: Sat, 23 Apr 2011 19:36:49 +0800
Message-Id: <1303558609-1501-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were hundreds of warnings and errors given by checkpatch.pl but
now it's down to 20. These ones that were left in the code need some
more attention, cause I reckon the functions are overly nested leading
to a mess of code in a traditional 80 character screen. I'm sure this code
can be refactored into something more visually pleasing (things like
compressing two nested if's into a single if with an AND would help a
lot already).

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/vb_setmode.c | 1885 ++++++++++++++++++++++--------------
 1 files changed, 1133 insertions(+), 752 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 9669c22..2669b1b 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1,5 +1,5 @@
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/types.h>
 #include <linux/version.h>
@@ -71,7 +71,8 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 			= (struct XGI_CRT1TableStruct *) XGI_CRT1Table;
 
 	/* add for new UNIVGABIOS */
-	/* XGINew_UBLCDDataTable = (struct XGI_LCDDataTablStruct *) XGI_LCDDataTable; */
+	/* XGINew_UBLCDDataTable =
+	 *	(struct XGI_LCDDataTablStruct *) XGI_LCDDataTable; */
 	/* XGINew_UBTVDataTable = (XGI_TVDataTablStruct *) XGI_TVDataTable; */
 
 	pVBInfo->MCLKData = (struct XGI_MCLKDataStruct *) XGI340New_MCLKData;
@@ -190,8 +191,9 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 
 }
 
-static unsigned char XGI_GetModePtr(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static unsigned char XGI_GetModePtr(unsigned short ModeNo,
+				    unsigned short ModeIdIndex,
+				    struct vb_device_info *pVBInfo)
 {
 	unsigned char index;
 
@@ -207,21 +209,24 @@ static unsigned char XGI_GetModePtr(unsigned short ModeNo, unsigned short ModeId
 }
 
 /*
-unsigned char XGI_SetBIOSData(unsigned short ModeNo, unsigned short ModeIdIndex) {
+unsigned char XGI_SetBIOSData(unsigned short ModeNo,
+			      unsigned short ModeIdIndex) {
 	return (0);
 }
 */
 
-/* unsigned char XGI_ClearBankRegs(unsigned short ModeNo, unsigned short ModeIdIndex) {
+/* unsigned char XGI_ClearBankRegs(unsigned short ModeNo,
+				   unsigned short ModeIdIndex) {
 	return( 0 ) ;
 }
 */
 
-static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex,
-		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
+static void XGI_SetSeqRegs(unsigned short ModeNo,
+			   unsigned short StandTableIndex,
+			   unsigned short ModeIdIndex,
+			   struct vb_device_info *pVBInfo)
 {
 	unsigned char tempah, SRdata;
-
 	unsigned short i, modeflag;
 
 	if (ModeNo <= 0x13)
@@ -246,19 +251,25 @@ static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex
 	xgifb_reg_set(pVBInfo->P3c4, 0x01, tempah); /* Set SR1 */
 
 	for (i = 02; i <= 04; i++) {
-		SRdata = pVBInfo->StandTable[StandTableIndex].SR[i - 1]; /* Get SR2,3,4 from file */
+		/* Get SR2,3,4 from file */
+		SRdata = pVBInfo->StandTable[StandTableIndex].SR[i - 1];
 		xgifb_reg_set(pVBInfo->P3c4, i, SRdata); /* Set SR2 3 4 */
 	}
 }
 
 static void XGI_SetMiscRegs(unsigned short StandTableIndex,
-		struct vb_device_info *pVBInfo)
+			    struct vb_device_info *pVBInfo)
 {
 	unsigned char Miscdata;
 
-	Miscdata = pVBInfo->StandTable[StandTableIndex].MISC; /* Get Misc from file */
+	/* Get Misc from file */
+	Miscdata = pVBInfo->StandTable[StandTableIndex].MISC;
 	/*
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_XGI301B |
+			       VB_XGI302B |
+			       VB_XGI301LV |
+			       VB_XGI302LV |
+			       VB_XGI301C)) {
 		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
 			Miscdata |= 0x0C;
 		}
@@ -269,7 +280,8 @@ static void XGI_SetMiscRegs(unsigned short StandTableIndex,
 }
 
 static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
-		unsigned short StandTableIndex, struct vb_device_info *pVBInfo)
+			    unsigned short StandTableIndex,
+			    struct vb_device_info *pVBInfo)
 {
 	unsigned char CRTCdata;
 	unsigned short i;
@@ -279,11 +291,13 @@ static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, CRTCdata); /* Unlock CRTC */
 
 	for (i = 0; i <= 0x18; i++) {
-		CRTCdata = pVBInfo->StandTable[StandTableIndex].CRTC[i]; /* Get CRTC from file */
+		/* Get CRTC from file */
+		CRTCdata = pVBInfo->StandTable[StandTableIndex].CRTC[i];
 		xgifb_reg_set(pVBInfo->P3d4, i, CRTCdata); /* Set CRTC(3d4) */
 	}
 	/*
-	if ((HwDeviceExtension->jChipType == XGI_630) && (HwDeviceExtension->jChipRevision == 0x30)) {
+	if ((HwDeviceExtension->jChipType == XGI_630) &&
+	    (HwDeviceExtension->jChipRevision == 0x30)) {
 		if (pVBInfo->VBInfo & SetInSlaveMode) {
 			if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToTV)) {
 				xgifb_reg_set(pVBInfo->P3d4, 0x18, 0xFE);
@@ -293,8 +307,10 @@ static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	*/
 }
 
-static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex,
-		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
+static void XGI_SetATTRegs(unsigned short ModeNo,
+			   unsigned short StandTableIndex,
+			   unsigned short ModeIdIndex,
+			   struct vb_device_info *pVBInfo)
 {
 	unsigned char ARdata;
 	unsigned short i, modeflag;
@@ -313,8 +329,8 @@ static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex
 				} else {
 					if (pVBInfo->VBInfo & (SetCRT2ToTV
 							| SetCRT2ToLCD)) {
-						if (pVBInfo->VBInfo
-								& SetInSlaveMode)
+						if (pVBInfo->VBInfo &
+						    SetInSlaveMode)
 							ARdata = 0;
 					}
 				}
@@ -334,13 +350,14 @@ static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex
 }
 
 static void XGI_SetGRCRegs(unsigned short StandTableIndex,
-		struct vb_device_info *pVBInfo)
+			   struct vb_device_info *pVBInfo)
 {
 	unsigned char GRdata;
 	unsigned short i;
 
 	for (i = 0; i <= 0x08; i++) {
-		GRdata = pVBInfo->StandTable[StandTableIndex].GRC[i]; /* Get GR from file */
+		/* Get GR from file */
+		GRdata = pVBInfo->StandTable[StandTableIndex].GRC[i];
 		xgifb_reg_set(pVBInfo->P3ce, i, GRdata); /* Set GR(3ce) */
 	}
 
@@ -382,7 +399,8 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 	unsigned short tempax, tempbx, resinfo, modeflag, infoflag;
 
 	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ModeFlag */
+		/* si+St_ModeFlag */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	else
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
@@ -398,12 +416,14 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 				tempax |= SupportCRT2in301C;
 		}
 
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) { /* 301b */
+		/* 301b */
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
 			tempax |= SupportLCD;
 
 			if (pVBInfo->LCDResInfo != Panel1280x1024) {
 				if (pVBInfo->LCDResInfo != Panel1280x960) {
-					if (pVBInfo->LCDInfo & LCDNonExpanding) {
+					if (pVBInfo->LCDInfo &
+					    LCDNonExpanding) {
 						if (resinfo >= 9) {
 							tempax = 0;
 							return 0;
@@ -414,8 +434,8 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		}
 
 		if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) { /* for HiTV */
-			if ((pVBInfo->VBType & VB_XGI301LV)
-					&& (pVBInfo->VBExtInfo == VB_YPbPr1080i)) {
+			if ((pVBInfo->VBType & VB_XGI301LV) &&
+			    (pVBInfo->VBExtInfo == VB_YPbPr1080i)) {
 				tempax |= SupportYPbPr;
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
 					if (resinfo == 4)
@@ -444,9 +464,11 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 				}
 			}
 		} else {
-			if (pVBInfo->VBInfo & (SetCRT2ToAVIDEO
-					| SetCRT2ToSVIDEO | SetCRT2ToSCART
-					| SetCRT2ToYPbPr | SetCRT2ToHiVisionTV)) {
+			if (pVBInfo->VBInfo & (SetCRT2ToAVIDEO |
+					       SetCRT2ToSVIDEO |
+					       SetCRT2ToSCART |
+					       SetCRT2ToYPbPr |
+					       SetCRT2ToHiVisionTV)) {
 				tempax |= SupportTV;
 
 				if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
@@ -457,10 +479,10 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 
 				if (!(pVBInfo->VBInfo & SetPALTV)) {
 					if (modeflag & NoSupportSimuTV) {
-						if (pVBInfo->VBInfo
-								& SetInSlaveMode) {
-							if (!(pVBInfo->VBInfo
-									& SetNotSimuMode)) {
+						if (pVBInfo->VBInfo &
+						    SetInSlaveMode) {
+							if (!(pVBInfo->VBInfo &
+							      SetNotSimuMode)) {
 								return 0;
 							}
 						}
@@ -490,10 +512,10 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		}
 	}
 
-	for (; pVBInfo->RefIndex[RefreshRateTableIndex + (*i)].ModeID == tempbx; (*i)--) {
-		infoflag
-				= pVBInfo->RefIndex[RefreshRateTableIndex
-						+ (*i)].Ext_InfoFlag;
+	for (; pVBInfo->RefIndex[RefreshRateTableIndex + (*i)].ModeID ==
+	       tempbx; (*i)--) {
+		infoflag = pVBInfo->RefIndex[RefreshRateTableIndex + (*i)].
+				Ext_InfoFlag;
 		if (infoflag & tempax)
 			return 1;
 
@@ -502,9 +524,8 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 	}
 
 	for ((*i) = 0;; (*i)++) {
-		infoflag
-				= pVBInfo->RefIndex[RefreshRateTableIndex
-						+ (*i)].Ext_InfoFlag;
+		infoflag = pVBInfo->RefIndex[RefreshRateTableIndex + (*i)].
+				Ext_InfoFlag;
 		if (pVBInfo->RefIndex[RefreshRateTableIndex + (*i)].ModeID
 				!= tempbx) {
 			return 0;
@@ -521,7 +542,8 @@ static void XGI_SetSync(unsigned short RefreshRateTableIndex,
 {
 	unsigned short sync, temp;
 
-	sync = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag >> 8; /* di+0x00 */
+	/* di+0x00 */
+	sync = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag >> 8;
 	sync &= 0xC0;
 	temp = 0x2F;
 	temp |= sync;
@@ -538,7 +560,8 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	/* xgifb_reg_set(pVBInfo->P3d4, 0x56, 0); */
 	/* xgifb_reg_and_or(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
 
-	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11); /* unlock cr0-7 */
+	/* unlock cr0-7 */
+	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
 	xgifb_reg_set(pVBInfo->P3d4, 0x11, data);
 
@@ -591,8 +614,9 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	}
 }
 
-static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeNo,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex,
+				unsigned short ModeNo,
+				struct vb_device_info *pVBInfo)
 {
 	unsigned char data;
 	unsigned short i, j;
@@ -650,7 +674,8 @@ static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	unsigned char index, data;
 	unsigned short i;
 
-	index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC; /* Get index */
+	/* Get index */
+	index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 	index = index & IndexMask;
 
 	data = (unsigned char) xgifb_reg_get(pVBInfo->P3d4, 0x11);
@@ -688,9 +713,12 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (ModeNo <= 0x13) {
 		StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[4]; /* CR04 HRS */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E [7:0]->HRS */
-		Tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[5]; /* Tempbx: CR05 HRE */
+		/* CR04 HRS */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[4];
+		/* SR2E [7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax);
+		/* Tempbx: CR05 HRE */
+		Tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[5];
 		Tempbx &= 0x1F; /* Tempbx: HRE[4:0] */
 		Tempcx = Tempax;
 		Tempcx &= 0xE0; /* Tempcx: HRS[7:5] */
@@ -698,27 +726,34 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (Tempbx < (Tempax & 0x1F)) /* IF HRE < HRS */
 			Tempdx |= 0x20; /* Tempdx: HRE = HRE + 0x20 */
 		Tempdx <<= 2; /* Tempdx << 2 */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
+		/* SR2F [7:2]->HRE */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx);
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16]; /* Tempax: CR16 VRS */
+		/* Tempax: CR16 VRS */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16];
 		Tempbx = Tempax; /* Tempbx=Tempax */
 		Tempax &= 0x01; /* Tempax: VRS[0] */
 		xgifb_reg_or(pVBInfo->P3c4, 0x33, Tempax); /* SR33[0]->VRS */
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[7]; /* Tempax: CR7 VRS */
+
+		/* Tempax: CR7 VRS */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[7];
 		Tempdx = Tempbx >> 1; /* Tempdx: VRS[7:1] */
 		Tempcx = Tempax & 0x04; /* Tempcx: CR7[2] */
 		Tempcx <<= 5; /* Tempcx[7]: VRS[8] */
 		Tempdx |= Tempcx; /* Tempdx: VRS[8:1] */
-		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempdx); /* SR34[7:0]: VRS[8:1] */
+		/* SR34[7:0]: VRS[8:1] */
+		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempdx);
 
-		Temp1 = Tempcx << 1; /* Temp1[8]: VRS[8] unsigned char -> unsigned short */
+		/* Temp1[8]: VRS[8] unsigned char -> unsigned short */
+		Temp1 = Tempcx << 1;
 		Temp1 |= Tempbx; /* Temp1[8:0]: VRS[8:0] */
 		Tempax &= 0x80; /* Tempax[7]: CR7[7] */
 		Temp2 = Tempax << 2; /* Temp2[9]: VRS[9] */
 		Temp1 |= Temp2; /* Temp1[9:0]: VRS[9:0] */
 
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[17]; /* CR16 VRE */
+		/* CR16 VRE */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[17];
 		Tempax &= 0x0F; /* Tempax[3:0]: VRE[3:0] */
 		Temp2 = Temp1 & 0x3F0; /* Temp2[9:4]: VRS[9:4] */
 		Temp2 |= Tempax; /* Temp2[9:0]: VRE[9:0] */
@@ -733,12 +768,15 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempbx = (unsigned char) Temp1; /* Tempbx[1:0]: VRS[10:9] */
 		Tempax |= Tempbx; /* VRE[5:0]VRS[10:9] */
 		Tempax &= 0x7F;
-		xgifb_reg_set(pVBInfo->P3c4, 0x3F, Tempax); /* SR3F D[7:2]->VRE D[1:0]->VRS */
+		/* SR3F D[7:2]->VRE D[1:0]->VRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x3F, Tempax);
 	} else {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3]; /* Tempax: CR4 HRS */
+		/* Tempax: CR4 HRS */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3];
 		Tempcx = Tempax; /* Tempcx: HRS */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E[7:0]->HRS */
+		/* SR2E[7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax);
 
 		Tempdx = pVBInfo->XGINEWUB_CRT1Table[index].CR[5]; /* SRB */
 		Tempdx &= 0xC0; /* Tempdx[7:6]: SRB[7:6] */
@@ -766,14 +804,17 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax <<= 2; /* Tempax[7:2]: HRE[5:0] */
 		Tempdx >>= 6; /* Tempdx[7:6]->[1:0] HRS[9:8] */
 		Tempax |= Tempdx; /* HRE[5:0]HRS[9:8] */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F D[7:2]->HRE, D[1:0]->HRS */
+		/* SR2F D[7:2]->HRE, D[1:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax);
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10]; /* CR10 VRS */
+		/* CR10 VRS */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10];
 		Tempbx = Tempax; /* Tempbx: VRS */
 		Tempax &= 0x01; /* Tempax[0]: VRS[0] */
 		xgifb_reg_or(pVBInfo->P3c4, 0x33, Tempax); /* SR33[0]->VRS[0] */
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[9]; /* CR7[2][7] VRE */
+		/* CR7[2][7] VRE */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[9];
 		Tempcx = Tempbx >> 1; /* Tempcx[6:0]: VRS[7:1] */
 		Tempdx = Tempax & 0x04; /* Tempdx[2]: CR7[2] */
 		Tempdx <<= 5; /* Tempdx[7]: VRS[8] */
@@ -786,15 +827,18 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax &= 0x80;
 		Temp2 = Tempax << 2; /* Temp2[9]: VRS[9] */
 		Temp1 |= Temp2; /* Temp1[9:0]: VRS[9:0] */
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[14]; /* Tempax: SRA */
+		/* Tempax: SRA */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[14];
 		Tempax &= 0x08; /* Tempax[3]: VRS[3] */
 		Temp2 = Tempax;
 		Temp2 <<= 7; /* Temp2[10]: VRS[10] */
 		Temp1 |= Temp2; /* Temp1[10:0]: VRS[10:0] */
 
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[11]; /* Tempax: CR11 VRE */
+		/* Tempax: CR11 VRE */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[11];
 		Tempax &= 0x0F; /* Tempax[3:0]: VRE[3:0] */
-		Tempbx = pVBInfo->XGINEWUB_CRT1Table[index].CR[14]; /* Tempbx: SRA */
+		/* Tempbx: SRA */
+		Tempbx = pVBInfo->XGINEWUB_CRT1Table[index].CR[14];
 		Tempbx &= 0x20; /* Tempbx[5]: VRE[5] */
 		Tempbx >>= 1; /* Tempbx[4]: VRE[4] */
 		Tempax |= Tempbx; /* Tempax[4:0]: VRE[4:0] */
@@ -813,21 +857,26 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempbx = (unsigned char) Temp1;
 		Tempax |= Tempbx; /* Tempax[7:0]: VRE[5:0]VRS[10:9] */
 		Tempax &= 0x7F;
-		xgifb_reg_set(pVBInfo->P3c4, 0x3F, Tempax); /* SR3F D[7:2]->VRE D[1:0]->VRS */
+		/* SR3F D[7:2]->VRE D[1:0]->VRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x3F, Tempax);
 	}
 }
 
-static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetXG27CRTC(unsigned short ModeNo,
+			    unsigned short ModeIdIndex,
+			    unsigned short RefreshRateTableIndex,
+			    struct vb_device_info *pVBInfo)
 {
 	unsigned short StandTableIndex, index, Tempax, Tempbx, Tempcx, Tempdx;
 
 	if (ModeNo <= 0x13) {
 		StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[4]; /* CR04 HRS */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E [7:0]->HRS */
-		Tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[5]; /* Tempbx: CR05 HRE */
+		/* CR04 HRS */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[4];
+		/* SR2E [7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax);
+		/* Tempbx: CR05 HRE */
+		Tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[5];
 		Tempbx &= 0x1F; /* Tempbx: HRE[4:0] */
 		Tempcx = Tempax;
 		Tempcx &= 0xE0; /* Tempcx: HRS[7:5] */
@@ -835,39 +884,50 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (Tempbx < (Tempax & 0x1F)) /* IF HRE < HRS */
 			Tempdx |= 0x20; /* Tempdx: HRE = HRE + 0x20 */
 		Tempdx <<= 2; /* Tempdx << 2 */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
+		/* SR2F [7:2]->HRE */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx);
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16]; /* Tempax: CR10 VRS */
+		/* Tempax: CR10 VRS */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16];
 		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS */
 		Tempcx = Tempax; /* Tempcx=Tempax=VRS[7:0] */
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[7]; /* Tempax[7][2]: CR7[7][2] VRS[9][8] */
+		/* Tempax[7][2]: CR7[7][2] VRS[9][8] */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[7];
 		Tempbx = Tempax; /* Tempbx=CR07 */
 		Tempax &= 0x04; /* Tempax[2]: CR07[2] VRS[8] */
 		Tempax >>= 2;
-		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x01, Tempax); /* SR35 D[0]->VRS D[8] */
+		/* SR35 D[0]->VRS D[8] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x01, Tempax);
 		Tempcx |= (Tempax << 8); /* Tempcx[8] |= VRS[8] */
 		Tempcx |= (Tempbx & 0x80) << 2; /* Tempcx[9] |= VRS[9] */
 
-		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[17]; /* CR11 VRE */
+		/* CR11 VRE */
+		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[17];
 		Tempax &= 0x0F; /* Tempax: VRE[3:0] */
 		Tempbx = Tempcx; /* Tempbx=Tempcx=VRS[9:0] */
 		Tempbx &= 0x3F0; /* Tempbx[9:4]: VRS[9:4] */
 		Tempbx |= Tempax; /* Tempbx[9:0]: VRE[9:0] */
 		if (Tempax <= (Tempcx & 0x0F)) /* VRE[3:0]<=VRS[3:0] */
 			Tempbx |= 0x10; /* Tempbx: VRE + 0x10 */
-		Tempax = (unsigned char) Tempbx & 0xFF; /* Tempax[7:0]: VRE[7:0] */
+		/* Tempax[7:0]: VRE[7:0] */
+		Tempax = (unsigned char) Tempbx & 0xFF;
 		Tempax <<= 2; /* Tempax << 2: VRE[5:0] */
 		Tempcx = (Tempcx & 0x600) >> 8; /* Tempcx VRS[10:9] */
-		xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax); /* SR3F D[7:2]->VRE D[5:0] */
-		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x06, Tempcx); /* SR35 D[2:1]->VRS[10:9] */
+		/* SR3F D[7:2]->VRE D[5:0] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax);
+		/* SR35 D[2:1]->VRS[10:9] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x06, Tempcx);
 	} else {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3]; /* Tempax: CR4 HRS */
+		/* Tempax: CR4 HRS */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3];
 		Tempbx = Tempax; /* Tempbx: HRS[7:0] */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E[7:0]->HRS */
+		/* SR2E[7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax);
 
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[5]; /* SR0B */
+		/* SR0B */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[5];
 		Tempax &= 0xC0; /* Tempax[7:6]: SR0B[7:6]: HRS[9:8]*/
 		Tempbx |= (Tempax << 2); /* Tempbx: HRS[9:0] */
 
@@ -883,7 +943,8 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempbx = Tempbx & 0x3C0; /* Tempbx[9:6]: HRS[9:6] */
 		Tempbx |= Tempcx; /* Tempbx: HRS[9:6]HRE[5:0] */
 
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3]; /* Tempax: CR4 HRS */
+		/* Tempax: CR4 HRS */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3];
 		Tempax &= 0x3F; /* Tempax: HRS[5:0] */
 		if (Tempcx <= Tempax) /* HRE[5:0] < HRS[5:0] */
 			Tempbx += 0x40; /* Tempbx= Tempbx + 0x40 : HRE[9:0]*/
@@ -892,27 +953,35 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax &= 0xC0; /* Tempax[7:6]: SR0B[7:6]: HRS[9:8]*/
 		Tempax >>= 6; /* Tempax[1:0]: HRS[9:8]*/
 		Tempax |= ((Tempbx << 2) & 0xFF); /* Tempax[7:2]: HRE[5:0] */
-		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F [7:2][1:0]: HRE[5:0]HRS[9:8] */
+		/* SR2F [7:2][1:0]: HRE[5:0]HRS[9:8] */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax);
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10]; /* CR10 VRS */
-		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS[7:0] */
+		/* CR10 VRS */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10];
+		/* SR34[7:0]->VRS[7:0] */
+		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempax);
 
 		Tempcx = Tempax; /* Tempcx <= VRS[7:0] */
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[9]; /* CR7[7][2] VRS[9][8] */
+		/* CR7[7][2] VRS[9][8] */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[9];
 		Tempbx = Tempax; /* Tempbx <= CR07[7:0] */
 		Tempax = Tempax & 0x04; /* Tempax[2]: CR7[2]: VRS[8] */
 		Tempax >>= 2; /* Tempax[0]: VRS[8] */
-		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x01, Tempax); /* SR35[0]: VRS[8] */
+		/* SR35[0]: VRS[8] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x01, Tempax);
 		Tempcx |= (Tempax << 8); /* Tempcx <= VRS[8:0] */
 		Tempcx |= ((Tempbx & 0x80) << 2); /* Tempcx <= VRS[9:0] */
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[14]; /* Tempax: SR0A */
+		/* Tempax: SR0A */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[14];
 		Tempax &= 0x08; /* SR0A[3] VRS[10] */
 		Tempcx |= (Tempax << 7); /* Tempcx <= VRS[10:0] */
 
-		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[11]; /* Tempax: CR11 VRE */
+		/* Tempax: CR11 VRE */
+		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[11];
 		Tempax &= 0x0F; /* Tempax[3:0]: VRE[3:0] */
-		Tempbx = pVBInfo->XGINEWUB_CRT1Table[index].CR[14]; /* Tempbx: SR0A */
+		/* Tempbx: SR0A */
+		Tempbx = pVBInfo->XGINEWUB_CRT1Table[index].CR[14];
 		Tempbx &= 0x20; /* Tempbx[5]: SR0A[5]: VRE[4] */
 		Tempbx >>= 1; /* Tempbx[4]: VRE[4] */
 		Tempax |= Tempbx; /* Tempax[4:0]: VRE[4:0] */
@@ -923,10 +992,13 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (Tempbx <= Tempcx) /* VRE <= VRS */
 			Tempbx |= 0x20; /* VRE + 0x20 */
 
-		Tempax = (Tempbx << 2) & 0xFF; /* Tempax: Tempax[7:0]; VRE[5:0]00 */
-		xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax); /* SR3F[7:2]:VRE[5:0] */
+		/* Tempax: Tempax[7:0]; VRE[5:0]00 */
+		Tempax = (Tempbx << 2) & 0xFF;
+		/* SR3F[7:2]:VRE[5:0] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x3F, ~0xFC, Tempax);
 		Tempax = Tempcx >> 8;
-		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x07, Tempax); /* SR35[2:0]:VRS[10:8] */
+		/* SR35[2:0]:VRS[10:8] */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x07, Tempax);
 	}
 }
 
@@ -970,20 +1042,25 @@ static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 	if (ModeNo <= 0x13) {
 		b3CC = (unsigned char) inb(XGI_P3cc);
 		if (b3CC & 0x40)
-			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			/* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20);
 		if (b3CC & 0x80)
-			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			/* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80);
 	} else {
 		Data = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
 		if (Data & 0x4000)
-			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			/* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20);
 		if (Data & 0x8000)
-			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			/* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80);
 	}
 }
 
 static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
-		unsigned short RefreshRateTableIndex, unsigned short ModeNo)
+			   unsigned short RefreshRateTableIndex,
+			   unsigned short ModeNo)
 {
 	unsigned short Data, Temp, b3CC;
 	unsigned short XGI_P3cc;
@@ -1018,15 +1095,19 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 	if (ModeNo <= 0x13) {
 		b3CC = (unsigned char) inb(XGI_P3cc);
 		if (b3CC & 0x40)
-			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			/* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20);
 		if (b3CC & 0x80)
-			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			/* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80);
 	} else {
 		Data = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
 		if (Data & 0x4000)
-			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
+			/* Hsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x30, 0x20);
 		if (Data & 0x8000)
-			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80); /* Vsync polarity */
+			/* Vsync polarity */
+			xgifb_reg_or(pVBInfo->P3c4, 0x35, 0x80);
 	}
 }
 
@@ -1036,8 +1117,9 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 /* Output : CRT1 CRTC */
 /* Description : Modify CRT1 Hsync/Vsync to fix LCD mode timing */
 /* --------------------------------------------------------------------- */
-static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo,
-		unsigned short RefreshRateTableIndex)
+static void XGI_UpdateXG21CRTC(unsigned short ModeNo,
+			       struct vb_device_info *pVBInfo,
+			       unsigned short RefreshRateTableIndex)
 {
 	int i, index = -1;
 
@@ -1048,13 +1130,13 @@ static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVB
 				index = i;
 		}
 	} else {
-		if (ModeNo == 0x2E
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC
-						== RES640x480x60))
+		if (ModeNo == 0x2E &&
+		    (pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC ==
+							      RES640x480x60))
 			index = 12;
-		else if (ModeNo == 0x2E
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC
-						== RES640x480x72))
+		else if (ModeNo == 0x2E &&
+			 (pVBInfo->RefIndex[RefreshRateTableIndex].
+				Ext_CRT1CRTC == RES640x480x72))
 			index = 13;
 		else if (ModeNo == 0x2F)
 			index = 14;
@@ -1157,16 +1239,19 @@ unsigned short XGI_GetResInfo(unsigned short ModeNo,
 	unsigned short resindex;
 
 	if (ModeNo <= 0x13)
-		resindex = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		resindex = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 	else
-		resindex = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		resindex = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
 	return resindex;
 }
 
-static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetCRT1Offset(unsigned short ModeNo,
+			      unsigned short ModeIdIndex,
+			      unsigned short RefreshRateTableIndex,
+			      struct xgi_hw_device_info *HwDeviceExtension,
+			      struct vb_device_info *pVBInfo)
 {
 	unsigned short temp, ah, al, temp2, i, DisplayUnit;
 
@@ -1254,29 +1339,39 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 {
 	unsigned short tempbx;
 
-	unsigned short LCDXlat1VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
-			VCLK65 + 2 };
-	unsigned short LCDXlat2VCLK[4] = { VCLK108_2 + 5, VCLK108_2 + 5,
-			VCLK108_2 + 5, VCLK108_2 + 5 };
+	unsigned short LCDXlat1VCLK[4] = { VCLK65 + 2,
+					   VCLK65 + 2,
+					   VCLK65 + 2,
+					   VCLK65 + 2 };
+	unsigned short LCDXlat2VCLK[4] = { VCLK108_2 + 5,
+					   VCLK108_2 + 5,
+					   VCLK108_2 + 5,
+					   VCLK108_2 + 5 };
 	unsigned short LVDSXlat1VCLK[4] = { VCLK40, VCLK40, VCLK40, VCLK40 };
-	unsigned short LVDSXlat2VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
-			VCLK65 + 2 };
-	unsigned short LVDSXlat3VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
-			VCLK65 + 2 };
+	unsigned short LVDSXlat2VCLK[4] = { VCLK65 + 2,
+					    VCLK65 + 2,
+					    VCLK65 + 2,
+					    VCLK65 + 2 };
+	unsigned short LVDSXlat3VCLK[4] = { VCLK65 + 2,
+					    VCLK65 + 2,
+					    VCLK65 + 2,
+					    VCLK65 + 2 };
 
 	unsigned short CRT2Index, VCLKIndex;
 	unsigned short modeflag, resinfo;
 	unsigned char *CHTVVCLKPtr = NULL;
 
 	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 		resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 		CRT2Index = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
 	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
-		CRT2Index
-				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+		CRT2Index = pVBInfo->RefIndex[RefreshRateTableIndex].
+				Ext_CRT2CRTC;
 	}
 
 	if (pVBInfo->IF_DEF_LVDS == 0) {
@@ -1291,41 +1386,35 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 				if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
 					if (pVBInfo->SetFlag & RPLLDIV2XO) {
 						VCLKIndex = HiTVVCLKDIV2;
-
 						VCLKIndex += 25;
-
 					} else {
 						VCLKIndex = HiTVVCLK;
-
 						VCLKIndex += 25;
-
 					}
 
 					if (pVBInfo->SetFlag & TVSimuMode) {
 						if (modeflag & Charx8Dot) {
-							VCLKIndex
-									= HiTVSimuVCLK;
-
+							VCLKIndex =
+								HiTVSimuVCLK;
 							VCLKIndex += 25;
-
 						} else {
-							VCLKIndex
-									= HiTVTextVCLK;
-
+							VCLKIndex =
+								HiTVTextVCLK;
 							VCLKIndex += 25;
-
 						}
 					}
 
-					if (pVBInfo->VBType & VB_XGI301LV) { /* 301lv */
-						if (!(pVBInfo->VBExtInfo
-								== VB_YPbPr1080i)) {
-							VCLKIndex
-									= YPbPr750pVCLK;
+					/* 301lv */
+					if (pVBInfo->VBType & VB_XGI301LV) {
+						if (!(pVBInfo->VBExtInfo ==
+						     VB_YPbPr1080i)) {
+							VCLKIndex =
+								YPbPr750pVCLK;
 							if (!(pVBInfo->VBExtInfo
-									== VB_YPbPr750p)) {
-								VCLKIndex
-										= YPbPr525pVCLK;
+									==
+							     VB_YPbPr750p)) {
+								VCLKIndex =
+								  YPbPr525pVCLK;
 								if (!(pVBInfo->VBExtInfo
 										== VB_YPbPr525p)) {
 									VCLKIndex
@@ -1340,27 +1429,27 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 					}
 				} else {
 					if (pVBInfo->VBInfo & SetCRT2ToTV) {
-						if (pVBInfo->SetFlag
-								& RPLLDIV2XO) {
+						if (pVBInfo->SetFlag &
+						    RPLLDIV2XO) {
 							VCLKIndex = TVVCLKDIV2;
-
 							VCLKIndex += 25;
-
 						} else {
 							VCLKIndex = TVVCLK;
-
 							VCLKIndex += 25;
-
 						}
 					}
 				}
 			} else { /* for CRT2 */
+				/* Port 3cch */
 				VCLKIndex = (unsigned char) inb(
-						(pVBInfo->P3ca + 0x02)); /* Port 3cch */
+						(pVBInfo->P3ca + 0x02));
 				VCLKIndex = ((VCLKIndex >> 2) & 0x03);
 				if (ModeNo > 0x13) {
-					VCLKIndex
-							= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK; /* di+Ext_CRTVCLK */
+					/* di+Ext_CRTVCLK */
+					VCLKIndex =
+						pVBInfo->RefIndex[
+							RefreshRateTableIndex].
+								Ext_CRTVCLK;
 					VCLKIndex &= IndexMask;
 				}
 			}
@@ -1403,12 +1492,11 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			}
 		} else {
 			VCLKIndex = VCLKIndex >> 6;
-			if ((pVBInfo->LCDResInfo == Panel800x600)
-					|| (pVBInfo->LCDResInfo == Panel320x480))
+			if ((pVBInfo->LCDResInfo == Panel800x600) ||
+			    (pVBInfo->LCDResInfo == Panel320x480))
 				VCLKIndex = LVDSXlat1VCLK[VCLKIndex];
-			else if ((pVBInfo->LCDResInfo == Panel1024x768)
-					|| (pVBInfo->LCDResInfo
-							== Panel1024x768x75))
+			else if ((pVBInfo->LCDResInfo == Panel1024x768) ||
+				 (pVBInfo->LCDResInfo == Panel1024x768x75))
 				VCLKIndex = LVDSXlat2VCLK[VCLKIndex];
 			else
 				VCLKIndex = LVDSXlat3VCLK[VCLKIndex];
@@ -1419,10 +1507,11 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 	return VCLKIndex;
 }
 
-static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct xgi_hw_device_info *HwDeviceExtension,
-		unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetCRT1VCLK(unsigned short ModeNo,
+			    unsigned short ModeIdIndex,
+			    struct xgi_hw_device_info *HwDeviceExtension,
+			    unsigned short RefreshRateTableIndex,
+			    struct vb_device_info *pVBInfo)
 {
 	unsigned char index, data;
 	unsigned short vclkindex;
@@ -1461,7 +1550,8 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	if (HwDeviceExtension->jChipType >= XG20) {
-		if (pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag & HalfDCLK) {
+		if (pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag &
+		    HalfDCLK) {
 			data = xgifb_reg_get(pVBInfo->P3c4, 0x2B);
 			xgifb_reg_set(pVBInfo->P3c4, 0x2B, data);
 			data = xgifb_reg_get(pVBInfo->P3c4, 0x2C);
@@ -1575,10 +1665,11 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 
 	if (ModeNo > 0x13) {
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-		infoflag
-				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
+		infoflag = pVBInfo->RefIndex[RefreshRateTableIndex].
+				Ext_InfoFlag;
 	} else
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ModeFlag */
+		/* si+St_ModeFlag */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 
 	if (xgifb_reg_get(pVBInfo->P3d4, 0x31) & 0x01)
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x1F, 0x3F, 0x00);
@@ -1652,7 +1743,8 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 
 	/* if (modeflag&HalfDCLK) //030305 fix lowresolution bug */
 	/* if (XGINew_IF_DEF_NEW_LOWRES) */
-	/* XGI_VesaLowResolution(ModeNo, ModeIdIndex); //030305 fix lowresolution bug */
+	/* XGI_VesaLowResolution(ModeNo, ModeIdIndex);
+	 * //030305 fix lowresolution bug */
 
 	data = xgifb_reg_get(pVBInfo->P3d4, 0x31);
 
@@ -1681,7 +1773,9 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 }
 
 /*
-void XGI_VesaLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
+void XGI_VesaLowResolution(unsigned short ModeNo,
+			   unsigned short ModeIdIndex,
+			   struct vb_device_info *pVBInfo)
 {
 	unsigned short modeflag;
 
@@ -1693,17 +1787,37 @@ void XGI_VesaLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, st
 	if (ModeNo > 0x13) {
 		if (modeflag & DoubleScanMode) {
 			if (modeflag & HalfDCLK) {
-				if (pVBInfo->VBType & VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
-					if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
-						if (pVBInfo->VBInfo & SetInSlaveMode) {
-							xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xf7, 0x00);
-							xgifb_reg_and_or(pVBInfo->P3c4, 0x0f, 0x7f, 0x00);
+				if (pVBInfo->VBType & VB_XGI301B |
+						      VB_XGI302B |
+						      VB_XGI301LV |
+						      VB_XGI302LV |
+						      VB_XGI301C)) {
+					if (!(pVBInfo->VBInfo &
+					     SetCRT2ToRAMDAC)) {
+						if (pVBInfo->VBInfo &
+						    SetInSlaveMode) {
+							xgifb_reg_and_or(
+								pVBInfo->P3c4,
+								0x01,
+								0xf7,
+								0x00);
+							xgifb_reg_and_or(
+								pVBInfo->P3c4,
+								0x0f,
+								0x7f,
+								0x00);
 							return;
 						}
 					}
 				}
-				xgifb_reg_and_or(pVBInfo->P3c4, 0x0f, 0xff, 0x80);
-				xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xf7, 0x00);
+				xgifb_reg_and_or(pVBInfo->P3c4,
+						 0x0f,
+						 0xff,
+						 0x80);
+				xgifb_reg_and_or(pVBInfo->P3c4,
+						 0x01,
+						 0xf7,
+						 0x00);
 				return;
 			}
 		}
@@ -1712,8 +1826,11 @@ void XGI_VesaLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, st
 }
 */
 
-static void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al,
-		unsigned short dh, struct vb_device_info *pVBInfo)
+static void XGI_WriteDAC(unsigned short dl,
+			 unsigned short ah,
+			 unsigned short al,
+			 unsigned short dh,
+			 struct vb_device_info *pVBInfo)
 {
 	unsigned short temp, bh, bl;
 
@@ -1831,15 +1948,18 @@ static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_GetLVDSResInfo(unsigned short ModeNo,
+			       unsigned short ModeIdIndex,
+			       struct vb_device_info *pVBInfo)
 {
 	unsigned short resindex, xres, yres, modeflag;
 
 	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 	else
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
 
 	/* if (ModeNo > 0x13) */
 	/*	modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; */
@@ -1847,9 +1967,11 @@ static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex
 	/*	modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; */
 
 	if (ModeNo <= 0x13)
-		resindex = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		resindex = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 	else
-		resindex = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		resindex = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
 
 	/* resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo); */
 
@@ -1903,19 +2025,21 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 
 	if (tempbx <= 1) { /* ExpLink */
 		if (ModeNo <= 0x13) {
-			tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC; /* find no Ext_CRT2CRTC2 */
+			/* find no Ext_CRT2CRTC2 */
+			tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
 		} else {
-			tempal
-					= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+			tempal = pVBInfo->RefIndex[RefreshRateTableIndex].
+					Ext_CRT2CRTC;
 		}
 
 		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
 			if (ModeNo <= 0x13)
-				tempal
-						= pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC2;
+				tempal = pVBInfo->SModeIDTable[ModeIdIndex].
+						St_CRT2CRTC2;
 			else
-				tempal
-						= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC2;
+				tempal = pVBInfo->RefIndex[
+						RefreshRateTableIndex].
+							Ext_CRT2CRTC2;
 		}
 
 		if (tempbx & 0x01)
@@ -1933,7 +2057,8 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 			tempcx = LVDSDesDataLen2;
 	}
 	/* mov di, word ptr cs:LCDDataList[bx] */
-	/* tempdi = pVideoMemory[LCDDataList + tempbx * 2] | (pVideoMemory[LCDDataList + tempbx * 2 + 1] << 8); */
+	/* tempdi = pVideoMemory[LCDDataList + tempbx * 2] |
+		    (pVideoMemory[LCDDataList + tempbx * 2 + 1] << 8); */
 
 	switch (tempbx) {
 	case 0:
@@ -2243,36 +2368,36 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 			return &XGI_CetLCDDes1024x768Data[tempal];
 			break;
 		case 3:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+				(pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_ExtLCDDLDes1280x1024Data[tempal];
 			else
 				return &XGI_ExtLCDDes1280x1024Data[tempal];
 			break;
 		case 4:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_StLCDDLDes1280x1024Data[tempal];
 			else
 				return &XGI_StLCDDes1280x1024Data[tempal];
 			break;
 		case 5:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_CetLCDDLDes1280x1024Data[tempal];
 			else
 				return &XGI_CetLCDDes1280x1024Data[tempal];
 			break;
 		case 6:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_ExtLCDDLDes1400x1050Data[tempal];
 			else
 				return &XGI_ExtLCDDes1400x1050Data[tempal];
 			break;
 		case 7:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_StLCDDLDes1400x1050Data[tempal];
 			else
 				return &XGI_StLCDDes1400x1050Data[tempal];
@@ -2284,15 +2409,15 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 			return &XGI_CetLCDDes1400x1050Data2[tempal];
 			break;
 		case 10:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_ExtLCDDLDes1600x1200Data[tempal];
 			else
 				return &XGI_ExtLCDDes1600x1200Data[tempal];
 			break;
 		case 11:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_StLCDDLDes1600x1200Data[tempal];
 			else
 				return &XGI_StLCDDes1600x1200Data[tempal];
@@ -2310,22 +2435,22 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 			return &XGI_CetLCDDes1024x768x75Data[tempal];
 			break;
 		case 16:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_ExtLCDDLDes1280x1024x75Data[tempal];
 			else
 				return &XGI_ExtLCDDes1280x1024x75Data[tempal];
 			break;
 		case 17:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_StLCDDLDes1280x1024x75Data[tempal];
 			else
 				return &XGI_StLCDDes1280x1024x75Data[tempal];
 			break;
 		case 18:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV))
 				return &XGI_CetLCDDLDes1280x1024x75Data[tempal];
 			else
 				return &XGI_CetLCDDes1280x1024x75Data[tempal];
@@ -2423,7 +2548,8 @@ static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,
 		i++;
 	}
 
-	if (table == 0x00) { /* 07/05/22 */
+	/* 07/05/22 */
+	if (table == 0x00) {
 	} else if (table == 0x01) {
 	} else if (table == 0x04) {
 		switch (tempdi[i].DATAPTR) {
@@ -2528,14 +2654,12 @@ static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
 		if (!(pVBInfo->LCDInfo & (SetLCDtoNonExpanding
 				| EnableScalingLCD))) {
-			if ((pVBInfo->LCDResInfo == Panel1024x768)
-					|| (pVBInfo->LCDResInfo
-							== Panel1024x768x75)) {
+			if ((pVBInfo->LCDResInfo == Panel1024x768) ||
+			    (pVBInfo->LCDResInfo == Panel1024x768x75)) {
 				pVBInfo->HDE = 1024;
 				pVBInfo->VDE = 768;
-			} else if ((pVBInfo->LCDResInfo == Panel1280x1024)
-					|| (pVBInfo->LCDResInfo
-							== Panel1280x1024x75)) {
+			} else if ((pVBInfo->LCDResInfo == Panel1280x1024) ||
+				   (pVBInfo->LCDResInfo == Panel1280x1024x75)) {
 				pVBInfo->HDE = 1280;
 				pVBInfo->VDE = 1024;
 			} else if (pVBInfo->LCDResInfo == Panel1400x1050) {
@@ -2569,17 +2693,17 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	index = index & IndexMask;
 
-	if ((pVBInfo->IF_DEF_ScaleLCD == 0) || ((pVBInfo->IF_DEF_ScaleLCD == 1)
-			&& (!(pVBInfo->LCDInfo & EnableScalingLCD)))) {
+	if ((pVBInfo->IF_DEF_ScaleLCD == 0) ||
+	    ((pVBInfo->IF_DEF_ScaleLCD == 1) &&
+	    (!(pVBInfo->LCDInfo & EnableScalingLCD)))) {
 		tempbx = 0;
 
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-			LCDPtr
-					= (struct XGI_LVDSCRT1HDataStruct *) XGI_GetLcdPtr(
-							tempbx, ModeNo,
-							ModeIdIndex,
-							RefreshRateTableIndex,
-							pVBInfo);
+			LCDPtr = (struct XGI_LVDSCRT1HDataStruct *)
+					XGI_GetLcdPtr(tempbx, ModeNo,
+						      ModeIdIndex,
+						      RefreshRateTableIndex,
+						      pVBInfo);
 
 			for (i = 0; i < 8; i++)
 				pVBInfo->TimingH[0].data[i] = LCDPtr[0].Reg[i];
@@ -2587,23 +2711,30 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		if (pVBInfo->IF_DEF_CH7007 == 1) {
 			if (pVBInfo->VBInfo & SetCRT2ToTV) {
-				CH7007TV_TimingHPtr
-						= (struct XGI_CH7007TV_TimingHStruct *) XGI_GetTVPtr(
-								tempbx,
-								ModeNo,
-								ModeIdIndex,
-								RefreshRateTableIndex,
-								pVBInfo);
+				CH7007TV_TimingHPtr =
+					(struct XGI_CH7007TV_TimingHStruct *)
+						XGI_GetTVPtr(
+							tempbx,
+							ModeNo,
+							ModeIdIndex,
+							RefreshRateTableIndex,
+							pVBInfo);
 
 				for (i = 0; i < 8; i++)
-					pVBInfo->TimingH[0].data[i]
-							= CH7007TV_TimingHPtr[0].data[i];
+					pVBInfo->TimingH[0].data[i] =
+						CH7007TV_TimingHPtr[0].data[i];
 			}
 		}
 
 		/* if (pVBInfo->IF_DEF_CH7017 == 1) {
 			if (pVBInfo->VBInfo & SetCRT2ToTV)
-				TVPtr = (struct XGI330_CHTVDataStruct *)XGI_GetTVPtr(tempbx, ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
+				TVPtr = (struct XGI330_CHTVDataStruct *)
+						XGI_GetTVPtr(
+							tempbx,
+							ModeNo,
+							ModeIdIndex,
+							RefreshRateTableIndex,
+							pVBInfo);
 		}
 		*/
 
@@ -2619,34 +2750,41 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempbx = 1;
 
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-			LCDPtr1
-					= (struct XGI_LVDSCRT1VDataStruct *) XGI_GetLcdPtr(
-							tempbx, ModeNo,
-							ModeIdIndex,
-							RefreshRateTableIndex,
-							pVBInfo);
+			LCDPtr1 = (struct XGI_LVDSCRT1VDataStruct *)
+					XGI_GetLcdPtr(
+						tempbx,
+						ModeNo,
+						ModeIdIndex,
+						RefreshRateTableIndex,
+						pVBInfo);
 			for (i = 0; i < 7; i++)
 				pVBInfo->TimingV[0].data[i] = LCDPtr1[0].Reg[i];
 		}
 
 		if (pVBInfo->IF_DEF_CH7007 == 1) {
 			if (pVBInfo->VBInfo & SetCRT2ToTV) {
-				CH7007TV_TimingVPtr
-						= (struct XGI_CH7007TV_TimingVStruct *) XGI_GetTVPtr(
-								tempbx,
-								ModeNo,
-								ModeIdIndex,
-								RefreshRateTableIndex,
-								pVBInfo);
+				CH7007TV_TimingVPtr =
+					(struct XGI_CH7007TV_TimingVStruct *)
+						XGI_GetTVPtr(
+							tempbx,
+							ModeNo,
+							ModeIdIndex,
+							RefreshRateTableIndex,
+							pVBInfo);
 
 				for (i = 0; i < 7; i++)
-					pVBInfo->TimingV[0].data[i]
-							= CH7007TV_TimingVPtr[0].data[i];
+					pVBInfo->TimingV[0].data[i] =
+						CH7007TV_TimingVPtr[0].data[i];
 			}
 		}
 		/* if (pVBInfo->IF_DEF_CH7017 == 1) {
 			if (pVBInfo->VBInfo & SetCRT2ToTV)
-				TVPtr = (struct XGI330_CHTVDataStruct *)XGI_GetTVPtr(tempbx, ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
+				TVPtr = (struct XGI330_CHTVDataStruct *)
+					XGI_GetTVPtr(tempbx,
+						     ModeNo,
+						     ModeIdIndex,
+						     RefreshRateTableIndex,
+						     pVBInfo);
 		}
 		*/
 
@@ -2723,8 +2861,9 @@ static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo)
 	return i;
 }
 
-static void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth,
-		struct vb_device_info *pVBInfo)
+static void XGI_GetLCDSync(unsigned short *HSyncWidth,
+			   unsigned short *VSyncWidth,
+			   struct vb_device_info *pVBInfo)
 {
 	unsigned short Index;
 
@@ -2754,33 +2893,35 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 				& (SetCRT2ToLCD | SetCRT2ToLCDA))) {
 			if (pVBInfo->IF_DEF_OEMUtil == 1) {
 				tempbx = 8;
-				LCDPtr
-						= (struct XGI330_LCDDataDesStruct *) XGI_GetLcdPtr(
-								tempbx,
-								ModeNo,
-								ModeIdIndex,
-								RefreshRateTableIndex,
-								pVBInfo);
+				LCDPtr = (struct XGI330_LCDDataDesStruct *)
+					XGI_GetLcdPtr(tempbx,
+						      ModeNo,
+						      ModeIdIndex,
+						      RefreshRateTableIndex,
+						      pVBInfo);
 			}
 
-			if ((pVBInfo->IF_DEF_OEMUtil == 0) || (LCDPtr == NULL)) {
+			if ((pVBInfo->IF_DEF_OEMUtil == 0) ||
+			    (LCDPtr == NULL)) {
 				tempbx = 3;
 				if (pVBInfo->LCDInfo & EnableScalingLCD)
-					LCDPtr1
-							= (struct XGI330_LCDDataDesStruct2 *) XGI_GetLcdPtr(
-									tempbx,
-									ModeNo,
-									ModeIdIndex,
-									RefreshRateTableIndex,
-									pVBInfo);
+					LCDPtr1 =
+					    (struct XGI330_LCDDataDesStruct2 *)
+							XGI_GetLcdPtr(
+							  tempbx,
+							  ModeNo,
+							  ModeIdIndex,
+							  RefreshRateTableIndex,
+							  pVBInfo);
 				else
-					LCDPtr
-							= (struct XGI330_LCDDataDesStruct *) XGI_GetLcdPtr(
-									tempbx,
-									ModeNo,
-									ModeIdIndex,
-									RefreshRateTableIndex,
-									pVBInfo);
+					LCDPtr =
+					    (struct XGI330_LCDDataDesStruct *)
+							XGI_GetLcdPtr(
+							  tempbx,
+							  ModeNo,
+							  ModeIdIndex,
+							  RefreshRateTableIndex,
+							  pVBInfo);
 			}
 
 			XGI_GetLCDSync(&tempax, &tempbx, pVBInfo);
@@ -2788,14 +2929,12 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			push2 = tempax;
 
 			/* GetLCDResInfo */
-			if ((pVBInfo->LCDResInfo == Panel1024x768)
-					|| (pVBInfo->LCDResInfo
-							== Panel1024x768x75)) {
+			if ((pVBInfo->LCDResInfo == Panel1024x768) ||
+			    (pVBInfo->LCDResInfo == Panel1024x768x75)) {
 				tempax = 1024;
 				tempbx = 768;
-			} else if ((pVBInfo->LCDResInfo == Panel1280x1024)
-					|| (pVBInfo->LCDResInfo
-							== Panel1280x1024x75)) {
+			} else if ((pVBInfo->LCDResInfo == Panel1280x1024) ||
+				   (pVBInfo->LCDResInfo == Panel1280x1024x75)) {
 				tempax = 1280;
 				tempbx = 1024;
 			} else if (pVBInfo->LCDResInfo == Panel1400x1050) {
@@ -2813,8 +2952,8 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 				pVBInfo->VGAVDE = tempbx;
 			}
 
-			if ((pVBInfo->IF_DEF_ScaleLCD == 1)
-					&& (pVBInfo->LCDInfo & EnableScalingLCD)) {
+			if ((pVBInfo->IF_DEF_ScaleLCD == 1) &&
+			    (pVBInfo->LCDInfo & EnableScalingLCD)) {
 				tempax = pVBInfo->HDE;
 				tempbx = pVBInfo->VDE;
 			}
@@ -2961,16 +3100,18 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 			if (pVBInfo->VBType & VB_XGI301C) {
 				temp2 = push3;
-				xgifb_reg_set(pVBInfo->Part4Port, 0x3c,
-						(unsigned short) (temp2 & 0xff));
-				xgifb_reg_set(pVBInfo->Part4Port, 0x3b,
-						(unsigned short) ((temp2 >> 8)
-								& 0xff));
+				xgifb_reg_set(pVBInfo->Part4Port,
+					      0x3c,
+					      (unsigned short) (temp2 & 0xff));
+				xgifb_reg_set(pVBInfo->Part4Port,
+					      0x3b,
+					      (unsigned short) ((temp2 >> 8) &
+					      0xff));
 				tempbx = (unsigned short) (temp2 >> 16);
 				xgifb_reg_and_or(pVBInfo->Part4Port, 0x3a,
 						~0xc0,
-						(unsigned short) ((tempbx
-								& 0xff) << 6));
+						(unsigned short) ((tempbx &
+								   0xff) << 6));
 
 				tempcx = pVBInfo->VGAVDE;
 				if (tempcx == pVBInfo->VDE)
@@ -3072,12 +3213,14 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 	unsigned char *CHTVVCLKPtr = NULL;
 
 	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	else
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
-	if ((pVBInfo->SetFlag & ProgrammingCRT2) && (!(pVBInfo->LCDInfo
-			& EnableScalingLCD))) { /* {LCDA/LCDB} */
+	if ((pVBInfo->SetFlag & ProgrammingCRT2) &&
+	    (!(pVBInfo->LCDInfo & EnableScalingLCD))) { /* {LCDA/LCDB} */
 		index = XGI_GetLCDCapPtr(pVBInfo);
 		tempal = pVBInfo->LCDCapList[index].LCD_VCLK;
 
@@ -3085,8 +3228,12 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 			return tempal;
 
 		/* {TV} */
-		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType &
+		    (VB_XGI301B |
+		     VB_XGI302B |
+		     VB_XGI301LV |
+		     VB_XGI302LV |
+		     VB_XGI301C)) {
 			if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
 				tempal = HiTVVCLKDIV2;
 				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
@@ -3121,11 +3268,14 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 			if (pVBInfo->VBInfo & SetCRT2ToTV)
 				return tempal;
 		}
-		/* else if ((pVBInfo->IF_DEF_CH7017==1)&&(pVBInfo->VBType&VB_CH7017)) {
+		/* else if ((pVBInfo->IF_DEF_CH7017==1) &&
+			    (pVBInfo->VBType&VB_CH7017)) {
 			if (ModeNo<=0x13)
-				*tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
+				*tempal = pVBInfo->SModeIDTable[ModeIdIndex].
+						St_CRT2CRTC;
 			else
-				*tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+				*tempal = pVBInfo->RefIndex[
+					RefreshRateTableIndex].Ext_CRT2CRTC;
 			*tempal = *tempal & 0x1F;
 			tempbx = 0;
 			if (pVBInfo->TVInfo & SetPALTV)
@@ -3136,15 +3286,18 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 		} */
 	} /* {End of VB} */
 
-	if ((pVBInfo->IF_DEF_CH7007 == 1) && (pVBInfo->VBType & VB_CH7007)) { /* [Billy] 07/05/08 CH7007 */
-		/* VideoDebugPrint((0, "XGI_GetVCLKPtr: pVBInfo->IF_DEF_CH7007==1\n")); */
+	if ((pVBInfo->IF_DEF_CH7007 == 1) &&
+	    (pVBInfo->VBType & VB_CH7007)) { /* [Billy] 07/05/08 CH7007 */
+		/* VideoDebugPrint((
+			0,
+			"XGI_GetVCLKPtr: pVBInfo->IF_DEF_CH7007==1\n")); */
 		if ((pVBInfo->VBInfo & SetCRT2ToTV)) {
 			if (ModeNo <= 0x13) {
-				tempal
-						= pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
+				tempal = pVBInfo->SModeIDTable[ModeIdIndex].
+					St_CRT2CRTC;
 			} else {
-				tempal
-						= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+				tempal = pVBInfo->RefIndex[
+					RefreshRateTableIndex].Ext_CRT2CRTC;
 			}
 
 			tempal = tempal & 0x0F;
@@ -3208,7 +3361,8 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 	tempal = tempal >> 2;
 	tempal &= 0x03;
 
-	if ((pVBInfo->LCDInfo & EnableScalingLCD) && (modeflag & Charx8Dot)) /* for Dot8 Scaling LCD */
+	/* for Dot8 Scaling LCD */
+	if ((pVBInfo->LCDInfo & EnableScalingLCD) && (modeflag & Charx8Dot))
 		tempal = tempal ^ tempal; /* ; set to VCLK25MHz always */
 
 	if (ModeNo <= 0x13)
@@ -3222,7 +3376,9 @@ static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
 		unsigned char *di_1, struct vb_device_info *pVBInfo)
 {
 	if (pVBInfo->IF_DEF_CH7007 == 1) { /* [Billy] 2007/05/16 */
-		/* VideoDebugPrint((0, "XGI_GetVCLKLen: pVBInfo->IF_DEF_CH7007==1\n")); */
+		/* VideoDebugPrint((
+			0,
+			"XGI_GetVCLKLen: pVBInfo->IF_DEF_CH7007==1\n")); */
 		*di_0 = (unsigned char) XGI_CH7007VCLKData[tempal].SR2B;
 		*di_1 = (unsigned char) XGI_CH7007VCLKData[tempal].SR2C;
 	} else if (pVBInfo->VBType & (VB_XGI301 | VB_XGI301B | VB_XGI302B
@@ -3291,7 +3447,8 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 		temp &= 0x0f;
 
 		if (!(temp == 0x08)) {
-			tempax = xgifb_reg_get(pVBInfo->Part1Port, 0x13); /* Check ChannelA by Part1_13 [2003/10/03] */
+			/* Check ChannelA by Part1_13 [2003/10/03] */
+			tempax = xgifb_reg_get(pVBInfo->Part1Port, 0x13);
 			if (tempax & 0x04)
 				tempcl = tempcl | ActiveLCD;
 
@@ -3388,13 +3545,12 @@ void XGI_GetVBType(struct vb_device_info *pVBInfo)
 						tempbx = VB_XGI301LV;
 						if (flag >= 0xE0) {
 							tempbx = VB_XGI302LV;
-							tempah
-									= xgifb_reg_get(
-											pVBInfo->Part4Port,
-											0x39);
+							tempah = xgifb_reg_get(
+							    pVBInfo->Part4Port,
+							    0x39);
 							if (tempah != 0xFF)
-								tempbx
-										= VB_XGI301C;
+								tempbx =
+								    VB_XGI301C;
 						}
 					}
 				}
@@ -3436,7 +3592,8 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx = 0;
 
 	if (pVBInfo->VBType & 0xFFFF) {
-		temp = xgifb_reg_get(pVBInfo->P3d4, 0x30); /* Check Display Device */
+		/* Check Display Device */
+		temp = xgifb_reg_get(pVBInfo->P3d4, 0x30);
 		tempbx = tempbx | temp;
 		temp = xgifb_reg_get(pVBInfo->P3d4, 0x31);
 		push = temp;
@@ -3455,29 +3612,34 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if ((pVBInfo->Set_VGAType >= XG20)
 					|| (pVBInfo->Set_VGAType >= XG40)) {
 				if (pVBInfo->IF_DEF_LVDS == 0) {
-					/* if ((pVBInfo->VBType & VB_XGI302B) || (pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType & VB_XGI302LV) || (pVBInfo->VBType & VB_XGI301C)) */
-					if (pVBInfo->VBType & (VB_XGI302B
-							| VB_XGI301LV
-							| VB_XGI302LV
-							| VB_XGI301C)) {
+					/* if ((pVBInfo->VBType & VB_XGI302B)
+					    || (pVBInfo->VBType & VB_XGI301LV)
+					    || (pVBInfo->VBType & VB_XGI302LV)
+					    || (pVBInfo->VBType & VB_XGI301C))
+					*/
+					if (pVBInfo->VBType &
+					    (VB_XGI302B |
+					     VB_XGI301LV |
+					     VB_XGI302LV |
+					     VB_XGI301C)) {
 						if (temp & EnableDualEdge) {
-							tempbx
-									|= SetCRT2ToDualEdge;
+							tempbx |=
+							    SetCRT2ToDualEdge;
 
 							if (temp & SetToLCDA)
-								tempbx
-										|= SetCRT2ToLCDA;
+								tempbx |=
+								  SetCRT2ToLCDA;
 						}
 					}
 				} else if (pVBInfo->IF_DEF_CH7017 == 1) {
 					if (pVBInfo->VBType & VB_CH7017) {
 						if (temp & EnableDualEdge) {
-							tempbx
-									|= SetCRT2ToDualEdge;
+							tempbx |=
+							    SetCRT2ToDualEdge;
 
 							if (temp & SetToLCDA)
-								tempbx
-										|= SetCRT2ToLCDA;
+								tempbx |=
+								  SetCRT2ToLCDA;
 						}
 					}
 				}
@@ -3485,29 +3647,30 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
-			if (((pVBInfo->IF_DEF_LVDS == 0) && ((pVBInfo->VBType
-					& VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV) || (pVBInfo->VBType
-					& VB_XGI301C)))
-					|| ((pVBInfo->IF_DEF_CH7017 == 1)
-							&& (pVBInfo->VBType
-									& VB_CH7017))
-					|| ((pVBInfo->IF_DEF_CH7007 == 1)
-							&& (pVBInfo->VBType
-									& VB_CH7007))) { /* [Billy] 07/05/04 */
+			/* [Billy] 07/05/04 */
+			if (((pVBInfo->IF_DEF_LVDS == 0) &&
+			    ((pVBInfo->VBType & VB_XGI301LV) ||
+			    (pVBInfo->VBType & VB_XGI302LV) ||
+			    (pVBInfo->VBType & VB_XGI301C))) ||
+			    ((pVBInfo->IF_DEF_CH7017 == 1) &&
+			    (pVBInfo->VBType & VB_CH7017)) ||
+			    ((pVBInfo->IF_DEF_CH7007 == 1) &&
+			    (pVBInfo->VBType & VB_CH7007))) {
 				if (temp & SetYPbPr) { /* temp = CR38 */
 					if (pVBInfo->IF_DEF_HiVision == 1) {
+						/* shampoo add for new
+						 * scratch */
 						temp = xgifb_reg_get(
 								pVBInfo->P3d4,
-								0x35); /* shampoo add for new scratch */
+								0x35);
 						temp &= YPbPrMode;
 						tempbx |= SetCRT2ToHiVisionTV;
 
 						if (temp != YPbPrMode1080i) {
-							tempbx
-									&= (~SetCRT2ToHiVisionTV);
-							tempbx
-									|= SetCRT2ToYPbPr;
+							tempbx &=
+							 (~SetCRT2ToHiVisionTV);
+							tempbx |=
+							 SetCRT2ToYPbPr;
 						}
 					}
 
@@ -3532,11 +3695,13 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			}
 		} else { /* 3nd party chip */
 			if (pVBInfo->IF_DEF_CH7017 == 1)
-				temp = (SetCRT2ToTV | SetCRT2ToLCD
-						| SetCRT2ToLCDA);
-			else if (pVBInfo->IF_DEF_CH7007 == 1) { /* [Billy] 07/05/03 */
+				temp = (SetCRT2ToTV |
+					SetCRT2ToLCD |
+					SetCRT2ToLCDA);
+			/* [Billy] 07/05/03 */
+			else if (pVBInfo->IF_DEF_CH7007 == 1)
 				temp = SetCRT2ToTV;
-			} else
+			else
 				temp = SetCRT2ToLCD;
 		}
 
@@ -3549,60 +3714,67 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (!(pVBInfo->VBType & VB_NoLCD)) {
 				if (tempbx & SetCRT2ToLCDA) {
 					if (tempbx & SetSimuScanMode)
-						tempbx
-								&= (~(SetCRT2ToLCD
-										| SetCRT2ToRAMDAC
-										| SwitchToCRT2));
+						tempbx &= (~(SetCRT2ToLCD |
+							   SetCRT2ToRAMDAC |
+							   SwitchToCRT2));
 					else
-						tempbx
-								&= (~(SetCRT2ToLCD
-										| SetCRT2ToRAMDAC
-										| SetCRT2ToTV
-										| SwitchToCRT2));
+						tempbx &= (~(SetCRT2ToLCD |
+							     SetCRT2ToRAMDAC |
+							     SetCRT2ToTV |
+							     SwitchToCRT2));
 				}
 			}
 		}
 
 		/* shampoo add */
-		if (!(tempbx & (SwitchToCRT2 | SetSimuScanMode))) { /* for driver abnormal */
+		/* for driver abnormal */
+		if (!(tempbx & (SwitchToCRT2 | SetSimuScanMode))) {
 			if (pVBInfo->IF_DEF_CRT2Monitor == 1) {
 				if (tempbx & SetCRT2ToRAMDAC) {
-					tempbx &= (0xFF00 | SetCRT2ToRAMDAC
-							| SwitchToCRT2
-							| SetSimuScanMode);
+					tempbx &= (0xFF00 |
+						   SetCRT2ToRAMDAC |
+						   SwitchToCRT2 |
+						   SetSimuScanMode);
 					tempbx &= (0x00FF | (~SetCRT2ToYPbPr));
 				}
 			} else {
-				tempbx &= (~(SetCRT2ToRAMDAC | SetCRT2ToLCD
-						| SetCRT2ToTV));
+				tempbx &= (~(SetCRT2ToRAMDAC |
+					   SetCRT2ToLCD |
+					   SetCRT2ToTV));
 			}
 		}
 
 		if (!(pVBInfo->VBType & VB_NoLCD)) {
 			if (tempbx & SetCRT2ToLCD) {
-				tempbx &= (0xFF00 | SetCRT2ToLCD | SwitchToCRT2
-						| SetSimuScanMode);
+				tempbx &= (0xFF00 |
+					   SetCRT2ToLCD |
+					   SwitchToCRT2 |
+					   SetSimuScanMode);
 				tempbx &= (0x00FF | (~SetCRT2ToYPbPr));
 			}
 		}
 
 		if (tempbx & SetCRT2ToSCART) {
-			tempbx &= (0xFF00 | SetCRT2ToSCART | SwitchToCRT2
-					| SetSimuScanMode);
+			tempbx &= (0xFF00 |
+				   SetCRT2ToSCART |
+				   SwitchToCRT2 |
+				   SetSimuScanMode);
 			tempbx &= (0x00FF | (~SetCRT2ToYPbPr));
 		}
 
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
 			if (tempbx & SetCRT2ToYPbPr)
-				tempbx &= (0xFF00 | SwitchToCRT2
-						| SetSimuScanMode);
+				tempbx &= (0xFF00 |
+					   SwitchToCRT2 |
+					   SetSimuScanMode);
 		}
 
 		if (pVBInfo->IF_DEF_HiVision == 1) {
 			if (tempbx & SetCRT2ToHiVisionTV)
-				tempbx &= (0xFF00 | SetCRT2ToHiVisionTV
-						| SwitchToCRT2
-						| SetSimuScanMode);
+				tempbx &= (0xFF00 |
+					   SetCRT2ToHiVisionTV |
+					   SwitchToCRT2 |
+					   SetSimuScanMode);
 		}
 
 		if (tempax & DisableCRT2Display) { /* Set Display Device Info */
@@ -3611,38 +3783,35 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 
 		if (!(tempbx & DisableCRT2Display)) {
-			if ((!(tempbx & DriverMode))
-					|| (!(modeflag & CRT2Mode))) {
+			if ((!(tempbx & DriverMode)) ||
+			    (!(modeflag & CRT2Mode))) {
 				if (pVBInfo->IF_DEF_LCDA == 1) {
 					if (!(tempbx & SetCRT2ToLCDA))
-						tempbx
-								|= (SetInSlaveMode
-										| SetSimuScanMode);
+						tempbx |= (SetInSlaveMode |
+							   SetSimuScanMode);
 				}
 
 				if (pVBInfo->IF_DEF_VideoCapture == 1) {
-					if (((HwDeviceExtension->jChipType
-							== XG40)
-							&& (pVBInfo->Set_VGAType
-									== XG40))
-							|| ((HwDeviceExtension->jChipType
-									== XG41)
-									&& (pVBInfo->Set_VGAType
-											== XG41))
-							|| ((HwDeviceExtension->jChipType
-									== XG42)
-									&& (pVBInfo->Set_VGAType
-											== XG42))
-							|| ((HwDeviceExtension->jChipType
-									== XG45)
-									&& (pVBInfo->Set_VGAType
-											== XG45))) {
+					if (((HwDeviceExtension->jChipType ==
+					      XG40) &&
+					     (pVBInfo->Set_VGAType == XG40)) ||
+					    ((HwDeviceExtension->jChipType ==
+					      XG41) &&
+					     (pVBInfo->Set_VGAType == XG41)) ||
+					    ((HwDeviceExtension->jChipType ==
+					      XG42) &&
+					     (pVBInfo->Set_VGAType == XG42)) ||
+					    ((HwDeviceExtension->jChipType ==
+					      XG45) &&
+					     (pVBInfo->Set_VGAType == XG45))) {
 						if (ModeNo <= 13) {
-							if (!(tempbx
-									& SetCRT2ToRAMDAC)) { /*CRT2 not need to support*/
-								tempbx
-										&= (0x00FF
-												| (~SetInSlaveMode));
+							if (!(tempbx &
+							     SetCRT2ToRAMDAC)) {
+								/*CRT2 not need
+								 * to support*/
+								tempbx &=
+								  (0x00FF |
+								  (~SetInSlaveMode));
 								pVBInfo->SetFlag
 										|= EnableVCMode;
 							}
@@ -3651,11 +3820,13 @@ void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 				}
 			}
 
-			/* LCD+TV can't support in slave mode (Force LCDA+TV->LCDB) */
-			if ((tempbx & SetInSlaveMode) && (tempbx
-					& SetCRT2ToLCDA)) {
-				tempbx ^= (SetCRT2ToLCD | SetCRT2ToLCDA
-						| SetCRT2ToDualEdge);
+			/* LCD+TV can't support in slave mode
+			 * (Force LCDA+TV->LCDB) */
+			if ((tempbx & SetInSlaveMode) &&
+			    (tempbx & SetCRT2ToLCDA)) {
+				tempbx ^= (SetCRT2ToLCD |
+					  SetCRT2ToLCDA |
+					  SetCRT2ToDualEdge);
 				pVBInfo->SetFlag |= ReserveTVOption;
 			}
 		}
@@ -3674,33 +3845,40 @@ void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
 		if (ModeNo <= 0x13) {
-			modeflag
-					= pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ModeFlag */
-			resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo; /* si+St_ResInfo */
+			modeflag = pVBInfo->SModeIDTable[ModeIdIndex].
+					St_ModeFlag; /* si+St_ModeFlag */
+			resinfo = pVBInfo->SModeIDTable[ModeIdIndex].
+					St_ResInfo; /* si+St_ResInfo */
 		} else {
-			modeflag
-					= pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-			resinfo
-					= pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO; /* si+Ext_ResInfo */
+			modeflag = pVBInfo->EModeIDTable[ModeIdIndex].
+					Ext_ModeFlag;
+			resinfo = pVBInfo->EModeIDTable[ModeIdIndex].
+					Ext_RESINFO; /* si+Ext_ResInfo */
 		}
 
 		if (pVBInfo->VBInfo & SetCRT2ToTV) {
 			temp = xgifb_reg_get(pVBInfo->P3d4, 0x35);
 			tempbx = temp;
 			if (tempbx & SetPALTV) {
-				tempbx &= (SetCHTVOverScan | SetPALMTV
-						| SetPALNTV | SetPALTV);
+				tempbx &= (SetCHTVOverScan |
+					   SetPALMTV |
+					   SetPALNTV |
+					   SetPALTV);
 				if (tempbx & SetPALMTV)
-					tempbx &= ~SetPALTV; /* set to NTSC if PAL-M */
+					/* set to NTSC if PAL-M */
+					tempbx &= ~SetPALTV;
 			} else
-				tempbx &= (SetCHTVOverScan | SetNTSCJ
-						| SetPALTV);
+				tempbx &= (SetCHTVOverScan |
+					   SetNTSCJ |
+					   SetPALTV);
 			/*
 			if (pVBInfo->IF_DEF_LVDS == 0) {
-				index1 = xgifb_reg_get(pVBInfo->P3d4, 0x38); //PAL-M/PAL-N Info
-				temp2 = (index1 & 0xC0) >> 5; //00:PAL, 01:PAL-M, 10:PAL-N
+				//PAL-M/PAL-N Info
+				index1 = xgifb_reg_get(pVBInfo->P3d4, 0x38);
+				//00:PAL, 01:PAL-M, 10:PAL-N
+				temp2 = (index1 & 0xC0) >> 5;
 				tempbx |= temp2;
-				if (temp2 & 0x02)          //PAL-M
+				if (temp2 & 0x02) //PAL-M
 					tempbx &= (~SetPALTV);
 			}
 			*/
@@ -3746,12 +3924,13 @@ void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 
 		if (pVBInfo->IF_DEF_LVDS == 0) { /* shampoo */
-			if ((pVBInfo->VBInfo & SetInSlaveMode)
-					&& (!(pVBInfo->VBInfo & SetNotSimuMode)))
+			if ((pVBInfo->VBInfo & SetInSlaveMode) &&
+			    (!(pVBInfo->VBInfo & SetNotSimuMode)))
 				tempbx |= TVSimuMode;
 
-			if (!(tempbx & SetPALTV) && (modeflag > 13) && (resinfo
-					== 8)) /* NTSC 1024x768, */
+			if (!(tempbx & SetPALTV) &&
+			    (modeflag > 13) &&
+			    (resinfo == 8)) /* NTSC 1024x768, */
 				tempbx |= NTSC1024x768;
 
 			tempbx |= RPLLDIV2XO;
@@ -3760,12 +3939,15 @@ void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 				if (pVBInfo->VBInfo & SetInSlaveMode)
 					tempbx &= (~RPLLDIV2XO);
 			} else {
-				if (tempbx & (SetYPbPrMode525p
-						| SetYPbPrMode750p))
+				if (tempbx &
+				    (SetYPbPrMode525p | SetYPbPrMode750p))
 					tempbx &= (~RPLLDIV2XO);
-				else if (!(pVBInfo->VBType & (VB_XGI301B
-						| VB_XGI302B | VB_XGI301LV
-						| VB_XGI302LV | VB_XGI301C))) {
+				else if (!(pVBInfo->VBType &
+					 (VB_XGI301B |
+					  VB_XGI302B |
+					  VB_XGI301LV |
+					  VB_XGI302LV |
+					  VB_XGI301C))) {
 					if (tempbx & TVSimuMode)
 						tempbx &= (~RPLLDIV2XO);
 				}
@@ -3785,10 +3967,12 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	pVBInfo->LCDInfo = 0;
 
 	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ModeFlag // */
+		/* si+St_ModeFlag // */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	} else {
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO; /* si+Ext_ResInfo // */
+		/* si+Ext_ResInfo // */
+		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
 	}
 
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x36); /* Get LCD Res.Info */
@@ -3857,7 +4041,8 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if ((pVBInfo->LCDResInfo == Panel1400x1050) && (pVBInfo->VBInfo
 				& SetCRT2ToLCD) && (ModeNo > 0x13) && (resinfo
 				== 9) && (!(tempbx & EnableScalingLCD)))
-			tempbx |= SetLCDtoNonExpanding; /* set to center in 1280x1024 LCDB for Panel1400x1050 */
+			/* set to center in 1280x1024 LCDB for Panel1400x1050 */
+			tempbx |= SetLCDtoNonExpanding;
 	}
 
 	/*
@@ -3875,7 +4060,7 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 				if (ModeNo > 0x13) {
 					if (pVBInfo->LCDResInfo
 							== Panel1024x768) {
-						if (resinfo == 4) { /* 512x384  */
+						if (resinfo == 4) {/* 512x384 */
 							tempbx |= EnableLVDSDDA;
 						}
 					}
@@ -3895,8 +4080,8 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->IF_DEF_PWD == 1) {
 		if (pVBInfo->LCDInfo & SetPWDEnable) {
-			if ((pVBInfo->VBType & VB_XGI302LV) || (pVBInfo->VBType
-					& VB_XGI301C)) {
+			if ((pVBInfo->VBType & VB_XGI302LV) ||
+			    (pVBInfo->VBType & VB_XGI301C)) {
 				if (!(tempax & PWDEnable))
 					pVBInfo->LCDInfo &= ~SetPWDEnable;
 			}
@@ -3908,13 +4093,13 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (pVBInfo->VBInfo & SetInSlaveMode) {
 				if (!(tempax & LockLCDBToA)) {
 					if (ModeNo <= 0x13) {
-						pVBInfo->VBInfo
-								&= ~(SetSimuScanMode
-										| SetInSlaveMode
-										| SetCRT2ToLCD);
-						pVBInfo->VBInfo
-								|= SetCRT2ToLCDA
-										| SetCRT2ToDualEdge;
+						pVBInfo->VBInfo &=
+							~(SetSimuScanMode |
+							  SetInSlaveMode |
+							  SetCRT2ToLCD);
+						pVBInfo->VBInfo |=
+							SetCRT2ToLCDA |
+							SetCRT2ToDualEdge;
 					}
 				}
 			}
@@ -3925,9 +4110,15 @@ unsigned char XGI_GetLCDInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (pVBInfo->IF_DEF_LVDS == 0) {
 		if (tempax & (LockLCDBToA | StLCDBToA)) {
 			if (pVBInfo->VBInfo & SetInSlaveMode) {
-				if (!((!(tempax & LockLCDBToA)) && (ModeNo > 0x13))) {
-					pVBInfo->VBInfo&=~(SetSimuScanMode|SetInSlaveMode|SetCRT2ToLCD);
-					pVBInfo->VBInfo|=SetCRT2ToLCDA|SetCRT2ToDualEdge;
+				if (!((!(tempax & LockLCDBToA)) &&
+				    (ModeNo > 0x13))) {
+					pVBInfo->VBInfo &=
+						~(SetSimuScanMode |
+						  SetInSlaveMode |
+						  SetCRT2ToLCD);
+					pVBInfo->VBInfo |=
+						SetCRT2ToLCDA |
+						SetCRT2ToDualEdge;
 				}
 			}
 		}
@@ -3943,11 +4134,16 @@ unsigned char XGI_SearchModeID(unsigned short ModeNo,
 	if (ModeNo <= 5)
 		ModeNo |= 1;
 	if (ModeNo <= 0x13) {
-		/* for (*ModeIdIndex=0; *ModeIdIndex < sizeof(pVBInfo->SModeIDTable) / sizeof(struct XGI_StStruct); (*ModeIdIndex)++) */
+		/* for (*ModeIdIndex=0;
+			*ModeIdIndex < sizeof(pVBInfo->SModeIDTable)
+				/ sizeof(struct XGI_StStruct);
+			(*ModeIdIndex)++) */
 		for (*ModeIdIndex = 0;; (*ModeIdIndex)++) {
-			if (pVBInfo->SModeIDTable[*ModeIdIndex].St_ModeID == ModeNo)
+			if (pVBInfo->SModeIDTable[*ModeIdIndex].St_ModeID ==
+			    ModeNo)
 				break;
-			if (pVBInfo->SModeIDTable[*ModeIdIndex].St_ModeID == 0xFF)
+			if (pVBInfo->SModeIDTable[*ModeIdIndex].St_ModeID ==
+			    0xFF)
 				return 0;
 		}
 
@@ -3957,11 +4153,16 @@ unsigned char XGI_SearchModeID(unsigned short ModeNo,
 			(*ModeIdIndex) += 2; /* 400 lines */
 		/* else 350 lines */
 	} else {
-		/* for (*ModeIdIndex=0; *ModeIdIndex < sizeof(pVBInfo->EModeIDTable) / sizeof(struct XGI_ExtStruct); (*ModeIdIndex)++) */
+		/* for (*ModeIdIndex=0;
+			*ModeIdIndex < sizeof(pVBInfo->EModeIDTable)
+				/ sizeof(struct XGI_ExtStruct);
+			(*ModeIdIndex)++) */
 		for (*ModeIdIndex = 0;; (*ModeIdIndex)++) {
-			if (pVBInfo->EModeIDTable[*ModeIdIndex].Ext_ModeID == ModeNo)
+			if (pVBInfo->EModeIDTable[*ModeIdIndex].Ext_ModeID ==
+			    ModeNo)
 				break;
-			if (pVBInfo->EModeIDTable[*ModeIdIndex].Ext_ModeID == 0xFF)
+			if (pVBInfo->EModeIDTable[*ModeIdIndex].Ext_ModeID ==
+			    0xFF)
 				return 0;
 		}
 	}
@@ -4002,19 +4203,22 @@ static unsigned char XGINew_CheckMemorySize(
 	tmp = temp;
 
 	if (HwDeviceExtension->jChipType == XG40) {
-		temp = 1 << ((temp & 0x0F0) >> 4); /* memory size per channel SR14[7:4] */
+		/* memory size per channel SR14[7:4] */
+		temp = 1 << ((temp & 0x0F0) >> 4);
 		if ((tmp & 0x0c) == 0x0C) { /* Qual channels */
 			temp <<= 2;
 		} else if ((tmp & 0x0c) == 0x08) { /* Dual channels */
 			temp <<= 1;
 		}
 	} else if (HwDeviceExtension->jChipType == XG42) {
-		temp = 1 << ((temp & 0x0F0) >> 4); /* memory size per channel SR14[7:4] */
+		/* memory size per channel SR14[7:4] */
+		temp = 1 << ((temp & 0x0F0) >> 4);
 		if ((tmp & 0x04) == 0x04) { /* Dual channels */
 			temp <<= 1;
 		}
 	} else if (HwDeviceExtension->jChipType == XG45) {
-		temp = 1 << ((temp & 0x0F0) >> 4); /* memory size per channel SR14[7:4] */
+		/* memory size per channel SR14[7:4] */
+		temp = 1 << ((temp & 0x0F0) >> 4);
 		if ((tmp & 0x0c) == 0x0C) { /* Qual channels */
 			temp <<= 2;
 		} else if ((tmp & 0x0c) == 0x08) { /* triple channels */
@@ -4033,7 +4237,13 @@ static unsigned char XGINew_CheckMemorySize(
 #endif
 
 /*
-void XGINew_IsLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned char XGINew_CheckMemorySize(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
+void XGINew_IsLowResolution(unsigned short ModeNo,
+			    unsigned short ModeIdIndex,
+			    unsigned char XGINew_CheckMemorySize(
+				struct xgi_hw_device_info *HwDeviceExtension,
+				unsigned short ModeNo,
+				unsigned short ModeIdIndex,
+				struct vb_device_info *pVBInfo)
 {
 	unsigned short data ;
 	unsigned short ModeFlag ;
@@ -4122,35 +4332,43 @@ void XGI_DisplayOn(struct xgi_hw_device_info *pXGIHWDE,
 	if (pXGIHWDE->jChipType == XG21) {
 		if (pVBInfo->IF_DEF_LVDS == 1) {
 			if (!(XGI_XG21GetPSCValue(pVBInfo) & 0x1)) {
-				XGI_XG21BLSignalVDD(0x01, 0x01, pVBInfo); /* LVDS VDD on */
+				/* LVDS VDD on */
+				XGI_XG21BLSignalVDD(0x01, 0x01, pVBInfo);
 				XGI_XG21SetPanelDelay(2, pVBInfo);
 			}
 			if (!(XGI_XG21GetPSCValue(pVBInfo) & 0x20))
-				XGI_XG21BLSignalVDD(0x20, 0x20, pVBInfo); /* LVDS signal on */
+				/* LVDS signal on */
+				XGI_XG21BLSignalVDD(0x20, 0x20, pVBInfo);
 			XGI_XG21SetPanelDelay(3, pVBInfo);
-			XGI_XG21BLSignalVDD(0x02, 0x02, pVBInfo); /* LVDS backlight on */
+			/* LVDS backlight on */
+			XGI_XG21BLSignalVDD(0x02, 0x02, pVBInfo);
 		} else {
-			XGI_XG21BLSignalVDD(0x20, 0x20, pVBInfo); /* DVO/DVI signal on */
+			/* DVO/DVI signal on */
+			XGI_XG21BLSignalVDD(0x20, 0x20, pVBInfo);
 		}
 
 	}
 
-	if (pVBInfo->IF_DEF_CH7007 == 1) { /* [Billy] 07/05/23 For CH7007 */
-
+	/* [Billy] 07/05/23 For CH7007 */
+	if (pVBInfo->IF_DEF_CH7007 == 1) {
 	}
 
 	if (pXGIHWDE->jChipType == XG27) {
 		if (pVBInfo->IF_DEF_LVDS == 1) {
 			if (!(XGI_XG27GetPSCValue(pVBInfo) & 0x1)) {
-				XGI_XG27BLSignalVDD(0x01, 0x01, pVBInfo); /* LVDS VDD on */
+				/* LVDS VDD on */
+				XGI_XG27BLSignalVDD(0x01, 0x01, pVBInfo);
 				XGI_XG21SetPanelDelay(2, pVBInfo);
 			}
 			if (!(XGI_XG27GetPSCValue(pVBInfo) & 0x20))
-				XGI_XG27BLSignalVDD(0x20, 0x20, pVBInfo); /* LVDS signal on */
+				/* LVDS signal on */
+				XGI_XG27BLSignalVDD(0x20, 0x20, pVBInfo);
 			XGI_XG21SetPanelDelay(3, pVBInfo);
-			XGI_XG27BLSignalVDD(0x02, 0x02, pVBInfo); /* LVDS backlight on */
+			/* LVDS backlight on */
+			XGI_XG27BLSignalVDD(0x02, 0x02, pVBInfo);
 		} else {
-			XGI_XG27BLSignalVDD(0x20, 0x20, pVBInfo); /* DVO/DVI signal on */
+			/* DVO/DVI signal on */
+			XGI_XG27BLSignalVDD(0x20, 0x20, pVBInfo);
 		}
 
 	}
@@ -4162,10 +4380,12 @@ void XGI_DisplayOff(struct xgi_hw_device_info *pXGIHWDE,
 
 	if (pXGIHWDE->jChipType == XG21) {
 		if (pVBInfo->IF_DEF_LVDS == 1) {
-			XGI_XG21BLSignalVDD(0x02, 0x00, pVBInfo); /* LVDS backlight off */
+			/* LVDS backlight off */
+			XGI_XG21BLSignalVDD(0x02, 0x00, pVBInfo);
 			XGI_XG21SetPanelDelay(3, pVBInfo);
 		} else {
-			XGI_XG21BLSignalVDD(0x20, 0x00, pVBInfo); /* DVO/DVI signal off */
+			/* DVO/DVI signal off */
+			XGI_XG21BLSignalVDD(0x20, 0x00, pVBInfo);
 		}
 	}
 
@@ -4177,12 +4397,14 @@ void XGI_DisplayOff(struct xgi_hw_device_info *pXGIHWDE,
 
 	if (pXGIHWDE->jChipType == XG27) {
 		if ((XGI_XG27GetPSCValue(pVBInfo) & 0x2)) {
-			XGI_XG27BLSignalVDD(0x02, 0x00, pVBInfo); /* LVDS backlight off */
+			/* LVDS backlight off */
+			XGI_XG27BLSignalVDD(0x02, 0x00, pVBInfo);
 			XGI_XG21SetPanelDelay(3, pVBInfo);
 		}
 
 		if (pVBInfo->IF_DEF_LVDS == 0)
-			XGI_XG27BLSignalVDD(0x20, 0x00, pVBInfo); /* DVO/DVI signal off */
+			/* DVO/DVI signal off */
+			XGI_XG27BLSignalVDD(0x20, 0x00, pVBInfo);
 	}
 
 	xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xDF, 0x20);
@@ -4200,8 +4422,10 @@ static void XGI_WaitDisply(struct vb_device_info *pVBInfo)
 #if 0
 static void XGI_WaitDisplay(struct vb_device_info *pVBInfo)
 {
-	while (!(inb(pVBInfo->P3da) & 0x01));
-	while (inb(pVBInfo->P3da) & 0x01);
+	while (!(inb(pVBInfo->P3da) & 0x01))
+		;
+	while (inb(pVBInfo->P3da) & 0x01)
+		;
 }
 #endif
 
@@ -4211,18 +4435,21 @@ static void XGI_AutoThreshold(struct vb_device_info *pVBInfo)
 		xgifb_reg_or(pVBInfo->Part1Port, 0x01, 0x40);
 }
 
-static void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo)
+static void XGI_SaveCRT2Info(unsigned short ModeNo,
+			     struct vb_device_info *pVBInfo)
 {
 	unsigned short temp1, temp2;
 
-	xgifb_reg_set(pVBInfo->P3d4, 0x34, ModeNo); /* reserve CR34 for CRT1 Mode No */
+	/* reserve CR34 for CRT1 Mode No */
+	xgifb_reg_set(pVBInfo->P3d4, 0x34, ModeNo);
 	temp1 = (pVBInfo->VBInfo & SetInSlaveMode) >> 8;
 	temp2 = ~(SetInSlaveMode >> 8);
 	xgifb_reg_and_or(pVBInfo->P3d4, 0x31, temp2, temp1);
 }
 
-static void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_GetCRT2ResInfo(unsigned short ModeNo,
+			       unsigned short ModeIdIndex,
+			       struct vb_device_info *pVBInfo)
 {
 	unsigned short xres, yres, modeflag, resindex;
 
@@ -4230,11 +4457,13 @@ static void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex
 	if (ModeNo <= 0x13) {
 		xres = pVBInfo->StResInfo[resindex].HTotal;
 		yres = pVBInfo->StResInfo[resindex].VTotal;
-		/* modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; si+St_ResInfo */
+		/* si+St_ResInfo */
+		/* modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;*/
 	} else {
 		xres = pVBInfo->ModeResInfo[resindex].HTotal; /* xres->ax */
 		yres = pVBInfo->ModeResInfo[resindex].VTotal; /* yres->bx */
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+St_ModeFlag */
+		/* si+St_ModeFlag */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
 		/*
 		if (pVBInfo->IF_DEF_FSTN) {
@@ -4306,9 +4535,10 @@ static unsigned char XGI_IsLCDDualLink(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
-static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_GetRAMDAC2DATA(unsigned short ModeNo,
+			       unsigned short ModeIdIndex,
+			       unsigned short RefreshRateTableIndex,
+			       struct vb_device_info *pVBInfo)
 {
 	unsigned short tempax, tempbx, temp1, temp2, modeflag = 0, tempcx,
 			StandTableIndex, CRT1Index;
@@ -4324,24 +4554,23 @@ static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex
 		temp1 = pVBInfo->StandTable[StandTableIndex].CRTC[7];
 	} else {
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-		CRT1Index
-				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
+		CRT1Index = pVBInfo->RefIndex[RefreshRateTableIndex].
+				Ext_CRT1CRTC;
 		CRT1Index &= IndexMask;
-		temp1
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[0];
-		temp2
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[5];
+		temp1 = (unsigned short) pVBInfo->
+			XGINEWUB_CRT1Table[CRT1Index].CR[0];
+		temp2 = (unsigned short) pVBInfo->
+			XGINEWUB_CRT1Table[CRT1Index].CR[5];
 		tempax = (temp1 & 0xFF) | ((temp2 & 0x03) << 8);
-		tempbx
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[8];
-		tempcx
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[14]
-						<< 8;
+		tempbx = (unsigned short) pVBInfo->
+			XGINEWUB_CRT1Table[CRT1Index].CR[8];
+		tempcx = (unsigned short) pVBInfo->
+			XGINEWUB_CRT1Table[CRT1Index].CR[14] << 8;
 		tempcx &= 0x0100;
 		tempcx = tempcx << 2;
 		tempbx |= tempcx;
-		temp1
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[9];
+		temp1 = (unsigned short) pVBInfo->
+			XGINEWUB_CRT1Table[CRT1Index].CR[9];
 	}
 
 	if (temp1 & 0x01)
@@ -4373,10 +4602,12 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 	struct XGI_TVDataStruct *TVPtr = NULL;
 
 	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 		resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
 	}
 
@@ -4598,7 +4829,8 @@ static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
 	return ColorDepth[index];
 }
 
-static unsigned short XGI_GetOffset(unsigned short ModeNo, unsigned short ModeIdIndex,
+static unsigned short XGI_GetOffset(unsigned short ModeNo,
+				    unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
@@ -4610,7 +4842,8 @@ static unsigned short XGI_GetOffset(unsigned short ModeNo, unsigned short ModeId
 	if (ModeNo <= 0x14)
 		infoflag = 0;
 	else
-		infoflag = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
+		infoflag = pVBInfo->
+				RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
 
 	index = (modeinfo >> 8) & 0xFF;
 
@@ -4657,8 +4890,10 @@ static void XGI_SetCRT2Offset(unsigned short ModeNo,
 
 static void XGI_SetCRT2FIFO(struct vb_device_info *pVBInfo)
 {
-	xgifb_reg_set(pVBInfo->Part1Port, 0x01, 0x3B); /* threshold high ,disable auto threshold */
-	xgifb_reg_and_or(pVBInfo->Part1Port, 0x02, ~(0x3F), 0x04); /* threshold low default 04h */
+	/* threshold high ,disable auto threshold */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x01, 0x3B);
+	/* threshold low default 04h */
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x02, ~(0x3F), 0x04);
 }
 
 static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -4669,7 +4904,8 @@ static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	unsigned short tempcx = 0, CRT1Index = 0, resinfo = 0;
 
 	if (ModeNo > 0x13) {
-		CRT1Index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
+		CRT1Index = pVBInfo->
+				RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 		CRT1Index &= IndexMask;
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
 	}
@@ -4695,7 +4931,8 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 			pushbx = 0, CRT1Index = 0, modeflag, resinfo = 0;
 
 	if (ModeNo > 0x13) {
-		CRT1Index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
+		CRT1Index = pVBInfo->
+				RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 		CRT1Index &= IndexMask;
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
 	}
@@ -4707,11 +4944,13 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	/* bainy change table name */
 	if (modeflag & HalfDCLK) {
-		temp = (pVBInfo->VGAHT / 2 - 1) & 0x0FF; /* BTVGA2HT 0x08,0x09 */
+		/* BTVGA2HT 0x08,0x09 */
+		temp = (pVBInfo->VGAHT / 2 - 1) & 0x0FF;
 		xgifb_reg_set(pVBInfo->Part1Port, 0x08, temp);
 		temp = (((pVBInfo->VGAHT / 2 - 1) & 0xFF00) >> 8) << 4;
 		xgifb_reg_and_or(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
-		temp = (pVBInfo->VGAHDE / 2 + 16) & 0x0FF; /* BTVGA2HDEE 0x0A,0x0C */
+		/* BTVGA2HDEE 0x0A,0x0C */
+		temp = (pVBInfo->VGAHDE / 2 + 16) & 0x0FF;
 		xgifb_reg_set(pVBInfo->Part1Port, 0x0A, temp);
 		tempcx = ((pVBInfo->VGAHT - pVBInfo->VGAHDE) / 2) >> 2;
 		pushbx = pVBInfo->VGAHDE / 2 + 16;
@@ -4721,8 +4960,9 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		if (pVBInfo->VBInfo & SetCRT2ToRAMDAC) {
 			tempbx = pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[4];
-			tempbx |= ((pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[14]
-							& 0xC0) << 2);
+			tempbx |= ((pVBInfo->
+					XGINEWUB_CRT1Table[CRT1Index].CR[14] &
+						0xC0) << 2);
 			tempbx = (tempbx - 3) << 3; /* (VGAHRS-3)*8 */
 			tempcx = pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[5];
 			tempcx &= 0x1F;
@@ -4745,7 +4985,8 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 		xgifb_reg_set(pVBInfo->Part1Port, 0x08, temp);
 		temp = (((pVBInfo->VGAHT - 1) & 0xFF00) >> 8) << 4;
 		xgifb_reg_and_or(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
-		temp = (pVBInfo->VGAHDE + 16) & 0x0FF; /* BTVGA2HDEE 0x0A,0x0C */
+		/* BTVGA2HDEE 0x0A,0x0C */
+		temp = (pVBInfo->VGAHDE + 16) & 0x0FF;
 		xgifb_reg_set(pVBInfo->Part1Port, 0x0A, temp);
 		tempcx = (pVBInfo->VGAHT - pVBInfo->VGAHDE) >> 2; /* cx */
 		pushbx = pVBInfo->VGAHDE + 16;
@@ -4755,8 +4996,9 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		if (pVBInfo->VBInfo & SetCRT2ToRAMDAC) {
 			tempbx = pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[3];
-			tempbx |= ((pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[5]
-							& 0xC0) << 2);
+			tempbx |= ((pVBInfo->
+					XGINEWUB_CRT1Table[CRT1Index].CR[5] &
+						0xC0) << 2);
 			tempbx = (tempbx - 3) << 3; /* (VGAHRS-3)*8 */
 			tempcx = pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[4];
 			tempcx &= 0x1F;
@@ -4801,8 +5043,10 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempax = pVBInfo->VGAVDE;
 	tempbx = pVBInfo->VGAVDE;
 	tempcx = pVBInfo->VGAVT;
-	tempbx = (pVBInfo->VGAVT + pVBInfo->VGAVDE) >> 1; /* BTVGA2VRS 0x10,0x11 */
-	tempcx = ((pVBInfo->VGAVT - pVBInfo->VGAVDE) >> 4) + tempbx + 1; /* BTVGA2VRE 0x11 */
+	/* BTVGA2VRS 0x10,0x11 */
+	tempbx = (pVBInfo->VGAVT + pVBInfo->VGAVDE) >> 1;
+	/* BTVGA2VRE 0x11 */
+	tempcx = ((pVBInfo->VGAVT - pVBInfo->VGAVDE) >> 4) + tempbx + 1;
 
 	if (pVBInfo->VBInfo & SetCRT2ToRAMDAC) {
 		tempbx = pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[10];
@@ -4860,12 +5104,15 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			modeflag, CRT1Index;
 
 	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 		resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
-		CRT1Index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
+		CRT1Index = pVBInfo->
+				RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 		CRT1Index &= IndexMask;
 	}
 
@@ -4911,8 +5158,10 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	xgifb_reg_set(pVBInfo->Part1Port, 0x05, temp); /* 0x05 Horizontal Display Start */
-	xgifb_reg_set(pVBInfo->Part1Port, 0x06, 0x03); /* 0x06 Horizontal Blank end */
+	/* 0x05 Horizontal Display Start */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x05, temp);
+	/* 0x06 Horizontal Blank end */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x06, 0x03);
 
 	if (!(pVBInfo->VBInfo & DisableCRT2Display)) { /* 030226 bainy */
 		if (pVBInfo->VBInfo & SetCRT2ToTV)
@@ -4960,15 +5209,14 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 				if (pVBInfo->LCDResInfo != Panel1280x960) {
 					if (pVBInfo->VGAHDE >= 800) {
 						temp -= 7;
-						if (pVBInfo->ModeType
-								== ModeEGA) {
-							if (pVBInfo->VGAVDE
-									== 1024) {
+						if (pVBInfo->ModeType ==
+							ModeEGA) {
+							if (pVBInfo->VGAVDE ==
+							    1024) {
 								temp += 15;
-								if (pVBInfo->LCDResInfo
-										!= Panel1280x1024) {
-									temp
-											+= 7;
+								if (pVBInfo->LCDResInfo != Panel1280x1024) {
+									temp +=
+									    7;
 								}
 							}
 						}
@@ -4989,8 +5237,10 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	xgifb_reg_set(pVBInfo->Part1Port, 0x07, temp); /* 0x07 Horizontal Retrace Start */
-	xgifb_reg_set(pVBInfo->Part1Port, 0x08, 0); /* 0x08 Horizontal Retrace End */
+	/* 0x07 Horizontal Retrace Start */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x07, temp);
+	/* 0x08 Horizontal Retrace End */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x08, 0);
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
 		if (pVBInfo->TVInfo & TVSimuMode) {
@@ -5087,7 +5337,8 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = tempbx & 0x00FF;
 	tempbx--;
 	temp = tempbx & 0x00FF;
-	xgifb_reg_set(pVBInfo->Part1Port, 0x10, temp); /* 0x10 vertical Blank Start */
+	/* 0x10 vertical Blank Start */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x10, temp);
 	tempbx = push2;
 	tempbx--;
 	temp = tempbx & 0x00FF;
@@ -5110,7 +5361,8 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (tempbx & 0x0400)
 		tempcx |= 0x0600;
 
-	xgifb_reg_set(pVBInfo->Part1Port, 0x11, 0x00); /* 0x11 Vertival Blank End */
+	/* 0x11 Vertival Blank End */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x11, 0x00);
 
 	tempax = push1;
 	tempax -= tempbx; /* 0x0C Vertical Retrace Start */
@@ -5129,12 +5381,12 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			} else {
 				if (pVBInfo->TVInfo & TVSimuMode) {
 					if (pVBInfo->TVInfo & SetPALTV) {
-						if (pVBInfo->VBType
-								& VB_XGI301LV) {
-							if (!(pVBInfo->TVInfo
-									& (SetYPbPrMode525p
-											| SetYPbPrMode750p
-											| SetYPbPrMode1080i)))
+						if (pVBInfo->VBType &
+						    VB_XGI301LV) {
+							if (!(pVBInfo->TVInfo &
+							    (SetYPbPrMode525p |
+							    SetYPbPrMode750p |
+							    SetYPbPrMode1080i)))
 								tempbx += 40;
 						} else {
 							tempbx += 40;
@@ -5149,10 +5401,10 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->TVInfo & TVSimuMode) {
 			if (pVBInfo->TVInfo & SetPALTV) {
 				if (pVBInfo->VBType & VB_XGI301LV) {
-					if (!(pVBInfo->TVInfo
-							& (SetYPbPrMode525p
-									| SetYPbPrMode750p
-									| SetYPbPrMode1080i)))
+					if (!(pVBInfo->TVInfo &
+					    (SetYPbPrMode525p |
+					     SetYPbPrMode750p |
+					     SetYPbPrMode1080i)))
 						tempbx += 40;
 				} else {
 					tempbx += 40;
@@ -5199,7 +5451,8 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx = push1; /* pop ax */
 	temp = tempbx & 0x00FF;
 	temp &= 0x0F;
-	xgifb_reg_set(pVBInfo->Part1Port, 0x0D, temp); /* 0x0D vertical Retrace End */
+	/* 0x0D vertical Retrace End */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0D, temp);
 
 	if (tempbx & 0x0010)
 		tempcx |= 0x2000;
@@ -5242,14 +5495,16 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	unsigned long longtemp, tempeax, tempebx, temp2, tempecx;
 
 	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 		resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 		crt2crtc = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
 	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
-		crt2crtc
-				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+		crt2crtc = pVBInfo->RefIndex[RefreshRateTableIndex].
+				Ext_CRT2CRTC;
 	}
 
 	tempax = 0;
@@ -5308,7 +5563,8 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		xgifb_reg_set(pVBInfo->Part2Port, i, TimingPoint[j]);
 
 	for (i = 0x39; i <= 0x45; i++, j++)
-		xgifb_reg_set(pVBInfo->Part2Port, i, TimingPoint[j]); /* di->temp2[j] */
+		/* di->temp2[j] */
+		xgifb_reg_set(pVBInfo->Part2Port, i, TimingPoint[j]);
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV)
 		xgifb_reg_and_or(pVBInfo->Part2Port, 0x3A, 0x1F, 0x00);
@@ -5453,9 +5709,10 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempbx = 853;
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
-		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
-			if (!(pVBInfo->TVInfo & (SetYPbPrMode525p
-					| SetYPbPrMode750p)))
+		if (pVBInfo->VBType &
+		    (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
+			if (!(pVBInfo->TVInfo &
+			    (SetYPbPrMode525p | SetYPbPrMode750p)))
 				tempbx = tempbx >> 1;
 		} else
 			tempbx = tempbx >> 1;
@@ -5688,13 +5945,15 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	struct XGI_LCDDesStruct *LCDBDesPtr = NULL;
 
 	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 		resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
 	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
-		CRT1Index
-				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
+		CRT1Index = pVBInfo->RefIndex[RefreshRateTableIndex].
+			Ext_CRT1CRTC;
 		CRT1Index &= IndexMask;
 	}
 
@@ -5755,7 +6014,8 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if ((tempah == Panel1024x768) || (tempah == Panel1024x768x75)) {
 		tempbx = 1024;
 		tempcx = 768;
-	} else if ((tempah == Panel1280x1024) || (tempah == Panel1280x1024x75)) {
+	} else if ((tempah == Panel1280x1024) ||
+		   (tempah == Panel1280x1024x75)) {
 		tempbx = 1280;
 		tempcx = 1024;
 	} else if (tempah == Panel1400x1050) {
@@ -5965,16 +6225,23 @@ static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 	for (i = 0x80, j = 0; i <= 0xBF; i++, j++)
 		xgifb_reg_set(pVBInfo->Part2Port, i, Tap4TimingPtr->Reg[j]);
 
-	if ((pVBInfo->VBInfo & SetCRT2ToTV) && (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV))) {
-		Tap4TimingPtr = XGI_GetTap4Ptr(1, pVBInfo); /* Set Vertical Scaling */
+	if ((pVBInfo->VBInfo & SetCRT2ToTV) &&
+	    (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV))) {
+		/* Set Vertical Scaling */
+		Tap4TimingPtr = XGI_GetTap4Ptr(1, pVBInfo);
 		for (i = 0xC0, j = 0; i < 0xFF; i++, j++)
-			xgifb_reg_set(pVBInfo->Part2Port, i, Tap4TimingPtr->Reg[j]);
+			xgifb_reg_set(pVBInfo->Part2Port,
+				      i,
+				      Tap4TimingPtr->Reg[j]);
 	}
 
-	if ((pVBInfo->VBInfo & SetCRT2ToTV) && (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)))
-		xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x14, 0x04); /* Enable V.Scaling */
+	if ((pVBInfo->VBInfo & SetCRT2ToTV) &&
+	    (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)))
+		/* Enable V.Scaling */
+		xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x14, 0x04);
 	else
-		xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x14, 0x10); /* Enable H.Scaling */
+		/* Enable H.Scaling */
+		xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x14, 0x10);
 #endif
 }
 
@@ -5986,9 +6253,11 @@ static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 	unsigned short modeflag;
 
 	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	else
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
 	xgifb_reg_set(pVBInfo->Part3Port, 0x00, 0x00);
 	if (pVBInfo->TVInfo & SetPALTV) {
@@ -6047,9 +6316,11 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 	unsigned long tempebx, tempeax, templong;
 
 	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	else
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		/* si+Ext_ResInfo */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
 	temp = pVBInfo->RVBHCFACT;
 	xgifb_reg_set(pVBInfo->Part4Port, 0x13, temp);
@@ -6162,7 +6433,9 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (XGI_IsLCDDualLink(pVBInfo))
 			tempax = tempax >> 1;
 
-		/* if((pVBInfo->VBInfo&(SetCRT2ToLCD))||((pVBInfo->TVInfo&SetYPbPrMode525p)||(pVBInfo->TVInfo&SetYPbPrMode750p))) { */
+		/* if((pVBInfo->VBInfo&(SetCRT2ToLCD)) ||
+		      ((pVBInfo->TVInfo&SetYPbPrMode525p) ||
+		      (pVBInfo->TVInfo&SetYPbPrMode750p))) { */
 		if (pVBInfo->VBInfo & SetCRT2ToLCD) {
 			if (tempax > 800)
 				tempax -= 800;
@@ -6179,12 +6452,17 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		/*
 		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToHiVisionTV)) {
 			if (pVBInfo->VBType & VB_XGI301LV) {
-				if (!(pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p | SetYPbPrMode1080i))) {
+				if (!(pVBInfo->TVInfo &
+				      (SetYPbPrMode525p |
+				       SetYPbPrMode750p |
+				       SetYPbPrMode1080i))) {
 					if (pVBInfo->VGAHDE > 800) {
 						if (pVBInfo->VGAHDE == 1024)
-							tempax = (tempax * 25 / 32) - 1;
+							tempax =(tempax * 25 /
+								 32) - 1;
 						else
-							tempax = (tempax * 20 / 32) - 1;
+							tempax = (tempax * 20 /
+								  32) - 1;
 					}
 				}
 			} else {
@@ -6297,7 +6575,8 @@ void XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	if (tempbh & 0x20) {
 		temp = (tempbl >> 4) & 0x02;
 
-		xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~0x02, temp); /* CR B4[1] */
+		/* CR B4[1] */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~0x02, temp);
 
 	}
 
@@ -6325,7 +6604,8 @@ void XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	if (tempbh & 0x20) {
 		temp = (tempbl >> 4) & 0x02;
 
-		xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~0x02, temp); /* CR B4[1] */
+		/* CR B4[1] */
+		xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~0x02, temp);
 
 	}
 	xgifb_reg_and_or(pVBInfo->P3d4, 0xB4, ~tempbh0, tempbl0);
@@ -6390,11 +6670,13 @@ unsigned char XGI_XG21CheckLVDSMode(unsigned short ModeNo,
 	if (ModeNo <= 0x13) {
 		xres = pVBInfo->StResInfo[resindex].HTotal;
 		yres = pVBInfo->StResInfo[resindex].VTotal;
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	} else {
 		xres = pVBInfo->ModeResInfo[resindex].HTotal; /* xres->ax */
 		yres = pVBInfo->ModeResInfo[resindex].VTotal; /* yres->bx */
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+St_ModeFlag */
+		/* si+St_ModeFlag */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 	}
 
 	if (!(modeflag & Charx8Dot)) {
@@ -6419,12 +6701,13 @@ unsigned char XGI_XG21CheckLVDSMode(unsigned short ModeNo,
 		return 0;
 
 	if (ModeNo > 0x13) {
-		if ((xres
-				!= (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSHDE))
-				|| (yres
-						!= (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE))) {
-			colordepth = XGI_GetColorDepth(ModeNo, ModeIdIndex,
-					pVBInfo);
+		if ((xres != (pVBInfo->XG21_LVDSCapList[lvdstableindex].
+				LVDSHDE)) ||
+		    (yres != (pVBInfo->XG21_LVDSCapList[lvdstableindex].
+				LVDSVDE))) {
+			colordepth = XGI_GetColorDepth(ModeNo,
+						       ModeIdIndex,
+						       pVBInfo);
 			if (colordepth > 2)
 				return 0;
 
@@ -6439,8 +6722,10 @@ void XGI_SetXG21FPBits(struct vb_device_info *pVBInfo)
 
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37); /* D[0] 1: 18bit */
 	temp = (temp & 1) << 6;
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x06, ~0x40, temp); /* SR06[6] 18bit Dither */
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: dual 12bits */
+	/* SR06[6] 18bit Dither */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x06, ~0x40, temp);
+	/* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: dual 12bits */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80);
 
 }
 
@@ -6448,15 +6733,19 @@ void XGI_SetXG27FPBits(struct vb_device_info *pVBInfo)
 {
 	unsigned char temp;
 
-	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37); /* D[1:0] 01: 18bit, 00: dual 12, 10: single 24 */
+	/* D[1:0] 01: 18bit, 00: dual 12, 10: single 24 */
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x37);
 	temp = (temp & 3) << 6;
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x06, ~0xc0, temp & 0x80); /* SR06[7]0: dual 12/1: single 24 [6] 18bit Dither <= 0 h/w recommend */
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80); /* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: 24bits */
+	/* SR06[7]0: dual 12/1: single 24 [6] 18bit Dither <= 0 h/w recommend */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x06, ~0xc0, temp & 0x80);
+	/* SR09[7] enable FP output, SR09[6] 1: sigle 18bits, 0: 24bits */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x09, ~0xc0, temp | 0x80);
 
 }
 
-static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetXG21LVDSPara(unsigned short ModeNo,
+				unsigned short ModeIdIndex,
+				struct vb_device_info *pVBInfo)
 {
 	unsigned char temp, Miscdata;
 	unsigned short xres, yres, modeflag, resindex, lvdstableindex;
@@ -6466,28 +6755,33 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 	lvdstableindex = XGI_GetLVDSOEMTableIndex(pVBInfo);
 
-	temp = (unsigned char) ((pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
-					& (LCDPolarity << 8)) >> 8);
+	temp = (unsigned char) ((pVBInfo->XG21_LVDSCapList[lvdstableindex].
+						LVDS_Capability &
+				(LCDPolarity << 8)) >> 8);
 	temp &= LCDPolarity;
 	Miscdata = (unsigned char) inb(pVBInfo->P3cc);
 
 	outb((Miscdata & 0x3F) | temp, pVBInfo->P3c2);
 
-	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
-					& LCDPolarity);
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80); /* SR35[7] FP VSync polarity */
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1); /* SR30[5] FP HSync polarity */
+	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].
+						LVDS_Capability & LCDPolarity);
+	/* SR35[7] FP VSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80);
+	/* SR30[5] FP HSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1);
 
 	XGI_SetXG21FPBits(pVBInfo);
 	resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
 	if (ModeNo <= 0x13) {
 		xres = pVBInfo->StResInfo[resindex].HTotal;
 		yres = pVBInfo->StResInfo[resindex].VTotal;
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	} else {
 		xres = pVBInfo->ModeResInfo[resindex].HTotal; /* xres->ax */
 		yres = pVBInfo->ModeResInfo[resindex].VTotal; /* yres->bx */
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+St_ModeFlag */
+		/* si+St_ModeFlag */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 	}
 
 	if (!(modeflag & Charx8Dot))
@@ -6619,18 +6913,21 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x31, ~0x30, value);
 		xgifb_reg_set(pVBInfo->P3c4,
-				0x2B,
-				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData1);
+			      0x2B,
+			      pVBInfo->XG21_LVDSCapList[lvdstableindex].
+						VCLKData1);
 		xgifb_reg_set(pVBInfo->P3c4,
-				0x2C,
-				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData2);
+			      0x2C,
+			      pVBInfo->XG21_LVDSCapList[lvdstableindex].
+						VCLKData2);
 		value += 0x10;
 	}
 
 	if (!(modeflag & Charx8Dot)) {
 		inb(pVBInfo->P3da); /* reset 3da */
 		outb(0x13, pVBInfo->P3c0); /* set index */
-		outb(0x00, pVBInfo->P3c0); /* set data, panning = 0, shift left 1 dot*/
+		/* set data, panning = 0, shift left 1 dot*/
+		outb(0x00, pVBInfo->P3c0);
 
 		inb(pVBInfo->P3da); /* Enable Attribute */
 		outb(0x20, pVBInfo->P3c0);
@@ -6641,8 +6938,9 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 }
 
 /* no shadow case */
-static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetXG27LVDSPara(unsigned short ModeNo,
+				unsigned short ModeIdIndex,
+				struct vb_device_info *pVBInfo)
 {
 	unsigned char temp, Miscdata;
 	unsigned short xres, yres, modeflag, resindex, lvdstableindex;
@@ -6651,28 +6949,33 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	unsigned short value;
 
 	lvdstableindex = XGI_GetLVDSOEMTableIndex(pVBInfo);
-	temp = (unsigned char) ((pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
-					& (LCDPolarity << 8)) >> 8);
+	temp = (unsigned char) ((pVBInfo->XG21_LVDSCapList[lvdstableindex].
+					LVDS_Capability &
+				(LCDPolarity << 8)) >> 8);
 	temp &= LCDPolarity;
 	Miscdata = (unsigned char) inb(pVBInfo->P3cc);
 
 	outb((Miscdata & 0x3F) | temp, pVBInfo->P3c2);
 
-	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
-					& LCDPolarity);
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80); /* SR35[7] FP VSync polarity */
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1); /* SR30[5] FP HSync polarity */
+	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].
+					LVDS_Capability & LCDPolarity);
+	/* SR35[7] FP VSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x35, ~0x80, temp & 0x80);
+	/* SR30[5] FP HSync polarity */
+	xgifb_reg_and_or(pVBInfo->P3c4, 0x30, ~0x20, (temp & 0x40) >> 1);
 
 	XGI_SetXG27FPBits(pVBInfo);
 	resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
 	if (ModeNo <= 0x13) {
 		xres = pVBInfo->StResInfo[resindex].HTotal;
 		yres = pVBInfo->StResInfo[resindex].VTotal;
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		/* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	} else {
 		xres = pVBInfo->ModeResInfo[resindex].HTotal; /* xres->ax */
 		yres = pVBInfo->ModeResInfo[resindex].VTotal; /* yres->bx */
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+St_ModeFlag */
+		/* si+St_ModeFlag */
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 	}
 
 	if (!(modeflag & Charx8Dot))
@@ -6713,7 +7016,8 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	if (LVDSVRS > LVDSVT)
 		LVDSVRS -= LVDSVT;
 
-	LVDSVRE = LVDSVRS + pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVSYNC;
+	LVDSVRE = LVDSVRS + pVBInfo->XG21_LVDSCapList[lvdstableindex].
+					LVDSVSYNC;
 	if (LVDSVRE > LVDSVT)
 		LVDSVRE -= LVDSVT;
 
@@ -6803,18 +7107,21 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x31, ~0x30, value);
 		xgifb_reg_set(pVBInfo->P3c4,
-				0x2B,
-				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData1);
+			      0x2B,
+			      pVBInfo->XG21_LVDSCapList[lvdstableindex].
+					VCLKData1);
 		xgifb_reg_set(pVBInfo->P3c4,
-				0x2C,
-				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData2);
+			      0x2C,
+			      pVBInfo->XG21_LVDSCapList[lvdstableindex].
+					VCLKData2);
 		value += 0x10;
 	}
 
 	if (!(modeflag & Charx8Dot)) {
 		inb(pVBInfo->P3da); /* reset 3da */
 		outb(0x13, pVBInfo->P3c0); /* set index */
-		outb(0x00, pVBInfo->P3c0); /* set data, panning = 0, shift left 1 dot*/
+		/* set data, panning = 0, shift left 1 dot*/
+		outb(0x00, pVBInfo->P3c0);
 
 		inb(pVBInfo->P3da); /* Enable Attribute */
 		outb(0x20, pVBInfo->P3c0);
@@ -6908,14 +7215,19 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 
 	/*
 	if (CH7017) {
-		if (!(pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2toLCDA)) || (XGI_DisableChISLCD(pVBInfo))) {
+		if (!(pVBInfo->VBInfo &
+		    (SetCRT2ToLCD | SetCRT2toLCDA)) ||
+		    (XGI_DisableChISLCD(pVBInfo))) {
 			if (!XGI_IsLCDON(pVBInfo)) {
 				if (DISCHARGE) {
 					tempbx = XGINew_GetCH7005(0x61);
-					if (tempbx < 0x01) // first time we power up
-						XGINew_SetCH7005(0x0066); // and disable power sequence
+					// first time we power up
+					if (tempbx < 0x01)
+						// and disable power sequence
+						XGINew_SetCH7005(0x0066);
 					else
-						XGINew_SetCH7005(0x5f66); // leave VDD on - disable power
+						// leave VDD on - disable power
+						XGINew_SetCH7005(0x5f66);
 				}
 			}
 		}
@@ -6925,29 +7237,35 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
 			| VB_XGI302LV | VB_XGI301C)) {
 		tempah = 0x3F;
-		if (!(pVBInfo->VBInfo & (DisableCRT2Display | SetSimuScanMode))) {
+		if (!(pVBInfo->VBInfo &
+		    (DisableCRT2Display | SetSimuScanMode))) {
 			if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
 				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
 					tempah = 0x7F; /* Disable Channel A */
 					if (!(pVBInfo->VBInfo & SetCRT2ToLCDA))
-						tempah = 0xBF; /* Disable Channel B */
+						/* Disable Channel B */
+						tempah = 0xBF;
 
 					if (pVBInfo->SetFlag & DisableChB)
-						tempah &= 0xBF; /* force to disable Cahnnel */
+						/* force to disable Cahnnel */
+						tempah &= 0xBF;
 
 					if (pVBInfo->SetFlag & DisableChA)
-						tempah &= 0x7F; /* Force to disable Channel B */
+						/* Force to disable Channel B */
+						tempah &= 0x7F;
 				}
 			}
 		}
 
-		xgifb_reg_and(pVBInfo->Part4Port, 0x1F, tempah); /* disable part4_1f */
+		/* disable part4_1f */
+		xgifb_reg_and(pVBInfo->Part4Port, 0x1F, tempah);
 
 		if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
 			if (((pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)))
 					|| (XGI_DisableChISLCD(pVBInfo))
 					|| (XGI_IsLCDON(pVBInfo)))
-				xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x80); /* LVDS Driver power down */
+				/* LVDS Driver power down */
+				xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x80);
 		}
 
 		if ((pVBInfo->SetFlag & DisableChA) || (pVBInfo->VBInfo
@@ -6961,38 +7279,48 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
 			if ((pVBInfo->SetFlag & DisableChA) || (pVBInfo->VBInfo
 					& SetCRT2ToLCDA))
-				xgifb_reg_and(pVBInfo->Part1Port, 0x1e, 0xdf); /* Power down */
+				/* Power down */
+				xgifb_reg_and(pVBInfo->Part1Port, 0x1e, 0xdf);
 		}
 
-		xgifb_reg_and(pVBInfo->P3c4, 0x32, 0xdf); /* disable TV as primary VGA swap */
+		/* disable TV as primary VGA swap */
+		xgifb_reg_and(pVBInfo->P3c4, 0x32, 0xdf);
 
 		if ((pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToDualEdge)))
 			xgifb_reg_and(pVBInfo->Part2Port, 0x00, 0xdf);
 
-		if ((pVBInfo->SetFlag & DisableChB) || (pVBInfo->VBInfo
-				& (DisableCRT2Display | SetSimuScanMode))
-				|| ((!(pVBInfo->VBInfo & SetCRT2ToLCDA))
-						&& (pVBInfo->VBInfo
-								& (SetCRT2ToRAMDAC
-										| SetCRT2ToLCD
-										| SetCRT2ToTV))))
-			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80); /* BScreenOff=1 */
-
-		if ((pVBInfo->SetFlag & DisableChB) || (pVBInfo->VBInfo
-				& (DisableCRT2Display | SetSimuScanMode))
-				|| (!(pVBInfo->VBInfo & SetCRT2ToLCDA))
-				|| (pVBInfo->VBInfo & (SetCRT2ToRAMDAC
-						| SetCRT2ToLCD | SetCRT2ToTV))) {
-			tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x00); /* save Part1 index 0 */
-			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x10); /* BTDAC = 1, avoid VB reset */
-			xgifb_reg_and(pVBInfo->Part1Port, 0x1E, 0xDF); /* disable CRT2 */
-			xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah); /* restore Part1 index 0 */
+		if ((pVBInfo->SetFlag & DisableChB) ||
+		    (pVBInfo->VBInfo &
+			(DisableCRT2Display | SetSimuScanMode)) ||
+		    ((!(pVBInfo->VBInfo & SetCRT2ToLCDA)) &&
+		    (pVBInfo->VBInfo &
+			(SetCRT2ToRAMDAC | SetCRT2ToLCD | SetCRT2ToTV))))
+			/* BScreenOff=1 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80);
+
+		if ((pVBInfo->SetFlag & DisableChB) ||
+		    (pVBInfo->VBInfo &
+			(DisableCRT2Display | SetSimuScanMode)) ||
+		    (!(pVBInfo->VBInfo & SetCRT2ToLCDA)) ||
+		    (pVBInfo->VBInfo &
+			(SetCRT2ToRAMDAC | SetCRT2ToLCD | SetCRT2ToTV))) {
+			/* save Part1 index 0 */
+			tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x00);
+			/* BTDAC = 1, avoid VB reset */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x10);
+			/* disable CRT2 */
+			xgifb_reg_and(pVBInfo->Part1Port, 0x1E, 0xDF);
+			/* restore Part1 index 0 */
+			xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah);
 		}
 	} else { /* {301} */
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToTV)) {
-			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80); /* BScreenOff=1 */
-			xgifb_reg_and(pVBInfo->Part1Port, 0x1E, 0xDF); /* Disable CRT2 */
-			xgifb_reg_and(pVBInfo->P3c4, 0x32, 0xDF); /* Disable TV asPrimary VGA swap */
+			/* BScreenOff=1 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80);
+			/* Disable CRT2 */
+			xgifb_reg_and(pVBInfo->Part1Port, 0x1E, 0xDF);
+			/* Disable TV asPrimary VGA swap */
+			xgifb_reg_and(pVBInfo->P3c4, 0x32, 0xDF);
 		}
 
 		if (pVBInfo->VBInfo & (DisableCRT2Display | SetCRT2ToLCDA
@@ -7116,12 +7444,19 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 			/*
 			if (pVBInfo->VBInfo & SetCRT2ToRAMDAC)
 				tempbl = CRT2Delay1;	// Get CRT2 Delay
-			if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV | VB_XGI302LV | VB_XGI301C))
+			if (pVBInfo->VBType &
+			    (VB_XGI301B |
+			     VB_XGI302B |
+			     VB_XGI301LV |
+			     VB_XGI302LV |
+			     VB_XGI301C))
 				tempbl = CRT2Delay2;
 			*/
 			if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-				index = XGI_GetLCDCapPtr(pVBInfo); /* Get LCD Delay */
-				tempbh = pVBInfo->LCDCapList[index].LCD_DelayCompensation;
+				/* Get LCD Delay */
+				index = XGI_GetLCDCapPtr(pVBInfo);
+				tempbh = pVBInfo->LCDCapList[index].
+						LCD_DelayCompensation;
 
 				if (!(pVBInfo->VBInfo & SetCRT2ToLCDA))
 					tempbl = tempbh;
@@ -7147,9 +7482,10 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 		tempbl = 0;
 		tempbh = 0;
 		if (pVBInfo->VBInfo & SetCRT2ToLCD) {
-			tempah
-					= pVBInfo->LCDCapList[XGI_GetLCDCapPtr(
-							pVBInfo)].LCD_DelayCompensation; /* / Get LCD Delay */
+			/* / Get LCD Delay */
+			tempah = pVBInfo->LCDCapList[
+					XGI_GetLCDCapPtr(pVBInfo)].
+						LCD_DelayCompensation;
 			tempah &= 0x0f;
 			tempah = tempah << 4;
 			xgifb_reg_and_or(pVBInfo->Part1Port, 0x2D, 0x0f,
@@ -7158,7 +7494,8 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 	}
 }
 
-static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo)
+static void XGI_SetLCDCap_A(unsigned short tempcx,
+			    struct vb_device_info *pVBInfo)
 {
 	unsigned short temp;
 
@@ -7166,7 +7503,8 @@ static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInf
 
 	if (temp & LCDRGB18Bit) {
 		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F,
-				(unsigned short) (0x20 | (tempcx & 0x00C0))); /* Enable Dither */
+				/* Enable Dither */
+				(unsigned short) (0x20 | (tempcx & 0x00C0)));
 		xgifb_reg_and_or(pVBInfo->Part1Port, 0x1A, 0x7F, 0x80);
 	} else {
 		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F,
@@ -7176,10 +7514,17 @@ static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInf
 
 	/*
 	if (tempcx & EnableLCD24bpp) {	// 24bits
-		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F, (unsigned short)(0x30 | (tempcx&0x00C0)));
+		xgifb_reg_and_or(pVBInfo->Part1Port,
+				 0x19,
+				 0x0F,
+				 (unsigned short)(0x30 | (tempcx&0x00C0)));
 		xgifb_reg_and_or(pVBInfo->Part1Port, 0x1A, 0x7F, 0x00);
 	} else {
-		xgifb_reg_and_or(pVBInfo->Part1Port, 0x19, 0x0F, (unsigned short)(0x20 | (tempcx&0x00C0))); // Enable Dither
+		xgifb_reg_and_or(pVBInfo->Part1Port,
+				 0x19,
+				 0x0F,
+				 // Enable Dither
+				 (unsigned short)(0x20 | (tempcx&0x00C0)));
 		xgifb_reg_and_or(pVBInfo->Part1Port, 0x1A, 0x7F, 0x80);
 	}
 	*/
@@ -7191,7 +7536,8 @@ static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInf
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-static void XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo)
+static void XGI_SetLCDCap_B(unsigned short tempcx,
+			    struct vb_device_info *pVBInfo)
 {
 	if (tempcx & EnableLCD24bpp) /* 24bits */
 		xgifb_reg_and_or(pVBInfo->Part2Port, 0x1A, 0xE0,
@@ -7209,7 +7555,8 @@ static void SetSpectrum(struct vb_device_info *pVBInfo)
 
 	index = XGI_GetLCDCapPtr(pVBInfo);
 
-	xgifb_reg_and(pVBInfo->Part4Port, 0x30, 0x8F); /* disable down spectrum D[4] */
+	/* disable down spectrum D[4] */
+	xgifb_reg_and(pVBInfo->Part4Port, 0x30, 0x8F);
 	XGI_LongWait(pVBInfo);
 	xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x20); /* reset spectrum */
 	XGI_LongWait(pVBInfo);
@@ -7232,9 +7579,14 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 
 	tempcx = pVBInfo->LCDCapList[XGI_GetLCDCapPtr(pVBInfo)].LCD_Capability;
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
-		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) { /* 301LV/302LV only */
+	if (pVBInfo->VBType &
+	    (VB_XGI301B |
+	     VB_XGI302B |
+	     VB_XGI301LV |
+	     VB_XGI302LV |
+	     VB_XGI301C)) { /* 301LV/302LV only */
+		if (pVBInfo->VBType &
+		    (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
 			/* Set 301LV Capability */
 			xgifb_reg_set(pVBInfo->Part4Port, 0x24,
 					(unsigned char) (tempcx & 0x1F));
@@ -7269,8 +7621,9 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 /* Output : */
 /* Description : Set TV Customized Param. */
 /* --------------------------------------------------------------------- */
-static void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetAntiFlicker(unsigned short ModeNo,
+			       unsigned short ModeIdIndex,
+			       struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, index;
 
@@ -7294,8 +7647,9 @@ static void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0A, 0x8F, tempah);
 }
 
-static void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_SetEdgeEnhance(unsigned short ModeNo,
+			       unsigned short ModeIdIndex,
+			       struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, index;
 
@@ -7388,10 +7742,11 @@ static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	if (ModeNo <= 0x13)
-		tempal = pVBInfo->SModeIDTable[ModeIdIndex].VB_StTVYFilterIndex;
+		tempal = pVBInfo->SModeIDTable[ModeIdIndex].
+				VB_StTVYFilterIndex;
 	else
-		tempal
-				= pVBInfo->EModeIDTable[ModeIdIndex].VB_ExtTVYFilterIndex;
+		tempal = pVBInfo->EModeIDTable[ModeIdIndex].
+				VB_ExtTVYFilterIndex;
 
 	if (tempcl == 0)
 		index = tempal * 4;
@@ -7424,8 +7779,9 @@ static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
 /* Output : */
 /* Description : Customized Param. for 301 */
 /* --------------------------------------------------------------------- */
-static void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_OEM310Setting(unsigned short ModeNo,
+			      unsigned short ModeIdIndex,
+			      struct vb_device_info *pVBInfo)
 {
 	if (pVBInfo->SetFlag & Win9xDOSMode)
 		return;
@@ -7462,7 +7818,8 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 
 	unsigned char tempah;
 
-	/* xgifb_reg_set(pVBInfo->Part1Port, 0x03, 0x00); // fix write part1 index 0 BTDRAM bit Bug */
+	/* // fix write part1 index 0 BTDRAM bit Bug
+	 * xgifb_reg_set(pVBInfo->Part1Port, 0x03, 0x00); */
 	tempah = 0;
 	if (!(pVBInfo->VBInfo & DisableCRT2Display)) {
 		tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x00);
@@ -7476,7 +7833,8 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 				tempcl = pVBInfo->ModeType;
 				tempcl -= ModeVGA;
 				if (tempcl >= 0) {
-					tempah = (0x008 >> tempcl); /* BT Color */
+					/* BT Color */
+					tempah = (0x008 >> tempcl);
 					if (tempah == 0)
 						tempah = 1;
 					tempah |= 0x040;
@@ -7525,8 +7883,8 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 
 		if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV
 				| SetCRT2ToLCD | SetCRT2ToLCDA)) {
-			if ((pVBInfo->VBInfo & SetCRT2ToLCDA)
-					&& (!(pVBInfo->VBInfo & SetSimuScanMode))) {
+			if ((pVBInfo->VBInfo & SetCRT2ToLCDA) &&
+			    (!(pVBInfo->VBInfo & SetSimuScanMode))) {
 				tempbl &= 0xf7;
 				tempah |= 0x01;
 				xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e,
@@ -7537,23 +7895,26 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 					tempah |= 0x01;
 				}
 
-				if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC
-						| SetCRT2ToTV | SetCRT2ToLCD)) {
+				if (pVBInfo->VBInfo &
+				    (SetCRT2ToRAMDAC |
+				     SetCRT2ToTV |
+				     SetCRT2ToLCD)) {
 					tempbl &= 0xf8;
 					tempah = 0x01;
 
 					if (!(pVBInfo->VBInfo & SetInSlaveMode))
 						tempah |= 0x02;
 
-					if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
+					if (!(pVBInfo->VBInfo &
+					      SetCRT2ToRAMDAC)) {
 						tempah = tempah ^ 0x05;
-						if (!(pVBInfo->VBInfo
-								& SetCRT2ToLCD))
+						if (!(pVBInfo->VBInfo &
+						      SetCRT2ToLCD))
 							tempah = tempah ^ 0x01;
 					}
 
-					if (!(pVBInfo->VBInfo
-							& SetCRT2ToDualEdge))
+					if (!(pVBInfo->VBInfo &
+					      SetCRT2ToDualEdge))
 						tempah |= 0x08;
 					xgifb_reg_and_or(pVBInfo->Part1Port,
 							0x2e, tempbl, tempah);
@@ -7578,7 +7939,8 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 		tempah |= 0x080;
 
 		if (pVBInfo->VBInfo & SetCRT2ToTV) {
-			/* if (!(pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p))) { */
+			/* if (!(pVBInfo->TVInfo &
+				 (SetYPbPrMode525p | SetYPbPrMode750p))) { */
 			tempah |= 0x020;
 			if (ModeNo > 0x13) {
 				if (pVBInfo->VBInfo & DriverMode)
@@ -7594,7 +7956,9 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 			tempah |= 0x40;
 
 		if (pVBInfo->VBInfo & SetCRT2ToTV) {
-			/* if ((!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)) && (!(pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p)))) { */
+			/* if ((!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)) &&
+			       (!(pVBInfo->TVInfo &
+				  (SetYPbPrMode525p | SetYPbPrMode750p)))) { */
 			if (pVBInfo->TVInfo & RPLLDIV2XO)
 				tempah |= 0x40;
 			/* } */
@@ -7805,13 +8169,12 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 				if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
 						| VB_XGI301LV | VB_XGI302LV
 						| VB_XGI301C))
-					temp
-							= LCDARefreshIndex[pVBInfo->LCDResInfo
-									& 0x0F]; /* 301b */
+					/* 301b */
+					temp = LCDARefreshIndex[
+						pVBInfo->LCDResInfo & 0x0F];
 				else
-					temp
-							= LCDRefreshIndex[pVBInfo->LCDResInfo
-									& 0x0F];
+					temp = LCDRefreshIndex[
+						pVBInfo->LCDResInfo & 0x0F];
 
 				if (index > temp)
 					index = temp;
@@ -7825,35 +8188,34 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 	ModeNo = pVBInfo->RefIndex[RefreshRateTableIndex].ModeID;
 	if (pXGIHWDE->jChipType >= XG20) { /* for XG20, XG21, XG27 */
 		/*
-		if (pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag & XG2xNotSupport) {
+		if (pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag &
+		    XG2xNotSupport) {
 			index++;
 		}
 		*/
-		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 800)
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
-						== 600)) {
+		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 800) &&
+		    (pVBInfo->RefIndex[RefreshRateTableIndex].YRes == 600)) {
 			index++;
 		}
-		/* Alan 10/19/2007; do the similar adjustment like XGISearchCRT1Rate() */
-		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1024)
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
-						== 768)) {
+		/* Alan 10/19/2007;
+		 * do the similar adjustment like XGISearchCRT1Rate() */
+		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1024) &&
+		    (pVBInfo->RefIndex[RefreshRateTableIndex].YRes == 768)) {
 			index++;
 		}
-		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1280)
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
-						== 1024)) {
+		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1280) &&
+		    (pVBInfo->RefIndex[RefreshRateTableIndex].YRes == 1024)) {
 			index++;
 		}
 	}
 
 	i = 0;
 	do {
-		if (pVBInfo->RefIndex[RefreshRateTableIndex + i].ModeID
-				!= ModeNo)
+		if (pVBInfo->RefIndex[RefreshRateTableIndex + i].
+			ModeID != ModeNo)
 			break;
-		temp
-				= pVBInfo->RefIndex[RefreshRateTableIndex + i].Ext_InfoFlag;
+		temp = pVBInfo->RefIndex[RefreshRateTableIndex + i].
+			Ext_InfoFlag;
 		temp &= ModeInfoFlag;
 		if (temp < pVBInfo->ModeType)
 			break;
@@ -7863,9 +8225,8 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 	} while (index != 0xFFFF);
 	if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
 		if (pVBInfo->VBInfo & SetInSlaveMode) {
-			temp
-					= pVBInfo->RefIndex[RefreshRateTableIndex
-							+ i - 1].Ext_InfoFlag;
+			temp = pVBInfo->RefIndex[RefreshRateTableIndex + i - 1].
+				Ext_InfoFlag;
 			if (temp & InterlaceMode)
 				i++;
 		}
@@ -8055,11 +8416,14 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			| VB_XGI302LV | VB_XGI301C)) {
 		if (!(pVBInfo->SetFlag & DisableChA)) {
 			if (pVBInfo->SetFlag & EnableChA) {
-				xgifb_reg_set(pVBInfo->Part1Port, 0x1E, 0x20); /* Power on */
+				/* Power on */
+				xgifb_reg_set(pVBInfo->Part1Port, 0x1E, 0x20);
 			} else {
-				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) { /* SetCRT2ToLCDA ) */
+				/* SetCRT2ToLCDA ) */
+				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
+					/* Power on */
 					xgifb_reg_set(pVBInfo->Part1Port,
-							0x1E, 0x20); /* Power on */
+							0x1E, 0x20);
 				}
 			}
 		}
@@ -8072,7 +8436,8 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 						pVBInfo->P3c4, 0x32);
 				tempah &= 0xDF;
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
-					if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC))
+					if (!(pVBInfo->VBInfo &
+					      SetCRT2ToRAMDAC))
 						tempah |= 0x20;
 				}
 				xgifb_reg_set(pVBInfo->P3c4, 0x32, tempah);
@@ -8082,10 +8447,11 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 						pVBInfo->Part1Port, 0x2E);
 
 				if (!(tempah & 0x80))
+					/* BVBDOENABLE = 1 */
 					xgifb_reg_or(pVBInfo->Part1Port,
-							0x2E, 0x80); /* BVBDOENABLE = 1 */
-
-				xgifb_reg_and(pVBInfo->Part1Port, 0x00, 0x7F); /* BScreenOFF = 0 */
+							0x2E, 0x80);
+				/* BScreenOFF = 0 */
+				xgifb_reg_and(pVBInfo->Part1Port, 0x00, 0x7F);
 			}
 		}
 
@@ -8095,15 +8461,17 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 					0x20); /* shampoo 0129 */
 			if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
 				if (!XGI_DisableChISLCD(pVBInfo)) {
-					if (XGI_EnableChISLCD(pVBInfo)
-							|| (pVBInfo->VBInfo
-									& (SetCRT2ToLCD
-											| SetCRT2ToLCDA)))
+					if (XGI_EnableChISLCD(pVBInfo) ||
+					    (pVBInfo->VBInfo &
+					    (SetCRT2ToLCD | SetCRT2ToLCDA)))
+						/* LVDS PLL power on */
 						xgifb_reg_and(
-								pVBInfo->Part4Port,
-								0x2A, 0x7F); /* LVDS PLL power on */
+							pVBInfo->Part4Port,
+							0x2A,
+							0x7F);
 				}
-				xgifb_reg_and(pVBInfo->Part4Port, 0x30, 0x7F); /* LVDS Driver power on */
+				/* LVDS Driver power on */
+				xgifb_reg_and(pVBInfo->Part4Port, 0x30, 0x7F);
 			}
 		}
 
@@ -8114,33 +8482,35 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 
 			if (!(pVBInfo->VBInfo & SetSimuScanMode)) {
 				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
-					if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
+					if (pVBInfo->VBInfo &
+					    SetCRT2ToDualEdge) {
 						tempah = tempah & 0x40;
-						if (pVBInfo->VBInfo
-								& SetCRT2ToLCDA)
+						if (pVBInfo->VBInfo &
+						    SetCRT2ToLCDA)
 							tempah = tempah ^ 0xC0;
 
-						if (pVBInfo->SetFlag
-								& DisableChB)
+						if (pVBInfo->SetFlag &
+						    DisableChB)
 							tempah &= 0xBF;
 
-						if (pVBInfo->SetFlag
-								& DisableChA)
+						if (pVBInfo->SetFlag &
+						    DisableChA)
 							tempah &= 0x7F;
 
-						if (pVBInfo->SetFlag
-								& EnableChB)
+						if (pVBInfo->SetFlag &
+						    EnableChB)
 							tempah |= 0x40;
 
-						if (pVBInfo->SetFlag
-								& EnableChA)
+						if (pVBInfo->SetFlag &
+						    EnableChA)
 							tempah |= 0x80;
 					}
 				}
 			}
 		}
 
-		xgifb_reg_or(pVBInfo->Part4Port, 0x1F, tempah); /* EnablePart4_1F */
+		/* EnablePart4_1F */
+		xgifb_reg_or(pVBInfo->Part4Port, 0x1F, tempah);
 
 		if (pVBInfo->SetFlag & Win9xDOSMode) {
 			XGI_DisplayOn(HwDeviceExtension, pVBInfo);
@@ -8150,7 +8520,8 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		if (!(pVBInfo->SetFlag & DisableChA)) {
 			XGI_VBLongWait(pVBInfo);
 			if (!(pVBInfo->SetFlag & GatingCRT)) {
-				XGI_DisableGatingCRT(HwDeviceExtension, pVBInfo);
+				XGI_DisableGatingCRT(HwDeviceExtension,
+						     pVBInfo);
 				XGI_DisplayOn(HwDeviceExtension, pVBInfo);
 				XGI_VBLongWait(pVBInfo);
 			}
@@ -8159,12 +8530,14 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 	else { /* LVDS */
 		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD
 				| SetCRT2ToLCDA))
-			xgifb_reg_or(pVBInfo->Part1Port, 0x1E, 0x20); /* enable CRT2 */
+			/* enable CRT2 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x1E, 0x20);
 
 		tempah = (unsigned char) xgifb_reg_get(pVBInfo->Part1Port,
 				0x2E);
 		if (!(tempah & 0x80))
-			xgifb_reg_or(pVBInfo->Part1Port, 0x2E, 0x80); /* BVBDOENABLE = 1 */
+			/* BVBDOENABLE = 1 */
+			xgifb_reg_or(pVBInfo->Part1Port, 0x2E, 0x80);
 
 		xgifb_reg_and(pVBInfo->Part1Port, 0x00, 0x7F);
 		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
@@ -8222,8 +8595,8 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 				RefreshRateTableIndex, pVBInfo);
 	}
 
-	if ((HwDeviceExtension->jChipType >= XG20)
-			&& (HwDeviceExtension->jChipType < XG27)) { /* fix H/W DCLK/2 bug */
+	if ((HwDeviceExtension->jChipType >= XG20) &&
+	    (HwDeviceExtension->jChipType < XG27)) { /* fix H/W DCLK/2 bug */
 		if ((ModeNo == 0x00) | (ModeNo == 0x01)) {
 			xgifb_reg_set(pVBInfo->P3c4, 0x2B, 0x4E);
 			xgifb_reg_set(pVBInfo->P3c4, 0x2C, 0xE9);
@@ -8242,8 +8615,10 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 		temp = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 		if (temp & 0xA0) {
 
-			/* xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20); *//* Enable write GPIOF */
-			/* xgifb_reg_and(pVBInfo->P3d4, 0x48, ~0x20); *//* P. DWN */
+			/* Enable write GPIOF */
+			/* xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20); */
+			/* P. DWN */
+			/* xgifb_reg_and(pVBInfo->P3d4, 0x48, ~0x20); */
 			/* XG21 CRT1 Timing */
 			if (HwDeviceExtension->jChipType == XG27)
 				XGI_SetXG27CRTC(ModeNo, ModeIdIndex,
@@ -8270,7 +8645,8 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 					XGI_SetXG21LVDSPara(ModeNo,
 							ModeIdIndex, pVBInfo);
 			}
-			/* xgifb_reg_or(pVBInfo->P3d4, 0x48, 0x20); *//* P. ON */
+			/* P. ON */
+			/* xgifb_reg_or(pVBInfo->P3d4, 0x48, 0x20); */
 		}
 	}
 
@@ -8289,7 +8665,8 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 			unsigned short ModeNo)
 {
 	unsigned short ModeIdIndex;
-	/* unsigned char *pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress; */
+	/* unsigned char *pVBInfo->FBAddr =
+				HwDeviceExtension->pjVideoMemoryAddress; */
 	struct vb_device_info VBINF;
 	struct vb_device_info *pVBInfo = &VBINF;
 	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
@@ -8334,7 +8711,8 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
 	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
 
-	if (HwDeviceExtension->jChipType == XG21) { /* for x86 Linux, XG21 LVDS */
+	/* for x86 Linux, XG21 LVDS */
+	if (HwDeviceExtension->jChipType == XG21) {
 		if ((xgifb_reg_get(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0)
 			pVBInfo->IF_DEF_LVDS = 1;
 	}
@@ -8417,17 +8795,17 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 	} /* !XG20 */
 	else {
 		if (pVBInfo->IF_DEF_LVDS == 1)
-			if (!XGI_XG21CheckLVDSMode(ModeNo, ModeIdIndex, pVBInfo))
+			if (!XGI_XG21CheckLVDSMode(ModeNo,
+						   ModeIdIndex,
+						   pVBInfo))
 				return 0;
 
 		if (ModeNo <= 0x13) {
-			pVBInfo->ModeType
-					= pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag
-							& ModeInfoFlag;
+			pVBInfo->ModeType = pVBInfo->SModeIDTable[ModeIdIndex].
+						St_ModeFlag & ModeInfoFlag;
 		} else {
-			pVBInfo->ModeType
-					= pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag
-							& ModeInfoFlag;
+			pVBInfo->ModeType = pVBInfo->EModeIDTable[ModeIdIndex].
+						Ext_ModeFlag & ModeInfoFlag;
 		}
 
 		pVBInfo->SetFlag = 0;
@@ -8455,7 +8833,10 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 	pVBInfo->ModeType = modeflag&ModeInfoFlag;
 	pVBInfo->SetFlag = 0x00;
 	pVBInfo->VBInfo = DisableCRT2Display;
-	temp = XGINew_CheckMemorySize(HwDeviceExtension, ModeNo, ModeIdIndex, pVBInfo);
+	temp = XGINew_CheckMemorySize(HwDeviceExtension,
+				      ModeNo,
+				      ModeIdIndex,
+				      pVBInfo);
 
 	if (temp == 0)
 		return (0);
-- 
1.7.1

