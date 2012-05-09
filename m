Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2EIGSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:18:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756416Ab2EIFxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:25 -0400
Message-Id: <20120509055046.116035794@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Fernandez Gonzalo <gfernandez@copreci.es>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 119/167] [PATCH] usb gadget: uvc: uvc_request_data::length field must be
 signed
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 6f6543f53f9ce136e01d7114bf6f0818ca54fb41 upstream.

The field is used to pass the UVC request data length, but can also be
used to signal an error when setting it to a negative value. Switch from
unsigned int to __s32.

Reported-by: Fernandez Gonzalo <gfernandez@copreci.es>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/uvc.h      |    2 +-
 drivers/usb/gadget/uvc_v4l2.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index bc78c60..ca4e03a 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -28,7 +28,7 @@
 
 struct uvc_request_data
 {
-	unsigned int length;
+	__s32 length;
 	__u8 data[60];
 };
 
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index f6e083b..54d7ca5 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -39,7 +39,7 @@ uvc_send_response(struct uvc_device *uvc, struct uvc_request_data *data)
 	if (data->length < 0)
 		return usb_ep_set_halt(cdev->gadget->ep0);
 
-	req->length = min(uvc->event_length, data->length);
+	req->length = min_t(unsigned int, uvc->event_length, data->length);
 	req->zero = data->length < uvc->event_length;
 	req->dma = DMA_ADDR_INVALID;
 
-- 
1.7.10



