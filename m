Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2GJGkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:40:13 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58971 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2GJGkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:40:11 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/6] staging/sbe-2t3e3: use module_pci_driver macro
Date: Tue, 10 Jul 2012 12:10:04 +0530
Message-Id: <1341902404-21979-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the _init and _exit functions do nothing but pci_register_driver,
and pci_unregister_driver,

so replace these and also the module _init and _exit
macros with the module_pci_driver macro.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/sbe-2t3e3/module.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/module.c b/drivers/staging/sbe-2t3e3/module.c
index e87fe81..cd778b3 100644
--- a/drivers/staging/sbe-2t3e3/module.c
+++ b/drivers/staging/sbe-2t3e3/module.c
@@ -194,17 +194,6 @@ static struct pci_driver t3e3_pci_driver = {
 	.remove   = t3e3_remove_card,
 };
 
-static int __init t3e3_init_module(void)
-{
-	return pci_register_driver(&t3e3_pci_driver);
-}
-
-static void __exit t3e3_cleanup_module(void)
-{
-	pci_unregister_driver(&t3e3_pci_driver);
-}
-
-module_init(t3e3_init_module);
-module_exit(t3e3_cleanup_module);
+module_pci_driver(t3e3_pci_driver);
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, t3e3_pci_tbl);
-- 
1.7.9.5

