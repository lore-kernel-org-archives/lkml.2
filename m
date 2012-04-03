Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2DCBJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:09:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60780 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2DCBJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:09:26 -0400
Message-ID: <1333415359.18133.3.camel@phoenix>
Subject: [PATCH] mfd: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andres Salomon <dilinger@queued.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Denis Turischev <denis@compulab.co.il>,
        Harald Welte <HaraldWelte@viatech.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 03 Apr 2012 09:09:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/mfd/* to use module_pci_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Denis Turischev <denis@compulab.co.il>
Cc: Harald Welte <HaraldWelte@viatech.com>
---
 drivers/mfd/cs5535-mfd.c          |   13 +------------
 drivers/mfd/janz-cmodio.c         |   17 +----------------
 drivers/mfd/lpc_sch.c             |   13 +------------
 drivers/mfd/rdc321x-southbridge.c |   13 +------------
 drivers/mfd/vx855.c               |   12 +-----------
 5 files changed, 5 insertions(+), 63 deletions(-)

diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 315fef5..3419e72 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -186,18 +186,7 @@ static struct pci_driver cs5535_mfd_driver = {
 	.remove = __devexit_p(cs5535_mfd_remove),
 };
 
-static int __init cs5535_mfd_init(void)
-{
-	return pci_register_driver(&cs5535_mfd_driver);
-}
-
-static void __exit cs5535_mfd_exit(void)
-{
-	pci_unregister_driver(&cs5535_mfd_driver);
-}
-
-module_init(cs5535_mfd_init);
-module_exit(cs5535_mfd_exit);
+module_pci_driver(cs5535_mfd_driver);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("MFD driver for CS5535/CS5536 southbridge's ISA PCI device");
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index a9223ed..2ea9998 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -283,23 +283,8 @@ static struct pci_driver cmodio_pci_driver = {
 	.remove   = __devexit_p(cmodio_pci_remove),
 };
 
-/*
- * Module Init / Exit
- */
-
-static int __init cmodio_init(void)
-{
-	return pci_register_driver(&cmodio_pci_driver);
-}
-
-static void __exit cmodio_exit(void)
-{
-	pci_unregister_driver(&cmodio_pci_driver);
-}
+module_pci_driver(cmodio_pci_driver);
 
 MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
 MODULE_DESCRIPTION("Janz CMOD-IO PCI MODULbus Carrier Board Driver");
 MODULE_LICENSE("GPL");
-
-module_init(cmodio_init);
-module_exit(cmodio_exit);
diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index abc4213..27026eb 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -167,18 +167,7 @@ static struct pci_driver lpc_sch_driver = {
 	.remove		= __devexit_p(lpc_sch_remove),
 };
 
-static int __init lpc_sch_init(void)
-{
-	return pci_register_driver(&lpc_sch_driver);
-}
-
-static void __exit lpc_sch_exit(void)
-{
-	pci_unregister_driver(&lpc_sch_driver);
-}
-
-module_init(lpc_sch_init);
-module_exit(lpc_sch_exit);
+module_pci_driver(lpc_sch_driver);
 
 MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
 MODULE_DESCRIPTION("LPC interface for Intel Poulsbo SCH");
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 809bd4a..685d61e 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -108,18 +108,7 @@ static struct pci_driver rdc321x_sb_driver = {
 	.remove		= __devexit_p(rdc321x_sb_remove),
 };
 
-static int __init rdc321x_sb_init(void)
-{
-	return pci_register_driver(&rdc321x_sb_driver);
-}
-
-static void __exit rdc321x_sb_exit(void)
-{
-	pci_unregister_driver(&rdc321x_sb_driver);
-}
-
-module_init(rdc321x_sb_init);
-module_exit(rdc321x_sb_exit);
+module_pci_driver(rdc321x_sb_driver);
 
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index b73cc15..872aff2 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -131,17 +131,7 @@ static struct pci_driver vx855_pci_driver = {
 	.remove		= __devexit_p(vx855_remove),
 };
 
-static int vx855_init(void)
-{
-	return pci_register_driver(&vx855_pci_driver);
-}
-module_init(vx855_init);
-
-static void vx855_exit(void)
-{
-	pci_unregister_driver(&vx855_pci_driver);
-}
-module_exit(vx855_exit);
+module_pci_driver(vx855_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <HaraldWelte@viatech.com>");
-- 
1.7.5.4



