Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2BQBAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53748 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756828Ab2BQBAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:06 -0500
X-Sasl-enc: OhwAE9bervg95CxHB0P1FGqwooWxPAbhUQtqpqIcYCng 1329440405
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:36 2012
Message-Id: <20120217005536.766801087@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [20/28] crypto: sha512 - Use binary and instead of modulus
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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


