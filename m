Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2FLS5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:57:15 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:47183 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2FLS5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:57:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1339527386!7796892!66
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] staging: comedi: add namespace to comedi's alloc_subdevices() function
Date: Tue, 12 Jun 2012 11:56:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121156.58648.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b228715e26f87e42c459733a03f116a04c4c382e Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 09:35:28 -0700
Subject: [PATCH 1/8] staging: comedi: add namespace to comedi's
 alloc_subdevices() function

Move the inline alloc_subdevices() function from comedidev.h to
drivers.c and rename it to comedi_alloc_subdevices(). The function
is large enough to warrant being an exported symbol rather than
being an inline in every driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedidev.h                 |   22 +------------------
 drivers/staging/comedi/drivers.c                   |   21 +++++++++++++++++++
 drivers/staging/comedi/drivers/8255.c              |    2 +-
 drivers/staging/comedi/drivers/acl7225b.c          |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |    2 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci7230.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci7296.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci7432.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    2 +-
 drivers/staging/comedi/drivers/adq12b.c            |    2 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    2 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |    2 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    2 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    2 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |    2 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |    3 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |    2 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    2 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    2 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |    2 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    2 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |    2 +-
 drivers/staging/comedi/drivers/das08.c             |    2 +-
 drivers/staging/comedi/drivers/das16.c             |    2 +-
 drivers/staging/comedi/drivers/das16m1.c           |    2 +-
 drivers/staging/comedi/drivers/das1800.c           |    2 +-
 drivers/staging/comedi/drivers/das6402.c           |    2 +-
 drivers/staging/comedi/drivers/das800.c            |    2 +-
 drivers/staging/comedi/drivers/dmm32at.c           |    2 +-
 drivers/staging/comedi/drivers/dt2801.c            |    2 +-
 drivers/staging/comedi/drivers/dt2811.c            |    2 +-
 drivers/staging/comedi/drivers/dt2814.c            |    2 +-
 drivers/staging/comedi/drivers/dt2815.c            |    2 +-
 drivers/staging/comedi/drivers/dt2817.c            |    2 +-
 drivers/staging/comedi/drivers/dt282x.c            |    2 +-
 drivers/staging/comedi/drivers/dt3000.c            |    2 +-
 drivers/staging/comedi/drivers/dt9812.c            |    2 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    2 +-
 drivers/staging/comedi/drivers/fl512.c             |    2 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |    2 +-
 drivers/staging/comedi/drivers/icp_multi.c         |    2 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |    2 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    2 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |    2 +-
 drivers/staging/comedi/drivers/me_daq.c            |    2 +-
 drivers/staging/comedi/drivers/mpc624.c            |    2 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        |    2 +-
 drivers/staging/comedi/drivers/multiq3.c           |    2 +-
 drivers/staging/comedi/drivers/ni_6527.c           |    2 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_670x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    2 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |    2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    2 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |    2 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    2 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    2 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |    2 +-
 drivers/staging/comedi/drivers/pcl711.c            |    2 +-
 drivers/staging/comedi/drivers/pcl724.c            |    2 +-
 drivers/staging/comedi/drivers/pcl725.c            |    2 +-
 drivers/staging/comedi/drivers/pcl726.c            |    2 +-
 drivers/staging/comedi/drivers/pcl730.c            |    2 +-
 drivers/staging/comedi/drivers/pcl812.c            |    2 +-
 drivers/staging/comedi/drivers/pcl816.c            |    2 +-
 drivers/staging/comedi/drivers/pcl818.c            |    2 +-
 drivers/staging/comedi/drivers/pcm3724.c           |    2 +-
 drivers/staging/comedi/drivers/pcm3730.c           |    2 +-
 drivers/staging/comedi/drivers/pcmad.c             |    2 +-
 drivers/staging/comedi/drivers/pcmda12.c           |    2 +-
 drivers/staging/comedi/drivers/pcmmio.c            |    2 +-
 drivers/staging/comedi/drivers/pcmuio.c            |    2 +-
 drivers/staging/comedi/drivers/poc.c               |    2 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    2 +-
 drivers/staging/comedi/drivers/rtd520.c            |    2 +-
 drivers/staging/comedi/drivers/rti800.c            |    2 +-
 drivers/staging/comedi/drivers/rti802.c            |    2 +-
 drivers/staging/comedi/drivers/s526.c              |    2 +-
 drivers/staging/comedi/drivers/s626.c              |    2 +-
 drivers/staging/comedi/drivers/serial2002.c        |    2 +-
 drivers/staging/comedi/drivers/skel.c              |    2 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |    2 +-
 drivers/staging/comedi/drivers/unioxx5.c           |    2 +-
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    2 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |    2 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |    2 +-
 105 files changed, 127 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 9cd2b51..bb98f82 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -292,6 +292,8 @@ static inline struct comedi_subdevice *comedi_get_write_subdevice(
 	return info->device->write_subdev;
 }
 
+int comedi_alloc_subdevices(struct comedi_device *, unsigned int);
+
 void comedi_device_detach(struct comedi_device *dev);
 int comedi_device_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
@@ -413,26 +415,6 @@ struct comedi_lrange {
 
 /* some silly little inline functions */
 
-static inline int alloc_subdevices(struct comedi_device *dev,
-				   unsigned int num_subdevices)
-{
-	unsigned i;
-
-	dev->n_subdevices = num_subdevices;
-	dev->subdevices =
-	    kcalloc(num_subdevices, sizeof(struct comedi_subdevice),
-		    GFP_KERNEL);
-	if (!dev->subdevices)
-		return -ENOMEM;
-	for (i = 0; i < num_subdevices; ++i) {
-		dev->subdevices[i].device = dev;
-		dev->subdevices[i].async_dma_dir = DMA_NONE;
-		spin_lock_init(&dev->subdevices[i].spin_lock);
-		dev->subdevices[i].minor = -1;
-	}
-	return 0;
-}
-
 static inline int alloc_private(struct comedi_device *dev, int size)
 {
 	dev->private = kzalloc(size, GFP_KERNEL);
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 9d2b206..cce7521 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -56,6 +56,27 @@ static int poll_invalid(struct comedi_device *dev, struct comedi_subdevice *s);
 
 struct comedi_driver *comedi_drivers;
 
+int comedi_alloc_subdevices(struct comedi_device *dev,
+			    unsigned int num_subdevices)
+{
+	unsigned i;
+
+	dev->n_subdevices = num_subdevices;
+	dev->subdevices =
+	    kcalloc(num_subdevices, sizeof(struct comedi_subdevice),
+		    GFP_KERNEL);
+	if (!dev->subdevices)
+		return -ENOMEM;
+	for (i = 0; i < num_subdevices; ++i) {
+		dev->subdevices[i].device = dev;
+		dev->subdevices[i].async_dma_dir = DMA_NONE;
+		spin_lock_init(&dev->subdevices[i].spin_lock);
+		dev->subdevices[i].minor = -1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(comedi_alloc_subdevices);
+
 static void cleanup_device(struct comedi_device *dev)
 {
 	int i;
diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 27e39e4..875b020 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -388,7 +388,7 @@ static int dev_8255_attach(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	ret = alloc_subdevices(dev, i);
+	ret = comedi_alloc_subdevices(dev, i);
 	if (ret < 0) {
 		/* FIXME this printk call should give a proper message, the
 		 * below line just maintains previous functionality */
diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index c1963ad..3c39148 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -82,7 +82,7 @@ static int acl7225b_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 44aaf83..274990a 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -1688,7 +1688,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	} else {
 		/* Update-0.7.57->0.7.68dev->n_subdevices = 7; */
 		n_subdevices = 7;
-		ret = alloc_subdevices(dev, n_subdevices);
+		ret = comedi_alloc_subdevices(dev, n_subdevices);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index a76ed25..9632ca1 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -63,7 +63,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	int n_subdevices = 9;
 
 	/* Update-0.7.57->0.7.68dev->n_subdevices = 9; */
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return;
 
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 2f48dc7..7d26d45 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -301,7 +301,7 @@ static int pci6208_attach(struct comedi_device *dev,
 	dev->iobase = io_base;
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 2c83492..5a6e6c1 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -116,7 +116,7 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7230_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	devpriv->pci_dev = adl_pci7230_find_pci(dev, it);
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 0b8b279..fd9b33a 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -92,7 +92,7 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7296_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	devpriv->pci_dev = adl_pci7296_find_pci(dev, it);
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index dd818f1..4976a70 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -125,7 +125,7 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7432_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	devpriv->pci_dev = adl_pci7432_find_pci(dev, it);
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 3447548..78169f7 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -261,7 +261,7 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci8164_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	devpriv->pci_dev = adl_pci8164_find_pci(dev, it);
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 410bbf9..cc17946 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1317,7 +1317,7 @@ static int pci9111_attach(struct comedi_device *dev,
 
 	/*  TODO: Add external multiplexer setup (according to option[2]). */
 
-	error = alloc_subdevices(dev, 4);
+	error = comedi_alloc_subdevices(dev, 4);
 	if (error < 0)
 		return error;
 
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 3670ebd..5099841 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -2268,7 +2268,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	pci_write_config_word(devpriv->pcidev, PCI_COMMAND, u16w | 64);
 				/* Enable parity check for parity error */
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 1da2989..ca8892e 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -271,7 +271,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the subdevice structures.  alloc_subdevice() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index db9f0a5..be3fc4d 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1433,7 +1433,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	if (this_board->n_counter)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index b8768b5..0aa0af4 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -365,7 +365,7 @@ static int pci1723_attach(struct comedi_device *dev,
 	if (this_board->n_diochan)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0) {
 		printk(" - Allocation failed!\n");
 		return ret;
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index df8236c..0fc4f85 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1156,7 +1156,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 				n_subdevices++;
 	}
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index d215ae1..60466c8 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -182,7 +182,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct aio12_8_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	s = &dev->subdevices[0];
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 5c1548b..7d161d6 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -124,7 +124,7 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct aio_iiro_16_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 3afebb2..d7d056e 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1273,7 +1273,7 @@ static int dio200_common_attach(struct comedi_device *dev, unsigned long iobase,
 	devpriv->intr_sd = -1;
 	dev->iobase = iobase;
 	dev->board_name = thisboard->name;
-	ret = alloc_subdevices(dev, layout->n_subdevs);
+	ret = comedi_alloc_subdevices(dev, layout->n_subdevs);
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 9cf514e..522e1c0 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -455,7 +455,7 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 	dev->board_name = thisboard->name;
 	dev->iobase = iobase;
 
-	ret = alloc_subdevices(dev, 2);
+	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 7020907..cfb69fa 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -227,7 +227,7 @@ static int pc263_common_attach(struct comedi_device *dev, unsigned long iobase)
 	dev->board_name = thisboard->name;
 	dev->iobase = iobase;
 
-	ret = alloc_subdevices(dev, 1);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 43f07f8..848fab2 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1383,7 +1383,7 @@ static int pci224_attach_common(struct comedi_device *dev,
 	     dev->iobase + PCI224_DACCON);
 
 	/* Allocate subdevices.  There is only one!  */
-	ret = alloc_subdevices(dev, 1);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 30487be..03c83e4 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2844,7 +2844,7 @@ static int pci230_attach_common(struct comedi_device *dev,
 	 * Allocate the subdevice structures.  alloc_subdevice() is a
 	 * convenient macro defined in comedidev.h.
 	 */
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index fb9951a..72b000f 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -433,7 +433,8 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	dev->board_name = "c6xdigio";
 
-	result = alloc_subdevices(dev, 2);	/*  3 with encoder_init write */
+	/* 3 subdevices with encoder_init write */
+	result = comedi_alloc_subdevices(dev, 2);
 	if (result < 0)
 		return result;
 
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 3515923..9aa11c1 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -195,7 +195,7 @@ static int das16cs_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 074feee..435f3aa 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -617,7 +617,7 @@ found:
 /*
  * Allocate the subdevice structures.
  */
-	if (alloc_subdevices(dev, 7) < 0)
+	if (comedi_alloc_subdevices(dev, 7) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 5bcadcb..6b2f153 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1345,7 +1345,7 @@ static int setup_subdevices(struct comedi_device *dev)
 	void __iomem *dio_8255_iobase;
 	int i;
 
-	if (alloc_subdevices(dev, 10) < 0)
+	if (comedi_alloc_subdevices(dev, 10) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index dc4cf0b..4ab3584 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -336,7 +336,7 @@ found:
 /*
  * Allocate the subdevice structures.
  */
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 58d5a3d..56c1d09 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -181,7 +181,7 @@ found:
  * Allocate the subdevice structures.  alloc_subdevice() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_subdevices(dev, thisboard->n_8255) < 0)
+	if (comedi_alloc_subdevices(dev, thisboard->n_8255) < 0)
 		return -ENOMEM;
 
 	for (i = 0; i < thisboard->n_8255; i++) {
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index a06b67a..6acb319 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -273,7 +273,7 @@ found:
  * Allocate the subdevice structures.  alloc_subdevice() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index bec250b..abb6008 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -240,7 +240,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the subdevice structures.  alloc_subdevice() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 29412de..d56eec4 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -362,7 +362,7 @@ static int bonding_attach(struct comedi_device *dev,
 	 * Allocate the subdevice structures.  alloc_subdevice() is a
 	 * convenient macro defined in comedidev.h.
 	 */
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index bff5dcd..c9a725f 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -315,7 +315,7 @@ static int parport_attach(struct comedi_device *dev,
 	}
 	dev->board_name = "parport";
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 	ret = alloc_private(dev, sizeof(struct parport_private));
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 9f3c3d5..cd43c0d 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -448,7 +448,7 @@ static int waveform_attach(struct comedi_device *dev,
 	devpriv->usec_period = period;
 
 	dev->n_subdevices = 2;
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
+	if (comedi_alloc_subdevices(dev, dev->n_subdevices) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 2cd7407..a5bad1b 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -115,7 +115,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct contec_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	for_each_pci_dev(pcidev) {
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index d84794c..dbd0472 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -772,7 +772,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
 
-	result = alloc_subdevices(dev, 3);
+	result = comedi_alloc_subdevices(dev, 3);
 	if (result < 0)
 		goto out;
 
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index f99f72b..1dea21a 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -834,7 +834,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 
 	dev->board_name = thisboard->name;
 
-	ret = alloc_subdevices(dev, 6);
+	ret = comedi_alloc_subdevices(dev, 6);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 6170536..6a8a7eb 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1264,7 +1264,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	devpriv->timer_mode = timer_mode ? 1 : 0;
 
-	ret = alloc_subdevices(dev, 5);
+	ret = comedi_alloc_subdevices(dev, 5);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index e468ff1..eafd6b5 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -646,7 +646,7 @@ static int das16m1_attach(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 079fb06..12d736a 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1644,7 +1644,7 @@ static int das1800_attach(struct comedi_device *dev,
 			return -ENOMEM;
 	}
 
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 881f392..2039b6c 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -307,7 +307,7 @@ static int das6402_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	ret = alloc_subdevices(dev, 1);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 4e33b2a..6263f53 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -510,7 +510,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 5be99b5..40d7bef 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -375,7 +375,7 @@ static int dmm32at_attach(struct comedi_device *dev,
  * Allocate the subdevice structures.  alloc_subdevice() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 625bd61..35ce076 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -628,7 +628,7 @@ havetype:
 	n_ai_chans = probe_number_of_ai_chans(dev);
 	printk(" (ai channels = %d)", n_ai_chans);
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		goto out;
 
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 727da9e..6ff610d 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -465,7 +465,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 #endif
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index fa4ade6..876d5cb 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -338,7 +338,7 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 	}
 
-	ret = alloc_subdevices(dev, 1);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index bbab712..33ad1fa 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -177,7 +177,7 @@ static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->board_name = "dt2815";
 
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 	if (alloc_private(dev, sizeof(struct dt2815_private)) < 0)
 		return -ENOMEM;
diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index 1ee10e7b..665db07 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -137,7 +137,7 @@ static int dt2817_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->board_name = "dt2817";
 
-	ret = alloc_subdevices(dev, 1);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index eefda3c..f11d1fd 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -1268,7 +1268,7 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	ret = alloc_subdevices(dev, 3);
+	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index af02024..10415b2 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -882,7 +882,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->irq = devpriv->pci_dev->irq;
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 22cda5c..56af2f2 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -1036,7 +1036,7 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->serial = it->options[0];
 
 	/* Allocate subdevices */
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	/* digital input subdevice */
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 367a7c8..6f6fb52 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -329,7 +329,7 @@ found:
 	devpriv->BADR4 = pci_resource_start(pcidev, 4);
 	devpriv->BADR5 = pci_resource_start(pcidev, 5);
 
-	if (alloc_subdevices(dev, 4) < 0) {
+	if (comedi_alloc_subdevices(dev, 4) < 0) {
 		printk(KERN_ERR "comedi: dyna_pci10xx: "
 			"failed allocating subdevices\n");
 		mutex_unlock(&start_stop_sem);
diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index d2381445..7218a9b 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -131,7 +131,7 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_DEBUG "malloc ok\n");
 #endif
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	/*
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index fe1fd2f..b103cfb 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -431,7 +431,7 @@ static int setup_subdevices(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
 
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 1f254f4..06c66af 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -903,7 +903,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 	if (this_board->n_ctrs)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 6f69476..9c11657 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -202,7 +202,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	union pci20xxx_subdev_private *sdp;
 
-	ret = alloc_subdevices(dev, 1 + PCI20000_MODULES);
+	ret = comedi_alloc_subdevices(dev, 1 + PCI20000_MODULES);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index e8dfc36..182643b 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -826,7 +826,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	if (!devpriv->iobase)
 		return -ENOMEM;
 
-	result = alloc_subdevices(dev, devpriv->n_channels);
+	result = comedi_alloc_subdevices(dev, devpriv->n_channels);
 	if (result < 0)
 		goto out;
 
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 9f92420..bcb1eb4 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -190,7 +190,7 @@ found:
 	dev->iobase = io_base;
 
 	/* allocate the subdevice structures */
-	error = alloc_subdevices(dev, 1);
+	error = comedi_alloc_subdevices(dev, 1);
 	if (error < 0)
 		return error;
 
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index cb6bf8c..8d011cb 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -2195,7 +2195,7 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * convenient macro defined in comedidev.h.  It relies on
 	 * n_subdevices being set correctly.
 	 */
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
     /*=========================================================================
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index fcadb0f..231b294 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -762,7 +762,7 @@ found:
 	me_reset(dev);
 
 	/* device driver capabilities */
-	error = alloc_subdevices(dev, 3);
+	error = comedi_alloc_subdevices(dev, 3);
 	if (error < 0)
 		return error;
 
diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index 4304e86..48ba6b9 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -349,7 +349,7 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/*  Subdevices structures */
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index 364470e4..1311051 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -131,7 +131,7 @@ static int mpc8260cpm_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct mpc8260cpm_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	for (i = 0; i < 4; i++) {
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index e951e73..00d497c 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -255,7 +255,7 @@ static int multiq3_attach(struct comedi_device *dev,
 	else
 		printk(KERN_WARNING "comedi%d: no irq\n", dev->minor);
 	dev->board_name = "multiq3";
-	result = alloc_subdevices(dev, 5);
+	result = comedi_alloc_subdevices(dev, 5);
 	if (result < 0)
 		return result;
 
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index b02aa0e..89fee6f 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -397,7 +397,7 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_INFO "comedi board: %s, ID=0x%02x\n", dev->board_name,
 		readb(devpriv->mite->daq_io_addr + ID_Register));
 
-	ret = alloc_subdevices(dev, 3);
+	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 0d27a93..a49dcea 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -678,7 +678,7 @@ static int ni_65xx_attach(struct comedi_device *dev,
 	printk(KERN_INFO " ID=0x%02x",
 	       readb(private(dev)->mite->daq_io_addr + ID_Register));
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 8c40730..5827deb 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1095,7 +1095,7 @@ static int ni_660x_attach(struct comedi_device *dev,
 
 	dev->n_subdevices = 2 + NI_660X_MAX_NUM_COUNTERS;
 
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
+	if (comedi_alloc_subdevices(dev, dev->n_subdevices) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index a9cf94f..45a03e6 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -202,7 +202,7 @@ static int ni_670x_attach(struct comedi_device *dev,
 	dev->irq = mite_irq(devpriv->mite);
 	printk(KERN_INFO " %s", dev->board_name);
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index ae896a0..9d1a0f7 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -826,7 +826,7 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_ptr = a2150_boards + a2150_probe(dev);
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index bfe7fb7..03a4d73 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -356,7 +356,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct atao_private)) < 0)
 		return -ENOMEM;
 
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index a0890ee..37ff6fc 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -709,7 +709,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 	dev->board_name = board->name;
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 75764e8..8860207 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -409,7 +409,7 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	/* DAQCard-700 dio */
diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 493a227..36c0c62 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -158,7 +158,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	/* 8255 dio */
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 5334977..825b162 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -622,7 +622,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 5) < 0)
+	if (comedi_alloc_subdevices(dev, 5) < 0)
 		return -ENOMEM;
 
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index fd232bc..4261e92 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -4412,7 +4412,7 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EINVAL;
 	}
 
-	if (alloc_subdevices(dev, NI_NUM_SUBDEVICES) < 0)
+	if (comedi_alloc_subdevices(dev, NI_NUM_SUBDEVICES) < 0)
 		return -ENOMEM;
 
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 37b7008..77ef312 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -1248,7 +1248,7 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	else
 		n_subdevices = 1;
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index e943b52..35b9510 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -518,7 +518,7 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->irq = irq;
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 4136a03..698c900 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -156,7 +156,7 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					 || (it->options[1] == 96)))
 		n_subdevices = 4;	/*  PCL-724 in 96 DIO configuration */
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index 83a6fa5..d7ba336 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -63,7 +63,7 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 2) < 0)
+	if (comedi_alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index e9449bb..e756a30 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -292,7 +292,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk("\n");
 
-	ret = alloc_subdevices(dev, 3);
+	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index 02a4386..e258bce 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -85,7 +85,7 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 28780ed..128f5b6 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1382,7 +1382,7 @@ no_dma:
 	if (board->n_dochan > 0)
 		n_subdevices++;
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0) {
 		free_resources(dev);
 		return ret;
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 277a23e..9d2d093 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -1194,7 +1194,7 @@ no_dma:
     subdevs[3] = COMEDI_SUBD_DO;
 */
 
-	ret = alloc_subdevices(dev, 1);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 6c84b29..a4c2870 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1778,7 +1778,7 @@ no_rtc:
 
 no_dma:
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 9eee708..d755b40 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -258,7 +258,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 
 	n_subdevices = board->numofports;
 
-	ret = alloc_subdevices(dev, n_subdevices);
+	ret = comedi_alloc_subdevices(dev, n_subdevices);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index f8d1c64..48a21bd 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -71,7 +71,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 	dev->iobase = dev->iobase;
 	dev->irq = 0;
 
-	if (alloc_subdevices(dev, 6) < 0)
+	if (comedi_alloc_subdevices(dev, 6) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 2ec0b2e..00b0f2a 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -117,7 +117,7 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_CONT "\n");
 	dev->iobase = iobase;
 
-	ret = alloc_subdevices(dev, 1);
+	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index f49c66a..3645e9e 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -197,7 +197,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
 	 * 96-channel version of the board.
 	 */
-	if (alloc_subdevices(dev, 1) < 0) {
+	if (comedi_alloc_subdevices(dev, 1) < 0) {
 		printk(KERN_ERR "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index c4482ae..67fdac5 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1077,7 +1077,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 *
 	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
 	 */
-	if (alloc_subdevices(dev, n_subdevs) < 0) {
+	if (comedi_alloc_subdevices(dev, n_subdevs) < 0) {
 		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
 				dev->minor);
 		return -ENOMEM;
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index b1a9bed..ce5068e 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -807,7 +807,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
 	 * 96-channel version of the board.
 	 */
-	if (alloc_subdevices(dev, n_subdevs) < 0) {
+	if (comedi_alloc_subdevices(dev, n_subdevs) < 0) {
 		dev_dbg(dev->hw_dev, "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 95e348f..1e954f9 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -160,7 +160,7 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 	if (alloc_private(dev, sizeof(unsigned int) * board->n_chan) < 0)
 		return -ENOMEM;
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 2f130b3..38a13ba 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -871,7 +871,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->iobase = local->link->resource[0]->start;
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 84b28b6..7d248a7 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -2003,7 +2003,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate the subdevice structures.  alloc_subdevice() is a
 	 * convenient macro defined in comedidev.h.
 	 */
-	if (alloc_subdevices(dev, 4) < 0)
+	if (comedi_alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
 
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 04a2368..a80f630 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -348,7 +348,7 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = board->name;
 
-	ret = alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index 09da5c2..1aacf3f 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -103,7 +103,7 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = "rti802";
 
-	if (alloc_subdevices(dev, 1) < 0
+	if (comedi_alloc_subdevices(dev, 1) < 0
 	    || alloc_private(dev, sizeof(struct rti802_private))) {
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 3c8e979..17d581b 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -779,7 +779,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	dev->n_subdevices = 4;
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
+	if (comedi_alloc_subdevices(dev, dev->n_subdevices) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d6dc338..f2eeca5 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -595,7 +595,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_ptr = s626_boards;
 	dev->board_name = thisboard->name;
 
-	if (alloc_subdevices(dev, 6) < 0)
+	if (comedi_alloc_subdevices(dev, 6) < 0)
 		return -ENOMEM;
 
 	dev->iobase = (unsigned long)devpriv->base_addr;
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 9200310..53ebb5d 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -792,7 +792,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	dev_dbg(dev->hw_dev, "/dev/ttyS%d @ %d\n", devpriv->port,
 		devpriv->speed);
 
-	if (alloc_subdevices(dev, 5) < 0)
+	if (comedi_alloc_subdevices(dev, 5) < 0)
 		return -ENOMEM;
 
 	/* digital input subdevice */
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 7d13ffa..16947c8 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -237,7 +237,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * Allocate the subdevice structures.  alloc_subdevice() is a
  * convenient macro defined in comedidev.h.
  */
-	if (alloc_subdevices(dev, 3) < 0)
+	if (comedi_alloc_subdevices(dev, 3) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index de58095..5eaef84 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -200,7 +200,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* Allocate the subdevice structures. alloc_subdevice() is a         */
 	/* convenient macro defined in comedidev.h.                          */
 
-	if (alloc_subdevices(dev, 1) < 0)
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index d5f1f22..170bc48 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -468,7 +468,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 		return -1;
 	}
 
-	if (alloc_subdevices(dev, n_subd) < 0) {
+	if (comedi_alloc_subdevices(dev, n_subd) < 0) {
 		printk(KERN_ERR "out of memory\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 13d9fd3..ca8b3e1 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2645,7 +2645,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	}
 
 	/* allocate space for the subdevices */
-	ret = alloc_subdevices(dev, dev->n_subdevices);
+	ret = comedi_alloc_subdevices(dev, dev->n_subdevices);
 	if (ret < 0) {
 		dev_err(&udev->interface->dev,
 			"comedi%d: error alloc space for subdev\n", dev->minor);
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 7b1d21a..b2f7350 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1675,7 +1675,7 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	dev->n_subdevices = N_SUBDEVICES;
 
 	/* allocate space for the subdevices */
-	ret = alloc_subdevices(dev, N_SUBDEVICES);
+	ret = comedi_alloc_subdevices(dev, N_SUBDEVICES);
 	if (ret < 0) {
 		printk(KERN_ERR "comedi%d: usbduxfast: error alloc space for "
 		       "subdev\n", dev->minor);
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 441ccef..00faf4a 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2690,7 +2690,7 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	}
 
 	/* allocate space for the subdevices */
-	ret = alloc_subdevices(dev, dev->n_subdevices);
+	ret = comedi_alloc_subdevices(dev, dev->n_subdevices);
 	if (ret < 0) {
 		dev_err(&udev->interface->dev,
 			"comedi%d: no space for subdev\n", dev->minor);
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index baee8d7..5a3e33d 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1159,7 +1159,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	else
 		n_subd = 6;
 
-	if (alloc_subdevices(cdev, n_subd) < 0) {
+	if (comedi_alloc_subdevices(cdev, n_subd) < 0) {
 		up(&dev->limit_sem);
 		mutex_unlock(&glb_mutex);
 		return -ENOMEM;
-- 
1.7.7

