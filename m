Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1EFK5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:57:48 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:39603 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296Ab1EFKy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:26 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 03/16] staging: usbip: stub_rx.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:43 -0700
Message-Id: <c87d8af709e5d944af453af821f2d230545e04ac.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix alignment for consistency and remove extraneous lines.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub_rx.c |   50 ++++++++++++++++----------------------
 1 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 51fbd09..ac4dd4d 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -24,7 +24,6 @@
 #include "stub.h"
 #include <linux/usb/hcd.h>
 
-
 static int is_clear_halt_cmd(struct urb *urb)
 {
 	struct usb_ctrlrequest *req;
@@ -43,7 +42,7 @@ static int is_set_interface_cmd(struct urb *urb)
 	req = (struct usb_ctrlrequest *) urb->setup_packet;
 
 	return (req->bRequest == USB_REQ_SET_INTERFACE) &&
-		   (req->bRequestType == USB_RECIP_INTERFACE);
+		(req->bRequestType == USB_RECIP_INTERFACE);
 }
 
 static int is_set_configuration_cmd(struct urb *urb)
@@ -53,7 +52,7 @@ static int is_set_configuration_cmd(struct urb *urb)
 	req = (struct usb_ctrlrequest *) urb->setup_packet;
 
 	return (req->bRequest == USB_REQ_SET_CONFIGURATION) &&
-		   (req->bRequestType == USB_RECIP_DEVICE);
+		(req->bRequestType == USB_RECIP_DEVICE);
 }
 
 static int is_reset_device_cmd(struct urb *urb)
@@ -67,8 +66,8 @@ static int is_reset_device_cmd(struct urb *urb)
 	index = le16_to_cpu(req->wIndex);
 
 	if ((req->bRequest == USB_REQ_SET_FEATURE) &&
-			(req->bRequestType == USB_RT_PORT) &&
-			(value == USB_PORT_FEAT_RESET)) {
+	    (req->bRequestType == USB_RT_PORT) &&
+	    (value == USB_PORT_FEAT_RESET)) {
 		usbip_dbg_stub_rx("reset_device_cmd, port %u\n", index);
 		return 1;
 	} else
@@ -103,10 +102,10 @@ static int tweak_clear_halt_cmd(struct urb *urb)
 	ret = usb_clear_halt(urb->dev, target_pipe);
 	if (ret < 0)
 		usbip_uinfo("clear_halt error: devnum %d endp %d, %d\n",
-					urb->dev->devnum, target_endp, ret);
+			    urb->dev->devnum, target_endp, ret);
 	else
 		usbip_uinfo("clear_halt done: devnum %d endp %d\n",
-					urb->dev->devnum, target_endp);
+			    urb->dev->devnum, target_endp);
 
 	return ret;
 }
@@ -122,17 +121,16 @@ static int tweak_set_interface_cmd(struct urb *urb)
 	alternate = le16_to_cpu(req->wValue);
 	interface = le16_to_cpu(req->wIndex);
 
-	usbip_dbg_stub_rx("set_interface: inf %u alt %u\n", interface,
-								alternate);
+	usbip_dbg_stub_rx("set_interface: inf %u alt %u\n",
+			  interface, alternate);
 
 	ret = usb_set_interface(urb->dev, interface, alternate);
 	if (ret < 0)
 		usbip_uinfo("set_interface error: inf %u alt %u, %d\n",
-					interface, alternate, ret);
+			    interface, alternate, ret);
 	else
 		usbip_uinfo("set_interface done: inf %u alt %u\n",
-							interface,
-							alternate);
+			    interface, alternate);
 
 	return ret;
 }
@@ -161,8 +159,8 @@ static int tweak_set_configuration_cmd(struct urb *urb)
 	 * A user may need to set a special configuration value before
 	 * exporting the device.
 	 */
-	usbip_uinfo("set_configuration (%d) to %s\n", config,
-						dev_name(&urb->dev->dev));
+	usbip_uinfo("set_configuration %d to %s\n",
+		    config, dev_name(&urb->dev->dev));
 	usbip_uinfo("but, skip!\n");
 
 	return 0;
@@ -228,13 +226,12 @@ static void tweak_special_requests(struct urb *urb)
  * See also comments about unlinking strategy in vhci_hcd.c.
  */
 static int stub_recv_cmd_unlink(struct stub_device *sdev,
-						struct usbip_header *pdu)
+				struct usbip_header *pdu)
 {
 	unsigned long flags;
 
 	struct stub_priv *priv;
 
-
 	spin_lock_irqsave(&sdev->priv_lock, flags);
 
 	list_for_each_entry(priv, &sdev->priv_init, list) {
@@ -289,7 +286,7 @@ static int stub_recv_cmd_unlink(struct stub_device *sdev,
 	}
 
 	usbip_dbg_stub_rx("seqnum %d is not pending\n",
-						pdu->u.cmd_unlink.seqnum);
+			  pdu->u.cmd_unlink.seqnum);
 
 	/*
 	 * The urb of the unlink target is not found in priv_init queue. It was
@@ -301,7 +298,6 @@ static int stub_recv_cmd_unlink(struct stub_device *sdev,
 
 	spin_unlock_irqrestore(&sdev->priv_lock, flags);
 
-
 	return 0;
 }
 
@@ -370,8 +366,6 @@ static int get_pipe(struct stub_device *sdev, int epnum, int dir)
 	}
 
 	epd = &ep->desc;
-
-
 #if 0
 	/* epnum 0 is always control */
 	if (epnum == 0) {
@@ -381,7 +375,6 @@ static int get_pipe(struct stub_device *sdev, int epnum, int dir)
 			return usb_rcvctrlpipe(udev, 0);
 	}
 #endif
-
 	if (usb_endpoint_xfer_control(epd)) {
 		if (dir == USBIP_DIR_OUT)
 			return usb_sndctrlpipe(udev, epnum);
@@ -430,19 +423,19 @@ static void masking_bogus_flags(struct urb *urb)
 		return;
 
 	ep = (usb_pipein(urb->pipe) ? dev->ep_in : dev->ep_out)
-			[usb_pipeendpoint(urb->pipe)];
+		[usb_pipeendpoint(urb->pipe)];
 	if (!ep)
 		return;
 
 	xfertype = usb_endpoint_type(&ep->desc);
 	if (xfertype == USB_ENDPOINT_XFER_CONTROL) {
 		struct usb_ctrlrequest *setup =
-				(struct usb_ctrlrequest *) urb->setup_packet;
+			(struct usb_ctrlrequest *) urb->setup_packet;
 
 		if (!setup)
 			return;
 		is_out = !(setup->bRequestType & USB_DIR_IN) ||
-				!setup->wLength;
+			!setup->wLength;
 	} else {
 		is_out = usb_endpoint_dir_out(&ep->desc);
 	}
@@ -478,7 +471,6 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 	struct usb_device *udev = sdev->udev;
 	int pipe = get_pipe(sdev, pdu->base.ep, pdu->base.direction);
 
-
 	priv = stub_priv_alloc(sdev, pdu);
 	if (!priv)
 		return;
@@ -486,7 +478,7 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 	/* setup a urb */
 	if (usb_pipeisoc(pipe))
 		priv->urb = usb_alloc_urb(pdu->u.cmd_submit.number_of_packets,
-								GFP_KERNEL);
+					  GFP_KERNEL);
 	else
 		priv->urb = usb_alloc_urb(0, GFP_KERNEL);
 
@@ -500,7 +492,7 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 	if (pdu->u.cmd_submit.transfer_buffer_length > 0) {
 		priv->urb->transfer_buffer =
 			kzalloc(pdu->u.cmd_submit.transfer_buffer_length,
-								GFP_KERNEL);
+				GFP_KERNEL);
 		if (!priv->urb->transfer_buffer) {
 			dev_err(&sdev->interface->dev, "malloc x_buff\n");
 			usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
@@ -541,7 +533,7 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 
 	if (ret == 0)
 		usbip_dbg_stub_rx("submit urb ok, seqnum %u\n",
-							pdu->base.seqnum);
+				  pdu->base.seqnum);
 	else {
 		dev_err(&sdev->interface->dev, "submit_urb error, %d\n", ret);
 		usbip_dump_header(pdu);
@@ -604,7 +596,6 @@ static void stub_rx_pdu(struct usbip_device *ud)
 		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
 		return;
 	}
-
 }
 
 int stub_rx_loop(void *data)
@@ -617,5 +608,6 @@ int stub_rx_loop(void *data)
 
 		stub_rx_pdu(ud);
 	}
+
 	return 0;
 }
-- 
1.7.5.1

