Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2DCB7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:59:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64584 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2DCB7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:59:50 -0400
Message-ID: <1333418384.18133.6.camel@phoenix>
Subject: [PATCH] mtd: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Lowe <alowe@mvista.com>, Russell King <rmk@arm.linux.org.uk>,
        Tim Hockin <thockin@sun.com>, Maxim Levitsky <maximlevitsky@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Date: Tue, 03 Apr 2012 09:59:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/mtd/* to use module_pci_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Andy Lowe <alowe@mvista.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Tim Hockin <thockin@sun.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/maps/intel_vr_nor.c |   13 +------------
 drivers/mtd/maps/pci.c          |   13 +------------
 drivers/mtd/maps/scb2_flash.c   |   15 +--------------
 drivers/mtd/nand/cafe_nand.c    |   12 +-----------
 drivers/mtd/nand/denali.c       |   15 +--------------
 drivers/mtd/nand/r852.c         |   13 +------------
 6 files changed, 6 insertions(+), 75 deletions(-)

diff --git a/drivers/mtd/maps/intel_vr_nor.c b/drivers/mtd/maps/intel_vr_nor.c
index 92e1f41..93f0317 100644
--- a/drivers/mtd/maps/intel_vr_nor.c
+++ b/drivers/mtd/maps/intel_vr_nor.c
@@ -260,18 +260,7 @@ static struct pci_driver vr_nor_pci_driver = {
 	.id_table = vr_nor_pci_ids,
 };
 
-static int __init vr_nor_mtd_init(void)
-{
-	return pci_register_driver(&vr_nor_pci_driver);
-}
-
-static void __exit vr_nor_mtd_exit(void)
-{
-	pci_unregister_driver(&vr_nor_pci_driver);
-}
-
-module_init(vr_nor_mtd_init);
-module_exit(vr_nor_mtd_exit);
+module_pci_driver(vr_nor_pci_driver);
 
 MODULE_AUTHOR("Andy Lowe");
 MODULE_DESCRIPTION("MTD map driver for NOR flash on Intel Vermilion Range");
diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index 1d005a3..f14ce0a 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -352,18 +352,7 @@ static struct pci_driver mtd_pci_driver = {
 	.id_table =	mtd_pci_ids,
 };
 
-static int __init mtd_pci_maps_init(void)
-{
-	return pci_register_driver(&mtd_pci_driver);
-}
-
-static void __exit mtd_pci_maps_exit(void)
-{
-	pci_unregister_driver(&mtd_pci_driver);
-}
-
-module_init(mtd_pci_maps_init);
-module_exit(mtd_pci_maps_exit);
+module_pci_driver(mtd_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
diff --git a/drivers/mtd/maps/scb2_flash.c b/drivers/mtd/maps/scb2_flash.c
index 934a72c..9dcbc68 100644
--- a/drivers/mtd/maps/scb2_flash.c
+++ b/drivers/mtd/maps/scb2_flash.c
@@ -234,20 +234,7 @@ static struct pci_driver scb2_flash_driver = {
 	.remove =   __devexit_p(scb2_flash_remove),
 };
 
-static int __init
-scb2_flash_init(void)
-{
-	return pci_register_driver(&scb2_flash_driver);
-}
-
-static void __exit
-scb2_flash_exit(void)
-{
-	pci_unregister_driver(&scb2_flash_driver);
-}
-
-module_init(scb2_flash_init);
-module_exit(scb2_flash_exit);
+module_pci_driver(scb2_flash_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tim Hockin <thockin@sun.com>");
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 2a96e1a..2973d97 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -888,17 +888,7 @@ static struct pci_driver cafe_nand_pci_driver = {
 	.resume = cafe_nand_resume,
 };
 
-static int __init cafe_nand_init(void)
-{
-	return pci_register_driver(&cafe_nand_pci_driver);
-}
-
-static void __exit cafe_nand_exit(void)
-{
-	pci_unregister_driver(&cafe_nand_pci_driver);
-}
-module_init(cafe_nand_init);
-module_exit(cafe_nand_exit);
+module_pci_driver(cafe_nand_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index a9e57d6..a1048c7 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1702,17 +1702,4 @@ static struct pci_driver denali_pci_driver = {
 	.remove = denali_pci_remove,
 };
 
-static int __devinit denali_init(void)
-{
-	printk(KERN_INFO "Spectra MTD driver\n");
-	return pci_register_driver(&denali_pci_driver);
-}
-
-/* Free memory */
-static void __devexit denali_exit(void)
-{
-	pci_unregister_driver(&denali_pci_driver);
-}
-
-module_init(denali_init);
-module_exit(denali_exit);
+module_pci_driver(denali_pci_driver);
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index c204018..859ef31 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -1104,18 +1104,7 @@ static struct pci_driver r852_pci_driver = {
 	.driver.pm	= &r852_pm_ops,
 };
 
-static __init int r852_module_init(void)
-{
-	return pci_register_driver(&r852_pci_driver);
-}
-
-static void __exit r852_module_exit(void)
-{
-	pci_unregister_driver(&r852_pci_driver);
-}
-
-module_init(r852_module_init);
-module_exit(r852_module_exit);
+module_pci_driver(r852_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Maxim Levitsky <maximlevitsky@gmail.com>");
-- 
1.7.5.4



