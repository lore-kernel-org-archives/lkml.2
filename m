Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2JZAV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:21:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:32876 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab2JZAVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:21:53 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH v4] staging/comedi: Use pr_ or dev_ printks in drivers/gsc_hpdi.c
Date: Fri, 26 Oct 2012 09:21:45 +0900
Message-Id: <1351210905-20366-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121025192430.GA26555@kroah.com>
References: <20121025192430.GA26555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

some of them have been replaced by dev_dbg.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/gsc_hpdi.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 17aec51..4809295 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -479,7 +479,7 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int i;
 	int retval;
 
-	printk(KERN_WARNING "comedi%d: gsc_hpdi\n", dev->minor);
+	dev_dbg(dev->class_dev, "gsc_hpdi\n");
 
 	devpriv = kzalloc(sizeof(*devpriv), GFP_KERNEL);
 	if (!devpriv)
@@ -510,17 +510,17 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		} while (pcidev != NULL);
 	}
 	if (dev->board_ptr == NULL) {
-		printk(KERN_WARNING "gsc_hpdi: no hpdi card found\n");
+		dev_warn(dev->class_dev, "no hpdi card found\n");
 		return -EIO;
 	}
 
-	printk(KERN_WARNING
-	       "gsc_hpdi: found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_warn(dev->class_dev,
+		 "found %s on bus %i, slot %i\n", board(dev)->name,
+		 pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
-		printk(KERN_WARNING
-		       " failed enable PCI device and request regions\n");
+		dev_warn(dev->class_dev,
+			 "failed enable PCI device and request regions\n");
 		return -EIO;
 	}
 	pci_set_master(pcidev);
@@ -541,7 +541,7 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    ioremap(devpriv->hpdi_phys_iobase,
 		    pci_resource_len(pcidev, HPDI_BADDRINDEX));
 	if (!devpriv->plx9080_iobase || !devpriv->hpdi_iobase) {
-		printk(KERN_WARNING " failed to remap io memory\n");
+		dev_warn(dev->class_dev, "failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -553,13 +553,13 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
 			dev->driver->driver_name, dev)) {
-		printk(KERN_WARNING
-		       " unable to allocate irq %u\n", pcidev->irq);
+		dev_warn(dev->class_dev,
+			 "unable to allocate irq %u\n", pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
 
-	printk(KERN_WARNING " irq %u\n", dev->irq);
+	dev_dbg(dev->class_dev, " irq %u\n", dev->irq);
 
 	/*  allocate pci dma buffers */
 	for (i = 0; i < NUM_DMA_BUFFERS; i++) {
@@ -577,8 +577,8 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 						   &devpriv->
 						   dma_desc_phys_addr);
 	if (devpriv->dma_desc_phys_addr & 0xf) {
-		printk(KERN_WARNING
-		       " dma descriptors not quad-word aligned (bug)\n");
+		dev_warn(dev->class_dev,
+			 " dma descriptors not quad-word aligned (bug)\n");
 		return -EIO;
 	}
 
-- 
1.7.9.5

