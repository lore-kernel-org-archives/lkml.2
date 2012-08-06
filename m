Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2HFVEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:04:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:34602 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2HFVED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="130905915"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: use KBUILD_MODNAME when allocating resources from the OS
Date: Tue,  7 Aug 2012 00:03:54 +0300
Message-Id: <1344287036-22649-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index b0903bd..c7d19f8 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -41,8 +41,6 @@
 #include <linux/mei.h>
 #include "interface.h"
 
-static const char mei_driver_name[] = "mei";
-
 /* The device pointer */
 /* Currently this driver works as long as there is only a single AMT device. */
 struct pci_dev *mei_device;
@@ -933,7 +931,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 	/* set PCI host mastering  */
 	pci_set_master(pdev);
 	/* pci request regions for mei driver */
-	err = pci_request_regions(pdev, mei_driver_name);
+	err = pci_request_regions(pdev, KBUILD_MODNAME);
 	if (err) {
 		dev_err(&pdev->dev, "failed to get pci regions.\n");
 		goto disable_device;
@@ -958,12 +956,12 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_interrupt_thread_handler,
-			IRQF_ONESHOT, mei_driver_name, dev);
+			IRQF_ONESHOT, KBUILD_MODNAME, dev);
 	else
 		err = request_threaded_irq(pdev->irq,
 			mei_interrupt_quick_handler,
 			mei_interrupt_thread_handler,
-			IRQF_SHARED, mei_driver_name, dev);
+			IRQF_SHARED, KBUILD_MODNAME, dev);
 
 	if (err) {
 		dev_err(&pdev->dev, "request_threaded_irq failure. irq = %d\n",
@@ -1123,12 +1121,12 @@ static int mei_pci_resume(struct device *device)
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_interrupt_thread_handler,
-			IRQF_ONESHOT, mei_driver_name, dev);
+			IRQF_ONESHOT, KBUILD_MODNAME, dev);
 	else
 		err = request_threaded_irq(pdev->irq,
 			mei_interrupt_quick_handler,
 			mei_interrupt_thread_handler,
-			IRQF_SHARED, mei_driver_name, dev);
+			IRQF_SHARED, KBUILD_MODNAME, dev);
 
 	if (err) {
 		dev_err(&pdev->dev, "request_threaded_irq failed: irq = %d.\n",
@@ -1155,7 +1153,7 @@ static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
  *  PCI driver structure
  */
 static struct pci_driver mei_driver = {
-	.name = mei_driver_name,
+	.name = KBUILD_MODNAME,
 	.id_table = mei_pci_tbl,
 	.probe = mei_probe,
 	.remove = __devexit_p(mei_remove),
-- 
1.7.4.4

