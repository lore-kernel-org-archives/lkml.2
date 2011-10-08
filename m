Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1JHGhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 02:37:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53556 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1JHGhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 02:37:04 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 2/4] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Sat,  8 Oct 2011 12:05:58 +0530
Message-Id: <1318055759-3549-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318055759-3549-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1318055759-3549-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas64.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 1e32419..95f24f1 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1739,8 +1739,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	uint32_t local_range, local_decode;
 	int retval;
 
-	printk("comedi%d: cb_pcidas64\n", dev->minor);
-
 /*
  * Allocate the private structure area.
  */
@@ -1776,17 +1774,15 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	if (dev->board_ptr == NULL) {
-		printk
-		    ("No supported ComputerBoards/MeasurementComputing card found\n");
+		pr_err("No supported ComputerBoards/MeasurementComputing card found\n");
 		return -EIO;
 	}
 
-	printk("Found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	pr_info("Found %s on bus %i, slot %i\n", board(dev)->name,
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, driver_cb_pcidas.driver_name)) {
-		printk(KERN_WARNING
-		       " failed to enable PCI device and request regions\n");
+		pr_err("failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	pci_set_master(pcidev);
@@ -1814,7 +1810,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (!priv(dev)->plx9080_iobase || !priv(dev)->main_iobase
 	    || !priv(dev)->dio_counter_iobase) {
-		printk(" failed to remap io memory\n");
+		pr_warn("failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -1850,23 +1846,21 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	priv(dev)->hw_revision =
 	    hw_revision(dev, readw(priv(dev)->main_iobase + HW_STATUS_REG));
-	printk(" stc hardware revision %i\n", priv(dev)->hw_revision);
+	pr_debug("stc hardware revision %i\n", priv(dev)->hw_revision);
 	init_plx9080(dev);
 	init_stc_registers(dev);
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
 			"cb_pcidas64", dev)) {
-		printk(" unable to allocate irq %u\n", pcidev->irq);
+		pr_err("unable to allocate irq %u\n", pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
-	printk(" irq %u\n", dev->irq);
+	pr_debug("irq %u\n", dev->irq);
 
 	retval = setup_subdevices(dev);
 	if (retval < 0)
 		return retval;
-
-
 	return 0;
 }
 
@@ -1882,8 +1876,6 @@ static int detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (priv(dev)) {
-- 
1.7.6.4

