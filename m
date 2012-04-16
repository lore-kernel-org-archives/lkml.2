Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2DPPDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:03:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59439 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab2DPPDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:03:18 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/usb/musb/davinci.c: add missing unregister
Date: Mon, 16 Apr 2012 17:03:10 +0200
Message-Id: <1334588590-23891-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

usb_nop_xceiv_unregister is needed on failure of usb_get_transceiver, as
done in other error-handling code in the same function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/musb/davinci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index 97ab975..768b4b5 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -386,7 +386,7 @@ static int davinci_musb_init(struct musb *musb)
 	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_transceiver();
 	if (!musb->xceiv)
-		return -ENODEV;
+		goto unregister;
 
 	musb->mregs += DAVINCI_BASE_OFFSET;
 
@@ -444,6 +444,7 @@ static int davinci_musb_init(struct musb *musb)
 
 fail:
 	usb_put_transceiver(musb->xceiv);
+unregister:
 	usb_nop_xceiv_unregister();
 	return -ENODEV;
 }

