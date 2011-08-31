Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1HaVai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:30:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab1HaVac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:30:32 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 2/3] define ARM-specific dma_coherent_write_sync
Date: Wed, 31 Aug 2011 17:30:13 -0400
Message-Id: <1314826214-22428-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826214-22428-1-git-send-email-msalter@redhat.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ARM kernels using CONFIG_ARM_DMA_MEM_BUFFERABLE, this patch adds an ARM
specific dma_coherent_write_sync() to override the default version. This
routine forces out any data sitting in a write buffer between the CPU and
memory.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm/include/asm/dma-mapping.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 7a21d0b..e99562b 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -206,6 +206,16 @@ int dma_mmap_writecombine(struct device *, struct vm_area_struct *,
 		void *, dma_addr_t, size_t);
 
 
+#ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
+#define ARCH_HAS_DMA_COHERENT_WRITE_SYNC
+
+static inline void dma_coherent_write_sync(void)
+{
+	dsb();
+	outer_sync();
+}
+#endif
+
 #ifdef CONFIG_DMABOUNCE
 /*
  * For SA-1111, IXP425, and ADI systems  the dma-mapping functions are "magic"
-- 
1.7.6

