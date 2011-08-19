Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1HSNoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:44:55 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:43290 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab1HSNow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:44:52 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmal.com>
Subject: [PATCH] Staging: comedi: fix printk issue in adv_pci1710.c
Date: Fri, 19 Aug 2011 09:44:28 -0400
Message-Id: <1313761468-8055-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi: fix printk warning issue in adv_pci1710.c>
References: <[PATCH]Staging: comedi: fix printk warning issue in adv_pci1710.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the adv_pci1710.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmal.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |   28 +++++++++++++-------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index da2b75b..e6c0f06 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1382,14 +1382,13 @@ static int pci1710_attach(struct comedi_device *dev,
 	int i;
 	int board_index;
 
-	printk("comedi%d: adv_pci1710: ", dev->minor);
+	pr_info("comedi%d: adv_pci1710: ", dev->minor);
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
 	ret = alloc_private(dev, sizeof(struct pci1710_private));
 	if (ret < 0) {
-		printk(" - Allocation failed!\n");
 		return -ENOMEM;
 	}
 
@@ -1436,10 +1435,13 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	if (!pcidev) {
 		if (opt_bus || opt_slot) {
-			printk(" - Card at b:s %d:%d %s\n",
-			       opt_bus, opt_slot, errstr);
+			pr_cont("\n");
+			pr_err("comedi%d: adv_pci1710: Card at b:s %d:%d %s\n",
+					dev->minor, opt_bus, opt_slot, errstr);
 		} else {
-			printk(" - Card %s\n", errstr);
+			pr_cont("\n");
+			pr_err("comedi%d: adv_pci1710: Card %s\n", dev->minor,
+					errstr);
 		}
 		return -EIO;
 	}
@@ -1450,8 +1452,8 @@ static int pci1710_attach(struct comedi_device *dev,
 	irq = pcidev->irq;
 	iobase = pci_resource_start(pcidev, 2);
 
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot, pci_func,
-	       iobase);
+	pr_cont(", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot, pci_func,
+			iobase);
 
 	dev->iobase = iobase;
 
@@ -1472,7 +1474,6 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	ret = alloc_subdevices(dev, n_subdevices);
 	if (ret < 0) {
-		printk(" - Allocation failed!\n");
 		return ret;
 	}
 
@@ -1483,15 +1484,14 @@ static int pci1710_attach(struct comedi_device *dev,
 			if (request_irq(irq, interrupt_service_pci1710,
 					IRQF_SHARED, "Advantech PCI-1710",
 					dev)) {
-				printk
-				    (", unable to allocate IRQ %d, DISABLING IT",
-				     irq);
+				pr_info(", unable to allocate IRQ %d, DISABLING IT",
+						irq);
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
@@ -1499,7 +1499,7 @@ static int pci1710_attach(struct comedi_device *dev,
 
 	dev->irq = irq;
 
-	printk(".\n");
+	pr_cont(".\n");
 
 	subdev = 0;
 
-- 
1.7.6

