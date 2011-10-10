Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1JJOAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:00:05 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63581 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1JJN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:59:46 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 2/2] Staging: comedi: fix printk and line over 80
Date: Mon, 10 Oct 2011 19:28:53 +0530
Message-Id: <1318255133-6986-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318255133-6986-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1318255133-6986-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a  printk and line over 80 charcter found by the
checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c |   41 ++++++++++++++++----------
 1 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 8c981a8..6918e3d 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -105,7 +105,10 @@ struct board_struct {
 	int ao_bits;
 	int dio_chans;
 	int dio_method;
-	int dio_offset;		/* how many bytes into the BADR are the DIO ports */
+	int dio_offset;		/*
+				 * how many bytes into the BADR
+				 * are the DIO ports
+				 */
 	int regs_badrindex;	/* IO Region for the control, analog output,
 				   and DIO registers */
 	int reg_sz;		/* number of bytes of registers in io region */
@@ -152,9 +155,12 @@ static DEFINE_PCI_DEVICE_TABLE(pci_table) = {
 
 MODULE_DEVICE_TABLE(pci, pci_table);
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * this structure is for data unique to this hardware driver.  If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct board_private_struct {
 	unsigned long registers;	/* set by probe */
 	unsigned long dio_registers;
@@ -300,7 +306,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return err;
 
 /* Output some info */
-	printk("comedi%d: %s: ", dev->minor, thisboard->name);
+	pr_info("comedi%d: %s: attached\n", dev->minor, thisboard->name);
 
 /*
  * Initialize dev->board_name.  Note that we can use the "thisboard"
@@ -335,13 +341,16 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->dio_chans) {
 		switch (thisboard->dio_method) {
 		case DIO_8255:
-			/* this is a straight 8255, so register us with the 8255 driver */
+			/*
+			 * this is a straight 8255, so register
+			 * us with the 8255 driver
+			 */
 			subdev_8255_init(dev, s, NULL, devpriv->dio_registers);
 			devpriv->attached_to_8255 = 1;
 			break;
 		case DIO_INTERNAL:
 		default:
-			printk("DIO_INTERNAL not implemented yet!\n");
+			pr_warn("DIO_INTERNAL not implemented yet!\n");
 			return -ENXIO;
 			break;
 		}
@@ -351,8 +360,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->attached_successfully = 1;
 
-	printk("attached\n");
-
 	return 1;
 }
 
@@ -381,8 +388,8 @@ static int detach(struct comedi_device *dev)
 		}
 
 		if (devpriv->attached_successfully && thisboard)
-			printk("comedi%d: %s: detached\n", dev->minor,
-			       thisboard->name);
+			pr_info("comedi%d: %s: detached\n", dev->minor,
+				thisboard->name);
 
 	}
 
@@ -436,8 +443,11 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	for (i = 0; i < insn->n; i++) {
 		inw(devpriv->registers + chan * 2);
-		/* should I set data[i] to the result of the actual read on the register
-		   or the cached unsigned int in devpriv->ao_readback[]? */
+		/*
+		 * should I set data[i] to the result of the actual read on
+		 * the register or the cached unsigned int in
+		 * devpriv->ao_readback[]?
+		 */
 		data[i] = devpriv->ao_readback[chan];
 	}
 
@@ -489,8 +499,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 			devpriv->pci_dev = pcidev;
 			dev->board_ptr = boards + index;
 			if (comedi_pci_enable(pcidev, thisboard->name)) {
-				printk
-				    ("cb_pcimdda: Failed to enable PCI device and request regions\n");
+				pr_err("cb_pcimdda: Failed to enable PCI device and request regions\n");
 				return -EIO;
 			}
 			registers =
@@ -503,7 +512,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 		}
 	}
 
-	printk("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
+	pr_err("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
 	       "card found at the requested position\n");
 	return -ENODEV;
 }
-- 
1.7.6.4

