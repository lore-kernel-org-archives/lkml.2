Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1ATLbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:31:53 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52036 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1ATLbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:31:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AUUl5GxDZSm1jsrKDpVxw6X6kUWMUlh1ypbgreCQuvcVEz0xRQBYgFEH5iaaE38dip
         VMGhT65xUf72usqRcK3vl8I40o46bhzpaDGt8eLD2vD4W89E810FVJzV+XuCTthfmnrO
         K42JMacLotjQV9cDVgKe5Q846vHQ9TuYTKc2g=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86: use asm-generic/cacheflush.h
Date: Thu, 20 Jan 2011 20:32:14 +0900
Message-Id: <1295523136-4277-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295523136-4277-1-git-send-email-akinobu.mita@gmail.com>
References: <1295523136-4277-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of the cache flushing interfaces on the x86
is identical with the default implementation in asm-generic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/cacheflush.h |   42 +------------------------------------
 1 files changed, 1 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 63e35ec..62f0844 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -1,48 +1,8 @@
 #ifndef _ASM_X86_CACHEFLUSH_H
 #define _ASM_X86_CACHEFLUSH_H
 
-/* Keep includes the same across arches.  */
-#include <linux/mm.h>
-
 /* Caches aren't brain-dead on the intel. */
-static inline void flush_cache_all(void) { }
-static inline void flush_cache_mm(struct mm_struct *mm) { }
-static inline void flush_cache_dup_mm(struct mm_struct *mm) { }
-static inline void flush_cache_range(struct vm_area_struct *vma,
-				     unsigned long start, unsigned long end) { }
-static inline void flush_cache_page(struct vm_area_struct *vma,
-				    unsigned long vmaddr, unsigned long pfn) { }
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-static inline void flush_dcache_page(struct page *page) { }
-static inline void flush_dcache_mmap_lock(struct address_space *mapping) { }
-static inline void flush_dcache_mmap_unlock(struct address_space *mapping) { }
-static inline void flush_icache_range(unsigned long start,
-				      unsigned long end) { }
-static inline void flush_icache_page(struct vm_area_struct *vma,
-				     struct page *page) { }
-static inline void flush_icache_user_range(struct vm_area_struct *vma,
-					   struct page *page,
-					   unsigned long addr,
-					   unsigned long len) { }
-static inline void flush_cache_vmap(unsigned long start, unsigned long end) { }
-static inline void flush_cache_vunmap(unsigned long start,
-				      unsigned long end) { }
-
-static inline void copy_to_user_page(struct vm_area_struct *vma,
-				     struct page *page, unsigned long vaddr,
-				     void *dst, const void *src,
-				     unsigned long len)
-{
-	memcpy(dst, src, len);
-}
-
-static inline void copy_from_user_page(struct vm_area_struct *vma,
-				       struct page *page, unsigned long vaddr,
-				       void *dst, const void *src,
-				       unsigned long len)
-{
-	memcpy(dst, src, len);
-}
+#include <asm-generic/cacheflush.h>
 
 #ifdef CONFIG_X86_PAT
 /*
-- 
1.7.3.4

