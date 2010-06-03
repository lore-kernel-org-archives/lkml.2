Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0FCOEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:04:50 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:42178 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab0FCOEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:04:37 -0400
Date: Thu, 3 Jun 2010 09:54:40 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       linux-fbdev@vger.kernel.org
Subject: [PATCH 4/4] lxfb: fix incorrect __init annotation
Message-ID: <20100603095440.5bb72ef5@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


WARNING: vmlinux.o(.data+0x196e8): Section mismatch in reference from the variable lxfb_driver to the function .init.text:lxfb_probe()
The variable lxfb_driver references
the function __init lxfb_probe()

This changes lxfb_probe and friends to use __devinit, and also adds __devexit
to lxfb_remove.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/video/geode/lxfb_core.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 1a18da8..39bdbed 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -35,7 +35,7 @@ static int vt_switch;
  * we try to make it something sane - 640x480-60 is sane
  */
 
-static struct fb_videomode geode_modedb[] __initdata = {
+static struct fb_videomode geode_modedb[] __devinitdata = {
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
@@ -219,14 +219,15 @@ static struct fb_videomode geode_modedb[] __initdata = {
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-static struct fb_videomode olpc_dcon_modedb[] __initdata = {
+static struct fb_videomode olpc_dcon_modedb[] __devinitdata = {
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
 		*modedb = (struct fb_videomode *) olpc_dcon_modedb;
@@ -238,7 +239,8 @@ static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 }
 
 #else
-static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __devinit get_modedb(struct fb_videomode **modedb,
+		unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) geode_modedb;
 	*size = ARRAY_SIZE(geode_modedb);
@@ -334,7 +336,7 @@ static int lxfb_blank(int blank_mode, struct fb_info *info)
 }
 
 
-static int __init lxfb_map_video_memory(struct fb_info *info,
+static int __devinit lxfb_map_video_memory(struct fb_info *info,
 					struct pci_dev *dev)
 {
 	struct lxfb_par *par = info->par;
@@ -412,7 +414,7 @@ static struct fb_ops lxfb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static struct fb_info * __init lxfb_init_fbinfo(struct device *dev)
+static struct fb_info * __devinit lxfb_init_fbinfo(struct device *dev)
 {
 	struct lxfb_par *par;
 	struct fb_info *info;
@@ -496,7 +498,7 @@ static int lxfb_resume(struct pci_dev *pdev)
 #define lxfb_resume NULL
 #endif
 
-static int __init lxfb_probe(struct pci_dev *pdev,
+static int __devinit lxfb_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
 	struct lxfb_par *par;
@@ -588,7 +590,7 @@ err:
 	return ret;
 }
 
-static void lxfb_remove(struct pci_dev *pdev)
+static void __devexit lxfb_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct lxfb_par *par = info->par;
-- 
1.5.6.5

