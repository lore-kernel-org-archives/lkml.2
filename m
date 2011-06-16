Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1FPHIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:08:39 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51585 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527Ab1FPHFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:50 -0400
X-Sasl-enc: Q7tdrjoVmYpMrPyUfDlYuI8Pqs4Uhpva0DL1ix8mQ0b8 1308207949
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:12 2011
Message-Id: <20110616001612.667930410@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>
Subject: [34/91] usb: gadget: rndis: dont test against req->length
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -400,8 +400,7 @@ rndis_setup(struct usb_function *f, cons
 	 */
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8)
 			| USB_CDC_SEND_ENCAPSULATED_COMMAND:
-		if (w_length > req->length || w_value
-				|| w_index != rndis->ctrl_id)
+		if (w_value || w_index != rndis->ctrl_id)
 			goto invalid;
 		/* read the request; process it later */
 		value = w_length;


