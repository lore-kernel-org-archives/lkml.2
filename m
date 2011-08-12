Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1HLHha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:37:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47502 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab1HLHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:37:27 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Fri, 12 Aug 2011 13:07:07 +0530
Message-Id: <1313134627-4781-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: comedi: fix warning issue in cb_pcidas64.c>
References: <[PATCH]Staging: comedi: fix warning issue in cb_pcidas64.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the cb_pcidas64.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   27 ++++++++++++-------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 1e32419..915f60a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1739,7 +1739,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	uint32_t local_range, local_decode;
 	int retval;
 
-	printk("comedi%d: cb_pcidas64\n", dev->minor);
+	printk(KERN_INFO "comedi%d: cb_pcidas64\n", dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -1776,17 +1776,16 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	if (dev->board_ptr == NULL) {
-		printk
-		    ("No supported ComputerBoards/MeasurementComputing card found\n");
+		printk(KERN_WARNING "No supported"
+				" ComputerBoards/MeasurementComputing card found\n");
 		return -EIO;
 	}
 
-	printk("Found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	printk(KERN_DEBUG "Found %s on bus %i, slot %i\n", board(dev)->name,
+			pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, driver_cb_pcidas.driver_name)) {
-		printk(KERN_WARNING
-		       " failed to enable PCI device and request regions\n");
+		printk(KERN_WARNING " failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	pci_set_master(pcidev);
@@ -1814,7 +1813,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (!priv(dev)->plx9080_iobase || !priv(dev)->main_iobase
 	    || !priv(dev)->dio_counter_iobase) {
-		printk(" failed to remap io memory\n");
+		printk(KERN_WARNING " failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -1850,17 +1849,17 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
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
+		printk(KERN_WARNING " unable to allocate irq %u\n", pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
-	printk(" irq %u\n", dev->irq);
+	printk(KERN_DEBUG " irq %u\n", dev->irq);
 
 	retval = setup_subdevices(dev);
 	if (retval < 0)
@@ -1882,7 +1881,7 @@ static int detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: cb_pcidas: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
@@ -2067,7 +2066,7 @@ static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		DEBUG_PRINT(" looped %i times waiting for data\n", i);
 		if (i == timeout) {
 			comedi_error(dev, " analog input read insn timed out");
-			printk(" status 0x%x\n", bits);
+			printk(KERN_DEBUG " status 0x%x\n", bits);
 			return -ETIME;
 		}
 		if (board(dev)->layout == LAYOUT_4020)
@@ -2093,7 +2092,7 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	else
 		num_calibration_sources = 8;
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		printk(KERN_WARNING "invalid calibration source: %i\n", source);
 		return -EINVAL;
 	}
 
-- 
1.6.5.2

