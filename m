Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0EVJ76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 05:59:58 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35913 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0EVJ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 05:59:53 -0400
Date: Sat, 22 May 2010 11:59:48 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/8] crypto: Use ERR_CAST
Message-ID: <Pine.LNX.4.64.1005221159290.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 crypto/authenc.c |    2 +-
 crypto/ctr.c     |    2 +-
 crypto/xts.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/crypto/authenc.c b/crypto/authenc.c
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -612,7 +612,7 @@ static struct crypto_instance *crypto_au
 	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
 			       CRYPTO_ALG_TYPE_AHASH_MASK);
 	if (IS_ERR(auth))
-		return ERR_PTR(PTR_ERR(auth));
+		return ERR_CAST(auth);
 
 	auth_base = &auth->base;
 
diff -u -p a/crypto/ctr.c b/crypto/ctr.c
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -185,7 +185,7 @@ static struct crypto_instance *crypto_ct
 	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	/* Block size must be >= 4 bytes. */
 	err = -EINVAL;
diff -u -p a/crypto/xts.c b/crypto/xts.c
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -224,7 +224,7 @@ static struct crypto_instance *alloc(str
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("xts", alg);
 	if (IS_ERR(inst))
