Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0HNHg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 03:36:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:33568 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab0HNHg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 03:36:57 -0400
Date: Sat, 14 Aug 2010 16:36:17 +0900
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: DMA-API-HOWTO.txt: rename
 ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100814163504B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Aug 2010 16:36:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_KMALLOC_MINALIGN was renamed to ARCH_DMA_MINALIGN (the commit
a6eb9fe105d5de0053b261148cee56c94b4720ca).

ARCH_DMA_MINALIGN must be defined instead of ARCH_KMALLOC_MINALIGN to
ensure that kmalloc'ed buffer is DMA-safe.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API-HOWTO.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 3c4e071..d568bc2 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -738,17 +738,17 @@ to "Closing".
    CONFIG_NEED_SG_DMA_LENGTH if the architecture supports IOMMUs
    (including software IOMMU).
 
-2) ARCH_KMALLOC_MINALIGN
+2) ARCH_DMA_MINALIGN
 
    Architectures must ensure that kmalloc'ed buffer is
    DMA-safe. Drivers and subsystems depend on it. If an architecture
    isn't fully DMA-coherent (i.e. hardware doesn't ensure that data in
    the CPU cache is identical to data in main memory),
-   ARCH_KMALLOC_MINALIGN must be set so that the memory allocator
+   ARCH_DMA_MINALIGN must be set so that the memory allocator
    makes sure that kmalloc'ed buffer doesn't share a cache line with
    the others. See arch/arm/include/asm/cache.h as an example.
 
-   Note that ARCH_KMALLOC_MINALIGN is about DMA memory alignment
+   Note that ARCH_DMA_MINALIGN is about DMA memory alignment
    constraints. You don't need to worry about the architecture data
    alignment constraints (e.g. the alignment constraints about 64-bit
    objects).
-- 
1.6.5

