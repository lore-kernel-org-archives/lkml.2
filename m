Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2DZSsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:48:12 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52353 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2DZSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQV5EFEhGxsHEod/Aw+xGA2JU4oChmMElX2LPYUDgmqBUhY
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960569"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 1/7] staging: sm7xx: remove old references and non updated comments
Date: Thu, 26 Apr 2012 20:45:49 +0200
Message-Id: <1335465955-32057-2-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes obsolete references to previous code and non updated
comments.

Tested with SM712

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |   44 +++++++--------------------------------
 1 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 83c582e..39ba558 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -2,31 +2,19 @@
  * Silicon Motion SM7XX frame buffer device
  *
  * Copyright (C) 2006 Silicon Motion Technology Corp.
- * Authors: Ge Wang, gewang@siliconmotion.com
- *	    Boyod boyod.yang@siliconmotion.com.cn
+ * Authors:  Ge Wang, gewang@siliconmotion.com
+ *	     Boyod boyod.yang@siliconmotion.com.cn
  *
  * Copyright (C) 2009 Lemote, Inc.
- * Author: Wu Zhangjin, wuzhangjin@gmail.com
+ * Author:   Wu Zhangjin, wuzhangjin@gmail.com
  *
  * Copyright (C) 2011 Igalia, S.L.
- * Author: Javier M. Mellid <jmunhoz@igalia.com>
+ * Author:   Javier M. Mellid <jmunhoz@igalia.com>
  *
- *  This file is subject to the terms and conditions of the GNU General Public
- *  License. See the file COPYING in the main directory of this archive for
- *  more details.
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file COPYING in the main directory of this archive for
+ * more details.
  *
- * Version 0.10.26192.21.01
- *	- Add PowerPC/Big endian support
- *	- Verified on 2.6.19.2
- *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
- *
- * Version 0.09.2621.00.01
- *	- Only support Linux Kernel's version 2.6.21
- *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
- *
- * Version 0.09
- *	- Only support Linux Kernel's version 2.6.12
- *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  */
 
 #include <linux/io.h>
@@ -57,12 +45,6 @@ struct screen_info smtc_screen_info;
 * Private structure
 */
 struct smtcfb_info {
-	/*
-	 * The following is a pointer to be passed into the
-	 * functions below.  The modules outside the main
-	 * voyager.c driver have no knowledge as to what
-	 * is within this structure.
-	 */
 	struct fb_info fb;
 	struct display_switch *dispsw;
 	struct pci_dev *dev;
@@ -858,10 +840,6 @@ static int __init sm712vga_setup(char *options)
 }
 __setup("vga=", sm712vga_setup);
 
-/* Jason (08/13/2009)
- * Original init function changed to probe method to be used by pci_drv
- * process used to detect chips replaced with kernel process in pci_drv
- */
 static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
@@ -885,9 +863,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	if (!sfb)
 		goto failed_free;
-	/* Jason (08/13/2009)
-	 * Store fb_info to be further used when suspending and resuming
-	 */
+
 	pci_set_drvdata(pdev, sfb);
 
 	sm7xx_init_hw();
@@ -1021,7 +997,6 @@ failed_free:
 }
 
 
-/* Jason (08/11/2009) PCI_DRV wrapper essential structs */
 static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
 	{ PCI_DEVICE(0x126f, 0x710), },
 	{ PCI_DEVICE(0x126f, 0x712), },
@@ -1030,9 +1005,6 @@ static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
 };
 
 
-/* Jason (08/14/2009)
- * do some clean up when the driver module is removed
- */
 static void __devexit smtcfb_pci_remove(struct pci_dev *pdev)
 {
 	struct smtcfb_info *sfb;
-- 
1.7.2.5

