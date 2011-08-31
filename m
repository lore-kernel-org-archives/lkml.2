Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1HaLx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:53:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63463 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1HaLxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:53:55 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 1/2] Staging: comedi: fix printk issue in cb_pcidda.c
Date: Wed, 31 Aug 2011 17:23:32 +0530
Message-Id: <1314791612-2724-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 1/2]Staging: comedi: fix printk issue in cb_pcidda.c>
References: <[PATCH 1/2]Staging: comedi: fix printk issue in cb_pcidda.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidda.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 49102b3..661e945 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -282,7 +282,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	struct pci_dev *pcidev = NULL;
 	int index;
 
-	printk("comedi%d: cb_pcidda: ", dev->minor);
+	pr_info("comedi%d: cb_pcidda: ", dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -293,7 +293,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
+	pr_cont("\n");
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CB) {
@@ -312,22 +312,23 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 		}
 	}
 	if (!pcidev) {
-		printk
-		    ("Not a ComputerBoards/MeasurementComputing card on requested position\n");
+		pr_warn("comedi%d: cb_pcidda: Not a ComputerBoards/MeasurementComputing "
+				"card on requested position\n", dev->minor);
 		return -EIO;
 	}
 found:
 	devpriv->pci_dev = pcidev;
 	dev->board_ptr = cb_pcidda_boards + index;
 	/*  "thisboard" macro can be used from here. */
-	printk("Found %s at requested position\n", thisboard->name);
+	pr_info("comedi%d: cb_pcidda: Found %s at requested position\n",
+			dev->minor, thisboard->name);
 
 	/*
 	 * Enable PCI device and request regions.
 	 */
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidda: failed to enable PCI device and request regions\n");
+		pr_warn("comedi%d: cb_pcidda: failed to enable "
+				"PCI device and request regions\n", dev->minor);
 		return -EIO;
 	}
 
@@ -377,12 +378,12 @@ found:
 	s = dev->subdevices + 2;
 	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
 
-	printk(" eeprom:");
+	pr_debug("comedi%d: cb_pcidda: eeprom: ", dev->minor);
 	for (index = 0; index < EEPROM_SIZE; index++) {
 		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
-		printk(" %i:0x%x ", index, devpriv->eeprom_data[index]);
+		pr_cont(" %i:0x%x ", index, devpriv->eeprom_data[index]);
 	}
-	printk("\n");
+	pr_cont("\n");
 
 	/*  set calibrations dacs */
 	for (index = 0; index < thisboard->ao_chans; index++)
@@ -417,7 +418,7 @@ static int cb_pcidda_detach(struct comedi_device *dev)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	}
 
-	printk("comedi%d: cb_pcidda: remove\n", dev->minor);
+	pr_info("comedi%d: cb_pcidda: remove\n", dev->minor);
 
 	return 0;
 }
-- 
1.6.5.2

