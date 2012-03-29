Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab2C2Xvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:51:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60875 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933533Ab2C2Xvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:51:38 -0400
Message-ID: <4F74F588.8020604@gmail.com>
Date: Fri, 30 Mar 2012 08:51:36 +0900
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag
 in urb
References: <4F739CBB.8060602@gmail.com> <4F744E23.3040207@mvista.com>
In-Reply-To: <4F744E23.3040207@mvista.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current probing code is setting URB_NO_TRANSFER_DMA_MAP flag into a wrong urb
structure, and this causes BUG_ON with some USB host implementations.
This patch fixes the issue.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
---
 drivers/usb/misc/yurex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 1.7.7.6

