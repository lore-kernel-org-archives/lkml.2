Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2FLS7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:59:05 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:22848 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2FLS7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:59:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1339527534!8265662!24
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] staging: comedi: remove the comed_alloc_subdevices "allocation failed" messages
Date: Tue, 12 Jun 2012 11:58:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121158.46249.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 62e9ab7262b4a5dc522dcb861d813cde4a718214 Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 10:33:08 -0700
Subject: [PATCH 5/8] staging: comedi: remove the comed_alloc_subdevices
 "allocation failed" messages

Remove all the "allocation failed" debug messages that are displayed
when the comedi_alloc_subdevices call fails.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbot <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c         |    6 +-----
 drivers/staging/comedi/drivers/adv_pci1723.c  |    4 +---
 drivers/staging/comedi/drivers/amplc_dio200.c |    4 +---
 drivers/staging/comedi/drivers/amplc_pc236.c  |    4 +---
 drivers/staging/comedi/drivers/amplc_pc263.c  |    4 +---
 drivers/staging/comedi/drivers/amplc_pci224.c |    4 +---
 drivers/staging/comedi/drivers/dyna_pci10xx.c |    2 --
 drivers/staging/comedi/drivers/pcmda12.c      |    4 +---
 drivers/staging/comedi/drivers/pcmmio.c       |    5 +----
 drivers/staging/comedi/drivers/pcmuio.c       |    4 +---
 drivers/staging/comedi/drivers/unioxx5.c      |    4 +---
 drivers/staging/comedi/drivers/usbdux.c       |    2 --
 drivers/staging/comedi/drivers/usbduxfast.c   |    2 --
 drivers/staging/comedi/drivers/usbduxsigma.c  |    2 --
 14 files changed, 10 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 875b020..64b0054 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -389,12 +389,8 @@ static int dev_8255_attach(struct comedi_device *dev,
 	}
 
 	ret = comedi_alloc_subdevices(dev, i);
-	if (ret < 0) {
-		/* FIXME this printk call should give a proper message, the
-		 * below line just maintains previous functionality */
-		printk("comedi%d: 8255:", dev->minor);
+	if (ret < 0)
 		return ret;
-	}
 
 	printk(KERN_INFO "comedi%d: 8255:", dev->minor);
 
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 0aa0af4..c14ad35 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -366,10 +366,8 @@ static int pci1723_attach(struct comedi_device *dev,
 		n_subdevices++;
 
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-	if (ret < 0) {
-		printk(" - Allocation failed!\n");
+	if (ret < 0)
 		return ret;
-	}
 
 	pci1723_reset(dev);
 	subdev = 0;
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index d7d056e..17d3489 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -1274,10 +1274,8 @@ static int dio200_common_attach(struct comedi_device *dev, unsigned long iobase,
 	dev->iobase = iobase;
 	dev->board_name = thisboard->name;
 	ret = comedi_alloc_subdevices(dev, layout->n_subdevs);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	if (ret < 0)
 		return ret;
-	}
 	for (n = 0; n < dev->n_subdevices; n++) {
 		s = &dev->subdevices[n];
 		switch (layout->sdtype[n]) {
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 522e1c0..6205985 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -456,10 +456,8 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 	dev->iobase = iobase;
 
 	ret = comedi_alloc_subdevices(dev, 2);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	if (ret < 0)
 		return ret;
-	}
 
 	s = dev->subdevices + 0;
 	/* digital i/o subdevice (8255) */
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index cfb69fa..f1d68df 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -228,10 +228,8 @@ static int pc263_common_attach(struct comedi_device *dev, unsigned long iobase)
 	dev->iobase = iobase;
 
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	if (ret < 0)
 		return ret;
-	}
 
 	s = dev->subdevices + 0;
 	/* digital output subdevice */
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 848fab2..7dd4057 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1384,10 +1384,8 @@ static int pci224_attach_common(struct comedi_device *dev,
 
 	/* Allocate subdevices.  There is only one!  */
 	ret = comedi_alloc_subdevices(dev, 1);
-	if (ret < 0) {
-		dev_err(dev->class_dev, "error! out of memory!\n");
+	if (ret < 0)
 		return ret;
-	}
 
 	s = dev->subdevices + 0;
 	/* Analog output subdevice. */
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 6f6fb52..bab2e37 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -330,8 +330,6 @@ found:
 	devpriv->BADR5 = pci_resource_start(pcidev, 5);
 
 	if (comedi_alloc_subdevices(dev, 4) < 0) {
-		printk(KERN_ERR "comedi: dyna_pci10xx: "
-			"failed allocating subdevices\n");
 		mutex_unlock(&start_stop_sem);
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 3645e9e..e1b30cc 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -197,10 +197,8 @@ static int pcmda12_attach(struct comedi_device *dev,
 	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
 	 * 96-channel version of the board.
 	 */
-	if (comedi_alloc_subdevices(dev, 1) < 0) {
-		printk(KERN_ERR "cannot allocate subdevice data structures\n");
+	if (comedi_alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
-	}
 
 	s = dev->subdevices;
 	s->private = NULL;
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 67fdac5..abaf6c7 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1077,11 +1077,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 *
 	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
 	 */
-	if (comedi_alloc_subdevices(dev, n_subdevs) < 0) {
-		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
-				dev->minor);
+	if (comedi_alloc_subdevices(dev, n_subdevs) < 0)
 		return -ENOMEM;
-	}
 
 	/* First, AI */
 	sdev_no = 0;
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index ce5068e..e4153bd 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -807,10 +807,8 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 2 subdevs (32 + 16 DIO lines) or 3 32 DIO subdevs for the
 	 * 96-channel version of the board.
 	 */
-	if (comedi_alloc_subdevices(dev, n_subdevs) < 0) {
-		dev_dbg(dev->hw_dev, "cannot allocate subdevice data structures\n");
+	if (comedi_alloc_subdevices(dev, n_subdevs) < 0)
 		return -ENOMEM;
-	}
 
 	port = 0;
 	asic = 0;
diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 170bc48..711dad7 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -468,10 +468,8 @@ static int unioxx5_attach(struct comedi_device *dev,
 		return -1;
 	}
 
-	if (comedi_alloc_subdevices(dev, n_subd) < 0) {
-		printk(KERN_ERR "out of memory\n");
+	if (comedi_alloc_subdevices(dev, n_subd) < 0)
 		return -ENOMEM;
-	}
 
 	/* initializing each of for same subdevices */
 	for (i = 0; i < n_subd; i++, iobase += UNIOXX5_SUBDEV_ODDS) {
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 3819663..79df200 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2648,8 +2648,6 @@ static int usbdux_attach_common(struct comedi_device *dev,
 	/* allocate space for the subdevices */
 	ret = comedi_alloc_subdevices(dev, n_subdevs);
 	if (ret < 0) {
-		dev_err(&udev->interface->dev,
-			"comedi%d: error alloc space for subdev\n", dev->minor);
 		up(&udev->sem);
 		return ret;
 	}
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 262556e..660dd4e 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1669,8 +1669,6 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	/* allocate space for the subdevices */
 	ret = comedi_alloc_subdevices(dev, 1);
 	if (ret < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: error alloc space for "
-		       "subdev\n", dev->minor);
 		up(&(usbduxfastsub[index].sem));
 		up(&start_stop_sem);
 		return ret;
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 87c613e..f37e96c 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -2693,8 +2693,6 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	/* allocate space for the subdevices */
 	ret = comedi_alloc_subdevices(dev, n_subdevs);
 	if (ret < 0) {
-		dev_err(&udev->interface->dev,
-			"comedi%d: no space for subdev\n", dev->minor);
 		up(&udev->sem);
 		up(&start_stop_sem);
 		return ret;
-- 
1.7.7

