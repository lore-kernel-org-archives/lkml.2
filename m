Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1CHUT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:19:27 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58628 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab1CHUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:15 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 09/15] staging: xgifb: vb_setmode: include the .h file
Date: Tue,  8 Mar 2011 22:16:14 +0200
Message-Id: <1299615380-22922-10-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the file's .h file and delete the duplicate declarations from
the .c file.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_setmode.c |   43 +-----------------------------------
 1 files changed, 1 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 0f37c80..5423524 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -11,7 +11,7 @@
 #include "vb_struct.h"
 #include "vb_util.h"
 #include "vb_table.h"
-
+#include "vb_setmode.h"
 
 
 #define  IndexMask 0xff
@@ -21,23 +21,10 @@
 
 
 
-unsigned char  XGI_SetCRT2Group301(unsigned short ModeNo,
-			struct xgi_hw_device_info *HwDeviceExtension,
-			struct vb_device_info *pVBInfo);
-
 static unsigned char  XGI_AjustCRT2Rate(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			unsigned short RefreshRateTableIndex,
 			unsigned short *i, struct vb_device_info *pVBInfo);
-unsigned char  XGI_SearchModeID(unsigned short ModeNo,
-			unsigned short *ModeIdIndex,
-			struct vb_device_info *pVBInfo);
-unsigned char  XGI_GetLCDInfo(unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			struct vb_device_info *pVBInfo);
-unsigned char  XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
-			unsigned short ModeNo);
-unsigned char  XGI_BridgeIsOn(struct vb_device_info *pVBInfo);
 static unsigned char  XGI_GetModePtr(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
@@ -46,13 +33,6 @@ static unsigned short XGI_GetOffset(unsigned short ModeNo,
 			unsigned short RefreshRateTableIndex,
 			struct xgi_hw_device_info *HwDeviceExtension,
 			struct vb_device_info *pVBInfo);
-unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
-			unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			struct vb_device_info *pVBInfo);
-unsigned short XGI_GetResInfo(unsigned short ModeNo,
-			unsigned short ModeIdIndex,
-			struct vb_device_info *pVBInfo);
 static unsigned short XGI_GetColorDepth(unsigned short ModeNo,
 			unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
@@ -79,15 +59,12 @@ static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo, unsigned sho
 static void XGI_AutoThreshold(struct vb_device_info *pVBInfo);
 static void XGI_SetTap4Regs(struct vb_device_info *pVBInfo);
 
-void     XGI_DisplayOn(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-void     XGI_DisplayOff(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension, unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetXG21CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
 static void XGI_SetXG27CRTC(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex, unsigned short ModeNo);
 static void XGI_UpdateXG21CRTC(unsigned short ModeNo, struct vb_device_info *pVBInfo, unsigned short RefreshRateTableIndex);
-void     XGI_SenseCRT1(struct vb_device_info *pVBInfo);
 static void XGI_SetSeqRegs(unsigned short ModeNo, unsigned short StandTableIndex, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetMiscRegs(unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension, unsigned short StandTableIndex, struct vb_device_info *pVBInfo);
@@ -112,22 +89,14 @@ static void XGI_SetLCDAGroup(unsigned short ModeNo, unsigned short ModeIdIndex,
 static void XGI_GetLVDSResInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 			struct vb_device_info *pVBInfo);
 static void XGI_GetLVDSData(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-unsigned short XGI_GetLVDSOEMTableIndex(struct vb_device_info *pVBInfo);
 static void XGI_ModCRT1Regs(unsigned short ModeNo, unsigned short ModeIdIndex,
 			unsigned short RefreshRateTableIndex,
 			struct xgi_hw_device_info *HwDeviceExtension,
 			struct vb_device_info *pVBInfo);
 static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
 static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_GetVGAType(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_GetVBType(struct vb_device_info *pVBInfo);
-void     XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetCRT2ECLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     InitTo330Pointer(unsigned char, struct vb_device_info *pVBInfo);
 static void XGI_GetLCDSync(unsigned short *HSyncWidth, unsigned short *VSyncWidth, struct vb_device_info *pVBInfo);
-void     XGI_DisableBridge(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-void     XGI_EnableBridge(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 static void XGI_SetCRT2VCLK(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
 static void XGI_OEM310Setting(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetDelayComp(struct vb_device_info *pVBInfo);
@@ -141,13 +110,9 @@ static void XGI_SetPhaseIncr(struct vb_device_info *pVBInfo);
 static void XGI_SetYFilter(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static void XGI_GetTVPtrIndex2(unsigned short *tempbx, unsigned char* tempcl,
 			unsigned char *tempch, struct vb_device_info *pVBInfo);
-void     XGI_SetCRT2ModeRegs(unsigned short ModeNo, struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 static void XGI_CloseCRTC(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 static void XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct vb_device_info *pVBInfo);
-void     XGI_UnLockCRT2(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
-void     XGI_LockCRT2(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 static void XGINew_EnableCRT2(struct vb_device_info *pVBInfo);
-void     XGI_LongWait(struct vb_device_info *pVBInfo);
 static void XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 static void XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
 			struct vb_device_info *pVBInfo);
@@ -160,14 +125,8 @@ static void XGI_GetVCLKLen(unsigned char tempal, unsigned char *di_0,
 static unsigned short XGI_GetLCDCapPtr(struct vb_device_info *pVBInfo);
 static unsigned short XGI_GetLCDCapPtr1(struct vb_device_info *pVBInfo);
 static struct XGI301C_Tap4TimingStruct *XGI_GetTap4Ptr(unsigned short tempcx, struct vb_device_info *pVBInfo);
-void     XGI_SetXG21FPBits(struct vb_device_info *pVBInfo);
-void     XGI_SetXG27FPBits(struct vb_device_info *pVBInfo);
 static unsigned char XGI_XG21GetPSCValue(struct vb_device_info *pVBInfo);
 static unsigned char XGI_XG27GetPSCValue(struct vb_device_info *pVBInfo);
-void     XGI_XG21BLSignalVDD(unsigned short tempbh, unsigned short tempbl, struct vb_device_info *pVBInfo);
-void     XGI_XG27BLSignalVDD(unsigned short tempbh, unsigned short tempbl, struct vb_device_info *pVBInfo);
-void     XGI_XG21SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo);
-unsigned char  XGI_XG21CheckLVDSMode(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdIndex, struct vb_device_info *pVBInfo);
 static unsigned char XGI_SetDefaultVCLK(struct vb_device_info *pVBInfo);
-- 
1.5.6.5

