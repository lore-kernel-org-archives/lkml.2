Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab2E2NjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:39:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:55463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab2E2NjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:39:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158216606"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        devel@linuxdriverproject.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/4] misc: mei: unregister misc device in pci_remove function
Date: Tue, 29 May 2012 16:39:11 +0300
Message-Id: <1338298752-15445-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
References: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the misc device is registered only in the pci probe function
it has to be also unregistered in the counterpart pci remove function
and not in the module exit function.
In case of probe failure the driver was oopsing in module exit function.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 88e5953..a5a17e7 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -1101,6 +1101,8 @@ static void __devexit mei_remove(struct pci_dev *pdev)
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+
+	misc_deregister(&mei_misc_device);
 }
 #ifdef CONFIG_PM
 static int mei_pci_suspend(struct device *device)
@@ -1216,7 +1218,6 @@ module_init(mei_init_module);
  */
 static void __exit mei_exit_module(void)
 {
-	misc_deregister(&mei_misc_device);
 	pci_unregister_driver(&mei_driver);
 
 	pr_debug("unloaded successfully.\n");
-- 
1.7.4.4

