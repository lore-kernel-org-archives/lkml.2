Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0F2GvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 02:51:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:45540 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0F2GvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 02:51:14 -0400
Date: Tue, 29 Jun 2010 15:50:50 +0900
To: linux-parisc@vger.kernel.org
Cc: kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: set ARCH_KMALLOC_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100629154801C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 29 Jun 2010 15:50:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend:

http://marc.info/?t=127432584100006&r=1&w=2

I thought that it was merged but seems that it was lost somewhere?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] parisc: set ARCH_KMALLOC_MINALIGN

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
the buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: stable@kernel.org
---
 arch/parisc/include/asm/cache.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
index 45effe6..5d87f27 100644
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -22,6 +22,8 @@
 #define L1_CACHE_SHIFT 5
 #endif
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 #ifndef __ASSEMBLY__
 
 #define L1_CACHE_ALIGN(x)       (((x)+(L1_CACHE_BYTES-1))&~(L1_CACHE_BYTES-1))
-- 
1.6.5

