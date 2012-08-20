Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2HTX7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 19:59:30 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:63042 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2HTX7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 19:59:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1345507161!25602975!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove pointer math for subdevice access
Date: Mon, 20 Aug 2012 16:59:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <dan.carpenter@oracle.com>,
        <abbotti@mev.co.uk>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201659.16987.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all the comedi_subdevice pointer access from pointer
math to array access.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_fops.c               | 28 ++++-----
 drivers/staging/comedi/drivers.c                   |  6 +-
 drivers/staging/comedi/drivers/8255.c              |  4 +-
 drivers/staging/comedi/drivers/acl7225b.c          |  6 +-
 .../staging/comedi/drivers/addi-data/addi_common.c | 14 ++---
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      | 21 +++----
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |  6 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |  6 +-
 drivers/staging/comedi/drivers/adl_pci7296.c       |  4 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |  8 +--
 drivers/staging/comedi/drivers/adl_pci8164.c       |  8 +--
 drivers/staging/comedi/drivers/adl_pci9111.c       |  8 +--
 drivers/staging/comedi/drivers/adl_pci9118.c       | 10 +--
 drivers/staging/comedi/drivers/adq12b.c            |  6 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       | 14 ++---
 drivers/staging/comedi/drivers/adv_pci1723.c       |  4 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       | 20 +++---
 drivers/staging/comedi/drivers/aio_aio12_8.c       | 10 +--
 drivers/staging/comedi/drivers/aio_iiro_16.c       |  4 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |  6 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |  8 +--
 drivers/staging/comedi/drivers/amplc_pc263.c       |  2 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  4 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      | 10 +--
 drivers/staging/comedi/drivers/c6xdigio.c          |  6 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |  6 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         | 16 ++---
 drivers/staging/comedi/drivers/cb_pcidas64.c       | 22 +++----
 drivers/staging/comedi/drivers/cb_pcidda.c         | 10 +--
 drivers/staging/comedi/drivers/cb_pcidio.c         |  4 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |  6 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |  6 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |  2 +-
 drivers/staging/comedi/drivers/comedi_parport.c    | 10 +--
 drivers/staging/comedi/drivers/comedi_test.c       |  4 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |  4 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |  8 +--
 drivers/staging/comedi/drivers/das08.c             | 14 ++---
 drivers/staging/comedi/drivers/das16.c             | 12 ++--
 drivers/staging/comedi/drivers/das16m1.c           | 10 +--
 drivers/staging/comedi/drivers/das1800.c           | 10 +--
 drivers/staging/comedi/drivers/das6402.c           |  4 +-
 drivers/staging/comedi/drivers/das800.c            |  8 +--
 drivers/staging/comedi/drivers/dmm32at.c           |  6 +-
 drivers/staging/comedi/drivers/dt2801.c            |  6 +-
 drivers/staging/comedi/drivers/dt2811.c            |  8 +--
 drivers/staging/comedi/drivers/dt2814.c            |  4 +-
 drivers/staging/comedi/drivers/dt2815.c            |  2 +-
 drivers/staging/comedi/drivers/dt2817.c            |  2 +-
 drivers/staging/comedi/drivers/dt282x.c            | 11 ++--
 drivers/staging/comedi/drivers/dt3000.c            |  5 +-
 drivers/staging/comedi/drivers/dt9812.c            |  8 +--
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |  8 +--
 drivers/staging/comedi/drivers/fl512.c             |  4 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |  2 +-
 drivers/staging/comedi/drivers/icp_multi.c         | 10 +--
 drivers/staging/comedi/drivers/ii_pci20kc.c        |  4 +-
 drivers/staging/comedi/drivers/ke_counter.c        |  2 +-
 drivers/staging/comedi/drivers/me4000.c            | 10 +--
 drivers/staging/comedi/drivers/me_daq.c            |  6 +-
 drivers/staging/comedi/drivers/mpc624.c            |  2 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        |  2 +-
 drivers/staging/comedi/drivers/multiq3.c           | 10 +--
 drivers/staging/comedi/drivers/ni_6527.c           |  8 +--
 drivers/staging/comedi/drivers/ni_65xx.c           | 10 +--
 drivers/staging/comedi/drivers/ni_660x.c           |  8 +--
 drivers/staging/comedi/drivers/ni_670x.c           |  6 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  2 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |  8 +--
 drivers/staging/comedi/drivers/ni_atmio16d.c       |  6 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |  2 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |  4 +-
 drivers/staging/comedi/drivers/ni_labpc.c          | 12 ++--
 drivers/staging/comedi/drivers/ni_mio_common.c     | 61 +++++++++---------
 drivers/staging/comedi/drivers/ni_pcidio.c         |  8 +--
 drivers/staging/comedi/drivers/pcl711.c            |  4 +-
 drivers/staging/comedi/drivers/pcl724.c            |  6 +-
 drivers/staging/comedi/drivers/pcl725.c            |  4 +-
 drivers/staging/comedi/drivers/pcl726.c            |  6 +-
 drivers/staging/comedi/drivers/pcl730.c            |  8 +--
 drivers/staging/comedi/drivers/pcl812.c            | 12 ++--
 drivers/staging/comedi/drivers/pcl816.c            |  6 +-
 drivers/staging/comedi/drivers/pcl818.c            | 18 +++---
 drivers/staging/comedi/drivers/pcm3724.c           | 16 ++---
 drivers/staging/comedi/drivers/pcm3730.c           | 12 ++--
 drivers/staging/comedi/drivers/pcmad.c             |  2 +-
 drivers/staging/comedi/drivers/pcmda12.c           |  2 +-
 drivers/staging/comedi/drivers/pcmmio.c            | 14 +++--
 drivers/staging/comedi/drivers/pcmuio.c            | 10 +--
 drivers/staging/comedi/drivers/poc.c               |  2 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |  8 +--
 drivers/staging/comedi/drivers/rtd520.c            | 10 +--
 drivers/staging/comedi/drivers/rti800.c            |  2 +-
 drivers/staging/comedi/drivers/rti802.c            |  2 +-
 drivers/staging/comedi/drivers/s526.c              |  8 +--
 drivers/staging/comedi/drivers/s626.c              | 73 ++++++++++------------
 drivers/staging/comedi/drivers/serial2002.c        | 10 +--
 drivers/staging/comedi/drivers/skel.c              |  6 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |  2 +-
 drivers/staging/comedi/drivers/usbdux.c            | 16 ++---
 drivers/staging/comedi/drivers/usbduxfast.c        |  4 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       | 14 ++---
 drivers/staging/comedi/drivers/vmk80xx.c           | 12 ++--
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |  4 +-
 drivers/staging/comedi/range.c                     |  2 +-
 106 files changed, 459 insertions(+), 464 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e821264..0d65ba9 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -426,7 +426,7 @@ static int do_bufconfig_ioctl(struct comedi_device *dev,
 	if (bc.subdevice >= dev->n_subdevices || bc.subdevice < 0)
 		return -EINVAL;
 
-	s = dev->subdevices + bc.subdevice;
+	s = &dev->subdevices[bc.subdevice];
 	async = s->async;
 
 	if (!async) {
@@ -539,7 +539,7 @@ static int do_subdinfo_ioctl(struct comedi_device *dev,
 
 	/* fill subdinfo structs */
 	for (i = 0; i < dev->n_subdevices; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		us = tmp + i;
 
 		us->type = s->type;
@@ -617,7 +617,7 @@ static int do_chaninfo_ioctl(struct comedi_device *dev,
 
 	if (it.subdev >= dev->n_subdevices)
 		return -EINVAL;
-	s = dev->subdevices + it.subdev;
+	s = &dev->subdevices[it.subdev];
 
 	if (it.maxdata_list) {
 		if (s->maxdata || !s->maxdata_list)
@@ -685,7 +685,7 @@ static int do_bufinfo_ioctl(struct comedi_device *dev,
 	if (bi.subdevice >= dev->n_subdevices || bi.subdevice < 0)
 		return -EINVAL;
 
-	s = dev->subdevices + bi.subdevice;
+	s = &dev->subdevices[bi.subdevice];
 
 	if (s->lock && s->lock != file)
 		return -EACCES;
@@ -940,7 +940,7 @@ static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 				ret = -EINVAL;
 				break;
 			}
-			s = dev->subdevices + insn->subdev;
+			s = &dev->subdevices[insn->subdev];
 			if (!s->async) {
 				DPRINTK("no async\n");
 				ret = -EINVAL;
@@ -969,7 +969,7 @@ static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 			ret = -EINVAL;
 			goto out;
 		}
-		s = dev->subdevices + insn->subdev;
+		s = &dev->subdevices[insn->subdev];
 
 		if (s->type == COMEDI_SUBD_UNUSED) {
 			DPRINTK("%d not usable subdevice\n", insn->subdev);
@@ -1153,7 +1153,7 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 		return -ENODEV;
 	}
 
-	s = dev->subdevices + user_cmd.subdev;
+	s = &dev->subdevices[user_cmd.subdev];
 	async = s->async;
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
@@ -1303,7 +1303,7 @@ static int do_cmdtest_ioctl(struct comedi_device *dev,
 		return -ENODEV;
 	}
 
-	s = dev->subdevices + user_cmd.subdev;
+	s = &dev->subdevices[user_cmd.subdev];
 	if (s->type == COMEDI_SUBD_UNUSED) {
 		DPRINTK("%d not valid subdevice\n", user_cmd.subdev);
 		return -EIO;
@@ -1390,7 +1390,7 @@ static int do_lock_ioctl(struct comedi_device *dev, unsigned int arg,
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
-	s = dev->subdevices + arg;
+	s = &dev->subdevices[arg];
 
 	spin_lock_irqsave(&s->spin_lock, flags);
 	if (s->busy || s->lock)
@@ -1433,7 +1433,7 @@ static int do_unlock_ioctl(struct comedi_device *dev, unsigned int arg,
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
-	s = dev->subdevices + arg;
+	s = &dev->subdevices[arg];
 
 	if (s->busy)
 		return -EBUSY;
@@ -1474,7 +1474,7 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
-	s = dev->subdevices + arg;
+	s = &dev->subdevices[arg];
 	if (s->async == NULL)
 		return -EINVAL;
 
@@ -1511,7 +1511,7 @@ static int do_poll_ioctl(struct comedi_device *dev, unsigned int arg,
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
-	s = dev->subdevices + arg;
+	s = &dev->subdevices[arg];
 
 	if (s->lock && s->lock != file)
 		return -EACCES;
@@ -2140,7 +2140,7 @@ static int comedi_close(struct inode *inode, struct file *file)
 
 	if (dev->subdevices) {
 		for (i = 0; i < dev->n_subdevices; i++) {
-			s = dev->subdevices + i;
+			s = &dev->subdevices[i];
 
 			if (s->busy == file)
 				do_cancel(dev, s);
@@ -2364,7 +2364,7 @@ static int is_device_busy(struct comedi_device *dev)
 		return 0;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		if (s->busy)
 			return 1;
 		if (s->async && s->async->mmap_count)
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index d04ce79..b5904c0 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -71,7 +71,7 @@ int comedi_alloc_subdevices(struct comedi_device *dev, int num_subdevices)
 	dev->n_subdevices = num_subdevices;
 
 	for (i = 0; i < num_subdevices; ++i) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		s->device = dev;
 		s->async_dma_dir = DMA_NONE;
 		spin_lock_init(&s->spin_lock);
@@ -88,7 +88,7 @@ static void cleanup_device(struct comedi_device *dev)
 
 	if (dev->subdevices) {
 		for (i = 0; i < dev->n_subdevices; i++) {
-			s = dev->subdevices + i;
+			s = &dev->subdevices[i];
 			comedi_free_subdevice_minor(s);
 			if (s->async) {
 				comedi_buf_alloc(dev, s, 0);
@@ -263,7 +263,7 @@ static int postconfig(struct comedi_device *dev)
 	int ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 
 		if (s->type == COMEDI_SUBD_UNUSED)
 			continue;
diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 4c9977b..e2506dd 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -403,7 +403,7 @@ static int dev_8255_attach(struct comedi_device *dev,
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		iobase = it->options[i];
 
 		if (!request_region(iobase, _8255_SIZE, "8255")) {
@@ -429,7 +429,7 @@ static void dev_8255_detach(struct comedi_device *dev)
 	int i;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		if (s->type != COMEDI_SUBD_UNUSED) {
 			spriv = s->private;
 			release_region(spriv->iobase, _8255_SIZE);
diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index ddba5db..28c7fd3 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -81,7 +81,7 @@ static int acl7225b_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* Relays outputs */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -91,7 +91,7 @@ static int acl7225b_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)ACL7225_RIO_LO;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* Relays status */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -101,7 +101,7 @@ static int acl7225b_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)ACL7225_RIO_LO;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* Isolated digital inputs */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index a3d4ed2..99a96bd 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -1669,7 +1669,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			return ret;
 
 		/*  Allocate and Initialise AI Subdevice Structures */
-		s = dev->subdevices + 0;
+		s = &dev->subdevices[0];
 		if ((devpriv->s_EeParameters.i_NbrAiChannel)
 			|| (this_board->i_NbrAiChannelDiff)) {
 			dev->read_subdev = s;
@@ -1705,7 +1705,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 
 		/*  Allocate and Initialise AO Subdevice Structures */
-		s = dev->subdevices + 1;
+		s = &dev->subdevices[1];
 		if (devpriv->s_EeParameters.i_NbrAoChannel) {
 			s->type = COMEDI_SUBD_AO;
 			s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
@@ -1720,7 +1720,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->type = COMEDI_SUBD_UNUSED;
 		}
 		/*  Allocate and Initialise DI Subdevice Structures */
-		s = dev->subdevices + 2;
+		s = &dev->subdevices[2];
 		if (devpriv->s_EeParameters.i_NbrDiChannel) {
 			s->type = COMEDI_SUBD_DI;
 			s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON;
@@ -1738,7 +1738,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->type = COMEDI_SUBD_UNUSED;
 		}
 		/*  Allocate and Initialise DO Subdevice Structures */
-		s = dev->subdevices + 3;
+		s = &dev->subdevices[3];
 		if (devpriv->s_EeParameters.i_NbrDoChannel) {
 			s->type = COMEDI_SUBD_DO;
 			s->subdev_flags =
@@ -1760,7 +1760,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 
 		/*  Allocate and Initialise Timer Subdevice Structures */
-		s = dev->subdevices + 4;
+		s = &dev->subdevices[4];
 		if (devpriv->s_EeParameters.i_Timer) {
 			s->type = COMEDI_SUBD_TIMER;
 			s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
@@ -1778,7 +1778,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 
 		/*  Allocate and Initialise TTL */
-		s = dev->subdevices + 5;
+		s = &dev->subdevices[5];
 		if (this_board->i_NbrTTLChannel) {
 			s->type = COMEDI_SUBD_TTLIO;
 			s->subdev_flags =
@@ -1797,7 +1797,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 
 		/* EEPROM */
-		s = dev->subdevices + 6;
+		s = &dev->subdevices[6];
 		if (this_board->i_PCIEeprom) {
 			s->type = COMEDI_SUBD_MEMORY;
 			s->subdev_flags = SDF_READABLE | SDF_INTERNAL;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index 595238f..9817285 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -67,8 +67,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 		return;
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
-	s = dev->subdevices + 0;
-
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_TIMER;
 	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
 	s->n_chan = 3;
@@ -81,8 +80,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_bits = i_APCI1710_InsnBitsTimer;
 
 	/*  Allocate and Initialise DIO Subdevice Structures */
-	s = dev->subdevices + 1;
-
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags =
 		SDF_WRITEABLE | SDF_READABLE | SDF_GROUND | SDF_COMMON;
@@ -96,8 +94,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_write = i_APCI1710_InsnWriteDigitalIOChlOnOff;
 
 	/*  Allocate and Initialise Chrono Subdevice Structures */
-	s = dev->subdevices + 2;
-
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_CHRONO;
 	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
 	s->n_chan = 4;
@@ -110,7 +107,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_bits = i_APCI1710_InsnBitsChronoDigitalIO;
 
 	/*  Allocate and Initialise PWM Subdevice Structures */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_PWM;
 	s->subdev_flags =
 		SDF_WRITEABLE | SDF_READABLE | SDF_GROUND | SDF_COMMON;
@@ -125,7 +122,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_bits = i_APCI1710_InsnBitsReadPWMInterrupt;
 
 	/*  Allocate and Initialise TTLIO Subdevice Structures */
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	s->type = COMEDI_SUBD_TTLIO;
 	s->subdev_flags =
 		SDF_WRITEABLE | SDF_READABLE | SDF_GROUND | SDF_COMMON;
@@ -139,7 +136,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_read = i_APCI1710_InsnReadTTLIOAllPortValue;
 
 	/*  Allocate and Initialise TOR Subdevice Structures */
-	s = dev->subdevices + 5;
+	s = &dev->subdevices[5];
 	s->type = COMEDI_SUBD_TOR;
 	s->subdev_flags =
 		SDF_WRITEABLE | SDF_READABLE | SDF_GROUND | SDF_COMMON;
@@ -154,7 +151,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_bits = i_APCI1710_InsnBitsGetTorCounterProgressStatusAndValue;
 
 	/*  Allocate and Initialise SSI Subdevice Structures */
-	s = dev->subdevices + 6;
+	s = &dev->subdevices[6];
 	s->type = COMEDI_SUBD_SSI;
 	s->subdev_flags =
 		SDF_WRITEABLE | SDF_READABLE | SDF_GROUND | SDF_COMMON;
@@ -167,7 +164,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_bits = i_APCI1710_InsnBitsSSIDigitalIO;
 
 	/*  Allocate and Initialise PULSEENCODER Subdevice Structures */
-	s = dev->subdevices + 7;
+	s = &dev->subdevices[7];
 	s->type = COMEDI_SUBD_PULSEENCODER;
 	s->subdev_flags =
 		SDF_WRITEABLE | SDF_READABLE | SDF_GROUND | SDF_COMMON;
@@ -181,7 +178,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	s->insn_read = i_APCI1710_InsnReadInterruptPulseEncoder;
 
 	/*  Allocate and Initialise INCREMENTALCOUNTER Subdevice Structures */
-	s = dev->subdevices + 8;
+	s = &dev->subdevices[8];
 	s->type = COMEDI_SUBD_INCREMENTALCOUNTER;
 	s->subdev_flags =
 		SDF_WRITEABLE | SDF_READABLE | SDF_GROUND | SDF_COMMON;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index ffe390c..d61fce0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1451,7 +1451,7 @@ void v_APCI3120_Interrupt(int irq, void *d)
 	unsigned short us_TmpValue;
 	unsigned char b_DummyRead;
 
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	ui_Check = 1;
 
 	int_daq = inw(dev->iobase + APCI3120_RD_STATUS) & 0xf000;	/*  get IRQ reasons */
@@ -1656,7 +1656,7 @@ void v_APCI3120_Interrupt(int irq, void *d)
 int i_APCI3120_InterruptHandleEos(struct comedi_device *dev)
 {
 	int n_chan, i;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int err = 1;
 
 	n_chan = devpriv->ui_AiNbrofChannels;
@@ -1698,7 +1698,7 @@ int i_APCI3120_InterruptHandleEos(struct comedi_device *dev)
 void v_APCI3120_InterruptDma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	unsigned int next_dma_buf, samplesinbuf;
 	unsigned long low_word, high_word, var;
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index f9545b0..4f64b28 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -3495,7 +3495,7 @@ void v_APCI3200_Interrupt(int irq, void *d)
 int i_APCI3200_InterruptHandleEos(struct comedi_device *dev)
 {
 	unsigned int ui_StatusRegister = 0;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 
 	/* BEGIN JK 18.10.2004: APCI-3200 Driver update 0.7.57 -> 0.7.68 */
 	/* comedi_async *async = s->async; */
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 99fbd94..3492ce1 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -205,7 +205,7 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog output subdevice */
 	s->type		= COMEDI_SUBD_AO;
 	s->subdev_flags	= SDF_WRITABLE;
@@ -215,7 +215,7 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 	s->insn_write	= pci6208_ao_winsn;
 	s->insn_read	= pci6208_ao_rinsn;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* digital input subdevice */
 	s->type		= COMEDI_SUBD_DI;
 	s->subdev_flags	= SDF_READABLE;
@@ -224,7 +224,7 @@ static int pci6208_attach_pci(struct comedi_device *dev,
 	s->range_table	= &range_digital;
 	s->insn_bits	= pci6208_di_insn_bits;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital output subdevice */
 	s->type		= COMEDI_SUBD_DO;
 	s->subdev_flags	= SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 67233be..96cfc9c 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -121,7 +121,7 @@ static int adl_pci7296_attach_pci(struct comedi_device *dev,
 		return ret;
 
 	for (i = 0; i < board->nsubdevs; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		ret = subdev_8255_init(dev, s, NULL, dev->iobase + (i * 4));
 		if (ret)
 			return ret;
@@ -142,7 +142,7 @@ static void adl_pci7296_detach(struct comedi_device *dev)
 
 	if (dev->subdevices) {
 		for (i = 0; i < board->nsubdevs; i++) {
-			s = dev->subdevices + i;
+			s = &dev->subdevices[i];
 			subdev_8255_cleanup(dev, s);
 		}
 	}
diff --git a/drivers/staging/comedi/drivers/adl_pci7x3x.c b/drivers/staging/comedi/drivers/adl_pci7x3x.c
index 48b3baa..599714e 100644
--- a/drivers/staging/comedi/drivers/adl_pci7x3x.c
+++ b/drivers/staging/comedi/drivers/adl_pci7x3x.c
@@ -211,7 +211,7 @@ static int adl_pci7x3x_attach_pci(struct comedi_device *dev,
 	if (board->di_nchan) {
 		nchan = min(board->di_nchan, 32);
 
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		/* Isolated digital inputs 0 to 15/31 */
 		s->type		= COMEDI_SUBD_DI;
 		s->subdev_flags	= SDF_READABLE;
@@ -226,7 +226,7 @@ static int adl_pci7x3x_attach_pci(struct comedi_device *dev,
 
 		nchan = board->di_nchan - nchan;
 		if (nchan) {
-			s = dev->subdevices + subdev;
+			s = &dev->subdevices[subdev];
 			/* Isolated digital inputs 32 to 63 */
 			s->type		= COMEDI_SUBD_DI;
 			s->subdev_flags	= SDF_READABLE;
@@ -244,7 +244,7 @@ static int adl_pci7x3x_attach_pci(struct comedi_device *dev,
 	if (board->do_nchan) {
 		nchan = min(board->do_nchan, 32);
 
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		/* Isolated digital outputs 0 to 15/31 */
 		s->type		= COMEDI_SUBD_DO;
 		s->subdev_flags	= SDF_WRITABLE;
@@ -259,7 +259,7 @@ static int adl_pci7x3x_attach_pci(struct comedi_device *dev,
 
 		nchan = board->do_nchan - nchan;
 		if (nchan) {
-			s = dev->subdevices + subdev;
+			s = &dev->subdevices[subdev];
 			/* Isolated digital outputs 32 to 63 */
 			s->type		= COMEDI_SUBD_DO;
 			s->subdev_flags	= SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index ac406cf..05e06e7 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -231,7 +231,7 @@ static int adl_pci8164_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_PROC;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 4;
@@ -241,7 +241,7 @@ static int adl_pci8164_attach_pci(struct comedi_device *dev,
 	s->insn_read = adl_pci8164_insn_read_msts;
 	s->insn_write = adl_pci8164_insn_write_cmd;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_PROC;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 4;
@@ -251,7 +251,7 @@ static int adl_pci8164_attach_pci(struct comedi_device *dev,
 	s->insn_read = adl_pci8164_insn_read_ssts;
 	s->insn_write = adl_pci8164_insn_write_otp;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_PROC;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 4;
@@ -261,7 +261,7 @@ static int adl_pci8164_attach_pci(struct comedi_device *dev,
 	s->insn_read = adl_pci8164_insn_read_buf0;
 	s->insn_write = adl_pci8164_insn_write_buf0;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_PROC;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 4;
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index a31dae6..c50c4b0 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1322,7 +1322,7 @@ static int pci9111_attach(struct comedi_device *dev,
 	if (error)
 		return error;
 
-	subdevice = dev->subdevices + 0;
+	subdevice = &dev->subdevices[0];
 	dev->read_subdev = subdevice;
 
 	subdevice->type = COMEDI_SUBD_AI;
@@ -1342,7 +1342,7 @@ static int pci9111_attach(struct comedi_device *dev,
 	subdevice->do_cmd = pci9111_ai_do_cmd;
 	subdevice->munge = pci9111_ai_munge;
 
-	subdevice = dev->subdevices + 1;
+	subdevice = &dev->subdevices[1];
 	subdevice->type = COMEDI_SUBD_AO;
 	subdevice->subdev_flags = SDF_WRITABLE | SDF_COMMON;
 	subdevice->n_chan = board->ao_channel_nbr;
@@ -1352,7 +1352,7 @@ static int pci9111_attach(struct comedi_device *dev,
 	subdevice->insn_write = pci9111_ao_insn_write;
 	subdevice->insn_read = pci9111_ao_insn_read;
 
-	subdevice = dev->subdevices + 2;
+	subdevice = &dev->subdevices[2];
 	subdevice->type = COMEDI_SUBD_DI;
 	subdevice->subdev_flags = SDF_READABLE;
 	subdevice->n_chan = PCI9111_DI_CHANNEL_NBR;
@@ -1360,7 +1360,7 @@ static int pci9111_attach(struct comedi_device *dev,
 	subdevice->range_table = &range_digital;
 	subdevice->insn_bits = pci9111_di_insn_bits;
 
-	subdevice = dev->subdevices + 3;
+	subdevice = &dev->subdevices[3];
 	subdevice->type = COMEDI_SUBD_DO;
 	subdevice->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	subdevice->n_chan = PCI9111_DO_CHANNEL_NBR;
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index a1f74c2..fdb0f5d 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -837,7 +837,7 @@ static irqreturn_t interrupt_pci9118(int irq, void *d)
 				}
 			}
 
-		(devpriv->int_ai_func) (dev, dev->subdevices + 0, int_adstat,
+		(devpriv->int_ai_func) (dev, &dev->subdevices[0], int_adstat,
 					int_amcc, int_daq);
 
 	}
@@ -2273,7 +2273,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_COMMON | SDF_GROUND | SDF_DIFF;
@@ -2294,7 +2294,7 @@ static int pci9118_attach(struct comedi_device *dev,
 		s->munge = pci9118_ai_munge;
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 	s->n_chan = this_board->n_aochan;
@@ -2304,7 +2304,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	s->insn_write = pci9118_insn_write_ao;
 	s->insn_read = pci9118_insn_read_ao;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON;
 	s->n_chan = 4;
@@ -2314,7 +2314,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	s->io_bits = 0;		/* all bits input */
 	s->insn_bits = pci9118_insn_bits_di;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 	s->n_chan = 4;
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 6df51c8..0340c9c 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -272,7 +272,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
 	if (differential) {
@@ -294,7 +294,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				   the board can handle */
 	s->insn_read = adq12b_ai_rinsn;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* digital input subdevice */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -303,7 +303,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_digital;
 	s->insn_bits = adq12b_di_insn_bits;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital output subdevice */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 66bd3858..699f267 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -744,7 +744,7 @@ static void interrupt_pci1710_every_sample(void *d)
 {
 	struct comedi_device *dev = d;
 	struct pci1710_private *devpriv = dev->private;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int m;
 #ifdef PCI171x_PARANOIDCHECK
 	const struct boardtype *this_board = comedi_board(dev);
@@ -873,7 +873,7 @@ static void interrupt_pci1710_half_fifo(void *d)
 	struct comedi_device *dev = d;
 	const struct boardtype *this_board = comedi_board(dev);
 	struct pci1710_private *devpriv = dev->private;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int m, samplesinbuf;
 
 	m = inw(dev->iobase + PCI171x_STATUS);
@@ -1395,7 +1395,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	subdev = 0;
 
 	if (this_board->n_aichan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		dev->read_subdev = s;
 		s->type = COMEDI_SUBD_AI;
 		s->subdev_flags = SDF_READABLE | SDF_COMMON | SDF_GROUND;
@@ -1417,7 +1417,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_aochan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 		s->n_chan = this_board->n_aochan;
@@ -1437,7 +1437,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_dichan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON;
 		s->n_chan = this_board->n_dichan;
@@ -1450,7 +1450,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_dochan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 		s->n_chan = this_board->n_dochan;
@@ -1465,7 +1465,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_counter) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_COUNTER;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 		s->n_chan = this_board->n_counter;
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index cbce06a..df4efc0 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -258,7 +258,7 @@ static int pci1723_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->write_subdev = s;
 	s->type		= COMEDI_SUBD_AO;
 	s->subdev_flags	= SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
@@ -269,7 +269,7 @@ static int pci1723_attach_pci(struct comedi_device *dev,
 	s->insn_write	= pci1723_ao_write_winsn;
 	s->insn_read	= pci1723_insn_read_ao;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type		= COMEDI_SUBD_DIO;
 	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
 	s->n_chan	= 16;
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index a4c1b13..fa5a6a1 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -957,7 +957,7 @@ static int pci1760_attach(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 	int subdev = 0;
 
-	s = dev->subdevices + subdev;
+	s = &dev->subdevices[subdev];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON;
 	s->n_chan = 8;
@@ -967,7 +967,7 @@ static int pci1760_attach(struct comedi_device *dev)
 	s->insn_bits = pci1760_insn_bits_di;
 	subdev++;
 
-	s = dev->subdevices + subdev;
+	s = &dev->subdevices[subdev];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 	s->n_chan = 8;
@@ -978,7 +978,7 @@ static int pci1760_attach(struct comedi_device *dev)
 	s->insn_bits = pci1760_insn_bits_do;
 	subdev++;
 
-	s = dev->subdevices + subdev;
+	s = &dev->subdevices[subdev];
 	s->type = COMEDI_SUBD_TIMER;
 	s->subdev_flags = SDF_WRITABLE | SDF_LSAMPL;
 	s->n_chan = 2;
@@ -987,7 +987,7 @@ static int pci1760_attach(struct comedi_device *dev)
 /*       s->insn_config=pci1760_insn_pwm_cfg; */
 	subdev++;
 
-	s = dev->subdevices + subdev;
+	s = &dev->subdevices[subdev];
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 8;
@@ -1128,21 +1128,21 @@ static int pci_dio_attach_pci(struct comedi_device *dev,
 	subdev = 0;
 	for (i = 0; i < MAX_DI_SUBDEVS; i++)
 		if (this_board->sdi[i].chans) {
-			s = dev->subdevices + subdev;
+			s = &dev->subdevices[subdev];
 			pci_dio_add_di(dev, s, &this_board->sdi[i], subdev);
 			subdev++;
 		}
 
 	for (i = 0; i < MAX_DO_SUBDEVS; i++)
 		if (this_board->sdo[i].chans) {
-			s = dev->subdevices + subdev;
+			s = &dev->subdevices[subdev];
 			pci_dio_add_do(dev, s, &this_board->sdo[i], subdev);
 			subdev++;
 		}
 
 	for (i = 0; i < MAX_DIO_SUBDEVG; i++)
 		for (j = 0; j < this_board->sdio[i].regs; j++) {
-			s = dev->subdevices + subdev;
+			s = &dev->subdevices[subdev];
 			subdev_8255_init(dev, s, NULL,
 					 dev->iobase +
 					 this_board->sdio[i].addr +
@@ -1151,7 +1151,7 @@ static int pci_dio_attach_pci(struct comedi_device *dev,
 		}
 
 	if (this_board->boardid.chans) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_DI;
 		pci_dio_add_di(dev, s, &this_board->boardid, subdev);
 		subdev++;
@@ -1159,7 +1159,7 @@ static int pci_dio_attach_pci(struct comedi_device *dev,
 
 	for (i = 0; i < MAX_8254_SUBDEVS; i++)
 		if (this_board->s8254[i].chans) {
-			s = dev->subdevices + subdev;
+			s = &dev->subdevices[subdev];
 			pci_dio_add_8254(dev, s, &this_board->s8254[i], subdev);
 			subdev++;
 		}
@@ -1187,7 +1187,7 @@ static void pci_dio_detach(struct comedi_device *dev)
 	}
 	if (dev->subdevices) {
 		for (i = 0; i < dev->n_subdevices; i++) {
-			s = dev->subdevices + i;
+			s = &dev->subdevices[i];
 			if (s->type == COMEDI_SUBD_DIO)
 				subdev_8255_cleanup(dev, s);
 			s->private = NULL;
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index c07de3e..8acf60d 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -221,7 +221,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	if (board->ai_nchan) {
 		/* Analog input subdevice */
 		s->type		= COMEDI_SUBD_AI;
@@ -234,7 +234,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	if (board->ao_nchan) {
 		/* Analog output subdevice */
 		s->type		= COMEDI_SUBD_AO;
@@ -248,14 +248,14 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* 8255 Digital i/o subdevice */
 	iobase = dev->iobase + AIO12_8_8255_BASE_REG;
 	ret = subdev_8255_init(dev, s, NULL, iobase);
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* 8254 counter/timer subdevice */
 	s->type		= COMEDI_SUBD_UNUSED;
 
@@ -268,7 +268,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 static void aio_aio12_8_detach(struct comedi_device *dev)
 {
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
+		subdev_8255_cleanup(dev, &dev->subdevices[2]);
 	if (dev->iobase)
 		release_region(dev->iobase, 24);
 }
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index ba1e3bb..b2cb8b0 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -112,7 +112,7 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = 16;
@@ -120,7 +120,7 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->insn_bits = aio_iiro_16_dio_insn_bits_write;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 16;
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 9c8fbf1..e2e3a54 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -978,15 +978,15 @@ static irqreturn_t dio200_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct dio200_private *devpriv = dev->private;
+	struct comedi_subdevice *s;
 	int handled;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
 	if (devpriv->intr_sd >= 0) {
-		handled = dio200_handle_read_intr(dev,
-						  dev->subdevices +
-						  devpriv->intr_sd);
+		s = &dev->subdevices[devpriv->intr_sd];
+		handled = dio200_handle_read_intr(dev, s);
 	} else {
 		handled = 0;
 	}
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index aabba98..c5c18a5 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -395,7 +395,7 @@ static int pc236_intr_cancel(struct comedi_device *dev,
 static irqreturn_t pc236_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 1;
+	struct comedi_subdevice *s = &dev->subdevices[1];
 	int handled;
 
 	handled = pc236_intr_check(dev);
@@ -449,14 +449,14 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* digital i/o subdevice (8255) */
 	ret = subdev_8255_init(dev, s, NULL, iobase);
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_UNUSED;
 	pc236_intr_disable(dev);
@@ -578,7 +578,7 @@ static void pc236_detach(struct comedi_device *dev)
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 0);
+		subdev_8255_cleanup(dev, &dev->subdevices[0]);
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 40ec1ff..0fdcb65 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -212,7 +212,7 @@ static int pc263_common_attach(struct comedi_device *dev, unsigned long iobase)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* digital output subdevice */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 4e17f13..6c54164 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1375,7 +1375,7 @@ static int pci224_attach_common(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* Analog output subdevice. */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_CMD_WRITE;
@@ -1516,7 +1516,7 @@ static void pci224_detach(struct comedi_device *dev)
 	if (dev->subdevices) {
 		struct comedi_subdevice *s;
 
-		s = dev->subdevices + 0;
+		s = &dev->subdevices[0];
 		/* AO subdevice */
 		kfree(s->range_table_list);
 	}
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 1b67d0c..6675aab 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2838,7 +2838,7 @@ static int pci230_attach_common(struct comedi_device *dev,
 	if (rc)
 		return rc;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_DIFF | SDF_GROUND;
@@ -2855,7 +2855,8 @@ static int pci230_attach_common(struct comedi_device *dev,
 		s->do_cmdtest = &pci230_ai_cmdtest;
 		s->cancel = pci230_ai_cancel;
 	}
-	s = dev->subdevices + 1;
+
+	s = &dev->subdevices[1];
 	/* analog output subdevice */
 	if (thisboard->ao_chans > 0) {
 		s->type = COMEDI_SUBD_AO;
@@ -2878,7 +2879,8 @@ static int pci230_attach_common(struct comedi_device *dev,
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
-	s = dev->subdevices + 2;
+
+	s = &dev->subdevices[2];
 	/* digital i/o subdevice */
 	if (thisboard->have_dio) {
 		rc = subdev_8255_init(dev, s, NULL,
@@ -2934,7 +2936,7 @@ static void pci230_detach(struct comedi_device *dev)
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (dev->subdevices && thisboard->have_dio)
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
+		subdev_8255_cleanup(dev, &dev->subdevices[2]);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (pcidev) {
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index 41ed857..070037c 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -447,7 +447,7 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	else if (irq == 0)
 		printk(KERN_DEBUG "comedi%d: no irq\n", dev->minor);
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* pwm output subdevice */
 	s->type = COMEDI_SUBD_AO;	/*  Not sure what to put here */
 	s->subdev_flags = SDF_WRITEABLE;
@@ -458,7 +458,7 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	s->maxdata = 500;
 	s->range_table = &range_bipolar10;	/*  A suitable lie */
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* encoder (counter) subdevice */
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_LSAMPL;
@@ -468,7 +468,7 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	s->maxdata = 0xffffff;
 	s->range_table = &range_unknown;
 
-	/*	s = dev->subdevices + 2; */
+	/*	s = &dev->subdevices[2]; */
 	/* pwm output subdevice */
 	/*	s->type = COMEDI_SUBD_COUNTER;  // Not sure what to put here */
 	/*	s->subdev_flags = SDF_WRITEABLE; */
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 58d4529..a3d53ba 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -478,7 +478,7 @@ static int das16cs_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* analog input subdevice */
 	s->type		= COMEDI_SUBD_AI;
@@ -491,7 +491,7 @@ static int das16cs_attach(struct comedi_device *dev,
 	s->do_cmd	= das16cs_ai_cmd;
 	s->do_cmdtest	= das16cs_ai_cmdtest;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* analog output subdevice */
 	if (thisboard->n_ao_chans) {
 		s->type		= COMEDI_SUBD_AO;
@@ -505,7 +505,7 @@ static int das16cs_attach(struct comedi_device *dev,
 		s->type		= COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital i/o subdevice */
 	s->type		= COMEDI_SUBD_DIO;
 	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 4b6fb88..4dd87c2 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1560,7 +1560,7 @@ static int cb_pcidas_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog input subdevice */
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
@@ -1577,7 +1577,7 @@ static int cb_pcidas_attach_pci(struct comedi_device *dev,
 	s->cancel = cb_pcidas_cancel;
 
 	/* analog output subdevice */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	if (thisboard->ao_nchan) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
@@ -1604,14 +1604,14 @@ static int cb_pcidas_attach_pci(struct comedi_device *dev,
 	}
 
 	/* 8255 */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	ret = subdev_8255_init(dev, s, NULL,
 			       devpriv->pacer_counter_dio + DIO_8255);
 	if (ret)
 		return ret;
 
 	/*  serial EEPROM, */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_MEMORY;
 	s->subdev_flags = SDF_READABLE | SDF_INTERNAL;
 	s->n_chan = 256;
@@ -1619,7 +1619,7 @@ static int cb_pcidas_attach_pci(struct comedi_device *dev,
 	s->insn_read = eeprom_read_insn;
 
 	/*  8800 caldac */
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	s->type = COMEDI_SUBD_CALIB;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
 	s->n_chan = NUM_CHANNELS_8800;
@@ -1630,7 +1630,7 @@ static int cb_pcidas_attach_pci(struct comedi_device *dev,
 		caldac_8800_write(dev, i, s->maxdata / 2);
 
 	/*  trim potentiometer */
-	s = dev->subdevices + 5;
+	s = &dev->subdevices[5];
 	s->type = COMEDI_SUBD_CALIB;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
 	if (thisboard->trimpot == AD7376) {
@@ -1646,7 +1646,7 @@ static int cb_pcidas_attach_pci(struct comedi_device *dev,
 		cb_pcidas_trimpot_write(dev, i, s->maxdata / 2);
 
 	/*  dac08 caldac */
-	s = dev->subdevices + 6;
+	s = &dev->subdevices[6];
 	if (thisboard->has_dac08) {
 		s->type = COMEDI_SUBD_CALIB;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
@@ -1688,7 +1688,7 @@ static void cb_pcidas_detach(struct comedi_device *dev)
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
+		subdev_8255_cleanup(dev, &dev->subdevices[2]);
 	if (pcidev) {
 		if (devpriv->s5933_config)
 			comedi_pci_disable(pcidev);
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 65cbaab..7168883 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1348,7 +1348,7 @@ static int setup_subdevices(struct comedi_device *dev)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog input subdevice */
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
@@ -1379,7 +1379,7 @@ static int setup_subdevices(struct comedi_device *dev)
 	}
 
 	/* analog output subdevice */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	if (board(dev)->ao_nchan) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags =
@@ -1401,7 +1401,7 @@ static int setup_subdevices(struct comedi_device *dev)
 	}
 
 	/*  digital input */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	if (board(dev)->layout == LAYOUT_64XX) {
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE;
@@ -1414,7 +1414,7 @@ static int setup_subdevices(struct comedi_device *dev)
 
 	/*  digital output */
 	if (board(dev)->layout == LAYOUT_64XX) {
-		s = dev->subdevices + 3;
+		s = &dev->subdevices[3];
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 		s->n_chan = 4;
@@ -1425,7 +1425,7 @@ static int setup_subdevices(struct comedi_device *dev)
 		s->type = COMEDI_SUBD_UNUSED;
 
 	/* 8255 */
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	if (board(dev)->has_8255) {
 		if (board(dev)->layout == LAYOUT_4020) {
 			dio_8255_iobase =
@@ -1442,7 +1442,7 @@ static int setup_subdevices(struct comedi_device *dev)
 		s->type = COMEDI_SUBD_UNUSED;
 
 	/*  8 channel dio for 60xx */
-	s = dev->subdevices + 5;
+	s = &dev->subdevices[5];
 	if (board(dev)->layout == LAYOUT_60XX) {
 		s->type = COMEDI_SUBD_DIO;
 		s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
@@ -1455,7 +1455,7 @@ static int setup_subdevices(struct comedi_device *dev)
 		s->type = COMEDI_SUBD_UNUSED;
 
 	/*  caldac */
-	s = dev->subdevices + 6;
+	s = &dev->subdevices[6];
 	s->type = COMEDI_SUBD_CALIB;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
 	s->n_chan = 8;
@@ -1469,7 +1469,7 @@ static int setup_subdevices(struct comedi_device *dev)
 		caldac_write(dev, i, s->maxdata / 2);
 
 	/*  2 channel ad8402 potentiometer */
-	s = dev->subdevices + 7;
+	s = &dev->subdevices[7];
 	if (board(dev)->layout == LAYOUT_64XX) {
 		s->type = COMEDI_SUBD_CALIB;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
@@ -1483,7 +1483,7 @@ static int setup_subdevices(struct comedi_device *dev)
 		s->type = COMEDI_SUBD_UNUSED;
 
 	/* serial EEPROM, if present */
-	s = dev->subdevices + 8;
+	s = &dev->subdevices[8];
 	if (readl(priv(dev)->plx9080_iobase + PLX_CONTROL_REG) & CTL_EECHK) {
 		s->type = COMEDI_SUBD_MEMORY;
 		s->subdev_flags = SDF_READABLE | SDF_INTERNAL;
@@ -1494,7 +1494,7 @@ static int setup_subdevices(struct comedi_device *dev)
 		s->type = COMEDI_SUBD_UNUSED;
 
 	/*  user counter subd XXX */
-	s = dev->subdevices + 9;
+	s = &dev->subdevices[9];
 	s->type = COMEDI_SUBD_UNUSED;
 
 	return 0;
@@ -1847,7 +1847,7 @@ static void detach(struct comedi_device *dev)
 		}
 	}
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 4);
+		subdev_8255_cleanup(dev, &dev->subdevices[4]);
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index c5944e3..ad9f3a3 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -716,7 +716,7 @@ static int cb_pcidda_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -730,9 +730,9 @@ static int cb_pcidda_attach_pci(struct comedi_device *dev,
 	/* s->do_cmdtest = cb_pcidda_ai_cmdtest; */
 
 	/*  two 8255 digital io subdevices */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	subdev_8255_init(dev, s, NULL, devpriv->digitalio);
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
 
 	dev_dbg(dev->class_dev, "eeprom:\n");
@@ -756,8 +756,8 @@ static void cb_pcidda_detach(struct comedi_device *dev)
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (dev->subdevices) {
-		subdev_8255_cleanup(dev, dev->subdevices + 1);
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
+		subdev_8255_cleanup(dev, &dev->subdevices[1]);
+		subdev_8255_cleanup(dev, &dev->subdevices[2]);
 	}
 	if (pcidev) {
 		if (dev->iobase)
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 52c6379..9f406ef 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -119,7 +119,7 @@ static int pcidio_attach_pci(struct comedi_device *dev,
 		return ret;
 
 	for (i = 0; i < board->n_8255; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		ret = subdev_8255_init(dev, s, NULL, dev->iobase + i * 4);
 		if (ret)
 			return ret;
@@ -140,7 +140,7 @@ static void pcidio_detach(struct comedi_device *dev)
 
 	if (dev->subdevices) {
 		for (i = 0; i < board->n_8255; i++) {
-			s = dev->subdevices + i;
+			s = &dev->subdevices[i];
 			subdev_8255_cleanup(dev, s);
 		}
 	}
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index fa3fd88..9515b69 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -318,7 +318,7 @@ static int cb_pcimdas_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* dev->read_subdev=s; */
 	/*  analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
@@ -330,7 +330,7 @@ static int cb_pcimdas_attach_pci(struct comedi_device *dev,
 	/*  the board can handle */
 	s->insn_read = cb_pcimdas_ai_rinsn;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/*  analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -341,7 +341,7 @@ static int cb_pcimdas_attach_pci(struct comedi_device *dev,
 	s->insn_write = &cb_pcimdas_ao_winsn;
 	s->insn_read = &cb_pcimdas_ao_rinsn;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital i/o subdevice */
 	if (thisboard->has_dio)
 		subdev_8255_init(dev, s, NULL, iobase_8255);
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index ea96514..ba9f059 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -176,7 +176,7 @@ static int cb_pcimdda_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog output subdevice */
 	s->type		= COMEDI_SUBD_AO;
 	s->subdev_flags	= SDF_WRITABLE | SDF_READABLE;
@@ -186,7 +186,7 @@ static int cb_pcimdda_attach_pci(struct comedi_device *dev,
 	s->insn_write	= cb_pcimdda_ao_winsn;
 	s->insn_read	= cb_pcimdda_ao_rinsn;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* digital i/o subdevice */
 	ret = subdev_8255_init(dev, s, NULL,
 			dev->iobase + PCIMDDA_8255_BASE_REG);
@@ -203,7 +203,7 @@ static void cb_pcimdda_detach(struct comedi_device *dev)
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 1);
+		subdev_8255_cleanup(dev, &dev->subdevices[1]);
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 6b516ed..5c768bc 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -321,7 +321,7 @@ static int bonding_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = devpriv->nchans;
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 2dce9df..c9e40a9 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -277,7 +277,7 @@ static irqreturn_t parport_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct parport_private *devpriv = dev->private;
-	struct comedi_subdevice *s = dev->subdevices + 3;
+	struct comedi_subdevice *s = &dev->subdevices[3];
 
 	if (!devpriv->enable_irq)
 		return IRQ_NONE;
@@ -327,7 +327,7 @@ static int parport_attach(struct comedi_device *dev,
 		return ret;
 	devpriv = dev->private;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 8;
@@ -336,7 +336,7 @@ static int parport_attach(struct comedi_device *dev,
 	s->insn_bits = parport_insn_a;
 	s->insn_config = parport_insn_config_a;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 5;
@@ -344,7 +344,7 @@ static int parport_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->insn_bits = parport_insn_b;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = 4;
@@ -352,7 +352,7 @@ static int parport_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->insn_bits = parport_insn_c;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	if (irq) {
 		dev->read_subdev = s;
 		s->type = COMEDI_SUBD_DI;
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 8ea9202..b0f0ec5 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -453,7 +453,7 @@ static int waveform_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
@@ -467,7 +467,7 @@ static int waveform_attach(struct comedi_device *dev,
 	s->do_cmdtest = waveform_ai_cmdtest;
 	s->cancel = waveform_ai_cancel;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	dev->write_subdev = s;
 	/* analog output subdevice (loopback) */
 	s->type = COMEDI_SUBD_AO;
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 944cfee..c380a32 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -140,7 +140,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = pci_resource_start(pcidev, 0);
 	printk(" base addr %lx ", dev->iobase);
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -149,7 +149,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_digital;
 	s->insn_bits = contec_di_insn_bits;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = 16;
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index cad559a..39a2b1e 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -804,7 +804,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 
 	dev->board_name = this_board->name;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* ai subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
@@ -813,7 +813,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	s->insn_read = daqboard2000_ai_insn_read;
 	s->range_table = &range_daqboard2000_ai;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* ao subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -823,7 +823,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	s->insn_write = daqboard2000_ao_insn_write;
 	s->range_table = &range_daqboard2000_ao;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	result = subdev_8255_init(dev, s, daqboard2000_8255_cb,
 				  (unsigned long)(devpriv->daq + 0x40));
 
@@ -836,7 +836,7 @@ static void daqboard2000_detach(struct comedi_device *dev)
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
+		subdev_8255_cleanup(dev, &dev->subdevices[2]);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 874e02e..687af1a 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -765,7 +765,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* ai */
 	if (thisboard->ai) {
 		s->type = COMEDI_SUBD_AI;
@@ -784,7 +784,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* ao */
 	if (thisboard->ao) {
 		s->type = COMEDI_SUBD_AO;
@@ -798,7 +798,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* di */
 	if (thisboard->di) {
 		s->type = COMEDI_SUBD_DI;
@@ -811,7 +811,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* do */
 	if (thisboard->do_) {
 		s->type = COMEDI_SUBD_DO;
@@ -824,7 +824,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	/* 8255 */
 	if (thisboard->i8255_offset != 0) {
 		subdev_8255_init(dev, s, NULL, (unsigned long)(dev->iobase +
@@ -834,7 +834,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 5;
+	s = &dev->subdevices[5];
 	/* 8254 */
 	if (thisboard->i8254_offset != 0) {
 		s->type = COMEDI_SUBD_COUNTER;
@@ -1012,7 +1012,7 @@ das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 void das08_common_detach(struct comedi_device *dev)
 {
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 4);
+		subdev_8255_cleanup(dev, &dev->subdevices[4]);
 }
 EXPORT_SYMBOL_GPL(das08_common_detach);
 
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 895cc77..2a38915 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1268,7 +1268,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* ai */
 	if (board->ai) {
@@ -1300,7 +1300,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* ao */
 	if (board->ao) {
 		s->type = COMEDI_SUBD_AO;
@@ -1318,7 +1318,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* di */
 	if (board->di) {
 		s->type = COMEDI_SUBD_DI;
@@ -1331,7 +1331,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* do */
 	if (board->do_) {
 		s->type = COMEDI_SUBD_DO;
@@ -1346,7 +1346,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	/* 8255 */
 	if (board->i8255_offset != 0) {
 		subdev_8255_init(dev, s, NULL, (dev->iobase +
@@ -1376,7 +1376,7 @@ static void das16_detach(struct comedi_device *dev)
 
 	das16_reset(dev);
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 4);
+		subdev_8255_cleanup(dev, &dev->subdevices[4]);
 	if (devpriv) {
 		int i;
 		for (i = 0; i < 2; i++) {
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index 2009263..7f0668f 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -650,7 +650,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* ai */
 	s->type = COMEDI_SUBD_AI;
@@ -666,7 +666,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	s->cancel = das16m1_cancel;
 	s->poll = das16m1_poll;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* di */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -675,7 +675,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->insn_bits = das16m1_di_rbits;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* do */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
@@ -684,7 +684,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->insn_bits = das16m1_do_wbits;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* 8255 */
 	subdev_8255_init(dev, s, NULL, dev->iobase + DAS16M1_82C55);
 
@@ -707,7 +707,7 @@ static int das16m1_attach(struct comedi_device *dev,
 static void das16m1_detach(struct comedi_device *dev)
 {
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 3);
+		subdev_8255_cleanup(dev, &dev->subdevices[3]);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase) {
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 25e7e56..421acb6 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -656,7 +656,7 @@ static int das1800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 /* the guts of the interrupt handler, that is shared with das1800_ai_poll */
 static void das1800_ai_handler(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog input subdevice */
+	struct comedi_subdevice *s = &dev->subdevices[0]; /* ai subdevice */
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int status = inb(dev->iobase + DAS1800_STATUS);
@@ -1653,7 +1653,7 @@ static int das1800_attach(struct comedi_device *dev,
 		return retval;
 
 	/* analog input subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_DIFF | SDF_GROUND | SDF_CMD_READ;
@@ -1670,7 +1670,7 @@ static int das1800_attach(struct comedi_device *dev,
 	s->cancel = das1800_cancel;
 
 	/* analog out */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	if (thisboard->ao_ability == 1) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE;
@@ -1683,7 +1683,7 @@ static int das1800_attach(struct comedi_device *dev,
 	}
 
 	/* di */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 4;
@@ -1692,7 +1692,7 @@ static int das1800_attach(struct comedi_device *dev,
 	s->insn_bits = das1800_di_rbits;
 
 	/* do */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 	s->n_chan = thisboard->do_n_chan;
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index e3afcfa..e134c46 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -152,7 +152,7 @@ static void das6402_setcounter(struct comedi_device *dev)
 static irqreturn_t intr_handler(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 
 	if (!dev->attached || devpriv->das6402_ignoreirq) {
 		dev_warn(dev->class_dev, "BUG: spurious interrupt\n");
@@ -312,7 +312,7 @@ static int das6402_attach(struct comedi_device *dev,
 		return ret;
 
 	/* ai subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = 8;
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index a0959a5..d05368e 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -435,7 +435,7 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 	if (fifo_overflow) {
 		spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 		comedi_error(dev, "DAS800 FIFO overflow");
-		das800_cancel(dev, dev->subdevices + 0);
+		das800_cancel(dev, &dev->subdevices[0]);
 		async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
 		comedi_event(dev, s);
 		async->events = 0;
@@ -517,7 +517,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 
 	/* analog input subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
@@ -531,7 +531,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->cancel = das800_cancel;
 
 	/* di */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 3;
@@ -540,7 +540,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_bits = das800_di_rbits;
 
 	/* do */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 	s->n_chan = 4;
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 7107f59..0703ca5 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -825,7 +825,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
@@ -841,7 +841,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 	s->do_cmdtest = dmm32at_ai_cmdtest;
 	s->cancel = dmm32at_ai_cancel;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -851,7 +851,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 	s->insn_write = dmm32at_ao_winsn;
 	s->insn_read = dmm32at_ao_rinsn;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital i/o subdevice */
 
 	/* get access to the DIO regs */
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index d332269..4597d17 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -532,7 +532,7 @@ static int dt2801_dio_insn_bits(struct comedi_device *dev,
 {
 	int which = 0;
 
-	if (s == dev->subdevices + 4)
+	if (s == &dev->subdevices[4])
 		which = 1;
 
 	if (data[0]) {
@@ -555,7 +555,7 @@ static int dt2801_dio_insn_config(struct comedi_device *dev,
 {
 	int which = 0;
 
-	if (s == dev->subdevices + 4)
+	if (s == &dev->subdevices[4])
 		which = 1;
 
 	/* configure */
@@ -636,7 +636,7 @@ havetype:
 
 	dev->board_name = boardtype.name;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* ai subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 290b933..d3a8c1a 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -510,7 +510,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		break;
 	}
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* initialize the ADC subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
@@ -530,7 +530,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		break;
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* ao subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -542,7 +542,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->range_type_list[0] = dac_range_types[devpriv->dac_range[0]];
 	devpriv->range_type_list[1] = dac_range_types[devpriv->dac_range[1]];
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* di subdevice */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -551,7 +551,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->maxdata = 1;
 	s->range_table = &range_digital;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* do subdevice */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index 2e39ebe..ce5d837 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -247,7 +247,7 @@ static irqreturn_t dt2814_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 
 	hi = inb(dev->iobase + DT2814_DATA);
 	lo = inb(dev->iobase + DT2814_DATA);
@@ -346,7 +346,7 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_CMD_READ;
diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index 45b20be..b9692ef 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -185,7 +185,7 @@ static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct dt2815_private)) < 0)
 		return -ENOMEM;
 
-	s = dev->subdevices;
+	s = &dev->subdevices[0];
 	/* ao subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index beba044..502e42e 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -141,7 +141,7 @@ static int dt2817_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 
 	s->n_chan = 32;
 	s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 1f0b40e..e917502 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -312,7 +312,7 @@ static void dt282x_ao_dma_interrupt(struct comedi_device *dev)
 	void *ptr;
 	int size;
 	int i;
-	struct comedi_subdevice *s = dev->subdevices + 1;
+	struct comedi_subdevice *s = &dev->subdevices[1];
 
 	outw(devpriv->supcsr | DT2821_CLRDMADNE, dev->iobase + DT2821_SUPCSR);
 
@@ -345,7 +345,7 @@ static void dt282x_ai_dma_interrupt(struct comedi_device *dev)
 	int size;
 	int i;
 	int ret;
-	struct comedi_subdevice *s = dev->subdevices;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 
 	outw(devpriv->supcsr | DT2821_CLRDMADNE, dev->iobase + DT2821_SUPCSR);
 
@@ -457,8 +457,8 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-	s = dev->subdevices + 0;
-	s_ao = dev->subdevices + 1;
+	s = &dev->subdevices[0];
+	s_ao = &dev->subdevices[1];
 	adcsr = inw(dev->iobase + DT2821_ADCSR);
 	dacsr = inw(dev->iobase + DT2821_DACSR);
 	supcsr = inw(dev->iobase + DT2821_SUPCSR);
@@ -1275,8 +1275,7 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
-
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* ai subdevice */
 	s->type = COMEDI_SUBD_AI;
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 3476cda..15ca897 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -330,7 +330,7 @@ static irqreturn_t dt3k_interrupt(int irq, void *d)
 	if (!dev->attached)
 		return IRQ_NONE;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	status = readw(devpriv->io_addr + DPR_Intr_Flag);
 #ifdef DEBUG
 	debug_intr_flags(status);
@@ -842,9 +842,8 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
-
 	/* ai subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 40821c7..bc6f409 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -1041,7 +1041,7 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 
 	/* digital input subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 0;
@@ -1050,7 +1050,7 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_read = &dt9812_di_rinsn;
 
 	/* digital output subdevice */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 0;
@@ -1059,7 +1059,7 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = &dt9812_do_winsn;
 
 	/* analog input subdevice */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = 0;
@@ -1068,7 +1068,7 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_read = &dt9812_ai_rinsn;
 
 	/* analog output subdevice */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 0;
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 9d55aa9..6f612be 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -208,7 +208,7 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 		return ret;
 
 	/* analog input */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
 	s->n_chan = 16;
@@ -218,7 +218,7 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s->insn_read = dyna_pci10xx_insn_read_ai;
 
 	/* analog output */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = 16;
@@ -228,7 +228,7 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s->insn_write = dyna_pci10xx_insn_write_ao;
 
 	/* digital input */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = 16;
@@ -238,7 +238,7 @@ static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
 	s->insn_bits = dyna_pci10xx_di_insn_bits;
 
 	/* digital output */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
 	s->n_chan = 16;
diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index d1da809..ae8e8f4 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -140,7 +140,7 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * this if the definitions of the supdevices, 2 have been defined
 	 */
 	/* Analog indput */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* define subdevice as Analog In */
 	s->type = COMEDI_SUBD_AI;
 	/* you can read it from userspace */
@@ -156,7 +156,7 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_INFO "comedi: fl512: subdevice 0 initialized\n");
 
 	/* Analog output */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* define subdevice as Analog OUT */
 	s->type = COMEDI_SUBD_AO;
 	/* you can write it from userspace */
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 79f5808..5d3fa71 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -436,7 +436,7 @@ static int setup_subdevices(struct comedi_device *dev)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog input subdevice */
 	dev->read_subdev = s;
 /*	dev->write_subdev = s; */
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index b10ebdb..73fe8a3 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -931,7 +931,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 	subdev = 0;
 
 	if (this_board->n_aichan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		dev->read_subdev = s;
 		s->type = COMEDI_SUBD_AI;
 		s->subdev_flags = SDF_READABLE | SDF_COMMON | SDF_GROUND;
@@ -946,7 +946,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_aochan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 		s->n_chan = this_board->n_aochan;
@@ -959,7 +959,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_dichan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE;
 		s->n_chan = this_board->n_dichan;
@@ -972,7 +972,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_dochan) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 		s->n_chan = this_board->n_dochan;
@@ -986,7 +986,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 	}
 
 	if (this_board->n_ctrs) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_COUNTER;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
 		s->n_chan = this_board->n_ctrs;
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 0f9cfe6..65ff1c9 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -224,7 +224,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	       dev->minor, devpriv->ioaddr);
 
 	for (i = 0; i < PCI20000_MODULES; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		id = readb(devpriv->ioaddr + (i + 1) * PCI20000_OFFSET);
 		s->private = devpriv->subdev_private + i;
 		sdp = s->private;
@@ -259,7 +259,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	}
 
 	/* initialize struct pci20xxx_private */
-	pci20xxx_dio_init(dev, dev->subdevices + PCI20000_MODULES);
+	pci20xxx_dio_init(dev, &dev->subdevices[PCI20000_MODULES]);
 
 	return 1;
 }
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index a24e932..b4850db 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -145,7 +145,7 @@ static int cnt_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	subdevice = dev->subdevices + 0;
+	subdevice = &dev->subdevices[0];
 	dev->read_subdev = subdevice;
 
 	subdevice->type = COMEDI_SUBD_COUNTER;
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 9a8258e..050f0e4 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1410,7 +1410,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 {
 	unsigned int tmp;
 	struct comedi_device *dev = dev_id;
-	struct comedi_subdevice *s = dev->subdevices;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	struct me4000_ai_context *ai_context = &info->ai_context;
 	int i;
 	int c = 0;
@@ -2017,7 +2017,7 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
       Analog input subdevice
       ========================================================================*/
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 
 	if (thisboard->ai.count) {
 		s->type = COMEDI_SUBD_AI;
@@ -2055,7 +2055,7 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
       Analog output subdevice
       ========================================================================*/
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 
 	if (thisboard->ao.count) {
 		s->type = COMEDI_SUBD_AO;
@@ -2073,7 +2073,7 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
       Digital I/O subdevice
       ========================================================================*/
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 
 	if (thisboard->dio.count) {
 		s->type = COMEDI_SUBD_DIO;
@@ -2100,7 +2100,7 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
       Counter subdevice
       ========================================================================*/
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 
 	if (thisboard->cnt.count) {
 		s->type = COMEDI_SUBD_COUNTER;
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 8c6f8b9..437adf0 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -758,7 +758,7 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (error)
 		return error;
 
-	subdevice = dev->subdevices + 0;
+	subdevice = &dev->subdevices[0];
 	subdevice->type = COMEDI_SUBD_AI;
 	subdevice->subdev_flags = SDF_READABLE | SDF_COMMON | SDF_CMD_READ;
 	subdevice->n_chan = board->ai_channel_nbr;
@@ -770,7 +770,7 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	subdevice->do_cmdtest = me_ai_do_cmd_test;
 	subdevice->do_cmd = me_ai_do_cmd;
 
-	subdevice = dev->subdevices + 1;
+	subdevice = &dev->subdevices[1];
 	subdevice->type = COMEDI_SUBD_AO;
 	subdevice->subdev_flags = SDF_WRITEABLE | SDF_COMMON;
 	subdevice->n_chan = board->ao_channel_nbr;
@@ -780,7 +780,7 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	subdevice->insn_read = me_ao_insn_read;
 	subdevice->insn_write = me_ao_insn_write;
 
-	subdevice = dev->subdevices + 2;
+	subdevice = &dev->subdevices[2];
 	subdevice->type = COMEDI_SUBD_DIO;
 	subdevice->subdev_flags = SDF_READABLE | SDF_WRITEABLE;
 	subdevice->n_chan = board->dio_channel_nbr;
diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index b928b67..f8b7fae 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -353,7 +353,7 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_DIFF;
 	s->n_chan = 8;
diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index a7fda8f..c0c3329 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -137,7 +137,7 @@ static int mpc8260cpm_attach(struct comedi_device *dev,
 		return ret;
 
 	for (i = 0; i < 4; i++) {
-		s = dev->subdevices + i;
+		s = &dev->subdevices[i];
 		s->type = COMEDI_SUBD_DIO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 		s->n_chan = 32;
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index eccbe1f..0f6cbe6 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -258,7 +258,7 @@ static int multiq3_attach(struct comedi_device *dev,
 	if (result < 0)
 		return result;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* ai subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
@@ -267,7 +267,7 @@ static int multiq3_attach(struct comedi_device *dev,
 	s->maxdata = 0x1fff;
 	s->range_table = &range_bipolar5;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* ao subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -277,7 +277,7 @@ static int multiq3_attach(struct comedi_device *dev,
 	s->maxdata = 0xfff;
 	s->range_table = &range_bipolar5;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* di subdevice */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -286,7 +286,7 @@ static int multiq3_attach(struct comedi_device *dev,
 	s->maxdata = 1;
 	s->range_table = &range_digital;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* do subdevice */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -296,7 +296,7 @@ static int multiq3_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->state = 0;
 
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	/* encoder (counter) subdevice */
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_LSAMPL;
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index a80c52f..cfebd0b 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -212,7 +212,7 @@ static int ni6527_do_insn_bits(struct comedi_device *dev,
 static irqreturn_t ni6527_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 2;
+	struct comedi_subdevice *s = &dev->subdevices[2];
 	unsigned int status;
 
 	status = readb(devpriv->mite->daq_io_addr + Change_Status);
@@ -393,7 +393,7 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 24;
@@ -402,7 +402,7 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_config = ni6527_di_insn_config;
 	s->insn_bits = ni6527_di_insn_bits;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 24;
@@ -410,7 +410,7 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->maxdata = 1;
 	s->insn_bits = ni6527_do_insn_bits;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_CMD_READ;
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index bce39f1..7f6abe6 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -478,7 +478,7 @@ static int ni_65xx_dio_insn_bits(struct comedi_device *dev,
 static irqreturn_t ni_65xx_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 2;
+	struct comedi_subdevice *s = &dev->subdevices[2];
 	unsigned int status;
 
 	status = readb(private(dev)->mite->daq_io_addr + Change_Status);
@@ -678,7 +678,7 @@ static int ni_65xx_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	if (board(dev)->num_di_ports) {
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE;
@@ -696,7 +696,7 @@ static int ni_65xx_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	if (board(dev)->num_do_ports) {
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
@@ -713,7 +713,7 @@ static int ni_65xx_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	if (board(dev)->num_dio_ports) {
 		s->type = COMEDI_SUBD_DIO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
@@ -737,7 +737,7 @@ static int ni_65xx_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_CMD_READ;
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 5e863ff..6bd5b55 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -985,7 +985,7 @@ static irqreturn_t ni_660x_interrupt(int irq, void *d)
 	spin_lock_irqsave(&private(dev)->interrupt_lock, flags);
 	smp_mb();
 	for (i = 0; i < ni_660x_num_counters(dev); ++i) {
-		s = dev->subdevices + NI_660X_GPCT_SUBDEV(i);
+		s = &dev->subdevices[NI_660X_GPCT_SUBDEV(i)];
 		ni_660x_handle_gpct_interrupt(dev, s);
 	}
 	spin_unlock_irqrestore(&private(dev)->interrupt_lock, flags);
@@ -1097,11 +1097,11 @@ static int ni_660x_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* Old GENERAL-PURPOSE COUNTER/TIME (GPCT) subdevice, no longer used */
 	s->type = COMEDI_SUBD_UNUSED;
 
-	s = dev->subdevices + NI_660X_DIO_SUBDEV;
+	s = &dev->subdevices[NI_660X_DIO_SUBDEV];
 	/* DIGITAL I/O SUBDEVICE */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
@@ -1124,7 +1124,7 @@ static int ni_660x_attach(struct comedi_device *dev,
 	if (private(dev)->counter_dev == NULL)
 		return -ENOMEM;
 	for (i = 0; i < NI_660X_MAX_NUM_COUNTERS; ++i) {
-		s = dev->subdevices + NI_660X_GPCT_SUBDEV(i);
+		s = &dev->subdevices[NI_660X_GPCT_SUBDEV(i)];
 		if (i < ni_660x_num_counters(dev)) {
 			s->type = COMEDI_SUBD_COUNTER;
 			s->subdev_flags =
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 9c57618..cdb36b8 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -247,7 +247,7 @@ static int ni_670x_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -271,7 +271,7 @@ static int ni_670x_attach(struct comedi_device *dev,
 	s->insn_write = &ni_670x_ao_winsn;
 	s->insn_read = &ni_670x_ao_rinsn;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* digital i/o subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
@@ -298,7 +298,7 @@ static void ni_670x_detach(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 
 	if (dev->n_subdevices) {
-		s = dev->subdevices + 0;
+		s = &dev->subdevices[0];
 		if (s)
 			kfree(s->range_table_list);
 	}
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index b53a428..5895d4d 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -832,7 +832,7 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 
 	/* analog input subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_OTHER | SDF_CMD_READ;
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 62c8c44..93938ce 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -358,7 +358,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -371,7 +371,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = &atao_ao_winsn;
 	s->insn_read = &atao_ao_rinsn;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* digital i/o subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
@@ -381,7 +381,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_bits = atao_dio_insn_bits;
 	s->insn_config = atao_dio_insn_config;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* caldac subdevice */
 	s->type = COMEDI_SUBD_CALIB;
 	s->subdev_flags = SDF_WRITABLE | SDF_INTERNAL;
@@ -390,7 +390,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_read = atao_calib_insn_read;
 	s->insn_write = atao_calib_insn_write;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* eeprom subdevice */
 	/* s->type=COMEDI_SUBD_EEPROM; */
 	s->type = COMEDI_SUBD_UNUSED;
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 2c78d3d..f7b76b5b 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -234,7 +234,7 @@ static void reset_atmio16d(struct comedi_device *dev)
 static irqreturn_t atmio16d_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 
 	comedi_buf_put(s->async, inw(dev->iobase + AD_FIFO_REG));
 
@@ -724,7 +724,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 	devpriv->dac1_coding = it->options[12];
 
 	/* setup sub-devices */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* ai subdevice */
 	s->type = COMEDI_SUBD_AI;
@@ -809,7 +809,7 @@ static void atmio16d_detach(struct comedi_device *dev)
 	const struct atmio16_board_t *board = comedi_board(dev);
 
 	if (dev->subdevices && board->has_8255)
-		subdev_8255_cleanup(dev, dev->subdevices + 3);
+		subdev_8255_cleanup(dev, &dev->subdevices[3]);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	reset_atmio16d(dev);
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 83016b41..7355860 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -121,7 +121,7 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 
 	/* DAQCard-700 dio */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type		= COMEDI_SUBD_DIO;
 	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
 	s->n_chan	= 16;
diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index e27cae0..a92cd07 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -164,7 +164,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 
 	/* 8255 dio */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	subdev_8255_init(dev, s, NULL, dev->iobase);
 
 	return 0;
@@ -173,7 +173,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static void dio24_detach(struct comedi_device *dev)
 {
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 0);
+		subdev_8255_cleanup(dev, &dev->subdevices[0]);
 	if (thisboard->bustype != pcmcia_bustype && dev->iobase)
 		release_region(dev->iobase, DIO24_SIZE);
 	if (dev->irq)
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index ab8b787..a9b2213 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -628,7 +628,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		return ret;
 
 	/* analog input subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags =
@@ -643,7 +643,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	s->cancel = labpc_cancel;
 
 	/* analog output */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	if (thisboard->has_ao) {
 		/*
 		 * Could provide command support, except it only has a
@@ -670,7 +670,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	}
 
 	/* 8255 dio */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/*  if board uses io memory we have to give a custom callback
 	 * function to the 8255 driver */
 	if (thisboard->memory_mapped_io)
@@ -680,7 +680,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		subdev_8255_init(dev, s, NULL, dev->iobase + DIO_BASE_REG);
 
 	/*  calibration subdevices for boards that have one */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	if (thisboard->register_layout == labpc_1200_layout) {
 		s->type = COMEDI_SUBD_CALIB;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
@@ -695,7 +695,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		s->type = COMEDI_SUBD_UNUSED;
 
 	/* EEPROM */
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	if (thisboard->register_layout == labpc_1200_layout) {
 		s->type = COMEDI_SUBD_MEMORY;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
@@ -810,7 +810,7 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 void labpc_common_detach(struct comedi_device *dev)
 {
 	if (dev->subdevices)
-		subdev_8255_cleanup(dev, dev->subdevices + 2);
+		subdev_8255_cleanup(dev, &dev->subdevices[2]);
 #ifdef CONFIG_ISA_DMA_API
 	/* only free stuff if it has been allocated by _attach */
 	kfree(devpriv->dma_buffer);
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index cf0e0d14..9cc66d6 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -872,7 +872,7 @@ static irqreturn_t ni_E_interrupt(int irq, void *d)
 #ifdef PCIDMA
 static void ni_sync_ai_dma(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 	unsigned long flags;
 
 	spin_lock_irqsave(&devpriv->mite_channel_lock, flags);
@@ -884,7 +884,7 @@ static void ni_sync_ai_dma(struct comedi_device *dev)
 static void mite_handle_b_linkc(struct mite_struct *mite,
 				struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AO_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AO_SUBDEV];
 	unsigned long flags;
 
 	spin_lock_irqsave(&devpriv->mite_channel_lock, flags);
@@ -942,7 +942,7 @@ static void ni_handle_eos(struct comedi_device *dev, struct comedi_subdevice *s)
 
 static void shutdown_ai_command(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 
 #ifdef PCIDMA
 	ni_ai_drain_dma(dev);
@@ -984,8 +984,9 @@ static void handle_gpct_interrupt(struct comedi_device *dev,
 				  unsigned short counter_index)
 {
 #ifdef PCIDMA
-	struct comedi_subdevice *s =
-	    dev->subdevices + NI_GPCT_SUBDEV(counter_index);
+	struct comedi_subdevice *s;
+
+	s = &dev->subdevices[NI_GPCT_SUBDEV(counter_index)];
 
 	ni_tio_handle_interrupt(&devpriv->counter_dev->counters[counter_index],
 				s);
@@ -1018,7 +1019,7 @@ static void ack_a_interrupt(struct comedi_device *dev, unsigned short a_status)
 static void handle_a_interrupt(struct comedi_device *dev, unsigned short status,
 			       unsigned ai_mite_status)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 
 	/* 67xx boards don't have ai subdevice, but their gpct0 might generate an a interrupt */
 	if (s->type == COMEDI_SUBD_UNUSED)
@@ -1150,7 +1151,7 @@ static void ack_b_interrupt(struct comedi_device *dev, unsigned short b_status)
 static void handle_b_interrupt(struct comedi_device *dev,
 			       unsigned short b_status, unsigned ao_mite_status)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AO_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AO_SUBDEV];
 	/* unsigned short ack=0; */
 #ifdef DEBUG_INTERRUPT
 	printk("ni_mio_common: interrupt: b_status=%04x m1_status=%08x\n",
@@ -1422,7 +1423,7 @@ static void ni_ai_fifo_read(struct comedi_device *dev,
 static void ni_handle_fifo_half_full(struct comedi_device *dev)
 {
 	int n;
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 
 	n = boardtype.ai_fifo_depth / 2;
 
@@ -1470,7 +1471,7 @@ static int ni_ai_drain_dma(struct comedi_device *dev)
 */
 static void ni_handle_fifo_dregs(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 	short data[2];
 	u32 dl;
 	short fifo_empty;
@@ -1534,7 +1535,7 @@ static void ni_handle_fifo_dregs(struct comedi_device *dev)
 
 static void get_last_sample_611x(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 	short data;
 	u32 dl;
 
@@ -1551,7 +1552,7 @@ static void get_last_sample_611x(struct comedi_device *dev)
 
 static void get_last_sample_6143(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 	short data;
 	u32 dl;
 
@@ -1598,7 +1599,7 @@ static void ni_ai_munge(struct comedi_device *dev, struct comedi_subdevice *s,
 
 static int ni_ai_setup_MITE_dma(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AI_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AI_SUBDEV];
 	int retval;
 	unsigned long flags;
 
@@ -1637,7 +1638,7 @@ static int ni_ai_setup_MITE_dma(struct comedi_device *dev)
 
 static int ni_ao_setup_MITE_dma(struct comedi_device *dev)
 {
-	struct comedi_subdevice *s = dev->subdevices + NI_AO_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_AO_SUBDEV];
 	int retval;
 	unsigned long flags;
 
@@ -3852,7 +3853,7 @@ static int ni_cdio_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 static void handle_cdio_interrupt(struct comedi_device *dev)
 {
 	unsigned cdio_status;
-	struct comedi_subdevice *s = dev->subdevices + NI_DIO_SUBDEV;
+	struct comedi_subdevice *s = &dev->subdevices[NI_DIO_SUBDEV];
 #ifdef PCIDMA
 	unsigned long flags;
 #endif
@@ -4107,7 +4108,7 @@ static void mio_common_detach(struct comedi_device *dev)
 		}
 	}
 	if (dev->subdevices && boardtype.has_8255)
-		subdev_8255_cleanup(dev, dev->subdevices + NI_8255_DIO_SUBDEV);
+		subdev_8255_cleanup(dev, &dev->subdevices[NI_8255_DIO_SUBDEV]);
 }
 
 static void init_ao_67xx(struct comedi_device *dev, struct comedi_subdevice *s)
@@ -4417,7 +4418,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* analog input subdevice */
 
-	s = dev->subdevices + NI_AI_SUBDEV;
+	s = &dev->subdevices[NI_AI_SUBDEV];
 	dev->read_subdev = s;
 	if (boardtype.n_adchan) {
 		s->type = COMEDI_SUBD_AI;
@@ -4449,7 +4450,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* analog output subdevice */
 
-	s = dev->subdevices + NI_AO_SUBDEV;
+	s = &dev->subdevices[NI_AO_SUBDEV];
 	if (boardtype.n_aochan) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_DEGLITCH | SDF_GROUND;
@@ -4488,7 +4489,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* digital i/o subdevice */
 
-	s = dev->subdevices + NI_DIO_SUBDEV;
+	s = &dev->subdevices[NI_DIO_SUBDEV];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 	s->maxdata = 1;
@@ -4516,7 +4517,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* 8255 device */
-	s = dev->subdevices + NI_8255_DIO_SUBDEV;
+	s = &dev->subdevices[NI_8255_DIO_SUBDEV];
 	if (boardtype.has_8255) {
 		subdev_8255_init(dev, s, ni_8255_callback, (unsigned long)dev);
 	} else {
@@ -4524,11 +4525,11 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* formerly general purpose counter/timer device, but no longer used */
-	s = dev->subdevices + NI_UNUSED_SUBDEV;
+	s = &dev->subdevices[NI_UNUSED_SUBDEV];
 	s->type = COMEDI_SUBD_UNUSED;
 
 	/* calibration subdevice -- ai and ao */
-	s = dev->subdevices + NI_CALIBRATION_SUBDEV;
+	s = &dev->subdevices[NI_CALIBRATION_SUBDEV];
 	s->type = COMEDI_SUBD_CALIB;
 	if (boardtype.reg_type & ni_reg_m_series_mask) {
 		/*  internal PWM analog output used for AI nonlinearity calibration */
@@ -4551,7 +4552,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* EEPROM */
-	s = dev->subdevices + NI_EEPROM_SUBDEV;
+	s = &dev->subdevices[NI_EEPROM_SUBDEV];
 	s->type = COMEDI_SUBD_MEMORY;
 	s->subdev_flags = SDF_READABLE | SDF_INTERNAL;
 	s->maxdata = 0xff;
@@ -4564,7 +4565,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* PFI */
-	s = dev->subdevices + NI_PFI_DIO_SUBDEV;
+	s = &dev->subdevices[NI_PFI_DIO_SUBDEV];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
 	if (boardtype.reg_type & ni_reg_m_series_mask) {
@@ -4586,7 +4587,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	ni_set_bits(dev, IO_Bidirection_Pin_Register, ~0, 0);
 
 	/* cs5529 calibration adc */
-	s = dev->subdevices + NI_CS5529_CALIBRATION_SUBDEV;
+	s = &dev->subdevices[NI_CS5529_CALIBRATION_SUBDEV];
 	if (boardtype.reg_type & ni_reg_67xx_mask) {
 		s->type = COMEDI_SUBD_AI;
 		s->subdev_flags = SDF_READABLE | SDF_DIFF | SDF_INTERNAL;
@@ -4602,7 +4603,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* Serial */
-	s = dev->subdevices + NI_SERIAL_SUBDEV;
+	s = &dev->subdevices[NI_SERIAL_SUBDEV];
 	s->type = COMEDI_SUBD_SERIAL;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
 	s->n_chan = 1;
@@ -4612,7 +4613,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->serial_hw_mode = 0;
 
 	/* RTSI */
-	s = dev->subdevices + NI_RTSI_SUBDEV;
+	s = &dev->subdevices[NI_RTSI_SUBDEV];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_INTERNAL;
 	s->n_chan = 8;
@@ -4633,7 +4634,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 							NUM_GPCT);
 	/* General purpose counters */
 	for (j = 0; j < NUM_GPCT; ++j) {
-		s = dev->subdevices + NI_GPCT_SUBDEV(j);
+		s = &dev->subdevices[NI_GPCT_SUBDEV(j)];
 		s->type = COMEDI_SUBD_COUNTER;
 		s->subdev_flags =
 		    SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL | SDF_CMD_READ
@@ -4659,7 +4660,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* Frequency output */
-	s = dev->subdevices + NI_FREQ_OUT_SUBDEV;
+	s = &dev->subdevices[NI_FREQ_OUT_SUBDEV];
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 1;
@@ -4669,7 +4670,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_config = &ni_freq_out_insn_config;
 
 	/* ai configuration */
-	ni_ai_reset(dev, dev->subdevices + NI_AI_SUBDEV);
+	ni_ai_reset(dev, &dev->subdevices[NI_AI_SUBDEV]);
 	if ((boardtype.reg_type & ni_reg_6xxx_mask) == 0) {
 		/*  BEAM is this needed for PCI-6143 ?? */
 		devpriv->clock_and_fout =
@@ -4688,7 +4689,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 			    Clock_and_FOUT_Register);
 
 	/* analog output configuration */
-	ni_ao_reset(dev, dev->subdevices + NI_AO_SUBDEV);
+	ni_ao_reset(dev, &dev->subdevices[NI_AO_SUBDEV]);
 
 	if (dev->irq) {
 		devpriv->stc_writew(dev,
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 0a55de9..556888f 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -480,7 +480,7 @@ static int ni_pcidio_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 static irqreturn_t nidio_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	struct comedi_async *async = s->async;
 	struct mite_struct *mite = devpriv->mite;
 
@@ -1252,7 +1252,7 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (!this_board->is_diodaq) {
 		for (i = 0; i < this_board->n_8255; i++) {
-			subdev_8255_init(dev, dev->subdevices + i,
+			subdev_8255_init(dev, &dev->subdevices[i],
 					 nidio96_8255_cb,
 					 (unsigned long)(devpriv->mite->
 							 daq_io_addr +
@@ -1263,7 +1263,7 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		printk(KERN_INFO " rev=%d",
 		       readb(devpriv->mite->daq_io_addr + Chip_Version));
 
-		s = dev->subdevices + 0;
+		s = &dev->subdevices[0];
 
 		dev->read_subdev = s;
 		s->type = COMEDI_SUBD_DIO;
@@ -1311,7 +1311,7 @@ static void nidio_detach(struct comedi_device *dev)
 
 	if (this_board && !this_board->is_diodaq) {
 		for (i = 0; i < this_board->n_8255; i++)
-			subdev_8255_cleanup(dev, dev->subdevices + i);
+			subdev_8255_cleanup(dev, &dev->subdevices[i]);
 	}
 	if (dev->irq)
 		free_irq(dev->irq, dev);
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index bb72d0b..97a5534 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -168,7 +168,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 	int data;
 	struct comedi_device *dev = d;
 	const struct pcl711_board *board = comedi_board(dev);
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 
 	if (!dev->attached) {
 		comedi_error(dev, "spurious interrupt");
@@ -520,7 +520,7 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* AI subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index c8fe23c..555c369 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -162,12 +162,12 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (i = 0; i < dev->n_subdevices; i++) {
 		if (board->is_pet48) {
-			subdev_8255_init(dev, dev->subdevices + i,
+			subdev_8255_init(dev, &dev->subdevices[i],
 					 subdev_8255mapped_cb,
 					 (unsigned long)(dev->iobase +
 							 i * 0x1000));
 		} else
-			subdev_8255_init(dev, dev->subdevices + i,
+			subdev_8255_init(dev, &dev->subdevices[i],
 					 subdev_8255_cb,
 					 (unsigned long)(dev->iobase +
 							 SIZE_8255 * i));
@@ -182,7 +182,7 @@ static void pcl724_detach(struct comedi_device *dev)
 	int i;
 
 	for (i = 0; i < dev->n_subdevices; i++)
-		subdev_8255_cleanup(dev, dev->subdevices + i);
+		subdev_8255_cleanup(dev, &dev->subdevices[i]);
 #ifdef PCL724_IRQ
 	if (dev->irq)
 		free_irq(dev->irq, dev);
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index d5b60cf..21fbc1ae 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -62,7 +62,7 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* do */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -71,7 +71,7 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_bits = pcl725_do_insn;
 	s->range_table = &range_digital;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* di */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index 2b10f1d..07e72de 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -290,7 +290,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* ao */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
@@ -316,7 +316,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			devpriv->bipolar[i] = 1;	/* bipolar range */
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* di */
 	if (!board->have_dio) {
 		s->type = COMEDI_SUBD_UNUSED;
@@ -330,7 +330,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->range_table = &range_digital;
 	}
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* do */
 	if (!board->have_dio) {
 		s->type = COMEDI_SUBD_UNUSED;
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index 4675ec5..e3de499 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -84,7 +84,7 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* Isolated do */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -94,7 +94,7 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_digital;
 	s->private = (void *)PCL730_IDIO_LO;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* Isolated di */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -104,7 +104,7 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_digital;
 	s->private = (void *)PCL730_IDIO_LO;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* TTL do */
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -114,7 +114,7 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_digital;
 	s->private = (void *)PCL730_DIO_LO;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* TTL di */
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 578fd89..d196343 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -806,7 +806,7 @@ static irqreturn_t interrupt_pcl812_ai_int(int irq, void *d)
 	char err = 1;
 	unsigned int mask, timeout;
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	unsigned int next_chan;
 
 	s->async->events = 0;
@@ -909,7 +909,7 @@ static void transfer_from_dma_buf(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl812_ai_dma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	unsigned long dma_flags;
 	int len, bufptr;
 	short *ptr;
@@ -1267,7 +1267,7 @@ no_dma:
 
 	/* analog input */
 	if (board->n_aichan > 0) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_AI;
 		s->subdev_flags = SDF_READABLE;
 		switch (board->board_type) {
@@ -1409,7 +1409,7 @@ no_dma:
 
 	/* analog output */
 	if (board->n_aochan > 0) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
 		s->n_chan = board->n_aochan;
@@ -1438,7 +1438,7 @@ no_dma:
 
 	/* digital input */
 	if (board->n_dichan > 0) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE;
 		s->n_chan = board->n_dichan;
@@ -1451,7 +1451,7 @@ no_dma:
 
 	/* digital output */
 	if (board->n_dochan > 0) {
-		s = dev->subdevices + subdev;
+		s = &dev->subdevices[subdev];
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_WRITABLE;
 		s->n_chan = board->n_dochan;
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index ba6911f..f65fd66 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -258,7 +258,7 @@ static int pcl816_ai_insn_read(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl816_ai_mode13_int(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int low, hi;
 	int timeout = 50;	/* wait max 50us */
 
@@ -349,7 +349,7 @@ static void transfer_from_dma_buf(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl816_ai_mode13_dma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int len, bufptr, this_dma_buf;
 	unsigned long dma_flags;
 	short *ptr;
@@ -1183,7 +1183,7 @@ no_dma:
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	if (board->n_aichan > 0) {
 		s->type = COMEDI_SUBD_AI;
 		devpriv->sub_ai = s;
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 34169c1..023a27d 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -477,7 +477,7 @@ static int pcl818_do_insn_bits(struct comedi_device *dev,
 static irqreturn_t interrupt_pcl818_ai_mode13_int(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int low;
 	int timeout = 50;	/* wait max 50us */
 
@@ -536,7 +536,7 @@ conv_finish:
 static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int i, len, bufptr;
 	unsigned long flags;
 	short *ptr;
@@ -615,7 +615,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	unsigned long tmp;
 	unsigned int top1, top2, i, bufptr;
 	long ofs_dats;
@@ -720,7 +720,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;
+	struct comedi_subdevice *s = &dev->subdevices[0];
 	int i, len, lo;
 
 	outb(0, dev->iobase + PCL818_FI_INTCLR);	/*  clear fifo int request */
@@ -811,7 +811,7 @@ static irqreturn_t interrupt_pcl818(int irq, void *d)
 			   being reprogrammed while a DMA transfer is in
 			   progress.
 			 */
-			struct comedi_subdevice *s = dev->subdevices + 0;
+			struct comedi_subdevice *s = &dev->subdevices[0];
 			devpriv->ai_act_scan = 0;
 			devpriv->neverending_ai = 0;
 			pcl818_ai_cancel(dev, s);
@@ -1763,7 +1763,7 @@ no_dma:
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	if (!board->n_aichan_se) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
@@ -1829,7 +1829,7 @@ no_dma:
 		}
 	}
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	if (!board->n_aochan) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
@@ -1862,7 +1862,7 @@ no_dma:
 		}
 	}
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	if (!board->n_dichan) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
@@ -1875,7 +1875,7 @@ no_dma:
 		s->insn_bits = pcl818_di_insn_bits;
 	}
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	if (!board->n_dochan) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 62c22cc..2a731ab 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -136,10 +136,10 @@ static void do_3724_config(struct comedi_device *dev,
 	if (!(s->io_bits & 0xff0000))
 		config |= CR_C_IO;
 
-	buffer_config = compute_buffer(0, 0, dev->subdevices);
-	buffer_config = compute_buffer(buffer_config, 1, (dev->subdevices) + 1);
+	buffer_config = compute_buffer(0, 0, &dev->subdevices[0]);
+	buffer_config = compute_buffer(buffer_config, 1, &dev->subdevices[1]);
 
-	if (s == dev->subdevices)
+	if (s == &dev->subdevices[0])
 		port_8255_cfg = dev->iobase + _8255_CR;
 	else
 		port_8255_cfg = dev->iobase + SIZE_8255 + _8255_CR;
@@ -162,7 +162,7 @@ static void enable_chan(struct comedi_device *dev, struct comedi_subdevice *s,
 	priv = dev->private;
 
 	mask = 1 << CR_CHAN(chanspec);
-	if (s == dev->subdevices)	/*  subdev 0 */
+	if (s == &dev->subdevices[0])
 		priv->dio_1 |= mask;
 	else		/* subdev 1 */
 		priv->dio_2 |= mask;
@@ -231,6 +231,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	const struct pcm3724_board *board = comedi_board(dev);
+	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iorange;
 	int ret, i, n_subdevices;
@@ -263,9 +264,10 @@ static int pcm3724_attach(struct comedi_device *dev,
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
-		subdev_8255_init(dev, dev->subdevices + i, subdev_8255_cb,
+		s = &dev->subdevices[i];
+		subdev_8255_init(dev, s, subdev_8255_cb,
 				 (unsigned long)(dev->iobase + SIZE_8255 * i));
-		((dev->subdevices) + i)->insn_config = subdev_3724_insn_config;
+		s->insn_config = subdev_3724_insn_config;
 	}
 	return 0;
 }
@@ -277,7 +279,7 @@ static void pcm3724_detach(struct comedi_device *dev)
 
 	if (dev->subdevices) {
 		for (i = 0; i < dev->n_subdevices; i++)
-			subdev_8255_cleanup(dev, dev->subdevices + i);
+			subdev_8255_cleanup(dev, &dev->subdevices[i]);
 	}
 	if (dev->iobase)
 		release_region(dev->iobase, board->io_range);
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index d65e0bd..067f14d 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -72,7 +72,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->maxdata = 1;
@@ -81,7 +81,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)PCM3730_DOA;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->maxdata = 1;
@@ -90,7 +90,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)PCM3730_DOB;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE;
 	s->maxdata = 1;
@@ -99,7 +99,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)PCM3730_DOC;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->maxdata = 1;
@@ -108,7 +108,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)PCM3730_DIA;
 
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->maxdata = 1;
@@ -117,7 +117,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)PCM3730_DIB;
 
-	s = dev->subdevices + 5;
+	s = &dev->subdevices[5];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->maxdata = 1;
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 54d19c9..5efeb92 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -127,7 +127,7 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = board->name;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | AREF_GROUND;
 	s->n_chan = 16;		/* XXX */
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 291ce7c..28af8f6 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -195,7 +195,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	s = dev->subdevices;
+	s = &dev->subdevices[0];
 	s->private = NULL;
 	s->maxdata = (0x1 << BITS) - 1;
 	s->range_table = &pcmda12_ranges;
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 3d2e6f0..d66d512 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -576,6 +576,8 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 
 			if (triggered) {
 				struct comedi_subdevice *s;
+				int subdev;
+
 				/*
 				 * TODO here: dispatch io lines to subdevs
 				 * with commands..
@@ -583,9 +585,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 				printk
 				    (KERN_DEBUG "got edge detect interrupt %d asic %d which_chans: %06x\n",
 				     irq, asic, triggered);
-				for (s = dev->subdevices + 2;
-				     s < dev->subdevices + dev->n_subdevices;
-				     ++s) {
+				for (subdev = 2; subdev < dev->n_subdevices;
+				     subdev++) {
+					s = &dev->subdevices[subdev];
 					/*
 					 * this is an interrupt subdev,
 					 * and it matches this asic!
@@ -1077,7 +1079,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* First, AI */
 	sdev_no = 0;
-	s = dev->subdevices + sdev_no;
+	s = &dev->subdevices[sdev_no];
 	s->private = devpriv->sprivs + sdev_no;
 	s->maxdata = (1 << board->ai_bits) - 1;
 	s->range_table = board->ai_range_table;
@@ -1093,7 +1095,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* Next, AO */
 	++sdev_no;
-	s = dev->subdevices + sdev_no;
+	s = &dev->subdevices[sdev_no];
 	s->private = devpriv->sprivs + sdev_no;
 	s->maxdata = (1 << board->ao_bits) - 1;
 	s->range_table = board->ao_range_table;
@@ -1114,7 +1116,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (; sdev_no < (int)dev->n_subdevices; ++sdev_no) {
 		int byte_no;
 
-		s = dev->subdevices + sdev_no;
+		s = &dev->subdevices[sdev_no];
 		s->private = devpriv->sprivs + sdev_no;
 		s->maxdata = 1;
 		s->range_table = &range_digital;
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index feef3d0..f4c2936 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -503,13 +503,15 @@ static irqreturn_t interrupt_pcmuio(int irq, void *d)
 
 			if (triggered) {
 				struct comedi_subdevice *s;
+				int subdev;
+
 				/* TODO here: dispatch io lines to subdevs with commands.. */
 				printk
 				    ("PCMUIO DEBUG: got edge detect interrupt %d asic %d which_chans: %06x\n",
 				     irq, asic, triggered);
-				for (s = dev->subdevices;
-				     s < dev->subdevices + dev->n_subdevices;
-				     ++s) {
+				for (subdev = 0; subdev < dev->n_subdevices;
+				     subdev++) {
+					s = &dev->subdevices[subdev];
 					if (subpriv->intr.asic == asic) {	/* this is an interrupt subdev, and it matches this asic! */
 						unsigned long flags;
 						unsigned oldevents;
@@ -811,7 +813,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (sdev_no = 0; sdev_no < (int)dev->n_subdevices; ++sdev_no) {
 		int byte_no;
 
-		s = dev->subdevices + sdev_no;
+		s = &dev->subdevices[sdev_no];
 		s->private = devpriv->sprivs + sdev_no;
 		s->maxdata = 1;
 		s->range_table = &range_digital;
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index c253bb9..78dfe16 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -164,7 +164,7 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 
 	/* analog output subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = board->type;
 	s->n_chan = board->n_chan;
 	s->maxdata = (1 << board->n_bits) - 1;
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index a029147..e95a4eb 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -878,7 +878,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_INFO "comedi%d: attaching daqp%d (io 0x%04lx)\n",
 	       dev->minor, it->options[0], dev->iobase);
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	s->private = local;
 	s->type = COMEDI_SUBD_AI;
@@ -892,7 +892,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->do_cmd = daqp_ai_cmd;
 	s->cancel = daqp_ai_cancel;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	dev->write_subdev = s;
 	s->private = local;
 	s->type = COMEDI_SUBD_AO;
@@ -903,7 +903,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_daqp_ao;
 	s->insn_write = daqp_ao_insn_write;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->private = local;
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
@@ -911,7 +911,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->len_chanlist = 1;
 	s->insn_read = daqp_di_insn_read;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->private = local;
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITEABLE;
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 5aa8be1..06ae9ba 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -783,7 +783,7 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 				 void *d)
 {				/* our data *//* cpu context (ignored) */
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog in subdevice */
+	struct comedi_subdevice *s = &dev->subdevices[0];  /* ai subdevice */
 	struct rtdPrivate *devpriv = dev->private;
 	u32 overrun;
 	u16 status;
@@ -1706,7 +1706,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	dev->read_subdev = s;
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
@@ -1726,7 +1726,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->cancel = rtd_ai_cancel;
 	/* s->poll = rtd_ai_poll; *//* not ready yet */
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -1736,7 +1736,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = rtd_ao_winsn;
 	s->insn_read = rtd_ao_rinsn;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital i/o subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
@@ -1748,7 +1748,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_config = rtd_dio_insn_config;
 
 	/* timer/counter subdevices (not currently supported) */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 3;
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index f7fa940..6c039af 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -360,7 +360,7 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->dac1_coding = it->options[8];
 	devpriv->muxgain_bits = -1;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* ai subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index fc16508..3f9d027 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -111,7 +111,7 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices;
+	s = &dev->subdevices[0];
 	/* ao subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 737a194..c89bd6c 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -768,7 +768,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* GENERAL-PURPOSE COUNTER/TIME (GPCT) */
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL;
@@ -786,7 +786,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* s->do_cmdtest = s526_gpct_cmdtest; */
 	/* s->cancel = s526_gpct_cancel; */
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* dev->read_subdev=s; */
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
@@ -802,7 +802,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_read = s526_ai_rinsn;
 	s->insn_config = s526_ai_insn_config;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -812,7 +812,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = s526_ao_winsn;
 	s->insn_read = s526_ao_rinsn;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* digital i/o subdevice */
 	if (board->have_dio) {
 		s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index f90578e..60b492e 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -228,7 +228,7 @@ struct enc_private {
 	uint16_t MyEventBits[4];	/*    Bit translations for IntSrc -->RDMISC2. */
 };
 
-#define encpriv ((struct enc_private *)(dev->subdevices+5)->private)
+#define encpriv ((struct enc_private *)(&dev->subdevices[5])->private)
 
 /*  Counter overflow/index event flag masks for RDMISC2. */
 #define INDXMASK(C)		(1 << (((C) > 2) ? ((C) * 2 - 1) : ((C) * 2 +  4)))
@@ -702,6 +702,8 @@ static unsigned int s626_ai_reg_to_uint(int data)
 
 static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
 {
+	struct comedi_subdevice *s;
+	struct dio_private *spriv;
 	unsigned int group;
 	unsigned int bitmask;
 	unsigned int status;
@@ -710,35 +712,23 @@ static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
 	group = chan / 16;
 	bitmask = 1 << (chan - (16 * group));
 
+	s = &dev->subdevices[2 + group];
+	spriv = s->private;
+
 	/* set channel to capture positive edge */
-	status = DEBIread(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->RDEdgSel);
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WREdgSel,
-		  bitmask | status);
+	status = DEBIread(dev, spriv->RDEdgSel);
+	DEBIwrite(dev, spriv->WREdgSel, bitmask | status);
 
 	/* enable interrupt on selected channel */
-	status = DEBIread(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->RDIntSel);
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WRIntSel,
-		  bitmask | status);
+	status = DEBIread(dev, spriv->RDIntSel);
+	DEBIwrite(dev, spriv->WRIntSel, bitmask | status);
 
 	/* enable edge capture write command */
 	DEBIwrite(dev, LP_MISC1, MISC1_EDCAP);
 
 	/* enable edge capture on selected channel */
-	status = DEBIread(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->RDCapSel);
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WRCapSel,
-		  bitmask | status);
+	status = DEBIread(dev, spriv->RDCapSel);
+	DEBIwrite(dev, spriv->WRCapSel, bitmask | status);
 
 	return 0;
 }
@@ -746,13 +736,14 @@ static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
 static int s626_dio_reset_irq(struct comedi_device *dev, unsigned int group,
 			      unsigned int mask)
 {
+	struct comedi_subdevice *s = &dev->subdevices[2 + group];
+	struct dio_private *spriv = s->private;
+
 	/* disable edge capture write command */
 	DEBIwrite(dev, LP_MISC1, MISC1_NOEDCAP);
 
 	/* enable edge capture on selected channel */
-	DEBIwrite(dev,
-		  ((struct dio_private *)(dev->subdevices + 2 +
-					  group)->private)->WRCapSel, mask);
+	DEBIwrite(dev, spriv->WRCapSel, mask);
 
 	return 0;
 }
@@ -765,11 +756,11 @@ static int s626_dio_clear_irq(struct comedi_device *dev)
 	DEBIwrite(dev, LP_MISC1, MISC1_NOEDCAP);
 
 	for (group = 0; group < S626_DIO_BANKS; group++) {
+		struct comedi_subdevice *s = &dev->subdevices[2 + group];
+		struct dio_private *spriv = s->private;
+
 		/* clear pending events and interrupt */
-		DEBIwrite(dev,
-			  ((struct dio_private *)(dev->subdevices + 2 +
-						  group)->private)->WRCapSel,
-			  0xffff);
+		DEBIwrite(dev, spriv->WRCapSel, 0xffff);
 	}
 
 	return 0;
@@ -809,7 +800,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	switch (irqtype) {
 	case IRQ_RPS1:		/*  end_of_scan occurs */
 		/*  manage ai subdevice */
-		s = dev->subdevices;
+		s = &dev->subdevices[0];
 		cmd = &(s->async->cmd);
 
 		/* Init ptr to DMA buffer that holds new ADC data.  We skip the
@@ -857,7 +848,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 		break;
 	case IRQ_GPIO3:	/* check dio and conter interrupt */
 		/*  manage ai subdevice */
-		s = dev->subdevices;
+		s = &dev->subdevices[0];
 		cmd = &(s->async->cmd);
 
 		/* s626_dio_clear_irq(dev); */
@@ -1016,7 +1007,7 @@ static void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 	uint16_t i;
 	uint16_t n;
 	uint32_t LocalPPL;
-	struct comedi_cmd *cmd = &(dev->subdevices->async->cmd);
+	struct comedi_cmd *cmd = &(dev->subdevices[0]->async->cmd);
 
 	/*  Stop RPS program in case it is currently running. */
 	MC_DISABLE(P_MC1, MC1_ERPS1);
@@ -1771,7 +1762,7 @@ static void s626_dio_init(struct comedi_device *dev)
 
 	/*  For each group of sixteen channels ... */
 	for (group = 0; group < S626_DIO_BANKS; group++) {
-		s = dev->subdevices + 2 + group;
+		s = &dev->subdevices[2 + group];
 		DEBIwrite(dev, diopriv->WRIntSel, 0);	/*  Disable all interrupts. */
 		DEBIwrite(dev, diopriv->WRCapSel, 0xFFFF);	/*  Disable all event */
 		/*  captures. */
@@ -2604,7 +2595,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* analog input subdevice */
 	dev->read_subdev = s;
 	/* we support single-ended (ground) and differential */
@@ -2622,7 +2613,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->do_cmdtest = s626_ai_cmdtest;
 	s->cancel = s626_ai_cancel;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
@@ -2632,7 +2623,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = s626_ao_winsn;
 	s->insn_read = s626_ao_rinsn;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital I/O subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
@@ -2644,7 +2635,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_config = s626_dio_insn_config;
 	s->insn_bits = s626_dio_insn_bits;
 
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	/* digital I/O subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
@@ -2656,7 +2647,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_config = s626_dio_insn_config;
 	s->insn_bits = s626_dio_insn_bits;
 
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	/* digital I/O subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
@@ -2668,7 +2659,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_config = s626_dio_insn_config;
 	s->insn_bits = s626_dio_insn_bits;
 
-	s = dev->subdevices + 5;
+	s = &dev->subdevices[5];
 	/* encoder (counter) subdevice */
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE | SDF_LSAMPL;
@@ -2798,7 +2789,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 /*				// channel 0. */
 /*     ResetADC( dev, &PollList ); */
 
-/*     s626_ai_rinsn(dev,dev->subdevices,NULL,data); //( &AdcData ); // */
+/*     s626_ai_rinsn(dev,&dev->subdevices[0],NULL,data); //( &AdcData ); // */
 /*							//Get initial ADC */
 /*							//value. */
 
@@ -2813,7 +2804,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 /*     for ( index = 0; index < 500; index++ ) */
 /*       { */
-/*	s626_ai_rinsn(dev,dev->subdevices,NULL,data); */
+/*	s626_ai_rinsn(dev,&dev->subdevices[0],NULL,data); */
 /*	AdcData = data[0];	//ReadADC(  &AdcData ); */
 /*	if ( AdcData != StartVal ) */
 /*		break; */
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index c18314b..b3ef99d 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -798,7 +798,7 @@ static int serial2002_attach(struct comedi_device *dev,
 		return ret;
 
 	/* digital input subdevice */
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 0;
@@ -807,7 +807,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->insn_read = &serial2002_di_rinsn;
 
 	/* digital output subdevice */
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 0;
@@ -816,7 +816,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->insn_write = &serial2002_do_winsn;
 
 	/* analog input subdevice */
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = 0;
@@ -825,7 +825,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->insn_read = &serial2002_ai_rinsn;
 
 	/* analog output subdevice */
-	s = dev->subdevices + 3;
+	s = &dev->subdevices[3];
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 0;
@@ -835,7 +835,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	s->insn_read = &serial2002_ao_rinsn;
 
 	/* encoder input subdevice */
-	s = dev->subdevices + 4;
+	s = &dev->subdevices[4];
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_LSAMPL;
 	s->n_chan = 0;
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 9a68eeb..eb70bac 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -238,7 +238,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* dev->read_subdev=s; */
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
@@ -256,7 +256,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 */
 	s->do_cmdtest = skel_ai_cmdtest;
 
-	s = dev->subdevices + 1;
+	s = &dev->subdevices[1];
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
@@ -266,7 +266,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = skel_ao_winsn;
 	s->insn_read = skel_ao_rinsn;
 
-	s = dev->subdevices + 2;
+	s = &dev->subdevices[2];
 	/* digital i/o subdevice */
 	if (thisboard->have_dio) {
 		s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index d1f5118..ae3aa1c 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -183,7 +183,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	s = dev->subdevices + 0;
+	s = &dev->subdevices[0];
 	/* digital i/o subdevice                                             */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 848c7ec..5777a10 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -403,7 +403,7 @@ static void usbduxsub_ai_IsocIrq(struct urb *urb)
 	/* the private structure of the subdevice is struct usbduxsub */
 	this_usbduxsub = this_comedidev->private;
 	/* subdevice which is the AD converter */
-	s = this_comedidev->subdevices + SUBDEV_AD;
+	s = &this_comedidev->subdevices[SUBDEV_AD];
 
 	/* first we test if something unusual has just happened */
 	switch (urb->status) {
@@ -603,7 +603,7 @@ static void usbduxsub_ao_IsocIrq(struct urb *urb)
 	/* the private structure of the subdevice is struct usbduxsub */
 	this_usbduxsub = this_comedidev->private;
 
-	s = this_comedidev->subdevices + SUBDEV_DA;
+	s = &this_comedidev->subdevices[SUBDEV_DA];
 
 	switch (urb->status) {
 	case 0:
@@ -1946,7 +1946,7 @@ static void usbduxsub_pwm_irq(struct urb *urb)
 	/* the private structure of the subdevice is struct usbduxsub */
 	this_usbduxsub = this_comedidev->private;
 
-	s = this_comedidev->subdevices + SUBDEV_DA;
+	s = &this_comedidev->subdevices[SUBDEV_DA];
 
 	switch (urb->status) {
 	case 0:
@@ -2330,7 +2330,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	dev->private = udev;
 
 	/* the first subdevice is the A/D converter */
-	s = dev->subdevices + SUBDEV_AD;
+	s = &dev->subdevices[SUBDEV_AD];
 	/* the URBs get the comedi subdevice */
 	/* which is responsible for reading */
 	/* this is the subdevice which reads data */
@@ -2357,7 +2357,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	s->range_table = (&range_usbdux_ai_range);
 
 	/* analog out */
-	s = dev->subdevices + SUBDEV_DA;
+	s = &dev->subdevices[SUBDEV_DA];
 	/* analog out */
 	s->type = COMEDI_SUBD_AO;
 	/* backward pointer */
@@ -2383,7 +2383,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	s->insn_write = usbdux_ao_insn_write;
 
 	/* digital I/O */
-	s = dev->subdevices + SUBDEV_DIO;
+	s = &dev->subdevices[SUBDEV_DIO];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 8;
@@ -2395,7 +2395,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	s->private = NULL;
 
 	/* counter */
-	s = dev->subdevices + SUBDEV_COUNTER;
+	s = &dev->subdevices[SUBDEV_COUNTER];
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 	s->n_chan = 4;
@@ -2406,7 +2406,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 
 	if (udev->high_speed) {
 		/* timer / pwm */
-		s = dev->subdevices + SUBDEV_PWM;
+		s = &dev->subdevices[SUBDEV_PWM];
 		s->type = COMEDI_SUBD_PWM;
 		s->subdev_flags = SDF_WRITABLE | SDF_PWM_HBRIDGE;
 		s->n_chan = 8;
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index d991158..3cdead0 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -345,7 +345,7 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 		return;
 	}
 	/* subdevice which is the AD converter */
-	s = this_comedidev->subdevices + SUBDEV_AD;
+	s = &this_comedidev->subdevices[SUBDEV_AD];
 
 	/* first we test if something unusual has just happened */
 	switch (urb->status) {
@@ -1452,7 +1452,7 @@ static int usbduxfast_attach_common(struct comedi_device *dev,
 	/* private structure is also simply the usb-structure */
 	dev->private = udfs;
 	/* the first subdevice is the A/D converter */
-	s = dev->subdevices + SUBDEV_AD;
+	s = &dev->subdevices[SUBDEV_AD];
 	/*
 	 * the URBs get the comedi subdevice which is responsible for reading
 	 * this is the subdevice which reads data
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 543e604..cdfc697 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -355,7 +355,7 @@ static void usbduxsub_ai_IsocIrq(struct urb *urb)
 	/* the private structure of the subdevice is struct usbduxsub */
 	this_usbduxsub = this_comedidev->private;
 	/* subdevice which is the AD converter */
-	s = this_comedidev->subdevices + SUBDEV_AD;
+	s = &this_comedidev->subdevices[SUBDEV_AD];
 
 	/* first we test if something unusual has just happened */
 	switch (urb->status) {
@@ -557,7 +557,7 @@ static void usbduxsub_ao_IsocIrq(struct urb *urb)
 	/* the private structure of the subdevice is struct usbduxsub */
 	this_usbduxsub = this_comedidev->private;
 
-	s = this_comedidev->subdevices + SUBDEV_DA;
+	s = &this_comedidev->subdevices[SUBDEV_DA];
 
 	switch (urb->status) {
 	case 0:
@@ -1949,7 +1949,7 @@ static void usbduxsub_pwm_irq(struct urb *urb)
 	/* the private structure of the subdevice is struct usbduxsub */
 	this_usbduxsub = this_comedidev->private;
 
-	s = this_comedidev->subdevices + SUBDEV_DA;
+	s = &this_comedidev->subdevices[SUBDEV_DA];
 
 	switch (urb->status) {
 	case 0:
@@ -2330,7 +2330,7 @@ static int usbduxsigma_attach_common(struct comedi_device *dev,
 	/* private structure is also simply the usb-structure */
 	dev->private = uds;
 	/* the first subdevice is the A/D converter */
-	s = dev->subdevices + SUBDEV_AD;
+	s = &dev->subdevices[SUBDEV_AD];
 	/* the URBs get the comedi subdevice */
 	/* which is responsible for reading */
 	/* this is the subdevice which reads data */
@@ -2357,7 +2357,7 @@ static int usbduxsigma_attach_common(struct comedi_device *dev,
 	/* range table to convert to physical units */
 	s->range_table = (&range_usbdux_ai_range);
 	/* analog output subdevice */
-	s = dev->subdevices + SUBDEV_DA;
+	s = &dev->subdevices[SUBDEV_DA];
 	/* analog out */
 	s->type = COMEDI_SUBD_AO;
 	/* backward pointer */
@@ -2382,7 +2382,7 @@ static int usbduxsigma_attach_common(struct comedi_device *dev,
 	s->insn_read = usbdux_ao_insn_read;
 	s->insn_write = usbdux_ao_insn_write;
 	/* digital I/O subdevice */
-	s = dev->subdevices + SUBDEV_DIO;
+	s = &dev->subdevices[SUBDEV_DIO];
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	/* 8 external and 16 internal channels */
@@ -2395,7 +2395,7 @@ static int usbduxsigma_attach_common(struct comedi_device *dev,
 	s->private = NULL;
 	if (uds->high_speed) {
 		/* timer / pwm subdevice */
-		s = dev->subdevices + SUBDEV_PWM;
+		s = &dev->subdevices[SUBDEV_PWM];
 		s->type = COMEDI_SUBD_PWM;
 		s->subdev_flags = SDF_WRITABLE | SDF_PWM_HBRIDGE;
 		s->n_chan = 8;
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 94010fc..f9fef26 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1119,7 +1119,7 @@ static int vmk80xx_attach_common(struct comedi_device *cdev,
 		return ret;
 	}
 	/* Analog input subdevice */
-	s = cdev->subdevices + VMK80XX_SUBD_AI;
+	s = &cdev->subdevices[VMK80XX_SUBD_AI];
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = dev->board.ai_chans;
@@ -1127,7 +1127,7 @@ static int vmk80xx_attach_common(struct comedi_device *cdev,
 	s->range_table = dev->board.range;
 	s->insn_read = vmk80xx_ai_rinsn;
 	/* Analog output subdevice */
-	s = cdev->subdevices + VMK80XX_SUBD_AO;
+	s = &cdev->subdevices[VMK80XX_SUBD_AO];
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND;
 	s->n_chan = dev->board.ao_chans;
@@ -1139,7 +1139,7 @@ static int vmk80xx_attach_common(struct comedi_device *cdev,
 		s->insn_read = vmk80xx_ao_rinsn;
 	}
 	/* Digital input subdevice */
-	s = cdev->subdevices + VMK80XX_SUBD_DI;
+	s = &cdev->subdevices[VMK80XX_SUBD_DI];
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
 	s->n_chan = dev->board.di_chans;
@@ -1147,7 +1147,7 @@ static int vmk80xx_attach_common(struct comedi_device *cdev,
 	s->insn_read = vmk80xx_di_rinsn;
 	s->insn_bits = vmk80xx_di_bits;
 	/* Digital output subdevice */
-	s = cdev->subdevices + VMK80XX_SUBD_DO;
+	s = &cdev->subdevices[VMK80XX_SUBD_DO];
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITEABLE | SDF_GROUND;
 	s->n_chan = dev->board.do_chans;
@@ -1159,7 +1159,7 @@ static int vmk80xx_attach_common(struct comedi_device *cdev,
 		s->insn_read = vmk80xx_do_rinsn;
 	}
 	/* Counter subdevice */
-	s = cdev->subdevices + VMK80XX_SUBD_CNT;
+	s = &cdev->subdevices[VMK80XX_SUBD_CNT];
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = dev->board.cnt_chans;
@@ -1172,7 +1172,7 @@ static int vmk80xx_attach_common(struct comedi_device *cdev,
 	}
 	/* PWM subdevice */
 	if (dev->board.model == VMK8061_MODEL) {
-		s = cdev->subdevices + VMK80XX_SUBD_PWM;
+		s = &cdev->subdevices[VMK80XX_SUBD_PWM];
 		s->type = COMEDI_SUBD_PWM;
 		s->subdev_flags = SDF_READABLE | SDF_WRITEABLE;
 		s->n_chan = dev->board.pwm_chans;
diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index 0252b44..e97db87 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -90,7 +90,7 @@ static int comedi_do_insn(struct comedi_device *dev, struct comedi_insn *insn)
 		ret = -EINVAL;
 		goto error;
 	}
-	s = dev->subdevices + insn->subdev;
+	s = &dev->subdevices[insn->subdev];
 
 	if (s->type == COMEDI_SUBD_UNUSED) {
 		printk(KERN_ERR "%d not useable subdevice\n", insn->subdev);
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(comedi_find_subdevice_by_type);
 
 int comedi_get_n_channels(struct comedi_device *dev, unsigned int subdevice)
 {
-	struct comedi_subdevice *s = dev->subdevices + subdevice;
+	struct comedi_subdevice *s = &dev->subdevices[subdevice];
 
 	return s->n_chan;
 }
diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index 41f9523..4438230 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -68,7 +68,7 @@ int do_rangeinfo_ioctl(struct comedi_device *dev,
 		return -EINVAL;
 	if (subd >= dev->n_subdevices)
 		return -EINVAL;
-	s = dev->subdevices + subd;
+	s = &dev->subdevices[subd];
 	if (s->range_table) {
 		lr = s->range_table;
 	} else if (s->range_table_list) {
-- 
1.7.11

