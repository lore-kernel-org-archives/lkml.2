Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2F1Erc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:47:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49582 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2F1ErX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:47:23 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH 4/4] Staging: comedi: drivers: usbduxfast: fixed several syntax issues
Date: Thu, 28 Jun 2012 01:47:09 -0300
Message-Id: <1340858829-26296-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed +40 "quoted string split across lines" issues
plus some lines that were over 80 chars
and a "pr_info(" function replaced "printk(KERN_INFO"

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 124 ++++++++++++++--------------
 1 file changed, 61 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index a8d8d06..59140ff 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -227,7 +227,7 @@ static int send_dux_commands(struct usbduxfastsub_s *udfs, int cmd_type)
 			   usb_sndbulkpipe(udfs->usbdev, CHANNELLISTEP),
 			   udfs->dux_commands, SIZEOFDUXBUFFER, &nsent, 10000);
 	if (tmp < 0)
-		pr_err("comedi%d: could not transmit dux_commands to"
+		pr_err("comedi%d: could not transmit dux_commands to" \
 		       "the usb-device, err=%d\n", udfs->comedidev->minor, tmp);
 	return tmp;
 }
@@ -324,21 +324,21 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 
 	/* sanity checks - is the urb there? */
 	if (!urb) {
-		pr_err("comedi_: usbduxfast_: ao int-handler called "
+		pr_err("comedi_: usbduxfast_: ao int-handler called " \
 		       "with urb=NULL!\n");
 		return;
 	}
 	/* the context variable points to the subdevice */
 	this_comedidev = urb->context;
 	if (!this_comedidev) {
-		pr_err("comedi_: usbduxfast_: urb context is a NULL "
+		pr_err("comedi_: usbduxfast_: urb context is a NULL " \
 		       "pointer!\n");
 		return;
 	}
 	/* the private structure of the subdevice is usbduxfastsub_s */
 	udfs = this_comedidev->private;
 	if (!udfs) {
-		pr_err("comedi_: usbduxfast_: private of comedi "
+		pr_err("comedi_: usbduxfast_: private of comedi " \
 		       "subdev is a NULL pointer!\n");
 		return;
 	}
@@ -381,7 +381,7 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 		return;
 
 	default:
-		printk("comedi%d: usbduxfast: non-zero urb status received in "
+		printk("comedi%d: usbduxfast: non-zero urb status received in "\
 		       "ai intr context: %d\n",
 		       udfs->comedidev->minor, urb->status);
 		s->async->events |= COMEDI_CB_EOA;
@@ -488,7 +488,7 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 			      local_transfer_buffer, 1,	/* Length */
 			      EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
-		pr_err("comedi_: usbduxfast: control msg failed "
+		pr_err("comedi_: usbduxfast: control msg failed " \
 		       "(stop)\n");
 		return ret;
 	}
@@ -543,13 +543,13 @@ static int usbduxfastsub_submit_InURBs(struct usbduxfastsub_s *udfs)
 			  SIZEINBUF, usbduxfastsub_ai_Irq, udfs->comedidev);
 
 #ifdef CONFIG_COMEDI_DEBUG
-	pr_debug("comedi%d: usbduxfast: submitting in-urb: "
+	pr_debug("comedi%d: usbduxfast: submitting in-urb: " \
 	       "0x%p,0x%p\n", udfs->comedidev->minor, udfs->urbIn->context,
 	       udfs->urbIn->dev);
 #endif
 	ret = usb_submit_urb(udfs->urbIn, GFP_ATOMIC);
 	if (ret) {
-		pr_err("comedi_: usbduxfast: ai: usb_submit_urb error"
+		pr_err("comedi_: usbduxfast: ai: usb_submit_urb error" \
 		       " %d\n", ret);
 		return ret;
 	}
@@ -570,8 +570,7 @@ static int usbduxfast_ai_cmdtest(struct comedi_device *dev,
 
 #ifdef CONFIG_COMEDI_DEBUG
 	pr_debug("comedi%d: usbduxfast_ai_cmdtest\n", dev->minor);
-	pr_debug("comedi%d: usbduxfast: convert_arg=%u "
-	       "scan_begin_arg=%u\n",
+	pr_debug("comedi%d: usbduxfast: convert_arg=%u " "scan_begin_arg=%u\n",
 	       dev->minor, cmd->convert_arg, cmd->scan_begin_arg);
 #endif
 	/* step 1: make sure trigger sources are trivially valid */
@@ -719,7 +718,7 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 #endif
 
 	if (trignum != 0) {
-		pr_err("comedi%d: usbduxfast_ai_inttrig: invalid"
+		pr_err("comedi%d: usbduxfast_ai_inttrig: invalid" \
 		       " trignum\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
@@ -728,7 +727,7 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		udfs->ai_cmd_running = 1;
 		ret = usbduxfastsub_submit_InURBs(udfs);
 		if (ret < 0) {
-			pr_err("comedi%d: usbduxfast_ai_inttrig: "
+			pr_err("comedi%d: usbduxfast_ai_inttrig: " \
 			       "urbSubmit: err=%d\n", dev->minor, ret);
 			udfs->ai_cmd_running = 0;
 			up(&udfs->sem);
@@ -736,8 +735,8 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		}
 		s->async->inttrig = NULL;
 	} else {
-		pr_err("comedi%d: ai_inttrig but acqu is already"
-		       " running\n", dev->minor);
+		pr_err("comedi%d: ai_inttrig but acqu is already" " running\n",
+			dev->minor);
 	}
 	up(&udfs->sem);
 	return 1;
@@ -775,7 +774,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		pr_err("comedi%d: ai_cmd not possible. Another ai_cmd"
+		pr_err("comedi%d: ai_cmd not possible. Another ai_cmd" \
 		       " is running.\n", dev->minor);
 		up(&udfs->sem);
 		return -EBUSY;
@@ -794,7 +793,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		for (i = 0; i < cmd->chanlist_len; ++i) {
 			chan = CR_CHAN(cmd->chanlist[i]);
 			if (chan != i) {
-				pr_err("comedi%d: cmd is accepting "
+				pr_err("comedi%d: cmd is accepting " \
 				       "only consecutive channels.\n",
 				       dev->minor);
 				up(&udfs->sem);
@@ -802,22 +801,22 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 			}
 			if ((gain != CR_RANGE(cmd->chanlist[i]))
 			    && (cmd->chanlist_len > 3)) {
-				pr_err("comedi%d: the gain must be"
+				pr_err("comedi%d: the gain must be" \
 				       " the same for all channels.\n",
 				       dev->minor);
 				up(&udfs->sem);
 				return -EINVAL;
 			}
 			if (i >= NUMCHANNELS) {
-				pr_err("comedi%d: channel list too"
-				       " long\n", dev->minor);
+				pr_err("comedi%d: channel list too" " long\n",
+					dev->minor);
 				break;
 			}
 		}
 	}
 	steps = 0;
 	if (cmd->scan_begin_src == TRIG_TIMER) {
-		pr_err("comedi%d: usbduxfast: "
+		pr_err("comedi%d: usbduxfast: " \
 		       "scan_begin_src==TRIG_TIMER not valid.\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
@@ -826,21 +825,21 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		steps = (cmd->convert_arg * 30) / 1000;
 
 	if ((steps < MIN_SAMPLING_PERIOD) && (cmd->chanlist_len != 1)) {
-		pr_err("comedi%d: usbduxfast: ai_cmd: steps=%ld, "
+		pr_err("comedi%d: usbduxfast: ai_cmd: steps=%ld, " \
 		       "scan_begin_arg=%d. Not properly tested by cmdtest?\n",
 		       dev->minor, steps, cmd->scan_begin_arg);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if (steps > MAX_SAMPLING_PERIOD) {
-		pr_err("comedi%d: usbduxfast: ai_cmd: sampling rate "
+		pr_err("comedi%d: usbduxfast: ai_cmd: sampling rate " \
 		       "too low.\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if ((cmd->start_src == TRIG_EXT) && (cmd->chanlist_len != 1)
 	    && (cmd->chanlist_len != 16)) {
-		pr_err("comedi%d: usbduxfast: ai_cmd: TRIG_EXT only"
+		pr_err("comedi%d: usbduxfast: ai_cmd: TRIG_EXT only" \
 		       " with 1 or 16 channels possible.\n", dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
@@ -1158,8 +1157,8 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		break;
 
 	default:
-		pr_err("comedi %d: unsupported combination of "
-		       "channels\n", dev->minor);
+		pr_err("comedi %d: unsupported combination of " "channels\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EFAULT;
 	}
@@ -1171,7 +1170,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	/* 0 means that the AD commands are sent */
 	result = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (result < 0) {
-		pr_err("comedi%d: adc command could not be submitted."
+		pr_err("comedi%d: adc command could not be submitted." \
 		       "Aborting...\n", dev->minor);
 		up(&udfs->sem);
 		return result;
@@ -1179,8 +1178,8 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	if (cmd->stop_src == TRIG_COUNT) {
 		udfs->ai_sample_count = cmd->stop_arg * cmd->scan_end_arg;
 		if (udfs->ai_sample_count < 1) {
-			pr_err("comedi%d: "
-			       "(cmd->stop_arg)*(cmd->scan_end_arg)<1, "
+			pr_err("comedi%d: " \
+			       "(cmd->stop_arg)*(cmd->scan_end_arg)<1, " \
 			       "aborting.\n", dev->minor);
 			up(&udfs->sem);
 			return -EFAULT;
@@ -1235,8 +1234,8 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	pr_debug("comedi%d: ai_insn_read, insn->n=%d, "
-	       "insn->subdev=%d\n", dev->minor, insn->n, insn->subdev);
+	pr_debug("comedi%d: ai_insn_read, insn->n=%d, " "insn->subdev=%d\n",
+		dev->minor, insn->n, insn->subdev);
 #endif
 	down(&udfs->sem);
 	if (!udfs->probed) {
@@ -1244,7 +1243,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		pr_err("comedi%d: ai_insn_read not possible. Async "
+		pr_err("comedi%d: ai_insn_read not possible. Async " \
 		       "Command is running.\n", dev->minor);
 		up(&udfs->sem);
 		return -EBUSY;
@@ -1305,15 +1304,15 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 	/* 0 means that the AD commands are sent */
 	err = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (err < 0) {
-		pr_err("comedi%d: adc command could not be submitted."
+		pr_err("comedi%d: adc command could not be submitted." \
 		       "Aborting...\n", dev->minor);
 		up(&udfs->sem);
 		return err;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	pr_debug("comedi%d: usbduxfast: submitting in-urb: "
-	       "0x%p,0x%p\n", udfs->comedidev->minor, udfs->urbIn->context,
-	       udfs->urbIn->dev);
+	pr_debug("comedi%d: usbduxfast: submitting in-urb: " "0x%p,0x%p\n",
+		udfs->comedidev->minor, udfs->urbIn->context,
+		udfs->urbIn->dev);
 #endif
 	for (i = 0; i < PACKETS_TO_IGNORE; i++) {
 		err = usb_bulk_msg(udfs->usbdev,
@@ -1341,8 +1340,8 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		}
 		n = actual_length / sizeof(uint16_t);
 		if ((n % 16) != 0) {
-			pr_err("comedi%d: insn data packet "
-			       "corrupted.\n", dev->minor);
+			pr_err("comedi%d: insn data packet " "corrupted.\n",
+				dev->minor);
 			up(&udfs->sem);
 			return -EINVAL;
 		}
@@ -1368,7 +1367,7 @@ static int firmwareUpload(struct usbduxfastsub_s *usbduxfastsub,
 
 	if (sizeFirmware > FIRMWARE_MAX_LEN) {
 		dev_err(&usbduxfastsub->interface->dev,
-			"comedi_: usbduxfast firmware binary it too large for FX2.\n");
+		"comedi_: usbduxfast firmware binary it too large for FX2.\n");
 		return -ENOMEM;
 	}
 
@@ -1480,12 +1479,12 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	int ret;
 
 	if (udev->speed != USB_SPEED_HIGH) {
-		pr_err("comedi_: usbduxfast_: This driver needs"
+		pr_err("comedi_: usbduxfast_: This driver needs" \
 		       "USB 2.0 to operate. Aborting...\n");
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	pr_debug("comedi_: usbduxfast_: finding a free structure for "
+	pr_debug("comedi_: usbduxfast_: finding a free structure for " \
 	       "the usb-device\n");
 #endif
 	down(&start_stop_sem);
@@ -1505,7 +1504,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 		return -EMFILE;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	pr_debug("comedi_: usbduxfast: usbduxfastsub[%d] is ready to "
+	pr_debug("comedi_: usbduxfast: usbduxfastsub[%d] is ready to " \
 	       "connect to comedi.\n", index);
 #endif
 
@@ -1531,7 +1530,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	usbduxfastsub[index].dux_commands = kmalloc(SIZEOFDUXBUFFER,
 						    GFP_KERNEL);
 	if (!usbduxfastsub[index].dux_commands) {
-		pr_err("comedi_: usbduxfast: error alloc space for "
+		pr_err("comedi_: usbduxfast: error alloc space for " \
 		       "dac commands\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1540,7 +1539,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxfastsub[index].insnBuffer = kmalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].insnBuffer) {
-		pr_err("comedi_: usbduxfast: could not alloc space "
+		pr_err("comedi_: usbduxfast: could not alloc space " \
 		       "for insnBuffer\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1550,7 +1549,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxfastsub[index].usbdev,
 			      usbduxfastsub[index].ifnum, 1);
 	if (i < 0) {
-		pr_err("comedi_: usbduxfast%d: could not switch to "
+		pr_err("comedi_: usbduxfast%d: could not switch to " \
 		       "alternate setting 1.\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
@@ -1558,16 +1557,16 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	}
 	usbduxfastsub[index].urbIn = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbduxfastsub[index].urbIn) {
-		pr_err("comedi_: usbduxfast%d: Could not alloc."
-		       "urb\n", index);
+		pr_err("comedi_: usbduxfast%d: Could not alloc." "urb\n",
+			index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
 	}
 	usbduxfastsub[index].transfer_buffer = kmalloc(SIZEINBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].transfer_buffer) {
-		pr_err("comedi_: usbduxfast%d: could not alloc. "
-		       "transb.\n", index);
+		pr_err("comedi_: usbduxfast%d: could not alloc. " "transb.\n",
+			index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1577,19 +1576,19 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	up(&start_stop_sem);
 
 	ret = request_firmware_nowait(THIS_MODULE,
-				      FW_ACTION_HOTPLUG,
-				      "usbduxfast_firmware.bin",
-				      &udev->dev,
-				      GFP_KERNEL,
-				      usbduxfastsub + index,
-				      usbduxfast_firmware_request_complete_handler);
+				FW_ACTION_HOTPLUG,
+				"usbduxfast_firmware.bin",
+				&udev->dev,
+				GFP_KERNEL,
+				usbduxfastsub + index,
+				usbduxfast_firmware_request_complete_handler);
 
 	if (ret) {
 		dev_err(&udev->dev, "could not load firmware (err=%d)\n", ret);
 		return ret;
 	}
 
-	pr_info("comedi_: usbduxfast%d has been successfully "
+	pr_info("comedi_: usbduxfast%d has been successfully " \
 	       "initialized.\n", index);
 	/* success */
 	return 0;
@@ -1601,13 +1600,13 @@ static void usbduxfastsub_disconnect(struct usb_interface *intf)
 	struct usb_device *udev = interface_to_usbdev(intf);
 
 	if (!udfs) {
-		pr_err("comedi_: usbduxfast: disconnect called with "
+		pr_err("comedi_: usbduxfast: disconnect called with " \
 		       "null pointer.\n");
 		return;
 	}
 	if (udfs->usbdev != udev) {
-		pr_err("comedi_: usbduxfast: BUG! called with wrong "
-		       "ptr!!!\n");
+		pr_err("comedi_: usbduxfast: BUG! called with wrong " \
+			"ptr!!!\n");
 		return;
 	}
 
@@ -1650,7 +1649,7 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	}
 
 	if (index < 0) {
-		pr_err("comedi%d: usbduxfast: error: attach failed, "
+		pr_err("comedi%d: usbduxfast: error: attach failed, " \
 		       "no usbduxfast devs connected to the usb bus.\n",
 		       dev->minor);
 		up(&start_stop_sem);
@@ -1677,14 +1676,14 @@ static int usbduxfast_attach(struct comedi_device *dev,
 	/* allocate space for the subdevices */
 	ret = alloc_subdevices(dev, N_SUBDEVICES);
 	if (ret < 0) {
-		pr_err("comedi%d: usbduxfast: error alloc space for "
+		pr_err("comedi%d: usbduxfast: error alloc space for " \
 		       "subdev\n", dev->minor);
 		up(&(usbduxfastsub[index].sem));
 		up(&start_stop_sem);
 		return ret;
 	}
 
-	pr_info("comedi%d: usbduxfast: usb-device %d is attached to "
+	pr_info("comedi%d: usbduxfast: usb-device %d is attached to " \
 	       "comedi.\n", dev->minor, index);
 	/* private structure is also simply the usb-structure */
 	dev->private = usbduxfastsub + index;
@@ -1782,8 +1781,7 @@ static struct usb_driver usbduxfastsub_driver = {
  */
 static int __init init_usbduxfast(void)
 {
-	printk(KERN_INFO
-	       KBUILD_MODNAME ": " DRIVER_VERSION ":" DRIVER_DESC "\n");
+	pr_info(KBUILD_MODNAME ": " DRIVER_VERSION ":" DRIVER_DESC "\n");
 	usb_register(&usbduxfastsub_driver);
 	comedi_driver_register(&driver_usbduxfast);
 	return 0;
-- 
1.7.11.1

