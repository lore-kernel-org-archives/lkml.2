Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1GGMnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:43:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:25124 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab1GGMnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,493,1304319600"; 
   d="scan'208";a="24903964"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: tomas.winkler@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 1/9] staging: mei: reordering the exit module cleanup
Date: Thu,  7 Jul 2011 15:43:22 +0300
Message-Id: <1310042602-12210-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keeping the exit flow in a reverse order then the init flow.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index 8341a78..de8825f 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -1326,9 +1326,9 @@ module_init(mei_init_module);
  */
 static void __exit mei_exit_module(void)
 {
-	pci_unregister_driver(&mei_driver);
 	mei_sysfs_device_remove();
 	mei_unregister_cdev();
+	pci_unregister_driver(&mei_driver);
 
 	pr_debug("mei: Driver unloaded successfully.\n");
 }
-- 
1.7.1

