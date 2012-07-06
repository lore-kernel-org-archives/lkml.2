Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab2GFKo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:44:58 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29884 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933167Ab2GFKl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCBIY4MgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130685"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 07/19 v2] Staging: xgifb: Simplify XGIfb_GetXG21DefaultLVDSModeIdx().
Date: Fri,  6 Jul 2012 12:40:42 +0200
Message-Id: <fafeba4d6423f66f18643bc69057cd8b977e0302.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
 <cover.1341569486.git.magomez@igalia.com>
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341569486.git.magomez@igalia.com>
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
index 788d141..c1aa037 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -262,28 +262,19 @@ static void XGIRegInit(struct vb_device_info *XGI_Pr, unsigned long BaseAddr)
 
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

