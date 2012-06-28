Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab2F1E2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:28:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54809 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2F1E2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:28:24 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH 3/3] Staging: comedi: drivers: usbduxfast: changed "printk(KERN_DEBUG ..." for "pr_debug(..."
Date: Thu, 28 Jun 2012 01:28:20 -0300
Message-Id: <1340857700-22904-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed 41 instances of printk(KERN_DEBUG for the prefered pr_debug(

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 44 ++++++++++++++---------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 9bcdcd1..a8d8d06 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -216,7 +216,7 @@ static int send_dux_commands(struct usbduxfastsub_s *udfs, int cmd_type)
 	udfs->dux_commands[0] = cmd_type;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: dux_commands: ",
+	pr_debug("comedi%d: usbduxfast: dux_commands: ",
 	       udfs->comedidev->minor);
 	for (tmp = 0; tmp < SIZEOFDUXBUFFER; tmp++)
 		printk(" %02x", udfs->dux_commands[tmp]);
@@ -248,7 +248,7 @@ static int usbduxfastsub_unlink_InURBs(struct usbduxfastsub_s *udfs)
 		j = 0;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast: unlinked InURB: res=%d\n", j);
+	pr_debug("comedi: usbduxfast: unlinked InURB: res=%d\n", j);
 #endif
 	return err;
 }
@@ -267,7 +267,7 @@ static int usbduxfast_ai_stop(struct usbduxfastsub_s *udfs, int do_unlink)
 		return -EFAULT;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast_ai_stop\n");
+	pr_debug("comedi: usbduxfast_ai_stop\n");
 #endif
 
 	udfs->ai_cmd_running = 0;
@@ -291,7 +291,7 @@ static int usbduxfast_ai_cancel(struct comedi_device *dev,
 
 	/* force unlink of all urbs */
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast_ai_cancel\n");
+	pr_debug("comedi: usbduxfast_ai_cancel\n");
 #endif
 	udfs = dev->private;
 	if (!udfs) {
@@ -503,8 +503,8 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 	int ret;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast: uploading %d bytes", len);
-	printk(KERN_DEBUG " to addr %d, first byte=%d.\n",
+	pr_debug("comedi: usbduxfast: uploading %d bytes", len);
+	pr_debug(" to addr %d, first byte=%d.\n",
 	       startAddr, local_transfer_buffer[0]);
 #endif
 	/* brequest, firmware */
@@ -519,7 +519,7 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 			      EZTIMEOUT);      /* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
+	pr_debug("comedi_: usbduxfast: result=%d\n", ret);
 #endif
 
 	if (ret < 0) {
@@ -543,7 +543,7 @@ static int usbduxfastsub_submit_InURBs(struct usbduxfastsub_s *udfs)
 			  SIZEINBUF, usbduxfastsub_ai_Irq, udfs->comedidev);
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: submitting in-urb: "
+	pr_debug("comedi%d: usbduxfast: submitting in-urb: "
 	       "0x%p,0x%p\n", udfs->comedidev->minor, udfs->urbIn->context,
 	       udfs->urbIn->dev);
 #endif
@@ -569,8 +569,8 @@ static int usbduxfast_ai_cmdtest(struct comedi_device *dev,
 		return -ENODEV;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast_ai_cmdtest\n", dev->minor);
-	printk(KERN_DEBUG "comedi%d: usbduxfast: convert_arg=%u "
+	pr_debug("comedi%d: usbduxfast_ai_cmdtest\n", dev->minor);
+	pr_debug("comedi%d: usbduxfast: convert_arg=%u "
 	       "scan_begin_arg=%u\n",
 	       dev->minor, cmd->convert_arg, cmd->scan_begin_arg);
 #endif
@@ -715,7 +715,7 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast_ai_inttrig\n", dev->minor);
+	pr_debug("comedi%d: usbduxfast_ai_inttrig\n", dev->minor);
 #endif
 
 	if (trignum != 0) {
@@ -763,7 +763,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	long steps, steps_tmp;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast_ai_cmd\n", dev->minor);
+	pr_debug("comedi%d: usbduxfast_ai_cmd\n", dev->minor);
 #endif
 	udfs = dev->private;
 	if (!udfs)
@@ -846,7 +846,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		return -EINVAL;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: steps=%ld, convert_arg=%u\n",
+	pr_debug("comedi%d: usbduxfast: steps=%ld, convert_arg=%u\n",
 	       dev->minor, steps, cmd->convert_arg);
 #endif
 
@@ -1165,7 +1165,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	}
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi %d: sending commands to the usb device\n",
+	pr_debug("comedi %d: sending commands to the usb device\n",
 	       dev->minor);
 #endif
 	/* 0 means that the AD commands are sent */
@@ -1235,7 +1235,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: ai_insn_read, insn->n=%d, "
+	pr_debug("comedi%d: ai_insn_read, insn->n=%d, "
 	       "insn->subdev=%d\n", dev->minor, insn->n, insn->subdev);
 #endif
 	down(&udfs->sem);
@@ -1299,7 +1299,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 	udfs->dux_commands[LOGBASE + 0] = 0;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi %d: sending commands to the usb device\n",
+	pr_debug("comedi %d: sending commands to the usb device\n",
 	       dev->minor);
 #endif
 	/* 0 means that the AD commands are sent */
@@ -1311,7 +1311,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		return err;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: submitting in-urb: "
+	pr_debug("comedi%d: usbduxfast: submitting in-urb: "
 	       "0x%p,0x%p\n", udfs->comedidev->minor, udfs->urbIn->context,
 	       udfs->urbIn->dev);
 #endif
@@ -1409,7 +1409,7 @@ static int firmwareUpload(struct usbduxfastsub_s *usbduxfastsub,
 static void tidy_up(struct usbduxfastsub_s *udfs)
 {
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: tiding up\n");
+	pr_debug("comedi_: usbduxfast: tiding up\n");
 #endif
 
 	if (!udfs)
@@ -1485,7 +1485,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast_: finding a free structure for "
+	pr_debug("comedi_: usbduxfast_: finding a free structure for "
 	       "the usb-device\n");
 #endif
 	down(&start_stop_sem);
@@ -1505,7 +1505,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 		return -EMFILE;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: usbduxfastsub[%d] is ready to "
+	pr_debug("comedi_: usbduxfast: usbduxfastsub[%d] is ready to "
 	       "connect to comedi.\n", index);
 #endif
 
@@ -1524,7 +1524,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	usb_set_intfdata(uinterf, &(usbduxfastsub[index]));
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: ifnum=%d\n",
+	pr_debug("comedi_: usbduxfast: ifnum=%d\n",
 	       usbduxfastsub[index].ifnum);
 #endif
 	/* create space for the commands going to the usb device */
@@ -1620,7 +1620,7 @@ static void usbduxfastsub_disconnect(struct usb_interface *intf)
 	up(&start_stop_sem);
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: disconnected from the usb\n");
+	pr_debug("comedi_: usbduxfast: disconnected from the usb\n");
 #endif
 }
 
-- 
1.7.11.1

