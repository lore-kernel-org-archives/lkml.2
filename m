Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab2KJJtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 04:49:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46967 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2KJJti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 04:49:38 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] staging: usbip: make the code consistent using the variable name 'vhci' instead of 'dum'.
Date: Sat, 10 Nov 2012 17:53:30 +0800
Message-Id: <1352541210-12508-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/staging/usbip/vhci_hcd.c |   80 +++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 620d1be..6771668 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -244,7 +244,7 @@ static inline void hub_descriptor(struct usb_hub_descriptor *desc)
 static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			    u16 wIndex, char *buf, u16 wLength)
 {
-	struct vhci_hcd	*dum;
+	struct vhci_hcd	*vhci;
 	int             retval = 0;
 	unsigned long   flags;
 	int		rhport;
@@ -264,13 +264,13 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		pr_err("invalid port number %d\n", wIndex);
 	rhport = ((__u8)(wIndex & 0x00ff)) - 1;
 
-	dum = hcd_to_vhci(hcd);
+	vhci = hcd_to_vhci(hcd);
 
-	spin_lock_irqsave(&dum->lock, flags);
+	spin_lock_irqsave(&vhci->lock, flags);
 
 	/* store old status and compare now and old later */
 	if (usbip_dbg_flag_vhci_rh) {
-		memcpy(prev_port_status, dum->port_status,
+		memcpy(prev_port_status, vhci->port_status,
 			sizeof(prev_port_status));
 	}
 
@@ -281,31 +281,31 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	case ClearPortFeature:
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			if (dum->port_status[rhport] & USB_PORT_STAT_SUSPEND) {
+			if (vhci->port_status[rhport] & USB_PORT_STAT_SUSPEND) {
 				/* 20msec signaling */
-				dum->resuming = 1;
-				dum->re_timeout =
+				vhci->resuming = 1;
+				vhci->re_timeout =
 					jiffies + msecs_to_jiffies(20);
 			}
 			break;
 		case USB_PORT_FEAT_POWER:
 			usbip_dbg_vhci_rh(" ClearPortFeature: "
 					  "USB_PORT_FEAT_POWER\n");
-			dum->port_status[rhport] = 0;
-			/* dum->address = 0; */
-			/* dum->hdev = 0; */
-			dum->resuming = 0;
+			vhci->port_status[rhport] = 0;
+			/* vhci->address = 0; */
+			/* vhci->hdev = 0; */
+			vhci->resuming = 0;
 			break;
 		case USB_PORT_FEAT_C_RESET:
 			usbip_dbg_vhci_rh(" ClearPortFeature: "
 					  "USB_PORT_FEAT_C_RESET\n");
-			switch (dum->vdev[rhport].speed) {
+			switch (vhci->vdev[rhport].speed) {
 			case USB_SPEED_HIGH:
-				dum->port_status[rhport] |=
+				vhci->port_status[rhport] |=
 					USB_PORT_STAT_HIGH_SPEED;
 				break;
 			case USB_SPEED_LOW:
-				dum->port_status[rhport] |=
+				vhci->port_status[rhport] |=
 					USB_PORT_STAT_LOW_SPEED;
 				break;
 			default:
@@ -314,7 +314,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		default:
 			usbip_dbg_vhci_rh(" ClearPortFeature: default %x\n",
 					  wValue);
-			dum->port_status[rhport] &= ~(1 << wValue);
+			vhci->port_status[rhport] &= ~(1 << wValue);
 			break;
 		}
 		break;
@@ -338,40 +338,40 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		/* whoever resets or resumes must GetPortStatus to
 		 * complete it!!
 		 *                                   */
-		if (dum->resuming && time_after(jiffies, dum->re_timeout)) {
-			dum->port_status[rhport] |=
+		if (vhci->resuming && time_after(jiffies, vhci->re_timeout)) {
+			vhci->port_status[rhport] |=
 				(1 << USB_PORT_FEAT_C_SUSPEND);
-			dum->port_status[rhport] &=
+			vhci->port_status[rhport] &=
 				~(1 << USB_PORT_FEAT_SUSPEND);
-			dum->resuming = 0;
-			dum->re_timeout = 0;
-			/* if (dum->driver && dum->driver->resume) {
-			 *	spin_unlock (&dum->lock);
-			 *	dum->driver->resume (&dum->gadget);
-			 *	spin_lock (&dum->lock);
+			vhci->resuming = 0;
+			vhci->re_timeout = 0;
+			/* if (vhci->driver && vhci->driver->resume) {
+			 *	spin_unlock (&vhci->lock);
+			 *	vhci->driver->resume (&vhci->gadget);
+			 *	spin_lock (&vhci->lock);
 			 * } */
 		}
 
-		if ((dum->port_status[rhport] & (1 << USB_PORT_FEAT_RESET)) !=
-		    0 && time_after(jiffies, dum->re_timeout)) {
-			dum->port_status[rhport] |=
+		if ((vhci->port_status[rhport] & (1 << USB_PORT_FEAT_RESET)) !=
+		    0 && time_after(jiffies, vhci->re_timeout)) {
+			vhci->port_status[rhport] |=
 				(1 << USB_PORT_FEAT_C_RESET);
-			dum->port_status[rhport] &=
+			vhci->port_status[rhport] &=
 				~(1 << USB_PORT_FEAT_RESET);
-			dum->re_timeout = 0;
+			vhci->re_timeout = 0;
 
-			if (dum->vdev[rhport].ud.status ==
+			if (vhci->vdev[rhport].ud.status ==
 			    VDEV_ST_NOTASSIGNED) {
 				usbip_dbg_vhci_rh(" enable rhport %d "
 						  "(status %u)\n",
 						  rhport,
-						  dum->vdev[rhport].ud.status);
-				dum->port_status[rhport] |=
+						  vhci->vdev[rhport].ud.status);
+				vhci->port_status[rhport] |=
 					USB_PORT_STAT_ENABLE;
 			}
 		}
-		((u16 *) buf)[0] = cpu_to_le16(dum->port_status[rhport]);
-		((u16 *) buf)[1] = cpu_to_le16(dum->port_status[rhport] >> 16);
+		((u16 *) buf)[0] = cpu_to_le16(vhci->port_status[rhport]);
+		((u16 *) buf)[1] = cpu_to_le16(vhci->port_status[rhport] >> 16);
 
 		usbip_dbg_vhci_rh(" GetPortStatus bye %x %x\n", ((u16 *)buf)[0],
 				  ((u16 *)buf)[1]);
@@ -390,21 +390,21 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			usbip_dbg_vhci_rh(" SetPortFeature: "
 					  "USB_PORT_FEAT_RESET\n");
 			/* if it's already running, disconnect first */
-			if (dum->port_status[rhport] & USB_PORT_STAT_ENABLE) {
-				dum->port_status[rhport] &=
+			if (vhci->port_status[rhport] & USB_PORT_STAT_ENABLE) {
+				vhci->port_status[rhport] &=
 					~(USB_PORT_STAT_ENABLE |
 					  USB_PORT_STAT_LOW_SPEED |
 					  USB_PORT_STAT_HIGH_SPEED);
 				/* FIXME test that code path! */
 			}
 			/* 50msec reset signaling */
-			dum->re_timeout = jiffies + msecs_to_jiffies(50);
+			vhci->re_timeout = jiffies + msecs_to_jiffies(50);
 
 			/* FALLTHROUGH */
 		default:
 			usbip_dbg_vhci_rh(" SetPortFeature: default %d\n",
 					  wValue);
-			dum->port_status[rhport] |= (1 << wValue);
+			vhci->port_status[rhport] |= (1 << wValue);
 			break;
 		}
 		break;
@@ -424,12 +424,12 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		/* Only dump valid port status */
 		if (rhport >= 0) {
 			dump_port_status_diff(prev_port_status[rhport],
-					      dum->port_status[rhport]);
+					      vhci->port_status[rhport]);
 		}
 	}
 	usbip_dbg_vhci_rh(" bye\n");
 
-	spin_unlock_irqrestore(&dum->lock, flags);
+	spin_unlock_irqrestore(&vhci->lock, flags);
 
 	return retval;
 }
-- 
1.7.1

