Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2GKNwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:52:03 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:40949 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757478Ab2GKNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFeRAgMTwbBxKIEb1XkS4DlTqJJoZggmE
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808132"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 4/9] staging: sm7xxfb: rename sm712vga_setup to sm7xx_vga_setup
Date: Wed, 11 Jul 2012 15:49:36 +0200
Message-Id: <1342014581-2979-5-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch renames sm712vga_setup to sm7xx_vga_setup. sm7xx_vga_setup
process command line options in order to get the vga parameter. This
parameter will be the lookup index to match the right vesa mode. It is
chip independent.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index d7d37bd..7a597fd 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -756,13 +756,8 @@ static inline void sm7xx_init_hw(void)
 	outb_p(0x11, 0x3c5);
 }
 
-/*
- *	sm712vga_setup - process command line options, get vga parameter
- *	@options: string of options
- *	Returns zero.
- *
- */
-static int __init sm712vga_setup(char *options)
+/* process command line options, get vga parameter */
+static int __init sm7xx_vga_setup(char *options)
 {
 	int i;
 
@@ -773,7 +768,7 @@ static int __init sm712vga_setup(char *options)
 	smtc_scr_info.lfb_height = 0;
 	smtc_scr_info.lfb_depth = 0;
 
-	pr_debug("sm712vga_setup = %s\n", options);
+	pr_debug("sm7xx_vga_setup = %s\n", options);
 
 	for (i = 0; i < ARRAY_SIZE(vesa_mode_table); i++) {
 		if (strstr(options, vesa_mode_table[i].index)) {
@@ -786,7 +781,7 @@ static int __init sm712vga_setup(char *options)
 
 	return -1;
 }
-__setup("vga=", sm712vga_setup);
+__setup("vga=", sm7xx_vga_setup);
 
 static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
-- 
1.7.10

