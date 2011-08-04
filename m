Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1HDUwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:52:15 -0400
Received: from www17.your-server.de ([213.133.104.17]:49953 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1HDUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:52:04 -0400
Subject: [PATCH] net/usb: Use kzalloc
From: Thomas Meyer <thomas@m3y3r.de>
To: Julie Sullivan <kernelmail.jms@gmail.com>
Cc: Tobias Klauser <tklauser@distanz.ch>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Thu, 04 Aug 2011 22:51:32 +0200
In-Reply-To: <CAAVPGOPbspuvS_745bPwAPuWY6_N5VQX-mUhxo=RZhZDNSn0QA@mail.gmail.com>
References: <1312301372.2629.10.camel@localhost.localdomain>
	 <20110803090223.GM4587@distanz.ch>
	 <CAAVPGOPbspuvS_745bPwAPuWY6_N5VQX-mUhxo=RZhZDNSn0QA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312491095.2629.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kzalloc rather than kmalloc followed by memset with 0

 This considers some simple cases that are common and easy to validate
 Note in particular that there are no ...s in the rule, so all of the
 matched code has to be contiguous

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

Am Donnerstag, den 04.08.2011, 21:31 +0100 schrieb Julie Sullivan:
> I think we could do with a log message before the SOB too (like you
> did in your 'Use resource_size()' patch? :-)
> 
yes, sure! sorry! I promise to improve.

here you go:

diff -u -p a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
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



