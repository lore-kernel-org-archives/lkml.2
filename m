Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1KCGka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:40:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56006 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1KCGkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:40:25 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 09/14] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Thu,  3 Nov 2011 12:09:57 +0530
Message-Id: <1320302402-5025-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_printk and Removed unnecessary
printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 61968a5..7433646 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -565,8 +565,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	int index;
 	int i;
 
-	printk("comedi%d: cb_pcidas: ", dev->minor);
-
 /*
  * Allocate the private structure area.
  */
@@ -576,7 +574,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -600,20 +597,20 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(dev->hw_dev, "No supported ComputerBoards/MeasurementComputing card found on requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcidas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_dbg(dev->hw_dev, "Found %s on bus %i, slot %i\n",
+		cb_pcidas_boards[index].name, pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
 
 	/*
 	 * Enable PCI device and reserve I/O ports.
 	 */
 	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	/*
@@ -639,7 +636,8 @@ found:
 	/*  get irq */
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, "cb_pcidas", dev)) {
-		printk(" unable to allocate irq %d\n", devpriv->pci_dev->irq);
+		dev_dbg(dev->hw_dev, "unable to allocate irq %d\n",
+			devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -768,7 +766,6 @@ found:
  */
 static int cb_pcidas_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
 
 	if (devpriv) {
 		if (devpriv->s5933_config) {
-- 
1.7.0.4

