Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0ETDVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:21:02 -0400
Received: from sh.osrg.net ([192.16.179.4]:48863 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0ETDUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:20:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: davem@davemloft.net, dwmw2@infradead.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Chris Zankel <chris@zankel.net>, stable@kernel.org
Subject: [PATCH -mm 6/6] xtensa: set ARCH_KMALLOC_MINALIGN
Date: Thu, 20 May 2010 12:21:43 +0900
Message-Id: <1274325703-11092-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 20 May 2010 12:20:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
the buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Chris Zankel <chris@zankel.net>
Cc: stable@kernel.org
---
 arch/xtensa/include/asm/cache.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/include/asm/cache.h b/arch/xtensa/include/asm/cache.h
index f04c989..ed8cd3c 100644
--- a/arch/xtensa/include/asm/cache.h
+++ b/arch/xtensa/include/asm/cache.h
@@ -29,5 +29,6 @@
 # define CACHE_WAY_SIZE ICACHE_WAY_SIZE
 #endif
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
 
 #endif	/* _XTENSA_CACHE_H */
-- 
1.6.5

