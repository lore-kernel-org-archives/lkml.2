Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2HZJCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:02:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39515 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2HZJCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:02:52 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Alex Dubov <oakad@yahoo.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [char-misc-next] tifm: use module_pci_driver
Date: Sun, 26 Aug 2012 14:32:43 +0530
Message-Id: <1345971763-13144-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tifm_7xx1_init and tifm_7xx1_exit with module_init and module_exit calls
can be replaced with the module_pci_driver call, as they are similar
to what module_pci_driver does

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/misc/tifm_7xx1.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index ba24790..f8d66543 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -434,21 +434,9 @@ static struct pci_driver tifm_7xx1_driver = {
 	.resume = tifm_7xx1_resume,
 };
 
-static int __init tifm_7xx1_init(void)
-{
-	return pci_register_driver(&tifm_7xx1_driver);
-}
-
-static void __exit tifm_7xx1_exit(void)
-{
-	pci_unregister_driver(&tifm_7xx1_driver);
-}
-
+module_pci_driver(tifm_7xx1_driver);
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("TI FlashMedia host driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, tifm_7xx1_pci_tbl);
 MODULE_VERSION(DRIVER_VERSION);
-
-module_init(tifm_7xx1_init);
-module_exit(tifm_7xx1_exit);
-- 
1.7.9.5

