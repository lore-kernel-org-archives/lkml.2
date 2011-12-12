Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1LLFXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:23:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1LLFVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:48 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 23/29] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Mon, 12 Dec 2011 10:49:35 +0530
Message-Id: <1323667181-17252-23-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas64.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels> and Removed unnecessary
printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 1e32419..b68c587 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1739,8 +1739,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	uint32_t local_range, local_decode;
 	int retval;
 
-	printk("comedi%d: cb_pcidas64\n", dev->minor);
-
 /*
  * Allocate the private structure area.
  */
@@ -1781,12 +1779,11 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	}
 
-	printk("Found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_dbg(dev->hw_dev, "Found %s on bus %i, slot %i\n", board(dev)->name,
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, driver_cb_pcidas.driver_name)) {
-		printk(KERN_WARNING
-		       " failed to enable PCI device and request regions\n");
+		dev_warn(dev->hw_dev, "failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	pci_set_master(pcidev);
@@ -1814,7 +1811,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (!priv(dev)->plx9080_iobase || !priv(dev)->main_iobase
 	    || !priv(dev)->dio_counter_iobase) {
-		printk(" failed to remap io memory\n");
+		dev_warn(dev->hw_dev, "failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -1850,17 +1847,19 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	priv(dev)->hw_revision =
 	    hw_revision(dev, readw(priv(dev)->main_iobase + HW_STATUS_REG));
-	printk(" stc hardware revision %i\n", priv(dev)->hw_revision);
+	dev_dbg(dev->hw_dev, "stc hardware revision %i\n",
+		priv(dev)->hw_revision);
 	init_plx9080(dev);
 	init_stc_registers(dev);
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
 			"cb_pcidas64", dev)) {
-		printk(" unable to allocate irq %u\n", pcidev->irq);
+		dev_dbg(dev->hw_dev, "unable to allocate irq %u\n",
+			pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
-	printk(" irq %u\n", dev->irq);
+	dev_dbg(dev->hw_dev, "irq %u\n", dev->irq);
 
 	retval = setup_subdevices(dev);
 	if (retval < 0)
-- 
1.7.0.4

