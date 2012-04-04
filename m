Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab2DDOPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:15:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64192 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab2DDOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:15:10 -0400
Message-ID: <1333548898.5856.1.camel@phoenix>
Subject: [PATCH] usb: gadget: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>, Felipe Balbi <balbi@ti.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org
Date: Wed, 04 Apr 2012 22:14:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/usb/gadget/* to use
module_pci_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Xiaochen Shen <xiaochen.shen@intel.com>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/amd5536udc.c   |   14 +-------------
 drivers/usb/gadget/ci13xxx_pci.c  |   22 +---------------------
 drivers/usb/gadget/goku_udc.c     |   12 +-----------
 drivers/usb/gadget/langwell_udc.c |   16 +---------------
 drivers/usb/gadget/pch_udc.c      |   13 +------------
 5 files changed, 5 insertions(+), 72 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 7777927..e6bb107 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3402,19 +3402,7 @@ static struct pci_driver udc_pci_driver = {
 	.remove =	udc_pci_remove,
 };
 
-/* Inits driver */
-static int __init init(void)
-{
-	return pci_register_driver(&udc_pci_driver);
-}
-module_init(init);
-
-/* Cleans driver */
-static void __exit cleanup(void)
-{
-	pci_unregister_driver(&udc_pci_driver);
-}
-module_exit(cleanup);
+module_pci_driver(udc_pci_driver);
 
 MODULE_DESCRIPTION(UDC_MOD_DESCRIPTION);
 MODULE_AUTHOR("Thomas Dahlmann");
diff --git a/drivers/usb/gadget/ci13xxx_pci.c b/drivers/usb/gadget/ci13xxx_pci.c
index 883ab5e..63ef96c 100644
--- a/drivers/usb/gadget/ci13xxx_pci.c
+++ b/drivers/usb/gadget/ci13xxx_pci.c
@@ -148,27 +148,7 @@ static struct pci_driver ci13xxx_pci_driver = {
 	.remove       =	__devexit_p(ci13xxx_pci_remove),
 };
 
-/**
- * ci13xxx_pci_init: module init
- *
- * Driver load
- */
-static int __init ci13xxx_pci_init(void)
-{
-	return pci_register_driver(&ci13xxx_pci_driver);
-}
-module_init(ci13xxx_pci_init);
-
-/**
- * ci13xxx_pci_exit: module exit
- *
- * Driver unload
- */
-static void __exit ci13xxx_pci_exit(void)
-{
-	pci_unregister_driver(&ci13xxx_pci_driver);
-}
-module_exit(ci13xxx_pci_exit);
+module_pci_driver(ci13xxx_pci_driver);
 
 MODULE_AUTHOR("MIPS - David Lopo <dlopo@chipidea.mips.com>");
 MODULE_DESCRIPTION("MIPS CI13XXX USB Peripheral Controller");
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index e151d6b..6ae874e 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1895,14 +1895,4 @@ static struct pci_driver goku_pci_driver = {
 	/* FIXME add power management support */
 };
 
-static int __init init (void)
-{
-	return pci_register_driver (&goku_pci_driver);
-}
-module_init (init);
-
-static void __exit cleanup (void)
-{
-	pci_unregister_driver (&goku_pci_driver);
-}
-module_exit (cleanup);
+module_pci_driver(goku_pci_driver);
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index f9cedd5..1308112 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -3412,23 +3412,9 @@ static struct pci_driver langwell_pci_driver = {
 	.shutdown =	langwell_udc_shutdown,
 };
 
-
-static int __init init(void)
-{
-	return pci_register_driver(&langwell_pci_driver);
-}
-module_init(init);
-
-
-static void __exit cleanup(void)
-{
-	pci_unregister_driver(&langwell_pci_driver);
-}
-module_exit(cleanup);
-
+module_pci_driver(langwell_pci_driver);
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Xiaochen Shen <xiaochen.shen@intel.com>");
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 6530706..3143a83 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -3282,7 +3282,6 @@ static DEFINE_PCI_DEVICE_TABLE(pch_udc_pcidev_id) = {
 
 MODULE_DEVICE_TABLE(pci, pch_udc_pcidev_id);
 
-
 static struct pci_driver pch_udc_driver = {
 	.name =	KBUILD_MODNAME,
 	.id_table =	pch_udc_pcidev_id,
@@ -3293,17 +3292,7 @@ static struct pci_driver pch_udc_driver = {
 	.shutdown =	pch_udc_shutdown,
 };
 
-static int __init pch_udc_pci_init(void)
-{
-	return pci_register_driver(&pch_udc_driver);
-}
-module_init(pch_udc_pci_init);
-
-static void __exit pch_udc_pci_exit(void)
-{
-	pci_unregister_driver(&pch_udc_driver);
-}
-module_exit(pch_udc_pci_exit);
+module_pci_driver(pch_udc_driver);
 
 MODULE_DESCRIPTION("Intel EG20T USB Device Controller");
 MODULE_AUTHOR("LAPIS Semiconductor, <tomoya-linux@dsn.lapis-semi.com>");
-- 
1.7.5.4



