Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab1IYFF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 01:05:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62876 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1IYFFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 01:05:25 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH] staging: comedi: Added log subjects to printk()s in pcmmio
Date: Sun, 25 Sep 2011 06:49:12 +0200
Message-Id: <1316926152-7258-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added log subject to printk()s in drivers/staging/comedi/drivers/pcmmio.c.

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/comedi/drivers/pcmmio.c |   34 +++++++++++++++---------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index f2e88e5..3ad04aa 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -371,7 +371,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	iobase = it->options[0];
 	irq[0] = it->options[1];
 
-	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
+	printk(KERN_INFO "comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
 	       iobase);
 
 	dev->iobase = iobase;
@@ -379,7 +379,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!iobase || !request_region(iobase,
 				       thisboard->total_iosize,
 				       driver.driver_name)) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "I/O port conflict\n");
 		return -EIO;
 	}
 
@@ -394,7 +394,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		printk(KERN_ERR "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
 
@@ -417,7 +417,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
 	/*
@@ -427,7 +427,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
 
@@ -557,14 +557,14 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		printk(KERN_DEBUG "irq: %u ", irq[0]);
 		if (thisboard->dio_num_asics == 2 && irq[1])
-			printk("second ASIC irq: %u ", irq[1]);
+			printk(KERN_DEBUG "second ASIC irq: %u ", irq[1]);
 	} else {
-		printk("(IRQ mode disabled) ");
+		printk(KERN_INFO "(IRQ mode disabled) ");
 	}
 
-	printk("attached\n");
+	printk(KERN_INFO "attached\n");
 
 	return 1;
 }
@@ -581,7 +581,7 @@ static int pcmmio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, thisboard->total_iosize);
 
@@ -622,7 +622,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("write mask: %08x  data: %08x\n", data[0], data[1]);
+	printk(KERN_DEBUG "write mask: %08x  data: %08x\n", data[0], data[1]);
 #endif
 
 	s->state = 0;
@@ -644,9 +644,9 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
 		printk
-		    ("byte %d wmb %02x db %02x offset %02d io %04x, data_in %02x ",
-		     byte_no, (unsigned)write_mask_byte, (unsigned)data_byte,
-		     offset, ioaddr, (unsigned)byte);
+		    (KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x,"
+		     " data_in %02x ", byte_no, (unsigned)write_mask_byte,
+		     (unsigned)data_byte, offset, ioaddr, (unsigned)byte);
 #endif
 
 		if (write_mask_byte) {
@@ -663,7 +663,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 		}
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk("data_out_byte %02x\n", (unsigned)byte);
+		printk(KERN_DEBUG "data_out_byte %02x\n", (unsigned)byte);
 #endif
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
@@ -674,7 +674,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("s->state %08x data_out %08x\n", s->state, data[1]);
+	printk(KERN_DEBUG "s->state %08x data_out %08x\n", s->state, data[1]);
 #endif
 
 	return 2;
@@ -886,7 +886,7 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 				 * with commands..
 				 */
 				printk
-				    ("PCMMIO DEBUG: got edge detect interrupt %d asic %d which_chans: %06x\n",
+				    (KERN_DEBUG "got edge detect interrupt %d asic %d which_chans: %06x\n",
 				     irq, asic, triggered);
 				for (s = dev->subdevices + 2;
 				     s < dev->subdevices + dev->n_subdevices;
-- 
1.7.4.1

