Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1CMK0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:26:49 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:39036 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab1CMK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:19 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 04/24] staging: xgifb: delete unsupported chip types
Date: Sun, 13 Mar 2011 12:26:08 +0200
Message-Id: <1300011988-2109-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe routine will fail if the chip is other than XG40..XG27, so
the other types can be dropped.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   31 +++++--------------------------
 drivers/staging/xgifb/XGIfb.h       |   18 ------------------
 2 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ee80171..b2cb7a3 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -182,8 +182,6 @@ static int XGIfb_mode_rate_to_dclock(struct vb_device_info *XGI_Pr,
 
 	*/
 	ClockIndex = XGI_Pr->RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
-	if (HwDeviceExtension->jChipType < XGI_315H)
-		ClockIndex &= 0x3F;
 
 	Clock = XGI_Pr->VCLKData[ClockIndex].CLOCK * 1000;
 
@@ -859,12 +857,6 @@ static int XGIfb_validate_mode(int myindex)
 				if (XGIbios_mode[myindex].bpp == 32)
 					return -1;
 			}
-			/* TW: LVDS/CHRONTEL only supports < 800 (1024 on 650/Ch7019) */
-			if (xgi_video_info.hasVB == HASVB_LVDS_CHRONTEL
-					|| xgi_video_info.hasVB	== HASVB_CHRONTEL) {
-				if (xgi_video_info.chip < XGI_315H)
-					return -1;
-			}
 			break;
 		default:
 			return -1;
@@ -1684,24 +1676,11 @@ static void XGIfb_detect_VB(void)
 		xgi_video_info.TV_plug = TVPLUG_SCART;
 
 	if (xgi_video_info.TV_type == 0) {
-		/* TW: PAL/NTSC changed for 650 */
-		if ((xgi_video_info.chip <= XGI_315PRO) || (xgi_video_info.chip
-				>= XGI_330)) {
-
-			inXGIIDXREG(XGICR, 0x38, temp);
-			if (temp & 0x10)
-				xgi_video_info.TV_type = TVMODE_PAL;
-			else
-				xgi_video_info.TV_type = TVMODE_NTSC;
-
-		} else {
-
-			inXGIIDXREG(XGICR, 0x79, temp);
-			if (temp & 0x20)
-				xgi_video_info.TV_type = TVMODE_PAL;
-			else
-				xgi_video_info.TV_type = TVMODE_NTSC;
-		}
+		inXGIIDXREG(XGICR, 0x38, temp);
+		if (temp & 0x10)
+			xgi_video_info.TV_type = TVMODE_PAL;
+		else
+			xgi_video_info.TV_type = TVMODE_NTSC;
 	}
 
 	/* TW: Copy forceCRT1 option to CRT1off if option is given */
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index 7813bbe..b43a758 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -27,23 +27,6 @@
 #endif
 
 enum XGI_CHIP_TYPE {
-    XGI_VGALegacy = 0,
-    XGI_300,
-    XGI_630,
-    XGI_730,
-    XGI_540,
-    XGI_315H,
-    XGI_315,
-    XGI_315PRO,
-    XGI_550,
-    XGI_640,
-    XGI_740,
-    XGI_650,
-    XGI_650M,
-    XGI_330 = 16,
-    XGI_660,
-    XGI_661,
-    XGI_760,
     XG40 = 32,
     XG41,
     XG42,
@@ -51,7 +34,6 @@ enum XGI_CHIP_TYPE {
     XG20 = 48,
     XG21,
     XG27,
-    MAX_XGI_CHIP
 };
 
 enum xgi_tvtype {
-- 
1.5.6.5

