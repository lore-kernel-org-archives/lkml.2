Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab1LERcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:32:46 -0500
Received: from www17.your-server.de ([213.133.104.17]:50066 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab1LERa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:30:59 -0500
Subject: [PATCH] usb: gadget: renesas_usbhs: Use kcalloc instead of kzalloc
 to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.338.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/renesas_usbhs/mod_host.c b/drivers/usb/renesas_usbhs/mod_host.c
--- a/drivers/usb/renesas_usbhs/mod_host.c 2011-11-28 19:36:48.033448938 +0100
+++ b/drivers/usb/renesas_usbhs/mod_host.c 2011-11-28 20:04:59.954526908 +0100
@@ -1268,7 +1268,7 @@ int usbhs_mod_host_probe(struct usbhs_pr
 		return -ENOMEM;
 	}
 
-	pipe_info = kzalloc(sizeof(*pipe_info) * pipe_size, GFP_KERNEL);
+	pipe_info = kcalloc(pipe_size, sizeof(*pipe_info), GFP_KERNEL);
 	if (!pipe_info) {
 		dev_err(dev, "Could not allocate pipe_info\n");
 		goto usbhs_mod_host_probe_err;
