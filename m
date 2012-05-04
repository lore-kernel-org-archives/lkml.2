Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab2EDW5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:57:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29456 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760485Ab2EDW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:57:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1336172243!5563390!6
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor jr3_pci driver to remove forward declarations
Date: Fri, 4 May 2012 15:57:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041557.24738.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver and associated variables to the
end of the source. This is more typical of how other drivers are
written and removes the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 114885d..9e21de0 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -59,28 +59,6 @@ Devices: [JR3] PCI force sensor board (jr3_pci)
 #define PCI_DEVICE_ID_JR3_3_CHANNEL 0x3113
 #define PCI_DEVICE_ID_JR3_4_CHANNEL 0x3114
 
-static int jr3_pci_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int jr3_pci_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_jr3_pci = {
-	.driver_name = "jr3_pci",
-	.module = THIS_MODULE,
-	.attach = jr3_pci_attach,
-	.detach = jr3_pci_detach,
-};
-
-static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_4_CHANNEL) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, jr3_pci_pci_table);
-
 struct jr3_pci_dev_private {
 
 	struct pci_dev *pci_dev;
@@ -948,8 +926,6 @@ out:
 	return result;
 }
 
-MODULE_FIRMWARE("comedi/jr3pci.idm");
-
 static int jr3_pci_detach(struct comedi_device *dev)
 {
 	int i;
@@ -974,6 +950,13 @@ static int jr3_pci_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_jr3_pci = {
+	.driver_name	= "jr3_pci",
+	.module		= THIS_MODULE,
+	.attach		= jr3_pci_attach,
+	.detach		= jr3_pci_detach,
+};
+
 static int __devinit driver_jr3_pci_pci_probe(struct pci_dev *dev,
 					      const struct pci_device_id *ent)
 {
@@ -985,10 +968,20 @@ static void __devexit driver_jr3_pci_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_4_CHANNEL) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, jr3_pci_pci_table);
+
 static struct pci_driver driver_jr3_pci_pci_driver = {
-	.id_table = jr3_pci_pci_table,
-	.probe = &driver_jr3_pci_pci_probe,
-	.remove = __devexit_p(&driver_jr3_pci_pci_remove)
+	.id_table	= jr3_pci_pci_table,
+	.probe		= driver_jr3_pci_pci_probe,
+	.remove		= __devexit_p(driver_jr3_pci_pci_remove),
 };
 
 static int __init driver_jr3_pci_init_module(void)
@@ -1002,16 +995,16 @@ static int __init driver_jr3_pci_init_module(void)
 	driver_jr3_pci_pci_driver.name = (char *)driver_jr3_pci.driver_name;
 	return pci_register_driver(&driver_jr3_pci_pci_driver);
 }
+module_init(driver_jr3_pci_init_module);
 
 static void __exit driver_jr3_pci_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_jr3_pci_pci_driver);
 	comedi_driver_unregister(&driver_jr3_pci);
 }
-
-module_init(driver_jr3_pci_init_module);
 module_exit(driver_jr3_pci_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("comedi/jr3pci.idm");
