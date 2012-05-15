Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab2EOHyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:54:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55263 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab2EOHyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:54:00 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-bc-4fb20b8c8630
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 3/7] backlight: cr_bllcd.c: use pr_err/info instead of printk
Date: Tue, 15 May 2012 16:53:48 +0900
Message-id: <000e01cd326f$dc652ff0$952f8fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0yb9xNTAxFLgnYRJ2Xf2jeiEgmgw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_err/info instead of printk to allow dynamic debugging.
It also fixes checkpatch warnings as below:

WARNING: printk() should include KERN_ facility level
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/cr_bllcd.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index 22489eb..4c08381 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -180,14 +180,13 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	lpc_dev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					CRVML_DEVICE_LPC, NULL);
 	if (!lpc_dev) {
-		printk("INTEL CARILLO RANCH LPC not found.\n");
+		pr_err("INTEL CARILLO RANCH LPC not found.\n");
 		return -ENODEV;
 	}
 
 	pci_read_config_byte(lpc_dev, CRVML_REG_GPIOEN, &dev_en);
 	if (!(dev_en & CRVML_GPIOEN_BIT)) {
-		printk(KERN_ERR
-		       "Carillo Ranch GPIO device was not enabled.\n");
+		pr_err("Carillo Ranch GPIO device was not enabled.\n");
 		pci_dev_put(lpc_dev);
 		return -ENODEV;
 	}
@@ -270,7 +269,7 @@ static int __init cr_backlight_init(void)
 		return PTR_ERR(crp);
 	}
 
-	printk("Carillo Ranch Backlight Driver Initialized.\n");
+	pr_info("Carillo Ranch Backlight Driver Initialized.\n");
 
 	return 0;
 }
-- 
1.7.1


