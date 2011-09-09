Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab1IIUrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:47:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11033 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759970Ab1IIUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1315598554!34066405!227
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] aes_glue.c: quiet sparse noise about symbol not declared
Date: Fri, 9 Sep 2011 13:47:02 -0700
User-Agent: KMail/1.9.9
CC: <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <herbert@gondor.hengli.com.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091347.03199.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include <asm/aes.h> to pick up the declarations for crypto_aes_encrypt_x86
and crypto_aes_decrypt_x86 to quiet the sparse noise:

warning: symbol 'crypto_aes_encrypt_x86' was not declared. Should it be static?
warning: symbol 'crypto_aes_decrypt_x86' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
"David S. Miller" <davem@davemloft.net>
Thomas Gleixner <tglx@linutronix.de>
Ingo Molnar <mingo@redhat.com>
"H. Peter Anvin" <hpa@zytor.com>

---

diff --git a/arch/x86/crypto/aes_glue.c b/arch/x86/crypto/aes_glue.c
index bdce3ee..8efcf42 100644
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -5,6 +5,7 @@
 
 #include <linux/module.h>
 #include <crypto/aes.h>
+#include <asm/aes.h>
 
 asmlinkage void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
 asmlinkage void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
