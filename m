Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800Ab1IOUOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:14:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:47975 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934725Ab1IOUKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="49297076"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, FlorianSchandinat@gmx.de
Subject: [PATCH 23/27] Initconst section fixes for VIDEO
Date: Thu, 15 Sep 2011 13:09:50 -0700
Message-Id: <1316117394-21666-24-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: FlorianSchandinat@gmx.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/video/aty/aty128fb.c     |    2 +-
 drivers/video/geode/gx1fb_core.c |    2 +-
 drivers/video/gxt4500.c          |    4 ++--
 drivers/video/i810/i810_main.c   |    2 +-
 drivers/video/jz4740_fb.c        |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index b0b2ac3..e9a0f98 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -148,7 +148,7 @@ enum {
 };
 
 /* Must match above enum */
-static const char *r128_family[] __devinitdata = {
+static char * const r128_family[] __devinitconst = {
 	"AGP",
 	"PCI",
 	"PRO AGP",
diff --git a/drivers/video/geode/gx1fb_core.c b/drivers/video/geode/gx1fb_core.c
index 5a5d092..265c5ed 100644
--- a/drivers/video/geode/gx1fb_core.c
+++ b/drivers/video/geode/gx1fb_core.c
@@ -29,7 +29,7 @@ static int  crt_option = 1;
 static char panel_option[32] = "";
 
 /* Modes relevant to the GX1 (taken from modedb.c) */
-static const struct fb_videomode __devinitdata gx1_modedb[] = {
+static const struct fb_videomode __devinitconst gx1_modedb[] = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
diff --git a/drivers/video/gxt4500.c b/drivers/video/gxt4500.c
index 896e53d..4d87d0b 100644
--- a/drivers/video/gxt4500.c
+++ b/drivers/video/gxt4500.c
@@ -156,7 +156,7 @@ struct gxt4500_par {
 static char *mode_option;
 
 /* default mode: 1280x1024 @ 60 Hz, 8 bpp */
-static const struct fb_videomode defaultmode __devinitdata = {
+static const struct fb_videomode defaultmode __devinitconst = {
 	.refresh = 60,
 	.xres = 1280,
 	.yres = 1024,
@@ -581,7 +581,7 @@ static int gxt4500_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
-static const struct fb_fix_screeninfo gxt4500_fix __devinitdata = {
+static const struct fb_fix_screeninfo gxt4500_fix __devinitconst = {
 	.id = "IBM GXT4500P",
 	.type = FB_TYPE_PACKED_PIXELS,
 	.visual = FB_VISUAL_PSEUDOCOLOR,
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index 318f6fb..42af268 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -97,7 +97,7 @@ static int i810fb_blank      (int blank_mode, struct fb_info *info);
 static void i810fb_release_resource       (struct fb_info *info, struct i810fb_par *par);
 
 /* PCI */
-static const char *i810_pci_list[] __devinitdata = {
+static const char * const i810_pci_list[] __devinitconst = {
 	"Intel(R) 810 Framebuffer Device"                                 ,
 	"Intel(R) 810-DC100 Framebuffer Device"                           ,
 	"Intel(R) 810E Framebuffer Device"                                ,
diff --git a/drivers/video/jz4740_fb.c b/drivers/video/jz4740_fb.c
index de36693..3c63fc2 100644
--- a/drivers/video/jz4740_fb.c
+++ b/drivers/video/jz4740_fb.c
@@ -136,7 +136,7 @@ struct jzfb {
 	uint32_t pseudo_palette[16];
 };
 
-static const struct fb_fix_screeninfo jzfb_fix __devinitdata = {
+static const struct fb_fix_screeninfo jzfb_fix __devinitconst = {
 	.id		= "JZ4740 FB",
 	.type		= FB_TYPE_PACKED_PIXELS,
 	.visual		= FB_VISUAL_TRUECOLOR,
-- 
1.7.4.4

