Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1G0FOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:14:44 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35476 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1G0FOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:14:43 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk issue in amplc_pci230.c
Date: Wed, 27 Jul 2011 10:58:07 +0530
Message-Id: <1311744487-14136-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: Comedi: fix printk issue in amplc_pci230.c>
References: <[PATCH]Staging: Comedi: fix printk issue in amplc_pci230.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the amplc_pci230.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/amplc_pci230.c |   38 ++++++++++++------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 399148b..c6ecc21 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -767,8 +767,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pci_dev *pci_dev = NULL;
 	int i = 0, irq_hdl, rc;
 
-	printk("comedi%d: amplc_pci230: attach %s %d,%d\n", dev->minor,
-	       thisboard->name, it->options[0], it->options[1]);
+	pr_info("comedi%d: amplc_pci230: attach %s %d,%d\n", dev->minor,
+		thisboard->name, it->options[0], it->options[1]);
 
 	/* Allocate the private structure area using alloc_private().
 	 * Macro defined in comedidev.h - memsets struct fields to 0. */
@@ -842,8 +842,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 	if (!pci_dev) {
-		printk("comedi%d: No %s card found\n", dev->minor,
-		       thisboard->name);
+		pr_err("comedi%d: No %s card found\n", dev->minor,
+		       thisboard->name);
 		return -EIO;
 	}
 	devpriv->pci_dev = pci_dev;
@@ -855,8 +855,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* Enable PCI device and reserve I/O spaces. */
 	if (comedi_pci_enable(pci_dev, "amplc_pci230") < 0) {
-		printk("comedi%d: failed to enable PCI device "
-		       "and request regions\n", dev->minor);
+		pr_err("comedi%d: failed to enable PCI device "
+		       "and request regions\n", dev->minor);
 		return -EIO;
 	}
 
@@ -865,8 +865,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	iobase1 = pci_resource_start(pci_dev, 2);
 	iobase2 = pci_resource_start(pci_dev, 3);
 
-	printk("comedi%d: %s I/O region 1 0x%04lx I/O region 2 0x%04lx\n",
-	       dev->minor, dev->board_name, iobase1, iobase2);
+	pr_info("comedi%d: %s I/O region 1 0x%04lx I/O region 2 0x%04lx\n",
+		dev->minor, dev->board_name, iobase1, iobase2);
 
 	devpriv->iobase1 = iobase1;
 	dev->iobase = iobase2;
@@ -881,10 +881,10 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		devpriv->hwver = inw(dev->iobase + PCI230P_HWVER);
 		if (devpriv->hwver < thisboard->min_hwver) {
-			printk("comedi%d: %s - bad hardware version "
-			       "- got %u, need %u\n", dev->minor,
-			       dev->board_name, devpriv->hwver,
-			       thisboard->min_hwver);
+			pr_err("comedi%d: %s - bad hardware version "
+			       "- got %u, need %u\n", dev->minor,
+			       dev->board_name, devpriv->hwver,
+			       thisboard->min_hwver);
 			return -EIO;
 		}
 		if (devpriv->hwver > 0) {
@@ -932,13 +932,13 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq_hdl = request_irq(devpriv->pci_dev->irq, pci230_interrupt,
 			      IRQF_SHARED, "amplc_pci230", dev);
 	if (irq_hdl < 0) {
-		printk("comedi%d: unable to register irq, "
-		       "commands will not be available %d\n", dev->minor,
-		       devpriv->pci_dev->irq);
+		pr_debug("comedi%d: unable to register irq, "
+			 "commands will not be available %d\n", dev->minor,
+			 devpriv->pci_dev->irq);
 		dev->irq = devpriv->pci_dev->irq;
-		printk("comedi%d: registered irq %u\n", dev->minor,
-		       devpriv->pci_dev->irq);
+		pr_debug("comedi%d: registered irq %u\n", dev->minor,
+			devpriv->pci_dev->irq);
 	}
 
 	/*
@@ -1001,7 +1001,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk("comedi%d: attached\n", dev->minor);
+	pr_info("comedi%d: attached\n", dev->minor);
 
 	return 1;
 }
@@ -1016,7 +1016,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 static int pci230_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: amplc_pci230: remove\n", dev->minor);
+	pr_info("comedi%d: amplc_pci230: remove\n", dev->minor);
 
 	if (dev->subdevices && thisboard->have_dio)
 		/* Clean up dio subdevice. */
-- 
1.6.5.2

