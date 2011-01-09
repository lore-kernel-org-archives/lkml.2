Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1AIXD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:03:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63620 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1AIXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h+vejtOK8f7FyoPfMQQ06oS+kZQB4e4AJJgFoF9tS9In7fTBf3IRLz4pk4aTohZz6N
         Dys93FCwUivUrOlu3UArJWuw5HWf/g+abXgFTWptStwqjat3ezDSulQq0SgvOFORVGxl
         xA4cIRS/lWh8KF516IA/Zktt9C1qW88I3wqF4=
From: ahern.michael.t@gmail.com
To: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mah <ahern.michael.t@gmail.com>
Subject: [PATCH 4/5] Coding style in serial2002 Patch that resolves braces and KERN_ warnings by checkpatch.pl Signed-off-by: Michael Ahern
Date: Mon, 10 Jan 2011 10:03:15 +1100
Message-Id: <1294614196-6665-4-git-send-email-ahern.michael.t@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
References: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mah <ahern.michael.t@gmail.com>

---
 drivers/staging/comedi/drivers/serial2002.c |  206 ++++++++++++---------------
 1 files changed, 93 insertions(+), 113 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index c9be9e0..6949086 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -192,9 +192,10 @@ static int tty_read(struct file *f, int timeout)
 				elapsed =
 				    (1000000 * (now.tv_sec - start.tv_sec) +
 				     now.tv_usec - start.tv_usec);
-				if (elapsed > timeout) {
+
+				if (elapsed > timeout)
 					break;
-				}
+
 				set_current_state(TASK_INTERRUPTIBLE);
 				schedule_timeout(((timeout -
 						   elapsed) * HZ) / 10000);
@@ -204,9 +205,10 @@ static int tty_read(struct file *f, int timeout)
 				unsigned char ch;
 
 				f->f_pos = 0;
-				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1) {
+
+				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1)
 					result = ch;
-				}
+
 			}
 		} else {
 			/* Device does not support poll, busy wait */
@@ -215,9 +217,10 @@ static int tty_read(struct file *f, int timeout)
 				unsigned char ch;
 
 				retries++;
-				if (retries >= timeout) {
+
+				if (retries >= timeout)
 					break;
-				}
+
 
 				f->f_pos = 0;
 				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1) {
@@ -329,7 +332,7 @@ static struct serial_data serial_read(struct file *f, int timeout)
 
 		length++;
 		if (data < 0) {
-			printk("serial2002 error\n");
+			printk(KERN_ERR "serial2002 error\n");
 			break;
 		} else if (data & 0x80) {
 			result.value = (result.value << 7) | (data & 0x7f);
@@ -402,7 +405,7 @@ static int serial_2002_open(struct comedi_device *dev)
 	devpriv->tty = filp_open(port, O_RDWR, 0);
 	if (IS_ERR(devpriv->tty)) {
 		result = (int)PTR_ERR(devpriv->tty);
-		printk("serial_2002: file open error = %d\n", result);
+		printk(KERN_ERR "serial_2002: file open error = %d\n", result);
 	} else {
 		struct config_t {
 
@@ -434,7 +437,7 @@ static int serial_2002_open(struct comedi_device *dev)
 		}
 
 		tty_setspeed(devpriv->tty, devpriv->speed);
-		poll_channel(devpriv->tty, 31);	/*  Start reading configuration */
+		poll_channel(devpriv->tty, 31);	/* Start reading config */
 		while (1) {
 			struct serial_data data;
 
@@ -451,23 +454,23 @@ static int serial_2002_open(struct comedi_device *dev)
 				command = (data.value >> 8) & 0x3;
 				switch (kind) {
 				case 1:{
-						cur_config = dig_in_config;
+					cur_config = dig_in_config;
 					}
 					break;
 				case 2:{
-						cur_config = dig_out_config;
+					cur_config = dig_out_config;
 					}
 					break;
 				case 3:{
-						cur_config = chan_in_config;
+					cur_config = chan_in_config;
 					}
 					break;
 				case 4:{
-						cur_config = chan_out_config;
+					cur_config = chan_out_config;
 					}
 					break;
 				case 5:{
-						cur_config = chan_in_config;
+					cur_config = chan_in_config;
 					}
 					break;
 				}
@@ -476,92 +479,69 @@ static int serial_2002_open(struct comedi_device *dev)
 					cur_config[channel].kind = kind;
 					switch (command) {
 					case 0:{
-							cur_config[channel].bits
-							    =
-							    (data.value >> 10) &
-							    0x3f;
+						cur_config[channel].bits
+							= (data.value >> 10) &
+							0x3f;
 						}
 						break;
 					case 1:{
-							int unit, sign, min;
-							unit =
-							    (data.value >> 10) &
-							    0x7;
-							sign =
-							    (data.value >> 13) &
-							    0x1;
-							min =
-							    (data.value >> 14) &
-							    0xfffff;
-
-							switch (unit) {
-							case 0:{
-									min =
-									    min
-									    *
-									    1000000;
-								}
-								break;
-							case 1:{
-									min =
-									    min
-									    *
-									    1000;
-								}
-								break;
-							case 2:{
-									min =
-									    min
-									    * 1;
-								}
-								break;
+						int unit, sign, min;
+						unit = (data.value >> 10) &
+							0x7;
+						sign = (data.value >> 13) &
+							0x1;
+						min = (data.value >> 14) &
+							0xfffff;
+
+						switch (unit) {
+						case 0:{
+							min = min * 1000000;
 							}
-							if (sign) {
-								min = -min;
+							break;
+						case 1:{
+							min = min * 1000;
 							}
-							cur_config[channel].min
-							    = min;
+							break;
+						case 2:{
+							min = min * 1;
+							}
+							break;
+						}
+
+						if (sign)
+							min = -min;
+
+						cur_config[channel].min = min;
 						}
 						break;
 					case 2:{
-							int unit, sign, max;
-							unit =
-							    (data.value >> 10) &
-							    0x7;
-							sign =
-							    (data.value >> 13) &
-							    0x1;
-							max =
-							    (data.value >> 14) &
-							    0xfffff;
-
-							switch (unit) {
-							case 0:{
-									max =
-									    max
-									    *
-									    1000000;
-								}
-								break;
-							case 1:{
-									max =
-									    max
-									    *
-									    1000;
-								}
-								break;
-							case 2:{
-									max =
-									    max
-									    * 1;
-								}
-								break;
+						int unit, sign, max;
+						unit = (data.value >> 10) &
+							0x7;
+						sign = (data.value >> 13) &
+							0x1;
+						max = (data.value >> 14) &
+							0xfffff;
+
+						switch (unit) {
+						case 0:{
+							max = max * 1000000;
+							}
+							break;
+						case 1:{
+							max = max * 1000;
 							}
-							if (sign) {
-								max = -max;
+							break;
+						case 2:{
+							max = max * 1;
 							}
-							cur_config[channel].max
-							    = max;
+							break;
+						}
+
+						if (sign)
+							max = -max;
+
+						cur_config[channel].max = max;
 						}
 						break;
 					}
@@ -622,9 +602,9 @@ static int serial_2002_open(struct comedi_device *dev)
 				int j, chan;
 
 				for (chan = 0, j = 0; j < 32; j++) {
-					if (c[j].kind == kind) {
+					if (c[j].kind == kind)
 						chan++;
-					}
+
 				}
 				s = &dev->subdevices[i];
 				s->n_chan = chan;
@@ -649,9 +629,9 @@ static int serial_2002_open(struct comedi_device *dev)
 				}
 				for (chan = 0, j = 0; j < 32; j++) {
 					if (c[j].kind == kind) {
-						if (mapping) {
+						if (mapping)
 							mapping[chan] = j;
-						}
+
 						if (range) {
 							range[j].length = 1;
 							range[j].range.min =
@@ -704,9 +684,9 @@ err_alloc_configs:
 
 static void serial_2002_close(struct comedi_device *dev)
 {
-	if (!IS_ERR(devpriv->tty) && (devpriv->tty != 0)) {
+	if (!IS_ERR(devpriv->tty) && (devpriv->tty != 0))
 		filp_close(devpriv->tty, 0);
-	}
+
 }
 
 static int serial2002_di_rinsn(struct comedi_device *dev,
@@ -723,9 +703,9 @@ static int serial2002_di_rinsn(struct comedi_device *dev,
 		poll_digital(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_digital || read.index == chan) {
+			if (read.kind != is_digital || read.index == chan)
 				break;
-			}
+
 		}
 		data[n] = read.value;
 	}
@@ -765,9 +745,9 @@ static int serial2002_ai_rinsn(struct comedi_device *dev,
 		poll_channel(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_channel || read.index == chan) {
+			if (read.kind != is_channel || read.index == chan)
 				break;
-			}
+
 		}
 		data[n] = read.value;
 	}
@@ -801,9 +781,9 @@ static int serial2002_ao_rinsn(struct comedi_device *dev,
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (n = 0; n < insn->n; n++) {
+	for (n = 0; n < insn->n; n++)
 		data[n] = devpriv->ao_readback[chan];
-	}
+
 
 	return n;
 }
@@ -822,9 +802,9 @@ static int serial2002_ei_rinsn(struct comedi_device *dev,
 		poll_channel(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_channel || read.index == chan) {
+			if (read.kind != is_channel || read.index == chan)
 				break;
-			}
+
 		}
 		data[n] = read.value;
 	}
@@ -836,16 +816,16 @@ static int serial2002_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: serial2002: ", dev->minor);
+	printk(KERN_INFO "comedi%d: serial2002: ", dev->minor);
 	dev->board_name = thisboard->name;
-	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0) {
+	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
 		return -ENOMEM;
-	}
+
 	dev->open = serial_2002_open;
 	dev->close = serial_2002_close;
 	devpriv->port = it->options[0];
 	devpriv->speed = it->options[1];
-	printk("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
+	printk(KERN_INFO "/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
 
 	if (alloc_subdevices(dev, 5) < 0)
 		return -ENOMEM;
@@ -904,15 +884,15 @@ static int serial2002_detach(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 	int i;
 
-	printk("comedi%d: serial2002: remove\n", dev->minor);
+	printk(KERN_ERR "comedi%d: serial2002: remove\n", dev->minor);
 	for (i = 0; i < 5; i++) {
 		s = &dev->subdevices[i];
-		if (s->maxdata_list) {
+		if (s->maxdata_list)
 			kfree(s->maxdata_list);
-		}
-		if (s->range_table_list) {
+
+		if (s->range_table_list)
 			kfree(s->range_table_list);
-		}
+
 	}
 	return 0;
 }
-- 
1.7.0.4

