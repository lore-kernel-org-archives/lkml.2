Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab2DXWhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:37:37 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2DXWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:31 -0400
Message-Id: <20120424223254.250893094@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Subject: [ 09/42] USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag in urb
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

commit 532f17b5d59bf0deb6f1ff9bc1fb27d5b5011c09 upstream.

Current probing code is setting URB_NO_TRANSFER_DMA_MAP flag into a wrong urb
structure, and this causes BUG_ON with some USB host implementations.
This patch fixes the issue.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/yurex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -282,7 +282,7 @@ static int yurex_probe(struct usb_interf
 			 usb_rcvintpipe(dev->udev, dev->int_in_endpointAddr),
 			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
 			 dev, 1);
-	dev->cntl_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	dev->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
 		retval = -EIO;
 		err("Could not submitting URB");


