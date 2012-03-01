Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2CAVwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:52:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687Ab2CAVvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:51:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.138.200 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213923.685779931@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 09/34] crypto: sha512 - Use binary and instead of modulus
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 58d7d18b5268febb8b1391c6dffc8e2aaa751fcd upstream.

The previous patch used the modulus operator over a power of 2
unnecessarily which may produce suboptimal binary code.  This
patch changes changes them to binary ands instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/sha512_generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -78,7 +78,7 @@ static inline void LOAD_OP(int I, u64 *W
 
 static inline void BLEND_OP(int I, u64 *W)
 {
-	W[I % 16] += s1(W[(I-2) % 16]) + W[(I-7) % 16] + s0(W[(I-15) % 16]);
+	W[I & 15] += s1(W[(I-2) & 15]) + W[(I-7) & 15] + s0(W[(I-15) & 15]);
 }
 
 static void
@@ -105,7 +105,7 @@ sha512_transform(u64 *state, const u8 *i
 
 #define SHA512_16_79(i, a, b, c, d, e, f, g, h)			\
 	BLEND_OP(i, W);						\
-	t1 = h + e1(e) + Ch(e, f, g) + sha512_K[i] + W[(i)%16];	\
+	t1 = h + e1(e) + Ch(e, f, g) + sha512_K[i] + W[(i)&15];	\
 	t2 = e0(a) + Maj(a, b, c);				\
 	d += t1;						\
 	h = t1 + t2


