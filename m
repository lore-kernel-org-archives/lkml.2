Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2DSFnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:43:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46735 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2DSFnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:43:16 -0400
Message-ID: <1334814185.11861.1.camel@phoenix>
Subject: [PATCH] ata: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Mark Lord <kernel@teksavvy.com>,
        Jeremy Higdon <jeremy@sgi.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-ide@vger.kernel.org
Date: Thu, 19 Apr 2012 13:43:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/ata/* to use module_pci_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Mark Lord <kernel@teksavvy.com>
Cc: Jeremy Higdon <jeremy@sgi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/ata/acard-ahci.c        |   13 +------------
 drivers/ata/ahci.c              |   14 +-------------
 drivers/ata/ata_generic.c       |   15 +--------------
 drivers/ata/pata_acpi.c         |   14 +-------------
 drivers/ata/pata_amd.c          |   13 +------------
 drivers/ata/pata_artop.c        |   13 +------------
 drivers/ata/pata_atiixp.c       |   14 +-------------
 drivers/ata/pata_atp867x.c      |   13 +------------
 drivers/ata/pata_cmd640.c       |   13 +------------
 drivers/ata/pata_cmd64x.c       |   13 +------------
 drivers/ata/pata_cs5520.c       |   14 +-------------
 drivers/ata/pata_cs5530.c       |   13 +------------
 drivers/ata/pata_cs5535.c       |   13 +------------
 drivers/ata/pata_cs5536.c       |   13 +------------
 drivers/ata/pata_cypress.c      |   15 +--------------
 drivers/ata/pata_efar.c         |   14 +-------------
 drivers/ata/pata_hpt366.c       |   13 +------------
 drivers/ata/pata_hpt37x.c       |   13 +------------
 drivers/ata/pata_hpt3x2n.c      |   13 +------------
 drivers/ata/pata_hpt3x3.c       |   15 +--------------
 drivers/ata/pata_it8213.c       |   13 +------------
 drivers/ata/pata_it821x.c       |   14 +-------------
 drivers/ata/pata_jmicron.c      |   13 +------------
 drivers/ata/pata_marvell.c      |   14 +-------------
 drivers/ata/pata_mpiix.c        |   13 +------------
 drivers/ata/pata_netcell.c      |   14 +-------------
 drivers/ata/pata_ninja32.c      |   13 +------------
 drivers/ata/pata_ns87410.c      |   13 +------------
 drivers/ata/pata_ns87415.c      |   13 +------------
 drivers/ata/pata_oldpiix.c      |   14 +-------------
 drivers/ata/pata_opti.c         |   14 +-------------
 drivers/ata/pata_optidma.c      |   13 +------------
 drivers/ata/pata_pdc2027x.c     |   19 +------------------
 drivers/ata/pata_pdc202xx_old.c |   13 +------------
 drivers/ata/pata_piccolo.c      |   16 +---------------
 drivers/ata/pata_radisys.c      |   14 +-------------
 drivers/ata/pata_rdc.c          |   13 +------------
 drivers/ata/pata_rz1000.c       |   14 +-------------
 drivers/ata/pata_sc1200.c       |   13 +------------
 drivers/ata/pata_scc.c          |   21 +--------------------
 drivers/ata/pata_sch.c          |   13 +------------
 drivers/ata/pata_serverworks.c  |   13 +------------
 drivers/ata/pata_sil680.c       |   13 +------------
 drivers/ata/pata_sis.c          |   14 +-------------
 drivers/ata/pata_sl82c105.c     |   13 +------------
 drivers/ata/pata_triflex.c      |   13 +------------
 drivers/ata/pata_via.c          |   13 +------------
 drivers/ata/pdc_adma.c          |   13 +------------
 drivers/ata/sata_inic162x.c     |   13 +------------
 drivers/ata/sata_nv.c           |   13 +------------
 drivers/ata/sata_promise.c      |   13 +------------
 drivers/ata/sata_qstor.c        |   13 +------------
 drivers/ata/sata_sil.c          |   14 +-------------
 drivers/ata/sata_sil24.c        |   13 +------------
 drivers/ata/sata_sis.c          |   13 +------------
 drivers/ata/sata_svw.c          |   13 +------------
 drivers/ata/sata_sx4.c          |   16 +---------------
 drivers/ata/sata_uli.c          |   14 +-------------
 drivers/ata/sata_via.c          |   13 +------------
 drivers/ata/sata_vsc.c          |   13 +------------
 60 files changed, 60 insertions(+), 761 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 3bc8c79..4e94ba2 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -503,21 +503,10 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 				 &acard_ahci_sht);
 }
 
-static int __init acard_ahci_init(void)
-{
-	return pci_register_driver(&acard_ahci_pci_driver);
-}
-
-static void __exit acard_ahci_exit(void)
-{
-	pci_unregister_driver(&acard_ahci_pci_driver);
-}
+module_pci_driver(acard_ahci_pci_driver);
 
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("ACard AHCI SATA low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, acard_ahci_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(acard_ahci_init);
-module_exit(acard_ahci_exit);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 79a1e9d..08838cb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1231,22 +1231,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				 &ahci_sht);
 }
 
-static int __init ahci_init(void)
-{
-	return pci_register_driver(&ahci_pci_driver);
-}
-
-static void __exit ahci_exit(void)
-{
-	pci_unregister_driver(&ahci_pci_driver);
-}
-
+module_pci_driver(ahci_pci_driver);
 
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("AHCI SATA low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, ahci_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ahci_init);
-module_exit(ahci_exit);
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 7df56ec..13ae497 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -255,17 +255,7 @@ static struct pci_driver ata_generic_pci_driver = {
 #endif
 };
 
-static int __init ata_generic_init(void)
-{
-	return pci_register_driver(&ata_generic_pci_driver);
-}
-
-
-static void __exit ata_generic_exit(void)
-{
-	pci_unregister_driver(&ata_generic_pci_driver);
-}
-
+module_pci_driver(ata_generic_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for generic ATA");
@@ -273,7 +263,4 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, ata_generic);
 MODULE_VERSION(DRV_VERSION);
 
-module_init(ata_generic_init);
-module_exit(ata_generic_exit);
-
 module_param(all_generic_ide, int, 0);
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 54145ed..801b337 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -273,22 +273,10 @@ static struct pci_driver pacpi_pci_driver = {
 #endif
 };
 
-static int __init pacpi_init(void)
-{
-	return pci_register_driver(&pacpi_pci_driver);
-}
-
-static void __exit pacpi_exit(void)
-{
-	pci_unregister_driver(&pacpi_pci_driver);
-}
-
-module_init(pacpi_init);
-module_exit(pacpi_exit);
+module_pci_driver(pacpi_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for ATA in ACPI mode");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pacpi_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index dc6b5da..82a0892 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -632,21 +632,10 @@ static struct pci_driver amd_pci_driver = {
 #endif
 };
 
-static int __init amd_init(void)
-{
-	return pci_register_driver(&amd_pci_driver);
-}
-
-static void __exit amd_exit(void)
-{
-	pci_unregister_driver(&amd_pci_driver);
-}
+module_pci_driver(amd_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for AMD and Nvidia PATA IDE");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, amd);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(amd_init);
-module_exit(amd_exit);
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 4b8b22e..74b215c 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -451,18 +451,7 @@ static struct pci_driver artop_pci_driver = {
 #endif
 };
 
-static int __init artop_init(void)
-{
-	return pci_register_driver(&artop_pci_driver);
-}
-
-static void __exit artop_exit(void)
-{
-	pci_unregister_driver(&artop_pci_driver);
-}
-
-module_init(artop_init);
-module_exit(artop_exit);
+module_pci_driver(artop_pci_driver);
 
 MODULE_AUTHOR("Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("SCSI low-level driver for ARTOP PATA");
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index be1aa14..361c75c 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -289,22 +289,10 @@ static struct pci_driver atiixp_pci_driver = {
 #endif
 };
 
-static int __init atiixp_init(void)
-{
-	return pci_register_driver(&atiixp_pci_driver);
-}
-
-
-static void __exit atiixp_exit(void)
-{
-	pci_unregister_driver(&atiixp_pci_driver);
-}
+module_pci_driver(atiixp_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for ATI IXP200/300/400");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, atiixp);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(atiixp_init);
-module_exit(atiixp_exit);
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
index 3cfabb2..041f50d 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -565,21 +565,10 @@ static struct pci_driver atp867x_driver = {
 #endif
 };
 
-static int __init atp867x_init(void)
-{
-	return pci_register_driver(&atp867x_driver);
-}
-
-static void __exit atp867x_exit(void)
-{
-	pci_unregister_driver(&atp867x_driver);
-}
+module_pci_driver(atp867x_driver);
 
 MODULE_AUTHOR("John(Jung-Ik) Lee, Google Inc.");
 MODULE_DESCRIPTION("low level driver for Artop/Acard 867x ATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, atp867x_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(atp867x_init);
-module_exit(atp867x_exit);
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 549d28d..504b98b 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -263,21 +263,10 @@ static struct pci_driver cmd640_pci_driver = {
 #endif
 };
 
-static int __init cmd640_init(void)
-{
-	return pci_register_driver(&cmd640_pci_driver);
-}
-
-static void __exit cmd640_exit(void)
-{
-	pci_unregister_driver(&cmd640_pci_driver);
-}
+module_pci_driver(cmd640_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for CMD640 PATA controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cmd640);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(cmd640_init);
-module_exit(cmd640_exit);
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 1c17cd1..8ec25af 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -525,21 +525,10 @@ static struct pci_driver cmd64x_pci_driver = {
 #endif
 };
 
-static int __init cmd64x_init(void)
-{
-	return pci_register_driver(&cmd64x_pci_driver);
-}
-
-static void __exit cmd64x_exit(void)
-{
-	pci_unregister_driver(&cmd64x_pci_driver);
-}
+module_pci_driver(cmd64x_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for CMD64x series PATA controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cmd64x);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(cmd64x_init);
-module_exit(cmd64x_exit);
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 9ddcddc..de74d80 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -302,22 +302,10 @@ static struct pci_driver cs5520_pci_driver = {
 #endif
 };
 
-static int __init cs5520_init(void)
-{
-	return pci_register_driver(&cs5520_pci_driver);
-}
-
-static void __exit cs5520_exit(void)
-{
-	pci_unregister_driver(&cs5520_pci_driver);
-}
+module_pci_driver(cs5520_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Cyrix CS5510/5520");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pata_cs5520);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(cs5520_init);
-module_exit(cs5520_exit);
-
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index f792330..48389ae 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -363,21 +363,10 @@ static struct pci_driver cs5530_pci_driver = {
 #endif
 };
 
-static int __init cs5530_init(void)
-{
-	return pci_register_driver(&cs5530_pci_driver);
-}
-
-static void __exit cs5530_exit(void)
-{
-	pci_unregister_driver(&cs5530_pci_driver);
-}
+module_pci_driver(cs5530_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for the Cyrix/NS/AMD 5530");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cs5530);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(cs5530_init);
-module_exit(cs5530_exit);
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index a0b4640..997e16a 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -207,21 +207,10 @@ static struct pci_driver cs5535_pci_driver = {
 #endif
 };
 
-static int __init cs5535_init(void)
-{
-	return pci_register_driver(&cs5535_pci_driver);
-}
-
-static void __exit cs5535_exit(void)
-{
-	pci_unregister_driver(&cs5535_pci_driver);
-}
+module_pci_driver(cs5535_pci_driver);
 
 MODULE_AUTHOR("Alan Cox, Jens Altmann, Wolfgan Zuleger, Alexander Kiausch");
 MODULE_DESCRIPTION("low-level driver for the NS/AMD 5535");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cs5535);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(cs5535_init);
-module_exit(cs5535_exit);
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 7a402c7..dec1b6c 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -274,21 +274,10 @@ static struct pci_driver cs5536_pci_driver = {
 #endif
 };
 
-static int __init cs5536_init(void)
-{
-	return pci_register_driver(&cs5536_pci_driver);
-}
-
-static void __exit cs5536_exit(void)
-{
-	pci_unregister_driver(&cs5536_pci_driver);
-}
+module_pci_driver(cs5536_pci_driver);
 
 MODULE_AUTHOR("Martin K. Petersen");
 MODULE_DESCRIPTION("low-level driver for the CS5536 IDE controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cs5536);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(cs5536_init);
-module_exit(cs5536_exit);
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 6d915b0..810bc99 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -158,23 +158,10 @@ static struct pci_driver cy82c693_pci_driver = {
 #endif
 };
 
-static int __init cy82c693_init(void)
-{
-	return pci_register_driver(&cy82c693_pci_driver);
-}
-
-
-static void __exit cy82c693_exit(void)
-{
-	pci_unregister_driver(&cy82c693_pci_driver);
-}
-
+module_pci_driver(cy82c693_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for the CY82C693 PATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cy82c693);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(cy82c693_init);
-module_exit(cy82c693_exit);
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index f0243ed..3c12fd7 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -295,22 +295,10 @@ static struct pci_driver efar_pci_driver = {
 #endif
 };
 
-static int __init efar_init(void)
-{
-	return pci_register_driver(&efar_pci_driver);
-}
-
-static void __exit efar_exit(void)
-{
-	pci_unregister_driver(&efar_pci_driver);
-}
-
-module_init(efar_init);
-module_exit(efar_exit);
+module_pci_driver(efar_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for EFAR PIIX clones");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, efar_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 42cffd3..4be884a 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -418,21 +418,10 @@ static struct pci_driver hpt36x_pci_driver = {
 #endif
 };
 
-static int __init hpt36x_init(void)
-{
-	return pci_register_driver(&hpt36x_pci_driver);
-}
-
-static void __exit hpt36x_exit(void)
-{
-	pci_unregister_driver(&hpt36x_pci_driver);
-}
+module_pci_driver(hpt36x_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for the Highpoint HPT366/368");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, hpt36x);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(hpt36x_init);
-module_exit(hpt36x_exit);
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 9620636..a9d74ef 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -1058,21 +1058,10 @@ static struct pci_driver hpt37x_pci_driver = {
 	.remove		= ata_pci_remove_one
 };
 
-static int __init hpt37x_init(void)
-{
-	return pci_register_driver(&hpt37x_pci_driver);
-}
-
-static void __exit hpt37x_exit(void)
-{
-	pci_unregister_driver(&hpt37x_pci_driver);
-}
+module_pci_driver(hpt37x_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for the Highpoint HPT37x/30x");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, hpt37x);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(hpt37x_init);
-module_exit(hpt37x_exit);
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 765f136..4be0398 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -621,21 +621,10 @@ static struct pci_driver hpt3x2n_pci_driver = {
 	.remove		= ata_pci_remove_one
 };
 
-static int __init hpt3x2n_init(void)
-{
-	return pci_register_driver(&hpt3x2n_pci_driver);
-}
-
-static void __exit hpt3x2n_exit(void)
-{
-	pci_unregister_driver(&hpt3x2n_pci_driver);
-}
+module_pci_driver(hpt3x2n_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for the Highpoint HPT3xxN");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, hpt3x2n);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(hpt3x2n_init);
-module_exit(hpt3x2n_exit);
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index b3042da..76c9314 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -284,23 +284,10 @@ static struct pci_driver hpt3x3_pci_driver = {
 #endif
 };
 
-static int __init hpt3x3_init(void)
-{
-	return pci_register_driver(&hpt3x3_pci_driver);
-}
-
-
-static void __exit hpt3x3_exit(void)
-{
-	pci_unregister_driver(&hpt3x3_pci_driver);
-}
-
+module_pci_driver(hpt3x3_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for the Highpoint HPT343/363");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, hpt3x3);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(hpt3x3_init);
-module_exit(hpt3x3_exit);
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index cf9164d..2a8dd95 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -290,18 +290,7 @@ static struct pci_driver it8213_pci_driver = {
 #endif
 };
 
-static int __init it8213_init(void)
-{
-	return pci_register_driver(&it8213_pci_driver);
-}
-
-static void __exit it8213_exit(void)
-{
-	pci_unregister_driver(&it8213_pci_driver);
-}
-
-module_init(it8213_init);
-module_exit(it8213_exit);
+module_pci_driver(it8213_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for the ITE 8213");
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 62c5d00..9cc05d8 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -972,15 +972,7 @@ static struct pci_driver it821x_pci_driver = {
 #endif
 };
 
-static int __init it821x_init(void)
-{
-	return pci_register_driver(&it821x_pci_driver);
-}
-
-static void __exit it821x_exit(void)
-{
-	pci_unregister_driver(&it821x_pci_driver);
-}
+module_pci_driver(it821x_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for the IT8211/IT8212 IDE RAID controller");
@@ -988,9 +980,5 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, it821x);
 MODULE_VERSION(DRV_VERSION);
 
-
 module_param_named(noraid, it8212_noraid, int, S_IRUGO);
 MODULE_PARM_DESC(noraid, "Force card into bypass mode");
-
-module_init(it821x_init);
-module_exit(it821x_exit);
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index cb3babb..76e739b0 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -164,18 +164,7 @@ static struct pci_driver jmicron_pci_driver = {
 #endif
 };
 
-static int __init jmicron_init(void)
-{
-	return pci_register_driver(&jmicron_pci_driver);
-}
-
-static void __exit jmicron_exit(void)
-{
-	pci_unregister_driver(&jmicron_pci_driver);
-}
-
-module_init(jmicron_init);
-module_exit(jmicron_exit);
+module_pci_driver(jmicron_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for Jmicron PATA ports");
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 5d7f58a..a4f5e78 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -178,22 +178,10 @@ static struct pci_driver marvell_pci_driver = {
 #endif
 };
 
-static int __init marvell_init(void)
-{
-	return pci_register_driver(&marvell_pci_driver);
-}
-
-static void __exit marvell_exit(void)
-{
-	pci_unregister_driver(&marvell_pci_driver);
-}
-
-module_init(marvell_init);
-module_exit(marvell_exit);
+module_pci_driver(marvell_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for Marvell ATA in legacy mode");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, marvell_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 9dc16df..1f5f28b 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -230,21 +230,10 @@ static struct pci_driver mpiix_pci_driver = {
 #endif
 };
 
-static int __init mpiix_init(void)
-{
-	return pci_register_driver(&mpiix_pci_driver);
-}
-
-static void __exit mpiix_exit(void)
-{
-	pci_unregister_driver(&mpiix_pci_driver);
-}
+module_pci_driver(mpiix_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Intel MPIIX");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, mpiix);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(mpiix_init);
-module_exit(mpiix_exit);
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index 9979a43..ad1a0fe 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -99,22 +99,10 @@ static struct pci_driver netcell_pci_driver = {
 #endif
 };
 
-static int __init netcell_init(void)
-{
-	return pci_register_driver(&netcell_pci_driver);
-}
-
-static void __exit netcell_exit(void)
-{
-	pci_unregister_driver(&netcell_pci_driver);
-}
-
-module_init(netcell_init);
-module_exit(netcell_exit);
+module_pci_driver(netcell_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for Netcell PATA RAID");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, netcell_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index e277a14..12010ed 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -190,21 +190,10 @@ static struct pci_driver ninja32_pci_driver = {
 #endif
 };
 
-static int __init ninja32_init(void)
-{
-	return pci_register_driver(&ninja32_pci_driver);
-}
-
-static void __exit ninja32_exit(void)
-{
-	pci_unregister_driver(&ninja32_pci_driver);
-}
+module_pci_driver(ninja32_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Ninja32 ATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, ninja32);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ninja32_init);
-module_exit(ninja32_exit);
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 31d5986..0c424da 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -168,21 +168,10 @@ static struct pci_driver ns87410_pci_driver = {
 #endif
 };
 
-static int __init ns87410_init(void)
-{
-	return pci_register_driver(&ns87410_pci_driver);
-}
-
-static void __exit ns87410_exit(void)
-{
-	pci_unregister_driver(&ns87410_pci_driver);
-}
+module_pci_driver(ns87410_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Nat Semi 87410");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, ns87410);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ns87410_init);
-module_exit(ns87410_exit);
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index f1d517b..6f6fa10 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -414,18 +414,7 @@ static struct pci_driver ns87415_pci_driver = {
 #endif
 };
 
-static int __init ns87415_init(void)
-{
-	return pci_register_driver(&ns87415_pci_driver);
-}
-
-static void __exit ns87415_exit(void)
-{
-	pci_unregister_driver(&ns87415_pci_driver);
-}
-
-module_init(ns87415_init);
-module_exit(ns87415_exit);
+module_pci_driver(ns87415_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("ATA low-level driver for NS87415 controllers");
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 98cdf50..d77b2e1 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -265,22 +265,10 @@ static struct pci_driver oldpiix_pci_driver = {
 #endif
 };
 
-static int __init oldpiix_init(void)
-{
-	return pci_register_driver(&oldpiix_pci_driver);
-}
-
-static void __exit oldpiix_exit(void)
-{
-	pci_unregister_driver(&oldpiix_pci_driver);
-}
-
-module_init(oldpiix_init);
-module_exit(oldpiix_exit);
+module_pci_driver(oldpiix_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for early PIIX series controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, oldpiix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index accc033..4ea70cd 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -191,22 +191,10 @@ static struct pci_driver opti_pci_driver = {
 #endif
 };
 
-static int __init opti_init(void)
-{
-	return pci_register_driver(&opti_pci_driver);
-}
-
-static void __exit opti_exit(void)
-{
-	pci_unregister_driver(&opti_pci_driver);
-}
-
+module_pci_driver(opti_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Opti 621/621X");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, opti);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(opti_init);
-module_exit(opti_exit);
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 77cb914..78ede3f 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -447,21 +447,10 @@ static struct pci_driver optidma_pci_driver = {
 #endif
 };
 
-static int __init optidma_init(void)
-{
-	return pci_register_driver(&optidma_pci_driver);
-}
-
-static void __exit optidma_exit(void)
-{
-	pci_unregister_driver(&optidma_pci_driver);
-}
+module_pci_driver(optidma_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Opti Firestar/Firestar Plus");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, optidma);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(optidma_init);
-module_exit(optidma_exit);
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 7d63f24..c9399c8 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -784,21 +784,4 @@ static int pdc2027x_reinit_one(struct pci_dev *pdev)
 }
 #endif
 
-/**
- * pdc2027x_init - Called after this module is loaded into the kernel.
- */
-static int __init pdc2027x_init(void)
-{
-	return pci_register_driver(&pdc2027x_pci_driver);
-}
-
-/**
- * pdc2027x_exit - Called before this module unloaded from the kernel
- */
-static void __exit pdc2027x_exit(void)
-{
-	pci_unregister_driver(&pdc2027x_pci_driver);
-}
-
-module_init(pdc2027x_init);
-module_exit(pdc2027x_exit);
+module_pci_driver(pdc2027x_pci_driver);
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index c2ed586..c34fc50 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -384,21 +384,10 @@ static struct pci_driver pdc202xx_pci_driver = {
 #endif
 };
 
-static int __init pdc202xx_init(void)
-{
-	return pci_register_driver(&pdc202xx_pci_driver);
-}
-
-static void __exit pdc202xx_exit(void)
-{
-	pci_unregister_driver(&pdc202xx_pci_driver);
-}
+module_pci_driver(pdc202xx_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Promise 2024x and 20262-20267");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pdc202xx);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pdc202xx_init);
-module_exit(pdc202xx_exit);
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
index cb01bf9..2beb6b5 100644
--- a/drivers/ata/pata_piccolo.c
+++ b/drivers/ata/pata_piccolo.c
@@ -117,24 +117,10 @@ static struct pci_driver ata_tosh_pci_driver = {
 #endif
 };
 
-static int __init ata_tosh_init(void)
-{
-	return pci_register_driver(&ata_tosh_pci_driver);
-}
-
-
-static void __exit ata_tosh_exit(void)
-{
-	pci_unregister_driver(&ata_tosh_pci_driver);
-}
-
+module_pci_driver(ata_tosh_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("Low level driver for Toshiba Piccolo ATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, ata_tosh);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ata_tosh_init);
-module_exit(ata_tosh_exit);
-
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index b2d3a2b..f582ba1 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -244,22 +244,10 @@ static struct pci_driver radisys_pci_driver = {
 #endif
 };
 
-static int __init radisys_init(void)
-{
-	return pci_register_driver(&radisys_pci_driver);
-}
-
-static void __exit radisys_exit(void)
-{
-	pci_unregister_driver(&radisys_pci_driver);
-}
-
-module_init(radisys_init);
-module_exit(radisys_exit);
+module_pci_driver(radisys_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for Radisys R82600 controllers");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, radisys_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index e6a2dd7..32a3499 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -394,18 +394,7 @@ static struct pci_driver rdc_pci_driver = {
 };
 
 
-static int __init rdc_init(void)
-{
-	return pci_register_driver(&rdc_pci_driver);
-}
-
-static void __exit rdc_exit(void)
-{
-	pci_unregister_driver(&rdc_pci_driver);
-}
-
-module_init(rdc_init);
-module_exit(rdc_exit);
+module_pci_driver(rdc_pci_driver);
 
 MODULE_AUTHOR("Alan Cox (based on ata_piix)");
 MODULE_DESCRIPTION("SCSI low-level driver for RDC PATA controllers");
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index aca321e..60f4de2 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -140,22 +140,10 @@ static struct pci_driver rz1000_pci_driver = {
 #endif
 };
 
-static int __init rz1000_init(void)
-{
-	return pci_register_driver(&rz1000_pci_driver);
-}
-
-static void __exit rz1000_exit(void)
-{
-	pci_unregister_driver(&rz1000_pci_driver);
-}
+module_pci_driver(rz1000_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for RZ1000 PCI ATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pata_rz1000);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(rz1000_init);
-module_exit(rz1000_exit);
-
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index c0e603a..ce2f828 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -261,21 +261,10 @@ static struct pci_driver sc1200_pci_driver = {
 #endif
 };
 
-static int __init sc1200_init(void)
-{
-	return pci_register_driver(&sc1200_pci_driver);
-}
-
-static void __exit sc1200_exit(void)
-{
-	pci_unregister_driver(&sc1200_pci_driver);
-}
+module_pci_driver(sc1200_pci_driver);
 
 MODULE_AUTHOR("Alan Cox, Mark Lord");
 MODULE_DESCRIPTION("low-level driver for the NS/AMD SC1200");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sc1200);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sc1200_init);
-module_exit(sc1200_exit);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index e265f83..f35f15f 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -1103,26 +1103,7 @@ static struct pci_driver scc_pci_driver = {
 #endif
 };
 
-static int __init scc_init (void)
-{
-	int rc;
-
-	DPRINTK("pci_register_driver\n");
-	rc = pci_register_driver(&scc_pci_driver);
-	if (rc)
-		return rc;
-
-	DPRINTK("done\n");
-	return 0;
-}
-
-static void __exit scc_exit (void)
-{
-	pci_unregister_driver(&scc_pci_driver);
-}
-
-module_init(scc_init);
-module_exit(scc_exit);
+module_pci_driver(scc_pci_driver);
 
 MODULE_AUTHOR("Toshiba corp");
 MODULE_DESCRIPTION("SCSI low-level driver for Toshiba SCC PATA controller");
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index 7c78b99..db0d18c 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -179,15 +179,4 @@ static int __devinit sch_init_one(struct pci_dev *pdev,
 	return ata_pci_bmdma_init_one(pdev, ppi, &sch_sht, NULL, 0);
 }
 
-static int __init sch_init(void)
-{
-	return pci_register_driver(&sch_pci_driver);
-}
-
-static void __exit sch_exit(void)
-{
-	pci_unregister_driver(&sch_pci_driver);
-}
-
-module_init(sch_init);
-module_exit(sch_exit);
+module_pci_driver(sch_pci_driver);
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 71eaf38..f3febbc 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -475,21 +475,10 @@ static struct pci_driver serverworks_pci_driver = {
 #endif
 };
 
-static int __init serverworks_init(void)
-{
-	return pci_register_driver(&serverworks_pci_driver);
-}
-
-static void __exit serverworks_exit(void)
-{
-	pci_unregister_driver(&serverworks_pci_driver);
-}
+module_pci_driver(serverworks_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Serverworks OSB4/CSB5/CSB6");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, serverworks);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(serverworks_init);
-module_exit(serverworks_exit);
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index b92eacf..5cfdf94 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -437,21 +437,10 @@ static struct pci_driver sil680_pci_driver = {
 #endif
 };
 
-static int __init sil680_init(void)
-{
-	return pci_register_driver(&sil680_pci_driver);
-}
-
-static void __exit sil680_exit(void)
-{
-	pci_unregister_driver(&sil680_pci_driver);
-}
+module_pci_driver(sil680_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for SI680 PATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sil680);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sil680_init);
-module_exit(sil680_exit);
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index b0edc7d..2d5ac13 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -906,22 +906,10 @@ static struct pci_driver sis_pci_driver = {
 #endif
 };
 
-static int __init sis_init(void)
-{
-	return pci_register_driver(&sis_pci_driver);
-}
-
-static void __exit sis_exit(void)
-{
-	pci_unregister_driver(&sis_pci_driver);
-}
-
-module_init(sis_init);
-module_exit(sis_exit);
+module_pci_driver(sis_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("SCSI low-level driver for SiS ATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sis_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 24cf200..738e000 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -372,21 +372,10 @@ static struct pci_driver sl82c105_pci_driver = {
 #endif
 };
 
-static int __init sl82c105_init(void)
-{
-	return pci_register_driver(&sl82c105_pci_driver);
-}
-
-static void __exit sl82c105_exit(void)
-{
-	pci_unregister_driver(&sl82c105_pci_driver);
-}
+module_pci_driver(sl82c105_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Sl82c105");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sl82c105);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sl82c105_init);
-module_exit(sl82c105_exit);
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 28da1c6..c8e589d 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -240,21 +240,10 @@ static struct pci_driver triflex_pci_driver = {
 #endif
 };
 
-static int __init triflex_init(void)
-{
-	return pci_register_driver(&triflex_pci_driver);
-}
-
-static void __exit triflex_exit(void)
-{
-	pci_unregister_driver(&triflex_pci_driver);
-}
+module_pci_driver(triflex_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for Compaq Triflex");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, triflex);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(triflex_init);
-module_exit(triflex_exit);
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 255f336..8d2a9fd 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -711,21 +711,10 @@ static struct pci_driver via_pci_driver = {
 #endif
 };
 
-static int __init via_init(void)
-{
-	return pci_register_driver(&via_pci_driver);
-}
-
-static void __exit via_exit(void)
-{
-	pci_unregister_driver(&via_pci_driver);
-}
+module_pci_driver(via_pci_driver);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for VIA PATA");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, via);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(via_init);
-module_exit(via_exit);
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 04911d5..5053333 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -660,21 +660,10 @@ static int adma_ata_init_one(struct pci_dev *pdev,
 				 &adma_ata_sht);
 }
 
-static int __init adma_ata_init(void)
-{
-	return pci_register_driver(&adma_ata_pci_driver);
-}
-
-static void __exit adma_ata_exit(void)
-{
-	pci_unregister_driver(&adma_ata_pci_driver);
-}
+module_pci_driver(adma_ata_pci_driver);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("Pacific Digital Corporation ADMA low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, adma_ata_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(adma_ata_init);
-module_exit(adma_ata_exit);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 5c7d70c..dc35f4d 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -894,21 +894,10 @@ static struct pci_driver inic_pci_driver = {
 	.remove		= ata_pci_remove_one,
 };
 
-static int __init inic_init(void)
-{
-	return pci_register_driver(&inic_pci_driver);
-}
-
-static void __exit inic_exit(void)
-{
-	pci_unregister_driver(&inic_pci_driver);
-}
+module_pci_driver(inic_pci_driver);
 
 MODULE_AUTHOR("Tejun Heo");
 MODULE_DESCRIPTION("low-level driver for Initio 162x SATA");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(pci, inic_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(inic_init);
-module_exit(inic_exit);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 55d6179d..85ee499 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2510,22 +2510,11 @@ static void nv_adma_host_stop(struct ata_host *host)
 	nv_ck804_host_stop(host);
 }
 
-static int __init nv_init(void)
-{
-	return pci_register_driver(&nv_pci_driver);
-}
-
-static void __exit nv_exit(void)
-{
-	pci_unregister_driver(&nv_pci_driver);
-}
+module_pci_driver(nv_pci_driver);
 
-module_init(nv_init);
-module_exit(nv_exit);
 module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: false)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
 MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
 module_param_named(msi, msi_enabled, bool, 0444);
 MODULE_PARM_DESC(msi, "Enable use of MSI (Default: false)");
-
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 000fcc9..489c817 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -1249,21 +1249,10 @@ static int pdc_ata_init_one(struct pci_dev *pdev,
 				 &pdc_ata_sht);
 }
 
-static int __init pdc_ata_init(void)
-{
-	return pci_register_driver(&pdc_ata_pci_driver);
-}
-
-static void __exit pdc_ata_exit(void)
-{
-	pci_unregister_driver(&pdc_ata_pci_driver);
-}
+module_pci_driver(pdc_ata_pci_driver);
 
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Promise ATA TX2/TX4/TX4000 low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pdc_ata_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pdc_ata_init);
-module_exit(pdc_ata_exit);
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 9d1a47b..3b0dd57 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -635,21 +635,10 @@ static int qs_ata_init_one(struct pci_dev *pdev,
 				 &qs_ata_sht);
 }
 
-static int __init qs_ata_init(void)
-{
-	return pci_register_driver(&qs_ata_pci_driver);
-}
-
-static void __exit qs_ata_exit(void)
-{
-	pci_unregister_driver(&qs_ata_pci_driver);
-}
+module_pci_driver(qs_ata_pci_driver);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("Pacific Digital Corporation QStor SATA low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, qs_ata_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(qs_ata_init);
-module_exit(qs_ata_exit);
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 9dfb40b..a7b3167 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -819,16 +819,4 @@ static int sil_pci_device_resume(struct pci_dev *pdev)
 }
 #endif
 
-static int __init sil_init(void)
-{
-	return pci_register_driver(&sil_pci_driver);
-}
-
-static void __exit sil_exit(void)
-{
-	pci_unregister_driver(&sil_pci_driver);
-}
-
-
-module_init(sil_init);
-module_exit(sil_exit);
+module_pci_driver(sil_pci_driver);
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index e7e610a..a5f2a56 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1382,20 +1382,9 @@ static int sil24_port_resume(struct ata_port *ap)
 }
 #endif
 
-static int __init sil24_init(void)
-{
-	return pci_register_driver(&sil24_pci_driver);
-}
-
-static void __exit sil24_exit(void)
-{
-	pci_unregister_driver(&sil24_pci_driver);
-}
+module_pci_driver(sil24_pci_driver);
 
 MODULE_AUTHOR("Tejun Heo");
 MODULE_DESCRIPTION("Silicon Image 3124/3132 SATA low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sil24_pci_tbl);
-
-module_init(sil24_init);
-module_exit(sil24_exit);
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 95ec435..fe3ca09 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -308,15 +308,4 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				 IRQF_SHARED, &sis_sht);
 }
 
-static int __init sis_init(void)
-{
-	return pci_register_driver(&sis_pci_driver);
-}
-
-static void __exit sis_exit(void)
-{
-	pci_unregister_driver(&sis_pci_driver);
-}
-
-module_init(sis_init);
-module_exit(sis_exit);
+module_pci_driver(sis_pci_driver);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index c646118..44a4256 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -525,21 +525,10 @@ static struct pci_driver k2_sata_pci_driver = {
 	.remove			= ata_pci_remove_one,
 };
 
-static int __init k2_sata_init(void)
-{
-	return pci_register_driver(&k2_sata_pci_driver);
-}
-
-static void __exit k2_sata_exit(void)
-{
-	pci_unregister_driver(&k2_sata_pci_driver);
-}
+module_pci_driver(k2_sata_pci_driver);
 
 MODULE_AUTHOR("Benjamin Herrenschmidt");
 MODULE_DESCRIPTION("low-level driver for K2 SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, k2_sata_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(k2_sata_init);
-module_exit(k2_sata_exit);
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index cdaebbe..1226055 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -1498,24 +1498,10 @@ static int pdc_sata_init_one(struct pci_dev *pdev,
 				 IRQF_SHARED, &pdc_sata_sht);
 }
 
-
-static int __init pdc_sata_init(void)
-{
-	return pci_register_driver(&pdc_sata_pci_driver);
-}
-
-
-static void __exit pdc_sata_exit(void)
-{
-	pci_unregister_driver(&pdc_sata_pci_driver);
-}
-
+module_pci_driver(pdc_sata_pci_driver);
 
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Promise SATA low-level driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, pdc_sata_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pdc_sata_init);
-module_exit(pdc_sata_exit);
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index b54ebfc..6d64891 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -243,16 +243,4 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				 IRQF_SHARED, &uli_sht);
 }
 
-static int __init uli_init(void)
-{
-	return pci_register_driver(&uli_pci_driver);
-}
-
-static void __exit uli_exit(void)
-{
-	pci_unregister_driver(&uli_pci_driver);
-}
-
-
-module_init(uli_init);
-module_exit(uli_exit);
+module_pci_driver(uli_pci_driver);
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index f93e43b..5913ea9 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -655,15 +655,4 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				 IRQF_SHARED, &svia_sht);
 }
 
-static int __init svia_init(void)
-{
-	return pci_register_driver(&svia_pci_driver);
-}
-
-static void __exit svia_exit(void)
-{
-	pci_unregister_driver(&svia_pci_driver);
-}
-
-module_init(svia_init);
-module_exit(svia_exit);
+module_pci_driver(svia_pci_driver);
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 6135a52..e8cf88ba 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -436,21 +436,10 @@ static struct pci_driver vsc_sata_pci_driver = {
 	.remove			= ata_pci_remove_one,
 };
 
-static int __init vsc_sata_init(void)
-{
-	return pci_register_driver(&vsc_sata_pci_driver);
-}
-
-static void __exit vsc_sata_exit(void)
-{
-	pci_unregister_driver(&vsc_sata_pci_driver);
-}
+module_pci_driver(vsc_sata_pci_driver);
 
 MODULE_AUTHOR("Jeremy Higdon");
 MODULE_DESCRIPTION("low-level driver for Vitesse VSC7174 SATA controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, vsc_sata_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-
-module_init(vsc_sata_init);
-module_exit(vsc_sata_exit);
-- 
1.7.5.4



