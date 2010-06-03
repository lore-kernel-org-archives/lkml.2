Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0FCOEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:04:48 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:42180 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab0FCOEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:04:37 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 10:04:37 EDT
Date: Thu, 3 Jun 2010 09:54:30 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       linux-fbdev@vger.kernel.org
Subject: [PATCH 3/4] gxfb: fix incorrect __init annotation
Message-ID: <20100603095430.64938042@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


WARNING: vmlinux.o(.data+0x195d8): Section mismatch in reference from the variable gxfb_driver to the function .init.text:gxfb_probe()
The variable gxfb_driver references
the function __init gxfb_probe()

This changes gxfb_probe and friends to use __devinit, and also adds __devexit
to gxfb_remove.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/video/geode/gxfb_core.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 76e7dac..70b1d9d 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -40,7 +40,7 @@ static int vram;
 static int vt_switch;
 
 /* Modes relevant to the GX (taken from modedb.c) */
-static struct fb_videomode gx_modedb[] __initdata = {
+static struct fb_videomode gx_modedb[] __devinitdata = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
@@ -110,14 +110,15 @@ static struct fb_videomode gx_modedb[] __initdata = {
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-static struct fb_videomode gx_dcon_modedb[] __initdata = {
+static struct fb_videomode gx_dcon_modedb[] __devinitdata = {
 	/* The only mode the DCON has is 1200x900 */
 	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, 0 }
 };
 
-static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __devinit get_modedb(struct fb_videomode **modedb,
+		unsigned int *size)
 {
 	if (olpc_has_dcon()) {
 		*modedb = (struct fb_videomode *) gx_dcon_modedb;
@@ -129,7 +130,8 @@ static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 }
 
 #else
-static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __devinit get_modedb(struct fb_videomode **modedb,
+		unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) gx_modedb;
 	*size = ARRAY_SIZE(gx_modedb);
@@ -226,7 +228,8 @@ static int gxfb_blank(int blank_mode, struct fb_info *info)
 	return gx_blank_display(info, blank_mode);
 }
 
-static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
+static int __devinit gxfb_map_video_memory(struct fb_info *info,
+		struct pci_dev *dev)
 {
 	struct gxfb_par *par = info->par;
 	int ret;
@@ -290,7 +293,7 @@ static struct fb_ops gxfb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static struct fb_info * __init gxfb_init_fbinfo(struct device *dev)
+static struct fb_info *__devinit gxfb_init_fbinfo(struct device *dev)
 {
 	struct gxfb_par *par;
 	struct fb_info *info;
@@ -371,7 +374,8 @@ static int gxfb_resume(struct pci_dev *pdev)
 }
 #endif
 
-static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit gxfb_probe(struct pci_dev *pdev,
+		const struct pci_device_id *id)
 {
 	struct gxfb_par *par;
 	struct fb_info *info;
@@ -451,7 +455,7 @@ static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	return ret;
 }
 
-static void gxfb_remove(struct pci_dev *pdev)
+static void __devexit gxfb_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct gxfb_par *par = info->par;
-- 
1.5.6.5

