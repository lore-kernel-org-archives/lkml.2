Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab0KSVsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:48:43 -0500
Received: from kroah.org ([198.145.64.141]:51848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab0KSVph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:37 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:12 2010
Message-Id: <20101119214411.983289234@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Mike Frysinger <vapier@gentoo.org>, Felipe Balbi <balbi@ti.com>
Subject: [31/45] usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 00be545e49d83485d49a598d3b7e090088934be8 upstream.

Blackfin's musb_platform_init() needs to call gpio_free() for error cleanup iff
otg_get_transceiver() call returns NULL.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/blackfin.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -248,8 +248,10 @@ int __init musb_platform_init(struct mus
 
 	usb_nop_xceiv_register();
 	musb->xceiv = otg_get_transceiver();
-	if (!musb->xceiv)
+	if (!musb->xceiv) {
+		gpio_free(musb->config->gpio_vrsel);
 		return -ENODEV;
+	}
 
 	if (ANOMALY_05000346) {
 		bfin_write_USB_APHY_CALIB(ANOMALY_05000346_value);


