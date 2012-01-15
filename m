Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab2AOTq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 14:46:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50141 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2AOTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 14:46:58 -0500
Message-ID: <4F132D37.7030405@gmail.com>
Date: Mon, 16 Jan 2012 01:17:03 +0530
From: mahendra singh meena <mahendra.devel@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: marcel@holtmann.org
CC: padovan@profusion.mobi, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: bfusb: Fixed some coding style issues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed some coding style issues shown by scripts/checkpatch.pl

Signed-off-by: Mahendra Singh Meena <mahendra.devel@gmail.com>
---
 drivers/bluetooth/bfusb.c |   52 ++++++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index a323bae..e74062a 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -127,11 +127,13 @@ static int bfusb_send_bulk(struct bfusb_data *data, struct sk_buff *skb)
 {
 	struct bfusb_data_scb *scb = (void *) skb->cb;
 	struct urb *urb = bfusb_get_completed(data);
+	struct urb *urb_chk = urb;
 	int err, pipe;

 	BT_DBG("bfusb %p skb %p len %d", data, skb, skb->len);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);

-	if (!urb && !(urb = usb_alloc_urb(0, GFP_ATOMIC)))
+	if (!urb_chk && !urb)
 		return -ENOMEM;

 	pipe = usb_sndbulkpipe(data->udev, data->bulk_out_ep);
@@ -145,7 +147,7 @@ static int bfusb_send_bulk(struct bfusb_data *data, struct sk_buff *skb)

 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err) {
-		BT_ERR("%s bulk tx submit failed urb %p err %d",
+		BT_ERR("%s bulk tx submit failed urb %p err %d",
 					data->hdev->name, urb, err);
 		skb_unlink(skb, &data->pending_q);
 		usb_free_urb(urb);
@@ -214,11 +216,13 @@ static int bfusb_rx_submit(struct bfusb_data *data, struct urb *urb)
 {
 	struct bfusb_data_scb *scb;
 	struct sk_buff *skb;
+	struct urb *urb_chk = urb;
 	int err, pipe, size = HCI_MAX_FRAME_SIZE + 32;

 	BT_DBG("bfusb %p urb %p", data, urb);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);

-	if (!urb && !(urb = usb_alloc_urb(0, GFP_ATOMIC)))
+	if (!urb && !urb_chk)
 		return -ENOMEM;

 	skb = bt_skb_alloc(size, GFP_ATOMIC);
@@ -251,7 +255,8 @@ static int bfusb_rx_submit(struct bfusb_data *data, struct urb *urb)
 	return err;
 }

-static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned char *buf, int len)
+static inline int bfusb_recv_block(struct bfusb_data *data, int hdr,
+						 unsigned char *buf, int len)
 {
 	BT_DBG("bfusb %p hdr 0x%02x data %p len %d", data, hdr, buf, len);

@@ -283,30 +288,37 @@ static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned ch
 		switch (pkt_type) {
 		case HCI_EVENT_PKT:
 			if (len >= HCI_EVENT_HDR_SIZE) {
-				struct hci_event_hdr *hdr = (struct hci_event_hdr *) buf;
+				struct hci_event_hdr *hdr;
+				hdr = (struct hci_event_hdr *) buf;
 				pkt_len = HCI_EVENT_HDR_SIZE + hdr->plen;
 			} else {
-				BT_ERR("%s event block is too short", data->hdev->name);
+				BT_ERR("%s event block is too short",
+							 data->hdev->name);
 				return -EILSEQ;
 			}
 			break;

 		case HCI_ACLDATA_PKT:
 			if (len >= HCI_ACL_HDR_SIZE) {
-				struct hci_acl_hdr *hdr = (struct hci_acl_hdr *) buf;
-				pkt_len = HCI_ACL_HDR_SIZE + __le16_to_cpu(hdr->dlen);
+				struct hci_acl_hdr *hdr;
+				hdr = (struct hci_acl_hdr *) buf;
+				pkt_len = HCI_ACL_HDR_SIZE;
+				pkt_len = pkt_len + __le16_to_cpu(hdr->dlen);
 			} else {
-				BT_ERR("%s data block is too short", data->hdev->name);
+				BT_ERR("%s data block is too short",
+							 data->hdev->name);
 				return -EILSEQ;
 			}
 			break;

 		case HCI_SCODATA_PKT:
 			if (len >= HCI_SCO_HDR_SIZE) {
-				struct hci_sco_hdr *hdr = (struct hci_sco_hdr *) buf;
+				struct hci_sco_hdr *hdr;
+				hdr = (struct hci_sco_hdr *) buf;
 				pkt_len = HCI_SCO_HDR_SIZE + hdr->dlen;
 			} else {
-				BT_ERR("%s audio block is too short", data->hdev->name);
+				BT_ERR("%s audio block is too short",
+							 data->hdev->name);
 				return -EILSEQ;
 			}
 			break;
@@ -324,7 +336,8 @@ static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned ch
 		data->reassembly = skb;
 	} else {
 		if (!data->reassembly) {
-			BT_ERR("%s unexpected continuation block", data->hdev->name);
+			BT_ERR("%s unexpected continuation block",
+							 data->hdev->name);
 			return -EIO;
 		}
 	}
@@ -473,7 +486,8 @@ static int bfusb_send_frame(struct sk_buff *skb)
 	unsigned char buf[3];
 	int sent = 0, size, count;

-	BT_DBG("hdev %p skb %p type %d len %d", hdev, skb, bt_cb(skb)->pkt_type, skb->len);
+	BT_DBG("hdev %p skb %p type %d len %d",
+				 hdev, skb, bt_cb(skb)->pkt_type, skb->len);

 	if (!hdev) {
 		BT_ERR("Frame for unknown HCI device (hdev=NULL)");
@@ -514,12 +528,14 @@ static int bfusb_send_frame(struct sk_buff *skb)
 	while (count) {
 		size = min_t(uint, count, BFUSB_MAX_BLOCK_SIZE);

-		buf[0] = 0xc1 | ((sent == 0) ? 0x04 : 0) | ((count == size) ? 0x08 : 0);
+		buf[0] = 0xc1 | ((sent == 0) ? 0x04 : 0) |
+						((count == size) ? 0x08 : 0);
 		buf[1] = 0x00;
 		buf[2] = (size == BFUSB_MAX_BLOCK_SIZE) ? 0 : size;

 		memcpy(skb_put(nskb, 3), buf, 3);
-		skb_copy_from_linear_data_offset(skb, sent, skb_put(nskb, size), size);
+		skb_copy_from_linear_data_offset(skb, sent,
+						 skb_put(nskb, size), size);

 		sent  += size;
 		count -= size;
@@ -553,7 +569,8 @@ static void bfusb_destruct(struct hci_dev *hdev)
 	kfree(data);
 }

-static int bfusb_ioctl(struct hci_dev *hdev, unsigned int cmd, unsigned long arg)
+static int bfusb_ioctl(struct hci_dev *hdev, unsigned int cmd,
+							 unsigned long arg)
 {
 	return -ENOIOCTLCMD;
 }
@@ -638,7 +655,8 @@ error:
 	return err;
 }

-static int bfusb_probe(struct usb_interface *intf, const struct usb_device_id *id)
+static int bfusb_probe(struct usb_interface *intf,
+						 const struct usb_device_id *id)
 {
 	const struct firmware *firmware;
 	struct usb_device *udev = interface_to_usbdev(intf);
-- 
1.7.0.4

