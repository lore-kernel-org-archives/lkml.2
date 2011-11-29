Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1LERbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:31:00 -0500
Received: from www17.your-server.de ([213.133.104.17]:38049 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab1LERa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:30:58 -0500
Subject: [PATCH] USB: wusb: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.339.camel@localhost.localdomain>
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

diff -u -p a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
--- a/drivers/usb/wusbcore/security.c 2011-11-13 11:07:52.997240138 +0100
+++ b/drivers/usb/wusbcore/security.c 2011-11-28 20:06:23.831675334 +0100
@@ -354,7 +354,7 @@ int wusb_dev_4way_handshake(struct wusbh
 	struct wusb_keydvt_in keydvt_in;
 	struct wusb_keydvt_out keydvt_out;
 
-	hs = kzalloc(3*sizeof(hs[0]), GFP_KERNEL);
+	hs = kcalloc(3, sizeof(hs[0]), GFP_KERNEL);
 	if (hs == NULL) {
 		dev_err(dev, "can't allocate handshake data\n");
 		goto error_kzalloc;
