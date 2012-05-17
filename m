Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682Ab2EQK4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:56:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60161 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760981Ab2EQKzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:55:05 -0400
Date: Thu, 17 May 2012 12:54:43 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv2 2/4] mm: vmalloc: export find_vm_area() function
In-reply-to: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>
Message-id: <1337252085-22039-3-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.10.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_vm_area() function is usefull for other core subsystems (like
dma-mapping) to get access to vm_area internals.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 2e28f4d..6071e91 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -93,6 +93,7 @@ extern struct vm_struct *__get_vm_area_caller(unsigned long size,
 					unsigned long start, unsigned long end,
 					const void *caller);
 extern struct vm_struct *remove_vm_area(const void *addr);
+extern struct vm_struct *find_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
 			struct page ***pages);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 8bc7f3ef..8cb7f22 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1402,7 +1402,15 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 						-1, GFP_KERNEL, caller);
 }
 
-static struct vm_struct *find_vm_area(const void *addr)
+/**
+ *	find_vm_area  -  find a continuous kernel virtual area
+ *	@addr:		base address
+ *
+ *	Search for the kernel VM area starting at @addr, and return it.
+ *	It is up to the caller to do all required locking to keep the returned
+ *	pointer valid.
+ */
+struct vm_struct *find_vm_area(const void *addr)
 {
 	struct vmap_area *va;
 
-- 
1.7.10.1

