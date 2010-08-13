Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0HMHhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:37:36 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:38590 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0HMHhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:37:32 -0400
Date: Fri, 13 Aug 2010 09:39:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dma-mapping: fix build errors on !HAS_DMA architectures
Message-ID: <20100813073918.GA3315@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 4565f0170dfc849b3629c27d769db800467baa62 "dma-mapping: unify
dma_get_cache_alignment implementations" causes build errors on
!HAS_DMA architectures/platforms like s390 and sun3:

include/linux/dma-mapping.h:145: error: static declaration of 'dma_get_cache_alignment' follows non-static declaration
include/asm-generic/dma-mapping-broken.h:73: error: previous declaration of 'dma_get_cache_alignment' was here

Fix this by adding an explicit ifdef.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/dma-mapping.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -142,6 +142,7 @@ static inline int dma_set_seg_boundary(s
 		return -EIO;
 }
 
+#ifdef CONFIG_HAS_DMA
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_DMA_MINALIGN
@@ -149,6 +150,7 @@ static inline int dma_get_cache_alignmen
 #endif
 	return 1;
 }
+#endif
 
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
