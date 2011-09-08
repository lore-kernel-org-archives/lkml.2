Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1IHXnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:43:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39514 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1IHXnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:43:37 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 3/3] Staging: comedi: fix printk issue in pcmuio.c
Date: Thu,  8 Sep 2011 23:51:24 +0530
Message-Id: <1315506084-2959-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 3/3]Staging: comedi: fix printk issue in pcmuio.c>
References: <[PATCH 3/3]Staging: comedi: fix printk issue in pcmuio.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmuio.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 8c82e45..aa27e99 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -316,8 +316,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq[0] = it->options[1];
 	irq[1] = it->options[2];
 
-	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
-	       iobase);
+	printk(KERN_INFO "comedi%d: %s: io: %lx ", dev->minor,
+			driver.driver_name, iobase);
 
 	dev->iobase = iobase;
 
@@ -339,7 +339,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmuio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		printk(KERN_ERR "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
 
@@ -360,7 +360,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmuio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
 	/*
@@ -371,7 +371,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * 96-channel version of the board.
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
 
@@ -468,7 +468,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		printk(KERN_INFO "irq: %u ", irq[0]);
 		if (irq[1] && thisboard->num_asics == 2)
 			printk("second ASIC irq: %u ", irq[1]);
 	} else {
@@ -492,7 +492,8 @@ static int pcmuio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor,
+			driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
 
@@ -533,7 +534,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("write mask: %08x  data: %08x\n", data[0], data[1]);
+	printk(KERN_DEBUG "write mask: %08x  data: %08x\n", data[0], data[1]);
 #endif
 
 	s->state = 0;
@@ -554,10 +555,9 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk
-		    ("byte %d wmb %02x db %02x offset %02d io %04x, data_in %02x ",
-		     byte_no, (unsigned)write_mask_byte, (unsigned)data_byte,
-		     offset, ioaddr, (unsigned)byte);
+		printk(KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x, data_in %02x ",
+			byte_no, (unsigned)write_mask_byte, (unsigned)data_byte,
+			offset, ioaddr, (unsigned)byte);
 #endif
 
 		if (write_mask_byte) {
@@ -572,7 +572,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 		}
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk("data_out_byte %02x\n", (unsigned)byte);
+		printk(KERN_DEBUG "data_out_byte %02x\n", (unsigned)byte);
 #endif
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
@@ -583,7 +583,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("s->state %08x data_out %08x\n", s->state, data[1]);
+	printk(KERN_DEBUG "s->state %08x data_out %08x\n", s->state, data[1]);
 #endif
 
 	return 2;
-- 
1.6.5.2

