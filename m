Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1CMK1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:46 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:39062 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab1CMK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:28 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 18/24] staging: xgifb: rename XGINew_SetReg1() to xgifb_reg_set()
Date: Sun, 13 Mar 2011 12:26:22 +0200
Message-Id: <1300011988-2109-19-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename XGINew_SetReg1() to xgifb_reg_set().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    2 +-
 drivers/staging/xgifb/vb_ext.c      |   16 +-
 drivers/staging/xgifb/vb_init.c     |  584 +++++++++++++++---------------
 drivers/staging/xgifb/vb_setmode.c  |  702 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_util.c     |   14 +-
 drivers/staging/xgifb/vb_util.h     |    2 +-
 6 files changed, 657 insertions(+), 663 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 3aec3f1..721bd25 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2321,7 +2321,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 					for (m = 0; m < sizeof(XGI21_LCDCapList)/sizeof(struct XGI21_LVDSCapStruct); m++) {
 						if ((XGI21_LCDCapList[m].LVDSHDE == XGIbios_mode[xgifb_mode_idx].xres) &&
 								(XGI21_LCDCapList[m].LVDSVDE == XGIbios_mode[xgifb_mode_idx].yres)) {
-							XGINew_SetReg1(XGI_Pr.P3d4, 0x36, m);
+							xgifb_reg_set(XGI_Pr.P3d4, 0x36, m);
 						}
 					}
 				}
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 5cf094a..a299864 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -31,7 +31,7 @@ static unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx,
 	unsigned short temp, i, tempch;
 
 	temp = tempbx & 0xFF;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x11, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp |= (tempcx & 0x00FF);
 	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
@@ -143,7 +143,7 @@ static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 
 		tempbx = tempbx >> 1;
 		temp = tempbx & 0x00F;
-		XGINew_SetReg1(pVBInfo->P3d4, 0x36, temp);
+		xgifb_reg_set(pVBInfo->P3d4, 0x36, temp);
 		tempbx--;
 		tempbx = PanelTypeTable[tempbx];
 
@@ -179,7 +179,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 	tempcx = 0x0604;
 
 	temp = tempbx & 0xFF;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x11, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp |= (tempcx & 0x00FF);
 	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
@@ -199,7 +199,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 
 	tempcx = 0x0804;
 	temp = tempbx & 0xFF;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x11, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp |= (tempcx & 0x00FF);
 	XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
@@ -218,7 +218,7 @@ static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtensi
 		tempbx = 0x3FF;
 		tempcx = 0x0804;
 		temp = tempbx & 0xFF;
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x11, temp);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x11, temp);
 		temp = (tempbx & 0xFF00) >> 8;
 		temp |= (tempcx & 0x00FF);
 		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x10, ~0x1F, temp);
@@ -276,7 +276,7 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 				P2reg0 = XGINew_GetReg1(pVBInfo->Part2Port, 0x00);
 				if (!XGINew_BridgeIsEnable(HwDeviceExtension, pVBInfo)) {
 					SenseModeNo = 0x2e;
-					/* XGINew_SetReg1(pVBInfo->P3d4, 0x30, 0x41); */
+					/* xgifb_reg_set(pVBInfo->P3d4, 0x30, 0x41); */
 					/* XGISetModeNew(HwDeviceExtension, 0x2e); // ynlai InitMode */
 
 					temp = XGI_SearchModeID(SenseModeNo, &ModeIdIndex, pVBInfo);
@@ -295,7 +295,7 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 					for (i = 0; i < 20; i++)
 						XGI_LongWait(pVBInfo);
 				}
-				XGINew_SetReg1(pVBInfo->Part2Port, 0x00, 0x1c);
+				xgifb_reg_set(pVBInfo->Part2Port, 0x00, 0x1c);
 				tempax = 0;
 				tempbx = *pVBInfo->pRGBSenseData;
 
@@ -366,7 +366,7 @@ void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_
 			XGINew_Sense(tempbx, tempcx, pVBInfo);
 
 			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~0xDF, tempax);
-			XGINew_SetReg1(pVBInfo->Part2Port, 0x00, P2reg0);
+			xgifb_reg_set(pVBInfo->Part2Port, 0x00, P2reg0);
 
 			if (!(P2reg0 & 0x20)) {
 				pVBInfo->VBInfo = DisableCRT2Display;
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 577f7de..07fa73d 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -94,45 +94,45 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 
 static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBInfo)
 {
-	XGINew_SetReg1(P3c4, 0x18, 0x01);
-	XGINew_SetReg1(P3c4, 0x19, 0x20);
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
+	xgifb_reg_set(P3c4, 0x18, 0x01);
+	xgifb_reg_set(P3c4, 0x19, 0x20);
+	xgifb_reg_set(P3c4, 0x16, 0x00);
+	xgifb_reg_set(P3c4, 0x16, 0x80);
 
 	if (*pVBInfo->pXGINew_DRAMTypeDefinition != 0x0C) { /* Samsung F Die */
 		mdelay(3);
-		XGINew_SetReg1(P3c4, 0x18, 0x00);
-		XGINew_SetReg1(P3c4, 0x19, 0x20);
-		XGINew_SetReg1(P3c4, 0x16, 0x00);
-		XGINew_SetReg1(P3c4, 0x16, 0x80);
+		xgifb_reg_set(P3c4, 0x18, 0x00);
+		xgifb_reg_set(P3c4, 0x19, 0x20);
+		xgifb_reg_set(P3c4, 0x16, 0x00);
+		xgifb_reg_set(P3c4, 0x16, 0x80);
 	}
 
 	udelay(60);
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	XGINew_SetReg1(P3c4, 0x19, 0x01);
-	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[0]);
-	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[1]);
+	xgifb_reg_set(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
+	xgifb_reg_set(P3c4, 0x19, 0x01);
+	xgifb_reg_set(P3c4, 0x16, pVBInfo->SR16[0]);
+	xgifb_reg_set(P3c4, 0x16, pVBInfo->SR16[1]);
 	mdelay(1);
-	XGINew_SetReg1(P3c4, 0x1B, 0x03);
+	xgifb_reg_set(P3c4, 0x1B, 0x03);
 	udelay(500);
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	XGINew_SetReg1(P3c4, 0x19, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[2]);
-	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[3]);
-	XGINew_SetReg1(P3c4, 0x1B, 0x00);
+	xgifb_reg_set(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
+	xgifb_reg_set(P3c4, 0x19, 0x00);
+	xgifb_reg_set(P3c4, 0x16, pVBInfo->SR16[2]);
+	xgifb_reg_set(P3c4, 0x16, pVBInfo->SR16[3]);
+	xgifb_reg_set(P3c4, 0x1B, 0x00);
 }
 
 static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x28, pVBInfo->MCLKData[XGINew_RAMType].SR28);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x29, pVBInfo->MCLKData[XGINew_RAMType].SR29);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2A, pVBInfo->MCLKData[XGINew_RAMType].SR2A);
+	xgifb_reg_set(pVBInfo->P3c4, 0x28, pVBInfo->MCLKData[XGINew_RAMType].SR28);
+	xgifb_reg_set(pVBInfo->P3c4, 0x29, pVBInfo->MCLKData[XGINew_RAMType].SR29);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2A, pVBInfo->MCLKData[XGINew_RAMType].SR2A);
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2E, pVBInfo->ECLKData[XGINew_RAMType].SR2E);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2F, pVBInfo->ECLKData[XGINew_RAMType].SR2F);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x30, pVBInfo->ECLKData[XGINew_RAMType].SR30);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2E, pVBInfo->ECLKData[XGINew_RAMType].SR2E);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2F, pVBInfo->ECLKData[XGINew_RAMType].SR2F);
+	xgifb_reg_set(pVBInfo->P3c4, 0x30, pVBInfo->ECLKData[XGINew_RAMType].SR30);
 
 	/* [Vicent] 2004/07/07, When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
 	/* [Hsuan] 2004/08/20, Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz, Set SR32 D[1:0] = 10b */
@@ -143,7 +143,7 @@ static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))
 					|| ((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x22)
 						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))))
-			XGINew_SetReg1(pVBInfo->P3c4, 0x32, ((unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
+			xgifb_reg_set(pVBInfo->P3c4, 0x32, ((unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
 	}
 }
 
@@ -156,67 +156,67 @@ static void XGINew_DDRII_Bootup_XG27(
 	XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
 
 	/* Set Double Frequency */
-	/* XGINew_SetReg1(P3d4, 0x97, 0x11); *//* CR97 */
-	XGINew_SetReg1(P3d4, 0x97, *pVBInfo->pXGINew_CR97); /* CR97 */
+	/* xgifb_reg_set(P3d4, 0x97, 0x11); *//* CR97 */
+	xgifb_reg_set(P3d4, 0x97, *pVBInfo->pXGINew_CR97); /* CR97 */
 
 	udelay(200);
 
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS2 */
-	XGINew_SetReg1(P3c4, 0x19, 0x80); /* Set SR19 */
-	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS2 */
+	xgifb_reg_set(P3c4, 0x19, 0x80); /* Set SR19 */
+	xgifb_reg_set(P3c4, 0x16, 0x20); /* Set SR16 */
 	udelay(15);
-	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0xA0); /* Set SR16 */
 	udelay(15);
 
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS3 */
-	XGINew_SetReg1(P3c4, 0x19, 0xC0); /* Set SR19 */
-	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS3 */
+	xgifb_reg_set(P3c4, 0x19, 0xC0); /* Set SR19 */
+	xgifb_reg_set(P3c4, 0x16, 0x20); /* Set SR16 */
 	udelay(15);
-	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0xA0); /* Set SR16 */
 	udelay(15);
 
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS1 */
-	XGINew_SetReg1(P3c4, 0x19, 0x40); /* Set SR19 */
-	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS1 */
+	xgifb_reg_set(P3c4, 0x19, 0x40); /* Set SR19 */
+	xgifb_reg_set(P3c4, 0x16, 0x20); /* Set SR16 */
 	udelay(30);
-	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0xA0); /* Set SR16 */
 	udelay(15);
 
-	XGINew_SetReg1(P3c4, 0x18, 0x42); /* Set SR18 */ /* MRS, DLL Enable */
-	XGINew_SetReg1(P3c4, 0x19, 0x0A); /* Set SR19 */
-	XGINew_SetReg1(P3c4, 0x16, 0x00); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x18, 0x42); /* Set SR18 */ /* MRS, DLL Enable */
+	xgifb_reg_set(P3c4, 0x19, 0x0A); /* Set SR19 */
+	xgifb_reg_set(P3c4, 0x16, 0x00); /* Set SR16 */
 	udelay(30);
-	XGINew_SetReg1(P3c4, 0x16, 0x00); /* Set SR16 */
-	XGINew_SetReg1(P3c4, 0x16, 0x80); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0x00); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0x80); /* Set SR16 */
 	/* udelay(15); */
 
-	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* Set SR1B */
+	xgifb_reg_set(P3c4, 0x1B, 0x04); /* Set SR1B */
 	udelay(60);
-	XGINew_SetReg1(P3c4, 0x1B, 0x00); /* Set SR1B */
+	xgifb_reg_set(P3c4, 0x1B, 0x00); /* Set SR1B */
 
-	XGINew_SetReg1(P3c4, 0x18, 0x42); /* Set SR18 */ /* MRS, DLL Reset */
-	XGINew_SetReg1(P3c4, 0x19, 0x08); /* Set SR19 */
-	XGINew_SetReg1(P3c4, 0x16, 0x00); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x18, 0x42); /* Set SR18 */ /* MRS, DLL Reset */
+	xgifb_reg_set(P3c4, 0x19, 0x08); /* Set SR19 */
+	xgifb_reg_set(P3c4, 0x16, 0x00); /* Set SR16 */
 
 	udelay(30);
-	XGINew_SetReg1(P3c4, 0x16, 0x83); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0x83); /* Set SR16 */
 	udelay(15);
 
-	XGINew_SetReg1(P3c4, 0x18, 0x80); /* Set SR18 */ /* MRS, ODT */
-	XGINew_SetReg1(P3c4, 0x19, 0x46); /* Set SR19 */
-	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x18, 0x80); /* Set SR18 */ /* MRS, ODT */
+	xgifb_reg_set(P3c4, 0x19, 0x46); /* Set SR19 */
+	xgifb_reg_set(P3c4, 0x16, 0x20); /* Set SR16 */
 	udelay(30);
-	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0xA0); /* Set SR16 */
 	udelay(15);
 
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS */
-	XGINew_SetReg1(P3c4, 0x19, 0x40); /* Set SR19 */
-	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS */
+	xgifb_reg_set(P3c4, 0x19, 0x40); /* Set SR19 */
+	xgifb_reg_set(P3c4, 0x16, 0x20); /* Set SR16 */
 	udelay(30);
-	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
+	xgifb_reg_set(P3c4, 0x16, 0xA0); /* Set SR16 */
 	udelay(15);
 
-	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* Set SR1B refresh control 000:close; 010:open */
+	xgifb_reg_set(P3c4, 0x1B, 0x04); /* Set SR1B refresh control 000:close; 010:open */
 	udelay(200);
 
 }
@@ -229,41 +229,41 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
 	XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
 
-	XGINew_SetReg1(P3d4, 0x97, 0x11); /* CR97 */
+	xgifb_reg_set(P3d4, 0x97, 0x11); /* CR97 */
 
 	udelay(200);
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* EMRS2 */
-	XGINew_SetReg1(P3c4, 0x19, 0x80);
-	XGINew_SetReg1(P3c4, 0x16, 0x05);
-	XGINew_SetReg1(P3c4, 0x16, 0x85);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* EMRS3 */
-	XGINew_SetReg1(P3c4, 0x19, 0xC0);
-	XGINew_SetReg1(P3c4, 0x16, 0x05);
-	XGINew_SetReg1(P3c4, 0x16, 0x85);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* EMRS1 */
-	XGINew_SetReg1(P3c4, 0x19, 0x40);
-	XGINew_SetReg1(P3c4, 0x16, 0x05);
-	XGINew_SetReg1(P3c4, 0x16, 0x85);
-
-	/* XGINew_SetReg1(P3c4, 0x18, 0x52); */ /* MRS1 */
-	XGINew_SetReg1(P3c4, 0x18, 0x42); /* MRS1 */
-	XGINew_SetReg1(P3c4, 0x19, 0x02);
-	XGINew_SetReg1(P3c4, 0x16, 0x05);
-	XGINew_SetReg1(P3c4, 0x16, 0x85);
+	xgifb_reg_set(P3c4, 0x18, 0x00); /* EMRS2 */
+	xgifb_reg_set(P3c4, 0x19, 0x80);
+	xgifb_reg_set(P3c4, 0x16, 0x05);
+	xgifb_reg_set(P3c4, 0x16, 0x85);
+
+	xgifb_reg_set(P3c4, 0x18, 0x00); /* EMRS3 */
+	xgifb_reg_set(P3c4, 0x19, 0xC0);
+	xgifb_reg_set(P3c4, 0x16, 0x05);
+	xgifb_reg_set(P3c4, 0x16, 0x85);
+
+	xgifb_reg_set(P3c4, 0x18, 0x00); /* EMRS1 */
+	xgifb_reg_set(P3c4, 0x19, 0x40);
+	xgifb_reg_set(P3c4, 0x16, 0x05);
+	xgifb_reg_set(P3c4, 0x16, 0x85);
+
+	/* xgifb_reg_set(P3c4, 0x18, 0x52); */ /* MRS1 */
+	xgifb_reg_set(P3c4, 0x18, 0x42); /* MRS1 */
+	xgifb_reg_set(P3c4, 0x19, 0x02);
+	xgifb_reg_set(P3c4, 0x16, 0x05);
+	xgifb_reg_set(P3c4, 0x16, 0x85);
 
 	udelay(15);
-	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* SR1B */
+	xgifb_reg_set(P3c4, 0x1B, 0x04); /* SR1B */
 	udelay(30);
-	XGINew_SetReg1(P3c4, 0x1B, 0x00); /* SR1B */
+	xgifb_reg_set(P3c4, 0x1B, 0x00); /* SR1B */
 	udelay(100);
 
-	/* XGINew_SetReg1(P3c4 ,0x18, 0x52); */ /* MRS2 */
-	XGINew_SetReg1(P3c4, 0x18, 0x42); /* MRS1 */
-	XGINew_SetReg1(P3c4, 0x19, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x05);
-	XGINew_SetReg1(P3c4, 0x16, 0x85);
+	/* xgifb_reg_set(P3c4 ,0x18, 0x52); */ /* MRS2 */
+	xgifb_reg_set(P3c4, 0x18, 0x42); /* MRS1 */
+	xgifb_reg_set(P3c4, 0x19, 0x00);
+	xgifb_reg_set(P3c4, 0x16, 0x05);
+	xgifb_reg_set(P3c4, 0x16, 0x85);
 
 	udelay(200);
 }
@@ -271,31 +271,31 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
 {
 
-	XGINew_SetReg1(P3c4, 0x18, 0x01);
-	XGINew_SetReg1(P3c4, 0x19, 0x40);
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
+	xgifb_reg_set(P3c4, 0x18, 0x01);
+	xgifb_reg_set(P3c4, 0x19, 0x40);
+	xgifb_reg_set(P3c4, 0x16, 0x00);
+	xgifb_reg_set(P3c4, 0x16, 0x80);
 	udelay(60);
 
-	XGINew_SetReg1(P3c4, 0x18, 0x00);
-	XGINew_SetReg1(P3c4, 0x19, 0x40);
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
+	xgifb_reg_set(P3c4, 0x18, 0x00);
+	xgifb_reg_set(P3c4, 0x19, 0x40);
+	xgifb_reg_set(P3c4, 0x16, 0x00);
+	xgifb_reg_set(P3c4, 0x16, 0x80);
 	udelay(60);
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
-	XGINew_SetReg1(P3c4, 0x19, 0x01);
-	XGINew_SetReg1(P3c4, 0x16, 0x03);
-	XGINew_SetReg1(P3c4, 0x16, 0x83);
+	xgifb_reg_set(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
+	/* xgifb_reg_set(P3c4, 0x18, 0x31); */
+	xgifb_reg_set(P3c4, 0x19, 0x01);
+	xgifb_reg_set(P3c4, 0x16, 0x03);
+	xgifb_reg_set(P3c4, 0x16, 0x83);
 	mdelay(1);
-	XGINew_SetReg1(P3c4, 0x1B, 0x03);
+	xgifb_reg_set(P3c4, 0x1B, 0x03);
 	udelay(500);
-	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	XGINew_SetReg1(P3c4, 0x19, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x03);
-	XGINew_SetReg1(P3c4, 0x16, 0x83);
-	XGINew_SetReg1(P3c4, 0x1B, 0x00);
+	/* xgifb_reg_set(P3c4, 0x18, 0x31); */
+	xgifb_reg_set(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
+	xgifb_reg_set(P3c4, 0x19, 0x00);
+	xgifb_reg_set(P3c4, 0x16, 0x03);
+	xgifb_reg_set(P3c4, 0x16, 0x83);
+	xgifb_reg_set(P3c4, 0x1B, 0x00);
 }
 
 static void XGINew_DDR1x_DefaultRegister(
@@ -306,12 +306,12 @@ static void XGINew_DDR1x_DefaultRegister(
 
 	if (HwDeviceExtension->jChipType >= XG20) {
 		XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
-		XGINew_SetReg1(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
-		XGINew_SetReg1(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-		XGINew_SetReg1(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
+		xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
+		xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
+		xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
 
-		XGINew_SetReg1(P3d4, 0x98, 0x01);
-		XGINew_SetReg1(P3d4, 0x9A, 0x02);
+		xgifb_reg_set(P3d4, 0x98, 0x01);
+		xgifb_reg_set(P3d4, 0x9A, 0x02);
 
 		XGINew_DDR1x_MRS_XG20(P3c4, pVBInfo);
 	} else {
@@ -320,30 +320,30 @@ static void XGINew_DDR1x_DefaultRegister(
 		switch (HwDeviceExtension->jChipType) {
 		case XG41:
 		case XG42:
-			XGINew_SetReg1(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
-			XGINew_SetReg1(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-			XGINew_SetReg1(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
+			xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
+			xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
+			xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
 			break;
 		default:
-			XGINew_SetReg1(P3d4, 0x82, 0x88);
-			XGINew_SetReg1(P3d4, 0x86, 0x00);
+			xgifb_reg_set(P3d4, 0x82, 0x88);
+			xgifb_reg_set(P3d4, 0x86, 0x00);
 			XGINew_GetReg1(P3d4, 0x86); /* Insert read command for delay */
-			XGINew_SetReg1(P3d4, 0x86, 0x88);
+			xgifb_reg_set(P3d4, 0x86, 0x88);
 			XGINew_GetReg1(P3d4, 0x86);
-			XGINew_SetReg1(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]);
-			XGINew_SetReg1(P3d4, 0x82, 0x77);
-			XGINew_SetReg1(P3d4, 0x85, 0x00);
+			xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]);
+			xgifb_reg_set(P3d4, 0x82, 0x77);
+			xgifb_reg_set(P3d4, 0x85, 0x00);
 			XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
-			XGINew_SetReg1(P3d4, 0x85, 0x88);
+			xgifb_reg_set(P3d4, 0x85, 0x88);
 			XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
-			XGINew_SetReg1(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-			XGINew_SetReg1(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
+			xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
+			xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
 			break;
 		}
 
-		XGINew_SetReg1(P3d4, 0x97, 0x00);
-		XGINew_SetReg1(P3d4, 0x98, 0x01);
-		XGINew_SetReg1(P3d4, 0x9A, 0x02);
+		xgifb_reg_set(P3d4, 0x97, 0x00);
+		xgifb_reg_set(P3d4, 0x98, 0x01);
+		xgifb_reg_set(P3d4, 0x9A, 0x02);
 		XGINew_DDR1x_MRS_340(P3c4, pVBInfo);
 	}
 }
@@ -355,25 +355,25 @@ static void XGINew_DDR2_DefaultRegister(
 	unsigned long P3d4 = Port, P3c4 = Port - 0x10;
 
 	/* keep following setting sequence, each setting in the same reg insert idle */
-	XGINew_SetReg1(P3d4, 0x82, 0x77);
-	XGINew_SetReg1(P3d4, 0x86, 0x00);
+	xgifb_reg_set(P3d4, 0x82, 0x77);
+	xgifb_reg_set(P3d4, 0x86, 0x00);
 	XGINew_GetReg1(P3d4, 0x86); /* Insert read command for delay */
-	XGINew_SetReg1(P3d4, 0x86, 0x88);
+	xgifb_reg_set(P3d4, 0x86, 0x88);
 	XGINew_GetReg1(P3d4, 0x86); /* Insert read command for delay */
-	XGINew_SetReg1(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
-	XGINew_SetReg1(P3d4, 0x82, 0x77);
-	XGINew_SetReg1(P3d4, 0x85, 0x00);
+	xgifb_reg_set(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
+	xgifb_reg_set(P3d4, 0x82, 0x77);
+	xgifb_reg_set(P3d4, 0x85, 0x00);
 	XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
-	XGINew_SetReg1(P3d4, 0x85, 0x88);
+	xgifb_reg_set(P3d4, 0x85, 0x88);
 	XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
-	XGINew_SetReg1(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
+	xgifb_reg_set(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
 	if (HwDeviceExtension->jChipType == XG27)
-		XGINew_SetReg1(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
+		xgifb_reg_set(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
 	else
-		XGINew_SetReg1(P3d4, 0x82, 0xA8); /* CR82 */
+		xgifb_reg_set(P3d4, 0x82, 0xA8); /* CR82 */
 
-	XGINew_SetReg1(P3d4, 0x98, 0x01);
-	XGINew_SetReg1(P3d4, 0x9A, 0x02);
+	xgifb_reg_set(P3d4, 0x98, 0x01);
+	xgifb_reg_set(P3d4, 0x9A, 0x02);
 	if (HwDeviceExtension->jChipType == XG27)
 		XGINew_DDRII_Bootup_XG27(HwDeviceExtension, P3c4, pVBInfo);
 	else
@@ -388,10 +388,10 @@ static void XGINew_SetDRAMDefaultRegister340(
 
 	unsigned long P3d4 = Port, P3c4 = Port - 0x10;
 
-	XGINew_SetReg1(P3d4, 0x6D, pVBInfo->CR40[8][XGINew_RAMType]);
-	XGINew_SetReg1(P3d4, 0x68, pVBInfo->CR40[5][XGINew_RAMType]);
-	XGINew_SetReg1(P3d4, 0x69, pVBInfo->CR40[6][XGINew_RAMType]);
-	XGINew_SetReg1(P3d4, 0x6A, pVBInfo->CR40[7][XGINew_RAMType]);
+	xgifb_reg_set(P3d4, 0x6D, pVBInfo->CR40[8][XGINew_RAMType]);
+	xgifb_reg_set(P3d4, 0x68, pVBInfo->CR40[5][XGINew_RAMType]);
+	xgifb_reg_set(P3d4, 0x69, pVBInfo->CR40[6][XGINew_RAMType]);
+	xgifb_reg_set(P3d4, 0x6A, pVBInfo->CR40[7][XGINew_RAMType]);
 
 	temp2 = 0;
 	for (i = 0; i < 4; i++) {
@@ -399,7 +399,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 		for (j = 0; j < 4; j++) {
 			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
 			temp2 |= temp1;
-			XGINew_SetReg1(P3d4, 0x6B, temp2);
+			xgifb_reg_set(P3d4, 0x6B, temp2);
 			XGINew_GetReg1(P3d4, 0x6B); /* Insert read command for delay */
 			temp2 &= 0xF0;
 			temp2 += 0x10;
@@ -412,7 +412,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 		for (j = 0; j < 4; j++) {
 			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
 			temp2 |= temp1;
-			XGINew_SetReg1(P3d4, 0x6E, temp2);
+			xgifb_reg_set(P3d4, 0x6E, temp2);
 			XGINew_GetReg1(P3d4, 0x6E); /* Insert read command for delay */
 			temp2 &= 0xF0;
 			temp2 += 0x10;
@@ -428,7 +428,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 			for (j = 0; j < 4; j++) {
 				temp1 = (temp >> (2 * j)) & 0x03;
 				temp2 |= temp1;
-				XGINew_SetReg1(P3d4, 0x6F, temp2);
+				xgifb_reg_set(P3d4, 0x6F, temp2);
 				XGINew_GetReg1(P3d4, 0x6F); /* Insert read command for delay */
 				temp2 &= 0xF8;
 				temp2 += 0x08;
@@ -437,15 +437,15 @@ static void XGINew_SetDRAMDefaultRegister340(
 		temp3 += 0x01;
 	}
 
-	XGINew_SetReg1(P3d4, 0x80, pVBInfo->CR40[9][XGINew_RAMType]); /* CR80 */
-	XGINew_SetReg1(P3d4, 0x81, pVBInfo->CR40[10][XGINew_RAMType]); /* CR81 */
+	xgifb_reg_set(P3d4, 0x80, pVBInfo->CR40[9][XGINew_RAMType]); /* CR80 */
+	xgifb_reg_set(P3d4, 0x81, pVBInfo->CR40[10][XGINew_RAMType]); /* CR81 */
 
 	temp2 = 0x80;
 	temp = pVBInfo->CR89[XGINew_RAMType][0]; /* CR89 terminator type select */
 	for (j = 0; j < 4; j++) {
 		temp1 = (temp >> (2 * j)) & 0x03;
 		temp2 |= temp1;
-		XGINew_SetReg1(P3d4, 0x89, temp2);
+		xgifb_reg_set(P3d4, 0x89, temp2);
 		XGINew_GetReg1(P3d4, 0x89); /* Insert read command for delay */
 		temp2 &= 0xF0;
 		temp2 += 0x10;
@@ -454,59 +454,59 @@ static void XGINew_SetDRAMDefaultRegister340(
 	temp = pVBInfo->CR89[XGINew_RAMType][1];
 	temp1 = temp & 0x03;
 	temp2 |= temp1;
-	XGINew_SetReg1(P3d4, 0x89, temp2);
+	xgifb_reg_set(P3d4, 0x89, temp2);
 
 	temp = pVBInfo->CR40[3][XGINew_RAMType];
 	temp1 = temp & 0x0F;
 	temp2 = (temp >> 4) & 0x07;
 	temp3 = temp & 0x80;
-	XGINew_SetReg1(P3d4, 0x45, temp1); /* CR45 */
-	XGINew_SetReg1(P3d4, 0x99, temp2); /* CR99 */
+	xgifb_reg_set(P3d4, 0x45, temp1); /* CR45 */
+	xgifb_reg_set(P3d4, 0x99, temp2); /* CR99 */
 	XGINew_SetRegOR(P3d4, 0x40, temp3); /* CR40_D[7] */
-	XGINew_SetReg1(P3d4, 0x41, pVBInfo->CR40[0][XGINew_RAMType]); /* CR41 */
+	xgifb_reg_set(P3d4, 0x41, pVBInfo->CR40[0][XGINew_RAMType]); /* CR41 */
 
 	if (HwDeviceExtension->jChipType == XG27)
-		XGINew_SetReg1(P3d4, 0x8F, *pVBInfo->pCR8F); /* CR8F */
+		xgifb_reg_set(P3d4, 0x8F, *pVBInfo->pCR8F); /* CR8F */
 
 	for (j = 0; j <= 6; j++)
-		XGINew_SetReg1(P3d4, (0x90 + j),
+		xgifb_reg_set(P3d4, (0x90 + j),
 				pVBInfo->CR40[14 + j][XGINew_RAMType]); /* CR90 - CR96 */
 
 	for (j = 0; j <= 2; j++)
-		XGINew_SetReg1(P3d4, (0xC3 + j),
+		xgifb_reg_set(P3d4, (0xC3 + j),
 				pVBInfo->CR40[21 + j][XGINew_RAMType]); /* CRC3 - CRC5 */
 
 	for (j = 0; j < 2; j++)
-		XGINew_SetReg1(P3d4, (0x8A + j),
+		xgifb_reg_set(P3d4, (0x8A + j),
 				pVBInfo->CR40[1 + j][XGINew_RAMType]); /* CR8A - CR8B */
 
 	if ((HwDeviceExtension->jChipType == XG41) || (HwDeviceExtension->jChipType == XG42))
-		XGINew_SetReg1(P3d4, 0x8C, 0x87);
+		xgifb_reg_set(P3d4, 0x8C, 0x87);
 
-	XGINew_SetReg1(P3d4, 0x59, pVBInfo->CR40[4][XGINew_RAMType]); /* CR59 */
+	xgifb_reg_set(P3d4, 0x59, pVBInfo->CR40[4][XGINew_RAMType]); /* CR59 */
 
-	XGINew_SetReg1(P3d4, 0x83, 0x09); /* CR83 */
-	XGINew_SetReg1(P3d4, 0x87, 0x00); /* CR87 */
-	XGINew_SetReg1(P3d4, 0xCF, *pVBInfo->pCRCF); /* CRCF */
+	xgifb_reg_set(P3d4, 0x83, 0x09); /* CR83 */
+	xgifb_reg_set(P3d4, 0x87, 0x00); /* CR87 */
+	xgifb_reg_set(P3d4, 0xCF, *pVBInfo->pCRCF); /* CRCF */
 	if (XGINew_RAMType) {
-		/* XGINew_SetReg1(P3c4, 0x17, 0xC0); */ /* SR17 DDRII */
-		XGINew_SetReg1(P3c4, 0x17, 0x80); /* SR17 DDRII */
+		/* xgifb_reg_set(P3c4, 0x17, 0xC0); */ /* SR17 DDRII */
+		xgifb_reg_set(P3c4, 0x17, 0x80); /* SR17 DDRII */
 		if (HwDeviceExtension->jChipType == XG27)
-			XGINew_SetReg1(P3c4, 0x17, 0x02); /* SR17 DDRII */
+			xgifb_reg_set(P3c4, 0x17, 0x02); /* SR17 DDRII */
 
 	} else {
-		XGINew_SetReg1(P3c4, 0x17, 0x00); /* SR17 DDR */
+		xgifb_reg_set(P3c4, 0x17, 0x00); /* SR17 DDR */
 	}
-	XGINew_SetReg1(P3c4, 0x1A, 0x87); /* SR1A */
+	xgifb_reg_set(P3c4, 0x1A, 0x87); /* SR1A */
 
 	temp = XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
 	if (temp == 0) {
 		XGINew_DDR1x_DefaultRegister(HwDeviceExtension, P3d4, pVBInfo);
 	} else {
-		XGINew_SetReg1(P3d4, 0xB0, 0x80); /* DDRII Dual frequency mode */
+		xgifb_reg_set(P3d4, 0xB0, 0x80); /* DDRII Dual frequency mode */
 		XGINew_DDR2_DefaultRegister(HwDeviceExtension, P3d4, pVBInfo);
 	}
-	XGINew_SetReg1(P3c4, 0x1B, pVBInfo->SR15[3][XGINew_RAMType]); /* SR1B */
+	xgifb_reg_set(P3c4, 0x1B, pVBInfo->SR15[3][XGINew_RAMType]); /* SR1B */
 }
 
 static void XGINew_SetDRAMSizingType(int index,
@@ -550,11 +550,11 @@ static unsigned short XGINew_SetDRAMSizeReg(int index,
 		memsize = data >> 4;
 
 		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, (XGINew_GetReg1(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
+		xgifb_reg_set(pVBInfo->P3c4, 0x14, (XGINew_GetReg1(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
 
 		/* data |= XGINew_ChannelAB << 2; */
 		/* data |= (XGINew_DataBusWidth / 64) << 1; */
-		/* XGINew_SetReg1(pVBInfo->P3c4, 0x14, data); */
+		/* xgifb_reg_set(pVBInfo->P3c4, 0x14, data); */
 
 		/* should delay */
 		/* XGINew_SetDRAMModeRegister340(pVBInfo); */
@@ -591,12 +591,12 @@ static unsigned short XGINew_SetDRAMSize20Reg(int index,
 		memsize = data >> 4;
 
 		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, (XGINew_GetReg1(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
+		xgifb_reg_set(pVBInfo->P3c4, 0x14, (XGINew_GetReg1(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
 		udelay(15);
 
 		/* data |= XGINew_ChannelAB << 2; */
 		/* data |= (XGINew_DataBusWidth / 64) << 1; */
-		/* XGINew_SetReg1(pVBInfo->P3c4, 0x14, data); */
+		/* xgifb_reg_set(pVBInfo->P3c4, 0x14, data); */
 
 		/* should delay */
 		/* XGINew_SetDRAMModeRegister340(pVBInfo); */
@@ -665,16 +665,16 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 					> 0x1000000) {
 
 				XGINew_DataBusWidth = 32; /* 32 bits */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 32bit */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x52);
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 32bit */
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x52);
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 					return;
 
 				if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x800000) {
-					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31); /* 22bit + 1 rank + 32bit */
-					XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x42);
+					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31); /* 22bit + 1 rank + 32bit */
+					xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x42);
 					udelay(15);
 
 					if (XGINew_ReadWriteRest(23, 23, pVBInfo) == 1)
@@ -684,14 +684,14 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 
 			if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x800000) {
 				XGINew_DataBusWidth = 16; /* 16 bits */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 16bit */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x41);
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 16bit */
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x41);
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 					return;
 				else
-					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31);
+					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31);
 				udelay(15);
 			}
 
@@ -699,16 +699,16 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 			if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x800000) {
 
 				XGINew_DataBusWidth = 16; /* 16 bits */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x41); /* 0x41:16Mx16 bit*/
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x41); /* 0x41:16Mx16 bit*/
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 					return;
 
 				if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x400000) {
-					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
-					XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x31); /* 0x31:8Mx16 bit*/
+					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
+					xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x31); /* 0x31:8Mx16 bit*/
 					udelay(15);
 
 					if (XGINew_ReadWriteRest(22, 22, pVBInfo) == 1)
@@ -718,14 +718,14 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 
 			if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x400000) {
 				XGINew_DataBusWidth = 8; /* 8 bits */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x30); /* 0x30:8Mx8 bit*/
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x30); /* 0x30:8Mx8 bit*/
 				udelay(15);
 
 				if (XGINew_ReadWriteRest(22, 21, pVBInfo) == 1)
 					return;
 				else
-					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
+					xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
 				udelay(15);
 			}
 		}
@@ -734,76 +734,76 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 	case XG27:
 		XGINew_DataBusWidth = 16; /* 16 bits */
 		XGINew_ChannelAB = 1; /* Single channel */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x51); /* 32Mx16 bit*/
+		xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x51); /* 32Mx16 bit*/
 		break;
 	case XG41:
 		if (XGINew_CheckFrequence(pVBInfo) == 1) {
 			XGINew_DataBusWidth = 32; /* 32 bits */
 			XGINew_ChannelAB = 3; /* Quad Channel */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xA1);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x4C);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xA1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x4C);
 
 			if (XGINew_ReadWriteRest(25, 23, pVBInfo) == 1)
 				return;
 
 			XGINew_ChannelAB = 2; /* Dual channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x48);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x48);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x49);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x49);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
 			XGINew_ChannelAB = 3;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x21);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x3C);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x21);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x3C);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x38);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x38);
 
 			if (XGINew_ReadWriteRest(8, 4, pVBInfo) == 1)
 				return;
 			else
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x39);
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x39);
 		} else { /* DDR */
 			XGINew_DataBusWidth = 64; /* 64 bits */
 			XGINew_ChannelAB = 2; /* Dual channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xA1);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x5A);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xA1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x5A);
 
 			if (XGINew_ReadWriteRest(25, 24, pVBInfo) == 1)
 				return;
 
 			XGINew_ChannelAB = 1; /* Single channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x52);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x52);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x53);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x53);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
 			XGINew_ChannelAB = 2; /* Dual channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x21);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x4A);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x21);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x4A);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
 			XGINew_ChannelAB = 1; /* Single channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x42);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x42);
 
 			if (XGINew_ReadWriteRest(8, 4, pVBInfo) == 1)
 				return;
 			else
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x43);
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x43);
 		}
 
 		break;
@@ -819,38 +819,38 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 		if (XGINew_CheckFrequence(pVBInfo) == 1) { /* DDRII, DDR2x */
 			XGINew_DataBusWidth = 32; /* 32 bits */
 			XGINew_ChannelAB = 2; /* 2 Channel */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xA1);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x44);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xA1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x44);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x21);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x34);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x21);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x34);
 			if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 				return;
 
 			XGINew_ChannelAB = 1; /* Single Channel */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xA1);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x40);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xA1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x40);
 
 			if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 				return;
 			else {
-				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x21);
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x30);
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x21);
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x30);
 			}
 		} else { /* DDR */
 			XGINew_DataBusWidth = 64; /* 64 bits */
 			XGINew_ChannelAB = 1; /* 1 channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xA1);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x52);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xA1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x52);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 			else {
-				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x21);
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x42);
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x21);
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x42);
 			}
 		}
 
@@ -861,38 +861,38 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 		if (XGINew_CheckFrequence(pVBInfo) == 1) { /* DDRII */
 			XGINew_DataBusWidth = 32; /* 32 bits */
 			XGINew_ChannelAB = 3;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xA1);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x4C);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xA1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x4C);
 
 			if (XGINew_ReadWriteRest(25, 23, pVBInfo) == 1)
 				return;
 
 			XGINew_ChannelAB = 2; /* 2 channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x48);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x48);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 				return;
 
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x21);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x3C);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x21);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x3C);
 
 			if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1) {
 				XGINew_ChannelAB = 3; /* 4 channels */
 			} else {
 				XGINew_ChannelAB = 2; /* 2 channels */
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x38);
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x38);
 			}
 		} else { /* DDR */
 			XGINew_DataBusWidth = 64; /* 64 bits */
 			XGINew_ChannelAB = 2; /* 2 channels */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xA1);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x5A);
+			xgifb_reg_set(pVBInfo->P3c4, 0x13, 0xA1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x5A);
 
 			if (XGINew_ReadWriteRest(25, 24, pVBInfo) == 1) {
 				return;
 			} else {
-				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x21);
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x4A);
+				xgifb_reg_set(pVBInfo->P3c4, 0x13, 0x21);
+				xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x4A);
 			}
 		}
 		break;
@@ -905,8 +905,8 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 	int i;
 	unsigned short memsize, addr;
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x15, 0x00); /* noninterleaving */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1C, 0x00); /* nontiling */
+	xgifb_reg_set(pVBInfo->P3c4, 0x15, 0x00); /* noninterleaving */
+	xgifb_reg_set(pVBInfo->P3c4, 0x1C, 0x00); /* nontiling */
 	XGINew_CheckChannel(HwDeviceExtension, pVBInfo);
 
 	if (HwDeviceExtension->jChipType >= XG20) {
@@ -953,15 +953,15 @@ static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 	XGISetModeNew(HwDeviceExtension, 0x2e);
 
 	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF)); /* disable read cache */
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF)); /* disable read cache */
 	XGI_DisplayOff(HwDeviceExtension, pVBInfo);
 
 	/* data = XGINew_GetReg1(pVBInfo->P3c4, 0x1); */
 	/* data |= 0x20 ; */
-	/* XGINew_SetReg1(pVBInfo->P3c4, 0x01, data); *//* Turn OFF Display */
+	/* xgifb_reg_set(pVBInfo->P3c4, 0x01, data); *//* Turn OFF Display */
 	XGINew_DDRSizing340(HwDeviceExtension, pVBInfo);
 	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
 }
 
 static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo)
@@ -1098,8 +1098,8 @@ static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 
 	tempbx &= tempcx;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x3d, (tempbx & 0x00FF));
-	XGINew_SetReg1(pVBInfo->P3d4, 0x3e, ((tempbx & 0xFF00) >> 8));
+	xgifb_reg_set(pVBInfo->P3d4, 0x3d, (tempbx & 0x00FF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x3e, ((tempbx & 0xFF00) >> 8));
 }
 
 static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
@@ -1166,7 +1166,7 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 		tempcl ^= (SetSimuScanMode | SwitchToCRT2);
 	if ((temp & ActiveLCD) && (temp & ActiveTV))
 		tempcl ^= (SetSimuScanMode | SwitchToCRT2);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x30, tempcl);
+	xgifb_reg_set(pVBInfo->P3d4, 0x30, tempcl);
 
 	CR31Data = XGINew_GetReg1(pVBInfo->P3d4, 0x31);
 	CR31Data &= ~(SetNotSimuMode >> 8);
@@ -1175,12 +1175,12 @@ static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 	CR31Data &= ~(DisableCRT2Display >> 8);
 	if (!((temp & ActiveLCD) || (temp & ActiveTV) || (temp & ActiveCRT2)))
 		CR31Data |= (DisableCRT2Display >> 8);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x31, CR31Data);
+	xgifb_reg_set(pVBInfo->P3d4, 0x31, CR31Data);
 
 	CR38Data = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
 	CR38Data &= ~SetYPbPr;
 	CR38Data |= tempch;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x38, CR38Data);
+	xgifb_reg_set(pVBInfo->P3d4, 0x38, CR38Data);
 
 }
 
@@ -1227,12 +1227,12 @@ static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
 	bCR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x4A, ~0x07, 0x07); /* Enable GPIOA/B/C read  */
 	Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48) & 0x07;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, bCR4A);
+	xgifb_reg_set(pVBInfo->P3d4, 0x4A, bCR4A);
 
 	if (Temp <= 0x02) {
 		pVBInfo->IF_DEF_LVDS = 1;
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0); /* LVDS setting */
-		XGINew_SetReg1(pVBInfo->P3d4, 0x30, 0x21);
+		xgifb_reg_set(pVBInfo->P3d4, 0x30, 0x21);
 	} else {
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x38, ~0xE0, 0xA0); /* TMDS/DVO setting */
 	}
@@ -1254,7 +1254,7 @@ static unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo)
 		temp >>= 3;
 	}
 
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
+	xgifb_reg_set(pVBInfo->P3d4, 0x4A, CR4A);
 
 	return temp;
 }
@@ -1271,7 +1271,7 @@ static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
 	else
 		temp = ((temp & 0x04) >> 1) || ((~temp) & 0x01);
 
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
+	xgifb_reg_set(pVBInfo->P3d4, 0x4A, CR4A);
 
 	return temp;
 }
@@ -1352,7 +1352,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	ReadVBIOSTablData(HwDeviceExtension->jChipType, pVBInfo);
 
 	/* 1.Openkey */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
+	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
 	printk("6");
 
 	/* GetXG21Sense (GPIO) */
@@ -1367,33 +1367,33 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	/* 2.Reset Extended register */
 
 	for (i = 0x06; i < 0x20; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
+		xgifb_reg_set(pVBInfo->P3c4, i, 0);
 
 	for (i = 0x21; i <= 0x27; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
+		xgifb_reg_set(pVBInfo->P3c4, i, 0);
 
 	/* for(i = 0x06; i <= 0x27; i++) */
-	/* XGINew_SetReg1(pVBInfo->P3c4, i, 0); */
+	/* xgifb_reg_set(pVBInfo->P3c4, i, 0); */
 
 	printk("8");
 
 	for (i = 0x31; i <= 0x3B; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
+		xgifb_reg_set(pVBInfo->P3c4, i, 0);
 	printk("9");
 
 	if (HwDeviceExtension->jChipType == XG42) /* [Hsuan] 2004/08/20 Auto over driver for XG42 */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x3B, 0xC0);
+		xgifb_reg_set(pVBInfo->P3c4, 0x3B, 0xC0);
 
 	/* for (i = 0x30; i <= 0x3F; i++) */
-	/* XGINew_SetReg1(pVBInfo->P3d4, i, 0); */
+	/* xgifb_reg_set(pVBInfo->P3d4, i, 0); */
 
 	for (i = 0x79; i <= 0x7C; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, i, 0); /* shampoo 0208 */
+		xgifb_reg_set(pVBInfo->P3d4, i, 0); /* shampoo 0208 */
 
 	printk("10");
 
 	if (HwDeviceExtension->jChipType >= XG20)
-		XGINew_SetReg1(pVBInfo->P3d4, 0x97, *pVBInfo->pXGINew_CR97);
+		xgifb_reg_set(pVBInfo->P3d4, 0x97, *pVBInfo->pXGINew_CR97);
 
 	/* 3.SetMemoryClock
 
@@ -1403,21 +1403,21 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	printk("11");
 
 	/* 4.SetDefExt1Regs begin */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x07, *pVBInfo->pSR07);
+	xgifb_reg_set(pVBInfo->P3c4, 0x07, *pVBInfo->pSR07);
 	if (HwDeviceExtension->jChipType == XG27) {
-		XGINew_SetReg1(pVBInfo->P3c4, 0x40, *pVBInfo->pSR40);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x41, *pVBInfo->pSR41);
+		xgifb_reg_set(pVBInfo->P3c4, 0x40, *pVBInfo->pSR40);
+		xgifb_reg_set(pVBInfo->P3c4, 0x41, *pVBInfo->pSR41);
 	}
-	XGINew_SetReg1(pVBInfo->P3c4, 0x11, 0x0F);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, *pVBInfo->pSR1F);
-	/* XGINew_SetReg1(pVBInfo->P3c4, 0x20, 0x20); */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x20, 0xA0); /* alan, 2001/6/26 Frame buffer can read/write SR20 */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x36, 0x70); /* Hsuan, 2006/01/01 H/W request for slow corner chip */
+	xgifb_reg_set(pVBInfo->P3c4, 0x11, 0x0F);
+	xgifb_reg_set(pVBInfo->P3c4, 0x1F, *pVBInfo->pSR1F);
+	/* xgifb_reg_set(pVBInfo->P3c4, 0x20, 0x20); */
+	xgifb_reg_set(pVBInfo->P3c4, 0x20, 0xA0); /* alan, 2001/6/26 Frame buffer can read/write SR20 */
+	xgifb_reg_set(pVBInfo->P3c4, 0x36, 0x70); /* Hsuan, 2006/01/01 H/W request for slow corner chip */
 	if (HwDeviceExtension->jChipType == XG27) /* Alan 12/07/2006 */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x36, *pVBInfo->pSR36);
+		xgifb_reg_set(pVBInfo->P3c4, 0x36, *pVBInfo->pSR36);
 
 	/* SR11 = 0x0F; */
-	/* XGINew_SetReg1(pVBInfo->P3c4, 0x11, SR11); */
+	/* xgifb_reg_set(pVBInfo->P3c4, 0x11, SR11); */
 
 	printk("12");
 
@@ -1437,18 +1437,18 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 			GraphicVendorID &= 0x0000FFFF;
 
 			if (ChipsetID == 0x7301039)
-				XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x09);
+				xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x09);
 
 			ChipsetID &= 0x0000FFFF;
 
 			if ((ChipsetID == 0x700E) || (ChipsetID == 0x1022) || (ChipsetID == 0x1106) || (ChipsetID == 0x10DE)) {
 				if (ChipsetID == 0x1106) {
 					if ((VendorID == 0x1019) && (GraphicVendorID == 0x1019))
-						XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0D);
+						xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x0D);
 					else
-						XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0B);
+						xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x0B);
 				} else {
-					XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0B);
+					xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x0B);
 				}
 			}
 		}
@@ -1458,61 +1458,61 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 		/* Set AGP customize registers (in SetDefAGPRegs) Start */
 		for (i = 0x47; i <= 0x4C; i++)
-			XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[i - 0x47]);
+			xgifb_reg_set(pVBInfo->P3d4, i, pVBInfo->AGPReg[i - 0x47]);
 
 		for (i = 0x70; i <= 0x71; i++)
-			XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[6 + i - 0x70]);
+			xgifb_reg_set(pVBInfo->P3d4, i, pVBInfo->AGPReg[6 + i - 0x70]);
 
 		for (i = 0x74; i <= 0x77; i++)
-			XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
+			xgifb_reg_set(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
 		/* Set AGP customize registers (in SetDefAGPRegs) End */
 		/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
 		/*        outl(0x80000000, 0xcf8); */
 		/*        ChipsetID = inl(0x0cfc); */
 		/*        if (ChipsetID == 0x25308086) */
-		/*            XGINew_SetReg1(pVBInfo->P3d4, 0x77, 0xF0); */
+		/*            xgifb_reg_set(pVBInfo->P3d4, 0x77, 0xF0); */
 
 		HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension, 0x50, 0, &Temp); /* Get */
 		Temp >>= 20;
 		Temp &= 0xF;
 
 		if (Temp == 1)
-			XGINew_SetReg1(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
+			xgifb_reg_set(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
 		printk("14");
 	} /* != XG20 */
 
 	/* Set PCI */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x23, *pVBInfo->pSR23);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x24, *pVBInfo->pSR24);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x25, pVBInfo->SR25[0]);
+	xgifb_reg_set(pVBInfo->P3c4, 0x23, *pVBInfo->pSR23);
+	xgifb_reg_set(pVBInfo->P3c4, 0x24, *pVBInfo->pSR24);
+	xgifb_reg_set(pVBInfo->P3c4, 0x25, pVBInfo->SR25[0]);
 	printk("15");
 
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
 		/* Set VB */
 		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
 		XGINew_SetRegANDOR(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00); /* alan, disable VideoCapture */
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x00, 0x00);
+		xgifb_reg_set(pVBInfo->Part1Port, 0x00, 0x00);
 		temp1 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x7B); /* chk if BCLK>=100MHz */
 		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
 
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x02, (*pVBInfo->pCRT2Data_1_2));
+		xgifb_reg_set(pVBInfo->Part1Port, 0x02, (*pVBInfo->pCRT2Data_1_2));
 
 		printk("16");
 
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x2E, 0x08); /* use VB */
+		xgifb_reg_set(pVBInfo->Part1Port, 0x2E, 0x08); /* use VB */
 	} /* != XG20 */
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x27, 0x1F);
+	xgifb_reg_set(pVBInfo->P3c4, 0x27, 0x1F);
 
 	if ((HwDeviceExtension->jChipType == XG42)
 			&& XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) != 0) { /* Not DDR */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x31, (*pVBInfo->pSR31 & 0x3F) | 0x40);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x32, (*pVBInfo->pSR32 & 0xFC) | 0x01);
+		xgifb_reg_set(pVBInfo->P3c4, 0x31, (*pVBInfo->pSR31 & 0x3F) | 0x40);
+		xgifb_reg_set(pVBInfo->P3c4, 0x32, (*pVBInfo->pSR32 & 0xFC) | 0x01);
 	} else {
-		XGINew_SetReg1(pVBInfo->P3c4, 0x31, *pVBInfo->pSR31);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x32, *pVBInfo->pSR32);
+		xgifb_reg_set(pVBInfo->P3c4, 0x31, *pVBInfo->pSR31);
+		xgifb_reg_set(pVBInfo->P3c4, 0x32, *pVBInfo->pSR32);
 	}
-	XGINew_SetReg1(pVBInfo->P3c4, 0x33, *pVBInfo->pSR33);
+	xgifb_reg_set(pVBInfo->P3c4, 0x33, *pVBInfo->pSR33);
 	printk("17");
 
 	/*
@@ -1521,11 +1521,11 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
 		if (XGI_BridgeIsOn(pVBInfo) == 1) {
 			if (pVBInfo->IF_DEF_LVDS == 0) {
-				XGINew_SetReg1(pVBInfo->Part2Port, 0x00, 0x1C);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x0D, *pVBInfo->pCRT2Data_4_D);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x0E, *pVBInfo->pCRT2Data_4_E);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x10, *pVBInfo->pCRT2Data_4_10);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x0F, 0x3F);
+				xgifb_reg_set(pVBInfo->Part2Port, 0x00, 0x1C);
+				xgifb_reg_set(pVBInfo->Part4Port, 0x0D, *pVBInfo->pCRT2Data_4_D);
+				xgifb_reg_set(pVBInfo->Part4Port, 0x0E, *pVBInfo->pCRT2Data_4_E);
+				xgifb_reg_set(pVBInfo->Part4Port, 0x10, *pVBInfo->pCRT2Data_4_10);
+				xgifb_reg_set(pVBInfo->Part4Port, 0x0F, 0x3F);
 			}
 
 			XGI_LockCRT2(HwDeviceExtension, pVBInfo);
@@ -1585,21 +1585,21 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	if (AGP == 0)
 		*pVBInfo->pSR21 &= 0xEF;
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
 	if (AGP == 1)
 		*pVBInfo->pSR22 &= 0x20;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22);
+	xgifb_reg_set(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22);
 	*/
 	/* base = 0x80000000; */
 	/* OutPortLong(0xcf8, base); */
 	/* Temp = (InPortLong(0xcfc) & 0xFFFF); */
 	/* if (Temp == 0x1039) { */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x22, (unsigned char) ((*pVBInfo->pSR22) & 0xFE));
+	xgifb_reg_set(pVBInfo->P3c4, 0x22, (unsigned char) ((*pVBInfo->pSR22) & 0xFE));
 	/* } else { */
-	/*	XGINew_SetReg1(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22); */
+	/*	xgifb_reg_set(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22); */
 	/* } */
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
+	xgifb_reg_set(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
 
 	printk("23");
 
@@ -1608,8 +1608,8 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 	printk("24");
 
-	XGINew_SetReg1(pVBInfo->P3d4, 0x8c, 0x87);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x31);
+	xgifb_reg_set(pVBInfo->P3d4, 0x8c, 0x87);
+	xgifb_reg_set(pVBInfo->P3c4, 0x14, 0x31);
 	printk("25");
 
 	return 1;
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index b4f2112..4cca02d 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -229,7 +229,7 @@ static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex
 	else
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x00, 0x03); /* Set SR0 */
+	xgifb_reg_set(pVBInfo->P3c4, 0x00, 0x03); /* Set SR0 */
 	tempah = pVBInfo->StandTable[StandTableIndex].SR[0];
 
 	i = SetCRT2ToLCDA;
@@ -243,11 +243,11 @@ static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex
 	}
 
 	tempah |= 0x20; /* screen off */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x01, tempah); /* Set SR1 */
+	xgifb_reg_set(pVBInfo->P3c4, 0x01, tempah); /* Set SR1 */
 
 	for (i = 02; i <= 04; i++) {
 		SRdata = pVBInfo->StandTable[StandTableIndex].SR[i - 1]; /* Get SR2,3,4 from file */
-		XGINew_SetReg1(pVBInfo->P3c4, i, SRdata); /* Set SR2 3 4 */
+		xgifb_reg_set(pVBInfo->P3c4, i, SRdata); /* Set SR2 3 4 */
 	}
 }
 
@@ -276,17 +276,17 @@ static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
 
 	CRTCdata = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
 	CRTCdata &= 0x7f;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, CRTCdata); /* Unlock CRTC */
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, CRTCdata); /* Unlock CRTC */
 
 	for (i = 0; i <= 0x18; i++) {
 		CRTCdata = pVBInfo->StandTable[StandTableIndex].CRTC[i]; /* Get CRTC from file */
-		XGINew_SetReg1(pVBInfo->P3d4, i, CRTCdata); /* Set CRTC(3d4) */
+		xgifb_reg_set(pVBInfo->P3d4, i, CRTCdata); /* Set CRTC(3d4) */
 	}
 	/*
 	if ((HwDeviceExtension->jChipType == XGI_630) && (HwDeviceExtension->jChipRevision == 0x30)) {
 		if (pVBInfo->VBInfo & SetInSlaveMode) {
 			if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToTV)) {
-				XGINew_SetReg1(pVBInfo->P3d4, 0x18, 0xFE);
+				xgifb_reg_set(pVBInfo->P3d4, 0x18, 0xFE);
 			}
 		}
 	}
@@ -341,13 +341,13 @@ static void XGI_SetGRCRegs(unsigned short StandTableIndex,
 
 	for (i = 0; i <= 0x08; i++) {
 		GRdata = pVBInfo->StandTable[StandTableIndex].GRC[i]; /* Get GR from file */
-		XGINew_SetReg1(pVBInfo->P3ce, i, GRdata); /* Set GR(3ce) */
+		xgifb_reg_set(pVBInfo->P3ce, i, GRdata); /* Set GR(3ce) */
 	}
 
 	if (pVBInfo->ModeType > ModeVGA) {
 		GRdata = (unsigned char) XGINew_GetReg1(pVBInfo->P3ce, 0x05);
 		GRdata &= 0xBF; /* 256 color disable */
-		XGINew_SetReg1(pVBInfo->P3ce, 0x05, GRdata);
+		xgifb_reg_set(pVBInfo->P3ce, 0x05, GRdata);
 	}
 }
 
@@ -356,19 +356,19 @@ static void XGI_ClearExt1Regs(struct vb_device_info *pVBInfo)
 	unsigned short i;
 
 	for (i = 0x0A; i <= 0x0E; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, i, 0x00); /* Clear SR0A-SR0E */
+		xgifb_reg_set(pVBInfo->P3c4, i, 0x00); /* Clear SR0A-SR0E */
 }
 
 static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo)
 {
 
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, 0x20);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2B, pVBInfo->VCLKData[0].SR2B);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2C, pVBInfo->VCLKData[0].SR2C);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2B, pVBInfo->VCLKData[0].SR2B);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2C, pVBInfo->VCLKData[0].SR2C);
 
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, 0x10);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2B, pVBInfo->VCLKData[1].SR2B);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2C, pVBInfo->VCLKData[1].SR2C);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2B, pVBInfo->VCLKData[1].SR2B);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2C, pVBInfo->VCLKData[1].SR2C);
 
 	XGINew_SetRegAND(pVBInfo->P3c4, 0x31, ~0x30);
 	return 0;
@@ -534,25 +534,25 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	unsigned char data, data1, pushax;
 	unsigned short i, j;
 
-	/* XGINew_SetReg1(pVBInfo->P3d4, 0x51, 0); */
-	/* XGINew_SetReg1(pVBInfo->P3d4, 0x56, 0); */
+	/* xgifb_reg_set(pVBInfo->P3d4, 0x51, 0); */
+	/* xgifb_reg_set(pVBInfo->P3d4, 0x56, 0); */
 	/* XGINew_SetRegANDOR(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
 
 	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11); /* unlock cr0-7 */
 	data &= 0x7F;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, data);
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, data);
 
 	data = pVBInfo->TimingH[0].data[0];
-	XGINew_SetReg1(pVBInfo->P3d4, 0, data);
+	xgifb_reg_set(pVBInfo->P3d4, 0, data);
 
 	for (i = 0x01; i <= 0x04; i++) {
 		data = pVBInfo->TimingH[0].data[i];
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 1), data);
+		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 1), data);
 	}
 
 	for (i = 0x05; i <= 0x06; i++) {
 		data = pVBInfo->TimingH[0].data[i];
-		XGINew_SetReg1(pVBInfo->P3c4, (unsigned short) (i + 6), data);
+		xgifb_reg_set(pVBInfo->P3c4, (unsigned short) (i + 6), data);
 	}
 
 	j = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x0e);
@@ -560,12 +560,12 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	data = pVBInfo->TimingH[0].data[7];
 	data &= 0xE0;
 	data |= j;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x0e, data);
+	xgifb_reg_set(pVBInfo->P3c4, 0x0e, data);
 
 	if (HwDeviceExtension->jChipType >= XG20) {
 		data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x04);
 		data = data - 1;
-		XGINew_SetReg1(pVBInfo->P3d4, 0x04, data);
+		xgifb_reg_set(pVBInfo->P3d4, 0x04, data);
 		data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x05);
 		data1 = data;
 		data1 &= 0xE0;
@@ -575,12 +575,12 @@ static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 			data = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4,
 					0x0c);
 			data &= 0xFB;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x0c, data);
+			xgifb_reg_set(pVBInfo->P3c4, 0x0c, data);
 			data = pushax;
 		}
 		data = data - 1;
 		data |= data1;
-		XGINew_SetReg1(pVBInfo->P3d4, 0x05, data);
+		xgifb_reg_set(pVBInfo->P3d4, 0x05, data);
 		data = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x0e);
 		data = data >> 5;
 		data = data + 3;
@@ -597,23 +597,23 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeN
 	unsigned char data;
 	unsigned short i, j;
 
-	/* XGINew_SetReg1(pVBInfo->P3d4, 0x51, 0); */
-	/* XGINew_SetReg1(pVBInfo->P3d4, 0x56, 0); */
+	/* xgifb_reg_set(pVBInfo->P3d4, 0x51, 0); */
+	/* xgifb_reg_set(pVBInfo->P3d4, 0x56, 0); */
 	/* XGINew_SetRegANDOR(pVBInfo->P3d4, 0x11, 0x7f, 0x00); */
 
 	for (i = 0x00; i <= 0x01; i++) {
 		data = pVBInfo->TimingV[0].data[i];
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 6), data);
+		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 6), data);
 	}
 
 	for (i = 0x02; i <= 0x03; i++) {
 		data = pVBInfo->TimingV[0].data[i];
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 0x0e), data);
+		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 0x0e), data);
 	}
 
 	for (i = 0x04; i <= 0x05; i++) {
 		data = pVBInfo->TimingV[0].data[i];
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 0x11), data);
+		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 0x11), data);
 	}
 
 	j = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x0a);
@@ -621,7 +621,7 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeN
 	data = pVBInfo->TimingV[0].data[6];
 	data &= 0x3F;
 	data |= j;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x0a, data);
+	xgifb_reg_set(pVBInfo->P3c4, 0x0a, data);
 
 	data = pVBInfo->TimingV[0].data[6];
 	data &= 0x80;
@@ -639,7 +639,7 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeN
 	j = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x09);
 	j &= 0x5F;
 	data |= j;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x09, data);
+	xgifb_reg_set(pVBInfo->P3d4, 0x09, data);
 }
 
 static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -655,7 +655,7 @@ static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
 
 	for (i = 0; i < 8; i++)
 		pVBInfo->TimingH[0].data[i]
@@ -670,7 +670,7 @@ static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGI_SetCRT1Timing_V(ModeIdIndex, ModeNo, pVBInfo);
 
 	if (pVBInfo->ModeType > 0x03)
-		XGINew_SetReg1(pVBInfo->P3d4, 0x14, 0x4F);
+		xgifb_reg_set(pVBInfo->P3d4, 0x14, 0x4F);
 }
 
 /* --------------------------------------------------------------------- */
@@ -689,7 +689,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (ModeNo <= 0x13) {
 		StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[4]; /* CR04 HRS */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E [7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E [7:0]->HRS */
 		Tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[5]; /* Tempbx: CR05 HRE */
 		Tempbx &= 0x1F; /* Tempbx: HRE[4:0] */
 		Tempcx = Tempax;
@@ -698,7 +698,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (Tempbx < (Tempax & 0x1F)) /* IF HRE < HRS */
 			Tempdx |= 0x20; /* Tempdx: HRE = HRE + 0x20 */
 		Tempdx <<= 2; /* Tempdx << 2 */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16]; /* Tempax: CR16 VRS */
@@ -710,7 +710,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempcx = Tempax & 0x04; /* Tempcx: CR7[2] */
 		Tempcx <<= 5; /* Tempcx[7]: VRS[8] */
 		Tempdx |= Tempcx; /* Tempdx: VRS[8:1] */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x34, Tempdx); /* SR34[7:0]: VRS[8:1] */
+		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempdx); /* SR34[7:0]: VRS[8:1] */
 
 		Temp1 = Tempcx << 1; /* Temp1[8]: VRS[8] unsigned char -> unsigned short */
 		Temp1 |= Tempbx; /* Temp1[8:0]: VRS[8:0] */
@@ -733,12 +733,12 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempbx = (unsigned char) Temp1; /* Tempbx[1:0]: VRS[10:9] */
 		Tempax |= Tempbx; /* VRE[5:0]VRS[10:9] */
 		Tempax &= 0x7F;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x3F, Tempax); /* SR3F D[7:2]->VRE D[1:0]->VRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x3F, Tempax); /* SR3F D[7:2]->VRE D[1:0]->VRS */
 	} else {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3]; /* Tempax: CR4 HRS */
 		Tempcx = Tempax; /* Tempcx: HRS */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E[7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E[7:0]->HRS */
 
 		Tempdx = pVBInfo->XGINEWUB_CRT1Table[index].CR[5]; /* SRB */
 		Tempdx &= 0xC0; /* Tempdx[7:6]: SRB[7:6] */
@@ -766,7 +766,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax <<= 2; /* Tempax[7:2]: HRE[5:0] */
 		Tempdx >>= 6; /* Tempdx[7:6]->[1:0] HRS[9:8] */
 		Tempax |= Tempdx; /* HRE[5:0]HRS[9:8] */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F D[7:2]->HRE, D[1:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F D[7:2]->HRE, D[1:0]->HRS */
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10]; /* CR10 VRS */
@@ -778,7 +778,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempdx = Tempax & 0x04; /* Tempdx[2]: CR7[2] */
 		Tempdx <<= 5; /* Tempdx[7]: VRS[8] */
 		Tempcx |= Tempdx; /* Tempcx[7:0]: VRS[8:1] */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x34, Tempcx); /* SR34[8:1]->VRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempcx); /* SR34[8:1]->VRS */
 
 		Temp1 = Tempdx; /* Temp1[7]: Tempdx[7] */
 		Temp1 <<= 1; /* Temp1[8]: VRS[8] */
@@ -813,7 +813,7 @@ static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempbx = (unsigned char) Temp1;
 		Tempax |= Tempbx; /* Tempax[7:0]: VRE[5:0]VRS[10:9] */
 		Tempax &= 0x7F;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x3F, Tempax); /* SR3F D[7:2]->VRE D[1:0]->VRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x3F, Tempax); /* SR3F D[7:2]->VRE D[1:0]->VRS */
 	}
 }
 
@@ -826,7 +826,7 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (ModeNo <= 0x13) {
 		StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[4]; /* CR04 HRS */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E [7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E [7:0]->HRS */
 		Tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[5]; /* Tempbx: CR05 HRE */
 		Tempbx &= 0x1F; /* Tempbx: HRE[4:0] */
 		Tempcx = Tempax;
@@ -835,11 +835,11 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (Tempbx < (Tempax & 0x1F)) /* IF HRE < HRS */
 			Tempdx |= 0x20; /* Tempdx: HRE = HRE + 0x20 */
 		Tempdx <<= 2; /* Tempdx << 2 */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempdx); /* SR2F [7:2]->HRE */
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[16]; /* Tempax: CR10 VRS */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS */
 		Tempcx = Tempax; /* Tempcx=Tempax=VRS[7:0] */
 		Tempax = pVBInfo->StandTable[StandTableIndex].CRTC[7]; /* Tempax[7][2]: CR7[7][2] VRS[9][8] */
 		Tempbx = Tempax; /* Tempbx=CR07 */
@@ -865,7 +865,7 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[3]; /* Tempax: CR4 HRS */
 		Tempbx = Tempax; /* Tempbx: HRS[7:0] */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E[7:0]->HRS */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2E, Tempax); /* SR2E[7:0]->HRS */
 
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[5]; /* SR0B */
 		Tempax &= 0xC0; /* Tempax[7:6]: SR0B[7:6]: HRS[9:8]*/
@@ -892,11 +892,11 @@ static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		Tempax &= 0xC0; /* Tempax[7:6]: SR0B[7:6]: HRS[9:8]*/
 		Tempax >>= 6; /* Tempax[1:0]: HRS[9:8]*/
 		Tempax |= ((Tempbx << 2) & 0xFF); /* Tempax[7:2]: HRE[5:0] */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F [7:2][1:0]: HRE[5:0]HRS[9:8] */
+		xgifb_reg_set(pVBInfo->P3c4, 0x2F, Tempax); /* SR2F [7:2][1:0]: HRE[5:0]HRS[9:8] */
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x30, 0xE3, 00);
 
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[10]; /* CR10 VRS */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS[7:0] */
+		xgifb_reg_set(pVBInfo->P3c4, 0x34, Tempax); /* SR34[7:0]->VRS[7:0] */
 
 		Tempcx = Tempax; /* Tempcx <= VRS[7:0] */
 		Tempax = pVBInfo->XGINEWUB_CRT1Table[index].CR[9]; /* CR7[7][2] VRS[9][8] */
@@ -944,15 +944,15 @@ static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 
 	XGI_P3cc = pVBInfo->P3cc;
 
-	XGINew_SetReg1(pVBInfo->P3d4, 0x2E, 0x00);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x2F, 0x00);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x46, 0x00);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x47, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x2E, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x2F, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x46, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x47, 0x00);
 	if (((*pVBInfo->pDVOSetting) & 0xC0) == 0xC0) {
-		XGINew_SetReg1(pVBInfo->P3d4, 0x2E, *pVBInfo->pCR2E);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x2F, *pVBInfo->pCR2F);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x46, *pVBInfo->pCR46);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x47, *pVBInfo->pCR47);
+		xgifb_reg_set(pVBInfo->P3d4, 0x2E, *pVBInfo->pCR2E);
+		xgifb_reg_set(pVBInfo->P3d4, 0x2F, *pVBInfo->pCR2F);
+		xgifb_reg_set(pVBInfo->P3d4, 0x46, *pVBInfo->pCR46);
+		xgifb_reg_set(pVBInfo->P3d4, 0x47, *pVBInfo->pCR47);
 	}
 
 	Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37);
@@ -990,22 +990,22 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 
 	XGI_P3cc = pVBInfo->P3cc;
 
-	XGINew_SetReg1(pVBInfo->P3d4, 0x2E, 0x00);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x2F, 0x00);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x46, 0x00);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x47, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x2E, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x2F, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x46, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x47, 0x00);
 
 	Temp = XGINew_GetReg1(pVBInfo->P3d4, 0x37);
 	if ((Temp & 0x03) == 0) { /* dual 12 */
-		XGINew_SetReg1(pVBInfo->P3d4, 0x46, 0x13);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x47, 0x13);
+		xgifb_reg_set(pVBInfo->P3d4, 0x46, 0x13);
+		xgifb_reg_set(pVBInfo->P3d4, 0x47, 0x13);
 	}
 
 	if (((*pVBInfo->pDVOSetting) & 0xC0) == 0xC0) {
-		XGINew_SetReg1(pVBInfo->P3d4, 0x2E, *pVBInfo->pCR2E);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x2F, *pVBInfo->pCR2F);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x46, *pVBInfo->pCR46);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x47, *pVBInfo->pCR47);
+		xgifb_reg_set(pVBInfo->P3d4, 0x2E, *pVBInfo->pCR2E);
+		xgifb_reg_set(pVBInfo->P3d4, 0x2F, *pVBInfo->pCR2F);
+		xgifb_reg_set(pVBInfo->P3d4, 0x46, *pVBInfo->pCR46);
+		xgifb_reg_set(pVBInfo->P3d4, 0x47, *pVBInfo->pCR47);
 	}
 
 	XGI_SetXG27FPBits(pVBInfo);
@@ -1065,13 +1065,13 @@ static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVB
 	}
 
 	if (index != -1) {
-		XGINew_SetReg1(pVBInfo->P3d4, 0x02,
+		xgifb_reg_set(pVBInfo->P3d4, 0x02,
 				pVBInfo->UpdateCRT1[index].CR02);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x03,
+		xgifb_reg_set(pVBInfo->P3d4, 0x03,
 				pVBInfo->UpdateCRT1[index].CR03);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x15,
+		xgifb_reg_set(pVBInfo->P3d4, 0x15,
 				pVBInfo->UpdateCRT1[index].CR15);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x16,
+		xgifb_reg_set(pVBInfo->P3d4, 0x16,
 				pVBInfo->UpdateCRT1[index].CR16);
 	}
 }
@@ -1125,11 +1125,11 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
 	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
 	data &= 0x7F;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
-	XGINew_SetReg1(pVBInfo->P3d4, 0x01, (unsigned short) (tempcx & 0xff));
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
+	xgifb_reg_set(pVBInfo->P3d4, 0x01, (unsigned short) (tempcx & 0xff));
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x0b, ~0x0c,
 			(unsigned short) ((tempcx & 0x0ff00) >> 10));
-	XGINew_SetReg1(pVBInfo->P3d4, 0x12, (unsigned short) (tempbx & 0xff));
+	xgifb_reg_set(pVBInfo->P3d4, 0x12, (unsigned short) (tempbx & 0xff));
 	tempax = 0;
 	tempbx = tempbx >> 8;
 
@@ -1148,7 +1148,7 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 		tempax |= 0x02;
 
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x0a, ~0x02, tempax);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, temp);
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp);
 }
 
 unsigned short XGI_GetResInfo(unsigned short ModeNo,
@@ -1219,11 +1219,11 @@ static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
 	i = XGINew_GetReg1(pVBInfo->P3c4, 0x0E);
 	i &= 0xF0;
 	i |= temp;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x0E, i);
+	xgifb_reg_set(pVBInfo->P3c4, 0x0E, i);
 
 	temp = (unsigned char) temp2;
 	temp &= 0xFF; /* al */
-	XGINew_SetReg1(pVBInfo->P3d4, 0x13, temp);
+	xgifb_reg_set(pVBInfo->P3d4, 0x13, temp);
 
 	/* SetDisplayUnit */
 	temp2 = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag;
@@ -1243,7 +1243,7 @@ static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if ((ModeNo == 0x4A) | (ModeNo == 0x49))
 			ah -= 1;
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x10, ah);
+	xgifb_reg_set(pVBInfo->P3c4, 0x10, ah);
 }
 
 static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
@@ -1430,12 +1430,12 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (pVBInfo->IF_DEF_LVDS == 1) {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
 		data = XGINew_GetReg1(pVBInfo->P3c4, 0x31) & 0xCF;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x31, data);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2B,
+		xgifb_reg_set(pVBInfo->P3c4, 0x31, data);
+		xgifb_reg_set(pVBInfo->P3c4, 0x2B,
 				pVBInfo->VCLKData[index].SR2B);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2C,
+		xgifb_reg_set(pVBInfo->P3c4, 0x2C,
 				pVBInfo->VCLKData[index].SR2C);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2D, 0x01);
+		xgifb_reg_set(pVBInfo->P3c4, 0x2D, 0x01);
 	} else if ((pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
 			| VB_XGI302LV | VB_XGI301C)) && (pVBInfo->VBInfo
 			& SetCRT2ToLCDA)) {
@@ -1443,27 +1443,27 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 				RefreshRateTableIndex, HwDeviceExtension,
 				pVBInfo);
 		data = XGINew_GetReg1(pVBInfo->P3c4, 0x31) & 0xCF;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x31, data);
+		xgifb_reg_set(pVBInfo->P3c4, 0x31, data);
 		data = pVBInfo->VBVCLKData[vclkindex].Part4_A;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2B, data);
+		xgifb_reg_set(pVBInfo->P3c4, 0x2B, data);
 		data = pVBInfo->VBVCLKData[vclkindex].Part4_B;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2C, data);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2D, 0x01);
+		xgifb_reg_set(pVBInfo->P3c4, 0x2C, data);
+		xgifb_reg_set(pVBInfo->P3c4, 0x2D, 0x01);
 	} else {
 		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
 		data = XGINew_GetReg1(pVBInfo->P3c4, 0x31) & 0xCF;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x31, data);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2B,
+		xgifb_reg_set(pVBInfo->P3c4, 0x31, data);
+		xgifb_reg_set(pVBInfo->P3c4, 0x2B,
 				pVBInfo->VCLKData[index].SR2B);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2C,
+		xgifb_reg_set(pVBInfo->P3c4, 0x2C,
 				pVBInfo->VCLKData[index].SR2C);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x2D, 0x01);
+		xgifb_reg_set(pVBInfo->P3c4, 0x2D, 0x01);
 	}
 
 	if (HwDeviceExtension->jChipType >= XG20) {
 		if (pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag & HalfDCLK) {
 			data = XGINew_GetReg1(pVBInfo->P3c4, 0x2B);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, data);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2B, data);
 			data = XGINew_GetReg1(pVBInfo->P3c4, 0x2C);
 			index = data;
 			index &= 0xE0;
@@ -1471,7 +1471,7 @@ static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 			data = data << 1;
 			data += 1;
 			data |= index;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, data);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2C, data);
 		}
 	}
 }
@@ -1484,27 +1484,27 @@ static void XGI_SetCRT1FIFO(unsigned short ModeNo,
 
 	data = XGINew_GetReg1(pVBInfo->P3c4, 0x3D);
 	data &= 0xfe;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x3D, data); /* diable auto-threshold */
+	xgifb_reg_set(pVBInfo->P3c4, 0x3D, data); /* diable auto-threshold */
 
 	if (ModeNo > 0x13) {
-		XGINew_SetReg1(pVBInfo->P3c4, 0x08, 0x34);
+		xgifb_reg_set(pVBInfo->P3c4, 0x08, 0x34);
 		data = XGINew_GetReg1(pVBInfo->P3c4, 0x09);
 		data &= 0xC0;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x09, data | 0x30);
+		xgifb_reg_set(pVBInfo->P3c4, 0x09, data | 0x30);
 		data = XGINew_GetReg1(pVBInfo->P3c4, 0x3D);
 		data |= 0x01;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x3D, data);
+		xgifb_reg_set(pVBInfo->P3c4, 0x3D, data);
 	} else {
 		if (HwDeviceExtension->jChipType == XG27) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x08, 0x0E);
+			xgifb_reg_set(pVBInfo->P3c4, 0x08, 0x0E);
 			data = XGINew_GetReg1(pVBInfo->P3c4, 0x09);
 			data &= 0xC0;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x09, data | 0x20);
+			xgifb_reg_set(pVBInfo->P3c4, 0x09, data | 0x20);
 		} else {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x08, 0xAE);
+			xgifb_reg_set(pVBInfo->P3c4, 0x08, 0xAE);
 			data = XGINew_GetReg1(pVBInfo->P3c4, 0x09);
 			data &= 0xF0;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x09, data);
+			xgifb_reg_set(pVBInfo->P3c4, 0x09, data);
 		}
 	}
 
@@ -1537,14 +1537,14 @@ static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
 	if (HwDeviceExtension->jChipType >= XG20)
 		data &= ~0x04; /* 2 pixel mode */
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x32, data);
+	xgifb_reg_set(pVBInfo->P3c4, 0x32, data);
 
 	if (HwDeviceExtension->jChipType < XG20) {
 		data = XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
 		data &= 0xE7;
 		if (VCLK < 200)
 			data |= 0x10;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x1F, data);
+		xgifb_reg_set(pVBInfo->P3c4, 0x1F, data);
 	}
 
 	/*  Jong for Adavantech LCD ripple issue
@@ -1605,7 +1605,7 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 		data2 |= 0x20;
 
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x06, ~0x3F, data2);
-	/* XGINew_SetReg1(pVBInfo->P3c4,0x06,data2); */
+	/* xgifb_reg_set(pVBInfo->P3c4,0x06,data2); */
 	resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
 	if (ModeNo <= 0x13)
 		xres = pVBInfo->StResInfo[resindex].HTotal;
@@ -1661,21 +1661,21 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 			data = 0x2c;
 		else
 			data = 0x6c;
-		XGINew_SetReg1(pVBInfo->P3d4, 0x52, data);
+		xgifb_reg_set(pVBInfo->P3d4, 0x52, data);
 		XGINew_SetRegOR(pVBInfo->P3d4, 0x51, 0x10);
 	} else if (HwDeviceExtension->jChipType >= XG20) {
 		if (data & 0x40)
 			data = 0x33;
 		else
 			data = 0x73;
-		XGINew_SetReg1(pVBInfo->P3d4, 0x52, data);
-		XGINew_SetReg1(pVBInfo->P3d4, 0x51, 0x02);
+		xgifb_reg_set(pVBInfo->P3d4, 0x52, data);
+		xgifb_reg_set(pVBInfo->P3d4, 0x51, 0x02);
 	} else {
 		if (data & 0x40)
 			data = 0x2c;
 		else
 			data = 0x6c;
-		XGINew_SetReg1(pVBInfo->P3d4, 0x52, data);
+		xgifb_reg_set(pVBInfo->P3d4, 0x52, data);
 	}
 
 }
@@ -2610,9 +2610,9 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		XGI_SetCRT1Timing_H(pVBInfo, HwDeviceExtension);
 
 		if (pVBInfo->IF_DEF_CH7007 == 1) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2E,
+			xgifb_reg_set(pVBInfo->P3c4, 0x2E,
 					CH7007TV_TimingHPtr[0].data[8]);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2F,
+			xgifb_reg_set(pVBInfo->P3c4, 0x2F,
 					CH7007TV_TimingHPtr[0].data[9]);
 		}
 
@@ -2655,9 +2655,9 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		if (pVBInfo->IF_DEF_CH7007 == 1) {
 			XGINew_SetRegANDOR(pVBInfo->P3c4, 0x33, ~0x01,
 					CH7007TV_TimingVPtr[0].data[7] & 0x01);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x34,
+			xgifb_reg_set(pVBInfo->P3c4, 0x34,
 					CH7007TV_TimingVPtr[0].data[8]);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x3F,
+			xgifb_reg_set(pVBInfo->P3c4, 0x3F,
 					CH7007TV_TimingVPtr[0].data[9]);
 
 		}
@@ -2833,14 +2833,14 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (tempcx >= tempax)
 				tempcx -= tempax;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x1A, tempbx & 0x07);
+			xgifb_reg_set(pVBInfo->Part1Port, 0x1A, tempbx & 0x07);
 
 			tempcx = tempcx >> 3;
 			tempbx = tempbx >> 3;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x16,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x16,
 					(unsigned short) (tempbx & 0xff));
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x17,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x17,
 					(unsigned short) (tempcx & 0xff));
 
 			tempax = pVBInfo->HT;
@@ -2868,8 +2868,8 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			tempcx &= 0x1f;
 			tempax |= tempcx;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x15, tempax);
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x14,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x15, tempax);
+			xgifb_reg_set(pVBInfo->Part1Port, 0x14,
 					(unsigned short) (tempbx & 0xff));
 
 			tempax = pVBInfo->VT;
@@ -2884,15 +2884,15 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (tempcx >= tempax)
 				tempcx -= tempax;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x1b,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x1b,
 					(unsigned short) (tempbx & 0xff));
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x1c,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x1c,
 					(unsigned short) (tempcx & 0xff));
 
 			tempbx = (tempbx >> 8) & 0x07;
 			tempcx = (tempcx >> 8) & 0x07;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x1d,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x1d,
 					(unsigned short) ((tempcx << 3)
 							| tempbx));
 
@@ -2912,7 +2912,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (tempcx >= tempax)
 				tempcx -= tempax;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x18,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x18,
 					(unsigned short) (tempbx & 0xff));
 			XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, ~0x0f,
 					(unsigned short) (tempcx & 0x0f));
@@ -2945,9 +2945,9 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			temp2 = temp1;
 			push3 = temp2;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x37,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x37,
 					(unsigned short) (temp2 & 0xff));
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x36,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x36,
 					(unsigned short) ((temp2 >> 8) & 0xff));
 
 			tempbx = (unsigned short) (temp2 >> 16);
@@ -2957,13 +2957,13 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (tempbx == pVBInfo->VDE)
 				tempax |= 0x04;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x35, tempax);
+			xgifb_reg_set(pVBInfo->Part1Port, 0x35, tempax);
 
 			if (pVBInfo->VBType & VB_XGI301C) {
 				temp2 = push3;
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x3c,
+				xgifb_reg_set(pVBInfo->Part4Port, 0x3c,
 						(unsigned short) (temp2 & 0xff));
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x3b,
+				xgifb_reg_set(pVBInfo->Part4Port, 0x3b,
 						(unsigned short) ((temp2 >> 8)
 								& 0xff));
 				tempbx = (unsigned short) (temp2 >> 16);
@@ -3001,7 +3001,7 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			temp3 = (temp3 & 0xffff0000) + (temp1 & 0xffff);
 
 			tempax = (unsigned short) (temp3 & 0xff);
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x1f, tempax);
+			xgifb_reg_set(pVBInfo->Part1Port, 0x1f, tempax);
 
 			temp1 = pVBInfo->VGAVDE << 18;
 			temp1 = temp1 / push3;
@@ -3012,9 +3012,9 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 			tempax = ((tempbx >> 8) & 0xff) << 3;
 			tempax |= (unsigned short) ((temp3 >> 8) & 0x07);
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x20,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x20,
 					(unsigned short) (tempax & 0xff));
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x21,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x21,
 					(unsigned short) (tempbx & 0xff));
 
 			temp3 = temp3 >> 16;
@@ -3022,9 +3022,9 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (modeflag & HalfDCLK)
 				temp3 = temp3 >> 1;
 
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x22,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x22,
 					(unsigned short) ((temp3 >> 8) & 0xff));
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x23,
+			xgifb_reg_set(pVBInfo->Part1Port, 0x23,
 					(unsigned short) (temp3 & 0xff));
 		}
 	}
@@ -3254,15 +3254,15 @@ static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x31, ~0x30,
 				(unsigned short) (0x10 * i));
 		if (pVBInfo->IF_DEF_CH7007 == 1) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2b, di_0);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2c, di_1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2b, di_0);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2c, di_1);
 		} else if ((!(pVBInfo->VBInfo & SetCRT2ToLCDA))
 				&& (!(pVBInfo->VBInfo & SetInSlaveMode))) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2e, di_0);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2f, di_1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2e, di_0);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2f, di_1);
 		} else {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2b, di_0);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2c, di_1);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2b, di_0);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2c, di_1);
 		}
 	}
 }
@@ -3347,7 +3347,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x3d, tempbl, temp);
 
 		if (!(pVBInfo->SetFlag & ReserveTVOption))
-			XGINew_SetReg1(pVBInfo->P3d4, 0x3e, tempch);
+			xgifb_reg_set(pVBInfo->P3d4, 0x3e, tempch);
 	} else {
 		return;
 	}
@@ -4040,17 +4040,17 @@ void XGINew_IsLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, u
 
 	data = XGINew_GetReg1(pVBInfo->P3c4, 0x0F);
 	data &= 0x7F;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x0F, data);
+	xgifb_reg_set(pVBInfo->P3c4, 0x0F, data);
 
 	if (ModeNo > 0x13) {
 		ModeFlag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		if ((ModeFlag & HalfDCLK) && (ModeFlag & DoubleScanMode)) {
 			data = XGINew_GetReg1(pVBInfo->P3c4, 0x0F);
 			data |= 0x80;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x0F, data);
+			xgifb_reg_set(pVBInfo->P3c4, 0x0F, data);
 			data = XGINew_GetReg1(pVBInfo->P3c4, 0x01);
 			data &= 0xF7;
-			XGINew_SetReg1(pVBInfo->P3c4, 0x01, data);
+			xgifb_reg_set(pVBInfo->P3c4, 0x01, data);
 		}
 	}
 }
@@ -4087,7 +4087,7 @@ static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
 
 	temp = XG21GPIODataTransfer(temp);
 	temp &= 0x23;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
+	xgifb_reg_set(pVBInfo->P3d4, 0x4A, CR4A);
 	return temp;
 }
 
@@ -4108,7 +4108,7 @@ static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo)
 
 	temp &= 0x0C;
 	temp >>= 2;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
+	xgifb_reg_set(pVBInfo->P3d4, 0x4A, CR4A);
 	CRB4 = XGINew_GetReg1(pVBInfo->P3d4, 0xB4);
 	temp |= ((CRB4 & 0x04) << 3);
 	return temp;
@@ -4215,7 +4215,7 @@ static void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBIn
 {
 	unsigned short temp1, temp2;
 
-	XGINew_SetReg1(pVBInfo->P3d4, 0x34, ModeNo); /* reserve CR34 for CRT1 Mode No */
+	xgifb_reg_set(pVBInfo->P3d4, 0x34, ModeNo); /* reserve CR34 for CRT1 Mode No */
 	temp1 = (pVBInfo->VBInfo & SetInSlaveMode) >> 8;
 	temp2 = ~(SetInSlaveMode >> 8);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x31, temp2, temp1);
@@ -4562,15 +4562,15 @@ static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->VBType & VB_XGI301) { /* shampoo 0129 */
 		/* 301 */
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x0A, 0x10);
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x0B, di_1);
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x0A, di_0);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x0A, 0x10);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x0B, di_1);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x0A, di_0);
 	} else { /* 301b/302b/301lv/302lv */
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x0A, di_0);
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x0B, di_1);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x0A, di_0);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x0B, di_1);
 	}
 
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x00, 0x12);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x00, 0x12);
 
 	if (pVBInfo->VBInfo & SetCRT2ToRAMDAC)
 		XGINew_SetRegOR(pVBInfo->Part4Port, 0x12, 0x28);
@@ -4648,16 +4648,16 @@ static void XGI_SetCRT2Offset(unsigned short ModeNo,
 	offset = XGI_GetOffset(ModeNo, ModeIdIndex, RefreshRateTableIndex,
 			HwDeviceExtension, pVBInfo);
 	temp = (unsigned char) (offset & 0xFF);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x07, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x07, temp);
 	temp = (unsigned char) ((offset & 0xFF00) >> 8);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x09, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x09, temp);
 	temp = (unsigned char) (((offset >> 3) & 0xFF) + 1);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x03, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x03, temp);
 }
 
 static void XGI_SetCRT2FIFO(struct vb_device_info *pVBInfo)
 {
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x01, 0x3B); /* threshold high ,disable auto threshold */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x01, 0x3B); /* threshold high ,disable auto threshold */
 	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x02, ~(0x3F), 0x04); /* threshold low default 04h */
 }
 
@@ -4680,10 +4680,10 @@ static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	/* XGI_SetCRT2Sync(ModeNo,RefreshRateTableIndex); */
 
 	for (tempcx = 4; tempcx < 7; tempcx++)
-		XGINew_SetReg1(pVBInfo->Part1Port, tempcx, 0x0);
+		xgifb_reg_set(pVBInfo->Part1Port, tempcx, 0x0);
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x50, 0x00);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x02, 0x44); /* temp 0206 */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x50, 0x00);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x02, 0x44); /* temp 0206 */
 }
 
 static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -4708,11 +4708,11 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	/* bainy change table name */
 	if (modeflag & HalfDCLK) {
 		temp = (pVBInfo->VGAHT / 2 - 1) & 0x0FF; /* BTVGA2HT 0x08,0x09 */
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x08, temp);
+		xgifb_reg_set(pVBInfo->Part1Port, 0x08, temp);
 		temp = (((pVBInfo->VGAHT / 2 - 1) & 0xFF00) >> 8) << 4;
 		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
 		temp = (pVBInfo->VGAHDE / 2 + 16) & 0x0FF; /* BTVGA2HDEE 0x0A,0x0C */
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x0A, temp);
+		xgifb_reg_set(pVBInfo->Part1Port, 0x0A, temp);
 		tempcx = ((pVBInfo->VGAHT - pVBInfo->VGAHDE) / 2) >> 2;
 		pushbx = pVBInfo->VGAHDE / 2 + 16;
 		tempcx = tempcx >> 1;
@@ -4739,14 +4739,14 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		temp = tempbx & 0x00FF;
 
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x0B, temp);
+		xgifb_reg_set(pVBInfo->Part1Port, 0x0B, temp);
 	} else {
 		temp = (pVBInfo->VGAHT - 1) & 0x0FF; /* BTVGA2HT 0x08,0x09 */
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x08, temp);
+		xgifb_reg_set(pVBInfo->Part1Port, 0x08, temp);
 		temp = (((pVBInfo->VGAHT - 1) & 0xFF00) >> 8) << 4;
 		XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x09, ~0x0F0, temp);
 		temp = (pVBInfo->VGAHDE + 16) & 0x0FF; /* BTVGA2HDEE 0x0A,0x0C */
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x0A, temp);
+		xgifb_reg_set(pVBInfo->Part1Port, 0x0A, temp);
 		tempcx = (pVBInfo->VGAHT - pVBInfo->VGAHDE) >> 2; /* cx */
 		pushbx = pVBInfo->VGAHDE + 16;
 		tempcx = tempcx >> 1;
@@ -4771,7 +4771,7 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 			tempcx = pVBInfo->VGAHT;
 
 		temp = tempbx & 0x00FF;
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x0B, temp);
+		xgifb_reg_set(pVBInfo->Part1Port, 0x0B, temp);
 	}
 
 	tempax = (tempax & 0x00FF) | (tempbx & 0xFF00);
@@ -4779,9 +4779,9 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx = (tempbx & 0x00FF) | ((tempbx & 0xFF00) << 4);
 	tempax |= (tempbx & 0xFF00);
 	temp = (tempax & 0xFF00) >> 8;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0C, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0C, temp);
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0D, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0D, temp);
 	tempcx = (pVBInfo->VGAVT - 1);
 	temp = tempcx & 0x00FF;
 
@@ -4790,13 +4790,13 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 			temp--;
 	}
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0E, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0E, temp);
 	tempbx = pVBInfo->VGAVDE - 1;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0F, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0F, temp);
 	temp = ((tempbx & 0xFF00) << 3) >> 8;
 	temp |= ((tempcx & 0xFF00) >> 8);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x12, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x12, temp);
 
 	tempax = pVBInfo->VGAVDE;
 	tempbx = pVBInfo->VGAVDE;
@@ -4824,10 +4824,10 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x10, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x10, temp);
 	temp = ((tempbx & 0xFF00) >> 8) << 4;
 	temp = ((tempcx & 0x000F) | (temp));
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x11, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x11, temp);
 	tempax = 0;
 
 	if (modeflag & DoubleScanMode)
@@ -4873,7 +4873,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		return;
 
 	temp = 0xFF; /* set MAX HT */
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x03, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x03, temp);
 	/* if (modeflag & Charx8Dot) */
 	/*	tempcx = 0x08; */
 	/* else */
@@ -4890,7 +4890,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempax = (tempax / tempcx) - 1;
 	tempbx |= ((tempax & 0x00FF) << 8);
 	temp = tempax & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x04, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x04, temp);
 
 	temp = (tempbx & 0xFF00) >> 8;
 
@@ -4911,8 +4911,8 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x05, temp); /* 0x05 Horizontal Display Start */
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x06, 0x03); /* 0x06 Horizontal Blank end */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x05, temp); /* 0x05 Horizontal Display Start */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x06, 0x03); /* 0x06 Horizontal Blank end */
 
 	if (!(pVBInfo->VBInfo & DisableCRT2Display)) { /* 030226 bainy */
 		if (pVBInfo->VBInfo & SetCRT2ToTV)
@@ -4989,30 +4989,30 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x07, temp); /* 0x07 Horizontal Retrace Start */
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x08, 0); /* 0x08 Horizontal Retrace End */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x07, temp); /* 0x07 Horizontal Retrace Start */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x08, 0); /* 0x08 Horizontal Retrace End */
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
 		if (pVBInfo->TVInfo & TVSimuMode) {
 			if ((ModeNo == 0x06) || (ModeNo == 0x10) || (ModeNo
 					== 0x11) || (ModeNo == 0x13) || (ModeNo
 					== 0x0F)) {
-				XGINew_SetReg1(pVBInfo->Part1Port, 0x07, 0x5b);
-				XGINew_SetReg1(pVBInfo->Part1Port, 0x08, 0x03);
+				xgifb_reg_set(pVBInfo->Part1Port, 0x07, 0x5b);
+				xgifb_reg_set(pVBInfo->Part1Port, 0x08, 0x03);
 			}
 
 			if ((ModeNo == 0x00) || (ModeNo == 0x01)) {
 				if (pVBInfo->TVInfo & SetNTSCTV) {
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x07, 0x2A);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x08, 0x61);
 				} else {
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x07, 0x2A);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x08, 0x41);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x0C, 0xF0);
 				}
 			}
@@ -5020,16 +5020,16 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if ((ModeNo == 0x02) || (ModeNo == 0x03) || (ModeNo
 					== 0x07)) {
 				if (pVBInfo->TVInfo & SetNTSCTV) {
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x07, 0x54);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x08, 0x00);
 				} else {
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x07, 0x55);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x08, 0x00);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x0C, 0xF0);
 				}
 			}
@@ -5037,23 +5037,23 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if ((ModeNo == 0x04) || (ModeNo == 0x05) || (ModeNo
 					== 0x0D) || (ModeNo == 0x50)) {
 				if (pVBInfo->TVInfo & SetNTSCTV) {
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x07, 0x30);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x08, 0x03);
 				} else {
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x07, 0x2f);
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x08, 0x02);
 				}
 			}
 		}
 	}
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x18, 0x03); /* 0x18 SR0B */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x18, 0x03); /* 0x18 SR0B */
 	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x19, 0xF0, 0x00);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x09, 0xFF); /* 0x09 Set Max VT */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x09, 0xFF); /* 0x09 Set Max VT */
 
 	tempbx = pVBInfo->VGAVT;
 	push1 = tempbx;
@@ -5087,11 +5087,11 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp = tempbx & 0x00FF;
 	tempbx--;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x10, temp); /* 0x10 vertical Blank Start */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x10, temp); /* 0x10 vertical Blank Start */
 	tempbx = push2;
 	tempbx--;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0E, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0E, temp);
 
 	if (tempbx & 0x0100)
 		tempcx |= 0x0002;
@@ -5105,12 +5105,12 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx |= 0x0040;
 
 	temp = (tempax & 0xFF00) >> 8;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0B, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0B, temp);
 
 	if (tempbx & 0x0400)
 		tempcx |= 0x0600;
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x11, 0x00); /* 0x11 Vertival Blank End */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x11, 0x00); /* 0x11 Vertival Blank End */
 
 	tempax = push1;
 	tempax -= tempbx; /* 0x0C Vertical Retrace Start */
@@ -5174,10 +5174,10 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0C, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0C, temp);
 	tempbx--;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x10, temp);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x10, temp);
 
 	if (tempbx & 0x0100)
 		tempcx |= 0x0008;
@@ -5199,15 +5199,15 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx = push1; /* pop ax */
 	temp = tempbx & 0x00FF;
 	temp &= 0x0F;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0D, temp); /* 0x0D vertical Retrace End */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0D, temp); /* 0x0D vertical Retrace End */
 
 	if (tempbx & 0x0010)
 		tempcx |= 0x2000;
 
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0A, temp); /* 0x0A CR07 */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0A, temp); /* 0x0A CR07 */
 	temp = (tempcx & 0x0FF00) >> 8;
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x17, temp); /* 0x17 SR0A */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x17, temp); /* 0x17 SR0A */
 	tempax = modeflag;
 	temp = (tempax & 0xFF00) >> 8;
 
@@ -5216,16 +5216,16 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C))
 		temp |= 0x01;
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x16, temp); /* 0x16 SR01 */
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x0F, 0); /* 0x0F CR14 */
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x12, 0); /* 0x12 CR17 */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x16, temp); /* 0x16 SR01 */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x0F, 0); /* 0x0F CR14 */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x12, 0); /* 0x12 CR17 */
 
 	if (pVBInfo->LCDInfo & LCDRGB18Bit)
 		temp = 0x80;
 	else
 		temp = 0x00;
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x1A, temp); /* 0x1A SR0E */
+	xgifb_reg_set(pVBInfo->Part1Port, 0x1A, temp); /* 0x1A SR0E */
 
 	return;
 }
@@ -5274,7 +5274,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempax = (tempax & 0xff00) >> 8;
 
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x0, tempax);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x0, tempax);
 	TimingPoint = pVBInfo->NTSCTiming;
 
 	if (pVBInfo->TVInfo & SetPALTV)
@@ -5305,10 +5305,10 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	for (i = 0x01, j = 0; i <= 0x2D; i++, j++)
-		XGINew_SetReg1(pVBInfo->Part2Port, i, TimingPoint[j]);
+		xgifb_reg_set(pVBInfo->Part2Port, i, TimingPoint[j]);
 
 	for (i = 0x39; i <= 0x45; i++, j++)
-		XGINew_SetReg1(pVBInfo->Part2Port, i, TimingPoint[j]); /* di->temp2[j] */
+		xgifb_reg_set(pVBInfo->Part2Port, i, TimingPoint[j]); /* di->temp2[j] */
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV)
 		XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x3A, 0x1F, 0x00);
@@ -5347,7 +5347,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 			}
 		}
 
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x01, temp);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x01, temp);
 		tempax = push1;
 		temp = (tempax & 0xFF00) >> 8;
 		temp += TimingPoint[1];
@@ -5365,7 +5365,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 				}
 			}
 		}
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x02, temp);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x02, temp);
 	}
 
 	/* 301b */
@@ -5376,7 +5376,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempcx -= 2;
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x1B, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x1B, temp);
 
 	temp = (tempcx & 0xFF00) >> 8;
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x1D, ~0x0F, temp);
@@ -5396,7 +5396,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	tempbx += tempcx;
 	push2 = tempbx;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x24, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x24, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp = temp << 4;
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x25, 0x0F, temp);
@@ -5414,7 +5414,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	j += 2;
 	tempcx += (TimingPoint[j] | ((TimingPoint[j + 1]) << 8));
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x27, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x27, temp);
 	temp = ((tempcx & 0xFF00) >> 8) << 4;
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x28, 0x0F, temp);
 
@@ -5441,7 +5441,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx = tempax - 1;
 	}
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x2E, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x2E, temp);
 
 	tempbx = pVBInfo->VDE;
 
@@ -5480,7 +5480,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x2F, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x2F, temp);
 
 	temp = (tempcx & 0xFF00) >> 8;
 	temp |= ((tempbx & 0xFF00) >> 8) << 6;
@@ -5500,7 +5500,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x30, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x30, temp);
 
 	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
 			| VB_XGI302LV | VB_XGI301C)) { /* TV gatingno */
@@ -5521,13 +5521,13 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (tempbx & 0x0400)
 				temp |= 0x40;
 
-			XGINew_SetReg1(pVBInfo->Part4Port, 0x10, temp);
+			xgifb_reg_set(pVBInfo->Part4Port, 0x10, temp);
 		}
 
 		temp = (((tempbx - 3) & 0x0300) >> 8) << 5;
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x46, temp);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x46, temp);
 		temp = (tempbx - 3) & 0x00FF;
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x47, temp);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x47, temp);
 	}
 
 	tempbx = tempbx & 0x00FF;
@@ -5597,7 +5597,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = (tempax & 0x00FF) >> 8;
 	}
 
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x44, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x44, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x45, ~0x03F, temp);
 	temp = tempcx & 0x00FF;
@@ -5618,9 +5618,9 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x4b, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x4b, temp);
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x4c, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x4c, temp);
 
 	temp = ((tempcx & 0xFF00) >> 8) & 0x03;
 	temp = temp << 2;
@@ -5636,18 +5636,18 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 			temp |= 0x60;
 	}
 
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x4d, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x4d, temp);
 	temp = XGINew_GetReg1(pVBInfo->Part2Port, 0x43); /* 301b change */
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x43, (unsigned short) (temp - 3));
+	xgifb_reg_set(pVBInfo->Part2Port, 0x43, (unsigned short) (temp - 3));
 
 	if (!(pVBInfo->TVInfo & (SetYPbPrMode525p | SetYPbPrMode750p))) {
 		if (pVBInfo->TVInfo & NTSC1024x768) {
 			TimingPoint = XGI_NTSC1024AdjTime;
 			for (i = 0x1c, j = 0; i <= 0x30; i++, j++) {
-				XGINew_SetReg1(pVBInfo->Part2Port, i,
+				xgifb_reg_set(pVBInfo->Part2Port, i,
 						TimingPoint[j]);
 			}
-			XGINew_SetReg1(pVBInfo->Part2Port, 0x43, 0x72);
+			xgifb_reg_set(pVBInfo->Part2Port, 0x43, 0x72);
 		}
 	}
 
@@ -5670,7 +5670,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
 		if (!(pVBInfo->VBInfo & SetInSlaveMode))
-			XGINew_SetReg1(pVBInfo->Part2Port, 0x0B, 0x00);
+			xgifb_reg_set(pVBInfo->Part2Port, 0x0B, 0x00);
 	}
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV)
@@ -5708,7 +5708,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempbx -= 1;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x2C, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x2C, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp = temp << 4;
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x2B, 0x0F, temp);
@@ -5724,22 +5724,22 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x0B, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x0B, temp);
 	tempbx = pVBInfo->VDE; /* RTVACTEO=(VDE-1)&0xFF */
 	push1 = tempbx;
 	tempbx--;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x03, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x03, temp);
 	temp = ((tempbx & 0xFF00) >> 8) & 0x07;
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x0C, ~0x07, temp);
 
 	tempcx = pVBInfo->VT - 1;
 	push2 = tempcx + 1;
 	temp = tempcx & 0x00FF; /* RVTVT=VT-1 */
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x19, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x19, temp);
 	temp = (tempcx & 0xFF00) >> 8;
 	temp = temp << 5;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x1A, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x1A, temp);
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x09, 0xF0, 0x00);
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x0A, 0xF0, 0x00);
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x17, 0xFB, 0x00);
@@ -5784,15 +5784,15 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx -= tempax; /* lcdvdes */
 
 	temp = tempbx & 0x00FF; /* RVEQ1EQ=lcdvdes */
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x05, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x05, temp);
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x06, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x06, temp);
 	tempch = ((tempcx & 0xFF00) >> 8) & 0x07;
 	tempbh = ((tempbx & 0xFF00) >> 8) & 0x07;
 	tempah = tempch;
 	tempah = tempah << 3;
 	tempah |= tempbh;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x02, tempah);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x02, tempah);
 
 	/* getlcdsync() */
 	XGI_GetLCDSync(&tempax, &tempbx, pVBInfo);
@@ -5806,11 +5806,11 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx -= tempax;
 
 	temp = tempbx & 0x00FF; /* RTVACTEE=lcdvrs */
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x04, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x04, temp);
 	temp = (tempbx & 0xFF00) >> 8;
 	temp = temp << 4;
 	temp |= (tempcx & 0x000F);
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x01, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x01, temp);
 	tempcx = pushbx;
 	tempax = pVBInfo->HT;
 	tempbx = pVBInfo->LCDHDES;
@@ -5834,13 +5834,13 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx -= tempax;
 
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x1F, temp); /* RHBLKE=lcdhdes */
+	xgifb_reg_set(pVBInfo->Part2Port, 0x1F, temp); /* RHBLKE=lcdhdes */
 	temp = ((tempbx & 0xFF00) >> 8) << 4;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x20, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x20, temp);
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x23, temp); /* RHEQPLE=lcdhdee */
+	xgifb_reg_set(pVBInfo->Part2Port, 0x23, temp); /* RHEQPLE=lcdhdee */
 	temp = (tempcx & 0xFF00) >> 8;
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x25, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x25, temp);
 
 	/* getlcdsync() */
 	XGI_GetLCDSync(&tempax, &tempbx, pVBInfo);
@@ -5863,13 +5863,13 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx -= tempax;
 
 	temp = tempbx & 0x00FF; /* RHBURSTS=lcdhrs */
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x1C, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x1C, temp);
 
 	temp = (tempbx & 0xFF00) >> 8;
 	temp = temp << 4;
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x1D, ~0x0F0, temp);
 	temp = tempcx & 0x00FF; /* RHSYEXP2S=lcdhre */
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x21, temp);
+	xgifb_reg_set(pVBInfo->Part2Port, 0x21, temp);
 
 	if (!(pVBInfo->LCDInfo & LCDVESATiming)) {
 		if (pVBInfo->VGAVDE == 525) {
@@ -5880,8 +5880,8 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			} else
 				temp = 0xC4;
 
-			XGINew_SetReg1(pVBInfo->Part2Port, 0x2f, temp);
-			XGINew_SetReg1(pVBInfo->Part2Port, 0x30, 0xB3);
+			xgifb_reg_set(pVBInfo->Part2Port, 0x2f, temp);
+			xgifb_reg_set(pVBInfo->Part2Port, 0x30, 0xB3);
 		}
 
 		if (pVBInfo->VGAVDE == 420) {
@@ -5891,7 +5891,7 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 				temp = 0x4F;
 			} else
 				temp = 0x4E;
-			XGINew_SetReg1(pVBInfo->Part2Port, 0x2f, temp);
+			xgifb_reg_set(pVBInfo->Part2Port, 0x2f, temp);
 		}
 	}
 }
@@ -5963,12 +5963,12 @@ static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 
 	Tap4TimingPtr = XGI_GetTap4Ptr(0, pVBInfo); /* Set Horizontal Scaling */
 	for (i = 0x80, j = 0; i <= 0xBF; i++, j++)
-		XGINew_SetReg1(pVBInfo->Part2Port, i, Tap4TimingPtr->Reg[j]);
+		xgifb_reg_set(pVBInfo->Part2Port, i, Tap4TimingPtr->Reg[j]);
 
 	if ((pVBInfo->VBInfo & SetCRT2ToTV) && (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV))) {
 		Tap4TimingPtr = XGI_GetTap4Ptr(1, pVBInfo); /* Set Vertical Scaling */
 		for (i = 0xC0, j = 0; i < 0xFF; i++, j++)
-			XGINew_SetReg1(pVBInfo->Part2Port, i, Tap4TimingPtr->Reg[j]);
+			xgifb_reg_set(pVBInfo->Part2Port, i, Tap4TimingPtr->Reg[j]);
 	}
 
 	if ((pVBInfo->VBInfo & SetCRT2ToTV) && (!(pVBInfo->VBInfo & SetCRT2ToHiVisionTV)))
@@ -5990,22 +5990,22 @@ static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 	else
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
 
-	XGINew_SetReg1(pVBInfo->Part3Port, 0x00, 0x00);
+	xgifb_reg_set(pVBInfo->Part3Port, 0x00, 0x00);
 	if (pVBInfo->TVInfo & SetPALTV) {
-		XGINew_SetReg1(pVBInfo->Part3Port, 0x13, 0xFA);
-		XGINew_SetReg1(pVBInfo->Part3Port, 0x14, 0xC8);
+		xgifb_reg_set(pVBInfo->Part3Port, 0x13, 0xFA);
+		xgifb_reg_set(pVBInfo->Part3Port, 0x14, 0xC8);
 	} else {
-		XGINew_SetReg1(pVBInfo->Part3Port, 0x13, 0xF5);
-		XGINew_SetReg1(pVBInfo->Part3Port, 0x14, 0xB7);
+		xgifb_reg_set(pVBInfo->Part3Port, 0x13, 0xF5);
+		xgifb_reg_set(pVBInfo->Part3Port, 0x14, 0xB7);
 	}
 
 	if (!(pVBInfo->VBInfo & SetCRT2ToTV))
 		return;
 
 	if (pVBInfo->TVInfo & SetPALMTV) {
-		XGINew_SetReg1(pVBInfo->Part3Port, 0x13, 0xFA);
-		XGINew_SetReg1(pVBInfo->Part3Port, 0x14, 0xC8);
-		XGINew_SetReg1(pVBInfo->Part3Port, 0x3D, 0xA8);
+		xgifb_reg_set(pVBInfo->Part3Port, 0x13, 0xFA);
+		xgifb_reg_set(pVBInfo->Part3Port, 0x14, 0xC8);
+		xgifb_reg_set(pVBInfo->Part3Port, 0x3D, 0xA8);
 	}
 
 	if ((pVBInfo->VBInfo & SetCRT2ToHiVisionTV) || (pVBInfo->VBInfo
@@ -6027,11 +6027,11 @@ static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 			tempdi = pVBInfo->Ren750pGroup3;
 
 		for (i = 0; i <= 0x3E; i++)
-			XGINew_SetReg1(pVBInfo->Part3Port, i, tempdi[i]);
+			xgifb_reg_set(pVBInfo->Part3Port, i, tempdi[i]);
 
 		if (pVBInfo->VBType & VB_XGI301C) { /* Marcovision */
 			if (pVBInfo->TVInfo & SetYPbPrMode525p)
-				XGINew_SetReg1(pVBInfo->Part3Port, 0x28, 0x3f);
+				xgifb_reg_set(pVBInfo->Part3Port, 0x28, 0x3f);
 		}
 	}
 	return;
@@ -6052,15 +6052,15 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
 
 	temp = pVBInfo->RVBHCFACT;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x13, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x13, temp);
 
 	tempbx = pVBInfo->RVBHCMAX;
 	temp = tempbx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x14, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x14, temp);
 	temp2 = ((tempbx & 0xFF00) >> 8) << 7;
 	tempcx = pVBInfo->VGAHT - 1;
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x16, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x16, temp);
 
 	temp = ((tempcx & 0xFF00) >> 8) << 3;
 	temp2 |= temp;
@@ -6070,9 +6070,9 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempcx -= 5;
 
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x17, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x17, temp);
 	temp = temp2 | ((tempcx & 0xFF00) >> 8);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x15, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x15, temp);
 	XGINew_SetRegOR(pVBInfo->Part4Port, 0x0D, 0x08);
 	tempcx = pVBInfo->VBInfo;
 	tempbx = pVBInfo->VGAHDE;
@@ -6120,7 +6120,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempcx = pVBInfo->RVBHRS;
 	temp = tempcx & 0x00FF;
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x18, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x18, temp);
 
 	tempeax = pVBInfo->VGAVDE;
 	tempcx |= 0x04000;
@@ -6140,21 +6140,21 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		tempebx++;
 
 	temp = (unsigned short) (tempebx & 0x000000FF);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x1B, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x1B, temp);
 
 	temp = (unsigned short) ((tempebx & 0x0000FF00) >> 8);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x1A, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x1A, temp);
 	tempbx = (unsigned short) (tempebx >> 16);
 	temp = tempbx & 0x00FF;
 	temp = temp << 4;
 	temp |= ((tempcx & 0xFF00) >> 8);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x19, temp);
+	xgifb_reg_set(pVBInfo->Part4Port, 0x19, temp);
 
 	/* 301b */
 	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
 			| VB_XGI302LV | VB_XGI301C)) {
 		temp = 0x0028;
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x1C, temp);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x1C, temp);
 		tempax = pVBInfo->VGAHDE;
 		if (modeflag & HalfDCLK)
 			tempax = tempax >> 1;
@@ -6200,9 +6200,9 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 		temp = (tempax & 0xFF00) >> 8;
 		temp = ((temp & 0x0003) << 4);
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x1E, temp);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x1E, temp);
 		temp = (tempax & 0x00FF);
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x1D, temp);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x1D, temp);
 
 		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToHiVisionTV)) {
 			if (pVBInfo->VGAHDE > 800)
@@ -6231,7 +6231,7 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		temp = ((tempbx & 0x0700) >> 8) << 3;
 		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x21, 0x00C0, temp);
 		temp = tempbx & 0x00FF;
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x22, temp);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x22, temp);
 	}
 	/* end 301b */
 
@@ -6306,7 +6306,7 @@ void XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
 	temp = XG21GPIODataTransfer(temp);
 	temp &= ~tempbh;
 	temp |= tempbl;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x48, temp);
+	xgifb_reg_set(pVBInfo->P3d4, 0x48, temp);
 }
 
 void XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl,
@@ -6536,7 +6536,7 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 			- pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE;
 
 	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
 
 	if (!(modeflag & Charx8Dot))
 		XGINew_SetRegOR(pVBInfo->P3c4, 0x1, 0x1);
@@ -6544,12 +6544,12 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	/* HT SR0B[1:0] CR00 */
 	value = (LVDSHT >> 3) - 5;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x03, (value & 0x300) >> 8);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x0, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x0, (value & 0xFF));
 
 	/* HBS SR0B[5:4] CR02 */
 	value = (LVDSHBS >> 3) - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x30, (value & 0x300) >> 4);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x2, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x2, (value & 0xFF));
 
 	/* HBE SR0C[1:0] CR05[7] CR03[4:0] */
 	value = (LVDSHBE >> 3) - 1;
@@ -6560,12 +6560,12 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	/* HRS SR0B[7:6] CR04 */
 	value = (LVDSHRS >> 3) + 2;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0xC0, (value & 0x300) >> 2);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x4, (value & 0xFF));
 
 	/* Panel HRS SR2F[1:0] SR2E[7:0]  */
 	value--;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x2F, ~0x03, (value & 0x300) >> 8);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2E, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3c4, 0x2E, (value & 0xFF));
 
 	/* HRE SR0C[2] CR05[4:0] */
 	value = (LVDSHRE >> 3) + 2;
@@ -6581,30 +6581,30 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x01, (value & 0x400) >> 10);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x20, (value & 0x200) >> 4);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x01, (value & 0x100) >> 8);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x06, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x06, (value & 0xFF));
 
 	/* VBS SR0A[2] CR09[5] CR07[3] CR15 */
 	value = LVDSVBS - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x04, (value & 0x400) >> 8);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x09, ~0x20, (value & 0x200) >> 4);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x08, (value & 0x100) >> 5);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x15, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x15, (value & 0xFF));
 
 	/* VBE SR0A[4] CR16 */
 	value = LVDSVBE - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x10, (value & 0x100) >> 4);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x16, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x16, (value & 0xFF));
 
 	/* VRS SR0A[3] CR7[7][2] CR10 */
 	value = LVDSVRS - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x08, (value & 0x400) >> 7);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x80, (value & 0x200) >> 2);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x04, (value & 0x100) >> 6);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x10, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x10, (value & 0xFF));
 
 	/* Panel VRS SR3F[1:0] SR34[7:0] SR33[0] */
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x3F, ~0x03, (value & 0x600) >> 9);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x34, (value >> 1) & 0xFF);
+	xgifb_reg_set(pVBInfo->P3c4, 0x34, (value >> 1) & 0xFF);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x33, ~0x01, value & 0x01);
 
 	/* VRE SR0A[5] CR11[3:0] */
@@ -6618,10 +6618,10 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	for (temp = 0, value = 0; temp < 3; temp++) {
 
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, value);
-		XGINew_SetReg1(pVBInfo->P3c4,
+		xgifb_reg_set(pVBInfo->P3c4,
 				0x2B,
 				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData1);
-		XGINew_SetReg1(pVBInfo->P3c4,
+		xgifb_reg_set(pVBInfo->P3c4,
 				0x2C,
 				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData2);
 		value += 0x10;
@@ -6721,7 +6721,7 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 			- pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE;
 
 	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, temp & 0x7f); /* Unlock CRTC */
 
 	if (!(modeflag & Charx8Dot))
 		XGINew_SetRegOR(pVBInfo->P3c4, 0x1, 0x1);
@@ -6729,12 +6729,12 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	/* HT SR0B[1:0] CR00 */
 	value = (LVDSHT >> 3) - 5;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x03, (value & 0x300) >> 8);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x0, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x0, (value & 0xFF));
 
 	/* HBS SR0B[5:4] CR02 */
 	value = (LVDSHBS >> 3) - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0x30, (value & 0x300) >> 4);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x2, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x2, (value & 0xFF));
 
 	/* HBE SR0C[1:0] CR05[7] CR03[4:0] */
 	value = (LVDSHBE >> 3) - 1;
@@ -6745,12 +6745,12 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	/* HRS SR0B[7:6] CR04 */
 	value = (LVDSHRS >> 3) + 2;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0B, ~0xC0, (value & 0x300) >> 2);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x4, (value & 0xFF));
 
 	/* Panel HRS SR2F[1:0] SR2E[7:0]  */
 	value--;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x2F, ~0x03, (value & 0x300) >> 8);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2E, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3c4, 0x2E, (value & 0xFF));
 
 	/* HRE SR0C[2] CR05[4:0] */
 	value = (LVDSHRE >> 3) + 2;
@@ -6766,30 +6766,30 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x01, (value & 0x400) >> 10);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x20, (value & 0x200) >> 4);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x01, (value & 0x100) >> 8);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x06, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x06, (value & 0xFF));
 
 	/* VBS SR0A[2] CR09[5] CR07[3] CR15 */
 	value = LVDSVBS - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x04, (value & 0x400) >> 8);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x09, ~0x20, (value & 0x200) >> 4);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x08, (value & 0x100) >> 5);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x15, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x15, (value & 0xFF));
 
 	/* VBE SR0A[4] CR16 */
 	value = LVDSVBE - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x10, (value & 0x100) >> 4);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x16, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x16, (value & 0xFF));
 
 	/* VRS SR0A[3] CR7[7][2] CR10 */
 	value = LVDSVRS - 1;
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x0A, ~0x08, (value & 0x400) >> 7);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x80, (value & 0x200) >> 2);
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x07, ~0x04, (value & 0x100) >> 6);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x10, (value & 0xFF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x10, (value & 0xFF));
 
 	/* Panel VRS SR35[2:0] SR34[7:0] */
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x35, ~0x07, (value & 0x700) >> 8);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x34, value & 0xFF);
+	xgifb_reg_set(pVBInfo->P3c4, 0x34, value & 0xFF);
 
 	/* VRE SR0A[5] CR11[3:0] */
 	value = LVDSVRE - 1;
@@ -6802,10 +6802,10 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	for (temp = 0, value = 0; temp < 3; temp++) {
 
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, value);
-		XGINew_SetReg1(pVBInfo->P3c4,
+		xgifb_reg_set(pVBInfo->P3c4,
 				0x2B,
 				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData1);
-		XGINew_SetReg1(pVBInfo->P3c4,
+		xgifb_reg_set(pVBInfo->P3c4,
 				0x2C,
 				pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData2);
 		value += 0x10;
@@ -6986,7 +6986,7 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			tempah = XGINew_GetReg1(pVBInfo->Part1Port, 0x00); /* save Part1 index 0 */
 			XGINew_SetRegOR(pVBInfo->Part1Port, 0x00, 0x10); /* BTDAC = 1, avoid VB reset */
 			XGINew_SetRegAND(pVBInfo->Part1Port, 0x1E, 0xDF); /* disable CRT2 */
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x00, tempah); /* restore Part1 index 0 */
+			xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah); /* restore Part1 index 0 */
 		}
 	} else { /* {301} */
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToTV)) {
@@ -7141,7 +7141,7 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 				tempah &= 0x0F;
 				tempah |= tempbh;
 			}
-			XGINew_SetReg1(pVBInfo->Part1Port, 0x2D, tempah);
+			xgifb_reg_set(pVBInfo->Part1Port, 0x2D, tempah);
 		}
 	} else if (pVBInfo->IF_DEF_LVDS == 1) {
 		tempbl = 0;
@@ -7214,13 +7214,13 @@ static void SetSpectrum(struct vb_device_info *pVBInfo)
 	XGINew_SetRegOR(pVBInfo->Part4Port, 0x30, 0x20); /* reset spectrum */
 	XGI_LongWait(pVBInfo);
 
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x31,
+	xgifb_reg_set(pVBInfo->Part4Port, 0x31,
 			pVBInfo->LCDCapList[index].Spectrum_31);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x32,
+	xgifb_reg_set(pVBInfo->Part4Port, 0x32,
 			pVBInfo->LCDCapList[index].Spectrum_32);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x33,
+	xgifb_reg_set(pVBInfo->Part4Port, 0x33,
 			pVBInfo->LCDCapList[index].Spectrum_33);
-	XGINew_SetReg1(pVBInfo->Part4Port, 0x34,
+	xgifb_reg_set(pVBInfo->Part4Port, 0x34,
 			pVBInfo->LCDCapList[index].Spectrum_34);
 	XGI_LongWait(pVBInfo);
 	XGINew_SetRegOR(pVBInfo->Part4Port, 0x30, 0x40); /* enable spectrum */
@@ -7236,7 +7236,7 @@ static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 			| VB_XGI302LV | VB_XGI301C)) {
 		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) { /* 301LV/302LV only */
 			/* Set 301LV Capability */
-			XGINew_SetReg1(pVBInfo->Part4Port, 0x24,
+			xgifb_reg_set(pVBInfo->Part4Port, 0x24,
 					(unsigned char) (tempcx & 0x1F));
 		}
 		/* VB Driving */
@@ -7327,13 +7327,13 @@ static void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo)
 	XGI_GetTVPtrIndex2(&tempbx, &tempcl, &tempch, pVBInfo); /* bx, cl, ch */
 	tempData = TVPhaseList[tempbx];
 
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x31, (unsigned short) (tempData
+	xgifb_reg_set(pVBInfo->Part2Port, 0x31, (unsigned short) (tempData
 			& 0x000000FF));
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x32, (unsigned short) ((tempData
+	xgifb_reg_set(pVBInfo->Part2Port, 0x32, (unsigned short) ((tempData
 			& 0x0000FF00) >> 8));
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x33, (unsigned short) ((tempData
+	xgifb_reg_set(pVBInfo->Part2Port, 0x33, (unsigned short) ((tempData
 			& 0x00FF0000) >> 16));
-	XGINew_SetReg1(pVBInfo->Part2Port, 0x34, (unsigned short) ((tempData
+	xgifb_reg_set(pVBInfo->Part2Port, 0x34, (unsigned short) ((tempData
 			& 0xFF000000) >> 24));
 }
 
@@ -7399,22 +7399,22 @@ static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
 		index = tempal * 7;
 
 	if ((tempcl == 0) && (tempch == 1)) {
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x35, 0);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x36, 0);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x37, 0);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x38, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x35, 0);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x36, 0);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x37, 0);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x38, filterPtr[index++]);
 	} else {
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x35, filterPtr[index++]);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x36, filterPtr[index++]);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x37, filterPtr[index++]);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x38, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x35, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x36, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x37, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x38, filterPtr[index++]);
 	}
 
 	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
 			| VB_XGI302LV | VB_XGI301C)) {
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x48, filterPtr[index++]);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x49, filterPtr[index++]);
-		XGINew_SetReg1(pVBInfo->Part2Port, 0x4A, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x48, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x49, filterPtr[index++]);
+		xgifb_reg_set(pVBInfo->Part2Port, 0x4A, filterPtr[index++]);
 	}
 }
 
@@ -7462,7 +7462,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 
 	unsigned char tempah;
 
-	/* XGINew_SetReg1(pVBInfo->Part1Port, 0x03, 0x00); // fix write part1 index 0 BTDRAM bit Bug */
+	/* xgifb_reg_set(pVBInfo->Part1Port, 0x03, 0x00); // fix write part1 index 0 BTDRAM bit Bug */
 	tempah = 0;
 	if (!(pVBInfo->VBInfo & DisableCRT2Display)) {
 		tempah = XGINew_GetReg1(pVBInfo->Part1Port, 0x00);
@@ -7492,7 +7492,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 		tempah = 0;
 	}
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x00, tempah);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah);
 	if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV | SetCRT2ToLCD)) {
 		tempcl = pVBInfo->ModeType;
 		if (ModeNo > 0x13) {
@@ -7513,7 +7513,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	}
 	*/
 
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x00, tempah);
+	xgifb_reg_set(pVBInfo->Part1Port, 0x00, tempah);
 	tempah = 0x08;
 	tempbl = 0xf0;
 
@@ -7607,7 +7607,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 		if (pVBInfo->LCDResInfo == Panel1280x960)
 			tempah |= 0x80;
 
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x0C, tempah);
+		xgifb_reg_set(pVBInfo->Part4Port, 0x0C, tempah);
 	}
 
 	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
@@ -7946,54 +7946,54 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	unsigned char DAC_TEST_PARMS[3] = { 0x0F, 0x0F, 0x0F };
 
 	int i;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
+	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
 
 	/* [2004/05/06] Vicent to fix XG42 single LCD sense to CRT+LCD */
-	XGINew_SetReg1(pVBInfo->P3d4, 0x57, 0x4A);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
+	xgifb_reg_set(pVBInfo->P3d4, 0x57, 0x4A);
+	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
 			pVBInfo->P3d4, 0x53) | 0x02));
 
 	SR31 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x31);
 	CR63 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x63);
 	SR01 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x01);
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x01, (unsigned char) (SR01 & 0xDF));
-	XGINew_SetReg1(pVBInfo->P3d4, 0x63, (unsigned char) (CR63 & 0xBF));
+	xgifb_reg_set(pVBInfo->P3c4, 0x01, (unsigned char) (SR01 & 0xDF));
+	xgifb_reg_set(pVBInfo->P3d4, 0x63, (unsigned char) (CR63 & 0xBF));
 
 	CR17 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x17);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x17, (unsigned char) (CR17 | 0x80));
+	xgifb_reg_set(pVBInfo->P3d4, 0x17, (unsigned char) (CR17 | 0x80));
 
 	SR1F = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, (unsigned char) (SR1F | 0x04));
+	xgifb_reg_set(pVBInfo->P3c4, 0x1F, (unsigned char) (SR1F | 0x04));
 
 	SR07 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x07);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x07, (unsigned char) (SR07 & 0xFB));
+	xgifb_reg_set(pVBInfo->P3c4, 0x07, (unsigned char) (SR07 & 0xFB));
 	SR06 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x06);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x06, (unsigned char) (SR06 & 0xC3));
+	xgifb_reg_set(pVBInfo->P3c4, 0x06, (unsigned char) (SR06 & 0xC3));
 
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, 0x00);
+	xgifb_reg_set(pVBInfo->P3d4, 0x11, 0x00);
 
 	for (i = 0; i < 8; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) i, CRTCData[i]);
+		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) i, CRTCData[i]);
 
 	for (i = 8; i < 11; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 8),
+		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 8),
 				CRTCData[i]);
 
 	for (i = 11; i < 13; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 4),
+		xgifb_reg_set(pVBInfo->P3d4, (unsigned short) (i + 4),
 				CRTCData[i]);
 
 	for (i = 13; i < 16; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, (unsigned short) (i - 3),
+		xgifb_reg_set(pVBInfo->P3c4, (unsigned short) (i - 3),
 				CRTCData[i]);
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x0E, (unsigned char) (CRTCData[16]
+	xgifb_reg_set(pVBInfo->P3c4, 0x0E, (unsigned char) (CRTCData[16]
 			& 0xE0));
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x31, 0x00);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE1);
+	xgifb_reg_set(pVBInfo->P3c4, 0x31, 0x00);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2B, 0x1B);
+	xgifb_reg_set(pVBInfo->P3c4, 0x2C, 0xE1);
 
 	outb(0x00, pVBInfo->P3c8);
 
@@ -8026,14 +8026,14 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 		outb(0, (pVBInfo->P3c8 + 1));
 	}
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x01, SR01);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x63, CR63);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x31, SR31);
+	xgifb_reg_set(pVBInfo->P3c4, 0x01, SR01);
+	xgifb_reg_set(pVBInfo->P3d4, 0x63, CR63);
+	xgifb_reg_set(pVBInfo->P3c4, 0x31, SR31);
 
 	/* [2004/05/11] Vicent */
-	XGINew_SetReg1(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
+	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
 			pVBInfo->P3d4, 0x53) & 0xFD));
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, (unsigned char) SR1F);
+	xgifb_reg_set(pVBInfo->P3c4, 0x1F, (unsigned char) SR1F);
 }
 
 void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
@@ -8055,10 +8055,10 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 			| VB_XGI302LV | VB_XGI301C)) {
 		if (!(pVBInfo->SetFlag & DisableChA)) {
 			if (pVBInfo->SetFlag & EnableChA) {
-				XGINew_SetReg1(pVBInfo->Part1Port, 0x1E, 0x20); /* Power on */
+				xgifb_reg_set(pVBInfo->Part1Port, 0x1E, 0x20); /* Power on */
 			} else {
 				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) { /* SetCRT2ToLCDA ) */
-					XGINew_SetReg1(pVBInfo->Part1Port,
+					xgifb_reg_set(pVBInfo->Part1Port,
 							0x1E, 0x20); /* Power on */
 				}
 			}
@@ -8075,7 +8075,7 @@ void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 					if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC))
 						tempah |= 0x20;
 				}
-				XGINew_SetReg1(pVBInfo->P3c4, 0x32, tempah);
+				xgifb_reg_set(pVBInfo->P3c4, 0x32, tempah);
 				XGINew_SetRegOR(pVBInfo->P3c4, 0x1E, 0x20);
 
 				tempah = (unsigned char) XGINew_GetReg1(
@@ -8225,14 +8225,14 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 	if ((HwDeviceExtension->jChipType >= XG20)
 			&& (HwDeviceExtension->jChipType < XG27)) { /* fix H/W DCLK/2 bug */
 		if ((ModeNo == 0x00) | (ModeNo == 0x01)) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x4E);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE9);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2B, 0x4E);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2C, 0xE9);
 			b3CC = (unsigned char) inb(XGINew_P3cc);
 			outb((b3CC |= 0x0C), XGINew_P3cc);
 		} else if ((ModeNo == 0x04) | (ModeNo == 0x05) | (ModeNo
 				== 0x0D)) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE3);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2B, 0x1B);
+			xgifb_reg_set(pVBInfo->P3c4, 0x2C, 0xE3);
 			b3CC = (unsigned char) inb(XGINew_P3cc);
 			outb((b3CC |= 0x0C), XGINew_P3cc);
 		}
@@ -8357,7 +8357,7 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 		XGINew_flag_clearbuffer = 1;
 	}
 	*/
-	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
+	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
 
 	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 1.Openkey */
 		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index a919fd6..f7cad57 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -8,13 +8,7 @@
 
 #include "vb_util.h"
 
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_SetReg1 */
-/* Input : */
-/* Output : */
-/* Description : SR CRTC GR */
-/* --------------------------------------------------------------------- */
-void XGINew_SetReg1(unsigned long port, unsigned short index,
+void xgifb_reg_set(unsigned long port, unsigned short index,
 		unsigned short data)
 {
 	outb(index, port);
@@ -37,7 +31,7 @@ void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
 
 	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
 	temp = (temp & (DataAND)) | DataOR;
-	XGINew_SetReg1(Port, Index, temp);
+	xgifb_reg_set(Port, Index, temp);
 }
 
 void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
@@ -47,7 +41,7 @@ void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
 
 	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
 	temp &= DataAND;
-	XGINew_SetReg1(Port, Index, temp);
+	xgifb_reg_set(Port, Index, temp);
 }
 
 void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
@@ -57,5 +51,5 @@ void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
 
 	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
 	temp |= DataOR;
-	XGINew_SetReg1(Port, Index, temp);
+	xgifb_reg_set(Port, Index, temp);
 }
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 7049fc7..c99592a 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -1,6 +1,6 @@
 #ifndef _VBUTIL_
 #define _VBUTIL_
-extern   void     XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
+extern void xgifb_reg_set(unsigned long, unsigned short, unsigned short);
 extern    unsigned char     XGINew_GetReg1(unsigned long, unsigned short);
 extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
 extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
-- 
1.5.6.5

