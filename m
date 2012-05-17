Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653Ab2EQKzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:55:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60161 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405Ab2EQKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:55:08 -0400
Date: Thu, 17 May 2012 12:54:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv2 3/4] mm: vmalloc: add VM_DMA flag to indicate areas used by
 dma-mapping framework
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
Message-id: <1337252085-22039-4-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.10.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new type of vm_area intented to be used for consisten mappings
created by dma-mapping framework.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 6071e91..8a9555a 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -14,6 +14,7 @@ struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 #define VM_USERMAP	0x00000008	/* suitable for remap_vmalloc_range */
 #define VM_VPAGES	0x00000010	/* buffer for pages was vmalloc'ed */
 #define VM_UNLIST	0x00000020	/* vm_struct is not listed in vmlist */
+#define VM_DMA		0x00000040	/* used by dma-mapping framework */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 8cb7f22..9c13bab 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2582,6 +2582,9 @@ static int s_show(struct seq_file *m, void *p)
 	if (v->flags & VM_IOREMAP)
 		seq_printf(m, " ioremap");
 
+	if (v->flags & VM_DMA)
+		seq_printf(m, " dma");
+
 	if (v->flags & VM_ALLOC)
 		seq_printf(m, " vmalloc");
 
-- 
1.7.10.1

