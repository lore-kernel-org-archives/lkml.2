Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab2APVmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:42:13 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12488 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab2APVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:42:11 -0500
Date: Mon, 16 Jan 2012 22:42:10 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-usb@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] renesas; Silence uninitialized variable report in
 usbhsg_recip_run_handle()
Message-ID: <alpine.LNX.2.00.1201162239110.16712@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/usb/renesas_usbhs/mod_gadget.c::usbhsg_recip_run_handle()
the Coverity Prevent checker currently flags a warning about possibly
uninitialized use of 'ret' i usbhsg_recip_run_handle(). It does this
since it assumes we take one of the non-default branches in the switch
and then subsequently take the false branch in the 'if (func)' case
below. This exact scenario will never happen, but Coverity can't see
that for some reason. This patch initializes 'ret' to '0' when it is
declared which should shut up this report and won't really hurt - so
why not? At least then it's clear that 'ret' is always initialized..

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/usb/renesas_usbhs/mod_gadget.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 528691d5f..7542aa9 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -425,7 +425,7 @@ static int usbhsg_recip_run_handle(struct usbhs_priv *priv,
 	struct usbhs_pipe *pipe;
 	int recip = ctrl->bRequestType & USB_RECIP_MASK;
 	int nth = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
-	int ret;
+	int ret = 0;
 	int (*func)(struct usbhs_priv *priv, struct usbhsg_uep *uep,
 		    struct usb_ctrlrequest *ctrl);
 	char *msg;
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

