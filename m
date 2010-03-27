Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0C0Gaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 02:30:35 -0400
Received: from server78.greatnet.de ([83.133.96.102]:45712 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab0C0Gab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 02:30:31 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: linux-fbdev@vger.kernel.org
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] fbdev: section cleanup in w100fb
Date: Sat, 27 Mar 2010 07:29:11 +0100
Message-Id: <1269671353-22041-6-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269671353-22041-1-git-send-email-henne@nachtwindheim.de>
References: <1269671353-22041-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the section in the w100fb driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/video/w100fb.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index 5d22395..a37a46c 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -52,7 +52,7 @@ static void w100_update_enable(void);
 static void w100_update_disable(void);
 static void calc_hsync(struct w100fb_par *par);
 static void w100_init_graphic_engine(struct w100fb_par *par);
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq);
+struct w100_pll_info *w100_get_xtal_table(unsigned int freq) __devinit;
 
 /* Pseudo palette size */
 #define MAX_PALETTES      16
@@ -781,7 +781,7 @@ out:
 }
 
 
-static int w100fb_remove(struct platform_device *pdev)
+static int __devexit w100fb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 	struct w100fb_par *par=info->par;
@@ -1019,7 +1019,7 @@ static struct pll_entries {
 	{ 0 },
 };
 
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq)
+struct w100_pll_info __devinit *w100_get_xtal_table(unsigned int freq)
 {
 	struct pll_entries *pll_entry = w100_pll_tables;
 
@@ -1610,7 +1610,7 @@ static void w100_vsync(void)
 
 static struct platform_driver w100fb_driver = {
 	.probe		= w100fb_probe,
-	.remove		= w100fb_remove,
+	.remove		= __devexit_p(w100fb_remove),
 	.suspend	= w100fb_suspend,
 	.resume		= w100fb_resume,
 	.driver		= {
@@ -1618,7 +1618,7 @@ static struct platform_driver w100fb_driver = {
 	},
 };
 
-int __devinit w100fb_init(void)
+int __init w100fb_init(void)
 {
 	return platform_driver_register(&w100fb_driver);
 }
-- 
1.7.0

