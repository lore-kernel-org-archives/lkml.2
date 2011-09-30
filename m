Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab1I3NT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53153 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab1I3NT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:27 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 5/9] Staging: comedi: fix printk  issue in cb_pcimdas.c
Date: Fri, 30 Sep 2011 18:48:23 +0530
Message-Id: <1317388707-1980-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index b1b832b..20e1421 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -212,7 +212,8 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	int index;
 	/* int i; */
 
-	printk("comedi%d: cb_pcimdas: ", dev->minor);
+	dev_info(&pcidev->dev, "comedi%d: cb_pcimdas:\n",
+		dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -223,7 +224,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -248,14 +248,17 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(&pcidev->dev, "No supported"
+		" ComputerBoards/MeasurementComputing"
+		" card found on requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcimdas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_info(&pcidev->dev, "Found %s on bus %i, slot %i\n",
+		cb_pcimdas_boards[index].name,
+		pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
 
 	/*  Warn about non-tested features */
 	switch (thisboard->device_id) {
@@ -267,7 +270,8 @@ found:
 	}
 
 	if (comedi_pci_enable(pcidev, "cb_pcimdas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		dev_warn(&pcidev->dev, "Failed to enable PCI"
+			" device and request regions\n");
 		return -EIO;
 	}
 
@@ -333,7 +337,7 @@ found:
 	else
 		s->type = COMEDI_SUBD_UNUSED;
 
-	printk("attached\n");
+	dev_info(&pcidev->dev, "attached\n");
 
 	return 1;
 }
@@ -357,7 +361,7 @@ static int cb_pcimdas_detach(struct comedi_device *dev)
 		printk("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
 	}
 #endif
-	printk("comedi%d: cb_pcimdas: remove\n", dev->minor);
+	pr_info("comedi%d: cb_pcimdas: remove\n", dev->minor);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
-- 
1.7.6.2

