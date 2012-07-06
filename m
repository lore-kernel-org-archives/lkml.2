Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab2GFKnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:43:35 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29884 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933185Ab2GFKl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130700"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 13/19 v2] Staging: xgifb: Rework conditions in XGI_GetVBInfo().
Date: Fri,  6 Jul 2012 12:40:48 +0200
Message-Id: <6cef5c340ef8b496c52e900923a75d67bccbb8d6.1341569486.git.magomez@igalia.com>
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

Rework some conditions to reduce indentation and fix style warnings.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_setmode.c |  287 ++++++++++++++++++------------------
 1 file changed, 142 insertions(+), 145 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 251145e..9dfc2de 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2611,186 +2611,183 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	pVBInfo->ModeType = modeflag & ModeTypeMask;
 	tempbx = 0;
 
-	if (pVBInfo->VBType & 0xFFFF) {
-		/* Check Display Device */
-		temp = xgifb_reg_get(pVBInfo->P3d4, 0x30);
-		tempbx = tempbx | temp;
-		temp = xgifb_reg_get(pVBInfo->P3d4, 0x31);
-		push = temp;
-		push = push << 8;
-		tempax = temp << 8;
-		tempbx = tempbx | tempax;
-		temp = (SetCRT2ToDualEdge | SetCRT2ToYPbPr525750 | XGI_SetCRT2ToLCDA
-				| SetInSlaveMode | DisableCRT2Display);
-		temp = 0xFFFF ^ temp;
-		tempbx &= temp;
-
-		temp = xgifb_reg_get(pVBInfo->P3d4, 0x38);
+	if (!(pVBInfo->VBType & 0xFFFF))
+		return;
 
-		if (pVBInfo->IF_DEF_LCDA == 1) {
-
-			if ((HwDeviceExtension->jChipType >= XG20) ||
-			    (HwDeviceExtension->jChipType >= XG40)) {
-				if (pVBInfo->IF_DEF_LVDS == 0) {
-					if (pVBInfo->VBType &
-					    (VB_SIS302B |
-					     VB_SIS301LV |
-					     VB_SIS302LV |
-					     VB_XGI301C)) {
-						if (temp & EnableDualEdge) {
-							tempbx |=
-							    SetCRT2ToDualEdge;
-
-							if (temp & SetToLCDA)
-								tempbx |=
-								  XGI_SetCRT2ToLCDA;
-						}
-					}
+	/* Check Display Device */
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x30);
+	tempbx = tempbx | temp;
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x31);
+	push = temp;
+	push = push << 8;
+	tempax = temp << 8;
+	tempbx = tempbx | tempax;
+	temp = (SetCRT2ToDualEdge | SetCRT2ToYPbPr525750 | XGI_SetCRT2ToLCDA
+		| SetInSlaveMode | DisableCRT2Display);
+	temp = 0xFFFF ^ temp;
+	tempbx &= temp;
+
+	temp = xgifb_reg_get(pVBInfo->P3d4, 0x38);
+
+	if (pVBInfo->IF_DEF_LCDA == 1) {
+
+		if (((HwDeviceExtension->jChipType >= XG20) ||
+		     (HwDeviceExtension->jChipType >= XG40)) &&
+		    (pVBInfo->IF_DEF_LVDS == 0)) {
+			if (pVBInfo->VBType &
+			    (VB_SIS302B |
+			     VB_SIS301LV |
+			     VB_SIS302LV |
+			     VB_XGI301C)) {
+				if (temp & EnableDualEdge) {
+					tempbx |= SetCRT2ToDualEdge;
+					if (temp & SetToLCDA)
+						tempbx |= XGI_SetCRT2ToLCDA;
 				}
 			}
 		}
+	}
 
-		if (pVBInfo->IF_DEF_YPbPr == 1) {
-			if (((pVBInfo->IF_DEF_LVDS == 0) &&
-			    ((pVBInfo->VBType & VB_SIS301LV) ||
-			    (pVBInfo->VBType & VB_SIS302LV) ||
-			    (pVBInfo->VBType & VB_XGI301C)))) {
-				if (temp & SetYPbPr) {
-					if (pVBInfo->IF_DEF_HiVision == 1) {
-						/* shampoo add for new
-						 * scratch */
-						temp = xgifb_reg_get(
-								pVBInfo->P3d4,
-								0x35);
-						temp &= YPbPrMode;
-						tempbx |= SetCRT2ToHiVision;
-
-						if (temp != YPbPrMode1080i) {
-							tempbx &=
-							 (~SetCRT2ToHiVision);
-							tempbx |=
-							 SetCRT2ToYPbPr525750;
-						}
+	if (pVBInfo->IF_DEF_YPbPr == 1) {
+		if (((pVBInfo->IF_DEF_LVDS == 0) &&
+		     ((pVBInfo->VBType & VB_SIS301LV) ||
+		      (pVBInfo->VBType & VB_SIS302LV) ||
+		      (pVBInfo->VBType & VB_XGI301C)))) {
+			if (temp & SetYPbPr) {
+				if (pVBInfo->IF_DEF_HiVision == 1) {
+					/* shampoo add for new
+					 * scratch */
+					temp = xgifb_reg_get(
+						pVBInfo->P3d4,
+						0x35);
+					temp &= YPbPrMode;
+					tempbx |= SetCRT2ToHiVision;
+
+					if (temp != YPbPrMode1080i) {
+						tempbx &=
+							(~SetCRT2ToHiVision);
+						tempbx |=
+							SetCRT2ToYPbPr525750;
 					}
 				}
 			}
 		}
+	}
 
-		tempax = push; /* restore CR31 */
+	tempax = push; /* restore CR31 */
 
-		if (pVBInfo->IF_DEF_LVDS == 0) {
-			if (pVBInfo->IF_DEF_YPbPr == 1) {
-				if (pVBInfo->IF_DEF_HiVision == 1)
-					temp = 0x09FC;
-				else
-					temp = 0x097C;
-			} else {
-				if (pVBInfo->IF_DEF_HiVision == 1)
-					temp = 0x01FC;
-				else
-					temp = 0x017C;
-			}
-		} else { /* 3nd party chip */
-			temp = SetCRT2ToLCD;
-		}
-
-		if (!(tempbx & temp)) {
-			tempax |= DisableCRT2Display;
-			tempbx = 0;
-		}
-
-		if (pVBInfo->IF_DEF_LCDA == 1) { /* Select Display Device */
-			if (!(pVBInfo->VBType & VB_NoLCD)) {
-				if (tempbx & XGI_SetCRT2ToLCDA) {
-					if (tempbx & SetSimuScanMode)
-						tempbx &= (~(SetCRT2ToLCD |
-							   SetCRT2ToRAMDAC |
-							   SwitchCRT2));
-					else
-						tempbx &= (~(SetCRT2ToLCD |
-							     SetCRT2ToRAMDAC |
-							     SetCRT2ToTV |
-							     SwitchCRT2));
-				}
-			}
+	if (pVBInfo->IF_DEF_LVDS == 0) {
+		if (pVBInfo->IF_DEF_YPbPr == 1) {
+			if (pVBInfo->IF_DEF_HiVision == 1)
+				temp = 0x09FC;
+			else
+				temp = 0x097C;
+		} else {
+			if (pVBInfo->IF_DEF_HiVision == 1)
+				temp = 0x01FC;
+			else
+				temp = 0x017C;
 		}
+	} else { /* 3nd party chip */
+		temp = SetCRT2ToLCD;
+	}
 
-		/* shampoo add */
-		/* for driver abnormal */
-		if (!(tempbx & (SwitchCRT2 | SetSimuScanMode))) {
-			if (pVBInfo->IF_DEF_CRT2Monitor == 1) {
-				if (tempbx & SetCRT2ToRAMDAC) {
-					tempbx &= (0xFF00 |
-						   SetCRT2ToRAMDAC |
-						   SwitchCRT2 |
-						   SetSimuScanMode);
-					tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
-				}
-			} else {
-				tempbx &= (~(SetCRT2ToRAMDAC |
-					   SetCRT2ToLCD |
-					   SetCRT2ToTV));
+	if (!(tempbx & temp)) {
+		tempax |= DisableCRT2Display;
+		tempbx = 0;
+	}
+
+	if (pVBInfo->IF_DEF_LCDA == 1) { /* Select Display Device */
+		if (!(pVBInfo->VBType & VB_NoLCD)) {
+			if (tempbx & XGI_SetCRT2ToLCDA) {
+				if (tempbx & SetSimuScanMode)
+					tempbx &= (~(SetCRT2ToLCD |
+						     SetCRT2ToRAMDAC |
+						     SwitchCRT2));
+				else
+					tempbx &= (~(SetCRT2ToLCD |
+						     SetCRT2ToRAMDAC |
+						     SetCRT2ToTV |
+						     SwitchCRT2));
 			}
 		}
+	}
 
-		if (!(pVBInfo->VBType & VB_NoLCD)) {
-			if (tempbx & SetCRT2ToLCD) {
+	/* shampoo add */
+	/* for driver abnormal */
+	if (!(tempbx & (SwitchCRT2 | SetSimuScanMode))) {
+		if (pVBInfo->IF_DEF_CRT2Monitor == 1) {
+			if (tempbx & SetCRT2ToRAMDAC) {
 				tempbx &= (0xFF00 |
-					   SetCRT2ToLCD |
+					   SetCRT2ToRAMDAC |
 					   SwitchCRT2 |
 					   SetSimuScanMode);
 				tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 			}
+		} else {
+			tempbx &= (~(SetCRT2ToRAMDAC |
+				     SetCRT2ToLCD |
+				     SetCRT2ToTV));
 		}
+	}
 
-		if (tempbx & SetCRT2ToSCART) {
+	if (!(pVBInfo->VBType & VB_NoLCD)) {
+		if (tempbx & SetCRT2ToLCD) {
 			tempbx &= (0xFF00 |
-				   SetCRT2ToSCART |
+				   SetCRT2ToLCD |
 				   SwitchCRT2 |
 				   SetSimuScanMode);
 			tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 		}
+	}
 
-		if (pVBInfo->IF_DEF_YPbPr == 1) {
-			if (tempbx & SetCRT2ToYPbPr525750)
-				tempbx &= (0xFF00 |
-					   SwitchCRT2 |
-					   SetSimuScanMode);
-		}
+	if (tempbx & SetCRT2ToSCART) {
+		tempbx &= (0xFF00 |
+			   SetCRT2ToSCART |
+			   SwitchCRT2 |
+			   SetSimuScanMode);
+		tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
+	}
 
-		if (pVBInfo->IF_DEF_HiVision == 1) {
-			if (tempbx & SetCRT2ToHiVision)
-				tempbx &= (0xFF00 |
-					   SetCRT2ToHiVision |
-					   SwitchCRT2 |
-					   SetSimuScanMode);
-		}
+	if (pVBInfo->IF_DEF_YPbPr == 1) {
+		if (tempbx & SetCRT2ToYPbPr525750)
+			tempbx &= (0xFF00 |
+				   SwitchCRT2 |
+				   SetSimuScanMode);
+	}
 
-		if (tempax & DisableCRT2Display) { /* Set Display Device Info */
-			if (!(tempbx & (SwitchCRT2 | SetSimuScanMode)))
-				tempbx = DisableCRT2Display;
-		}
+	if (pVBInfo->IF_DEF_HiVision == 1) {
+		if (tempbx & SetCRT2ToHiVision)
+			tempbx &= (0xFF00 |
+				   SetCRT2ToHiVision |
+				   SwitchCRT2 |
+				   SetSimuScanMode);
+	}
 
-		if (!(tempbx & DisableCRT2Display)) {
-			if ((!(tempbx & DriverMode)) ||
-			    (!(modeflag & CRT2Mode))) {
-				if (pVBInfo->IF_DEF_LCDA == 1) {
-					if (!(tempbx & XGI_SetCRT2ToLCDA))
-						tempbx |= (SetInSlaveMode |
-							   SetSimuScanMode);
-				}
-			}
+	if (tempax & DisableCRT2Display) { /* Set Display Device Info */
+		if (!(tempbx & (SwitchCRT2 | SetSimuScanMode)))
+			tempbx = DisableCRT2Display;
+	}
 
-			/* LCD+TV can't support in slave mode
-			 * (Force LCDA+TV->LCDB) */
-			if ((tempbx & SetInSlaveMode) &&
-			    (tempbx & XGI_SetCRT2ToLCDA)) {
-				tempbx ^= (SetCRT2ToLCD |
-					  XGI_SetCRT2ToLCDA |
-					  SetCRT2ToDualEdge);
-				pVBInfo->SetFlag |= ReserveTVOption;
+	if (!(tempbx & DisableCRT2Display)) {
+		if ((!(tempbx & DriverMode)) ||
+		    (!(modeflag & CRT2Mode))) {
+			if (pVBInfo->IF_DEF_LCDA == 1) {
+				if (!(tempbx & XGI_SetCRT2ToLCDA))
+					tempbx |= (SetInSlaveMode |
+						   SetSimuScanMode);
 			}
 		}
+
+		/* LCD+TV can't support in slave mode
+		 * (Force LCDA+TV->LCDB) */
+		if ((tempbx & SetInSlaveMode) &&
+		    (tempbx & XGI_SetCRT2ToLCDA)) {
+			tempbx ^= (SetCRT2ToLCD |
+				   XGI_SetCRT2ToLCDA |
+				   SetCRT2ToDualEdge);
+			pVBInfo->SetFlag |= ReserveTVOption;
+		}
 	}
 
 	pVBInfo->VBInfo = tempbx;
-- 
1.7.9.5

