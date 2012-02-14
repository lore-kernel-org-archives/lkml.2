Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2BNGTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:19:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61414 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2BNGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:19:22 -0500
Message-ID: <1329200354.3806.1.camel@phoenix>
Subject: [PATCH] RxRPC: Fix kcalloc parameters swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
        Thomas Meyer <thomas@m3y3r.de>, Anton Blanchard <anton@samba.org>,
        netdev@vger.kernel.org
Date: Tue, 14 Feb 2012 14:19:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter should be "number of elements" and the second parameter
should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 net/rxrpc/ar-key.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 4cba13e..ae3a035 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -232,7 +232,7 @@ static int rxrpc_krb5_decode_principal(struct krb5_principal *princ,
 	if (toklen <= (n_parts + 1) * 4)
 		return -EINVAL;
 
-	princ->name_parts = kcalloc(sizeof(char *), n_parts, GFP_KERNEL);
+	princ->name_parts = kcalloc(n_parts, sizeof(char *), GFP_KERNEL);
 	if (!princ->name_parts)
 		return -ENOMEM;
 
@@ -355,7 +355,7 @@ static int rxrpc_krb5_decode_tagged_array(struct krb5_tagged_data **_td,
 
 		_debug("n_elem %d", n_elem);
 
-		td = kcalloc(sizeof(struct krb5_tagged_data), n_elem,
+		td = kcalloc(n_elem, sizeof(struct krb5_tagged_data),
 			     GFP_KERNEL);
 		if (!td)
 			return -ENOMEM;
-- 
1.7.5.4



