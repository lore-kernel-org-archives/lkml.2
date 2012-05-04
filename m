Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab2EDUt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:49:26 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842Ab2EDUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:19 -0400
Message-Id: <20120504204247.209170133@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fernandez Gonzalo <gfernandez@copreci.es>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [ 27/47] usb gadget: uvc: uvc_request_data::length field must be signed
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 6f6543f53f9ce136e01d7114bf6f0818ca54fb41 upstream.

The field is used to pass the UVC request data length, but can also be
used to signal an error when setting it to a negative value. Switch from
unsigned int to __s32.

Reported-by: Fernandez Gonzalo <gfernandez@copreci.es>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/uvc.h      |    2 +-
 drivers/usb/gadget/uvc_v4l2.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -29,7 +29,7 @@
 
 struct uvc_request_data
 {
-	unsigned int length;
+	__s32 length;
 	__u8 data[60];
 };
 
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -41,7 +41,7 @@ uvc_send_response(struct uvc_device *uvc
 	if (data->length < 0)
 		return usb_ep_set_halt(cdev->gadget->ep0);
 
-	req->length = min(uvc->event_length, data->length);
+	req->length = min_t(unsigned int, uvc->event_length, data->length);
 	req->zero = data->length < uvc->event_length;
 	req->dma = DMA_ADDR_INVALID;
 


