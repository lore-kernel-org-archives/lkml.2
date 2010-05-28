Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab0E1JmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:42:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab0E1JmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:42:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: ARCH_KMALLOC_MINALIGN was already defined
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 28 May 2010 10:41:16 +0100
Message-ID: <20100528094115.30547.20855.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_KMALLOC_MINALIGN was already defined in asm/mem-layout.h and so shouldn't
have been added to asm/cache.h as well, but rather altered in place.

The commit that added it to asm/cache.h was:

	commit 69dcf3db03626c4f18de624e8632454ea12ff260
	Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
	Date:   Mon May 24 14:32:54 2010 -0700

	    frv: set ARCH_KMALLOC_MINALIGN

	    Architectures that handle DMA-non-coherent memory need to set
	    ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is
	    DMA-safe: the buffer doesn't share a cache with the others.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---

 arch/frv/include/asm/cache.h      |    2 --
 arch/frv/include/asm/mem-layout.h |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/arch/frv/include/asm/cache.h b/arch/frv/include/asm/cache.h
index 7dc0f0f..2797163 100644
--- a/arch/frv/include/asm/cache.h
+++ b/arch/frv/include/asm/cache.h
@@ -17,8 +17,6 @@
 #define L1_CACHE_SHIFT		(CONFIG_FRV_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
-
 #define __cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
 #define ____cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
 
diff --git a/arch/frv/include/asm/mem-layout.h b/arch/frv/include/asm/mem-layout.h
index 2947764..ccae981 100644
--- a/arch/frv/include/asm/mem-layout.h
+++ b/arch/frv/include/asm/mem-layout.h
@@ -35,8 +35,8 @@
  * the slab must be aligned such that load- and store-double instructions don't
  * fault if used
  */
-#define	ARCH_KMALLOC_MINALIGN		8
-#define	ARCH_SLAB_MINALIGN		8
+#define	ARCH_KMALLOC_MINALIGN		L1_CACHE_BYTES
+#define	ARCH_SLAB_MINALIGN		L1_CACHE_BYTES
 
 /*****************************************************************************/
 /*

