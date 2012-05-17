Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328Ab2EQQyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:54:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29313 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760372Ab2EQQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:53:28 -0400
Date: Thu, 17 May 2012 18:53:04 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/3] common: DMA-mapping: add DMA_ATTR_NO_KERNEL_MAPPING
 attribute
In-reply-to: <1337273586-11089-1-git-send-email-m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Abhinav Kochhar <abhinav.k@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1337273586-11089-2-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.10.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337273586-11089-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMA_ATTR_NO_KERNEL_MAPPING attribute which lets the
platform to avoid creating a kernel virtual mapping for the allocated
buffer. On some architectures creating such mapping is non-trivial task
and consumes very limited resources (like kernel virtual address space
or dma consistent address space). Buffers allocated with this attribute
can be only passed to user space by calling dma_mmap_attrs().

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/DMA-attributes.txt |   18 ++++++++++++++++++
 include/linux/dma-attrs.h        |    1 +
 2 files changed, 19 insertions(+)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 5c72eed..725580d 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -49,3 +49,21 @@ DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
 consistent or non-consistent memory as it sees fit.  By using this API,
 you are guaranteeing to the platform that you have all the correct and
 necessary sync points for this memory in the driver.
+
+DMA_ATTR_NO_KERNEL_MAPPING
+--------------------------
+
+DMA_ATTR_NO_KERNEL_MAPPING lets the platform to avoid creating a kernel
+virtual mapping for the allocated buffer. On some architectures creating
+such mapping is non-trivial task and consumes very limited resources
+(like kernel virtual address space or dma consistent address space).
+Buffers allocated with this attribute can be only passed to user space
+by calling dma_mmap_attrs(). By using this API, you are guaranteeing
+that you won't dereference the pointer returned by dma_alloc_attr(). You
+can threat it as a cookie that must be passed to dma_mmap_attrs() and
+dma_free_attrs(). Make sure that both of these also get this attribute
+set on each call.
+
+Since it is optional for platforms to implement
+DMA_ATTR_NO_KERNEL_MAPPING, those that do not will simply ignore the
+attribute and exhibit default behavior.
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index 547ab56..a37c10c 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -15,6 +15,7 @@ enum dma_attr {
 	DMA_ATTR_WEAK_ORDERING,
 	DMA_ATTR_WRITE_COMBINE,
 	DMA_ATTR_NON_CONSISTENT,
+	DMA_ATTR_NO_KERNEL_MAPPING,
 	DMA_ATTR_MAX,
 };
 
-- 
1.7.10.1

