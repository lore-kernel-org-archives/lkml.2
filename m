Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898Ab2F1FQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 01:16:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54132 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2F1FQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 01:16:52 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH 6/6] Staging: comedi: usbdux: several syntax issues fixed
Date: Thu, 28 Jun 2012 02:16:48 -0300
Message-Id: <1340860608-31767-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several "quoted string split across lines" issues fixed
changed some "printk(KERN_X" functions tp "pr_x("
fixed some +80 chars lines

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/usbdux.c | 84 ++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 13d9fd3..805fa4a 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -1103,7 +1103,7 @@ static int send_dux_commands(struct usbduxsub *this_usbduxsub, int cmd_type)
 
 	this_usbduxsub->dux_commands[0] = cmd_type;
 #ifdef NOISY_DUX_DEBUGBUG
-	printk(KERN_DEBUG "comedi%d: usbdux: dux_commands: ",
+	pr_debug("comedi%d: usbdux: dux_commands: ",
 	       this_usbduxsub->comedidev->minor);
 	for (result = 0; result < SIZEOFDUXBUFFER; result++)
 		printk(" %02x", this_usbduxsub->dux_commands[result]);
@@ -1115,7 +1115,7 @@ static int send_dux_commands(struct usbduxsub *this_usbduxsub, int cmd_type)
 			      this_usbduxsub->dux_commands, SIZEOFDUXBUFFER,
 			      &nsent, BULK_TIMEOUT);
 	if (result < 0)
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
+		dev_err(&this_usbduxsub->interface->dev, "comedi%d: " \
 			"could not transmit dux_command to the usb-device, "
 			"err=%d\n", this_usbduxsub->comedidev->minor, result);
 
@@ -1135,7 +1135,7 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 				      this_usbduxsub->insnBuffer, SIZEINSNBUF,
 				      &nrec, BULK_TIMEOUT);
 		if (result < 0) {
-			dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
+			dev_err(&this_usbduxsub->interface->dev, "comedi%d: " \
 				"insn: USB error %d while receiving DUX command"
 				"\n", this_usbduxsub->comedidev->minor, result);
 			return result;
@@ -1145,7 +1145,7 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 	}
 	/* this is only reached if the data has been requested a couple of
 	 * times */
-	dev_err(&this_usbduxsub->interface->dev, "comedi%d: insn: "
+	dev_err(&this_usbduxsub->interface->dev, "comedi%d: insn: " \
 		"wrong data returned from firmware: want cmd %d, got cmd %d.\n",
 		this_usbduxsub->comedidev->minor, command,
 		le16_to_cpu(this_usbduxsub->insnBuffer[0]));
@@ -1180,7 +1180,7 @@ static int usbdux_ai_inttrig(struct comedi_device *dev,
 		ret = usbduxsub_submit_InURBs(this_usbduxsub);
 		if (ret < 0) {
 			dev_err(&this_usbduxsub->interface->dev,
-				"comedi%d: usbdux_ai_inttrig: "
+				"comedi%d: usbdux_ai_inttrig: " \
 				"urbSubmit: err=%d\n", dev->minor, ret);
 			this_usbduxsub->ai_cmd_running = 0;
 			up(&this_usbduxsub->sem);
@@ -1218,7 +1218,7 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return -ENODEV;
 	}
 	if (this_usbduxsub->ai_cmd_running) {
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
+		dev_err(&this_usbduxsub->interface->dev, "comedi%d: " \
 			"ai_cmd not possible. Another ai_cmd is running.\n",
 			dev->minor);
 		up(&this_usbduxsub->sem);
@@ -1272,8 +1272,8 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		this_usbduxsub->ai_timer = cmd->scan_begin_arg / 1000000;
 	}
 	if (this_usbduxsub->ai_timer < 1) {
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: ai_cmd: "
-			"timer=%d, scan_begin_arg=%d. "
+		dev_err(&this_usbduxsub->interface->dev, "comedi%d: ai_cmd: " \
+			"timer=%d, scan_begin_arg=%d. " \
 			"Not properly tested by cmdtest?\n", dev->minor,
 			this_usbduxsub->ai_timer, cmd->scan_begin_arg);
 		up(&this_usbduxsub->sem);
@@ -1337,7 +1337,7 @@ static int usbdux_ai_insn_read(struct comedi_device *dev,
 	}
 	if (this_usbduxsub->ai_cmd_running) {
 		dev_err(&this_usbduxsub->interface->dev,
-			"comedi%d: ai_insn_read not possible. "
+			"comedi%d: ai_insn_read not possible. " \
 			"Async Command is running.\n", dev->minor);
 		up(&this_usbduxsub->sem);
 		return 0;
@@ -1419,7 +1419,7 @@ static int usbdux_ao_insn_write(struct comedi_device *dev,
 	}
 	if (this_usbduxsub->ao_cmd_running) {
 		dev_err(&this_usbduxsub->interface->dev,
-			"comedi%d: ao_insn_write: "
+			"comedi%d: ao_insn_write: " \
 			"ERROR: asynchronous ao_cmd is running\n", dev->minor);
 		up(&this_usbduxsub->sem);
 		return 0;
@@ -1619,7 +1619,7 @@ static int usbdux_ao_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	dev_dbg(&this_usbduxsub->interface->dev, "comedi%d: err=%d, "
+	dev_dbg(&this_usbduxsub->interface->dev, "comedi%d: err=%d, " \
 		"scan_begin_src=%d, scan_begin_arg=%d, convert_src=%d, "
 		"convert_arg=%d\n", dev->minor, err, cmd->scan_begin_src,
 		cmd->scan_begin_arg, cmd->convert_src, cmd->convert_arg);
@@ -1676,7 +1676,7 @@ static int usbdux_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		/* timing of the scan: we get all channels at once */
 		this_usbduxsub->ao_timer = cmd->scan_begin_arg / 1000000;
 		dev_dbg(&this_usbduxsub->interface->dev,
-			"comedi%d: scan_begin_src=%d, scan_begin_arg=%d, "
+			"comedi%d: scan_begin_src=%d, scan_begin_arg=%d, " \
 			"convert_src=%d, convert_arg=%d\n", dev->minor,
 			cmd->scan_begin_src, cmd->scan_begin_arg,
 			cmd->convert_src, cmd->convert_arg);
@@ -1685,8 +1685,8 @@ static int usbdux_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			dev->minor, this_usbduxsub->ao_timer);
 		if (this_usbduxsub->ao_timer < 1) {
 			dev_err(&this_usbduxsub->interface->dev,
-				"comedi%d: usbdux: ao_timer=%d, "
-				"scan_begin_arg=%d. "
+				"comedi%d: usbdux: ao_timer=%d, " \
+				"scan_begin_arg=%d. " \
 				"Not properly tested by cmdtest?\n",
 				dev->minor, this_usbduxsub->ao_timer,
 				cmd->scan_begin_arg);
@@ -1980,7 +1980,7 @@ static void usbduxsub_pwm_irq(struct urb *urb)
 		/* a real error */
 		if (this_usbduxsub->pwm_cmd_running) {
 			dev_err(&this_usbduxsub->interface->dev,
-				"comedi_: Non-zero urb status received in "
+				"comedi_: Non-zero urb status received in " \
 				"pwm intr context: %d\n", urb->status);
 			usbdux_pwm_stop(this_usbduxsub, 0);
 		}
@@ -1998,11 +1998,11 @@ static void usbduxsub_pwm_irq(struct urb *urb)
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
 		if (ret < 0) {
 			dev_err(&this_usbduxsub->interface->dev,
-				"comedi_: pwm urb resubm failed in int-cont. "
+				"comedi_: pwm urb resubm failed in int-cont. " \
 				"ret=%d", ret);
 			if (ret == EL2NSYNC)
 				dev_err(&this_usbduxsub->interface->dev,
-					"buggy USB host controller or bug in "
+					"buggy USB host controller or bug in " \
 					"IRQ handling!\n");
 
 			/* don't do an unlink here */
@@ -2341,7 +2341,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	int index;
 	int ret;
 
-	dev_dbg(dev, "comedi_: usbdux_: "
+	dev_dbg(dev, "comedi_: usbdux_: " \
 		"finding a free structure for the usb-device\n");
 
 	down(&start_stop_sem);
@@ -2360,7 +2360,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		up(&start_stop_sem);
 		return -EMFILE;
 	}
-	dev_dbg(dev, "comedi_: usbdux: "
+	dev_dbg(dev, "comedi_: usbdux: " \
 		"usbduxsub[%d] is ready to connect to comedi.\n", index);
 
 	sema_init(&(usbduxsub[index].sem), 1);
@@ -2384,7 +2384,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the commands of the DA converter */
 	usbduxsub[index].dac_commands = kzalloc(NUMOUTCHANNELS, GFP_KERNEL);
 	if (!usbduxsub[index].dac_commands) {
-		dev_err(dev, "comedi_: usbdux: "
+		dev_err(dev, "comedi_: usbdux: " \
 			"error alloc space for dac commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2393,7 +2393,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the commands going to the usb device */
 	usbduxsub[index].dux_commands = kzalloc(SIZEOFDUXBUFFER, GFP_KERNEL);
 	if (!usbduxsub[index].dux_commands) {
-		dev_err(dev, "comedi_: usbdux: "
+		dev_err(dev, "comedi_: usbdux: " \
 			"error alloc space for dux commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2402,7 +2402,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the in buffer and set it to zero */
 	usbduxsub[index].inBuffer = kzalloc(SIZEINBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].inBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
+		dev_err(dev, "comedi_: usbdux: " \
 			"could not alloc space for inBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2411,7 +2411,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxsub[index].insnBuffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].insnBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
+		dev_err(dev, "comedi_: usbdux: " \
 			"could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2420,7 +2420,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	/* create space for the outbuffer */
 	usbduxsub[index].outBuffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].outBuffer)) {
-		dev_err(dev, "comedi_: usbdux: "
+		dev_err(dev, "comedi_: usbdux: " \
 			"could not alloc space for outBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2430,7 +2430,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxsub[index].usbdev,
 			      usbduxsub[index].ifnum, 3);
 	if (i < 0) {
-		dev_err(dev, "comedi_: usbdux%d: "
+		dev_err(dev, "comedi_: usbdux%d: " \
 			"could not set alternate setting 3 in high speed.\n",
 			index);
 		tidy_up(&(usbduxsub[index]));
@@ -2455,7 +2455,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbIn[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbIn[i] == NULL) {
-			dev_err(dev, "comedi_: usbdux%d: "
+			dev_err(dev, "comedi_: usbdux%d: " \
 				"Could not alloc. urb(%d)\n", index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2471,7 +2471,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbIn[i]->transfer_buffer =
 		    kzalloc(SIZEINBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbIn[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
+			dev_err(dev, "comedi_: usbdux%d: " \
 				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2494,7 +2494,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfOutBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbOut)) {
-		dev_err(dev, "comedi_: usbdux: "
+		dev_err(dev, "comedi_: usbdux: " \
 			"Could not alloc. urbOut array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2504,7 +2504,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbOut[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbOut[i] == NULL) {
-			dev_err(dev, "comedi_: usbdux%d: "
+			dev_err(dev, "comedi_: usbdux%d: " \
 				"Could not alloc. urb(%d)\n", index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2520,7 +2520,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbOut[i]->transfer_buffer =
 		    kzalloc(SIZEOUTBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbOut[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
+			dev_err(dev, "comedi_: usbdux%d: " \
 				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2547,7 +2547,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].sizePwmBuf = 512;
 		usbduxsub[index].urbPwm = usb_alloc_urb(0, GFP_KERNEL);
 		if (usbduxsub[index].urbPwm == NULL) {
-			dev_err(dev, "comedi_: usbdux%d: "
+			dev_err(dev, "comedi_: usbdux%d: " \
 				"Could not alloc. pwm urb\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2556,7 +2556,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbPwm->transfer_buffer =
 		    kzalloc(usbduxsub[index].sizePwmBuf, GFP_KERNEL);
 		if (!(usbduxsub[index].urbPwm->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
+			dev_err(dev, "comedi_: usbdux%d: " \
 				"could not alloc. transb. for pwm\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2588,7 +2588,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		return ret;
 	}
 
-	dev_info(dev, "comedi_: usbdux%d "
+	dev_info(dev, "comedi_: usbdux%d " \
 		 "has been successfully initialised.\n", index);
 	/* success */
 	return 0;
@@ -2785,9 +2785,9 @@ static int usbdux_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	if (index < 0) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach failed, no usbdux devs connected to the usb bus.\n",
-		       dev->minor);
+		pr_err("comedi%d: usbdux: error: attach failed," \
+			"no usbdux devs connected to the usb bus.\n",
+			dev->minor);
 		ret = -ENODEV;
 	} else
 		ret = usbdux_attach_common(dev, &usbduxsub[index],
@@ -2808,13 +2808,13 @@ static int usbdux_attach_usb(struct comedi_device *dev,
 	down(&start_stop_sem);
 	this_usbduxsub = usb_get_intfdata(uinterf);
 	if (!this_usbduxsub || !this_usbduxsub->probed) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach_usb failed, not connected\n",
-		       dev->minor);
+		pr_err("comedi%d: usbdux: error: attach_usb failed," \
+			"not connected\n",
+			dev->minor);
 		ret = -ENODEV;
 	} else if (this_usbduxsub->attached) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach_usb failed, already attached\n",
+		pr_err("comedi%d: usbdux: error: attach_usb failed," \
+		       "already attached\n",
 		       dev->minor);
 		ret = -ENODEV;
 	} else
@@ -2867,7 +2867,7 @@ static struct usb_driver usbduxsub_driver = {
 /* registering the usb-system _and_ the comedi-driver */
 static int __init init_usbdux(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME ": "
+	pr_info(KBUILD_MODNAME ": "
 	       DRIVER_VERSION ":" DRIVER_DESC "\n");
 	usb_register(&usbduxsub_driver);
 	comedi_driver_register(&driver_usbdux);
-- 
1.7.11.1

