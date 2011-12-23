Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab1LWM2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:28:30 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53176 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828Ab1LWM2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:28:05 -0500
Date: Fri, 23 Dec 2011 13:27:31 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 12/14] common: dma-mapping: introduce mmap method
In-reply-to: <1324643253-3024-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        discuss@x86-64.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Jonathan Corbet <corbet@lwn.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1324643253-3024-13-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.7.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1324643253-3024-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new generic mmap method with attributes argument.

This method lets drivers to create a userspace mapping for a DMA buffer
in generic, architecture independent way.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/dma-mapping.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2fc413a..b903a20 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -15,6 +15,9 @@ struct dma_map_ops {
 	void (*free)(struct device *dev, size_t size,
 			      void *vaddr, dma_addr_t dma_handle,
 			      struct dma_attrs *attrs);
+	int (*mmap)(struct device *, struct vm_area_struct *,
+			  void *, dma_addr_t, size_t, struct dma_attrs *attrs);
+
 	dma_addr_t (*map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
-- 
1.7.1.569.g6f426

