Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2BJFlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:41:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2BJFlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:41:53 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Heechul Yun <heechul@illinois.edu>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/60] arm: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:24 +0800
Message-Id: <1328852421-19678-4-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/arm/mm/copypage-fa.c       |   12 ++++++------
 arch/arm/mm/copypage-feroceon.c |   12 ++++++------
 arch/arm/mm/copypage-v3.c       |   12 ++++++------
 arch/arm/mm/copypage-v4mc.c     |    8 ++++----
 arch/arm/mm/copypage-v4wb.c     |   12 ++++++------
 arch/arm/mm/copypage-v4wt.c     |   12 ++++++------
 arch/arm/mm/copypage-v6.c       |   12 ++++++------
 arch/arm/mm/copypage-xsc3.c     |   12 ++++++------
 arch/arm/mm/copypage-xscale.c   |    8 ++++----
 9 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/arch/arm/mm/copypage-fa.c b/arch/arm/mm/copypage-fa.c
index d2852e1..d130a5e 100644
--- a/arch/arm/mm/copypage-fa.c
+++ b/arch/arm/mm/copypage-fa.c
@@ -44,11 +44,11 @@ void fa_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic(to);
+	kfrom = kmap_atomic(from);
 	fa_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kunmap_atomic(kfrom);
+	kunmap_atomic(kto);
 }
 
 /*
@@ -58,7 +58,7 @@ void fa_copy_user_highpage(struct page *to, struct page *from,
  */
 void fa_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -77,7 +77,7 @@ void fa_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns fa_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-feroceon.c b/arch/arm/mm/copypage-feroceon.c
index ac163de..49ee0c1 100644
--- a/arch/arm/mm/copypage-feroceon.c
+++ b/arch/arm/mm/copypage-feroceon.c
@@ -72,17 +72,17 @@ void feroceon_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic(to);
+	kfrom = kmap_atomic(from);
 	flush_cache_page(vma, vaddr, page_to_pfn(from));
 	feroceon_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kunmap_atomic(kfrom);
+	kunmap_atomic(kto);
 }
 
 void feroceon_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile ("\
 	mov	r1, %2				\n\
 	mov	r2, #0				\n\
@@ -102,7 +102,7 @@ void feroceon_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3", "r4", "r5", "r6", "r7", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns feroceon_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-v3.c b/arch/arm/mm/copypage-v3.c
index f72303e..3935bdd 100644
--- a/arch/arm/mm/copypage-v3.c
+++ b/arch/arm/mm/copypage-v3.c
@@ -42,11 +42,11 @@ void v3_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic(to);
+	kfrom = kmap_atomic(from);
 	v3_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kunmap_atomic(kfrom);
+	kunmap_atomic(kto);
 }
 
 /*
@@ -56,7 +56,7 @@ void v3_copy_user_highpage(struct page *to, struct page *from,
  */
 void v3_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile("\n\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -72,7 +72,7 @@ void v3_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns v3_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-v4mc.c b/arch/arm/mm/copypage-v4mc.c
index 7d0a8c2..ec8c3be 100644
--- a/arch/arm/mm/copypage-v4mc.c
+++ b/arch/arm/mm/copypage-v4mc.c
@@ -71,7 +71,7 @@ mc_copy_user_page(void *from, void *to)
 void v4_mc_copy_user_highpage(struct page *to, struct page *from,
 	unsigned long vaddr, struct vm_area_struct *vma)
 {
-	void *kto = kmap_atomic(to, KM_USER1);
+	void *kto = kmap_atomic(to);
 
 	if (!test_and_set_bit(PG_dcache_clean, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
@@ -85,7 +85,7 @@ void v4_mc_copy_user_highpage(struct page *to, struct page *from,
 
 	raw_spin_unlock(&minicache_lock);
 
-	kunmap_atomic(kto, KM_USER1);
+	kunmap_atomic(kto);
 }
 
 /*
@@ -93,7 +93,7 @@ void v4_mc_copy_user_highpage(struct page *to, struct page *from,
  */
 void v4_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -111,7 +111,7 @@ void v4_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns v4_mc_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-v4wb.c b/arch/arm/mm/copypage-v4wb.c
index cb589cb..067d0fd 100644
--- a/arch/arm/mm/copypage-v4wb.c
+++ b/arch/arm/mm/copypage-v4wb.c
@@ -52,12 +52,12 @@ void v4wb_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic(to);
+	kfrom = kmap_atomic(from);
 	flush_cache_page(vma, vaddr, page_to_pfn(from));
 	v4wb_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kunmap_atomic(kfrom);
+	kunmap_atomic(kto);
 }
 
 /*
@@ -67,7 +67,7 @@ void v4wb_copy_user_highpage(struct page *to, struct page *from,
  */
 void v4wb_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -86,7 +86,7 @@ void v4wb_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns v4wb_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-v4wt.c b/arch/arm/mm/copypage-v4wt.c
index 30c7d04..b85c5da 100644
--- a/arch/arm/mm/copypage-v4wt.c
+++ b/arch/arm/mm/copypage-v4wt.c
@@ -48,11 +48,11 @@ void v4wt_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic(to);
+	kfrom = kmap_atomic(from);
 	v4wt_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kunmap_atomic(kfrom);
+	kunmap_atomic(kto);
 }
 
 /*
@@ -62,7 +62,7 @@ void v4wt_copy_user_highpage(struct page *to, struct page *from,
  */
 void v4wt_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile("\
 	mov	r1, %2				@ 1\n\
 	mov	r2, #0				@ 1\n\
@@ -79,7 +79,7 @@ void v4wt_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 64)
 	: "r1", "r2", "r3", "ip", "lr");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns v4wt_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
index 3d9a155..8b03a58 100644
--- a/arch/arm/mm/copypage-v6.c
+++ b/arch/arm/mm/copypage-v6.c
@@ -38,11 +38,11 @@ static void v6_copy_user_highpage_nonaliasing(struct page *to,
 {
 	void *kto, *kfrom;
 
-	kfrom = kmap_atomic(from, KM_USER0);
-	kto = kmap_atomic(to, KM_USER1);
+	kfrom = kmap_atomic(from);
+	kto = kmap_atomic(to);
 	copy_page(kto, kfrom);
-	kunmap_atomic(kto, KM_USER1);
-	kunmap_atomic(kfrom, KM_USER0);
+	kunmap_atomic(kto);
+	kunmap_atomic(kfrom);
 }
 
 /*
@@ -51,9 +51,9 @@ static void v6_copy_user_highpage_nonaliasing(struct page *to,
  */
 static void v6_clear_user_highpage_nonaliasing(struct page *page, unsigned long vaddr)
 {
-	void *kaddr = kmap_atomic(page, KM_USER0);
+	void *kaddr = kmap_atomic(page);
 	clear_page(kaddr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 /*
diff --git a/arch/arm/mm/copypage-xsc3.c b/arch/arm/mm/copypage-xsc3.c
index f9cde07..03a2042 100644
--- a/arch/arm/mm/copypage-xsc3.c
+++ b/arch/arm/mm/copypage-xsc3.c
@@ -75,12 +75,12 @@ void xsc3_mc_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto, *kfrom;
 
-	kto = kmap_atomic(to, KM_USER0);
-	kfrom = kmap_atomic(from, KM_USER1);
+	kto = kmap_atomic(to);
+	kfrom = kmap_atomic(from);
 	flush_cache_page(vma, vaddr, page_to_pfn(from));
 	xsc3_mc_copy_user_page(kto, kfrom);
-	kunmap_atomic(kfrom, KM_USER1);
-	kunmap_atomic(kto, KM_USER0);
+	kunmap_atomic(kfrom);
+	kunmap_atomic(kto);
 }
 
 /*
@@ -90,7 +90,7 @@ void xsc3_mc_copy_user_highpage(struct page *to, struct page *from,
  */
 void xsc3_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile ("\
 	mov	r1, %2				\n\
 	mov	r2, #0				\n\
@@ -105,7 +105,7 @@ void xsc3_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns xsc3_mc_user_fns __initdata = {
diff --git a/arch/arm/mm/copypage-xscale.c b/arch/arm/mm/copypage-xscale.c
index 610c24c..439d106 100644
--- a/arch/arm/mm/copypage-xscale.c
+++ b/arch/arm/mm/copypage-xscale.c
@@ -93,7 +93,7 @@ mc_copy_user_page(void *from, void *to)
 void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
 	unsigned long vaddr, struct vm_area_struct *vma)
 {
-	void *kto = kmap_atomic(to, KM_USER1);
+	void *kto = kmap_atomic(to);
 
 	if (!test_and_set_bit(PG_dcache_clean, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
@@ -107,7 +107,7 @@ void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
 
 	raw_spin_unlock(&minicache_lock);
 
-	kunmap_atomic(kto, KM_USER1);
+	kunmap_atomic(kto);
 }
 
 /*
@@ -116,7 +116,7 @@ void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
 void
 xscale_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 {
-	void *ptr, *kaddr = kmap_atomic(page, KM_USER0);
+	void *ptr, *kaddr = kmap_atomic(page);
 	asm volatile(
 	"mov	r1, %2				\n\
 	mov	r2, #0				\n\
@@ -133,7 +133,7 @@ xscale_mc_clear_user_highpage(struct page *page, unsigned long vaddr)
 	: "=r" (ptr)
 	: "0" (kaddr), "I" (PAGE_SIZE / 32)
 	: "r1", "r2", "r3", "ip");
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 
 struct cpu_user_fns xscale_mc_user_fns __initdata = {
-- 
1.7.7.6

