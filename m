Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1GVLYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:24:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64004 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1GVLYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:24:47 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/2 v3] Staging: comedi: fix printk issue in adv_pci1710.c
Date: Fri, 22 Jul 2011 16:54:21 +0530
Message-Id: <1311333861-5675-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: Comedi: fix printk issue in adv_pci1710.c>
References: <[PATCH]Staging: Comedi: fix printk issue in adv_pci1710.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the adv_pci1710.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---

Converted printk to dev_ versions 

 drivers/staging/comedi/drivers/adv_pci1710.c |   31 ++++++++++++-------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index da2b75b..4f863ec 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1382,14 +1382,13 @@ static int pci1710_attach(struct comedi_device *dev,
 	int i;
 	int board_index;
 
-	printk("comedi%d: adv_pci1710: ", dev->minor);
-
+	dev_info(dev->hw_dev, "comedi%d: adv_pci1710: ", dev->minor);
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
 	ret = alloc_private(dev, sizeof(struct pci1710_private));
 	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+		dev_err(dev->hw_dev, " - Allocation failed!\n");
 		return -ENOMEM;
 	}
 
@@ -1429,17 +1428,19 @@ static int pci1710_attach(struct comedi_device *dev,
 			    "failed to enable PCI device and request regions!";
 			continue;
 		}
-		/*  fixup board_ptr in case we were using the dummy entry with the driver name */
+		/* fixup board_ptr in case we were using the dummy
+		 * entry with the driver name
+		 */
 		dev->board_ptr = &boardtypes[board_index];
 		break;
 	}
 
 	if (!pcidev) {
 		if (opt_bus || opt_slot) {
-			printk(" - Card at b:s %d:%d %s\n",
-			       opt_bus, opt_slot, errstr);
+			dev_err(dev->hw_dev, " - Card at b:s %d:%d %s\n",
+					opt_bus, opt_slot, errstr);
 		} else {
-			printk(" - Card %s\n", errstr);
+			dev_err(dev->hw_dev, " - Card %s\n", errstr);
 		}
 		return -EIO;
 	}
@@ -1450,8 +1451,8 @@ static int pci1710_attach(struct comedi_device *dev,
 	irq = pcidev->irq;
 	iobase = pci_resource_start(pcidev, 2);
 
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot, pci_func,
-	       iobase);
+	dev_info(dev->hw_dev, ", b:s:f=%d:%d:%d, io=0x%4lx",
+			pci_bus, pci_slot, pci_func, iobase);
 
 	dev->iobase = iobase;
 
@@ -1472,7 +1473,7 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	ret = alloc_subdevices(dev, n_subdevices);
 	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+		dev_err(dev->hw_dev, " - Allocation failed!\n");
 		return ret;
 	}
 
@@ -1483,15 +1484,13 @@ static int pci1710_attach(struct comedi_device *dev,
 			if (request_irq(irq, interrupt_service_pci1710,
 					IRQF_SHARED, "Advantech PCI-1710",
 					dev)) {
-				printk
-				    (", unable to allocate IRQ %d, DISABLING IT",
-				     irq);
+				pr_info(", unable to allocate IRQ %d,DISABLING IT", irq);
 				irq = 0;	/* Can't use IRQ */
 			} else {
-				printk(", irq=%u", irq);
+				pr_cont(", irq=%u", irq);
 			}
 		} else {
-			printk(", IRQ disabled");
+			pr_cont(", IRQ disabled");
 		}
 	} else {
 		irq = 0;
@@ -1499,7 +1498,7 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	dev->irq = irq;
 
-	printk(".\n");
+	pr_cont(".\n");
 
 	subdev = 0;
 
-- 
1.6.5.2

