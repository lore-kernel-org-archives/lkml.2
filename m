Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0F2Hnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:43:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:48233 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab0F2Hnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:43:50 -0400
Date: Tue, 29 Jun 2010 16:43:45 +0900
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -next] tile: set ARCH_KMALLOC_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100629164117Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 29 Jun 2010 16:43:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The minimum alignment and width of DMA is L2_CACHE_BYTES (because your
dma_get_cache_alignment() returns L2_CACHE_BYTES), right?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -next] tile: set ARCH_KMALLOC_MINALIGN

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
the buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/tile/include/asm/cache.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index ee59714..e08d9e8 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -31,6 +31,8 @@
 #define L2_CACHE_BYTES		(1 << L2_CACHE_SHIFT)
 #define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
 
+#define ARCH_KMALLOC_MINALIGN	L2_CACHE_BYTES
+
 /* use the cache line size for the L2, which is where it counts */
 #define SMP_CACHE_BYTES_SHIFT	L2_CACHE_SHIFT
 #define SMP_CACHE_BYTES		L2_CACHE_BYTES
-- 
1.6.5

