Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0HLJEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:04:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33057 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0HLJEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:04:45 -0400
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        jdike@addtoit.com
Subject: [PATCH] uml: fix compile error in dma_get_cache_alignment()
Message-Id: <E1OjTiF-0001KI-Rx@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 12 Aug 2010 11:04:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix uml compile error:

include/linux/dma-mapping.h:145: error: redefinition of 'dma_get_cache_alignment'
/store/git/linux-2.6/arch/um/include/asm/dma-mapping.h:99: note: previous definition of 'dma_get_cache_alignment' was here

Introduced by this commit:

commit 4565f0170dfc849b3629c27d769db800467baa62
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Aug 10 18:03:22 2010 -0700

    dma-mapping: unify dma_get_cache_alignment implementations

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 arch/um/include/asm/dma-mapping.h |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6/arch/um/include/asm/dma-mapping.h
===================================================================
--- linux-2.6.orig/arch/um/include/asm/dma-mapping.h	2010-08-12 09:32:16.000000000 +0200
+++ linux-2.6/arch/um/include/asm/dma-mapping.h	2010-08-12 10:14:12.000000000 +0200
@@ -95,13 +95,6 @@ dma_sync_sg_for_cpu(struct device *dev,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-static inline int
-dma_get_cache_alignment(void)
-{
-	BUG();
-	return(0);
-}
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
