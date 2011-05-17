Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1EQSxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:53:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41913 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab1EQSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:53:10 -0400
Date: Tue, 17 May 2011 11:52:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>, davem@davemloft.net,
        Huang Ying <ying.huang@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH -next] crypto: fix aesni build on i386
Message-Id: <20110517115245.5544a0d0.randy.dunlap@oracle.com>
In-Reply-To: <20110517142749.8927b65b.sfr@canb.auug.org.au>
References: <20110517142749.8927b65b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DD2C409.0076:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error on i386 by moving function prototypes:

arch/x86/crypto/aesni-intel_glue.c: In function 'aesni_init':
arch/x86/crypto/aesni-intel_glue.c:1263: error: implicit declaration of function 'crypto_fpu_init'
arch/x86/crypto/aesni-intel_glue.c: In function 'aesni_exit':
arch/x86/crypto/aesni-intel_glue.c:1373: error: implicit declaration of function 'crypto_fpu_exit'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

These function prototypes should preferably be in a header file somewhere.

--- linux-next-20110517.orig/arch/x86/crypto/aesni-intel_glue.c
+++ linux-next-20110517/arch/x86/crypto/aesni-intel_glue.c
@@ -94,6 +94,10 @@ asmlinkage void aesni_cbc_enc(struct cry
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+
+int crypto_fpu_init(void);
+void crypto_fpu_exit(void);
+
 #ifdef CONFIG_X86_64
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
@@ -140,9 +144,6 @@ asmlinkage void aesni_gcm_dec(void *ctx,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-int crypto_fpu_init(void);
-void crypto_fpu_exit(void);
-
 static inline struct
 aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
 {
