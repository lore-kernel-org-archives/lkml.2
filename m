Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1ATLcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:32:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37737 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab1ATLbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FhBrXmYUOgk/FarLaUUs31h1v0t0Dcgn6AlmcPPYhz/LT8fpnDcMQK9Z8bxz6w0baS
         btCA/b1uBzWh7/5ibUBr0bh3d/f+5L86Q4M3wgaF4nLtkFnFQxkYweMf21Qzzuz++2m3
         kk27ZjVwRAqFz6DjWd+QJqnmkzCYGSZPdd2Lg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH] h8300: use asm-generic/cacheflush.h
Date: Thu, 20 Jan 2011 20:32:15 +0900
Message-Id: <1295523136-4277-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295523136-4277-1-git-send-email-akinobu.mita@gmail.com>
References: <1295523136-4277-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of the cache flushing interfaces on the h8300
is identical with the default implementation in asm-generic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/include/asm/cacheflush.h |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/arch/h8300/include/asm/cacheflush.h b/arch/h8300/include/asm/cacheflush.h
index 4cf2df2..46fddd6 100644
--- a/arch/h8300/include/asm/cacheflush.h
+++ b/arch/h8300/include/asm/cacheflush.h
@@ -9,32 +9,13 @@
  * Cache handling functions
  * No Cache memory all dummy functions
  */
+#include <asm-generic/cacheflush.h>
 
-#define flush_cache_all()
-#define	flush_cache_mm(mm)
-#define	flush_cache_dup_mm(mm)		do { } while (0)
-#define	flush_cache_range(vma,a,b)
-#define	flush_cache_page(vma,p,pfn)
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-#define	flush_dcache_page(page)
-#define	flush_dcache_mmap_lock(mapping)
-#define	flush_dcache_mmap_unlock(mapping)
 #define	flush_icache()
-#define	flush_icache_page(vma,page)
-#define	flush_icache_range(start,len)
-#define flush_cache_vmap(start, end)
-#define flush_cache_vunmap(start, end)
 #define	cache_push_v(vaddr,len)
 #define	cache_push(paddr,len)
 #define	cache_clear(paddr,len)
 
 #define	flush_dcache_range(a,b)
 
-#define	flush_icache_user_range(vma,page,addr,len)
-
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
-
 #endif /* _ASM_H8300_CACHEFLUSH_H */
-- 
1.7.3.4

