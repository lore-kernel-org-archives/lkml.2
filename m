Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1HZM5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:57:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52266 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1HZM5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:57:35 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk() issue in cb_pcidas.c
Date: Fri, 26 Aug 2011 18:27:06 +0530
Message-Id: <1314363426-3233-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi:fix printk issue in cb_pcidas.c>
References: <[PATCH]Staging: comedi:fix printk issue in cb_pcidas.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the cb_pcidas.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 61968a5..a8f2c42 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -565,7 +565,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	int index;
 	int i;
 
-	printk("comedi%d: cb_pcidas: ", dev->minor);
+	pr_info("comedi%d: cb_pcidas: ", dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -576,7 +576,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
+	pr_cont("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -600,20 +600,22 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	pr_warn("comedi%d: cb_pcidas: No supported ComputerBoards/MeasurementComputing "
+			"card found on requested position\n", dev->minor);
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcidas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	pr_info("comedi%d: cb_pcidas: Found %s on bus %i, slot %i\n",
+			dev->minor, cb_pcidas_boards[index].name,
+			pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	/*
 	 * Enable PCI device and reserve I/O ports.
 	 */
 	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		pr_warn("comedi%d: cb_pcidas: Failed to enable PCI device and request regions\n",
+				dev->minor);
 		return -EIO;
 	}
 	/*
@@ -639,7 +641,8 @@ found:
 	/*  get irq */
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, "cb_pcidas", dev)) {
-		printk(" unable to allocate irq %d\n", devpriv->pci_dev->irq);
+		pr_warn("comedi%d: cb_pcidas: unable to allocate irq %d\n",
+				dev->minor, devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -768,7 +771,7 @@ found:
  */
 static int cb_pcidas_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
+	pr_info("comedi%d: cb_pcidas: remove\n", dev->minor);
 
 	if (devpriv) {
 		if (devpriv->s5933_config) {
-- 
1.7.6

