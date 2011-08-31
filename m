Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1HaL76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:59:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47440 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1HaL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:59:55 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/3] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Wed, 31 Aug 2011 17:29:40 +0530
Message-Id: <1314791980-2841-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 1/3]Staging : comedi:fix printk issue in cb_pcidas64.c>
References: <[PATCH 1/3]Staging : comedi:fix printk issue in cb_pcidas64.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>

This is a patch to the cb_pcidas64.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 1e32419..a64889b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1739,7 +1739,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	uint32_t local_range, local_decode;
 	int retval;
 
-	printk("comedi%d: cb_pcidas64\n", dev->minor);
+	printk(KERN_INFO "comedi%d: cb_pcidas64\n", dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -1776,13 +1776,13 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	if (dev->board_ptr == NULL) {
-		printk
-		    ("No supported ComputerBoards/MeasurementComputing card found\n");
+		printk(KERN_WARNING
+				"No supported ComputerBoards/MeasurementComputing card found\n");
 		return -EIO;
 	}
 
-	printk("Found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	printk(KERN_INFO "Found %s on bus %i, slot %i\n", board(dev)->name,
+			pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, driver_cb_pcidas.driver_name)) {
 		printk(KERN_WARNING
@@ -1814,7 +1814,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (!priv(dev)->plx9080_iobase || !priv(dev)->main_iobase
 	    || !priv(dev)->dio_counter_iobase) {
-		printk(" failed to remap io memory\n");
+		printk(KERN_WARNING " failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -1850,17 +1850,17 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	priv(dev)->hw_revision =
 	    hw_revision(dev, readw(priv(dev)->main_iobase + HW_STATUS_REG));
-	printk(" stc hardware revision %i\n", priv(dev)->hw_revision);
+	printk(KERN_DEBUG " stc hardware revision %i\n", priv(dev)->hw_revision);
 	init_plx9080(dev);
 	init_stc_registers(dev);
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
 			"cb_pcidas64", dev)) {
-		printk(" unable to allocate irq %u\n", pcidev->irq);
+		printk(KERN_DEBUG " unable to allocate irq %u\n", pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
-	printk(" irq %u\n", dev->irq);
+	printk(KERN_DEBUG " irq %u\n", dev->irq);
 
 	retval = setup_subdevices(dev);
 	if (retval < 0)
@@ -1882,7 +1882,7 @@ static int detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: cb_pcidas: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-- 
1.6.5.2

