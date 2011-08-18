Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1HRE4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 00:56:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57817 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1HRE4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 00:56:35 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix line over 80 character and printk issue in cb_pcimdda.c
Date: Thu, 18 Aug 2011 00:56:13 -0400
Message-Id: <1313643373-2568-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging:comedi: fix printk and line over 80 character issue in cb_pcimdda.c>
References: <[PATCH]Staging:comedi: fix printk and line over 80 character issue in cb_pcimdda.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the cb_pcimdda.c file that fixes up a line over 80 character and printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 8c981a8..49a6c5e 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -105,7 +105,8 @@ struct board_struct {
 	int ao_bits;
 	int dio_chans;
 	int dio_method;
-	int dio_offset;		/* how many bytes into the BADR are the DIO ports */
+	int dio_offset;         /* how many bytes into the BADR are the DIO
+				 * ports */
 	int regs_badrindex;	/* IO Region for the control, analog output,
 				   and DIO registers */
 	int reg_sz;		/* number of bytes of registers in io region */
@@ -154,7 +155,8 @@ MODULE_DEVICE_TABLE(pci, pci_table);
 
 /* this structure is for data unique to this hardware driver.  If
    several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+   feel free to suggest moving the variable to the struct comedi_device
+   struct. */
 struct board_private_struct {
 	unsigned long registers;	/* set by probe */
 	unsigned long dio_registers;
@@ -300,7 +302,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return err;
 
 /* Output some info */
-	printk("comedi%d: %s: ", dev->minor, thisboard->name);
+	pr_info("comedi%d: %s: ", dev->minor, thisboard->name);
 
 /*
  * Initialize dev->board_name.  Note that we can use the "thisboard"
@@ -335,13 +337,14 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->dio_chans) {
 		switch (thisboard->dio_method) {
 		case DIO_8255:
-			/* this is a straight 8255, so register us with the 8255 driver */
+			/* this is a straight 8255, so register us with the 8255
+			 * driver */
 			subdev_8255_init(dev, s, NULL, devpriv->dio_registers);
 			devpriv->attached_to_8255 = 1;
 			break;
 		case DIO_INTERNAL:
 		default:
-			printk("DIO_INTERNAL not implemented yet!\n");
+			pr_cont("DIO_INTERNAL not implemented yet!\n");
 			return -ENXIO;
 			break;
 		}
@@ -351,7 +354,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->attached_successfully = 1;
 
-	printk("attached\n");
+	pr_cont("attached\n");
 
 	return 1;
 }
@@ -381,8 +384,8 @@ static int detach(struct comedi_device *dev)
 		}
 
 		if (devpriv->attached_successfully && thisboard)
-			printk("comedi%d: %s: detached\n", dev->minor,
-			       thisboard->name);
+			pr_info("comedi%d: %s: detached\n", dev->minor,
+					thisboard->name);
 
 	}
 
@@ -489,8 +492,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 			devpriv->pci_dev = pcidev;
 			dev->board_ptr = boards + index;
 			if (comedi_pci_enable(pcidev, thisboard->name)) {
-				printk
-				    ("cb_pcimdda: Failed to enable PCI device and request regions\n");
+				pr_warn("cb_pcimdda: Failed to enable PCI device and request regions\n");
 				return -EIO;
 			}
 			registers =
@@ -503,7 +505,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 		}
 	}
 
-	printk("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
-	       "card found at the requested position\n");
+	pr_warn("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
+			"card found at the requested position\n");
 	return -ENODEV;
 }
-- 
1.7.6

