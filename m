Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1GGKyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:54:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42973 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1GGKyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:54:19 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarm32@gmail.com>
Subject: [PATCH 7/7] Staging: comedi: fix warning issue in unioxx5.c
Date: Thu,  7 Jul 2011 16:36:37 +0530
Message-Id: <1310036797-15964-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix printk and line over 80 character warning issues in unioxx5.c>
References: <[PATCH]Staging: comedi: fix printk and line over 80 character warning issues in unioxx5.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the unioxx5.c file that fixes up a warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarm32@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |   95 ++++++++++++++++-------------
 1 files changed, 52 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 88dafb7..a8fab8c 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -75,12 +75,13 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
 /* 'private' structure for each subdevice */
 struct unioxx5_subd_priv {
 	int usp_iobase;
-	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L
-						 * or 73L
-						*/
-	unsigned char usp_extra_data[12][4];	/* for saving previous written
-						 * value for analog modules
-						*/
+	/* 12 modules. each can be 70L or 73L */
+	unsigned char usp_module_type[12];
+
+	/*for saving previous written value for analog modules */
+	unsigned char usp_extra_data[12][4];
+
+
 
 	unsigned char usp_prev_wr_val[3];	/* previous written value */
 	unsigned char usp_prev_cn_val[3];	/* previous channel value */
@@ -144,7 +145,9 @@ static int unioxx5_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	iobase += UNIOXX5_SUBDEV_BASE;
 
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
+	/* defining number of subdevices and getting they types
+	 * (it must be 'g01')
+	 */
 	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
@@ -174,7 +177,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 			return -1;
 	}
 
-	printk("attached\n");
+	printk(KERN_INFO "attached\n");
 	return 0;
 }
 
@@ -186,7 +189,10 @@ static int unioxx5_subdev_read(struct comedi_device *dev,
 	int channel, type;
 
 	channel = CR_CHAN(insn->chanspec);
-	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
+	/* defining module type (analog or digital) */
+	type = usp->usp_module_type[channel / 2];
+
+
 
 	if (type == MODULE_DIGITAL) {
 		if (!__unioxx5_digital_read(usp, data, channel, dev->minor))
@@ -207,9 +213,9 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
 	int channel, type;
 
 	channel = CR_CHAN(insn->chanspec);
-	type = usp->usp_module_type[channel / 2];	/* defining module type
-							 * (analog or digital)
-							*/
+	/* defining module type (analog or digital) */
+	type = usp->usp_module_type[channel / 2];
+
 
 	if (type == MODULE_DIGITAL) {
 		if (!__unioxx5_digital_write(usp, data, channel, dev->minor))
@@ -268,13 +274,15 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	 * change channel type on input or output)                *
 	 \*                                                        */
 	outb(1, usp->usp_iobase + 0);
-	outb(flags, usp->usp_iobase + channel_offset);	/* changes type of
-							 * _one_ channel
-							*/
-	outb(0, usp->usp_iobase + 0);	/* sets channels bank to 0(allows directly input/output) */
-	usp->usp_prev_cn_val[channel_offset - 1] = flags;	/* saves written 
-								 * value
-								*/
+
+	/* changes type of_one_ channel*/
+	outb(flags, usp->usp_iobase + channel_offset);
+
+	/* sets channels bank to 0 (allows directly input/output) */
+	outb(0, usp->usp_iobase + 0);
+
+	/* saves written value */
+	usp->usp_prev_cn_val[channel_offset - 1] = flags;
 
 	return 0;
 }
@@ -315,16 +323,17 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	}
 
 	usp->usp_iobase = subdev_iobase;
-	printk("comedi%d: |", minor);
+	printk(KERN_INFO "comedi%d: |", minor);
 
 	/* defining modules types */
 	for (i = 0; i < 12; i++) {
 		to = 10000;
 
 		__unioxx5_analog_config(usp, i * 2);
-		outb(i + 1, subdev_iobase + 5);	/* sends channel number
-						 * to card
-						*/
+		/* sends channel number to card */
+		outb(i + 1, subdev_iobase + 5);
+
+
 		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
 		while (!(inb(subdev_iobase + 0) & TxBE))
 			;	/* waits while writting will be allowed */
@@ -359,9 +368,9 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	subdev->range_table = &range_digital;
 	subdev->insn_read = unioxx5_subdev_read;
 	subdev->insn_write = unioxx5_subdev_write;
-	subdev->insn_config = unioxx5_insn_config;	/* for digital modules 
-							 * only !!!
-							*/
+	/* for digital modules only !!! */
+	subdev->insn_config = unioxx5_insn_config;
+
 	printk(KERN_INFO "subdevice configured\n");
 
 	return 0;
@@ -380,19 +389,18 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 		       minor, channel);
 		return 0;
 	}
-
-	val = usp->usp_prev_wr_val[channel_offset - 1];	/* getting previous
-							 * written value
-							*/
+	/* getting previous written value */
+	val = usp->usp_prev_wr_val[channel_offset - 1];
 	if (*data)
 		val |= mask;
 	else
 		val &= ~mask;
 
 	outb(val, usp->usp_iobase + channel_offset);
-	usp->usp_prev_wr_val[channel_offset - 1] = val;	/* saving new written
-							 * value
-							*/
+	/* saving new written value */
+	usp->usp_prev_wr_val[channel_offset - 1] = val;
+
+
 	return 1;
 }
 
@@ -414,10 +422,9 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 	*data &= mask;
 
 	if (channel_offset > 1)
-		channel -= 2 << channel_offset;	/* this operation is created for
-						 * correct readed value to
-						 * 0 or 1
-						*/
+		/* this operation is created for correct read value to 0 or 1 */
+		channel -= 2 << channel_offset;
+
 
 	*data >>= channel;
 	return 1;
@@ -463,9 +470,10 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 	usp->usp_extra_data[module][i] = (unsigned char)((*data & 0xFF00) >> 8);
 
 	/* while(!((inb(usp->usp_iobase + 0)) & TxBE)); */
-	outb(module + 1, usp->usp_iobase + 5);	/* sending module number
-						 * to card (1..12)
-						*/
+	/* sends module number to card (1. .12) */
+	outb(module + 1, usp->usp_iobase + 5);
+
+
 	outb('W', usp->usp_iobase + 6);	/* sends (W)rite command to module */
 
 	/* sending for bytes to module(one byte per cycle iteration) */
@@ -496,9 +504,10 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 	}
 
 	__unioxx5_analog_config(usp, channel);
-	outb(module_no + 1, usp->usp_iobase + 5);	/* sends module number
-							 * to card (1. .12)
-							*/
+	/* sends module number to card (1. .12) */
+	outb(module_no + 1, usp->usp_iobase + 5);
+
+
 	outb('V', usp->usp_iobase + 6);	/* sends to module (V)erify command */
 	control = inb(usp->usp_iobase);	/* get control register byte */
 
-- 
1.6.5.2

