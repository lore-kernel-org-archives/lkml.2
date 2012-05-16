Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab2EPIKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:10:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56096 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab2EPIK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:10:27 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-7f-4fb360f250e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v3 4/7] backlight: generic_bl: use pr_info instead of printk
Date: Wed, 16 May 2012 17:10:25 +0900
Message-id: <003701cd333b$59737bc0$0c5a7340$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0zO1lgf3+dFHpEQAiEjpvnpoMXrQ==
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
index 9ce6170..8c660fc 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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


