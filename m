Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab2JXMG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:06:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2JXMG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:06:26 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH v2] staging/comedi: Use pr_ or dev_ printks in drivers/unioxx5.c
Date: Wed, 24 Oct 2012 21:06:17 +0900
Message-Id: <1351080378-4802-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121022195115.GB8567@kroah.com>
References: <20121022195115.GB8567@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and added pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |   44 ++++++++++++++----------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 9f1fdec..c9ded93 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -42,6 +42,8 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "../comedidev.h"
 #include <linux/ioport.h>
 #include <linux/slab.h>
@@ -144,8 +146,7 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
 		       minor, channel);
 		return 0;
 	}
@@ -171,8 +172,7 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 
 	/* defining if given module can work on input */
 	if (usp->usp_module_type[module_no] & MODULE_OUTPUT_MASK) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%02x is for output only",
+		pr_err("comedi%d: module in position %d with id 0x%02x is for output only",
 		       minor, module_no, usp->usp_module_type[module_no]);
 		return 0;
 	}
@@ -209,8 +209,7 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
 		       minor, channel);
 		return 0;
 	}
@@ -240,8 +239,7 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 
 	/* defining if given module can work on output */
 	if (!(usp->usp_module_type[module] & MODULE_OUTPUT_MASK)) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%0x is for input only!\n",
+		pr_err("comedi%d: module in position %d with id 0x%0x is for input only!\n",
 		       minor, module, usp->usp_module_type[module]);
 		return 0;
 	}
@@ -323,17 +321,17 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	type = usp->usp_module_type[channel / 2];
 
 	if (type != MODULE_DIGITAL) {
-		printk(KERN_ERR
-		       "comedi%d: channel configuration accessible only for digital modules\n",
-		       dev->minor);
+		dev_err(dev->class_dev,
+			"comedi%d: channel configuration accessible only for digital modules\n",
+			dev->minor);
 		return -1;
 	}
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       dev->minor, channel);
+		dev_err(dev->class_dev,
+			"comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+			dev->minor, channel);
 		return -1;
 	}
 
@@ -348,7 +346,8 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 		flags |= mask;
 		break;
 	default:
-		printk(KERN_ERR "comedi%d: unknown flag\n", dev->minor);
+		dev_err(dev->class_dev,
+			"comedi%d: unknown flag\n", dev->minor);
 		return -1;
 	}
 
@@ -375,19 +374,21 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	int i, to, ndef_flag = 0;
 
 	if (!request_region(subdev_iobase, UNIOXX5_SIZE, DRIVER_NAME)) {
-		printk(KERN_ERR "comedi%d: I/O port conflict\n", minor);
+		dev_err(subdev->class_dev,
+			"comedi%d: I/O port conflict\n", minor);
 		return -EIO;
 	}
 
 	usp = kzalloc(sizeof(*usp), GFP_KERNEL);
 
 	if (usp == NULL) {
-		printk(KERN_ERR "comedi%d: error! --> out of memory!\n", minor);
+		dev_err(subdev->class_dev,
+			"comedi%d: error! --> out of memory!\n", minor);
 		return -1;
 	}
 
 	usp->usp_iobase = subdev_iobase;
-	printk(KERN_INFO "comedi%d: |", minor);
+	dev_info(subdev->class_dev, "comedi%d: |", minor);
 
 	/* defining modules types */
 	for (i = 0; i < 12; i++) {
@@ -433,8 +434,6 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	/* for digital modules only!!! */
 	subdev->insn_config = unioxx5_insn_config;
 
-	printk(KERN_INFO "subdevice configured\n");
-
 	return 0;
 }
 
@@ -464,8 +463,8 @@ static int unioxx5_attach(struct comedi_device *dev,
 
 	/* unioxx5 can has from two to four subdevices */
 	if (n_subd < 2) {
-		printk(KERN_ERR
-		       "your card must has at least 2 'g01' subdevices\n");
+		dev_err(dev->class_dev,
+			"your card must has at least 2 'g01' subdevices\n");
 		return -1;
 	}
 
@@ -480,7 +479,6 @@ static int unioxx5_attach(struct comedi_device *dev,
 			return -1;
 	}
 
-	printk(KERN_INFO "attached\n");
 	return 0;
 }
 
-- 
1.7.9.5

