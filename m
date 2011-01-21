Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1AUPhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:37:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:35770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab1AUPhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:37:11 -0500
Date: Fri, 21 Jan 2011 15:36:46 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <1295523136-4277-2-git-send-email-akinobu.mita@gmail.com>
References: <1295523136-4277-2-git-send-email-akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Use asm-generic/cacheflush.h
Message-ID: <tip-cc67ba6352ecbf6891083a18f8c78fa639ebd274@git.kernel.org>
Git-Commit-ID: cc67ba6352ecbf6891083a18f8c78fa639ebd274
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 Jan 2011 15:36:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc67ba6352ecbf6891083a18f8c78fa639ebd274
Gitweb:     http://git.kernel.org/tip/cc67ba6352ecbf6891083a18f8c78fa639ebd274
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Thu, 20 Jan 2011 20:32:14 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Jan 2011 14:11:12 +0100

x86: Use asm-generic/cacheflush.h

The implementation of the cache flushing interfaces on the x86
is identical with the default implementation in asm-generic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: arnd@arndb.de
LKML-Reference: <1295523136-4277-2-git-send-email-akinobu.mita@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
