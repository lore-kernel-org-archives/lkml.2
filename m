Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab2EKKj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:39:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777Ab2EKKj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:39:28 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 02/25] Staging: comedi: fix printk issues in usbduxfast.c
Date: Fri, 11 May 2012 16:07:50 +0530
Message-Id: <1336732693-7408-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a printk found
by checkpatch.pl tool.

i.e. WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
     WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
     WARNING: quoted string split across lines.
     WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   47 ++++++++++++---------------
 1 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 09d2d9f..32e3f65 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -539,14 +539,14 @@ static int usbduxfastsub_submit_InURBs(struct usbduxfastsub_s *udfs)
 			  SIZEINBUF, usbduxfastsub_ai_Irq, udfs->comedidev);
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: submitting in-urb: "
-	       "0x%p,0x%p\n", udfs->comedidev->minor, udfs->urbIn->context,
-	       udfs->urbIn->dev);
+	pr_debug("comedi%d: usbduxfast: submitting in-urb: 0x%p,0x%p\n",
+		 udfs->comedidev->minor, udfs->urbIn->context,
+		 udfs->urbIn->dev);
 #endif
 	ret = usb_submit_urb(udfs->urbIn, GFP_ATOMIC);
 	if (ret) {
-		printk(KERN_ERR "comedi_: usbduxfast: ai: usb_submit_urb error"
-		       " %d\n", ret);
+		pr_err("comedi_: usbduxfast: ai: usb_submit_urb error %d\n",
+		       ret);
 		return ret;
 	}
 	return 0;
@@ -1476,13 +1476,11 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	int ret;
 
 	if (udev->speed != USB_SPEED_HIGH) {
-		printk(KERN_ERR "comedi_: usbduxfast_: This driver needs"
-		       "USB 2.0 to operate. Aborting...\n");
+		pr_err("comedi_: usbduxfast_: This driver needs USB 2.0 to operate. Aborting...\n");
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast_: finding a free structure for "
-	       "the usb-device\n");
+	pr_debug("comedi_: usbduxfast_: finding a free structure for the usb-device\n");
 #endif
 	down(&start_stop_sem);
 	/* look for a free place in the usbduxfast array */
@@ -1496,13 +1494,13 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 
 	/* no more space */
 	if (index == -1) {
-		printk(KERN_ERR "Too many usbduxfast-devices connected.\n");
+		pr_err("Too many usbduxfast-devices connected.\n");
 		up(&start_stop_sem);
 		return -EMFILE;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: usbduxfastsub[%d] is ready to "
-	       "connect to comedi.\n", index);
+	pr_debug("comedi_: usbduxfast: usbduxfastsub[%d] is ready to connect to comedi.\n",
+		 index);
 #endif
 
 	sema_init(&(usbduxfastsub[index].sem), 1);
@@ -1520,15 +1518,14 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	usb_set_intfdata(uinterf, &(usbduxfastsub[index]));
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi_: usbduxfast: ifnum=%d\n",
-	       usbduxfastsub[index].ifnum);
+	pr_debug("comedi_: usbduxfast: ifnum=%d\n",
+		 usbduxfastsub[index].ifnum);
 #endif
 	/* create space for the commands going to the usb device */
 	usbduxfastsub[index].dux_commands = kmalloc(SIZEOFDUXBUFFER,
 						    GFP_KERNEL);
 	if (!usbduxfastsub[index].dux_commands) {
-		printk(KERN_ERR "comedi_: usbduxfast: error alloc space for "
-		       "dac commands\n");
+		pr_err("comedi_: usbduxfast: error alloc space for dac commands\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1536,8 +1533,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	/* create space of the instruction buffer */
 	usbduxfastsub[index].insnBuffer = kmalloc(SIZEINSNBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].insnBuffer) {
-		printk(KERN_ERR "comedi_: usbduxfast: could not alloc space "
-		       "for insnBuffer\n");
+		pr_err("comedi_: usbduxfast: could not alloc space for insnBuffer\n");
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1546,24 +1542,23 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxfastsub[index].usbdev,
 			      usbduxfastsub[index].ifnum, 1);
 	if (i < 0) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: could not switch to "
-		       "alternate setting 1.\n", index);
+		pr_err("comedi_: usbduxfast%d: could not switch to alternate setting 1.\n",
+		       index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENODEV;
 	}
 	usbduxfastsub[index].urbIn = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbduxfastsub[index].urbIn) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: Could not alloc."
-		       "urb\n", index);
+		pr_err("comedi_: usbduxfast%d: Could not alloc.urb\n", index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
 	}
 	usbduxfastsub[index].transfer_buffer = kmalloc(SIZEINBUF, GFP_KERNEL);
 	if (!usbduxfastsub[index].transfer_buffer) {
-		printk(KERN_ERR "comedi_: usbduxfast%d: could not alloc. "
-		       "transb.\n", index);
+		pr_err("comedi_: usbduxfast%d: could not alloc. transb.\n",
+		       index);
 		tidy_up(&(usbduxfastsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -1585,8 +1580,8 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 		return ret;
 	}
 
-	printk(KERN_INFO "comedi_: usbduxfast%d has been successfully "
-	       "initialized.\n", index);
+	pr_info("comedi_: usbduxfast%d has been successfully initialized.\n",
+	       index);
 	/* success */
 	return 0;
 }
-- 
1.7.0.4

