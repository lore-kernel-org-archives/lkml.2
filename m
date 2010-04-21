Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0DUBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:09:26 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:51832 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0DUBJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=XPYFSOzOyWYU3j5Zrr6kABySkZnQ5b2uHivL/Gbb6ltcnilTjSBgXyYERZXvNB2xVL
         iS0rGanx+DA0K41RmO+pQpqsfbB9WZ+My3W4cdKl8EkM2+q2K6aJyYiL5ivEtd1249Tb
         n5WBSTR1uJSkdRuscJhIBbVYmxeCnWC8pNuKw=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 21 Apr 2010 09:09:04 +0800
Message-ID: <z2v427d64721004201809n11a1ce9exe6e7bdf243636c5e@mail.gmail.com>
Subject: [PATCH] kbtab: fix incorrect size parameter in usb_buffer_free
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Josh Myer <josh@joshisanerd.com>, Dmitry Torokhov <dtor@mail.ru>,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size allocated by usb_buffer_alloc is 8, however the size free by
usb_buffer_free is 10.
This patch corrects the size parameter in usb_buffer_free.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/input/tablet/kbtab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 6682b17..76b5d52 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -182,7 +182,7 @@ static int kbtab_probe(struct usb_interface *intf,
const struct usb_device_id *i
        return 0;

  fail3:        usb_free_urb(kbtab->irq);
- fail2:        usb_buffer_free(dev, 10, kbtab->data, kbtab->data_dma);
+ fail2:        usb_buffer_free(dev, 8, kbtab->data, kbtab->data_dma);
  fail1:        input_free_device(input_dev);
        kfree(kbtab);
        return error;
@@ -197,7 +197,7 @@ static void kbtab_disconnect(struct usb_interface *intf)
                usb_kill_urb(kbtab->irq);
                input_unregister_device(kbtab->dev);
                usb_free_urb(kbtab->irq);
-               usb_buffer_free(interface_to_usbdev(intf), 10,
kbtab->data, kbtab->data_dma);
+               usb_buffer_free(interface_to_usbdev(intf), 8,
kbtab->data, kbtab->data_dma);
                kfree(kbtab);
        }
 }
-- 
1.5.4.3
