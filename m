Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab2GKNu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:50:28 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:64298 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932574Ab2GKNuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFJ1IQIDE8GwcSiBG9V5EuA5U6iSaGYIJh
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808128"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 3/9] staging: sm7xxfb: rename smtc_screen_info to smtc_scr_info
Date: Wed, 11 Jul 2012 15:49:35 +0200
Message-Id: <1342014581-2979-4-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This change of name improves readability on sm712_vga_setup and
smtcfb_pci_probe. It is coherent with the name of vars being used on
code while avoiding the use of extra long lines in functions.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 88d4b79..d7d37bd 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -34,7 +34,7 @@
 
 #include "sm7xx.h"
 
-struct screen_info smtc_screen_info;
+struct screen_info smtc_scr_info;
 
 /*
 * Private structure
@@ -769,20 +769,17 @@ static int __init sm712vga_setup(char *options)
 	if (!options || !*options)
 		return -EINVAL;
 
-	smtc_screen_info.lfb_width = 0;
-	smtc_screen_info.lfb_height = 0;
-	smtc_screen_info.lfb_depth = 0;
+	smtc_scr_info.lfb_width = 0;
+	smtc_scr_info.lfb_height = 0;
+	smtc_scr_info.lfb_depth = 0;
 
 	pr_debug("sm712vga_setup = %s\n", options);
 
 	for (i = 0; i < ARRAY_SIZE(vesa_mode_table); i++) {
 		if (strstr(options, vesa_mode_table[i].index)) {
-			smtc_screen_info.lfb_width =
-				vesa_mode_table[i].lfb_width;
-			smtc_screen_info.lfb_height =
-				vesa_mode_table[i].lfb_height;
-			smtc_screen_info.lfb_depth =
-				vesa_mode_table[i].lfb_depth;
+			smtc_scr_info.lfb_width  = vesa_mode_table[i].lfb_width;
+			smtc_scr_info.lfb_height = vesa_mode_table[i].lfb_height;
+			smtc_scr_info.lfb_depth  = vesa_mode_table[i].lfb_depth;
 			return 0;
 		}
 	}
@@ -818,11 +815,11 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	sm7xx_init_hw();
 
-	/*get mode parameter from smtc_screen_info */
-	if (smtc_screen_info.lfb_width != 0) {
-		sfb->fb.var.xres = smtc_screen_info.lfb_width;
-		sfb->fb.var.yres = smtc_screen_info.lfb_height;
-		sfb->fb.var.bits_per_pixel = smtc_screen_info.lfb_depth;
+	/* get mode parameter from smtc_scr_info */
+	if (smtc_scr_info.lfb_width != 0) {
+		sfb->fb.var.xres = smtc_scr_info.lfb_width;
+		sfb->fb.var.yres = smtc_scr_info.lfb_height;
+		sfb->fb.var.bits_per_pixel = smtc_scr_info.lfb_depth;
 	} else {
 		/* default resolution 1024x600 16bit mode */
 		sfb->fb.var.xres = SCREEN_X_RES;
-- 
1.7.10

