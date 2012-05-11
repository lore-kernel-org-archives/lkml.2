Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab2EKKmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:42:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2EKKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:42:30 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 20/25] Staging: comedi: Checkpatch cleanups.
Date: Fri, 11 May 2012 16:08:08 +0530
Message-Id: <1336732693-7408-21-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/usbduxsigma.c:1085: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbduxsigma.c:1105: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbduxsigma.c:1117: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbduxsigma.c:1193: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbduxsigma.c:1255: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbduxsigma.c:1687: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbduxsigma.c:2353: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbduxsigma.c:2372: WARNING: quoted string split across lines

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxsigma.c |  102 +++++++++++---------------
 1 files changed, 44 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index f21bb0d..83e1669 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -1081,9 +1081,9 @@ static int send_dux_commands(struct usbduxsub *this_usbduxsub, int cmd_type)
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
@@ -1101,11 +1101,9 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 				      this_usbduxsub->insnBuffer, SIZEINSNBUF,
 				      &nrec, BULK_TIMEOUT);
 		if (result < 0) {
-			dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
-				"insn: USB error %d "
-				"while receiving DUX command"
-				"\n", this_usbduxsub->comedidev->minor,
-				result);
+			dev_err(&this_usbduxsub->interface->dev,
+				"comedi%d: insn: USB error %d while receiving DUX command\n",
+				this_usbduxsub->comedidev->minor, result);
 			return result;
 		}
 		if (this_usbduxsub->insnBuffer[0] == command)
@@ -1113,8 +1111,8 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 	}
 	/* this is only reached if the data has been requested a couple of
 	 * times */
-	dev_err(&this_usbduxsub->interface->dev, "comedi%d: insn: "
-		"wrong data returned from firmware: want %d, got %d.\n",
+	dev_err(&this_usbduxsub->interface->dev,
+		"comedi%d: insn: wrong data returned from firmware: want %d, got %d.\n",
 		this_usbduxsub->comedidev->minor, command,
 		this_usbduxsub->insnBuffer[0]);
 	return -EFAULT;
@@ -1189,8 +1187,8 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return -ENODEV;
 	}
 	if (this_usbduxsub->ai_cmd_running) {
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
-			"ai_cmd not possible. Another ai_cmd is running.\n",
+		dev_err(&this_usbduxsub->interface->dev,
+			"comedi%d: ai_cmd not possible. Another ai_cmd is running.\n",
 			dev->minor);
 		up(&this_usbduxsub->sem);
 		return -EBUSY;
@@ -1251,10 +1249,10 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
@@ -1683,10 +1681,10 @@ static int usbdux_ao_cmdtest(struct comedi_device *dev,
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
@@ -1740,18 +1738,15 @@ static int usbdux_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
@@ -2349,8 +2344,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	int index;
 	int ret;
 
-	dev_dbg(dev, "comedi_: usbdux_: "
-		"finding a free structure for the usb-device\n");
+	dev_dbg(dev, "comedi_: finding a free structure for the usb-device\n");
 
 	down(&start_stop_sem);
 	/* look for a free place in the usbdux array */
@@ -2368,8 +2362,8 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		up(&start_stop_sem);
 		return -EMFILE;
 	}
-	dev_dbg(dev, "comedi_: usbdux: "
-		"usbduxsub[%d] is ready to connect to comedi.\n", index);
+	dev_dbg(dev, "comedi_: usbduxsub[%d] is ready to connect to comedi.\n",
+		index);
 
 	sema_init(&(usbduxsub[index].sem), 1);
 	/* save a pointer to the usb device */
@@ -2392,8 +2386,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the commands of the DA converter */
 	usbduxsub[index].dac_commands = kzalloc(NUMOUTCHANNELS, GFP_KERNEL);
 	if (!usbduxsub[index].dac_commands) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"error alloc space for dac commands\n");
+		dev_err(dev, "comedi_: error alloc space for dac commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2401,8 +2394,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the commands going to the usb device */
 	usbduxsub[index].dux_commands = kzalloc(SIZEOFDUXBUFFER, GFP_KERNEL);
 	if (!usbduxsub[index].dux_commands) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"error alloc space for dux commands\n");
+		dev_err(dev, "comedi_: error alloc space for dux commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2410,8 +2402,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the in buffer and set it to zero */
 	usbduxsub[index].inBuffer = kzalloc(SIZEINBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].inBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"could not alloc space for inBuffer\n");
+		dev_err(dev, "comedi_: could not alloc space for inBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2419,8 +2410,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxsub[index].insnBuffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].insnBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"could not alloc space for insnBuffer\n");
+		dev_err(dev, "comedi_: could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2428,8 +2418,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the outbuffer */
 	usbduxsub[index].outBuffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].outBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"could not alloc space for outBuffer\n");
+		dev_err(dev, "comedi_: could not alloc space for outBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2438,8 +2427,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxsub[index].usbdev,
 			      usbduxsub[index].ifnum, 3);
 	if (i < 0) {
-		dev_err(dev, "comedi_: usbduxsigma%d: "
-			"could not set alternate setting 3 in high speed.\n",
+		dev_err(dev, "comedi_: usbduxsigma%d: could not set alternate setting 3 in high speed.\n",
 			index);
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2454,8 +2442,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfInBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbIn)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"Could not alloc. urbIn array\n");
+		dev_err(dev, "comedi_: Could not alloc. urbIn array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2464,8 +2451,8 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbIn[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbIn[i] == NULL) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"Could not alloc. urb(%d)\n", index, i);
+			dev_err(dev, "comedi_: usbduxsigma%d: Could not alloc. urb(%d)\n",
+				index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2480,8 +2467,8 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbIn[i]->transfer_buffer =
 		    kzalloc(SIZEINBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbIn[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"could not alloc. transb.\n", index);
+			dev_err(dev, "comedi_: usbduxsigma%d: could not alloc. transb.\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2504,8 +2491,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfOutBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbOut)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
-			"Could not alloc. urbOut array\n");
+		dev_err(dev, "comedi_: Could not alloc. urbOut array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2514,8 +2500,8 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbOut[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbOut[i] == NULL) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"Could not alloc. urb(%d)\n", index, i);
+			dev_err(dev, "comedi_: usbduxsigma%d: Could not alloc. urb(%d)\n",
+				index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2530,8 +2516,8 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbOut[i]->transfer_buffer =
 		    kzalloc(SIZEOUTBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbOut[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"could not alloc. transb.\n", index);
+			dev_err(dev, "comedi_: usbduxsigma%d: could not alloc. transb.\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2558,8 +2544,8 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].sizePwmBuf = 512;
 		usbduxsub[index].urbPwm = usb_alloc_urb(0, GFP_KERNEL);
 		if (usbduxsub[index].urbPwm == NULL) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"Could not alloc. pwm urb\n", index);
+			dev_err(dev, "comedi_: usbduxsigma%d: Could not alloc. pwm urb\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2567,8 +2553,8 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbPwm->transfer_buffer =
 		    kzalloc(usbduxsub[index].sizePwmBuf, GFP_KERNEL);
 		if (!(usbduxsub[index].urbPwm->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
-				"could not alloc. transb. for pwm\n", index);
+			dev_err(dev, "comedi_: usbduxsigma%d: could not alloc. transb. for pwm\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
-- 
1.7.0.4

