Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2FRLMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:12:41 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60062 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974Ab2FRLMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:12:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4CADoM309bdWObgWdsb2JhbABFhVewBCIBARYmJ4IZAQUjBAsBRhAlAiYCAlcHEogPpXKSBYEgj0CBEgOVJJJf
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="1004339232"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 2/8] Staging: xgifb: remove DEBUGPRN() macro and its uses.
Date: Mon, 18 Jun 2012 13:12:00 +0200
Message-Id: <6b55840f5dc51a182454be72c6ee3143c8c57849.1340016625.git.magomez@igalia.com>
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

Remove DEBUGPRN() macro which is defined as empty.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 8e0786d..143dd31 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -117,12 +117,6 @@ static inline void dumpVGAReg(void)
 }
 #endif
 
-#if 1
-#define DEBUGPRN(x)
-#else
-#define DEBUGPRN(x) pr_info(x "\n");
-#endif
-
 /* --------------- Hardware Access Routines -------------------------- */
 
 static int XGIfb_mode_rate_to_dclock(struct vb_device_info *XGI_Pr,
@@ -1054,7 +1048,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	int old_mode;
 	/* unsigned char reg, reg1; */
 
-	DEBUGPRN("Inside do_set_var");
 	/* printk(KERN_DEBUG "XGIfb:var->yres=%d, var->upper_margin=%d, var->lower_margin=%d, var->vsync_len=%d\n", var->yres, var->upper_margin, var->lower_margin, var->vsync_len); */
 
 	info->var.xres_virtual = var->xres_virtual;
@@ -1199,7 +1192,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		}
 	}
 	XGIfb_bpp_to_var(xgifb_info, var); /*update ARGB info*/
-	DEBUGPRN("End of do_set_var");
 
 	dumpVGAReg();
 	return 0;
@@ -1321,7 +1313,6 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 {
 	struct xgifb_video_info *xgifb_info = info->par;
 
-	DEBUGPRN("inside get_fix");
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
 
 	strncpy(fix->id, "XGI", sizeof(fix->id) - 1);
@@ -1352,7 +1343,6 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 	fix->mmio_len = xgifb_info->mmio_size;
 	fix->accel = FB_ACCEL_SIS_XABRE;
 
-	DEBUGPRN("end of get_fix");
 	return 0;
 }
 
@@ -1379,8 +1369,6 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	int found_mode = 0;
 	int refresh_rate, search_idx;
 
-	DEBUGPRN("Inside check_var");
-
 	if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
 		vtotal = var->upper_margin + var->yres + var->lower_margin
 				+ var->vsync_len;
@@ -1511,7 +1499,6 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	var->blue.msb_right =
 	var->transp.offset = var->transp.length = var->transp.msb_right = 0;
 
-	DEBUGPRN("end of check_var");
 	return 0;
 }
 
-- 
1.7.9.5

