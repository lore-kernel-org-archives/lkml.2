Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1JHGhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 02:37:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52182 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1JHGg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 02:36:59 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/4] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Sat,  8 Oct 2011 12:05:57 +0530
Message-Id: <1318055759-3549-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318055759-3549-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1318055759-3549-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 61968a5..572525c5 100644
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
+	pr_err("No supported ComputerBoards/MeasurementComputing card found on "
 	       "requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcidas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	pr_info("Found %s on bus %i, slot %i\n", cb_pcidas_boards[index].name,
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	/*
 	 * Enable PCI device and reserve I/O ports.
 	 */
 	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		pr_err("Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	/*
@@ -639,7 +636,7 @@ found:
 	/*  get irq */
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, "cb_pcidas", dev)) {
-		printk(" unable to allocate irq %d\n", devpriv->pci_dev->irq);
+		pr_err("unable to allocate irq %d\n", devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -768,7 +765,6 @@ found:
  */
 static int cb_pcidas_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
 
 	if (devpriv) {
 		if (devpriv->s5933_config) {
-- 
1.7.6.4

