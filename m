Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0FUPBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:01:37 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48085 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab0FUPBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:01:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] CRYPTO: ablkcipher, avoid NULL dereference
Date: Mon, 21 Jun 2010 17:01:23 +0200
Message-Id: <1277132483-14172-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a potential NULL dereference in ablkcipher_next_slow.
Even though kmalloc fails, its retval is dereferenced later. Return
from that function properly earlier.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ablkcipher.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 98a6610..a854df2 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -165,7 +165,7 @@ static inline int ablkcipher_next_slow(struct ablkcipher_request *req,
 
 	p = kmalloc(n, GFP_ATOMIC);
 	if (!p)
-		ablkcipher_walk_done(req, walk, -ENOMEM);
+		return ablkcipher_walk_done(req, walk, -ENOMEM);
 
 	base = p + 1;
 
-- 
1.7.1


