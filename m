Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2FMLCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:02:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13235 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2FMLCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:02:25 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-51-4fd8733f3c8f
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
Subject: [PATCHv3 2/3] mm: vmalloc: add VM_DMA flag to indicate areas used by
 dma-mapping framework
Date: Wed, 13 Jun 2012 13:01:45 +0200
Message-id: <1339585306-7147-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1339585306-7147-1-git-send-email-m.szyprowski@samsung.com>
References: <1339585306-7147-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jQV2H4hv+Bk8/MVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6ME9t5CjZwVfxc0szawLiDo4uRk0NCwERi3fzt7BC2mMSFe+vZ
	uhi5OIQEpjNK3Di4hwnCWc0kMW3KHEaQKjYBQ4mut11AVRwcIgI1EvNmMILUMAvMZZa4t/Mn
	2CRhgVSJJ5sXsoLYLAKqEldfnGUDsXkF3CWabl5khNgmL/H0fh9YnFPAQ+LDgRVg9UJANT+7
	e5knMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRHs8WdSOxhXNlgcYhTgYFTi4Y0o
	uOEvxJpYVlyZe4hRgoNZSYT3WTZQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+T9QV/IYH0xJLU
	7NTUgtQimCwTB6dUA+PF9in35fssunx3tbuya8U0cd+cu3eJa2fe04vVC6anzbzwu+e9jMX1
	R9Z36soMxa19lG/P1ZavPzlfJfzB0Quf35Qlbyj19LhybMmG/ZsiDSv/XnmpauYd5NX8mOH/
	T4WNS2oO1a5SWnT411O+BSs8f6+/wsupWOd/NmeJjFPTRZ3OIKbSuMNKLMUZiYZazEXFiQB3
	1WxM9AEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new type of vm_area intented to be used for mappings created by
dma-mapping framework.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 2e28f4d..e725b7b 100644
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
index 11308f0..e04d59b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2575,6 +2575,9 @@ static int s_show(struct seq_file *m, void *p)
 	if (v->flags & VM_IOREMAP)
 		seq_printf(m, " ioremap");
 
+	if (v->flags & VM_DMA)
+		seq_printf(m, " dma");
+
 	if (v->flags & VM_ALLOC)
 		seq_printf(m, " vmalloc");
 
-- 
1.7.1.569.g6f426

