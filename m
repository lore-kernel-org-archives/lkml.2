Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1COX5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:57:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39259 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab1COX5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VoW0ZtOZsgbLmNmwY6/Y0VOna6nJ6rh1tjYggdCqbWRJKXaGOjT+ZZ7iBXa+GyEoMT
         uvoBdTZIHtpEJF90CfeeCRmXz3ztFEdtP/vgacbeTavMxfh6yQ7+SVlHXKWonlb0/Kvp
         /v7ad1OS7WoR3ZqgIPmu7fx++MAYrgmVbxuiI=
From: ellwync@gmail.com
To: gregkh@suse.de, arun.thomas@gmail.com, julia@diku.dk, tj@kernel.org,
        john.d.sheehan@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Ellwyn C <ellwync@googlemail.com>
Subject: [PATCH] Staging: comedi: Fix 80 characters limit and printk issues in unioxx5.c
Date: Tue, 15 Mar 2011 23:57:04 +0000
Message-Id: <4d7ffceb.dd25e30a.10e8.1876@mx.google.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ellwyn C <ellwync@googlemail.com>

This is a patch to the unioxx5.c file that fixes the 80 characters limit and
printk warnings found by the checkpatch.pl tool

Signed-off-by: Ellwyn C <ellwync@googlemail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |   61 +++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 598884e..0d91f53 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -75,8 +75,10 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
 /* 'private' structure for each subdevice */
 struct unioxx5_subd_priv {
 	int usp_iobase;
-	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L or 73L */
-	unsigned char usp_extra_data[12][4];	/* for saving previous written value for analog modules */
+	unsigned char usp_module_type[12];
+	/* 12 modules. each can be 70L or 73L */
+	unsigned char usp_extra_data[12][4];
+	/* for saving previous written value for analog modules */
 	unsigned char usp_prev_wr_val[3];	/* previous written value */
 	unsigned char usp_prev_cn_val[3];	/* previous channel value */
 };
@@ -99,7 +101,8 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 				   unsigned int *data, int channel, int minor);
 static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 				  unsigned int *data, int channel, int minor);
-/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode); */
+/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode)
+; */
 static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 				  unsigned int *data, int channel, int minor);
 static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
@@ -139,8 +142,10 @@ static int unioxx5_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	iobase += UNIOXX5_SUBDEV_BASE;
 
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
-	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
+	/* defining number of subdevices and getting they types
+	(it must be 'g01')  */
+	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba +=
+	UNIOXX5_SUBDEV_ODDS) {
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
 
@@ -169,7 +174,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 			return -1;
 	}
 
-	printk("attached\n");
+	pr_info("attached\n");
 	return 0;
 }
 
@@ -181,7 +186,8 @@ static int unioxx5_subdev_read(struct comedi_device *dev,
 	int channel, type;
 
 	channel = CR_CHAN(insn->chanspec);
-	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
+	type = usp->usp_module_type[channel / 2];
+	/* defining module type(analog or digital) */
 
 	if (type == MODULE_DIGITAL) {
 		if (!__unioxx5_digital_read(usp, data, channel, dev->minor))
@@ -202,7 +208,8 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
 	int channel, type;
 
 	channel = CR_CHAN(insn->chanspec);
-	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
+	type = usp->usp_module_type[channel / 2];
+	/* defining module type(analog or digital) */
 
 	if (type == MODULE_DIGITAL) {
 		if (!__unioxx5_digital_write(usp, data, channel, dev->minor))
@@ -261,9 +268,12 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	 * change channel type on input or output)                *
 	 \*                                                        */
 	outb(1, usp->usp_iobase + 0);
-	outb(flags, usp->usp_iobase + channel_offset);	/* changes type of _one_ channel */
-	outb(0, usp->usp_iobase + 0);	/* sets channels bank to 0(allows directly input/output) */
-	usp->usp_prev_cn_val[channel_offset - 1] = flags;	/* saves written value */
+	outb(flags, usp->usp_iobase + channel_offset);
+	/* changes type of _one_ channel */
+	outb(0, usp->usp_iobase + 0);
+	/* sets channels bank to 0(allows directly input/output) */
+	usp->usp_prev_cn_val[channel_offset - 1] = flags;
+	/* saves written value */
 
 	return 0;
 }
@@ -304,14 +314,15 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	}
 
 	usp->usp_iobase = subdev_iobase;
-	printk("comedi%d: |", minor);
+	pr_info("comedi%d: |", minor);
 
 	/* defining modules types */
 	for (i = 0; i < 12; i++) {
 		to = 10000;
 
 		__unioxx5_analog_config(usp, i * 2);
-		outb(i + 1, subdev_iobase + 5);	/* sends channel number to card */
+		outb(i + 1, subdev_iobase + 5);
+		/* sends channel number to card */
 		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
 		while (!(inb(subdev_iobase + 0) & TxBE))
 			;	/* waits while writting will be allowed */
@@ -331,11 +342,11 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 		} else
 			usp->usp_module_type[i] = inb(subdev_iobase + 6);
 
-		printk(" [%d] 0x%02x |", i, usp->usp_module_type[i]);
+		pr_info(" [%d] 0x%02x |", i, usp->usp_module_type[i]);
 		udelay(1);
 	}
 
-	printk("\n");
+	pr_info("\n");
 
 	/* initial subdevice for digital or analog i/o */
 	subdev->type = COMEDI_SUBD_DIO;
@@ -346,9 +357,10 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	subdev->range_table = &range_digital;
 	subdev->insn_read = unioxx5_subdev_read;
 	subdev->insn_write = unioxx5_subdev_write;
-	subdev->insn_config = unioxx5_insn_config;	/* for digital modules only!!! */
+	subdev->insn_config = unioxx5_insn_config;
+	/* for digital modules only!!! */
 
-	printk("subdevice configured\n");
+	pr_info("subdevice configured\n");
 
 	return 0;
 }
@@ -367,7 +379,8 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 		return 0;
 	}
 
-	val = usp->usp_prev_wr_val[channel_offset - 1];	/* getting previous written value */
+	val = usp->usp_prev_wr_val[channel_offset - 1];
+	/* getting previous written value */
 
 	if (*data)
 		val |= mask;
@@ -375,7 +388,8 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 		val &= ~mask;
 
 	outb(val, usp->usp_iobase + channel_offset);
-	usp->usp_prev_wr_val[channel_offset - 1] = val;	/* saving new written value */
+	usp->usp_prev_wr_val[channel_offset - 1] = val;
+	/* saving new written value */
 
 	return 1;
 }
@@ -398,7 +412,8 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 	*data &= mask;
 
 	if (channel_offset > 1)
-		channel -= 2 << channel_offset;	/* this operation is created for correct readed value to 0 or 1 */
+		channel -= 2 << channel_offset;
+	/* this operation is created for correct readed value to 0 or 1 */
 
 	*data >>= channel;
 	return 1;
@@ -444,7 +459,8 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 	usp->usp_extra_data[module][i] = (unsigned char)((*data & 0xFF00) >> 8);
 
 	/* while(!((inb(usp->usp_iobase + 0)) & TxBE)); */
-	outb(module + 1, usp->usp_iobase + 5);	/* sending module number to card(1 .. 12) */
+	outb(module + 1, usp->usp_iobase + 5);
+	/* sending module number to card(1 .. 12) */
 	outb('W', usp->usp_iobase + 6);	/* sends (W)rite command to module */
 
 	/* sending for bytes to module(one byte per cycle iteration) */
@@ -475,7 +491,8 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 	}
 
 	__unioxx5_analog_config(usp, channel);
-	outb(module_no + 1, usp->usp_iobase + 5);	/* sends module number to card(1 .. 12) */
+	outb(module_no + 1, usp->usp_iobase + 5);
+	/* sends module number to card(1 .. 12) */
 	outb('V', usp->usp_iobase + 6);	/* sends to module (V)erify command */
 	control = inb(usp->usp_iobase);	/* get control register byte */
 
-- 
1.7.2.3

