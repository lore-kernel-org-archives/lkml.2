Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0ETDVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:21:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:48872 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab0ETDVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:21:04 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: davem@davemloft.net, dwmw2@infradead.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: [PATCH -mm 2/6] frv: set ARCH_KMALLOC_MINALIGN
Date: Thu, 20 May 2010 12:21:39 +0900
Message-Id: <1274325703-11092-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 20 May 2010 12:20:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
the buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
Cc: stable@kernel.org
---
 arch/frv/include/asm/cache.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/frv/include/asm/cache.h b/arch/frv/include/asm/cache.h
index 2797163..7dc0f0f 100644
--- a/arch/frv/include/asm/cache.h
+++ b/arch/frv/include/asm/cache.h
@@ -17,6 +17,8 @@
 #define L1_CACHE_SHIFT		(CONFIG_FRV_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 #define __cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
 #define ____cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
 
-- 
1.6.5

