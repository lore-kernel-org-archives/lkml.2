Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0LINtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:49:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42244 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0LINr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:47:29 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/9] fb: export fb mode db table
Date: Thu,  9 Dec 2010 14:47:16 +0100
Message-Id: <1291902441-24712-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different modes can be useful for drivers. Currently there is
no way to expose the modes to sysfs, so export them.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/video/modedb.c |    7 ++++++-
 include/linux/fb.h     |    3 +++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 0a4dbdc..82122a9 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -36,7 +36,7 @@ EXPORT_SYMBOL_GPL(fb_mode_option);
      *  Standard video mode definitions (taken from XFree86)
      */
 
-static const struct fb_videomode modedb[] = {
+const struct fb_videomode modedb[] = {
     {
 	/* 640x400 @ 70 Hz, 31.5 kHz hsync */
 	NULL, 70, 640, 400, 39721, 40, 24, 39, 9, 96, 2,
@@ -277,6 +277,11 @@ static const struct fb_videomode modedb[] = {
     },
 };
 
+const struct fb_videomode *fb_modes = modedb;
+EXPORT_SYMBOL(fb_modes);
+const int num_fb_modes = ARRAY_SIZE(modedb);
+EXPORT_SYMBOL(num_fb_modes);
+
 #ifdef CONFIG_FB_MODE_HELPERS
 const struct fb_videomode vesa_modes[] = {
 	/* 0 640x350-85 VESA */
diff --git a/include/linux/fb.h b/include/linux/fb.h
index d1631d3..e006172 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -1151,6 +1151,9 @@ struct fb_videomode {
 extern const char *fb_mode_option;
 extern const struct fb_videomode vesa_modes[];
 
+extern const struct fb_videomode *fb_modes;
+extern const int num_fb_modes;
+
 struct fb_modelist {
 	struct list_head list;
 	struct fb_videomode mode;
-- 
1.7.2.3

