Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1CHUQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:35 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58628 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1CHUQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:21 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 15/15] staging: xgifb: vb_init: make internal functions static
Date: Tue,  8 Mar 2011 22:16:20 +0200
Message-Id: <1299615380-22922-16-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make some internal functions static.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.h  |    3 --
 drivers/staging/xgifb/vb_init.c |   51 ++++++++++++++++++++-------------------
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
index 6824525..cabe365 100644
--- a/drivers/staging/xgifb/vb_ext.h
+++ b/drivers/staging/xgifb/vb_ext.h
@@ -22,9 +22,6 @@ typedef union   _X86_REGS    {
 } X86_REGS, *PX86_REGS;
 
 extern   void     XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
-extern   void     XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-extern void ReadVBIOSTablData(unsigned char ChipType,
-			      struct vb_device_info *pVBInfo);
 extern unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *,
 				      struct vb_device_info *pVBInfo);
 
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 2cf50dd..4bbcff6 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -37,22 +37,23 @@ static unsigned short XGINew_DDRDRAM_TYPE20[12][5] = {
 	{ 2, 12,  9,  8, 0x35},
 	{ 2, 12,  8,  4, 0x31} };
 
-void     XGINew_SetDRAMSize_340(struct xgi_hw_device_info *, struct vb_device_info *);
-void     XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
-void XGINew_SetDRAMDefaultRegister340(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *, struct vb_device_info *);
+static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
+static void XGINew_SetDRAMDefaultRegister340(struct xgi_hw_device_info *HwDeviceExtension,
 				      unsigned long, struct vb_device_info *);
-unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
+static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 				     struct vb_device_info *pVBInfo);
 
-int      XGINew_DDRSizing340(struct xgi_hw_device_info *, struct vb_device_info *);
+static int XGINew_DDRSizing340(struct xgi_hw_device_info *, struct vb_device_info *);
 static int      XGINew_RAMType;		/*int      ModeIDOffset,StandTable,CRT1Table,ScreenOffset,REFIndex;*/
-void     ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo);
-void     XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo);
-void     XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-void     XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-unsigned char    GetXG21FPBits(struct vb_device_info *pVBInfo);
-void     XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-unsigned char    GetXG27FPBits(struct vb_device_info *pVBInfo);
+static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo);
+static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo);
+static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
+static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
+static unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo);
+static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
+static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo);
+static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
 
 static void DelayUS(unsigned long MicroSeconds)
 {
@@ -419,7 +420,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 /* ============== alan ====================== */
 
-unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
+static unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 					struct vb_device_info *pVBInfo)
 {
 	unsigned char data, temp;
@@ -705,7 +706,7 @@ static void XGINew_DDR2_DefaultRegister(
 		XGINew_DDR2_MRS_XG20(HwDeviceExtension, P3c4, pVBInfo);
 }
 
-void XGINew_SetDRAMDefaultRegister340(
+static void XGINew_SetDRAMDefaultRegister340(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned long Port, struct vb_device_info *pVBInfo)
 {
@@ -834,7 +835,7 @@ void XGINew_SetDRAMDefaultRegister340(
 	XGINew_SetReg1(P3c4, 0x1B, pVBInfo->SR15[3][XGINew_RAMType]); /* SR1B */
 }
 
-void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_SetDRAMSize_340(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short data;
@@ -1246,7 +1247,7 @@ static void XGINew_CheckChannel(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 }
 
-int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
+static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	int i;
@@ -1289,7 +1290,7 @@ int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 	return 0;
 }
 
-void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 
@@ -1314,7 +1315,7 @@ void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 }
 
-void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo)
+static void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo)
 {
 	volatile unsigned char *pVideoMemory = (unsigned char *) pVBInfo->ROMAddr;
 	unsigned long i;
@@ -1404,7 +1405,7 @@ void ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo)
 	}
 }
 
-void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
+static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
 {
 
 	XGINew_SetReg1(P3c4, 0x18, 0x01);
@@ -1434,7 +1435,7 @@ void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo)
 	XGINew_SetReg1(P3c4, 0x1B, 0x00);
 }
 
-void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx = 0, temp, tempcx, CR3CData;
@@ -1482,7 +1483,7 @@ void XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
 	XGINew_SetReg1(pVBInfo->P3d4, 0x3e, ((tempbx & 0xFF00) >> 8));
 }
 
-void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short temp, tempcl = 0, tempch = 0, CR31Data, CR38Data;
@@ -1564,7 +1565,7 @@ void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
 
 }
 
-void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char Temp;
@@ -1598,7 +1599,7 @@ void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 #endif
 }
 
-void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
+static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned char Temp, bCR4A;
@@ -1620,7 +1621,7 @@ void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
 
 }
 
-unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo)
+static unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR38, CR4A, temp;
 
@@ -1639,7 +1640,7 @@ unsigned char GetXG21FPBits(struct vb_device_info *pVBInfo)
 	return temp;
 }
 
-unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
+static unsigned char GetXG27FPBits(struct vb_device_info *pVBInfo)
 {
 	unsigned char CR4A, temp;
 
-- 
1.5.6.5

