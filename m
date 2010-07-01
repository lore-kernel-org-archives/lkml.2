Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab0GAVq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:46:58 -0400
Received: from kroah.org ([198.145.64.141]:32780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805Ab0GAVOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:09 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:55 2010
Message-Id: <20100701174254.954465277@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Chris Zankel <chris@zankel.net>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [101/200] xtensa: set ARCH_KMALLOC_MINALIGN
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 498900fc9cd1adbad1ba6b55ed9d8f2f5d655ca3 upstream.

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe: the
buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/xtensa/include/asm/cache.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/xtensa/include/asm/cache.h
+++ b/arch/xtensa/include/asm/cache.h
@@ -29,5 +29,6 @@
 # define CACHE_WAY_SIZE ICACHE_WAY_SIZE
 #endif
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
 
 #endif	/* _XTENSA_CACHE_H */


