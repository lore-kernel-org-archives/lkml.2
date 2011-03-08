Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1CHUSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:18:52 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58631 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1CHUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 11/15] staging: xgifb: vb_ext: delete unused functions
Date: Tue,  8 Mar 2011 22:16:16 +0200
Message-Id: <1299615380-22922-12-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused functions.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.c |  437 ----------------------------------------
 drivers/staging/xgifb/vb_ext.h |    3 -
 2 files changed, 0 insertions(+), 440 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index e1f9188..cc78815 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -34,28 +34,6 @@ static unsigned char XGINew_Is301B(struct vb_device_info *pVBInfo)
 		return 1;
 }
 
-unsigned char XGI_Is301C(struct vb_device_info *pVBInfo)
-{
-	if ((XGINew_GetReg1(pVBInfo->Part4Port, 0x01) & 0xF0) == 0xC0)
-		return 1;
-
-	if (XGINew_GetReg1(pVBInfo->Part4Port, 0x01) >= 0xD0) {
-		if (XGINew_GetReg1(pVBInfo->Part4Port, 0x39) == 0xE0)
-			return 1;
-	}
-
-	return 0;
-}
-
-unsigned char XGI_Is301LV(struct vb_device_info *pVBInfo)
-{
-	if (XGINew_GetReg1(pVBInfo->Part4Port, 0x01) >= 0xD0) {
-		if (XGINew_GetReg1(pVBInfo->Part4Port, 0x39) == 0xFF)
-			return 1;
-	}
-	return 0;
-}
-
 unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp, i, tempch;
@@ -80,190 +58,6 @@ unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx, struct
 		return 0;
 }
 
-void XGISetDPMS(struct xgi_hw_device_info *pXGIHWDE, unsigned long VESA_POWER_STATE)
-{
-	unsigned short ModeNo, ModeIdIndex;
-	unsigned char temp;
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-	pVBInfo->BaseAddr = (unsigned long) pXGIHWDE->pjIOAddress;
-	pVBInfo->ROMAddr = pXGIHWDE->pjVirtualRomBase;
-
-	pVBInfo->IF_DEF_LVDS = 0;
-	pVBInfo->IF_DEF_CH7005 = 0;
-	pVBInfo->IF_DEF_HiVision = 1;
-	pVBInfo->IF_DEF_LCDA = 1;
-	pVBInfo->IF_DEF_CH7017 = 0;
-	pVBInfo->IF_DEF_YPbPr = 1;
-	pVBInfo->IF_DEF_CRT2Monitor = 0;
-	pVBInfo->IF_DEF_VideoCapture = 0;
-	pVBInfo->IF_DEF_ScaleLCD = 0;
-	pVBInfo->IF_DEF_OEMUtil = 0;
-	pVBInfo->IF_DEF_PWD = 0;
-
-	InitTo330Pointer(pXGIHWDE->jChipType, pVBInfo);
-	ReadVBIOSTablData(pXGIHWDE->jChipType, pVBInfo);
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
-	if (pXGIHWDE->jChipType == XG27) {
-		if ((XGINew_GetReg1(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0) {
-			if (XGINew_GetReg1(pVBInfo->P3d4, 0x30) & 0x20)
-				pVBInfo->IF_DEF_LVDS = 1;
-		}
-	}
-
-	if (pVBInfo->IF_DEF_CH7007 == 0)
-		XGINew_SetModeScratch(pXGIHWDE, pVBInfo);
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86); /* 1.Openkey */
-	XGI_UnLockCRT2(pXGIHWDE, pVBInfo);
-	ModeNo = XGINew_GetReg1(pVBInfo->P3d4, 0x34);
-	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
-	XGI_GetVGAType(pXGIHWDE, pVBInfo);
-
-	if ((pXGIHWDE->ujVBChipID == VB_CHIP_301) || (pXGIHWDE->ujVBChipID == VB_CHIP_302) || (pVBInfo->IF_DEF_CH7007 == 1)) {
-		XGI_GetVBType(pVBInfo);
-		XGI_GetVBInfo(ModeNo, ModeIdIndex, pXGIHWDE, pVBInfo);
-		XGI_GetTVInfo(ModeNo, ModeIdIndex, pVBInfo);
-		XGI_GetLCDInfo(ModeNo, ModeIdIndex, pVBInfo);
-	}
-
-	if (VESA_POWER_STATE == 0x00000400)
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x31, (unsigned char) (XGINew_GetReg1(pVBInfo->Part4Port, 0x31) & 0xFE));
-	else
-		XGINew_SetReg1(pVBInfo->Part4Port, 0x31, (unsigned char) (XGINew_GetReg1(pVBInfo->Part4Port, 0x31) | 0x01));
-
-	temp = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x1f);
-	temp &= 0x3f;
-	switch (VESA_POWER_STATE) {
-	case 0x00000000: /* on */
-		if ((pXGIHWDE->ujVBChipID == VB_CHIP_301) || (pXGIHWDE->ujVBChipID == VB_CHIP_302)) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x1f, (unsigned char) (temp | 0x00));
-			XGI_EnableBridge(pXGIHWDE, pVBInfo);
-		} else {
-			if (pXGIHWDE->jChipType == XG21) {
-				if (pVBInfo->IF_DEF_LVDS == 1) {
-					XGI_XG21BLSignalVDD(0x01, 0x01, pVBInfo); /* LVDS VDD on */
-					XGI_XG21SetPanelDelay(2, pVBInfo);
-				}
-			}
-			if (pXGIHWDE->jChipType == XG27) {
-				if (pVBInfo->IF_DEF_LVDS == 1) {
-					XGI_XG27BLSignalVDD(0x01, 0x01, pVBInfo); /* LVDS VDD on */
-					XGI_XG21SetPanelDelay(2, pVBInfo);
-				}
-			}
-			XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1F, ~0xC0, 0x00);
-			XGINew_SetRegAND(pVBInfo->P3c4, 0x01, ~0x20); /* CRT on */
-
-			if (pXGIHWDE->jChipType == XG21) {
-				temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
-				if (temp & 0xE0) {
-					XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0x80, 0x80); /* DVO ON */
-					XGI_SetXG21FPBits(pVBInfo);
-					XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); /* Enable write GPIOF */
-					/* XGINew_SetRegANDOR(pVBInfo->P3d4, 0x48, ~0x20, 0x20); *//* LCD Display ON */
-				}
-				XGI_XG21BLSignalVDD(0x20, 0x20, pVBInfo); /* LVDS signal on */
-				XGI_DisplayOn(pXGIHWDE, pVBInfo);
-			}
-			if (pXGIHWDE->jChipType == XG27) {
-				temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
-				if (temp & 0xE0) {
-					XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0x80, 0x80); /* DVO ON */
-					XGI_SetXG27FPBits(pVBInfo);
-					XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); /* Enable write GPIOF */
-					/* XGINew_SetRegANDOR(pVBInfo->P3d4, 0x48, ~0x20, 0x20); *//* LCD Display ON */
-				}
-				XGI_XG27BLSignalVDD(0x20, 0x20, pVBInfo); /* LVDS signal on */
-				XGI_DisplayOn(pXGIHWDE, pVBInfo);
-			}
-		}
-		break;
-
-	case 0x00000100: /* standby */
-		if (pXGIHWDE->jChipType >= XG21)
-			XGI_DisplayOff(pXGIHWDE, pVBInfo);
-		XGINew_SetReg1(pVBInfo->P3c4, 0x1f, (unsigned char) (temp | 0x40));
-		break;
-
-	case 0x00000200: /* suspend */
-		if (pXGIHWDE->jChipType == XG21) {
-			XGI_DisplayOff(pXGIHWDE, pVBInfo);
-			XGI_XG21BLSignalVDD(0x20, 0x00, pVBInfo); /* LVDS signal off */
-		}
-		if (pXGIHWDE->jChipType == XG27) {
-			XGI_DisplayOff(pXGIHWDE, pVBInfo);
-			XGI_XG27BLSignalVDD(0x20, 0x00, pVBInfo); /* LVDS signal off */
-		}
-		XGINew_SetReg1(pVBInfo->P3c4, 0x1f, (unsigned char) (temp | 0x80));
-		break;
-
-	case 0x00000400: /* off */
-		if ((pXGIHWDE->ujVBChipID == VB_CHIP_301) || (pXGIHWDE->ujVBChipID == VB_CHIP_302)) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x1f, (unsigned char) (temp | 0xc0));
-			XGI_DisableBridge(pXGIHWDE, pVBInfo);
-		} else {
-			if (pXGIHWDE->jChipType == XG21) {
-				XGI_DisplayOff(pXGIHWDE, pVBInfo);
-
-				XGI_XG21BLSignalVDD(0x20, 0x00, pVBInfo); /* LVDS signal off */
-
-				temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
-				if (temp & 0xE0) {
-					XGINew_SetRegAND(pVBInfo->P3c4, 0x09, ~0x80); /* DVO Off */
-					XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); /* Enable write GPIOF */
-					/* XGINew_SetRegAND(pVBInfo->P3d4, 0x48, ~0x20); *//* LCD Display OFF */
-				}
-			}
-			if (pXGIHWDE->jChipType == XG27) {
-				XGI_DisplayOff(pXGIHWDE, pVBInfo);
-
-				XGI_XG27BLSignalVDD(0x20, 0x00, pVBInfo); /* LVDS signal off */
-
-				temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
-				if (temp & 0xE0)
-					XGINew_SetRegAND(pVBInfo->P3c4, 0x09, ~0x80); /* DVO Off */
-			}
-			XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1F, ~0xC0, 0xC0);
-			XGINew_SetRegOR(pVBInfo->P3c4, 0x01, 0x20); /* CRT Off */
-
-			if ((pXGIHWDE->jChipType == XG21) && (pVBInfo->IF_DEF_LVDS == 1)) {
-				XGI_XG21SetPanelDelay(4, pVBInfo);
-				XGI_XG21BLSignalVDD(0x01, 0x00, pVBInfo); /* LVDS VDD off */
-				XGI_XG21SetPanelDelay(5, pVBInfo);
-			}
-			if ((pXGIHWDE->jChipType == XG27) && (pVBInfo->IF_DEF_LVDS == 1)) {
-				XGI_XG21SetPanelDelay(4, pVBInfo);
-				XGI_XG27BLSignalVDD(0x01, 0x00, pVBInfo); /* LVDS VDD off */
-				XGI_XG21SetPanelDelay(5, pVBInfo);
-			}
-		}
-		break;
-
-	default:
-		break;
-	}
-	XGI_LockCRT2(pXGIHWDE, pVBInfo);
-}
-
 void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
 {
 	unsigned short tempax = 0, tempbx, tempcx, temp, P2reg0 = 0, SenseModeNo = 0,
@@ -607,234 +401,3 @@ unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension, str
 			return 0;
 	}
 }
-
-/* ----------------------------------------------------------------------------
- *       Description: Get Panel support
- *	O/P	   :
- *            BL: Panel ID=81h for no scaler LVDS
- *		     BH: Panel enhanced Mode Count
- *		     CX: Panel H. resolution
- *		     DX: PAnel V. resolution
- * ----------------------------------------------------------------------------
- */
-static void XGI_XG21Fun14Sub70(struct vb_device_info *pVBInfo, PX86_REGS pBiosArguments)
-{
-	unsigned short ModeIdIndex;
-	unsigned short ModeNo;
-
-	unsigned short EModeCount;
-	unsigned short lvdstableindex;
-
-	lvdstableindex = XGI_GetLVDSOEMTableIndex(pVBInfo);
-	pBiosArguments->h.bl = 0x81;
-	pBiosArguments->x.cx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSHDE;
-	pBiosArguments->x.dx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVDE;
-	EModeCount = 0;
-
-	pBiosArguments->x.ax = 0x0014;
-	for (ModeIdIndex = 0;; ModeIdIndex++) {
-		ModeNo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeID;
-		if (pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeID == 0xFF) {
-			pBiosArguments->h.bh = (unsigned char) EModeCount;
-			return;
-		}
-		if (!XGI_XG21CheckLVDSMode(ModeNo, ModeIdIndex, pVBInfo))
-			continue;
-
-		EModeCount++;
-	}
-}
-
-/* ----------------------------------------------------------------------------
- *
- *       Description: Get Panel mode ID for enhanced mode
- *	I/P	   : BH: EModeIndex ( which < Panel enhanced Mode Count )
- *	O/P	   :
- *            BL: Mode ID
- *		     CX: H. resolution of the assigned by the index
- *		     DX: V. resolution of the assigned by the index
- *
- * ----------------------------------------------------------------------------
- */
-
-static void XGI_XG21Fun14Sub71(struct vb_device_info *pVBInfo, PX86_REGS pBiosArguments)
-{
-
-	unsigned short EModeCount;
-	unsigned short ModeIdIndex, resindex;
-	unsigned short ModeNo;
-	unsigned short EModeIndex = pBiosArguments->h.bh;
-
-	EModeCount = 0;
-	for (ModeIdIndex = 0;; ModeIdIndex++) {
-		ModeNo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeID;
-		if (pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeID == 0xFF) {
-			pBiosArguments->x.ax = 0x0114;
-			return;
-		}
-		if (!XGI_XG21CheckLVDSMode(ModeNo, ModeIdIndex, pVBInfo))
-			continue;
-
-		if (EModeCount == EModeIndex) {
-			resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
-			pBiosArguments->h.bl = (unsigned char) ModeNo;
-			pBiosArguments->x.cx = pVBInfo->ModeResInfo[resindex].HTotal; /* xres->ax */
-			pBiosArguments->x.dx = pVBInfo->ModeResInfo[resindex].VTotal; /* yres->bx */
-			pBiosArguments->x.ax = 0x0014;
-		}
-		EModeCount++;
-
-	}
-
-}
-
-/* ----------------------------------------------------------------------------
- *
- *       Description: Validate Panel modes ID support
- *	I/P	   :
- *            BL: ModeID
- *	O/P	   :
- *		     CX: H. resolution of the assigned by the index
- *		     DX: V. resolution of the assigned by the index
- *
- * ----------------------------------------------------------------------------
- */
-static void XGI_XG21Fun14Sub72(struct vb_device_info *pVBInfo, PX86_REGS pBiosArguments)
-{
-	unsigned short ModeIdIndex, resindex;
-	unsigned short ModeNo;
-
-	ModeNo = pBiosArguments->h.bl;
-	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
-	if (!XGI_XG21CheckLVDSMode(ModeNo, ModeIdIndex, pVBInfo)) {
-		pBiosArguments->x.cx = 0;
-		pBiosArguments->x.dx = 0;
-		pBiosArguments->x.ax = 0x0114;
-		return;
-	}
-	resindex = XGI_GetResInfo(ModeNo, ModeIdIndex, pVBInfo);
-	if (ModeNo <= 0x13) {
-		pBiosArguments->x.cx = pVBInfo->StResInfo[resindex].HTotal;
-		pBiosArguments->x.dx = pVBInfo->StResInfo[resindex].VTotal;
-	} else {
-		pBiosArguments->x.cx = pVBInfo->ModeResInfo[resindex].HTotal; /* xres->ax */
-		pBiosArguments->x.dx = pVBInfo->ModeResInfo[resindex].VTotal; /* yres->bx */
-	}
-
-	pBiosArguments->x.ax = 0x0014;
-
-}
-
-/* ----------------------------------------------------------------------------
- *
- *	Description: Get Customized Panel misc. information support
- *	I/P	   : Select
- *		     to get panel horizontal timing
- *			 to get panel vertical timing
- *			 to get channel clock parameter
- *            to get panel misc information
- *
- *	O/P	   :
- *		     BL: for input Select = 0 ;
- *                       BX: *Value1 = Horizontal total
- *                       CX: *Value2 = Horizontal front porch
- *                       DX: *Value2 = Horizontal sync width
- *		     BL: for input Select = 1 ;
- *                       BX: *Value1 = Vertical total
- *                       CX: *Value2 = Vertical front porch
- *                       DX: *Value2 = Vertical sync width
- *            BL: for input Select = 2 ;
- *                       BX: Value1 = The first CLK parameter
- *                       CX: Value2 = The second CLK parameter
- *		     BL: for input Select = 4 ;
- *                       BX[15]: *Value1 D[15] VESA V. Polarity
- *                       BX[14]: *Value1 D[14] VESA H. Polarity
- *                       BX[7]: *Value1 D[7] Panel V. Polarity
- *                       BX[6]: *Value1 D[6] Panel H. Polarity
- * ----------------------------------------------------------------------------
- */
-static void XGI_XG21Fun14Sub73(struct vb_device_info *pVBInfo, PX86_REGS pBiosArguments)
-{
-	unsigned char Select;
-
-	unsigned short lvdstableindex;
-
-	lvdstableindex = XGI_GetLVDSOEMTableIndex(pVBInfo);
-	Select = pBiosArguments->h.bl;
-
-	switch (Select) {
-	case 0:
-		pBiosArguments->x.bx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSHT;
-		pBiosArguments->x.cx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSHFP;
-		pBiosArguments->x.dx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSHSYNC;
-		break;
-	case 1:
-		pBiosArguments->x.bx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVT;
-		pBiosArguments->x.cx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVFP;
-		pBiosArguments->x.dx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDSVSYNC;
-		break;
-	case 2:
-		pBiosArguments->x.bx = pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData1;
-		pBiosArguments->x.cx = pVBInfo->XG21_LVDSCapList[lvdstableindex].VCLKData2;
-		break;
-	case 4:
-		pBiosArguments->x.bx = pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability;
-		break;
-	}
-
-	pBiosArguments->x.ax = 0x0014;
-}
-
-void XGI_XG21Fun14(struct xgi_hw_device_info *pXGIHWDE, PX86_REGS pBiosArguments)
-{
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-
-	pVBInfo->IF_DEF_LVDS = 0;
-	pVBInfo->IF_DEF_CH7005 = 0;
-	pVBInfo->IF_DEF_HiVision = 1;
-	pVBInfo->IF_DEF_LCDA = 1;
-	pVBInfo->IF_DEF_CH7017 = 0;
-	pVBInfo->IF_DEF_YPbPr = 1;
-	pVBInfo->IF_DEF_CRT2Monitor = 0;
-	pVBInfo->IF_DEF_VideoCapture = 0;
-	pVBInfo->IF_DEF_ScaleLCD = 0;
-	pVBInfo->IF_DEF_OEMUtil = 0;
-	pVBInfo->IF_DEF_PWD = 0;
-
-	InitTo330Pointer(pXGIHWDE->jChipType, pVBInfo);
-	ReadVBIOSTablData(pXGIHWDE->jChipType, pVBInfo);
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
-	switch (pBiosArguments->x.ax) {
-	case 0x1470:
-		XGI_XG21Fun14Sub70(pVBInfo, pBiosArguments);
-		break;
-	case 0x1471:
-		XGI_XG21Fun14Sub71(pVBInfo, pBiosArguments);
-		break;
-	case 0x1472:
-		XGI_XG21Fun14Sub72(pVBInfo, pBiosArguments);
-		break;
-	case 0x1473:
-		XGI_XG21Fun14Sub73(pVBInfo, pBiosArguments);
-		break;
-	}
-}
diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
index 5cc4d12..6824525 100644
--- a/drivers/staging/xgifb/vb_ext.h
+++ b/drivers/staging/xgifb/vb_ext.h
@@ -21,9 +21,6 @@ typedef union   _X86_REGS    {
     struct  BYTEREGS h;
 } X86_REGS, *PX86_REGS;
 
-extern   void     XGI_XG21Fun14(struct xgi_hw_device_info *pXGIHWDE, PX86_REGS pBiosArguments);
-extern void XGISetDPMS(struct xgi_hw_device_info *pXGIHWDE,
-		       unsigned long VESA_POWER_STATE);
 extern   void     XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 extern   void     XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
 extern void ReadVBIOSTablData(unsigned char ChipType,
-- 
1.5.6.5

