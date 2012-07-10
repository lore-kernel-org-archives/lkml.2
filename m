Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2GJGl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:41:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49688 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2GJGlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:41:55 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 3/6] staging/sep: use module_pci_driver macro
Date: Tue, 10 Jul 2012 12:11:48 +0530
Message-Id: <1341902508-22314-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this driver duplicates the module_pci_driver code, so remove the
duplicated code and use module_pci_driver and also remove the
obvious comments about _init and _exit.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/sep/sep_main.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 270fcb8..205d0df 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -4492,30 +4492,5 @@ static struct pci_driver sep_pci_driver = {
 	.remove = sep_remove
 };
 
-/**
- * sep_init - init function
- *
- * Module load time. Register the PCI device driver.
- */
-
-static int __init sep_init(void)
-{
-	return pci_register_driver(&sep_pci_driver);
-}
-
-
-/**
- * sep_exit - called to unload driver
- *
- * Unregister the driver The device will perform all the cleanup required.
- */
-static void __exit sep_exit(void)
-{
-	pci_unregister_driver(&sep_pci_driver);
-}
-
-
-module_init(sep_init);
-module_exit(sep_exit);
-
+module_pci_driver(sep_pci_driver);
 MODULE_LICENSE("GPL");
-- 
1.7.9.5

