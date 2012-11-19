Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2KSVkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:40:03 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33218 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2KSVkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:40:00 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        laurent.pinchart@ideasonboard.com, kernel-janitors@vger.kernel.org,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] UVC: use GFP_ATOMIC under spin lock.
Date: Mon, 19 Nov 2012 22:34:02 +0100
Message-Id: <1353360842-18384-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using the following semantic patch:
<spml>
@@
@@
spin_lock_irqsave(...);
... when != spin_unlock_irqrestore(...);
* GFP_KERNEL
</spml>

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/uvc_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
index b0e53a8..79b4132 100644
--- a/drivers/usb/gadget/uvc_video.c
+++ b/drivers/usb/gadget/uvc_video.c
@@ -309,7 +309,7 @@ uvc_video_pump(struct uvc_video *video)
 		video->encode(req, video, buf);
 
 		/* Queue the USB request */
-		if ((ret = usb_ep_queue(video->ep, req, GFP_KERNEL)) < 0) {
+		if ((ret = usb_ep_queue(video->ep, req, GFP_ATOMIC)) < 0) {
 			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
 			usb_ep_set_halt(video->ep);
 			spin_unlock_irqrestore(&video->queue.irqlock, flags);
-- 
1.7.10.4

