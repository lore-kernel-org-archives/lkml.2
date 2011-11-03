Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab1KCGke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:40:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56006 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1KCGka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:40:30 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 10/14] Staging: comedi: fix printk issue in cb_pcidda.c
Date: Thu,  3 Nov 2011 12:09:58 +0530
Message-Id: <1320302402-5025-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidda.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_printk and Removed unnecessary
printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 49102b3..abba220 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -282,7 +282,6 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	struct pci_dev *pcidev = NULL;
 	int index;
 
-	printk("comedi%d: cb_pcidda: ", dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -293,7 +292,6 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CB) {
@@ -312,22 +310,21 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 		}
 	}
 	if (!pcidev) {
-		printk
-		    ("Not a ComputerBoards/MeasurementComputing card on requested position\n");
+		dev_err(dev->hw_dev, "Not a ComputerBoards/MeasurementComputing card on requested position\n");
 		return -EIO;
 	}
 found:
 	devpriv->pci_dev = pcidev;
 	dev->board_ptr = cb_pcidda_boards + index;
 	/*  "thisboard" macro can be used from here. */
-	printk("Found %s at requested position\n", thisboard->name);
+	dev_dbg(dev->hw_dev, "Found %s at requested position\n",
+		thisboard->name);
 
 	/*
 	 * Enable PCI device and request regions.
 	 */
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidda: failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "cb_pcidda: failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
@@ -377,12 +374,11 @@ found:
 	s = dev->subdevices + 2;
 	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
 
-	printk(" eeprom:");
+	dev_dbg(dev->hw_dev, "eeprom:\n");
 	for (index = 0; index < EEPROM_SIZE; index++) {
 		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
-		printk(" %i:0x%x ", index, devpriv->eeprom_data[index]);
+		dev_dbg(dev->hw_dev, "%i:0x%x\n", index, devpriv->eeprom_data[index]);
 	}
-	printk("\n");
 
 	/*  set calibrations dacs */
 	for (index = 0; index < thisboard->ao_chans; index++)
@@ -417,8 +413,6 @@ static int cb_pcidda_detach(struct comedi_device *dev)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	}
 
-	printk("comedi%d: cb_pcidda: remove\n", dev->minor);
-
 	return 0;
 }
 
-- 
1.7.0.4

