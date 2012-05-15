Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378Ab2EOCRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:52 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52964 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887Ab2EOCQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 030/179] usb: gadget: rndis: don't test against req->length
Date: Mon, 14 May 2012 22:12:06 -0400
Message-ID: <1337048075-6132-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/gadget/f_rndis.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 56b0221..d1eb94a 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -420,8 +420,7 @@ rndis_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
 	 */
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8)
 			| USB_CDC_SEND_ENCAPSULATED_COMMAND:
-		if (w_length > req->length || w_value
-				|| w_index != rndis->ctrl_id)
+		if (w_value || w_index != rndis->ctrl_id)
 			goto invalid;
 		/* read the request; process it later */
 		value = w_length;
-- 
1.7.9.6

