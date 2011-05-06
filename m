Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1EFKzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:55:41 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:41723 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab1EFKyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:38 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 13/16] staging: usbip: vhci_tx.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:53 -0700
Message-Id: <3ace7eca2f5c9073a1d64e8935a504577bb569d0.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few alignment issues and remove extraneous lines.
Use ternary operator for pdup->base.direction assignment.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/vhci_tx.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
index d9ab49d..6ececa8 100644
--- a/drivers/staging/usbip/vhci_tx.c
+++ b/drivers/staging/usbip/vhci_tx.c
@@ -23,23 +23,20 @@
 #include "usbip_common.h"
 #include "vhci.h"
 
-
 static void setup_cmd_submit_pdu(struct usbip_header *pdup,  struct urb *urb)
 {
 	struct vhci_priv *priv = ((struct vhci_priv *)urb->hcpriv);
 	struct vhci_device *vdev = priv->vdev;
 
 	usbip_dbg_vhci_tx("URB, local devnum %u, remote devid %u\n",
-				usb_pipedevice(urb->pipe), vdev->devid);
+			  usb_pipedevice(urb->pipe), vdev->devid);
 
-	pdup->base.command = USBIP_CMD_SUBMIT;
-	pdup->base.seqnum  = priv->seqnum;
-	pdup->base.devid   = vdev->devid;
-	if (usb_pipein(urb->pipe))
-		pdup->base.direction = USBIP_DIR_IN;
-	else
-		pdup->base.direction = USBIP_DIR_OUT;
-	pdup->base.ep      = usb_pipeendpoint(urb->pipe);
+	pdup->base.command   = USBIP_CMD_SUBMIT;
+	pdup->base.seqnum    = priv->seqnum;
+	pdup->base.devid     = vdev->devid;
+	pdup->base.direction = usb_pipein(urb->pipe) ?
+		USBIP_DIR_IN : USBIP_DIR_OUT;
+	pdup->base.ep	     = usb_pipeendpoint(urb->pipe);
 
 	usbip_pack_pdu(pdup, urb, USBIP_CMD_SUBMIT, 1);
 
@@ -65,8 +62,6 @@ static struct vhci_priv *dequeue_from_priv_tx(struct vhci_device *vdev)
 	return NULL;
 }
 
-
-
 static int vhci_send_cmd_submit(struct vhci_device *vdev)
 {
 	struct vhci_priv *priv = NULL;
@@ -90,7 +85,6 @@ static int vhci_send_cmd_submit(struct vhci_device *vdev)
 
 		usbip_dbg_vhci_tx("setup txdata urb %p\n", urb);
 
-
 		/* 1. setup usbip_header */
 		setup_cmd_submit_pdu(&pdu_header, urb);
 		usbip_header_correct_endian(&pdu_header, 1);
@@ -125,7 +119,7 @@ static int vhci_send_cmd_submit(struct vhci_device *vdev)
 		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 3, txsize);
 		if (ret != txsize) {
 			usbip_uerr("sendmsg failed!, retval %d for %zd\n", ret,
-									txsize);
+				   txsize);
 			kfree(iso_buffer);
 			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
 			return -1;
@@ -140,7 +134,6 @@ static int vhci_send_cmd_submit(struct vhci_device *vdev)
 	return total_size;
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 static struct vhci_unlink *dequeue_from_unlink_tx(struct vhci_device *vdev)
@@ -182,7 +175,6 @@ static int vhci_send_cmd_unlink(struct vhci_device *vdev)
 
 		usbip_dbg_vhci_tx("setup cmd unlink, %lu\n", unlink->seqnum);
 
-
 		/* 1. setup usbip_header */
 		pdu_header.base.command = USBIP_CMD_UNLINK;
 		pdu_header.base.seqnum  = unlink->seqnum;
@@ -204,7 +196,6 @@ static int vhci_send_cmd_unlink(struct vhci_device *vdev)
 			return -1;
 		}
 
-
 		usbip_dbg_vhci_tx("send txdata\n");
 
 		total_size += txsize;
@@ -213,7 +204,6 @@ static int vhci_send_cmd_unlink(struct vhci_device *vdev)
 	return total_size;
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 int vhci_tx_loop(void *data)
@@ -229,9 +219,9 @@ int vhci_tx_loop(void *data)
 			break;
 
 		wait_event_interruptible(vdev->waitq_tx,
-				(!list_empty(&vdev->priv_tx) ||
-				 !list_empty(&vdev->unlink_tx) ||
-				 kthread_should_stop()));
+					 (!list_empty(&vdev->priv_tx) ||
+					  !list_empty(&vdev->unlink_tx) ||
+					  kthread_should_stop()));
 
 		usbip_dbg_vhci_tx("pending urbs ?, now wake up\n");
 	}
-- 
1.7.5.1

