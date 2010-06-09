Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab0FISrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:47:16 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:60527 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758116Ab0FISrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:47:13 -0400
Date: Wed, 9 Jun 2010 20:43:03 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Duncan Sands <duncan.sands@free.fr>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] speedtouch: fixed brace and spacing coding style issues
Message-ID: <20100609204303.489ca8c2@absol.kitzblitz>
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

Fixed spacing coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
This patch depends on patch 1/2.

 drivers/usb/atm/speedtch.c |    6 +++---
 drivers/usb/atm/usbatm.c   |   16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 50c44b2..600dd88 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -759,7 +759,7 @@ static void speedtch_release_interfaces(struct usb_device *usb_dev,
 	struct usb_interface *cur_intf;
 	int i;
 
-	for(i = 0; i < num_interfaces; i++)
+	for (i = 0; i < num_interfaces; i++)
 		if ((cur_intf = usb_ifnum_to_if(usb_dev, i))) {
 			usb_set_intfdata(cur_intf, NULL);
 			usb_driver_release_interface(&speedtch_usb_driver, cur_intf);
@@ -794,7 +794,7 @@ static int speedtch_bind(struct usbatm_data *usbatm,
 
 	/* claim all interfaces */
 
-	for (i=0; i < num_interfaces; i++) {
+	for (i = 0; i < num_interfaces; i++) {
 		cur_intf = usb_ifnum_to_if(usb_dev, i);
 
 		if ((i != ifnum) && cur_intf) {
@@ -844,7 +844,7 @@ static int speedtch_bind(struct usbatm_data *usbatm,
 
 		use_isoc = 0; /* fall back to bulk if endpoint not found */
 
-		for (i=0; i<desc->desc.bNumEndpoints; i++) {
+		for (i = 0; i < desc->desc.bNumEndpoints; i++) {
 			const struct usb_endpoint_descriptor *endpoint_desc = &desc->endpoint[i].desc;
 
 			if ((endpoint_desc->bEndpointAddress == target_address)) {
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index a67166e..05bf5a2 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -84,8 +84,8 @@
 
 #ifdef VERBOSE_DEBUG
 static int usbatm_print_packet(const unsigned char *data, int len);
-#define PACKETDEBUG(arg...)	usbatm_print_packet (arg)
-#define vdbg(arg...)		dbg (arg)
+#define PACKETDEBUG(arg...)	usbatm_print_packet(arg)
+#define vdbg(arg...)		dbg(arg)
 #else
 #define PACKETDEBUG(arg...)
 #define vdbg(arg...)
@@ -273,7 +273,7 @@ static void usbatm_complete(struct urb *urb)
 
 	if (unlikely(status) &&
 			(!(channel->usbatm->flags & UDSL_IGNORE_EILSEQ) ||
-			 status != -EILSEQ )) {
+			 status != -EILSEQ)) {
 		if (status == -ESHUTDOWN)
 			return;
 
@@ -493,7 +493,7 @@ static unsigned int usbatm_write_cells(struct usbatm_data *instance,
 		ptr += data_len;
 		__skb_pull(skb, data_len);
 
-		if(!left)
+		if (!left)
 			continue;
 
 		memset(ptr, 0, left);
@@ -505,7 +505,7 @@ static unsigned int usbatm_write_cells(struct usbatm_data *instance,
 			trailer[2] = ctrl->len >> 8;
 			trailer[3] = ctrl->len;
 
-			ctrl->crc = ~ crc32_be(ctrl->crc, ptr, left - 4);
+			ctrl->crc = ~crc32_be(ctrl->crc, ptr, left - 4);
 
 			trailer[4] = ctrl->crc >> 24;
 			trailer[5] = ctrl->crc >> 16;
@@ -1144,7 +1144,7 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 	instance->tx_channel.endpoint = usb_sndbulkpipe(usb_dev, driver->bulk_out);
 
 	/* tx buffer size must be a positive multiple of the stride */
-	instance->tx_channel.buf_size = max (instance->tx_channel.stride,
+	instance->tx_channel.buf_size = max(instance->tx_channel.stride,
 			snd_buf_bytes - (snd_buf_bytes % instance->tx_channel.stride));
 
 	/* rx buffer size must be a positive multiple of the endpoint maxpacket */
@@ -1157,7 +1157,7 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 		goto fail_unbind;
 	}
 
-	num_packets = max (1U, (rcv_buf_bytes + maxpacket / 2) / maxpacket); /* round */
+	num_packets = max(1U, (rcv_buf_bytes + maxpacket / 2) / maxpacket); /* round */
 
 	if (num_packets * maxpacket > UDSL_MAX_BUF_SIZE)
 		num_packets--;
@@ -1260,7 +1260,7 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 		usb_free_urb(instance->urbs[i]);
 	}
 
-	kfree (instance);
+	kfree(instance);
 
 	return error;
 }
-- 
1.6.4.4

