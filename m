Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1EFK4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:56:12 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:46234
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254Ab1EFKyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:36 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/16] staging: usbip: vhci_rx.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:51 -0700
Message-Id: <094477ed7e0cab360d865d4ead28180f77077b1c.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix alignment for consistency and remove extraneous lines.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/vhci_rx.c |   44 +++++++++++---------------------------
 1 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index 2ffc96a..61b9fc7 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -23,10 +23,8 @@
 #include "usbip_common.h"
 #include "vhci.h"
 
-
 /* get URB from transmitted urb queue. caller must hold vdev->priv_lock */
-struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
-					    __u32 seqnum)
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev, __u32 seqnum)
 {
 	struct vhci_priv *priv, *tmp;
 	struct urb *urb = NULL;
@@ -38,12 +36,12 @@ struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
 			status = urb->status;
 
 			usbip_dbg_vhci_rx("find urb %p vurb %p seqnum %u\n",
-				    urb, priv, seqnum);
+					  urb, priv, seqnum);
 
 			/* TODO: fix logic here to improve indent situtation */
 			if (status != -EINPROGRESS) {
 				if (status == -ENOENT ||
-				     status == -ECONNRESET)
+				    status == -ECONNRESET)
 					dev_info(&urb->dev->dev,
 						 "urb %p was unlinked "
 						 "%ssynchronuously.\n", urb,
@@ -66,36 +64,31 @@ struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
 }
 
 static void vhci_recv_ret_submit(struct vhci_device *vdev,
-						struct usbip_header *pdu)
+				 struct usbip_header *pdu)
 {
 	struct usbip_device *ud = &vdev->ud;
 	struct urb *urb;
 
 	spin_lock(&vdev->priv_lock);
-
 	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
-
 	spin_unlock(&vdev->priv_lock);
 
 	if (!urb) {
 		usbip_uerr("cannot find a urb of seqnum %u\n",
-							pdu->base.seqnum);
+			   pdu->base.seqnum);
 		usbip_uinfo("max seqnum %d\n",
-					atomic_read(&the_controller->seqnum));
+			    atomic_read(&the_controller->seqnum));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
 
-
 	/* unpack the pdu to a urb */
 	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
 
-
 	/* recv transfer buffer */
 	if (usbip_recv_xbuff(ud, urb) < 0)
 		return;
 
-
 	/* recv iso_packet_descriptor */
 	if (usbip_recv_iso(ud, urb) < 0)
 		return;
@@ -107,7 +100,6 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	if (usbip_dbg_flag_vhci_rx)
 		usbip_dump_urb(urb);
 
-
 	usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
 
 	spin_lock(&the_controller->lock);
@@ -116,15 +108,13 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 
 	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
 
-
 	usbip_dbg_vhci_rx("Leave\n");
 
 	return;
 }
 
-
 static struct vhci_unlink *dequeue_pending_unlink(struct vhci_device *vdev,
-		struct usbip_header *pdu)
+						  struct usbip_header *pdu)
 {
 	struct vhci_unlink *unlink, *tmp;
 
@@ -134,7 +124,7 @@ static struct vhci_unlink *dequeue_pending_unlink(struct vhci_device *vdev,
 		usbip_uinfo("unlink->seqnum %lu\n", unlink->seqnum);
 		if (unlink->seqnum == pdu->base.seqnum) {
 			usbip_dbg_vhci_rx("found pending unlink, %lu\n",
-							unlink->seqnum);
+					  unlink->seqnum);
 			list_del(&unlink->list);
 
 			spin_unlock(&vdev->priv_lock);
@@ -147,9 +137,8 @@ static struct vhci_unlink *dequeue_pending_unlink(struct vhci_device *vdev,
 	return NULL;
 }
 
-
 static void vhci_recv_ret_unlink(struct vhci_device *vdev,
-						struct usbip_header *pdu)
+				 struct usbip_header *pdu)
 {
 	struct vhci_unlink *unlink;
 	struct urb *urb;
@@ -159,14 +148,12 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 	unlink = dequeue_pending_unlink(vdev, pdu);
 	if (!unlink) {
 		usbip_uinfo("cannot find the pending unlink %u\n",
-							pdu->base.seqnum);
+			    pdu->base.seqnum);
 		return;
 	}
 
 	spin_lock(&vdev->priv_lock);
-
 	urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
-
 	spin_unlock(&vdev->priv_lock);
 
 	if (!urb) {
@@ -176,7 +163,7 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 		 * back the URB.
 		 */
 		usbip_uinfo("the urb (seqnum %d) was already given backed\n",
-							pdu->base.seqnum);
+			    pdu->base.seqnum);
 	} else {
 		usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
 
@@ -189,7 +176,7 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 		spin_unlock(&the_controller->lock);
 
 		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-								urb->status);
+				     urb->status);
 	}
 
 	kfree(unlink);
@@ -202,9 +189,7 @@ static int vhci_priv_tx_empty(struct vhci_device *vdev)
 	int empty = 0;
 
 	spin_lock(&vdev->priv_lock);
-
 	empty = list_empty(&vdev->priv_rx);
-
 	spin_unlock(&vdev->priv_lock);
 
 	return empty;
@@ -217,7 +202,6 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	struct usbip_header pdu;
 	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
 
-
 	usbip_dbg_vhci_rx("Enter\n");
 
 	memset(&pdu, 0, sizeof(pdu));
@@ -245,7 +229,7 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	}
 	if (ret != sizeof(pdu)) {
 		usbip_uerr("received pdu size is %d, should be %d\n",
-					ret, (unsigned int)sizeof(pdu));
+			   ret, (unsigned int)sizeof(pdu));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
@@ -270,14 +254,12 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	}
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 int vhci_rx_loop(void *data)
 {
 	struct usbip_device *ud = data;
 
-
 	while (!kthread_should_stop()) {
 		if (usbip_event_happened(ud))
 			break;
-- 
1.7.5.1

