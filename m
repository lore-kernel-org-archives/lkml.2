Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1HBQ1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:27:40 -0400
Received: from www17.your-server.de ([213.133.104.17]:51221 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1HBQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:27:35 -0400
Subject: [PATCH] net/usb: Use kzalloc
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 02 Aug 2011 18:09:28 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312301372.2629.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- a/drivers/net/usb/cdc_ncm.c 2011-07-26 00:46:08.126846923 +0200
+++ b/drivers/net/usb/cdc_ncm.c 2011-08-01 20:20:43.396390040 +0200
@@ -479,12 +479,10 @@ static int cdc_ncm_bind(struct usbnet *d
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


