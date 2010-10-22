Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0JVSZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:53 -0400
Received: from kroah.org ([198.145.64.141]:37862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758986Ab0JVSZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/31] driver core: Display error codes when class suspend fails
Date: Fri, 22 Oct 2010 11:25:16 -0700
Message-Id: <1287771916-15016-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Aid diagnostics by printing the error code from failed suspends, which
doesn't otherwise seem to get displayed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

