Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab2EKKmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:42:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35076 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab2EKKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:42:08 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 18/25] Staging: comedi: Checkpatch cleanups.
Date: Fri, 11 May 2012 16:08:06 +0530
Message-Id: <1336732693-7408-19-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/usbdux.c:1119: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:1139: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:1149: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:1222: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:1276: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:1623: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2345: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2364: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2388: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2397: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2406: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2415: WARNING: quoted string split across lines

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbdux.c |   73 +++++++++++++-----------------
 1 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 3d300ef..bd71671 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -1115,9 +1115,9 @@ static int send_dux_commands(struct usbduxsub *this_usbduxsub, int cmd_type)
 			      this_usbduxsub->dux_commands, SIZEOFDUXBUFFER,
 			      &nsent, BULK_TIMEOUT);
 	if (result < 0)
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
-			"could not transmit dux_command to the usb-device, "
-			"err=%d\n", this_usbduxsub->comedidev->minor, result);
+		dev_err(&this_usbduxsub->interface->dev,
+			"comedi%d: could not transmit dux_command to the usb-device, err=%d\n",
+			this_usbduxsub->comedidev->minor, result);
 
 	return result;
 }
@@ -1135,9 +1135,9 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 				      this_usbduxsub->insnBuffer, SIZEINSNBUF,
 				      &nrec, BULK_TIMEOUT);
 		if (result < 0) {
-			dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
-				"insn: USB error %d while receiving DUX command"
-				"\n", this_usbduxsub->comedidev->minor, result);
+			dev_err(&this_usbduxsub->interface->dev,
+				"comedi%d: insn: USB error %d while receiving DUX command\n",
+				this_usbduxsub->comedidev->minor, result);
 			return result;
 		}
 		if (le16_to_cpu(this_usbduxsub->insnBuffer[0]) == command)
@@ -1145,8 +1145,8 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 	}
 	/* this is only reached if the data has been requested a couple of
 	 * times */
-	dev_err(&this_usbduxsub->interface->dev, "comedi%d: insn: "
-		"wrong data returned from firmware: want cmd %d, got cmd %d.\n",
+	dev_err(&this_usbduxsub->interface->dev,
+		"comedi%d: insn: wrong data returned from firmware: want cmd %d, got cmd %d.\n",
 		this_usbduxsub->comedidev->minor, command,
 		le16_to_cpu(this_usbduxsub->insnBuffer[0]));
 	return -EFAULT;
@@ -1218,9 +1218,9 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return -ENODEV;
 	}
 	if (this_usbduxsub->ai_cmd_running) {
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
-			"ai_cmd not possible. Another ai_cmd is running.\n",
-			dev->minor);
+		dev_err(&this_usbduxsub->interface->dev,
+		"comedi%d: ai_cmd not possible. Another ai_cmd is running.\n",
+		dev->minor);
 		up(&this_usbduxsub->sem);
 		return -EBUSY;
 	}
@@ -1272,10 +1272,10 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		this_usbduxsub->ai_timer = cmd->scan_begin_arg / 1000000;
 	}
 	if (this_usbduxsub->ai_timer < 1) {
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: ai_cmd: "
-			"timer=%d, scan_begin_arg=%d. "
-			"Not properly tested by cmdtest?\n", dev->minor,
-			this_usbduxsub->ai_timer, cmd->scan_begin_arg);
+		dev_err(&this_usbduxsub->interface->dev,
+			"comedi%d: ai_cmd: timer=%d, scan_begin_arg=%d. Not properly tested by cmdtest?\n",
+			dev->minor, this_usbduxsub->ai_timer,
+			cmd->scan_begin_arg);
 		up(&this_usbduxsub->sem);
 		return -EINVAL;
 	}
@@ -1337,8 +1337,8 @@ static int usbdux_ai_insn_read(struct comedi_device *dev,
 	}
 	if (this_usbduxsub->ai_cmd_running) {
 		dev_err(&this_usbduxsub->interface->dev,
-			"comedi%d: ai_insn_read not possible. "
-			"Async Command is running.\n", dev->minor);
+			"comedi%d: ai_insn_read not possible. Async Command is running.\n",
+			dev->minor);
 		up(&this_usbduxsub->sem);
 		return 0;
 	}
@@ -1619,10 +1619,10 @@ static int usbdux_ao_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	dev_dbg(&this_usbduxsub->interface->dev, "comedi%d: err=%d, "
-		"scan_begin_src=%d, scan_begin_arg=%d, convert_src=%d, "
-		"convert_arg=%d\n", dev->minor, err, cmd->scan_begin_src,
-		cmd->scan_begin_arg, cmd->convert_src, cmd->convert_arg);
+	dev_dbg(&this_usbduxsub->interface->dev,
+		"comedi%d: err=%d, scan_begin_src=%d, scan_begin_arg=%d, convert_src=%d, convert_arg=%d\n",
+		dev->minor, err, cmd->scan_begin_src, cmd->scan_begin_arg,
+		cmd->convert_src, cmd->convert_arg);
 
 	if (err)
 		return 3;
@@ -1676,18 +1676,15 @@ static int usbdux_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/* timing of the scan: we get all channels at once */
 		this_usbduxsub->ao_timer = cmd->scan_begin_arg / 1000000;
 		dev_dbg(&this_usbduxsub->interface->dev,
-			"comedi%d: scan_begin_src=%d, scan_begin_arg=%d, "
-			"convert_src=%d, convert_arg=%d\n", dev->minor,
-			cmd->scan_begin_src, cmd->scan_begin_arg,
+			"comedi%d: scan_begin_src=%d, scan_begin_arg=%d, convert_src=%d, convert_arg=%d\n",
+			dev->minor, cmd->scan_begin_src, cmd->scan_begin_arg,
 			cmd->convert_src, cmd->convert_arg);
 		dev_dbg(&this_usbduxsub->interface->dev,
 			"comedi%d: ao_timer=%d (ms)\n",
 			dev->minor, this_usbduxsub->ao_timer);
 		if (this_usbduxsub->ao_timer < 1) {
 			dev_err(&this_usbduxsub->interface->dev,
-				"comedi%d: usbdux: ao_timer=%d, "
-				"scan_begin_arg=%d. "
-				"Not properly tested by cmdtest?\n",
+				"comedi%d: ao_timer=%d, scan_begin_arg=%d. Not properly tested by cmdtest?\n",
 				dev->minor, this_usbduxsub->ao_timer,
 				cmd->scan_begin_arg);
 			up(&this_usbduxsub->sem);
@@ -2341,8 +2338,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	int index;
 	int ret;
 
-	dev_dbg(dev, "comedi_: usbdux_: "
-		"finding a free structure for the usb-device\n");
+	dev_dbg(dev, "comedi_: finding a free structure for the usb-device\n");
 
 	down(&start_stop_sem);
 	/* look for a free place in the usbdux array */
@@ -2360,8 +2356,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		up(&start_stop_sem);
 		return -EMFILE;
 	}
-	dev_dbg(dev, "comedi_: usbdux: "
-		"usbduxsub[%d] is ready to connect to comedi.\n", index);
+	dev_dbg(dev, "comedi_: usbduxsub[%d] is ready to connect to comedi.\n",
+		index);
 
 	sema_init(&(usbduxsub[index].sem), 1);
 	/* save a pointer to the usb device */
@@ -2384,8 +2380,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the commands of the DA converter */
 	usbduxsub[index].dac_commands = kzalloc(NUMOUTCHANNELS, GFP_KERNEL);
 	if (!usbduxsub[index].dac_commands) {
-		dev_err(dev, "comedi_: usbdux: "
-			"error alloc space for dac commands\n");
+		dev_err(dev, "comedi_: error alloc space for dac commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2393,8 +2388,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the commands going to the usb device */
 	usbduxsub[index].dux_commands = kzalloc(SIZEOFDUXBUFFER, GFP_KERNEL);
 	if (!usbduxsub[index].dux_commands) {
-		dev_err(dev, "comedi_: usbdux: "
-			"error alloc space for dux commands\n");
+		dev_err(dev, "comedi_: error alloc space for dux commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2402,8 +2396,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the in buffer and set it to zero */
 	usbduxsub[index].inBuffer = kzalloc(SIZEINBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].inBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"could not alloc space for inBuffer\n");
+		dev_err(dev, "comedi_: could not alloc space for inBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2411,8 +2404,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxsub[index].insnBuffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].insnBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"could not alloc space for insnBuffer\n");
+		dev_err(dev, "comedi_: could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2420,8 +2412,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the outbuffer */
 	usbduxsub[index].outBuffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].outBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"could not alloc space for outBuffer\n");
+		dev_err(dev, "comedi_: could not alloc space for outBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
-- 
1.7.0.4

