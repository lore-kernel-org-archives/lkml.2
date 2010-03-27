Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0C0GZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 02:25:48 -0400
Received: from server78.greatnet.de ([83.133.96.102]:43611 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0C0GZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 02:25:46 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: linux-fbdev@vger.kernel.org
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>,
       Jaya Kumar <jayalk@intworks.biz>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       James Simmons <jsimmons@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] fbdev: section cleanup in arcfb
Date: Sat, 27 Mar 2010 07:24:45 +0100
Message-Id: <1269671092-19948-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sections in the arcfb driver.

WARNING: drivers/video/built-in.o(.devinit.text+0x543): Section mismatch in reference from the function arcfb_probe() to the variable .init.data:arcfb_var
The function __devinit arcfb_probe() references
a variable __initdata arcfb_var.
If arcfb_var is only used by arcfb_probe then
annotate arcfb_var with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x558): Section mismatch in reference from the function arcfb_probe() to the variable .init.data:arcfb_fix
The function __devinit arcfb_probe() references
a variable __initdata arcfb_fix.
If arcfb_fix is only used by arcfb_probe then
annotate arcfb_fix with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/video/arcfb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index 01554d6..3d18039 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -81,7 +81,7 @@ struct arcfb_par {
 	spinlock_t lock;
 };
 
-static struct fb_fix_screeninfo arcfb_fix __initdata = {
+static struct fb_fix_screeninfo arcfb_fix __devinitdata = {
 	.id =		"arcfb",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_MONO01,
@@ -91,7 +91,7 @@ static struct fb_fix_screeninfo arcfb_fix __initdata = {
 	.accel =	FB_ACCEL_NONE,
 };
 
-static struct fb_var_screeninfo arcfb_var __initdata = {
+static struct fb_var_screeninfo arcfb_var __devinitdata = {
 	.xres		= 128,
 	.yres		= 64,
 	.xres_virtual	= 128,
@@ -589,7 +589,7 @@ err:
 	return retval;
 }
 
-static int arcfb_remove(struct platform_device *dev)
+static int __devexit arcfb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
@@ -603,7 +603,7 @@ static int arcfb_remove(struct platform_device *dev)
 
 static struct platform_driver arcfb_driver = {
 	.probe	= arcfb_probe,
-	.remove = arcfb_remove,
+	.remove = __devexit_p(arcfb_remove),
 	.driver	= {
 		.name	= "arcfb",
 	},
-- 
1.7.0

