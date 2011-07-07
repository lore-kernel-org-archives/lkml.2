Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1GGOKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:10:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58420 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1GGOKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:10:46 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix brace coding style issue in serial2002.c
Date: Thu,  7 Jul 2011 19:53:04 +0530
Message-Id: <1310048584-3652-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix bracecoding style issue in serial2002.c>
References: <[PATCH]Staging: comedi: fix bracecoding style issue in serial2002.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the serial2002.c file that fixes up a brace warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/serial2002.c |   30 +++++++++------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index ebfce33..a1c6a1c 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -516,9 +516,8 @@ static int serial_2002_open(struct comedi_device *dev)
 								}
 								break;
 							}
-							if (sign) {
+							if (sign)
 								min = -min;
-							}
 							cur_config[channel].min
 							    = min;
 						}
@@ -557,9 +556,8 @@ static int serial_2002_open(struct comedi_device *dev)
 								}
 								break;
 							}
-							if (sign) {
+							if (sign)
 								max = -max;
-							}
 							cur_config[channel].max
 							    = max;
 						}
@@ -622,9 +620,8 @@ static int serial_2002_open(struct comedi_device *dev)
 				int j, chan;
 
 				for (chan = 0, j = 0; j < 32; j++) {
-					if (c[j].kind == kind) {
+					if (c[j].kind == kind)
 						chan++;
-					}
 				}
 				s = &dev->subdevices[i];
 				s->n_chan = chan;
@@ -649,9 +646,8 @@ static int serial_2002_open(struct comedi_device *dev)
 				}
 				for (chan = 0, j = 0; j < 32; j++) {
 					if (c[j].kind == kind) {
-						if (mapping) {
+						if (mapping)
 							mapping[chan] = j;
-						}
 						if (range) {
 							range[j].length = 1;
 							range[j].range.min =
@@ -704,9 +700,8 @@ err_alloc_configs:
 
 static void serial_2002_close(struct comedi_device *dev)
 {
-	if (!IS_ERR(devpriv->tty) && (devpriv->tty != 0)) {
+	if (!IS_ERR(devpriv->tty) && (devpriv->tty != 0))
 		filp_close(devpriv->tty, 0);
-	}
 }
 
 static int serial2002_di_rinsn(struct comedi_device *dev,
@@ -723,9 +718,8 @@ static int serial2002_di_rinsn(struct comedi_device *dev,
 		poll_digital(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_digital || read.index == chan) {
+			if (read.kind != is_digital || read.index == chan)
 				break;
-			}
 		}
 		data[n] = read.value;
 	}
@@ -765,9 +759,8 @@ static int serial2002_ai_rinsn(struct comedi_device *dev,
 		poll_channel(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_channel || read.index == chan) {
+			if (read.kind != is_channel || read.index == chan)
 				break;
-			}
 		}
 		data[n] = read.value;
 	}
@@ -801,9 +794,8 @@ static int serial2002_ao_rinsn(struct comedi_device *dev,
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (n = 0; n < insn->n; n++) {
+	for (n = 0; n < insn->n; n++)
 		data[n] = devpriv->ao_readback[chan];
-	}
 
 	return n;
 }
@@ -822,9 +814,8 @@ static int serial2002_ei_rinsn(struct comedi_device *dev,
 		poll_channel(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_channel || read.index == chan) {
+			if (read.kind != is_channel || read.index == chan)
 				break;
-			}
 		}
 		data[n] = read.value;
 	}
@@ -838,9 +829,8 @@ static int serial2002_attach(struct comedi_device *dev,
 
 	printk("comedi%d: serial2002: ", dev->minor);
 	dev->board_name = thisboard->name;
-	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0) {
+	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
 		return -ENOMEM;
-	}
 	dev->open = serial_2002_open;
 	dev->close = serial_2002_close;
 	devpriv->port = it->options[0];
-- 
1.6.5.2

