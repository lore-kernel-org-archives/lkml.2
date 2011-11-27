Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1K0FaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:30:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1K0FaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:30:06 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>, Stuart Menefy <stuart.menefy@st.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH 06/62] sh: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:46 +0800
Message-Id: <1322371662-26166-7-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/sh/mm/cache-sh4.c |    4 ++--
 arch/sh/mm/cache.c     |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/sh/mm/cache-sh4.c b/arch/sh/mm/cache-sh4.c
index 92eb986..112fea1 100644
--- a/arch/sh/mm/cache-sh4.c
+++ b/arch/sh/mm/cache-sh4.c
@@ -244,7 +244,7 @@ static void sh4_flush_cache_page(void *args)
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
 		else
-			vaddr = kmap_atomic(page, KM_USER0);
+			vaddr = kmap_atomic(page);
 
 		address = (unsigned long)vaddr;
 	}
@@ -259,7 +259,7 @@ static void sh4_flush_cache_page(void *args)
 		if (map_coherent)
 			kunmap_coherent(vaddr);
 		else
-			kunmap_atomic(vaddr, KM_USER0);
+			kunmap_atomic(vaddr);
 	}
 }
 
diff --git a/arch/sh/mm/cache.c b/arch/sh/mm/cache.c
index 5a580ea..616966a 100644
--- a/arch/sh/mm/cache.c
+++ b/arch/sh/mm/cache.c
@@ -95,7 +95,7 @@ void copy_user_highpage(struct page *to, struct page *from,
 {
 	void *vfrom, *vto;
 
-	vto = kmap_atomic(to, KM_USER1);
+	vto = kmap_atomic(to);
 
 	if (boot_cpu_data.dcache.n_aliases && page_mapped(from) &&
 	    test_bit(PG_dcache_clean, &from->flags)) {
@@ -103,16 +103,16 @@ void copy_user_highpage(struct page *to, struct page *from,
 		copy_page(vto, vfrom);
 		kunmap_coherent(vfrom);
 	} else {
-		vfrom = kmap_atomic(from, KM_USER0);
+		vfrom = kmap_atomic(from);
 		copy_page(vto, vfrom);
-		kunmap_atomic(vfrom, KM_USER0);
+		kunmap_atomic(vfrom);
 	}
 
 	if (pages_do_alias((unsigned long)vto, vaddr & PAGE_MASK) ||
 	    (vma->vm_flags & VM_EXEC))
 		__flush_purge_region(vto, PAGE_SIZE);
 
-	kunmap_atomic(vto, KM_USER1);
+	kunmap_atomic(vto);
 	/* Make sure this page is cleared on other CPU's too before using it */
 	smp_wmb();
 }
@@ -120,14 +120,14 @@ EXPORT_SYMBOL(copy_user_highpage);
 
 void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic(page);
 
 	clear_page(kaddr);
 
 	if (pages_do_alias((unsigned long)kaddr, vaddr & PAGE_MASK))
 		__flush_purge_region(kaddr, PAGE_SIZE);
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 EXPORT_SYMBOL(clear_user_highpage);
 
-- 
1.7.4.4

