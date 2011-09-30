Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1I3NTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46656 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1I3NTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:11 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/9] Staging: comedi: fix printk  issue in cb_pcidio.c
Date: Fri, 30 Sep 2011 18:48:19 +0530
Message-Id: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidio.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidio.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 79477a5..85cc78d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -184,7 +184,8 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int index;
 	int i;
 
-	printk("comedi%d: cb_pcidio: \n", dev->minor);
+	dev_info(&pcidev->dev, "comedi%d: cb_pcidio:\n",
+		dev->minor);
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -223,8 +224,9 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(&pcidev->dev, "No supported"
+		" ComputerBoards/MeasurementComputing"
+		" card found on requested position\n");
 	return -EIO;
 
 found:
@@ -236,12 +238,13 @@ found:
 	dev->board_name = thisboard->name;
 
 	devpriv->pci_dev = pcidev;
-	printk("Found %s on bus %i, slot %i\n", thisboard->name,
-	       devpriv->pci_dev->bus->number,
-	       PCI_SLOT(devpriv->pci_dev->devfn));
+	dev_info(&pcidev->dev, "Found %s on bus %i, slot %i\n",
+		thisboard->name,
+		devpriv->pci_dev->bus->number,
+		PCI_SLOT(devpriv->pci_dev->devfn));
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidio: failed to enable PCI device and request regions\n");
+		dev_err(&pcidev->dev, "cb_pcidio: failed to enable PCI"
+			" device and request regions\n");
 		return -EIO;
 	}
 	devpriv->dio_reg_base
@@ -259,11 +262,11 @@ found:
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
 				 NULL, devpriv->dio_reg_base + i * 4);
-		printk(" subdev %d: base = 0x%lx\n", i,
-		       devpriv->dio_reg_base + i * 4);
+		dev_dbg(&pcidev->dev, " subdev %d: base = 0x%lx\n", i,
+			devpriv->dio_reg_base + i * 4);
 	}
 
-	printk("attached\n");
+	dev_info(&pcidev->dev, "attached\n");
 	return 1;
 }
 
@@ -277,7 +280,7 @@ found:
  */
 static int pcidio_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidio: remove\n", dev->minor);
+	pr_info("comedi%d: cb_pcidio: remove\n", dev->minor);
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->dio_reg_base)
-- 
1.7.6.2

