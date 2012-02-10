Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828Ab2BJXIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:08:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab2BJWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:13 -0500
MIME-Version: 1.0
Message-Id: <20120210222951.878998692@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Becker <chemobejk@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [patch 77/86] usb: ch9.h: usb_endpoint_maxp() uses __le16_to_cpu()
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 9c0a835a9d9aed41bcf9c287f5069133a6e2a87b upstream.

The usb/ch9.h will be installed to /usr/include/linux,
and be used from user space.
But le16_to_cpu() is only defined for kernel code.
Without this patch, user space compile will be broken.
Special thanks to Stefan Becker

Reported-by: Stefan Becker <chemobejk@gmail.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/usb/ch9.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -589,7 +589,7 @@ static inline int usb_endpoint_is_isoc_o
  */
 static inline int usb_endpoint_maxp(const struct usb_endpoint_descriptor *epd)
 {
-	return le16_to_cpu(epd->wMaxPacketSize);
+	return __le16_to_cpu(epd->wMaxPacketSize);
 }
 
 /*-------------------------------------------------------------------------*/


