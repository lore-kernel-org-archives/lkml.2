Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1EFKyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:35 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:45008
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756256Ab1EFKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:32 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/16] staging: usbip: vhci_hcd.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:50 -0700
Message-Id: <6f8eaf3d60b36864ea54be6342f78a90df9392a6.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix alignment for consistency and remove extraneous lines.
Move MODULE_ macros to the end of file.
Make bit_desc[] an array of const pointers.
Add KERN_ level to a couple of printks.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/vhci_hcd.c |  187 +++++++++++++++----------------------
 1 files changed, 76 insertions(+), 111 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 4f4f133..86d85cc 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -27,11 +27,6 @@
 #define DRIVER_AUTHOR "Takahiro Hirofuchi"
 #define DRIVER_DESC "Virtual Host Controller Interface Driver for USB/IP"
 #define DRIVER_LICENCE "GPL"
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE(DRIVER_LICENCE);
-
-
 
 /*
  * TODO
@@ -43,15 +38,13 @@ MODULE_LICENSE(DRIVER_LICENCE);
  *	- clean up everything
  */
 
-
 /* See usb gadget dummy hcd */
 
-
 static int vhci_hub_status(struct usb_hcd *hcd, char *buff);
 static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
-		u16 wIndex, char *buff, u16 wLength);
+			    u16 wIndex, char *buff, u16 wLength);
 static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
-							gfp_t mem_flags);
+			    gfp_t mem_flags);
 static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status);
 static int vhci_start(struct usb_hcd *vhci_hcd);
 static void vhci_stop(struct usb_hcd *hcd);
@@ -62,42 +55,41 @@ static const char driver_desc[] = "USB/IP Virtual Host Controller";
 
 struct vhci_hcd *the_controller;
 
-static const char *bit_desc[] = {
+static const char * const bit_desc[] = {
 	"CONNECTION",		/*0*/
 	"ENABLE",		/*1*/
 	"SUSPEND",		/*2*/
 	"OVER_CURRENT",		/*3*/
 	"RESET",		/*4*/
-	"R5",		/*5*/
-	"R6",		/*6*/
-	"R7",		/*7*/
+	"R5",			/*5*/
+	"R6",			/*6*/
+	"R7",			/*7*/
 	"POWER",		/*8*/
 	"LOWSPEED",		/*9*/
 	"HIGHSPEED",		/*10*/
 	"PORT_TEST",		/*11*/
 	"INDICATOR",		/*12*/
-	"R13",		/*13*/
-	"R14",		/*14*/
-	"R15",		/*15*/
+	"R13",			/*13*/
+	"R14",			/*14*/
+	"R15",			/*15*/
 	"C_CONNECTION",		/*16*/
 	"C_ENABLE",		/*17*/
 	"C_SUSPEND",		/*18*/
 	"C_OVER_CURRENT",	/*19*/
 	"C_RESET",		/*20*/
-	"R21",		/*21*/
-	"R22",		/*22*/
-	"R23",		/*23*/
-	"R24",		/*24*/
-	"R25",		/*25*/
-	"R26",		/*26*/
-	"R27",		/*27*/
-	"R28",		/*28*/
-	"R29",		/*29*/
-	"R30",		/*30*/
-	"R31",		/*31*/
+	"R21",			/*21*/
+	"R22",			/*22*/
+	"R23",			/*23*/
+	"R24",			/*24*/
+	"R25",			/*25*/
+	"R26",			/*26*/
+	"R27",			/*27*/
+	"R28",			/*28*/
+	"R29",			/*29*/
+	"R30",			/*30*/
+	"R31",			/*31*/
 };
 
-
 static void dump_port_status(u32 status)
 {
 	int i = 0;
@@ -105,14 +97,11 @@ static void dump_port_status(u32 status)
 	printk(KERN_DEBUG "status %08x:", status);
 	for (i = 0; i < 32; i++) {
 		if (status & (1 << i))
-			printk(" %s", bit_desc[i]);
+			printk(KERN_DEBUG " %s", bit_desc[i]);
 	}
-
-	printk("\n");
+	printk(KERN_DEBUG "\n");
 }
 
-
-
 void rh_port_connect(int rhport, enum usb_device_speed speed)
 {
 	unsigned long	flags;
@@ -156,26 +145,22 @@ void rh_port_disconnect(int rhport)
 	the_controller->port_status[rhport] |=
 					(1 << USB_PORT_FEAT_C_CONNECTION);
 
-
 	/* not yet complete the disconnection
 	 * spin_lock(&vdev->ud.lock);
 	 * vdev->ud.status = VHC_ST_DISCONNECT;
 	 * spin_unlock(&vdev->ud.lock); */
 
 	spin_unlock_irqrestore(&the_controller->lock, flags);
-
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
-
-
 /*----------------------------------------------------------------------*/
 
-#define PORT_C_MASK \
-	((USB_PORT_STAT_C_CONNECTION \
-	  | USB_PORT_STAT_C_ENABLE \
-	  | USB_PORT_STAT_C_SUSPEND \
-	  | USB_PORT_STAT_C_OVERCURRENT \
+#define PORT_C_MASK				\
+	((USB_PORT_STAT_C_CONNECTION		\
+	  | USB_PORT_STAT_C_ENABLE		\
+	  | USB_PORT_STAT_C_SUSPEND		\
+	  | USB_PORT_STAT_C_OVERCURRENT		\
 	  | USB_PORT_STAT_C_RESET) << 16)
 
 /*
@@ -210,7 +195,6 @@ static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
 	int		rhport;
 	int		changed = 0;
 
-
 	*event_bits = 0;
 
 	vhci = hcd_to_vhci(hcd);
@@ -278,10 +262,10 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	 * wIndex shows the port number and begins from 1.
 	 */
 	usbip_dbg_vhci_rh("typeReq %x wValue %x wIndex %x\n", typeReq, wValue,
-								wIndex);
+			  wIndex);
 	if (wIndex > VHCI_NPORTS)
 		printk(KERN_ERR "%s: invalid port number %d\n", __func__,
-								wIndex);
+		       wIndex);
 	rhport = ((__u8)(wIndex & 0x00ff)) - 1;
 
 	dum = hcd_to_vhci(hcd);
@@ -311,7 +295,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			break;
 		case USB_PORT_FEAT_POWER:
 			usbip_dbg_vhci_rh(" ClearPortFeature: "
-						"USB_PORT_FEAT_POWER\n");
+					  "USB_PORT_FEAT_POWER\n");
 			dum->port_status[rhport] = 0;
 			/* dum->address = 0; */
 			/* dum->hdev = 0; */
@@ -319,22 +303,22 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			break;
 		case USB_PORT_FEAT_C_RESET:
 			usbip_dbg_vhci_rh(" ClearPortFeature: "
-						"USB_PORT_FEAT_C_RESET\n");
+					  "USB_PORT_FEAT_C_RESET\n");
 			switch (dum->vdev[rhport].speed) {
 			case USB_SPEED_HIGH:
 				dum->port_status[rhport] |=
-						USB_PORT_STAT_HIGH_SPEED;
+					USB_PORT_STAT_HIGH_SPEED;
 				break;
 			case USB_SPEED_LOW:
 				dum->port_status[rhport] |=
-						USB_PORT_STAT_LOW_SPEED;
+					USB_PORT_STAT_LOW_SPEED;
 				break;
 			default:
 				break;
 			}
 		default:
 			usbip_dbg_vhci_rh(" ClearPortFeature: default %x\n",
-								wValue);
+					  wValue);
 			dum->port_status[rhport] &= ~(1 << wValue);
 		}
 		break;
@@ -375,39 +359,38 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		}
 
 		if ((dum->port_status[rhport] & (1 << USB_PORT_FEAT_RESET)) !=
-				0 && time_after(jiffies, dum->re_timeout)) {
+		    0 && time_after(jiffies, dum->re_timeout)) {
 			dum->port_status[rhport] |=
-						(1 << USB_PORT_FEAT_C_RESET);
+				(1 << USB_PORT_FEAT_C_RESET);
 			dum->port_status[rhport] &=
-						~(1 << USB_PORT_FEAT_RESET);
+				~(1 << USB_PORT_FEAT_RESET);
 			dum->re_timeout = 0;
 
 			if (dum->vdev[rhport].ud.status ==
-							VDEV_ST_NOTASSIGNED) {
+			    VDEV_ST_NOTASSIGNED) {
 				usbip_dbg_vhci_rh(" enable rhport %d "
-						"(status %u)\n",
-						rhport,
-						dum->vdev[rhport].ud.status);
+						  "(status %u)\n",
+						  rhport,
+						  dum->vdev[rhport].ud.status);
 				dum->port_status[rhport] |=
-							USB_PORT_STAT_ENABLE;
+					USB_PORT_STAT_ENABLE;
 			}
 #if 0
 			if (dum->driver) {
-
 				dum->port_status[rhport] |=
-							USB_PORT_STAT_ENABLE;
+					USB_PORT_STAT_ENABLE;
 				/* give it the best speed we agree on */
 				dum->gadget.speed = dum->driver->speed;
 				dum->gadget.ep0->maxpacket = 64;
 				switch (dum->gadget.speed) {
 				case USB_SPEED_HIGH:
 					dum->port_status[rhport] |=
-					USB_PORT_STAT_HIGH_SPEED;
+						USB_PORT_STAT_HIGH_SPEED;
 					break;
 				case USB_SPEED_LOW:
 					dum->gadget.ep0->maxpacket = 8;
 					dum->port_status[rhport] |=
-					USB_PORT_STAT_LOW_SPEED;
+						USB_PORT_STAT_LOW_SPEED;
 					break;
 				default:
 					dum->gadget.speed = USB_SPEED_FULL;
@@ -415,14 +398,12 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				}
 			}
 #endif
-
 		}
 		((u16 *) buf)[0] = cpu_to_le16(dum->port_status[rhport]);
-		((u16 *) buf)[1] =
-				cpu_to_le16(dum->port_status[rhport] >> 16);
+		((u16 *) buf)[1] = cpu_to_le16(dum->port_status[rhport] >> 16);
 
 		usbip_dbg_vhci_rh(" GetPortStatus bye %x %x\n", ((u16 *)buf)[0],
-							((u16 *)buf)[1]);
+				  ((u16 *)buf)[1]);
 		break;
 	case SetHubFeature:
 		usbip_dbg_vhci_rh(" SetHubFeature\n");
@@ -432,11 +413,11 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
 			usbip_dbg_vhci_rh(" SetPortFeature: "
-					"USB_PORT_FEAT_SUSPEND\n");
+					  "USB_PORT_FEAT_SUSPEND\n");
 			printk(KERN_ERR "%s: not yet\n", __func__);
 #if 0
 			dum->port_status[rhport] |=
-						(1 << USB_PORT_FEAT_SUSPEND);
+				(1 << USB_PORT_FEAT_SUSPEND);
 			if (dum->driver->suspend) {
 				spin_unlock(&dum->lock);
 				dum->driver->suspend(&dum->gadget);
@@ -446,13 +427,13 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			break;
 		case USB_PORT_FEAT_RESET:
 			usbip_dbg_vhci_rh(" SetPortFeature: "
-						"USB_PORT_FEAT_RESET\n");
+					  "USB_PORT_FEAT_RESET\n");
 			/* if it's already running, disconnect first */
 			if (dum->port_status[rhport] & USB_PORT_STAT_ENABLE) {
 				dum->port_status[rhport] &=
-						~(USB_PORT_STAT_ENABLE |
-						  USB_PORT_STAT_LOW_SPEED |
-						  USB_PORT_STAT_HIGH_SPEED);
+					~(USB_PORT_STAT_ENABLE |
+					  USB_PORT_STAT_LOW_SPEED |
+					  USB_PORT_STAT_HIGH_SPEED);
 #if 0
 				if (dum->driver) {
 					dev_dbg(hardware, "disconnect\n");
@@ -468,7 +449,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			/* FALLTHROUGH */
 		default:
 			usbip_dbg_vhci_rh(" SetPortFeature: default %d\n",
-								wValue);
+					  wValue);
 			dum->port_status[rhport] |= (1 << wValue);
 		}
 		break;
@@ -545,7 +526,6 @@ static void vhci_tx_urb(struct urb *urb)
 
 	urb->hcpriv = (void *) priv;
 
-
 	list_add_tail(&priv->list, &vdev->priv_tx);
 
 	wake_up(&vdev->waitq_tx);
@@ -561,7 +541,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	struct vhci_device *vdev;
 
 	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
-		    hcd, urb, mem_flags);
+			  hcd, urb, mem_flags);
 
 	/* patch to usb_sg_init() is in 2.5.60 */
 	BUG_ON(!urb->transfer_buffer && urb->transfer_buffer_length);
@@ -578,7 +558,8 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 
 	/* refuse enqueue for dead connection */
 	spin_lock(&vdev->ud.lock);
-	if (vdev->ud.status == VDEV_ST_NULL || vdev->ud.status == VDEV_ST_ERROR) {
+	if (vdev->ud.status == VDEV_ST_NULL ||
+	    vdev->ud.status == VDEV_ST_ERROR) {
 		usbip_uerr("enqueue for inactive port %d\n", vdev->rhport);
 		spin_unlock(&vdev->ud.lock);
 		spin_unlock_irqrestore(&the_controller->lock, flags);
@@ -599,11 +580,10 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	 *  2. Set_Address request to DevAddr(0) EndPoint(0)
 	 *
 	 */
-
 	if (usb_pipedevice(urb->pipe) == 0) {
 		__u8 type = usb_pipetype(urb->pipe);
 		struct usb_ctrlrequest *ctrlreq =
-				(struct usb_ctrlrequest *) urb->setup_packet;
+			(struct usb_ctrlrequest *) urb->setup_packet;
 
 		if (type != PIPE_CONTROL || !ctrlreq) {
 			dev_err(dev, "invalid request to devnum 0\n");
@@ -636,8 +616,8 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 		case USB_REQ_GET_DESCRIPTOR:
 			if (ctrlreq->wValue == (USB_DT_DEVICE << 8))
 				usbip_dbg_vhci_hc("Not yet?: "
-						"Get_Descriptor to device 0 "
-						"(get max pipe size)\n");
+						  "Get_Descriptor to device 0 "
+						  "(get max pipe size)\n");
 
 			if (vdev->udev)
 				usb_put_dev(vdev->udev);
@@ -657,7 +637,6 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 
 out:
 	vhci_tx_urb(urb);
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	return 0;
@@ -726,7 +705,6 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 
 	usbip_uinfo("vhci_hcd: dequeue a urb %p\n", urb);
 
-
 	spin_lock_irqsave(&the_controller->lock, flags);
 
 	priv = urb->hcpriv;
@@ -756,7 +734,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		spin_lock_irqsave(&vdev->priv_lock, flags2);
 
 		usbip_uinfo("vhci_hcd: device %p seems to be disconnected\n",
-									vdev);
+			    vdev);
 		list_del(&priv->list);
 		kfree(priv);
 		urb->hcpriv = NULL;
@@ -769,13 +747,13 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		 * Otherwise, we give back it here.
 		 */
 		usbip_uinfo("vhci_hcd: vhci_urb_dequeue() gives back urb %p\n",
-									urb);
+			    urb);
 
 		usb_hcd_unlink_urb_from_ep(hcd, urb);
 
 		spin_unlock_irqrestore(&the_controller->lock, flags);
 		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-								urb->status);
+				     urb->status);
 		spin_lock_irqsave(&the_controller->lock, flags);
 
 	} else {
@@ -802,7 +780,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		unlink->unlink_seqnum = priv->seqnum;
 
 		usbip_uinfo("vhci_hcd: device %p seems to be still connected\n",
-									vdev);
+			    vdev);
 
 		/* send cmd_unlink and try to cancel the pending URB in the
 		 * peer */
@@ -838,8 +816,8 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 
 		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
 		if (!urb) {
-			usbip_uinfo("the urb (seqnum %lu) was already given back\n",
-							unlink->unlink_seqnum);
+			usbip_uinfo("the urb (seqnum %lu) was already given "
+				    "back\n", unlink->unlink_seqnum);
 			list_del(&unlink->list);
 			kfree(unlink);
 			continue;
@@ -851,7 +829,8 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
 		spin_unlock(&the_controller->lock);
 
-		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
+		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
+				     urb->status);
 
 		list_del(&unlink->list);
 		kfree(unlink);
@@ -932,7 +911,6 @@ static void vhci_device_reset(struct usbip_device *ud)
 	vdev->udev = NULL;
 
 	ud->tcp_socket = NULL;
-
 	ud->status = VDEV_ST_NULL;
 
 	spin_unlock(&ud->lock);
@@ -941,9 +919,7 @@ static void vhci_device_reset(struct usbip_device *ud)
 static void vhci_device_unusable(struct usbip_device *ud)
 {
 	spin_lock(&ud->lock);
-
 	ud->status = VDEV_ST_ERROR;
-
 	spin_unlock(&ud->lock);
 }
 
@@ -983,7 +959,6 @@ static int vhci_start(struct usb_hcd *hcd)
 
 	usbip_dbg_vhci_hc("enter vhci_start\n");
 
-
 	/* initialize private data of usb_hcd */
 
 	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
@@ -995,13 +970,10 @@ static int vhci_start(struct usb_hcd *hcd)
 	atomic_set(&vhci->seqnum, 0);
 	spin_lock_init(&vhci->lock);
 
-
-
 	hcd->power_budget = 0; /* no limit */
 	hcd->state  = HC_STATE_RUNNING;
 	hcd->uses_new_polling = 1;
 
-
 	/* vhci_hcd is now ready to be controlled through sysfs */
 	err = sysfs_create_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
 	if (err) {
@@ -1019,7 +991,6 @@ static void vhci_stop(struct usb_hcd *hcd)
 
 	usbip_dbg_vhci_hc("stop VHCI controller\n");
 
-
 	/* 1. remove the userland interface of vhci_hcd */
 	sysfs_remove_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
 
@@ -1031,7 +1002,6 @@ static void vhci_stop(struct usb_hcd *hcd)
 		usbip_stop_eh(&vdev->ud);
 	}
 
-
 	usbip_uinfo("vhci_stop done\n");
 }
 
@@ -1043,7 +1013,6 @@ static int vhci_get_frame_number(struct usb_hcd *hcd)
 	return 0;
 }
 
-
 #ifdef CONFIG_PM
 
 /* FIXME: suspend/resume */
@@ -1091,8 +1060,6 @@ static int vhci_bus_resume(struct usb_hcd *hcd)
 #define vhci_bus_resume       NULL
 #endif
 
-
-
 static struct hc_driver vhci_hc_driver = {
 	.description	= driver_name,
 	.product_desc	= driver_desc,
@@ -1155,12 +1122,10 @@ static int vhci_hcd_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-
 	usbip_dbg_vhci_hc("bye\n");
 	return 0;
 }
 
-
 static int vhci_hcd_remove(struct platform_device *pdev)
 {
 	struct usb_hcd	*hcd;
@@ -1178,12 +1143,9 @@ static int vhci_hcd_remove(struct platform_device *pdev)
 	usb_put_hcd(hcd);
 	the_controller = NULL;
 
-
 	return 0;
 }
 
-
-
 #ifdef CONFIG_PM
 
 /* what should happen for USB/IP under suspend/resume? */
@@ -1202,14 +1164,14 @@ static int vhci_hcd_suspend(struct platform_device *pdev, pm_message_t state)
 
 	for (rhport = 0; rhport < VHCI_NPORTS; rhport++)
 		if (the_controller->port_status[rhport] &
-						USB_PORT_STAT_CONNECTION)
+		    USB_PORT_STAT_CONNECTION)
 			connected += 1;
 
 	spin_unlock(&the_controller->lock);
 
 	if (connected > 0) {
 		usbip_uinfo("We have %d active connection%s. Do not suspend.\n",
-				connected, (connected == 1 ? "" : "s"));
+			    connected, (connected == 1 ? "" : "s"));
 		ret =  -EBUSY;
 	} else {
 		usbip_uinfo("suspend vhci_hcd");
@@ -1239,7 +1201,6 @@ static int vhci_hcd_resume(struct platform_device *pdev)
 
 #endif
 
-
 static struct platform_driver vhci_driver = {
 	.probe	= vhci_hcd_probe,
 	.remove	= __devexit_p(vhci_hcd_remove),
@@ -1298,12 +1259,10 @@ static int __init vhci_init(void)
 	/* error occurred */
 err_platform_device_register:
 	platform_driver_unregister(&vhci_driver);
-
 err_driver_register:
 	usbip_dbg_vhci_hc("bye\n");
 	return ret;
 }
-module_init(vhci_init);
 
 static void __exit vhci_cleanup(void)
 {
@@ -1314,4 +1273,10 @@ static void __exit vhci_cleanup(void)
 
 	usbip_dbg_vhci_hc("bye\n");
 }
+
+module_init(vhci_init);
 module_exit(vhci_cleanup);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE(DRIVER_LICENCE);
-- 
1.7.5.1

