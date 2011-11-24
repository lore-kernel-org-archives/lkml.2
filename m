Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1KXGr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:47:58 -0500
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:55417 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1KXGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:47:57 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Nov 2011 01:47:56 EST
Subject: [PATCH] crypto: serpent-sse2 - should select CRYPTO_CRYPTD
To: Stephen Rothwell <sfr@canb.auug.org.au>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 24 Nov 2011 08:37:41 +0200
Message-ID: <20111124063741.17986.23462.stgit@localhost6.localdomain6>
In-Reply-To: <4ECD527E.8000506@xenotime.net>
References: <4ECD527E.8000506@xenotime.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since serpent_sse2_glue.c uses cryptd, CRYPTO_SERPENT_SSE2_X86_64 and
CRYPTO_SERPENT_SSE2_586 should be selecting CRYPTO_CRYPTD.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 16e0c13..b8d1b10 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -770,6 +770,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	tristate "Serpent cipher algorithm (x86_64/SSE2)"
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
 	select CRYPTO_SERPENT
 	help
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
@@ -787,6 +788,7 @@ config CRYPTO_SERPENT_SSE2_586
 	tristate "Serpent cipher algorithm (i586/SSE2)"
 	depends on X86 && !64BIT
 	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
 	select CRYPTO_SERPENT
 	help
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.

