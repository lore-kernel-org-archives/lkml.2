Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2BAVI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:57 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35855 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148Ab2BAVIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:52 -0500
X-Sasl-enc: zX7Xj3EzdZY6orqTITWXZAyRWelpQ+KsMJc786RXl0XX 1328130531
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:41 2012
Message-Id: <20120201205741.585485432@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [47/65] USB: cdc-wdm: better allocate a buffer that is at least as big as we tell the USB core
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


