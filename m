Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab0GAWII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:08:08 -0400
Received: from kroah.org ([198.145.64.141]:47547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692Ab0GAUu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:27 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:33 2010
Message-Id: <20100701173433.129957748@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       David Howells <dhowells@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 075/164] frv: set ARCH_KMALLOC_MINALIGN
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 69dcf3db03626c4f18de624e8632454ea12ff260 upstream.

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe: the
buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/frv/include/asm/cache.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/frv/include/asm/cache.h
+++ b/arch/frv/include/asm/cache.h
@@ -17,6 +17,8 @@
 #define L1_CACHE_SHIFT		(CONFIG_FRV_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+
 #define __cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
 #define ____cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
 


