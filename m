Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1CHUQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:33 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:42467 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab1CHUQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 08/15] staging: xgifb: vb_setmode: make internal functions static
Date: Tue,  8 Mar 2011 22:16:13 +0200
Message-Id: <1299615380-22922-9-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make internal functions static and remove unneeded forward declarations.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_setmode.c |  372 +++++++++++++++++-------------------
 drivers/staging/xgifb/vb_setmode.h |    4 -
 2 files changed, 176 insertions(+), 200 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index fa2cf96..0f37c80 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -21,16 +21,11 @@
 
 
 
-unsigned char  XGI_IsLCDDualLink(struct vb_device_info *pVBInfo);
 unsigned char  XGI_SetCRT2Group301(unsigned short ModeNo,
 			struct xgi_hw_device_info *HwDeviceExtension,
 			struct vb_device_info *pVBInfo);
-unsigned char  XGI_BacklightByDrv(struct vb_device_info *pVBInfo);
 
-unsigned char  XGI_IsLCDON(struct vb_device_info *pVBInfo);
-unsigned char  XGI_DisableChISLCD(struct vb_device_info *pVBInfo);
-unsigned char  XGI_EnableChISLCD(struct vb_device_info *pVBInfo);
-unsigned char  XGI_AjustCRT2Rate(unsigned short ModeNo,
+static unsigned char  XGI_AjustCRT2Rate(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			unsigned short RefreshRateTableIndex,
 			unsigned short *i, struct vb_device_info *pVBInfo);
@@ -43,10 +38,10 @@ unsigned char  XGI_GetLCDInfo(unsigned short ModeNo,
 unsigned char  XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 			unsigned short ModeNo);
 unsigned char  XGI_BridgeIsOn(struct vb_device_info *pVBInfo);
-unsigned char  XGI_GetModePtr(unsigned short ModeNo,
+static unsigned char  XGI_GetModePtr(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
-unsigned short XGI_GetOffset(unsigned short ModeNo,
+static unsigned short XGI_GetOffset(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			unsigned short RefreshRateTableIndex,
 			struct xgi_hw_device_info *HwDeviceExtension,
@@ -58,139 +53,124 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 unsigned short XGI_GetResInfo(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
-unsigned short XGI_GetColorDepth(unsigned short ModeNo,
+static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
-unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo);
-unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
+static unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo);
+static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			unsigned short RefreshRateTableIndex,
 			struct xgi_hw_device_info *HwDeviceExtension,
 			struct vb_device_info *pVBInfo);
-void     XGI_VBLongWait(struct vb_device_info *pVBInfo);
-void     XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo);
-void     XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     *XGI_GetLcdPtr(unsigned short BX,  unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_FirePWDEnable(struct vb_device_info *pVBInfo);
-void     XGI_EnableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_DisableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo);
-void     XGI_SetPanelPower(unsigned short tempah, unsigned short tempbl, struct vb_device_info *pVBInfo);
-void     XGI_EnablePWD(struct vb_device_info *pVBInfo);
-void     XGI_DisablePWD(struct vb_device_info *pVBInfo);
-void     XGI_AutoThreshold(struct vb_device_info *pVBInfo);
-void     XGI_SetTap4Regs(struct vb_device_info *pVBInfo);
+static void XGI_VBLongWait(struct vb_device_info *pVBInfo);
+static void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo);
+static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
+static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
+static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void *XGI_GetLcdPtr(unsigned short BX,  unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_AutoThreshold(struct vb_device_info *pVBInfo);
+static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo);
 
 void     XGI_DisplayOn(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 void     XGI_DisplayOff(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetXG21LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
-void     XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetXG27LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
-void	 XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex);
-void     XGI_WaitDisply(struct vb_device_info *pVBInfo);
+static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
+static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
+static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex);
 void     XGI_SenseCRT1(struct vb_device_info *pVBInfo);
-void     XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetMiscRegs(unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension, unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetGRCRegs(unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_ClearExt1Regs(struct vb_device_info *pVBInfo);
-
-void     XGI_SetSync(unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo, struct xgi_hw_device_info *HwDeviceExtension);
-void     XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo, struct xgi_hw_device_info *HwDeviceExtension);
-void     XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeNo, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT1FIFO(unsigned short ModeNo, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-
-void     XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al, unsigned short dh, struct vb_device_info *pVBInfo);
+static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetMiscRegs(unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension, unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetGRCRegs(unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_ClearExt1Regs(struct vb_device_info *pVBInfo);
+
+static void XGI_SetSync(unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo, struct xgi_hw_device_info *HwDeviceExtension);
+static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo, struct xgi_hw_device_info *HwDeviceExtension);
+static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeNo, struct vb_device_info *pVBInfo);
+static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetCRT1FIFO(unsigned short ModeNo, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
+static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+
+static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al, unsigned short dh, struct vb_device_info *pVBInfo);
 /*void     XGI_ClearBuffer(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, struct vb_device_info *pVBInfo);*/
-void     XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
+static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
-void     XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
 unsigned short XGI_GetLVDSOEMTableIndex(struct vb_device_info *pVBInfo);
-void     XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			unsigned short RefreshRateTableIndex,
 			struct xgi_hw_device_info *HwDeviceExtension,
 			struct vb_device_info *pVBInfo);
-void     XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
+static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 void     XGI_GetVGAType(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 void     XGI_GetVBType(struct vb_device_info *pVBInfo);
 void     XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 void     XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
 void     InitTo330Pointer(unsigned char, struct vb_device_info *pVBInfo);
-void     XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth, struct vb_device_info *pVBInfo);
+static void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth, struct vb_device_info *pVBInfo);
 void     XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 void     XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetDelayComp(struct vb_device_info *pVBInfo);
-void     XGI_SetLCDCap(struct vb_device_info *pVBInfo);
-void     XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo);
-void     XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo);
-void     SetSpectrum(struct vb_device_info *pVBInfo);
-void     XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetPhaseIncr(struct vb_device_info *pVBInfo);
-void     XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char* tempcl,
+static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetDelayComp(struct vb_device_info *pVBInfo);
+static void XGI_SetLCDCap(struct vb_device_info *pVBInfo);
+static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo);
+static void XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo);
+static void SetSpectrum(struct vb_device_info *pVBInfo);
+static void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo);
+static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char* tempcl,
 			unsigned char *tempch, struct vb_device_info *pVBInfo);
-unsigned short   XGI_GetTVPtrIndex(struct vb_device_info *pVBInfo);
 void     XGI_SetCRT2ModeRegs(unsigned short ModeNo, struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-void     XGI_CloseCRTC(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-void     XGI_OpenCRTC(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-void     XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
+static void XGI_CloseCRTC(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
+static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
 void     XGI_UnLockCRT2(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 void     XGI_LockCRT2(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-void     XGINew_EnableCRT2(struct vb_device_info *pVBInfo);
+static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo);
 void     XGI_LongWait(struct vb_device_info *pVBInfo);
-void     XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
+static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
+static void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
 			struct vb_device_info *pVBInfo);
-unsigned char    XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
+static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 			unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
-void     XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
+static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
 			unsigned char *di_1, struct vb_device_info *pVBInfo);
-unsigned short   XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo);
-unsigned short   XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo);
-struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx, struct vb_device_info *pVBInfo);
+static unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo);
+static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo);
+static struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx, struct vb_device_info *pVBInfo);
 void     XGI_SetXG21FPBits(struct vb_device_info *pVBInfo);
 void     XGI_SetXG27FPBits(struct vb_device_info *pVBInfo);
-unsigned char    XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo);
-unsigned char    XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo);
+static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo);
+static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo);
 void     XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl, struct vb_device_info *pVBInfo);
 void     XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl, struct vb_device_info *pVBInfo);
 void     XGI_XG21SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo);
 unsigned char  XGI_XG21CheckLVDSMode(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-void     XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-unsigned char  XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo);
-
-extern void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo);
-
-/* unsigned short XGINew_flag_clearbuffer; 0: no clear frame buffer 1:clear frame buffer */
-
+static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
+static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo);
 
 static unsigned short XGINew_MDA_DAC[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -566,7 +546,7 @@ unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 	return 1;
 }
 
-void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -680,7 +660,7 @@ void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 	/* XGI_ClearBuffer(HwDeviceExtension, ModeNo, pVBInfo); */
 }
 
-unsigned char XGI_GetModePtr(unsigned short ModeNo, unsigned short ModeIdIndex,
+static unsigned char XGI_GetModePtr(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char index;
@@ -707,7 +687,7 @@ unsigned char XGI_SetBIOSData(unsigned short ModeNo, unsigned short ModeIdIndex)
 }
 */
 
-void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex,
+static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex,
 		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
 {
 	unsigned char tempah, SRdata;
@@ -741,7 +721,7 @@ void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex,
 	}
 }
 
-void XGI_SetMiscRegs(unsigned short StandTableIndex,
+static void XGI_SetMiscRegs(unsigned short StandTableIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char Miscdata;
@@ -758,7 +738,7 @@ void XGI_SetMiscRegs(unsigned short StandTableIndex,
 	XGINew_SetReg3(pVBInfo->P3c2, Miscdata); /* Set Misc(3c2) */
 }
 
-void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short StandTableIndex, struct vb_device_info *pVBInfo)
 {
 	unsigned char CRTCdata;
@@ -783,7 +763,7 @@ void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
 	*/
 }
 
-void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex,
+static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex,
 		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
 {
 	unsigned char ARdata;
@@ -823,7 +803,7 @@ void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex,
 	XGINew_SetReg3(pVBInfo->P3c0, 0x20);
 }
 
-void XGI_SetGRCRegs(unsigned short StandTableIndex,
+static void XGI_SetGRCRegs(unsigned short StandTableIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char GRdata;
@@ -841,7 +821,7 @@ void XGI_SetGRCRegs(unsigned short StandTableIndex,
 	}
 }
 
-void XGI_ClearExt1Regs(struct vb_device_info *pVBInfo)
+static void XGI_ClearExt1Regs(struct vb_device_info *pVBInfo)
 {
 	unsigned short i;
 
@@ -849,7 +829,7 @@ void XGI_ClearExt1Regs(struct vb_device_info *pVBInfo)
 		XGINew_SetReg1(pVBInfo->P3c4, i, 0x00); /* Clear SR0A-SR0E */
 }
 
-unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo)
+static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo)
 {
 
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x31, ~0x30, 0x20);
@@ -983,7 +963,7 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 	return RefreshRateTableIndex + i; /* return (0x01 | (temp1<<1)); */
 }
 
-unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
+static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex, unsigned short *i,
 		struct vb_device_info *pVBInfo)
@@ -1125,7 +1105,7 @@ unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 	return 1;
 }
 
-void XGI_SetSync(unsigned short RefreshRateTableIndex,
+static void XGI_SetSync(unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short sync, temp;
@@ -1137,7 +1117,7 @@ void XGI_SetSync(unsigned short RefreshRateTableIndex,
 	XGINew_SetReg3(pVBInfo->P3c2, temp); /* Set Misc(3c2) */
 }
 
-void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo,
 		struct xgi_hw_device_info *HwDeviceExtension)
@@ -1168,7 +1148,7 @@ void XGI_SetCRT1CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		XGINew_SetReg1(pVBInfo->P3d4, 0x14, 0x4F);
 }
 
-void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
+static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 		struct xgi_hw_device_info *HwDeviceExtension)
 {
 	unsigned char data, data1, pushax;
@@ -1231,7 +1211,7 @@ void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
 	}
 }
 
-void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeNo,
+static void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeNo,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char data;
@@ -1288,7 +1268,7 @@ void XGI_SetCRT1Timing_V(unsigned short ModeIdIndex, unsigned short ModeNo,
 /* Output : Fill CRT Hsync/Vsync to SR2E/SR2F/SR30/SR33/SR34/SR3F */
 /* Description : Set LCD timing */
 /* --------------------------------------------------------------------- */
-void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -1426,7 +1406,7 @@ void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -1545,7 +1525,7 @@ void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex,
 /* Output : FCLK duty cycle, FCLK delay compensation */
 /* Description : All values set zero */
 /* --------------------------------------------------------------------- */
-void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
+static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 		unsigned short RefreshRateTableIndex, unsigned short ModeNo)
 {
 	unsigned short Data, Temp, b3CC;
@@ -1591,7 +1571,7 @@ void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 	}
 }
 
-void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
+static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 		unsigned short RefreshRateTableIndex, unsigned short ModeNo)
 {
 	unsigned short Data, Temp, b3CC;
@@ -1645,7 +1625,7 @@ void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 /* Output : CRT1 CRTC */
 /* Description : Modify CRT1 Hsync/Vsync to fix LCD mode timing */
 /* --------------------------------------------------------------------- */
-void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo,
+static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo,
 		unsigned short RefreshRateTableIndex)
 {
 	int i, index = -1;
@@ -1685,7 +1665,7 @@ void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo,
 	}
 }
 
-void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -1772,7 +1752,7 @@ unsigned short XGI_GetResInfo(unsigned short ModeNo,
 	return resindex;
 }
 
-void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
@@ -1855,7 +1835,7 @@ void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGINew_SetReg1(pVBInfo->P3c4, 0x10, ah);
 }
 
-void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -1912,7 +1892,7 @@ void XGI_SetCRT1VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_SetCRT1FIFO(unsigned short ModeNo,
+static void XGI_SetCRT1FIFO(unsigned short ModeNo,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -1948,7 +1928,7 @@ void XGI_SetCRT1FIFO(unsigned short ModeNo,
 		XGI_SetXG21FPBits(pVBInfo); /* Fix SR9[7:6] can't read back */
 }
 
-void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -2063,7 +2043,7 @@ void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 
 }
 
-void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_SetVCLKState(struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short ModeNo, unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -2149,7 +2129,7 @@ void XGI_VesaLowResolution(unsigned short ModeNo, unsigned short ModeIdIndex, st
 }
 */
 
-void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short data, data2, time, i, j, k, m, n, o, si, di, bx, dl, al,
@@ -2241,7 +2221,7 @@ void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al,
+static void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al,
 		unsigned short dh, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp, bh, bl;
@@ -2268,7 +2248,7 @@ void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al,
 	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) bl);
 }
 
-void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
@@ -2288,7 +2268,7 @@ void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGI_SetCRT2ECLK(ModeNo, ModeIdIndex, RefreshRateTableIndex, pVBInfo);
 }
 
-void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short resindex, xres, yres, modeflag;
@@ -2337,7 +2317,7 @@ void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	pVBInfo->VDE = yres;
 }
 
-void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -2392,7 +2372,7 @@ void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
@@ -2507,7 +2487,7 @@ void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -2802,7 +2782,7 @@ void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -2831,7 +2811,7 @@ void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempcl, tempch, temp, tempbl, tempax;
@@ -3702,7 +3682,7 @@ void XGI_DisplayOff(struct xgi_hw_device_info *pXGIHWDE,
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x01, 0xDF, 0x20);
 }
 
-void XGI_WaitDisply(struct vb_device_info *pVBInfo)
+static void XGI_WaitDisply(struct vb_device_info *pVBInfo)
 {
 	while ((XGINew_GetReg2(pVBInfo->P3da) & 0x01))
 		break;
@@ -3860,13 +3840,13 @@ unsigned char XGI_SetCRT2Group301(unsigned short ModeNo,
 	return 1;
 }
 
-void XGI_AutoThreshold(struct vb_device_info *pVBInfo)
+static void XGI_AutoThreshold(struct vb_device_info *pVBInfo)
 {
 	if (!(pVBInfo->SetFlag & Win9xDOSMode))
 		XGINew_SetRegOR(pVBInfo->Part1Port, 0x01, 0x40);
 }
 
-void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo)
+static void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp1, temp2;
 
@@ -3876,7 +3856,7 @@ void XGI_SaveCRT2Info(unsigned short ModeNo, struct vb_device_info *pVBInfo)
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x31, temp2, temp1);
 }
 
-void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short xres, yres, modeflag, resindex;
@@ -3951,7 +3931,7 @@ void XGI_GetCRT2ResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 	pVBInfo->VDE = yres;
 }
 
-unsigned char XGI_IsLCDDualLink(struct vb_device_info *pVBInfo)
+static unsigned char XGI_IsLCDDualLink(struct vb_device_info *pVBInfo)
 {
 
 	if ((pVBInfo->VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA)) &&
@@ -3961,7 +3941,7 @@ unsigned char XGI_IsLCDDualLink(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
-void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -4147,7 +4127,7 @@ void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -4182,7 +4162,7 @@ void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex,
 /* Output : al -> VCLK Index */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
+static void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short index;
@@ -4207,7 +4187,7 @@ void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
 	return;
 }
 
-unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
+static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 		unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -4364,7 +4344,7 @@ unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 	return tempal;
 }
 
-void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
+static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
 		unsigned char *di_1, struct vb_device_info *pVBInfo)
 {
 	if (pVBInfo->IF_DEF_CH7007 == 1) { /* [Billy] 2007/05/16 */
@@ -4406,7 +4386,7 @@ static void XGI_SetCRT2Offset(unsigned short ModeNo,
 	XGINew_SetReg1(pVBInfo->Part1Port, 0x03, temp);
 }
 
-unsigned short XGI_GetOffset(unsigned short ModeNo, unsigned short ModeIdIndex,
+static unsigned short XGI_GetOffset(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
@@ -4447,7 +4427,7 @@ static void XGI_SetCRT2FIFO(struct vb_device_info *pVBInfo)
 	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x02, ~(0x3F), 0x04); /* threshold low default 04h */
 }
 
-void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -4472,7 +4452,7 @@ void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGINew_SetReg1(pVBInfo->Part1Port, 0x02, 0x44); /* temp 0206 */
 }
 
-void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -4625,7 +4605,7 @@ void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x2C, ~0x0C0, tempax);
 }
 
-void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -5004,7 +4984,7 @@ void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	return;
 }
 
-void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
@@ -5451,7 +5431,7 @@ void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		return;
 }
 
-void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -5676,7 +5656,7 @@ void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 /* Output : di -> Tap4 Reg. Setting Pointer */
 /* Description : */
 /* --------------------------------------------------------------------- */
-struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx,
+static struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempax, tempbx, i;
@@ -5722,7 +5702,7 @@ struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx,
 	return &Tap4TimingPtr[i];
 }
 
-void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
+static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 {
 	unsigned short i, j;
 
@@ -5752,7 +5732,7 @@ void XGI_SetTap4Regs(struct vb_device_info *pVBInfo)
 #endif
 }
 
-void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short i;
@@ -5811,7 +5791,7 @@ void XGI_SetGroup3(unsigned short ModeNo, unsigned short ModeIdIndex,
 	return;
 } /* {end of XGI_SetGroup3} */
 
-void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
@@ -6014,7 +5994,7 @@ void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 				pVBInfo);
 }
 
-void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short Pindex, Pdata;
@@ -6031,7 +6011,7 @@ void XGI_SetGroup5(unsigned short ModeNo, unsigned short ModeIdIndex,
 	return;
 }
 
-void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
+static void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 		unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -6502,7 +6482,7 @@ void *XGI_GetLcdPtr(unsigned short BX, unsigned short ModeNo,
 	return NULL;
 }
 
-void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,
+static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,
 		unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
@@ -6651,7 +6631,7 @@ void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,
 /* Output : 1 -> Skip backlight control */
 /* Description : */
 /* --------------------------------------------------------------------- */
-unsigned char XGI_BacklightByDrv(struct vb_device_info *pVBInfo)
+static unsigned char XGI_BacklightByDrv(struct vb_device_info *pVBInfo)
 {
 	unsigned char tempah;
 
@@ -6681,18 +6661,18 @@ void XGI_FirePWDDisable(struct vb_device_info *pVBInfo)
 /* Output : */
 /* Description : Turn on VDD & Backlight : Fire enable procedure */
 /* --------------------------------------------------------------------- */
-void XGI_FirePWDEnable(struct vb_device_info *pVBInfo)
+static void XGI_FirePWDEnable(struct vb_device_info *pVBInfo)
 {
 	XGINew_SetRegANDOR(pVBInfo->Part1Port, 0x26, 0x03, 0xFC);
 }
 
-void XGI_EnableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_EnableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	XGINew_SetRegANDOR(pVBInfo->P3d4, 0x63, 0xBF, 0x40);
 }
 
-void XGI_DisableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_DisableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 
@@ -6709,7 +6689,7 @@ void XGI_DisableGatingCRT(struct xgi_hw_device_info *HwDeviceExtension,
 /* : bl : 3 ; T3 : the duration between CPL off and signal off */
 /* : bl : 4 ; T4 : the duration signal off and Vdd off */
 /* --------------------------------------------------------------------- */
-void XGI_SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo)
+static void XGI_SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo)
 {
 	unsigned short index;
 
@@ -6738,7 +6718,7 @@ void XGI_SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo)
 /* = 1011b = 0Bh ; Backlight off, Power on */
 /* = 1111b = 0Fh ; Backlight off, Power off */
 /* --------------------------------------------------------------------- */
-void XGI_SetPanelPower(unsigned short tempah, unsigned short tempbl,
+static void XGI_SetPanelPower(unsigned short tempah, unsigned short tempbl,
 		struct vb_device_info *pVBInfo)
 {
 	if (pVBInfo->VBType & (VB_XGI301LV | VB_XGI302LV | VB_XGI301C))
@@ -6767,7 +6747,7 @@ static unsigned char XG21GPIODataTransfer(unsigned char ujDate)
 /*      bl[1] : LVDS backlight                                                */
 /*      bl[0] : LVDS VDD                                                      */
 /*----------------------------------------------------------------------------*/
-unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
+static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR4A, temp;
 
@@ -6788,7 +6768,7 @@ unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo)
 /*      bl[1] : LVDS backlight                                                */
 /*      bl[0] : LVDS VDD                                                      */
 /*----------------------------------------------------------------------------*/
-unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo)
+static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR4A, CRB4, temp;
 
@@ -6984,7 +6964,7 @@ void XGI_SetXG27FPBits(struct vb_device_info *pVBInfo)
 
 }
 
-void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char temp, Miscdata;
@@ -7170,7 +7150,7 @@ void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
 }
 
 /* no shadow case */
-void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char temp, Miscdata;
@@ -7360,7 +7340,7 @@ void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex,
 /* 1: Disable PSC */
 /* Description : */
 /* --------------------------------------------------------------------- */
-unsigned char XGI_IsLCDON(struct vb_device_info *pVBInfo)
+static unsigned char XGI_IsLCDON(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempax;
 
@@ -7373,7 +7353,7 @@ unsigned char XGI_IsLCDON(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
-void XGI_EnablePWD(struct vb_device_info *pVBInfo)
+static void XGI_EnablePWD(struct vb_device_info *pVBInfo)
 {
 	unsigned short index, temp;
 
@@ -7391,7 +7371,7 @@ void XGI_EnablePWD(struct vb_device_info *pVBInfo)
 	XGINew_SetRegOR(pVBInfo->Part4Port, 0x27, 0x80); /* enable PWD */
 }
 
-void XGI_DisablePWD(struct vb_device_info *pVBInfo)
+static void XGI_DisablePWD(struct vb_device_info *pVBInfo)
 {
 	XGINew_SetRegAND(pVBInfo->Part4Port, 0x27, 0x7F); /* disable PWD */
 }
@@ -7402,7 +7382,7 @@ void XGI_DisablePWD(struct vb_device_info *pVBInfo)
 /* Output : 0 -> Not LCD Mode */
 /* Description : */
 /* --------------------------------------------------------------------- */
-unsigned char XGI_DisableChISLCD(struct vb_device_info *pVBInfo)
+static unsigned char XGI_DisableChISLCD(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, tempah;
 
@@ -7429,7 +7409,7 @@ unsigned char XGI_DisableChISLCD(struct vb_device_info *pVBInfo)
 /* Output : 0 -> Not LCD mode */
 /* Description : */
 /* --------------------------------------------------------------------- */
-unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo)
+static unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, tempah;
 
@@ -7450,7 +7430,7 @@ unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo)
 	return 0;
 }
 
-unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo)
+static unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo)
 {
 	unsigned char tempal, tempah, tempbl, i;
 
@@ -7477,7 +7457,7 @@ unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo)
 	return i;
 }
 
-unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo)
+static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempah, tempal, tempbl, i;
 
@@ -7509,7 +7489,7 @@ unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo)
 	return i;
 }
 
-void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth,
+static void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short Index;
@@ -7876,7 +7856,7 @@ void XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension,
 /* A : Ext750p */
 /* B : St750p */
 /* --------------------------------------------------------------------- */
-unsigned short XGI_GetTVPtrIndex(struct vb_device_info *pVBInfo)
+static unsigned short XGI_GetTVPtrIndex(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx = 0;
 
@@ -7902,7 +7882,7 @@ unsigned short XGI_GetTVPtrIndex(struct vb_device_info *pVBInfo)
 /* Output : */
 /* Description : Customized Param. for 301 */
 /* --------------------------------------------------------------------- */
-void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	if (pVBInfo->SetFlag & Win9xDOSMode)
@@ -7925,7 +7905,7 @@ void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 }
 
-void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
+static void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 {
 	unsigned short index;
 
@@ -7993,7 +7973,7 @@ void XGI_SetDelayComp(struct vb_device_info *pVBInfo)
 	}
 }
 
-void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
+static void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempcx;
 
@@ -8030,7 +8010,7 @@ void XGI_SetLCDCap(struct vb_device_info *pVBInfo)
 	}
 }
 
-void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo)
+static void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp;
 
@@ -8063,7 +8043,7 @@ void XGI_SetLCDCap_A(unsigned short tempcx, struct vb_device_info *pVBInfo)
 /* Output : */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo)
+static void XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo)
 {
 	if (tempcx & EnableLCD24bpp) /* 24bits */
 		XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x1A, 0xE0,
@@ -8075,7 +8055,7 @@ void XGI_SetLCDCap_B(unsigned short tempcx, struct vb_device_info *pVBInfo)
 						| 0x18)); /* Enable Dither */
 }
 
-void SetSpectrum(struct vb_device_info *pVBInfo)
+static void SetSpectrum(struct vb_device_info *pVBInfo)
 {
 	unsigned short index;
 
@@ -8104,7 +8084,7 @@ void SetSpectrum(struct vb_device_info *pVBInfo)
 /* Output : */
 /* Description : Set TV Customized Param. */
 /* --------------------------------------------------------------------- */
-void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, index;
@@ -8129,7 +8109,7 @@ void XGI_SetAntiFlicker(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x0A, 0x8F, tempah);
 }
 
-void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, index;
@@ -8151,7 +8131,7 @@ void XGI_SetEdgeEnhance(unsigned short ModeNo, unsigned short ModeIdIndex,
 	XGINew_SetRegANDOR(pVBInfo->Part2Port, 0x3A, 0x1F, tempah);
 }
 
-void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo)
+static void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx;
 
@@ -8172,7 +8152,7 @@ void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo)
 			& 0xFF000000) >> 24));
 }
 
-void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, index;
@@ -8269,7 +8249,7 @@ void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex,
 /* 1 : 301B/302B/301LV/302LV */
 /* Description : */
 /* --------------------------------------------------------------------- */
-void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
+static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char *tempcl,
 		unsigned char *tempch, struct vb_device_info *pVBInfo)
 {
 	*tempbx = 0;
@@ -8516,7 +8496,7 @@ void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	}
 }
 
-void XGI_CloseCRTC(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGI_CloseCRTC(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx;
@@ -8535,7 +8515,7 @@ void XGI_OpenCRTC(struct xgi_hw_device_info *HwDeviceExtension,
 	tempbx = 0;
 }
 
-void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex,
+static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
@@ -8592,7 +8572,7 @@ void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex,
 	pVBInfo->VT = tempbx;
 }
 
-unsigned short XGI_GetColorDepth(unsigned short ModeNo,
+static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
 		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
 {
 	unsigned short ColorDepth[6] = { 1, 2, 4, 4, 6, 8 };
@@ -8628,7 +8608,7 @@ void XGI_LockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
 
 }
 
-void XGINew_EnableCRT2(struct vb_device_info *pVBInfo)
+static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo)
 {
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1E, 0xFF, 0x20);
 }
@@ -8667,7 +8647,7 @@ void XGI_LongWait(struct vb_device_info *pVBInfo)
 	}
 }
 
-void XGI_VBLongWait(struct vb_device_info *pVBInfo)
+static void XGI_VBLongWait(struct vb_device_info *pVBInfo)
 {
 	unsigned short tempal, temp, i, j;
 	return;
@@ -8699,7 +8679,7 @@ void XGI_VBLongWait(struct vb_device_info *pVBInfo)
 	return;
 }
 
-unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo)
+static unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo)
 {
 	unsigned long tempax, tempbx;
 
@@ -8711,7 +8691,7 @@ unsigned short XGI_GetVGAHT2(struct vb_device_info *pVBInfo)
 	return (unsigned short) tempax;
 }
 
-unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
+static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 		unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct xgi_hw_device_info *HwDeviceExtension,
diff --git a/drivers/staging/xgifb/vb_setmode.h b/drivers/staging/xgifb/vb_setmode.h
index 0dcc297..7a2e564 100644
--- a/drivers/staging/xgifb/vb_setmode.h
+++ b/drivers/staging/xgifb/vb_setmode.h
@@ -17,9 +17,6 @@ extern   void     XGI_SenseCRT1(struct vb_device_info *);
 extern   void     XGI_GetVGAType(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
 extern   void     XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
 extern   void     XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *);
-extern   void     XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-extern   void     XGI_WaitDisply(struct vb_device_info *);
 extern   unsigned short   XGI_GetResInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 
 extern   unsigned char  XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo) ;
@@ -36,7 +33,6 @@ extern   void     XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short temp
 extern   void     XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl, struct vb_device_info *pVBInfo);
 extern   void     XGI_XG21SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo);
 extern   unsigned char  XGI_XG21CheckLVDSMode(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
-extern   void     XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 extern   unsigned short XGI_GetLVDSOEMTableIndex(struct vb_device_info *pVBInfo);
 
 #endif
-- 
1.5.6.5

