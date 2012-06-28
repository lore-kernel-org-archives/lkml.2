Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2F1FBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 01:01:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48907 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2F1FBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 01:01:05 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH 5/5] Staging: comedi: usbduxsigma: Syntax issue fixes
Date: Thu, 28 Jun 2012 02:01:00 -0300
Message-Id: <1340859660-28813-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed "many quoted string split across lines" issues,
replaced "printk(KERN_ERR" for "pr_err("
and replaced "printk(KERN_INFO" for "pr_info("

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxsigma.c | 68 ++++++++++++++--------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 465afbd..37541c1 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -1069,7 +1069,7 @@ static int send_dux_commands(struct usbduxsub *this_usbduxsub, int cmd_type)
 
 	this_usbduxsub->dux_commands[0] = cmd_type;
 #ifdef NOISY_DUX_DEBUGBUG
-	printk(KERN_DEBUG "comedi%d: usbdux: dux_commands: ",
+	pr_debug("comedi%d: usbdux: dux_commands: ",
 	       this_usbduxsub->comedidev->minor);
 	for (result = 0; result < SIZEOFDUXBUFFER; result++)
 		printk(" %02x", this_usbduxsub->dux_commands[result]);
@@ -1081,8 +1081,8 @@ static int send_dux_commands(struct usbduxsub *this_usbduxsub, int cmd_type)
 			      this_usbduxsub->dux_commands, SIZEOFDUXBUFFER,
 			      &nsent, BULK_TIMEOUT);
 	if (result < 0)
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
-			"could not transmit dux_command to the usb-device, "
+		dev_err(&this_usbduxsub->interface->dev, "comedi%d: " \
+			"could not transmit dux_command to the usb-device, " \
 			"err=%d\n", this_usbduxsub->comedidev->minor, result);
 
 	return result;
@@ -1101,9 +1101,9 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 				      this_usbduxsub->insnBuffer, SIZEINSNBUF,
 				      &nrec, BULK_TIMEOUT);
 		if (result < 0) {
-			dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
-				"insn: USB error %d "
-				"while receiving DUX command"
+			dev_err(&this_usbduxsub->interface->dev, "comedi%d: " \
+				"insn: USB error %d " \
+				"while receiving DUX command" \
 				"\n", this_usbduxsub->comedidev->minor,
 				result);
 			return result;
@@ -1113,7 +1113,7 @@ static int receive_dux_commands(struct usbduxsub *this_usbduxsub, int command)
 	}
 	/* this is only reached if the data has been requested a couple of
 	 * times */
-	dev_err(&this_usbduxsub->interface->dev, "comedi%d: insn: "
+	dev_err(&this_usbduxsub->interface->dev, "comedi%d: insn: " \
 		"wrong data returned from firmware: want %d, got %d.\n",
 		this_usbduxsub->comedidev->minor, command,
 		this_usbduxsub->insnBuffer[0]);
@@ -1189,7 +1189,7 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return -ENODEV;
 	}
 	if (this_usbduxsub->ai_cmd_running) {
-		dev_err(&this_usbduxsub->interface->dev, "comedi%d: "
+		dev_err(&this_usbduxsub->interface->dev, "comedi%d: " \
 			"ai_cmd not possible. Another ai_cmd is running.\n",
 			dev->minor);
 		up(&this_usbduxsub->sem);
@@ -1251,8 +1251,8 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
@@ -1319,7 +1319,7 @@ static int usbdux_ai_insn_read(struct comedi_device *dev,
 	}
 	if (this_usbduxsub->ai_cmd_running) {
 		dev_err(&this_usbduxsub->interface->dev,
-			"comedi%d: ai_insn_read not possible. "
+			"comedi%d: ai_insn_read not possible. " \
 			"Async Command is running.\n", dev->minor);
 		up(&this_usbduxsub->sem);
 		return 0;
@@ -1383,7 +1383,7 @@ static int usbdux_getstatusinfo(struct comedi_device *dev, int chan)
 
 	if (this_usbduxsub->ai_cmd_running) {
 		dev_err(&this_usbduxsub->interface->dev,
-			"comedi%d: status read not possible. "
+			"comedi%d: status read not possible. " \
 			"Async Command is running.\n", dev->minor);
 		return 0;
 	}
@@ -1488,7 +1488,7 @@ static int usbdux_ao_insn_write(struct comedi_device *dev,
 	}
 	if (this_usbduxsub->ao_cmd_running) {
 		dev_err(&this_usbduxsub->interface->dev,
-			"comedi%d: ao_insn_write: "
+			"comedi%d: ao_insn_write: " \
 			"ERROR: asynchronous ao_cmd is running\n", dev->minor);
 		up(&this_usbduxsub->sem);
 		return 0;
@@ -1543,7 +1543,7 @@ static int usbdux_ao_inttrig(struct comedi_device *dev,
 		ret = usbduxsub_submit_OutURBs(this_usbduxsub);
 		if (ret < 0) {
 			dev_err(&this_usbduxsub->interface->dev,
-				"comedi%d: usbdux_ao_inttrig: submitURB: "
+				"comedi%d: usbdux_ao_inttrig: submitURB: " \
 				"err=%d\n", dev->minor, ret);
 			this_usbduxsub->ao_cmd_running = 0;
 			goto out;
@@ -1683,7 +1683,7 @@ static int usbdux_ao_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	dev_dbg(&this_usbduxsub->interface->dev, "comedi%d: err=%d, "
+	dev_dbg(&this_usbduxsub->interface->dev, "comedi%d: err=%d, " \
 		"scan_begin_src=%d, scan_begin_arg=%d, convert_src=%d, "
 		"convert_arg=%d\n", dev->minor, err, cmd->scan_begin_src,
 		cmd->scan_begin_arg, cmd->convert_src, cmd->convert_arg);
@@ -2349,7 +2349,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	int index;
 	int ret;
 
-	dev_dbg(dev, "comedi_: usbdux_: "
+	dev_dbg(dev, "comedi_: usbdux_: " \
 		"finding a free structure for the usb-device\n");
 
 	down(&start_stop_sem);
@@ -2368,7 +2368,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		up(&start_stop_sem);
 		return -EMFILE;
 	}
-	dev_dbg(dev, "comedi_: usbdux: "
+	dev_dbg(dev, "comedi_: usbdux: " \
 		"usbduxsub[%d] is ready to connect to comedi.\n", index);
 
 	sema_init(&(usbduxsub[index].sem), 1);
@@ -2392,7 +2392,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the commands of the DA converter */
 	usbduxsub[index].dac_commands = kzalloc(NUMOUTCHANNELS, GFP_KERNEL);
 	if (!usbduxsub[index].dac_commands) {
-		dev_err(dev, "comedi_: usbduxsigma: "
+		dev_err(dev, "comedi_: usbduxsigma: " \
 			"error alloc space for dac commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2401,7 +2401,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the commands going to the usb device */
 	usbduxsub[index].dux_commands = kzalloc(SIZEOFDUXBUFFER, GFP_KERNEL);
 	if (!usbduxsub[index].dux_commands) {
-		dev_err(dev, "comedi_: usbduxsigma: "
+		dev_err(dev, "comedi_: usbduxsigma: " \
 			"error alloc space for dux commands\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2410,7 +2410,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the in buffer and set it to zero */
 	usbduxsub[index].inBuffer = kzalloc(SIZEINBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].inBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
+		dev_err(dev, "comedi_: usbduxsigma: " \
 			"could not alloc space for inBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2419,7 +2419,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxsub[index].insnBuffer = kzalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].insnBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
+		dev_err(dev, "comedi_: usbduxsigma: " \
 			"could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2428,7 +2428,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	/* create space for the outbuffer */
 	usbduxsub[index].outBuffer = kzalloc(SIZEOUTBUF, GFP_KERNEL);
 	if (!(usbduxsub[index].outBuffer)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
+		dev_err(dev, "comedi_: usbduxsigma: " \
 			"could not alloc space for outBuffer\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2438,7 +2438,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxsub[index].usbdev,
 			      usbduxsub[index].ifnum, 3);
 	if (i < 0) {
-		dev_err(dev, "comedi_: usbduxsigma%d: "
+		dev_err(dev, "comedi_: usbduxsigma%d: " \
 			"could not set alternate setting 3 in high speed.\n",
 			index);
 		tidy_up(&(usbduxsub[index]));
@@ -2454,7 +2454,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfInBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbIn)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
+		dev_err(dev, "comedi_: usbduxsigma: " \
 			"Could not alloc. urbIn array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2464,7 +2464,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbIn[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbIn[i] == NULL) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
+			dev_err(dev, "comedi_: usbduxsigma%d: " \
 				"Could not alloc. urb(%d)\n", index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2480,7 +2480,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbIn[i]->transfer_buffer =
 		    kzalloc(SIZEINBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbIn[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
+			dev_err(dev, "comedi_: usbduxsigma%d: " \
 				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2504,7 +2504,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfOutBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbOut)) {
-		dev_err(dev, "comedi_: usbduxsigma: "
+		dev_err(dev, "comedi_: usbduxsigma: " \
 			"Could not alloc. urbOut array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2514,7 +2514,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbOut[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbOut[i] == NULL) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
+			dev_err(dev, "comedi_: usbduxsigma%d: " \
 				"Could not alloc. urb(%d)\n", index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2530,7 +2530,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbOut[i]->transfer_buffer =
 		    kzalloc(SIZEOUTBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbOut[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
+			dev_err(dev, "comedi_: usbduxsigma%d: " \
 				"could not alloc. transb.\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2558,7 +2558,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].sizePwmBuf = 512;
 		usbduxsub[index].urbPwm = usb_alloc_urb(0, GFP_KERNEL);
 		if (usbduxsub[index].urbPwm == NULL) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
+			dev_err(dev, "comedi_: usbduxsigma%d: " \
 				"Could not alloc. pwm urb\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2567,7 +2567,7 @@ static int usbduxsigma_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbPwm->transfer_buffer =
 		    kzalloc(usbduxsub[index].sizePwmBuf, GFP_KERNEL);
 		if (!(usbduxsub[index].urbPwm->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbduxsigma%d: "
+			dev_err(dev, "comedi_: usbduxsigma%d: " \
 				"could not alloc. transb. for pwm\n", index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
@@ -2660,7 +2660,7 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	}
 
 	if (index < 0) {
-		printk(KERN_ERR "comedi%d: usbduxsigma: error: attach failed,"
+		pr_err("comedi%d: usbduxsigma: error: attach failed," \
 		       "dev not connected to the usb bus.\n", dev->minor);
 		up(&start_stop_sem);
 		return -ENODEV;
@@ -2792,7 +2792,7 @@ static int usbduxsigma_attach(struct comedi_device *dev,
 	offset = usbdux_getstatusinfo(dev, 0);
 	if (offset < 0)
 		dev_err(&udev->interface->dev,
-			"Communication to USBDUXSIGMA failed!"
+			"Communication to USBDUXSIGMA failed!" \
 			"Check firmware and cabling.");
 
 	dev_info(&udev->interface->dev,
@@ -2845,7 +2845,7 @@ static struct usb_driver usbduxsigma_driver = {
 /* registering the usb-system _and_ the comedi-driver */
 static int __init init_usbduxsigma(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME ": "
+	pr_info(KBUILD_MODNAME ": "
 	       DRIVER_VERSION ":" DRIVER_DESC "\n");
 	usb_register(&usbduxsigma_driver);
 	comedi_driver_register(&driver_usbduxsigma);
-- 
1.7.11.1

