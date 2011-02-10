Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1BJE6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:58:10 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37533 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab1BJE6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ch2DEcfC6HKmqX163M7OVuMe+Woxvxhe/OpjSOuNxXt/jMnMEL3odjJNxeFPRPnukd
         x8qwbZwdSXhLxVhI5o+UNOSYhUNcYUMCywXHhWTxS+27R0Bk77qp1EtAowVdxq6v8qO7
         LCcn3fPU4kAIX6BI+pzxVzPlT/1ksKOsVvAxw=
From: Ryota Ozaki <ozaki.ryota@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH v2] mm: Fix out-of-date comments which refers non-existent functions
Date: Thu, 10 Feb 2011 13:56:28 +0900
Message-Id: <1297313788-10905-1-git-send-email-ozaki.ryota@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryota Ozaki <ozaki.ryota@gmail.com>

do_file_page and do_no_page don't exist anymore, but some comments
still refers them. The patch fixes them by replacing them with
existing ones.

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Kosina <trivial@kernel.org>
---
 arch/alpha/include/asm/cacheflush.h |    2 +-
 arch/avr32/mm/cache.c               |    2 +-
 mm/memory.c                         |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

Change from v1: Fix two files other than mm/memory.c as well.

diff --git a/arch/alpha/include/asm/cacheflush.h b/arch/alpha/include/asm/cacheflush.h
index 012f124..a9cb6aa 100644
--- a/arch/alpha/include/asm/cacheflush.h
+++ b/arch/alpha/include/asm/cacheflush.h
@@ -63,7 +63,7 @@ extern void flush_icache_user_range(struct vm_area_struct *vma,
 		struct page *page, unsigned long addr, int len);
 #endif
 
-/* This is used only in do_no_page and do_swap_page.  */
+/* This is used only in __do_fault and do_swap_page.  */
 #define flush_icache_page(vma, page) \
   flush_icache_user_range((vma), (page), 0, 0)
 
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index 24a74d1..6a46ecd 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -113,7 +113,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 }
 
 /*
- * This one is called from do_no_page(), do_swap_page() and install_page().
+ * This one is called from __do_fault() and do_swap_page().
  */
 void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 31250fa..3fbf32a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2115,10 +2115,10 @@ EXPORT_SYMBOL_GPL(apply_to_page_range);
  * handle_pte_fault chooses page fault handler according to an entry
  * which was read non-atomically.  Before making any commitment, on
  * those architectures or configurations (e.g. i386 with PAE) which
- * might give a mix of unmatched parts, do_swap_page and do_file_page
+ * might give a mix of unmatched parts, do_swap_page and do_nonlinear_fault
  * must check under lock before unmapping the pte and proceeding
  * (but do_wp_page is only called after already making such a check;
- * and do_anonymous_page and do_no_page can safely check later on).
+ * and do_anonymous_page can safely check later on).
  */
 static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
 				pte_t *page_table, pte_t orig_pte)
@@ -2316,7 +2316,7 @@ reuse:
 		 * bit after it clear all dirty ptes, but before a racing
 		 * do_wp_page installs a dirty pte.
 		 *
-		 * do_no_page is protected similarly.
+		 * __do_fault is protected similarly.
 		 */
 		if (!page_mkwrite) {
 			wait_on_page_locked(dirty_page);
-- 
1.7.2.3

