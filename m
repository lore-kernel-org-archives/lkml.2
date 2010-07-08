Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0GHHAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:00:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:43061 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0GHHAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:00:20 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH -mm 3/3] parisc: set ARCH_DMA_MINALIGN
Date: Thu,  8 Jul 2010 15:57:48 +0900
Message-Id: <1278572268-26146-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278572268-26146-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278572268-26146-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 08 Jul 2010 15:59:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures that handle DMA-non-coherent memory need to set
ARCH_DMA_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe: the
buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
---
 arch/parisc/include/asm/cache.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
index 45effe6..039880e 100644
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -28,6 +28,8 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 void parisc_cache_init(void);	/* initializes cache-flushing */
-- 
1.6.5

