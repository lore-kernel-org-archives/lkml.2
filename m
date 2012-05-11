Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2EKXQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:16:33 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:12667 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2EKXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:16:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1336778187!11350925!9
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] staging: comedi: Use module_comedi_pci_driver and standardize drivers
Date: Fri, 11 May 2012 16:16:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205111616.21236.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the refactored comedi pci drivers to use the
module_comedi_pci_driver() macro which makes the code
smaller and a bit simpler.
    
In the process, rename some of the symbols in the driver
to standardize the comedi pci drivers.

Based on the driver {name}:
1) Rename the comedi_driver to {name}_driver.
2) Use a static string {name} for the comedi_driver.driver_name.
3) Rename the pci probe/remove functions to {name)_pci_probe/remove.
4) Rename the pci id_table to {name}_pci_table.
5) Add the static string {name} for the pci_driver.name.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/adl_pci6208.c  |   50 +++++++-----------------
 drivers/staging/comedi/drivers/adl_pci7230.c  |   42 +++++---------------
 drivers/staging/comedi/drivers/adl_pci7296.c  |   42 +++++---------------
 drivers/staging/comedi/drivers/adl_pci7432.c  |   42 +++++---------------
 drivers/staging/comedi/drivers/adl_pci8164.c  |   40 +++++---------------
 drivers/staging/comedi/drivers/adl_pci9111.c  |   40 +++++--------------
 drivers/staging/comedi/drivers/adv_pci1723.c  |   44 ++++++---------------
 drivers/staging/comedi/drivers/dt3000.c       |   44 ++++++---------------
 drivers/staging/comedi/drivers/dyna_pci10xx.c |   41 +++++---------------
 drivers/staging/comedi/drivers/jr3_pci.c      |   38 +++++--------------
 drivers/staging/comedi/drivers/ke_counter.c   |   44 ++++++---------------
 drivers/staging/comedi/drivers/me4000.c       |   38 +++++--------------
 drivers/staging/comedi/drivers/me_daq.c       |   46 +++++++----------------
 drivers/staging/comedi/drivers/rtd520.c       |   40 +++++--------------
 drivers/staging/comedi/drivers/s626.c         |   38 +++++--------------
 15 files changed, 174 insertions(+), 455 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 889d147..f9fefef 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -54,8 +54,6 @@ References:
 #include "../comedidev.h"
 #include "comedi_pci.h"
 
-#define PCI6208_DRIVER_NAME	"adl_pci6208"
-
 /* Board descriptions */
 struct pci6208_board {
 	const char *name;
@@ -248,7 +246,7 @@ pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
 	unsigned long io_base, io_range, lcr_io_base, lcr_io_range;
 
 	/*  Enable PCI device and request regions */
-	if (comedi_pci_enable(pci_dev, PCI6208_DRIVER_NAME) < 0) {
+	if (comedi_pci_enable(pci_dev, "adl_pci6208") < 0) {
 		printk(KERN_ERR "comedi%d: Failed to enable PCI device "
 			"and request regions\n",
 			dev_minor);
@@ -345,59 +343,41 @@ static int pci6208_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_pci6208 = {
-	.driver_name	= PCI6208_DRIVER_NAME,
+static struct comedi_driver adl_pci6208_driver = {
+	.driver_name	= "adl_pci6208",
 	.module		= THIS_MODULE,
 	.attach		= pci6208_attach,
 	.detach		= pci6208_detach,
 };
 
-static int __devinit driver_pci6208_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
+static int __devinit adl_pci6208_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_pci6208);
+	return comedi_pci_auto_config(dev, &adl_pci6208_driver);
 }
 
-static void __devexit driver_pci6208_pci_remove(struct pci_dev *dev)
+static void __devexit adl_pci6208_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
 /* This is used by modprobe to translate PCI IDs to drivers.  Should
  * only be used for PCI and ISA-PnP devices */
-static DEFINE_PCI_DEVICE_TABLE(pci6208_pci_table) = {
+static DEFINE_PCI_DEVICE_TABLE(adl_pci6208_pci_table) = {
 	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
 	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, 0x6208) },
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(pci, pci6208_pci_table);
+MODULE_DEVICE_TABLE(pci, adl_pci6208_pci_table);
 
-static struct pci_driver driver_pci6208_pci_driver = {
-	.id_table	= pci6208_pci_table,
-	.probe		= driver_pci6208_pci_probe,
-	.remove		= __devexit_p(driver_pci6208_pci_remove),
+static struct pci_driver adl_pci6208_pci_driver = {
+	.name		= "adl_pci6208",
+	.id_table	= adl_pci6208_pci_table,
+	.probe		= adl_pci6208_pci_probe,
+	.remove		= __devexit_p(adl_pci6208_pci_remove),
 };
-
-static int __init driver_pci6208_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pci6208);
-	if (retval < 0)
-		return retval;
-
-	driver_pci6208_pci_driver.name = (char *)driver_pci6208.driver_name;
-	return pci_register_driver(&driver_pci6208_pci_driver);
-}
-module_init(driver_pci6208_init_module);
-
-static void __exit driver_pci6208_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pci6208_pci_driver);
-	comedi_driver_unregister(&driver_pci6208);
-}
-module_exit(driver_pci6208_cleanup_module);
+module_comedi_pci_driver(adl_pci6208_driver, adl_pci6208_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 7bb66b0..430ec73 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -163,57 +163,37 @@ static int adl_pci7230_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_adl_pci7230 = {
+static struct comedi_driver adl_pci7230_driver = {
 	.driver_name	= "adl_pci7230",
 	.module		= THIS_MODULE,
 	.attach		= adl_pci7230_attach,
 	.detach		= adl_pci7230_detach,
 };
 
-static int __devinit driver_adl_pci7230_pci_probe(struct pci_dev *dev,
-						  const struct pci_device_id
-						  *ent)
+static int __devinit adl_pci7230_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_adl_pci7230);
+	return comedi_pci_auto_config(dev, &adl_pci7230_driver);
 }
 
-static void __devexit driver_adl_pci7230_pci_remove(struct pci_dev *dev)
+static void __devexit adl_pci7230_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci7230_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7230) },
-	{0}
+	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, adl_pci7230_pci_table);
 
-static struct pci_driver driver_adl_pci7230_pci_driver = {
+static struct pci_driver adl_pci7230_pci_driver = {
+	.name		= "adl_pci7230",
 	.id_table	= adl_pci7230_pci_table,
-	.probe		= driver_adl_pci7230_pci_probe,
-	.remove		= __devexit_p(driver_adl_pci7230_pci_remove)
+	.probe		= adl_pci7230_pci_probe,
+	.remove		= __devexit_p(adl_pci7230_pci_remove),
 };
-
-static int __init driver_adl_pci7230_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_adl_pci7230);
-	if (retval < 0)
-		return retval;
-
-	driver_adl_pci7230_pci_driver.name =
-	    (char *)driver_adl_pci7230.driver_name;
-	return pci_register_driver(&driver_adl_pci7230_pci_driver);
-}
-module_init(driver_adl_pci7230_init_module);
-
-static void __exit driver_adl_pci7230_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_adl_pci7230_pci_driver);
-	comedi_driver_unregister(&driver_adl_pci7230);
-}
-module_exit(driver_adl_pci7230_cleanup_module);
+module_comedi_pci_driver(adl_pci7230_driver, adl_pci7230_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 2bd749b..a84a384 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -155,57 +155,37 @@ static int adl_pci7296_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_adl_pci7296 = {
+static struct comedi_driver adl_pci7296_driver = {
 	.driver_name	= "adl_pci7296",
 	.module		= THIS_MODULE,
 	.attach		= adl_pci7296_attach,
 	.detach		= adl_pci7296_detach,
 };
 
-static int __devinit driver_adl_pci7296_pci_probe(struct pci_dev *dev,
-						  const struct pci_device_id
-						  *ent)
+static int __devinit adl_pci7296_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_adl_pci7296);
+	return comedi_pci_auto_config(dev, &adl_pci7296_driver);
 }
 
-static void __devexit driver_adl_pci7296_pci_remove(struct pci_dev *dev)
+static void __devexit adl_pci7296_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci7296_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7296) },
-	{0}
+	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, adl_pci7296_pci_table);
 
-static struct pci_driver driver_adl_pci7296_pci_driver = {
+static struct pci_driver adl_pci7296_pci_driver = {
+	.name		= "adl_pci7296",
 	.id_table	= adl_pci7296_pci_table,
-	.probe		= driver_adl_pci7296_pci_probe,
-	.remove		= __devexit_p(driver_adl_pci7296_pci_remove)
+	.probe		= adl_pci7296_pci_probe,
+	.remove		= __devexit_p(adl_pci7296_pci_remove),
 };
-
-static int __init driver_adl_pci7296_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_adl_pci7296);
-	if (retval < 0)
-		return retval;
-
-	driver_adl_pci7296_pci_driver.name =
-	    (char *)driver_adl_pci7296.driver_name;
-	return pci_register_driver(&driver_adl_pci7296_pci_driver);
-}
-module_init(driver_adl_pci7296_init_module);
-
-static void __exit driver_adl_pci7296_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_adl_pci7296_pci_driver);
-	comedi_driver_unregister(&driver_adl_pci7296);
-}
-module_exit(driver_adl_pci7296_cleanup_module);
+module_comedi_pci_driver(adl_pci7296_driver, adl_pci7296_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index db15ec6e..330be9d 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -174,57 +174,37 @@ static int adl_pci7432_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_adl_pci7432 = {
+static struct comedi_driver adl_pci7432_driver = {
 	.driver_name	= "adl_pci7432",
 	.module		= THIS_MODULE,
 	.attach		= adl_pci7432_attach,
 	.detach		= adl_pci7432_detach,
 };
 
-static int __devinit driver_adl_pci7432_pci_probe(struct pci_dev *dev,
-						  const struct pci_device_id
-						  *ent)
+static int __devinit adl_pci7432_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_adl_pci7432);
+	return comedi_pci_auto_config(dev, &adl_pci7432_driver);
 }
 
-static void __devexit driver_adl_pci7432_pci_remove(struct pci_dev *dev)
+static void __devexit adl_pci7432_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci7432_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7432) },
-	{0}
+	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, adl_pci7432_pci_table);
 
-static struct pci_driver driver_adl_pci7432_pci_driver = {
+static struct pci_driver adl_pci7432_pci_driver = {
+	.name		= "adl_pci7432",
 	.id_table	= adl_pci7432_pci_table,
-	.probe		= driver_adl_pci7432_pci_probe,
-	.remove		= __devexit_p(driver_adl_pci7432_pci_remove)
+	.probe		= adl_pci7432_pci_probe,
+	.remove		= __devexit_p(adl_pci7432_pci_remove),
 };
-
-static int __init driver_adl_pci7432_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_adl_pci7432);
-	if (retval < 0)
-		return retval;
-
-	driver_adl_pci7432_pci_driver.name =
-	    (char *)driver_adl_pci7432.driver_name;
-	return pci_register_driver(&driver_adl_pci7432_pci_driver);
-}
-module_init(driver_adl_pci7432_init_module);
-
-static void __exit driver_adl_pci7432_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_adl_pci7432_pci_driver);
-	comedi_driver_unregister(&driver_adl_pci7432);
-}
-module_exit(driver_adl_pci7432_cleanup_module);
+module_comedi_pci_driver(adl_pci7432_driver, adl_pci7432_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 6b32e45..9c5906b 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -327,21 +327,20 @@ static int adl_pci8164_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_adl_pci8164 = {
+static struct comedi_driver adl_pci8164_driver = {
 	.driver_name	= "adl_pci8164",
 	.module		= THIS_MODULE,
 	.attach		= adl_pci8164_attach,
 	.detach		= adl_pci8164_detach,
 };
 
-static int __devinit driver_adl_pci8164_pci_probe(struct pci_dev *dev,
-						  const struct pci_device_id
-						  *ent)
+static int __devinit adl_pci8164_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_adl_pci8164);
+	return comedi_pci_auto_config(dev, &adl_pci8164_driver);
 }
 
-static void __devexit driver_adl_pci8164_pci_remove(struct pci_dev *dev)
+static void __devexit adl_pci8164_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
@@ -352,32 +351,13 @@ static DEFINE_PCI_DEVICE_TABLE(adl_pci8164_pci_table) = {
 };
 MODULE_DEVICE_TABLE(pci, adl_pci8164_pci_table);
 
-static struct pci_driver driver_adl_pci8164_pci_driver = {
+static struct pci_driver adl_pci8164_pci_driver = {
+	.name		= "adl_pci8164",
 	.id_table	= adl_pci8164_pci_table,
-	.probe		= driver_adl_pci8164_pci_probe,
-	.remove		= __devexit_p(driver_adl_pci8164_pci_remove),
+	.probe		= adl_pci8164_pci_probe,
+	.remove		= __devexit_p(adl_pci8164_pci_remove),
 };
-
-static int __init driver_adl_pci8164_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_adl_pci8164);
-	if (retval < 0)
-		return retval;
-
-	driver_adl_pci8164_pci_driver.name =
-	    (char *)driver_adl_pci8164.driver_name;
-	return pci_register_driver(&driver_adl_pci8164_pci_driver);
-}
-module_init(driver_adl_pci8164_init_module);
-
-static void __exit driver_adl_pci8164_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_adl_pci8164_pci_driver);
-	comedi_driver_unregister(&driver_adl_pci8164);
-}
-module_exit(driver_adl_pci8164_cleanup_module);
+module_comedi_pci_driver(adl_pci8164_driver, adl_pci8164_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 4e4e5fd..31dfd86 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1407,20 +1407,20 @@ static int pci9111_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver pci9111_driver = {
-	.driver_name	= PCI9111_DRIVER_NAME,
+static struct comedi_driver adl_pci9111_driver = {
+	.driver_name	= "adl_pci9111",
 	.module		= THIS_MODULE,
 	.attach		= pci9111_attach,
 	.detach		= pci9111_detach,
 };
 
-static int __devinit pci9111_driver_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
+static int __devinit pci9111_pci_probe(struct pci_dev *dev,
+				       const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &pci9111_driver);
+	return comedi_pci_auto_config(dev, &adl_pci9111_driver);
 }
 
-static void __devexit pci9111_driver_pci_remove(struct pci_dev *dev)
+static void __devexit pci9111_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
@@ -1432,31 +1432,13 @@ static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
 };
 MODULE_DEVICE_TABLE(pci, pci9111_pci_table);
 
-static struct pci_driver pci9111_driver_pci_driver = {
+static struct pci_driver adl_pci9111_pci_driver = {
+	.name		= "adl_pci9111",
 	.id_table	= pci9111_pci_table,
-	.probe		= pci9111_driver_pci_probe,
-	.remove		= __devexit_p(pci9111_driver_pci_remove),
+	.probe		= pci9111_pci_probe,
+	.remove		= __devexit_p(pci9111_pci_remove),
 };
-
-static int __init pci9111_driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&pci9111_driver);
-	if (retval < 0)
-		return retval;
-
-	pci9111_driver_pci_driver.name = (char *)pci9111_driver.driver_name;
-	return pci_register_driver(&pci9111_driver_pci_driver);
-}
-module_init(pci9111_driver_init_module);
-
-static void __exit pci9111_driver_cleanup_module(void)
-{
-	pci_unregister_driver(&pci9111_driver_pci_driver);
-	comedi_driver_unregister(&pci9111_driver);
-}
-module_exit(pci9111_driver_cleanup_module);
+module_comedi_pci_driver(adl_pci9111_driver, adl_pci9111_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 54a3304..6356bd8 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -449,55 +449,37 @@ static int pci1723_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_pci1723 = {
+static struct comedi_driver adv_pci1723_driver = {
 	.driver_name	= "adv_pci1723",
 	.module		= THIS_MODULE,
 	.attach		= pci1723_attach,
 	.detach		= pci1723_detach,
 };
 
-static int __devinit driver_pci1723_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
+static int __devinit adv_pci1723_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_pci1723);
+	return comedi_pci_auto_config(dev, &adv_pci1723_driver);
 }
 
-static void __devexit driver_pci1723_pci_remove(struct pci_dev *dev)
+static void __devexit adv_pci1723_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pci1723_pci_table) = {
+static DEFINE_PCI_DEVICE_TABLE(adv_pci1723_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1723) },
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(pci, pci1723_pci_table);
+MODULE_DEVICE_TABLE(pci, adv_pci1723_pci_table);
 
-static struct pci_driver driver_pci1723_pci_driver = {
-	.id_table	= pci1723_pci_table,
-	.probe		= driver_pci1723_pci_probe,
-	.remove		= __devexit_p(driver_pci1723_pci_remove),
+static struct pci_driver adv_pci1723_pci_driver = {
+	.name		= "adv_pci1723",
+	.id_table	= adv_pci1723_pci_table,
+	.probe		= adv_pci1723_pci_probe,
+	.remove		= __devexit_p(adv_pci1723_pci_remove),
 };
-
-static int __init driver_pci1723_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pci1723);
-	if (retval < 0)
-		return retval;
-
-	driver_pci1723_pci_driver.name = (char *)driver_pci1723.driver_name;
-	return pci_register_driver(&driver_pci1723_pci_driver);
-}
-module_init(driver_pci1723_init_module);
-
-static void __exit driver_pci1723_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pci1723_pci_driver);
-	comedi_driver_unregister(&driver_pci1723);
-}
-module_exit(driver_pci1723_cleanup_module);
+module_comedi_pci_driver(adv_pci1723_driver, adv_pci1723_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 932eac9..6d113cd 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -962,25 +962,25 @@ static int dt3000_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_dt3000 = {
+static struct comedi_driver dt3000_driver = {
 	.driver_name	= "dt3000",
 	.module		= THIS_MODULE,
 	.attach		= dt3000_attach,
 	.detach		= dt3000_detach,
 };
 
-static int __devinit driver_dt3000_pci_probe(struct pci_dev *dev,
-					     const struct pci_device_id *ent)
+static int __devinit dt3000_pci_probe(struct pci_dev *dev,
+				      const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_dt3000);
+	return comedi_pci_auto_config(dev, &dt3000_driver);
 }
 
-static void __devexit driver_dt3000_pci_remove(struct pci_dev *dev)
+static void __devexit dt3000_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(dt3k_pci_table) = {
+static DEFINE_PCI_DEVICE_TABLE(dt3000_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0022) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0027) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0023) },
@@ -990,33 +990,15 @@ static DEFINE_PCI_DEVICE_TABLE(dt3k_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0026) },
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(pci, dt3k_pci_table);
+MODULE_DEVICE_TABLE(pci, dt3000_pci_table);
 
-static struct pci_driver driver_dt3000_pci_driver = {
-	.id_table	= dt3k_pci_table,
-	.probe		= driver_dt3000_pci_probe,
-	.remove		= __devexit_p(driver_dt3000_pci_remove),
+static struct pci_driver dt3000_pci_driver = {
+	.name		= "dt3000",
+	.id_table	= dt3000_pci_table,
+	.probe		= dt3000_pci_probe,
+	.remove		= __devexit_p(dt3000_pci_remove),
 };
-
-static int __init driver_dt3000_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_dt3000);
-	if (retval < 0)
-		return retval;
-
-	driver_dt3000_pci_driver.name = (char *)driver_dt3000.driver_name;
-	return pci_register_driver(&driver_dt3000_pci_driver);
-}
-module_init(driver_dt3000_init_module);
-
-static void __exit driver_dt3000_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_dt3000_pci_driver);
-	comedi_driver_unregister(&driver_dt3000);
-}
-module_exit(driver_dt3000_cleanup_module);
+module_comedi_pci_driver(dt3000_driver, dt3000_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index bb86c85..23375de 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -397,8 +397,8 @@ static int dyna_pci10xx_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_dyna_pci10xx = {
-	.driver_name	= DRV_NAME,
+static struct comedi_driver dyna_pci10xx_driver = {
+	.driver_name	= "dyna_pci10xx",
 	.module		= THIS_MODULE,
 	.attach		= dyna_pci10xx_attach,
 	.detach		= dyna_pci10xx_detach,
@@ -407,13 +407,13 @@ static struct comedi_driver driver_dyna_pci10xx = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 };
 
-static int __devinit driver_dyna_pci10xx_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
+static int __devinit dyna_pci10xx_pci_probe(struct pci_dev *dev,
+					    const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_dyna_pci10xx);
+	return comedi_pci_auto_config(dev, &dyna_pci10xx_driver);
 }
 
-static void __devexit driver_dyna_pci10xx_pci_remove(struct pci_dev *dev)
+static void __devexit dyna_pci10xx_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
@@ -424,32 +424,13 @@ static DEFINE_PCI_DEVICE_TABLE(dyna_pci10xx_pci_table) = {
 };
 MODULE_DEVICE_TABLE(pci, dyna_pci10xx_pci_table);
 
-static struct pci_driver driver_dyna_pci10xx_pci_driver = {
+static struct pci_driver dyna_pci10xx_pci_driver = {
+	.name		= "dyna_pci10xx",
 	.id_table	= dyna_pci10xx_pci_table,
-	.probe		= driver_dyna_pci10xx_pci_probe,
-	.remove		= __devexit_p(driver_dyna_pci10xx_pci_remove),
+	.probe		= dyna_pci10xx_pci_probe,
+	.remove		= __devexit_p(dyna_pci10xx_pci_remove),
 };
-
-static int __init driver_dyna_pci10xx_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_dyna_pci10xx);
-	if (retval < 0)
-		return retval;
-
-	driver_dyna_pci10xx_pci_driver.name =
-		(char *)driver_dyna_pci10xx.driver_name;
-	return pci_register_driver(&driver_dyna_pci10xx_pci_driver);
-}
-module_init(driver_dyna_pci10xx_init_module);
-
-static void __exit driver_dyna_pci10xx_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_dyna_pci10xx_pci_driver);
-	comedi_driver_unregister(&driver_dyna_pci10xx);
-}
-module_exit(driver_dyna_pci10xx_cleanup_module);
+module_comedi_pci_driver(dyna_pci10xx_driver, dyna_pci10xx_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Prashant Shah <pshah.mumbai@gmail.com>");
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 9e21de0..beb82d9 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -950,20 +950,20 @@ static int jr3_pci_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_jr3_pci = {
+static struct comedi_driver jr3_pci_driver = {
 	.driver_name	= "jr3_pci",
 	.module		= THIS_MODULE,
 	.attach		= jr3_pci_attach,
 	.detach		= jr3_pci_detach,
 };
 
-static int __devinit driver_jr3_pci_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
+static int __devinit jr3_pci_pci_probe(struct pci_dev *dev,
+				       const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_jr3_pci);
+	return comedi_pci_auto_config(dev, &jr3_pci_driver);
 }
 
-static void __devexit driver_jr3_pci_pci_remove(struct pci_dev *dev)
+static void __devexit jr3_pci_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
@@ -978,31 +978,13 @@ static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
 };
 MODULE_DEVICE_TABLE(pci, jr3_pci_pci_table);
 
-static struct pci_driver driver_jr3_pci_pci_driver = {
+static struct pci_driver jr3_pci_pci_driver = {
+	.name		= "jr3_pci",
 	.id_table	= jr3_pci_pci_table,
-	.probe		= driver_jr3_pci_pci_probe,
-	.remove		= __devexit_p(driver_jr3_pci_pci_remove),
+	.probe		= jr3_pci_pci_probe,
+	.remove		= __devexit_p(jr3_pci_pci_remove),
 };
-
-static int __init driver_jr3_pci_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_jr3_pci);
-	if (retval < 0)
-		return retval;
-
-	driver_jr3_pci_pci_driver.name = (char *)driver_jr3_pci.driver_name;
-	return pci_register_driver(&driver_jr3_pci_pci_driver);
-}
-module_init(driver_jr3_pci_init_module);
-
-static void __exit driver_jr3_pci_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_jr3_pci_pci_driver);
-	comedi_driver_unregister(&driver_jr3_pci);
-}
-module_exit(driver_jr3_pci_cleanup_module);
+module_comedi_pci_driver(jr3_pci_driver, jr3_pci_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 0db76a5..708704d 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -231,55 +231,37 @@ static int cnt_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver cnt_driver = {
-	.driver_name	= CNT_DRIVER_NAME,
+static struct comedi_driver ke_counter_driver = {
+	.driver_name	= "ke_counter",
 	.module		= THIS_MODULE,
 	.attach		= cnt_attach,
 	.detach		= cnt_detach,
 };
 
-static int __devinit cnt_driver_pci_probe(struct pci_dev *dev,
+static int __devinit ke_counter_pci_probe(struct pci_dev *dev,
 					  const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &cnt_driver);
+	return comedi_pci_auto_config(dev, &ke_counter_driver);
 }
 
-static void __devexit cnt_driver_pci_remove(struct pci_dev *dev)
+static void __devexit ke_counter_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cnt_pci_table) = {
+static DEFINE_PCI_DEVICE_TABLE(ke_counter_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_KOLTER, CNT_CARD_DEVICE_ID) },
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(pci, cnt_pci_table);
+MODULE_DEVICE_TABLE(pci, ke_counter_pci_table);
 
-static struct pci_driver cnt_driver_pci_driver = {
-	.id_table	= cnt_pci_table,
-	.probe		= cnt_driver_pci_probe,
-	.remove		= __devexit_p(cnt_driver_pci_remove),
+static struct pci_driver ke_counter_pci_driver = {
+	.name		= "ke_counter",
+	.id_table	= ke_counter_pci_table,
+	.probe		= ke_counter_pci_probe,
+	.remove		= __devexit_p(ke_counter_pci_remove),
 };
-
-static int __init cnt_driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&cnt_driver);
-	if (retval < 0)
-		return retval;
-
-	cnt_driver_pci_driver.name = (char *)cnt_driver.driver_name;
-	return pci_register_driver(&cnt_driver_pci_driver);
-}
-module_init(cnt_driver_init_module);
-
-static void __exit cnt_driver_cleanup_module(void)
-{
-	pci_unregister_driver(&cnt_driver_pci_driver);
-	comedi_driver_unregister(&cnt_driver);
-}
-module_exit(cnt_driver_cleanup_module);
+module_comedi_pci_driver(ke_counter_driver, ke_counter_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index c54c071..879acbc 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -2320,20 +2320,20 @@ static int me4000_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_me4000 = {
+static struct comedi_driver me4000_driver = {
 	.driver_name	= "me4000",
 	.module		= THIS_MODULE,
 	.attach		= me4000_attach,
 	.detach		= me4000_detach,
 };
 
-static int __devinit driver_me4000_pci_probe(struct pci_dev *dev,
-					     const struct pci_device_id *ent)
+static int __devinit me4000_pci_probe(struct pci_dev *dev,
+				      const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_me4000);
+	return comedi_pci_auto_config(dev, &me4000_driver);
 }
 
-static void __devexit driver_me4000_pci_remove(struct pci_dev *dev)
+static void __devexit me4000_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
@@ -2356,31 +2356,13 @@ static DEFINE_PCI_DEVICE_TABLE(me4000_pci_table) = {
 };
 MODULE_DEVICE_TABLE(pci, me4000_pci_table);
 
-static struct pci_driver driver_me4000_pci_driver = {
+static struct pci_driver me4000_pci_driver = {
+	.name		= "me4000",
 	.id_table	= me4000_pci_table,
-	.probe		= driver_me4000_pci_probe,
-	.remove		= __devexit_p(driver_me4000_pci_remove),
+	.probe		= me4000_pci_probe,
+	.remove		= __devexit_p(me4000_pci_remove),
 };
-
-static int __init driver_me4000_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_me4000);
-	if (retval < 0)
-		return retval;
-
-	driver_me4000_pci_driver.name = (char *)driver_me4000.driver_name;
-	return pci_register_driver(&driver_me4000_pci_driver);
-}
-module_init(driver_me4000_init_module);
-
-static void __exit driver_me4000_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_me4000_pci_driver);
-	comedi_driver_unregister(&driver_me4000);
-}
-module_exit(driver_me4000_cleanup_module);
+module_comedi_pci_driver(me4000_driver, me4000_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 4ce6339..1f99527 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -825,56 +825,38 @@ static int me_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver me_driver = {
-	.driver_name	= ME_DRIVER_NAME,
+static struct comedi_driver me_daq_driver = {
+	.driver_name	= "me_daq",
 	.module		= THIS_MODULE,
 	.attach		= me_attach,
 	.detach		= me_detach,
 };
 
-static int __devinit me_driver_pci_probe(struct pci_dev *dev,
-					 const struct pci_device_id *ent)
+static int __devinit me_daq_pci_probe(struct pci_dev *dev,
+				      const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &me_driver);
+	return comedi_pci_auto_config(dev, &me_daq_driver);
 }
 
-static void __devexit me_driver_pci_remove(struct pci_dev *dev)
+static void __devexit me_daq_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(me_pci_table) = {
+static DEFINE_PCI_DEVICE_TABLE(me_daq_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2600_DEVICE_ID) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2000_DEVICE_ID) },
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(pci, me_pci_table);
+MODULE_DEVICE_TABLE(pci, me_daq_pci_table);
 
-static struct pci_driver me_driver_pci_driver = {
-	.id_table	= me_pci_table,
-	.probe		= me_driver_pci_probe,
-	.remove		= __devexit_p(me_driver_pci_remove),
+static struct pci_driver me_daq_pci_driver = {
+	.name		= "me_daq",
+	.id_table	= me_daq_pci_table,
+	.probe		= me_daq_pci_probe,
+	.remove		= __devexit_p(me_daq_pci_remove),
 };
-
-static int __init me_driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&me_driver);
-	if (retval < 0)
-		return retval;
-
-	me_driver_pci_driver.name = (char *)me_driver.driver_name;
-	return pci_register_driver(&me_driver_pci_driver);
-}
-module_init(me_driver_init_module);
-
-static void __exit me_driver_cleanup_module(void)
-{
-	pci_unregister_driver(&me_driver_pci_driver);
-	comedi_driver_unregister(&me_driver);
-}
-module_exit(me_driver_cleanup_module);
+module_comedi_pci_driver(me_daq_driver, me_daq_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 0e62bae..32766ed 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -2346,20 +2346,20 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
-static struct comedi_driver rtd520Driver = {
-	.driver_name	= DRV_NAME,
+static struct comedi_driver rtd520_driver = {
+	.driver_name	= "rtd520",
 	.module		= THIS_MODULE,
 	.attach		= rtd_attach,
 	.detach		= rtd_detach,
 };
 
-static int __devinit rtd520Driver_pci_probe(struct pci_dev *dev,
-					    const struct pci_device_id *ent)
+static int __devinit rtd520_pci_probe(struct pci_dev *dev,
+				      const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &rtd520Driver);
+	return comedi_pci_auto_config(dev, &rtd520_driver);
 }
 
-static void __devexit rtd520Driver_pci_remove(struct pci_dev *dev)
+static void __devexit rtd520_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
@@ -2371,31 +2371,13 @@ static DEFINE_PCI_DEVICE_TABLE(rtd520_pci_table) = {
 };
 MODULE_DEVICE_TABLE(pci, rtd520_pci_table);
 
-static struct pci_driver rtd520Driver_pci_driver = {
+static struct pci_driver rtd520_pci_driver = {
+	.name		= "rtd520",
 	.id_table	= rtd520_pci_table,
-	.probe		= &rtd520Driver_pci_probe,
-	.remove		= __devexit_p(&rtd520Driver_pci_remove)
+	.probe		= rtd520_pci_probe,
+	.remove		= __devexit_p(rtd520_pci_remove),
 };
-
-static int __init rtd520Driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&rtd520Driver);
-	if (retval < 0)
-		return retval;
-
-	rtd520Driver_pci_driver.name = (char *)rtd520Driver.driver_name;
-	return pci_register_driver(&rtd520Driver_pci_driver);
-}
-module_init(rtd520Driver_init_module);
-
-static void __exit rtd520Driver_cleanup_module(void)
-{
-	pci_unregister_driver(&rtd520Driver_pci_driver);
-	comedi_driver_unregister(&rtd520Driver);
-}
-module_exit(rtd520Driver_cleanup_module);
+module_comedi_pci_driver(rtd520_driver, rtd520_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index ad4d2f6..56b111f 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -3315,20 +3315,20 @@ static void CountersInit(struct comedi_device *dev)
 
 }
 
-static struct comedi_driver driver_s626 = {
+static struct comedi_driver s626_driver = {
 	.driver_name	= "s626",
 	.module		= THIS_MODULE,
 	.attach		= s626_attach,
 	.detach		= s626_detach,
 };
 
-static int __devinit driver_s626_pci_probe(struct pci_dev *dev,
-					   const struct pci_device_id *ent)
+static int __devinit s626_pci_probe(struct pci_dev *dev,
+				    const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_s626);
+	return comedi_pci_auto_config(dev, &s626_driver);
 }
 
-static void __devexit driver_s626_pci_remove(struct pci_dev *dev)
+static void __devexit s626_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
@@ -3345,31 +3345,13 @@ static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
 };
 MODULE_DEVICE_TABLE(pci, s626_pci_table);
 
-static struct pci_driver driver_s626_pci_driver = {
+static struct pci_driver s626_pci_driver = {
+	.name		= "s626",
 	.id_table	= s626_pci_table,
-	.probe		= driver_s626_pci_probe,
-	.remove		= __devexit_p(driver_s626_pci_remove),
+	.probe		= s626_pci_probe,
+	.remove		= __devexit_p(s626_pci_remove),
 };
-
-static int __init driver_s626_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_s626);
-	if (retval < 0)
-		return retval;
-
-	driver_s626_pci_driver.name = (char *)driver_s626.driver_name;
-	return pci_register_driver(&driver_s626_pci_driver);
-}
-module_init(driver_s626_init_module);
-
-static void __exit driver_s626_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_s626_pci_driver);
-	comedi_driver_unregister(&driver_s626);
-}
-module_exit(driver_s626_cleanup_module);
+module_comedi_pci_driver(s626_driver, s626_pci_driver);
 
 MODULE_AUTHOR("Gianluca Palli <gpalli@deis.unibo.it>");
 MODULE_DESCRIPTION("Sensoray 626 Comedi driver module");
