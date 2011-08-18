Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1HRHLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:11:19 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64526 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1HRHLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:11:17 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk issue in cb_pcidio.c
Date: Thu, 18 Aug 2011 03:10:59 -0400
Message-Id: <1313651459-5047-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging:comedi: fix printk issue in cb_pcidio.c>
References: <[PATCH]Staging:comedi: fix printk issue in cb_pcidio.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the cb_pcidio.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidio.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 79477a5..4a5f2c9 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -184,7 +184,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int index;
 	int i;
 
-	printk("comedi%d: cb_pcidio: \n", dev->minor);
+	pr_info("comedi%d: cb_pcidio:\n", dev->minor);
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -223,8 +223,8 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	pr_warn("No supported ComputerBoards/MeasurementComputing card found on "
+			"requested position\n");
 	return -EIO;
 
 found:
@@ -236,12 +236,11 @@ found:
 	dev->board_name = thisboard->name;
 
 	devpriv->pci_dev = pcidev;
-	printk("Found %s on bus %i, slot %i\n", thisboard->name,
-	       devpriv->pci_dev->bus->number,
-	       PCI_SLOT(devpriv->pci_dev->devfn));
+	pr_info("Found %s on bus %i, slot %i\n", thisboard->name,
+			devpriv->pci_dev->bus->number,
+			PCI_SLOT(devpriv->pci_dev->devfn));
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidio: failed to enable PCI device and request regions\n");
+		pr_warn("cb_pcidio: failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	devpriv->dio_reg_base
@@ -259,11 +258,11 @@ found:
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
 				 NULL, devpriv->dio_reg_base + i * 4);
-		printk(" subdev %d: base = 0x%lx\n", i,
-		       devpriv->dio_reg_base + i * 4);
+		pr_debug(" subdev %d: base = 0x%lx\n", i,
+				devpriv->dio_reg_base + i * 4);
 	}
 
-	printk("attached\n");
+	pr_info("attached\n");
 	return 1;
 }
 
@@ -277,7 +276,7 @@ found:
  */
 static int pcidio_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidio: remove\n", dev->minor);
+	pr_info("comedi%d: cb_pcidio: remove\n", dev->minor);
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->dio_reg_base)
-- 
1.7.6

