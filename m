Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0GAVPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:15:23 -0400
Received: from kroah.org ([198.145.64.141]:60825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927Ab0GAVNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:34 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:51 2010
Message-Id: <20100701174251.498358157@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [060/200] fbdev: section cleanup in w100fb
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Kretzschmar <henne@nachtwindheim.de>

commit fb6cb3270af8f2ad3dd556906a9c52aa85754849 upstream.

Fix up the section in the w100fb driver, by moving:

*	w100fb_remove() from .text to .devexit.text

*	w100_get_xtal_table() from .text to .devinit.text

*	w100fb_init() from .devinit.text to .init.text

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/w100fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -53,7 +53,7 @@ static void w100_update_enable(void);
 static void w100_update_disable(void);
 static void calc_hsync(struct w100fb_par *par);
 static void w100_init_graphic_engine(struct w100fb_par *par);
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq);
+struct w100_pll_info *w100_get_xtal_table(unsigned int freq) __devinit;
 
 /* Pseudo palette size */
 #define MAX_PALETTES      16
@@ -782,7 +782,7 @@ out:
 }
 
 
-static int w100fb_remove(struct platform_device *pdev)
+static int __devexit w100fb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 	struct w100fb_par *par=info->par;
@@ -1020,7 +1020,7 @@ static struct pll_entries {
 	{ 0 },
 };
 
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq)
+struct w100_pll_info __devinit *w100_get_xtal_table(unsigned int freq)
 {
 	struct pll_entries *pll_entry = w100_pll_tables;
 
@@ -1611,7 +1611,7 @@ static void w100_vsync(void)
 
 static struct platform_driver w100fb_driver = {
 	.probe		= w100fb_probe,
-	.remove		= w100fb_remove,
+	.remove		= __devexit_p(w100fb_remove),
 	.suspend	= w100fb_suspend,
 	.resume		= w100fb_resume,
 	.driver		= {
@@ -1619,7 +1619,7 @@ static struct platform_driver w100fb_dri
 	},
 };
 
-int __devinit w100fb_init(void)
+int __init w100fb_init(void)
 {
 	return platform_driver_register(&w100fb_driver);
 }


