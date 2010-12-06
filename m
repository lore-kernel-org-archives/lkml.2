Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0LFX1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:27:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27035 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0LFXZQ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/23] agp: Introduce two new macros: _agp_[alloc|free]_page.
Date: Mon,  6 Dec 2010 18:24:15 -0500
Message-Id: <1291677875-30493-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro will be used in the agp_generic_[alloc|destroy]_page[s|]
functions. Currently it does exactly what it replaces and also
saves the DMA address in dma_addr[] using the page_to_phys() macro.

These two macros can be at any time replaced with an implementation that
can utilize the PCI API.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/alpha/include/asm/agp.h   |   14 ++++++++++++++
 arch/ia64/include/asm/agp.h    |   15 +++++++++++++++
 arch/parisc/include/asm/agp.h  |   15 +++++++++++++++
 arch/powerpc/include/asm/agp.h |   15 +++++++++++++++
 arch/sparc/include/asm/agp.h   |   14 ++++++++++++++
 arch/x86/include/asm/agp.h     |   14 ++++++++++++++
 6 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/agp.h b/arch/alpha/include/asm/agp.h
index 0ee274c..41547e3 100644
--- a/arch/alpha/include/asm/agp.h
+++ b/arch/alpha/include/asm/agp.h
@@ -15,4 +15,18 @@
 #define free_gatt_pages(bridge, order)	\
 	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
+/* pages allocation. */
+#define _agp_alloc_page(bridge, dma_addr) \
+	({ \
+		struct page *_page = NULL; \
+		_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO); \
+		if (_page) \
+			*dma_addr = page_to_phys(_page); \
+		_page; \
+	})
+#define _agp_free_page(bridge, page, dma_addr) \
+	({ \
+		__free_page(page); \
+		*dma_addr = DMA_ERROR_CODE; \
+	})
 #endif
diff --git a/arch/ia64/include/asm/agp.h b/arch/ia64/include/asm/agp.h
index 4e12b72..9107e97 100644
--- a/arch/ia64/include/asm/agp.h
+++ b/arch/ia64/include/asm/agp.h
@@ -23,4 +23,19 @@
 #define free_gatt_pages(bridge, order)	\
 	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
+/* pages allocation. */
+#define _agp_alloc_page(bridge, dma_addr) \
+	({ \
+		struct page *_page = NULL; \
+		_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO); \
+		if (_page) \
+			*dma_addr = page_to_phys(_page); \
+		_page; \
+	})
+#define _agp_free_page(bridge, page, dma_addr) \
+	({ \
+		__free_page(page); \
+		*dma_addr = DMA_ERROR_CODE; \
+	})
+
 #endif /* _ASM_IA64_AGP_H */
diff --git a/arch/parisc/include/asm/agp.h b/arch/parisc/include/asm/agp.h
index 6e8fd98..1de4174 100644
--- a/arch/parisc/include/asm/agp.h
+++ b/arch/parisc/include/asm/agp.h
@@ -17,4 +17,19 @@
 #define free_gatt_pages(bridge, order)	\
 	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
+/* pages allocation. */
+#define _agp_alloc_page(bridge, dma_addr) \
+	({ \
+		struct page *_page = NULL; \
+		_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO); \
+		if (_page) \
+			*dma_addr = page_to_phys(_page); \
+		_page; \
+	})
+#define _agp_free_page(bridge, page, dma_addr) \
+	({ \
+		__free_page(page); \
+		*dma_addr = DMA_ERROR_CODE; \
+	})
+
 #endif /* _ASM_PARISC_AGP_H */
diff --git a/arch/powerpc/include/asm/agp.h b/arch/powerpc/include/asm/agp.h
index 0996a43..cdfa8e7 100644
--- a/arch/powerpc/include/asm/agp.h
+++ b/arch/powerpc/include/asm/agp.h
@@ -14,5 +14,20 @@
 #define free_gatt_pages(bridge, order)	\
 	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
+/* pages allocation. */
+#define _agp_alloc_page(bridge, dma_addr) \
+	({ \
+		struct page *_page = NULL; \
+		_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO); \
+		if (_page) \
+			*dma_addr = page_to_phys(_page); \
+		_page; \
+	})
+#define _agp_free_page(bridge, page, dma_addr) \
+	({ \
+		__free_page(page); \
+		*dma_addr = DMA_ERROR_CODE; \
+	})
+
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_AGP_H */
diff --git a/arch/sparc/include/asm/agp.h b/arch/sparc/include/asm/agp.h
index 2a83241..b0cd187 100644
--- a/arch/sparc/include/asm/agp.h
+++ b/arch/sparc/include/asm/agp.h
@@ -13,4 +13,18 @@
 #define free_gatt_pages(bridge, order)	\
 	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
+/* pages allocation. */
+#define _agp_alloc_page(bridge, dma_addr) \
+	({ \
+		struct page *_page = NULL; \
+		_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO); \
+		if (_page) \
+			*dma_addr = page_to_phys(_page); \
+		_page; \
+	})
+#define _agp_free_page(bridge, page, dma_addr) \
+	({ \
+		__free_page(page); \
+		*dma_addr = DMA_ERROR_CODE; \
+	})
 #endif
diff --git a/arch/x86/include/asm/agp.h b/arch/x86/include/asm/agp.h
index cbc996d..72e7179 100644
--- a/arch/x86/include/asm/agp.h
+++ b/arch/x86/include/asm/agp.h
@@ -28,4 +28,18 @@
 #define free_gatt_pages(bridge, order)	\
 	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
+/* pages allocation. */
+#define _agp_alloc_page(bridge, dma_addr) \
+	({ \
+		struct page *_page = NULL; \
+		_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO); \
+		if (_page) \
+			*dma_addr = page_to_phys(_page); \
+		_page; \
+	})
+#define _agp_free_page(bridge, page, dma_addr) \
+	({ \
+		__free_page(page); \
+		*dma_addr = DMA_ERROR_CODE; \
+	})
 #endif /* _ASM_X86_AGP_H */
-- 
1.7.1

