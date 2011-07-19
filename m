Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1GSDjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:39:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62903 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1GSDjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:39:07 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/2 v2] Staging: comedi: fix printk() issue in adv_pci1710.c
Date: Tue, 19 Jul 2011 09:22:01 +0530
Message-Id: <1311047521-4113-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix printk() issue in adv_pci1710.c>
References: <[PATCH]Staging: comedi: fix printk() issue in adv_pci1710.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the adv_pci1710.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---

 KERN_INFO is replaced by KERN_ERR. 


 drivers/staging/comedi/drivers/adv_pci1710.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index fd71cc6..093b9e6 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1396,14 +1396,14 @@ static int pci1710_attach(struct comedi_device *dev,
 	int i;
 	int board_index;
 
-	printk("comedi%d: adv_pci1710: ", dev->minor);
+	printk(KERN_INFO "comedi%d: adv_pci1710: ", dev->minor);
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
 	ret = alloc_private(dev, sizeof(struct pci1710_private));
 	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+		printk(KERN_ERR " - Allocation failed!\n");
 		return -ENOMEM;
 	}
 
@@ -1451,10 +1451,10 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	if (!pcidev) {
 		if (opt_bus || opt_slot) {
-			printk(" - Card at b:s %d:%d %s\n",
+			printk(KERN_ERR " - Card at b:s %d:%d %s\n",
 			       opt_bus, opt_slot, errstr);
 		} else {
-			printk(" - Card %s\n", errstr);
+			printk(KERN_ERR " - Card %s\n", errstr);
 		}
 		return -EIO;
 	}
@@ -1465,7 +1465,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	irq = pcidev->irq;
 	iobase = pci_resource_start(pcidev, 2);
 
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot, pci_func,
+	printk(KERN_INFO ", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot,
+	  pci_func, iobase);
 
 	dev->iobase = iobase;
@@ -1487,7 +1487,7 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	ret = alloc_subdevices(dev, n_subdevices);
 	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+		printk(KERN_ERR " - Allocation failed!\n");
 		return ret;
 	}
 
@@ -1499,14 +1499,14 @@ static int pci1710_attach(struct comedi_device *dev,
 					IRQF_SHARED, "Advantech PCI-1710",
 					dev)) {
 				printk
-				    (", unable to allocate IRQ %d, DISABLING IT",
+				    (KERN_CONT ", unable to allocate IRQ %d, DISABLING IT",
 				     irq);
 				irq = 0;	/* Can't use IRQ */
 			} else {
-				printk(", irq=%u", irq);
+				printk(KERN_CONT ", irq=%u", irq);
 			}
 		} else {
-			printk(", IRQ disabled");
+			printk(KERN_CONT ", IRQ disabled");
 		}
 	} else {
 		irq = 0;
@@ -1514,7 +1514,7 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	dev->irq = irq;
 
-	printk(".\n");
+	printk(KERN_CONT ".\n");
 
 	subdev = 0;
 
-- 
1.6.5.2

