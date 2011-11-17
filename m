Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab1KVLmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:42:44 -0500
Received: from www17.your-server.de ([213.133.104.17]:40351 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab1KVLmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:42:42 -0500
Subject: [PATCH] CDC NCM: Use kzalloc rather than kmalloc followed by
 memset with 0
From: Thomas Meyer <thomas@m3y3r.de>
To: oliver@neukum.name, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.264.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This considers some simple cases that are common and easy to validate
Note in particular that there are no ...s in the rule, so all of the
matched code has to be contiguous

The semantic patch that makes this change is available
in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
--- a/drivers/net/usb/cdc_ncm.c 2011-11-07 19:38:00.160137318 +0100
+++ b/drivers/net/usb/cdc_ncm.c 2011-11-08 09:35:34.632578608 +0100
@@ -465,12 +465,10 @@ static int cdc_ncm_bind(struct usbnet *d
 	int temp;
 	u8 iface_no;
 
-	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx == NULL)
 		return -ENODEV;
 
-	memset(ctx, 0, sizeof(*ctx));
-
 	init_timer(&ctx->tx_timer);
 	spin_lock_init(&ctx->mtx);
 	ctx->netdev = dev->net;
