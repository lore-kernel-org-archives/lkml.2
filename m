Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1HKRxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1HKRxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:53:14 -0400
Date: Thu, 11 Aug 2011 12:40:41 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Message-ID: <20110811164040.GB2167@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ablkcipher structure in ablk_ecb_alg is lacking an ivsize setting.
This causes the algorithm to fail it's self-test when it's registered
with the error message:

[    0.806920] alg: skcipher: Failed to load transform for ecb-aes-aesni: -2

crypto_lookup_skcipher doesn't like a missing ivsize.  Adding the ivsize
allows the self-test lookup to pass.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index feee8ff..711cc3c 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -587,6 +587,7 @@ static struct crypto_alg ablk_ecb_alg = {
 		.ablkcipher = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
 			.setkey		= ablk_set_key,
 			.encrypt	= ablk_encrypt,
 			.decrypt	= ablk_decrypt,
-- 
1.7.6

