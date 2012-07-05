Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2GEOqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:46:25 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:57200 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932805Ab2GEOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHghkBBSMECwFGECUCJgICVwcSiA+mepJWgSCBIY4kgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562640"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 07/19] Staging: xgifb: Simplify XGIfb_GetXG21DefaultLVDSModeIdx().
Date: Thu,  5 Jul 2012 16:45:50 +0200
Message-Id: <cebdaec272aedd4922dedc65484f4dbb2d6a77d8.1341498466.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code and make it more readable.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 367e581..b360ad3 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -256,28 +256,19 @@ static void XGIRegInit(struct vb_device_info *XGI_Pr, unsigned long BaseAddr)
 
 static int XGIfb_GetXG21DefaultLVDSModeIdx(struct xgifb_video_info *xgifb_info)
 {
+	int i = 0;
 
-	int found_mode = 0;
-	int XGIfb_mode_idx = 0;
-
-	found_mode = 0;
-	while ((XGIbios_mode[XGIfb_mode_idx].mode_no != 0)
-			&& (XGIbios_mode[XGIfb_mode_idx].xres
-					<= xgifb_info->lvds_data.LVDSHDE)) {
-		if ((XGIbios_mode[XGIfb_mode_idx].xres
-				== xgifb_info->lvds_data.LVDSHDE)
-				&& (XGIbios_mode[XGIfb_mode_idx].yres
-					== xgifb_info->lvds_data.LVDSVDE)
-				&& (XGIbios_mode[XGIfb_mode_idx].bpp == 8)) {
-			found_mode = 1;
-			break;
+	while ((XGIbios_mode[i].mode_no != 0)
+	       && (XGIbios_mode[i].xres <= xgifb_info->lvds_data.LVDSHDE)) {
+		if ((XGIbios_mode[i].xres == xgifb_info->lvds_data.LVDSHDE)
+		    && (XGIbios_mode[i].yres == xgifb_info->lvds_data.LVDSVDE)
+		    && (XGIbios_mode[i].bpp == 8)) {
+			return i;
 		}
-		XGIfb_mode_idx++;
+		i++;
 	}
-	if (!found_mode)
-		XGIfb_mode_idx = -1;
 
-	return XGIfb_mode_idx;
+	return -1;
 }
 
 static void XGIfb_search_mode(struct xgifb_video_info *xgifb_info,
-- 
1.7.9.5

