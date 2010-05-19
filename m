Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0ESLCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:02:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:42949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab0ESLC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:02:26 -0400
Subject: [PATCH 4/4] crypto: Use ARCH_KMALLOC_MINALIGN for CRYPTO_MINALIGN
 now that it's exposed
From: David Woodhouse <dwmw2@infradead.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
In-Reply-To: <1274266725.6930.9823.camel@macbook.infradead.org>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 12:02:17 +0100
Message-ID: <1274266937.6930.9841.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/crypto.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 24d2e30..a6a7a1c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -99,13 +99,7 @@
  * as arm where pointers are 32-bit aligned but there are data types such as
  * u64 which require 64-bit alignment.
  */
-#if defined(ARCH_KMALLOC_MINALIGN)
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
-#elif defined(ARCH_SLAB_MINALIGN)
-#define CRYPTO_MINALIGN ARCH_SLAB_MINALIGN
-#else
-#define CRYPTO_MINALIGN __alignof__(unsigned long long)
-#endif
 
 #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
 
-- 
1.6.6.1


