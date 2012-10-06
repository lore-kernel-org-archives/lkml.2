Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2JFFxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 01:53:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34629 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2JFFxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 01:53:08 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in rtd520.c
Date: Sat,  6 Oct 2012 14:53:02 +0900
Message-Id: <1349502782-8809-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
-Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/rtd520.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 41d24b0..d7ed26a 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -507,15 +507,14 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 		}
 	}
 	if (i == limit) {
-		printk(KERN_INFO "\ncomedi: %s: failed to probe fifo size.\n",
-		       DRV_NAME);
+		dev_info(dev->class_dev, "failed to probe fifo size.\n");
 		return -EIO;
 	}
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	if (fifo_size != 0x400 && fifo_size != 0x2000) {
-		printk
-		    (KERN_INFO "\ncomedi: %s: unexpected fifo size of %i, expected 1024 or 8192.\n",
-		     DRV_NAME, fifo_size);
+		dev_info(dev->class_dev,
+			 "unexpected fifo size of %i, expected 1024 or 8192.\n",
+			 fifo_size);
 		return -EIO;
 	}
 	return fifo_size;
@@ -1600,7 +1599,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int index;
 #endif
 
-	printk(KERN_INFO "comedi%d: rtd520 attaching.\n", dev->minor);
+	dev_info(dev->class_dev, "rtd520 attaching.\n");
 
 #if defined(CONFIG_COMEDI_DEBUG) && defined(USE_DMA)
 	/* You can set this a load time: modprobe comedi comedi_debug=1 */
@@ -1626,7 +1625,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	ret = comedi_pci_enable(pcidev, DRV_NAME);
 	if (ret < 0) {
-		printk(KERN_INFO "Failed to enable PCI device and request regions.\n");
+		dev_info(dev->class_dev,
+			 "Failed to enable PCI device and request regions.\n");
 		return ret;
 	}
 	dev->iobase = 1;	/* the "detach" needs this */
@@ -1653,8 +1653,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		pci_read_config_byte(pcidev,
 				     PCI_LATENCY_TIMER, &pci_latency);
 		if (pci_latency < 32) {
-			printk(KERN_INFO "%s: PCI latency changed from %d to %d\n",
-			       dev->board_name, pci_latency, 32);
+			dev_info(dev->class_dev,
+				 "PCI latency changed from %d to %d\n",
+				 pci_latency, 32);
 			pci_write_config_byte(pcidev,
 					      PCI_LATENCY_TIMER, 32);
 		} else {
@@ -1675,7 +1676,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* Show board configuration */
-	printk(KERN_INFO "%s:", dev->board_name);
+	dev_info(dev->class_dev, "%s:", dev->board_name);
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
@@ -1767,7 +1768,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 	}
 	dev->irq = pcidev->irq;
-	printk(KERN_INFO "( irq=%u )", dev->irq);
+	dev_info(dev->class_dev, "( irq=%u )", dev->irq);
 
 	ret = rtd520_probe_fifo_depth(dev);
 	if (ret < 0)
@@ -1844,7 +1845,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/* set DMA trigger source */
 		writel(DMAS_ADFIFO_HALF_FULL, devpriv->las0 + LAS0_DMA0_SRC);
 	} else {
-		printk(KERN_INFO "( no IRQ->no DMA )");
+		dev_info(dev->class_dev, "( no IRQ->no DMA )");
 	}
 #endif /* USE_DMA */
 
-- 
1.7.9.5

