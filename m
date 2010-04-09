Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab0DIU22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:28:28 -0400
Received: from mtumx-1.merit.edu ([198.108.1.19]:25632 "EHLO mail.mtu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757019Ab0DIU2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:28:24 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2010 16:28:24 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHIqv0uN208i/2dsb2JhbADPHohchQkEjj4
X-IronPort-AV: E=Sophos;i="4.52,179,1270440000"; 
   d="scan'208";a="274489655"
Message-ID: <4BBF8D27.6000501@mtu.edu>
Date: Fri, 09 Apr 2010 16:25:11 -0400
From: Jakob Penzien <jwpenzie@mtu.edu>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: gregkh@suse.de, Bill Pemberton <wfp5p@virginia.edu>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: PATCH: ni_labpc.c
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Staging: comedi: Fixed brace, KERN_, 80 characters issues in ni_labpc.c
 This is a patch to ni_labpc.c file that fixes all the brace
 and 80 character warnings and it also fixes some of the KERN_ facility
 warnings found by the checkpatch.pl tool. The two errors about indent warning
are there because I do not understand what they want and so I left it in the orginal code
and they happened to get pulled in the patch.
 Signed-off-by: Jakob Penzien <supermine290@gmail.com>

---
 drivers/staging/comedi/drivers/ni_labpc.c |  219 ++++++++++++++++++-----------
 1 files changed, 135 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index dc3f398..2140bd8 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1,7 +1,8 @@
 /*
     comedi/drivers/ni_labpc.c
     Driver for National Instruments Lab-PC series boards and compatibles
-    Copyright (C) 2001, 2002, 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
+    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
+    <fmhess@users.sourceforge.net>

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -101,15 +102,15 @@ NI manuals:
 #define   ADC_CHAN_BITS(x)	((x) & 0x7)
 #define   ADC_SCAN_EN_BIT	0x80	/*  enables multi channel scans */
 #define COMMAND2_REG	0x1
-#define   PRETRIG_BIT	0x1	/*  enable pretriggering (used in conjunction with SWTRIG) */
-#define   HWTRIG_BIT	0x2	/*  enable paced conversions on external trigger */
+#define   PRETRIG_BIT	0x1     /*  enable pretriggering (used with SWTRIG) */
+#define   HWTRIG_BIT	0x2  /*  enable paced conversions on external trigger */
 #define   SWTRIG_BIT	0x4	/*  enable paced conversions */
 #define   CASCADE_BIT	0x8	/*  use two cascaded counters for pacing */
 #define   DAC_PACED_BIT(channel)	(0x40 << ((channel) & 0x1))
 #define COMMAND3_REG	0x2
 #define   DMA_EN_BIT	0x1	/*  enable dma transfers */
 #define   DIO_INTR_EN_BIT	0x2	/*  enable interrupts for 8255 */
-#define   DMATC_INTR_EN_BIT	0x4	/*  enable dma terminal count interrupt */
+#define   DMATC_INTR_EN_BIT	0x4   /*  enable dma terminal count interrupt */
 #define   TIMER_INTR_EN_BIT	0x8	/*  enable timer interrupt */
 #define   ERR_INTR_EN_BIT	0x10	/*  enable error interrupt */
 #define   ADC_FNE_INTR_EN_BIT	0x20	/*  enable fifo not empty interrupt */
@@ -120,24 +121,38 @@ NI manuals:
 #define DMATC_CLEAR_REG	0xa
 #define TIMER_CLEAR_REG	0xc
 #define COMMAND6_REG	0xe	/*  1200 boards only */
-#define   ADC_COMMON_BIT	0x1	/*  select ground or common-mode reference */
+#define   ADC_COMMON_BIT      0x1  /*  select ground or common-mode reference */
 #define   ADC_UNIP_BIT	0x2	/*  adc unipolar */
-#define   DAC_UNIP_BIT(channel)	(0x4 << ((channel) & 0x1))	/*  dac unipolar */
+#define   DAC_UNIP_BIT(channel)	(0x4 << ((channel) & 0x1))   /*  dac unipolar */
 #define   ADC_FHF_INTR_EN_BIT	0x20	/*  enable fifo half full interrupt */
-#define   A1_INTR_EN_BIT	0x40	/*  enable interrupt on end of hardware count */
-#define   ADC_SCAN_UP_BIT 0x80	/*  scan up from channel zero instead of down to zero */
+#define   A1_INTR_EN_BIT	0x40	/*  enable interrupt on end of hardware
+					 *  count
+					 */
+#define   ADC_SCAN_UP_BIT 0x80	/*  scan up from channel zero instead of down
+				 *to zero
+				 */
 #define COMMAND4_REG	0xf
 #define   INTERVAL_SCAN_EN_BIT	0x1	/*  enables 'interval' scanning */
-#define   EXT_SCAN_EN_BIT	0x2	/*  enables external signal on counter b1 output to trigger scan */
-#define   EXT_CONVERT_OUT_BIT	0x4	/*  chooses direction (output or input) for EXTCONV* line */
-#define   ADC_DIFF_BIT	0x8	/*  chooses differential inputs for adc (in conjunction with board jumper) */
+#define   EXT_SCAN_EN_BIT	0x2	/*  enables external signal on counter
+					 *  b1 output to trigger scan
+					 */
+#define   EXT_CONVERT_OUT_BIT	0x4	/*  chooses direction (output or input)
+					 *  for EXTCONV* line
+					 */
+#define   ADC_DIFF_BIT	0x8	/*  chooses differential inputs for adc
+				 *  (in conjunction with board jumper)
+				 */
 #define   EXT_CONVERT_DISABLE_BIT	0x10
 #define COMMAND5_REG	0x1c	/*  1200 boards only, calibration stuff */
 #define   EEPROM_WRITE_UNPROTECT_BIT	0x4	/*  enable eeprom for write */
 #define   DITHER_EN_BIT	0x8	/*  enable dithering */
 #define   CALDAC_LOAD_BIT	0x10	/*  load calibration dac */
-#define   SCLOCK_BIT	0x20	/*  serial clock - rising edge writes, falling edge reads */
-#define   SDATA_BIT	0x40	/*  serial data bit for writing to eeprom or calibration dacs */
+#define   SCLOCK_BIT	0x20	/*  serial clock - rising edge writes,
+				 *  falling edge reads
+				 */
+#define   SDATA_BIT	0x40	/*  serial data bit for writing to eeprom
+				 *  or calibration dacs
+				 */
 #define   EEPROM_EN_BIT	0x80	/*  enable eeprom for read/write */
 #define INTERVAL_COUNT_REG	0x1e
 #define INTERVAL_LOAD_REG	0x1f
@@ -160,8 +175,12 @@ NI manuals:
 #define DIO_BASE_REG	0x10
 #define COUNTER_A_BASE_REG	0x14
 #define COUNTER_A_CONTROL_REG	(COUNTER_A_BASE_REG + 0x3)
-#define   INIT_A0_BITS	0x14	/*  check modes put conversion pacer output in harmless state (a0 mode 2) */
-#define   INIT_A1_BITS	0x70	/*  put hardware conversion counter output in harmless state (a1 mode 0) */
+#define   INIT_A0_BITS	0x14	/*  check modes put conversion pacer output
+				 *  in harmless state (a0 mode 2)
+				 */
+#define   INIT_A1_BITS	0x70	/*  put hardware conversion counter output
+				 *  in harmless state (a1 mode 0)
+				 */
 #define COUNTER_B_BASE_REG	0x18

 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it);
@@ -351,7 +370,8 @@ static const struct comedi_lrange range_labpc_ao = {
 };

 /* functions that do inb/outb and readb/writeb so we can use
- * function pointers to decide which to use */
+ * function pointers to decide which to use
+ */
 static inline unsigned int labpc_inb(unsigned long address)
 {
 	return inb(address);
@@ -423,7 +443,9 @@ static const struct labpc_board_struct labpc_boards[] = {
 	 .ai_scan_up = 1,
 	 .memory_mapped_io = 1,
 	 },
-	/*  dummy entry so pci board works when comedi_config is passed driver name */
+	/*  dummy entry so pci board works when comedi_config is passed
+	 *  driver name
+	 */
 	{
 	 .name = DRV_NAME,
 	 .bustype = pci_bustype,
@@ -436,7 +458,7 @@ static const struct labpc_board_struct labpc_boards[] = {
  */
 #define thisboard ((struct labpc_board_struct *)dev->board_ptr)

-static const int dma_buffer_size = 0xff00;	/*  size in bytes of dma buffer */
+static const int dma_buffer_size = 0xff00; /*  size in bytes of dma buffer */
 static const int sample_size = 2;	/*  2 bytes per sample */

 #define devpriv ((struct labpc_private *)dev->private)
@@ -481,18 +503,16 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	unsigned long dma_flags, isr_flags;
 	short lsb, msb;

-	printk("comedi%d: ni_labpc: %s, io 0x%lx", dev->minor, thisboard->name,
-	       iobase);
-	if (irq) {
+	printk("comedi%d: ni_labpc: %s, io 0x%lx", dev->minor,
+thisboard->name, iobase);
+	if (irq)
 		printk(", irq %u", irq);
-	}
-	if (dma_chan) {
+	if (dma_chan)
 		printk(", dma %u", dma_chan);
-	}
 	printk("\n");

 	if (iobase == 0) {
-		printk("io base address is zero!\n");
+		printk(KERN_ERR"io base address is zero!\n");
 		return -EINVAL;
 	}
 	/*  request io regions for isa boards */
@@ -500,7 +520,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		/* check if io addresses are available */
 		if (!request_region(iobase, LABPC_SIZE,
 				    driver_labpc.driver_name)) {
-			printk("I/O port conflict\n");
+			printk(KERN_ERR"I/O port conflict\n");
 			return -EIO;
 		}
 	}
@@ -532,7 +552,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 			isr_flags |= IRQF_SHARED;
 		if (request_irq(irq, labpc_interrupt, isr_flags,
 				driver_labpc.driver_name, dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			printk(KERN_ERR"unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
 	}
@@ -540,18 +560,18 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,

 	/*  grab dma channel */
 	if (dma_chan > 3) {
-		printk(" invalid dma channel %u\n", dma_chan);
+		printk(KERN_ERR" invalid dma channel %u\n", dma_chan);
 		return -EINVAL;
 	} else if (dma_chan) {
 		/*  allocate dma buffer */
 		devpriv->dma_buffer =
 		    kmalloc(dma_buffer_size, GFP_KERNEL | GFP_DMA);
 		if (devpriv->dma_buffer == NULL) {
-			printk(" failed to allocate dma buffer\n");
+			printk(KERN_ERR" failed to allocate dma buffer\n");
 			return -ENOMEM;
 		}
 		if (request_dma(dma_chan, driver_labpc.driver_name)) {
-			printk(" failed to allocate dma channel %u\n",
+			printk(KERN_ERR" failed to allocate dma channel %u\n",
 			       dma_chan);
 			return -EINVAL;
 		}
@@ -586,7 +606,8 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	s = dev->subdevices + 1;
 	if (thisboard->has_ao) {
 /* Could provide command support, except it only has a one sample
- * hardware buffer for analog output and no underrun flag. */
+ * hardware buffer for analog output and no underrun flag.
+ */
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
 		s->n_chan = NUM_AO_CHAN;
@@ -608,7 +629,9 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,

 	/* 8255 dio */
 	s = dev->subdevices + 2;
-	/*  if board uses io memory we have to give a custom callback function to the 8255 driver */
+	/*  if board uses io memory we have to give a custom callback function
+	 *to the 8255 driver
+	 */
 	if (thisboard->memory_mapped_io)
 		subdev_8255_init(dev, s, labpc_dio_mem_callback,
 				 (unsigned long)(dev->iobase + DIO_BASE_REG));
@@ -640,14 +663,12 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		s->insn_read = labpc_eeprom_read_insn;
 		s->insn_write = labpc_eeprom_write_insn;

-		for (i = 0; i < EEPROM_SIZE; i++) {
+		for (i = 0; i < EEPROM_SIZE; i++)
 			devpriv->eeprom_data[i] = labpc_eeprom_read(dev, i);
-		}
 #ifdef LABPC_DEBUG
-		printk(" eeprom:");
-		for (i = 0; i < EEPROM_SIZE; i++) {
+		printk(KERN_" eeprom:");
+		for (i = 0; i < EEPROM_SIZE; i++)
 			printk(" %i:0x%x ", i, devpriv->eeprom_data[i]);
-		}
 		printk("\n");
 #endif
 	} else
@@ -679,22 +700,23 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	case pci_bustype:
 #ifdef CONFIG_COMEDI_PCI
 		retval = labpc_find_device(dev, it->options[0], it->options[1]);
-		if (retval < 0) {
+		if (retval < 0)
 			return retval;
-		}
 		retval = mite_setup(devpriv->mite);
 		if (retval < 0)
 			return retval;
 		iobase = (unsigned long)devpriv->mite->daq_io_addr;
 		irq = mite_irq(devpriv->mite);
 #else
-		printk(" this driver has not been built with PCI support.\n");
+		printk(KERN_"this driver has not been"
+			"built with PCI support.\n");
 		return -EINVAL;
 #endif
 		break;
 	case pcmcia_bustype:
 		printk
-		    (" this driver does not support pcmcia cards, use ni_labpc_cs.o\n");
+		    (" this driver does not support pcmcia cards,"
+			    "use ni_labpc_cs.o\n");
 		return -EINVAL;
 		break;
 	default:
@@ -715,7 +737,7 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 	for (mite = mite_devices; mite; mite = mite->next) {
 		if (mite->used)
 			continue;
-		/*  if bus/slot are specified then make sure we have the right bus/slot */
+/*  if bus/slot are specified then make sure we have the right bus/slot */
 		if (bus || slot) {
 			if (bus != mite->pcidev->bus->number
 			    || slot != PCI_SLOT(mite->pcidev->devfn))
@@ -726,13 +748,13 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 				continue;
 			if (mite_device_id(mite) == labpc_boards[i].device_id) {
 				devpriv->mite = mite;
-				/*  fixup board pointer, in case we were using the dummy "ni_labpc" entry */
+   /*  fixup board pointer, in case we were using the dummy "ni_labpc" entry */
 				dev->board_ptr = &labpc_boards[i];
 				return 0;
 			}
 		}
 	}
-	printk("no device found\n");
+	printk(KERN_ERR"no device found\n");
 	mite_list_devices();
 	return -EIO;
 }
@@ -823,7 +845,8 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 	if (mode == MODE_SINGLE_CHAN_INTERVAL) {
 		if (cmd->chanlist_len > 0xff) {
 			comedi_error(dev,
-				     "ni_labpc: chanlist too long for single channel interval mode\n");
+				     "ni_labpc: chanlist too long for single"
+				"channel interval mode\n");
 			return 1;
 		}
 	}
@@ -838,14 +861,16 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 		case MODE_SINGLE_CHAN_INTERVAL:
 			if (CR_CHAN(cmd->chanlist[i]) != channel) {
 				comedi_error(dev,
-					     "channel scanning order specified in chanlist is not supported by hardware.\n");
+					     "channel scanning order specified"
+				"in chanlist is not supported by hardware.\n");
 				return 1;
 			}
 			break;
 		case MODE_MULT_CHAN_UP:
 			if (CR_CHAN(cmd->chanlist[i]) != i) {
 				comedi_error(dev,
-					     "channel scanning order specified in chanlist is not supported by hardware.\n");
+					     "channel scanning order specified"
+				"in chanlist is not supported by hardware.\n");
 				return 1;
 			}
 			break;
@@ -853,7 +878,8 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 			if (CR_CHAN(cmd->chanlist[i]) !=
 			    cmd->chanlist_len - i - 1) {
 				comedi_error(dev,
-					     "channel scanning order specified in chanlist is not supported by hardware.\n");
+					     "channel scanning order specified"
+				"in chanlist is not supported by hardware.\n");
 				return 1;
 			}
 			break;
@@ -865,13 +891,15 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,

 		if (CR_RANGE(cmd->chanlist[i]) != range) {
 			comedi_error(dev,
-				     "entries in chanlist must all have the same range\n");
+				     "entries in chanlist must all have the"
+				"same range\n");
 			return 1;
 		}

 		if (CR_AREF(cmd->chanlist[i]) != aref) {
 			comedi_error(dev,
-				     "entries in chanlist must all have the same reference\n");
+				     "entries in chanlist must all have the"
+				"same reference\n");
 			return 1;
 		}
 	}
@@ -980,7 +1008,7 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;

-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*step 2: make sure trigger sources are unique and mutually compatible*/

 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -1008,9 +1036,8 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 		err++;
 	}

-	if (!cmd->chanlist_len) {
+	if (!cmd->chanlist_len)
 		err++;
-	}
 	if (cmd->scan_end_arg != cmd->chanlist_len) {
 		cmd->scan_end_arg = cmd->chanlist_len;
 		err++;
@@ -1052,7 +1079,9 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 			err++;
 		}
 		break;
-		/*  TRIG_EXT doesn't care since it doesn't trigger off a numbered channel */
+		/*  TRIG_EXT doesn't care since it doesn't trigger off a
+		 *  numbered channel
+		 */
 	default:
 		break;
 	}
@@ -1105,30 +1134,36 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->write_byte(devpriv->command3_bits, dev->iobase + COMMAND3_REG);

 	/*  initialize software conversion count */
-	if (cmd->stop_src == TRIG_COUNT) {
+	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->count = cmd->stop_arg * cmd->chanlist_len;
-	}
 	/*  setup hardware conversion counter */
 	if (cmd->stop_src == TRIG_EXT) {
-		/*  load counter a1 with count of 3 (pc+ manual says this is minimum allowed) using mode 0 */
+		/*  load counter a1 with count of 3 (pc+ manual says this
+		 *  is minimum allowed) using mode 0
+		 */
 		ret = labpc_counter_load(dev, dev->iobase + COUNTER_A_BASE_REG,
 					 1, 3, 0);
 		if (ret < 0) {
 			comedi_error(dev, "error loading counter a1");
 			return -1;
 		}
-	} else			/*  otherwise, just put a1 in mode 0 with no count to set its output low */
+	} else
+/*  otherwise, just put a1 in mode 0 with no count to set its output low */
 		devpriv->write_byte(INIT_A1_BITS,
 				    dev->iobase + COUNTER_A_CONTROL_REG);

 	/*  figure out what method we will use to transfer data */
 	if (devpriv->dma_chan &&	/*  need a dma channel allocated */
-	    /*  dma unsafe at RT priority, and too much setup time for TRIG_WAKE_EOS for */
+	    /*  dma unsafe at RT priority, and too much setup time for
+	     *TRIG_WAKE_EOS for
+	     */
 	    (cmd->flags & (TRIG_WAKE_EOS | TRIG_RT)) == 0 &&
 	    /*  only available on the isa boards */
 	    thisboard->bustype == isa_bustype) {
 		xfer = isa_dma_transfer;
-	} else if (thisboard->register_layout == labpc_1200_layout &&	/*  pc-plus has no fifo-half full interrupt */
+	} else if (thisboard->register_layout == labpc_1200_layout &&
+/*  pc-plus has no fifo-half full interrupt */
+
 		   /*  wake-end-of-scan should interrupt on fifo not empty */
 		   (cmd->flags & TRIG_WAKE_EOS) == 0 &&
 		   /*  make sure we are taking more than just a few points */
@@ -1186,8 +1221,10 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (labpc_ai_scan_mode(cmd) == MODE_MULT_CHAN_UP ||
 	    labpc_ai_scan_mode(cmd) == MODE_MULT_CHAN_DOWN) {
 		devpriv->command1_bits |= ADC_SCAN_EN_BIT;
-		/* need a brief delay before enabling scan, or scan list will get screwed when you switch
-		 * between scan up to scan down mode - dunno why */
+		/* need a brief delay before enabling scan, or scan list will
+		 * get screwed when you switch between scan up to
+		 * scan down mode - dunno why
+		 */
 		udelay(1);
 		devpriv->write_byte(devpriv->command1_bits,
 				    dev->iobase + COMMAND1_REG);
@@ -1197,7 +1234,8 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->convert_src != TRIG_EXT)
 		devpriv->command4_bits |= EXT_CONVERT_DISABLE_BIT;
 	/* XXX should discard first scan when using interval scanning
-	 * since manual says it is not synced with scan clock */
+	 * since manual says it is not synced with scan clock
+	 */
 	if (labpc_use_continuous_mode(cmd) == 0) {
 		devpriv->command4_bits |= INTERVAL_SCAN_EN_BIT;
 		if (cmd->scan_begin_src == TRIG_EXT)
@@ -1214,7 +1252,8 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->write_byte(INTERVAL_LOAD_BITS,
 			    dev->iobase + INTERVAL_LOAD_REG);

-	if (cmd->convert_src == TRIG_TIMER || cmd->scan_begin_src == TRIG_TIMER) {
+	if (cmd->convert_src == TRIG_TIMER ||
+		cmd->scan_begin_src == TRIG_TIMER) {
 		/*  set up pacing */
 		labpc_adc_timing(dev, cmd);
 		/*  load counter b0 in mode 3 */
@@ -1256,7 +1295,8 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		irq_flags = claim_dma_lock();
 		disable_dma(devpriv->dma_chan);
 		/* clear flip-flop to make sure 2-byte registers for
-		 * count and address get set correctly */
+		 * count and address get set correctly
+		 */
 		clear_dma_ff(devpriv->dma_chan);
 		set_dma_addr(devpriv->dma_chan,
 			     virt_to_bus(devpriv->dma_buffer));
@@ -1361,7 +1401,7 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 	}

 	if (devpriv->current_transfer == isa_dma_transfer) {
-		/*  if a dma terminal count of external stop trigger has occurred */
+	/*  if a dma terminal count of external stop trigger has occurred */
 		if (devpriv->status1_bits & DMATC_BIT ||
 		    (thisboard->register_layout == labpc_1200_layout
 		     && devpriv->status2_bits & A1_TC_BIT)) {
@@ -1454,7 +1494,8 @@ static void labpc_drain_dma(struct comedi_device *dev)
 	flags = claim_dma_lock();
 	disable_dma(devpriv->dma_chan);
 	/* clear flip-flop to make sure 2-byte registers for
-	 * count and address get set correctly */
+	 * count and address get set correctly
+	 */
 	clear_dma_ff(devpriv->dma_chan);

 	/*  figure out how many points to read */
@@ -1479,12 +1520,10 @@ static void labpc_drain_dma(struct comedi_device *dev)
 	}

 	/* write data to comedi buffer */
-	for (i = 0; i < num_points; i++) {
+	for (i = 0; i < num_points; i++)
 		cfc_write_to_buffer(s, devpriv->dma_buffer[i]);
-	}
 	if (async->cmd.stop_src == TRIG_COUNT)
 		devpriv->count -= num_points;
-
 	/*  set address and count for next transfer */
 	set_dma_addr(devpriv->dma_chan, virt_to_bus(devpriv->dma_buffer));
 	set_dma_count(devpriv->dma_chan, leftover * sample_size);
@@ -1504,7 +1543,8 @@ static void handle_isa_dma(struct comedi_device *dev)
 }

 /* makes sure all data aquired by board is transfered to comedi (used
- * when aquisition is terminated by stop_src == TRIG_EXT). */
+ * when aquisition is terminated by stop_src == TRIG_EXT).
+ */
 static void labpc_drain_dregs(struct comedi_device *dev)
 {
 	if (devpriv->current_transfer == isa_dma_transfer)
@@ -1571,7 +1611,9 @@ static int labpc_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		devpriv->command4_bits |= ADC_DIFF_BIT;
 	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);

-	/*  initialize pacer counter output to make sure it doesn't cause any problems */
+	/*  initialize pacer counter output to make sure it doesn't
+	 *  cause any problems
+	 */
 	devpriv->write_byte(INIT_A0_BITS, dev->iobase + COUNTER_A_CONTROL_REG);

 	labpc_clear_adc_fifo(dev);
@@ -1610,7 +1652,8 @@ static int labpc_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,

 	/*  turn off pacing of analog output channel */
 	/* note: hardware bug in daqcard-1200 means pacing cannot
-	 * be independently enabled/disabled for its the two channels */
+	 * be independently enabled/disabled for its the two channels
+	 */
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->command2_bits &= ~DAC_PACED_BIT(channel);
 	devpriv->write_byte(devpriv->command2_bits, dev->iobase + COMMAND2_REG);
@@ -1686,7 +1729,8 @@ static int labpc_eeprom_write_insn(struct comedi_device *dev,
 	/*  only allow writes to user area of eeprom */
 	if (channel < 16 || channel > 127) {
 		printk
-		    ("eeprom writes are only allowed to channels 16 through 127 (the pointer and user areas)");
+		    ("eeprom writes are only allowed to channels 16 through 127"
+			    "(the pointer and user areas)");
 		return -EINVAL;
 	}

@@ -1724,13 +1768,19 @@ static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd)
 /* figures out what counter values to use based on command */
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 {
-	const int max_counter_value = 0x10000;	/*  max value for 16 bit counter in mode 2 */
-	const int min_counter_value = 2;	/*  min value for 16 bit counter in mode 2 */
+	const int max_counter_value = 0x10000;
+/*  max value for 16 bit counter in mode 2 */
+	const int min_counter_value = 2;
+/*  min value for 16 bit counter in mode 2 */
 	unsigned int base_period;

-	/*  if both convert and scan triggers are TRIG_TIMER, then they both rely on counter b0 */
+	/*  if both convert and scan triggers are TRIG_TIMER,
+	 *  then they both rely on counter b0
+	 */
 	if (labpc_ai_convert_period(cmd) && labpc_ai_scan_period(cmd)) {
-		/*  pick the lowest b0 divisor value we can (for maximum input clock speed on convert and scan counters) */
+	/*  pick the lowest b0 divisor value we can
+	 *  (for maximum input clock speed on convert and scan counters)
+	 */
 		devpriv->divisor_b0 = (labpc_ai_scan_period(cmd) - 1) /
 		    (LABPC_TIMER_BASE * max_counter_value) + 1;
 		if (devpriv->divisor_b0 < min_counter_value)
@@ -1780,12 +1830,14 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 					    base_period * devpriv->divisor_a0);
 		labpc_set_ai_scan_period(cmd,
 					 base_period * devpriv->divisor_b1);
-		/*  if only one TRIG_TIMER is used, we can employ the generic cascaded timing functions */
+		/* if only one TRIG_TIMER is used,
+		 * we use the generic cascaded timing functions
+		 */
 	} else if (labpc_ai_scan_period(cmd)) {
 		unsigned int scan_period;

 		scan_period = labpc_ai_scan_period(cmd);
-		/* calculate cascaded counter values that give desired scan timing */
+		/* calculate cascaded counter values (scan timing) */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					       &(devpriv->divisor_b1),
 					       &(devpriv->divisor_b0),
@@ -1796,7 +1848,7 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 		unsigned int convert_period;

 		convert_period = labpc_ai_convert_period(cmd);
-		/* calculate cascaded counter values that give desired conversion timing */
+		/* calculate cascaded counter values (conversion timing) */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					       &(devpriv->divisor_a0),
 					       &(devpriv->divisor_b0),
@@ -1864,9 +1916,8 @@ static unsigned int labpc_serial_in(struct comedi_device *dev)
 		udelay(1);
 		devpriv->status2_bits =
 		    devpriv->read_byte(dev->iobase + STATUS2_REG);
-		if (devpriv->status2_bits & EEPROM_OUT_BIT) {
+		if (devpriv->status2_bits & EEPROM_OUT_BIT)
 			value |= 1 << (value_width - i);
-		}
 	}

 	return value;
@@ -1876,7 +1927,7 @@ static unsigned int labpc_eeprom_read(struct comedi_device *dev,
 				      unsigned int address)
 {
 	unsigned int value;
-	const int read_instruction = 0x3;	/*  bits to tell eeprom to expect a read */
+	const int read_instruction = 0x3; /* tells eeprom to expect a read */
 	const int write_length = 8;	/*  8 bit write lengths to eeprom */

 	/*  enable read/write to eeprom */
--
1.6.3.3

