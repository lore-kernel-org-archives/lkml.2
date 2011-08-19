Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1HSTms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:42:48 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60188 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab1HSTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:31 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] staging: xgifb: eliminate #ifdef XGIFB_PAN
Date: Fri, 19 Aug 2011 22:40:25 +0300
Message-Id: <1313782830-31461-8-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XGIFB_PAN is always defined and checks can be eliminated.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 0636300..cc4127f 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -28,10 +28,6 @@
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 
-#ifndef XGIFB_PAN
-#define XGIFB_PAN
-#endif
-
 #include <linux/io.h>
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
@@ -1361,7 +1357,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	return 0;
 }
 
-#ifdef XGIFB_PAN
 static int XGIfb_pan_var(struct fb_var_screeninfo *var)
 {
 	unsigned int base;
@@ -1414,7 +1409,6 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var)
 	/* printk("End of pan_var"); */
 	return 0;
 }
-#endif
 
 static int XGIfb_open(struct fb_info *info, int user)
 {
@@ -1500,10 +1494,8 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 	else
 		fix->visual = FB_VISUAL_DIRECTCOLOR;
 	fix->xpanstep = 0;
-#ifdef XGIFB_PAN
 	if (XGIfb_ypan)
 		fix->ypanstep = 1;
-#endif
 	fix->ywrapstep = 0;
 	fix->line_length = xgi_video_info.video_linelength;
 	fix->mmio_start = xgi_video_info.mmio_base;
@@ -1671,7 +1663,6 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	return 0;
 }
 
-#ifdef XGIFB_PAN
 static int XGIfb_pan_display(struct fb_var_screeninfo *var,
 		struct fb_info *info)
 {
@@ -1708,7 +1699,6 @@ static int XGIfb_pan_display(struct fb_var_screeninfo *var,
 	/* printk("End of pan_display\n"); */
 	return 0;
 }
-#endif
 
 static int XGIfb_blank(int blank, struct fb_info *info)
 {
@@ -1734,9 +1724,7 @@ static struct fb_ops XGIfb_ops = {
 	.fb_check_var = XGIfb_check_var,
 	.fb_set_par = XGIfb_set_par,
 	.fb_setcolreg = XGIfb_setcolreg,
-#ifdef XGIFB_PAN
 	.fb_pan_display = XGIfb_pan_display,
-#endif
 	.fb_blank = XGIfb_blank,
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
-- 
1.7.2.5

