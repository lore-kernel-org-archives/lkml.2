Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2G3I2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:28:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25374 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab2G3I2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:28:37 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-f2-501645b4d315
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
Subject: [PATCHv6 1/2] mm: vmalloc: use const void * for caller argument
Date: Mon, 30 Jul 2012 10:28:18 +0200
Message-id: <1343636899-19508-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1343636899-19508-1-git-send-email-m.szyprowski@samsung.com>
References: <1343636899-19508-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t9jQd0trmIBBvtPqFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M94umMRYsUq/Y3faGqYFxjnwXIyeHhICJxNL591kgbDGJC/fW
	s3UxcnEICUxnlFj0cCIzhLOaSeJoyxVWkCo2AUOJrrddQFUcHCICNRLzZjCC1DALzGWWuLfz
	JztIjbCAh8SWj99YQWpYBFQl1tzVBwnzAoVv7/vDCLFMXuLp/T6wMZwCnhJP9qqAhIWASg49
	v8Q+gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYxgfz+T2sG4ssHiEKMAB6MSD6/h
	ZdEAIdbEsuLK3EOMEhzMSiK8k0TEAoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzGnt/9RcSSE8s
	Sc1OTS1ILYLJMnFwSjUwVnalNBs5T9kgr78sb+bGqKDL+puyU8tnb/Kft9f8od7T8jWplZ1H
	ppjq1GyT41n0fSJnoZTh1CMJR+Ir31hYFzGVMR8u7zrx8fGLdxIKRx0V9H6av11qYZb8Z8vD
	nmqTP9d2sR0IMtnXFd7SnGlfueMHc93kvBhGUZG5qzkzZ5qt+l7LvviVEktxRqKhFnNRcSIA
	TAK14fMBAAA=
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

