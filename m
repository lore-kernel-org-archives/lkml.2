Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab0GAVPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:15:04 -0400
Received: from kroah.org ([198.145.64.141]:60801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758922Ab0GAVNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:30 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:51 2010
Message-Id: <20100701174251.165473863@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [056/200] fbdev: section cleanup in hgafb
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Kretzschmar <henne@nachtwindheim.de>

commit e217e6e39f62e47f7e659b715235dbd57df480f8 upstream.

Fix up the sections in the hgafb driver, by

* moving hga_default_var and hga_fix from .init.data to .devinit.data

* moving hga_detect() from .init.text to .devinit.text

* moving hga_fb_remove() from .text to .devexit.text

This fixes the following warnings issued by modpost:

WARNING: drivers/video/hgafb.o(.devinit.text+0x18): Section mismatch in referenc
e from the function hgafb_probe() to the function .init.text:hga_card_detect()
The function __devinit hgafb_probe() references
a function __init hga_card_detect().
If hga_card_detect is only used by hgafb_probe then
annotate hga_card_detect with a matching annotation.

WARNING: drivers/video/hgafb.o(.devinit.text+0xfe): Section mismatch in referenc
e from the function hgafb_probe() to the variable .init.data:hga_fix
The function __devinit hgafb_probe() references
a variable __initdata hga_fix.
If hga_fix is only used by hgafb_probe then
annotate hga_fix with a matching annotation.

WARNING: drivers/video/hgafb.o(.devinit.text+0x105): Section mismatch in reference from the function hgafb_probe() to the variable .init.data:hga_default_var
The function __devinit hgafb_probe() references
a variable __initdata hga_default_var.
If hga_default_var is only used by hgafb_probe then
annotate hga_default_var with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/hgafb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -106,7 +106,7 @@ static DEFINE_SPINLOCK(hga_reg_lock);
 
 /* Framebuffer driver structures */
 
-static struct fb_var_screeninfo __initdata hga_default_var = {
+static struct fb_var_screeninfo hga_default_var __devinitdata = {
 	.xres		= 720,
 	.yres 		= 348,
 	.xres_virtual 	= 720,
@@ -120,7 +120,7 @@ static struct fb_var_screeninfo __initda
 	.width 		= -1,
 };
 
-static struct fb_fix_screeninfo __initdata hga_fix = {
+static struct fb_fix_screeninfo hga_fix __devinitdata = {
 	.id 		= "HGA",
 	.type 		= FB_TYPE_PACKED_PIXELS,	/* (not sure) */
 	.visual 	= FB_VISUAL_MONO10,
@@ -276,7 +276,7 @@ static void hga_blank(int blank_mode)
 	spin_unlock_irqrestore(&hga_reg_lock, flags);
 }
 
-static int __init hga_card_detect(void)
+static int __devinit hga_card_detect(void)
 {
 	int count = 0;
 	void __iomem *p, *q;
@@ -596,7 +596,7 @@ static int __devinit hgafb_probe(struct
 	return 0;
 }
 
-static int hgafb_remove(struct platform_device *pdev)
+static int __devexit hgafb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 
@@ -621,7 +621,7 @@ static int hgafb_remove(struct platform_
 
 static struct platform_driver hgafb_driver = {
 	.probe = hgafb_probe,
-	.remove = hgafb_remove,
+	.remove = __devexit_p(hgafb_remove),
 	.driver = {
 		.name = "hgafb",
 	},


