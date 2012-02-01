Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2BAVRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:17:53 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56732 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757400Ab2BAVRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:17:44 -0500
X-Sasl-enc: Bwa7cVIXiPBeWL0rM0Xi+FYr2l3h7/0t+uAHRfc4P5Vg 1328131063
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.788725663@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [67/89] USB: cdc-wdm: better allocate a buffer that is at least as big as we tell the USB core
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 655e247daf52b202a6c2d0f8a06dd2051e756ce4 upstream.

As it turns out, there was a mismatch between the allocated inbuf size
(desc->bMaxPacketSize0, typically something like 64) and the length we
specified in the URB (desc->wMaxCommand, typically something like 2048)

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -723,7 +723,7 @@ next_desc:
 		goto err;
 
 	desc->inbuf = usb_alloc_coherent(interface_to_usbdev(intf),
-					 desc->bMaxPacketSize0,
+					 desc->wMaxCommand,
 					 GFP_KERNEL,
 					 &desc->response->transfer_dma);
 	if (!desc->inbuf)


