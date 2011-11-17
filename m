Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1KSL3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:29:43 -0500
Received: from www17.your-server.de ([213.133.104.17]:41059 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1KSL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:29:37 -0500
Subject: [PATCH] RxRPC: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.308.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
--- a/net/rxrpc/ar-key.c 2011-11-07 19:38:32.050621708 +0100
+++ b/net/rxrpc/ar-key.c 2011-11-08 10:59:18.926240106 +0100
@@ -306,10 +306,9 @@ static int rxrpc_krb5_decode_tagged_data
 	td->data_len = len;
 
 	if (len > 0) {
-		td->data = kmalloc(len, GFP_KERNEL);
+		td->data = kmemdup(xdr, len, GFP_KERNEL);
 		if (!td->data)
 			return -ENOMEM;
-		memcpy(td->data, xdr, len);
 		len = (len + 3) & ~3;
 		toklen -= len;
 		xdr += len >> 2;
@@ -401,10 +400,9 @@ static int rxrpc_krb5_decode_ticket(u8 *
 	_debug("ticket len %u", len);
 
 	if (len > 0) {
-		*_ticket = kmalloc(len, GFP_KERNEL);
+		*_ticket = kmemdup(xdr, len, GFP_KERNEL);
 		if (!*_ticket)
 			return -ENOMEM;
-		memcpy(*_ticket, xdr, len);
 		len = (len + 3) & ~3;
 		toklen -= len;
 		xdr += len >> 2;
