Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab2BJWnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab2BJWnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:15 -0500
MIME-Version: 1.0
Message-Id: <20120210222951.977928532@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Felipe Balbi <balbi@ti.com>
Subject: [patch 78/86] usb: gadget: zero: fix bug in loopback autoresume handling
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timo Juhani Lindfors <timo.lindfors@iki.fi>

commit 683da59d7b8ae04891636d4b59893cd4e9b0b7e5 upstream.

ab943a2e125b (USB: gadget: gadget zero uses new suspend/resume hooks)
introduced a copy-paste error where f_loopback.c writes to a variable
declared in f_sourcesink.c. This prevents one from creating gadgets
that only have a loopback function.

Signed-off-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_loopback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -418,7 +418,7 @@ int __init loopback_add(struct usb_compo
 
 	/* support autoresume for remote wakeup testing */
 	if (autoresume)
-		sourcesink_driver.bmAttributes |= USB_CONFIG_ATT_WAKEUP;
+		loopback_driver.bmAttributes |= USB_CONFIG_ATT_WAKEUP;
 
 	/* support OTG systems */
 	if (gadget_is_otg(cdev->gadget)) {


