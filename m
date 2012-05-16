Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967333Ab2EPFL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:11:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22651 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966201Ab2EPFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:11:28 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-0c-4fb336ff7021
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 4/7] backlight: generic_bl: use pr_info instead of printk
Date: Wed, 16 May 2012 14:11:27 +0900
Message-id: <002201cd3322$58b53e30$0a1fba90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zIlijX8xRfeYnTRCSxNRxn9/jRw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_info instead of printk to allow dynamic debugging.
The pr_fmt prefix for pr_ macros is used. It also fixes checkpatch
warnings as below:

WARNING: printk() should include KERN_ facility level

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/generic_bl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 9ce6170..96437e6 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "generic_bl: " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -106,7 +108,7 @@ static int genericbl_probe(struct platform_device *pdev)
 
 	generic_backlight_device = bd;
 
-	printk("Generic Backlight Driver Initialized.\n");
+	pr_info("Generic Backlight Driver Initialized.\n");
 	return 0;
 }
 
@@ -120,7 +122,7 @@ static int genericbl_remove(struct platform_device *pdev)
 
 	backlight_device_unregister(bd);
 
-	printk("Generic Backlight Driver Unloaded\n");
+	pr_info("Generic Backlight Driver Unloaded\n");
 	return 0;
 }
 
-- 
1.7.1


