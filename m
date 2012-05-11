Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab2EKKjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:39:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52986 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2EKKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:39:15 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 01/25] Staging: comedi: fix printk issue in usbduxfast.c
Date: Fri, 11 May 2012 16:07:49 +0530
Message-Id: <1336732693-7408-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a printk found
by the checkpatch.pl tool.

i.e. WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
     WARNING: Prefer pr_err(... to printk(KERN_ERR, ...and
     WARNING: quoted string split across lines.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   34 ++++++++++++---------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index c672ea3..09d2d9f 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -216,19 +216,19 @@ static int send_dux_commands(struct usbduxfastsub_s *udfs, int cmd_type)
 	udfs->dux_commands[0] = cmd_type;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: dux_commands: ",
-	       udfs->comedidev->minor);
+	pr_debug("comedi%d: usbduxfast: dux_commands: ",
+		 udfs->comedidev->minor);
 	for (tmp = 0; tmp < SIZEOFDUXBUFFER; tmp++)
-		printk(" %02x", udfs->dux_commands[tmp]);
-	printk("\n");
+		pr_cont(" %02x", udfs->dux_commands[tmp]);
+	pr_cont("\n");
 #endif
 
 	tmp = usb_bulk_msg(udfs->usbdev,
 			   usb_sndbulkpipe(udfs->usbdev, CHANNELLISTEP),
 			   udfs->dux_commands, SIZEOFDUXBUFFER, &nsent, 10000);
 	if (tmp < 0)
-		printk(KERN_ERR "comedi%d: could not transmit dux_commands to"
-		       "the usb-device, err=%d\n", udfs->comedidev->minor, tmp);
+		pr_err("comedi%d: could not transmit dux_commands to the usb-device, err=%d\n",
+		       udfs->comedidev->minor, tmp);
 	return tmp;
 }
 
@@ -248,7 +248,7 @@ static int usbduxfastsub_unlink_InURBs(struct usbduxfastsub_s *udfs)
 		j = 0;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast: unlinked InURB: res=%d\n", j);
+	pr_debug("comedi: usbduxfast: unlinked InURB: res=%d\n", j);
 #endif
 	return err;
 }
@@ -263,11 +263,11 @@ static int usbduxfast_ai_stop(struct usbduxfastsub_s *udfs, int do_unlink)
 	int ret = 0;
 
 	if (!udfs) {
-		printk(KERN_ERR "comedi?: usbduxfast_ai_stop: udfs=NULL!\n");
+		pr_err("comedi?: usbduxfast_ai_stop: udfs=NULL!\n");
 		return -EFAULT;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast_ai_stop\n");
+	pr_debug("comedi: usbduxfast_ai_stop\n");
 #endif
 
 	udfs->ai_cmd_running = 0;
@@ -324,22 +324,19 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 
 	/* sanity checks - is the urb there? */
 	if (!urb) {
-		printk(KERN_ERR "comedi_: usbduxfast_: ao int-handler called "
-		       "with urb=NULL!\n");
+		pr_err("comedi_: usbduxfast_: ao int-handler called with urb=NULL!\n");
 		return;
 	}
 	/* the context variable points to the subdevice */
 	this_comedidev = urb->context;
 	if (!this_comedidev) {
-		printk(KERN_ERR "comedi_: usbduxfast_: urb context is a NULL "
-		       "pointer!\n");
+		pr_err("comedi_: usbduxfast_: urb context is a NULL pointer!\n");
 		return;
 	}
 	/* the private structure of the subdevice is usbduxfastsub_s */
 	udfs = this_comedidev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi_: usbduxfast_: private of comedi "
-		       "subdev is a NULL pointer!\n");
+		pr_err("comedi_: usbduxfast_: private of comedi subdev is a NULL pointer!\n");
 		return;
 	}
 	/* are we running a command? */
@@ -438,7 +435,7 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 	urb->status = 0;
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast: urb resubm failed: %d",
+		pr_err("comedi%d: usbduxfast: urb resubm failed: %d\n",
 		       udfs->comedidev->minor, err);
 		s->async->events |= COMEDI_CB_EOA;
 		s->async->events |= COMEDI_CB_ERROR;
@@ -465,7 +462,7 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 			      1,      /* Length */
 			      EZTIMEOUT);    /* Timeout */
 	if (ret < 0) {
-		printk("comedi_: usbduxfast_: control msg failed (start)\n");
+		pr_err("comedi_: usbduxfast_: control msg failed (start)\n");
 		return ret;
 	}
 
@@ -488,8 +485,7 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 			      local_transfer_buffer, 1,	/* Length */
 			      EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast: control msg failed "
-		       "(stop)\n");
+		pr_err("comedi_: usbduxfast: control msg failed (stop)\n");
 		return ret;
 	}
 
-- 
1.7.0.4

