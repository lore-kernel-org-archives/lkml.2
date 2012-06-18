Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2FRSSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:18:40 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:53428 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2FRSSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:18:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1340043516!6251990!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove unneeded sanity check in insn_bits functions
Date: Mon, 18 Jun 2012 11:18:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206181118.26219.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comedi core does the sanity check to make sure that the data length
the INSN_BITS instruction is 2. There is no need for the drivers to do
this check. Remove all the sanity checks in the drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c           |  3 ---
 drivers/staging/comedi/drivers/acl7225b.c       |  6 ------
 drivers/staging/comedi/drivers/adl_pci6208.c    |  2 --
 drivers/staging/comedi/drivers/adl_pci7230.c    |  6 ------
 drivers/staging/comedi/drivers/adl_pci7432.c    |  6 ------
 drivers/staging/comedi/drivers/aio_iiro_16.c    |  6 ------
 drivers/staging/comedi/drivers/amplc_pc263.c    |  3 ---
 drivers/staging/comedi/drivers/cb_das16_cs.c    |  3 ---
 drivers/staging/comedi/drivers/comedi_bond.c    |  2 --
 drivers/staging/comedi/drivers/comedi_parport.c |  3 ---
 drivers/staging/comedi/drivers/contec_pci_dio.c |  6 ------
 drivers/staging/comedi/drivers/dmm32at.c        |  3 ---
 drivers/staging/comedi/drivers/dt2801.c         |  2 --
 drivers/staging/comedi/drivers/dt2811.c         |  6 ------
 drivers/staging/comedi/drivers/dt3000.c         |  3 ---
 drivers/staging/comedi/drivers/dyna_pci10xx.c   |  6 ------
 drivers/staging/comedi/drivers/me4000.c         | 11 -----------
 drivers/staging/comedi/drivers/multiq3.c        |  6 ------
 drivers/staging/comedi/drivers/ni_6527.c        |  8 --------
 drivers/staging/comedi/drivers/ni_65xx.c        |  6 +-----
 drivers/staging/comedi/drivers/ni_670x.c        |  3 ---
 drivers/staging/comedi/drivers/ni_at_ao.c       |  3 ---
 drivers/staging/comedi/drivers/ni_atmio16d.c    |  3 ---
 drivers/staging/comedi/drivers/ni_mio_common.c  |  9 ++-------
 drivers/staging/comedi/drivers/ni_pcidio.c      |  2 --
 drivers/staging/comedi/drivers/pcl711.c         |  6 ------
 drivers/staging/comedi/drivers/pcl725.c         |  6 ------
 drivers/staging/comedi/drivers/pcl726.c         |  6 ------
 drivers/staging/comedi/drivers/pcl730.c         |  6 ------
 drivers/staging/comedi/drivers/pcl812.c         |  6 ------
 drivers/staging/comedi/drivers/pcl818.c         |  6 ------
 drivers/staging/comedi/drivers/pcm3730.c        |  4 ----
 drivers/staging/comedi/drivers/pcmmio.c         |  2 --
 drivers/staging/comedi/drivers/pcmuio.c         |  2 --
 drivers/staging/comedi/drivers/poc.c            |  5 -----
 drivers/staging/comedi/drivers/rtd520.c         |  3 ---
 drivers/staging/comedi/drivers/rti800.c         |  5 -----
 drivers/staging/comedi/drivers/s526.c           |  3 ---
 drivers/staging/comedi/drivers/s626.c           | 12 ------------
 drivers/staging/comedi/drivers/skel.c           |  3 ---
 drivers/staging/comedi/drivers/ssv_dnp.c        |  4 ----
 drivers/staging/comedi/drivers/usbdux.c         |  3 ---
 drivers/staging/comedi/drivers/usbduxsigma.c    |  3 ---
 43 files changed, 3 insertions(+), 199 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index e0de149..4c9977b 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -139,9 +139,6 @@ static int subdev_8255_insn(struct comedi_device *dev,
 	unsigned int bits;
 	unsigned int v;
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	mask = data[0];
 	bits = data[1];
 
diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index 0bf5525..ab765d3 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -31,9 +31,6 @@ static int acl7225b_do_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -53,9 +50,6 @@ static int acl7225b_di_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + (unsigned long)s->private) |
 	    (inb(dev->iobase + (unsigned long)s->private + 1) << 8);
 
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 98b3730..f0a5958 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -141,8 +141,6 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
  *					struct comedi_subdevice *s, */
 /* struct comedi_insn *insn,unsigned int *data) */
 /* { */
-/* if(insn->n!=2)return -EINVAL; */
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 /* if(data[0]){ */
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 62fdf7f..d75734a 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -54,9 +54,6 @@ static int adl_pci7230_do_insn_bits(struct comedi_device *dev,
 	struct comedi_insn *insn,
 	unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -72,9 +69,6 @@ static int adl_pci7230_di_insn_bits(struct comedi_device *dev,
 	struct comedi_insn *insn,
 	unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inl(dev->iobase + PCI7230_DI) & 0xffffffff;
 
 	return 2;
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index aabf418..b071a08 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -57,9 +57,6 @@ static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
 	printk(KERN_DEBUG "comedi: pci7432_do_insn_bits called\n");
 	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -79,9 +76,6 @@ static int adl_pci7432_di_insn_bits(struct comedi_device *dev,
 	printk(KERN_DEBUG "comedi: pci7432_di_insn_bits called\n");
 	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inl(dev->iobase + PCI7432_DI) & 0xffffffff;
 	printk(KERN_DEBUG "comedi: data1 %8x\n", data[1]);
 
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 8059cef..3434107 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -70,9 +70,6 @@ static int aio_iiro_16_dio_insn_bits_write(struct comedi_device *dev,
 					   struct comedi_insn *insn,
 					   unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
@@ -91,9 +88,6 @@ static int aio_iiro_16_dio_insn_bits_read(struct comedi_device *dev,
 					  struct comedi_insn *insn,
 					  unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = 0;
 	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_0_7);
 	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_8_15) << 8;
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 4f15bfd..a018d81 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -185,9 +185,6 @@ static int pc263_do_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 0310077..c3a7133 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -549,9 +549,6 @@ static int das16cs_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 0260ddc..5ed324c 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -133,8 +133,6 @@ static int bonding_dio_insn_bits(struct comedi_device *dev,
 {
 #define LSAMPL_BITS (sizeof(unsigned int)*8)
 	unsigned nchans = LSAMPL_BITS, num_done = 0, i;
-	if (insn->n != 2)
-		return -EINVAL;
 
 	if (devpriv->nchans < nchans)
 		nchans = devpriv->nchans;
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 589d12f..10c3c35 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -162,9 +162,6 @@ static int parport_intr_insn(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n < 1)
-		return -EINVAL;
-
 	data[1] = 0;
 	return 2;
 }
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 79854b1..8d27154 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -74,9 +74,6 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 	dev_dbg(dev->hw_dev, "contec_do_insn_bits called\n");
 	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
@@ -95,9 +92,6 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 	dev_dbg(dev->hw_dev, "contec_di_insn_bits called\n");
 	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inw(dev->iobase + thisboard->in_offs);
 
 	return 2;
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 2b60cf8..7cc9d20 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -914,9 +914,6 @@ static int dmm32at_dio_insn_bits(struct comedi_device *dev,
 {
 	unsigned char diobits;
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 5afbf8a..d0bbbbb 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -535,8 +535,6 @@ static int dt2801_dio_insn_bits(struct comedi_device *dev,
 	if (s == dev->subdevices + 4)
 		which = 1;
 
-	if (insn->n != 2)
-		return -EINVAL;
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 91fbf4a..b239f38 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -352,9 +352,6 @@ static int dt2811_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + DT2811_DIO);
 
 	return 2;
@@ -364,9 +361,6 @@ static int dt2811_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	s->state &= ~data[0];
 	s->state |= data[0] & data[1];
 	outb(s->state, dev->iobase + DT2811_DIO);
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 9828fb1..0b130bf 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -745,9 +745,6 @@ static int dt3k_dio_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[1] & data[0];
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 9c855e2..78f3c8b 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -189,9 +189,6 @@ static int dyna_pci10xx_di_insn_bits(struct comedi_device *dev,
 {
 	u16 d = 0;
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	mutex_lock(&devpriv->mutex);
 	smp_mb();
 	d = inw_p(devpriv->BADR3);
@@ -209,9 +206,6 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit.
 	 * s->state contains the previous write data
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 72466bf..631b422 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1643,17 +1643,6 @@ static int me4000_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-	/* Length of data must be 2 (mask and new data, see below) */
-	if (insn->n == 0)
-		return 0;
-
-	if (insn->n != 2) {
-		printk
-		    ("comedi%d: me4000: me4000_dio_insn_bits(): "
-		     "Invalid instruction length\n", dev->minor);
-		return -EINVAL;
-	}
-
 	/*
 	 * The insn data consists of a mask in data[0] and the new data
 	 * in data[1]. The mask defines which bits we are concerning about.
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index b1bbd02..d1a8e91 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -161,9 +161,6 @@ static int multiq3_di_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inw(dev->iobase + MULTIQ3_DIGIN_PORT);
 
 	return 2;
@@ -173,9 +170,6 @@ static int multiq3_do_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	s->state &= ~data[0];
 	s->state |= (data[0] & data[1]);
 	outw(s->state, dev->iobase + MULTIQ3_DIGOUT_PORT);
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index b60ab48..eec44a0 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -174,9 +174,6 @@ static int ni6527_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = readb(devpriv->mite->daq_io_addr + Port_Register(0));
 	data[1] |= readb(devpriv->mite->daq_io_addr + Port_Register(1)) << 8;
 	data[1] |= readb(devpriv->mite->daq_io_addr + Port_Register(2)) << 16;
@@ -188,8 +185,6 @@ static int ni6527_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -339,9 +334,6 @@ static int ni6527_intr_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n < 1)
-		return -EINVAL;
-
 	data[1] = 0;
 	return 2;
 }
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index ac7c74b..f92f8ab 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -415,8 +415,7 @@ static int ni_65xx_dio_insn_bits(struct comedi_device *dev,
 	const unsigned max_ports_per_bitfield = 5;
 	unsigned read_bits = 0;
 	unsigned j;
-	if (insn->n != 2)
-		return -EINVAL;
+
 	base_bitfield_channel = CR_CHAN(insn->chanspec);
 	for (j = 0; j < max_ports_per_bitfield; ++j) {
 		const unsigned port_offset =
@@ -602,9 +601,6 @@ static int ni_65xx_intr_insn_bits(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n < 1)
-		return -EINVAL;
-
 	data[1] = 0;
 	return 2;
 }
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 5dffe6c..b62b427 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -306,9 +306,6 @@ static int ni_670x_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 1c3f322..28848bc 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -239,9 +239,6 @@ static int atao_dio_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 87992c9..54c0394 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -599,9 +599,6 @@ static int atmio16d_dio_insn_bits(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] | data[1]);
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 1f796b9..42df64e 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -3567,8 +3567,7 @@ static int ni_dio_insn_bits(struct comedi_device *dev,
 #ifdef DEBUG_DIO
 	printk("ni_dio_insn_bits() mask=0x%x bits=0x%x\n", data[0], data[1]);
 #endif
-	if (insn->n != 2)
-		return -EINVAL;
+
 	if (data[0]) {
 		/* Perform check to make sure we're not using the
 		   serial part of the dio */
@@ -3629,8 +3628,7 @@ static int ni_m_series_dio_insn_bits(struct comedi_device *dev,
 	printk("ni_m_series_dio_insn_bits() mask=0x%x bits=0x%x\n", data[0],
 	       data[1]);
 #endif
-	if (insn->n != 2)
-		return -EINVAL;
+
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -5485,9 +5483,6 @@ static int ni_rtsi_insn_bits(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = 0;
 
 	return 2;
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index cba0459..133ab2f 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -745,8 +745,6 @@ static int ni_pcidio_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index d5fa6f2..0df086a 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -449,9 +449,6 @@ static int pcl711_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + PCL711_DI_LO) |
 	    (inb(dev->iobase + PCL711_DI_HI) << 8);
 
@@ -463,9 +460,6 @@ static int pcl711_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index 8edbefd..433ea05 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -23,9 +23,6 @@ Devices: [Advantech] PCL-725 (pcl725)
 static int pcl725_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -40,9 +37,6 @@ static int pcl725_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int pcl725_di_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + PCL725_DI);
 
 	return 2;
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index b2e73cd..dfff9af 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -197,9 +197,6 @@ static int pcl726_di_insn_bits(struct comedi_device *dev,
 {
 	const struct pcl726_board *board = comedi_board(dev);
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + board->di_lo) |
 	    (inb(dev->iobase + board->di_hi) << 8);
 
@@ -212,9 +209,6 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 {
 	const struct pcl726_board *board = comedi_board(dev);
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index 3cba79a..d40caca 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -35,9 +35,6 @@ struct pcl730_board {
 static int pcl730_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -57,9 +54,6 @@ static int pcl730_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int pcl730_di_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + ((unsigned long)s->private)) |
 	    (inb(dev->iobase + ((unsigned long)s->private) + 1) << 8);
 
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index b0eb2ab..1c146c8 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -501,9 +501,6 @@ static int pcl812_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + PCL812_DI_LO);
 	data[1] |= inb(dev->iobase + PCL812_DI_HI) << 8;
 
@@ -517,9 +514,6 @@ static int pcl812_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 786c3b6..8e426a1 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -442,9 +442,6 @@ static int pcl818_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + PCL818_DI_LO) |
 	    (inb(dev->iobase + PCL818_DI_HI) << 8);
 
@@ -461,9 +458,6 @@ static int pcl818_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	s->state &= ~data[0];
 	s->state |= (data[0] & data[1]);
 
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index b48f7aa..311fe2d 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -32,8 +32,6 @@ static int pcm3730_do_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
@@ -48,8 +46,6 @@ static int pcm3730_di_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
 	data[1] = inb(dev->iobase + (unsigned long)(s->private));
 	return 2;
 }
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 0e64d84..a918cc0 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -275,8 +275,6 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_insn *insn, unsigned int *data)
 {
 	int byte_no;
-	if (insn->n != 2)
-		return -EINVAL;
 
 	/* NOTE:
 	   reading a 0 means this channel was high
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 48565fe..cfbf916 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -211,8 +211,6 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_insn *insn, unsigned int *data)
 {
 	int byte_no;
-	if (insn->n != 2)
-		return -EINVAL;
 
 	/* NOTE:
 	   reading a 0 means this channel was high
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index a129ccac..a655b90 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -99,9 +99,6 @@ static int pcl733_insn_bits(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	data[1] = inb(dev->iobase + 0);
 	data[1] |= (inb(dev->iobase + 1) << 8);
 	data[1] |= (inb(dev->iobase + 2) << 16);
@@ -114,8 +111,6 @@ static int pcl734_insn_bits(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index c3c8097..6ff1fa0 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1811,9 +1811,6 @@ static int rtd_dio_insn_bits(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 966ac2cc..b6f2199 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -263,8 +263,6 @@ static int rti800_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
 	data[1] = inb(dev->iobase + RTI800_DI);
 	return 2;
 }
@@ -273,9 +271,6 @@ static int rti800_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	if (data[0]) {
 		s->state &= ~data[0];
 		s->state |= data[0] & data[1];
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 141bc9e..b1dd224 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -678,9 +678,6 @@ static int s526_dio_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 32e03bc..182074c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2140,18 +2140,6 @@ static int s626_dio_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-
-	/* Length of data must be 2 (mask and new data, see below) */
-	if (insn->n == 0)
-		return 0;
-
-	if (insn->n != 2) {
-		printk
-		    ("comedi%d: s626: s626_dio_insn_bits(): Invalid instruction length\n",
-		     dev->minor);
-		return -EINVAL;
-	}
-
 	/*
 	 * The insn data consists of a mask in data[0] and the new data in
 	 * data[1]. The mask defines which bits we are concerning about.
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 92d44c1..67207de 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -561,9 +561,6 @@ static int skel_dio_insn_bits(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	if (insn->n != 2)
-		return -EINVAL;
-
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index b12bafe..f7bf3a2 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -77,10 +77,6 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
-
-	if (insn->n != 2)
-		return -EINVAL;	/* insn uses data[0] and data[1]     */
-
 	/* The insn data is a mask in data[0] and the new data in data[1],   */
 	/* each channel cooresponding to a bit.                              */
 
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 0386fd4..3185e1c 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -1780,9 +1780,6 @@ static int usbdux_dio_insn_bits(struct comedi_device *dev,
 	if (!this_usbduxsub)
 		return -EFAULT;
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	down(&this_usbduxsub->sem);
 
 	if (!(this_usbduxsub->probed)) {
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 502a409..f944c6a 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -1845,9 +1845,6 @@ static int usbdux_dio_insn_bits(struct comedi_device *dev,
 	if (!this_usbduxsub)
 		return -EFAULT;
 
-	if (insn->n != 2)
-		return -EINVAL;
-
 	down(&this_usbduxsub->sem);
 
 	if (!(this_usbduxsub->probed)) {
-- 
1.7.11

