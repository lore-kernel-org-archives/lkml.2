Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1CMK0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:26:52 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39909 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1CMK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:21 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 07/24] staging: xgifb: delete unused LINUXBIOS code
Date: Sun, 13 Mar 2011 12:26:11 +0200
Message-Id: <1300011988-2109-8-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused LINUXBIOS code.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    2 --
 drivers/staging/xgifb/XGI_main_26.c |   27 ---------------------------
 2 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index b27623a..a014405 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -9,8 +9,6 @@
 #include "vb_struct.h"
 #include "vb_def.h"
 
-//#define LINUXBIOS   /* turn this on when compiling for LINUXBIOS */
-
 #define XGIFAIL(x) do { printk(x "\n"); return -EINVAL; } while(0)
 
 #define VER_MAJOR                 0
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ed0d554..79ff4df 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2265,34 +2265,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		/* Mapping Max FB Size for 315 Init */
 		XGIhw_ext.pjVideoMemoryAddress = ioremap(xgi_video_info.video_base, 0x10000000);
 		if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
-#ifdef LINUXBIOS
-			printk("XGIfb: XGIInit() ...");
-			/* XGIInitNewt for LINUXBIOS only */
-			if (XGIInitNew(&XGIhw_ext))
-				printk("OK\n");
-			else
-				printk("Fail\n");
-#endif
-
 			outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
 
 		}
 	}
-#ifdef LINUXBIOS
-	else {
-		XGIhw_ext.pjVideoMemoryAddress = ioremap(xgi_video_info.video_base, 0x10000000);
-		if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
-
-			outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
-
-			/* yilin Because no VBIOS DRAM Sizing, Dram size will error. */
-			/* Set SR13 ,14 temporarily for UDtech */
-			outXGIIDXREG(XGISR, 0x13, 0x45);
-			outXGIIDXREG(XGISR, 0x14, 0x51);
-
-		}
-	}
-#endif
 	if (XGIfb_get_dram_size()) {
 		printk(KERN_INFO "XGIfb: Fatal error: Unable to determine RAM size.\n");
 		ret = -ENODEV;
@@ -2459,7 +2435,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		XGIfb_detectedpdc = 0;
 
 		XGIfb_detectedlcda = 0xff;
-#ifndef LINUXBIOS
 
 		/* TW: Try to find about LCDA */
 
@@ -2492,8 +2467,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		}
 
-#endif
-
 		if (xgifb_mode_idx >= 0)
 			xgifb_mode_idx = XGIfb_validate_mode(xgifb_mode_idx);
 
-- 
1.5.6.5

