Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2FYIsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:48:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31803 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2FYIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:47:59 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-7c-4fe825bedae2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCHv4 1/2] mm: vmalloc: use const void * for caller argument
Date: Mon, 25 Jun 2012 10:47:26 +0200
Message-id: <1340614047-5824-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1340614047-5824-1-git-send-email-m.szyprowski@samsung.com>
References: <1340614047-5824-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jQd19qi/8DZ6vFrG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ7xdNYyxYpF6xu+0NUwPjHPkuRk4OCQETiZ0nNjFD2GISF+6t
	Z+ti5OIQEpjOKHHj81FGCGc1k8TOpydYQarYBAwlut52AVVxcIgI1EjMmwFWwywwl1ni3s6f
	7CA1wgIeEicf3WUCsVkEVCU+LXwCZvMKuEtM3PaYDWKbvMTT+31gNidQ/c7761hAbCGgmjl/
	5jJOYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyPY58+kdjCubLA4xCjAwajEw9sg
	9cJfiDWxrLgy9xCjBAezkggvByNQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+T9QV/IYH0xJLU
	7NTUgtQimCwTB6dUA+OUKg3nVFnhGcdjVs/7u2KhkHTczij2VplUngDFNys93V7Nu1m1NPit
	kUZganDhobzuT/FrJxgyxUQLbNEycto42+RG8TrJnWLuMtWTHYWWfzE57KZ15sGT560s75qW
	fQxac/HxlQ8HjvCFfbExl9kxs/nJj9/ckjufJJ6PMDR5vvp5U1vCk5dKLMUZiYZazEXFiQAQ
	f5RB9QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'const void *' is a safer type for caller function type. This patch
updates all references to caller function type.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/vmalloc.h |    8 ++++----
 mm/vmalloc.c            |   18 +++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index dcdfc2b..2e28f4d 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -32,7 +32,7 @@ struct vm_struct {
 	struct page		**pages;
 	unsigned int		nr_pages;
 	phys_addr_t		phys_addr;
-	void			*caller;
+	const void		*caller;
 };
 
 /*
@@ -62,7 +62,7 @@ extern void *vmalloc_32_user(unsigned long size);
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
 extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
-			pgprot_t prot, int node, void *caller);
+			pgprot_t prot, int node, const void *caller);
 extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
@@ -85,13 +85,13 @@ static inline size_t get_vm_area_size(const struct vm_struct *area)
 
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
 extern struct vm_struct *get_vm_area_caller(unsigned long size,
-					unsigned long flags, void *caller);
+					unsigned long flags, const void *caller);
 extern struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 					unsigned long start, unsigned long end);
 extern struct vm_struct *__get_vm_area_caller(unsigned long size,
 					unsigned long flags,
 					unsigned long start, unsigned long end,
-					void *caller);
+					const void *caller);
 extern struct vm_struct *remove_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2aad499..11308f0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1280,7 +1280,7 @@ DEFINE_RWLOCK(vmlist_lock);
 struct vm_struct *vmlist;
 
 static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
-			      unsigned long flags, void *caller)
+			      unsigned long flags, const void *caller)
 {
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
@@ -1306,7 +1306,7 @@ static void insert_vmalloc_vmlist(struct vm_struct *vm)
 }
 
 static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
-			      unsigned long flags, void *caller)
+			      unsigned long flags, const void *caller)
 {
 	setup_vmalloc_vm(vm, va, flags, caller);
 	insert_vmalloc_vmlist(vm);
@@ -1314,7 +1314,7 @@ static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
 		unsigned long align, unsigned long flags, unsigned long start,
-		unsigned long end, int node, gfp_t gfp_mask, void *caller)
+		unsigned long end, int node, gfp_t gfp_mask, const void *caller)
 {
 	struct vmap_area *va;
 	struct vm_struct *area;
@@ -1375,7 +1375,7 @@ EXPORT_SYMBOL_GPL(__get_vm_area);
 
 struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
 				       unsigned long start, unsigned long end,
-				       void *caller)
+				       const void *caller)
 {
 	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 				  caller);
@@ -1397,7 +1397,7 @@ struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 }
 
 struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
-				void *caller)
+				const void *caller)
 {
 	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
 						-1, GFP_KERNEL, caller);
@@ -1568,9 +1568,9 @@ EXPORT_SYMBOL(vmap);
 
 static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
-			    int node, void *caller);
+			    int node, const void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
-				 pgprot_t prot, int node, void *caller)
+				 pgprot_t prot, int node, const void *caller)
 {
 	const int order = 0;
 	struct page **pages;
@@ -1643,7 +1643,7 @@ fail:
  */
 void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
-			pgprot_t prot, int node, void *caller)
+			pgprot_t prot, int node, const void *caller)
 {
 	struct vm_struct *area;
 	void *addr;
@@ -1699,7 +1699,7 @@ fail:
  */
 static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
-			    int node, void *caller)
+			    int node, const void *caller)
 {
 	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
 				gfp_mask, prot, node, caller);
-- 
1.7.1.569.g6f426

