Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1CJVCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:02:40 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:55748 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1CJVCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:37 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 02/22] staging: xgifb: vb_init: move functions to avoid forward declarations
Date: Thu, 10 Mar 2011 23:02:27 +0200
Message-Id: <1299790967-7135-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move functions to avoid forward declarations.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c |  875 +++++++++++++++++++--------------------
 1 files changed, 428 insertions(+), 447 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 4bbcff6..7b8e00d 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -37,389 +37,13 @@ static unsigned short XGINew_DDRDRAM_TYPE20[12][5] = {
 	{ 2, 12,  9,  8, 0x35},
 	{ 2, 12,  8,  4, 0x31} };
 
-static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *, struct vb_device_info *);
-static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-static void XGINew_SetDRAMDefaultRegister340(struct xgi_hw_device_info *HwDeviceExtension,
-				      unsigned long, struct vb_device_info *);
-static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
-				     struct vb_device_info *pVBInfo);
-
-static int XGINew_DDRSizing340(struct xgi_hw_device_info *, struct vb_device_info *);
-static int      XGINew_RAMType;		/*int      ModeIDOffset,StandTable,CRT1Table,ScreenOffset,REFIndex;*/
-static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo);
-static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo);
-static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-static unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo);
-static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo);
-static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
+static int XGINew_RAMType;
 
 static void DelayUS(unsigned long MicroSeconds)
 {
 	udelay(MicroSeconds);
 }
 
-unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
-{
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-	unsigned char i, temp = 0, temp1;
-	/* VBIOSVersion[5]; */
-	volatile unsigned char *pVideoMemory;
-
-	/* unsigned long j, k; */
-
-	unsigned long Temp;
-
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-
-	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
-
-	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
-
-	pVideoMemory = (unsigned char *) pVBInfo->ROMAddr;
-
-	/* Newdebugcode(0x99); */
-
-
-	/* if (pVBInfo->ROMAddr == 0) */
-	/* return(0); */
-
-	if (pVBInfo->FBAddr == NULL) {
-		printk("\n pVBInfo->FBAddr == 0 ");
-		return 0;
-	}
-	printk("1");
-	if (pVBInfo->BaseAddr == 0) {
-		printk("\npVBInfo->BaseAddr == 0 ");
-		return 0;
-	}
-	printk("2");
-
-	XGINew_SetReg3((pVBInfo->BaseAddr + 0x12), 0x67); /* 3c2 <- 67 ,ynlai */
-
-	pVBInfo->ISXPDOS = 0;
-	printk("3");
-
-	printk("4");
-
-	/* VBIOSVersion[4] = 0x0; */
-
-	/* 09/07/99 modify by domao */
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
-	printk("5");
-
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
-		XGI_GetVBType(pVBInfo); /* Run XGI_GetVBType before InitTo330Pointer */
-
-	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
-
-	/* ReadVBIOSData */
-	ReadVBIOSTablData(HwDeviceExtension->jChipType, pVBInfo);
-
-	/* 1.Openkey */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
-	printk("6");
-
-	/* GetXG21Sense (GPIO) */
-	if (HwDeviceExtension->jChipType == XG21)
-		XGINew_GetXG21Sense(HwDeviceExtension, pVBInfo);
-
-	if (HwDeviceExtension->jChipType == XG27)
-		XGINew_GetXG27Sense(HwDeviceExtension, pVBInfo);
-
-	printk("7");
-
-	/* 2.Reset Extended register */
-
-	for (i = 0x06; i < 0x20; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
-
-	for (i = 0x21; i <= 0x27; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
-
-	/* for(i = 0x06; i <= 0x27; i++) */
-	/* XGINew_SetReg1(pVBInfo->P3c4, i, 0); */
-
-	printk("8");
-
-	if ((HwDeviceExtension->jChipType >= XG20) || (HwDeviceExtension->jChipType >= XG40)) {
-		for (i = 0x31; i <= 0x3B; i++)
-			XGINew_SetReg1(pVBInfo->P3c4, i, 0);
-	} else {
-		for (i = 0x31; i <= 0x3D; i++)
-			XGINew_SetReg1(pVBInfo->P3c4, i, 0);
-	}
-	printk("9");
-
-	if (HwDeviceExtension->jChipType == XG42) /* [Hsuan] 2004/08/20 Auto over driver for XG42 */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x3B, 0xC0);
-
-	/* for (i = 0x30; i <= 0x3F; i++) */
-	/* XGINew_SetReg1(pVBInfo->P3d4, i, 0); */
-
-	for (i = 0x79; i <= 0x7C; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, i, 0); /* shampoo 0208 */
-
-	printk("10");
-
-	if (HwDeviceExtension->jChipType >= XG20)
-		XGINew_SetReg1(pVBInfo->P3d4, 0x97, *pVBInfo->pXGINew_CR97);
-
-	/* 3.SetMemoryClock
-
-	 if (HwDeviceExtension->jChipType >= XG40)
-	 XGINew_RAMType = (int)XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
-
-	 if (HwDeviceExtension->jChipType < XG40)
-	 XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);  */
-
-	printk("11");
-
-	/* 4.SetDefExt1Regs begin */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x07, *pVBInfo->pSR07);
-	if (HwDeviceExtension->jChipType == XG27) {
-		XGINew_SetReg1(pVBInfo->P3c4, 0x40, *pVBInfo->pSR40);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x41, *pVBInfo->pSR41);
-	}
-	XGINew_SetReg1(pVBInfo->P3c4, 0x11, 0x0F);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, *pVBInfo->pSR1F);
-	/* XGINew_SetReg1(pVBInfo->P3c4, 0x20, 0x20); */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x20, 0xA0); /* alan, 2001/6/26 Frame buffer can read/write SR20 */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x36, 0x70); /* Hsuan, 2006/01/01 H/W request for slow corner chip */
-	if (HwDeviceExtension->jChipType == XG27) /* Alan 12/07/2006 */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x36, *pVBInfo->pSR36);
-
-	/* SR11 = 0x0F; */
-	/* XGINew_SetReg1(pVBInfo->P3c4, 0x11, SR11); */
-
-	printk("12");
-
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
-		/* Set AGP Rate */
-		/*
-		temp1 = XGINew_GetReg1(pVBInfo->P3c4, 0x3B);
-		temp1 &= 0x02;
-		if (temp1 == 0x02) {
-			XGINew_SetReg4(0xcf8, 0x80000000);
-			ChipsetID = XGINew_GetReg3(0x0cfc);
-			XGINew_SetReg4(0xcf8, 0x8000002C);
-			VendorID = XGINew_GetReg3(0x0cfc);
-			VendorID &= 0x0000FFFF;
-			XGINew_SetReg4(0xcf8, 0x8001002C);
-			GraphicVendorID = XGINew_GetReg3(0x0cfc);
-			GraphicVendorID &= 0x0000FFFF;
-
-			if (ChipsetID == 0x7301039)
-				XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x09);
-
-			ChipsetID &= 0x0000FFFF;
-
-			if ((ChipsetID == 0x700E) || (ChipsetID == 0x1022) || (ChipsetID == 0x1106) || (ChipsetID == 0x10DE)) {
-				if (ChipsetID == 0x1106) {
-					if ((VendorID == 0x1019) && (GraphicVendorID == 0x1019))
-						XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0D);
-					else
-						XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0B);
-				} else {
-					XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0B);
-				}
-			}
-		}
-		*/
-
-		printk("13");
-
-		if (HwDeviceExtension->jChipType >= XG40) {
-			/* Set AGP customize registers (in SetDefAGPRegs) Start */
-			for (i = 0x47; i <= 0x4C; i++)
-				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[i - 0x47]);
-
-			for (i = 0x70; i <= 0x71; i++)
-				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[6 + i - 0x70]);
-
-			for (i = 0x74; i <= 0x77; i++)
-				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
-			/* Set AGP customize registers (in SetDefAGPRegs) End */
-			/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
-			/*        XGINew_SetReg4(0xcf8 , 0x80000000); */
-			/*        ChipsetID = XGINew_GetReg3(0x0cfc); */
-			/*        if (ChipsetID == 0x25308086) */
-			/*            XGINew_SetReg1(pVBInfo->P3d4, 0x77, 0xF0); */
-
-			HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension, 0x50, 0, &Temp); /* Get */
-			Temp >>= 20;
-			Temp &= 0xF;
-
-			if (Temp == 1)
-				XGINew_SetReg1(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
-		}
-		printk("14");
-
-		if (HwDeviceExtension->jChipType < XG40)
-			XGINew_SetReg1(pVBInfo->P3d4, 0x49, pVBInfo->CR49[0]);
-	} /* != XG20 */
-
-	/* Set PCI */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x23, *pVBInfo->pSR23);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x24, *pVBInfo->pSR24);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x25, pVBInfo->SR25[0]);
-	printk("15");
-
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
-		/* Set VB */
-		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
-		XGINew_SetRegANDOR(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00); /* alan, disable VideoCapture */
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x00, 0x00);
-		temp1 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x7B); /* chk if BCLK>=100MHz */
-		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
-
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x02, (*pVBInfo->pCRT2Data_1_2));
-
-		printk("16");
-
-		XGINew_SetReg1(pVBInfo->Part1Port, 0x2E, 0x08); /* use VB */
-	} /* != XG20 */
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x27, 0x1F);
-
-	if ((HwDeviceExtension->jChipType == XG42)
-			&& XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) != 0) { /* Not DDR */
-		XGINew_SetReg1(pVBInfo->P3c4, 0x31, (*pVBInfo->pSR31 & 0x3F) | 0x40);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x32, (*pVBInfo->pSR32 & 0xFC) | 0x01);
-	} else {
-		XGINew_SetReg1(pVBInfo->P3c4, 0x31, *pVBInfo->pSR31);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x32, *pVBInfo->pSR32);
-	}
-	XGINew_SetReg1(pVBInfo->P3c4, 0x33, *pVBInfo->pSR33);
-	printk("17");
-
-	/*
-	 if (HwDeviceExtension->jChipType >= XG40)
-	 SetPowerConsume (HwDeviceExtension, pVBInfo->P3c4);	*/
-
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
-		if (XGI_BridgeIsOn(pVBInfo) == 1) {
-			if (pVBInfo->IF_DEF_LVDS == 0) {
-				XGINew_SetReg1(pVBInfo->Part2Port, 0x00, 0x1C);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x0D, *pVBInfo->pCRT2Data_4_D);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x0E, *pVBInfo->pCRT2Data_4_E);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x10, *pVBInfo->pCRT2Data_4_10);
-				XGINew_SetReg1(pVBInfo->Part4Port, 0x0F, 0x3F);
-			}
-
-			XGI_LockCRT2(HwDeviceExtension, pVBInfo);
-		}
-	} /* != XG20 */
-	printk("18");
-
-	if (HwDeviceExtension->jChipType < XG40)
-		XGINew_SetReg1(pVBInfo->P3d4, 0x83, 0x00);
-	printk("181");
-
-	printk("182");
-
-	XGI_SenseCRT1(pVBInfo);
-
-	printk("183");
-	/* XGINew_DetectMonitor(HwDeviceExtension); */
-	pVBInfo->IF_DEF_CH7007 = 0;
-	if ((HwDeviceExtension->jChipType == XG21) && (pVBInfo->IF_DEF_CH7007)) {
-		printk("184");
-		XGI_GetSenseStatus(HwDeviceExtension, pVBInfo); /* sense CRT2 */
-		printk("185");
-
-	}
-	if (HwDeviceExtension->jChipType == XG21) {
-		printk("186");
-
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
-		temp = GetXG21FPBits(pVBInfo);
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x01, temp);
-		printk("187");
-
-	}
-	if (HwDeviceExtension->jChipType == XG27) {
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
-		temp = GetXG27FPBits(pVBInfo);
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x03, temp);
-	}
-	printk("19");
-
-	if (HwDeviceExtension->jChipType >= XG40) {
-		if (HwDeviceExtension->jChipType >= XG40)
-			XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
-
-		XGINew_SetDRAMDefaultRegister340(HwDeviceExtension, pVBInfo->P3d4, pVBInfo);
-
-		printk("20");
-		XGINew_SetDRAMSize_340(HwDeviceExtension, pVBInfo);
-		printk("21");
-	} /* XG40 */
-
-	printk("22");
-
-	/* SetDefExt2Regs begin */
-	/*
-	AGP = 1;
-	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x3A);
-	temp &= 0x30;
-	if (temp == 0x30)
-		AGP = 0;
-
-	if (AGP == 0)
-		*pVBInfo->pSR21 &= 0xEF;
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
-	if (AGP == 1)
-		*pVBInfo->pSR22 &= 0x20;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22);
-	*/
-	/* base = 0x80000000; */
-	/* OutPortLong(0xcf8, base); */
-	/* Temp = (InPortLong(0xcfc) & 0xFFFF); */
-	/* if (Temp == 0x1039) { */
-	XGINew_SetReg1(pVBInfo->P3c4, 0x22, (unsigned char) ((*pVBInfo->pSR22) & 0xFE));
-	/* } else { */
-	/*	XGINew_SetReg1(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22); */
-	/* } */
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
-
-	printk("23");
-
-	XGINew_ChkSenseStatus(HwDeviceExtension, pVBInfo);
-	XGINew_SetModeScratch(HwDeviceExtension, pVBInfo);
-
-	printk("24");
-
-	XGINew_SetReg1(pVBInfo->P3d4, 0x8c, 0x87);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x31);
-	printk("25");
-
-	return 1;
-} /* end of init */
-
-/* ============== alan ====================== */
-
 static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 					struct vb_device_info *pVBInfo)
 {
@@ -503,6 +127,31 @@ static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBI
 	XGINew_SetReg1(P3c4, 0x1B, 0x00);
 }
 
+static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
+		struct vb_device_info *pVBInfo)
+{
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x28, pVBInfo->MCLKData[XGINew_RAMType].SR28);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x29, pVBInfo->MCLKData[XGINew_RAMType].SR29);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x2A, pVBInfo->MCLKData[XGINew_RAMType].SR2A);
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x2E, pVBInfo->ECLKData[XGINew_RAMType].SR2E);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x2F, pVBInfo->ECLKData[XGINew_RAMType].SR2F);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x30, pVBInfo->ECLKData[XGINew_RAMType].SR30);
+
+	/* [Vicent] 2004/07/07, When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
+	/* [Hsuan] 2004/08/20, Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz, Set SR32 D[1:0] = 10b */
+	if (HwDeviceExtension->jChipType == XG42) {
+		if ((pVBInfo->MCLKData[XGINew_RAMType].SR28 == 0x1C)
+				&& (pVBInfo->MCLKData[XGINew_RAMType].SR29 == 0x01)
+				&& (((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x1C)
+						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))
+					|| ((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x22)
+						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))))
+			XGINew_SetReg1(pVBInfo->P3c4, 0x32, ((unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
+	}
+}
+
 static void XGINew_DDRII_Bootup_XG27(
 			struct xgi_hw_device_info *HwDeviceExtension,
 			unsigned long P3c4, struct vb_device_info *pVBInfo)
@@ -624,6 +273,36 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	DelayUS(200);
 }
 
+static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
+{
+
+	XGINew_SetReg1(P3c4, 0x18, 0x01);
+	XGINew_SetReg1(P3c4, 0x19, 0x40);
+	XGINew_SetReg1(P3c4, 0x16, 0x00);
+	XGINew_SetReg1(P3c4, 0x16, 0x80);
+	DelayUS(60);
+
+	XGINew_SetReg1(P3c4, 0x18, 0x00);
+	XGINew_SetReg1(P3c4, 0x19, 0x40);
+	XGINew_SetReg1(P3c4, 0x16, 0x00);
+	XGINew_SetReg1(P3c4, 0x16, 0x80);
+	DelayUS(60);
+	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
+	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
+	XGINew_SetReg1(P3c4, 0x19, 0x01);
+	XGINew_SetReg1(P3c4, 0x16, 0x03);
+	XGINew_SetReg1(P3c4, 0x16, 0x83);
+	DelayUS(1000);
+	XGINew_SetReg1(P3c4, 0x1B, 0x03);
+	DelayUS(500);
+	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
+	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
+	XGINew_SetReg1(P3c4, 0x19, 0x00);
+	XGINew_SetReg1(P3c4, 0x16, 0x03);
+	XGINew_SetReg1(P3c4, 0x16, 0x83);
+	XGINew_SetReg1(P3c4, 0x1B, 0x00);
+}
+
 static void XGINew_DDR1x_DefaultRegister(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned long Port, struct vb_device_info *pVBInfo)
@@ -835,28 +514,6 @@ static void XGINew_SetDRAMDefaultRegister340(
 	XGINew_SetReg1(P3c4, 0x1B, pVBInfo->SR15[3][XGINew_RAMType]); /* SR1B */
 }
 
-static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
-
-	XGISetModeNew(HwDeviceExtension, 0x2e);
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF)); /* disable read cache */
-	XGI_DisplayOff(HwDeviceExtension, pVBInfo);
-
-	/* data = XGINew_GetReg1(pVBInfo->P3c4, 0x1); */
-	/* data |= 0x20 ; */
-	/* XGINew_SetReg1(pVBInfo->P3c4, 0x01, data); *//* Turn OFF Display */
-	XGINew_DDRSizing340(HwDeviceExtension, pVBInfo);
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
-}
-
 static void XGINew_SetDRAMSizingType(int index,
 		unsigned short DRAMTYPE_TABLE[][5],
 		struct vb_device_info *pVBInfo)
@@ -1290,29 +947,26 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 	return 0;
 }
 
-static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
+	unsigned short data;
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x28, pVBInfo->MCLKData[XGINew_RAMType].SR28);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x29, pVBInfo->MCLKData[XGINew_RAMType].SR29);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2A, pVBInfo->MCLKData[XGINew_RAMType].SR2A);
+	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
+	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
 
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2E, pVBInfo->ECLKData[XGINew_RAMType].SR2E);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2F, pVBInfo->ECLKData[XGINew_RAMType].SR2F);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x30, pVBInfo->ECLKData[XGINew_RAMType].SR30);
+	XGISetModeNew(HwDeviceExtension, 0x2e);
 
-	/* [Vicent] 2004/07/07, When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
-	/* [Hsuan] 2004/08/20, Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz, Set SR32 D[1:0] = 10b */
-	if (HwDeviceExtension->jChipType == XG42) {
-		if ((pVBInfo->MCLKData[XGINew_RAMType].SR28 == 0x1C)
-				&& (pVBInfo->MCLKData[XGINew_RAMType].SR29 == 0x01)
-				&& (((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x1C)
-						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))
-					|| ((pVBInfo->ECLKData[XGINew_RAMType].SR2E == 0x22)
-						&& (pVBInfo->ECLKData[XGINew_RAMType].SR2F == 0x01))))
-			XGINew_SetReg1(pVBInfo->P3c4, 0x32, ((unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x32) & 0xFC) | 0x02);
-	}
+	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF)); /* disable read cache */
+	XGI_DisplayOff(HwDeviceExtension, pVBInfo);
+
+	/* data = XGINew_GetReg1(pVBInfo->P3c4, 0x1); */
+	/* data |= 0x20 ; */
+	/* XGINew_SetReg1(pVBInfo->P3c4, 0x01, data); *//* Turn OFF Display */
+	XGINew_DDRSizing340(HwDeviceExtension, pVBInfo);
+	data = XGINew_GetReg1(pVBInfo->P3c4, 0x21);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x21, (unsigned short) (data | 0x20)); /* enable read cache */
 }
 
 static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo)
@@ -1405,36 +1059,6 @@ static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVB
 	}
 }
 
-static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
-{
-
-	XGINew_SetReg1(P3c4, 0x18, 0x01);
-	XGINew_SetReg1(P3c4, 0x19, 0x40);
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-	DelayUS(60);
-
-	XGINew_SetReg1(P3c4, 0x18, 0x00);
-	XGINew_SetReg1(P3c4, 0x19, 0x40);
-	XGINew_SetReg1(P3c4, 0x16, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x80);
-	DelayUS(60);
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
-	XGINew_SetReg1(P3c4, 0x19, 0x01);
-	XGINew_SetReg1(P3c4, 0x16, 0x03);
-	XGINew_SetReg1(P3c4, 0x16, 0x83);
-	DelayUS(1000);
-	XGINew_SetReg1(P3c4, 0x1B, 0x03);
-	DelayUS(500);
-	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
-	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
-	XGINew_SetReg1(P3c4, 0x19, 0x00);
-	XGINew_SetReg1(P3c4, 0x16, 0x03);
-	XGINew_SetReg1(P3c4, 0x16, 0x83);
-	XGINew_SetReg1(P3c4, 0x1B, 0x00);
-}
-
 static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -1657,3 +1281,360 @@ static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
 	return temp;
 }
 
+unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
+{
+	struct vb_device_info VBINF;
+	struct vb_device_info *pVBInfo = &VBINF;
+	unsigned char i, temp = 0, temp1;
+	/* VBIOSVersion[5]; */
+	volatile unsigned char *pVideoMemory;
+
+	/* unsigned long j, k; */
+
+	unsigned long Temp;
+
+	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
+
+	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
+
+	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
+
+	pVideoMemory = (unsigned char *) pVBInfo->ROMAddr;
+
+	/* Newdebugcode(0x99); */
+
+
+	/* if (pVBInfo->ROMAddr == 0) */
+	/* return(0); */
+
+	if (pVBInfo->FBAddr == NULL) {
+		printk("\n pVBInfo->FBAddr == 0 ");
+		return 0;
+	}
+	printk("1");
+	if (pVBInfo->BaseAddr == 0) {
+		printk("\npVBInfo->BaseAddr == 0 ");
+		return 0;
+	}
+	printk("2");
+
+	XGINew_SetReg3((pVBInfo->BaseAddr + 0x12), 0x67); /* 3c2 <- 67 ,ynlai */
+
+	pVBInfo->ISXPDOS = 0;
+	printk("3");
+
+	printk("4");
+
+	/* VBIOSVersion[4] = 0x0; */
+
+	/* 09/07/99 modify by domao */
+
+	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
+	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
+	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
+	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
+	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
+	pVBInfo->P3ca = pVBInfo->BaseAddr + 0x1a;
+	pVBInfo->P3c6 = pVBInfo->BaseAddr + 0x16;
+	pVBInfo->P3c7 = pVBInfo->BaseAddr + 0x17;
+	pVBInfo->P3c8 = pVBInfo->BaseAddr + 0x18;
+	pVBInfo->P3c9 = pVBInfo->BaseAddr + 0x19;
+	pVBInfo->P3da = pVBInfo->BaseAddr + 0x2A;
+	pVBInfo->Part0Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_00;
+	pVBInfo->Part1Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_04;
+	pVBInfo->Part2Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_10;
+	pVBInfo->Part3Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_12;
+	pVBInfo->Part4Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14;
+	pVBInfo->Part5Port = pVBInfo->BaseAddr + XGI_CRT2_PORT_14 + 2;
+	printk("5");
+
+	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
+		XGI_GetVBType(pVBInfo); /* Run XGI_GetVBType before InitTo330Pointer */
+
+	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
+
+	/* ReadVBIOSData */
+	ReadVBIOSTablData(HwDeviceExtension->jChipType, pVBInfo);
+
+	/* 1.Openkey */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
+	printk("6");
+
+	/* GetXG21Sense (GPIO) */
+	if (HwDeviceExtension->jChipType == XG21)
+		XGINew_GetXG21Sense(HwDeviceExtension, pVBInfo);
+
+	if (HwDeviceExtension->jChipType == XG27)
+		XGINew_GetXG27Sense(HwDeviceExtension, pVBInfo);
+
+	printk("7");
+
+	/* 2.Reset Extended register */
+
+	for (i = 0x06; i < 0x20; i++)
+		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
+
+	for (i = 0x21; i <= 0x27; i++)
+		XGINew_SetReg1(pVBInfo->P3c4, i, 0);
+
+	/* for(i = 0x06; i <= 0x27; i++) */
+	/* XGINew_SetReg1(pVBInfo->P3c4, i, 0); */
+
+	printk("8");
+
+	if ((HwDeviceExtension->jChipType >= XG20) || (HwDeviceExtension->jChipType >= XG40)) {
+		for (i = 0x31; i <= 0x3B; i++)
+			XGINew_SetReg1(pVBInfo->P3c4, i, 0);
+	} else {
+		for (i = 0x31; i <= 0x3D; i++)
+			XGINew_SetReg1(pVBInfo->P3c4, i, 0);
+	}
+	printk("9");
+
+	if (HwDeviceExtension->jChipType == XG42) /* [Hsuan] 2004/08/20 Auto over driver for XG42 */
+		XGINew_SetReg1(pVBInfo->P3c4, 0x3B, 0xC0);
+
+	/* for (i = 0x30; i <= 0x3F; i++) */
+	/* XGINew_SetReg1(pVBInfo->P3d4, i, 0); */
+
+	for (i = 0x79; i <= 0x7C; i++)
+		XGINew_SetReg1(pVBInfo->P3d4, i, 0); /* shampoo 0208 */
+
+	printk("10");
+
+	if (HwDeviceExtension->jChipType >= XG20)
+		XGINew_SetReg1(pVBInfo->P3d4, 0x97, *pVBInfo->pXGINew_CR97);
+
+	/* 3.SetMemoryClock
+
+	 if (HwDeviceExtension->jChipType >= XG40)
+	 XGINew_RAMType = (int)XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
+
+	 if (HwDeviceExtension->jChipType < XG40)
+	 XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);  */
+
+	printk("11");
+
+	/* 4.SetDefExt1Regs begin */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x07, *pVBInfo->pSR07);
+	if (HwDeviceExtension->jChipType == XG27) {
+		XGINew_SetReg1(pVBInfo->P3c4, 0x40, *pVBInfo->pSR40);
+		XGINew_SetReg1(pVBInfo->P3c4, 0x41, *pVBInfo->pSR41);
+	}
+	XGINew_SetReg1(pVBInfo->P3c4, 0x11, 0x0F);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, *pVBInfo->pSR1F);
+	/* XGINew_SetReg1(pVBInfo->P3c4, 0x20, 0x20); */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x20, 0xA0); /* alan, 2001/6/26 Frame buffer can read/write SR20 */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x36, 0x70); /* Hsuan, 2006/01/01 H/W request for slow corner chip */
+	if (HwDeviceExtension->jChipType == XG27) /* Alan 12/07/2006 */
+		XGINew_SetReg1(pVBInfo->P3c4, 0x36, *pVBInfo->pSR36);
+
+	/* SR11 = 0x0F; */
+	/* XGINew_SetReg1(pVBInfo->P3c4, 0x11, SR11); */
+
+	printk("12");
+
+	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+		/* Set AGP Rate */
+		/*
+		temp1 = XGINew_GetReg1(pVBInfo->P3c4, 0x3B);
+		temp1 &= 0x02;
+		if (temp1 == 0x02) {
+			XGINew_SetReg4(0xcf8, 0x80000000);
+			ChipsetID = XGINew_GetReg3(0x0cfc);
+			XGINew_SetReg4(0xcf8, 0x8000002C);
+			VendorID = XGINew_GetReg3(0x0cfc);
+			VendorID &= 0x0000FFFF;
+			XGINew_SetReg4(0xcf8, 0x8001002C);
+			GraphicVendorID = XGINew_GetReg3(0x0cfc);
+			GraphicVendorID &= 0x0000FFFF;
+
+			if (ChipsetID == 0x7301039)
+				XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x09);
+
+			ChipsetID &= 0x0000FFFF;
+
+			if ((ChipsetID == 0x700E) || (ChipsetID == 0x1022) || (ChipsetID == 0x1106) || (ChipsetID == 0x10DE)) {
+				if (ChipsetID == 0x1106) {
+					if ((VendorID == 0x1019) && (GraphicVendorID == 0x1019))
+						XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0D);
+					else
+						XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0B);
+				} else {
+					XGINew_SetReg1(pVBInfo->P3d4, 0x5F, 0x0B);
+				}
+			}
+		}
+		*/
+
+		printk("13");
+
+		if (HwDeviceExtension->jChipType >= XG40) {
+			/* Set AGP customize registers (in SetDefAGPRegs) Start */
+			for (i = 0x47; i <= 0x4C; i++)
+				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[i - 0x47]);
+
+			for (i = 0x70; i <= 0x71; i++)
+				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[6 + i - 0x70]);
+
+			for (i = 0x74; i <= 0x77; i++)
+				XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
+			/* Set AGP customize registers (in SetDefAGPRegs) End */
+			/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
+			/*        XGINew_SetReg4(0xcf8 , 0x80000000); */
+			/*        ChipsetID = XGINew_GetReg3(0x0cfc); */
+			/*        if (ChipsetID == 0x25308086) */
+			/*            XGINew_SetReg1(pVBInfo->P3d4, 0x77, 0xF0); */
+
+			HwDeviceExtension->pQueryVGAConfigSpace(HwDeviceExtension, 0x50, 0, &Temp); /* Get */
+			Temp >>= 20;
+			Temp &= 0xF;
+
+			if (Temp == 1)
+				XGINew_SetReg1(pVBInfo->P3d4, 0x48, 0x20); /* CR48 */
+		}
+		printk("14");
+
+		if (HwDeviceExtension->jChipType < XG40)
+			XGINew_SetReg1(pVBInfo->P3d4, 0x49, pVBInfo->CR49[0]);
+	} /* != XG20 */
+
+	/* Set PCI */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x23, *pVBInfo->pSR23);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x24, *pVBInfo->pSR24);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x25, pVBInfo->SR25[0]);
+	printk("15");
+
+	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+		/* Set VB */
+		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
+		XGINew_SetRegANDOR(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00); /* alan, disable VideoCapture */
+		XGINew_SetReg1(pVBInfo->Part1Port, 0x00, 0x00);
+		temp1 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x7B); /* chk if BCLK>=100MHz */
+		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
+
+		XGINew_SetReg1(pVBInfo->Part1Port, 0x02, (*pVBInfo->pCRT2Data_1_2));
+
+		printk("16");
+
+		XGINew_SetReg1(pVBInfo->Part1Port, 0x2E, 0x08); /* use VB */
+	} /* != XG20 */
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x27, 0x1F);
+
+	if ((HwDeviceExtension->jChipType == XG42)
+			&& XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo) != 0) { /* Not DDR */
+		XGINew_SetReg1(pVBInfo->P3c4, 0x31, (*pVBInfo->pSR31 & 0x3F) | 0x40);
+		XGINew_SetReg1(pVBInfo->P3c4, 0x32, (*pVBInfo->pSR32 & 0xFC) | 0x01);
+	} else {
+		XGINew_SetReg1(pVBInfo->P3c4, 0x31, *pVBInfo->pSR31);
+		XGINew_SetReg1(pVBInfo->P3c4, 0x32, *pVBInfo->pSR32);
+	}
+	XGINew_SetReg1(pVBInfo->P3c4, 0x33, *pVBInfo->pSR33);
+	printk("17");
+
+	/*
+	 if (HwDeviceExtension->jChipType >= XG40)
+	 SetPowerConsume (HwDeviceExtension, pVBInfo->P3c4);	*/
+
+	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+		if (XGI_BridgeIsOn(pVBInfo) == 1) {
+			if (pVBInfo->IF_DEF_LVDS == 0) {
+				XGINew_SetReg1(pVBInfo->Part2Port, 0x00, 0x1C);
+				XGINew_SetReg1(pVBInfo->Part4Port, 0x0D, *pVBInfo->pCRT2Data_4_D);
+				XGINew_SetReg1(pVBInfo->Part4Port, 0x0E, *pVBInfo->pCRT2Data_4_E);
+				XGINew_SetReg1(pVBInfo->Part4Port, 0x10, *pVBInfo->pCRT2Data_4_10);
+				XGINew_SetReg1(pVBInfo->Part4Port, 0x0F, 0x3F);
+			}
+
+			XGI_LockCRT2(HwDeviceExtension, pVBInfo);
+		}
+	} /* != XG20 */
+	printk("18");
+
+	if (HwDeviceExtension->jChipType < XG40)
+		XGINew_SetReg1(pVBInfo->P3d4, 0x83, 0x00);
+	printk("181");
+
+	printk("182");
+
+	XGI_SenseCRT1(pVBInfo);
+
+	printk("183");
+	/* XGINew_DetectMonitor(HwDeviceExtension); */
+	pVBInfo->IF_DEF_CH7007 = 0;
+	if ((HwDeviceExtension->jChipType == XG21) && (pVBInfo->IF_DEF_CH7007)) {
+		printk("184");
+		XGI_GetSenseStatus(HwDeviceExtension, pVBInfo); /* sense CRT2 */
+		printk("185");
+
+	}
+	if (HwDeviceExtension->jChipType == XG21) {
+		printk("186");
+
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		temp = GetXG21FPBits(pVBInfo);
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x01, temp);
+		printk("187");
+
+	}
+	if (HwDeviceExtension->jChipType == XG27) {
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		temp = GetXG27FPBits(pVBInfo);
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x03, temp);
+	}
+	printk("19");
+
+	if (HwDeviceExtension->jChipType >= XG40) {
+		if (HwDeviceExtension->jChipType >= XG40)
+			XGINew_RAMType = (int) XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
+
+		XGINew_SetDRAMDefaultRegister340(HwDeviceExtension, pVBInfo->P3d4, pVBInfo);
+
+		printk("20");
+		XGINew_SetDRAMSize_340(HwDeviceExtension, pVBInfo);
+		printk("21");
+	} /* XG40 */
+
+	printk("22");
+
+	/* SetDefExt2Regs begin */
+	/*
+	AGP = 1;
+	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x3A);
+	temp &= 0x30;
+	if (temp == 0x30)
+		AGP = 0;
+
+	if (AGP == 0)
+		*pVBInfo->pSR21 &= 0xEF;
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
+	if (AGP == 1)
+		*pVBInfo->pSR22 &= 0x20;
+	XGINew_SetReg1(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22);
+	*/
+	/* base = 0x80000000; */
+	/* OutPortLong(0xcf8, base); */
+	/* Temp = (InPortLong(0xcfc) & 0xFFFF); */
+	/* if (Temp == 0x1039) { */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x22, (unsigned char) ((*pVBInfo->pSR22) & 0xFE));
+	/* } else { */
+	/*	XGINew_SetReg1(pVBInfo->P3c4, 0x22, *pVBInfo->pSR22); */
+	/* } */
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x21, *pVBInfo->pSR21);
+
+	printk("23");
+
+	XGINew_ChkSenseStatus(HwDeviceExtension, pVBInfo);
+	XGINew_SetModeScratch(HwDeviceExtension, pVBInfo);
+
+	printk("24");
+
+	XGINew_SetReg1(pVBInfo->P3d4, 0x8c, 0x87);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x14, 0x31);
+	printk("25");
+
+	return 1;
+} /* end of init */
-- 
1.5.6.5

