Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0FYSfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:35:31 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:56089 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756697Ab0FYSfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:35:30 -0400
Date: Fri, 25 Jun 2010 20:25:37 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] usb: usblp: fixed switch, brace, whitespace and spacing
 coding style issues
Message-ID: <20100625202537.1cd4526c@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed switch, brace, whitespace and spacing coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/usb/class/usblp.c |  371 ++++++++++++++++++++++-----------------------
 1 files changed, 185 insertions(+), 186 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 2250095..74759df 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -135,7 +135,7 @@ MFG:HEWLETT-PACKARD;MDL:DESKJET 970C;CMD:MLC,PCL,PML;CLASS:PRINTER;DESCRIPTION:H
  * ->lock locks what interrupt accesses.
  */
 struct usblp {
-	struct usb_device 	*dev;			/* USB device */
+	struct usb_device	*dev;			/* USB device */
 	struct mutex		wmut;
 	struct mutex		mut;
 	spinlock_t		lock;		/* locks rcomplete, wcomplete */
@@ -169,7 +169,8 @@ struct usblp {
 };
 
 #ifdef DEBUG
-static void usblp_dump(struct usblp *usblp) {
+static void usblp_dump(struct usblp *usblp)
+{
 	int p;
 
 	dbg("usblp=0x%p", usblp);
@@ -216,8 +217,8 @@ static const struct quirk_printer_struct quirk_printers[] = {
 	{ 0x03f0, 0x0304, USBLP_QUIRK_BIDIR }, /* HP DeskJet 810C/812C */
 	{ 0x03f0, 0x0404, USBLP_QUIRK_BIDIR }, /* HP DeskJet 830C */
 	{ 0x03f0, 0x0504, USBLP_QUIRK_BIDIR }, /* HP DeskJet 885C */
-	{ 0x03f0, 0x0604, USBLP_QUIRK_BIDIR }, /* HP DeskJet 840C */   
-	{ 0x03f0, 0x0804, USBLP_QUIRK_BIDIR }, /* HP DeskJet 816C */   
+	{ 0x03f0, 0x0604, USBLP_QUIRK_BIDIR }, /* HP DeskJet 840C */
+	{ 0x03f0, 0x0804, USBLP_QUIRK_BIDIR }, /* HP DeskJet 816C */
 	{ 0x03f0, 0x1104, USBLP_QUIRK_BIDIR }, /* HP Deskjet 959C */
 	{ 0x0409, 0xefbe, USBLP_QUIRK_BIDIR }, /* NEC Picty900 (HP OEM) */
 	{ 0x0409, 0xbef4, USBLP_QUIRK_BIDIR }, /* NEC Picty760 (HP OEM) */
@@ -254,9 +255,8 @@ static int usblp_ctrl_msg(struct usblp *usblp, int request, int type, int dir, i
 	/* High byte has the interface index.
 	   Low byte has the alternate setting.
 	 */
-	if ((request == USBLP_REQ_GET_ID) && (type == USB_TYPE_CLASS)) {
-	  index = (usblp->ifnum<<8)|usblp->protocol[usblp->current_protocol].alt_setting;
-	}
+	if ((request == USBLP_REQ_GET_ID) && (type == USB_TYPE_CLASS))
+		index = (usblp->ifnum<<8)|usblp->protocol[usblp->current_protocol].alt_setting;
 
 	retval = usb_control_msg(usblp->dev,
 		dir ? usb_rcvctrlpipe(usblp->dev, 0) : usb_sndctrlpipe(usblp->dev, 0),
@@ -372,7 +372,7 @@ static int usblp_check_status(struct usblp *usblp, int err)
 	return newerr;
 }
 
-static int handle_bidir (struct usblp *usblp)
+static int handle_bidir(struct usblp *usblp)
 {
 	if (usblp->bidir && usblp->used) {
 		if (usblp_submit_read(usblp) < 0)
@@ -395,14 +395,13 @@ static int usblp_open(struct inode *inode, struct file *file)
 	if (minor < 0)
 		return -ENODEV;
 
-	mutex_lock (&usblp_mutex);
+	mutex_lock(&usblp_mutex);
 
 	retval = -ENODEV;
 	intf = usb_find_interface(&usblp_driver, minor);
-	if (!intf) {
+	if (!intf)
 		goto out;
-	}
-	usblp = usb_get_intfdata (intf);
+	usblp = usb_get_intfdata(intf);
 	if (!usblp || !usblp->dev || !usblp->present)
 		goto out;
 
@@ -433,18 +432,18 @@ static int usblp_open(struct inode *inode, struct file *file)
 		retval = -EIO;
 	}
 out:
-	mutex_unlock (&usblp_mutex);
+	mutex_unlock(&usblp_mutex);
 	return retval;
 }
 
-static void usblp_cleanup (struct usblp *usblp)
+static void usblp_cleanup(struct usblp *usblp)
 {
 	printk(KERN_INFO "usblp%d: removed\n", usblp->minor);
 
 	kfree(usblp->readbuf);
-	kfree (usblp->device_id_string);
-	kfree (usblp->statusbuf);
-	kfree (usblp);
+	kfree(usblp->device_id_string);
+	kfree(usblp->statusbuf);
+	kfree(usblp);
 }
 
 static void usblp_unlink_urbs(struct usblp *usblp)
@@ -458,14 +457,14 @@ static int usblp_release(struct inode *inode, struct file *file)
 
 	usblp->flags &= ~LP_ABORT;
 
-	mutex_lock (&usblp_mutex);
+	mutex_lock(&usblp_mutex);
 	usblp->used = 0;
 	if (usblp->present) {
 		usblp_unlink_urbs(usblp);
 		usb_autopm_put_interface(usblp->intf);
-	} else 		/* finish cleanup from disconnect */
-		usblp_cleanup (usblp);
-	mutex_unlock (&usblp_mutex);
+	} else		/* finish cleanup from disconnect */
+		usblp_cleanup(usblp);
+	mutex_unlock(&usblp_mutex);
 	return 0;
 }
 
@@ -495,190 +494,190 @@ static long usblp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int twoints[2];
 	int retval = 0;
 
-	mutex_lock (&usblp->mut);
+	mutex_lock(&usblp->mut);
 	if (!usblp->present) {
 		retval = -ENODEV;
 		goto done;
 	}
 
 	dbg("usblp_ioctl: cmd=0x%x (%c nr=%d len=%d dir=%d)", cmd, _IOC_TYPE(cmd),
-		_IOC_NR(cmd), _IOC_SIZE(cmd), _IOC_DIR(cmd) );
+		_IOC_NR(cmd), _IOC_SIZE(cmd), _IOC_DIR(cmd));
 
 	if (_IOC_TYPE(cmd) == 'P')	/* new-style ioctl number */
 
 		switch (_IOC_NR(cmd)) {
 
-			case IOCNR_GET_DEVICE_ID: /* get the DEVICE_ID string */
-				if (_IOC_DIR(cmd) != _IOC_READ) {
-					retval = -EINVAL;
-					goto done;
-				}
+		case IOCNR_GET_DEVICE_ID: /* get the DEVICE_ID string */
+			if (_IOC_DIR(cmd) != _IOC_READ) {
+				retval = -EINVAL;
+				goto done;
+			}
 
-				length = usblp_cache_device_id_string(usblp);
-				if (length < 0) {
-					retval = length;
-					goto done;
-				}
-				if (length > _IOC_SIZE(cmd))
-					length = _IOC_SIZE(cmd); /* truncate */
-
-				if (copy_to_user((void __user *) arg,
-						usblp->device_id_string,
-						(unsigned long) length)) {
-					retval = -EFAULT;
-					goto done;
-				}
+			length = usblp_cache_device_id_string(usblp);
+			if (length < 0) {
+				retval = length;
+				goto done;
+			}
+			if (length > _IOC_SIZE(cmd))
+				length = _IOC_SIZE(cmd); /* truncate */
+
+			if (copy_to_user((void __user *) arg,
+					usblp->device_id_string,
+					(unsigned long) length)) {
+				retval = -EFAULT;
+				goto done;
+			}
 
-				break;
+			break;
 
-			case IOCNR_GET_PROTOCOLS:
-				if (_IOC_DIR(cmd) != _IOC_READ ||
-				    _IOC_SIZE(cmd) < sizeof(twoints)) {
-					retval = -EINVAL;
-					goto done;
-				}
+		case IOCNR_GET_PROTOCOLS:
+			if (_IOC_DIR(cmd) != _IOC_READ ||
+			    _IOC_SIZE(cmd) < sizeof(twoints)) {
+				retval = -EINVAL;
+				goto done;
+			}
 
-				twoints[0] = usblp->current_protocol;
-				twoints[1] = 0;
-				for (i = USBLP_FIRST_PROTOCOL;
-				     i <= USBLP_LAST_PROTOCOL; i++) {
-					if (usblp->protocol[i].alt_setting >= 0)
-						twoints[1] |= (1<<i);
-				}
+			twoints[0] = usblp->current_protocol;
+			twoints[1] = 0;
+			for (i = USBLP_FIRST_PROTOCOL;
+			     i <= USBLP_LAST_PROTOCOL; i++) {
+				if (usblp->protocol[i].alt_setting >= 0)
+					twoints[1] |= (1<<i);
+			}
 
-				if (copy_to_user((void __user *)arg,
-						(unsigned char *)twoints,
-						sizeof(twoints))) {
-					retval = -EFAULT;
-					goto done;
-				}
+			if (copy_to_user((void __user *)arg,
+					(unsigned char *)twoints,
+					sizeof(twoints))) {
+				retval = -EFAULT;
+				goto done;
+			}
 
-				break;
+			break;
 
-			case IOCNR_SET_PROTOCOL:
-				if (_IOC_DIR(cmd) != _IOC_WRITE) {
-					retval = -EINVAL;
-					goto done;
-				}
+		case IOCNR_SET_PROTOCOL:
+			if (_IOC_DIR(cmd) != _IOC_WRITE) {
+				retval = -EINVAL;
+				goto done;
+			}
 
 #ifdef DEBUG
-				if (arg == -10) {
-					usblp_dump(usblp);
-					break;
-				}
+			if (arg == -10) {
+				usblp_dump(usblp);
+				break;
+			}
 #endif
 
-				usblp_unlink_urbs(usblp);
-				retval = usblp_set_protocol(usblp, arg);
-				if (retval < 0) {
-					usblp_set_protocol(usblp,
-						usblp->current_protocol);
-				}
-				break;
+			usblp_unlink_urbs(usblp);
+			retval = usblp_set_protocol(usblp, arg);
+			if (retval < 0) {
+				usblp_set_protocol(usblp,
+					usblp->current_protocol);
+			}
+			break;
 
-			case IOCNR_HP_SET_CHANNEL:
-				if (_IOC_DIR(cmd) != _IOC_WRITE ||
-				    le16_to_cpu(usblp->dev->descriptor.idVendor) != 0x03F0 ||
-				    usblp->quirks & USBLP_QUIRK_BIDIR) {
-					retval = -EINVAL;
-					goto done;
-				}
+		case IOCNR_HP_SET_CHANNEL:
+			if (_IOC_DIR(cmd) != _IOC_WRITE ||
+			    le16_to_cpu(usblp->dev->descriptor.idVendor) != 0x03F0 ||
+			    usblp->quirks & USBLP_QUIRK_BIDIR) {
+				retval = -EINVAL;
+				goto done;
+			}
 
-				err = usblp_hp_channel_change_request(usblp,
-					arg, &newChannel);
-				if (err < 0) {
-					dev_err(&usblp->dev->dev,
-						"usblp%d: error = %d setting "
-						"HP channel\n",
-						usblp->minor, err);
-					retval = -EIO;
-					goto done;
-				}
+			err = usblp_hp_channel_change_request(usblp,
+				arg, &newChannel);
+			if (err < 0) {
+				dev_err(&usblp->dev->dev,
+					"usblp%d: error = %d setting "
+					"HP channel\n",
+					usblp->minor, err);
+				retval = -EIO;
+				goto done;
+			}
 
-				dbg("usblp%d requested/got HP channel %ld/%d",
-					usblp->minor, arg, newChannel);
-				break;
+			dbg("usblp%d requested/got HP channel %ld/%d",
+				usblp->minor, arg, newChannel);
+			break;
 
-			case IOCNR_GET_BUS_ADDRESS:
-				if (_IOC_DIR(cmd) != _IOC_READ ||
-				    _IOC_SIZE(cmd) < sizeof(twoints)) {
-					retval = -EINVAL;
-					goto done;
-				}
+		case IOCNR_GET_BUS_ADDRESS:
+			if (_IOC_DIR(cmd) != _IOC_READ ||
+			    _IOC_SIZE(cmd) < sizeof(twoints)) {
+				retval = -EINVAL;
+				goto done;
+			}
 
-				twoints[0] = usblp->dev->bus->busnum;
-				twoints[1] = usblp->dev->devnum;
-				if (copy_to_user((void __user *)arg,
-						(unsigned char *)twoints,
-						sizeof(twoints))) {
-					retval = -EFAULT;
-					goto done;
-				}
+			twoints[0] = usblp->dev->bus->busnum;
+			twoints[1] = usblp->dev->devnum;
+			if (copy_to_user((void __user *)arg,
+					(unsigned char *)twoints,
+					sizeof(twoints))) {
+				retval = -EFAULT;
+				goto done;
+			}
 
-				dbg("usblp%d is bus=%d, device=%d",
-					usblp->minor, twoints[0], twoints[1]);
-				break;
+			dbg("usblp%d is bus=%d, device=%d",
+				usblp->minor, twoints[0], twoints[1]);
+			break;
 
-			case IOCNR_GET_VID_PID:
-				if (_IOC_DIR(cmd) != _IOC_READ ||
-				    _IOC_SIZE(cmd) < sizeof(twoints)) {
-					retval = -EINVAL;
-					goto done;
-				}
+		case IOCNR_GET_VID_PID:
+			if (_IOC_DIR(cmd) != _IOC_READ ||
+			    _IOC_SIZE(cmd) < sizeof(twoints)) {
+				retval = -EINVAL;
+				goto done;
+			}
 
-				twoints[0] = le16_to_cpu(usblp->dev->descriptor.idVendor);
-				twoints[1] = le16_to_cpu(usblp->dev->descriptor.idProduct);
-				if (copy_to_user((void __user *)arg,
-						(unsigned char *)twoints,
-						sizeof(twoints))) {
-					retval = -EFAULT;
-					goto done;
-				}
+			twoints[0] = le16_to_cpu(usblp->dev->descriptor.idVendor);
+			twoints[1] = le16_to_cpu(usblp->dev->descriptor.idProduct);
+			if (copy_to_user((void __user *)arg,
+					(unsigned char *)twoints,
+					sizeof(twoints))) {
+				retval = -EFAULT;
+				goto done;
+			}
 
-				dbg("usblp%d is VID=0x%4.4X, PID=0x%4.4X",
-					usblp->minor, twoints[0], twoints[1]);
-				break;
+			dbg("usblp%d is VID=0x%4.4X, PID=0x%4.4X",
+				usblp->minor, twoints[0], twoints[1]);
+			break;
 
-			case IOCNR_SOFT_RESET:
-				if (_IOC_DIR(cmd) != _IOC_NONE) {
-					retval = -EINVAL;
-					goto done;
-				}
-				retval = usblp_reset(usblp);
-				break;
-			default:
-				retval = -ENOTTY;
+		case IOCNR_SOFT_RESET:
+			if (_IOC_DIR(cmd) != _IOC_NONE) {
+				retval = -EINVAL;
+				goto done;
+			}
+			retval = usblp_reset(usblp);
+			break;
+		default:
+			retval = -ENOTTY;
 		}
 	else	/* old-style ioctl value */
 		switch (cmd) {
 
-			case LPGETSTATUS:
-				if ((retval = usblp_read_status(usblp, usblp->statusbuf))) {
-					if (printk_ratelimit())
-						printk(KERN_ERR "usblp%d:"
-						    "failed reading printer status (%d)\n",
-						    usblp->minor, retval);
-					retval = -EIO;
-					goto done;
-				}
-				status = *usblp->statusbuf;
-				if (copy_to_user ((void __user *)arg, &status, sizeof(int)))
-					retval = -EFAULT;
-				break;
+		case LPGETSTATUS:
+			if ((retval = usblp_read_status(usblp, usblp->statusbuf))) {
+				if (printk_ratelimit())
+					printk(KERN_ERR "usblp%d:"
+					    "failed reading printer status (%d)\n",
+					    usblp->minor, retval);
+				retval = -EIO;
+				goto done;
+			}
+			status = *usblp->statusbuf;
+			if (copy_to_user((void __user *)arg, &status, sizeof(int)))
+				retval = -EFAULT;
+			break;
 
-			case LPABORT:
-				if (arg)
-					usblp->flags |= LP_ABORT;
-				else
-					usblp->flags &= ~LP_ABORT;
-				break;
+		case LPABORT:
+			if (arg)
+				usblp->flags |= LP_ABORT;
+			else
+				usblp->flags &= ~LP_ABORT;
+			break;
 
-			default:
-				retval = -ENOTTY;
+		default:
+			retval = -ENOTTY;
 		}
 
 done:
-	mutex_unlock (&usblp->mut);
+	mutex_unlock(&usblp->mut);
 	return retval;
 }
 
@@ -840,7 +839,7 @@ static ssize_t usblp_read(struct file *file, char __user *buffer, size_t len, lo
 	}
 
 done:
-	mutex_unlock (&usblp->mut);
+	mutex_unlock(&usblp->mut);
 	return count;
 }
 
@@ -1023,7 +1022,7 @@ raise_urb:
  * while you are sending print data, and you don't try to query the
  * printer status every couple of milliseconds, you will probably be OK.
  */
-static unsigned int usblp_quirks (__u16 vendor, __u16 product)
+static unsigned int usblp_quirks(__u16 vendor, __u16 product)
 {
 	int i;
 
@@ -1031,7 +1030,7 @@ static unsigned int usblp_quirks (__u16 vendor, __u16 product)
 		if (vendor == quirk_printers[i].vendorId &&
 		    product == quirk_printers[i].productId)
 			return quirk_printers[i].quirks;
- 	}
+	}
 	return 0;
 }
 
@@ -1061,7 +1060,7 @@ static struct usb_class_driver usblp_class = {
 static ssize_t usblp_show_ieee1284_id(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
-	struct usblp *usblp = usb_get_intfdata (intf);
+	struct usblp *usblp = usb_get_intfdata(intf);
 
 	if (usblp->device_id_string[0] == 0 &&
 	    usblp->device_id_string[1] == 0)
@@ -1075,7 +1074,7 @@ static DEVICE_ATTR(ieee1284_id, S_IRUGO, usblp_show_ieee1284_id, NULL);
 static int usblp_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
-	struct usb_device *dev = interface_to_usbdev (intf);
+	struct usb_device *dev = interface_to_usbdev(intf);
 	struct usblp *usblp;
 	int protocol;
 	int retval;
@@ -1089,7 +1088,7 @@ static int usblp_probe(struct usb_interface *intf,
 	}
 	usblp->dev = dev;
 	mutex_init(&usblp->wmut);
-	mutex_init (&usblp->mut);
+	mutex_init(&usblp->mut);
 	spin_lock_init(&usblp->lock);
 	init_waitqueue_head(&usblp->rwait);
 	init_waitqueue_head(&usblp->wwait);
@@ -1153,7 +1152,7 @@ static int usblp_probe(struct usb_interface *intf,
 	usblp_check_status(usblp, 0);
 #endif
 
-	usb_set_intfdata (intf, usblp);
+	usb_set_intfdata(intf, usblp);
 
 	usblp->present = 1;
 
@@ -1177,7 +1176,7 @@ static int usblp_probe(struct usb_interface *intf,
 	return 0;
 
 abort_intfdata:
-	usb_set_intfdata (intf, NULL);
+	usb_set_intfdata(intf, NULL);
 	device_remove_file(&intf->dev, &dev_attr_ieee1284_id);
 abort:
 	kfree(usblp->readbuf);
@@ -1340,35 +1339,35 @@ static int usblp_cache_device_id_string(struct usblp *usblp)
 
 static void usblp_disconnect(struct usb_interface *intf)
 {
-	struct usblp *usblp = usb_get_intfdata (intf);
+	struct usblp *usblp = usb_get_intfdata(intf);
 
 	usb_deregister_dev(intf, &usblp_class);
 
 	if (!usblp || !usblp->dev) {
 		dev_err(&intf->dev, "bogus disconnect\n");
-		BUG ();
+		BUG();
 	}
 
 	device_remove_file(&intf->dev, &dev_attr_ieee1284_id);
 
-	mutex_lock (&usblp_mutex);
-	mutex_lock (&usblp->mut);
+	mutex_lock(&usblp_mutex);
+	mutex_lock(&usblp->mut);
 	usblp->present = 0;
 	wake_up(&usblp->wwait);
 	wake_up(&usblp->rwait);
-	usb_set_intfdata (intf, NULL);
+	usb_set_intfdata(intf, NULL);
 
 	usblp_unlink_urbs(usblp);
-	mutex_unlock (&usblp->mut);
+	mutex_unlock(&usblp->mut);
 
 	if (!usblp->used)
-		usblp_cleanup (usblp);
-	mutex_unlock (&usblp_mutex);
+		usblp_cleanup(usblp);
+	mutex_unlock(&usblp_mutex);
 }
 
 static int usblp_suspend(struct usb_interface *intf, pm_message_t message)
 {
-	struct usblp *usblp = usb_get_intfdata (intf);
+	struct usblp *usblp = usb_get_intfdata(intf);
 
 	usblp_unlink_urbs(usblp);
 #if 0 /* XXX Do we want this? What if someone is reading, should we fail? */
@@ -1382,10 +1381,10 @@ static int usblp_suspend(struct usb_interface *intf, pm_message_t message)
 
 static int usblp_resume(struct usb_interface *intf)
 {
-	struct usblp *usblp = usb_get_intfdata (intf);
+	struct usblp *usblp = usb_get_intfdata(intf);
 	int r;
 
-	r = handle_bidir (usblp);
+	r = handle_bidir(usblp);
 
 	return r;
 }
@@ -1401,7 +1400,7 @@ static const struct usb_device_id usblp_ids[] = {
 	{ }						/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, usblp_ids);
+MODULE_DEVICE_TABLE(usb, usblp_ids);
 
 static struct usb_driver usblp_driver = {
 	.name =		"usblp",
@@ -1426,8 +1425,8 @@ static void __exit usblp_exit(void)
 module_init(usblp_init);
 module_exit(usblp_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 module_param(proto_bias, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(proto_bias, "Favourite protocol number");
 MODULE_LICENSE("GPL");
-- 
1.7.1
