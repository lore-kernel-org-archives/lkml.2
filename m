Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2EOH5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:57:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30494 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab2EOH5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:57:40 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-45-4fb20c73eac0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Marcin Juszkiewicz'" <openembedded@hrw.one.pl>
Subject: [PATCH 7/7] backlight: progear: use pr_err instead of printk
Date: Tue, 15 May 2012 16:57:39 +0900
Message-id: <001201cd3270$65f4cb40$31de61c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0ycGXacd5KZG1ySNWbjAAX+wpeOA==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_err instead of printk to allow dynamic debugging.

It also fixes checkpatch warnings as below:
WARNING: printk() should include KERN_ facility level

Cc: Marcin Juszkiewicz <openembedded@hrw.one.pl>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/progear_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 6af183d..cd1e0dc 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -68,13 +68,13 @@ static int progearbl_probe(struct platform_device *pdev)
 
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


