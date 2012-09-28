Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031704Ab2I1Tv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:51:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965020Ab2I1S57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ido Shayevitz <idos@codeaurora.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Mario Isidoro <Mario.Isidoro@tecmic.pt>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 083/262] usb: gadget: at91udc: Dont check for ep->ep.desc
Date: Fri, 28 Sep 2012 11:50:12 -0700
Message-Id: <20120928183007.984281730@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit f3bb8e63a8ee0398dffe412e774d8801db7e1bf1 upstream.

Earlier we used to check for ep->ep.desc to figure out if this ep has
already been enabled and if so, abort.
Ido Shayevitz removed the usb_endpoint_descriptor from private udc
structure 5a6506f00 ("usb: gadget: Update at91_udc to use
usb_endpoint_descriptor	inside the struct usb_ep") but did not fix up
the ep_enable condition because _now_ the member is always true and we
can't check if this ep is enabled twice.

Cc: Ido Shayevitz <idos@codeaurora.org>
Tested-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Tested-by: Mario Isidoro <Mario.Isidoro@tecmic.pt>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/at91_udc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -475,8 +475,7 @@ static int at91_ep_enable(struct usb_ep
 	unsigned long	flags;
 
 	if (!_ep || !ep
-			|| !desc || ep->ep.desc
-			|| _ep->name == ep0name
+			|| !desc || _ep->name == ep0name
 			|| desc->bDescriptorType != USB_DT_ENDPOINT
 			|| (maxpacket = usb_endpoint_maxp(desc)) == 0
 			|| maxpacket > ep->maxpacket) {
@@ -530,7 +529,6 @@ ok:
 	tmp |= AT91_UDP_EPEDS;
 	__raw_writel(tmp, ep->creg);
 
-	ep->ep.desc = desc;
 	ep->ep.maxpacket = maxpacket;
 
 	/*


