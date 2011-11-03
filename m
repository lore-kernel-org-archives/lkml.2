Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1KCGkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:40:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54315 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1KCGkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:40:20 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 08/14] Staging: comedi: fix printk issue in adv_pci1710.c
Date: Thu,  3 Nov 2011 12:09:56 +0530
Message-Id: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adv_pci1710.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_version and Removed an unnecessary printk
statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |   32 +++++++++----------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index da2b75b..8318c82 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1382,16 +1382,14 @@ static int pci1710_attach(struct comedi_device *dev,
 	int i;
 	int board_index;
 
-	printk("comedi%d: adv_pci1710: ", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: adv_pci1710:\n", dev->minor);
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
 	ret = alloc_private(dev, sizeof(struct pci1710_private));
-	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+	if (ret < 0)
 		return -ENOMEM;
-	}
 
 	/* Look for matching PCI device */
 	errstr = "not found!";
@@ -1436,10 +1434,10 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	if (!pcidev) {
 		if (opt_bus || opt_slot) {
-			printk(" - Card at b:s %d:%d %s\n",
-			       opt_bus, opt_slot, errstr);
+			dev_err(dev->hw_dev, "- Card at b:s %d:%d %s\n",
+				opt_bus, opt_slot, errstr);
 		} else {
-			printk(" - Card %s\n", errstr);
+			dev_err(dev->hw_dev, "- Card %s\n", errstr);
 		}
 		return -EIO;
 	}
@@ -1450,8 +1448,8 @@ static int pci1710_attach(struct comedi_device *dev,
 	irq = pcidev->irq;
 	iobase = pci_resource_start(pcidev, 2);
 
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot, pci_func,
-	       iobase);
+	dev_dbg(dev->hw_dev, "b:s:f=%d:%d:%d, io=0x%4lx\n", pci_bus, pci_slot,
+		pci_func, iobase);
 
 	dev->iobase = iobase;
 
@@ -1471,10 +1469,8 @@ static int pci1710_attach(struct comedi_device *dev,
 		n_subdevices++;
 
 	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+	if (ret < 0)
 		return ret;
-	}
 
 	pci1710_reset(dev);
 
@@ -1483,24 +1479,20 @@ static int pci1710_attach(struct comedi_device *dev,
 			if (request_irq(irq, interrupt_service_pci1710,
 					IRQF_SHARED, "Advantech PCI-1710",
 					dev)) {
-				printk
-				    (", unable to allocate IRQ %d, DISABLING IT",
-				     irq);
+				dev_dbg(dev->hw_dev, "unable to allocate IRQ %d, DISABLING IT",
+					irq);
 				irq = 0;	/* Can't use IRQ */
 			} else {
-				printk(", irq=%u", irq);
+				dev_dbg(dev->hw_dev, "irq=%u", irq);
 			}
 		} else {
-			printk(", IRQ disabled");
+			dev_dbg(dev->hw_dev, "IRQ disabled");
 		}
 	} else {
 		irq = 0;
 	}
 
 	dev->irq = irq;
-
-	printk(".\n");
-
 	subdev = 0;
 
 	if (this_board->n_aichan) {
-- 
1.7.0.4

