Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0KKO21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:28:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54663 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0KKO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:28:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=KlQhLyMefwdsCvV/RM6Qm7F8Q7wgO6Sly1w5NdyJ9P3TxPGco5kUgDXrFST4SpIL92
         PYcPCKvgDlZZYSHxt1JLLFNoBvOH1HkZalK4ey6Lw1m2kuCLvT9J2P5bTkGryh/bAg5C
         ED5JeQEHXyHzDUEjnpI+HagY+UpFkxIM6IsEE=
From: Damian Varayud <davarayud@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, ezemed7@gmail.com, tj@kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fix coding style issue in pcmuio.c
Date: Thu, 11 Nov 2010 11:28:12 -0300
Message-Id: <1289485692-1527-1-git-send-email-user@netbu>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up braces, overlines and printk warnings found by the checkpatch.pl tool

Signed-off-by: Ezequiel Medina <ezemed7@gmail.com>
---
 drivers/staging/comedi/drivers/pcmuio.c |  151 ++++++++++++++++++-------------
 1 files changed, 88 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 7a92874..d0bd454 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -64,7 +64,8 @@ In the 48-channel version:
 
 On subdev 0, the first 24 channels channels are edge-detect channels.
 
-In the 96-channel board you have the collowing channels that can do edge detection:
+In the 96-channel board you have the collowing channels that can do edge
+detection:
 
 subdev 0, channels 0-24  (first 24 channels of 1st ASIC)
 subdev 2, channels 0-24  (first 24 channels of 2nd ASIC)
@@ -72,7 +73,8 @@ subdev 2, channels 0-24  (first 24 channels of 2nd ASIC)
 Configuration Options:
   [0] - I/O port base address
   [1] - IRQ (for first ASIC, or first 24 channels)
-  [2] - IRQ for second ASIC (pcmuio96 only - IRQ for chans 48-72 .. can be the same as first irq!)
+  [2] - IRQ for second ASIC (pcmuio96 only - IRQ for chans 48-72 ..
+	can be the same as first irq!)
 */
 
 #include <linux/interrupt.h>
@@ -119,9 +121,9 @@ Configuration Options:
 #define REG_PORT4 0x4
 #define REG_PORT5 0x5
 #define REG_INT_PENDING 0x6
-#define REG_PAGELOCK 0x7	/* page selector register, upper 2 bits select a page
-				   and bits 0-5 are used to 'lock down' a particular
-				   port above to make it readonly.  */
+#define REG_PAGELOCK 0x7/* page selector register, upper 2 bits select a page
+			   and bits 0-5 are used to 'lock down' a particular
+			   port above to make it readonly.  */
 #define REG_POL0 0x8
 #define REG_POL1 0x9
 #define REG_POL2 0xA
@@ -138,7 +140,7 @@ Configuration Options:
 #define REG_PAGE_BITOFFSET 6
 #define REG_LOCK_BITOFFSET 0
 #define REG_PAGE_MASK (~((0x1<<REG_PAGE_BITOFFSET)-1))
-#define REG_LOCK_MASK ~(REG_PAGE_MASK)
+#define REG_LOCK_MASK (~(REG_PAGE_MASK))
 #define PAGE_POL 1
 #define PAGE_ENAB 2
 #define PAGE_INT_ID 3
@@ -180,14 +182,16 @@ struct pcmuio_subdev_private {
 
 	/* The below is only used for intr subdevices */
 	struct {
-		int asic;	/* if non-negative, this subdev has an interrupt asic */
+		int asic;	/* if non-negative, this subdev has an
+				 * interrupt asic */
 		int first_chan;	/* if nonnegative, the first channel id for
 				   interrupts. */
-		int num_asic_chans;	/* the number of asic channels in this subdev
-					   that have interrutps */
+		int num_asic_chans;	/* the number of asic channels in
+					 * this subdev that have interrutps */
 		int asic_chan;	/* if nonnegative, the first channel id with
 				   respect to the asic that has interrupts */
-		int enabled_mask;	/* subdev-relative channel mask for channels
+		int enabled_mask;	/* subdev-relative
+					   channel mask for channels
 					   we are interested in */
 		int active;
 		int stop_count;
@@ -196,14 +200,19 @@ struct pcmuio_subdev_private {
 	} intr;
 };
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/* this structure is for data unique to this hardware driver.
+   If several hardware drivers keep similar information in this structure
+   feel free to suggest moving the variable to the struct comedi_device
+   struct.*/
 struct pcmuio_private {
 	struct {
-		unsigned char pagelock;	/* current page and lock */
-		unsigned char pol[NUM_PAGED_REGS];	/* shadow of POLx registers */
-		unsigned char enab[NUM_PAGED_REGS];	/* shadow of ENABx registers */
+		unsigned char pagelock;
+		/* current page and lock */
+		unsigned char pol[NUM_PAGED_REGS];
+		/* shadow of POLx registers */
+		unsigned char enab[NUM_PAGED_REGS];
+		/* shadow of ENABx registers */
+
 		int num;
 		unsigned long iobase;
 		unsigned int irq;
@@ -261,17 +270,21 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_insn *insn, unsigned int *data);
 static int pcmuio_dio_insn_config(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data);
+				 struct comedi_insn *insn, unsigned int *data);
 
 static irqreturn_t interrupt_pcmuio(int irq, void *d);
-static void pcmuio_stop_intr(struct comedi_device *, struct comedi_subdevice *);
-static int pcmuio_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
+static void pcmuio_stop_intr(struct comedi_device *,
+			     struct comedi_subdevice *);
+static int pcmuio_cancel(struct comedi_device *dev,
+			 struct comedi_subdevice *s);
 static int pcmuio_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
-static int pcmuio_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
+static int pcmuio_cmdtest(struct comedi_device *dev,
+			  struct comedi_subdevice *s,
 			  struct comedi_cmd *cmd);
 
 /* some helper functions to deal with specifics of this device's registers */
-static void init_asics(struct comedi_device *dev);	/* sets up/clears ASIC chips to defaults */
+/* sets up/clears ASIC chips to defaults */
+static void init_asics(struct comedi_device *dev);
 static void switch_page(struct comedi_device *dev, int asic, int page);
 #ifdef notused
 static void lock_port(struct comedi_device *dev, int asic, int port);
@@ -284,7 +297,8 @@ static void unlock_port(struct comedi_device *dev, int asic, int port);
  * in the driver structure, dev->board_ptr contains that
  * address.
  */
-static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static int pcmuio_attach(struct comedi_device *dev,
+			 struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 	int sdev_no, chans_left, n_subdevs, port, asic, thisasic_chanct = 0;
@@ -295,7 +309,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq[0] = it->options[1];
 	irq[1] = it->options[2];
 
-	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
+	printk(KERN_ERR "comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
 	       iobase);
 
 	dev->iobase = iobase;
@@ -318,16 +332,18 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmuio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		printk(KERN_ERR "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
 
 	for (asic = 0; asic < MAX_ASICS; ++asic) {
 		devpriv->asics[asic].num = asic;
 		devpriv->asics[asic].iobase = dev->iobase + asic * ASIC_IOSIZE;
-		devpriv->asics[asic].irq = 0;	/* this gets actually set at the end of
-						   this function when we
-						   request_irqs */
+		devpriv->asics[asic].irq = 0;	/* this gets actually set
+						 * at the end of
+						 * this function when we
+						 * request_irqs
+						 */
 		spin_lock_init(&devpriv->asics[asic].spinlock);
 	}
 
@@ -337,7 +353,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmuio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
 	/*
@@ -348,7 +364,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * 96-channel version of the board.
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
 
@@ -375,7 +391,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		/* save the ioport address for each 'port' of 8 channels in the
 		   subdevice */
-		for (byte_no = 0; byte_no < PORTS_PER_SUBDEV; ++byte_no, ++port) {
+		for (byte_no = 0; byte_no < PORTS_PER_SUBDEV;
+						++byte_no, ++port) {
 			if (port >= PORTS_PER_ASIC) {
 				port = 0;
 				++asic;
@@ -387,7 +404,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			if (thisasic_chanct <
 			    CHANS_PER_PORT * INTR_PORTS_PER_ASIC
 			    && subpriv->intr.asic < 0) {
-				/* this is an interrupt subdevice, so setup the struct */
+				/* this is an interrupt subdevice,
+				 * so setup the struct */
 				subpriv->intr.asic = asic;
 				subpriv->intr.active = 0;
 				subpriv->intr.stop_count = 0;
@@ -409,7 +427,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		chans_left -= s->n_chan;
 
 		if (!chans_left) {
-			asic = 0;	/* reset the asic to our first asic, to do intr subdevs */
+			asic = 0;	/* reset the asic to our first asic,
+					 * to do intr subdevs */
 			port = 0;
 		}
 
@@ -432,11 +451,11 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->asics[asic].irq = irq[asic];
 	}
 
-	dev->irq = irq[0];	/* grr.. wish comedi dev struct supported multiple
-				   irqs.. */
+	dev->irq = irq[0];	/* grr.. wish comedi dev struct
+				 * supported multiple irqs.. */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		printk(KERN_ERR "irq: %u ", irq[0]);
 		if (irq[1] && thisboard->num_asics == 2)
 			printk("second ASIC irq: %u ", irq[1]);
 	} else {
@@ -460,7 +479,7 @@ static int pcmuio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	printk(KERN_ERR "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
 
@@ -501,7 +520,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("write mask: %08x  data: %08x\n", data[0], data[1]);
+	printk(KERN_ERR "write mask: %08x  data: %08x\n", data[0], data[1]);
 #endif
 
 	s->state = 0;
@@ -529,15 +548,18 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 #endif
 
 		if (write_mask_byte) {
-			/* this byte has some write_bits -- so set the output lines */
-			byte &= ~write_mask_byte;	/* clear bits for write mask */
-			byte |= ~data_byte & write_mask_byte;	/* set to inverted data_byte */
+			/* this byte has some write_bits -- so set
+			 * the output lines */
+			/* clear bits for write mask */
+			byte &= ~write_mask_byte;
+			/* set to inverted data_byte */
+			byte |= ~data_byte & write_mask_byte;
 			/* Write out the new digital output state */
 			outb(byte, ioaddr);
 		}
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk("data_out_byte %02x\n", (unsigned)byte);
+		printk(KERN_ERR "data_out_byte %02x\n", (unsigned)byte);
 #endif
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
@@ -548,7 +570,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("s->state %08x data_out %08x\n", s->state, data[1]);
+	printk(KERN_ERR "s->state %08x data_out %08x\n", s->state, data[1]);
 #endif
 
 	return 2;
@@ -595,9 +617,11 @@ static int pcmuio_dio_insn_config(struct comedi_device *dev,
 		byte &= ~(1 << bit_no);
 				/**< set input channel to '0' */
 
-		/* write out byte -- this is the only time we actually affect the
-		   hardware as all channels are implicitly output -- but input
-		   channels are set to float-high */
+		/* write out byte -- this is the only
+		 * time we actually affect the
+		 * hardware as all channels are
+		 * implicitly output -- but input
+		 * channels are set to float-high */
 		outb(byte, ioaddr);
 
 		/* save to io_bits */
@@ -651,7 +675,7 @@ static void init_asics(struct comedi_device *dev)
 		   outb(0xff, baseaddr + REG_ENAB0); */
 		/* END DEBUG */
 
-		switch_page(dev, asic, 0);	/* switch back to default page 0 */
+		switch_page(dev, asic, 0); /* switch back to default page 0 */
 
 	}
 }
@@ -730,7 +754,8 @@ static irqreturn_t interrupt_pcmuio(int irq, void *d)
 							REG_INT_ID0 + port);
 
 						if (io_lines_with_edges)
-							/* clear pending interrupt */
+							/* clear pending
+							 * interrupt */
 							outb(0, iobase +
 							     REG_INT_ID0 +
 							     port);
@@ -749,14 +774,17 @@ static irqreturn_t interrupt_pcmuio(int irq, void *d)
 
 			if (triggered) {
 				struct comedi_subdevice *s;
-				/* TODO here: dispatch io lines to subdevs with commands.. */
+				/* TODO here: dispatch io lines
+				 * to subdevs with commands.. */
 				printk
 				    ("PCMUIO DEBUG: got edge detect interrupt %d asic %d which_chans: %06x\n",
 				     irq, asic, triggered);
 				for (s = dev->subdevices;
 				     s < dev->subdevices + dev->n_subdevices;
 				     ++s) {
-					if (subpriv->intr.asic == asic) {	/* this is an interrupt subdev, and it matches this asic! */
+					/* this is an interrupt subdev,
+					 * and it matches this asic! */
+					if (subpriv->intr.asic == asic) {
 						unsigned long flags;
 						unsigned oldevents;
 
@@ -777,8 +805,7 @@ static irqreturn_t interrupt_pcmuio(int irq, void *d)
 							      1)) << subpriv->
 							    intr.first_chan;
 							if (mytrig &
-							    subpriv->intr.enabled_mask)
-							{
+							    subpriv->intr.enabled_mask) {
 								unsigned int val
 								    = 0;
 								unsigned int n,
@@ -791,18 +818,18 @@ static irqreturn_t interrupt_pcmuio(int irq, void *d)
 								     n < len;
 								     n++) {
 									ch = CR_CHAN(s->async->cmd.chanlist[n]);
-									if (mytrig & (1U << ch)) {
+									if (mytrig & (1U << ch))
 										val |= (1U << n);
-									}
 								}
-								/* Write the scan to the buffer. */
+								/* Write the
+								 * scan to the
+								 * buffer.*/
 								if (comedi_buf_put(s->async, ((short *)&val)[0])
 								    &&
 								    comedi_buf_put
 								    (s->async,
 								     ((short *)
-								      &val)[1]))
-								{
+								      &val)[1])) {
 									s->async->events |= (COMEDI_CB_BLOCK | COMEDI_CB_EOS);
 								} else {
 									/* Overflow! Stop acquisition!! */
@@ -940,7 +967,8 @@ static int pcmuio_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
  * Internal trigger function to start acquisition for an 'INTERRUPT' subdevice.
  */
 static int
-pcmuio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
+pcmuio_inttrig_start_intr(struct comedi_device *dev,
+			  struct comedi_subdevice *s,
 			  unsigned int trignum)
 {
 	unsigned long flags;
@@ -951,14 +979,12 @@ pcmuio_inttrig_start_intr(struct comedi_device *dev, struct comedi_subdevice *s,
 
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
 
 	return 1;
 }
@@ -1000,9 +1026,8 @@ static int pcmuio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 	spin_unlock_irqrestore(&subpriv->intr.spinlock, flags);
 
-	if (event) {
+	if (event)
 		comedi_event(dev, s);
-	}
 
 	return 0;
 }
-- 
1.7.0.4

