Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab2DJB5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:57:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61584 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2DJB5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:57:02 -0400
Message-ID: <1334023011.16328.1.camel@phoenix>
Subject: [PATCH] mmc: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <pierre@ossman.eu>,
        Shashidhar Hiremath <shashidharh@vayavyalabs.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Date: Tue, 10 Apr 2012 09:56:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/mmc/host/* to use module_pci_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mmc/host/dw_mmc-pci.c |   13 +------------
 drivers/mmc/host/sdhci-pci.c  |   19 +------------------
 2 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-pci.c b/drivers/mmc/host/dw_mmc-pci.c
index dc0d25a..f5ab03d 100644
--- a/drivers/mmc/host/dw_mmc-pci.c
+++ b/drivers/mmc/host/dw_mmc-pci.c
@@ -140,18 +140,7 @@ static struct pci_driver dw_mci_pci_driver = {
 	},
 };
 
-static int __init dw_mci_init(void)
-{
-	return pci_register_driver(&dw_mci_pci_driver);
-}
-
-static void __exit dw_mci_exit(void)
-{
-	pci_unregister_driver(&dw_mci_pci_driver);
-}
-
-module_init(dw_mci_init);
-module_exit(dw_mci_exit);
+module_pci_driver(dw_mci_pci_driver);
 
 MODULE_DESCRIPTION("DW Multimedia Card PCI Interface driver");
 MODULE_AUTHOR("Shashidhar Hiremath <shashidharh@vayavyalabs.com>");
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 69ef0be..baed1f1 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1475,24 +1475,7 @@ static struct pci_driver sdhci_driver = {
 	},
 };
 
-/*****************************************************************************\
- *                                                                           *
- * Driver init/exit                                                          *
- *                                                                           *
-\*****************************************************************************/
-
-static int __init sdhci_drv_init(void)
-{
-	return pci_register_driver(&sdhci_driver);
-}
-
-static void __exit sdhci_drv_exit(void)
-{
-	pci_unregister_driver(&sdhci_driver);
-}
-
-module_init(sdhci_drv_init);
-module_exit(sdhci_drv_exit);
+module_pci_driver(sdhci_driver);
 
 MODULE_AUTHOR("Pierre Ossman <pierre@ossman.eu>");
 MODULE_DESCRIPTION("Secure Digital Host Controller Interface PCI driver");
-- 
1.7.5.4



