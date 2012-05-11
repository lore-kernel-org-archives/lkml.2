Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab2EKKlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:41:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab2EKKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:50 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 16/25] Staging: comedi: fix printk issues in unioxx5.c
Date: Fri, 11 May 2012 16:08:04 +0530
Message-Id: <1336732693-7408-17-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the unioxx5.c file that fixes up a
printk warning found by the checkpatch.pl tool.

i.e. WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
     WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
     WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/unioxx5.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 8cba339..1823642 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -296,19 +296,19 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
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
@@ -336,11 +336,11 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 		} else
 			usp->usp_module_type[i] = inb(subdev_iobase + 6);
 
-		printk(" [%d] 0x%02x |", i, usp->usp_module_type[i]);
+		pr_cont(" [%d] 0x%02x |", i, usp->usp_module_type[i]);
 		udelay(1);
 	}
 
-	printk("\n");
+	pr_cont("\n");
 
 	/* initial subdevice for digital or analog i/o */
 	subdev->type = COMEDI_SUBD_DIO;
@@ -354,7 +354,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	/* for digital modules only!!! */
 	subdev->insn_config = unioxx5_insn_config;
 
-	printk(KERN_INFO "subdevice configured\n");
+	pr_info("subdevice configured\n");
 
 	return 0;
 }
@@ -367,8 +367,7 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
 		       minor, channel);
 		return 0;
 	}
@@ -396,8 +395,7 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
 		       minor, channel);
 		return 0;
 	}
@@ -438,8 +436,7 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 
 	/* defining if given module can work on output */
 	if (!(usp->usp_module_type[module] & MODULE_OUTPUT_MASK)) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%0x is for input only!\n",
+		pr_err("comedi%d: module in position %d with id 0x%0x is for input only!\n",
 		       minor, module, usp->usp_module_type[module]);
 		return 0;
 	}
@@ -476,8 +473,7 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 
 	/* defining if given module can work on input */
 	if (usp->usp_module_type[module_no] & MODULE_OUTPUT_MASK) {
-		printk(KERN_ERR
-		       "comedi%d: module in position %d with id 0x%02x is for output only",
+		pr_err("comedi%d: module in position %d with id 0x%02x is for output only",
 		       minor, module_no, usp->usp_module_type[module_no]);
 		return 0;
 	}
-- 
1.7.0.4

