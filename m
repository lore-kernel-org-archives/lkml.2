Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1EFK5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:57:31 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:42901 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257Ab1EFKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:27 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 04/16] staging: usbip: stub_tx.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:44 -0700
Message-Id: <1b65ea26f5738445f69669e55d57b3cc6c88497a.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix alignment for consistency, checkpatch.pl warnings for lines
over 80 characters, remove extraneous lines, and change conversion
specifier within a format string to remove warning.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub_tx.c |   56 ++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index 64a52b2..bbf207d 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -23,7 +23,6 @@
 #include "usbip_common.h"
 #include "stub.h"
 
-
 static void stub_free_priv_and_urb(struct stub_priv *priv)
 {
 	struct urb *urb = priv->urb;
@@ -71,28 +70,27 @@ void stub_complete(struct urb *urb)
 
 	usbip_dbg_stub_tx("complete! status %d\n", urb->status);
 
-
 	switch (urb->status) {
 	case 0:
 		/* OK */
 		break;
 	case -ENOENT:
 		usbip_uinfo("stopped by a call of usb_kill_urb() because of"
-					"cleaning up a virtual connection\n");
+			    "cleaning up a virtual connection\n");
 		return;
 	case -ECONNRESET:
 		usbip_uinfo("unlinked by a call of usb_unlink_urb()\n");
 		break;
 	case -EPIPE:
 		usbip_uinfo("endpoint %d is stalled\n",
-						usb_pipeendpoint(urb->pipe));
+			    usb_pipeendpoint(urb->pipe));
 		break;
 	case -ESHUTDOWN:
 		usbip_uinfo("device removed?\n");
 		break;
 	default:
 		usbip_uinfo("urb completion with non-zero status %d\n",
-							urb->status);
+			    urb->status);
 	}
 
 	/* link a urb to the queue of tx. */
@@ -104,25 +102,23 @@ void stub_complete(struct urb *urb)
 	} else
 		list_move_tail(&priv->list, &sdev->priv_tx);
 
-
 	spin_unlock_irqrestore(&sdev->priv_lock, flags);
 
 	/* wake up tx_thread */
 	wake_up(&sdev->tx_waitq);
 }
 
-
 /*-------------------------------------------------------------------------*/
 /* fill PDU */
 
 static inline void setup_base_pdu(struct usbip_header_basic *base,
-		__u32 command, __u32 seqnum)
+				  __u32 command, __u32 seqnum)
 {
 	base->command = command;
 	base->seqnum  = seqnum;
 	base->devid   = 0;
 	base->ep      = 0;
-	base->direction   = 0;
+	base->direction = 0;
 }
 
 static void setup_ret_submit_pdu(struct usbip_header *rpdu, struct urb *urb)
@@ -130,19 +126,16 @@ static void setup_ret_submit_pdu(struct usbip_header *rpdu, struct urb *urb)
 	struct stub_priv *priv = (struct stub_priv *) urb->context;
 
 	setup_base_pdu(&rpdu->base, USBIP_RET_SUBMIT, priv->seqnum);
-
 	usbip_pack_pdu(rpdu, urb, USBIP_RET_SUBMIT, 1);
 }
 
 static void setup_ret_unlink_pdu(struct usbip_header *rpdu,
-		struct stub_unlink *unlink)
+				 struct stub_unlink *unlink)
 {
 	setup_base_pdu(&rpdu->base, USBIP_RET_UNLINK, unlink->seqnum);
-
 	rpdu->u.ret_unlink.status = unlink->status;
 }
 
-
 /*-------------------------------------------------------------------------*/
 /* send RET_SUBMIT */
 
@@ -203,7 +196,7 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 		/* 1. setup usbip_header */
 		setup_ret_submit_pdu(&pdu_header, urb);
 		usbip_dbg_stub_tx("setup txdata seqnum: %d urb: %p\n",
-						pdu_header.base.seqnum, urb);
+				  pdu_header.base.seqnum, urb);
 		/*usbip_dump_header(pdu_header);*/
 		usbip_header_correct_endian(&pdu_header, 1);
 
@@ -214,14 +207,14 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 
 		/* 2. setup transfer buffer */
 		if (usb_pipein(urb->pipe) &&
-				usb_pipetype(urb->pipe) != PIPE_ISOCHRONOUS &&
-					urb->actual_length > 0) {
+		    usb_pipetype(urb->pipe) != PIPE_ISOCHRONOUS &&
+		    urb->actual_length > 0) {
 			iov[iovnum].iov_base = urb->transfer_buffer;
 			iov[iovnum].iov_len  = urb->actual_length;
 			iovnum++;
 			txsize += urb->actual_length;
 		} else if (usb_pipein(urb->pipe) &&
-				usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
+			   usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
 			/*
 			 * For isochronous packets: actual length is the sum of
 			 * the actual length of the individual, packets, but as
@@ -232,18 +225,23 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 
 			int i;
 			for (i = 0; i < urb->number_of_packets; i++) {
-				iov[iovnum].iov_base = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
-				iov[iovnum].iov_len = urb->iso_frame_desc[i].actual_length;
+				iov[iovnum].iov_base = urb->transfer_buffer +
+					urb->iso_frame_desc[i].offset;
+				iov[iovnum].iov_len =
+					urb->iso_frame_desc[i].actual_length;
 				iovnum++;
 				txsize += urb->iso_frame_desc[i].actual_length;
 			}
 
 			if (txsize != sizeof(pdu_header) + urb->actual_length) {
 				dev_err(&sdev->interface->dev,
-					"actual length of urb (%d) does not match iso packet sizes (%d)\n",
-					urb->actual_length, txsize-sizeof(pdu_header));
+					"actual length of urb %d does not "
+					"match iso packet sizes %lu\n",
+					urb->actual_length,
+					txsize-sizeof(pdu_header));
 				kfree(iov);
-				usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_TCP);
+				usbip_event_add(&sdev->ud,
+						SDEV_EVENT_ERROR_TCP);
 			   return -1;
 			}
 		}
@@ -285,17 +283,14 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 	}
 
 	spin_lock_irqsave(&sdev->priv_lock, flags);
-
 	list_for_each_entry_safe(priv, tmp, &sdev->priv_free, list) {
 		stub_free_priv_and_urb(priv);
 	}
-
 	spin_unlock_irqrestore(&sdev->priv_lock, flags);
 
 	return total_size;
 }
 
-
 /*-------------------------------------------------------------------------*/
 /* send RET_UNLINK */
 
@@ -317,7 +312,6 @@ static struct stub_unlink *dequeue_from_unlink_tx(struct stub_device *sdev)
 	return NULL;
 }
 
-
 static int stub_send_ret_unlink(struct stub_device *sdev)
 {
 	unsigned long flags;
@@ -358,13 +352,10 @@ static int stub_send_ret_unlink(struct stub_device *sdev)
 			return -1;
 		}
 
-
 		usbip_dbg_stub_tx("send txdata\n");
-
 		total_size += txsize;
 	}
 
-
 	spin_lock_irqsave(&sdev->priv_lock, flags);
 
 	list_for_each_entry_safe(unlink, tmp, &sdev->unlink_free, list) {
@@ -377,7 +368,6 @@ static int stub_send_ret_unlink(struct stub_device *sdev)
 	return total_size;
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 int stub_tx_loop(void *data)
@@ -410,9 +400,9 @@ int stub_tx_loop(void *data)
 			break;
 
 		wait_event_interruptible(sdev->tx_waitq,
-				(!list_empty(&sdev->priv_tx) ||
-				 !list_empty(&sdev->unlink_tx) ||
-				 kthread_should_stop()));
+					 (!list_empty(&sdev->priv_tx) ||
+					  !list_empty(&sdev->unlink_tx) ||
+					  kthread_should_stop()));
 	}
 
 	return 0;
-- 
1.7.5.1

