Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0JTSWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:22:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32831 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752065Ab0JTSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:22:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] driver core: Display error codes when class suspend fails
Date: Wed, 20 Oct 2010 11:22:42 -0700
Message-Id: <1287598962-28013-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aid diagnostics by printing the error code from failed suspends, which
doesn't otherwise seem to get displayed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/sys.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 9354dc1..1667aaf 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -432,13 +432,13 @@ int sysdev_suspend(pm_message_t state)
 	/* resume current sysdev */
 cls_driver:
 	drv = NULL;
-	printk(KERN_ERR "Class suspend failed for %s\n",
-		kobject_name(&sysdev->kobj));
+	printk(KERN_ERR "Class suspend failed for %s: %d\n",
+		kobject_name(&sysdev->kobj), ret);
 
 aux_driver:
 	if (drv)
-		printk(KERN_ERR "Class driver suspend failed for %s\n",
-				kobject_name(&sysdev->kobj));
+		printk(KERN_ERR "Class driver suspend failed for %s: %d\n",
+				kobject_name(&sysdev->kobj), ret);
 	list_for_each_entry(err_drv, &cls->drivers, entry) {
 		if (err_drv == drv)
 			break;
-- 
1.7.1

