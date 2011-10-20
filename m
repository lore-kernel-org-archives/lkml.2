Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab1JTGVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:21:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64400 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1JTGVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:21:19 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 13/24] Staging: comedi: fix printk issue in cb_pcimdas.c
Date: Thu, 20 Oct 2011 11:48:59 +0530
Message-Id: <1319091550-2558-13-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a printk
warning found by the checkpatch.pl tool.
Converted printks to dev_<level>.
Removed unnecessary printk statement.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   48 +++++++++++---------------
 1 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index b1b832b..9aae302 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -212,8 +212,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	int index;
 	/* int i; */
 
-	printk("comedi%d: cb_pcimdas: ", dev->minor);
-
 /*
  * Allocate the private structure area.
  */
@@ -223,7 +221,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -248,26 +245,27 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(dev->hw_dev,
+		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcimdas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_dbg(dev->hw_dev, "Found %s on bus %i, slot %i\n",
+		cb_pcimdas_boards[index].name,
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	/*  Warn about non-tested features */
 	switch (thisboard->device_id) {
 	case 0x56:
 		break;
 	default:
-		printk("THIS CARD IS UNSUPPORTED.\n"
-		       "PLEASE REPORT USAGE TO <mocelet@sucs.org>\n");
+		dev_err(dev->hw_dev, "THIS CARD IS UNSUPPORTED.\n"
+			 "PLEASE REPORT USAGE TO <mocelet@sucs.org>\n");
 	}
 
 	if (comedi_pci_enable(pcidev, "cb_pcimdas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
@@ -277,13 +275,11 @@ found:
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
 	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
 
-#ifdef CBPCIMDAS_DEBUG
-	printk("devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
-	printk("devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
-	printk("devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
-	printk("devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
-	printk("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
-#endif
+	dev_dbg(dev->hw_dev, "devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
+	dev_dbg(dev->hw_dev, "devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
+	dev_dbg(dev->hw_dev, "devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
+	dev_dbg(dev->hw_dev, "devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
+	dev_dbg(dev->hw_dev, "devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
 
 /* Dont support IRQ yet */
 /*  get irq */
@@ -333,8 +329,6 @@ found:
 	else
 		s->type = COMEDI_SUBD_UNUSED;
 
-	printk("attached\n");
-
 	return 1;
 }
 
@@ -348,16 +342,14 @@ found:
  */
 static int cb_pcimdas_detach(struct comedi_device *dev)
 {
-#ifdef CBPCIMDAS_DEBUG
 	if (devpriv) {
-		printk("devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
-		printk("devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
-		printk("devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
-		printk("devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
-		printk("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
+		dev_dbg(dev->hw_dev, "devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
+		dev_dbg(dev->hw_dev, "devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
+		dev_dbg(dev->hw_dev, "devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
+		dev_dbg(dev->hw_dev, "devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
+		dev_dbg(dev->hw_dev, "devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
 	}
-#endif
-	printk("comedi%d: cb_pcimdas: remove\n", dev->minor);
+	
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
@@ -425,7 +417,7 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 				break;
 		}
 		if (i == TIMEOUT) {
-			printk("timeout\n");
+			dev_err(dev->hw_dev, "timeout\n");
 			return -ETIMEDOUT;
 		}
 		/* read data */
-- 
1.7.6.4

