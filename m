Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1CMK1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:38 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39913 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1CMK01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:27 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 22/24] staging: xgifb: rename XGINew_SetRegAND() to xgifb_reg_and()
Date: Sun, 13 Mar 2011 12:26:26 +0200
Message-Id: <1300011988-2109-23-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename XGINew_SetRegAND() to xgifb_reg_and().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c    |    4 +-
 drivers/staging/xgifb/vb_setmode.c |   54 ++++++++++++++++++------------------
 drivers/staging/xgifb/vb_util.c    |    2 +-
 drivers/staging/xgifb/vb_util.h    |    2 +-
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 45491be..61d1370 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -69,7 +69,7 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 			data = 1; /* DDRII */
 		return data;
 	} else if (HwDeviceExtension->jChipType == XG21) {
-		XGINew_SetRegAND(pVBInfo->P3d4, 0xB4, ~0x02); /* Independent GPIO control */
+		xgifb_reg_and(pVBInfo->P3d4, 0xB4, ~0x02); /* Independent GPIO control */
 		udelay(800);
 		xgifb_reg_or(pVBInfo->P3d4, 0x4A, 0x80); /* Enable GPIOH read */
 		temp = xgifb_reg_get(pVBInfo->P3d4, 0x48); /* GPIOF 0:DVI 1:DVO */
@@ -1211,7 +1211,7 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 				xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0x80); /* TMDS on chip */
 			else
 				xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* Only DVO on chip */
-			XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); /* Disable read GPIOF */
+			xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20); /* Disable read GPIOF */
 		}
 #if 1
 	}
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 49791c4..8762a53 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -370,7 +370,7 @@ static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo)
 	xgifb_reg_set(pVBInfo->P3c4, 0x2B, pVBInfo->VCLKData[1].SR2B);
 	xgifb_reg_set(pVBInfo->P3c4, 0x2C, pVBInfo->VCLKData[1].SR2C);
 
-	XGINew_SetRegAND(pVBInfo->P3c4, 0x31, ~0x30);
+	xgifb_reg_and(pVBInfo->P3c4, 0x31, ~0x30);
 	return 0;
 }
 
@@ -964,8 +964,8 @@ static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 
 	xgifb_reg_or(pVBInfo->P3c4, 0x1E, 0x01); /* Negative blank polarity */
 
-	XGINew_SetRegAND(pVBInfo->P3c4, 0x30, ~0x20);
-	XGINew_SetRegAND(pVBInfo->P3c4, 0x35, ~0x80);
+	xgifb_reg_and(pVBInfo->P3c4, 0x30, ~0x20);
+	xgifb_reg_and(pVBInfo->P3c4, 0x35, ~0x80);
 
 	if (ModeNo <= 0x13) {
 		b3CC = (unsigned char) inb(XGI_P3cc);
@@ -1012,8 +1012,8 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 
 	xgifb_reg_or(pVBInfo->P3c4, 0x1E, 0x01); /* Negative blank polarity */
 
-	XGINew_SetRegAND(pVBInfo->P3c4, 0x30, ~0x20); /* Hsync polarity */
-	XGINew_SetRegAND(pVBInfo->P3c4, 0x35, ~0x80); /* Vsync polarity */
+	xgifb_reg_and(pVBInfo->P3c4, 0x30, ~0x20); /* Hsync polarity */
+	xgifb_reg_and(pVBInfo->P3c4, 0x35, ~0x80); /* Vsync polarity */
 
 	if (ModeNo <= 0x13) {
 		b3CC = (unsigned char) inb(XGI_P3cc);
@@ -1041,7 +1041,7 @@ static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVB
 {
 	int i, index = -1;
 
-	XGINew_SetRegAND(pVBInfo->P3d4, 0x11, 0x7F); /* Unlock CR0~7 */
+	xgifb_reg_and(pVBInfo->P3d4, 0x11, 0x7F); /* Unlock CR0~7 */
 	if (ModeNo <= 0x13) {
 		for (i = 0; i < 12; i++) {
 			if (ModeNo == pVBInfo->UpdateCRT1[i].ModeID)
@@ -4081,7 +4081,7 @@ static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
 	unsigned char CR4A, temp;
 
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x23); /* enable GPIO write */
+	xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x23); /* enable GPIO write */
 
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 
@@ -4102,7 +4102,7 @@ static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo)
 	unsigned char CR4A, CRB4, temp;
 
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
-	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x0C); /* enable GPIO write */
+	xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x0C); /* enable GPIO write */
 
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x48);
 
@@ -5662,10 +5662,10 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempax = (unsigned char) xgifb_reg_get(pVBInfo->Part2Port,
 				0x01);
 		tempax--;
-		XGINew_SetRegAND(pVBInfo->Part2Port, 0x01, tempax);
+		xgifb_reg_and(pVBInfo->Part2Port, 0x01, tempax);
 
 		/* if ( !( pVBInfo->VBType & VB_XGI301C ) ) */
-		XGINew_SetRegAND(pVBInfo->Part2Port, 0x00, 0xEF);
+		xgifb_reg_and(pVBInfo->Part2Port, 0x00, 0xEF);
 	}
 
 	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
@@ -5958,7 +5958,7 @@ static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 		return;
 
 #ifndef Tap4
-	XGINew_SetRegAND(pVBInfo->Part2Port, 0x4E, 0xEB); /* Disable Tap4 */
+	xgifb_reg_and(pVBInfo->Part2Port, 0x4E, 0xEB); /* Disable Tap4 */
 #else            /* Tap4 Setting */
 
 	Tap4TimingPtr = XGI_GetTap4Ptr(0, pVBInfo); /* Set Horizontal Scaling */
@@ -6292,7 +6292,7 @@ void XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	CR4A = xgifb_reg_get(pVBInfo->P3d4, 0x4A);
 	tempbh &= 0x23;
 	tempbl &= 0x23;
-	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~tempbh); /* enable GPIO write */
+	xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~tempbh); /* enable GPIO write */
 
 	if (tempbh & 0x20) {
 		temp = (tempbl >> 4) & 0x02;
@@ -6335,7 +6335,7 @@ void XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	tempbl &= 0x03;
 	tempbh <<= 2;
 	tempbl <<= 2; /* GPIOC,GPIOD */
-	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~tempbh); /* enable GPIO write */
+	xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~tempbh); /* enable GPIO write */
 	xgifb_reg_and_or(pVBInfo->P3d4, 0x48, ~tempbh, tempbl);
 }
 
@@ -6941,7 +6941,7 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			}
 		}
 
-		XGINew_SetRegAND(pVBInfo->Part4Port, 0x1F, tempah); /* disable part4_1f */
+		xgifb_reg_and(pVBInfo->Part4Port, 0x1F, tempah); /* disable part4_1f */
 
 		if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
 			if (((pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)))
@@ -6961,13 +6961,13 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
 			if ((pVBInfo->SetFlag & DisableChA) || (pVBInfo->VBInfo
 					& SetCRT2ToLCDA))
-				XGINew_SetRegAND(pVBInfo->Part1Port, 0x1e, 0xdf); /* Power down */
+				xgifb_reg_and(pVBInfo->Part1Port, 0x1e, 0xdf); /* Power down */
 		}
 
-		XGINew_SetRegAND(pVBInfo->P3c4, 0x32, 0xdf); /* disable TV as primary VGA swap */
+		xgifb_reg_and(pVBInfo->P3c4, 0x32, 0xdf); /* disable TV as primary VGA swap */
 
 		if ((pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToDualEdge)))
-			XGINew_SetRegAND(pVBInfo->Part2Port, 0x00, 0xdf);
+			xgifb_reg_and(pVBInfo->Part2Port, 0x00, 0xdf);
 
 		if ((pVBInfo->SetFlag & DisableChB) || (pVBInfo->VBInfo
 				& (DisableCRT2Display | SetSimuScanMode))
@@ -6985,14 +6985,14 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 						| SetCRT2ToLCD | SetCRT2ToTV))) {
 			tempah = xgifb_reg_get(pVBInfo->Part1Port, 0x00); /* save Part1 index 0 */
 			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x10); /* BTDAC = 1, avoid VB reset */
-			XGINew_SetRegAND(pVBInfo->Part1Port, 0x1E, 0xDF); /* disable CRT2 */
+			xgifb_reg_and(pVBInfo->Part1Port, 0x1E, 0xDF); /* disable CRT2 */
 			xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah); /* restore Part1 index 0 */
 		}
 	} else { /* {301} */
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToTV)) {
 			xgifb_reg_or(pVBInfo->Part1Port, 0x00, 0x80); /* BScreenOff=1 */
-			XGINew_SetRegAND(pVBInfo->Part1Port, 0x1E, 0xDF); /* Disable CRT2 */
-			XGINew_SetRegAND(pVBInfo->P3c4, 0x32, 0xDF); /* Disable TV asPrimary VGA swap */
+			xgifb_reg_and(pVBInfo->Part1Port, 0x1E, 0xDF); /* Disable CRT2 */
+			xgifb_reg_and(pVBInfo->P3c4, 0x32, 0xDF); /* Disable TV asPrimary VGA swap */
 		}
 
 		if (pVBInfo->VBInfo & (DisableCRT2Display | SetCRT2ToLCDA
@@ -7209,7 +7209,7 @@ static void SetSpectrum(struct vb_device_info *pVBInfo)
 
 	index = XGI_GetLCDCapPtr(pVBInfo);
 
-	XGINew_SetRegAND(pVBInfo->Part4Port, 0x30, 0x8F); /* disable down spectrum D[4] */
+	xgifb_reg_and(pVBInfo->Part4Port, 0x30, 0x8F); /* disable down spectrum D[4] */
 	XGI_LongWait(pVBInfo);
 	xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x20); /* reset spectrum */
 	XGI_LongWait(pVBInfo);
@@ -8085,7 +8085,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 					xgifb_reg_or(pVBInfo->Part1Port,
 							0x2E, 0x80); /* BVBDOENABLE = 1 */
 
-				XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F); /* BScreenOFF = 0 */
+				xgifb_reg_and(pVBInfo->Part1Port, 0x00, 0x7F); /* BScreenOFF = 0 */
 			}
 		}
 
@@ -8099,11 +8099,11 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 							|| (pVBInfo->VBInfo
 									& (SetCRT2ToLCD
 											| SetCRT2ToLCDA)))
-						XGINew_SetRegAND(
+						xgifb_reg_and(
 								pVBInfo->Part4Port,
 								0x2A, 0x7F); /* LVDS PLL power on */
 				}
-				XGINew_SetRegAND(pVBInfo->Part4Port, 0x30, 0x7F); /* LVDS Driver power on */
+				xgifb_reg_and(pVBInfo->Part4Port, 0x30, 0x7F); /* LVDS Driver power on */
 			}
 		}
 
@@ -8166,7 +8166,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		if (!(tempah & 0x80))
 			xgifb_reg_or(pVBInfo->Part1Port, 0x2E, 0x80); /* BVBDOENABLE = 1 */
 
-		XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F);
+		xgifb_reg_and(pVBInfo->Part1Port, 0x00, 0x7F);
 		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
 	} /* End of VB */
 }
@@ -8242,8 +8242,8 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 		temp = xgifb_reg_get(pVBInfo->P3d4, 0x38);
 		if (temp & 0xA0) {
 
-			/* XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); *//* Enable write GPIOF */
-			/* XGINew_SetRegAND(pVBInfo->P3d4, 0x48, ~0x20); *//* P. DWN */
+			/* xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20); *//* Enable write GPIOF */
+			/* xgifb_reg_and(pVBInfo->P3d4, 0x48, ~0x20); *//* P. DWN */
 			/* XG21 CRT1 Timing */
 			if (HwDeviceExtension->jChipType == XG27)
 				XGI_SetXG27CRTC(ModeNo, ModeIdIndex,
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 9eb8060..d8429e8 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -34,7 +34,7 @@ void xgifb_reg_and_or(unsigned long Port, unsigned short Index,
 	xgifb_reg_set(Port, Index, temp);
 }
 
-void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
+void xgifb_reg_and(unsigned long Port, unsigned short Index,
 		unsigned short DataAND)
 {
 	unsigned short temp;
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index e8e36a2..98af1c0 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -3,7 +3,7 @@
 extern void xgifb_reg_set(unsigned long, unsigned short, unsigned short);
 extern unsigned char xgifb_reg_get(unsigned long, unsigned short);
 extern void xgifb_reg_or(unsigned long, unsigned short, unsigned short);
-extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
+extern void xgifb_reg_and(unsigned long, unsigned short, unsigned short);
 extern void xgifb_reg_and_or(unsigned long, unsigned short, unsigned short, unsigned short);
 #endif
 
-- 
1.5.6.5

