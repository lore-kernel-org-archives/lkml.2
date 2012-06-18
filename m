Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2FRLNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:13:48 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60062 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751439Ab2FRLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4IZAQUjBAsBRhAlAiYCAlcHEogPpXKSBYEgj0CBEgOVJIkkiTs
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339237"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 3/8] Staging: xgifb: remove DPRINTK() macro and replace it with pr_debug.
Date: Mon, 18 Jun 2012 13:12:01 +0200
Message-Id: <ae46504eae191c2b2648cdcae8a27c9c7b03e69f.1340016625.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
In-Reply-To: <cover.1340016625.git.magomez@igalia.com>
References: <cover.1340016625.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   42 +++++++++++++++--------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 143dd31..9ffc853 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -33,12 +33,6 @@ static unsigned int refresh_rate;
 #undef XGIFBDEBUG
 
 #ifdef XGIFBDEBUG
-#define DPRINTK(fmt, args...) pr_debug("%s: " fmt, __func__ , ## args)
-#else
-#define DPRINTK(fmt, args...)
-#endif
-
-#ifdef XGIFBDEBUG
 static void dumpVGAReg(void)
 {
 	u8 i, reg;
@@ -662,8 +656,8 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				break;
 			} else if (XGIfb_vrate[i].refresh > rate) {
 				if ((XGIfb_vrate[i].refresh - rate) <= 3) {
-					DPRINTK("XGIfb: Adjusting rate from %d up to %d\n",
-						rate, XGIfb_vrate[i].refresh);
+					pr_debug("XGIfb: Adjusting rate from %d up to %d\n",
+						 rate, XGIfb_vrate[i].refresh);
 					xgifb_info->rate_idx =
 						XGIfb_vrate[i].idx;
 					xgifb_info->refresh_rate =
@@ -671,8 +665,8 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				} else if (((rate - XGIfb_vrate[i - 1].refresh)
 						<= 2) && (XGIfb_vrate[i].idx
 						!= 1)) {
-					DPRINTK("XGIfb: Adjusting rate from %d down to %d\n",
-						rate, XGIfb_vrate[i-1].refresh);
+					pr_debug("XGIfb: Adjusting rate from %d down to %d\n",
+						 rate, XGIfb_vrate[i-1].refresh);
 					xgifb_info->rate_idx =
 						XGIfb_vrate[i - 1].idx;
 					xgifb_info->refresh_rate =
@@ -680,8 +674,8 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				}
 				break;
 			} else if ((rate - XGIfb_vrate[i].refresh) <= 2) {
-				DPRINTK("XGIfb: Adjusting rate from %d down to %d\n",
-					rate, XGIfb_vrate[i].refresh);
+				pr_debug("XGIfb: Adjusting rate from %d down to %d\n",
+					 rate, XGIfb_vrate[i].refresh);
 				xgifb_info->rate_idx = XGIfb_vrate[i].idx;
 				break;
 			}
@@ -995,15 +989,15 @@ static void XGIfb_post_setmode(struct xgifb_video_info *xgifb_info)
 			}
 
 			if ((filter >= 0) && (filter <= 7)) {
-				DPRINTK("FilterTable[%d]-%d: %02x %02x %02x %02x\n",
-					filter_tb, filter,
-					XGI_TV_filter[filter_tb].
+				pr_debug("FilterTable[%d]-%d: %02x %02x %02x %02x\n",
+					 filter_tb, filter,
+					 XGI_TV_filter[filter_tb].
 						filter[filter][0],
-					XGI_TV_filter[filter_tb].
+					 XGI_TV_filter[filter_tb].
 						filter[filter][1],
-					XGI_TV_filter[filter_tb].
+					 XGI_TV_filter[filter_tb].
 						filter[filter][2],
-					XGI_TV_filter[filter_tb].
+					 XGI_TV_filter[filter_tb].
 						filter[filter][3]
 				);
 				xgifb_reg_set(
@@ -1064,7 +1058,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	}
 
 	if (!htotal || !vtotal) {
-		DPRINTK("XGIfb: Invalid 'var' information\n");
+		pr_debug("XGIfb: Invalid 'var' information\n");
 		return -EINVAL;
 	} pr_debug("var->pixclock=%d, htotal=%d, vtotal=%d\n",
 			var->pixclock, htotal, vtotal);
@@ -1140,11 +1134,11 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 
 		XGIfb_post_setmode(xgifb_info);
 
-		DPRINTK("XGIfb: Set new mode: %dx%dx%d-%d\n",
-				XGIbios_mode[xgifb_info->mode_idx].xres,
-				XGIbios_mode[xgifb_info->mode_idx].yres,
-				XGIbios_mode[xgifb_info->mode_idx].bpp,
-				xgifb_info->refresh_rate);
+		pr_debug("XGIfb: Set new mode: %dx%dx%d-%d\n",
+			 XGIbios_mode[xgifb_info->mode_idx].xres,
+			 XGIbios_mode[xgifb_info->mode_idx].yres,
+			 XGIbios_mode[xgifb_info->mode_idx].bpp,
+			 xgifb_info->refresh_rate);
 
 		xgifb_info->video_bpp = XGIbios_mode[xgifb_info->mode_idx].bpp;
 		xgifb_info->video_vwidth = info->var.xres_virtual;
-- 
1.7.9.5

