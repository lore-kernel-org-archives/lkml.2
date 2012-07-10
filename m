Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2GJGqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:46:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53142 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2GJGqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:46:37 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 6/6] staging/phison: use module_pci_driver macro
Date: Tue, 10 Jul 2012 12:16:30 +0530
Message-Id: <1341902790-22631-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the duplication of module_pci_driver and use this macro instead

module_pci_driver macro does the same things as the code below does

static int __init pci_test_dev_init(void)
{
       return pci_register_driver(&pci_test_driver_ops);
}

static void __exit pci_test_dev_exit(void)
{
       pci_unregister_driver(&pci_test_driver_ops);
}

module_init(pci_test_dev_init);
module_exit(pci_test_dev_exit);

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/phison/phison.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index d77b21f..919cb95 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -87,18 +87,7 @@ static struct pci_driver phison_pci_driver = {
 #endif
 };
 
-static int __init phison_ide_init(void)
-{
-	return pci_register_driver(&phison_pci_driver);
-}
-
-static void __exit phison_ide_exit(void)
-{
-	pci_unregister_driver(&phison_pci_driver);
-}
-
-module_init(phison_ide_init);
-module_exit(phison_ide_exit);
+module_pci_driver(phison_pci_driver);
 
 MODULE_AUTHOR("Evan Ko");
 MODULE_DESCRIPTION("PCIE driver module for PHISON PS5000 E-BOX");
-- 
1.7.9.5

