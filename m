Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1FMSNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:13:04 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:52434 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab1FMSNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:13:02 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>, Ville Syrjala <syrjala@sci.fi>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] fbdev/atyfb: Fix 2 defined-but-not-used warnings
Date: Mon, 13 Jun 2011 20:12:58 +0200
Message-Id: <1307988778-21644-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_FB_ATY_BACKLIGHT=y but CONFIG_PCI=n:

drivers/video/aty/atyfb_base.c:2272: warning: ‘aty_bl_exit’ defined but not used

If CONFIG_ATARI=y for a modular build:

drivers/video/aty/atyfb_base.c:2794: warning: ‘store_video_par’ defined but not
used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/aty/atyfb_base.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index ebb893c..d7aaec5 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -248,10 +248,6 @@ static int atyfb_sync(struct fb_info *info);
 
 static int aty_init(struct fb_info *info);
 
-#ifdef CONFIG_ATARI
-static int store_video_par(char *videopar, unsigned char m64_num);
-#endif
-
 static void aty_get_crtc(const struct atyfb_par *par, struct crtc *crtc);
 
 static void aty_set_crtc(const struct atyfb_par *par, const struct crtc *crtc);
@@ -2268,11 +2264,13 @@ error:
 	return;
 }
 
+#ifdef CONFIG_PCI
 static void aty_bl_exit(struct backlight_device *bd)
 {
 	backlight_device_unregister(bd);
 	printk("aty: Backlight unloaded\n");
 }
+#endif /* CONFIG_PCI */
 
 #endif /* CONFIG_FB_ATY_BACKLIGHT */
 
@@ -2789,7 +2787,7 @@ aty_init_exit:
 	return ret;
 }
 
-#ifdef CONFIG_ATARI
+#if defined(CONFIG_ATARI) && !defined(MODULE)
 static int __devinit store_video_par(char *video_str, unsigned char m64_num)
 {
 	char *p;
@@ -2818,7 +2816,7 @@ static int __devinit store_video_par(char *video_str, unsigned char m64_num)
 	phys_vmembase[m64_num] = 0;
 	return -1;
 }
-#endif /* CONFIG_ATARI */
+#endif /* CONFIG_ATARI && !MODULE */
 
 /*
  * Blank the display.
-- 
1.7.0.4

