Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1CMK1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:16 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46221 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab1CMK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:21 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 11/24] staging: xgifb: replace DelayUS() with udelay()
Date: Sun, 13 Mar 2011 12:26:15 +0200
Message-Id: <1300011988-2109-12-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace DelayUS() with udelay().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c |   83 ++++++++++++++++++--------------------
 1 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 8567696..22a3bea 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -39,11 +39,6 @@ static unsigned short XGINew_DDRDRAM_TYPE20[12][5] = {
 
 static int XGINew_RAMType;
 
-static void DelayUS(unsigned long MicroSeconds)
-{
-	udelay(MicroSeconds);
-}
-
 static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 					struct vb_device_info *pVBInfo)
 {
@@ -75,7 +70,7 @@ static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceE
 		return data;
 	} else if (HwDeviceExtension->jChipType == XG21) {
 		XGINew_SetRegAND(pVBInfo->P3d4, 0xB4, ~0x02); /* Independent GPIO control */
-		DelayUS(800);
+		udelay(800);
 		XGINew_SetRegOR(pVBInfo->P3d4, 0x4A, 0x80); /* Enable GPIOH read */
 		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48); /* GPIOF 0:DVI 1:DVO */
 		/* HOTPLUG_SUPPORT */
@@ -112,14 +107,14 @@ static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBI
 		XGINew_SetReg1(P3c4, 0x16, 0x80);
 	}
 
-	DelayUS(60);
+	udelay(60);
 	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
 	XGINew_SetReg1(P3c4, 0x19, 0x01);
 	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[0]);
 	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[1]);
 	mdelay(1);
 	XGINew_SetReg1(P3c4, 0x1B, 0x03);
-	DelayUS(500);
+	udelay(500);
 	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
 	XGINew_SetReg1(P3c4, 0x19, 0x00);
 	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[2]);
@@ -164,65 +159,65 @@ static void XGINew_DDRII_Bootup_XG27(
 	/* XGINew_SetReg1(P3d4, 0x97, 0x11); *//* CR97 */
 	XGINew_SetReg1(P3d4, 0x97, *pVBInfo->pXGINew_CR97); /* CR97 */
 
-	DelayUS(200);
+	udelay(200);
 
 	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS2 */
 	XGINew_SetReg1(P3c4, 0x19, 0x80); /* Set SR19 */
 	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 
 	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS3 */
 	XGINew_SetReg1(P3c4, 0x19, 0xC0); /* Set SR19 */
 	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 
 	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS1 */
 	XGINew_SetReg1(P3c4, 0x19, 0x40); /* Set SR19 */
 	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
-	DelayUS(30);
+	udelay(30);
 	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 
 	XGINew_SetReg1(P3c4, 0x18, 0x42); /* Set SR18 */ /* MRS, DLL Enable */
 	XGINew_SetReg1(P3c4, 0x19, 0x0A); /* Set SR19 */
 	XGINew_SetReg1(P3c4, 0x16, 0x00); /* Set SR16 */
-	DelayUS(30);
+	udelay(30);
 	XGINew_SetReg1(P3c4, 0x16, 0x00); /* Set SR16 */
 	XGINew_SetReg1(P3c4, 0x16, 0x80); /* Set SR16 */
-	/* DelayUS(15); */
+	/* udelay(15); */
 
 	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* Set SR1B */
-	DelayUS(60);
+	udelay(60);
 	XGINew_SetReg1(P3c4, 0x1B, 0x00); /* Set SR1B */
 
 	XGINew_SetReg1(P3c4, 0x18, 0x42); /* Set SR18 */ /* MRS, DLL Reset */
 	XGINew_SetReg1(P3c4, 0x19, 0x08); /* Set SR19 */
 	XGINew_SetReg1(P3c4, 0x16, 0x00); /* Set SR16 */
 
-	DelayUS(30);
+	udelay(30);
 	XGINew_SetReg1(P3c4, 0x16, 0x83); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 
 	XGINew_SetReg1(P3c4, 0x18, 0x80); /* Set SR18 */ /* MRS, ODT */
 	XGINew_SetReg1(P3c4, 0x19, 0x46); /* Set SR19 */
 	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
-	DelayUS(30);
+	udelay(30);
 	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 
 	XGINew_SetReg1(P3c4, 0x18, 0x00); /* Set SR18 */ /* EMRS */
 	XGINew_SetReg1(P3c4, 0x19, 0x40); /* Set SR19 */
 	XGINew_SetReg1(P3c4, 0x16, 0x20); /* Set SR16 */
-	DelayUS(30);
+	udelay(30);
 	XGINew_SetReg1(P3c4, 0x16, 0xA0); /* Set SR16 */
-	DelayUS(15);
+	udelay(15);
 
 	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* Set SR1B refresh control 000:close; 010:open */
-	DelayUS(200);
+	udelay(200);
 
 }
 
@@ -236,7 +231,7 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 
 	XGINew_SetReg1(P3d4, 0x97, 0x11); /* CR97 */
 
-	DelayUS(200);
+	udelay(200);
 	XGINew_SetReg1(P3c4, 0x18, 0x00); /* EMRS2 */
 	XGINew_SetReg1(P3c4, 0x19, 0x80);
 	XGINew_SetReg1(P3c4, 0x16, 0x05);
@@ -258,11 +253,11 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	XGINew_SetReg1(P3c4, 0x16, 0x05);
 	XGINew_SetReg1(P3c4, 0x16, 0x85);
 
-	DelayUS(15);
+	udelay(15);
 	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* SR1B */
-	DelayUS(30);
+	udelay(30);
 	XGINew_SetReg1(P3c4, 0x1B, 0x00); /* SR1B */
-	DelayUS(100);
+	udelay(100);
 
 	/* XGINew_SetReg1(P3c4 ,0x18, 0x52); */ /* MRS2 */
 	XGINew_SetReg1(P3c4, 0x18, 0x42); /* MRS1 */
@@ -270,7 +265,7 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	XGINew_SetReg1(P3c4, 0x16, 0x05);
 	XGINew_SetReg1(P3c4, 0x16, 0x85);
 
-	DelayUS(200);
+	udelay(200);
 }
 
 static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
@@ -280,13 +275,13 @@ static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVB
 	XGINew_SetReg1(P3c4, 0x19, 0x40);
 	XGINew_SetReg1(P3c4, 0x16, 0x00);
 	XGINew_SetReg1(P3c4, 0x16, 0x80);
-	DelayUS(60);
+	udelay(60);
 
 	XGINew_SetReg1(P3c4, 0x18, 0x00);
 	XGINew_SetReg1(P3c4, 0x19, 0x40);
 	XGINew_SetReg1(P3c4, 0x16, 0x00);
 	XGINew_SetReg1(P3c4, 0x16, 0x80);
-	DelayUS(60);
+	udelay(60);
 	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
 	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
 	XGINew_SetReg1(P3c4, 0x19, 0x01);
@@ -294,7 +289,7 @@ static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVB
 	XGINew_SetReg1(P3c4, 0x16, 0x83);
 	mdelay(1);
 	XGINew_SetReg1(P3c4, 0x1B, 0x03);
-	DelayUS(500);
+	udelay(500);
 	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
 	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
 	XGINew_SetReg1(P3c4, 0x19, 0x00);
@@ -522,7 +517,7 @@ static void XGINew_SetDRAMSizingType(int index,
 
 	data = DRAMTYPE_TABLE[index][4];
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x13, 0x80, data);
-	DelayUS(15);
+	udelay(15);
 	/* should delay 50 ns */
 }
 
@@ -597,7 +592,7 @@ static unsigned short XGINew_SetDRAMSize20Reg(int index,
 
 		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
 		XGINew_SetReg1(pVBInfo->P3c4, 0x14, (XGINew_GetReg1(pVBInfo->P3c4, 0x14) & 0x0F) | (data & 0xF0));
-		DelayUS(15);
+		udelay(15);
 
 		/* data |= XGINew_ChannelAB << 2; */
 		/* data |= (XGINew_DataBusWidth / 64) << 1; */
@@ -622,7 +617,7 @@ static int XGINew_ReadWriteRest(unsigned short StopAddr,
 		*((unsigned long *) (pVBInfo->FBAddr + Position)) = Position;
 	}
 
-	DelayUS(500); /* [Vicent] 2004/04/16. Fix #1759 Memory Size error in Multi-Adapter. */
+	udelay(500); /* [Vicent] 2004/04/16. Fix #1759 Memory Size error in Multi-Adapter. */
 
 	Position = 0;
 
@@ -672,7 +667,7 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 				XGINew_DataBusWidth = 32; /* 32 bits */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 32bit */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x52);
-				DelayUS(15);
+				udelay(15);
 
 				if (XGINew_ReadWriteRest(24, 23, pVBInfo) == 1)
 					return;
@@ -680,7 +675,7 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 				if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x800000) {
 					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31); /* 22bit + 1 rank + 32bit */
 					XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x42);
-					DelayUS(15);
+					udelay(15);
 
 					if (XGINew_ReadWriteRest(23, 23, pVBInfo) == 1)
 						return;
@@ -691,13 +686,13 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 				XGINew_DataBusWidth = 16; /* 16 bits */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* 22bit + 2 rank + 16bit */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x41);
-				DelayUS(15);
+				udelay(15);
 
 				if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 					return;
 				else
 					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31);
-				DelayUS(15);
+				udelay(15);
 			}
 
 		} else { /* Dual_16_8 */
@@ -706,7 +701,7 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 				XGINew_DataBusWidth = 16; /* 16 bits */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x41); /* 0x41:16Mx16 bit*/
-				DelayUS(15);
+				udelay(15);
 
 				if (XGINew_ReadWriteRest(23, 22, pVBInfo) == 1)
 					return;
@@ -714,7 +709,7 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 				if ((HwDeviceExtension->ulVideoMemorySize - 1) > 0x400000) {
 					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
 					XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x31); /* 0x31:8Mx16 bit*/
-					DelayUS(15);
+					udelay(15);
 
 					if (XGINew_ReadWriteRest(22, 22, pVBInfo) == 1)
 						return;
@@ -725,13 +720,13 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 				XGINew_DataBusWidth = 8; /* 8 bits */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0xB1); /* (0x31:12x8x2) 22bit + 2 rank */
 				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x30); /* 0x30:8Mx8 bit*/
-				DelayUS(15);
+				udelay(15);
 
 				if (XGINew_ReadWriteRest(22, 21, pVBInfo) == 1)
 					return;
 				else
 					XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x31); /* (0x31:12x8x2) 22bit + 1 rank */
-				DelayUS(15);
+				udelay(15);
 			}
 		}
 		break;
-- 
1.5.6.5

