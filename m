Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0CZB0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:26:44 -0400
Received: from server78.greatnet.de ([83.133.96.102]:49365 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0CZB0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:26:43 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: miguel.ojeda.sandonis@gmail.com
Cc: u.kleine-koenig@pengutronix.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH] auxdisplay: section cleanup in cfag12864bfb driver
Date: Fri, 26 Mar 2010 02:26:14 +0100
Message-Id: <1269566774-26330-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a two section mismatches and makes
remove() __devexit.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/auxdisplay/cfag12864bfb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/auxdisplay/cfag12864bfb.c b/drivers/auxdisplay/cfag12864bfb.c
index b0ca5a4..9d466d6 100644
--- a/drivers/auxdisplay/cfag12864bfb.c
+++ b/drivers/auxdisplay/cfag12864bfb.c
@@ -38,7 +38,7 @@
 
 #define CFAG12864BFB_NAME "cfag12864bfb"
 
-static struct fb_fix_screeninfo cfag12864bfb_fix __initdata = {
+static struct fb_fix_screeninfo cfag12864bfb_fix __devinitdata = {
 	.id = "cfag12864b",
 	.type = FB_TYPE_PACKED_PIXELS,
 	.visual = FB_VISUAL_MONO10,
@@ -49,7 +49,7 @@ static struct fb_fix_screeninfo cfag12864bfb_fix __initdata = {
 	.accel = FB_ACCEL_NONE,
 };
 
-static struct fb_var_screeninfo cfag12864bfb_var __initdata = {
+static struct fb_var_screeninfo cfag12864bfb_var __devinitdata = {
 	.xres = CFAG12864B_WIDTH,
 	.yres = CFAG12864B_HEIGHT,
 	.xres_virtual = CFAG12864B_WIDTH,
@@ -115,7 +115,7 @@ none:
 	return ret;
 }
 
-static int cfag12864bfb_remove(struct platform_device *device)
+static int __devexit cfag12864bfb_remove(struct platform_device *device)
 {
 	struct fb_info *info = platform_get_drvdata(device);
 
@@ -129,7 +129,7 @@ static int cfag12864bfb_remove(struct platform_device *device)
 
 static struct platform_driver cfag12864bfb_driver = {
 	.probe	= cfag12864bfb_probe,
-	.remove = cfag12864bfb_remove,
+	.remove = __devexit_p(cfag12864bfb_remove),
 	.driver = {
 		.name	= CFAG12864BFB_NAME,
 	},
-- 
1.6.3.3

