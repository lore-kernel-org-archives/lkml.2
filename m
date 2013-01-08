Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3AHXw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:52:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:63516 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab3AHXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tushar Gohad <tgohad@mvista.com>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 50/77] xfrm: Fix key lengths for rfc3686(ctr(aes))
Date: Tue, 8 Jan 2013 18:35:29 -0500
Message-ID: <1357688156-25387-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Gohad <tgohad@mvista.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4203223a1aed862b4445fdcd260d6139603a51d9 upstream.

Fix the min and max bit lengths for AES-CTR (RFC3686) keys.
The number of bits in key spec is the key length (128/256)
plus 32 bits of nonce.

This change takes care of the "Invalid key length" errors
reported by setkey when specifying 288 bit keys for aes-ctr.

Signed-off-by: Tushar Gohad <tgohad@mvista.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/xfrm/xfrm_algo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 8b4d6e3..2437ef2 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -462,8 +462,8 @@ static struct xfrm_algo_desc ealg_list[] = {
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
-- 
1.7.12.1

