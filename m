Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2GQIX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:23:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:37787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab2GQIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="167311430"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: use module_pci_driver
Date: Tue, 17 Jul 2012 11:23:46 +0300
Message-Id: <1342513427-10076-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |   39 +--------------------------------------
 1 files changed, 1 insertions(+), 38 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 0d98c2e..0923302 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -1182,44 +1182,7 @@ static struct pci_driver mei_driver = {
 	.driver.pm = MEI_PM_OPS,
 };
 
-/**
- * mei_init_module - Driver Registration Routine
- *
- * mei_init_module is the first routine called when the driver is
- * loaded. All it does is to register with the PCI subsystem.
- *
- * returns 0 on success, <0 on failure.
- */
-static int __init mei_init_module(void)
-{
-	int ret;
-
-	pr_debug("loading.\n");
-	/* init pci module */
-	ret = pci_register_driver(&mei_driver);
-	if (ret < 0)
-		pr_err("error registering driver.\n");
-
-	return ret;
-}
-
-module_init(mei_init_module);
-
-/**
- * mei_exit_module - Driver Exit Cleanup Routine
- *
- * mei_exit_module is called just before the driver is removed
- * from memory.
- */
-static void __exit mei_exit_module(void)
-{
-	pci_unregister_driver(&mei_driver);
-
-	pr_debug("unloaded successfully.\n");
-}
-
-module_exit(mei_exit_module);
-
+module_pci_driver(mei_driver);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
-- 
1.7.4.4

