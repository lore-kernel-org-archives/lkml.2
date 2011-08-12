Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1HNQIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1HNQIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210556.925248738@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tushar Gohad <tgohad@mvista.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [55/90] xfrm: Fix key lengths for rfc3686(ctr(aes))
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Tushar Gohad <tgohad@mvista.com>

[ Upstream commit 4203223a1aed862b4445fdcd260d6139603a51d9 ]

Fix the min and max bit lengths for AES-CTR (RFC3686) keys.
The number of bits in key spec is the key length (128/256)
plus 32 bits of nonce.

This change takes care of the "Invalid key length" errors
reported by setkey when specifying 288 bit keys for aes-ctr.

Signed-off-by: Tushar Gohad <tgohad@mvista.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/xfrm/xfrm_algo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -462,8 +462,8 @@ static struct xfrm_algo_desc ealg_list[]
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


