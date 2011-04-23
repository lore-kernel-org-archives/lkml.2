Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1DWA2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:28:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65411 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab1DWA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QO9jXkWJsVji+hkg0P8caYV3I7XWhZByx+jnR/yhvlvncZ4evAUG9uMP7lX9KCFHzc
         htjt5DrNWPDuuxWNPmXVMvR8ZiV9+1XjompvgHBhvvIo9axio4zRJJen+JH+lxfeUY3x
         iXKblmkgIVMFNPDwNrs8ustjExeZS4zdYDK5g=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, aaro.koskinen@iki.fi,
        apatard@mandriva.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 2/2] Staging: xgifb: Fixed coding style issues.
Date: Sat, 23 Apr 2011 08:27:48 +0800
Message-Id: <1303518468-29356-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all warnings were silenced. One of them is a typedef in vb_ext.h
which I think seems alright.
The other warnings in vb_ext.c I left there because that would involve
changing a bit of the logic in the code. IMHO though I think the
functions are too complicated (i.e. the if/else are too deep within a
big function.) and can probably be split.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/vb_ext.c |  138 ++++++++++++++++++++++++++++------------
 drivers/staging/xgifb/vb_ext.h |   25 ++++----
 2 files changed, 110 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index d7c1b2e..7e1f76a 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -1,5 +1,5 @@
 #include <linux/version.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/types.h>
 #include "XGIfb.h"
 
@@ -26,7 +26,9 @@ static unsigned char XGINew_Is301B(struct vb_device_info *pVBInfo)
 		return 1;
 }
 
-static unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx, struct vb_device_info *pVBInfo)
+static unsigned char XGINew_Sense(unsigned short tempbx,
+				  unsigned short tempcx,
+				  struct vb_device_info *pVBInfo)
 {
 	unsigned short temp, i, tempch;
 
@@ -50,7 +52,9 @@ static unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx,
 		return 0;
 }
 
-static unsigned char XGINew_GetLCDDDCInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+static unsigned char
+XGINew_GetLCDDDCInfo(struct xgi_hw_device_info *HwDeviceExtension,
+		     struct vb_device_info *pVBInfo)
 {
 	unsigned short temp;
 
@@ -154,7 +158,9 @@ static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 	}
 }
 
-static unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+static unsigned char
+XGINew_BridgeIsEnable(struct xgi_hw_device_info *HwDeviceExtension,
+		      struct vb_device_info *pVBInfo)
 {
 	unsigned short flag;
 
@@ -170,7 +176,9 @@ static unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *HwDeviceEx
 	return 0;
 }
 
-static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+static unsigned char
+XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension,
+		 struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, tempcx, temp, i, tempch;
 
@@ -238,21 +246,29 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 	}
 }
 
-void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
+			struct vb_device_info *pVBInfo)
 {
-	unsigned short tempax = 0, tempbx, tempcx, temp, P2reg0 = 0, SenseModeNo = 0,
-			OutputSelect = *pVBInfo->pOutputSelect, ModeIdIndex, i;
+	unsigned short  tempax = 0, tempbx, tempcx, temp,
+			P2reg0 = 0, SenseModeNo = 0,
+			OutputSelect = *pVBInfo->pOutputSelect,
+			ModeIdIndex, i;
 	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
 
 	if (pVBInfo->IF_DEF_LVDS == 1) {
-		tempax = xgifb_reg_get(pVBInfo->P3c4, 0x1A); /* ynlai 02/27/2002 */
+		/* ynlai 02/27/2002 */
+		tempax = xgifb_reg_get(pVBInfo->P3c4, 0x1A);
 		tempbx = xgifb_reg_get(pVBInfo->P3c4, 0x1B);
 		tempax = ((tempax & 0xFE) >> 1) | (tempbx << 8);
 		if (tempax == 0x00) { /* Get Panel id from DDC */
 			temp = XGINew_GetLCDDDCInfo(HwDeviceExtension, pVBInfo);
 			if (temp == 1) { /* LCD connect */
-				xgifb_reg_and_or(pVBInfo->P3d4, 0x39, 0xFF, 0x01); /* set CR39 bit0="1" */
-				xgifb_reg_and_or(pVBInfo->P3d4, 0x37, 0xEF, 0x00); /* clean CR37 bit4="0" */
+				/* set CR39 bit0="1" */
+				xgifb_reg_and_or(pVBInfo->P3d4,
+						 0x39, 0xFF, 0x01);
+				/* clean CR37 bit4="0" */
+				xgifb_reg_and_or(pVBInfo->P3d4,
+						 0x37, 0xEF, 0x00);
 				temp = LCDSense;
 			} else { /* LCD don't connect */
 				temp = 0;
@@ -273,25 +289,47 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 			xgifb_reg_and_or(pVBInfo->P3d4, 0x32, 0xA0, temp);
 		} else {
 			if (XGI_BridgeIsOn(pVBInfo)) {
-				P2reg0 = xgifb_reg_get(pVBInfo->Part2Port, 0x00);
-				if (!XGINew_BridgeIsEnable(HwDeviceExtension, pVBInfo)) {
+				P2reg0 = xgifb_reg_get(pVBInfo->Part2Port,
+						       0x00);
+				if (!XGINew_BridgeIsEnable(HwDeviceExtension,
+							   pVBInfo)) {
 					SenseModeNo = 0x2e;
-					/* xgifb_reg_set(pVBInfo->P3d4, 0x30, 0x41); */
-					/* XGISetModeNew(HwDeviceExtension, 0x2e); // ynlai InitMode */
-
-					temp = XGI_SearchModeID(SenseModeNo, &ModeIdIndex, pVBInfo);
-					XGI_GetVGAType(HwDeviceExtension, pVBInfo);
+				/* xgifb_reg_set(pVBInfo->P3d4, 0x30, 0x41);
+				 * XGISetModeNew(HwDeviceExtension, 0x2e);
+				 * // ynlai InitMode */
+
+					temp = XGI_SearchModeID(SenseModeNo,
+								&ModeIdIndex,
+								pVBInfo);
+					XGI_GetVGAType(HwDeviceExtension,
+						       pVBInfo);
 					XGI_GetVBType(pVBInfo);
 					pVBInfo->SetFlag = 0x00;
 					pVBInfo->ModeType = ModeVGA;
-					pVBInfo->VBInfo = SetCRT2ToRAMDAC | LoadDACFlag | SetInSlaveMode;
-					XGI_GetLCDInfo(0x2e, ModeIdIndex, pVBInfo);
-					XGI_GetTVInfo(0x2e, ModeIdIndex, pVBInfo);
-					XGI_EnableBridge(HwDeviceExtension, pVBInfo);
-					XGI_SetCRT2Group301(SenseModeNo, HwDeviceExtension, pVBInfo);
-					XGI_SetCRT2ModeRegs(0x2e, HwDeviceExtension, pVBInfo);
-					/* XGI_DisableBridge( HwDeviceExtension, pVBInfo ) ; */
-					xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xDF, 0x20); /* Display Off 0212 */
+					pVBInfo->VBInfo = SetCRT2ToRAMDAC |
+							  LoadDACFlag |
+							  SetInSlaveMode;
+					XGI_GetLCDInfo(0x2e,
+						       ModeIdIndex,
+						       pVBInfo);
+					XGI_GetTVInfo(0x2e,
+						      ModeIdIndex,
+						      pVBInfo);
+					XGI_EnableBridge(HwDeviceExtension,
+							 pVBInfo);
+					XGI_SetCRT2Group301(SenseModeNo,
+							    HwDeviceExtension,
+							    pVBInfo);
+					XGI_SetCRT2ModeRegs(0x2e,
+							    HwDeviceExtension,
+							    pVBInfo);
+					/* XGI_DisableBridge(HwDeviceExtension,
+					 *		     pVBInfo ) ; */
+					/* Display Off 0212 */
+					xgifb_reg_and_or(pVBInfo->P3c4,
+							 0x01,
+							 0xDF,
+							 0x20);
 					for (i = 0; i < 20; i++)
 						XGI_LongWait(pVBInfo);
 				}
@@ -304,29 +342,38 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 
 				tempcx = 0x0E08;
 				if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
-					if (XGINew_Sense(tempbx, tempcx, pVBInfo))
+					if (XGINew_Sense(tempbx,
+							 tempcx,
+							 pVBInfo))
 						tempax |= Monitor2Sense;
 				}
 
 				if (pVBInfo->VBType & VB_XGI301C)
-					xgifb_reg_or(pVBInfo->Part4Port, 0x0d, 0x04);
+					xgifb_reg_or(pVBInfo->Part4Port,
+						     0x0d,
+						     0x04);
 
-				if (XGINew_SenseHiTV(HwDeviceExtension, pVBInfo)) { /* add by kuku for Multi-adapter sense HiTV */
+				/* add by kuku for Multi-adapter sense HiTV */
+				if (XGINew_SenseHiTV(HwDeviceExtension,
+						     pVBInfo)) {
 					tempax |= HiTVSense;
 					if ((pVBInfo->VBType & VB_XGI301C))
-						tempax ^= (HiTVSense | YPbPrSense);
+						tempax ^= (HiTVSense |
+							   YPbPrSense);
 				}
 
-				if (!(tempax & (HiTVSense | YPbPrSense))) { /* start */
-
+				/* start */
+				if (!(tempax & (HiTVSense | YPbPrSense))) {
 					tempbx = *pVBInfo->pYCSenseData;
-
 					if (!(XGINew_Is301B(pVBInfo)))
 						tempbx = *pVBInfo->pYCSenseData2;
-
 					tempcx = 0x0604;
-					if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
-						if (XGINew_Sense(tempbx, tempcx, pVBInfo))
+					if (XGINew_Sense(tempbx,
+							 tempcx,
+							 pVBInfo)) {
+						if (XGINew_Sense(tempbx,
+								 tempcx,
+								 pVBInfo))
 							tempax |= SVIDEOSense;
 					}
 
@@ -337,8 +384,12 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 							tempbx = *pVBInfo->pVideoSenseData2;
 
 						tempcx = 0x0804;
-						if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
-							if (XGINew_Sense(tempbx, tempcx, pVBInfo))
+						if (XGINew_Sense(tempbx,
+								 tempcx,
+								 pVBInfo)) {
+							if (XGINew_Sense(tempbx,
+									 tempcx,
+									 pVBInfo))
 								tempax |= AVIDEOSense;
 						}
 					} else {
@@ -349,7 +400,9 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 								tempbx = *pVBInfo->pVideoSenseData2;
 
 							tempcx = 0x0804;
-							if (XGINew_Sense(tempbx, tempcx, pVBInfo)) {
+							if (XGINew_Sense(tempbx,
+									 tempcx,
+									 pVBInfo)) {
 								if (XGINew_Sense(tempbx, tempcx, pVBInfo))
 									tempax |= AVIDEOSense;
 							}
@@ -370,7 +423,9 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 
 			if (!(P2reg0 & 0x20)) {
 				pVBInfo->VBInfo = DisableCRT2Display;
-				/* XGI_SetCRT2Group301(SenseModeNo, HwDeviceExtension, pVBInfo); */
+				/* XGI_SetCRT2Group301(SenseModeNo,
+				 *		       HwDeviceExtension,
+				 *		       pVBInfo); */
 			}
 		}
 	}
@@ -378,7 +433,8 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 
 }
 
-unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *HwDeviceExtension,
+			       struct vb_device_info *pVBInfo)
 {
 	/* unsigned short SoftSetting ; */
 	unsigned short temp;
diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
index cabe365..814a446 100644
--- a/drivers/staging/xgifb/vb_ext.h
+++ b/drivers/staging/xgifb/vb_ext.h
@@ -1,27 +1,28 @@
-#ifndef  _VBEXT_
-#define  _VBEXT_
+#ifndef _VBEXT_
+#define _VBEXT_
 
 struct DWORDREGS {
-    unsigned long    Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
+	unsigned long Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
 };
 
 struct WORDREGS {
-    unsigned short ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si,
-	    hi_si, di, hi_di, bp, hi_bp;
+	unsigned short  ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si,
+			hi_si, di, hi_di, bp, hi_bp;
 };
 
 struct BYTEREGS {
-     unsigned char al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch,
-	     hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
+	unsigned char   al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch,
+			hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
 };
 
-typedef union   _X86_REGS    {
-    struct  DWORDREGS e;
-    struct  WORDREGS x;
-    struct  BYTEREGS h;
+typedef union _X86_REGS {
+	struct  DWORDREGS e;
+	struct  WORDREGS x;
+	struct  BYTEREGS h;
 } X86_REGS, *PX86_REGS;
 
-extern   void     XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
+extern void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
+			       struct vb_device_info *pVBInfo);
 extern unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *,
 				      struct vb_device_info *pVBInfo);
 
-- 
1.7.1

