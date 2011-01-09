Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1AIXHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:07:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51440 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1AIXHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:07:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OjA3kYYbCSs4SjKurTFZrkjUEQrbnvCUjvwQjbQ8+L2LB6CqtWS5EasjA7Vghf4DS1
         Cj3Sok4ce88FOEbgIVjUxDDNpOergJOVgFF/Vh+QzUCMlqIa4iL55yFOddkssz+db/sc
         xja+fIBiWJZTJJDN3sfsaAfL/SNxoKOgZ5dCE=
From: ahern.michael.t@gmail.com
To: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mah <ahern.michael.t@gmail.com>
Subject: [PATCH 3/5] Coding style in unioxx5.c KERN_ facility level and coding style warnings as reported by checkpatch.pl Signed-off-by: Michael Ahern <ahern.michael.t@gmail.com>
Date: Mon, 10 Jan 2011 10:03:14 +1100
Message-Id: <1294614196-6665-3-git-send-email-ahern.michael.t@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
References: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mah <ahern.michael.t@gmail.com>

---
 drivers/staging/comedi/drivers/unioxx5.c |   65 +++++++++++++++++++----------
 1 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 598884e..334f036 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -72,13 +72,17 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
 #define ALL_2_INPUT  0		/* config all digital channels to input */
 #define ALL_2_OUTPUT 1		/* config all digital channels to output */
 
-/* 'private' structure for each subdevice */
+/* 'private' unioxx5 structure for each subdevice
+	usp_module_type - 12 modules. each can be 70L or 73L
+	usp_extra_data  - for saving previous written value for analog modules
+	usp_prev_wr_val	- previous written value
+	usp_prev_cn_val - previous channel value */
 struct unioxx5_subd_priv {
 	int usp_iobase;
-	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L or 73L */
-	unsigned char usp_extra_data[12][4];	/* for saving previous written value for analog modules */
-	unsigned char usp_prev_wr_val[3];	/* previous written value */
-	unsigned char usp_prev_cn_val[3];	/* previous channel value */
+	unsigned char usp_module_type[12];	/* see comment above */
+	unsigned char usp_extra_data[12][4];	/* see comment above */
+	unsigned char usp_prev_wr_val[3];	/* see comment above */
+	unsigned char usp_prev_cn_val[3];	/* see comment above */
 };
 
 static int unioxx5_attach(struct comedi_device *dev,
@@ -99,7 +103,8 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 				   unsigned int *data, int channel, int minor);
 static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 				  unsigned int *data, int channel, int minor);
-/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode); */
+/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp,
+					int mode); */
 static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 				  unsigned int *data, int channel, int minor);
 static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
@@ -139,8 +144,10 @@ static int unioxx5_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	iobase += UNIOXX5_SUBDEV_BASE;
 
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
-	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
+	/* defining number of subdevices and getting types (it must be 'g01') */
+	for (i = n_subd = 0, ba = iobase; i < 4;
+		i++, ba += UNIOXX5_SUBDEV_ODDS) {
+
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
 
@@ -169,7 +176,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 			return -1;
 	}
 
-	printk("attached\n");
+	printk(KERN_INFO "attached\n");
 	return 0;
 }
 
@@ -181,7 +188,8 @@ static int unioxx5_subdev_read(struct comedi_device *dev,
 	int channel, type;
 
 	channel = CR_CHAN(insn->chanspec);
-	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
+	/* defining module type(analog or digital) */
+	type = usp->usp_module_type[channel / 2];
 
 	if (type == MODULE_DIGITAL) {
 		if (!__unioxx5_digital_read(usp, data, channel, dev->minor))
@@ -202,7 +210,8 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
 	int channel, type;
 
 	channel = CR_CHAN(insn->chanspec);
-	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
+	/* defining module type(analog or digital) */
+	type = usp->usp_module_type[channel / 2];
 
 	if (type == MODULE_DIGITAL) {
 		if (!__unioxx5_digital_write(usp, data, channel, dev->minor))
@@ -259,11 +268,16 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	/*                                                        *\
 	 * sets channels buffer to 1(after this we are allowed to *
 	 * change channel type on input or output)                *
+	 *
+	outb(flags, ...) - changes type of _one_ channel
+	outb(0, ...)	 - sets channels bank to 0(allows directly input/output)
+	usp-> ... flags  - saves written value
+	 *
 	 \*                                                        */
 	outb(1, usp->usp_iobase + 0);
-	outb(flags, usp->usp_iobase + channel_offset);	/* changes type of _one_ channel */
-	outb(0, usp->usp_iobase + 0);	/* sets channels bank to 0(allows directly input/output) */
-	usp->usp_prev_cn_val[channel_offset - 1] = flags;	/* saves written value */
+	outb(flags, usp->usp_iobase + channel_offset);	/* see comment above */
+	outb(0, usp->usp_iobase + 0);				/* see above */
+	usp->usp_prev_cn_val[channel_offset - 1] = flags;	/* see above */
 
 	return 0;
 }
@@ -304,14 +318,14 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	}
 
 	usp->usp_iobase = subdev_iobase;
-	printk("comedi%d: |", minor);
+	printk(KERN_ERR "comedi%d: |", minor);
 
 	/* defining modules types */
 	for (i = 0; i < 12; i++) {
 		to = 10000;
 
 		__unioxx5_analog_config(usp, i * 2);
-		outb(i + 1, subdev_iobase + 5);	/* sends channel number to card */
+		outb(i + 1, subdev_iobase + 5);	/* sends channel num to card */
 		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
 		while (!(inb(subdev_iobase + 0) & TxBE))
 			;	/* waits while writting will be allowed */
@@ -346,9 +360,9 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	subdev->range_table = &range_digital;
 	subdev->insn_read = unioxx5_subdev_read;
 	subdev->insn_write = unioxx5_subdev_write;
-	subdev->insn_config = unioxx5_insn_config;	/* for digital modules only!!! */
+	subdev->insn_config = unioxx5_insn_config; /* 4 digital modules only */
 
-	printk("subdevice configured\n");
+	printk(KERN_INFO "subdevice configured\n");
 
 	return 0;
 }
@@ -367,7 +381,8 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 		return 0;
 	}
 
-	val = usp->usp_prev_wr_val[channel_offset - 1];	/* getting previous written value */
+	/* getting previous written value */
+	val = usp->usp_prev_wr_val[channel_offset - 1];
 
 	if (*data)
 		val |= mask;
@@ -375,7 +390,7 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 		val &= ~mask;
 
 	outb(val, usp->usp_iobase + channel_offset);
-	usp->usp_prev_wr_val[channel_offset - 1] = val;	/* saving new written value */
+	usp->usp_prev_wr_val[channel_offset - 1] = val;	/* save new value */
 
 	return 1;
 }
@@ -397,8 +412,9 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 	*data = inb(usp->usp_iobase + channel_offset);
 	*data &= mask;
 
+	/* this operation is created for correct readed value to 0 or 1 */
 	if (channel_offset > 1)
-		channel -= 2 << channel_offset;	/* this operation is created for correct readed value to 0 or 1 */
+		channel -= 2 << channel_offset;
 
 	*data >>= channel;
 	return 1;
@@ -444,7 +460,9 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 	usp->usp_extra_data[module][i] = (unsigned char)((*data & 0xFF00) >> 8);
 
 	/* while(!((inb(usp->usp_iobase + 0)) & TxBE)); */
-	outb(module + 1, usp->usp_iobase + 5);	/* sending module number to card(1 .. 12) */
+
+	/* sends module number to card(1 .. 12) */
+	outb(module + 1, usp->usp_iobase + 5);
 	outb('W', usp->usp_iobase + 6);	/* sends (W)rite command to module */
 
 	/* sending for bytes to module(one byte per cycle iteration) */
@@ -475,7 +493,8 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 	}
 
 	__unioxx5_analog_config(usp, channel);
-	outb(module_no + 1, usp->usp_iobase + 5);	/* sends module number to card(1 .. 12) */
+	/* sends module number to card(1 .. 12) */
+	outb(module_no + 1, usp->usp_iobase + 5);
 	outb('V', usp->usp_iobase + 6);	/* sends to module (V)erify command */
 	control = inb(usp->usp_iobase);	/* get control register byte */
 
-- 
1.7.0.4

