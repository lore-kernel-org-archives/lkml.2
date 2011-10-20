Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1JTGUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:20:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50871 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1JTGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:20:19 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 04/24] Staging: comedi: fix code cleanup issue in pcmuio.c
Date: Thu, 20 Oct 2011 11:48:50 +0530
Message-Id: <1319091550-2558-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up a brace coding style
and printk warning found by the checkpatch.pl tool.
Converted printk to pr_<levels>.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmuio.c |   67 ++++++++-----------------------
 1 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index b2c2c89..adf27de 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -295,15 +295,12 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq[0] = it->options[1];
 	irq[1] = it->options[2];
 
-	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
-	       iobase);
-
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->num_asics * ASIC_IOSIZE,
 				       driver.driver_name)) {
-		printk("I/O port conflict\n");
+		pr_err("I/O port conflict\n");
 		return -EIO;
 	}
 
@@ -317,10 +314,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_private(dev, sizeof(struct pcmuio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+	if (alloc_private(dev, sizeof(struct pcmuio_private)) < 0)
 		return -ENOMEM;
-	}
 
 	for (asic = 0; asic < MAX_ASICS; ++asic) {
 		devpriv->asics[asic].num = asic;
@@ -336,10 +331,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->sprivs =
 	    kcalloc(n_subdevs, sizeof(struct pcmuio_subdev_private),
 		    GFP_KERNEL);
-	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+	if (!devpriv->sprivs)
 		return -ENOMEM;
-	}
 	/*
 	 * Allocate the subdevice structures.  alloc_subdevice() is a
 	 * convenient macro defined in comedidev.h.
@@ -347,11 +340,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
 	 * 96-channel version of the board.
 	 */
-	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+	if (alloc_subdevices(dev, n_subdevs) < 0)
 		return -ENOMEM;
-	}
-
 	port = 0;
 	asic = 0;
 	for (sdev_no = 0; sdev_no < (int)dev->n_subdevices; ++sdev_no) {
@@ -436,15 +426,13 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				   irqs.. */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		pr_debug("irq: %u\n", irq[0]);
 		if (irq[1] && thisboard->num_asics == 2)
-			printk("second ASIC irq: %u ", irq[1]);
+			pr_debug("second ASIC irq: %u\n", irq[1]);
 	} else {
-		printk("(IRQ mode disabled) ");
+		pr_debug("(IRQ mode disabled)\n");
 	}
 
-	printk("attached\n");
-
 	return 1;
 }
 
@@ -460,7 +448,6 @@ static int pcmuio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
 
@@ -499,16 +486,12 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 
-#ifdef DAMMIT_ITS_BROKEN
-	/* DEBUG */
-	printk("write mask: %08x  data: %08x\n", data[0], data[1]);
-#endif
-
+	pr_debug("write mask: %08x  data: %08x\n", data[0], data[1]);
 	s->state = 0;
 
 	for (byte_no = 0; byte_no < s->n_chan / CHANS_PER_PORT; ++byte_no) {
 		/* address of 8-bit port */
-		unsigned long ioaddr = subpriv->iobases[byte_no],
+		int ioaddr = subpriv->iobases[byte_no],
 		    /* bit offset of port in 32-bit doubleword */
 		    offset = byte_no * 8;
 		/* this 8-bit port's data */
@@ -520,13 +503,9 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 
 		byte = inb(ioaddr);	/* read all 8-bits for this port */
 
-#ifdef DAMMIT_ITS_BROKEN
-		/* DEBUG */
-		printk
-		    ("byte %d wmb %02x db %02x offset %02d io %04x, data_in %02x ",
-		     byte_no, (unsigned)write_mask_byte, (unsigned)data_byte,
-		     offset, ioaddr, (unsigned)byte);
-#endif
+		pr_debug("byte %d wmb %02x db %02x offset %02d io %04d, data_in %02x\n",
+			 byte_no, (unsigned)write_mask_byte, (unsigned)data_byte,
+			 offset, ioaddr, (unsigned)byte);
 
 		if (write_mask_byte) {
 			/* this byte has some write_bits -- so set the output lines */
@@ -535,10 +514,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 			/* Write out the new digital output state */
 			outb(byte, ioaddr);
 		}
-#ifdef DAMMIT_ITS_BROKEN
-		/* DEBUG */
-		printk("data_out_byte %02x\n", (unsigned)byte);
-#endif
+		pr_debug("data_out_byte %02x\n", (unsigned)byte);
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
 	}
@@ -546,11 +522,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 	/* now return the DIO lines to data[1] - note they came inverted! */
 	data[1] = ~s->state;
 
-#ifdef DAMMIT_ITS_BROKEN
-	/* DEBUG */
-	printk("s->state %08x data_out %08x\n", s->state, data[1]);
-#endif
-
+	pr_debug("s->state %08x data_out %08x\n", s->state, data[1]);
 	return 2;
 }
 
@@ -951,15 +923,12 @@ pcmuio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	spin_lock_irqsave(&subpriv->intr.spinlock, flags);
 	s->async->inttrig = 0;
-	if (subpriv->intr.active) {
+	if (subpriv->intr.active)
 		event = pcmuio_start_intr(dev, s);
-	}
 	spin_unlock_irqrestore(&subpriv->intr.spinlock, flags);
 
-	if (event) {
+	if (event)
 		comedi_event(dev, s);
-	}
-
 	return 1;
 }
 
@@ -1000,10 +969,8 @@ static int pcmuio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 	spin_unlock_irqrestore(&subpriv->intr.spinlock, flags);
 
-	if (event) {
+	if (event)
 		comedi_event(dev, s);
-	}
-
 	return 0;
 }
 
-- 
1.7.6.4

