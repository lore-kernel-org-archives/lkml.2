Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab0GAVyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:54:09 -0400
Received: from kroah.org ([198.145.64.141]:60801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926Ab0GAVNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:33 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:51 2010
Message-Id: <20100701174251.418658013@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [059/200] fbdev: section cleanup in arcfb
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Kretzschmar <henne@nachtwindheim.de>

commit bd9b5caf8616501d2ab6f17210b11f81ea7546eb upstream.

Fix the sections in the arcfb driver, by moving:

*	the variables arcfb_fix and arcfb_var from .init.data to .devinit.data

*	arcfb_remove() from .text to .devexit.text

This fixes the following warnings issued by modpost:

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
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/arcfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -80,7 +80,7 @@ struct arcfb_par {
 	spinlock_t lock;
 };
 
-static struct fb_fix_screeninfo arcfb_fix __initdata = {
+static struct fb_fix_screeninfo arcfb_fix __devinitdata = {
 	.id =		"arcfb",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_MONO01,
@@ -90,7 +90,7 @@ static struct fb_fix_screeninfo arcfb_fi
 	.accel =	FB_ACCEL_NONE,
 };
 
-static struct fb_var_screeninfo arcfb_var __initdata = {
+static struct fb_var_screeninfo arcfb_var __devinitdata = {
 	.xres		= 128,
 	.yres		= 64,
 	.xres_virtual	= 128,
@@ -588,7 +588,7 @@ err:
 	return retval;
 }
 
-static int arcfb_remove(struct platform_device *dev)
+static int __devexit arcfb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
@@ -602,7 +602,7 @@ static int arcfb_remove(struct platform_
 
 static struct platform_driver arcfb_driver = {
 	.probe	= arcfb_probe,
-	.remove = arcfb_remove,
+	.remove = __devexit_p(arcfb_remove),
 	.driver	= {
 		.name	= "arcfb",
 	},


