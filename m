Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0ETDV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:21:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:48879 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab0ETDVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:21:13 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: davem@davemloft.net, dwmw2@infradead.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>, stable@kernel.org
Subject: [PATCH -mm 4/6] mn10300: set ARCH_KMALLOC_MINALIGN
Date: Thu, 20 May 2010 12:21:41 +0900
Message-Id: <1274325703-11092-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: stable@kernel.org
---
 arch/mn10300/include/asm/cache.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/include/asm/cache.h b/arch/mn10300/include/asm/cache.h
index e03cfa2..6e2fe28 100644
--- a/arch/mn10300/include/asm/cache.h
+++ b/arch/mn10300/include/asm/cache.h
@@ -21,6 +21,8 @@
 #define L1_CACHE_DISPARITY	L1_CACHE_NENTRIES * L1_CACHE_BYTES
 #endif
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 /* data cache purge registers
  * - read from the register to unconditionally purge that cache line
  * - write address & 0xffffff00 to conditionally purge that cache line
-- 
1.6.5

