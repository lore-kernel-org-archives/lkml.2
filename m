Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2JPO7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:59:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:2900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab2JPO7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:59:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235797812"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Viresh Kumar <viresh.linux@gmail.com>, linux-ide@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 1/5] ata: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP
Date: Tue, 16 Oct 2012 22:59:01 +0800
Message-Id: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will fix warnings like following when CONFIG_PM_SLEEP is not set:

        warning: 'xxx_suspend' defined but not used [-Wunused-function]
        warning: 'xxx_resume' defined but not used [-Wunused-function]

Because
	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)

Only references the callbacks on CONFIG_PM_SLEEP (instead of CONFIG_PM).

Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: linux-ide@vger.kernel.org
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/ata/ahci_platform.c  |    2 +-
 drivers/ata/pata_arasan_cf.c |    2 +-
 drivers/ata/sata_highbank.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index b1ae480..b7078af 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -238,7 +238,7 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ahci_suspend(struct device *dev)
 {
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 26201eb..3fe2f66 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -908,7 +908,7 @@ static int __devexit arasan_cf_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int arasan_cf_suspend(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 0d7c4c2..b045b19 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -378,7 +378,7 @@ static int __devexit ahci_highbank_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ahci_highbank_suspend(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
-- 
1.7.7.6

