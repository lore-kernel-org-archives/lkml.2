Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1CMK1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:00 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:48549 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab1CMK0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:22 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 03/24] staging: xgifb: vb_setmode: move functions to avoid forward declarations
Date: Sun, 13 Mar 2011 12:26:07 +0200
Message-Id: <1300011988-2109-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move functions to avoid forward declarations.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_setmode.c | 4445 ++++++++++++++++++------------------
 1 files changed, 2166 insertions(+), 2279 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 5423524..693be07 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -19,118 +19,6 @@
 #define XGI_MASK_DUAL_CHIP	  0x04  /* SR3A */
 #endif
 
-
-
-static unsigned char  XGI_AjustCRT2Rate(unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			unsigned short RefreshRateTableIndex,
-			unsigned short *i, struct vb_device_info *pVBInfo);
-static unsigned char  XGI_GetModePtr(unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			struct vb_device_info *pVBInfo);
-static unsigned short XGI_GetOffset(unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			unsigned short RefreshRateTableIndex,
-			struct xgi_hw_device_info *HwDeviceExtension,
-			struct vb_device_info *pVBInfo);
-static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			struct vb_device_info *pVBInfo);
-static unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo);
-static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			unsigned short RefreshRateTableIndex,
-			struct xgi_hw_device_info *HwDeviceExtension,
-			struct vb_device_info *pVBInfo);
-static void XGI_VBLongWait(struct vb_device_info *pVBInfo);
-static void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo);
-static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void *XGI_GetLcdPtr(unsigned short BX,  unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_AutoThreshold(struct vb_device_info *pVBInfo);
-static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo);
-
-static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
-static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
-static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex);
-static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetMiscRegs(unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension, unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetGRCRegs(unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_ClearExt1Regs(struct vb_device_info *pVBInfo);
-
-static void XGI_SetSync(unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo, struct xgi_hw_device_info *HwDeviceExtension);
-static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo, struct xgi_hw_device_info *HwDeviceExtension);
-static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeNo, struct vb_device_info *pVBInfo);
-static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetCRT1FIFO(unsigned short ModeNo, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-
-static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al, unsigned short dh, struct vb_device_info *pVBInfo);
-/*void     XGI_ClearBuffer(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, struct vb_device_info *pVBInfo);*/
-static void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
-			struct vb_device_info *pVBInfo);
-static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
-			unsigned short RefreshRateTableIndex,
-			struct xgi_hw_device_info *HwDeviceExtension,
-			struct vb_device_info *pVBInfo);
-static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth, struct vb_device_info *pVBInfo);
-static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetDelayComp(struct vb_device_info *pVBInfo);
-static void XGI_SetLCDCap(struct vb_device_info *pVBInfo);
-static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo);
-static void XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo);
-static void SetSpectrum(struct vb_device_info *pVBInfo);
-static void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo);
-static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char* tempcl,
-			unsigned char *tempch, struct vb_device_info *pVBInfo);
-static void XGI_CloseCRTC(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo);
-static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-static void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
-			struct vb_device_info *pVBInfo);
-static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
-			unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			struct vb_device_info *pVBInfo);
-static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
-			unsigned char *di_1, struct vb_device_info *pVBInfo);
-static unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo);
-static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo);
-static struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx, struct vb_device_info *pVBInfo);
-static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo);
-static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo);
-static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo);
-
 static unsigned short XGINew_MDA_DAC[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15,
@@ -312,313 +200,6 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 
 }
 
-unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
-			unsigned short ModeNo)
-{
-	unsigned short ModeIdIndex;
-	/* unsigned char *pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress; */
-	struct vb_device_info VBINF;
-	struct vb_device_info *pVBInfo = &VBINF;
-	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
-	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
-	pVBInfo->IF_DEF_LVDS = 0;
-	pVBInfo->IF_DEF_CH7005 = 0;
-	pVBInfo->IF_DEF_LCDA = 1;
-	pVBInfo->IF_DEF_CH7017 = 0;
-	pVBInfo->IF_DEF_CH7007 = 0; /* [Billy] 2007/05/14 */
-	pVBInfo->IF_DEF_VideoCapture = 0;
-	pVBInfo->IF_DEF_ScaleLCD = 0;
-	pVBInfo->IF_DEF_OEMUtil = 0;
-	pVBInfo->IF_DEF_PWD = 0;
-
-	if (HwDeviceExtension->jChipType >= XG20) { /* kuku 2004/06/25 */
-		pVBInfo->IF_DEF_YPbPr = 0;
-		pVBInfo->IF_DEF_HiVision = 0;
-		pVBInfo->IF_DEF_CRT2Monitor = 0;
-		pVBInfo->VBType = 0; /*set VBType default 0*/
-	} else if (HwDeviceExtension->jChipType >= XG40) {
-		pVBInfo->IF_DEF_YPbPr = 1;
-		pVBInfo->IF_DEF_HiVision = 1;
-		pVBInfo->IF_DEF_CRT2Monitor = 1;
-	} else {
-		pVBInfo->IF_DEF_YPbPr = 1;
-		pVBInfo->IF_DEF_HiVision = 1;
-		pVBInfo->IF_DEF_CRT2Monitor = 0;
-	}
-
-	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
-	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
-	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
-	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
-	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
-	pVBInfo->P3cc = pVBInfo->BaseAddr + 0x1C;
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
-	if (HwDeviceExtension->jChipType == XG21) { /* for x86 Linux, XG21 LVDS */
-		if ((XGINew_GetReg1(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0)
-			pVBInfo->IF_DEF_LVDS = 1;
-	}
-	if (HwDeviceExtension->jChipType == XG27) {
-		if ((XGINew_GetReg1(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0) {
-			if (XGINew_GetReg1(pVBInfo->P3d4, 0x30) & 0x20)
-				pVBInfo->IF_DEF_LVDS = 1;
-		}
-	}
-
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
-		XGI_GetVBType(pVBInfo);
-
-	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
-	if (ModeNo & 0x80) {
-		ModeNo = ModeNo & 0x7F;
-		/* XGINew_flag_clearbuffer = 0; */
-	}
-	/* else {
-		XGINew_flag_clearbuffer = 1;
-	}
-	*/
-	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
-
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 1.Openkey */
-		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
-
-	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
-
-	XGI_GetVGAType(HwDeviceExtension, pVBInfo);
-
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
-		XGI_GetVBInfo(ModeNo, ModeIdIndex, HwDeviceExtension, pVBInfo);
-		XGI_GetTVInfo(ModeNo, ModeIdIndex, pVBInfo);
-		XGI_GetLCDInfo(ModeNo, ModeIdIndex, pVBInfo);
-		XGI_DisableBridge(HwDeviceExtension, pVBInfo);
-		/* XGI_OpenCRTC(HwDeviceExtension, pVBInfo); */
-
-		if (pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToLCDA)) {
-			XGI_SetCRT1Group(HwDeviceExtension, ModeNo,
-					ModeIdIndex, pVBInfo);
-
-			if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
-				XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
-						HwDeviceExtension, pVBInfo);
-			}
-		} else {
-			if (!(pVBInfo->VBInfo & SwitchToCRT2)) {
-				XGI_SetCRT1Group(HwDeviceExtension, ModeNo,
-						ModeIdIndex, pVBInfo);
-				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
-					XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
-							HwDeviceExtension,
-							pVBInfo);
-				}
-			}
-		}
-
-		if (pVBInfo->VBInfo & (SetSimuScanMode | SwitchToCRT2)) {
-			switch (HwDeviceExtension->ujVBChipID) {
-			case VB_CHIP_301:
-				XGI_SetCRT2Group301(ModeNo, HwDeviceExtension,
-						pVBInfo); /*add for CRT2 */
-				break;
-
-			case VB_CHIP_302:
-				XGI_SetCRT2Group301(ModeNo, HwDeviceExtension,
-						pVBInfo); /*add for CRT2 */
-				break;
-
-			default:
-				break;
-			}
-		}
-
-		XGI_SetCRT2ModeRegs(ModeNo, HwDeviceExtension, pVBInfo);
-		XGI_OEM310Setting(ModeNo, ModeIdIndex, pVBInfo); /*0212*/
-		XGI_CloseCRTC(HwDeviceExtension, pVBInfo);
-		XGI_EnableBridge(HwDeviceExtension, pVBInfo);
-	} /* !XG20 */
-	else {
-		if (pVBInfo->IF_DEF_LVDS == 1)
-			if (!XGI_XG21CheckLVDSMode(ModeNo, ModeIdIndex, pVBInfo))
-				return 0;
-
-		if (ModeNo <= 0x13) {
-			pVBInfo->ModeType
-					= pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag
-							& ModeInfoFlag;
-		} else {
-			pVBInfo->ModeType
-					= pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag
-							& ModeInfoFlag;
-		}
-
-		pVBInfo->SetFlag = 0;
-		if (pVBInfo->IF_DEF_CH7007 != 1)
-			pVBInfo->VBInfo = DisableCRT2Display;
-
-		XGI_DisplayOff(HwDeviceExtension, pVBInfo);
-
-		XGI_SetCRT1Group(HwDeviceExtension, ModeNo, ModeIdIndex,
-				pVBInfo);
-
-		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
-		/*
-		if (HwDeviceExtension->jChipType == XG21)
-			XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0x80, 0x80);
-		*/
-	}
-
-	/*
-	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
-	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-	}
-	pVBInfo->ModeType = modeflag&ModeInfoFlag;
-	pVBInfo->SetFlag = 0x00;
-	pVBInfo->VBInfo = DisableCRT2Display;
-	temp = XGINew_CheckMemorySize(HwDeviceExtension, ModeNo, ModeIdIndex, pVBInfo);
-
-	if (temp == 0)
-		return (0);
-
-	XGI_DisplayOff(HwDeviceExtension, pVBInfo) ;
-	XGI_SetCRT1Group(HwDeviceExtension, ModeNo, ModeIdIndex, pVBInfo);
-	XGI_DisplayOn(HwDeviceExtension, pVBInfo);
-	*/
-
-	XGI_UpdateModeInfo(HwDeviceExtension, pVBInfo);
-
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
-		XGI_LockCRT2(HwDeviceExtension, pVBInfo);
-	}
-
-	return 1;
-}
-
-static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
-		unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short StandTableIndex, RefreshRateTableIndex, b3CC, temp;
-
-	unsigned short XGINew_P3cc = pVBInfo->P3cc;
-
-	/* XGINew_CRT1Mode = ModeNo; // SaveModeID */
-	StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
-	/* XGI_SetBIOSData(ModeNo, ModeIdIndex); */
-	/* XGI_ClearBankRegs(ModeNo, ModeIdIndex); */
-	XGI_SetSeqRegs(ModeNo, StandTableIndex, ModeIdIndex, pVBInfo);
-	XGI_SetMiscRegs(StandTableIndex, pVBInfo);
-	XGI_SetCRTCRegs(HwDeviceExtension, StandTableIndex, pVBInfo);
-	XGI_SetATTRegs(ModeNo, StandTableIndex, ModeIdIndex, pVBInfo);
-	XGI_SetGRCRegs(StandTableIndex, pVBInfo);
-	XGI_ClearExt1Regs(pVBInfo);
-
-	/* if (pVBInfo->IF_DEF_ExpLink) */
-	if (HwDeviceExtension->jChipType == XG27) {
-		if (pVBInfo->IF_DEF_LVDS == 0)
-			XGI_SetDefaultVCLK(pVBInfo);
-	}
-
-	temp = ~ProgrammingCRT2;
-	pVBInfo->SetFlag &= temp;
-	pVBInfo->SelectCRT2Rate = 0;
-
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
-		if (pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToLCDA
-				| SetInSlaveMode)) {
-			pVBInfo->SetFlag |= ProgrammingCRT2;
-		}
-	}
-
-	RefreshRateTableIndex = XGI_GetRatePtrCRT2(HwDeviceExtension, ModeNo,
-			ModeIdIndex, pVBInfo);
-	if (RefreshRateTableIndex != 0xFFFF) {
-		XGI_SetSync(RefreshRateTableIndex, pVBInfo);
-		XGI_SetCRT1CRTC(ModeNo, ModeIdIndex, RefreshRateTableIndex,
-				pVBInfo, HwDeviceExtension);
-		XGI_SetCRT1DE(HwDeviceExtension, ModeNo, ModeIdIndex,
-				RefreshRateTableIndex, pVBInfo);
-		XGI_SetCRT1Offset(ModeNo, ModeIdIndex, RefreshRateTableIndex,
-				HwDeviceExtension, pVBInfo);
-		XGI_SetCRT1VCLK(ModeNo, ModeIdIndex, HwDeviceExtension,
-				RefreshRateTableIndex, pVBInfo);
-	}
-
-	if ((HwDeviceExtension->jChipType >= XG20)
-			&& (HwDeviceExtension->jChipType < XG27)) { /* fix H/W DCLK/2 bug */
-		if ((ModeNo == 0x00) | (ModeNo == 0x01)) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x4E);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE9);
-			b3CC = (unsigned char) XGINew_GetReg2(XGINew_P3cc);
-			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
-		} else if ((ModeNo == 0x04) | (ModeNo == 0x05) | (ModeNo
-				== 0x0D)) {
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
-			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE3);
-			b3CC = (unsigned char) XGINew_GetReg2(XGINew_P3cc);
-			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
-		}
-	}
-
-	if (HwDeviceExtension->jChipType >= XG21) {
-		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
-		if (temp & 0xA0) {
-
-			/* XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); *//* Enable write GPIOF */
-			/* XGINew_SetRegAND(pVBInfo->P3d4, 0x48, ~0x20); *//* P. DWN */
-			/* XG21 CRT1 Timing */
-			if (HwDeviceExtension->jChipType == XG27)
-				XGI_SetXG27CRTC(ModeNo, ModeIdIndex,
-						RefreshRateTableIndex, pVBInfo);
-			else
-				XGI_SetXG21CRTC(ModeNo, ModeIdIndex,
-						RefreshRateTableIndex, pVBInfo);
-
-			XGI_UpdateXG21CRTC(ModeNo, pVBInfo,
-					RefreshRateTableIndex);
-
-			if (HwDeviceExtension->jChipType == XG27)
-				XGI_SetXG27LCD(pVBInfo, RefreshRateTableIndex,
-						ModeNo);
-			else
-				XGI_SetXG21LCD(pVBInfo, RefreshRateTableIndex,
-						ModeNo);
-
-			if (pVBInfo->IF_DEF_LVDS == 1) {
-				if (HwDeviceExtension->jChipType == XG27)
-					XGI_SetXG27LVDSPara(ModeNo,
-							ModeIdIndex, pVBInfo);
-				else
-					XGI_SetXG21LVDSPara(ModeNo,
-							ModeIdIndex, pVBInfo);
-			}
-			/* XGINew_SetRegOR(pVBInfo->P3d4, 0x48, 0x20); *//* P. ON */
-		}
-	}
-
-	pVBInfo->SetFlag &= (~ProgrammingCRT2);
-	XGI_SetCRT1FIFO(ModeNo, HwDeviceExtension, pVBInfo);
-	XGI_SetCRT1ModeRegs(HwDeviceExtension, ModeNo, ModeIdIndex,
-			RefreshRateTableIndex, pVBInfo);
-
-	/* XGI_LoadCharacter(); //dif ifdef TVFont */
-
-	XGI_LoadDAC(ModeNo, ModeIdIndex, pVBInfo);
-	/* XGI_ClearBuffer(HwDeviceExtension, ModeNo, pVBInfo); */
-}
-
 static unsigned char XGI_GetModePtr(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -803,125 +384,6 @@ static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
-unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
-		unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
-{
-	short LCDRefreshIndex[] = { 0x00, 0x00, 0x03, 0x01 },
-			LCDARefreshIndex[] = { 0x00, 0x00, 0x03, 0x01, 0x01,
-					0x01, 0x01 };
-
-	unsigned short RefreshRateTableIndex, i, modeflag, index, temp;
-
-	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
-	else
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-
-	if (pVBInfo->IF_DEF_CH7005 == 1) {
-		if (pVBInfo->VBInfo & SetCRT2ToTV) {
-			if (modeflag & HalfDCLK)
-				return 0;
-		}
-	}
-
-	if (ModeNo < 0x14)
-		return 0xFFFF;
-
-	index = XGINew_GetReg1(pVBInfo->P3d4, 0x33);
-	index = index >> pVBInfo->SelectCRT2Rate;
-	index &= 0x0F;
-
-	if (pVBInfo->LCDInfo & LCDNonExpanding)
-		index = 0;
-
-	if (index > 0)
-		index--;
-
-	if (pVBInfo->SetFlag & ProgrammingCRT2) {
-		if (pVBInfo->IF_DEF_CH7005 == 1) {
-			if (pVBInfo->VBInfo & SetCRT2ToTV)
-				index = 0;
-		}
-
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-			if (pVBInfo->IF_DEF_LVDS == 0) {
-				if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
-						| VB_XGI301LV | VB_XGI302LV
-						| VB_XGI301C))
-					temp
-							= LCDARefreshIndex[pVBInfo->LCDResInfo
-									& 0x0F]; /* 301b */
-				else
-					temp
-							= LCDRefreshIndex[pVBInfo->LCDResInfo
-									& 0x0F];
-
-				if (index > temp)
-					index = temp;
-			} else {
-				index = 0;
-			}
-		}
-	}
-
-	RefreshRateTableIndex = pVBInfo->EModeIDTable[ModeIdIndex].REFindex;
-	ModeNo = pVBInfo->RefIndex[RefreshRateTableIndex].ModeID;
-	if (pXGIHWDE->jChipType >= XG20) { /* for XG20, XG21, XG27 */
-		/*
-		if (pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag & XG2xNotSupport) {
-			index++;
-		}
-		*/
-		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 800)
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
-						== 600)) {
-			index++;
-		}
-		/* Alan 10/19/2007; do the similiar adjustment like XGISearchCRT1Rate() */
-		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1024)
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
-						== 768)) {
-			index++;
-		}
-		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1280)
-				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
-						== 1024)) {
-			index++;
-		}
-	}
-
-	i = 0;
-	do {
-		if (pVBInfo->RefIndex[RefreshRateTableIndex + i].ModeID
-				!= ModeNo)
-			break;
-		temp
-				= pVBInfo->RefIndex[RefreshRateTableIndex + i].Ext_InfoFlag;
-		temp &= ModeInfoFlag;
-		if (temp < pVBInfo->ModeType)
-			break;
-		i++;
-		index--;
-
-	} while (index != 0xFFFF);
-	if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
-		if (pVBInfo->VBInfo & SetInSlaveMode) {
-			temp
-					= pVBInfo->RefIndex[RefreshRateTableIndex
-							+ i - 1].Ext_InfoFlag;
-			if (temp & InterlaceMode)
-				i++;
-		}
-	}
-	i--;
-	if ((pVBInfo->SetFlag & ProgrammingCRT2)) {
-		temp = XGI_AjustCRT2Rate(ModeNo, ModeIdIndex,
-				RefreshRateTableIndex, &i, pVBInfo);
-	}
-	return RefreshRateTableIndex + i; /* return (0x01 | (temp1<<1)); */
-}
-
 static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex, unsigned short *i,
@@ -1076,37 +538,6 @@ static void XGI_SetSync(unsigned short RefreshRateTableIndex,
 	XGINew_SetReg3(pVBInfo->P3c2, temp); /* Set Misc(3c2) */
 }
 
-static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo,
-		struct xgi_hw_device_info *HwDeviceExtension)
-{
-	unsigned char index, data;
-	unsigned short i;
-
-	index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC; /* Get index */
-	index = index & IndexMask;
-
-	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
-	data &= 0x7F;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
-
-	for (i = 0; i < 8; i++)
-		pVBInfo->TimingH[0].data[i]
-				= pVBInfo->XGINEWUB_CRT1Table[index].CR[i];
-
-	for (i = 0; i < 7; i++)
-		pVBInfo->TimingV[0].data[i]
-				= pVBInfo->XGINEWUB_CRT1Table[index].CR[i + 8];
-
-	XGI_SetCRT1Timing_H(pVBInfo, HwDeviceExtension);
-
-	XGI_SetCRT1Timing_V(ModeIdIndex, ModeNo, pVBInfo);
-
-	if (pVBInfo->ModeType > 0x03)
-		XGINew_SetReg1(pVBInfo->P3d4, 0x14, 0x4F);
-}
-
 static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 		struct xgi_hw_device_info *HwDeviceExtension)
 {
@@ -1221,6 +652,37 @@ static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeN
 	XGINew_SetReg1(pVBInfo->P3d4, 0x09, data);
 }
 
+static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
+		unsigned short RefreshRateTableIndex,
+		struct vb_device_info *pVBInfo,
+		struct xgi_hw_device_info *HwDeviceExtension)
+{
+	unsigned char index, data;
+	unsigned short i;
+
+	index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC; /* Get index */
+	index = index & IndexMask;
+
+	data = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x11);
+	data &= 0x7F;
+	XGINew_SetReg1(pVBInfo->P3d4, 0x11, data); /* Unlock CRTC */
+
+	for (i = 0; i < 8; i++)
+		pVBInfo->TimingH[0].data[i]
+				= pVBInfo->XGINEWUB_CRT1Table[index].CR[i];
+
+	for (i = 0; i < 7; i++)
+		pVBInfo->TimingV[0].data[i]
+				= pVBInfo->XGINEWUB_CRT1Table[index].CR[i + 8];
+
+	XGI_SetCRT1Timing_H(pVBInfo, HwDeviceExtension);
+
+	XGI_SetCRT1Timing_V(ModeIdIndex, ModeNo, pVBInfo);
+
+	if (pVBInfo->ModeType > 0x03)
+		XGINew_SetReg1(pVBInfo->P3d4, 0x14, 0x4F);
+}
+
 /* --------------------------------------------------------------------- */
 /* Function : XGI_SetXG21CRTC */
 /* Input : Stand or enhance CRTC table */
@@ -1794,6 +1256,179 @@ static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGINew_SetReg1(pVBInfo->P3c4, 0x10, ah);
 }
 
+static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
+		unsigned short ModeIdIndex,
+		unsigned short RefreshRateTableIndex,
+		struct xgi_hw_device_info *HwDeviceExtension,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short tempbx;
+
+	unsigned short LCDXlat1VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
+			VCLK65 + 2 };
+	unsigned short LCDXlat2VCLK[4] = { VCLK108_2 + 5, VCLK108_2 + 5,
+			VCLK108_2 + 5, VCLK108_2 + 5 };
+	unsigned short LVDSXlat1VCLK[4] = { VCLK40, VCLK40, VCLK40, VCLK40 };
+	unsigned short LVDSXlat2VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
+			VCLK65 + 2 };
+	unsigned short LVDSXlat3VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
+			VCLK65 + 2 };
+
+	unsigned short CRT2Index, VCLKIndex;
+	unsigned short modeflag, resinfo;
+	unsigned char *CHTVVCLKPtr = NULL;
+
+	if (ModeNo <= 0x13) {
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
+		CRT2Index = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
+	} else {
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
+		CRT2Index
+				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+	}
+
+	if (pVBInfo->IF_DEF_LVDS == 0) {
+		CRT2Index = CRT2Index >> 6; /*  for LCD */
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) { /*301b*/
+			if (pVBInfo->LCDResInfo != Panel1024x768)
+				VCLKIndex = LCDXlat2VCLK[CRT2Index];
+			else
+				VCLKIndex = LCDXlat1VCLK[CRT2Index];
+		} else { /* for TV */
+			if (pVBInfo->VBInfo & SetCRT2ToTV) {
+				if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+					if (pVBInfo->SetFlag & RPLLDIV2XO) {
+						VCLKIndex = HiTVVCLKDIV2;
+
+						VCLKIndex += 25;
+
+					} else {
+						VCLKIndex = HiTVVCLK;
+
+						VCLKIndex += 25;
+
+					}
+
+					if (pVBInfo->SetFlag & TVSimuMode) {
+						if (modeflag & Charx8Dot) {
+							VCLKIndex
+									= HiTVSimuVCLK;
+
+							VCLKIndex += 25;
+
+						} else {
+							VCLKIndex
+									= HiTVTextVCLK;
+
+							VCLKIndex += 25;
+
+						}
+					}
+
+					if (pVBInfo->VBType & VB_XGI301LV) { /* 301lv */
+						if (!(pVBInfo->VBExtInfo
+								== VB_YPbPr1080i)) {
+							VCLKIndex
+									= YPbPr750pVCLK;
+							if (!(pVBInfo->VBExtInfo
+									== VB_YPbPr750p)) {
+								VCLKIndex
+										= YPbPr525pVCLK;
+								if (!(pVBInfo->VBExtInfo
+										== VB_YPbPr525p)) {
+									VCLKIndex
+											= YPbPr525iVCLK_2;
+									if (!(pVBInfo->SetFlag
+											& RPLLDIV2XO))
+										VCLKIndex
+												= YPbPr525iVCLK;
+								}
+							}
+						}
+					}
+				} else {
+					if (pVBInfo->VBInfo & SetCRT2ToTV) {
+						if (pVBInfo->SetFlag
+								& RPLLDIV2XO) {
+							VCLKIndex = TVVCLKDIV2;
+
+							VCLKIndex += 25;
+
+						} else {
+							VCLKIndex = TVVCLK;
+
+							VCLKIndex += 25;
+
+						}
+					}
+				}
+			} else { /* for CRT2 */
+				VCLKIndex = (unsigned char) XGINew_GetReg2(
+						(pVBInfo->P3ca + 0x02)); /* Port 3cch */
+				VCLKIndex = ((VCLKIndex >> 2) & 0x03);
+				if (ModeNo > 0x13) {
+					VCLKIndex
+							= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK; /* di+Ext_CRTVCLK */
+					VCLKIndex &= IndexMask;
+				}
+			}
+		}
+	} else { /* LVDS */
+		if (ModeNo <= 0x13)
+			VCLKIndex = CRT2Index;
+		else
+			VCLKIndex = CRT2Index;
+
+		if (pVBInfo->IF_DEF_CH7005 == 1) {
+			if (!(pVBInfo->VBInfo & SetCRT2ToLCD)) {
+				VCLKIndex &= 0x1f;
+				tempbx = 0;
+
+				if (pVBInfo->VBInfo & SetPALTV)
+					tempbx += 2;
+
+				if (pVBInfo->VBInfo & SetCHTVOverScan)
+					tempbx += 1;
+
+				switch (tempbx) {
+				case 0:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKUNTSC;
+					break;
+				case 1:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKONTSC;
+					break;
+				case 2:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKUPAL;
+					break;
+				case 3:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKOPAL;
+					break;
+				default:
+					break;
+				}
+
+				VCLKIndex = CHTVVCLKPtr[VCLKIndex];
+			}
+		} else {
+			VCLKIndex = VCLKIndex >> 6;
+			if ((pVBInfo->LCDResInfo == Panel800x600)
+					|| (pVBInfo->LCDResInfo == Panel320x480))
+				VCLKIndex = LVDSXlat1VCLK[VCLKIndex];
+			else if ((pVBInfo->LCDResInfo == Panel1024x768)
+					|| (pVBInfo->LCDResInfo
+							== Panel1024x768x75))
+				VCLKIndex = LVDSXlat2VCLK[VCLKIndex];
+			else
+				VCLKIndex = LVDSXlat3VCLK[VCLKIndex];
+		}
+	}
+	/* VCLKIndex = VCLKIndex&IndexMask; */
+
+	return VCLKIndex;
+}
+
 static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short RefreshRateTableIndex,
@@ -1887,6 +1522,59 @@ static void XGI_SetCRT1FIFO(unsigned short ModeNo,
 		XGI_SetXG21FPBits(pVBInfo); /* Fix SR9[7:6] can't read back */
 }
 
+static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
+		unsigned short ModeNo, unsigned short RefreshRateTableIndex,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short data, data2 = 0;
+	short VCLK;
+
+	unsigned char index;
+
+	if (ModeNo <= 0x13)
+		VCLK = 0;
+	else {
+		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
+		index &= IndexMask;
+		VCLK = pVBInfo->VCLKData[index].CLOCK;
+	}
+
+	data = XGINew_GetReg1(pVBInfo->P3c4, 0x32);
+	data &= 0xf3;
+	if (VCLK >= 200)
+		data |= 0x0c; /* VCLK > 200 */
+
+	if (HwDeviceExtension->jChipType >= XG20)
+		data &= ~0x04; /* 2 pixel mode */
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x32, data);
+
+	if (HwDeviceExtension->jChipType < XG20) {
+		data = XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
+		data &= 0xE7;
+		if (VCLK < 200)
+			data |= 0x10;
+		XGINew_SetReg1(pVBInfo->P3c4, 0x1F, data);
+	}
+
+	/*  Jong for Adavantech LCD ripple issue
+	if ((VCLK >= 0) && (VCLK < 135))
+		data2 = 0x03;
+	else if ((VCLK >= 135) && (VCLK < 160))
+		data2 = 0x02;
+	else if ((VCLK >= 160) && (VCLK < 260))
+		data2 = 0x01;
+	else if (VCLK > 260)
+		data2 = 0x00;
+	*/
+	data2 = 0x00;
+
+	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x07, 0xFC, data2);
+	if (HwDeviceExtension->jChipType >= XG27)
+		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x40, 0xFC, data2 & 0x03);
+
+}
+
 static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
@@ -2002,60 +1690,6 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 
 }
 
-static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
-		unsigned short ModeNo, unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data, data2 = 0;
-	short VCLK;
-
-	unsigned char index;
-
-	if (ModeNo <= 0x13)
-		VCLK = 0;
-	else {
-		index = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
-		index &= IndexMask;
-		VCLK = pVBInfo->VCLKData[index].CLOCK;
-	}
-
-	data = XGINew_GetReg1(pVBInfo->P3c4, 0x32);
-	data &= 0xf3;
-	if (VCLK >= 200)
-		data |= 0x0c; /* VCLK > 200 */
-
-	if (HwDeviceExtension->jChipType >= XG20)
-		data &= ~0x04; /* 2 pixel mode */
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x32, data);
-
-	if (HwDeviceExtension->jChipType < XG20) {
-		data = XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
-		data &= 0xE7;
-		if (VCLK < 200)
-			data |= 0x10;
-		XGINew_SetReg1(pVBInfo->P3c4, 0x1F, data);
-	}
-
-	/*  Jong for Adavantech LCD ripple issue
-	if ((VCLK >= 0) && (VCLK < 135))
-		data2 = 0x03;
-	else if ((VCLK >= 135) && (VCLK < 160))
-		data2 = 0x02;
-	else if ((VCLK >= 160) && (VCLK < 260))
-		data2 = 0x01;
-	else if (VCLK > 260)
-		data2 = 0x00;
-	*/
-	data2 = 0x00;
-
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x07, 0xFC, data2);
-	if (HwDeviceExtension->jChipType >= XG27)
-		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x40, 0xFC, data2 & 0x03);
-
-}
-
-
 /*
 void XGI_VesaLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
 {
@@ -2088,6 +1722,33 @@ void XGI_VesaLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, st
 }
 */
 
+static void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al,
+		unsigned short dh, struct vb_device_info *pVBInfo)
+{
+	unsigned short temp, bh, bl;
+
+	bh = ah;
+	bl = al;
+
+	if (dl != 0) {
+		temp = bh;
+		bh = dh;
+		dh = temp;
+		if (dl == 1) {
+			temp = bl;
+			bl = dh;
+			dh = temp;
+		} else {
+			temp = bl;
+			bl = bh;
+			bh = temp;
+		}
+	}
+	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) dh);
+	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) bh);
+	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) bl);
+}
+
 static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -2180,53 +1841,6 @@ static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-static void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al,
-		unsigned short dh, struct vb_device_info *pVBInfo)
-{
-	unsigned short temp, bh, bl;
-
-	bh = ah;
-	bl = al;
-
-	if (dl != 0) {
-		temp = bh;
-		bh = dh;
-		dh = temp;
-		if (dl == 1) {
-			temp = bl;
-			bl = dh;
-			dh = temp;
-		} else {
-			temp = bl;
-			bl = bh;
-			bh = temp;
-		}
-	}
-	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) dh);
-	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) bh);
-	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) bl);
-}
-
-static void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short RefreshRateTableIndex;
-	/* unsigned short temp ; */
-
-	/* pVBInfo->SelectCRT2Rate = 0; */
-
-	pVBInfo->SetFlag |= ProgrammingCRT2;
-	RefreshRateTableIndex = XGI_GetRatePtrCRT2(HwDeviceExtension, ModeNo,
-			ModeIdIndex, pVBInfo);
-	XGI_GetLVDSResInfo(ModeNo, ModeIdIndex, pVBInfo);
-	XGI_GetLVDSData(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
-	XGI_ModCRT1Regs(ModeNo, ModeIdIndex, RefreshRateTableIndex,
-			HwDeviceExtension, pVBInfo);
-	XGI_SetLVDSRegs(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
-	XGI_SetCRT2ECLK(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
-}
-
 static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -2276,6 +1890,620 @@ static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex
 	pVBInfo->VDE = yres;
 }
 
+static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
+		unsigned short ModeIdIndex,
+		unsigned short RefreshRateTableIndex,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short i, tempdx, tempcx, tempbx, tempal, modeflag, table;
+
+	struct XGI330_LCDDataTablStruct *tempdi = NULL;
+
+	tempbx = BX;
+
+	if (ModeNo <= 0x13) {
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
+		tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
+	} else {
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
+		tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+	}
+
+	tempal = tempal & 0x0f;
+
+	if (tempbx <= 1) { /* ExpLink */
+		if (ModeNo <= 0x13) {
+			tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC; /* find no Ext_CRT2CRTC2 */
+		} else {
+			tempal
+					= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+		}
+
+		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+			if (ModeNo <= 0x13)
+				tempal
+						= pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC2;
+			else
+				tempal
+						= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC2;
+		}
+
+		if (tempbx & 0x01)
+			tempal = (tempal >> 4);
+
+		tempal = (tempal & 0x0f);
+	}
+
+	tempcx = LCDLenList[tempbx]; /* mov cl,byte ptr cs:LCDLenList[bx] */
+
+	if (pVBInfo->LCDInfo & EnableScalingLCD) { /* ScaleLCD */
+		if ((tempbx == 5) || (tempbx) == 7)
+			tempcx = LCDDesDataLen2;
+		else if ((tempbx == 3) || (tempbx == 8))
+			tempcx = LVDSDesDataLen2;
+	}
+	/* mov di, word ptr cs:LCDDataList[bx] */
+	/* tempdi = pVideoMemory[LCDDataList + tempbx * 2] | (pVideoMemory[LCDDataList + tempbx * 2 + 1] << 8); */
+
+	switch (tempbx) {
+	case 0:
+		tempdi = XGI_EPLLCDCRT1Ptr_H;
+		break;
+	case 1:
+		tempdi = XGI_EPLLCDCRT1Ptr_V;
+		break;
+	case 2:
+		tempdi = XGI_EPLLCDDataPtr;
+		break;
+	case 3:
+		tempdi = XGI_EPLLCDDesDataPtr;
+		break;
+	case 4:
+		tempdi = XGI_LCDDataTable;
+		break;
+	case 5:
+		tempdi = XGI_LCDDesDataTable;
+		break;
+	case 6:
+		tempdi = XGI_EPLCHLCDRegPtr;
+		break;
+	case 7:
+	case 8:
+	case 9:
+		tempdi = NULL;
+		break;
+	default:
+		break;
+	}
+
+	if (tempdi == NULL) /* OEMUtil */
+		return NULL;
+
+	table = tempbx;
+	i = 0;
+
+	while (tempdi[i].PANELID != 0xff) {
+		tempdx = pVBInfo->LCDResInfo;
+		if (tempbx & 0x0080) { /* OEMUtil */
+			tempbx &= (~0x0080);
+			tempdx = pVBInfo->LCDTypeInfo;
+		}
+
+		if (pVBInfo->LCDInfo & EnableScalingLCD)
+			tempdx &= (~PanelResInfo);
+
+		if (tempdi[i].PANELID == tempdx) {
+			tempbx = tempdi[i].MASK;
+			tempdx = pVBInfo->LCDInfo;
+
+			if (ModeNo <= 0x13) /* alan 09/10/2003 */
+				tempdx |= SetLCDStdMode;
+
+			if (modeflag & HalfDCLK)
+				tempdx |= SetLCDLowResolution;
+
+			tempbx &= tempdx;
+			if (tempbx == tempdi[i].CAP)
+				break;
+		}
+		i++;
+	}
+
+	if (table == 0) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_LVDSCRT11024x768_1_H[tempal];
+			break;
+		case 1:
+			return &XGI_LVDSCRT11024x768_2_H[tempal];
+			break;
+		case 2:
+			return &XGI_LVDSCRT11280x1024_1_H[tempal];
+			break;
+		case 3:
+			return &XGI_LVDSCRT11280x1024_2_H[tempal];
+			break;
+		case 4:
+			return &XGI_LVDSCRT11400x1050_1_H[tempal];
+			break;
+		case 5:
+			return &XGI_LVDSCRT11400x1050_2_H[tempal];
+			break;
+		case 6:
+			return &XGI_LVDSCRT11600x1200_1_H[tempal];
+			break;
+		case 7:
+			return &XGI_LVDSCRT11024x768_1_Hx75[tempal];
+			break;
+		case 8:
+			return &XGI_LVDSCRT11024x768_2_Hx75[tempal];
+			break;
+		case 9:
+			return &XGI_LVDSCRT11280x1024_1_Hx75[tempal];
+			break;
+		case 10:
+			return &XGI_LVDSCRT11280x1024_2_Hx75[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 1) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_LVDSCRT11024x768_1_V[tempal];
+			break;
+		case 1:
+			return &XGI_LVDSCRT11024x768_2_V[tempal];
+			break;
+		case 2:
+			return &XGI_LVDSCRT11280x1024_1_V[tempal];
+			break;
+		case 3:
+			return &XGI_LVDSCRT11280x1024_2_V[tempal];
+			break;
+		case 4:
+			return &XGI_LVDSCRT11400x1050_1_V[tempal];
+			break;
+		case 5:
+			return &XGI_LVDSCRT11400x1050_2_V[tempal];
+			break;
+		case 6:
+			return &XGI_LVDSCRT11600x1200_1_V[tempal];
+			break;
+		case 7:
+			return &XGI_LVDSCRT11024x768_1_Vx75[tempal];
+			break;
+		case 8:
+			return &XGI_LVDSCRT11024x768_2_Vx75[tempal];
+			break;
+		case 9:
+			return &XGI_LVDSCRT11280x1024_1_Vx75[tempal];
+			break;
+		case 10:
+			return &XGI_LVDSCRT11280x1024_2_Vx75[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 2) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_LVDS1024x768Data_1[tempal];
+			break;
+		case 1:
+			return &XGI_LVDS1024x768Data_2[tempal];
+			break;
+		case 2:
+			return &XGI_LVDS1280x1024Data_1[tempal];
+			break;
+		case 3:
+			return &XGI_LVDS1280x1024Data_2[tempal];
+			break;
+		case 4:
+			return &XGI_LVDS1400x1050Data_1[tempal];
+			break;
+		case 5:
+			return &XGI_LVDS1400x1050Data_2[tempal];
+			break;
+		case 6:
+			return &XGI_LVDS1600x1200Data_1[tempal];
+			break;
+		case 7:
+			return &XGI_LVDSNoScalingData[tempal];
+			break;
+		case 8:
+			return &XGI_LVDS1024x768Data_1x75[tempal];
+			break;
+		case 9:
+			return &XGI_LVDS1024x768Data_2x75[tempal];
+			break;
+		case 10:
+			return &XGI_LVDS1280x1024Data_1x75[tempal];
+			break;
+		case 11:
+			return &XGI_LVDS1280x1024Data_2x75[tempal];
+			break;
+		case 12:
+			return &XGI_LVDSNoScalingDatax75[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 3) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_LVDS1024x768Des_1[tempal];
+			break;
+		case 1:
+			return &XGI_LVDS1024x768Des_3[tempal];
+			break;
+		case 2:
+			return &XGI_LVDS1024x768Des_2[tempal];
+			break;
+		case 3:
+			return &XGI_LVDS1280x1024Des_1[tempal];
+			break;
+		case 4:
+			return &XGI_LVDS1280x1024Des_2[tempal];
+			break;
+		case 5:
+			return &XGI_LVDS1400x1050Des_1[tempal];
+			break;
+		case 6:
+			return &XGI_LVDS1400x1050Des_2[tempal];
+			break;
+		case 7:
+			return &XGI_LVDS1600x1200Des_1[tempal];
+			break;
+		case 8:
+			return &XGI_LVDSNoScalingDesData[tempal];
+			break;
+		case 9:
+			return &XGI_LVDS1024x768Des_1x75[tempal];
+			break;
+		case 10:
+			return &XGI_LVDS1024x768Des_3x75[tempal];
+			break;
+		case 11:
+			return &XGI_LVDS1024x768Des_2x75[tempal];
+			break;
+		case 12:
+			return &XGI_LVDS1280x1024Des_1x75[tempal];
+			break;
+		case 13:
+			return &XGI_LVDS1280x1024Des_2x75[tempal];
+			break;
+		case 14:
+			return &XGI_LVDSNoScalingDesDatax75[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 4) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_ExtLCD1024x768Data[tempal];
+			break;
+		case 1:
+			return &XGI_StLCD1024x768Data[tempal];
+			break;
+		case 2:
+			return &XGI_CetLCD1024x768Data[tempal];
+			break;
+		case 3:
+			return &XGI_ExtLCD1280x1024Data[tempal];
+			break;
+		case 4:
+			return &XGI_StLCD1280x1024Data[tempal];
+			break;
+		case 5:
+			return &XGI_CetLCD1280x1024Data[tempal];
+			break;
+		case 6:
+			return &XGI_ExtLCD1400x1050Data[tempal];
+			break;
+		case 7:
+			return &XGI_StLCD1400x1050Data[tempal];
+			break;
+		case 8:
+			return &XGI_CetLCD1400x1050Data[tempal];
+			break;
+		case 9:
+			return &XGI_ExtLCD1600x1200Data[tempal];
+			break;
+		case 10:
+			return &XGI_StLCD1600x1200Data[tempal];
+			break;
+		case 11:
+			return &XGI_NoScalingData[tempal];
+			break;
+		case 12:
+			return &XGI_ExtLCD1024x768x75Data[tempal];
+			break;
+		case 13:
+			return &XGI_ExtLCD1024x768x75Data[tempal];
+			break;
+		case 14:
+			return &XGI_CetLCD1024x768x75Data[tempal];
+			break;
+		case 15:
+			return &XGI_ExtLCD1280x1024x75Data[tempal];
+			break;
+		case 16:
+			return &XGI_StLCD1280x1024x75Data[tempal];
+			break;
+		case 17:
+			return &XGI_CetLCD1280x1024x75Data[tempal];
+			break;
+		case 18:
+			return &XGI_NoScalingDatax75[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 5) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_ExtLCDDes1024x768Data[tempal];
+			break;
+		case 1:
+			return &XGI_StLCDDes1024x768Data[tempal];
+			break;
+		case 2:
+			return &XGI_CetLCDDes1024x768Data[tempal];
+			break;
+		case 3:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_ExtLCDDLDes1280x1024Data[tempal];
+			else
+				return &XGI_ExtLCDDes1280x1024Data[tempal];
+			break;
+		case 4:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_StLCDDLDes1280x1024Data[tempal];
+			else
+				return &XGI_StLCDDes1280x1024Data[tempal];
+			break;
+		case 5:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_CetLCDDLDes1280x1024Data[tempal];
+			else
+				return &XGI_CetLCDDes1280x1024Data[tempal];
+			break;
+		case 6:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_ExtLCDDLDes1400x1050Data[tempal];
+			else
+				return &XGI_ExtLCDDes1400x1050Data[tempal];
+			break;
+		case 7:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_StLCDDLDes1400x1050Data[tempal];
+			else
+				return &XGI_StLCDDes1400x1050Data[tempal];
+			break;
+		case 8:
+			return &XGI_CetLCDDes1400x1050Data[tempal];
+			break;
+		case 9:
+			return &XGI_CetLCDDes1400x1050Data2[tempal];
+			break;
+		case 10:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_ExtLCDDLDes1600x1200Data[tempal];
+			else
+				return &XGI_ExtLCDDes1600x1200Data[tempal];
+			break;
+		case 11:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_StLCDDLDes1600x1200Data[tempal];
+			else
+				return &XGI_StLCDDes1600x1200Data[tempal];
+			break;
+		case 12:
+			return &XGI_NoScalingDesData[tempal];
+			break;
+		case 13:
+			return &XGI_ExtLCDDes1024x768x75Data[tempal];
+			break;
+		case 14:
+			return &XGI_StLCDDes1024x768x75Data[tempal];
+			break;
+		case 15:
+			return &XGI_CetLCDDes1024x768x75Data[tempal];
+			break;
+		case 16:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_ExtLCDDLDes1280x1024x75Data[tempal];
+			else
+				return &XGI_ExtLCDDes1280x1024x75Data[tempal];
+			break;
+		case 17:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_StLCDDLDes1280x1024x75Data[tempal];
+			else
+				return &XGI_StLCDDes1280x1024x75Data[tempal];
+			break;
+		case 18:
+			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
+					& VB_XGI302LV))
+				return &XGI_CetLCDDLDes1280x1024x75Data[tempal];
+			else
+				return &XGI_CetLCDDes1280x1024x75Data[tempal];
+			break;
+		case 19:
+			return &XGI_NoScalingDesDatax75[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 6) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_CH7017LV1024x768[tempal];
+			break;
+		case 1:
+			return &XGI_CH7017LV1400x1050[tempal];
+			break;
+		default:
+			break;
+		}
+	}
+	return NULL;
+}
+
+static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,
+		unsigned short ModeIdIndex,
+		unsigned short RefreshRateTableIndex,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short i, tempdx, tempbx, tempal, modeflag, table;
+	struct XGI330_TVDataTablStruct *tempdi = NULL;
+
+	tempbx = BX;
+
+	if (ModeNo <= 0x13) {
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
+		tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
+	} else {
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
+		tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+	}
+
+	tempal = tempal & 0x3f;
+	table = tempbx;
+
+	switch (tempbx) {
+	case 0:
+		tempdi = NULL; /*EPLCHTVCRT1Ptr_H;*/
+		if (pVBInfo->IF_DEF_CH7007 == 1)
+			tempdi = XGI_EPLCHTVCRT1Ptr;
+
+		break;
+	case 1:
+		tempdi = NULL; /*EPLCHTVCRT1Ptr_V;*/
+		if (pVBInfo->IF_DEF_CH7007 == 1)
+			tempdi = XGI_EPLCHTVCRT1Ptr;
+
+		break;
+	case 2:
+		tempdi = XGI_EPLCHTVDataPtr;
+		break;
+	case 3:
+		tempdi = NULL;
+		break;
+	case 4:
+		tempdi = XGI_TVDataTable;
+		break;
+	case 5:
+		tempdi = NULL;
+		break;
+	case 6:
+		tempdi = XGI_EPLCHTVRegPtr;
+		break;
+	default:
+		break;
+	}
+
+	if (tempdi == NULL) /* OEMUtil */
+		return NULL;
+
+	tempdx = pVBInfo->TVInfo;
+
+	if (pVBInfo->VBInfo & SetInSlaveMode)
+		tempdx = tempdx | SetTVLockMode;
+
+	if (modeflag & HalfDCLK)
+		tempdx = tempdx | SetTVLowResolution;
+
+	i = 0;
+
+	while (tempdi[i].MASK != 0xffff) {
+		if ((tempdx & tempdi[i].MASK) == tempdi[i].CAP)
+			break;
+		i++;
+	}
+
+	if (table == 0x00) { /* 07/05/22 */
+	} else if (table == 0x01) {
+	} else if (table == 0x04) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_ExtPALData[tempal];
+			break;
+		case 1:
+			return &XGI_ExtNTSCData[tempal];
+			break;
+		case 2:
+			return &XGI_StPALData[tempal];
+			break;
+		case 3:
+			return &XGI_StNTSCData[tempal];
+			break;
+		case 4:
+			return &XGI_ExtHiTVData[tempal];
+			break;
+		case 5:
+			return &XGI_St2HiTVData[tempal];
+			break;
+		case 6:
+			return &XGI_ExtYPbPr525iData[tempal];
+			break;
+		case 7:
+			return &XGI_ExtYPbPr525pData[tempal];
+			break;
+		case 8:
+			return &XGI_ExtYPbPr750pData[tempal];
+			break;
+		case 9:
+			return &XGI_StYPbPr525iData[tempal];
+			break;
+		case 10:
+			return &XGI_StYPbPr525pData[tempal];
+			break;
+		case 11:
+			return &XGI_StYPbPr750pData[tempal];
+			break;
+		case 12: /* avoid system hang */
+			return &XGI_ExtNTSCData[tempal];
+			break;
+		case 13:
+			return &XGI_St1HiTVData[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 0x02) {
+		switch (tempdi[i].DATAPTR) {
+		case 0:
+			return &XGI_CHTVUNTSCData[tempal];
+			break;
+		case 1:
+			return &XGI_CHTVONTSCData[tempal];
+			break;
+		case 2:
+			return &XGI_CHTVUPALData[tempal];
+			break;
+		case 3:
+			return &XGI_CHTVOPALData[tempal];
+			break;
+		default:
+			break;
+		}
+	} else if (table == 0x06) {
+	}
+	return NULL;
+}
+
 static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -2446,6 +2674,77 @@ static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
+static unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo)
+{
+	unsigned char tempal, tempah, tempbl, i;
+
+	tempah = XGINew_GetReg1(pVBInfo->P3d4, 0x36);
+	tempal = tempah & 0x0F;
+	tempah = tempah & 0xF0;
+	i = 0;
+	tempbl = pVBInfo->LCDCapList[i].LCD_ID;
+
+	while (tempbl != 0xFF) {
+		if (tempbl & 0x80) { /* OEMUtil */
+			tempal = tempah;
+			tempbl = tempbl & ~(0x80);
+		}
+
+		if (tempal == tempbl)
+			break;
+
+		i++;
+
+		tempbl = pVBInfo->LCDCapList[i].LCD_ID;
+	}
+
+	return i;
+}
+
+static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo)
+{
+	unsigned short tempah, tempal, tempbl, i;
+
+	tempal = pVBInfo->LCDResInfo;
+	tempah = pVBInfo->LCDTypeInfo;
+
+	i = 0;
+	tempbl = pVBInfo->LCDCapList[i].LCD_ID;
+
+	while (tempbl != 0xFF) {
+		if ((tempbl & 0x80) && (tempbl != 0x80)) {
+			tempal = tempah;
+			tempbl &= ~0x80;
+		}
+
+		if (tempal == tempbl)
+			break;
+
+		i++;
+		tempbl = pVBInfo->LCDCapList[i].LCD_ID;
+	}
+
+	if (tempbl == 0xFF) {
+		pVBInfo->LCDResInfo = Panel1024x768;
+		pVBInfo->LCDTypeInfo = 0;
+		i = 0;
+	}
+
+	return i;
+}
+
+static void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short Index;
+
+	Index = XGI_GetLCDCapPtr(pVBInfo);
+	*HSyncWidth = pVBInfo->LCDCapList[Index].LCD_HSyncWidth;
+	*VSyncWidth = pVBInfo->LCDCapList[Index].LCD_VSyncWidth;
+
+	return;
+}
+
 static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -2741,6 +3040,214 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
+/* --------------------------------------------------------------------- */
+/* Function : XGI_GETLCDVCLKPtr */
+/* Input : */
+/* Output : al -> VCLK Index */
+/* Description : */
+/* --------------------------------------------------------------------- */
+static void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short index;
+
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+		if (pVBInfo->IF_DEF_ScaleLCD == 1) {
+			if (pVBInfo->LCDInfo & EnableScalingLCD)
+				return;
+		}
+
+		/* index = XGI_GetLCDCapPtr(pVBInfo); */
+		index = XGI_GetLCDCapPtr1(pVBInfo);
+
+		if (pVBInfo->VBInfo & SetCRT2ToLCD) { /* LCDB */
+			*di_0 = pVBInfo->LCDCapList[index].LCUCHAR_VCLKData1;
+			*di_1 = pVBInfo->LCDCapList[index].LCUCHAR_VCLKData2;
+		} else { /* LCDA */
+			*di_0 = pVBInfo->LCDCapList[index].LCDA_VCLKData1;
+			*di_1 = pVBInfo->LCDCapList[index].LCDA_VCLKData2;
+		}
+	}
+	return;
+}
+
+static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
+		unsigned short ModeNo, unsigned short ModeIdIndex,
+		struct vb_device_info *pVBInfo)
+{
+
+	unsigned short index, modeflag;
+	unsigned short tempbx;
+	unsigned char tempal;
+	unsigned char *CHTVVCLKPtr = NULL;
+
+	if (ModeNo <= 0x13)
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+	else
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
+
+	if ((pVBInfo->SetFlag & ProgrammingCRT2) && (!(pVBInfo->LCDInfo
+			& EnableScalingLCD))) { /* {LCDA/LCDB} */
+		index = XGI_GetLCDCapPtr(pVBInfo);
+		tempal = pVBInfo->LCDCapList[index].LCD_VCLK;
+
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))
+			return tempal;
+
+		/* {TV} */
+		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+				| VB_XGI302LV | VB_XGI301C)) {
+			if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
+				tempal = HiTVVCLKDIV2;
+				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
+					tempal = HiTVVCLK;
+				if (pVBInfo->TVInfo & TVSimuMode) {
+					tempal = HiTVSimuVCLK;
+					if (!(modeflag & Charx8Dot))
+						tempal = HiTVTextVCLK;
+
+				}
+				return tempal;
+			}
+
+			if (pVBInfo->TVInfo & SetYPbPrMode750p) {
+				tempal = YPbPr750pVCLK;
+				return tempal;
+			}
+
+			if (pVBInfo->TVInfo & SetYPbPrMode525p) {
+				tempal = YPbPr525pVCLK;
+				return tempal;
+			}
+
+			tempal = NTSC1024VCLK;
+
+			if (!(pVBInfo->TVInfo & NTSC1024x768)) {
+				tempal = TVVCLKDIV2;
+				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
+					tempal = TVVCLK;
+			}
+
+			if (pVBInfo->VBInfo & SetCRT2ToTV)
+				return tempal;
+		}
+		/* else if ((pVBInfo->IF_DEF_CH7017==1)&&(pVBInfo->VBType&VB_CH7017)) {
+			if (ModeNo<=0x13)
+				*tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
+			else
+				*tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+			*tempal = *tempal & 0x1F;
+			tempbx = 0;
+			if (pVBInfo->TVInfo & SetPALTV)
+				tempbx = tempbx + 2;
+			if (pVBInfo->TVInfo & SetCHTVOverScan)
+				tempbx++;
+			tempbx = tempbx << 1;
+		} */
+	} /* {End of VB} */
+
+	if ((pVBInfo->IF_DEF_CH7007 == 1) && (pVBInfo->VBType & VB_CH7007)) { /* [Billy] 07/05/08 CH7007 */
+		/* VideoDebugPrint((0, "XGI_GetVCLKPtr: pVBInfo->IF_DEF_CH7007==1\n")); */
+		if ((pVBInfo->VBInfo & SetCRT2ToTV)) {
+			if (ModeNo <= 0x13) {
+				tempal
+						= pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
+			} else {
+				tempal
+						= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
+			}
+
+			tempal = tempal & 0x0F;
+			tempbx = 0;
+
+			if (pVBInfo->TVInfo & SetPALTV)
+				tempbx = tempbx + 2;
+
+			if (pVBInfo->TVInfo & SetCHTVOverScan)
+				tempbx++;
+
+			/** tempbx = tempbx << 1; CH7007 ? **/
+
+			/* [Billy]07/05/29 CH7007 */
+			if (pVBInfo->IF_DEF_CH7007 == 1) {
+				switch (tempbx) {
+				case 0:
+					CHTVVCLKPtr = XGI7007_CHTVVCLKUNTSC;
+					break;
+				case 1:
+					CHTVVCLKPtr = XGI7007_CHTVVCLKONTSC;
+					break;
+				case 2:
+					CHTVVCLKPtr = XGI7007_CHTVVCLKUPAL;
+					break;
+				case 3:
+					CHTVVCLKPtr = XGI7007_CHTVVCLKOPAL;
+					break;
+				default:
+					break;
+
+				}
+			}
+			/* else {
+				switch(tempbx) {
+				case 0:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKUNTSC;
+					break;
+				case 1:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKONTSC;
+					break;
+				case 2:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKUPAL;
+					break;
+				case 3:
+					CHTVVCLKPtr = pVBInfo->CHTVVCLKOPAL;
+					break;
+				default:
+					break;
+				}
+			}
+			*/
+
+			tempal = CHTVVCLKPtr[tempal];
+			return tempal;
+		}
+
+	}
+
+	tempal = (unsigned char) XGINew_GetReg2((pVBInfo->P3ca + 0x02));
+	tempal = tempal >> 2;
+	tempal &= 0x03;
+
+	if ((pVBInfo->LCDInfo & EnableScalingLCD) && (modeflag & Charx8Dot)) /* for Dot8 Scaling LCD */
+		tempal = tempal ^ tempal; /* ; set to VCLK25MHz always */
+
+	if (ModeNo <= 0x13)
+		return tempal;
+
+	tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
+	return tempal;
+}
+
+static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
+		unsigned char *di_1, struct vb_device_info *pVBInfo)
+{
+	if (pVBInfo->IF_DEF_CH7007 == 1) { /* [Billy] 2007/05/16 */
+		/* VideoDebugPrint((0, "XGI_GetVCLKLen: pVBInfo->IF_DEF_CH7007==1\n")); */
+		*di_0 = (unsigned char) XGI_CH7007VCLKData[tempal].SR2B;
+		*di_1 = (unsigned char) XGI_CH7007VCLKData[tempal].SR2C;
+	} else if (pVBInfo->VBType & (VB_XGI301 | VB_XGI301B | VB_XGI302B
+			| VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
+		if ((!(pVBInfo->VBInfo & SetCRT2ToLCDA)) && (pVBInfo->SetFlag
+				& ProgrammingCRT2)) {
+			*di_0 = (unsigned char) XGI_VBVCLKData[tempal].SR2B;
+			*di_1 = XGI_VBVCLKData[tempal].SR2C;
+		}
+	} else {
+		*di_0 = XGI_VCLKData[tempal].SR2B;
+		*di_1 = XGI_VCLKData[tempal].SR2C;
+	}
+}
+
 static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -3567,6 +4074,64 @@ void XGINew_IsLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, u
 }
 */
 
+static unsigned char XG21GPIODataTransfer(unsigned char ujDate)
+{
+	unsigned char ujRet = 0;
+	unsigned char i = 0;
+
+	for (i = 0; i < 8; i++) {
+		ujRet = ujRet << 1;
+		/* ujRet |= GETBITS(ujDate >> i, 0:0); */
+		ujRet |= (ujDate >> i) & 1;
+	}
+
+	return ujRet;
+}
+
+/*----------------------------------------------------------------------------*/
+/* output                                                                     */
+/*      bl[5] : LVDS signal                                                   */
+/*      bl[1] : LVDS backlight                                                */
+/*      bl[0] : LVDS VDD                                                      */
+/*----------------------------------------------------------------------------*/
+static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
+{
+	unsigned char CR4A, temp;
+
+	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x23); /* enable GPIO write */
+
+	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
+
+	temp = XG21GPIODataTransfer(temp);
+	temp &= 0x23;
+	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
+	return temp;
+}
+
+/*----------------------------------------------------------------------------*/
+/* output                                                                     */
+/*      bl[5] : LVDS signal                                                   */
+/*      bl[1] : LVDS backlight                                                */
+/*      bl[0] : LVDS VDD                                                      */
+/*----------------------------------------------------------------------------*/
+static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo)
+{
+	unsigned char CR4A, CRB4, temp;
+
+	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
+	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x0C); /* enable GPIO write */
+
+	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
+
+	temp &= 0x0C;
+	temp >>= 2;
+	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
+	CRB4 = XGINew_GetReg1(pVBInfo->P3d4, 0xB4);
+	temp |= ((CRB4 & 0x04) << 3);
+	return temp;
+}
+
 void XGI_DisplayOn(struct xgi_hw_device_info *pXGIHWDE,
 		struct vb_device_info *pVBInfo)
 {
@@ -3650,112 +4215,6 @@ static void XGI_WaitDisply(struct vb_device_info *pVBInfo)
 		break;
 }
 
-void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
-{
-	unsigned char CRTCData[17] = { 0x5F, 0x4F, 0x50, 0x82, 0x55, 0x81,
-			0x0B, 0x3E, 0xE9, 0x0B, 0xDF, 0xE7, 0x04, 0x00, 0x00,
-			0x05, 0x00 };
-
-	unsigned char SR01 = 0, SR1F = 0, SR07 = 0, SR06 = 0;
-
-	unsigned char CR17, CR63, SR31;
-	unsigned short temp;
-	unsigned char DAC_TEST_PARMS[3] = { 0x0F, 0x0F, 0x0F };
-
-	int i;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
-
-	/* [2004/05/06] Vicent to fix XG42 single LCD sense to CRT+LCD */
-	XGINew_SetReg1(pVBInfo->P3d4, 0x57, 0x4A);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
-			pVBInfo->P3d4, 0x53) | 0x02));
-
-	SR31 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x31);
-	CR63 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x63);
-	SR01 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x01);
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x01, (unsigned char) (SR01 & 0xDF));
-	XGINew_SetReg1(pVBInfo->P3d4, 0x63, (unsigned char) (CR63 & 0xBF));
-
-	CR17 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x17);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x17, (unsigned char) (CR17 | 0x80));
-
-	SR1F = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, (unsigned char) (SR1F | 0x04));
-
-	SR07 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x07);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x07, (unsigned char) (SR07 & 0xFB));
-	SR06 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x06);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x06, (unsigned char) (SR06 & 0xC3));
-
-	XGINew_SetReg1(pVBInfo->P3d4, 0x11, 0x00);
-
-	for (i = 0; i < 8; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) i, CRTCData[i]);
-
-	for (i = 8; i < 11; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 8),
-				CRTCData[i]);
-
-	for (i = 11; i < 13; i++)
-		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 4),
-				CRTCData[i]);
-
-	for (i = 13; i < 16; i++)
-		XGINew_SetReg1(pVBInfo->P3c4, (unsigned short) (i - 3),
-				CRTCData[i]);
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x0E, (unsigned char) (CRTCData[16]
-			& 0xE0));
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x31, 0x00);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE1);
-
-	XGINew_SetReg3(pVBInfo->P3c8, 0x00);
-
-	for (i = 0; i < 256; i++) {
-		XGINew_SetReg3((pVBInfo->P3c8 + 1),
-				(unsigned char) DAC_TEST_PARMS[0]);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1),
-				(unsigned char) DAC_TEST_PARMS[1]);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1),
-				(unsigned char) DAC_TEST_PARMS[2]);
-	}
-
-	XGI_VBLongWait(pVBInfo);
-	XGI_VBLongWait(pVBInfo);
-	XGI_VBLongWait(pVBInfo);
-
-	mdelay(1);
-
-	XGI_WaitDisply(pVBInfo);
-	temp = XGINew_GetReg2(pVBInfo->P3c2);
-
-	if (temp & 0x10)
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x20);
-	else
-		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x00);
-
-	/* alan, avoid display something, set BLACK DAC if not restore DAC */
-	XGINew_SetReg3(pVBInfo->P3c8, 0x00);
-
-	for (i = 0; i < 256; i++) {
-		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
-	}
-
-	XGINew_SetReg1(pVBInfo->P3c4, 0x01, SR01);
-	XGINew_SetReg1(pVBInfo->P3d4, 0x63, CR63);
-	XGINew_SetReg1(pVBInfo->P3c4, 0x31, SR31);
-
-	/* [2004/05/11] Vicent */
-	XGINew_SetReg1(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
-			pVBInfo->P3d4, 0x53) & 0xFD));
-	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, (unsigned char) SR1F);
-}
-
 #if 0
 static void XGI_WaitDisplay(struct vb_device_info *pVBInfo)
 {
@@ -3764,41 +4223,6 @@ static void XGI_WaitDisplay(struct vb_device_info *pVBInfo)
 }
 #endif
 
-unsigned char XGI_SetCRT2Group301(unsigned short ModeNo,
-		struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short tempbx, ModeIdIndex, RefreshRateTableIndex;
-
-	tempbx = pVBInfo->VBInfo;
-	pVBInfo->SetFlag |= ProgrammingCRT2;
-	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
-	pVBInfo->SelectCRT2Rate = 4;
-	RefreshRateTableIndex = XGI_GetRatePtrCRT2(HwDeviceExtension, ModeNo,
-			ModeIdIndex, pVBInfo);
-	XGI_SaveCRT2Info(ModeNo, pVBInfo);
-	XGI_GetCRT2ResInfo(ModeNo, ModeIdIndex, pVBInfo);
-	XGI_GetCRT2Data(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
-	XGI_PreSetGroup1(ModeNo, ModeIdIndex, HwDeviceExtension,
-			RefreshRateTableIndex, pVBInfo);
-	XGI_SetGroup1(ModeNo, ModeIdIndex, HwDeviceExtension,
-			RefreshRateTableIndex, pVBInfo);
-	XGI_SetLockRegs(ModeNo, ModeIdIndex, HwDeviceExtension,
-			RefreshRateTableIndex, pVBInfo);
-	XGI_SetGroup2(ModeNo, ModeIdIndex, RefreshRateTableIndex,
-			HwDeviceExtension, pVBInfo);
-	XGI_SetLCDRegs(ModeNo, ModeIdIndex, HwDeviceExtension,
-			RefreshRateTableIndex, pVBInfo);
-	XGI_SetTap4Regs(pVBInfo);
-	XGI_SetGroup3(ModeNo, ModeIdIndex, pVBInfo);
-	XGI_SetGroup4(ModeNo, ModeIdIndex, RefreshRateTableIndex,
-			HwDeviceExtension, pVBInfo);
-	XGI_SetCRT2VCLK(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
-	XGI_SetGroup5(ModeNo, ModeIdIndex, pVBInfo);
-	XGI_AutoThreshold(pVBInfo);
-	return 1;
-}
-
 static void XGI_AutoThreshold(struct vb_device_info *pVBInfo)
 {
 	if (!(pVBInfo->SetFlag & Win9xDOSMode))
@@ -3900,6 +4324,63 @@ static unsigned char XGI_IsLCDDualLink(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
+static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex,
+		unsigned short RefreshRateTableIndex,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short tempax, tempbx, temp1, temp2, modeflag = 0, tempcx,
+			StandTableIndex, CRT1Index;
+
+	pVBInfo->RVBHCMAX = 1;
+	pVBInfo->RVBHCFACT = 1;
+
+	if (ModeNo <= 0x13) {
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
+		StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
+		tempax = pVBInfo->StandTable[StandTableIndex].CRTC[0];
+		tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[6];
+		temp1 = pVBInfo->StandTable[StandTableIndex].CRTC[7];
+	} else {
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
+		CRT1Index
+				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
+		CRT1Index &= IndexMask;
+		temp1
+				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[0];
+		temp2
+				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[5];
+		tempax = (temp1 & 0xFF) | ((temp2 & 0x03) << 8);
+		tempbx
+				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[8];
+		tempcx
+				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[14]
+						<< 8;
+		tempcx &= 0x0100;
+		tempcx = tempcx << 2;
+		tempbx |= tempcx;
+		temp1
+				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[9];
+	}
+
+	if (temp1 & 0x01)
+		tempbx |= 0x0100;
+
+	if (temp1 & 0x20)
+		tempbx |= 0x0200;
+	tempax += 5;
+
+	if (modeflag & Charx8Dot)
+		tempax *= 8;
+	else
+		tempax *= 9;
+
+	pVBInfo->VGAHT = tempax;
+	pVBInfo->HT = tempax;
+	tempbx++;
+	pVBInfo->VGAVT = tempbx;
+	pVBInfo->VT = tempbx;
+}
+
 static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -4115,234 +4596,24 @@ static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		XGINew_SetRegOR(pVBInfo->Part4Port, 0x12, 0x08);
 }
 
-/* --------------------------------------------------------------------- */
-/* Function : XGI_GETLCDVCLKPtr */
-/* Input : */
-/* Output : al -> VCLK Index */
-/* Description : */
-/* --------------------------------------------------------------------- */
-static void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short index;
-
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-		if (pVBInfo->IF_DEF_ScaleLCD == 1) {
-			if (pVBInfo->LCDInfo & EnableScalingLCD)
-				return;
-		}
-
-		/* index = XGI_GetLCDCapPtr(pVBInfo); */
-		index = XGI_GetLCDCapPtr1(pVBInfo);
-
-		if (pVBInfo->VBInfo & SetCRT2ToLCD) { /* LCDB */
-			*di_0 = pVBInfo->LCDCapList[index].LCUCHAR_VCLKData1;
-			*di_1 = pVBInfo->LCDCapList[index].LCUCHAR_VCLKData2;
-		} else { /* LCDA */
-			*di_0 = pVBInfo->LCDCapList[index].LCDA_VCLKData1;
-			*di_1 = pVBInfo->LCDCapList[index].LCDA_VCLKData2;
-		}
-	}
-	return;
-}
-
-static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
-		unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
+		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
 {
-
-	unsigned short index, modeflag;
-	unsigned short tempbx;
-	unsigned char tempal;
-	unsigned char *CHTVVCLKPtr = NULL;
+	unsigned short ColorDepth[6] = { 1, 2, 4, 4, 6, 8 };
+	short index;
+	unsigned short modeflag;
 
 	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
 	else
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
-
-	if ((pVBInfo->SetFlag & ProgrammingCRT2) && (!(pVBInfo->LCDInfo
-			& EnableScalingLCD))) { /* {LCDA/LCDB} */
-		index = XGI_GetLCDCapPtr(pVBInfo);
-		tempal = pVBInfo->LCDCapList[index].LCD_VCLK;
-
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))
-			return tempal;
-
-		/* {TV} */
-		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)) {
-			if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
-				tempal = HiTVVCLKDIV2;
-				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
-					tempal = HiTVVCLK;
-				if (pVBInfo->TVInfo & TVSimuMode) {
-					tempal = HiTVSimuVCLK;
-					if (!(modeflag & Charx8Dot))
-						tempal = HiTVTextVCLK;
-
-				}
-				return tempal;
-			}
-
-			if (pVBInfo->TVInfo & SetYPbPrMode750p) {
-				tempal = YPbPr750pVCLK;
-				return tempal;
-			}
-
-			if (pVBInfo->TVInfo & SetYPbPrMode525p) {
-				tempal = YPbPr525pVCLK;
-				return tempal;
-			}
-
-			tempal = NTSC1024VCLK;
-
-			if (!(pVBInfo->TVInfo & NTSC1024x768)) {
-				tempal = TVVCLKDIV2;
-				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
-					tempal = TVVCLK;
-			}
-
-			if (pVBInfo->VBInfo & SetCRT2ToTV)
-				return tempal;
-		}
-		/* else if ((pVBInfo->IF_DEF_CH7017==1)&&(pVBInfo->VBType&VB_CH7017)) {
-			if (ModeNo<=0x13)
-				*tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
-			else
-				*tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
-			*tempal = *tempal & 0x1F;
-			tempbx = 0;
-			if (pVBInfo->TVInfo & SetPALTV)
-				tempbx = tempbx + 2;
-			if (pVBInfo->TVInfo & SetCHTVOverScan)
-				tempbx++;
-			tempbx = tempbx << 1;
-		} */
-	} /* {End of VB} */
-
-	if ((pVBInfo->IF_DEF_CH7007 == 1) && (pVBInfo->VBType & VB_CH7007)) { /* [Billy] 07/05/08 CH7007 */
-		/* VideoDebugPrint((0, "XGI_GetVCLKPtr: pVBInfo->IF_DEF_CH7007==1\n")); */
-		if ((pVBInfo->VBInfo & SetCRT2ToTV)) {
-			if (ModeNo <= 0x13) {
-				tempal
-						= pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
-			} else {
-				tempal
-						= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
-			}
-
-			tempal = tempal & 0x0F;
-			tempbx = 0;
-
-			if (pVBInfo->TVInfo & SetPALTV)
-				tempbx = tempbx + 2;
-
-			if (pVBInfo->TVInfo & SetCHTVOverScan)
-				tempbx++;
-
-			/** tempbx = tempbx << 1; CH7007 ? **/
-
-			/* [Billy]07/05/29 CH7007 */
-			if (pVBInfo->IF_DEF_CH7007 == 1) {
-				switch (tempbx) {
-				case 0:
-					CHTVVCLKPtr = XGI7007_CHTVVCLKUNTSC;
-					break;
-				case 1:
-					CHTVVCLKPtr = XGI7007_CHTVVCLKONTSC;
-					break;
-				case 2:
-					CHTVVCLKPtr = XGI7007_CHTVVCLKUPAL;
-					break;
-				case 3:
-					CHTVVCLKPtr = XGI7007_CHTVVCLKOPAL;
-					break;
-				default:
-					break;
-
-				}
-			}
-			/* else {
-				switch(tempbx) {
-				case 0:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKUNTSC;
-					break;
-				case 1:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKONTSC;
-					break;
-				case 2:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKUPAL;
-					break;
-				case 3:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKOPAL;
-					break;
-				default:
-					break;
-				}
-			}
-			*/
-
-			tempal = CHTVVCLKPtr[tempal];
-			return tempal;
-		}
-
-	}
-
-	tempal = (unsigned char) XGINew_GetReg2((pVBInfo->P3ca + 0x02));
-	tempal = tempal >> 2;
-	tempal &= 0x03;
-
-	if ((pVBInfo->LCDInfo & EnableScalingLCD) && (modeflag & Charx8Dot)) /* for Dot8 Scaling LCD */
-		tempal = tempal ^ tempal; /* ; set to VCLK25MHz always */
-
-	if (ModeNo <= 0x13)
-		return tempal;
-
-	tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
-	return tempal;
-}
-
-static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
-		unsigned char *di_1, struct vb_device_info *pVBInfo)
-{
-	if (pVBInfo->IF_DEF_CH7007 == 1) { /* [Billy] 2007/05/16 */
-		/* VideoDebugPrint((0, "XGI_GetVCLKLen: pVBInfo->IF_DEF_CH7007==1\n")); */
-		*di_0 = (unsigned char) XGI_CH7007VCLKData[tempal].SR2B;
-		*di_1 = (unsigned char) XGI_CH7007VCLKData[tempal].SR2C;
-	} else if (pVBInfo->VBType & (VB_XGI301 | VB_XGI301B | VB_XGI302B
-			| VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
-		if ((!(pVBInfo->VBInfo & SetCRT2ToLCDA)) && (pVBInfo->SetFlag
-				& ProgrammingCRT2)) {
-			*di_0 = (unsigned char) XGI_VBVCLKData[tempal].SR2B;
-			*di_1 = XGI_VBVCLKData[tempal].SR2C;
-		}
-	} else {
-		*di_0 = XGI_VCLKData[tempal].SR2B;
-		*di_1 = XGI_VCLKData[tempal].SR2C;
-	}
-}
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
-static void XGI_SetCRT2Offset(unsigned short ModeNo,
-		unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short offset;
-	unsigned char temp;
+	index = (modeflag & ModeInfoFlag) - ModeEGA;
 
-	if (pVBInfo->VBInfo & SetInSlaveMode)
-		return;
+	if (index < 0)
+		index = 0;
 
-	offset = XGI_GetOffset(ModeNo, ModeIdIndex, RefreshRateTableIndex,
-			HwDeviceExtension, pVBInfo);
-	temp = (unsigned char) (offset & 0xFF);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x07, temp);
-	temp = (unsigned char) ((offset & 0xFF00) >> 8);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x09, temp);
-	temp = (unsigned char) (((offset >> 3) & 0xFF) + 1);
-	XGINew_SetReg1(pVBInfo->Part1Port, 0x03, temp);
+	return ColorDepth[index];
 }
 
 static unsigned short XGI_GetOffset(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -4380,6 +4651,28 @@ static unsigned short XGI_GetOffset(unsigned short ModeNo, unsigned short ModeId
 	}
 }
 
+static void XGI_SetCRT2Offset(unsigned short ModeNo,
+		unsigned short ModeIdIndex,
+		unsigned short RefreshRateTableIndex,
+		struct xgi_hw_device_info *HwDeviceExtension,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short offset;
+	unsigned char temp;
+
+	if (pVBInfo->VBInfo & SetInSlaveMode)
+		return;
+
+	offset = XGI_GetOffset(ModeNo, ModeIdIndex, RefreshRateTableIndex,
+			HwDeviceExtension, pVBInfo);
+	temp = (unsigned char) (offset & 0xFF);
+	XGINew_SetReg1(pVBInfo->Part1Port, 0x07, temp);
+	temp = (unsigned char) ((offset & 0xFF00) >> 8);
+	XGINew_SetReg1(pVBInfo->Part1Port, 0x09, temp);
+	temp = (unsigned char) (((offset >> 3) & 0xFF) + 1);
+	XGINew_SetReg1(pVBInfo->Part1Port, 0x03, temp);
+}
+
 static void XGI_SetCRT2FIFO(struct vb_device_info *pVBInfo)
 {
 	XGINew_SetReg1(pVBInfo->Part1Port, 0x01, 0x3B); /* threshold high ,disable auto threshold */
@@ -4564,6 +4857,18 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2C, ~0x0C0, tempax);
 }
 
+static unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo)
+{
+	unsigned long tempax, tempbx;
+
+	tempbx = ((pVBInfo->VGAVT - pVBInfo->VGAVDE) * pVBInfo->RVBHCMAX)
+			& 0xFFFF;
+	tempax = (pVBInfo->VT - pVBInfo->VDE) * pVBInfo->RVBHCFACT;
+	tempax = (tempax * pVBInfo->HT) / tempbx;
+
+	return (unsigned short) tempax;
+}
+
 static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short RefreshRateTableIndex,
@@ -5953,6 +6258,11 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 				pVBInfo);
 }
 
+static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo)
+{
+	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1E, 0xFF, 0x20);
+}
+
 static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -5970,620 +6280,6 @@ static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 	return;
 }
 
-static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
-		unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short i, tempdx, tempcx, tempbx, tempal, modeflag, table;
-
-	struct XGI330_LCDDataTablStruct *tempdi = NULL;
-
-	tempbx = BX;
-
-	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
-		tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
-	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-		tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
-	}
-
-	tempal = tempal & 0x0f;
-
-	if (tempbx <= 1) { /* ExpLink */
-		if (ModeNo <= 0x13) {
-			tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC; /* find no Ext_CRT2CRTC2 */
-		} else {
-			tempal
-					= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
-		}
-
-		if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
-			if (ModeNo <= 0x13)
-				tempal
-						= pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC2;
-			else
-				tempal
-						= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC2;
-		}
-
-		if (tempbx & 0x01)
-			tempal = (tempal >> 4);
-
-		tempal = (tempal & 0x0f);
-	}
-
-	tempcx = LCDLenList[tempbx]; /* mov cl,byte ptr cs:LCDLenList[bx] */
-
-	if (pVBInfo->LCDInfo & EnableScalingLCD) { /* ScaleLCD */
-		if ((tempbx == 5) || (tempbx) == 7)
-			tempcx = LCDDesDataLen2;
-		else if ((tempbx == 3) || (tempbx == 8))
-			tempcx = LVDSDesDataLen2;
-	}
-	/* mov di, word ptr cs:LCDDataList[bx] */
-	/* tempdi = pVideoMemory[LCDDataList + tempbx * 2] | (pVideoMemory[LCDDataList + tempbx * 2 + 1] << 8); */
-
-	switch (tempbx) {
-	case 0:
-		tempdi = XGI_EPLLCDCRT1Ptr_H;
-		break;
-	case 1:
-		tempdi = XGI_EPLLCDCRT1Ptr_V;
-		break;
-	case 2:
-		tempdi = XGI_EPLLCDDataPtr;
-		break;
-	case 3:
-		tempdi = XGI_EPLLCDDesDataPtr;
-		break;
-	case 4:
-		tempdi = XGI_LCDDataTable;
-		break;
-	case 5:
-		tempdi = XGI_LCDDesDataTable;
-		break;
-	case 6:
-		tempdi = XGI_EPLCHLCDRegPtr;
-		break;
-	case 7:
-	case 8:
-	case 9:
-		tempdi = NULL;
-		break;
-	default:
-		break;
-	}
-
-	if (tempdi == NULL) /* OEMUtil */
-		return NULL;
-
-	table = tempbx;
-	i = 0;
-
-	while (tempdi[i].PANELID != 0xff) {
-		tempdx = pVBInfo->LCDResInfo;
-		if (tempbx & 0x0080) { /* OEMUtil */
-			tempbx &= (~0x0080);
-			tempdx = pVBInfo->LCDTypeInfo;
-		}
-
-		if (pVBInfo->LCDInfo & EnableScalingLCD)
-			tempdx &= (~PanelResInfo);
-
-		if (tempdi[i].PANELID == tempdx) {
-			tempbx = tempdi[i].MASK;
-			tempdx = pVBInfo->LCDInfo;
-
-			if (ModeNo <= 0x13) /* alan 09/10/2003 */
-				tempdx |= SetLCDStdMode;
-
-			if (modeflag & HalfDCLK)
-				tempdx |= SetLCDLowResolution;
-
-			tempbx &= tempdx;
-			if (tempbx == tempdi[i].CAP)
-				break;
-		}
-		i++;
-	}
-
-	if (table == 0) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_LVDSCRT11024x768_1_H[tempal];
-			break;
-		case 1:
-			return &XGI_LVDSCRT11024x768_2_H[tempal];
-			break;
-		case 2:
-			return &XGI_LVDSCRT11280x1024_1_H[tempal];
-			break;
-		case 3:
-			return &XGI_LVDSCRT11280x1024_2_H[tempal];
-			break;
-		case 4:
-			return &XGI_LVDSCRT11400x1050_1_H[tempal];
-			break;
-		case 5:
-			return &XGI_LVDSCRT11400x1050_2_H[tempal];
-			break;
-		case 6:
-			return &XGI_LVDSCRT11600x1200_1_H[tempal];
-			break;
-		case 7:
-			return &XGI_LVDSCRT11024x768_1_Hx75[tempal];
-			break;
-		case 8:
-			return &XGI_LVDSCRT11024x768_2_Hx75[tempal];
-			break;
-		case 9:
-			return &XGI_LVDSCRT11280x1024_1_Hx75[tempal];
-			break;
-		case 10:
-			return &XGI_LVDSCRT11280x1024_2_Hx75[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 1) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_LVDSCRT11024x768_1_V[tempal];
-			break;
-		case 1:
-			return &XGI_LVDSCRT11024x768_2_V[tempal];
-			break;
-		case 2:
-			return &XGI_LVDSCRT11280x1024_1_V[tempal];
-			break;
-		case 3:
-			return &XGI_LVDSCRT11280x1024_2_V[tempal];
-			break;
-		case 4:
-			return &XGI_LVDSCRT11400x1050_1_V[tempal];
-			break;
-		case 5:
-			return &XGI_LVDSCRT11400x1050_2_V[tempal];
-			break;
-		case 6:
-			return &XGI_LVDSCRT11600x1200_1_V[tempal];
-			break;
-		case 7:
-			return &XGI_LVDSCRT11024x768_1_Vx75[tempal];
-			break;
-		case 8:
-			return &XGI_LVDSCRT11024x768_2_Vx75[tempal];
-			break;
-		case 9:
-			return &XGI_LVDSCRT11280x1024_1_Vx75[tempal];
-			break;
-		case 10:
-			return &XGI_LVDSCRT11280x1024_2_Vx75[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 2) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_LVDS1024x768Data_1[tempal];
-			break;
-		case 1:
-			return &XGI_LVDS1024x768Data_2[tempal];
-			break;
-		case 2:
-			return &XGI_LVDS1280x1024Data_1[tempal];
-			break;
-		case 3:
-			return &XGI_LVDS1280x1024Data_2[tempal];
-			break;
-		case 4:
-			return &XGI_LVDS1400x1050Data_1[tempal];
-			break;
-		case 5:
-			return &XGI_LVDS1400x1050Data_2[tempal];
-			break;
-		case 6:
-			return &XGI_LVDS1600x1200Data_1[tempal];
-			break;
-		case 7:
-			return &XGI_LVDSNoScalingData[tempal];
-			break;
-		case 8:
-			return &XGI_LVDS1024x768Data_1x75[tempal];
-			break;
-		case 9:
-			return &XGI_LVDS1024x768Data_2x75[tempal];
-			break;
-		case 10:
-			return &XGI_LVDS1280x1024Data_1x75[tempal];
-			break;
-		case 11:
-			return &XGI_LVDS1280x1024Data_2x75[tempal];
-			break;
-		case 12:
-			return &XGI_LVDSNoScalingDatax75[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 3) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_LVDS1024x768Des_1[tempal];
-			break;
-		case 1:
-			return &XGI_LVDS1024x768Des_3[tempal];
-			break;
-		case 2:
-			return &XGI_LVDS1024x768Des_2[tempal];
-			break;
-		case 3:
-			return &XGI_LVDS1280x1024Des_1[tempal];
-			break;
-		case 4:
-			return &XGI_LVDS1280x1024Des_2[tempal];
-			break;
-		case 5:
-			return &XGI_LVDS1400x1050Des_1[tempal];
-			break;
-		case 6:
-			return &XGI_LVDS1400x1050Des_2[tempal];
-			break;
-		case 7:
-			return &XGI_LVDS1600x1200Des_1[tempal];
-			break;
-		case 8:
-			return &XGI_LVDSNoScalingDesData[tempal];
-			break;
-		case 9:
-			return &XGI_LVDS1024x768Des_1x75[tempal];
-			break;
-		case 10:
-			return &XGI_LVDS1024x768Des_3x75[tempal];
-			break;
-		case 11:
-			return &XGI_LVDS1024x768Des_2x75[tempal];
-			break;
-		case 12:
-			return &XGI_LVDS1280x1024Des_1x75[tempal];
-			break;
-		case 13:
-			return &XGI_LVDS1280x1024Des_2x75[tempal];
-			break;
-		case 14:
-			return &XGI_LVDSNoScalingDesDatax75[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 4) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_ExtLCD1024x768Data[tempal];
-			break;
-		case 1:
-			return &XGI_StLCD1024x768Data[tempal];
-			break;
-		case 2:
-			return &XGI_CetLCD1024x768Data[tempal];
-			break;
-		case 3:
-			return &XGI_ExtLCD1280x1024Data[tempal];
-			break;
-		case 4:
-			return &XGI_StLCD1280x1024Data[tempal];
-			break;
-		case 5:
-			return &XGI_CetLCD1280x1024Data[tempal];
-			break;
-		case 6:
-			return &XGI_ExtLCD1400x1050Data[tempal];
-			break;
-		case 7:
-			return &XGI_StLCD1400x1050Data[tempal];
-			break;
-		case 8:
-			return &XGI_CetLCD1400x1050Data[tempal];
-			break;
-		case 9:
-			return &XGI_ExtLCD1600x1200Data[tempal];
-			break;
-		case 10:
-			return &XGI_StLCD1600x1200Data[tempal];
-			break;
-		case 11:
-			return &XGI_NoScalingData[tempal];
-			break;
-		case 12:
-			return &XGI_ExtLCD1024x768x75Data[tempal];
-			break;
-		case 13:
-			return &XGI_ExtLCD1024x768x75Data[tempal];
-			break;
-		case 14:
-			return &XGI_CetLCD1024x768x75Data[tempal];
-			break;
-		case 15:
-			return &XGI_ExtLCD1280x1024x75Data[tempal];
-			break;
-		case 16:
-			return &XGI_StLCD1280x1024x75Data[tempal];
-			break;
-		case 17:
-			return &XGI_CetLCD1280x1024x75Data[tempal];
-			break;
-		case 18:
-			return &XGI_NoScalingDatax75[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 5) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_ExtLCDDes1024x768Data[tempal];
-			break;
-		case 1:
-			return &XGI_StLCDDes1024x768Data[tempal];
-			break;
-		case 2:
-			return &XGI_CetLCDDes1024x768Data[tempal];
-			break;
-		case 3:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_ExtLCDDLDes1280x1024Data[tempal];
-			else
-				return &XGI_ExtLCDDes1280x1024Data[tempal];
-			break;
-		case 4:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_StLCDDLDes1280x1024Data[tempal];
-			else
-				return &XGI_StLCDDes1280x1024Data[tempal];
-			break;
-		case 5:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_CetLCDDLDes1280x1024Data[tempal];
-			else
-				return &XGI_CetLCDDes1280x1024Data[tempal];
-			break;
-		case 6:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_ExtLCDDLDes1400x1050Data[tempal];
-			else
-				return &XGI_ExtLCDDes1400x1050Data[tempal];
-			break;
-		case 7:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_StLCDDLDes1400x1050Data[tempal];
-			else
-				return &XGI_StLCDDes1400x1050Data[tempal];
-			break;
-		case 8:
-			return &XGI_CetLCDDes1400x1050Data[tempal];
-			break;
-		case 9:
-			return &XGI_CetLCDDes1400x1050Data2[tempal];
-			break;
-		case 10:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_ExtLCDDLDes1600x1200Data[tempal];
-			else
-				return &XGI_ExtLCDDes1600x1200Data[tempal];
-			break;
-		case 11:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_StLCDDLDes1600x1200Data[tempal];
-			else
-				return &XGI_StLCDDes1600x1200Data[tempal];
-			break;
-		case 12:
-			return &XGI_NoScalingDesData[tempal];
-			break;
-		case 13:
-			return &XGI_ExtLCDDes1024x768x75Data[tempal];
-			break;
-		case 14:
-			return &XGI_StLCDDes1024x768x75Data[tempal];
-			break;
-		case 15:
-			return &XGI_CetLCDDes1024x768x75Data[tempal];
-			break;
-		case 16:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_ExtLCDDLDes1280x1024x75Data[tempal];
-			else
-				return &XGI_ExtLCDDes1280x1024x75Data[tempal];
-			break;
-		case 17:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_StLCDDLDes1280x1024x75Data[tempal];
-			else
-				return &XGI_StLCDDes1280x1024x75Data[tempal];
-			break;
-		case 18:
-			if ((pVBInfo->VBType & VB_XGI301LV) || (pVBInfo->VBType
-					& VB_XGI302LV))
-				return &XGI_CetLCDDLDes1280x1024x75Data[tempal];
-			else
-				return &XGI_CetLCDDes1280x1024x75Data[tempal];
-			break;
-		case 19:
-			return &XGI_NoScalingDesDatax75[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 6) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_CH7017LV1024x768[tempal];
-			break;
-		case 1:
-			return &XGI_CH7017LV1400x1050[tempal];
-			break;
-		default:
-			break;
-		}
-	}
-	return NULL;
-}
-
-static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,
-		unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short i, tempdx, tempbx, tempal, modeflag, table;
-	struct XGI330_TVDataTablStruct *tempdi = NULL;
-
-	tempbx = BX;
-
-	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
-		tempal = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
-	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-		tempal = pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
-	}
-
-	tempal = tempal & 0x3f;
-	table = tempbx;
-
-	switch (tempbx) {
-	case 0:
-		tempdi = NULL; /*EPLCHTVCRT1Ptr_H;*/
-		if (pVBInfo->IF_DEF_CH7007 == 1)
-			tempdi = XGI_EPLCHTVCRT1Ptr;
-
-		break;
-	case 1:
-		tempdi = NULL; /*EPLCHTVCRT1Ptr_V;*/
-		if (pVBInfo->IF_DEF_CH7007 == 1)
-			tempdi = XGI_EPLCHTVCRT1Ptr;
-
-		break;
-	case 2:
-		tempdi = XGI_EPLCHTVDataPtr;
-		break;
-	case 3:
-		tempdi = NULL;
-		break;
-	case 4:
-		tempdi = XGI_TVDataTable;
-		break;
-	case 5:
-		tempdi = NULL;
-		break;
-	case 6:
-		tempdi = XGI_EPLCHTVRegPtr;
-		break;
-	default:
-		break;
-	}
-
-	if (tempdi == NULL) /* OEMUtil */
-		return NULL;
-
-	tempdx = pVBInfo->TVInfo;
-
-	if (pVBInfo->VBInfo & SetInSlaveMode)
-		tempdx = tempdx | SetTVLockMode;
-
-	if (modeflag & HalfDCLK)
-		tempdx = tempdx | SetTVLowResolution;
-
-	i = 0;
-
-	while (tempdi[i].MASK != 0xffff) {
-		if ((tempdx & tempdi[i].MASK) == tempdi[i].CAP)
-			break;
-		i++;
-	}
-
-	if (table == 0x00) { /* 07/05/22 */
-	} else if (table == 0x01) {
-	} else if (table == 0x04) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_ExtPALData[tempal];
-			break;
-		case 1:
-			return &XGI_ExtNTSCData[tempal];
-			break;
-		case 2:
-			return &XGI_StPALData[tempal];
-			break;
-		case 3:
-			return &XGI_StNTSCData[tempal];
-			break;
-		case 4:
-			return &XGI_ExtHiTVData[tempal];
-			break;
-		case 5:
-			return &XGI_St2HiTVData[tempal];
-			break;
-		case 6:
-			return &XGI_ExtYPbPr525iData[tempal];
-			break;
-		case 7:
-			return &XGI_ExtYPbPr525pData[tempal];
-			break;
-		case 8:
-			return &XGI_ExtYPbPr750pData[tempal];
-			break;
-		case 9:
-			return &XGI_StYPbPr525iData[tempal];
-			break;
-		case 10:
-			return &XGI_StYPbPr525pData[tempal];
-			break;
-		case 11:
-			return &XGI_StYPbPr750pData[tempal];
-			break;
-		case 12: /* avoid system hang */
-			return &XGI_ExtNTSCData[tempal];
-			break;
-		case 13:
-			return &XGI_St1HiTVData[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 0x02) {
-		switch (tempdi[i].DATAPTR) {
-		case 0:
-			return &XGI_CHTVUNTSCData[tempal];
-			break;
-		case 1:
-			return &XGI_CHTVONTSCData[tempal];
-			break;
-		case 2:
-			return &XGI_CHTVUPALData[tempal];
-			break;
-		case 3:
-			return &XGI_CHTVOPALData[tempal];
-			break;
-		default:
-			break;
-		}
-	} else if (table == 0x06) {
-	}
-	return NULL;
-}
-
 /* --------------------------------------------------------------------- */
 /* Function : XGI_BacklightByDrv */
 /* Input : */
@@ -6686,63 +6382,6 @@ static void XGI_SetPanelPower(unsigned short tempah, unsigned short tempbl,
 		XGINew_SetRegANDOR(pVBInfo->P3c4, 0x11, tempbl, tempah);
 }
 
-static unsigned char XG21GPIODataTransfer(unsigned char ujDate)
-{
-	unsigned char ujRet = 0;
-	unsigned char i = 0;
-
-	for (i = 0; i < 8; i++) {
-		ujRet = ujRet << 1;
-		/* ujRet |= GETBITS(ujDate >> i, 0:0); */
-		ujRet |= (ujDate >> i) & 1;
-	}
-
-	return ujRet;
-}
-
-/*----------------------------------------------------------------------------*/
-/* output                                                                     */
-/*      bl[5] : LVDS signal                                                   */
-/*      bl[1] : LVDS backlight                                                */
-/*      bl[0] : LVDS VDD                                                      */
-/*----------------------------------------------------------------------------*/
-static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
-{
-	unsigned char CR4A, temp;
-
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
-	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x23); /* enable GPIO write */
-
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
-
-	temp = XG21GPIODataTransfer(temp);
-	temp &= 0x23;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
-	return temp;
-}
-
-/*----------------------------------------------------------------------------*/
-/* output                                                                     */
-/*      bl[5] : LVDS signal                                                   */
-/*      bl[1] : LVDS backlight                                                */
-/*      bl[0] : LVDS VDD                                                      */
-/*----------------------------------------------------------------------------*/
-static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo)
-{
-	unsigned char CR4A, CRB4, temp;
-
-	CR4A = XGINew_GetReg1(pVBInfo->P3d4, 0x4A);
-	XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x0C); /* enable GPIO write */
-
-	temp = XGINew_GetReg1(pVBInfo->P3d4, 0x48);
-
-	temp &= 0x0C;
-	temp >>= 2;
-	XGINew_SetReg1(pVBInfo->P3d4, 0x4A, CR4A);
-	CRB4 = XGINew_GetReg1(pVBInfo->P3d4, 0xB4);
-	temp |= ((CRB4 & 0x04) << 3);
-	return temp;
-}
 /*----------------------------------------------------------------------------*/
 /* input                                                                      */
 /*      bl[5] : 1;LVDS signal on                                              */
@@ -7389,264 +7028,6 @@ static unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
-static unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo)
-{
-	unsigned char tempal, tempah, tempbl, i;
-
-	tempah = XGINew_GetReg1(pVBInfo->P3d4, 0x36);
-	tempal = tempah & 0x0F;
-	tempah = tempah & 0xF0;
-	i = 0;
-	tempbl = pVBInfo->LCDCapList[i].LCD_ID;
-
-	while (tempbl != 0xFF) {
-		if (tempbl & 0x80) { /* OEMUtil */
-			tempal = tempah;
-			tempbl = tempbl & ~(0x80);
-		}
-
-		if (tempal == tempbl)
-			break;
-
-		i++;
-
-		tempbl = pVBInfo->LCDCapList[i].LCD_ID;
-	}
-
-	return i;
-}
-
-static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo)
-{
-	unsigned short tempah, tempal, tempbl, i;
-
-	tempal = pVBInfo->LCDResInfo;
-	tempah = pVBInfo->LCDTypeInfo;
-
-	i = 0;
-	tempbl = pVBInfo->LCDCapList[i].LCD_ID;
-
-	while (tempbl != 0xFF) {
-		if ((tempbl & 0x80) && (tempbl != 0x80)) {
-			tempal = tempah;
-			tempbl &= ~0x80;
-		}
-
-		if (tempal == tempbl)
-			break;
-
-		i++;
-		tempbl = pVBInfo->LCDCapList[i].LCD_ID;
-	}
-
-	if (tempbl == 0xFF) {
-		pVBInfo->LCDResInfo = Panel1024x768;
-		pVBInfo->LCDTypeInfo = 0;
-		i = 0;
-	}
-
-	return i;
-}
-
-static void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short Index;
-
-	Index = XGI_GetLCDCapPtr(pVBInfo);
-	*HSyncWidth = pVBInfo->LCDCapList[Index].LCD_HSyncWidth;
-	*VSyncWidth = pVBInfo->LCDCapList[Index].LCD_VSyncWidth;
-
-	return;
-}
-
-void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short tempbl, tempah;
-
-	if (pVBInfo->SetFlag == Win9xDOSMode) {
-		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-				| VB_XGI302LV | VB_XGI301C)) {
-			XGI_DisplayOn(HwDeviceExtension, pVBInfo);
-			return;
-		} else
-			/* LVDS or CH7017 */
-			return;
-	}
-
-	if (HwDeviceExtension->jChipType < XG40) {
-		if (!XGI_DisableChISLCD(pVBInfo)) {
-			if ((XGI_EnableChISLCD(pVBInfo)) || (pVBInfo->VBInfo
-					& (SetCRT2ToLCD | SetCRT2ToLCDA))) {
-				if (pVBInfo->LCDInfo & SetPWDEnable) {
-					XGI_EnablePWD(pVBInfo);
-				} else {
-					pVBInfo->LCDInfo &= (~SetPWDEnable);
-					if (pVBInfo->VBType & (VB_XGI301LV
-							| VB_XGI302LV
-							| VB_XGI301C)) {
-						tempbl = 0xFD;
-						tempah = 0x02;
-					} else {
-						tempbl = 0xFB;
-						tempah = 0x00;
-					}
-
-					XGI_SetPanelPower(tempah, tempbl,
-							pVBInfo);
-					XGI_SetPanelDelay(1, pVBInfo);
-				}
-			}
-		}
-	} /* Not 340 */
-
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
-		if (!(pVBInfo->SetFlag & DisableChA)) {
-			if (pVBInfo->SetFlag & EnableChA) {
-				XGINew_SetReg1(pVBInfo->Part1Port, 0x1E, 0x20); /* Power on */
-			} else {
-				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) { /* SetCRT2ToLCDA ) */
-					XGINew_SetReg1(pVBInfo->Part1Port,
-							0x1E, 0x20); /* Power on */
-				}
-			}
-		}
-
-		if (!(pVBInfo->SetFlag & DisableChB)) {
-			if ((pVBInfo->SetFlag & EnableChB) || (pVBInfo->VBInfo
-					& (SetCRT2ToLCD | SetCRT2ToTV
-							| SetCRT2ToRAMDAC))) {
-				tempah = (unsigned char) XGINew_GetReg1(
-						pVBInfo->P3c4, 0x32);
-				tempah &= 0xDF;
-				if (pVBInfo->VBInfo & SetInSlaveMode) {
-					if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC))
-						tempah |= 0x20;
-				}
-				XGINew_SetReg1(pVBInfo->P3c4, 0x32, tempah);
-				XGINew_SetRegOR(pVBInfo->P3c4, 0x1E, 0x20);
-
-				tempah = (unsigned char) XGINew_GetReg1(
-						pVBInfo->Part1Port, 0x2E);
-
-				if (!(tempah & 0x80))
-					XGINew_SetRegOR(pVBInfo->Part1Port,
-							0x2E, 0x80); /* BVBDOENABLE = 1 */
-
-				XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F); /* BScreenOFF = 0 */
-			}
-		}
-
-		if ((pVBInfo->SetFlag & (EnableChA | EnableChB))
-				|| (!(pVBInfo->VBInfo & DisableCRT2Display))) {
-			XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x00, ~0xE0,
-					0x20); /* shampoo 0129 */
-			if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
-				if (!XGI_DisableChISLCD(pVBInfo)) {
-					if (XGI_EnableChISLCD(pVBInfo)
-							|| (pVBInfo->VBInfo
-									& (SetCRT2ToLCD
-											| SetCRT2ToLCDA)))
-						XGINew_SetRegAND(
-								pVBInfo->Part4Port,
-								0x2A, 0x7F); /* LVDS PLL power on */
-				}
-				XGINew_SetRegAND(pVBInfo->Part4Port, 0x30, 0x7F); /* LVDS Driver power on */
-			}
-		}
-
-		tempah = 0x00;
-
-		if (!(pVBInfo->VBInfo & DisableCRT2Display)) {
-			tempah = 0xc0;
-
-			if (!(pVBInfo->VBInfo & SetSimuScanMode)) {
-				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
-					if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
-						tempah = tempah & 0x40;
-						if (pVBInfo->VBInfo
-								& SetCRT2ToLCDA)
-							tempah = tempah ^ 0xC0;
-
-						if (pVBInfo->SetFlag
-								& DisableChB)
-							tempah &= 0xBF;
-
-						if (pVBInfo->SetFlag
-								& DisableChA)
-							tempah &= 0x7F;
-
-						if (pVBInfo->SetFlag
-								& EnableChB)
-							tempah |= 0x40;
-
-						if (pVBInfo->SetFlag
-								& EnableChA)
-							tempah |= 0x80;
-					}
-				}
-			}
-		}
-
-		XGINew_SetRegOR(pVBInfo->Part4Port, 0x1F, tempah); /* EnablePart4_1F */
-
-		if (pVBInfo->SetFlag & Win9xDOSMode) {
-			XGI_DisplayOn(HwDeviceExtension, pVBInfo);
-			return;
-		}
-
-		if (!(pVBInfo->SetFlag & DisableChA)) {
-			XGI_VBLongWait(pVBInfo);
-			if (!(pVBInfo->SetFlag & GatingCRT)) {
-				XGI_DisableGatingCRT(HwDeviceExtension, pVBInfo);
-				XGI_DisplayOn(HwDeviceExtension, pVBInfo);
-				XGI_VBLongWait(pVBInfo);
-			}
-		}
-	} /* 301 */
-	else { /* LVDS */
-		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD
-				| SetCRT2ToLCDA))
-			XGINew_SetRegOR(pVBInfo->Part1Port, 0x1E, 0x20); /* enable CRT2 */
-
-		tempah = (unsigned char) XGINew_GetReg1(pVBInfo->Part1Port,
-				0x2E);
-		if (!(tempah & 0x80))
-			XGINew_SetRegOR(pVBInfo->Part1Port, 0x2E, 0x80); /* BVBDOENABLE = 1 */
-
-		XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F);
-		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
-	} /* End of VB */
-
-	if (HwDeviceExtension->jChipType < XG40) {
-		if (!XGI_EnableChISLCD(pVBInfo)) {
-			if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
-				if (XGI_BacklightByDrv(pVBInfo))
-					return;
-			} else
-				return;
-		}
-
-		if (pVBInfo->LCDInfo & SetPWDEnable) {
-			XGI_FirePWDEnable(pVBInfo);
-			return;
-		}
-
-		XGI_SetPanelDelay(2, pVBInfo);
-
-		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
-			tempah = 0x01;
-			tempbl = 0xFE; /* turn on backlght */
-		} else {
-			tempbl = 0xF7;
-			tempah = 0x00;
-		}
-		XGI_SetPanelPower(tempah, tempbl, pVBInfo);
-	}
-}
-
 void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -7836,32 +7217,55 @@ static unsigned short XGI_GetTVPtrIndex(struct vb_device_info *pVBInfo)
 }
 
 /* --------------------------------------------------------------------- */
-/* Function : XGI_OEM310Setting */
+/* Function : XGI_GetTVPtrIndex2 */
 /* Input : */
-/* Output : */
-/* Description : Customized Param. for 301 */
+/* Output : bx 0 : NTSC */
+/* 1 : PAL */
+/* 2 : PALM */
+/* 3 : PALN */
+/* 4 : NTSC1024x768 */
+/* 5 : PAL-M 1024x768 */
+/* 6-7: reserved */
+/* cl 0 : YFilter1 */
+/* 1 : YFilter2 */
+/* ch 0 : 301A */
+/* 1 : 301B/302B/301LV/302LV */
+/* Description : */
 /* --------------------------------------------------------------------- */
-static void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex,
-		struct vb_device_info *pVBInfo)
+static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
+		unsigned char *tempch, struct vb_device_info *pVBInfo)
 {
-	if (pVBInfo->SetFlag & Win9xDOSMode)
-		return;
+	*tempbx = 0;
+	*tempcl = 0;
+	*tempch = 0;
 
-	/* GetPart1IO(); */
-	XGI_SetDelayComp(pVBInfo);
+	if (pVBInfo->TVInfo & SetPALTV)
+		*tempbx = 1;
 
-	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))
-		XGI_SetLCDCap(pVBInfo);
+	if (pVBInfo->TVInfo & SetPALMTV)
+		*tempbx = 2;
 
-	if (pVBInfo->VBInfo & SetCRT2ToTV) {
-		/* GetPart2IO() */
-		XGI_SetPhaseIncr(pVBInfo);
-		XGI_SetYFilter(ModeNo, ModeIdIndex, pVBInfo);
-		XGI_SetAntiFlicker(ModeNo, ModeIdIndex, pVBInfo);
+	if (pVBInfo->TVInfo & SetPALNTV)
+		*tempbx = 3;
 
-		if (pVBInfo->VBType & VB_XGI301)
-			XGI_SetEdgeEnhance(ModeNo, ModeIdIndex, pVBInfo);
+	if (pVBInfo->TVInfo & NTSC1024x768) {
+		*tempbx = 4;
+		if (pVBInfo->TVInfo & SetPALMTV)
+			*tempbx = 5;
+	}
+
+	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+			| VB_XGI302LV | VB_XGI301C)) {
+		if ((!(pVBInfo->VBInfo & SetInSlaveMode)) || (pVBInfo->TVInfo
+				& TVSimuMode)) {
+			*tempbx += 8;
+			*tempcl += 1;
+		}
 	}
+
+	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+			| VB_XGI302LV | VB_XGI301C))
+		(*tempch)++;
 }
 
 static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
@@ -7932,43 +7336,6 @@ static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 	}
 }
 
-static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
-{
-	unsigned short tempcx;
-
-	tempcx = pVBInfo->LCDCapList[XGI_GetLCDCapPtr(pVBInfo)].LCD_Capability;
-
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
-		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) { /* 301LV/302LV only */
-			/* Set 301LV Capability */
-			XGINew_SetReg1(pVBInfo->Part4Port, 0x24,
-					(unsigned char) (tempcx & 0x1F));
-		}
-		/* VB Driving */
-		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x0D,
-				~((EnableVBCLKDRVLOW | EnablePLLSPLOW) >> 8),
-				(unsigned short) ((tempcx & (EnableVBCLKDRVLOW
-						| EnablePLLSPLOW)) >> 8));
-	}
-
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
-		if (pVBInfo->VBInfo & SetCRT2ToLCD)
-			XGI_SetLCDCap_B(tempcx, pVBInfo);
-		else if (pVBInfo->VBInfo & SetCRT2ToLCDA)
-			XGI_SetLCDCap_A(tempcx, pVBInfo);
-
-		if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
-			if (tempcx & EnableSpectrum)
-				SetSpectrum(pVBInfo);
-		}
-	} else {
-		/* LVDS,CH7017 */
-		XGI_SetLCDCap_A(tempcx, pVBInfo);
-	}
-}
-
 static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp;
@@ -8037,6 +7404,43 @@ static void SetSpectrum(struct vb_device_info *pVBInfo)
 	XGINew_SetRegOR(pVBInfo->Part4Port, 0x30, 0x40); /* enable spectrum */
 }
 
+static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
+{
+	unsigned short tempcx;
+
+	tempcx = pVBInfo->LCDCapList[XGI_GetLCDCapPtr(pVBInfo)].LCD_Capability;
+
+	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+			| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) { /* 301LV/302LV only */
+			/* Set 301LV Capability */
+			XGINew_SetReg1(pVBInfo->Part4Port, 0x24,
+					(unsigned char) (tempcx & 0x1F));
+		}
+		/* VB Driving */
+		XGINew_SetRegANDOR(pVBInfo->Part4Port, 0x0D,
+				~((EnableVBCLKDRVLOW | EnablePLLSPLOW) >> 8),
+				(unsigned short) ((tempcx & (EnableVBCLKDRVLOW
+						| EnablePLLSPLOW)) >> 8));
+	}
+
+	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+			| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBInfo & SetCRT2ToLCD)
+			XGI_SetLCDCap_B(tempcx, pVBInfo);
+		else if (pVBInfo->VBInfo & SetCRT2ToLCDA)
+			XGI_SetLCDCap_A(tempcx, pVBInfo);
+
+		if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
+			if (tempcx & EnableSpectrum)
+				SetSpectrum(pVBInfo);
+		}
+	} else {
+		/* LVDS,CH7017 */
+		XGI_SetLCDCap_A(tempcx, pVBInfo);
+	}
+}
+
 /* --------------------------------------------------------------------- */
 /* Function : XGI_SetAntiFlicker */
 /* Input : */
@@ -8193,55 +7597,32 @@ static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
 }
 
 /* --------------------------------------------------------------------- */
-/* Function : XGI_GetTVPtrIndex2 */
+/* Function : XGI_OEM310Setting */
 /* Input : */
-/* Output : bx 0 : NTSC */
-/* 1 : PAL */
-/* 2 : PALM */
-/* 3 : PALN */
-/* 4 : NTSC1024x768 */
-/* 5 : PAL-M 1024x768 */
-/* 6-7: reserved */
-/* cl 0 : YFilter1 */
-/* 1 : YFilter2 */
-/* ch 0 : 301A */
-/* 1 : 301B/302B/301LV/302LV */
-/* Description : */
+/* Output : */
+/* Description : Customized Param. for 301 */
 /* --------------------------------------------------------------------- */
-static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
-		unsigned char *tempch, struct vb_device_info *pVBInfo)
+static void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex,
+		struct vb_device_info *pVBInfo)
 {
-	*tempbx = 0;
-	*tempcl = 0;
-	*tempch = 0;
-
-	if (pVBInfo->TVInfo & SetPALTV)
-		*tempbx = 1;
+	if (pVBInfo->SetFlag & Win9xDOSMode)
+		return;
 
-	if (pVBInfo->TVInfo & SetPALMTV)
-		*tempbx = 2;
+	/* GetPart1IO(); */
+	XGI_SetDelayComp(pVBInfo);
 
-	if (pVBInfo->TVInfo & SetPALNTV)
-		*tempbx = 3;
+	if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))
+		XGI_SetLCDCap(pVBInfo);
 
-	if (pVBInfo->TVInfo & NTSC1024x768) {
-		*tempbx = 4;
-		if (pVBInfo->TVInfo & SetPALMTV)
-			*tempbx = 5;
-	}
+	if (pVBInfo->VBInfo & SetCRT2ToTV) {
+		/* GetPart2IO() */
+		XGI_SetPhaseIncr(pVBInfo);
+		XGI_SetYFilter(ModeNo, ModeIdIndex, pVBInfo);
+		XGI_SetAntiFlicker(ModeNo, ModeIdIndex, pVBInfo);
 
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C)) {
-		if ((!(pVBInfo->VBInfo & SetInSlaveMode)) || (pVBInfo->TVInfo
-				& TVSimuMode)) {
-			*tempbx += 8;
-			*tempcl += 1;
-		}
+		if (pVBInfo->VBType & VB_XGI301)
+			XGI_SetEdgeEnhance(ModeNo, ModeIdIndex, pVBInfo);
 	}
-
-	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
-			| VB_XGI302LV | VB_XGI301C))
-		(*tempch)++;
 }
 
 /* --------------------------------------------------------------------- */
@@ -8474,83 +7855,6 @@ void XGI_OpenCRTC(struct xgi_hw_device_info *HwDeviceExtension,
 	tempbx = 0;
 }
 
-static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short tempax, tempbx, temp1, temp2, modeflag = 0, tempcx,
-			StandTableIndex, CRT1Index;
-
-	pVBInfo->RVBHCMAX = 1;
-	pVBInfo->RVBHCFACT = 1;
-
-	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
-		StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
-		tempax = pVBInfo->StandTable[StandTableIndex].CRTC[0];
-		tempbx = pVBInfo->StandTable[StandTableIndex].CRTC[6];
-		temp1 = pVBInfo->StandTable[StandTableIndex].CRTC[7];
-	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-		CRT1Index
-				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
-		CRT1Index &= IndexMask;
-		temp1
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[0];
-		temp2
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[5];
-		tempax = (temp1 & 0xFF) | ((temp2 & 0x03) << 8);
-		tempbx
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[8];
-		tempcx
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[14]
-						<< 8;
-		tempcx &= 0x0100;
-		tempcx = tempcx << 2;
-		tempbx |= tempcx;
-		temp1
-				= (unsigned short) pVBInfo->XGINEWUB_CRT1Table[CRT1Index].CR[9];
-	}
-
-	if (temp1 & 0x01)
-		tempbx |= 0x0100;
-
-	if (temp1 & 0x20)
-		tempbx |= 0x0200;
-	tempax += 5;
-
-	if (modeflag & Charx8Dot)
-		tempax *= 8;
-	else
-		tempax *= 9;
-
-	pVBInfo->VGAHT = tempax;
-	pVBInfo->HT = tempax;
-	tempbx++;
-	pVBInfo->VGAVT = tempbx;
-	pVBInfo->VT = tempbx;
-}
-
-static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
-		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
-{
-	unsigned short ColorDepth[6] = { 1, 2, 4, 4, 6, 8 };
-	short index;
-	unsigned short modeflag;
-
-	if (ModeNo <= 0x13)
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
-	else
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-
-	index = (modeflag & ModeInfoFlag) - ModeEGA;
-
-	if (index < 0)
-		index = 0;
-
-	return ColorDepth[index];
-}
-
 void XGI_UnLockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -8567,11 +7871,6 @@ void XGI_LockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
 
 }
 
-static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo)
-{
-	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1E, 0xFF, 0x20);
-}
-
 unsigned char XGI_BridgeIsOn(struct vb_device_info *pVBInfo)
 {
 	unsigned short flag;
@@ -8638,188 +7937,776 @@ static void XGI_VBLongWait(struct vb_device_info *pVBInfo)
 	return;
 }
 
-static unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo)
+unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
+		unsigned short ModeNo, unsigned short ModeIdIndex,
+		struct vb_device_info *pVBInfo)
 {
-	unsigned long tempax, tempbx;
+	short LCDRefreshIndex[] = { 0x00, 0x00, 0x03, 0x01 },
+			LCDARefreshIndex[] = { 0x00, 0x00, 0x03, 0x01, 0x01,
+					0x01, 0x01 };
 
-	tempbx = ((pVBInfo->VGAVT - pVBInfo->VGAVDE) * pVBInfo->RVBHCMAX)
-			& 0xFFFF;
-	tempax = (pVBInfo->VT - pVBInfo->VDE) * pVBInfo->RVBHCFACT;
-	tempax = (tempax * pVBInfo->HT) / tempbx;
+	unsigned short RefreshRateTableIndex, i, modeflag, index, temp;
 
-	return (unsigned short) tempax;
+	if (ModeNo <= 0x13)
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
+	else
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
+
+	if (pVBInfo->IF_DEF_CH7005 == 1) {
+		if (pVBInfo->VBInfo & SetCRT2ToTV) {
+			if (modeflag & HalfDCLK)
+				return 0;
+		}
+	}
+
+	if (ModeNo < 0x14)
+		return 0xFFFF;
+
+	index = XGINew_GetReg1(pVBInfo->P3d4, 0x33);
+	index = index >> pVBInfo->SelectCRT2Rate;
+	index &= 0x0F;
+
+	if (pVBInfo->LCDInfo & LCDNonExpanding)
+		index = 0;
+
+	if (index > 0)
+		index--;
+
+	if (pVBInfo->SetFlag & ProgrammingCRT2) {
+		if (pVBInfo->IF_DEF_CH7005 == 1) {
+			if (pVBInfo->VBInfo & SetCRT2ToTV)
+				index = 0;
+		}
+
+		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+			if (pVBInfo->IF_DEF_LVDS == 0) {
+				if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B
+						| VB_XGI301LV | VB_XGI302LV
+						| VB_XGI301C))
+					temp
+							= LCDARefreshIndex[pVBInfo->LCDResInfo
+									& 0x0F]; /* 301b */
+				else
+					temp
+							= LCDRefreshIndex[pVBInfo->LCDResInfo
+									& 0x0F];
+
+				if (index > temp)
+					index = temp;
+			} else {
+				index = 0;
+			}
+		}
+	}
+
+	RefreshRateTableIndex = pVBInfo->EModeIDTable[ModeIdIndex].REFindex;
+	ModeNo = pVBInfo->RefIndex[RefreshRateTableIndex].ModeID;
+	if (pXGIHWDE->jChipType >= XG20) { /* for XG20, XG21, XG27 */
+		/*
+		if (pVBInfo->RefIndex[RefreshRateTableIndex].Ext_InfoFlag & XG2xNotSupport) {
+			index++;
+		}
+		*/
+		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 800)
+				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
+						== 600)) {
+			index++;
+		}
+		/* Alan 10/19/2007; do the similiar adjustment like XGISearchCRT1Rate() */
+		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1024)
+				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
+						== 768)) {
+			index++;
+		}
+		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1280)
+				&& (pVBInfo->RefIndex[RefreshRateTableIndex].YRes
+						== 1024)) {
+			index++;
+		}
+	}
+
+	i = 0;
+	do {
+		if (pVBInfo->RefIndex[RefreshRateTableIndex + i].ModeID
+				!= ModeNo)
+			break;
+		temp
+				= pVBInfo->RefIndex[RefreshRateTableIndex + i].Ext_InfoFlag;
+		temp &= ModeInfoFlag;
+		if (temp < pVBInfo->ModeType)
+			break;
+		i++;
+		index--;
+
+	} while (index != 0xFFFF);
+	if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
+		if (pVBInfo->VBInfo & SetInSlaveMode) {
+			temp
+					= pVBInfo->RefIndex[RefreshRateTableIndex
+							+ i - 1].Ext_InfoFlag;
+			if (temp & InterlaceMode)
+				i++;
+		}
+	}
+	i--;
+	if ((pVBInfo->SetFlag & ProgrammingCRT2)) {
+		temp = XGI_AjustCRT2Rate(ModeNo, ModeIdIndex,
+				RefreshRateTableIndex, &i, pVBInfo);
+	}
+	return RefreshRateTableIndex + i; /* return (0x01 | (temp1<<1)); */
 }
 
-static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
-		unsigned short ModeIdIndex,
-		unsigned short RefreshRateTableIndex,
+static void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short tempbx;
+	unsigned short RefreshRateTableIndex;
+	/* unsigned short temp ; */
 
-	unsigned short LCDXlat1VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
-			VCLK65 + 2 };
-	unsigned short LCDXlat2VCLK[4] = { VCLK108_2 + 5, VCLK108_2 + 5,
-			VCLK108_2 + 5, VCLK108_2 + 5 };
-	unsigned short LVDSXlat1VCLK[4] = { VCLK40, VCLK40, VCLK40, VCLK40 };
-	unsigned short LVDSXlat2VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
-			VCLK65 + 2 };
-	unsigned short LVDSXlat3VCLK[4] = { VCLK65 + 2, VCLK65 + 2, VCLK65 + 2,
-			VCLK65 + 2 };
+	/* pVBInfo->SelectCRT2Rate = 0; */
 
-	unsigned short CRT2Index, VCLKIndex;
-	unsigned short modeflag, resinfo;
-	unsigned char *CHTVVCLKPtr = NULL;
+	pVBInfo->SetFlag |= ProgrammingCRT2;
+	RefreshRateTableIndex = XGI_GetRatePtrCRT2(HwDeviceExtension, ModeNo,
+			ModeIdIndex, pVBInfo);
+	XGI_GetLVDSResInfo(ModeNo, ModeIdIndex, pVBInfo);
+	XGI_GetLVDSData(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
+	XGI_ModCRT1Regs(ModeNo, ModeIdIndex, RefreshRateTableIndex,
+			HwDeviceExtension, pVBInfo);
+	XGI_SetLVDSRegs(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
+	XGI_SetCRT2ECLK(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
+}
 
-	if (ModeNo <= 0x13) {
-		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag; /* si+St_ResInfo */
-		resinfo = pVBInfo->SModeIDTable[ModeIdIndex].St_ResInfo;
-		CRT2Index = pVBInfo->SModeIDTable[ModeIdIndex].St_CRT2CRTC;
-	} else {
-		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag; /* si+Ext_ResInfo */
-		resinfo = pVBInfo->EModeIDTable[ModeIdIndex].Ext_RESINFO;
-		CRT2Index
-				= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
-	}
+unsigned char XGI_SetCRT2Group301(unsigned short ModeNo,
+		struct xgi_hw_device_info *HwDeviceExtension,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short tempbx, ModeIdIndex, RefreshRateTableIndex;
 
-	if (pVBInfo->IF_DEF_LVDS == 0) {
-		CRT2Index = CRT2Index >> 6; /*  for LCD */
-		if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) { /*301b*/
-			if (pVBInfo->LCDResInfo != Panel1024x768)
-				VCLKIndex = LCDXlat2VCLK[CRT2Index];
-			else
-				VCLKIndex = LCDXlat1VCLK[CRT2Index];
-		} else { /* for TV */
-			if (pVBInfo->VBInfo & SetCRT2ToTV) {
-				if (pVBInfo->VBInfo & SetCRT2ToHiVisionTV) {
-					if (pVBInfo->SetFlag & RPLLDIV2XO) {
-						VCLKIndex = HiTVVCLKDIV2;
+	tempbx = pVBInfo->VBInfo;
+	pVBInfo->SetFlag |= ProgrammingCRT2;
+	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
+	pVBInfo->SelectCRT2Rate = 4;
+	RefreshRateTableIndex = XGI_GetRatePtrCRT2(HwDeviceExtension, ModeNo,
+			ModeIdIndex, pVBInfo);
+	XGI_SaveCRT2Info(ModeNo, pVBInfo);
+	XGI_GetCRT2ResInfo(ModeNo, ModeIdIndex, pVBInfo);
+	XGI_GetCRT2Data(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
+	XGI_PreSetGroup1(ModeNo, ModeIdIndex, HwDeviceExtension,
+			RefreshRateTableIndex, pVBInfo);
+	XGI_SetGroup1(ModeNo, ModeIdIndex, HwDeviceExtension,
+			RefreshRateTableIndex, pVBInfo);
+	XGI_SetLockRegs(ModeNo, ModeIdIndex, HwDeviceExtension,
+			RefreshRateTableIndex, pVBInfo);
+	XGI_SetGroup2(ModeNo, ModeIdIndex, RefreshRateTableIndex,
+			HwDeviceExtension, pVBInfo);
+	XGI_SetLCDRegs(ModeNo, ModeIdIndex, HwDeviceExtension,
+			RefreshRateTableIndex, pVBInfo);
+	XGI_SetTap4Regs(pVBInfo);
+	XGI_SetGroup3(ModeNo, ModeIdIndex, pVBInfo);
+	XGI_SetGroup4(ModeNo, ModeIdIndex, RefreshRateTableIndex,
+			HwDeviceExtension, pVBInfo);
+	XGI_SetCRT2VCLK(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
+	XGI_SetGroup5(ModeNo, ModeIdIndex, pVBInfo);
+	XGI_AutoThreshold(pVBInfo);
+	return 1;
+}
 
-						VCLKIndex += 25;
+void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
+{
+	unsigned char CRTCData[17] = { 0x5F, 0x4F, 0x50, 0x82, 0x55, 0x81,
+			0x0B, 0x3E, 0xE9, 0x0B, 0xDF, 0xE7, 0x04, 0x00, 0x00,
+			0x05, 0x00 };
 
-					} else {
-						VCLKIndex = HiTVVCLK;
+	unsigned char SR01 = 0, SR1F = 0, SR07 = 0, SR06 = 0;
 
-						VCLKIndex += 25;
+	unsigned char CR17, CR63, SR31;
+	unsigned short temp;
+	unsigned char DAC_TEST_PARMS[3] = { 0x0F, 0x0F, 0x0F };
 
-					}
+	int i;
+	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
 
-					if (pVBInfo->SetFlag & TVSimuMode) {
-						if (modeflag & Charx8Dot) {
-							VCLKIndex
-									= HiTVSimuVCLK;
+	/* [2004/05/06] Vicent to fix XG42 single LCD sense to CRT+LCD */
+	XGINew_SetReg1(pVBInfo->P3d4, 0x57, 0x4A);
+	XGINew_SetReg1(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
+			pVBInfo->P3d4, 0x53) | 0x02));
 
-							VCLKIndex += 25;
+	SR31 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x31);
+	CR63 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x63);
+	SR01 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x01);
 
-						} else {
-							VCLKIndex
-									= HiTVTextVCLK;
+	XGINew_SetReg1(pVBInfo->P3c4, 0x01, (unsigned char) (SR01 & 0xDF));
+	XGINew_SetReg1(pVBInfo->P3d4, 0x63, (unsigned char) (CR63 & 0xBF));
 
-							VCLKIndex += 25;
+	CR17 = (unsigned char) XGINew_GetReg1(pVBInfo->P3d4, 0x17);
+	XGINew_SetReg1(pVBInfo->P3d4, 0x17, (unsigned char) (CR17 | 0x80));
 
-						}
-					}
+	SR1F = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x1F);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, (unsigned char) (SR1F | 0x04));
 
-					if (pVBInfo->VBType & VB_XGI301LV) { /* 301lv */
-						if (!(pVBInfo->VBExtInfo
-								== VB_YPbPr1080i)) {
-							VCLKIndex
-									= YPbPr750pVCLK;
-							if (!(pVBInfo->VBExtInfo
-									== VB_YPbPr750p)) {
-								VCLKIndex
-										= YPbPr525pVCLK;
-								if (!(pVBInfo->VBExtInfo
-										== VB_YPbPr525p)) {
-									VCLKIndex
-											= YPbPr525iVCLK_2;
-									if (!(pVBInfo->SetFlag
-											& RPLLDIV2XO))
-										VCLKIndex
-												= YPbPr525iVCLK;
-								}
-							}
-						}
-					}
-				} else {
-					if (pVBInfo->VBInfo & SetCRT2ToTV) {
-						if (pVBInfo->SetFlag
-								& RPLLDIV2XO) {
-							VCLKIndex = TVVCLKDIV2;
+	SR07 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x07);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x07, (unsigned char) (SR07 & 0xFB));
+	SR06 = (unsigned char) XGINew_GetReg1(pVBInfo->P3c4, 0x06);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x06, (unsigned char) (SR06 & 0xC3));
 
-							VCLKIndex += 25;
+	XGINew_SetReg1(pVBInfo->P3d4, 0x11, 0x00);
 
-						} else {
-							VCLKIndex = TVVCLK;
+	for (i = 0; i < 8; i++)
+		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) i, CRTCData[i]);
 
-							VCLKIndex += 25;
+	for (i = 8; i < 11; i++)
+		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 8),
+				CRTCData[i]);
 
-						}
+	for (i = 11; i < 13; i++)
+		XGINew_SetReg1(pVBInfo->P3d4, (unsigned short) (i + 4),
+				CRTCData[i]);
+
+	for (i = 13; i < 16; i++)
+		XGINew_SetReg1(pVBInfo->P3c4, (unsigned short) (i - 3),
+				CRTCData[i]);
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x0E, (unsigned char) (CRTCData[16]
+			& 0xE0));
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x31, 0x00);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE1);
+
+	XGINew_SetReg3(pVBInfo->P3c8, 0x00);
+
+	for (i = 0; i < 256; i++) {
+		XGINew_SetReg3((pVBInfo->P3c8 + 1),
+				(unsigned char) DAC_TEST_PARMS[0]);
+		XGINew_SetReg3((pVBInfo->P3c8 + 1),
+				(unsigned char) DAC_TEST_PARMS[1]);
+		XGINew_SetReg3((pVBInfo->P3c8 + 1),
+				(unsigned char) DAC_TEST_PARMS[2]);
+	}
+
+	XGI_VBLongWait(pVBInfo);
+	XGI_VBLongWait(pVBInfo);
+	XGI_VBLongWait(pVBInfo);
+
+	mdelay(1);
+
+	XGI_WaitDisply(pVBInfo);
+	temp = XGINew_GetReg2(pVBInfo->P3c2);
+
+	if (temp & 0x10)
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x20);
+	else
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x00);
+
+	/* alan, avoid display something, set BLACK DAC if not restore DAC */
+	XGINew_SetReg3(pVBInfo->P3c8, 0x00);
+
+	for (i = 0; i < 256; i++) {
+		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
+		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
+		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
+	}
+
+	XGINew_SetReg1(pVBInfo->P3c4, 0x01, SR01);
+	XGINew_SetReg1(pVBInfo->P3d4, 0x63, CR63);
+	XGINew_SetReg1(pVBInfo->P3c4, 0x31, SR31);
+
+	/* [2004/05/11] Vicent */
+	XGINew_SetReg1(pVBInfo->P3d4, 0x53, (unsigned char) (XGINew_GetReg1(
+			pVBInfo->P3d4, 0x53) & 0xFD));
+	XGINew_SetReg1(pVBInfo->P3c4, 0x1F, (unsigned char) SR1F);
+}
+
+void XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short tempbl, tempah;
+
+	if (pVBInfo->SetFlag == Win9xDOSMode) {
+		if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+				| VB_XGI302LV | VB_XGI301C)) {
+			XGI_DisplayOn(HwDeviceExtension, pVBInfo);
+			return;
+		} else
+			/* LVDS or CH7017 */
+			return;
+	}
+
+	if (HwDeviceExtension->jChipType < XG40) {
+		if (!XGI_DisableChISLCD(pVBInfo)) {
+			if ((XGI_EnableChISLCD(pVBInfo)) || (pVBInfo->VBInfo
+					& (SetCRT2ToLCD | SetCRT2ToLCDA))) {
+				if (pVBInfo->LCDInfo & SetPWDEnable) {
+					XGI_EnablePWD(pVBInfo);
+				} else {
+					pVBInfo->LCDInfo &= (~SetPWDEnable);
+					if (pVBInfo->VBType & (VB_XGI301LV
+							| VB_XGI302LV
+							| VB_XGI301C)) {
+						tempbl = 0xFD;
+						tempah = 0x02;
+					} else {
+						tempbl = 0xFB;
+						tempah = 0x00;
 					}
+
+					XGI_SetPanelPower(tempah, tempbl,
+							pVBInfo);
+					XGI_SetPanelDelay(1, pVBInfo);
 				}
-			} else { /* for CRT2 */
-				VCLKIndex = (unsigned char) XGINew_GetReg2(
-						(pVBInfo->P3ca + 0x02)); /* Port 3cch */
-				VCLKIndex = ((VCLKIndex >> 2) & 0x03);
-				if (ModeNo > 0x13) {
-					VCLKIndex
-							= pVBInfo->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK; /* di+Ext_CRTVCLK */
-					VCLKIndex &= IndexMask;
+			}
+		}
+	} /* Not 340 */
+
+	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+			| VB_XGI302LV | VB_XGI301C)) {
+		if (!(pVBInfo->SetFlag & DisableChA)) {
+			if (pVBInfo->SetFlag & EnableChA) {
+				XGINew_SetReg1(pVBInfo->Part1Port, 0x1E, 0x20); /* Power on */
+			} else {
+				if (pVBInfo->VBInfo & SetCRT2ToDualEdge) { /* SetCRT2ToLCDA ) */
+					XGINew_SetReg1(pVBInfo->Part1Port,
+							0x1E, 0x20); /* Power on */
 				}
 			}
 		}
-	} else { /* LVDS */
-		if (ModeNo <= 0x13)
-			VCLKIndex = CRT2Index;
-		else
-			VCLKIndex = CRT2Index;
 
-		if (pVBInfo->IF_DEF_CH7005 == 1) {
-			if (!(pVBInfo->VBInfo & SetCRT2ToLCD)) {
-				VCLKIndex &= 0x1f;
-				tempbx = 0;
+		if (!(pVBInfo->SetFlag & DisableChB)) {
+			if ((pVBInfo->SetFlag & EnableChB) || (pVBInfo->VBInfo
+					& (SetCRT2ToLCD | SetCRT2ToTV
+							| SetCRT2ToRAMDAC))) {
+				tempah = (unsigned char) XGINew_GetReg1(
+						pVBInfo->P3c4, 0x32);
+				tempah &= 0xDF;
+				if (pVBInfo->VBInfo & SetInSlaveMode) {
+					if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC))
+						tempah |= 0x20;
+				}
+				XGINew_SetReg1(pVBInfo->P3c4, 0x32, tempah);
+				XGINew_SetRegOR(pVBInfo->P3c4, 0x1E, 0x20);
 
-				if (pVBInfo->VBInfo & SetPALTV)
-					tempbx += 2;
+				tempah = (unsigned char) XGINew_GetReg1(
+						pVBInfo->Part1Port, 0x2E);
 
-				if (pVBInfo->VBInfo & SetCHTVOverScan)
-					tempbx += 1;
+				if (!(tempah & 0x80))
+					XGINew_SetRegOR(pVBInfo->Part1Port,
+							0x2E, 0x80); /* BVBDOENABLE = 1 */
 
-				switch (tempbx) {
-				case 0:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKUNTSC;
-					break;
-				case 1:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKONTSC;
-					break;
-				case 2:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKUPAL;
-					break;
-				case 3:
-					CHTVVCLKPtr = pVBInfo->CHTVVCLKOPAL;
-					break;
-				default:
-					break;
+				XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F); /* BScreenOFF = 0 */
+			}
+		}
+
+		if ((pVBInfo->SetFlag & (EnableChA | EnableChB))
+				|| (!(pVBInfo->VBInfo & DisableCRT2Display))) {
+			XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x00, ~0xE0,
+					0x20); /* shampoo 0129 */
+			if (pVBInfo->VBType & (VB_XGI302LV | VB_XGI301C)) {
+				if (!XGI_DisableChISLCD(pVBInfo)) {
+					if (XGI_EnableChISLCD(pVBInfo)
+							|| (pVBInfo->VBInfo
+									& (SetCRT2ToLCD
+											| SetCRT2ToLCDA)))
+						XGINew_SetRegAND(
+								pVBInfo->Part4Port,
+								0x2A, 0x7F); /* LVDS PLL power on */
 				}
+				XGINew_SetRegAND(pVBInfo->Part4Port, 0x30, 0x7F); /* LVDS Driver power on */
+			}
+		}
 
-				VCLKIndex = CHTVVCLKPtr[VCLKIndex];
+		tempah = 0x00;
+
+		if (!(pVBInfo->VBInfo & DisableCRT2Display)) {
+			tempah = 0xc0;
+
+			if (!(pVBInfo->VBInfo & SetSimuScanMode)) {
+				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+					if (pVBInfo->VBInfo & SetCRT2ToDualEdge) {
+						tempah = tempah & 0x40;
+						if (pVBInfo->VBInfo
+								& SetCRT2ToLCDA)
+							tempah = tempah ^ 0xC0;
+
+						if (pVBInfo->SetFlag
+								& DisableChB)
+							tempah &= 0xBF;
+
+						if (pVBInfo->SetFlag
+								& DisableChA)
+							tempah &= 0x7F;
+
+						if (pVBInfo->SetFlag
+								& EnableChB)
+							tempah |= 0x40;
+
+						if (pVBInfo->SetFlag
+								& EnableChA)
+							tempah |= 0x80;
+					}
+				}
+			}
+		}
+
+		XGINew_SetRegOR(pVBInfo->Part4Port, 0x1F, tempah); /* EnablePart4_1F */
+
+		if (pVBInfo->SetFlag & Win9xDOSMode) {
+			XGI_DisplayOn(HwDeviceExtension, pVBInfo);
+			return;
+		}
+
+		if (!(pVBInfo->SetFlag & DisableChA)) {
+			XGI_VBLongWait(pVBInfo);
+			if (!(pVBInfo->SetFlag & GatingCRT)) {
+				XGI_DisableGatingCRT(HwDeviceExtension, pVBInfo);
+				XGI_DisplayOn(HwDeviceExtension, pVBInfo);
+				XGI_VBLongWait(pVBInfo);
 			}
+		}
+	} /* 301 */
+	else { /* LVDS */
+		if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD
+				| SetCRT2ToLCDA))
+			XGINew_SetRegOR(pVBInfo->Part1Port, 0x1E, 0x20); /* enable CRT2 */
+
+		tempah = (unsigned char) XGINew_GetReg1(pVBInfo->Part1Port,
+				0x2E);
+		if (!(tempah & 0x80))
+			XGINew_SetRegOR(pVBInfo->Part1Port, 0x2E, 0x80); /* BVBDOENABLE = 1 */
+
+		XGINew_SetRegAND(pVBInfo->Part1Port, 0x00, 0x7F);
+		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
+	} /* End of VB */
+
+	if (HwDeviceExtension->jChipType < XG40) {
+		if (!XGI_EnableChISLCD(pVBInfo)) {
+			if (pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) {
+				if (XGI_BacklightByDrv(pVBInfo))
+					return;
+			} else
+				return;
+		}
+
+		if (pVBInfo->LCDInfo & SetPWDEnable) {
+			XGI_FirePWDEnable(pVBInfo);
+			return;
+		}
+
+		XGI_SetPanelDelay(2, pVBInfo);
+
+		if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C)) {
+			tempah = 0x01;
+			tempbl = 0xFE; /* turn on backlght */
 		} else {
-			VCLKIndex = VCLKIndex >> 6;
-			if ((pVBInfo->LCDResInfo == Panel800x600)
-					|| (pVBInfo->LCDResInfo == Panel320x480))
-				VCLKIndex = LVDSXlat1VCLK[VCLKIndex];
-			else if ((pVBInfo->LCDResInfo == Panel1024x768)
-					|| (pVBInfo->LCDResInfo
-							== Panel1024x768x75))
-				VCLKIndex = LVDSXlat2VCLK[VCLKIndex];
+			tempbl = 0xF7;
+			tempah = 0x00;
+		}
+		XGI_SetPanelPower(tempah, tempbl, pVBInfo);
+	}
+}
+
+static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
+		unsigned short ModeNo, unsigned short ModeIdIndex,
+		struct vb_device_info *pVBInfo)
+{
+	unsigned short StandTableIndex, RefreshRateTableIndex, b3CC, temp;
+
+	unsigned short XGINew_P3cc = pVBInfo->P3cc;
+
+	/* XGINew_CRT1Mode = ModeNo; // SaveModeID */
+	StandTableIndex = XGI_GetModePtr(ModeNo, ModeIdIndex, pVBInfo);
+	/* XGI_SetBIOSData(ModeNo, ModeIdIndex); */
+	/* XGI_ClearBankRegs(ModeNo, ModeIdIndex); */
+	XGI_SetSeqRegs(ModeNo, StandTableIndex, ModeIdIndex, pVBInfo);
+	XGI_SetMiscRegs(StandTableIndex, pVBInfo);
+	XGI_SetCRTCRegs(HwDeviceExtension, StandTableIndex, pVBInfo);
+	XGI_SetATTRegs(ModeNo, StandTableIndex, ModeIdIndex, pVBInfo);
+	XGI_SetGRCRegs(StandTableIndex, pVBInfo);
+	XGI_ClearExt1Regs(pVBInfo);
+
+	/* if (pVBInfo->IF_DEF_ExpLink) */
+	if (HwDeviceExtension->jChipType == XG27) {
+		if (pVBInfo->IF_DEF_LVDS == 0)
+			XGI_SetDefaultVCLK(pVBInfo);
+	}
+
+	temp = ~ProgrammingCRT2;
+	pVBInfo->SetFlag &= temp;
+	pVBInfo->SelectCRT2Rate = 0;
+
+	if (pVBInfo->VBType & (VB_XGI301B | VB_XGI302B | VB_XGI301LV
+			| VB_XGI302LV | VB_XGI301C)) {
+		if (pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToLCDA
+				| SetInSlaveMode)) {
+			pVBInfo->SetFlag |= ProgrammingCRT2;
+		}
+	}
+
+	RefreshRateTableIndex = XGI_GetRatePtrCRT2(HwDeviceExtension, ModeNo,
+			ModeIdIndex, pVBInfo);
+	if (RefreshRateTableIndex != 0xFFFF) {
+		XGI_SetSync(RefreshRateTableIndex, pVBInfo);
+		XGI_SetCRT1CRTC(ModeNo, ModeIdIndex, RefreshRateTableIndex,
+				pVBInfo, HwDeviceExtension);
+		XGI_SetCRT1DE(HwDeviceExtension, ModeNo, ModeIdIndex,
+				RefreshRateTableIndex, pVBInfo);
+		XGI_SetCRT1Offset(ModeNo, ModeIdIndex, RefreshRateTableIndex,
+				HwDeviceExtension, pVBInfo);
+		XGI_SetCRT1VCLK(ModeNo, ModeIdIndex, HwDeviceExtension,
+				RefreshRateTableIndex, pVBInfo);
+	}
+
+	if ((HwDeviceExtension->jChipType >= XG20)
+			&& (HwDeviceExtension->jChipType < XG27)) { /* fix H/W DCLK/2 bug */
+		if ((ModeNo == 0x00) | (ModeNo == 0x01)) {
+			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x4E);
+			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE9);
+			b3CC = (unsigned char) XGINew_GetReg2(XGINew_P3cc);
+			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
+		} else if ((ModeNo == 0x04) | (ModeNo == 0x05) | (ModeNo
+				== 0x0D)) {
+			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
+			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE3);
+			b3CC = (unsigned char) XGINew_GetReg2(XGINew_P3cc);
+			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
+		}
+	}
+
+	if (HwDeviceExtension->jChipType >= XG21) {
+		temp = XGINew_GetReg1(pVBInfo->P3d4, 0x38);
+		if (temp & 0xA0) {
+
+			/* XGINew_SetRegAND(pVBInfo->P3d4, 0x4A, ~0x20); *//* Enable write GPIOF */
+			/* XGINew_SetRegAND(pVBInfo->P3d4, 0x48, ~0x20); *//* P. DWN */
+			/* XG21 CRT1 Timing */
+			if (HwDeviceExtension->jChipType == XG27)
+				XGI_SetXG27CRTC(ModeNo, ModeIdIndex,
+						RefreshRateTableIndex, pVBInfo);
 			else
-				VCLKIndex = LVDSXlat3VCLK[VCLKIndex];
+				XGI_SetXG21CRTC(ModeNo, ModeIdIndex,
+						RefreshRateTableIndex, pVBInfo);
+
+			XGI_UpdateXG21CRTC(ModeNo, pVBInfo,
+					RefreshRateTableIndex);
+
+			if (HwDeviceExtension->jChipType == XG27)
+				XGI_SetXG27LCD(pVBInfo, RefreshRateTableIndex,
+						ModeNo);
+			else
+				XGI_SetXG21LCD(pVBInfo, RefreshRateTableIndex,
+						ModeNo);
+
+			if (pVBInfo->IF_DEF_LVDS == 1) {
+				if (HwDeviceExtension->jChipType == XG27)
+					XGI_SetXG27LVDSPara(ModeNo,
+							ModeIdIndex, pVBInfo);
+				else
+					XGI_SetXG21LVDSPara(ModeNo,
+							ModeIdIndex, pVBInfo);
+			}
+			/* XGINew_SetRegOR(pVBInfo->P3d4, 0x48, 0x20); *//* P. ON */
 		}
 	}
-	/* VCLKIndex = VCLKIndex&IndexMask; */
 
-	return VCLKIndex;
+	pVBInfo->SetFlag &= (~ProgrammingCRT2);
+	XGI_SetCRT1FIFO(ModeNo, HwDeviceExtension, pVBInfo);
+	XGI_SetCRT1ModeRegs(HwDeviceExtension, ModeNo, ModeIdIndex,
+			RefreshRateTableIndex, pVBInfo);
+
+	/* XGI_LoadCharacter(); //dif ifdef TVFont */
+
+	XGI_LoadDAC(ModeNo, ModeIdIndex, pVBInfo);
+	/* XGI_ClearBuffer(HwDeviceExtension, ModeNo, pVBInfo); */
 }
 
+unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
+			unsigned short ModeNo)
+{
+	unsigned short ModeIdIndex;
+	/* unsigned char *pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress; */
+	struct vb_device_info VBINF;
+	struct vb_device_info *pVBInfo = &VBINF;
+	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
+	pVBInfo->BaseAddr = (unsigned long) HwDeviceExtension->pjIOAddress;
+	pVBInfo->IF_DEF_LVDS = 0;
+	pVBInfo->IF_DEF_CH7005 = 0;
+	pVBInfo->IF_DEF_LCDA = 1;
+	pVBInfo->IF_DEF_CH7017 = 0;
+	pVBInfo->IF_DEF_CH7007 = 0; /* [Billy] 2007/05/14 */
+	pVBInfo->IF_DEF_VideoCapture = 0;
+	pVBInfo->IF_DEF_ScaleLCD = 0;
+	pVBInfo->IF_DEF_OEMUtil = 0;
+	pVBInfo->IF_DEF_PWD = 0;
+
+	if (HwDeviceExtension->jChipType >= XG20) { /* kuku 2004/06/25 */
+		pVBInfo->IF_DEF_YPbPr = 0;
+		pVBInfo->IF_DEF_HiVision = 0;
+		pVBInfo->IF_DEF_CRT2Monitor = 0;
+		pVBInfo->VBType = 0; /*set VBType default 0*/
+	} else if (HwDeviceExtension->jChipType >= XG40) {
+		pVBInfo->IF_DEF_YPbPr = 1;
+		pVBInfo->IF_DEF_HiVision = 1;
+		pVBInfo->IF_DEF_CRT2Monitor = 1;
+	} else {
+		pVBInfo->IF_DEF_YPbPr = 1;
+		pVBInfo->IF_DEF_HiVision = 1;
+		pVBInfo->IF_DEF_CRT2Monitor = 0;
+	}
+
+	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
+	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
+	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
+	pVBInfo->P3ce = pVBInfo->BaseAddr + 0x1e;
+	pVBInfo->P3c2 = pVBInfo->BaseAddr + 0x12;
+	pVBInfo->P3cc = pVBInfo->BaseAddr + 0x1C;
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
+
+	if (HwDeviceExtension->jChipType == XG21) { /* for x86 Linux, XG21 LVDS */
+		if ((XGINew_GetReg1(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0)
+			pVBInfo->IF_DEF_LVDS = 1;
+	}
+	if (HwDeviceExtension->jChipType == XG27) {
+		if ((XGINew_GetReg1(pVBInfo->P3d4, 0x38) & 0xE0) == 0xC0) {
+			if (XGINew_GetReg1(pVBInfo->P3d4, 0x30) & 0x20)
+				pVBInfo->IF_DEF_LVDS = 1;
+		}
+	}
+
+	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
+		XGI_GetVBType(pVBInfo);
+
+	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
+	if (ModeNo & 0x80) {
+		ModeNo = ModeNo & 0x7F;
+		/* XGINew_flag_clearbuffer = 0; */
+	}
+	/* else {
+		XGINew_flag_clearbuffer = 1;
+	}
+	*/
+	XGINew_SetReg1(pVBInfo->P3c4, 0x05, 0x86);
+
+	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 1.Openkey */
+		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
+
+	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
+
+	XGI_GetVGAType(HwDeviceExtension, pVBInfo);
+
+	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+		XGI_GetVBInfo(ModeNo, ModeIdIndex, HwDeviceExtension, pVBInfo);
+		XGI_GetTVInfo(ModeNo, ModeIdIndex, pVBInfo);
+		XGI_GetLCDInfo(ModeNo, ModeIdIndex, pVBInfo);
+		XGI_DisableBridge(HwDeviceExtension, pVBInfo);
+		/* XGI_OpenCRTC(HwDeviceExtension, pVBInfo); */
+
+		if (pVBInfo->VBInfo & (SetSimuScanMode | SetCRT2ToLCDA)) {
+			XGI_SetCRT1Group(HwDeviceExtension, ModeNo,
+					ModeIdIndex, pVBInfo);
+
+			if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+				XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
+						HwDeviceExtension, pVBInfo);
+			}
+		} else {
+			if (!(pVBInfo->VBInfo & SwitchToCRT2)) {
+				XGI_SetCRT1Group(HwDeviceExtension, ModeNo,
+						ModeIdIndex, pVBInfo);
+				if (pVBInfo->VBInfo & SetCRT2ToLCDA) {
+					XGI_SetLCDAGroup(ModeNo, ModeIdIndex,
+							HwDeviceExtension,
+							pVBInfo);
+				}
+			}
+		}
+
+		if (pVBInfo->VBInfo & (SetSimuScanMode | SwitchToCRT2)) {
+			switch (HwDeviceExtension->ujVBChipID) {
+			case VB_CHIP_301:
+				XGI_SetCRT2Group301(ModeNo, HwDeviceExtension,
+						pVBInfo); /*add for CRT2 */
+				break;
+
+			case VB_CHIP_302:
+				XGI_SetCRT2Group301(ModeNo, HwDeviceExtension,
+						pVBInfo); /*add for CRT2 */
+				break;
+
+			default:
+				break;
+			}
+		}
+
+		XGI_SetCRT2ModeRegs(ModeNo, HwDeviceExtension, pVBInfo);
+		XGI_OEM310Setting(ModeNo, ModeIdIndex, pVBInfo); /*0212*/
+		XGI_CloseCRTC(HwDeviceExtension, pVBInfo);
+		XGI_EnableBridge(HwDeviceExtension, pVBInfo);
+	} /* !XG20 */
+	else {
+		if (pVBInfo->IF_DEF_LVDS == 1)
+			if (!XGI_XG21CheckLVDSMode(ModeNo, ModeIdIndex, pVBInfo))
+				return 0;
+
+		if (ModeNo <= 0x13) {
+			pVBInfo->ModeType
+					= pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag
+							& ModeInfoFlag;
+		} else {
+			pVBInfo->ModeType
+					= pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag
+							& ModeInfoFlag;
+		}
+
+		pVBInfo->SetFlag = 0;
+		if (pVBInfo->IF_DEF_CH7007 != 1)
+			pVBInfo->VBInfo = DisableCRT2Display;
+
+		XGI_DisplayOff(HwDeviceExtension, pVBInfo);
+
+		XGI_SetCRT1Group(HwDeviceExtension, ModeNo, ModeIdIndex,
+				pVBInfo);
+
+		XGI_DisplayOn(HwDeviceExtension, pVBInfo);
+		/*
+		if (HwDeviceExtension->jChipType == XG21)
+			XGINew_SetRegANDOR(pVBInfo->P3c4, 0x09, ~0x80, 0x80);
+		*/
+	}
+
+	/*
+	if (ModeNo <= 0x13) {
+		modeflag = pVBInfo->SModeIDTable[ModeIdIndex].St_ModeFlag;
+	} else {
+		modeflag = pVBInfo->EModeIDTable[ModeIdIndex].Ext_ModeFlag;
+	}
+	pVBInfo->ModeType = modeflag&ModeInfoFlag;
+	pVBInfo->SetFlag = 0x00;
+	pVBInfo->VBInfo = DisableCRT2Display;
+	temp = XGINew_CheckMemorySize(HwDeviceExtension, ModeNo, ModeIdIndex, pVBInfo);
+
+	if (temp == 0)
+		return (0);
+
+	XGI_DisplayOff(HwDeviceExtension, pVBInfo) ;
+	XGI_SetCRT1Group(HwDeviceExtension, ModeNo, ModeIdIndex, pVBInfo);
+	XGI_DisplayOn(HwDeviceExtension, pVBInfo);
+	*/
+
+	XGI_UpdateModeInfo(HwDeviceExtension, pVBInfo);
+
+	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+		XGI_LockCRT2(HwDeviceExtension, pVBInfo);
+	}
+
+	return 1;
+}
-- 
1.5.6.5

