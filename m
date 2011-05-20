Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935731Ab1ETTNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:13:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61839 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935691Ab1ETTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:32 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au> (maintainer:CRYPTO API),
        "David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API),
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        linux-crypto@vger.kernel.org (open list:CRYPTO API)
Subject: [PATCH 2/8] x86: Fix set but not used in ghash_async_setkey()
Date: Fri, 20 May 2011 16:12:59 -0300
Message-Id: <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 7a6e68e..976aa64 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -245,7 +245,7 @@ static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_ahash_set_flags(tfm, crypto_ahash_get_flags(child)
 			       & CRYPTO_TFM_RES_MASK);
 
-	return 0;
+	return err;
 }
 
 static int ghash_async_init_tfm(struct crypto_tfm *tfm)
-- 
1.7.5.1

