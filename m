Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1EFKyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:37 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:57355 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755170Ab1EFKyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:31 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 06/16] staging: usbip: usbip_common.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:46 -0700
Message-Id: <e440cc99d6ebb971ca89682181970fdbe179fc0c.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix alignment for consistency, checkpatch.pl warning of line over
80 characters, and remove extraneous lines.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/usbip_common.c |  107 +++++++++++++++-------------------
 1 files changed, 46 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 7b1fe45..cd66d56 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -27,7 +27,8 @@
 
 /* version information */
 #define DRIVER_VERSION "1.0"
-#define DRIVER_AUTHOR "Takahiro Hirofuchi <hirofuchi _at_ users.sourceforge.net>"
+#define DRIVER_AUTHOR \
+	"Takahiro Hirofuchi <hirofuchi _at_ users.sourceforge.net>"
 #define DRIVER_DESC "usbip common driver"
 
 /*-------------------------------------------------------------------------*/
@@ -40,23 +41,20 @@ unsigned long usbip_debug_flag;
 #endif
 EXPORT_SYMBOL_GPL(usbip_debug_flag);
 
-
 /* FIXME */
 struct device_attribute dev_attr_usbip_debug;
 EXPORT_SYMBOL_GPL(dev_attr_usbip_debug);
 
-
 static ssize_t show_flag(struct device *dev, struct device_attribute *attr,
-								char *buf)
+			 char *buf)
 {
 	return sprintf(buf, "%lx\n", usbip_debug_flag);
 }
 
 static ssize_t store_flag(struct device *dev, struct device_attribute *attr,
-		const char *buf, size_t count)
+			  const char *buf, size_t count)
 {
 	sscanf(buf, "%lx", &usbip_debug_flag);
-
 	return count;
 }
 DEVICE_ATTR(usbip_debug, (S_IRUGO | S_IWUSR), show_flag, store_flag);
@@ -298,7 +296,7 @@ void usbip_dump_urb(struct urb *urb)
 	dev_dbg(dev, "   setup_packet          :%p\n", urb->setup_packet);
 
 	if (urb->setup_packet && usb_pipetype(urb->pipe) == PIPE_CONTROL)
-			usbip_dump_usb_ctrlrequest(
+		usbip_dump_usb_ctrlrequest(
 			(struct usb_ctrlrequest *)urb->setup_packet);
 
 	dev_dbg(dev, "   start_frame           :%d\n", urb->start_frame);
@@ -313,32 +311,32 @@ EXPORT_SYMBOL_GPL(usbip_dump_urb);
 void usbip_dump_header(struct usbip_header *pdu)
 {
 	usbip_udbg("BASE: cmd %u seq %u devid %u dir %u ep %u\n",
-			pdu->base.command,
-			pdu->base.seqnum,
-			pdu->base.devid,
-			pdu->base.direction,
-			pdu->base.ep);
+		   pdu->base.command,
+		   pdu->base.seqnum,
+		   pdu->base.devid,
+		   pdu->base.direction,
+		   pdu->base.ep);
 
 	switch (pdu->base.command) {
 	case USBIP_CMD_SUBMIT:
 		usbip_udbg("CMD_SUBMIT: "
-				"x_flags %u x_len %u sf %u #p %u iv %u\n",
-				pdu->u.cmd_submit.transfer_flags,
-				pdu->u.cmd_submit.transfer_buffer_length,
-				pdu->u.cmd_submit.start_frame,
-				pdu->u.cmd_submit.number_of_packets,
-				pdu->u.cmd_submit.interval);
-				break;
+			   "x_flags %u x_len %u sf %u #p %u iv %u\n",
+			   pdu->u.cmd_submit.transfer_flags,
+			   pdu->u.cmd_submit.transfer_buffer_length,
+			   pdu->u.cmd_submit.start_frame,
+			   pdu->u.cmd_submit.number_of_packets,
+			   pdu->u.cmd_submit.interval);
+		break;
 	case USBIP_CMD_UNLINK:
 		usbip_udbg("CMD_UNLINK: seq %u\n", pdu->u.cmd_unlink.seqnum);
 		break;
 	case USBIP_RET_SUBMIT:
 		usbip_udbg("RET_SUBMIT: st %d al %u sf %d #p %d ec %d\n",
-				pdu->u.ret_submit.status,
-				pdu->u.ret_submit.actual_length,
-				pdu->u.ret_submit.start_frame,
-				pdu->u.ret_submit.number_of_packets,
-				pdu->u.ret_submit.error_count);
+			   pdu->u.ret_submit.status,
+			   pdu->u.ret_submit.actual_length,
+			   pdu->u.ret_submit.start_frame,
+			   pdu->u.ret_submit.number_of_packets,
+			   pdu->u.ret_submit.error_count);
 	case USBIP_RET_UNLINK:
 		usbip_udbg("RET_UNLINK: status %d\n", pdu->u.ret_unlink.status);
 		break;
@@ -352,7 +350,7 @@ EXPORT_SYMBOL_GPL(usbip_dump_header);
 /*-------------------------------------------------------------------------*/
 /* socket routines */
 
-/*  Send/receive messages over TCP/IP. I refer drivers/block/nbd.c */
+/* Send/receive messages over TCP/IP. I refer drivers/block/nbd.c */
 int usbip_xmit(int send, struct socket *sock, char *buf,
 	       int size, int msg_flags)
 {
@@ -373,7 +371,6 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 		return -EINVAL;
 	}
 
-
 	if (usbip_dbg_flag_xmit) {
 		if (send) {
 			if (!in_interrupt())
@@ -388,7 +385,6 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 		}
 	}
 
-
 	do {
 		sock->sk->sk_allocation = GFP_NOIO;
 		iov.iov_base    = buf;
@@ -404,13 +400,12 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 			result = kernel_sendmsg(sock, &msg, &iov, 1, size);
 		else
 			result = kernel_recvmsg(sock, &msg, &iov, 1, size,
-								MSG_WAITALL);
+						MSG_WAITALL);
 
 		if (result <= 0) {
 			usbip_udbg("usbip_xmit: %s sock %p buf %p size %u ret "
-					"%d total %d\n",
-					send ? "send" : "receive", sock, buf,
-					size, result, total);
+				   "%d total %d\n", send ? "send" : "receive",
+				   sock, buf, size, result, total);
 			goto err;
 		}
 
@@ -420,7 +415,6 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 
 	} while (size > 0);
 
-
 	if (usbip_dbg_flag_xmit) {
 		if (!send) {
 			if (!in_interrupt())
@@ -431,13 +425,13 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 			printk(KERN_DEBUG "usbip_xmit: receiving....\n");
 			usbip_dump_buffer(bp, osize);
 			printk(KERN_DEBUG "usbip_xmit: received, osize %d ret "
-					"%d size %d total %d\n", osize, result,
-					size, total);
+			       "%d size %d total %d\n", osize, result, size,
+			       total);
 		}
 
 		if (send)
 			printk(KERN_DEBUG "usbip_xmit: send, total %d\n",
-									total);
+			       total);
 	}
 
 	return total;
@@ -470,8 +464,6 @@ struct socket *sockfd_to_socket(unsigned int sockfd)
 }
 EXPORT_SYMBOL_GPL(sockfd_to_socket);
 
-
-
 /*-------------------------------------------------------------------------*/
 /* pdu routines */
 
@@ -483,7 +475,7 @@ static unsigned int tweak_transfer_flags(unsigned int flags)
 }
 
 static void usbip_pack_cmd_submit(struct usbip_header *pdu, struct urb *urb,
-								int pack)
+				  int pack)
 {
 	struct usbip_header_cmd_submit *spdu = &pdu->u.cmd_submit;
 
@@ -494,7 +486,7 @@ static void usbip_pack_cmd_submit(struct usbip_header *pdu, struct urb *urb,
 	if (pack) {
 		/* vhci_tx.c */
 		spdu->transfer_flags =
-				tweak_transfer_flags(urb->transfer_flags);
+			tweak_transfer_flags(urb->transfer_flags);
 		spdu->transfer_buffer_length	= urb->transfer_buffer_length;
 		spdu->start_frame		= urb->start_frame;
 		spdu->number_of_packets		= urb->number_of_packets;
@@ -511,7 +503,7 @@ static void usbip_pack_cmd_submit(struct usbip_header *pdu, struct urb *urb,
 }
 
 static void usbip_pack_ret_submit(struct usbip_header *pdu, struct urb *urb,
-								int pack)
+				  int pack)
 {
 	struct usbip_header_ret_submit *rpdu = &pdu->u.ret_submit;
 
@@ -534,9 +526,8 @@ static void usbip_pack_ret_submit(struct usbip_header *pdu, struct urb *urb,
 	}
 }
 
-
 void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
-								int pack)
+		    int pack)
 {
 	switch (cmd) {
 	case USBIP_CMD_SUBMIT:
@@ -553,7 +544,6 @@ void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
 }
 EXPORT_SYMBOL_GPL(usbip_pack_pdu);
 
-
 static void correct_endian_basic(struct usbip_header_basic *base, int send)
 {
 	if (send) {
@@ -572,7 +562,7 @@ static void correct_endian_basic(struct usbip_header_basic *base, int send)
 }
 
 static void correct_endian_cmd_submit(struct usbip_header_cmd_submit *pdu,
-								int send)
+				      int send)
 {
 	if (send) {
 		pdu->transfer_flags = cpu_to_be32(pdu->transfer_flags);
@@ -592,7 +582,7 @@ static void correct_endian_cmd_submit(struct usbip_header_cmd_submit *pdu,
 }
 
 static void correct_endian_ret_submit(struct usbip_header_ret_submit *pdu,
-								int send)
+				      int send)
 {
 	if (send) {
 		cpu_to_be32s(&pdu->status);
@@ -610,7 +600,7 @@ static void correct_endian_ret_submit(struct usbip_header_ret_submit *pdu,
 }
 
 static void correct_endian_cmd_unlink(struct usbip_header_cmd_unlink *pdu,
-								int send)
+				      int send)
 {
 	if (send)
 		pdu->seqnum = cpu_to_be32(pdu->seqnum);
@@ -619,7 +609,7 @@ static void correct_endian_cmd_unlink(struct usbip_header_cmd_unlink *pdu,
 }
 
 static void correct_endian_ret_unlink(struct usbip_header_ret_unlink *pdu,
-								int send)
+				      int send)
 {
 	if (send)
 		cpu_to_be32s(&pdu->status);
@@ -661,8 +651,8 @@ void usbip_header_correct_endian(struct usbip_header *pdu, int send)
 EXPORT_SYMBOL_GPL(usbip_header_correct_endian);
 
 static void usbip_iso_pakcet_correct_endian(
-				struct usbip_iso_packet_descriptor *iso,
-				int send)
+	struct usbip_iso_packet_descriptor *iso,
+	int send)
 {
 	/* does not need all members. but copy all simply. */
 	if (send) {
@@ -679,7 +669,7 @@ static void usbip_iso_pakcet_correct_endian(
 }
 
 static void usbip_pack_iso(struct usbip_iso_packet_descriptor *iso,
-		struct usb_iso_packet_descriptor *uiso, int pack)
+			   struct usb_iso_packet_descriptor *uiso, int pack)
 {
 	if (pack) {
 		iso->offset		= uiso->offset;
@@ -694,7 +684,6 @@ static void usbip_pack_iso(struct usbip_iso_packet_descriptor *iso,
 	}
 }
 
-
 /* must free buffer */
 void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen)
 {
@@ -760,7 +749,6 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 		return -EPIPE;
 	}
 
-
 	for (i = 0; i < np; i++) {
 		iso = buff + (i * sizeof(*iso));
 
@@ -773,8 +761,9 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 
 	if (total_length != urb->actual_length) {
 		dev_err(&urb->dev->dev,
-		  "total length of iso packets (%d) not equal to actual length of buffer (%d)\n",
-		  total_length, urb->actual_length);
+			"total length of iso packets %d not equal to actual "
+			"length of buffer %d\n",
+			total_length, urb->actual_length);
 
 		if (ud->side == USBIP_STUB)
 			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
@@ -823,9 +812,10 @@ int usbip_pad_iso(struct usbip_device *ud, struct urb *urb)
 	for (i = np-1; i > 0; i--) {
 		actualoffset -= urb->iso_frame_desc[i].actual_length;
 		memmove(urb->transfer_buffer + urb->iso_frame_desc[i].offset,
-				  urb->transfer_buffer + actualoffset,
-				  urb->iso_frame_desc[i].actual_length);
+			urb->transfer_buffer + actualoffset,
+			urb->iso_frame_desc[i].actual_length);
 	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usbip_pad_iso);
@@ -872,13 +862,11 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(usbip_recv_xbuff);
 
-
 /*-------------------------------------------------------------------------*/
 
 static int __init usbip_common_init(void)
 {
 	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "" DRIVER_VERSION);
-
 	return 0;
 }
 
@@ -887,9 +875,6 @@ static void __exit usbip_common_exit(void)
 	return;
 }
 
-
-
-
 module_init(usbip_common_init);
 module_exit(usbip_common_exit);
 
-- 
1.7.5.1

