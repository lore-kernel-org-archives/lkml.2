Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2BIUNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:13:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57813 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932107Ab2BIUMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:23 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/R7PEG01PRzNSV9VfhD3iajquhaJa9+kW5+CxV2C
	a+ibzXQjwFMToq
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/7] staging/xgifb: Rename remaining sis initdef.h defines and remove duplicates
Date: Thu,  9 Feb 2012 21:11:46 +0100
Message-Id: <1328818309-5103-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
References: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the remaining duplicate defines and their usage to
the naming convention of the sis initdef.h and removes the now duplicated
defines.

Renames:
CRT2DisplayFlag -> DisableCRT2Display
ModeInfoFlag -> ModeTypeMask

Support16Bpp -> Mode16Bpp
Support32Bpp -> Mode32Bpp

SupportHiVisionTV -> SupportHiVision
SupportYPbPr -> SupportYPbPr750p
SwitchToCRT2 -> SwitchCRT2

VB_XGI301 -> VB_SIS301
VB_XGI301B -> VB_SIS301B
VB_XGI301LV -> VB_SIS301LV
VB_XGI302B -> VB_SIS302B
VB_XGI302LV -> VB_SIS302LV
VB_YPbPr525p -> YPbPr525p
VB_YPbPr750p -> YPbPr750p

VCLK108_2 -> VCLK108_2_315
VCLK65 -> VCLK65_315

XGI_CRT2_PORT_04 -> SIS_CRT2_PORT_04
XGI_CRT2_PORT_10 -> SIS_CRT2_PORT_10
XGI_CRT2_PORT_12 -> SIS_CRT2_PORT_12
XGI_CRT2_PORT_14 -> SIS_CRT2_PORT_14

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |   10 +-
 drivers/staging/xgifb/vb_def.h      |   25 ---
 drivers/staging/xgifb/vb_init.c     |   14 +-
 drivers/staging/xgifb/vb_setmode.c  |  306 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_table.h    |  172 ++++++++++----------
 5 files changed, 251 insertions(+), 276 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index fb9b5b3..21c0378 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -371,15 +371,15 @@ static void XGIRegInit(struct vb_device_info *XGI_Pr, unsigned long BaseAddr)
 	XGI_Pr->P3c9 = BaseAddr + 0x19;
 	XGI_Pr->P3da = BaseAddr + 0x2A;
 	/* Digital video interface registers (LCD) */
-	XGI_Pr->Part1Port = BaseAddr + XGI_CRT2_PORT_04;
+	XGI_Pr->Part1Port = BaseAddr + SIS_CRT2_PORT_04;
 	/* 301 TV Encoder registers */
-	XGI_Pr->Part2Port = BaseAddr + XGI_CRT2_PORT_10;
+	XGI_Pr->Part2Port = BaseAddr + SIS_CRT2_PORT_10;
 	/* 301 Macrovision registers */
-	XGI_Pr->Part3Port = BaseAddr + XGI_CRT2_PORT_12;
+	XGI_Pr->Part3Port = BaseAddr + SIS_CRT2_PORT_12;
 	/* 301 VGA2 (and LCD) registers */
-	XGI_Pr->Part4Port = BaseAddr + XGI_CRT2_PORT_14;
+	XGI_Pr->Part4Port = BaseAddr + SIS_CRT2_PORT_14;
 	/* 301 palette address port registers */
-	XGI_Pr->Part5Port = BaseAddr + XGI_CRT2_PORT_14 + 2;
+	XGI_Pr->Part5Port = BaseAddr + SIS_CRT2_PORT_14 + 2;
 
 }
 
diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index c368322..12454c5 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -5,10 +5,6 @@
 #include "../../video/sis/initdef.h"
 
 #define VB_XGI301C      0x0020 /* for 301C */
-/*end 301b*/
-
-#define VB_YPbPr525p    0x01
-#define VB_YPbPr750p    0x02
 #define VB_YPbPr1080i   0x03
 
 #define LVDSCRT1Len     15
@@ -28,16 +24,10 @@
 #define PanelRef60Hz            0x00
 #define PanelRef75Hz            0x20
 
-#define CRT2DisplayFlag         0x2000
-
 #define YPbPr525iVCLK           0x03B
 #define YPbPr525iVCLK_2         0x03A
 
 #define XGI_CRT2_PORT_00        (0x00 - 0x030)
-#define XGI_CRT2_PORT_04        (0x04 - 0x030)
-#define XGI_CRT2_PORT_10        (0x10 - 0x30)
-#define XGI_CRT2_PORT_12        (0x12 - 0x30)
-#define XGI_CRT2_PORT_14        (0x14 - 0x30)
 
 #define _PanelType00             0x00
 #define _PanelType01             0x08
@@ -77,15 +67,9 @@
 #define VCLKLen           4
 #define VGA_XGI340        0x0001       /* 340 series */
 
-#define VB_XGI301         0x0001       /* VB Type Info */
-#define VB_XGI301B        0x0002       /* 301 series */
-#define VB_XGI302B        0x0004
 #define VB_NoLCD          0x8000
-#define VB_XGI301LV       0x0008
-#define VB_XGI302LV       0x0010
 #define VB_LVDS_NS        0x0001       /* 3rd party chip */
 
-#define ModeInfoFlag      0x0007
 #define ModeText          0x0000
 #define ModeEGA           0x0002    /* 16 colors mode */
 #define ModeVGA           0x0003    /* 256 colors mode */
@@ -103,19 +87,14 @@
 #define DoubleScanMode    0x8000
 
 /* -------------- Ext_InfoFlag */
-#define Support16Bpp        0x0005
-#define Support32Bpp        0x0007
-
 #define SupportAllCRT2      0x0078
 #define SupportTV           0x0008
-#define SupportHiVisionTV   0x0010
 #define SupportLCD          0x0020
 #define SupportRAMDAC2      0x0040
 #define NoSupportTV         0x0070
 #define NoSupportHiVisionTV 0x0060
 #define NoSupportLCD        0x0058
 #define SupportTV1024       0x0800 /* 301btest */
-#define SupportYPbPr        0x1000 /* 301lv */
 #define InterlaceMode       0x0080
 #define SyncPP              0x0000
 #define SyncPN              0x4000
@@ -124,7 +103,6 @@
 
 /* -------------- SetMode Stack/Scratch */
 #define SetSimuScanMode     0x0001    /* VBInfo/CR30 & CR31 */
-#define SwitchToCRT2        0x0002
 #define SetCRT2ToTV         0x089C
 #define SetCRT2ToAVIDEO     0x0004
 #define SetCRT2ToSVIDEO     0x0008
@@ -135,7 +113,6 @@
 #define SetInSlaveMode      0x0200
 #define SetNotSimuMode      0x0400
 #define LoadDACFlag         0x1000
-#define DisableCRT2Display  0x2000
 #define DriverMode          0x4000
 #define SetCRT2ToDualEdge   0x8000
 
@@ -275,7 +252,6 @@
 #define VCLK50               0x08
 #define VCLK52_406           0x09
 #define VCLK56_25            0x0A
-#define VCLK65               0x0B
 #define VCLK68_179           0x0D
 #define VCLK72_852           0x0E
 #define VCLK75               0x0F
@@ -284,7 +260,6 @@
 #define VCLK83_95            0x13
 #define VCLK86_6             0x15
 #define VCLK94_5             0x16
-#define VCLK108_2            0x19
 #define VCLK113_309          0x1B
 #define VCLK116_406          0x1C
 #define VCLK135_5            0x1E
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 4c54568..94d5c35 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1299,9 +1299,9 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 	tempcl |= SetSimuScanMode;
 	if ((!(temp & ActiveCRT1)) && ((temp & ActiveLCD) || (temp & ActiveTV)
 			|| (temp & ActiveCRT2)))
-		tempcl ^= (SetSimuScanMode | SwitchToCRT2);
+		tempcl ^= (SetSimuScanMode | SwitchCRT2);
 	if ((temp & ActiveLCD) && (temp & ActiveTV))
-		tempcl ^= (SetSimuScanMode | SwitchToCRT2);
+		tempcl ^= (SetSimuScanMode | SwitchCRT2);
 	xgifb_reg_set(pVBInfo->P3d4, 0x30, tempcl);
 
 	CR31Data = xgifb_reg_get(pVBInfo->P3d4, 0x31);
@@ -1516,11 +1516,11 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
 	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
 	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
-	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
-	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
-	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
-	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
-	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
+	pVBInfo->Part1Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_04;
+	pVBInfo->Part2Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_10;
+	pVBInfo->Part3Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_12;
+	pVBInfo->Part4Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14;
+	pVBInfo->Part5Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14 + 2;
 	printk("5");
 
 	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index ea142e9..ab2157c 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -138,7 +138,7 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 	pVBInfo->UpdateCRT1 = (struct XGI_XG21CRT1Struct *) XGI_UpdateCRT1Table;
 
 	/* 310 customization related */
-	if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType & VB_XGI302LV))
+	if ((pVBInfo->VBType & VB_SIS301LV) || (pVBInfo->VBType & VB_SIS302LV))
 		pVBInfo->LCDCapList = XGI_LCDDLCapList;
 	else
 		pVBInfo->LCDCapList = XGI_LCDCapList;
@@ -373,9 +373,9 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		}
 
 		if (pVBInfo->VBInfo & SetCRT2ToHiVision) { /* for HiTV */
-			if ((pVBInfo->VBType & VB_XGI301LV) &&
+			if ((pVBInfo->VBType & VB_SIS301LV) &&
 			    (pVBInfo->VBExtInfo == VB_YPbPr1080i)) {
-				tempax |= SupportYPbPr;
+				tempax |= SupportYPbPr750p;
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
 					if (resinfo == 4)
 						return 0;
@@ -387,7 +387,7 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 						return 0;
 				}
 			} else {
-				tempax |= SupportHiVisionTV;
+				tempax |= SupportHiVision;
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
 					if (resinfo == 4)
 						return 0;
@@ -410,8 +410,8 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 					       SetCRT2ToHiVision)) {
 				tempax |= SupportTV;
 
-				if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
-						| VB_XGI301LV | VB_XGI302LV
+				if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
+						| VB_SIS301LV | VB_SIS302LV
 						| VB_XGI301C)) {
 					tempax |= SupportTV1024;
 				}
@@ -1230,23 +1230,23 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short LCDXlat1VCLK[4] = { VCLK65 + 2,
-					   VCLK65 + 2,
-					   VCLK65 + 2,
-					   VCLK65 + 2 };
-	unsigned short LCDXlat2VCLK[4] = { VCLK108_2 + 5,
-					   VCLK108_2 + 5,
-					   VCLK108_2 + 5,
-					   VCLK108_2 + 5 };
+	unsigned short LCDXlat1VCLK[4] = { VCLK65_315 + 2,
+					   VCLK65_315 + 2,
+					   VCLK65_315 + 2,
+					   VCLK65_315 + 2 };
+	unsigned short LCDXlat2VCLK[4] = { VCLK108_2_315 + 5,
+					   VCLK108_2_315 + 5,
+					   VCLK108_2_315 + 5,
+					   VCLK108_2_315 + 5 };
 	unsigned short LVDSXlat1VCLK[4] = { VCLK40, VCLK40, VCLK40, VCLK40 };
-	unsigned short LVDSXlat2VCLK[4] = { VCLK65 + 2,
-					    VCLK65 + 2,
-					    VCLK65 + 2,
-					    VCLK65 + 2 };
-	unsigned short LVDSXlat3VCLK[4] = { VCLK65 + 2,
-					    VCLK65 + 2,
-					    VCLK65 + 2,
-					    VCLK65 + 2 };
+	unsigned short LVDSXlat2VCLK[4] = { VCLK65_315 + 2,
+					    VCLK65_315 + 2,
+					    VCLK65_315 + 2,
+					    VCLK65_315 + 2 };
+	unsigned short LVDSXlat3VCLK[4] = { VCLK65_315 + 2,
+					    VCLK65_315 + 2,
+					    VCLK65_315 + 2,
+					    VCLK65_315 + 2 };
 
 	unsigned short CRT2Index, VCLKIndex;
 	unsigned short modeflag, resinfo;
@@ -1291,11 +1291,11 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			}
 
 			/* 301lv */
-			if ((pVBInfo->VBType & VB_XGI301LV) &&
+			if ((pVBInfo->VBType & VB_SIS301LV) &&
 			    !(pVBInfo->VBExtInfo == VB_YPbPr1080i)) {
-				if (pVBInfo->VBExtInfo == VB_YPbPr750p)
+				if (pVBInfo->VBExtInfo == YPbPr750p)
 					VCLKIndex = YPbPr750pVCLK;
-				else if (pVBInfo->VBExtInfo == VB_YPbPr525p)
+				else if (pVBInfo->VBExtInfo == YPbPr525p)
 					VCLKIndex = YPbPr525pVCLK;
 				else if (pVBInfo->SetFlag & RPLLDIV2XO)
 					VCLKIndex = YPbPr525iVCLK_2;
@@ -1360,8 +1360,8 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo,
 		xgifb_reg_set(pVBInfo->P3c4, 0x2C,
 				pVBInfo->VCLKData[index].SR2C);
 		xgifb_reg_set(pVBInfo->P3c4, 0x2D, 0x01);
-	} else if ((pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) && (pVBInfo->VBInfo
+	} else if ((pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) && (pVBInfo->VBInfo
 			& SetCRT2ToLCDA)) {
 		vclkindex = XGI_GetVCLK2Ptr(ModeNo, ModeIdIndex,
 				RefreshRateTableIndex, HwDeviceExtension,
@@ -2128,30 +2128,30 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 			return &XGI_CetLCDDes1024x768Data[tempal];
 			break;
 		case 3:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-				(pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+				(pVBInfo->VBType & VB_SIS302LV))
 				return &XGI_ExtLCDDLDes1280x1024Data[tempal];
 			else
 				return &XGI_ExtLCDDes1280x1024Data[tempal];
 			break;
 		case 4:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV))
 				return &XGI_StLCDDLDes1280x1024Data[tempal];
 			else
 				return &XGI_StLCDDes1280x1024Data[tempal];
 			break;
 		case 5:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV))
 				return &XGI_CetLCDDLDes1280x1024Data[tempal];
 			else
 				return &XGI_CetLCDDes1280x1024Data[tempal];
 			break;
 		case 6:
 		case 7:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV))
 				return &xgifb_lcddldes_1400x1050[tempal];
 			else
 				return &xgifb_lcddes_1400x1050[tempal];
@@ -2163,15 +2163,15 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 			return &XGI_CetLCDDes1400x1050Data2[tempal];
 			break;
 		case 10:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV))
 				return &XGI_ExtLCDDLDes1600x1200Data[tempal];
 			else
 				return &XGI_ExtLCDDes1600x1200Data[tempal];
 			break;
 		case 11:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV))
 				return &XGI_StLCDDLDes1600x1200Data[tempal];
 			else
 				return &XGI_StLCDDes1600x1200Data[tempal];
@@ -2188,15 +2188,15 @@ static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 			break;
 		case 16:
 		case 17:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV))
 				return &xgifb_lcddldes_1280x1024x75[tempal];
 			else
 				return &xgifb_lcddes_1280x1024x75[tempal];
 			break;
 		case 18:
-			if ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV))
+			if ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV))
 				return &XGI_CetLCDDLDes1280x1024x75Data[tempal];
 			else
 				return &XGI_CetLCDDes1280x1024x75Data[tempal];
@@ -2839,10 +2839,10 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 
 		/* {TV} */
 		if (pVBInfo->VBType &
-		    (VB_XGI301B |
-		     VB_XGI302B |
-		     VB_XGI301LV |
-		     VB_XGI302LV |
+		    (VB_SIS301B |
+		     VB_SIS302B |
+		     VB_SIS301LV |
+		     VB_SIS302LV |
 		     VB_XGI301C)) {
 			if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 				tempal = HiTVVCLKDIV2;
@@ -2898,8 +2898,8 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
 		unsigned char *di_1, struct vb_device_info *pVBInfo)
 {
-	if (pVBInfo->VBType & (VB_XGI301 | VB_XGI301B | VB_XGI302B
-			| VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301 | VB_SIS301B | VB_SIS302B
+			| VB_SIS301LV | VB_SIS302LV | VB_XGI301C)) {
 		if ((!(pVBInfo->VBInfo & SetCRT2ToLCDA)) && (pVBInfo->SetFlag
 				& ProgrammingCRT2)) {
 			*di_0 = (unsigned char) XGI_VBVCLKData[tempal].SR2B;
@@ -2942,8 +2942,8 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 {
 	unsigned short tempcl, tempch, temp, tempbl, tempax;
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		tempcl = 0;
 		tempch = 0;
 		temp = xgifb_reg_get(pVBInfo->P3c4, 0x01);
@@ -3029,19 +3029,19 @@ void XGI_GetVBType(struct vb_device_info *pVBInfo)
 	unsigned short flag, tempbx, tempah;
 
 	if (pVBInfo->IF_DEF_LVDS == 0) {
-		tempbx = VB_XGI302B;
+		tempbx = VB_SIS302B;
 		flag = xgifb_reg_get(pVBInfo->Part4Port, 0x00);
 		if (flag != 0x02) {
-			tempbx = VB_XGI301;
+			tempbx = VB_SIS301;
 			flag = xgifb_reg_get(pVBInfo->Part4Port, 0x01);
 			if (flag >= 0xB0) {
-				tempbx = VB_XGI301B;
+				tempbx = VB_SIS301B;
 				if (flag >= 0xC0) {
 					tempbx = VB_XGI301C;
 					if (flag >= 0xD0) {
-						tempbx = VB_XGI301LV;
+						tempbx = VB_SIS301LV;
 						if (flag >= 0xE0) {
-							tempbx = VB_XGI302LV;
+							tempbx = VB_SIS302LV;
 							tempah = xgifb_reg_get(
 							    pVBInfo->Part4Port,
 							    0x39);
@@ -3052,7 +3052,7 @@ void XGI_GetVBType(struct vb_device_info *pVBInfo)
 					}
 				}
 
-				if (tempbx & (VB_XGI301B | VB_XGI302B)) {
+				if (tempbx & (VB_SIS301B | VB_SIS302B)) {
 					flag = xgifb_reg_get(
 							pVBInfo->Part4Port,
 							0x23);
@@ -3078,7 +3078,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
 	pVBInfo->SetFlag = 0;
-	pVBInfo->ModeType = modeflag & ModeInfoFlag;
+	pVBInfo->ModeType = modeflag & ModeTypeMask;
 	tempbx = 0;
 
 	if (pVBInfo->VBType & 0xFFFF) {
@@ -3103,9 +3103,9 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			    (HwDeviceExtension->jChipType >= XG40)) {
 				if (pVBInfo->IF_DEF_LVDS == 0) {
 					if (pVBInfo->VBType &
-					    (VB_XGI302B |
-					     VB_XGI301LV |
-					     VB_XGI302LV |
+					    (VB_SIS302B |
+					     VB_SIS301LV |
+					     VB_SIS302LV |
 					     VB_XGI301C)) {
 						if (temp & EnableDualEdge) {
 							tempbx |=
@@ -3123,8 +3123,8 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
 			/* [Billy] 07/05/04 */
 			if (((pVBInfo->IF_DEF_LVDS == 0) &&
-			    ((pVBInfo->VBType & VB_XGI301LV) ||
-			    (pVBInfo->VBType & VB_XGI302LV) ||
+			    ((pVBInfo->VBType & VB_SIS301LV) ||
+			    (pVBInfo->VBType & VB_SIS302LV) ||
 			    (pVBInfo->VBType & VB_XGI301C)))) {
 				if (temp & SetYPbPr) {
 					if (pVBInfo->IF_DEF_HiVision == 1) {
@@ -3176,24 +3176,24 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 					if (tempbx & SetSimuScanMode)
 						tempbx &= (~(SetCRT2ToLCD |
 							   SetCRT2ToRAMDAC |
-							   SwitchToCRT2));
+							   SwitchCRT2));
 					else
 						tempbx &= (~(SetCRT2ToLCD |
 							     SetCRT2ToRAMDAC |
 							     SetCRT2ToTV |
-							     SwitchToCRT2));
+							     SwitchCRT2));
 				}
 			}
 		}
 
 		/* shampoo add */
 		/* for driver abnormal */
-		if (!(tempbx & (SwitchToCRT2 | SetSimuScanMode))) {
+		if (!(tempbx & (SwitchCRT2 | SetSimuScanMode))) {
 			if (pVBInfo->IF_DEF_CRT2Monitor == 1) {
 				if (tempbx & SetCRT2ToRAMDAC) {
 					tempbx &= (0xFF00 |
 						   SetCRT2ToRAMDAC |
-						   SwitchToCRT2 |
+						   SwitchCRT2 |
 						   SetSimuScanMode);
 					tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 				}
@@ -3208,7 +3208,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (tempbx & SetCRT2ToLCD) {
 				tempbx &= (0xFF00 |
 					   SetCRT2ToLCD |
-					   SwitchToCRT2 |
+					   SwitchCRT2 |
 					   SetSimuScanMode);
 				tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 			}
@@ -3217,7 +3217,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (tempbx & SetCRT2ToSCART) {
 			tempbx &= (0xFF00 |
 				   SetCRT2ToSCART |
-				   SwitchToCRT2 |
+				   SwitchCRT2 |
 				   SetSimuScanMode);
 			tempbx &= (0x00FF | (~SetCRT2ToYPbPr525750));
 		}
@@ -3225,7 +3225,7 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
 			if (tempbx & SetCRT2ToYPbPr525750)
 				tempbx &= (0xFF00 |
-					   SwitchToCRT2 |
+					   SwitchCRT2 |
 					   SetSimuScanMode);
 		}
 
@@ -3233,12 +3233,12 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (tempbx & SetCRT2ToHiVision)
 				tempbx &= (0xFF00 |
 					   SetCRT2ToHiVision |
-					   SwitchToCRT2 |
+					   SwitchCRT2 |
 					   SetSimuScanMode);
 		}
 
 		if (tempax & DisableCRT2Display) { /* Set Display Device Info */
-			if (!(tempbx & (SwitchToCRT2 | SetSimuScanMode)))
+			if (!(tempbx & (SwitchCRT2 | SetSimuScanMode)))
 				tempbx = DisableCRT2Display;
 		}
 
@@ -3350,10 +3350,10 @@ static void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 				    (TVSetYPbPr525p | TVSetYPbPr750p))
 					tempbx &= (~RPLLDIV2XO);
 				else if (!(pVBInfo->VBType &
-					 (VB_XGI301B |
-					  VB_XGI302B |
-					  VB_XGI301LV |
-					  VB_XGI302LV |
+					 (VB_SIS301B |
+					  VB_SIS302B |
+					  VB_SIS301LV |
+					  VB_SIS302LV |
 					  VB_XGI301C))) {
 					if (tempbx & TVSimuMode)
 						tempbx &= (~RPLLDIV2XO);
@@ -3427,7 +3427,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 	tempax = pVBInfo->LCDCapList[LCDIdIndex].LCD_Capability;
 
 	if (pVBInfo->IF_DEF_LVDS == 0) { /* shampoo */
-		if (((pVBInfo->VBType & VB_XGI302LV) || (pVBInfo->VBType
+		if (((pVBInfo->VBType & VB_SIS302LV) || (pVBInfo->VBType
 				& VB_XGI301C)) && (tempax & LCDDualLink)) {
 			tempbx |= SetLCDDualLink;
 		}
@@ -4109,7 +4109,7 @@ static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGI_GetVCLKLen(tempal, &di_0, &di_1, pVBInfo);
 	XGI_GetLCDVCLKPtr(&di_0, &di_1, pVBInfo);
 
-	if (pVBInfo->VBType & VB_XGI301) { /* shampoo 0129 */
+	if (pVBInfo->VBType & VB_SIS301) { /* shampoo 0129 */
 		/* 301 */
 		xgifb_reg_set(pVBInfo->Part4Port, 0x0A, 0x10);
 		xgifb_reg_set(pVBInfo->Part4Port, 0x0B, di_1);
@@ -4139,7 +4139,7 @@ static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
 	else
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
-	index = (modeflag & ModeInfoFlag) - ModeEGA;
+	index = (modeflag & ModeTypeMask) - ModeEGA;
 
 	if (index < 0)
 		index = 0;
@@ -4435,7 +4435,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part1Port, 0x03, temp);
 	tempcx = 0x08;
 
-	if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C))
+	if (pVBInfo->VBType & (VB_SIS301LV | VB_SIS302LV | VB_XGI301C))
 		modeflag |= Charx8Dot;
 
 	tempax = pVBInfo->VGAHDE; /* 0x04 Horizontal Display End */
@@ -4451,12 +4451,12 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = (tempbx & 0xFF00) >> 8;
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
-		if (!(pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)))
+		if (!(pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+				| VB_SIS302LV | VB_XGI301C)))
 			temp += 2;
 
 		if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
-			if (pVBInfo->VBType & VB_XGI301LV) {
+			if (pVBInfo->VBType & VB_SIS301LV) {
 				if (pVBInfo->VBExtInfo == VB_YPbPr1080i) {
 					if (resinfo == 7)
 						temp -= 2;
@@ -4670,14 +4670,14 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
-		if (pVBInfo->VBType & VB_XGI301LV) {
+		if (pVBInfo->VBType & VB_SIS301LV) {
 			if (pVBInfo->TVInfo & TVSetHiVision) {
 				tempbx -= 10;
 			} else {
 				if (pVBInfo->TVInfo & TVSimuMode) {
 					if (pVBInfo->TVInfo & TVSetPAL) {
 						if (pVBInfo->VBType &
-						    VB_XGI301LV) {
+						    VB_SIS301LV) {
 							if (!(pVBInfo->TVInfo &
 							    (TVSetYPbPr525p |
 							    TVSetYPbPr750p |
@@ -4695,7 +4695,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	} else {
 		if (pVBInfo->TVInfo & TVSimuMode) {
 			if (pVBInfo->TVInfo & TVSetPAL) {
-				if (pVBInfo->VBType & VB_XGI301LV) {
+				if (pVBInfo->VBType & VB_SIS301LV) {
 					if (!(pVBInfo->TVInfo &
 					    (TVSetYPbPr525p |
 					     TVSetYPbPr750p |
@@ -4761,7 +4761,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	temp = (temp >> 1) & 0x09;
 
-	if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C))
+	if (pVBInfo->VBType & (VB_SIS301LV | VB_SIS302LV | VB_XGI301C))
 		temp |= 0x01;
 
 	xgifb_reg_set(pVBInfo->Part1Port, 0x16, temp); /* 0x16 SR01 */
@@ -4884,8 +4884,8 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = (tempax & 0xFF00) >> 8;
 		temp += (unsigned short) TimingPoint[0];
 
-		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+				| VB_SIS302LV | VB_XGI301C)) {
 			if (pVBInfo->VBInfo & (SetCRT2ToAVIDEO
 					| SetCRT2ToSVIDEO | SetCRT2ToSCART
 					| SetCRT2ToYPbPr525750)) {
@@ -4903,8 +4903,8 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = (tempax & 0xFF00) >> 8;
 		temp += TimingPoint[1];
 
-		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+				| VB_SIS302LV | VB_XGI301C)) {
 			if ((pVBInfo->VBInfo & (SetCRT2ToAVIDEO
 					| SetCRT2ToSVIDEO | SetCRT2ToSCART
 					| SetCRT2ToYPbPr525750))) {
@@ -5005,7 +5005,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
 		if (pVBInfo->VBType &
-		    (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
+		    (VB_SIS301LV | VB_SIS302LV | VB_XGI301C)) {
 			if (!(pVBInfo->TVInfo &
 			    (TVSetYPbPr525p | TVSetYPbPr750p)))
 				tempbx = tempbx >> 1;
@@ -5017,7 +5017,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = tempbx & 0x00FF;
 
 	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
-		if (pVBInfo->VBType & VB_XGI301LV) {
+		if (pVBInfo->VBType & VB_SIS301LV) {
 			if (pVBInfo->TVInfo & TVSetHiVision) {
 				if (pVBInfo->VBInfo & SetInSlaveMode) {
 					if (ModeNo == 0x2f)
@@ -5038,7 +5038,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp |= ((tempbx & 0xFF00) >> 8) << 6;
 
 	if (!(pVBInfo->VBInfo & SetCRT2ToHiVision)) {
-		if (pVBInfo->VBType & VB_XGI301LV) {
+		if (pVBInfo->VBType & VB_SIS301LV) {
 			if (pVBInfo->TVInfo & TVSetHiVision) {
 				temp |= 0x10;
 
@@ -5054,8 +5054,8 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	xgifb_reg_set(pVBInfo->Part2Port, 0x30, temp);
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) { /* TV gatingno */
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) { /* TV gatingno */
 		tempbx = pVBInfo->VDE;
 		tempcx = tempbx - 2;
 
@@ -5065,7 +5065,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 				tempbx = tempbx >> 1;
 		}
 
-		if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
 			temp = 0;
 			if (tempcx & 0x0400)
 				temp |= 0x20;
@@ -5118,8 +5118,8 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		/* 301b */
 		tempecx = 8 * 1024;
 
-		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+				| VB_SIS302LV | VB_XGI301C)) {
 			tempecx = tempecx * 8;
 		}
 
@@ -5133,8 +5133,8 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempax = (unsigned short) tempeax;
 
 		/* 301b */
-		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+				| VB_SIS302LV | VB_XGI301C)) {
 			tempcx = ((tempax & 0xFF00) >> 5) >> 8;
 		}
 		/* end 301b */
@@ -5375,7 +5375,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx = tempcx >> 1;
 	}
 
-	if (pVBInfo->VBType & VB_XGI302LV)
+	if (pVBInfo->VBType & VB_SIS302LV)
 		tempbx += 1;
 
 	if (pVBInfo->VBType & VB_XGI301C) /* tap4 */
@@ -5405,7 +5405,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx = tempcx >> 1;
 	}
 
-	if (pVBInfo->VBType & VB_XGI302LV)
+	if (pVBInfo->VBType & VB_SIS302LV)
 		tempbx += 1;
 
 	tempcx += tempbx;
@@ -5424,8 +5424,8 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
 		if (pVBInfo->VGAVDE == 525) {
-			if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
-					| VB_XGI301LV | VB_XGI302LV
+			if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
+					| VB_SIS301LV | VB_SIS302LV
 					| VB_XGI301C)) {
 				temp = 0xC6;
 			} else
@@ -5436,8 +5436,8 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 
 		if (pVBInfo->VGAVDE == 420) {
-			if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
-					| VB_XGI301LV | VB_XGI302LV
+			if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
+					| VB_SIS301LV | VB_SIS302LV
 					| VB_XGI301C)) {
 				temp = 0x4F;
 			} else
@@ -5705,8 +5705,8 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_set(pVBInfo->Part4Port, 0x19, temp);
 
 	/* 301b */
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		temp = 0x0028;
 		xgifb_reg_set(pVBInfo->Part4Port, 0x1C, temp);
 		tempax = pVBInfo->VGAHDE;
@@ -5785,7 +5785,7 @@ static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 	Pdata = pVBInfo->Part5Port + 1;
 	if (pVBInfo->ModeType == ModeVGA) {
 		if (!(pVBInfo->VBInfo & (SetInSlaveMode | LoadDACFlag
-				| CRT2DisplayFlag))) {
+				| DisableCRT2Display))) {
 			XGINew_EnableCRT2(pVBInfo);
 		}
 	}
@@ -6074,7 +6074,7 @@ static unsigned char XGI_IsLCDON(struct vb_device_info *pVBInfo)
 	tempax = pVBInfo->VBInfo;
 	if (tempax & SetCRT2ToDualEdge)
 		return 0;
-	else if (tempax & (DisableCRT2Display | SwitchToCRT2 | SetSimuScanMode))
+	else if (tempax & (DisableCRT2Display | SwitchCRT2 | SetSimuScanMode))
 		return 1;
 
 	return 0;
@@ -6140,8 +6140,8 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 {
 	unsigned short tempah = 0;
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		tempah = 0x3F;
 		if (!(pVBInfo->VBInfo &
 		    (DisableCRT2Display | SetSimuScanMode))) {
@@ -6166,7 +6166,7 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 		/* disable part4_1f */
 		xgifb_reg_and(pVBInfo->Part4Port, 0x1F, tempah);
 
-		if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
 			if (((pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)))
 					|| (XGI_DisableChISLCD(pVBInfo))
 					|| (XGI_IsLCDON(pVBInfo)))
@@ -6308,8 +6308,8 @@ static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
 			*tempbx = 5;
 	}
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		if ((!(pVBInfo->VBInfo & SetInSlaveMode)) || (pVBInfo->TVInfo
 				& TVSimuMode)) {
 			*tempbx += 8;
@@ -6317,8 +6317,8 @@ static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
 		}
 	}
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C))
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C))
 		(*tempch)++;
 }
 
@@ -6328,8 +6328,8 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 
 	unsigned char tempah, tempbl, tempbh;
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA
 				| SetCRT2ToTV | SetCRT2ToRAMDAC)) {
 			tempbl = 0;
@@ -6338,8 +6338,8 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 			index = XGI_GetTVPtrIndex(pVBInfo); /* Get TV Delay */
 			tempbl = pVBInfo->XGI_TVDelayList[index];
 
-			if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
-					| VB_XGI301LV | VB_XGI302LV
+			if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
+					| VB_SIS301LV | VB_SIS302LV
 					| VB_XGI301C))
 				tempbl = pVBInfo->XGI_TVDelayList2[index];
 
@@ -6475,13 +6475,13 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 	tempcx = pVBInfo->LCDCapList[XGI_GetLCDCapPtr(pVBInfo)].LCD_Capability;
 
 	if (pVBInfo->VBType &
-	    (VB_XGI301B |
-	     VB_XGI302B |
-	     VB_XGI301LV |
-	     VB_XGI302LV |
+	    (VB_SIS301B |
+	     VB_SIS302B |
+	     VB_SIS301LV |
+	     VB_SIS302LV |
 	     VB_XGI301C)) { /* 301LV/302LV only */
 		if (pVBInfo->VBType &
-		    (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
+		    (VB_SIS301LV | VB_SIS302LV | VB_XGI301C)) {
 			/* Set 301LV Capability */
 			xgifb_reg_set(pVBInfo->Part4Port, 0x24,
 					(unsigned char) (tempcx & 0x1F));
@@ -6493,14 +6493,14 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 						| EnablePLLSPLOW)) >> 8));
 	}
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->VBInfo & SetCRT2ToLCD)
 			XGI_SetLCDCap_B(tempcx, pVBInfo);
 		else if (pVBInfo->VBInfo & SetCRT2ToLCDA)
 			XGI_SetLCDCap_A(tempcx, pVBInfo);
 
-		if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
 			if (tempcx & EnableSpectrum)
 				SetSpectrum(pVBInfo);
 		}
@@ -6648,8 +6648,8 @@ static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
 		xgifb_reg_set(pVBInfo->Part2Port, 0x38, filterPtr[index++]);
 	}
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		xgifb_reg_set(pVBInfo->Part2Port, 0x48, filterPtr[index++]);
 		xgifb_reg_set(pVBInfo->Part2Port, 0x49, filterPtr[index++]);
 		xgifb_reg_set(pVBInfo->Part2Port, 0x4A, filterPtr[index++]);
@@ -6676,7 +6676,7 @@ static void XGI_OEM310Setting(unsigned short ModeNo,
 		XGI_SetYFilter(ModeNo, ModeIdIndex, pVBInfo);
 		XGI_SetAntiFlicker(ModeNo, ModeIdIndex, pVBInfo);
 
-		if (pVBInfo->VBType & VB_XGI301)
+		if (pVBInfo->VBType & VB_SIS301)
 			XGI_SetEdgeEnhance(ModeNo, ModeIdIndex, pVBInfo);
 	}
 }
@@ -6817,8 +6817,8 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 		xgifb_reg_set(pVBInfo->Part4Port, 0x0C, tempah);
 	}
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		tempah = 0;
 		tempbl = 0xfb;
 
@@ -6857,7 +6857,7 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 
 	xgifb_reg_and_or(pVBInfo->Part4Port, 0x23, tempbl, tempah);
 
-	if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->LCDInfo & SetLCDDualLink) {
 			xgifb_reg_or(pVBInfo->Part4Port, 0x27, 0x20);
 			xgifb_reg_or(pVBInfo->Part4Port, 0x34, 0x10);
@@ -6939,8 +6939,8 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 	if (pVBInfo->SetFlag & ProgrammingCRT2) {
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
 			if (pVBInfo->IF_DEF_LVDS == 0) {
-				if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
-						| VB_XGI301LV | VB_XGI302LV
+				if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
+						| VB_SIS301LV | VB_SIS302LV
 						| VB_XGI301C))
 					/* 301b */
 					temp = LCDARefreshIndex[
@@ -6983,7 +6983,7 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 			break;
 		temp = pVBInfo->RefIndex[RefreshRateTableIndex + i].
 			Ext_InfoFlag;
-		temp &= ModeInfoFlag;
+		temp &= ModeTypeMask;
 		if (temp < pVBInfo->ModeType)
 			break;
 		i++;
@@ -7163,8 +7163,8 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 {
 	unsigned short tempah;
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		if (!(pVBInfo->SetFlag & DisableChA)) {
 			if (pVBInfo->SetFlag & EnableChA) {
 				/* Power on */
@@ -7207,7 +7207,7 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 				|| (!(pVBInfo->VBInfo & DisableCRT2Display))) {
 			xgifb_reg_and_or(pVBInfo->Part2Port, 0x00, ~0xE0,
 					0x20); /* shampoo 0129 */
-			if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
+			if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
 				if (!XGI_DisableChISLCD(pVBInfo)) {
 					if (XGI_EnableChISLCD(pVBInfo) ||
 					    (pVBInfo->VBInfo &
@@ -7311,8 +7311,8 @@ static void XGI_SetCRT1Group(struct xgifb_video_info *xgifb_info,
 	pVBInfo->SetFlag &= temp;
 	pVBInfo->SelectCRT2Rate = 0;
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
+	if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B | VB_SIS301LV
+			| VB_SIS302LV | VB_XGI301C)) {
 		if (pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToLCDA
 				| SetInSlaveMode)) {
 			pVBInfo->SetFlag |= ProgrammingCRT2;
@@ -7415,11 +7415,11 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
 	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
 	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
-	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
-	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
-	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
-	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
-	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
+	pVBInfo->Part1Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_04;
+	pVBInfo->Part2Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_10;
+	pVBInfo->Part3Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_12;
+	pVBInfo->Part4Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14;
+	pVBInfo->Part5Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14 + 2;
 
 	/* for x86 Linux, XG21 LVDS */
 	if (HwDeviceExtension->jChipType == XG21) {
@@ -7461,7 +7461,7 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 						HwDeviceExtension, pVBInfo);
 			}
 		} else {
-			if (!(pVBInfo->VBInfo & SwitchToCRT2)) {
+			if (!(pVBInfo->VBInfo & SwitchCRT2)) {
 				XGI_SetCRT1Group(xgifb_info,
 						HwDeviceExtension, ModeNo,
 						ModeIdIndex, pVBInfo);
@@ -7473,7 +7473,7 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 			}
 		}
 
-		if (pVBInfo->VBInfo & (SetSimuScanMode | SwitchToCRT2)) {
+		if (pVBInfo->VBInfo & (SetSimuScanMode | SwitchCRT2)) {
 			switch (HwDeviceExtension->ujVBChipID) {
 			case VB_CHIP_301:
 				XGI_SetCRT2Group301(ModeNo, HwDeviceExtension,
@@ -7504,10 +7504,10 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 
 		if (ModeNo <= 0x13) {
 			pVBInfo->ModeType = pVBInfo->SModeIDTable[ModeIdIndex].
-						St_ModeFlag & ModeInfoFlag;
+						St_ModeFlag & ModeTypeMask;
 		} else {
 			pVBInfo->ModeType = pVBInfo->EModeIDTable[ModeIdIndex].
-						Ext_ModeFlag & ModeInfoFlag;
+						Ext_ModeFlag & ModeTypeMask;
 		}
 
 		pVBInfo->SetFlag = 0;
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index c587d41..4f803b6 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -2501,17 +2501,17 @@ static unsigned short LCDLenList[] = {
 /* Dual link only */
 static struct XGI330_LCDCapStruct  XGI_LCDDLCapList[] = {
 /* LCDCap1024x768 */
-	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
+	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024 */
 	{Panel_1280x1024, LCDDualLink+DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2,
+	0x012, 0x70, 0x03, VCLK108_2_315,
 	0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1400x1050 */
 	{Panel_1400x1050, LCDDualLink+DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2,
+	0x012, 0x70, 0x03, VCLK108_2_315,
 	 0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1600x1200 */
@@ -2529,24 +2529,24 @@ static struct XGI330_LCDCapStruct  XGI_LCDDLCapList[] = {
 	 0x54, 0x42, 0x4A, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCapDefault */
-	{0xFF, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
+	{0xFF, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10}
 };
 
 static struct XGI330_LCDCapStruct  XGI_LCDCapList[] = {
 /* LCDCap1024x768 */
-	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
+	{Panel_1024x768, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10},
 /* LCDCap1280x1024 */
 	{Panel_1280x1024, DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2,
+	0x012, 0x70, 0x03, VCLK108_2_315,
 	0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1400x1050 */
 	{Panel_1400x1050, DefaultLCDCap, StLCDBToA,
-	0x012, 0x70, 0x03, VCLK108_2,
+	0x012, 0x70, 0x03, VCLK108_2_315,
 	 0x70, 0x44, 0xF8, 0x2F, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCap1600x1200 */
@@ -2564,162 +2564,162 @@ static struct XGI330_LCDCapStruct  XGI_LCDCapList[] = {
 	 0x54, 0x42, 0x4A, 0x61, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	 0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x30, 0x10},
 /* LCDCapDefault */
-	{0xFF, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65,
+	{0xFF, DefaultLCDCap, 0, 0x012, 0x88, 0x06, VCLK65_315,
 	0x6C, 0xC3, 0x35, 0x62, 0x02, 0x14, 0x0A, 0x02, 0x00,
 	0x30, 0x10, 0x5A, 0x10, 0x10, 0x0A, 0xC0, 0x28, 0x10}
 };
 
 static struct XGI_Ext2Struct XGI330_RefIndex[] = {
-	{Support32Bpp + SupportAllCRT2 + SyncPN, RES320x200, VCLK25_175,
+	{Mode32Bpp + SupportAllCRT2 + SyncPN, RES320x200, VCLK25_175,
 	0x00, 0x10, 0x59, 320, 200},/* 00 */
-	{Support32Bpp + SupportAllCRT2 + SyncPN, RES320x200, VCLK25_175,
+	{Mode32Bpp + SupportAllCRT2 + SyncPN, RES320x200, VCLK25_175,
 	0x00, 0x10, 0x00, 320, 400},/* 01 */
-	{Support32Bpp + SupportAllCRT2 + SyncNN, RES320x240, VCLK25_175,
+	{Mode32Bpp + SupportAllCRT2 + SyncNN, RES320x240, VCLK25_175,
 	0x04, 0x20, 0x50, 320, 240},/* 02 */
-	{Support32Bpp + SupportAllCRT2 + SyncPP, RES400x300, VCLK40,
+	{Mode32Bpp + SupportAllCRT2 + SyncPP, RES400x300, VCLK40,
 	0x05, 0x32, 0x51, 400, 300},/* 03 */
-	{Support32Bpp + NoSupportTV + SyncNN + SupportTV1024, RES512x384,
-	VCLK65, 0x06, 0x43, 0x52, 512, 384},/* 04 */
-	{Support32Bpp + SupportAllCRT2 + SyncPN, RES640x400, VCLK25_175,
+	{Mode32Bpp + NoSupportTV + SyncNN + SupportTV1024, RES512x384,
+	VCLK65_315, 0x06, 0x43, 0x52, 512, 384},/* 04 */
+	{Mode32Bpp + SupportAllCRT2 + SyncPN, RES640x400, VCLK25_175,
 	0x00, 0x14, 0x2f, 640, 400},/* 05 */
-	{Support32Bpp + SupportAllCRT2 + SyncNN, RES640x480x60, VCLK25_175,
+	{Mode32Bpp + SupportAllCRT2 + SyncNN, RES640x480x60, VCLK25_175,
 	0x04, 0x24, 0x2e, 640, 480},/* 06 640x480x60Hz (LCD 640x480x60z) */
-	{Support32Bpp + NoSupportHiVisionTV + SyncNN, RES640x480x72, VCLK31_5,
+	{Mode32Bpp + NoSupportHiVisionTV + SyncNN, RES640x480x72, VCLK31_5,
 	0x04, 0x24, 0x2e, 640, 480},/* 07 640x480x72Hz (LCD 640x480x70Hz) */
-	{Support32Bpp + NoSupportHiVisionTV + SyncNN, RES640x480x75, VCLK31_5,
+	{Mode32Bpp + NoSupportHiVisionTV + SyncNN, RES640x480x75, VCLK31_5,
 	0x47, 0x24, 0x2e, 640, 480},/* 08 640x480x75Hz (LCD 640x480x75Hz) */
-	{Support32Bpp + SupportRAMDAC2 + SyncNN, RES640x480x85, VCLK36,
+	{Mode32Bpp + SupportRAMDAC2 + SyncNN, RES640x480x85, VCLK36,
 	0x8A, 0x24, 0x2e, 640, 480},/* 09 640x480x85Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES640x480x100, VCLK43_163,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES640x480x100, VCLK43_163,
 	0x00, 0x24, 0x2e, 640, 480},/* 0a 640x480x100Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES640x480x120, VCLK52_406,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES640x480x120, VCLK52_406,
 	0x00, 0x24, 0x2e, 640, 480},/* 0b 640x480x120Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES640x480x160, VCLK72_852,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES640x480x160, VCLK72_852,
 	0x00, 0x24, 0x2e, 640, 480},/* 0c 640x480x160Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncNN, RES640x480x200, VCLK86_6,
+	{Mode32Bpp + SupportRAMDAC2 + SyncNN, RES640x480x200, VCLK86_6,
 	0x00, 0x24, 0x2e, 640, 480},/* 0d 640x480x200Hz */
-	{Support32Bpp + NoSupportLCD + SyncPP, RES800x600x56, VCLK36,
+	{Mode32Bpp + NoSupportLCD + SyncPP, RES800x600x56, VCLK36,
 	0x05, 0x36, 0x6a, 800, 600},/* 0e 800x600x56Hz */
-	{Support32Bpp + NoSupportTV + SyncPP, RES800x600x60, VCLK40,
+	{Mode32Bpp + NoSupportTV + SyncPP, RES800x600x60, VCLK40,
 	0x05, 0x36, 0x6a, 800, 600},/* 0f 800x600x60Hz (LCD 800x600x60Hz) */
-	{Support32Bpp + NoSupportHiVisionTV + SyncPP, RES800x600x72, VCLK50,
+	{Mode32Bpp + NoSupportHiVisionTV + SyncPP, RES800x600x72, VCLK50,
 	0x48, 0x36, 0x6a, 800, 600},/* 10 800x600x72Hz (LCD 800x600x70Hz) */
-	{Support32Bpp + NoSupportHiVisionTV + SyncPP, RES800x600x75, VCLK49_5,
+	{Mode32Bpp + NoSupportHiVisionTV + SyncPP, RES800x600x75, VCLK49_5,
 	0x8B, 0x36, 0x6a, 800, 600},/* 11 800x600x75Hz (LCD 800x600x75Hz) */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES800x600x85, VCLK56_25,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES800x600x85, VCLK56_25,
 	0x00, 0x36, 0x6a, 800, 600},/* 12 800x600x85Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES800x600x100, VCLK68_179,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES800x600x100, VCLK68_179,
 	0x00, 0x36, 0x6a, 800, 600},/* 13 800x600x100Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES800x600x120, VCLK83_95,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES800x600x120, VCLK83_95,
 	0x00, 0x36, 0x6a, 800, 600},/* 14 800x600x120Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES800x600x160, VCLK116_406,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES800x600x160, VCLK116_406,
 	0x00, 0x36, 0x6a, 800, 600},/* 15 800x600x160Hz */
-	{Support32Bpp + InterlaceMode + SyncPP, RES1024x768x43, VCLK44_9,
+	{Mode32Bpp + InterlaceMode + SyncPP, RES1024x768x43, VCLK44_9,
 	0x00, 0x47, 0x37, 1024, 768},/* 16 1024x768x43Hz */
 	/* 17 1024x768x60Hz (LCD 1024x768x60Hz) */
-	{Support32Bpp + NoSupportTV + SyncNN + SupportTV1024, RES1024x768x60,
-	VCLK65, 0x06, 0x47, 0x37, 1024, 768},
-	{Support32Bpp + NoSupportHiVisionTV + SyncNN, RES1024x768x70, VCLK75,
+	{Mode32Bpp + NoSupportTV + SyncNN + SupportTV1024, RES1024x768x60,
+	VCLK65_315, 0x06, 0x47, 0x37, 1024, 768},
+	{Mode32Bpp + NoSupportHiVisionTV + SyncNN, RES1024x768x70, VCLK75,
 	0x49, 0x47, 0x37, 1024, 768},/* 18 1024x768x70Hz (LCD 1024x768x70Hz) */
-	{Support32Bpp + NoSupportHiVisionTV + SyncPP, RES1024x768x75, VCLK78_75,
+	{Mode32Bpp + NoSupportHiVisionTV + SyncPP, RES1024x768x75, VCLK78_75,
 	0x00, 0x47, 0x37, 1024, 768},/* 19 1024x768x75Hz (LCD 1024x768x75Hz) */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES1024x768x85, VCLK94_5,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES1024x768x85, VCLK94_5,
 	0x8C, 0x47, 0x37, 1024, 768},/* 1a 1024x768x85Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES1024x768x100, VCLK113_309,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES1024x768x100, VCLK113_309,
 	0x00, 0x47, 0x37, 1024, 768},/* 1b 1024x768x100Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES1024x768x120, VCLK139_054,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES1024x768x120, VCLK139_054,
 	0x00, 0x47, 0x37, 1024, 768},/* 1c 1024x768x120Hz */
-	{Support32Bpp + SupportLCD + SyncPP, RES1280x960x60, VCLK108_2,
+	{Mode32Bpp + SupportLCD + SyncPP, RES1280x960x60, VCLK108_2_315,
 	0x08, 0x58, 0x7b, 1280, 960},/* 1d 1280x960x60Hz */
-	{Support32Bpp + InterlaceMode + SyncPP, RES1280x1024x43, VCLK78_75,
+	{Mode32Bpp + InterlaceMode + SyncPP, RES1280x1024x43, VCLK78_75,
 	0x00, 0x58, 0x3a, 1280, 1024},/* 1e 1280x1024x43Hz */
-	{Support32Bpp + NoSupportTV + SyncPP, RES1280x1024x60, VCLK108_2,
+	{Mode32Bpp + NoSupportTV + SyncPP, RES1280x1024x60, VCLK108_2_315,
 	0x07, 0x58, 0x3a, 1280, 1024},/*1f 1280x1024x60Hz (LCD 1280x1024x60Hz)*/
-	{Support32Bpp + NoSupportTV + SyncPP, RES1280x1024x75, VCLK135_5,
+	{Mode32Bpp + NoSupportTV + SyncPP, RES1280x1024x75, VCLK135_5,
 	0x00, 0x58, 0x3a, 1280, 1024},/*20 1280x1024x75Hz (LCD 1280x1024x75Hz)*/
-	{Support32Bpp + SyncPP, RES1280x1024x85, VCLK157_5,
+	{Mode32Bpp + SyncPP, RES1280x1024x85, VCLK157_5,
 	0x00, 0x58, 0x3a, 1280, 1024},/* 21 1280x1024x85Hz */
 	/* 22 1600x1200x60Hz */
-	{Support32Bpp + SupportLCD + SyncPP + SupportCRT2in301C,
+	{Mode32Bpp + SupportLCD + SyncPP + SupportCRT2in301C,
 	RES1600x1200x60, VCLK162, 0x09, 0x7A, 0x3c, 1600, 1200},
-	{Support32Bpp + SyncPP + SupportCRT2in301C, RES1600x1200x65, VCLK175,
+	{Mode32Bpp + SyncPP + SupportCRT2in301C, RES1600x1200x65, VCLK175,
 	0x00, 0x69, 0x3c, 1600, 1200},/* 23 1600x1200x65Hz */
-	{Support32Bpp + SyncPP + SupportCRT2in301C, RES1600x1200x70, VCLK189,
+	{Mode32Bpp + SyncPP + SupportCRT2in301C, RES1600x1200x70, VCLK189,
 	0x00, 0x69, 0x3c, 1600, 1200},/* 24 1600x1200x70Hz */
-	{Support32Bpp + SyncPP + SupportCRT2in301C, RES1600x1200x75, VCLK202_5,
+	{Mode32Bpp + SyncPP + SupportCRT2in301C, RES1600x1200x75, VCLK202_5,
 	0x00, 0x69, 0x3c, 1600, 1200},/* 25 1600x1200x75Hz */
-	{Support32Bpp + SyncPP, RES1600x1200x85, VCLK229_5,
+	{Mode32Bpp + SyncPP, RES1600x1200x85, VCLK229_5,
 	0x00, 0x69, 0x3c, 1600, 1200},/* 26 1600x1200x85Hz */
-	{Support32Bpp + SyncPP, RES1600x1200x100, VCLK269_655,
+	{Mode32Bpp + SyncPP, RES1600x1200x100, VCLK269_655,
 	0x00, 0x69, 0x3c, 1600, 1200},/* 27 1600x1200x100Hz */
-	{Support32Bpp + SyncPP, RES1600x1200x120, VCLK323_586,
+	{Mode32Bpp + SyncPP, RES1600x1200x120, VCLK323_586,
 	0x00, 0x69, 0x3c, 1600, 1200},/* 28 1600x1200x120Hz */
-	{Support32Bpp + SupportLCD + SyncNP, RES1920x1440x60, VCLK234,
+	{Mode32Bpp + SupportLCD + SyncNP, RES1920x1440x60, VCLK234,
 	0x00, 0x00, 0x68, 1920, 1440},/* 29 1920x1440x60Hz */
-	{Support32Bpp + SyncPN, RES1920x1440x65, VCLK254_817,
+	{Mode32Bpp + SyncPN, RES1920x1440x65, VCLK254_817,
 	0x00, 0x00, 0x68, 1920, 1440},/* 2a 1920x1440x65Hz */
-	{Support32Bpp + SyncPN, RES1920x1440x70, VCLK277_015,
+	{Mode32Bpp + SyncPN, RES1920x1440x70, VCLK277_015,
 	0x00, 0x00, 0x68, 1920, 1440},/* 2b 1920x1440x70Hz */
-	{Support32Bpp + SyncPN, RES1920x1440x75, VCLK291_132,
+	{Mode32Bpp + SyncPN, RES1920x1440x75, VCLK291_132,
 	0x00, 0x00, 0x68, 1920, 1440},/* 2c 1920x1440x75Hz */
-	{Support32Bpp + SyncPN, RES1920x1440x85, VCLK330_615,
+	{Mode32Bpp + SyncPN, RES1920x1440x85, VCLK330_615,
 	0x00, 0x00, 0x68, 1920, 1440},/* 2d 1920x1440x85Hz */
-	{Support16Bpp + SyncPN, RES1920x1440x100, VCLK388_631,
+	{Mode16Bpp + SyncPN, RES1920x1440x100, VCLK388_631,
 	0x00, 0x00, 0x68, 1920, 1440},/* 2e 1920x1440x100Hz */
-	{Support32Bpp + SupportLCD + SyncPN, RES2048x1536x60, VCLK266_952,
+	{Mode32Bpp + SupportLCD + SyncPN, RES2048x1536x60, VCLK266_952,
 	0x00, 0x00, 0x6c, 2048, 1536},/* 2f 2048x1536x60Hz */
-	{Support32Bpp + SyncPN, RES2048x1536x65, VCLK291_766,
+	{Mode32Bpp + SyncPN, RES2048x1536x65, VCLK291_766,
 	0x00, 0x00, 0x6c, 2048, 1536},/* 30 2048x1536x65Hz */
-	{Support32Bpp + SyncPN, RES2048x1536x70, VCLK315_195,
+	{Mode32Bpp + SyncPN, RES2048x1536x70, VCLK315_195,
 	0x00, 0x00, 0x6c, 2048, 1536},/* 31 2048x1536x70Hz */
-	{Support32Bpp + SyncPN, RES2048x1536x75, VCLK340_477,
+	{Mode32Bpp + SyncPN, RES2048x1536x75, VCLK340_477,
 	0x00, 0x00, 0x6c, 2048, 1536},/* 32 2048x1536x75Hz */
-	{Support16Bpp + SyncPN, RES2048x1536x85, VCLK375_847,
+	{Mode16Bpp + SyncPN, RES2048x1536x85, VCLK375_847,
 	0x00, 0x00, 0x6c, 2048, 1536},/* 33 2048x1536x85Hz */
-	{Support32Bpp + SupportHiVisionTV + SupportRAMDAC2 +
-	 SyncPP + SupportYPbPr, RES800x480x60, VCLK39_77,
+	{Mode32Bpp + SupportHiVision + SupportRAMDAC2 +
+	 SyncPP + SupportYPbPr750p, RES800x480x60, VCLK39_77,
 	 0x08, 0x00, 0x70, 800, 480},/* 34 800x480x60Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES800x480x75, VCLK49_5,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES800x480x75, VCLK49_5,
 	0x08, 0x00, 0x70, 800, 480},/* 35 800x480x75Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES800x480x85, VCLK56_25,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES800x480x85, VCLK56_25,
 	0x08, 0x00, 0x70, 800, 480},/* 36 800x480x85Hz */
-	{Support32Bpp + SupportHiVisionTV + SupportRAMDAC2 +
-	 SyncPP + SupportYPbPr, RES1024x576x60, VCLK65,
+	{Mode32Bpp + SupportHiVision + SupportRAMDAC2 +
+	 SyncPP + SupportYPbPr750p, RES1024x576x60, VCLK65_315,
 	 0x09, 0x00, 0x71, 1024, 576},/* 37 1024x576x60Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES1024x576x75, VCLK78_75,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES1024x576x75, VCLK78_75,
 	0x09, 0x00, 0x71, 1024, 576},/* 38 1024x576x75Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES1024x576x85, VCLK94_5,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES1024x576x85, VCLK94_5,
 	0x09, 0x00, 0x71, 1024, 576},/* 39 1024x576x85Hz */
-	{Support32Bpp + SupportHiVisionTV + SupportRAMDAC2 +
-	SyncPP + SupportYPbPr, RES1280x720x60, VCLK108_2,
+	{Mode32Bpp + SupportHiVision + SupportRAMDAC2 +
+	SyncPP + SupportYPbPr750p, RES1280x720x60, VCLK108_2_315,
 	0x0A, 0x00, 0x75, 1280, 720},/* 3a 1280x720x60Hz*/
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES1280x720x75, VCLK135_5,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES1280x720x75, VCLK135_5,
 	0x0A, 0x00, 0x75, 1280, 720},/* 3b 1280x720x75Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES1280x720x85, VCLK157_5,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES1280x720x85, VCLK157_5,
 	0x0A, 0x00, 0x75, 1280, 720},/* 3c 1280x720x85Hz */
-	{Support32Bpp + SupportTV + SyncNN, RES720x480x60, VCLK28_322,
+	{Mode32Bpp + SupportTV + SyncNN, RES720x480x60, VCLK28_322,
 	0x06, 0x00, 0x31,  720, 480},/* 3d 720x480x60Hz */
-	{Support32Bpp + SupportTV + SyncPP, RES720x576x56, VCLK36,
+	{Mode32Bpp + SupportTV + SyncPP, RES720x576x56, VCLK36,
 	0x06, 0x00, 0x32, 720, 576},/* 3e 720x576x56Hz */
-	{Support32Bpp + InterlaceMode + NoSupportLCD + SyncPP, RES856x480x79I,
+	{Mode32Bpp + InterlaceMode + NoSupportLCD + SyncPP, RES856x480x79I,
 	VCLK35_2, 0x00, 0x00, 0x00,  856, 480},/* 3f 856x480x79I */
-	{Support32Bpp + NoSupportLCD + SyncNN, RES856x480x60, VCLK35_2,
+	{Mode32Bpp + NoSupportLCD + SyncNN, RES856x480x60, VCLK35_2,
 	0x00, 0x00, 0x00,  856, 480},/* 40 856x480x60Hz */
-	{Support32Bpp + NoSupportHiVisionTV + SyncPP, RES1280x768x60,
+	{Mode32Bpp + NoSupportHiVisionTV + SyncPP, RES1280x768x60,
 	VCLK79_411, 0x08, 0x48, 0x23, 1280, 768},/* 41 1280x768x60Hz */
-	{Support32Bpp + NoSupportHiVisionTV + SyncPP, RES1400x1050x60,
+	{Mode32Bpp + NoSupportHiVisionTV + SyncPP, RES1400x1050x60,
 	VCLK122_61, 0x08, 0x69, 0x26, 1400, 1050},/* 42 1400x1050x60Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES1152x864x60, VCLK80_350,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES1152x864x60, VCLK80_350,
 	0x37, 0x00, 0x20, 1152, 864},/* 43 1152x864x60Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPP, RES1152x864x75, VCLK107_385,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPP, RES1152x864x75, VCLK107_385,
 	0x37, 0x00, 0x20, 1152, 864},/* 44 1152x864x75Hz */
-	{Support32Bpp + SupportLCD + SupportRAMDAC2 + SyncPP, RES1280x960x75,
+	{Mode32Bpp + SupportLCD + SupportRAMDAC2 + SyncPP, RES1280x960x75,
 	VCLK125_999, 0x3A, 0x88, 0x7b, 1280, 960},/* 45 1280x960x75Hz */
-	{Support32Bpp + SupportLCD + SupportRAMDAC2 + SyncPP, RES1280x960x85,
+	{Mode32Bpp + SupportLCD + SupportRAMDAC2 + SyncPP, RES1280x960x85,
 	VCLK148_5, 0x0A, 0x88, 0x7b, 1280, 960},/* 46 1280x960x85Hz */
-	{Support32Bpp + SupportLCD + SupportRAMDAC2 + SyncPP, RES1280x960x120,
+	{Mode32Bpp + SupportLCD + SupportRAMDAC2 + SyncPP, RES1280x960x120,
 	VCLK217_325, 0x3A, 0x88, 0x7b, 1280, 960},/* 47 1280x960x120Hz */
-	{Support32Bpp + SupportRAMDAC2 + SyncPN, RES1024x768x160, VCLK139_054,
+	{Mode32Bpp + SupportRAMDAC2 + SyncPN, RES1024x768x160, VCLK139_054,
 	0x30, 0x47, 0x37, 1024, 768},/* 48 1024x768x160Hz */
 };
 
-- 
1.7.3.4

