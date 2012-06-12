Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2FLS7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:59:54 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:60005 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2FLS7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:59:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1339527580!19060119!18
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] staging: comedi: propogate error code from comedi_alloc_subdevices
Date: Tue, 12 Jun 2012 11:59:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121159.33654.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8c5ac55523759196d4751a7ee3b37b56a9cc210c Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 11:22:30 -0700
Subject: [PATCH 7/8] staging: comedi: propogate error code from
 comedi_alloc_subdevices

comedi_alloc_subdevices can fail with -EINVAL or -ENOMEM. When it
does fail make sure to pass the proper error code back.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c              |    2 +-
 drivers/staging/comedi/drivers/acl7225b.c          |    6 ++++--
 .../staging/comedi/drivers/addi-data/addi_common.c |    2 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |    5 +++--
 drivers/staging/comedi/drivers/adl_pci7230.c       |    6 ++++--
 drivers/staging/comedi/drivers/adl_pci7296.c       |    5 +++--
 drivers/staging/comedi/drivers/adl_pci7432.c       |    6 ++++--
 drivers/staging/comedi/drivers/adl_pci8164.c       |    6 ++++--
 drivers/staging/comedi/drivers/adl_pci9111.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    2 +-
 drivers/staging/comedi/drivers/adq12b.c            |    6 ++++--
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    2 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |    6 ++++--
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    6 ++++--
 drivers/staging/comedi/drivers/amplc_dio200.c      |    4 +++-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    2 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |    2 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    6 ++++--
 drivers/staging/comedi/drivers/c6xdigio.c          |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    5 +++--
 drivers/staging/comedi/drivers/cb_pcidas.c         |    6 ++++--
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    6 ++++--
 drivers/staging/comedi/drivers/cb_pcidda.c         |    7 ++++---
 drivers/staging/comedi/drivers/cb_pcidio.c         |    6 ++++--
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    6 ++++--
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    5 +++--
 drivers/staging/comedi/drivers/comedi_bond.c       |    6 ++++--
 drivers/staging/comedi/drivers/comedi_parport.c    |    3 ++-
 drivers/staging/comedi/drivers/comedi_test.c       |    6 ++++--
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    6 ++++--
 drivers/staging/comedi/drivers/daqboard2000.c      |    4 ++--
 drivers/staging/comedi/drivers/das08.c             |    2 +-
 drivers/staging/comedi/drivers/das16.c             |    2 +-
 drivers/staging/comedi/drivers/das16m1.c           |    2 +-
 drivers/staging/comedi/drivers/das1800.c           |    5 +++--
 drivers/staging/comedi/drivers/das6402.c           |    2 +-
 drivers/staging/comedi/drivers/das800.c            |    6 ++++--
 drivers/staging/comedi/drivers/dmm32at.c           |    5 +++--
 drivers/staging/comedi/drivers/dt2801.c            |    8 +++-----
 drivers/staging/comedi/drivers/dt2811.c            |    2 +-
 drivers/staging/comedi/drivers/dt2814.c            |    2 +-
 drivers/staging/comedi/drivers/dt2815.c            |    7 +++++--
 drivers/staging/comedi/drivers/dt2817.c            |    2 +-
 drivers/staging/comedi/drivers/dt282x.c            |    2 +-
 drivers/staging/comedi/drivers/dt3000.c            |    2 +-
 drivers/staging/comedi/drivers/dt9812.c            |    6 ++++--
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    6 ++++--
 drivers/staging/comedi/drivers/fl512.c             |    6 ++++--
 drivers/staging/comedi/drivers/gsc_hpdi.c          |    6 ++++--
 drivers/staging/comedi/drivers/icp_multi.c         |    2 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |    2 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    4 ++--
 drivers/staging/comedi/drivers/ke_counter.c        |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |    5 +++--
 drivers/staging/comedi/drivers/me_daq.c            |    3 +--
 drivers/staging/comedi/drivers/mpc624.c            |    6 ++++--
 drivers/staging/comedi/drivers/mpc8260cpm.c        |    6 ++++--
 drivers/staging/comedi/drivers/multiq3.c           |    3 ++-
 drivers/staging/comedi/drivers/ni_6527.c           |    2 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    2 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    5 +++--
 drivers/staging/comedi/drivers/ni_670x.c           |    5 +++--
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    6 ++++--
 drivers/staging/comedi/drivers/ni_at_ao.c          |    6 ++++--
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    2 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |    6 ++++--
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    6 ++++--
 drivers/staging/comedi/drivers/ni_labpc.c          |    6 ++++--
 drivers/staging/comedi/drivers/ni_mio_common.c     |    6 ++++--
 drivers/staging/comedi/drivers/ni_pcidio.c         |    2 +-
 drivers/staging/comedi/drivers/pcl711.c            |    2 +-
 drivers/staging/comedi/drivers/pcl724.c            |    2 +-
 drivers/staging/comedi/drivers/pcl725.c            |    6 ++++--
 drivers/staging/comedi/drivers/pcl726.c            |    2 +-
 drivers/staging/comedi/drivers/pcl730.c            |    6 ++++--
 drivers/staging/comedi/drivers/pcl812.c            |    2 +-
 drivers/staging/comedi/drivers/pcl816.c            |    2 +-
 drivers/staging/comedi/drivers/pcl818.c            |    2 +-
 drivers/staging/comedi/drivers/pcm3724.c           |    2 +-
 drivers/staging/comedi/drivers/pcm3730.c           |    6 ++++--
 drivers/staging/comedi/drivers/pcmad.c             |    2 +-
 drivers/staging/comedi/drivers/pcmda12.c           |    6 ++++--
 drivers/staging/comedi/drivers/pcmmio.c            |    6 ++++--
 drivers/staging/comedi/drivers/pcmuio.c            |    6 ++++--
 drivers/staging/comedi/drivers/poc.c               |    7 +++++--
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    2 +-
 drivers/staging/comedi/drivers/rtd520.c            |    6 +++---
 drivers/staging/comedi/drivers/rti800.c            |    2 +-
 drivers/staging/comedi/drivers/rti802.c            |    9 ++++++---
 drivers/staging/comedi/drivers/s526.c              |    6 ++++--
 drivers/staging/comedi/drivers/s626.c              |    5 +++--
 drivers/staging/comedi/drivers/serial2002.c        |    6 ++++--
 drivers/staging/comedi/drivers/skel.c              |    6 ++++--
 drivers/staging/comedi/drivers/ssv_dnp.c           |    6 ++++--
 drivers/staging/comedi/drivers/unioxx5.c           |    6 ++++--
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    2 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |    2 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |    6 ++++--
 103 files changed, 269 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 64b0054..502bde8 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -389,7 +389,7 @@ static int dev_8255_attach(struct comedi_device *dev,
 	}
 
 	ret = comedi_alloc_subdevices(dev, i);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	printk(KERN_INFO "comedi%d: 8255:", dev->minor);
diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index 3c39148..0bf5525 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -68,6 +68,7 @@ static int acl7225b_attach(struct comedi_device *dev,
 	const struct boardtype *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int iobase, iorange;
+	int ret;
 
 	iobase = it->options[0];
 	iorange = board->io_range;
@@ -82,8 +83,9 @@ static int acl7225b_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* Relays outputs */
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 46c590b..a5aa673 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -1688,7 +1688,7 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	} else {
 		n_subdevices = 7;
 		ret = comedi_alloc_subdevices(dev, n_subdevices);
-		if (ret < 0)
+		if (ret)
 			return ret;
 
 		/*  Allocate and Initialise AI Subdevice Structures */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index aa390b0..595238f 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -63,7 +63,7 @@ void i_ADDI_AttachPCI1710(struct comedi_device *dev)
 	int n_subdevices = 9;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return;
 
 	/*  Allocate and Initialise Timer Subdevice Structures */
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 7d26d45..98b3730 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -301,8 +301,9 @@ static int pci6208_attach(struct comedi_device *dev,
 	dev->iobase = io_base;
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	retval = comedi_alloc_subdevices(dev, 2);
+	if (retval)
+		return retval;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 5a6e6c1..62fdf7f 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -108,6 +108,7 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: adl_pci7230\n", dev->minor);
 
@@ -116,8 +117,9 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7230_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci7230_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index fd9b33a..58deb60 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -92,8 +92,9 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7296_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci7296_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index 4976a70..aabf418 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -117,6 +117,7 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: attach adl_pci7432\n", dev->minor);
 
@@ -125,8 +126,9 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci7432_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci7432_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 78169f7..1811375 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -252,6 +252,7 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi: attempt to attach...\n");
 	printk(KERN_INFO "comedi%d: adl_pci8164\n", dev->minor);
@@ -261,8 +262,9 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct adl_pci8164_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	devpriv->pci_dev = adl_pci8164_find_pci(dev, it);
 	if (!devpriv->pci_dev)
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index cc17946..4f2cea8 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1318,7 +1318,7 @@ static int pci9111_attach(struct comedi_device *dev,
 	/*  TODO: Add external multiplexer setup (according to option[2]). */
 
 	error = comedi_alloc_subdevices(dev, 4);
-	if (error < 0)
+	if (error)
 		return error;
 
 	subdevice = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 5099841..e1958e3 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -2269,7 +2269,7 @@ static int pci9118_attach(struct comedi_device *dev,
 				/* Enable parity check for parity error */
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index afc6815..f7bb145 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -224,6 +224,7 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int unipolar, differential;
+	int ret;
 
 	iobase = it->options[0];
 	unipolar = it->options[1];
@@ -267,8 +268,9 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->last_channel = -1;
 	devpriv->last_range = -1;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index be3fc4d..60a50ad 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1434,7 +1434,7 @@ static int pci1710_attach(struct comedi_device *dev,
 		n_subdevices++;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	pci1710_reset(dev);
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index c14ad35..d37c14d 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -366,7 +366,7 @@ static int pci1723_attach(struct comedi_device *dev,
 		n_subdevices++;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	pci1723_reset(dev);
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 0fc4f85..942dc77 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1157,7 +1157,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	subdev = 0;
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index 60466c8..f7d453f 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -168,6 +168,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	const struct aio12_8_boardtype *board = comedi_board(dev);
 	int iobase;
 	struct comedi_subdevice *s;
+	int ret;
 
 	iobase = it->options[0];
 	if (!request_region(iobase, 24, "aio_aio12_8")) {
@@ -182,8 +183,9 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct aio12_8_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = &dev->subdevices[0];
 	s->type = COMEDI_SUBD_AI;
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 7d161d6..8059cef 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -107,6 +107,7 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	const struct aio_iiro_16_board *board = comedi_board(dev);
 	int iobase;
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: aio_iiro_16: ", dev->minor);
 
@@ -124,8 +125,9 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct aio_iiro_16_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 17d3489..c67b09f 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1273,9 +1273,11 @@ static int dio200_common_attach(struct comedi_device *dev, unsigned long iobase,
 	devpriv->intr_sd = -1;
 	dev->iobase = iobase;
 	dev->board_name = thisboard->name;
+
 	ret = comedi_alloc_subdevices(dev, layout->n_subdevs);
-	if (ret < 0)
+	if (ret)
 		return ret;
+
 	for (n = 0; n < dev->n_subdevices; n++) {
 		s = &dev->subdevices[n];
 		switch (layout->sdtype[n]) {
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 6205985..e55321e 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -456,7 +456,7 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 	dev->iobase = iobase;
 
 	ret = comedi_alloc_subdevices(dev, 2);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index f1d68df..4f15bfd 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -228,7 +228,7 @@ static int pc263_common_attach(struct comedi_device *dev, unsigned long iobase)
 	dev->iobase = iobase;
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index d6e0d01..600aeee 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1383,7 +1383,7 @@ static int pci224_attach_common(struct comedi_device *dev,
 	     dev->iobase + PCI224_DACCON);
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index c9d8d5b..9f7e115 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2841,8 +2841,10 @@ static int pci230_attach_common(struct comedi_device *dev,
 			devpriv->pci_dev->irq);
 	}
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	rc = comedi_alloc_subdevices(dev, 3);
+	if (rc)
+		return rc;
+
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index 5fa344b..41ed857 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -434,7 +434,7 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	dev->board_name = "c6xdigio";
 
 	result = comedi_alloc_subdevices(dev, 2);
-	if (result < 0)
+	if (result)
 		return result;
 
 	/*  Make sure that PnP ports get activated */
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 9aa11c1..0310077 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -195,8 +195,9 @@ static int das16cs_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index e1bd99a..2ca3fa0 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -533,6 +533,7 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	struct pci_dev *pcidev = NULL;
 	int index;
 	int i;
+	int ret;
 
 /*
  * Allocate the private structure area.
@@ -614,8 +615,9 @@ found:
 	/* Initialize dev->board_name */
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 7) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 7);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 6b2f153..3aab75b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1344,9 +1344,11 @@ static int setup_subdevices(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 	void __iomem *dio_8255_iobase;
 	int i;
+	int ret;
 
-	if (comedi_alloc_subdevices(dev, 10) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 10);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index fedaf55..0572dc6 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -265,7 +265,7 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
-
+	int ret;
 
 /*
  * Allocate the private structure area.
@@ -333,8 +333,9 @@ found:
  */
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index f2fff4f..0186737 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -116,6 +116,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pci_dev *pcidev = NULL;
 	int index;
 	int i;
+	int ret;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -177,8 +178,9 @@ found:
 	    pci_resource_start(devpriv->pci_dev,
 			       pcidio_boards[index].dioregs_badrindex);
 
-	if (comedi_alloc_subdevices(dev, thisboard->n_8255) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 0ada8b9..b99a451b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -187,6 +187,7 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
 	int index;
+	int ret;
 	/* int i; */
 
 /*
@@ -269,8 +270,9 @@ found:
 	/* Initialize dev->board_name */
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* dev->read_subdev=s; */
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index b401aec..a801461 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -236,8 +236,9 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	err = comedi_alloc_subdevices(dev, 2);
+	if (err)
+		return err;
 
 	s = dev->subdevices + 0;
 
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 96e5b35..0260ddc 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -336,6 +336,7 @@ static int bonding_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	LOG_MSG("comedi%d\n", dev->minor);
 
@@ -358,8 +359,9 @@ static int bonding_attach(struct comedi_device *dev,
 	 */
 	dev->board_name = devpriv->name;
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DIO;
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index c9a725f..589d12f 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -316,8 +316,9 @@ static int parport_attach(struct comedi_device *dev,
 	dev->board_name = "parport";
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
+
 	ret = alloc_private(dev, sizeof(struct parport_private));
 	if (ret < 0)
 		return ret;
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 004da30..523a809 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -432,6 +432,7 @@ static int waveform_attach(struct comedi_device *dev,
 	int amplitude = it->options[0];
 	int period = it->options[1];
 	int i;
+	int ret;
 
 	dev->board_name = board->name;
 
@@ -447,8 +448,9 @@ static int waveform_attach(struct comedi_device *dev,
 	devpriv->uvolt_amplitude = amplitude;
 	devpriv->usec_period = period;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index a5bad1b..79854b1 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -107,6 +107,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk("comedi%d: contec: ", dev->minor);
 
@@ -115,8 +116,9 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct contec_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	for_each_pci_dev(pcidev) {
 		if (pcidev->vendor == PCI_VENDOR_ID_CONTEC &&
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index dbd0472..9ecf1a4 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -773,8 +773,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 		return -ENOMEM;
 
 	result = comedi_alloc_subdevices(dev, 3);
-	if (result < 0)
-		goto out;
+	if (result)
+		return result;
 
 	readl(devpriv->plx + 0x6c);
 
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 1dea21a..c4627a6 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -835,7 +835,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 	dev->board_name = thisboard->name;
 
 	ret = comedi_alloc_subdevices(dev, 6);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 6a8a7eb..0c6ad10 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1265,7 +1265,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->timer_mode = timer_mode ? 1 : 0;
 
 	ret = comedi_alloc_subdevices(dev, 5);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index eafd6b5..f3fba13 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -647,7 +647,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	}
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 12d736a..af60e5d5 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1644,8 +1644,9 @@ static int das1800_attach(struct comedi_device *dev,
 			return -ENOMEM;
 	}
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	retval = comedi_alloc_subdevices(dev, 4);
+	if (retval)
+		return retval;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 2039b6c..22a9b34 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -308,7 +308,7 @@ static int das6402_attach(struct comedi_device *dev,
 		return ret;
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	/* ai subdevice */
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 6263f53..81698b1 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -465,6 +465,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int irq = it->options[1];
 	unsigned long irq_flags;
 	int board;
+	int ret;
 
 	dev_info(dev->hw_dev, "comedi%d: das800: io 0x%lx\n", dev->minor,
 		 iobase);
@@ -510,8 +511,9 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 6b637a2..2b60cf8 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -371,8 +371,9 @@ static int dmm32at_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct dmm32at_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index 35ce076..5afbf8a 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -626,15 +626,15 @@ havetype:
 	printk("dt2801: %s at port 0x%lx", boardtype.name, iobase);
 
 	n_ai_chans = probe_number_of_ai_chans(dev);
-	printk(" (ai channels = %d)", n_ai_chans);
+	printk(" (ai channels = %d)\n", n_ai_chans);
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		goto out;
 
 	ret = alloc_private(dev, sizeof(struct dt2801_private));
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	dev->board_name = boardtype.name;
 
@@ -688,8 +688,6 @@ havetype:
 
 	ret = 0;
 out:
-	printk("\n");
-
 	return ret;
 }
 
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 6ff610d..91fbf4a 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -466,7 +466,7 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct dt2811_private));
diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index 876d5cb..2e39ebe 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -339,7 +339,7 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct dt2814_private));
diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index 33ad1fa..45b20be 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -166,6 +166,7 @@ static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int i;
 	const struct comedi_lrange *current_range_type, *voltage_range_type;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: dt2815: 0x%04lx ", dev->minor, iobase);
@@ -177,8 +178,10 @@ static int dt2815_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->board_name = "dt2815";
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
+
 	if (alloc_private(dev, sizeof(struct dt2815_private)) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index 665db07..9282ca5 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -138,7 +138,7 @@ static int dt2817_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_name = "dt2817";
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index f11d1fd..9c0a0df 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -1269,7 +1269,7 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 
 	ret = comedi_alloc_subdevices(dev, 3);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 10415b2..9828fb1 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -883,7 +883,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->irq = devpriv->pci_dev->irq;
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices;
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 678fa50..40821c7 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -1021,6 +1021,7 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int i;
 	struct comedi_subdevice *s;
+	int ret;
 
 	dev->board_name = "dt9812";
 
@@ -1035,8 +1036,9 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->serial = it->options[0];
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	/* digital input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index bab2e37..9c855e2 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -246,6 +246,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	struct pci_dev *pcidev;
 	unsigned int opt_bus, opt_slot;
 	int board_index, i;
+	int ret;
 
 	mutex_lock(&start_stop_sem);
 
@@ -329,9 +330,10 @@ found:
 	devpriv->BADR4 = pci_resource_start(pcidev, 4);
 	devpriv->BADR5 = pci_resource_start(pcidev, 5);
 
-	if (comedi_alloc_subdevices(dev, 4) < 0) {
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret) {
 		mutex_unlock(&start_stop_sem);
-		return -ENOMEM;
+		return ret;
 	}
 
 	/* analog input */
diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index 7218a9b..d1da809 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -111,6 +111,7 @@ static int fl512_ao_insn_readback(struct comedi_device *dev,
 static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	unsigned long iobase;
+	int ret;
 
 	/* pointer to the subdevice: Analog in, Analog out,
 	   (not made ->and Digital IO) */
@@ -131,8 +132,9 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_DEBUG "malloc ok\n");
 #endif
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	/*
 	 * this if the definitions of the supdevices, 2 have been defined
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index b103cfb..79f5808 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -430,9 +430,11 @@ static void init_plx9080(struct comedi_device *dev)
 static int setup_subdevices(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog input subdevice */
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 06c66af..544bed8 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -904,7 +904,7 @@ static int icp_multi_attach(struct comedi_device *dev,
 		n_subdevices++;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	icp_multi_reset(dev);
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 9c11657..bea3d03 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -203,7 +203,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
 	union pci20xxx_subdev_private *sdp;
 
 	ret = comedi_alloc_subdevices(dev, 1 + PCI20000_MODULES);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct pci20xxx_private));
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 182643b..3c043e5 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -827,8 +827,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
 		return -ENOMEM;
 
 	result = comedi_alloc_subdevices(dev, devpriv->n_channels);
-	if (result < 0)
-		goto out;
+	if (result)
+		return result;
 
 	dev->open = jr3_pci_open;
 	for (i = 0; i < devpriv->n_channels; i++) {
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 7c256f4..019e91a 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -190,7 +190,7 @@ found:
 	dev->iobase = io_base;
 
 	error = comedi_alloc_subdevices(dev, 1);
-	if (error < 0)
+	if (error)
 		return error;
 
 	subdevice = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 2ca8d8b..c8ee22d 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -2190,8 +2190,9 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (result)
 		return result;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	result = comedi_alloc_subdevices(dev, 4);
+	if (result)
+		return result;
 
     /*=========================================================================
       Analog input subdevice
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 231b294..ae3b046 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -761,9 +761,8 @@ found:
 
 	me_reset(dev);
 
-	/* device driver capabilities */
 	error = comedi_alloc_subdevices(dev, 3);
-	if (error < 0)
+	if (error)
 		return error;
 
 	subdevice = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index 9750336..b928b67 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -285,6 +285,7 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: mpc624 [0x%04lx, ", dev->minor, iobase);
@@ -348,8 +349,9 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
 	}
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_AI;
diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index 1311051..a6311b1 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -121,6 +121,7 @@ static int mpc8260cpm_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 	int i;
+	int ret;
 
 	printk("comedi%d: mpc8260cpm: ", dev->minor);
 
@@ -131,8 +132,9 @@ static int mpc8260cpm_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct mpc8260cpm_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret =comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < 4; i++) {
 		s = dev->subdevices + i;
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index 00d497c..b1bbd02 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -255,8 +255,9 @@ static int multiq3_attach(struct comedi_device *dev,
 	else
 		printk(KERN_WARNING "comedi%d: no irq\n", dev->minor);
 	dev->board_name = "multiq3";
+
 	result = comedi_alloc_subdevices(dev, 5);
-	if (result < 0)
+	if (result)
 		return result;
 
 	result = alloc_private(dev, sizeof(struct multiq3_private));
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index 89fee6f..b60ab48 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -398,7 +398,7 @@ static int ni6527_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		readb(devpriv->mite->daq_io_addr + ID_Register));
 
 	ret = comedi_alloc_subdevices(dev, 3);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index a49dcea..ac7c74b 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -679,7 +679,7 @@ static int ni_65xx_attach(struct comedi_device *dev,
 	       readb(private(dev)->mite->daq_io_addr + ID_Register));
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 8c6a6ba..5391a39 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1093,8 +1093,9 @@ static int ni_660x_attach(struct comedi_device *dev,
 
 	printk(KERN_INFO " %s ", dev->board_name);
 
-	if (comedi_alloc_subdevices(dev, 2 + NI_660X_MAX_NUM_COUNTERS) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2 + NI_660X_MAX_NUM_COUNTERS);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* Old GENERAL-PURPOSE COUNTER/TIME (GPCT) subdevice, no longer used */
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 45a03e6..5dffe6c 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -202,8 +202,9 @@ static int ni_670x_attach(struct comedi_device *dev,
 	dev->irq = mite_irq(devpriv->mite);
 	printk(KERN_INFO " %s", dev->board_name);
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 9d1a0f7..b53a428 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -755,6 +755,7 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int dma = it->options[2];
 	static const int timeout = 2000;
 	int i;
+	int ret;
 
 	printk("comedi%d: %s: io 0x%lx", dev->minor, dev->driver->driver_name,
 	       iobase);
@@ -826,8 +827,9 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_ptr = a2150_boards + a2150_probe(dev);
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 03a4d73..1c3f322 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -337,6 +337,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	int ao_unipolar;
+	int ret;
 
 	iobase = it->options[0];
 	if (iobase == 0)
@@ -356,8 +357,9 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct atao_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* analog output subdevice */
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 37ff6fc..95bee84 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -710,7 +710,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 	dev->board_name = board->name;
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct atmio16d_private));
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 8860207..53b0173 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -364,6 +364,7 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int irq = 0;
 #endif
 	struct pcmcia_device *link;
+	int ret;
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct dio700_private)) < 0)
@@ -409,8 +410,9 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	/* DAQCard-700 dio */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 36c0c62..e27cae0 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -116,6 +116,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int irq = 0;
 #endif
 	struct pcmcia_device *link;
+	int ret;
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct dio24_private)) < 0)
@@ -158,8 +159,9 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	/* 8255 dio */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 825b162..5816986 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -536,6 +536,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	unsigned long dma_flags;
 #endif
 	short lsb, msb;
+	int ret;
 
 	printk(KERN_ERR "comedi%d: ni_labpc: %s, io 0x%lx", dev->minor,
 								thisboard->name,
@@ -622,8 +623,9 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 5) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 5);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 4261e92..1f796b9 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -4406,14 +4406,16 @@ static int ni_E_init(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned j;
 	enum ni_gpct_variant counter_variant;
+	int ret;
 
 	if (boardtype.n_aochan > MAX_N_AO_CHAN) {
 		printk("bug! boardtype.n_aochan > MAX_N_AO_CHAN\n");
 		return -EINVAL;
 	}
 
-	if (comedi_alloc_subdevices(dev, NI_NUM_SUBDEVICES) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, NI_NUM_SUBDEVICES);
+	if (ret)
+		return ret;
 
 	/* analog input subdevice */
 
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 77ef312..cba0459 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -1249,7 +1249,7 @@ static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		n_subdevices = 1;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	if (!this_board->is_diodaq) {
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index 35b9510..d5fa6f2 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -519,7 +519,7 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->irq = irq;
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct pcl711_private));
diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 698c900..c8fe23c 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -157,7 +157,7 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		n_subdevices = 4;	/*  PCL-724 in 96 DIO configuration */
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index d7ba336..8edbefd 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -52,6 +52,7 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: pcl725: 0x%04lx ", dev->minor, iobase);
@@ -63,8 +64,9 @@ static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (comedi_alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* do */
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index e756a30..b2e73cd 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -293,7 +293,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("\n");
 
 	ret = comedi_alloc_subdevices(dev, 3);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index e258bce..3cba79a 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -72,6 +72,7 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iorange;
+	int ret;
 
 	iobase = it->options[0];
 	iorange = board->io_range;
@@ -85,8 +86,9 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 	dev->irq = 0;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* Isolated do */
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 128f5b6..0a4074a 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1383,7 +1383,7 @@ no_dma:
 		n_subdevices++;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0) {
+	if (ret) {
 		free_resources(dev);
 		return ret;
 	}
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 9d2d093..68ad759 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -1195,7 +1195,7 @@ no_dma:
 */
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index a4c2870..66b2570 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1779,7 +1779,7 @@ no_rtc:
 no_dma:
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index d755b40..62c22cc 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -259,7 +259,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 	n_subdevices = board->numofports;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index 48a21bd..b48f7aa 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -59,6 +59,7 @@ static int pcm3730_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: pcm3730: 0x%04lx ", dev->minor, iobase);
@@ -71,8 +72,9 @@ static int pcm3730_attach(struct comedi_device *dev,
 	dev->iobase = dev->iobase;
 	dev->irq = 0;
 
-	if (comedi_alloc_subdevices(dev, 6) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 6);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DO;
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 00b0f2a..54d19c9 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -118,7 +118,7 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct pcmad_priv_struct));
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 87faa03..291ce7c 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -165,6 +165,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 	const struct pcmda12_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO
@@ -190,8 +191,9 @@ static int pcmda12_attach(struct comedi_device *dev,
 
 	devpriv->simultaneous_xfer_mode = it->options[1];
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices;
 	s->private = NULL;
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 3105303..0e64d84 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1020,6 +1020,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    thisasic_chanct = 0;
 	unsigned long iobase;
 	unsigned int irq[MAX_ASICS];
+	int ret;
 
 	iobase = it->options[0];
 	irq[0] = it->options[1];
@@ -1072,8 +1073,9 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 	}
 
-	if (comedi_alloc_subdevices(dev, n_subdevs) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
+	if (ret)
+		return ret;
 
 	/* First, AI */
 	sdev_no = 0;
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 33ab4c6..48565fe 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -754,6 +754,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int sdev_no, chans_left, n_subdevs, port, asic, thisasic_chanct = 0;
 	unsigned long iobase;
 	unsigned int irq[MAX_ASICS];
+	int ret;
 
 	iobase = it->options[0];
 	irq[0] = it->options[1];
@@ -801,8 +802,9 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 	}
 
-	if (comedi_alloc_subdevices(dev, n_subdevs) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, n_subdevs);
+	if (ret)
+		return ret;
 
 	port = 0;
 	asic = 0;
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 1e954f9..a129ccac 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -139,6 +139,7 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iosize;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
@@ -160,8 +161,10 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	dev->iobase = iobase;
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
+
 	if (alloc_private(dev, sizeof(unsigned int) * board->n_chan) < 0)
 		return -ENOMEM;
 
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 38a13ba..a029147 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -872,7 +872,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = local->link->resource[0]->start;
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	printk(KERN_INFO "comedi%d: attaching daqp%d (io 0x%04lx)\n",
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 445333b..c3c8097 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1999,9 +1999,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* Show board configuration */
 	printk(KERN_INFO "%s:", dev->board_name);
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index a80f630..966ac2cc 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -349,7 +349,7 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_name = board->name;
 
 	ret = comedi_alloc_subdevices(dev, 4);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = alloc_private(dev, sizeof(struct rti800_private));
diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index 1aacf3f..fc16508 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -92,6 +92,7 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	int i;
 	unsigned long iobase;
+	int ret;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: rti802: 0x%04lx ", dev->minor, iobase);
@@ -103,10 +104,12 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->board_name = "rti802";
 
-	if (comedi_alloc_subdevices(dev, 1) < 0
-	    || alloc_private(dev, sizeof(struct rti802_private))) {
+	if (alloc_private(dev, sizeof(struct rti802_private)))
 		return -ENOMEM;
-	}
+
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices;
 	/* ao subdevice */
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 6a30537..141bc9e 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -743,6 +743,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	int iobase;
 	int i, n;
+	int ret;
 /* short value; */
 /* int subdev_channel = 0; */
 	union cmReg cmReg;
@@ -774,8 +775,9 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct s526_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* GENERAL-PURPOSE COUNTER/TIME (GPCT) */
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index f2eeca5..32e03bc 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -595,8 +595,9 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_ptr = s626_boards;
 	dev->board_name = thisboard->name;
 
-	if (comedi_alloc_subdevices(dev, 6) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 6);
+	if (ret)
+		return ret;
 
 	dev->iobase = (unsigned long)devpriv->base_addr;
 	dev->irq = devpriv->pdev->irq;
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 53ebb5d..439fb50 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -780,6 +780,7 @@ static int serial2002_attach(struct comedi_device *dev,
 {
 	const struct serial2002_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
+	int ret;
 
 	dev_dbg(dev->hw_dev, "comedi%d: attached\n", dev->minor);
 	dev->board_name = board->name;
@@ -792,8 +793,9 @@ static int serial2002_attach(struct comedi_device *dev,
 	dev_dbg(dev->hw_dev, "/dev/ttyS%d @ %d\n", devpriv->port,
 		devpriv->speed);
 
-	if (comedi_alloc_subdevices(dev, 5) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 5);
+	if (ret)
+		return ret;
 
 	/* digital input subdevice */
 	s = dev->subdevices + 0;
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index ca10b1a..92d44c1 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -210,6 +210,7 @@ static int skel_ns_to_timer(unsigned int *ns, int round);
 static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	pr_info("comedi%d: skel: ", dev->minor);
 
@@ -233,8 +234,9 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct skel_private)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 3) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* dev->read_subdev=s; */
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 130e4bd..b12bafe 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -187,6 +187,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct dnp_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
+	int ret;
 
 	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
 
@@ -197,8 +198,9 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
 		return -ENOMEM;
 
-	if (comedi_alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	/* digital i/o subdevice                                             */
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 711dad7..9f1fdec 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -443,6 +443,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 {
 	int iobase, i, n_subd;
 	int id, num, ba;
+	int ret;
 
 	iobase = it->options[0];
 
@@ -468,8 +469,9 @@ static int unioxx5_attach(struct comedi_device *dev,
 		return -1;
 	}
 
-	if (comedi_alloc_subdevices(dev, n_subd) < 0)
-		return -ENOMEM;
+	ret = comedi_alloc_subdevices(dev, n_subd);
+	if (ret)
+		return ret;
 
 	/* initializing each of for same subdevices */
 	for (i = 0; i < n_subd; i++, iobase += UNIOXX5_SUBDEV_ODDS) {
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index a6cf134..0386fd4 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2646,7 +2646,7 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	}
 
 	ret = comedi_alloc_subdevices(dev, n_subdevs);
-	if (ret < 0) {
+	if (ret) {
 		up(&udev->sem);
 		return ret;
 	}
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index f7d4f56..2ee9ecd 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1667,7 +1667,7 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	dev->board_name = BOARDNAME;
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0) {
+	if (ret) {
 		up(&(usbduxfastsub[index].sem));
 		up(&start_stop_sem);
 		return ret;
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index f23fad9..502a409 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2691,7 +2691,7 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	}
 
 	ret = comedi_alloc_subdevices(dev, n_subdevs);
-	if (ret < 0) {
+	if (ret) {
 		up(&udev->sem);
 		up(&start_stop_sem);
 		return ret;
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 5a3e33d..69402da 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1135,6 +1135,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	int n_subd;
 	struct comedi_subdevice *s;
 	int minor;
+	int ret;
 
 	mutex_lock(&glb_mutex);
 
@@ -1159,10 +1160,11 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	else
 		n_subd = 6;
 
-	if (comedi_alloc_subdevices(cdev, n_subd) < 0) {
+	ret = comedi_alloc_subdevices(cdev, n_subd);
+	if (ret) {
 		up(&dev->limit_sem);
 		mutex_unlock(&glb_mutex);
-		return -ENOMEM;
+		return ret;
 	}
 
 	/* Analog input subdevice */
-- 
1.7.7

