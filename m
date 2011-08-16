Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1HPK05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 06:26:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40047 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1HPK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 06:26:56 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        root <root@localhost.localdomain>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix printk issue in cb_pcidda.c
Date: Tue, 16 Aug 2011 06:26:37 -0400
Message-Id: <1313490397-7445-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi: fix printk warning issue in cb_pcidda.c>
References: <[PATCH]Staging: comedi: fix printk warning issue in cb_pcidda.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@localhost.localdomain>

This is a patch to the cb_pcidda.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   29 +++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 49102b3..9716f19 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -282,7 +282,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	struct pci_dev *pcidev = NULL;
 	int index;
 
-	printk("comedi%d: cb_pcidda: ", dev->minor);
+	printk(KERN_INFO "comedi%d: cb_pcidda: ", dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -293,7 +293,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CB) {
@@ -312,22 +312,21 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 		}
 	}
 	if (!pcidev) {
-		printk
-		    ("Not a ComputerBoards/MeasurementComputing card on requested position\n");
+		printk(KERN_WARNING "Not a ComputerBoards/MeasurementComputing"
+				" card on requested position\n");
 		return -EIO;
 	}
 found:
 	devpriv->pci_dev = pcidev;
 	dev->board_ptr = cb_pcidda_boards + index;
 	/*  "thisboard" macro can be used from here. */
-	printk("Found %s at requested position\n", thisboard->name);
+	printk(KERN_CONT "Found %s at requested position\n", thisboard->name);
 
 	/*
 	 * Enable PCI device and request regions.
 	 */
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidda: failed to enable PCI device and request regions\n");
+		printk(KERN_WARNING "cb_pcidda: failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
@@ -342,10 +341,9 @@ found:
  * Warn about the status of the driver.
  */
 	if (thisboard->status == 2)
-		printk
-		    ("WARNING: DRIVER FOR THIS BOARD NOT CHECKED WITH MANUAL. "
-		     "WORKS ASSUMING FULL COMPATIBILITY WITH PCI-DDA08/12. "
-		     "PLEASE REPORT USAGE TO <ivanmr@altavista.com>.\n");
+		printk(KERN_WARNING "WARNING: DRIVER FOR THIS BOARD NOT CHECKED WITH MANUAL. "
+				"WORKS ASSUMING FULL COMPATIBILITY WITH PCI-DDA08/12. "
+				"PLEASE REPORT USAGE TO <ivanmr@altavista.com>.\n");
 
 /*
  * Initialize dev->board_name.
@@ -377,12 +375,12 @@ found:
 	s = dev->subdevices + 2;
 	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
 
-	printk(" eeprom:");
+	printk(KERN_CONT " eeprom:");
 	for (index = 0; index < EEPROM_SIZE; index++) {
 		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
-		printk(" %i:0x%x ", index, devpriv->eeprom_data[index]);
+		printk(KERN_CONT " %i:0x%x ", index,
+				devpriv->eeprom_data[index]);
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	/*  set calibrations dacs */
 	for (index = 0; index < thisboard->ao_chans; index++)
@@ -417,7 +415,7 @@ static int cb_pcidda_detach(struct comedi_device *dev)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	}
 
-	printk("comedi%d: cb_pcidda: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: cb_pcidda: remove\n", dev->minor);
 
 	return 0;
 }
-- 
1.7.6

