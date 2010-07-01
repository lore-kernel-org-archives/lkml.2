Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab0GAVyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:54:16 -0400
Received: from kroah.org ([198.145.64.141]:60813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770Ab0GAVNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:32 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:51 2010
Message-Id: <20100701174251.337449786@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [058/200] fbdev: section cleanup in vga16fb
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Kretzschmar <henne@nachtwindheim.de>

commit ad1458464cbbe6935be6e20d70920301733158af upstream.

Fix up the sections in the vga16fb driver, by moving:

*	the variables vga16_defined and vga16fb
	from .init.data to .devinit.data

*	vga16fb_setup() from .text to .init.text

*	vga16fb_remove() from .text. to .devexit.text

This fixes the following warnings issued by modpost:

WARNING: drivers/video/built-in.o(.devinit.text+0x1a420): Section mismatch in re
ference from the function vga16fb_probe() to the (unknown reference) .init.data:
(unknown)
The function __devinit vga16fb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by vga16fb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x1a437): Section mismatch in reference from the function vga16fb_probe() to the variable .init.data:vga16fb_defined
The function __devinit vga16fb_probe() references
a variable __initdata vga16fb_defined.
If vga16fb_defined is only used by vga16fb_probe then
annotate vga16fb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x1a457): Section mismatch in reference from the function vga16fb_probe() to the variable .init.data:vga16fb_fix
The function __devinit vga16fb_probe() references
a variable __initdata vga16fb_fix.
If vga16fb_fix is only used by vga16fb_probe then
annotate vga16fb_fix with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/vga16fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -65,7 +65,7 @@ struct vga16fb_par {
 
 /* --------------------------------------------------------------------- */
 
-static struct fb_var_screeninfo vga16fb_defined __initdata = {
+static struct fb_var_screeninfo vga16fb_defined __devinitdata = {
 	.xres		= 640,
 	.yres		= 480,
 	.xres_virtual	= 640,
@@ -85,7 +85,7 @@ static struct fb_var_screeninfo vga16fb_
 };
 
 /* name should not depend on EGA/VGA */
-static struct fb_fix_screeninfo vga16fb_fix __initdata = {
+static struct fb_fix_screeninfo vga16fb_fix __devinitdata = {
 	.id		= "VGA16 VGA",
 	.smem_start	= VGA_FB_PHYS,
 	.smem_len	= VGA_FB_PHYS_LEN,
@@ -1278,7 +1278,7 @@ static struct fb_ops vga16fb_ops = {
 };
 
 #ifndef MODULE
-static int vga16fb_setup(char *options)
+static int __init vga16fb_setup(char *options)
 {
 	char *this_opt;
 	
@@ -1376,7 +1376,7 @@ static int __devinit vga16fb_probe(struc
 	return ret;
 }
 
-static int vga16fb_remove(struct platform_device *dev)
+static int __devexit vga16fb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
@@ -1393,7 +1393,7 @@ static int vga16fb_remove(struct platfor
 
 static struct platform_driver vga16fb_driver = {
 	.probe = vga16fb_probe,
-	.remove = vga16fb_remove,
+	.remove = __devexit_p(vga16fb_remove),
 	.driver = {
 		.name = "vga16fb",
 	},


