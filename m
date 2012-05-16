Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967391Ab2EPFOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:14:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966201Ab2EPFOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:14:03 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-79-4fb33797c751
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Marcin Juszkiewicz'" <openembedded@haerwu.biz>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 7/7] backlight: progear: use pr_err instead of printk
Date: Wed, 16 May 2012 14:13:59 +0900
Message-id: <002501cd3322$b3675250$1a35f6f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zIrNMKFrhKC2BSqCaX/71zWiwBw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_err instead of printk to allow dynamic debugging.
The pr_fmt prefix for pr_ macros is used. It also fixes checkpatch
warnings as below:

WARNING: printk() should include KERN_ facility level

Cc: Marcin Juszkiewicz <openembedded@haerwu.biz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/progear_bl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 6af183d..e176147 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) "progear_bl: " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -68,13 +70,13 @@ static int progearbl_probe(struct platform_device *pdev)
 
 	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, NULL);
 	if (!pmu_dev) {
-		printk("ALI M7101 PMU not found.\n");
+		pr_err("ALI M7101 PMU not found.\n");
 		return -ENODEV;
 	}
 
 	sb_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 	if (!sb_dev) {
-		printk("ALI 1533 SB not found.\n");
+		pr_err("ALI 1533 SB not found.\n");
 		ret = -ENODEV;
 		goto put_pmu;
 	}
-- 
1.7.1


