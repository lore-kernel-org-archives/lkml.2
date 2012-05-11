Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab2EKKkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:40:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56846 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab2EKKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:30 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 06/25] Staging: comedi: fix printk issue in usbduxfast.c
Date: Fri, 11 May 2012 16:07:54 +0530
Message-Id: <1336732693-7408-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a printk found
by the checkpatch.pl tool.

Used dev_*() functions instead of printks wherver possible and fixed
a quoted string split across line warnings.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   31 ++++++++++++--------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index e66c1f3..3824d51 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1637,9 +1637,8 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	}
 
 	if (index < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: error: attach failed, "
-		       "no usbduxfast devs connected to the usb bus.\n",
-		       dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: error: attach failed, no usbduxfast devs connected to the usb bus.\n",
+			dev->minor);
 		up(&start_stop_sem);
 		return -ENODEV;
 	}
@@ -1664,15 +1663,15 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	/* allocate space for the subdevices */
 	ret = alloc_subdevices(dev, N_SUBDEVICES);
 	if (ret < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: error alloc space for "
-		       "subdev\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: error alloc space for subdev\n",
+			dev->minor);
 		up(&(usbduxfastsub[index].sem));
 		up(&start_stop_sem);
 		return ret;
 	}
 
-	printk(KERN_INFO "comedi%d: usbduxfast: usb-device %d is attached to "
-	       "comedi.\n", dev->minor, index);
+	dev_info(dev->hw_dev, "comedi%d: usb-device %d is attached to comedi.\n",
+		 dev->minor, index);
 	/* private structure is also simply the usb-structure */
 	dev->private = usbduxfastsub + index;
 	/* the first subdevice is the A/D converter */
@@ -1707,8 +1706,8 @@ static int usbduxfast_attach(struct comedi_device *dev,
 
 	up(&(usbduxfastsub[index].sem));
 	up(&start_stop_sem);
-	printk(KERN_INFO "comedi%d: successfully attached to usbduxfast.\n",
-	       dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: successfully attached to usbduxfast.\n",
+		 dev->minor);
 
 	return 0;
 }
@@ -1718,19 +1717,17 @@ static int usbduxfast_detach(struct comedi_device *dev)
 	struct usbduxfastsub_s *udfs;
 
 	if (!dev) {
-		printk(KERN_ERR "comedi?: usbduxfast: detach without dev "
-		       "variable...\n");
+		dev_err(dev->hw_dev, "comedi?: detach without dev variable...\n");
 		return -EFAULT;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: detach usb device\n",
-	       dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: detach usb device\n",
+		dev->minor);
 #endif
 
 	udfs = dev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi?: usbduxfast: detach without ptr to "
-		       "usbduxfastsub[]\n");
+		dev_err(dev->hw_dev, "comedi?: detach without ptr to usbduxfastsub[]\n");
 		return -EFAULT;
 	}
 
@@ -1744,8 +1741,8 @@ static int usbduxfast_detach(struct comedi_device *dev)
 	udfs->attached = 0;
 	udfs->comedidev = NULL;
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: detach: successfully "
-	       "removed\n", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: detach: successfully removed\n",
+		dev->minor);
 #endif
 	up(&start_stop_sem);
 	up(&udfs->sem);
-- 
1.7.0.4

