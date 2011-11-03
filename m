Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1KCGkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:40:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56006 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1KCGkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:40:36 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 11/14] Staging: comedi: fix printk issue in cb_pcidio.c
Date: Thu,  3 Nov 2011 12:09:59 +0530
Message-Id: <1320302402-5025-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidio.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_printk and Removed unnecessary printk
statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidio.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 79477a5..0c74491 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -184,8 +184,6 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int index;
 	int i;
 
-	printk("comedi%d: cb_pcidio: \n", dev->minor);
-
 /*
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
@@ -223,8 +221,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(dev->hw_dev, "No supported ComputerBoards/MeasurementComputing card found on requested position\n");
 	return -EIO;
 
 found:
@@ -236,14 +233,12 @@ found:
 	dev->board_name = thisboard->name;
 
 	devpriv->pci_dev = pcidev;
-	printk("Found %s on bus %i, slot %i\n", thisboard->name,
-	       devpriv->pci_dev->bus->number,
-	       PCI_SLOT(devpriv->pci_dev->devfn));
-	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidio: failed to enable PCI device and request regions\n");
+	dev_dbg(dev->hw_dev, "Found %s on bus %i, slot %i\n", thisboard->name,
+		devpriv->pci_dev->bus->number,
+		PCI_SLOT(devpriv->pci_dev->devfn));
+	if (comedi_pci_enable(pcidev, thisboard->name))
 		return -EIO;
-	}
+
 	devpriv->dio_reg_base
 	    =
 	    pci_resource_start(devpriv->pci_dev,
@@ -259,11 +254,10 @@ found:
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
 				 NULL, devpriv->dio_reg_base + i * 4);
-		printk(" subdev %d: base = 0x%lx\n", i,
-		       devpriv->dio_reg_base + i * 4);
+		dev_dbg(dev->hw_dev, "subdev %d: base = 0x%lx\n", i,
+			devpriv->dio_reg_base + i * 4);
 	}
 
-	printk("attached\n");
 	return 1;
 }
 
@@ -277,7 +271,6 @@ found:
  */
 static int pcidio_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidio: remove\n", dev->minor);
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->dio_reg_base)
-- 
1.7.0.4

