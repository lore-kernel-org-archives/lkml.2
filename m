Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1JCOLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:11:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48354 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1JCOLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:11:49 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH V1 2/2] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Mon,  3 Oct 2011 19:41:05 +0530
Message-Id: <1317651065-2870-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 Space issue is fixed. Sorry by mistake Earlier i sent wrong one.
 please find the correct one.
	
 drivers/staging/comedi/drivers/cb_pcidas.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9dec153..1fc8db4 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -565,7 +565,8 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	int index;
 	int i;
 
-	pr_info("comedi%d: cb_pcidas: ", dev->minor);
+	dev_info(&pcidev->dev, "comedi%d: cb_pcidas:\n",
+		dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -576,7 +577,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -600,20 +600,24 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(&pcidev->dev, "No supported "
+		"ComputerBoards/MeasurementComputing "
+		"card found on requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcidas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_info(&pcidev->dev, "Found %s on bus %i, slot %i\n",
+		cb_pcidas_boards[index].name,
+		pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
 
 	/*
 	 * Enable PCI device and reserve I/O ports.
 	 */
 	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		dev_err(&pcidev->dev, "Failed to enable PCI "
+			"device and request regions\n");
 		return -EIO;
 	}
 	/*
@@ -639,7 +643,8 @@ found:
 	/*  get irq */
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, "cb_pcidas", dev)) {
-		printk(" unable to allocate irq %d\n", devpriv->pci_dev->irq);
+		dev_warn(&pcidev->dev, "unable to allocate irq %d\n",
+			devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -768,7 +773,8 @@ found:
  */
 static int cb_pcidas_detach(struct comedi_device *dev)
 {
-	pr_info("comedi%d: cb_pcidas: remove\n", dev->minor);
+	pr_info(&pcidev->dev, "comedi%d: cb_pcidas: remove\n",
+		dev->minor);
 
 	if (devpriv) {
 		if (devpriv->s5933_config) {
-- 
1.7.6.2

