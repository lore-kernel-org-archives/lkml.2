Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab0EVAiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:38:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:60910 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0EVAiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:38:07 -0400
Date: Sat, 22 May 2010 09:37:51 +0900
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, mpm@selenic.com
Subject: [PATCH -mm] Documentation/DMA-API-HOWTO: add ARCH_KMALLOC_MINALIGN
 description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100522094017U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 22 May 2010 09:37:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds ARCH_KMALLOC_MINALIGN description in "Platform Issues" section.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API-HOWTO.txt |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index bfd94e9..98ce517 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -738,7 +738,20 @@ to "Closing".
    CONFIG_NEED_SG_DMA_LENGTH if the architecture supports IOMMUs
    (including software IOMMU).
 
-2) More to come...
+2) ARCH_KMALLOC_MINALIGN
+
+   Architectures must ensure that kmalloc'ed buffer is
+   DMA-safe. Drivers and subsystems depend on it. If an architecture
+   isn't fully DMA-coherent (i.e. hardware doesn't ensure that data in
+   the CPU cache is identical to data in main memory),
+   ARCH_KMALLOC_MINALIGN must be set so that the memory allocator
+   makes sure that kmalloc'ed buffer doesn't share a cache line with
+   the others. See arch/arm/include/asm/cache.h as an example.
+
+   Note that ARCH_KMALLOC_MINALIGN is about DMA memory alignment
+   constraints. You don't need to worry about the architecture data
+   alignment constraints (e.g. the alignment constraints about 64-bit
+   objects).
 
 			   Closing
 
-- 
1.6.5

