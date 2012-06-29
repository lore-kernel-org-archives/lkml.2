Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2F2Bm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:42:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56468 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2F2Bm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:42:56 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: unioxx5: Syntax issues fixed
Date: Thu, 28 Jun 2012 22:42:50 -0300
Message-Id: <1340934170-22854-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed "printk(KERN_INFO" to "pr_info("
and "printk(KERN_ERROR" to "pr_err("

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c | 55 ++++++++++++++++----------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index d5f1f22..01668be 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -144,9 +144,9 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       minor, channel);
+		pr_err("comedi%d: undefined channel %d." \
+			"channel range is 0 .. 23\n",
+			minor, channel);
 		return 0;
 	}
 
@@ -171,9 +171,9 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 
 	/* defining if given module can work on input */
 	if (usp->usp_module_type[module_no] & MODULE_OUTPUT_MASK) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%02x is for output only",
-		       minor, module_no, usp->usp_module_type[module_no]);
+		pr_err("comedi%d: module in position %d" \
+			"with id 0x%02x is for output only",
+			minor, module_no, usp->usp_module_type[module_no]);
 		return 0;
 	}
 
@@ -209,9 +209,9 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       minor, channel);
+		pr_err("comedi%d: undefined channel %d." \
+			"channel range is 0 .. 23\n",
+			minor, channel);
 		return 0;
 	}
 
@@ -240,9 +240,9 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 
 	/* defining if given module can work on output */
 	if (!(usp->usp_module_type[module] & MODULE_OUTPUT_MASK)) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%0x is for input only!\n",
-		       minor, module, usp->usp_module_type[module]);
+		pr_err("comedi%d: module in position %d" \
+			"with id 0x%0x is for input only!\n",
+			minor, module, usp->usp_module_type[module]);
 		return 0;
 	}
 
@@ -323,17 +323,17 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	type = usp->usp_module_type[channel / 2];
 
 	if (type != MODULE_DIGITAL) {
-		printk(KERN_ERR
-		       "comedi%d: channel configuration accessible only for digital modules\n",
-		       dev->minor);
+		pr_err("comedi%d: channel configuration accessible only" \
+			" for digital modules\n",
+			dev->minor);
 		return -1;
 	}
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       dev->minor, channel);
+		pr_err("comedi%d: undefined channel %d." \
+			" channel range is 0 .. 23\n",
+			dev->minor, channel);
 		return -1;
 	}
 
@@ -348,7 +348,7 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 		flags |= mask;
 		break;
 	default:
-		printk(KERN_ERR "comedi%d: unknown flag\n", dev->minor);
+		pr_err("comedi%d: unknown flag\n", dev->minor);
 		return -1;
 	}
 
@@ -375,19 +375,19 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	int i, to, ndef_flag = 0;
 
 	if (!request_region(subdev_iobase, UNIOXX5_SIZE, DRIVER_NAME)) {
-		printk(KERN_ERR "comedi%d: I/O port conflict\n", minor);
+		pr_err("comedi%d: I/O port conflict\n", minor);
 		return -EIO;
 	}
 
 	usp = kzalloc(sizeof(*usp), GFP_KERNEL);
 
 	if (usp == NULL) {
-		printk(KERN_ERR "comedi%d: error! --> out of memory!\n", minor);
+		pr_err("comedi%d: error! --> out of memory!\n", minor);
 		return -1;
 	}
 
 	usp->usp_iobase = subdev_iobase;
-	printk(KERN_INFO "comedi%d: |", minor);
+	pr_info("comedi%d: |", minor);
 
 	/* defining modules types */
 	for (i = 0; i < 12; i++) {
@@ -433,7 +433,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	/* for digital modules only!!! */
 	subdev->insn_config = unioxx5_insn_config;
 
-	printk(KERN_INFO "subdevice configured\n");
+	pr_info("subdevice configured\n");
 
 	return 0;
 }
@@ -450,7 +450,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	iobase += UNIOXX5_SUBDEV_BASE;
 
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
+/* defining number of subdevices and getting they types (it must be 'g01')  */
 	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
@@ -463,13 +463,12 @@ static int unioxx5_attach(struct comedi_device *dev,
 
 	/* unioxx5 can has from two to four subdevices */
 	if (n_subd < 2) {
-		printk(KERN_ERR
-		       "your card must has at least 2 'g01' subdevices\n");
+		pr_err("your card must has at least 2 'g01' subdevices\n");
 		return -1;
 	}
 
 	if (alloc_subdevices(dev, n_subd) < 0) {
-		printk(KERN_ERR "out of memory\n");
+		pr_err("out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -480,7 +479,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 			return -1;
 	}
 
-	printk(KERN_INFO "attached\n");
+	pr_info("attached\n");
 	return 0;
 }
 
-- 
1.7.11.1

