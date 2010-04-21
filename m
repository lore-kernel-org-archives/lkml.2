Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0DUBHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:07:36 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37500 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0DUBHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=vuUBkkNkWQnjw/d9Siq4a2b/Wm0HNK3JLs3++n/Rys9Zav9d3Ua5QCDaw30xQx0x30
         l1Rvjte8T0AqGQ63LYTyOxMgrT0P+hxwi/TlTwjlcAfWWIjybxKd4vVT1PtTPGX9826k
         FFtfpW8i7DQr8QrFCtRqz9qR5gHzrPksL181k=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 21 Apr 2010 09:07:14 +0800
Message-ID: <m2i427d64721004201807z2888dd31oc1c54b61fb2d8078@mail.gmail.com>
Subject: [PATCH] acecad: fix incorrect size parameter in usb_buffer_free
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Edouard TISSERANT <edouard.tisserant@wanadoo.fr>,
       Dmitry Torokhov <dtor@mail.ru>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size allocated by usb_buffer_alloc is 8, however the size free by
usb_buffer_free in usb_acecad_disconnect is 10.
This patch corrects the size parameter in usb_buffer_free.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/input/tablet/acecad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index 670c61c..265753c 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -256,7 +256,7 @@ static void usb_acecad_disconnect(struct
usb_interface *intf)
 		usb_kill_urb(acecad->irq);
 		input_unregister_device(acecad->input);
 		usb_free_urb(acecad->irq);
-		usb_buffer_free(interface_to_usbdev(intf), 10, acecad->data,
acecad->data_dma);
+		usb_buffer_free(interface_to_usbdev(intf), 8, acecad->data,
acecad->data_dma);
 		kfree(acecad);
 	}
 }
-- 
1.5.4.3
