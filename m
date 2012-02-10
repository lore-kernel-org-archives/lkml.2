Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2BJFlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:41:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab2BJFkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:40:51 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 02/60] include/linux/highmem.h: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:23 +0800
Message-Id: <1328852421-19678-3-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 include/linux/highmem.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 11617a8..284ec55 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -167,9 +167,9 @@ do {                                                            \
 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *addr = kmap_atomic(page, KM_USER0);
+	void *addr = kmap_atomic(page);
 	clear_user_page(addr, vaddr, page);
-	kunmap_atomic(addr, KM_USER0);
+	kunmap_atomic(addr);
 }
 #endif
 
@@ -220,16 +220,16 @@ alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
 
 static inline void clear_highpage(struct page *page)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic(page);
 	clear_page(kaddr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 static inline void zero_user_segments(struct page *page,
 	unsigned start1, unsigned end1,
 	unsigned start2, unsigned end2)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic(page);
 
 	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
 
@@ -239,7 +239,7 @@ static inline void zero_user_segments(struct page *page,
 	if (end2 > start2)
 		memset(kaddr + start2, 0, end2 - start2);
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	flush_dcache_page(page);
 }
 
@@ -268,11 +268,11 @@ static inline void copy_user_highpage(struct page *to, struct page *from,
 {
 	char *vfrom, *vto;
 
-	vfrom = kmap_atomic(from, KM_USER0);
-	vto = kmap_atomic(to, KM_USER1);
+	vfrom = kmap_atomic(from);
+	vto = kmap_atomic(to);
 	copy_user_page(vto, vfrom, vaddr, to);
-	kunmap_atomic(vto, KM_USER1);
-	kunmap_atomic(vfrom, KM_USER0);
+	kunmap_atomic(vto);
+	kunmap_atomic(vfrom);
 }
 
 #endif
@@ -281,11 +281,11 @@ static inline void copy_highpage(struct page *to, struct page *from)
 {
 	char *vfrom, *vto;
 
-	vfrom = kmap_atomic(from, KM_USER0);
-	vto = kmap_atomic(to, KM_USER1);
+	vfrom = kmap_atomic(from);
+	vto = kmap_atomic(to);
 	copy_page(vto, vfrom);
-	kunmap_atomic(vto, KM_USER1);
-	kunmap_atomic(vfrom, KM_USER0);
+	kunmap_atomic(vto);
+	kunmap_atomic(vfrom);
 }
 
 #endif /* _LINUX_HIGHMEM_H */
-- 
1.7.7.6

