Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab2F1EXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:23:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45749 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2F1EXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:23:52 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: drivers: usbduxfast: changed "printk(KERN_ERR ..." for "pr_err(..."
Date: Thu, 28 Jun 2012 01:23:47 -0300
Message-Id: <1340857427-21915-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed 3 instances of printk(KERN_ERR for the prefered pr_err(

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 82 ++++++++++++++---------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index c37371c..9bcdcd1 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -227,7 +227,7 @@ static int send_dux_commands(struct usbduxfastsub_s *udfs, int cmd_type)
 			   usb_sndbulkpipe(udfs->usbdev, CHANNELLISTEP),
 			   udfs->dux_commands, SIZEOFDUXBUFFER, &nsent, 10000);
 	if (tmp < 0)
-		printk(KERN_ERR "comedi%d: could not transmit dux_commands to"
+		pr_err("comedi%d: could not transmit dux_commands to"
 		       "the usb-device, err=%d\n", udfs->comedidev->minor, tmp);
 	return tmp;
 }
@@ -263,7 +263,7 @@ static int usbduxfast_ai_stop(struct usbduxfastsub_s *udfs, int do_unlink)
 	int ret = 0;
 
 	if (!udfs) {
-		printk(KERN_ERR "comedi?: usbduxfast_ai_stop: udfs=NULL!\n");
+		pr_err("comedi?: usbduxfast_ai_stop: udfs=NULL!\n");
 		return -EFAULT;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
@@ -295,7 +295,7 @@ static int usbduxfast_ai_cancel(struct comedi_device *dev,
 #endif
 	udfs = dev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi: usbduxfast_ai_cancel: udfs=NULL\n");
+		pr_err("comedi: usbduxfast_ai_cancel: udfs=NULL\n");
 		return -EFAULT;
 	}
 	down(&udfs->sem);
@@ -324,21 +324,21 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 
 	/* sanity checks - is the urb there? */
 	if (!urb) {
-		printk(KERN_ERR "comedi_: usbduxfast_: ao int-handler called "
+		pr_err("comedi_: usbduxfast_: ao int-handler called "
 		       "with urb=NULL!\n");
 		return;
 	}
 	/* the context variable points to the subdevice */
 	this_comedidev = urb->context;
 	if (!this_comedidev) {
-		printk(KERN_ERR "comedi_: usbduxfast_: urb context is a NULL "
+		pr_err("comedi_: usbduxfast_: urb context is a NULL "
 		       "pointer!\n");
 		return;
 	}
 	/* the private structure of the subdevice is usbduxfastsub_s */
 	udfs = this_comedidev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi_: usbduxfast_: private of comedi "
+		pr_err("comedi_: usbduxfast_: private of comedi "
 		       "subdev is a NULL pointer!\n");
 		return;
 	}
@@ -438,7 +438,7 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 	urb->status = 0;
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: urb resubm failed: %d",
+		pr_err("comedi%d: usbduxfast: urb resubm failed: %d",
 		       udfs->comedidev->minor, err);
 		s->async->events |= COMEDI_CB_EOA;
 		s->async->events |= COMEDI_CB_ERROR;
@@ -488,7 +488,7 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 			      local_transfer_buffer, 1,	/* Length */
 			      EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast: control msg failed "
+		pr_err("comedi_: usbduxfast: control msg failed "
 		       "(stop)\n");
 		return ret;
 	}
@@ -523,7 +523,7 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 #endif
 
 	if (ret < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast: uppload failed\n");
+		pr_err("comedi_: usbduxfast: uppload failed\n");
 		return ret;
 	}
 
@@ -549,7 +549,7 @@ static int usbduxfastsub_submit_InURBs(struct usbduxfastsub_s *udfs)
 #endif
 	ret = usb_submit_urb(udfs->urbIn, GFP_ATOMIC);
 	if (ret) {
-		printk(KERN_ERR "comedi_: usbduxfast: ai: usb_submit_urb error"
+		pr_err("comedi_: usbduxfast: ai: usb_submit_urb error"
 		       " %d\n", ret);
 		return ret;
 	}
@@ -719,7 +719,7 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 #endif
 
 	if (trignum != 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast_ai_inttrig: invalid"
+		pr_err("comedi%d: usbduxfast_ai_inttrig: invalid"
 		       " trignum\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
@@ -728,7 +728,7 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		udfs->ai_cmd_running = 1;
 		ret = usbduxfastsub_submit_InURBs(udfs);
 		if (ret < 0) {
-			printk(KERN_ERR "comedi%d: usbduxfast_ai_inttrig: "
+			pr_err("comedi%d: usbduxfast_ai_inttrig: "
 			       "urbSubmit: err=%d\n", dev->minor, ret);
 			udfs->ai_cmd_running = 0;
 			up(&udfs->sem);
@@ -736,7 +736,7 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		}
 		s->async->inttrig = NULL;
 	} else {
-		printk(KERN_ERR "comedi%d: ai_inttrig but acqu is already"
+		pr_err("comedi%d: ai_inttrig but acqu is already"
 		       " running\n", dev->minor);
 	}
 	up(&udfs->sem);
@@ -775,7 +775,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		printk(KERN_ERR "comedi%d: ai_cmd not possible. Another ai_cmd"
+		pr_err("comedi%d: ai_cmd not possible. Another ai_cmd"
 		       " is running.\n", dev->minor);
 		up(&udfs->sem);
 		return -EBUSY;
@@ -794,7 +794,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		for (i = 0; i < cmd->chanlist_len; ++i) {
 			chan = CR_CHAN(cmd->chanlist[i]);
 			if (chan != i) {
-				printk(KERN_ERR "comedi%d: cmd is accepting "
+				pr_err("comedi%d: cmd is accepting "
 				       "only consecutive channels.\n",
 				       dev->minor);
 				up(&udfs->sem);
@@ -802,14 +802,14 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 			}
 			if ((gain != CR_RANGE(cmd->chanlist[i]))
 			    && (cmd->chanlist_len > 3)) {
-				printk(KERN_ERR "comedi%d: the gain must be"
+				pr_err("comedi%d: the gain must be"
 				       " the same for all channels.\n",
 				       dev->minor);
 				up(&udfs->sem);
 				return -EINVAL;
 			}
 			if (i >= NUMCHANNELS) {
-				printk(KERN_ERR "comedi%d: channel list too"
+				pr_err("comedi%d: channel list too"
 				       " long\n", dev->minor);
 				break;
 			}
@@ -817,7 +817,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	}
 	steps = 0;
 	if (cmd->scan_begin_src == TRIG_TIMER) {
-		printk(KERN_ERR "comedi%d: usbduxfast: "
+		pr_err("comedi%d: usbduxfast: "
 		       "scan_begin_src==TRIG_TIMER not valid.\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
@@ -826,21 +826,21 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		steps = (cmd->convert_arg * 30) / 1000;
 
 	if ((steps < MIN_SAMPLING_PERIOD) && (cmd->chanlist_len != 1)) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: steps=%ld, "
+		pr_err("comedi%d: usbduxfast: ai_cmd: steps=%ld, "
 		       "scan_begin_arg=%d. Not properly tested by cmdtest?\n",
 		       dev->minor, steps, cmd->scan_begin_arg);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if (steps > MAX_SAMPLING_PERIOD) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: sampling rate "
+		pr_err("comedi%d: usbduxfast: ai_cmd: sampling rate "
 		       "too low.\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if ((cmd->start_src == TRIG_EXT) && (cmd->chanlist_len != 1)
 	    && (cmd->chanlist_len != 16)) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: TRIG_EXT only"
+		pr_err("comedi%d: usbduxfast: ai_cmd: TRIG_EXT only"
 		       " with 1 or 16 channels possible.\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
@@ -1158,7 +1158,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		break;
 
 	default:
-		printk(KERN_ERR "comedi %d: unsupported combination of "
+		pr_err("comedi %d: unsupported combination of "
 		       "channels\n", dev->minor);
 		up(&udfs->sem);
 		return -EFAULT;
@@ -1171,7 +1171,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	/* 0 means that the AD commands are sent */
 	result = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (result < 0) {
-		printk(KERN_ERR "comedi%d: adc command could not be submitted."
+		pr_err("comedi%d: adc command could not be submitted."
 		       "Aborting...\n", dev->minor);
 		up(&udfs->sem);
 		return result;
@@ -1179,7 +1179,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	if (cmd->stop_src == TRIG_COUNT) {
 		udfs->ai_sample_count = cmd->stop_arg * cmd->scan_end_arg;
 		if (udfs->ai_sample_count < 1) {
-			printk(KERN_ERR "comedi%d: "
+			pr_err("comedi%d: "
 			       "(cmd->stop_arg)*(cmd->scan_end_arg)<1, "
 			       "aborting.\n", dev->minor);
 			up(&udfs->sem);
@@ -1230,7 +1230,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 
 	udfs = dev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi%d: ai_insn_read: no usb dev.\n",
+		pr_err("comedi%d: ai_insn_read: no usb dev.\n",
 		       dev->minor);
 		return -ENODEV;
 	}
@@ -1244,7 +1244,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		printk(KERN_ERR "comedi%d: ai_insn_read not possible. Async "
+		pr_err("comedi%d: ai_insn_read not possible. Async "
 		       "Command is running.\n", dev->minor);
 		up(&udfs->sem);
 		return -EBUSY;
@@ -1305,7 +1305,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 	/* 0 means that the AD commands are sent */
 	err = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (err < 0) {
-		printk(KERN_ERR "comedi%d: adc command could not be submitted."
+		pr_err("comedi%d: adc command could not be submitted."
 		       "Aborting...\n", dev->minor);
 		up(&udfs->sem);
 		return err;
@@ -1321,7 +1321,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 				   udfs->transfer_buffer, SIZEINBUF,
 				   &actual_length, 10000);
 		if (err < 0) {
-			printk(KERN_ERR "comedi%d: insn timeout. No data.\n",
+			pr_err("comedi%d: insn timeout. No data.\n",
 			       dev->minor);
 			up(&udfs->sem);
 			return err;
@@ -1334,14 +1334,14 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 				   udfs->transfer_buffer, SIZEINBUF,
 				   &actual_length, 10000);
 		if (err < 0) {
-			printk(KERN_ERR "comedi%d: insn data error: %d\n",
+			pr_err("comedi%d: insn data error: %d\n",
 			       dev->minor, err);
 			up(&udfs->sem);
 			return err;
 		}
 		n = actual_length / sizeof(uint16_t);
 		if ((n % 16) != 0) {
-			printk(KERN_ERR "comedi%d: insn data packet "
+			pr_err("comedi%d: insn data packet "
 			       "corrupted.\n", dev->minor);
 			up(&udfs->sem);
 			return -EINVAL;
@@ -1480,7 +1480,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	int ret;
 
 	if (udev->speed != USB_SPEED_HIGH) {
-		printk(KERN_ERR "comedi_: usbduxfast_: This driver needs"
+		pr_err("comedi_: usbduxfast_: This driver needs"
 		       "USB 2.0 to operate. Aborting...\n");
 		return -ENODEV;
 	}
@@ -1500,7 +1500,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 
 	/* no more space */
 	if (index == -1) {
-		printk(KERN_ERR "Too many usbduxfast-devices connected.\n");
+		pr_err("Too many usbduxfast-devices connected.\n");
 		up(&start_stop_sem);
 		return -EMFILE;
 	}
@@ -1531,7 +1531,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	usbduxfastsub[index].dux_commands = kmalloc(SIZEOFDUXBUFFER,
 						    GFP_KERNEL);
 	if (!usbduxfastsub[index].dux_commands) {
-		printk(KERN_ERR "comedi_: usbduxfast: error alloc space for "
+		pr_err("comedi_: usbduxfast: error alloc space for "
 		       "dac commands\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1540,7 +1540,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxfastsub[index].insnBuffer = kmalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].insnBuffer) {
-		printk(KERN_ERR "comedi_: usbduxfast: could not alloc space "
+		pr_err("comedi_: usbduxfast: could not alloc space "
 		       "for insnBuffer\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1550,7 +1550,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxfastsub[index].usbdev,
 			      usbduxfastsub[index].ifnum, 1);
 	if (i < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: could not switch to "
+		pr_err("comedi_: usbduxfast%d: could not switch to "
 		       "alternate setting 1.\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1558,7 +1558,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	}
 	usbduxfastsub[index].urbIn = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbduxfastsub[index].urbIn) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: Could not alloc."
+		pr_err("comedi_: usbduxfast%d: Could not alloc."
 		       "urb\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1566,7 +1566,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	}
 	usbduxfastsub[index].transfer_buffer = kmalloc(SIZEINBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].transfer_buffer) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: could not alloc. "
+		pr_err("comedi_: usbduxfast%d: could not alloc. "
 		       "transb.\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1601,12 +1601,12 @@ static void usbduxfastsub_disconnect(struct usb_interface *intf)
 	struct usb_device *udev = interface_to_usbdev(intf);
 
 	if (!udfs) {
-		printk(KERN_ERR "comedi_: usbduxfast: disconnect called with "
+		pr_err("comedi_: usbduxfast: disconnect called with "
 		       "null pointer.\n");
 		return;
 	}
 	if (udfs->usbdev != udev) {
-		printk(KERN_ERR "comedi_: usbduxfast: BUG! called with wrong "
+		pr_err("comedi_: usbduxfast: BUG! called with wrong "
 		       "ptr!!!\n");
 		return;
 	}
@@ -1650,7 +1650,7 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	}
 
 	if (index < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: error: attach failed, "
+		pr_err("comedi%d: usbduxfast: error: attach failed, "
 		       "no usbduxfast devs connected to the usb bus.\n",
 		       dev->minor);
 		up(&start_stop_sem);
@@ -1677,7 +1677,7 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	/* allocate space for the subdevices */
 	ret = alloc_subdevices(dev, N_SUBDEVICES);
 	if (ret < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: error alloc space for "
+		pr_err("comedi%d: usbduxfast: error alloc space for "
 		       "subdev\n", dev->minor);
 		up(&(usbduxfastsub[index].sem));
 		up(&start_stop_sem);
-- 
1.7.11.1

