Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234Ab1LPUwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:52:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783Ab1LPUw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:52:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 12:50:43 2011
Message-Id: <20111216205042.962457883@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 12:49:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tushar Gohad <tgohad@mvista.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Calvin Owens <jcalvinowens@gmail.com>
Subject: [07/16] xfrm: Fix key lengths for rfc3686(ctr(aes))
In-Reply-To: <20111216205049.GA28030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Gohad <tgohad@mvista.com>

commit 4203223a1aed862b4445fdcd260d6139603a51d9 upstream.

Fix the min and max bit lengths for AES-CTR (RFC3686) keys.
The number of bits in key spec is the key length (128/256)
plus 32 bits of nonce.

This change takes care of the "Invalid key length" errors
reported by setkey when specifying 288 bit keys for aes-ctr.

Signed-off-by: Tushar Gohad <tgohad@mvista.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_algo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -411,8 +411,8 @@ static struct xfrm_algo_desc ealg_list[]
 	.desc = {
 		.sadb_alg_id = SADB_X_EALG_AESCTR,
 		.sadb_alg_ivlen	= 8,
-		.sadb_alg_minbits = 128,
-		.sadb_alg_maxbits = 256
+		.sadb_alg_minbits = 160,
+		.sadb_alg_maxbits = 288
 	}
 },
 };


