Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1JHGh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 02:37:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63083 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1JHGhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 02:37:07 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 3/4] Staging: comedi: fix printk  issue in cb_pcimdas.c
Date: Sat,  8 Oct 2011 12:05:59 +0530
Message-Id: <1318055759-3549-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318055759-3549-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1318055759-3549-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   39 +++++++++-----------------
 1 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index b1b832b..4c2edbc 100644
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
@@ -248,14 +245,14 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
+	pr_err("No supported ComputerBoards/MeasurementComputing card found on "
 	       "requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcimdas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	pr_info("Found %s on bus %i, slot %i\n", cb_pcimdas_boards[index].name,
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	/*  Warn about non-tested features */
 	switch (thisboard->device_id) {
@@ -267,7 +264,7 @@ found:
 	}
 
 	if (comedi_pci_enable(pcidev, "cb_pcimdas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		pr_err("Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
@@ -277,13 +274,11 @@ found:
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
 	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
 
-#ifdef CBPCIMDAS_DEBUG
-	printk("devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
-	printk("devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
-	printk("devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
-	printk("devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
-	printk("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
-#endif
+	pr_debug("devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
+	pr_debug("devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
+	pr_debug("devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
+	pr_debug("devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
+	pr_debug("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
 
 /* Dont support IRQ yet */
 /*  get irq */
@@ -332,9 +327,6 @@ found:
 		subdev_8255_init(dev, s, NULL, devpriv->BADR4);
 	else
 		s->type = COMEDI_SUBD_UNUSED;
-
-	printk("attached\n");
-
 	return 1;
 }
 
@@ -348,16 +340,13 @@ found:
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
+		pr_debug("devpriv->BADR0 = 0x%lx\n", devpriv->BADR0);
+		pr_debug("devpriv->BADR1 = 0x%lx\n", devpriv->BADR1);
+		pr_debug("devpriv->BADR2 = 0x%lx\n", devpriv->BADR2);
+		pr_debug("devpriv->BADR3 = 0x%lx\n", devpriv->BADR3);
+		pr_debug("devpriv->BADR4 = 0x%lx\n", devpriv->BADR4);
 	}
-#endif
-	printk("comedi%d: cb_pcimdas: remove\n", dev->minor);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
-- 
1.7.6.4

