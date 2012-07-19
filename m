Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2GSGpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 02:45:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:31047 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2GSGpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 02:45:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170234820"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next V2] mei: use module_pci_driver
Date: Thu, 19 Jul 2012 09:45:32 +0300
Message-Id: <1342680332-4814-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_pci_driver() macro to wrap standard
pci module registration into a single line

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: verboser commit message
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

