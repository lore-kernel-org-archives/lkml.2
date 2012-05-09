Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2EIFwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38645 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab2EIFwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:36 -0400
Message-Id: <20120509055031.389717526@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoki Sekiyama <tomoki.sekiyama@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 013/167] [PATCH] USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag in urb
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

commit 532f17b5d59bf0deb6f1ff9bc1fb27d5b5011c09 upstream.

Current probing code is setting URB_NO_TRANSFER_DMA_MAP flag into a wrong urb
structure, and this causes BUG_ON with some USB host implementations.
This patch fixes the issue.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/yurex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index a4a76fc..7020146 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -282,7 +282,7 @@ static int yurex_probe(struct usb_interface *interface, const struct usb_device_
 			 usb_rcvintpipe(dev->udev, dev->int_in_endpointAddr),
 			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
 			 dev, 1);
-	dev->cntl_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	dev->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
 		retval = -EIO;
 		err("Could not submitting URB");
-- 
1.7.10



