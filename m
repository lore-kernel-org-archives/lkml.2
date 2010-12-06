Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0LFXZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:32 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27247 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0LFXZa (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/23] agp: Add bridge argument to [free|alloc]_gatt_pages macro.
Date: Mon,  6 Dec 2010 18:24:13 -0500
Message-Id: <1291677875-30493-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add to the macro an extra parameter: bridge. We will use
this new bridge parameter for the PCI API. Specifically
we will extract the 'struct pcidev' from it for the PCI API calls.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/alpha/include/asm/agp.h   |    6 +++---
 arch/ia64/include/asm/agp.h    |    6 +++---
 arch/parisc/include/asm/agp.h  |    6 +++---
 arch/powerpc/include/asm/agp.h |    6 +++---
 arch/sparc/include/asm/agp.h   |    6 +++---
 arch/x86/include/asm/agp.h     |    6 +++---
 drivers/char/agp/generic.c     |    8 ++++----
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/alpha/include/asm/agp.h b/arch/alpha/include/asm/agp.h
index a94d48b..0ee274c 100644
--- a/arch/alpha/include/asm/agp.h
+++ b/arch/alpha/include/asm/agp.h
@@ -10,9 +10,9 @@
 #define flush_agp_cache() mb()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
-#define alloc_gatt_pages(order)		\
+#define alloc_gatt_pages(bridge, order)		\
 	((char *)__get_free_pages(GFP_KERNEL, (order)))
-#define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+#define free_gatt_pages(bridge, order)	\
+	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
 #endif
diff --git a/arch/ia64/include/asm/agp.h b/arch/ia64/include/asm/agp.h
index 01d09c4..4e12b72 100644
--- a/arch/ia64/include/asm/agp.h
+++ b/arch/ia64/include/asm/agp.h
@@ -18,9 +18,9 @@
 #define flush_agp_cache()		mb()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
-#define alloc_gatt_pages(order)		\
+#define alloc_gatt_pages(bridge, order)		\
 	((char *)__get_free_pages(GFP_KERNEL, (order)))
-#define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+#define free_gatt_pages(bridge, order)	\
+	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
 #endif /* _ASM_IA64_AGP_H */
diff --git a/arch/parisc/include/asm/agp.h b/arch/parisc/include/asm/agp.h
index d226ffa..6e8fd98 100644
--- a/arch/parisc/include/asm/agp.h
+++ b/arch/parisc/include/asm/agp.h
@@ -12,9 +12,9 @@
 #define flush_agp_cache()		mb()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
-#define alloc_gatt_pages(order)		\
+#define alloc_gatt_pages(bridge, order)		\
 	((char *)__get_free_pages(GFP_KERNEL, (order)))
-#define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+#define free_gatt_pages(bridge, order)	\
+	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
 #endif /* _ASM_PARISC_AGP_H */
diff --git a/arch/powerpc/include/asm/agp.h b/arch/powerpc/include/asm/agp.h
index 416e12c..0996a43 100644
--- a/arch/powerpc/include/asm/agp.h
+++ b/arch/powerpc/include/asm/agp.h
@@ -9,10 +9,10 @@
 #define flush_agp_cache() mb()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
-#define alloc_gatt_pages(order)		\
+#define alloc_gatt_pages(bridge, order)		\
 	((char *)__get_free_pages(GFP_KERNEL, (order)))
-#define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+#define free_gatt_pages(bridge, order)	\
+	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_AGP_H */
diff --git a/arch/sparc/include/asm/agp.h b/arch/sparc/include/asm/agp.h
index 70f52c1..2a83241 100644
--- a/arch/sparc/include/asm/agp.h
+++ b/arch/sparc/include/asm/agp.h
@@ -8,9 +8,9 @@
 #define flush_agp_cache() mb()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
-#define alloc_gatt_pages(order)		\
+#define alloc_gatt_pages(bridge, order)		\
 	((char *)__get_free_pages(GFP_KERNEL, (order)))
-#define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+#define free_gatt_pages(bridge, order)	\
+	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
 #endif
diff --git a/arch/x86/include/asm/agp.h b/arch/x86/include/asm/agp.h
index eec2a70..cbc996d 100644
--- a/arch/x86/include/asm/agp.h
+++ b/arch/x86/include/asm/agp.h
@@ -23,9 +23,9 @@
 #define flush_agp_cache() wbinvd()
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
-#define alloc_gatt_pages(order)		\
+#define alloc_gatt_pages(bridge, order)		\
 	((char *)__get_free_pages(GFP_KERNEL, (order)))
-#define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+#define free_gatt_pages(bridge, order)	\
+	free_pages((unsigned long)(bridge->gatt_table_real), (order))
 
 #endif /* _ASM_X86_AGP_H */
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 4956f1c..09332ba 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -931,7 +931,7 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 				break;
 			}
 
-			table = alloc_gatt_pages(page_order);
+			table = alloc_gatt_pages(bridge, page_order);
 
 			if (table == NULL) {
 				i++;
@@ -960,7 +960,7 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 		size = ((struct aper_size_info_fixed *) temp)->size;
 		page_order = ((struct aper_size_info_fixed *) temp)->page_order;
 		num_entries = ((struct aper_size_info_fixed *) temp)->num_entries;
-		table = alloc_gatt_pages(page_order);
+		table = alloc_gatt_pages(bridge, page_order);
 	}
 
 	if (table == NULL)
@@ -990,7 +990,7 @@ int agp_generic_create_gatt_table(struct agp_bridge_data *bridge)
 		for (page = virt_to_page(table); page <= virt_to_page(table_end); page++)
 			ClearPageReserved(page);
 
-		free_gatt_pages(table, page_order);
+		free_gatt_pages(bridge, page_order);
 
 		return -ENOMEM;
 	}
@@ -1052,7 +1052,7 @@ int agp_generic_free_gatt_table(struct agp_bridge_data *bridge)
 	for (page = virt_to_page(table); page <= virt_to_page(table_end); page++)
 		ClearPageReserved(page);
 
-	free_gatt_pages(bridge->gatt_table_real, page_order);
+	free_gatt_pages(bridge, page_order);
 
 	agp_gatt_table = NULL;
 	bridge->gatt_table = NULL;
-- 
1.7.1

