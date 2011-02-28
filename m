Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1B1KAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:00:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60326 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1B1KAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:00:35 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/8] fb: export fb mode db table
Date: Mon, 28 Feb 2011 11:00:22 +0100
Message-Id: <1298887229-7987-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de>
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
Cc: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>
---
 drivers/video/modedb.c |    8 ++++++--
 include/linux/fb.h     |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 48c3ea8..942b44d 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -36,8 +36,7 @@ EXPORT_SYMBOL_GPL(fb_mode_option);
  *  Standard video mode definitions (taken from XFree86)
  */
 
-static const struct fb_videomode modedb[] = {
-
+const struct fb_videomode modedb[] = {
 	/* 640x400 @ 70 Hz, 31.5 kHz hsync */
 	{ NULL, 70, 640, 400, 39721, 40, 24, 39, 9, 96, 2, 0,
 		FB_VMODE_NONINTERLACED },
@@ -291,6 +290,11 @@ static const struct fb_videomode modedb[] = {
 		0, FB_VMODE_NONINTERLACED },
 };
 
+const struct fb_videomode *fb_modes = modedb;
+EXPORT_SYMBOL(fb_modes);
+const int num_fb_modes = ARRAY_SIZE(modedb);
+EXPORT_SYMBOL(num_fb_modes);
+
 #ifdef CONFIG_FB_MODE_HELPERS
 const struct fb_videomode cea_modes[64] = {
 	/* #1: 640x480p@59.94/60Hz */
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 68ba85a..41b0ce1 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -1154,6 +1154,9 @@ extern const char *fb_mode_option;
 extern const struct fb_videomode vesa_modes[];
 extern const struct fb_videomode cea_modes[64];
 
+extern const struct fb_videomode *fb_modes;
+extern const int num_fb_modes;
+
 struct fb_modelist {
 	struct list_head list;
 	struct fb_videomode mode;
-- 
1.7.2.3

