Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1DRTYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:24:42 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:48113 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1DRTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:24:08 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 10/12] staging: xgifb: main: delete redudant extern declarations
Date: Mon, 18 Apr 2011 22:14:06 +0300
Message-Id: <1303154048-21989-11-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete redudant declarations and include proper .h files.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |   55 -----------------------------------
 drivers/staging/xgifb/XGI_main_26.c |    2 +
 2 files changed, 2 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 1b20e55..4c480bc 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -648,59 +648,4 @@ static const struct _XGI_TV_filter {
 static int           filter = -1;
 static unsigned char filter_tb;
 
-
-/* ---------------------- Routine prototypes ------------------------- */
-
-/*
-extern int	XGIfb_mode_rate_to_dclock(VB_DEVICE_INFO *XGI_Pr,
-			      struct xgi_hw_device_info *HwDeviceExtension,
-			      unsigned char modeno, unsigned char rateindex);
-extern int      XGIfb_mode_rate_to_ddata(VB_DEVICE_INFO *XGI_Pr, struct xgi_hw_device_info *HwDeviceExtension,
-			 unsigned char modeno, unsigned char rateindex,
-			 unsigned int *left_margin, unsigned int *right_margin,
-			 unsigned int *upper_margin, unsigned int *lower_margin,
-			 unsigned int *hsync_len, unsigned int *vsync_len,
-			 unsigned int *sync, unsigned int *vmode);
-*/
-extern unsigned char XGI_SearchModeID(unsigned short ModeNo,
-				unsigned short *ModeIdIndex,
-				struct vb_device_info *);
-
-/* Internal routines to access PCI configuration space */
-unsigned char XGIfb_query_VGA_config_space(struct xgi_hw_device_info *pXGIhw_ext,
-					   unsigned long offset,
-					   unsigned long set,
-					   unsigned long *value);
-//BOOLEAN         XGIfb_query_north_bridge_space(PXGI_HW_DEVICE_INFO pXGIhw_ext,
-//	         	unsigned long offset, unsigned long set, unsigned long *value);
-
-
-/* Routines from init.c/init301.c */
-extern void     InitTo330Pointer(unsigned char, struct vb_device_info *pVBInfo);
-extern unsigned char  XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension);
-extern unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
-				   unsigned short ModeNo);
-//extern void     XGI_SetEnableDstn(VB_DEVICE_INFO *XGI_Pr);
-extern void     XGI_LongWait(struct vb_device_info *XGI_Pr);
-extern unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
-					 unsigned short ModeNo,
-					 unsigned short ModeIdIndex,
-					 struct vb_device_info *pVBInfo);
-/* TW: Chrontel TV functions */
-extern unsigned short XGI_GetCH700x(struct vb_device_info *XGI_Pr,
-				    unsigned short tempbx);
-extern void XGI_SetCH700x(struct vb_device_info *XGI_Pr, unsigned short tempbx);
-extern unsigned short XGI_GetCH701x(struct vb_device_info *XGI_Pr,
-				    unsigned short tempbx);
-extern void XGI_SetCH701x(struct vb_device_info *XGI_Pr, unsigned short tempbx);
-extern void XGI_SetCH70xxANDOR(struct vb_device_info *XGI_Pr,
-			       unsigned short tempax,
-			       unsigned short tempbh);
-extern void XGI_DDC2Delay(struct vb_device_info *XGI_Pr, unsigned short delaytime);
-
-/* TW: Sensing routines */
-void            XGI_Sense30x(void);
-int             XGIDoSense(int tempbl, int tempbh, int tempcl, int tempch);
-
-extern struct XGI21_LVDSCapStruct XGI21_LCDCapList[13];
 #endif
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 1350681..a6e9c60 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -41,7 +41,9 @@
 #include "XGIfb.h"
 #include "vgatypes.h"
 #include "XGI_main.h"
+#include "vb_init.h"
 #include "vb_util.h"
+#include "vb_setmode.h"
 
 #define Index_CR_GPIO_Reg1 0x48
 #define Index_CR_GPIO_Reg2 0x49
-- 
1.5.6.5

