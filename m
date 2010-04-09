Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0DIOOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:14:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52734 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab0DION6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=r1ow5L+AwwlYvot/A1NCGGzbbFhC05/SZX/6yZhbISvkfAr/DhogYXbH+wsZYRy54x
         952gE3mZ5RvJx943OCG2B2jOuuLJ2ixbCb7CTqjCWXdbHK0UrBL2qbcizYDrllvatVaC
         3W/zAr8yet9hYTMtk9xVDdKJhOu3zgsJgwIT4=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 30/30] Staging: comedi: fix over 80 character coding style issues in ni_labpc.c
Date: Fri,  9 Apr 2010 15:13:43 +0100
Message-Id: <1270822424-3813-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-submitted patch to the ni_labpc.c file that fixes up over 80 characters warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |  258 ++++++++++++++++------------
 1 files changed, 147 insertions(+), 111 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 4eaf31f..becbe47 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -101,18 +101,18 @@ NI manuals:
 #define   ADC_CHAN_BITS(x)	((x) & 0x7)
 #define   ADC_SCAN_EN_BIT	0x80	/* enables multi channel scans */
 #define COMMAND2_REG	0x1
-#define   PRETRIG_BIT	0x1	/* enable pretriggering
-				 * (used in conjunction with SWTRIG) */
-#define   HWTRIG_BIT	0x2	/* enable paced conversions
-				 * on external trigger */
+		/* enable pretriggering (used in conjunction with SWTRIG) */
+#define   PRETRIG_BIT	0x1
+		/* enable paced conversions on external trigger */
+#define   HWTRIG_BIT	0x2
 #define   SWTRIG_BIT	0x4	/* enable paced conversions */
 #define   CASCADE_BIT	0x8	/* use two cascaded counters for pacing */
 #define   DAC_PACED_BIT(channel)	(0x40 << ((channel) & 0x1))
 #define COMMAND3_REG	0x2
 #define   DMA_EN_BIT	0x1	/* enable dma transfers */
 #define   DIO_INTR_EN_BIT	0x2	/* enable interrupts for 8255 */
-#define   DMATC_INTR_EN_BIT	0x4	/* enable dma terminal count
-					 * interrupt */
+		/* enable dma terminal count interrupt */
+#define   DMATC_INTR_EN_BIT	0x4
 #define   TIMER_INTR_EN_BIT	0x8	/* enable timer interrupt */
 #define   ERR_INTR_EN_BIT	0x10	/* enable error interrupt */
 #define   ADC_FNE_INTR_EN_BIT	0x20	/* enable fifo not empty interrupt */
@@ -123,32 +123,32 @@ NI manuals:
 #define DMATC_CLEAR_REG	0xa
 #define TIMER_CLEAR_REG	0xc
 #define COMMAND6_REG	0xe	/* 1200 boards only */
-#define   ADC_COMMON_BIT	0x1	/* select ground or
-					 * common-mode reference */
+		/* select ground or common-mode reference */
+#define   ADC_COMMON_BIT	0x1
 #define   ADC_UNIP_BIT	0x2	/* adc unipolar */
 #define   DAC_UNIP_BIT(channel)	(0x4 << ((channel) & 0x1))    /* dac unipolar */
 #define   ADC_FHF_INTR_EN_BIT	0x20	/* enable fifo half full interrupt */
-#define   A1_INTR_EN_BIT	0x40	/* enable interrupt
-					 * on end of hardware count */
-#define   ADC_SCAN_UP_BIT 0x80		/* scan up from channel zero
-					 * instead of down to zero */
+		/* enable interrupt on end of hardware count */
+#define   A1_INTR_EN_BIT	0x40
+		/* scan up from channel zero instead of down to zero */
+#define   ADC_SCAN_UP_BIT 0x80
 #define COMMAND4_REG	0xf
 #define   INTERVAL_SCAN_EN_BIT	0x1	/* enables 'interval' scanning */
-#define   EXT_SCAN_EN_BIT	0x2	/* enables external signal on
-					 * counter b1 output to trigger scan */
-#define   EXT_CONVERT_OUT_BIT	0x4	/* chooses direction (output or input)
-					 * for EXTCONV* line */
-#define   ADC_DIFF_BIT	0x8	/* chooses differential inputs for adc
-				 * (in conjunction with board jumper) */
+	/* enables external signal on counter b1 output to trigger scan */
+#define   EXT_SCAN_EN_BIT	0x2
+		/* chooses direction (output or input) for EXTCONV* line */
+#define   EXT_CONVERT_OUT_BIT	0x4
+/* chooses differential inputs for adc (in conjunction with board jumper) */
+#define   ADC_DIFF_BIT	0x8
 #define   EXT_CONVERT_DISABLE_BIT	0x10
 #define COMMAND5_REG	0x1c	/* 1200 boards only, calibration stuff */
 #define   EEPROM_WRITE_UNPROTECT_BIT	0x4	/* enable eeprom for write */
 #define   DITHER_EN_BIT	0x8	/* enable dithering */
 #define   CALDAC_LOAD_BIT	0x10	/* load calibration dac */
-#define   SCLOCK_BIT	0x20	/* serial clock - rising edge writes,
-				 * falling edge reads */
-#define   SDATA_BIT	0x40	/* serial data bit for writing to eeprom
-				 * or calibration dacs */
+		/* serial clock - rising edge writes, falling edge reads */
+#define   SCLOCK_BIT	0x20
+		/* serial data bit for writing to eeprom or calibration dacs */
+#define   SDATA_BIT	0x40
 #define   EEPROM_EN_BIT	0x80	/* enable eeprom for read/write */
 #define INTERVAL_COUNT_REG	0x1e
 #define INTERVAL_LOAD_REG	0x1f
@@ -171,10 +171,10 @@ NI manuals:
 #define DIO_BASE_REG	0x10
 #define COUNTER_A_BASE_REG	0x14
 #define COUNTER_A_CONTROL_REG	(COUNTER_A_BASE_REG + 0x3)
-#define   INIT_A0_BITS	0x14	/* check modes put conversion pacer output
-				 * in harmless state (a0 mode 2) */
-#define   INIT_A1_BITS	0x70	/* put hardware conversion counter output
-				 * in harmless state (a1 mode 0) */
+/* check modes put conversion pacer output in harmless state (a0 mode 2) */
+#define   INIT_A0_BITS	0x14
+/* put hardware conversion counter output in harmless state (a1 mode 0) */
+#define   INIT_A1_BITS	0x70
 #define COUNTER_B_BASE_REG	0x18
 
 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it);
@@ -363,8 +363,10 @@ static const struct comedi_lrange range_labpc_ao = {
 	}
 };
 
-/* functions that do inb/outb and readb/writeb so we can use
- * function pointers to decide which to use */
+/*
+ * functions that do inb/outb and readb/writeb so we can use
+ * function pointers to decide which to use
+ */
 static inline unsigned int labpc_inb(unsigned long address)
 {
 	return inb(address);
@@ -422,6 +424,7 @@ static const struct labpc_board_struct labpc_boards[] = {
 	.ai_scan_up = 0,
 	.memory_mapped_io = 0,
 	},
+/* dummy entry so pci board works when comedi_config is passed driver name */
 #ifdef CONFIG_COMEDI_PCI
 	{
 	.name = "pci-1200",
@@ -437,8 +440,6 @@ static const struct labpc_board_struct labpc_boards[] = {
 	.memory_mapped_io = 1,
 	},
 
-	/* dummy entry so pci board works when
-	 * comedi_config is passed driver name */
 	{
 	.name = DRV_NAME,
 	.bustype = pci_bustype,
@@ -446,13 +447,11 @@ static const struct labpc_board_struct labpc_boards[] = {
 #endif
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
+/* Useful for shorthand access to the particular board structure */
 #define thisboard ((struct labpc_board_struct *)dev->board_ptr)
 
-static const int dma_buffer_size = 0xff00;	/* size in bytes
-						 * of dma buffer */
+			/* size in bytes of dma buffer */
+static const int dma_buffer_size = 0xff00;
 static const int sample_size = 2;		/* 2 bytes per sample */
 
 #define devpriv ((struct labpc_private *)dev->private)
@@ -476,19 +475,19 @@ MODULE_DEVICE_TABLE(pci, labpc_pci_table);
 #endif /* CONFIG_COMEDI_PCI */
 
 static inline int labpc_counter_load(struct comedi_device *dev,
-				unsigned long base_address,
-				unsigned int counter_number,
-				unsigned int count, unsigned int mode)
+					unsigned long base_address,
+					unsigned int counter_number,
+					unsigned int count, unsigned int mode)
 {
 	if (thisboard->memory_mapped_io)
 		return i8254_mm_load((void *)base_address, 0, counter_number,
-					count, mode);
+								count, mode);
 	else
 		return i8254_load(base_address, 0, counter_number, count, mode);
 }
 EXPORT_SYMBOL_GPL(labpc_1200_ai_gain_bits);
 int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
-				unsigned int irq, unsigned int dma_chan)
+					unsigned int irq, unsigned int dma_chan)
 {
 	struct comedi_subdevice *s;
 	int i;
@@ -513,7 +512,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	if (thisboard->bustype == isa_bustype) {
 		/* check if io addresses are available */
 		if (!request_region(iobase, LABPC_SIZE,
-				driver_labpc.driver_name)) {
+						driver_labpc.driver_name)) {
 			printk(KERN_ERR "I/O port conflict\n");
 			return -EIO;
 		}
@@ -534,9 +533,9 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);
 	if (thisboard->register_layout == labpc_1200_layout) {
 		devpriv->write_byte(devpriv->command5_bits,
-					dev->iobase + COMMAND5_REG);
+						dev->iobase + COMMAND5_REG);
 		devpriv->write_byte(devpriv->command6_bits,
-					dev->iobase + COMMAND6_REG);
+						dev->iobase + COMMAND6_REG);
 	}
 
 	/* grab our IRQ */
@@ -545,7 +544,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		if (thisboard->bustype == pci_bustype)
 			isr_flags |= IRQF_SHARED;
 		if (request_irq(irq, labpc_interrupt, isr_flags,
-			driver_labpc.driver_name, dev)) {
+					driver_labpc.driver_name, dev)) {
 			printk(KERN_ERR "unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
@@ -624,8 +623,10 @@ if (thisboard->has_ao) {
 
 	/* 8255 dio */
 	s = dev->subdevices + 2;
-	/* if board uses io memory we have to give a custom callback
-	 * function to the 8255 driver */
+	/*
+	 * if board uses io memory we have to give a custom callback
+	 * function to the 8255 driver
+	 */
 	if (thisboard->memory_mapped_io)
 		subdev_8255_init(dev, s, labpc_dio_mem_callback,
 				(unsigned long)(dev->iobase + DIO_BASE_REG));
@@ -733,8 +734,10 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 	for (mite = mite_devices; mite; mite = mite->next) {
 		if (mite->used)
 			continue;
-		/* if bus/slot are specified then make sure
-		 * we have the right bus/slot */
+		/*
+		 * if bus/slot are specified then make sure
+		 * we have the right bus/slot
+		 */
 		if (bus || slot) {
 			if (bus != mite->pcidev->bus->number
 			|| slot != PCI_SLOT(mite->pcidev->devfn))
@@ -745,8 +748,10 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 				continue;
 			if (mite_device_id(mite) == labpc_boards[i].device_id) {
 				devpriv->mite = mite;
-				/* fixup board pointer, in case we were using
-				 * the dummy "ni_labpc" entry */
+				/*
+				 * fixup board pointer, in case we were using
+				 * the dummy "ni_labpc" entry
+				 */
 				dev->board_ptr = &labpc_boards[i];
 				return 0;
 			}
@@ -855,26 +860,23 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 		switch (mode) {
 		case MODE_SINGLE_CHAN_INTERVAL:
 			if (CR_CHAN(cmd->chanlist[i]) != channel) {
-				comedi_error(dev,
-					"channel scanning order specified in "
-				"chanlist is not supported by hardware.\n");
+				comedi_error(dev, "channel scanning order "
+		"specified in chanlist is not supported by hardware.\n");
 				return 1;
 			}
 			break;
 		case MODE_MULT_CHAN_UP:
 			if (CR_CHAN(cmd->chanlist[i]) != i) {
-				comedi_error(dev,
-					"channel scanning order specified in "
-				"chanlist is not supported by hardware.\n");
+				comedi_error(dev, "channel scanning order "
+		"specified in chanlist is not supported by hardware.\n");
 				return 1;
 			}
 			break;
 		case MODE_MULT_CHAN_DOWN:
 			if (CR_CHAN(cmd->chanlist[i]) !=
 				cmd->chanlist_len - i - 1) {
-				comedi_error(dev,
-					"channel scanning order specified in "
-				"chanlist is not supported by hardware.\n");
+				comedi_error(dev, "channel scanning order "
+		"specified in chanlist is not supported by hardware.\n");
 				return 1;
 			}
 			break;
@@ -885,8 +887,7 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 		}
 
 		if (CR_RANGE(cmd->chanlist[i]) != range) {
-			comedi_error(dev,
-					"entries in chanlist must all have "
+			comedi_error(dev, "entries in chanlist must all have "
 							"the same range\n");
 			return 1;
 		}
@@ -1004,8 +1005,10 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and
-	 * mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and
+	 * mutually compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -1077,8 +1080,10 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 			err++;
 		}
 		break;
-		/* TRIG_EXT doesn't care since it doesn't trigger off
-		 * a numbered channel */
+		/*
+		 * TRIG_EXT doesn't care since it doesn't trigger off
+		 * a numbered channel
+		 */
 	default:
 		break;
 	}
@@ -1136,23 +1141,29 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* setup hardware conversion counter */
 	if (cmd->stop_src == TRIG_EXT) {
-		/* load counter a1 with count of 3
-		 * (pc+ manual says this is minimum allowed) using mode 0 */
+		/*
+		 * load counter a1 with count of 3
+		 * (pc+ manual says this is minimum allowed) using mode 0
+		 */
 		ret = labpc_counter_load(dev, dev->iobase + COUNTER_A_BASE_REG,
 								1, 3, 0);
 		if (ret < 0) {
 			comedi_error(dev, "error loading counter a1");
 			return -1;
 		}
-	} else			/* otherwise, just put a1 in mode 0
-				 * with no count to set its output low */
+	} else			/*
+				 * otherwise, just put a1 in mode 0
+				 * with no count to set its output low
+				 */
 		devpriv->write_byte(INIT_A1_BITS,
-				dev->iobase + COUNTER_A_CONTROL_REG);
+					dev->iobase + COUNTER_A_CONTROL_REG);
 
 	/* figure out what method we will use to transfer data */
-	if (devpriv->dma_chan &&	/*  need a dma channel allocated */
-	/* dma unsafe at RT priority,
-			* and too much setup time for TRIG_WAKE_EOS for */
+	if (devpriv->dma_chan &&	/* need a dma channel allocated */
+	/*
+	 * dma unsafe at RT priority, and
+	 * too much setup time for TRIG_WAKE_EOS
+	 */
 		(cmd->flags & (TRIG_WAKE_EOS | TRIG_RT)) == 0 &&
 	    /* only available on the isa boards */
 		thisboard->bustype == isa_bustype) {
@@ -1216,9 +1227,11 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (labpc_ai_scan_mode(cmd) == MODE_MULT_CHAN_UP ||
 		labpc_ai_scan_mode(cmd) == MODE_MULT_CHAN_DOWN) {
 		devpriv->command1_bits |= ADC_SCAN_EN_BIT;
-		/* need a brief delay before enabling scan,
+		/*
+		 * need a brief delay before enabling scan,
 		 * or scan list will get screwed when you switch
-		 * between scan up to scan down mode - dunno why */
+		 * between scan up to scan down mode - dunno why
+		 */
 		udelay(1);
 		devpriv->write_byte(devpriv->command1_bits,
 				dev->iobase + COMMAND1_REG);
@@ -1227,8 +1240,10 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->command4_bits = 0;
 	if (cmd->convert_src != TRIG_EXT)
 		devpriv->command4_bits |= EXT_CONVERT_DISABLE_BIT;
-	/* XXX should discard first scan when using interval scanning
-	 * since manual says it is not synced with scan clock */
+	/*
+	 * XXX should discard first scan when using interval scanning
+	 * since manual says it is not synced with scan clock
+	 */
 	if (labpc_use_continuous_mode(cmd) == 0) {
 		devpriv->command4_bits |= INTERVAL_SCAN_EN_BIT;
 		if (cmd->scan_begin_src == TRIG_EXT)
@@ -1287,8 +1302,10 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (xfer == isa_dma_transfer) {
 		irq_flags = claim_dma_lock();
 		disable_dma(devpriv->dma_chan);
-		/* clear flip-flop to make sure 2-byte registers for
-		 * count and address get set correctly */
+		/*
+		 * clear flip-flop to make sure 2-byte registers for
+		 * count and address get set correctly
+		 */
 		clear_dma_ff(devpriv->dma_chan);
 		set_dma_addr(devpriv->dma_chan,
 			virt_to_bus(devpriv->dma_buffer));
@@ -1394,8 +1411,10 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 	}
 
 	if (devpriv->current_transfer == isa_dma_transfer) {
-		/* if a dma terminal count of external
-		 * stop trigger has occurred */
+		/*
+		 * if a dma terminal count of external
+		 * stop trigger has occurred
+		 */
 		if (devpriv->status1_bits & DMATC_BIT ||
 			(thisboard->register_layout == labpc_1200_layout
 			&& devpriv->status2_bits & A1_TC_BIT)) {
@@ -1487,13 +1506,16 @@ static void labpc_drain_dma(struct comedi_device *dev)
 
 	flags = claim_dma_lock();
 	disable_dma(devpriv->dma_chan);
-	/* clear flip-flop to make sure 2-byte registers for
-	 * count and address get set correctly */
+	/*
+	 * clear flip-flop to make sure 2-byte registers for
+	 * count and address get set correctly
+	 */
 	clear_dma_ff(devpriv->dma_chan);
 
 	/* figure out how many points to read */
 	max_points = devpriv->dma_transfer_size / sample_size;
-	/* residue is the number of points left to be done on the dma
+	/*
+	 * residue is the number of points left to be done on the dma
 	 * transfer.  It should always be zero at this point unless
 	 * the stop_src is set to external triggering.
 	 */
@@ -1537,8 +1559,10 @@ static void handle_isa_dma(struct comedi_device *dev)
 	devpriv->write_byte(0x1, dev->iobase + DMATC_CLEAR_REG);
 }
 
-/* makes sure all data aquired by board is transfered to comedi (used
- * when aquisition is terminated by stop_src == TRIG_EXT). */
+/*
+ * makes sure all data aquired by board is transfered to comedi
+ * (used when aquisition is terminated by stop_src == TRIG_EXT)
+ */
 static void labpc_drain_dregs(struct comedi_device *dev)
 {
 	if (devpriv->current_transfer == isa_dma_transfer)
@@ -1605,8 +1629,10 @@ static int labpc_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		devpriv->command4_bits |= ADC_DIFF_BIT;
 	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);
 
-	/* initialize pacer counter output to
-	 * make sure it doesn't cause any problems */
+	/*
+	 * initialize pacer counter output to
+	 * make sure it doesn't cause any problems
+	 */
 	devpriv->write_byte(INIT_A0_BITS, dev->iobase + COUNTER_A_CONTROL_REG);
 
 	labpc_clear_adc_fifo(dev);
@@ -1643,9 +1669,11 @@ static int labpc_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	channel = CR_CHAN(insn->chanspec);
 
-	/* turn off pacing of analog output channel */
-	/* note: hardware bug in daqcard-1200 means pacing cannot
-	 * be independently enabled/disabled for its the two channels */
+	/*
+	 * turn off pacing of analog output channel
+	 * NOTE: hardware bug in daqcard-1200 means pacing cannot
+	 * be independently enabled/disabled for its the two channels
+	 */
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->command2_bits &= ~DAC_PACED_BIT(channel);
 	devpriv->write_byte(devpriv->command2_bits, dev->iobase + COMMAND2_REG);
@@ -1720,9 +1748,8 @@ static int labpc_eeprom_write_insn(struct comedi_device *dev,
 
 	/* only allow writes to user area of eeprom */
 	if (channel < 16 || channel > 127) {
-		printk
-		("eeprom writes are only allowed to channels 16 through 127 "
-						"(the pointer and user areas)");
+		printk(KERN_ERR "eeprom writes are only allowed to channels "
+				"16 through 127 (the pointer and user areas)");
 		return -EINVAL;
 	}
 
@@ -1760,17 +1787,20 @@ static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd)
 /* figures out what counter values to use based on command */
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 {
-	const int max_counter_value = 0x10000;	/* max value for 16 bit counter
-						 * in mode 2 */
-	const int min_counter_value = 2;	/* min value for 16 bit counter
-						 * in mode 2 */
+	/* max value for 16 bit counter in mode 2 */
+	const int max_counter_value = 0x10000;
+	/* min value for 16 bit counter in mode 2 */
+	const int min_counter_value = 2;
 	unsigned int base_period;
-
-	/* if both convert and scan triggers are TRIG_TIMER,
-	 * then they both rely on counter b0 */
+	/*
+	 * if both convert and scan triggers are TRIG_TIMER,
+	 * then they both rely on counter b0
+	 */
 	if (labpc_ai_convert_period(cmd) && labpc_ai_scan_period(cmd)) {
-		/* pick the lowest b0 divisor value we can (for maximum input
-		 * clock speed on convert and scan counters) */
+		/*
+		 * pick the lowest b0 divisor value we can (for maximum input
+		 * clock speed on convert and scan counters)
+		 */
 		devpriv->divisor_b0 = (labpc_ai_scan_period(cmd) - 1) /
 			(LABPC_TIMER_BASE * max_counter_value) + 1;
 		if (devpriv->divisor_b0 < min_counter_value)
@@ -1820,14 +1850,18 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 					base_period * devpriv->divisor_a0);
 		labpc_set_ai_scan_period(cmd,
 					base_period * devpriv->divisor_b1);
-		/* if only one TRIG_TIMER is used,
-		 * we can employ the generic cascaded timing functions */
+		/*
+		 * if only one TRIG_TIMER is used, we can employ the generic
+		 * cascaded timing functions
+		 */
 	} else if (labpc_ai_scan_period(cmd)) {
 		unsigned int scan_period;
 
 		scan_period = labpc_ai_scan_period(cmd);
-		/* calculate cascaded counter values
-		 * that give desired scan timing */
+		/*
+		 * calculate cascaded counter values that give desired
+		 * scan timing
+		 */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					&(devpriv->divisor_b1),
 					&(devpriv->divisor_b0),
@@ -1838,8 +1872,10 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 		unsigned int convert_period;
 
 		convert_period = labpc_ai_convert_period(cmd);
-		/* calculate cascaded counter values
-		 * that give desired conversion timing */
+		/*
+		 * calculate cascaded counter values that give desired
+		 * conversion timing
+		 */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					&(devpriv->divisor_a0),
 					&(devpriv->divisor_b0),
@@ -1919,8 +1955,8 @@ static unsigned int labpc_eeprom_read(struct comedi_device *dev,
 					unsigned int address)
 {
 	unsigned int value;
-	const int read_instruction = 0x3;	/* bits to tell eeprom
-						 * to expect a read */
+				/* bits to tell eeprom to expect a read */
+	const int read_instruction = 0x3;
 	const int write_length = 8;	/* 8 bit write lengths to eeprom */
 
 	/* enable read/write to eeprom */
-- 
1.6.3.3

