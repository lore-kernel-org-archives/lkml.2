Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab0KSW1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:27:44 -0500
Received: from kroah.org ([198.145.64.141]:45127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932527Ab0KSV6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:43 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:42 2010
Message-Id: <20101119215641.975107517@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Mike Frysinger <vapier@gentoo.org>, Felipe Balbi <balbi@ti.com>
Subject: [39/82] usb: musb: blackfin: call usb_nop_xceiv_unregister() in musb_platform_exit()
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 3daad24d6c72affdd40e8b6a75c87d3c175880b6 upstream.

Blackfin's musb_platform_exit() forgets to call usb_nop_xceiv_unregister().
While fixing this, also remove the unneeded blank line there.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/blackfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -394,9 +394,9 @@ int __init musb_platform_init(struct mus
 
 int musb_platform_exit(struct musb *musb)
 {
-
 	gpio_free(musb->config->gpio_vrsel);
 
 	otg_put_transceiver(musb->xceiv);
+	usb_nop_xceiv_unregister();
 	return 0;
 }


