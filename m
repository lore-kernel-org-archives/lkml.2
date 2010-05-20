Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0ETDVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:21:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:48868 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0ETDVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:21:00 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: davem@davemloft.net, dwmw2@infradead.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, stable@kernel.org
Subject: [PATCH -mm 3/6] m68k: set ARCH_KMALLOC_MINALIGN
Date: Thu, 20 May 2010 12:21:40 +0900
Message-Id: <1274325703-11092-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 20 May 2010 12:20:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
the buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: stable@kernel.org
---
 arch/m68k/include/asm/cache.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/include/asm/cache.h b/arch/m68k/include/asm/cache.h
index fed3fd3..ecafbe1 100644
--- a/arch/m68k/include/asm/cache.h
+++ b/arch/m68k/include/asm/cache.h
@@ -8,4 +8,6 @@
 #define        L1_CACHE_SHIFT  4
 #define        L1_CACHE_BYTES  (1<< L1_CACHE_SHIFT)
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 #endif
-- 
1.6.5

