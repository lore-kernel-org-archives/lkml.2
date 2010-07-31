Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0GaUzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 16:55:49 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41808 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756692Ab0GaUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 16:55:44 -0400
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/3] cyber2000fb: add mode_option parameter
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Sat, 31 Jul 2010 22:55:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007312255.40036.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mode_option parameter to specify the default video mode.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc3-/drivers/video/cyber2000fb.c	2010-07-25 21:28:33.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-25 20:36:49.000000000 +0200
@@ -94,6 +94,10 @@ static char *default_font = "Acorn8x8";
 module_param(default_font, charp, 0);
 MODULE_PARM_DESC(default_font, "Default font name");
 
+static char *mode_option __devinitdata = "640x480-8@60";
+module_param(mode_option, charp, 0444);
+MODULE_PARM_DESC(mode_option, "Default video mode ('640x480-8@60', etc)");
+
 /*
  * Our access methods.
  */
@@ -1368,7 +1372,7 @@ static int __devinit cyberpro_common_pro
 	cfb->fb.screen_base    = cfb->region;
 
 	err = -EINVAL;
-	if (!fb_find_mode(&cfb->fb.var, &cfb->fb, NULL, NULL, 0,
+	if (!fb_find_mode(&cfb->fb.var, &cfb->fb, mode_option, NULL, 0,
 			  &cyber2000fb_default_mode, 8)) {
 		printk(KERN_ERR "%s: no valid mode found\n", cfb->fb.fix.id);
 		goto failed;

-- 
Ondrej Zary
