Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1CHURf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:17:35 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58631 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab1CHUQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:22 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 14/15] staging: xgifb: vb_init: delete unused functions
Date: Tue,  8 Mar 2011 22:16:19 +0200
Message-Id: <1299615380-22922-15-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused functions.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c | 1014 ---------------------------------------
 1 files changed, 0 insertions(+), 1014 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 24dc00c..2cf50dd 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -17,27 +17,6 @@
 
 static unsigned char XGINew_ChannelAB, XGINew_DataBusWidth;
 
-static unsigned short XGINew_SDRDRAM_TYPE[13][5] = {
-	{ 2, 12, 9, 64, 0x35},
-	{ 1, 13, 9, 64, 0x44},
-	{ 2, 12, 8, 32, 0x31},
-	{ 2, 11, 9, 32, 0x25},
-	{ 1, 12, 9, 32, 0x34},
-	{ 1, 13, 8, 32, 0x40},
-	{ 2, 11, 8, 16, 0x21},
-	{ 1, 12, 8, 16, 0x30},
-	{ 1, 11, 9, 16, 0x24},
-	{ 1, 11, 8,  8, 0x20},
-	{ 2,  9, 8,  4, 0x01},
-	{ 1, 10, 8,  4, 0x10},
-	{ 1,  9, 8,  2, 0x00} };
-
-static unsigned short XGINew_DDRDRAM_TYPE[4][5] = {
-	{ 2, 12, 9, 64, 0x35},
-	{ 2, 12, 8, 32, 0x31},
-	{ 2, 11, 8, 16, 0x21},
-	{ 2,  9, 8,  4, 0x01} };
-
 static unsigned short XGINew_DDRDRAM_TYPE340[4][5] = {
 	{ 2, 13, 9, 64, 0x45},
 	{ 2, 12, 9, 32, 0x35},
@@ -59,23 +38,14 @@ static unsigned short XGINew_DDRDRAM_TYPE20[12][5] = {
 	{ 2, 12,  8,  4, 0x31} };
 
 void     XGINew_SetDRAMSize_340(struct xgi_hw_device_info *, struct vb_device_info *);
-void     XGINew_SetDRAMSize_310(struct xgi_hw_device_info *, struct vb_device_info *);
 void     XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-void     XGINew_SetDRAMModeRegister(struct vb_device_info *);
 void XGINew_SetDRAMDefaultRegister340(struct xgi_hw_device_info *HwDeviceExtension,
 				      unsigned long, struct vb_device_info *);
 unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 				     struct vb_device_info *pVBInfo);
 
 int      XGINew_DDRSizing340(struct xgi_hw_device_info *, struct vb_device_info *);
-void     XGINew_DisableRefresh(struct xgi_hw_device_info *, struct vb_device_info *) ;
-void     XGINew_CheckBusWidth_310(struct vb_device_info *) ;
-int      XGINew_SDRSizing(struct vb_device_info *);
-int      XGINew_DDRSizing(struct vb_device_info *);
-void     XGINew_EnableRefresh(struct xgi_hw_device_info *, struct vb_device_info *);
 static int      XGINew_RAMType;		/*int      ModeIDOffset,StandTable,CRT1Table,ScreenOffset,REFIndex;*/
-void     SetPowerConsume(struct xgi_hw_device_info *HwDeviceExtension,
-			 unsigned long XGI_P3d4Port);
 void     ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo);
 void     XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo);
 void     XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
@@ -502,40 +472,6 @@ unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtensio
 	}
 }
 
-static unsigned char XGINew_Get310DRAMType(struct vb_device_info *pVBInfo)
-{
-	unsigned char data;
-
-	/* index = XGINew_GetReg1(pVBInfo->P3c4, 0x1A); */
-	/* index &= 07; */
-
-	if (*pVBInfo->pSoftSetting & SoftDRAMType)
-		data = *pVBInfo->pSoftSetting & 0x03;
-	else
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x3a) & 0x03;
-
-	return data;
-}
-
-/*
-void XGINew_Delay15us(unsigned long ulMicrsoSec)
-{
-}
-*/
-
-static void XGINew_SDR_MRS(struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x16);
-	data &= 0x3F; /* SR16 D7=0,D6=0 */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data); /* enable mode register set(MRS) low */
-	/* XGINew_Delay15us(0x100); */
-	data |= 0x80; /* SR16 D7=1,D6=0 */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data); /* enable mode register set(MRS) high */
-	/* XGINew_Delay15us(0x100); */
-}
-
 static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBInfo)
 {
 	XGINew_SetReg1(P3c4, 0x18, 0x01);
@@ -566,29 +502,6 @@ static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBI
 	XGINew_SetReg1(P3c4, 0x1B, 0x00);
 }
 
-static void XGINew_DDR2x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBInfo)
-{
-	XGINew_SetReg1(P3c4, 0x18, 0x00);
-	XGINew_SetReg1(P3c4, 0x19, 0x20);
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-	DelayUS(60);
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	/* XGINew_SetReg1(P3c4 ,0x18 ,0x31); */
-	XGINew_SetReg1(P3c4, 0x19, 0x01);
-	XGINew_SetReg1(P3c4, 0x16, 0x05);
-	XGINew_SetReg1(P3c4, 0x16, 0x85);
-	DelayUS(1000);
-	XGINew_SetReg1(P3c4, 0x1B, 0x03);
-	DelayUS(500);
-	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	XGINew_SetReg1(P3c4, 0x19, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x05);
-	XGINew_SetReg1(P3c4, 0x16, 0x85);
-	XGINew_SetReg1(P3c4, 0x1B, 0x00);
-}
-
 static void XGINew_DDRII_Bootup_XG27(
 			struct xgi_hw_device_info *HwDeviceExtension,
 			unsigned long P3c4, struct vb_device_info *pVBInfo)
@@ -710,79 +623,6 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	DelayUS(200);
 }
 
-#if 0
-static void XGINew_DDR2_MRS_XG27(struct xgi_hw_device_info *HwDeviceExtension,
-		unsigned long P3c4, struct vb_device_info *pVBInfo)
-{
-	unsigned long P3d4 = P3c4 + 0x10;
-
-	XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
-	XGINew_SetMemoryClock(HwDeviceExtension , pVBInfo);
-
-	XGINew_SetReg1(P3d4, 0x97, 0x11); /* CR97 */
-	DelayUS(200);
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* EMRS2 */
-	XGINew_SetReg1(P3c4, 0x19, 0x80);
-
-	XGINew_SetReg1(P3c4, 0x16, 0x10);
-	DelayUS(15); /* 06/11/23 XG27 A0 for CKE enable */
-	XGINew_SetReg1(P3c4, 0x16, 0x90);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* EMRS3 */
-	XGINew_SetReg1(P3c4, 0x19, 0xC0);
-
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	DelayUS(15); /* 06/11/22 XG27 A0 */
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x00); /* EMRS1 */
-	XGINew_SetReg1(P3c4, 0x19, 0x40);
-
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	DelayUS(15); /* 06/11/22 XG27 A0 */
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x42); /* MRS1 */
-	XGINew_SetReg1(P3c4, 0x19, 0x06); /* [Billy]06/11/22 DLL Reset for XG27 Hynix DRAM */
-
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	DelayUS(15); /* 06/11/23 XG27 A0 */
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-
-	DelayUS(30); /* 06/11/23 XG27 A0 Start Auto-PreCharge */
-	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* SR1B */
-	DelayUS(60);
-	XGINew_SetReg1(P3c4, 0x1B, 0x00); /* SR1B */
-
-	XGINew_SetReg1(P3c4, 0x18, 0x42); /* MRS1 */
-	XGINew_SetReg1(P3c4, 0x19, 0x04); /* DLL without Reset for XG27 Hynix DRAM */
-
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	DelayUS(30);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x80); /* XG27 OCD ON */
-	XGINew_SetReg1(P3c4, 0x19, 0x46);
-
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	DelayUS(30);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x00);
-	XGINew_SetReg1(P3c4, 0x19, 0x40);
-
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	DelayUS(30);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-
-	DelayUS(15); /* Start Auto-PreCharge */
-	XGINew_SetReg1(P3c4, 0x1B, 0x04); /* SR1B */
-	DelayUS(200);
-	XGINew_SetReg1(P3c4, 0x1B, 0x03); /* SR1B */
-
-}
-#endif
-
 static void XGINew_DDR1x_DefaultRegister(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned long Port, struct vb_device_info *pVBInfo)
@@ -833,51 +673,6 @@ static void XGINew_DDR1x_DefaultRegister(
 	}
 }
 
-#if 0
-
-static void XGINew_DDR2x_DefaultRegister(
-		struct xgi_hw_device_info *HwDeviceExtension,
-		unsigned long Port, struct vb_device_info *pVBInfo)
-{
-	unsigned long P3d4 = Port ,
-	P3c4 = Port - 0x10;
-
-	XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
-
-	/* 20040906 Hsuan modify CR82, CR85, CR86 for XG42 */
-	switch (HwDeviceExtension->jChipType) {
-	case XG41:
-	case XG42:
-		XGINew_SetReg1(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
-		XGINew_SetReg1(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-		XGINew_SetReg1(P3d4, 0x86, pVBInfo->CR40[13][XGINew_RAMType]); /* CR86 */
-		break;
-	default:
-		/* keep following setting sequence, each setting in the same reg insert idle */
-		XGINew_SetReg1(P3d4, 0x82, 0x88);
-		XGINew_SetReg1(P3d4, 0x86, 0x00);
-		XGINew_GetReg1(P3d4, 0x86); /* Insert read command for delay */
-		XGINew_SetReg1(P3d4, 0x86, 0x88);
-		XGINew_SetReg1(P3d4, 0x82, 0x77);
-		XGINew_SetReg1(P3d4, 0x85, 0x00);
-		XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
-		XGINew_SetReg1(P3d4, 0x85, 0x88);
-		XGINew_GetReg1(P3d4, 0x85); /* Insert read command for delay */
-		XGINew_SetReg1(P3d4, 0x85, pVBInfo->CR40[12][XGINew_RAMType]); /* CR85 */
-		XGINew_SetReg1(P3d4, 0x82, pVBInfo->CR40[11][XGINew_RAMType]); /* CR82 */
-	}
-	XGINew_SetReg1(P3d4, 0x97, 0x11);
-	if (HwDeviceExtension->jChipType == XG42)
-		XGINew_SetReg1(P3d4, 0x98, 0x01);
-	else
-		XGINew_SetReg1(P3d4, 0x98, 0x03);
-
-	XGINew_SetReg1(P3d4, 0x9A, 0x02);
-
-	XGINew_DDR2x_MRS_340(P3c4, pVBInfo);
-}
-#endif
-
 static void XGINew_DDR2_DefaultRegister(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned long Port, struct vb_device_info *pVBInfo)
@@ -1039,95 +834,6 @@ void XGINew_SetDRAMDefaultRegister340(
 	XGINew_SetReg1(P3c4, 0x1B, pVBInfo->SR15[3][XGINew_RAMType]); /* SR1B */
 }
 
-static void XGINew_DDR_MRS(struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-
-	volatile unsigned char *pVideoMemory = (unsigned char *) pVBInfo->ROMAddr;
-
-	/* SR16 <- 1F,DF,2F,AF */
-	/* yriver modified SR16 <- 0F,DF,0F,AF */
-	/* enable DLL of DDR SD/SGRAM , SR16 D4=1 */
-	data = pVideoMemory[0xFB];
-	/* data = XGINew_GetReg1(pVBInfo->P3c4, 0x16); */
-
-	data &= 0x0F;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	data |= 0xC0;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	data &= 0x0F;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	data |= 0x80;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	data &= 0x0F;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	data |= 0xD0;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	data &= 0x0F;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	data |= 0xA0;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, data);
-	/*
-	else {
-		data &= 0x0F;
-		data |= 0x10;
-		XGINew_SetReg1(pVBInfo->P3c4,0x16,data);
-
-		if (!(pVBInfo->SR15[1][XGINew_RAMType] & 0x10)) {
-			data &= 0x0F;
-		}
-
-		data |= 0xC0;
-		XGINew_SetReg1(pVBInfo->P3c4,0x16,data);
-
-		data &= 0x0F;
-		data |= 0x20;
-		XGINew_SetReg1(pVBInfo->P3c4,0x16,data);
-		if (!(pVBInfo->SR15[1][XGINew_RAMType] & 0x10)) {
-			data &= 0x0F;
-		}
-
-		data |= 0x80;
-		XGINew_SetReg1(pVBInfo->P3c4,0x16,data);
-	}
-	*/
-}
-
-/* check if read cache pointer is correct */
-
-static void XGINew_VerifyMclk(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned char *pVideoMemory = pVBInfo->FBAddr;
-	unsigned char i, j;
-	unsigned short Temp, SR21;
-
-	pVideoMemory[0] = 0xaa; /* alan */
-	pVideoMemory[16] = 0x55; /* note: PCI read cache is off */
-
-	if ((pVideoMemory[0] != 0xaa) || (pVideoMemory[16] != 0x55)) {
-		for (i = 0, j = 16; i < 2; i++, j += 16) {
-			SR21 = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
-			Temp = SR21 & 0xFB; /* disable PCI post write buffer empty gating */
-			XGINew_SetReg1(pVBInfo->P3c4, 0x21, Temp);
-
-			Temp = XGINew_GetReg1(pVBInfo->P3c4, 0x3C);
-			Temp |= 0x01; /* MCLK reset */
-
-			Temp = XGINew_GetReg1(pVBInfo->P3c4, 0x3C);
-			Temp &= 0xFE; /* MCLK normal operation */
-
-			XGINew_SetReg1(pVBInfo->P3c4, 0x21, SR21);
-
-			pVideoMemory[16 + j] = j;
-			if (pVideoMemory[16 + j] == j) {
-				pVideoMemory[j] = j;
-				break;
-			}
-		}
-	}
-}
-
 void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -1150,155 +856,6 @@ void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
 }
 
-void XGINew_SetDRAMSize_310(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase, pVBInfo->FBAddr
-			= HwDeviceExtension->pjVideoMemoryAddress;
-#ifdef XGI301
-	/* XGINew_SetReg1(pVBInfo->P3d4, 0x30, 0x40); */
-#endif
-
-#ifdef XGI302	/* alan,should change value */
-	XGINew_SetReg1(pVBInfo->P3d4, 0x30, 0x4D);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x31, 0xc0);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x34, 0x3F);
-#endif
-
-	XGISetModeNew(HwDeviceExtension, 0x2e);
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF)); /* disable read cache */
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x1);
-	data |= 0x20;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x01, data); /* Turn OFF Display */
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x16);
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, (unsigned short) (data | 0x0F)); /* assume lowest speed DRAM */
-
-	XGINew_SetDRAMModeRegister(pVBInfo);
-	XGINew_DisableRefresh(HwDeviceExtension, pVBInfo);
-	XGINew_CheckBusWidth_310(pVBInfo);
-	XGINew_VerifyMclk(HwDeviceExtension, pVBInfo); /* alan 2000/7/3 */
-
-	if (XGINew_Get310DRAMType(pVBInfo) < 2)
-		XGINew_SDRSizing(pVBInfo);
-	else
-		XGINew_DDRSizing(pVBInfo);
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x16, pVBInfo->SR15[1][XGINew_RAMType]); /* restore SR16 */
-
-	XGINew_EnableRefresh(HwDeviceExtension, pVBInfo);
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
-}
-
-void XGINew_SetDRAMModeRegister340(struct xgi_hw_device_info *HwDeviceExtension)
-{
-	unsigned char data;
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
-	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
-	pVBInfo->ISXPDOS = 0;
-
-	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
-	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
-	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
-	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
-	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
-	pVBInfo->P3ca = pVBInfo->BaseAddr + 0x1a;
-	pVBInfo->P3c6 = pVBInfo->BaseAddr + 0x16;
-	pVBInfo->P3c7 = pVBInfo->BaseAddr + 0x17;
-	pVBInfo->P3c8 = pVBInfo->BaseAddr + 0x18;
-	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
-	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
-	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
-	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
-	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
-	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
-	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
-	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
-		XGI_GetVBType(pVBInfo); /* Run XGI_GetVBType before InitTo330Pointer */
-
-	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
-
-	ReadVBIOSTablData(HwDeviceExtension->jChipType, pVBInfo);
-
-	if (XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) == 0) {
-		data = (XGINew_GetReg1(pVBInfo->P3c4, 0x39) & 0x02) >> 1;
-		if (data == 0x01)
-			XGINew_DDR2x_MRS_340(pVBInfo->P3c4, pVBInfo);
-		else
-			XGINew_DDR1x_MRS_340(pVBInfo->P3c4, pVBInfo);
-	} else {
-		XGINew_DDR2_MRS_XG20(HwDeviceExtension, pVBInfo->P3c4, pVBInfo);
-	}
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1B, 0x03);
-}
-
-void XGINew_SetDRAMModeRegister(struct vb_device_info *pVBInfo)
-{
-	if (XGINew_Get310DRAMType(pVBInfo) < 2) {
-		XGINew_SDR_MRS(pVBInfo);
-	} else {
-		/* SR16 <- 0F,CF,0F,8F */
-		XGINew_DDR_MRS(pVBInfo);
-	}
-}
-
-void XGINew_DisableRefresh(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x1B);
-	data &= 0xF8;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1B, data);
-
-}
-
-void XGINew_EnableRefresh(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1B, pVBInfo->SR15[3][XGINew_RAMType]); /* SR1B */
-
-}
-
-static void XGINew_DisableChannelInterleaving(int index,
-		unsigned short XGINew_DDRDRAM_TYPE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x15);
-	data &= 0x1F;
-
-	switch (XGINew_DDRDRAM_TYPE[index][3]) {
-	case 64:
-		data |= 0;
-		break;
-	case 32:
-		data |= 0x20;
-		break;
-	case 16:
-		data |= 0x40;
-		break;
-	case 4:
-		data |= 0x60;
-		break;
-	default:
-		break;
-	}
-	XGINew_SetReg1(pVBInfo->P3c4, 0x15, data);
-}
-
 static void XGINew_SetDRAMSizingType(int index,
 		unsigned short DRAMTYPE_TABLE[][5],
 		struct vb_device_info *pVBInfo)
@@ -1311,349 +868,6 @@ static void XGINew_SetDRAMSizingType(int index,
 	/* should delay 50 ns */
 }
 
-void XGINew_CheckBusWidth_310(struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-	volatile unsigned long *pVideoMemory;
-
-	pVideoMemory = (unsigned long *) pVBInfo->FBAddr;
-
-	if (XGINew_Get310DRAMType(pVBInfo) < 2) {
-		XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x00);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x12);
-		/* should delay */
-		XGINew_SDR_MRS(pVBInfo);
-
-		XGINew_ChannelAB = 0;
-		XGINew_DataBusWidth = 128;
-		pVideoMemory[0] = 0x01234567L;
-		pVideoMemory[1] = 0x456789ABL;
-		pVideoMemory[2] = 0x89ABCDEFL;
-		pVideoMemory[3] = 0xCDEF0123L;
-		pVideoMemory[4] = 0x55555555L;
-		pVideoMemory[5] = 0x55555555L;
-		pVideoMemory[6] = 0xFFFFFFFFL;
-		pVideoMemory[7] = 0xFFFFFFFFL;
-
-		if ((pVideoMemory[3] != 0xCDEF0123L) || (pVideoMemory[2]
-				!= 0x89ABCDEFL)) {
-			/* ChannelA64Bit */
-			XGINew_DataBusWidth = 64;
-			XGINew_ChannelAB = 0;
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x14);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14,
-					(unsigned short) (data & 0xFD));
-		}
-
-		if ((pVideoMemory[1] != 0x456789ABL) || (pVideoMemory[0]
-				!= 0x01234567L)) {
-			/* ChannelB64Bit */
-			XGINew_DataBusWidth = 64;
-			XGINew_ChannelAB = 1;
-			data = XGINew_GetReg1(pVBInfo->P3c4, 0x14);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x14,
-					(unsigned short) ((data & 0xFD) | 0x01));
-		}
-
-		return;
-	} else {
-		/* DDR Dual channel */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x13, 0x00);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x02); /* Channel A, 64bit */
-		/* should delay */
-		XGINew_DDR_MRS(pVBInfo);
-
-		XGINew_ChannelAB = 0;
-		XGINew_DataBusWidth = 64;
-		pVideoMemory[0] = 0x01234567L;
-		pVideoMemory[1] = 0x456789ABL;
-		pVideoMemory[2] = 0x89ABCDEFL;
-		pVideoMemory[3] = 0xCDEF0123L;
-		pVideoMemory[4] = 0x55555555L;
-		pVideoMemory[5] = 0x55555555L;
-		pVideoMemory[6] = 0xAAAAAAAAL;
-		pVideoMemory[7] = 0xAAAAAAAAL;
-
-		if (pVideoMemory[1] == 0x456789ABL) {
-			if (pVideoMemory[0] == 0x01234567L) {
-				/* Channel A 64bit */
-				return;
-			}
-		} else {
-			if (pVideoMemory[0] == 0x01234567L) {
-				/* Channel A 32bit */
-				XGINew_DataBusWidth = 32;
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x00);
-				return;
-			}
-		}
-
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x03); /* Channel B, 64bit */
-		XGINew_DDR_MRS(pVBInfo);
-
-		XGINew_ChannelAB = 1;
-		XGINew_DataBusWidth = 64;
-		pVideoMemory[0] = 0x01234567L;
-		pVideoMemory[1] = 0x456789ABL;
-		pVideoMemory[2] = 0x89ABCDEFL;
-		pVideoMemory[3] = 0xCDEF0123L;
-		pVideoMemory[4] = 0x55555555L;
-		pVideoMemory[5] = 0x55555555L;
-		pVideoMemory[6] = 0xAAAAAAAAL;
-		pVideoMemory[7] = 0xAAAAAAAAL;
-
-		if (pVideoMemory[1] == 0x456789ABL) {
-			/* Channel B 64 */
-			if (pVideoMemory[0] == 0x01234567L) {
-				/* Channel B 64bit */
-				return;
-			} else {
-				/* error */
-			}
-		} else {
-			if (pVideoMemory[0] == 0x01234567L) {
-				/* Channel B 32 */
-				XGINew_DataBusWidth = 32;
-				XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x01);
-			} else {
-				/* error */
-			}
-		}
-	}
-}
-
-static int XGINew_SetRank(int index, unsigned char RankNo,
-		unsigned char XGINew_ChannelAB,
-		unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-	int RankSize;
-
-	if ((RankNo == 2) && (DRAMTYPE_TABLE[index][0] == 2))
-		return 0;
-
-	RankSize = DRAMTYPE_TABLE[index][3] / 2 * XGINew_DataBusWidth / 32;
-
-	if ((RankNo * RankSize) <= 128) {
-		data = 0;
-
-		while ((RankSize >>= 1) > 0)
-			data += 0x10;
-
-		data |= (RankNo - 1) << 2;
-		data |= (XGINew_DataBusWidth / 64) & 2;
-		data |= XGINew_ChannelAB;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, data);
-		/* should delay */
-		XGINew_SDR_MRS(pVBInfo);
-		return 1;
-	} else {
-		return 0;
-	}
-}
-
-static int XGINew_SetDDRChannel(int index, unsigned char ChannelNo,
-		unsigned char XGINew_ChannelAB,
-		unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-	int RankSize;
-
-	RankSize = DRAMTYPE_TABLE[index][3] / 2 * XGINew_DataBusWidth / 32;
-	/* RankSize = DRAMTYPE_TABLE[index][3]; */
-	if (ChannelNo * RankSize <= 128) {
-		data = 0;
-		while ((RankSize >>= 1) > 0)
-			data += 0x10;
-
-		if (ChannelNo == 2)
-			data |= 0x0C;
-
-		data |= (XGINew_DataBusWidth / 32) & 2;
-		data |= XGINew_ChannelAB;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x14, data);
-		/* should delay */
-		XGINew_DDR_MRS(pVBInfo);
-		return 1;
-	} else {
-		return 0;
-	}
-}
-
-static int XGINew_CheckColumn(int index, unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	int i;
-	unsigned long Increment, Position;
-
-	/* Increment = 1 << (DRAMTYPE_TABLE[index][2] + XGINew_DataBusWidth / 64 + 1); */
-	Increment = 1 << (10 + XGINew_DataBusWidth / 64);
-
-	for (i = 0, Position = 0; i < 2; i++) {
-		*((unsigned long *) (pVBInfo->FBAddr + Position)) = Position;
-		Position += Increment;
-	}
-
-	for (i = 0, Position = 0; i < 2; i++) {
-		/* if ( pVBInfo->FBAddr[ Position ] != Position ) */
-		if ((*(unsigned long *) (pVBInfo->FBAddr + Position)) != Position)
-			return 0;
-		Position += Increment;
-	}
-	return 1;
-}
-
-static int XGINew_CheckBanks(int index, unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	int i;
-	unsigned long Increment, Position;
-
-	Increment = 1 << (DRAMTYPE_TABLE[index][2] + XGINew_DataBusWidth / 64 + 2);
-
-	for (i = 0, Position = 0; i < 4; i++) {
-		/* pVBInfo->FBAddr[Position] = Position; */
-		*((unsigned long *) (pVBInfo->FBAddr + Position)) = Position;
-		Position += Increment;
-	}
-
-	for (i = 0, Position = 0; i < 4; i++) {
-		/* if (pVBInfo->FBAddr[Position] != Position) */
-		if ((*(unsigned long *) (pVBInfo->FBAddr + Position)) != Position)
-			return 0;
-		Position += Increment;
-	}
-	return 1;
-}
-
-static int XGINew_CheckRank(int RankNo, int index,
-		unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	int i;
-	unsigned long Increment, Position;
-
-	Increment = 1 << (DRAMTYPE_TABLE[index][2] + DRAMTYPE_TABLE[index][1]
-			+ DRAMTYPE_TABLE[index][0] + XGINew_DataBusWidth / 64
-			+ RankNo);
-
-	for (i = 0, Position = 0; i < 2; i++) {
-		/* pVBInfo->FBAddr[Position] = Position; */
-		/* *((unsigned long *)(pVBInfo->FBAddr)) = Position; */
-		*((unsigned long *) (pVBInfo->FBAddr + Position)) = Position;
-		Position += Increment;
-	}
-
-	for (i = 0, Position = 0; i < 2; i++) {
-		/* if (pVBInfo->FBAddr[Position] != Position) */
-		/* if ((*(unsigned long *)(pVBInfo->FBAddr)) != Position) */
-		if ((*(unsigned long *) (pVBInfo->FBAddr + Position)) != Position)
-			return 0;
-		Position += Increment;
-	}
-	return 1;
-}
-
-static int XGINew_CheckDDRRank(int RankNo, int index,
-		unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	unsigned long Increment, Position;
-	unsigned short data;
-
-	Increment = 1 << (DRAMTYPE_TABLE[index][2] + DRAMTYPE_TABLE[index][1]
-			+ DRAMTYPE_TABLE[index][0] + XGINew_DataBusWidth / 64
-			+ RankNo);
-
-	Increment += Increment / 2;
-
-	Position = 0;
-	*((unsigned long *) (pVBInfo->FBAddr + Position + 0)) = 0x01234567;
-	*((unsigned long *) (pVBInfo->FBAddr + Position + 1)) = 0x456789AB;
-	*((unsigned long *) (pVBInfo->FBAddr + Position + 2)) = 0x55555555;
-	*((unsigned long *) (pVBInfo->FBAddr + Position + 3)) = 0x55555555;
-	*((unsigned long *) (pVBInfo->FBAddr + Position + 4)) = 0xAAAAAAAA;
-	*((unsigned long *) (pVBInfo->FBAddr + Position + 5)) = 0xAAAAAAAA;
-
-	if ((*(unsigned long *) (pVBInfo->FBAddr + 1)) == 0x456789AB)
-		return 1;
-
-	if ((*(unsigned long *) (pVBInfo->FBAddr + 0)) == 0x01234567)
-		return 0;
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x14);
-	data &= 0xF3;
-	data |= 0x0E;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x14, data);
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x15);
-	data += 0x20;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x15, data);
-
-	return 1;
-}
-
-static int XGINew_CheckRanks(int RankNo, int index,
-		unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	int r;
-
-	for (r = RankNo; r >= 1; r--) {
-		if (!XGINew_CheckRank(r, index, DRAMTYPE_TABLE, pVBInfo))
-			return 0;
-	}
-
-	if (!XGINew_CheckBanks(index, DRAMTYPE_TABLE, pVBInfo))
-		return 0;
-
-	if (!XGINew_CheckColumn(index, DRAMTYPE_TABLE, pVBInfo))
-		return 0;
-
-	return 1;
-}
-
-static int XGINew_CheckDDRRanks(int RankNo, int index,
-		unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	int r;
-
-	for (r = RankNo; r >= 1; r--) {
-		if (!XGINew_CheckDDRRank(r, index, DRAMTYPE_TABLE, pVBInfo))
-			return 0;
-	}
-
-	if (!XGINew_CheckBanks(index, DRAMTYPE_TABLE, pVBInfo))
-		return 0;
-
-	if (!XGINew_CheckColumn(index, DRAMTYPE_TABLE, pVBInfo))
-		return 0;
-
-	return 1;
-}
-
-int XGINew_SDRSizing(struct vb_device_info *pVBInfo)
-{
-	int i;
-	unsigned char j;
-
-	for (i = 0; i < 13; i++) {
-		XGINew_SetDRAMSizingType(i, XGINew_SDRDRAM_TYPE, pVBInfo);
-
-		for (j = 2; j > 0; j--) {
-			if (!XGINew_SetRank(i, (unsigned char) j, XGINew_ChannelAB, XGINew_SDRDRAM_TYPE, pVBInfo)) {
-				continue;
-			} else {
-				if (XGINew_CheckRanks(j, i, XGINew_SDRDRAM_TYPE, pVBInfo))
-					return 1;
-			}
-		}
-	}
-	return 0;
-}
-
 static unsigned short XGINew_SetDRAMSizeReg(int index,
 		unsigned short DRAMTYPE_TABLE[][5],
 		struct vb_device_info *pVBInfo)
@@ -2075,27 +1289,6 @@ int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 	return 0;
 }
 
-int XGINew_DDRSizing(struct vb_device_info *pVBInfo)
-{
-	int i;
-	unsigned char j;
-
-	for (i = 0; i < 4; i++) {
-		XGINew_SetDRAMSizingType(i, XGINew_DDRDRAM_TYPE, pVBInfo);
-		XGINew_DisableChannelInterleaving(i, XGINew_DDRDRAM_TYPE, pVBInfo);
-		for (j = 2; j > 0; j--) {
-			XGINew_SetDDRChannel(i, j, XGINew_ChannelAB, XGINew_DDRDRAM_TYPE, pVBInfo);
-			if (!XGINew_SetRank(i, (unsigned char) j, XGINew_ChannelAB, XGINew_DDRDRAM_TYPE, pVBInfo)) {
-				continue;
-			} else {
-				if (XGINew_CheckDDRRanks(j, i, XGINew_DDRDRAM_TYPE, pVBInfo))
-					return 1;
-			}
-		}
-	}
-	return 0;
-}
-
 void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -2121,89 +1314,6 @@ void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 }
 
-unsigned char ChkLFB(struct vb_device_info *pVBInfo)
-{
-	if (LFBDRAMTrap & XGINew_GetReg1(pVBInfo->P3d4, 0x78))
-		return 1;
-	else
-		return 0;
-}
-
-/* --------------------------------------------------------------------- */
-/* input : dx ,valid value : CR or second chip's CR */
-/*  */
-/* SetPowerConsume : */
-/* Description: reduce 40/43 power consumption in first chip or */
-/* in second chip, assume CR A1 D[6]="1" in this case */
-/* output : none */
-/* --------------------------------------------------------------------- */
-void SetPowerConsume(struct xgi_hw_device_info *HwDeviceExtension,
-		unsigned long XGI_P3d4Port)
-{
-	unsigned long lTemp;
-	unsigned char bTemp;
-
-	HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension, 0x08, 0, &lTemp); /* Get */
-	if ((lTemp & 0xFF) == 0) {
-		/* set CR58 D[5]=0 D[3]=0 */
-		XGINew_SetRegAND(XGI_P3d4Port, 0x58, 0xD7);
-		bTemp = (unsigned char) XGINew_GetReg1(XGI_P3d4Port, 0xCB);
-		if (bTemp & 0x20) {
-			if (!(bTemp & 0x10))
-				XGINew_SetRegANDOR(XGI_P3d4Port, 0x58, 0xD7, 0x20); /* CR58 D[5]=1 D[3]=0 */
-			else
-				XGINew_SetRegANDOR(XGI_P3d4Port, 0x58, 0xD7, 0x08); /* CR58 D[5]=0 D[3]=1 */
-
-		}
-
-	}
-}
-
-#if 0
-static void XGINew_InitVBIOSData(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-
-	/* unsigned long ROMAddr = (unsigned long) HwDeviceExtension->pjVirtualRomBase; */
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
-	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
-	pVBInfo->ISXPDOS = 0;
-
-	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
-	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
-	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
-	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
-	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
-	pVBInfo->P3ca = pVBInfo->BaseAddr + 0x1a;
-	pVBInfo->P3c6 = pVBInfo->BaseAddr + 0x16;
-	pVBInfo->P3c7 = pVBInfo->BaseAddr + 0x17;
-	pVBInfo->P3c8 = pVBInfo->BaseAddr + 0x18;
-	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
-	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
-	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
-	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
-	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
-	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
-	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
-	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
-	XGI_GetVBType(pVBInfo); /* Run XGI_GetVBType before InitTo330Pointer */
-
-	switch (HwDeviceExtension->jChipType) {
-	case XG40:
-	case XG41:
-	case XG42:
-	case XG20:
-	case XG21:
-	default:
-		InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
-		return;
-	}
-
-}
-#endif
-
 void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo)
 {
 	volatile unsigned char *pVideoMemory = (unsigned char *) pVBInfo->ROMAddr;
@@ -2324,130 +1434,6 @@ void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
 	XGINew_SetReg1(P3c4, 0x1B, 0x00);
 }
 
-void XGINew_SetDRAMModeRegister_XG20(struct xgi_hw_device_info *HwDeviceExtension)
-{
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
-	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
-	pVBInfo->ISXPDOS = 0;
-
-	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
-	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
-	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
-	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
-	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
-	pVBInfo->P3ca = pVBInfo->BaseAddr + 0x1a;
-	pVBInfo->P3c6 = pVBInfo->BaseAddr + 0x16;
-	pVBInfo->P3c7 = pVBInfo->BaseAddr + 0x17;
-	pVBInfo->P3c8 = pVBInfo->BaseAddr + 0x18;
-	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
-	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
-	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
-	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
-	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
-	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
-	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
-	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
-
-	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
-
-	ReadVBIOSTablData(HwDeviceExtension->jChipType, pVBInfo);
-
-	if (XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) == 0)
-		XGINew_DDR1x_MRS_XG20(pVBInfo->P3c4, pVBInfo);
-	else
-		XGINew_DDR2_MRS_XG20(HwDeviceExtension, pVBInfo->P3c4, pVBInfo);
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1B, 0x03);
-}
-
-void XGINew_SetDRAMModeRegister_XG27(
-		struct xgi_hw_device_info *HwDeviceExtension)
-{
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
-	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
-	pVBInfo->ISXPDOS = 0;
-
-	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
-	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
-	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
-	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
-	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
-	pVBInfo->P3ca = pVBInfo->BaseAddr + 0x1a;
-	pVBInfo->P3c6 = pVBInfo->BaseAddr + 0x16;
-	pVBInfo->P3c7 = pVBInfo->BaseAddr + 0x17;
-	pVBInfo->P3c8 = pVBInfo->BaseAddr + 0x18;
-	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
-	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
-	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
-	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
-	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
-	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
-	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
-	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
-
-	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
-
-	ReadVBIOSTablData(HwDeviceExtension->jChipType, pVBInfo);
-
-	if (XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) == 0)
-		XGINew_DDR1x_MRS_XG20(pVBInfo->P3c4, pVBInfo);
-	else
-		/* XGINew_DDR2_MRS_XG27(HwDeviceExtension, pVBInfo->P3c4, pVBInfo); */
-		XGINew_DDRII_Bootup_XG27(HwDeviceExtension, pVBInfo->P3c4, pVBInfo);
-
-	/* XGINew_SetReg1(pVBInfo->P3c4, 0x1B, 0x03); */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1B, pVBInfo->SR15[3][XGINew_RAMType]); /* SR1B */
-
-}
-
-/*
-void XGINew_SetDRAMModeRegister_XG27(struct xgi_hw_device_info *HwDeviceExtension)
-{
-	unsigned char data;
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
-	pVBInfo->BaseAddr = HwDeviceExtension->pjIOAddress;
-	pVBInfo->ISXPDOS = 0;
-
-	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
-	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
-	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
-	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
-	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
-	pVBInfo->P3ca = pVBInfo->BaseAddr + 0x1a;
-	pVBInfo->P3c6 = pVBInfo->BaseAddr + 0x16;
-	pVBInfo->P3c7 = pVBInfo->BaseAddr + 0x17;
-	pVBInfo->P3c8 = pVBInfo->BaseAddr + 0x18;
-	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
-	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
-	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
-	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
-	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
-	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
-	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
-	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
-
-	InitTo330Pointer(HwDeviceExtension->jChipType,pVBInfo);
-
-	ReadVBIOSTablData(HwDeviceExtension->jChipType , pVBInfo);
-
-	if (XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) == 0)
-		XGINew_DDR1x_MRS_XG20(pVBInfo->P3c4, pVBInfo);
-	else
-		XGINew_DDR2_MRS_XG27(HwDeviceExtension, pVBInfo->P3c4, pVBInfo);
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1B, 0x03);
-}
-*/
-
 void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-- 
1.5.6.5

