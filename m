Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1HSTki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:40:38 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60197 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab1HSTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:31 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] staging: xgifb: replace video_type with FB_TYPE_PACKED_PIXELS
Date: Fri, 19 Aug 2011 22:40:27 +0300
Message-Id: <1313782830-31461-10-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a global variable with a constant.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    3 ---
 drivers/staging/xgifb/XGI_main_26.c |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index d0a672c..2f82488 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -132,9 +132,6 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 /* Fbcon variables */
 static struct fb_info *fb_info;
 
-
-static int    video_type = FB_TYPE_PACKED_PIXELS;
-
 static struct fb_var_screeninfo default_var = {
 	.xres		= 0,
 	.yres		= 0,
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 1674a4b..7d06c05 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1487,7 +1487,7 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 
 	fix->smem_len = xgi_video_info.video_size;
 
-	fix->type = video_type;
+	fix->type = FB_TYPE_PACKED_PIXELS;
 	fix->type_aux = 0;
 	if (xgi_video_info.video_bpp == 8)
 		fix->visual = FB_VISUAL_PSEUDOCOLOR;
-- 
1.7.2.5

