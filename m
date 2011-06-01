Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162047Ab1FAJHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:07:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:43922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161982Ab1FAIQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:22 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:22 2011
Message-Id: <20110601080421.664816564@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:48 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [112/146] usb: gadget: rndis: dont test against req->length
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 472b91274a6c6857877b5caddb875dcb5ecdfcb8 upstream.

composite.c always sets req->length to zero
and expects function driver's setup handlers
to return the amount of bytes to be used
on req->length. If we test against req->length
w_length will always be greater than req->length
thus making us always stall that particular
SEND_ENCAPSULATED_COMMAND request.

Tested against a Windows XP SP3.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_rndis.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -420,8 +420,7 @@ rndis_setup(struct usb_function *f, cons
 	 */
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8)
 			| USB_CDC_SEND_ENCAPSULATED_COMMAND:
-		if (w_length > req->length || w_value
-				|| w_index != rndis->ctrl_id)
+		if (w_value || w_index != rndis->ctrl_id)
 			goto invalid;
 		/* read the request; process it later */
 		value = w_length;


