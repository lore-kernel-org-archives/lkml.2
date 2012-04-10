Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab2DJOGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:06:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45698 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab2DJOGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:06:39 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <santoshsy@gmail.com>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Venkatraman S <svenkatr@ti.com>
Subject: [PATCH] scsi/ufs: use module_pci_driver
Date: Tue, 10 Apr 2012 19:36:11 +0530
Message-ID: <1334066771-10458-1-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macro module_pci_driver and get rid of boilerplate code.
No functional changes.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 drivers/scsi/ufs/ufshcd.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cd59f6f..5ab9b3f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1952,24 +1952,7 @@ static struct pci_driver ufshcd_pci_driver = {
 #endif
 };
 
-/**
- * ufshcd_init - Driver registration routine
- */
-static int __init ufshcd_init(void)
-{
-	return pci_register_driver(&ufshcd_pci_driver);
-}
-module_init(ufshcd_init);
-
-/**
- * ufshcd_exit - Driver exit clean-up routine
- */
-static void __exit ufshcd_exit(void)
-{
-	pci_unregister_driver(&ufshcd_pci_driver);
-}
-module_exit(ufshcd_exit);
-
+module_pci_driver(ufshcd_pci_driver);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>, "
 	      "Vinayak Holikatti <h.vinayak@samsung.com>");
-- 
1.7.10.rc2

