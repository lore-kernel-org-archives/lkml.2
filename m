Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2FMWWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:22:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44482 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754946Ab2FMWWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/yMOZK+kryFOIchU77O83kD1laISj9gIeVqRmxqW
	FiUte5ws19oCV6
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] staging/xgifb: Remove useless function XGI_CloseCRTC
Date: Thu, 14 Jun 2012 00:21:49 +0200
Message-Id: <1339626112-20671-11-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since XGI_CloseCRTC does not perform anything useful we can simply
remove it.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 3b9a0f7..2ffab45 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -6229,17 +6229,6 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	}
 }
 
-static void XGI_CloseCRTC(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short tempbx;
-
-	tempbx = 0;
-
-	if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)
-		tempbx = 0x08A0;
-
-}
 
 void XGI_UnLockCRT2(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
@@ -6831,7 +6820,6 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 
 		XGI_SetCRT2ModeRegs(ModeNo, HwDeviceExtension, pVBInfo);
 		XGI_OEM310Setting(ModeNo, ModeIdIndex, pVBInfo); /*0212*/
-		XGI_CloseCRTC(HwDeviceExtension, pVBInfo);
 		XGI_EnableBridge(xgifb_info, HwDeviceExtension, pVBInfo);
 	} /* !XG20 */
 	else {
-- 
1.7.3.4

