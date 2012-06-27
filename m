Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2F0Aqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:46:53 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:10601 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F0Aqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:46:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1340758008!12303568!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/36] staging: comedi: cb_pcidas: remove forward declarations 1
Date: Tue, 26 Jun 2012 17:46:44 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261746.44862.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the attach/detach functions to remove the need for some
of the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 494 +++++++++++++----------------
 1 file changed, 219 insertions(+), 275 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index e2bf222..5460410 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -447,37 +447,9 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-static int cb_pcidas_ai_rinsn(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn, unsigned int *data);
-static int ai_config_insn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-static int cb_pcidas_ao_nofifo_winsn(struct comedi_device *dev,
-				     struct comedi_subdevice *s,
-				     struct comedi_insn *insn,
-				     unsigned int *data);
-static int cb_pcidas_ao_fifo_winsn(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn,
-				   unsigned int *data);
-static int cb_pcidas_ao_readback_insn(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data);
-static int cb_pcidas_ai_cmd(struct comedi_device *dev,
-			    struct comedi_subdevice *s);
-static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_cmd *cmd);
-static int cb_pcidas_ao_cmd(struct comedi_device *dev,
-			    struct comedi_subdevice *s);
 static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 				struct comedi_subdevice *subdev,
 				unsigned int trig_num);
-static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_cmd *cmd);
-static irqreturn_t cb_pcidas_interrupt(int irq, void *d);
 static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status);
 static int cb_pcidas_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s);
@@ -485,30 +457,6 @@ static int cb_pcidas_ao_cancel(struct comedi_device *dev,
 			       struct comedi_subdevice *s);
 static void cb_pcidas_load_counters(struct comedi_device *dev, unsigned int *ns,
 				    int round_flags);
-static int eeprom_read_insn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int caldac_read_insn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int caldac_write_insn(struct comedi_device *dev,
-			     struct comedi_subdevice *s,
-			     struct comedi_insn *insn, unsigned int *data);
-static int trimpot_read_insn(struct comedi_device *dev,
-			     struct comedi_subdevice *s,
-			     struct comedi_insn *insn, unsigned int *data);
-static int cb_pcidas_trimpot_write(struct comedi_device *dev,
-				   unsigned int channel, unsigned int value);
-static int trimpot_write_insn(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn, unsigned int *data);
-static int dac08_read_insn(struct comedi_device *dev,
-			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data);
-static int dac08_write(struct comedi_device *dev, unsigned int value);
-static int dac08_write_insn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
 static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
 			     uint8_t value);
 static int trimpot_7376_write(struct comedi_device *dev, uint8_t value);
@@ -523,229 +471,6 @@ static inline unsigned int cal_enable_bits(struct comedi_device *dev)
 }
 
 /*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.
- */
-static int cb_pcidas_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	struct pci_dev *pcidev = NULL;
-	int index;
-	int i;
-	int ret;
-
-/*
- * Allocate the private structure area.
- */
-	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
-		return -ENOMEM;
-
-/*
- * Probe the device to determine what device in the series it is.
- */
-
-	for_each_pci_dev(pcidev) {
-		/*  is it not a computer boards card? */
-		if (pcidev->vendor != PCI_VENDOR_ID_CB)
-			continue;
-		/*  loop through cards supported by this driver */
-		for (index = 0; index < ARRAY_SIZE(cb_pcidas_boards); index++) {
-			if (cb_pcidas_boards[index].device_id != pcidev->device)
-				continue;
-			/*  was a particular bus/slot requested? */
-			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
-			}
-			devpriv->pci_dev = pcidev;
-			dev->board_ptr = cb_pcidas_boards + index;
-			goto found;
-		}
-	}
-
-	dev_err(dev->class_dev,
-		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
-	return -EIO;
-
-found:
-
-	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		cb_pcidas_boards[index].name, pcidev->bus->number,
-		PCI_SLOT(pcidev->devfn));
-
-	/*
-	 * Enable PCI device and reserve I/O ports.
-	 */
-	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
-		dev_err(dev->class_dev,
-			"Failed to enable PCI device and request regions\n");
-		return -EIO;
-	}
-	/*
-	 * Initialize devpriv->control_status and devpriv->adc_fifo to point to
-	 * their base address.
-	 */
-	devpriv->s5933_config =
-	    pci_resource_start(devpriv->pci_dev, S5933_BADRINDEX);
-	devpriv->control_status =
-	    pci_resource_start(devpriv->pci_dev, CONT_STAT_BADRINDEX);
-	devpriv->adc_fifo =
-	    pci_resource_start(devpriv->pci_dev, ADC_FIFO_BADRINDEX);
-	devpriv->pacer_counter_dio =
-	    pci_resource_start(devpriv->pci_dev, PACER_BADRINDEX);
-	if (thisboard->ao_nchan) {
-		devpriv->ao_registers =
-		    pci_resource_start(devpriv->pci_dev, AO_BADRINDEX);
-	}
-	/*  disable and clear interrupts on amcc s5933 */
-	outl(INTCSR_INBOX_INTR_STATUS,
-	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-
-	/*  get irq */
-	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
-			IRQF_SHARED, "cb_pcidas", dev)) {
-		dev_dbg(dev->class_dev, "unable to allocate irq %d\n",
-			devpriv->pci_dev->irq);
-		return -EINVAL;
-	}
-	dev->irq = devpriv->pci_dev->irq;
-
-	/* Initialize dev->board_name */
-	dev->board_name = thisboard->name;
-
-	ret = comedi_alloc_subdevices(dev, 7);
-	if (ret)
-		return ret;
-
-	s = dev->subdevices + 0;
-	/* analog input subdevice */
-	dev->read_subdev = s;
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
-	/* WARNING: Number of inputs in differential mode is ignored */
-	s->n_chan = thisboard->ai_se_chans;
-	s->len_chanlist = thisboard->ai_se_chans;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
-	s->range_table = thisboard->ranges;
-	s->insn_read = cb_pcidas_ai_rinsn;
-	s->insn_config = ai_config_insn;
-	s->do_cmd = cb_pcidas_ai_cmd;
-	s->do_cmdtest = cb_pcidas_ai_cmdtest;
-	s->cancel = cb_pcidas_cancel;
-
-	/* analog output subdevice */
-	s = dev->subdevices + 1;
-	if (thisboard->ao_nchan) {
-		s->type = COMEDI_SUBD_AO;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = thisboard->ao_nchan;
-		/*  analog out resolution is the same as analog input resolution, so use ai_bits */
-		s->maxdata = (1 << thisboard->ai_bits) - 1;
-		s->range_table = &cb_pcidas_ao_ranges;
-		s->insn_read = cb_pcidas_ao_readback_insn;
-		if (thisboard->has_ao_fifo) {
-			dev->write_subdev = s;
-			s->subdev_flags |= SDF_CMD_WRITE;
-			s->insn_write = cb_pcidas_ao_fifo_winsn;
-			s->do_cmdtest = cb_pcidas_ao_cmdtest;
-			s->do_cmd = cb_pcidas_ao_cmd;
-			s->cancel = cb_pcidas_ao_cancel;
-		} else {
-			s->insn_write = cb_pcidas_ao_nofifo_winsn;
-		}
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	/* 8255 */
-	s = dev->subdevices + 2;
-	subdev_8255_init(dev, s, NULL, devpriv->pacer_counter_dio + DIO_8255);
-
-	/*  serial EEPROM, */
-	s = dev->subdevices + 3;
-	s->type = COMEDI_SUBD_MEMORY;
-	s->subdev_flags = SDF_READABLE | SDF_INTERNAL;
-	s->n_chan = 256;
-	s->maxdata = 0xff;
-	s->insn_read = eeprom_read_insn;
-
-	/*  8800 caldac */
-	s = dev->subdevices + 4;
-	s->type = COMEDI_SUBD_CALIB;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
-	s->n_chan = NUM_CHANNELS_8800;
-	s->maxdata = 0xff;
-	s->insn_read = caldac_read_insn;
-	s->insn_write = caldac_write_insn;
-	for (i = 0; i < s->n_chan; i++)
-		caldac_8800_write(dev, i, s->maxdata / 2);
-
-	/*  trim potentiometer */
-	s = dev->subdevices + 5;
-	s->type = COMEDI_SUBD_CALIB;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
-	if (thisboard->trimpot == AD7376) {
-		s->n_chan = NUM_CHANNELS_7376;
-		s->maxdata = 0x7f;
-	} else {
-		s->n_chan = NUM_CHANNELS_8402;
-		s->maxdata = 0xff;
-	}
-	s->insn_read = trimpot_read_insn;
-	s->insn_write = trimpot_write_insn;
-	for (i = 0; i < s->n_chan; i++)
-		cb_pcidas_trimpot_write(dev, i, s->maxdata / 2);
-
-	/*  dac08 caldac */
-	s = dev->subdevices + 6;
-	if (thisboard->has_dac08) {
-		s->type = COMEDI_SUBD_CALIB;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
-		s->n_chan = NUM_CHANNELS_DAC08;
-		s->insn_read = dac08_read_insn;
-		s->insn_write = dac08_write_insn;
-		s->maxdata = 0xff;
-		dac08_write(dev, s->maxdata / 2);
-	} else
-		s->type = COMEDI_SUBD_UNUSED;
-
-	/*  make sure mailbox 4 is empty */
-	inl(devpriv->s5933_config + AMCC_OP_REG_IMB4);
-	/* Set bits to enable incoming mailbox interrupts on amcc s5933. */
-	devpriv->s5933_intcsr_bits =
-	    INTCSR_INBOX_BYTE(3) | INTCSR_INBOX_SELECT(3) |
-	    INTCSR_INBOX_FULL_INT;
-	/*  clear and enable interrupt on amcc s5933 */
-	outl(devpriv->s5933_intcsr_bits | INTCSR_INBOX_INTR_STATUS,
-	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-
-	return 1;
-}
-
-static void cb_pcidas_detach(struct comedi_device *dev)
-{
-	if (devpriv) {
-		if (devpriv->s5933_config) {
-			outl(INTCSR_INBOX_INTR_STATUS,
-			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-		}
-	}
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
-	if (devpriv && devpriv->pci_dev) {
-		if (devpriv->s5933_config)
-			comedi_pci_disable(devpriv->pci_dev);
-		pci_dev_put(devpriv->pci_dev);
-	}
-}
-
-/*
  * "instructions" read/write data in "one-shot" or "software-triggered"
  * mode.
  */
@@ -1872,6 +1597,225 @@ static int nvram_read(struct comedi_device *dev, unsigned int address,
 	return 0;
 }
 
+static int cb_pcidas_attach(struct comedi_device *dev,
+			    struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	struct pci_dev *pcidev = NULL;
+	int index;
+	int i;
+	int ret;
+
+/*
+ * Allocate the private structure area.
+ */
+	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
+		return -ENOMEM;
+
+/*
+ * Probe the device to determine what device in the series it is.
+ */
+
+	for_each_pci_dev(pcidev) {
+		/*  is it not a computer boards card? */
+		if (pcidev->vendor != PCI_VENDOR_ID_CB)
+			continue;
+		/*  loop through cards supported by this driver */
+		for (index = 0; index < ARRAY_SIZE(cb_pcidas_boards); index++) {
+			if (cb_pcidas_boards[index].device_id != pcidev->device)
+				continue;
+			/*  was a particular bus/slot requested? */
+			if (it->options[0] || it->options[1]) {
+				/*  are we on the wrong bus/slot? */
+				if (pcidev->bus->number != it->options[0] ||
+				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
+					continue;
+				}
+			}
+			devpriv->pci_dev = pcidev;
+			dev->board_ptr = cb_pcidas_boards + index;
+			goto found;
+		}
+	}
+
+	dev_err(dev->class_dev,
+		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
+	return -EIO;
+
+found:
+
+	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
+		cb_pcidas_boards[index].name, pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
+
+	/*
+	 * Enable PCI device and reserve I/O ports.
+	 */
+	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
+		dev_err(dev->class_dev,
+			"Failed to enable PCI device and request regions\n");
+		return -EIO;
+	}
+	/*
+	 * Initialize devpriv->control_status and devpriv->adc_fifo to point to
+	 * their base address.
+	 */
+	devpriv->s5933_config =
+	    pci_resource_start(devpriv->pci_dev, S5933_BADRINDEX);
+	devpriv->control_status =
+	    pci_resource_start(devpriv->pci_dev, CONT_STAT_BADRINDEX);
+	devpriv->adc_fifo =
+	    pci_resource_start(devpriv->pci_dev, ADC_FIFO_BADRINDEX);
+	devpriv->pacer_counter_dio =
+	    pci_resource_start(devpriv->pci_dev, PACER_BADRINDEX);
+	if (thisboard->ao_nchan) {
+		devpriv->ao_registers =
+		    pci_resource_start(devpriv->pci_dev, AO_BADRINDEX);
+	}
+	/*  disable and clear interrupts on amcc s5933 */
+	outl(INTCSR_INBOX_INTR_STATUS,
+	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
+
+	/*  get irq */
+	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
+			IRQF_SHARED, "cb_pcidas", dev)) {
+		dev_dbg(dev->class_dev, "unable to allocate irq %d\n",
+			devpriv->pci_dev->irq);
+		return -EINVAL;
+	}
+	dev->irq = devpriv->pci_dev->irq;
+
+	/* Initialize dev->board_name */
+	dev->board_name = thisboard->name;
+
+	ret = comedi_alloc_subdevices(dev, 7);
+	if (ret)
+		return ret;
+
+	s = dev->subdevices + 0;
+	/* analog input subdevice */
+	dev->read_subdev = s;
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
+	/* WARNING: Number of inputs in differential mode is ignored */
+	s->n_chan = thisboard->ai_se_chans;
+	s->len_chanlist = thisboard->ai_se_chans;
+	s->maxdata = (1 << thisboard->ai_bits) - 1;
+	s->range_table = thisboard->ranges;
+	s->insn_read = cb_pcidas_ai_rinsn;
+	s->insn_config = ai_config_insn;
+	s->do_cmd = cb_pcidas_ai_cmd;
+	s->do_cmdtest = cb_pcidas_ai_cmdtest;
+	s->cancel = cb_pcidas_cancel;
+
+	/* analog output subdevice */
+	s = dev->subdevices + 1;
+	if (thisboard->ao_nchan) {
+		s->type = COMEDI_SUBD_AO;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
+		s->n_chan = thisboard->ao_nchan;
+		/*  analog out resolution is the same as analog input resolution, so use ai_bits */
+		s->maxdata = (1 << thisboard->ai_bits) - 1;
+		s->range_table = &cb_pcidas_ao_ranges;
+		s->insn_read = cb_pcidas_ao_readback_insn;
+		if (thisboard->has_ao_fifo) {
+			dev->write_subdev = s;
+			s->subdev_flags |= SDF_CMD_WRITE;
+			s->insn_write = cb_pcidas_ao_fifo_winsn;
+			s->do_cmdtest = cb_pcidas_ao_cmdtest;
+			s->do_cmd = cb_pcidas_ao_cmd;
+			s->cancel = cb_pcidas_ao_cancel;
+		} else {
+			s->insn_write = cb_pcidas_ao_nofifo_winsn;
+		}
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	/* 8255 */
+	s = dev->subdevices + 2;
+	subdev_8255_init(dev, s, NULL, devpriv->pacer_counter_dio + DIO_8255);
+
+	/*  serial EEPROM, */
+	s = dev->subdevices + 3;
+	s->type = COMEDI_SUBD_MEMORY;
+	s->subdev_flags = SDF_READABLE | SDF_INTERNAL;
+	s->n_chan = 256;
+	s->maxdata = 0xff;
+	s->insn_read = eeprom_read_insn;
+
+	/*  8800 caldac */
+	s = dev->subdevices + 4;
+	s->type = COMEDI_SUBD_CALIB;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
+	s->n_chan = NUM_CHANNELS_8800;
+	s->maxdata = 0xff;
+	s->insn_read = caldac_read_insn;
+	s->insn_write = caldac_write_insn;
+	for (i = 0; i < s->n_chan; i++)
+		caldac_8800_write(dev, i, s->maxdata / 2);
+
+	/*  trim potentiometer */
+	s = dev->subdevices + 5;
+	s->type = COMEDI_SUBD_CALIB;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
+	if (thisboard->trimpot == AD7376) {
+		s->n_chan = NUM_CHANNELS_7376;
+		s->maxdata = 0x7f;
+	} else {
+		s->n_chan = NUM_CHANNELS_8402;
+		s->maxdata = 0xff;
+	}
+	s->insn_read = trimpot_read_insn;
+	s->insn_write = trimpot_write_insn;
+	for (i = 0; i < s->n_chan; i++)
+		cb_pcidas_trimpot_write(dev, i, s->maxdata / 2);
+
+	/*  dac08 caldac */
+	s = dev->subdevices + 6;
+	if (thisboard->has_dac08) {
+		s->type = COMEDI_SUBD_CALIB;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
+		s->n_chan = NUM_CHANNELS_DAC08;
+		s->insn_read = dac08_read_insn;
+		s->insn_write = dac08_write_insn;
+		s->maxdata = 0xff;
+		dac08_write(dev, s->maxdata / 2);
+	} else
+		s->type = COMEDI_SUBD_UNUSED;
+
+	/*  make sure mailbox 4 is empty */
+	inl(devpriv->s5933_config + AMCC_OP_REG_IMB4);
+	/* Set bits to enable incoming mailbox interrupts on amcc s5933. */
+	devpriv->s5933_intcsr_bits =
+	    INTCSR_INBOX_BYTE(3) | INTCSR_INBOX_SELECT(3) |
+	    INTCSR_INBOX_FULL_INT;
+	/*  clear and enable interrupt on amcc s5933 */
+	outl(devpriv->s5933_intcsr_bits | INTCSR_INBOX_INTR_STATUS,
+	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
+
+	return 1;
+}
+
+static void cb_pcidas_detach(struct comedi_device *dev)
+{
+	if (devpriv) {
+		if (devpriv->s5933_config) {
+			outl(INTCSR_INBOX_INTR_STATUS,
+			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
+		}
+	}
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->subdevices)
+		subdev_8255_cleanup(dev, dev->subdevices + 2);
+	if (devpriv && devpriv->pci_dev) {
+		if (devpriv->s5933_config)
+			comedi_pci_disable(devpriv->pci_dev);
+		pci_dev_put(devpriv->pci_dev);
+	}
+}
+
 static struct comedi_driver cb_pcidas_driver = {
 	.driver_name	= "cb_pcidas",
 	.module		= THIS_MODULE,
-- 
1.7.11

