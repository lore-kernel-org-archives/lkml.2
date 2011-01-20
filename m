Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1ATHuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:50:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63525 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1ATHuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=epESzVBCchA5YrZwhlQ920JmuA9Mis4qyZmpWhxdSI2V/9ozguxVA9mZ62I3lZp6tu
         p1+7ghyC3SEAi5hshWfBHKSdl9d7Nv+Gx2BeTkggeQffO4rtPYrwpMahucaJlS97nBds
         Un6X7l2fdrBcQUXOUoUsNivk2pzpdXJncjBnM=
From: ahern.michael.t@gmail.com
To: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michael Ahern <ahern.michael.t@gmail.com>
Subject: [PATCH] Coding style in serial2002
Date: Thu, 20 Jan 2011 18:50:02 +1100
Message-Id: <1295509802-18042-1-git-send-email-ahern.michael.t@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ahern <ahern.michael.t@gmail.com>

This patch resolves braces and KERN_ warnings by checkpatch.pl
Warnings: printk() should include KERN_ facility level, removed unnecessary braces, lines over 80 chars

Signed-off-by: Michael Ahern <ahern.michael.t@gmail.com>
---
 drivers/staging/comedi/drivers/serial2002.c |  172 ++++++++++++---------------
 1 files changed, 76 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 6949086..eee14dd 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -246,7 +246,12 @@ static void tty_setspeed(struct file *f, int speed)
 		struct termios settings;
 
 		tty_ioctl(f, TCGETS, (unsigned long)&settings);
-/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX)); */
+
+		/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
+		 * better
+		 * pr_info("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
+		 */
+
 		settings.c_iflag = 0;
 		settings.c_oflag = 0;
 		settings.c_lflag = 0;
@@ -254,41 +259,36 @@ static void tty_setspeed(struct file *f, int speed)
 		settings.c_cc[VMIN] = 0;
 		settings.c_cc[VTIME] = 0;
 		switch (speed) {
-		case 2400:{
-				settings.c_cflag |= B2400;
-			}
+		case 2400:
+			settings.c_cflag |= B2400;
 			break;
-		case 4800:{
-				settings.c_cflag |= B4800;
-			}
+		case 4800:
+			settings.c_cflag |= B4800;
 			break;
-		case 9600:{
-				settings.c_cflag |= B9600;
-			}
+		case 9600:
+			settings.c_cflag |= B9600;
 			break;
-		case 19200:{
-				settings.c_cflag |= B19200;
-			}
+		case 19200:
+			settings.c_cflag |= B19200;
 			break;
-		case 38400:{
-				settings.c_cflag |= B38400;
-			}
+		case 38400:
+			settings.c_cflag |= B38400;
 			break;
-		case 57600:{
-				settings.c_cflag |= B57600;
-			}
+		case 57600:
+			settings.c_cflag |= B57600;
 			break;
-		case 115200:{
-				settings.c_cflag |= B115200;
-			}
+		case 115200:
+			settings.c_cflag |= B115200;
 			break;
-		default:{
-				settings.c_cflag |= B9600;
-			}
+		default:
+			settings.c_cflag |= B9600;
 			break;
 		}
 		tty_ioctl(f, TCSETS, (unsigned long)&settings);
-/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX)); */
+/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
+ * better
+ * pr_info("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
+ */
 	}
 	{
 		/*  Set low latency */
@@ -332,22 +332,20 @@ static struct serial_data serial_read(struct file *f, int timeout)
 
 		length++;
 		if (data < 0) {
-			printk(KERN_ERR "serial2002 error\n");
+			pr_err("serial2002 error\n");
 			break;
 		} else if (data & 0x80) {
 			result.value = (result.value << 7) | (data & 0x7f);
 		} else {
 			if (length == 1) {
 				switch ((data >> 5) & 0x03) {
-				case 0:{
-						result.value = 0;
-						result.kind = is_digital;
-					}
+				case 0:
+					result.value = 0;
+					result.kind = is_digital;
 					break;
-				case 1:{
-						result.value = 1;
-						result.kind = is_digital;
-					}
+				case 1:
+					result.value = 1;
+					result.kind = is_digital;
 					break;
 				}
 			} else {
@@ -405,7 +403,7 @@ static int serial_2002_open(struct comedi_device *dev)
 	devpriv->tty = filp_open(port, O_RDWR, 0);
 	if (IS_ERR(devpriv->tty)) {
 		result = (int)PTR_ERR(devpriv->tty);
-		printk(KERN_ERR "serial_2002: file open error = %d\n", result);
+		pr_err("serial_2002: file open error = %d\n", result);
 	} else {
 		struct config_t {
 
@@ -453,38 +451,32 @@ static int serial_2002_open(struct comedi_device *dev)
 				kind = (data.value >> 5) & 0x7;
 				command = (data.value >> 8) & 0x3;
 				switch (kind) {
-				case 1:{
+				case 1:
 					cur_config = dig_in_config;
-					}
 					break;
-				case 2:{
+				case 2:
 					cur_config = dig_out_config;
-					}
 					break;
-				case 3:{
+				case 3:
 					cur_config = chan_in_config;
-					}
 					break;
-				case 4:{
+				case 4:
 					cur_config = chan_out_config;
-					}
 					break;
-				case 5:{
+				case 5:
 					cur_config = chan_in_config;
-					}
 					break;
 				}
 
 				if (cur_config) {
 					cur_config[channel].kind = kind;
 					switch (command) {
-					case 0:{
+					case 0:
 						cur_config[channel].bits
 							= (data.value >> 10) &
 							0x3f;
-						}
 						break;
-					case 1:{
+					case 1: {
 						int unit, sign, min;
 						unit = (data.value >> 10) &
 							0x7;
@@ -494,17 +486,14 @@ static int serial_2002_open(struct comedi_device *dev)
 							0xfffff;
 
 						switch (unit) {
-						case 0:{
+						case 0:
 							min = min * 1000000;
-							}
 							break;
-						case 1:{
+						case 1:
 							min = min * 1000;
-							}
 							break;
-						case 2:{
+						case 2:
 							min = min * 1;
-							}
 							break;
 						}
 
@@ -514,7 +503,7 @@ static int serial_2002_open(struct comedi_device *dev)
 						cur_config[channel].min = min;
 						}
 						break;
-					case 2:{
+					case 2: {
 						int unit, sign, max;
 						unit = (data.value >> 10) &
 							0x7;
@@ -524,17 +513,14 @@ static int serial_2002_open(struct comedi_device *dev)
 							0xfffff;
 
 						switch (unit) {
-						case 0:{
+						case 0:
 							max = max * 1000000;
-							}
 							break;
-						case 1:{
+						case 1:
 							max = max * 1000;
-							}
 							break;
-						case 2:{
+						case 2:
 							max = max * 1;
-							}
 							break;
 						}
 
@@ -556,42 +542,36 @@ static int serial_2002_open(struct comedi_device *dev)
 			int kind = 0;
 
 			switch (i) {
-			case 0:{
-					c = dig_in_config;
-					mapping = devpriv->digital_in_mapping;
-					kind = 1;
-				}
+			case 0:
+				c = dig_in_config;
+				mapping = devpriv->digital_in_mapping;
+				kind = 1;
 				break;
-			case 1:{
-					c = dig_out_config;
-					mapping = devpriv->digital_out_mapping;
-					kind = 2;
-				}
+			case 1:
+				c = dig_out_config;
+				mapping = devpriv->digital_out_mapping;
+				kind = 2;
 				break;
-			case 2:{
-					c = chan_in_config;
-					mapping = devpriv->analog_in_mapping;
-					range = devpriv->in_range;
-					kind = 3;
-				}
+			case 2:
+				c = chan_in_config;
+				mapping = devpriv->analog_in_mapping;
+				range = devpriv->in_range;
+				kind = 3;
 				break;
-			case 3:{
-					c = chan_out_config;
-					mapping = devpriv->analog_out_mapping;
-					range = devpriv->out_range;
-					kind = 4;
-				}
+			case 3:
+				c = chan_out_config;
+				mapping = devpriv->analog_out_mapping;
+				range = devpriv->out_range;
+				kind = 4;
 				break;
-			case 4:{
-					c = chan_in_config;
-					mapping = devpriv->encoder_in_mapping;
-					range = devpriv->in_range;
-					kind = 5;
-				}
+			case 4:
+				c = chan_in_config;
+				mapping = devpriv->encoder_in_mapping;
+				range = devpriv->in_range;
+				kind = 5;
 				break;
-			default:{
-					c = NULL;
-				}
+			default:
+				c = NULL;
 				break;
 			}
 			if (c) {
@@ -816,7 +796,7 @@ static int serial2002_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 
-	printk(KERN_INFO "comedi%d: serial2002: ", dev->minor);
+	pr_info("comedi%d: serial2002: ", dev->minor);
 	dev->board_name = thisboard->name;
 	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
 		return -ENOMEM;
@@ -825,7 +805,7 @@ static int serial2002_attach(struct comedi_device *dev,
 	dev->close = serial_2002_close;
 	devpriv->port = it->options[0];
 	devpriv->speed = it->options[1];
-	printk(KERN_INFO "/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
+	pr_info("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
 
 	if (alloc_subdevices(dev, 5) < 0)
 		return -ENOMEM;
@@ -884,7 +864,7 @@ static int serial2002_detach(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 	int i;
 
-	printk(KERN_ERR "comedi%d: serial2002: remove\n", dev->minor);
+	pr_err("comedi%d: serial2002: remove\n", dev->minor);
 	for (i = 0; i < 5; i++) {
 		s = &dev->subdevices[i];
 		if (s->maxdata_list)
-- 
1.7.0.4

