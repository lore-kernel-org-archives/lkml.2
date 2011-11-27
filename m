Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1K0Fkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:40:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab1K0Fkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:40:49 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org
Subject: [PATCH 61/62] highmem: kill all __kmap_atomic()
Date: Sun, 27 Nov 2011 13:27:41 +0800
Message-Id: <1322371662-26166-62-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/arm/mm/highmem.c                |    4 ++--
 arch/frv/include/asm/highmem.h       |    2 +-
 arch/frv/mm/highmem.c                |    4 ++--
 arch/mips/include/asm/highmem.h      |    2 +-
 arch/mips/mm/highmem.c               |    4 ++--
 arch/mn10300/include/asm/highmem.h   |    2 +-
 arch/parisc/include/asm/cacheflush.h |    2 +-
 arch/powerpc/include/asm/highmem.h   |    2 +-
 arch/sparc/include/asm/highmem.h     |    2 +-
 arch/sparc/mm/highmem.c              |    4 ++--
 arch/tile/include/asm/highmem.h      |    2 +-
 arch/tile/mm/highmem.c               |    4 ++--
 arch/x86/include/asm/highmem.h       |    2 +-
 arch/x86/mm/highmem_32.c             |    4 ++--
 include/linux/highmem.h              |   11 +++--------
 15 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index 807c057..5a21505 100644
--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -36,7 +36,7 @@ void kunmap(struct page *page)
 }
 EXPORT_SYMBOL(kunmap);
 
-void *__kmap_atomic(struct page *page)
+void *kmap_atomic(struct page *page)
 {
 	unsigned int idx;
 	unsigned long vaddr;
@@ -81,7 +81,7 @@ void *__kmap_atomic(struct page *page)
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(__kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic);
 
 void __kunmap_atomic(void *kvaddr)
 {
diff --git a/arch/frv/include/asm/highmem.h b/arch/frv/include/asm/highmem.h
index a8d6565..716956a 100644
--- a/arch/frv/include/asm/highmem.h
+++ b/arch/frv/include/asm/highmem.h
@@ -157,7 +157,7 @@ static inline void kunmap_atomic_primary(void *kvaddr, enum km_type type)
 	pagefault_enable();
 }
 
-void *__kmap_atomic(struct page *page);
+void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/frv/mm/highmem.c b/arch/frv/mm/highmem.c
index fd7fcd4..31902c9 100644
--- a/arch/frv/mm/highmem.c
+++ b/arch/frv/mm/highmem.c
@@ -37,7 +37,7 @@ struct page *kmap_atomic_to_page(void *ptr)
 	return virt_to_page(ptr);
 }
 
-void *__kmap_atomic(struct page *page)
+void *kmap_atomic(struct page *page)
 {
 	unsigned long paddr;
 	int type;
@@ -64,7 +64,7 @@ void *__kmap_atomic(struct page *page)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL(__kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic);
 
 void __kunmap_atomic(void *kvaddr)
 {
diff --git a/arch/mips/include/asm/highmem.h b/arch/mips/include/asm/highmem.h
index 77e6440..2d91888 100644
--- a/arch/mips/include/asm/highmem.h
+++ b/arch/mips/include/asm/highmem.h
@@ -47,7 +47,7 @@ extern void kunmap_high(struct page *page);
 
 extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
-extern void *__kmap_atomic(struct page *page);
+extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
diff --git a/arch/mips/mm/highmem.c b/arch/mips/mm/highmem.c
index 3634c7e..aff5705 100644
--- a/arch/mips/mm/highmem.c
+++ b/arch/mips/mm/highmem.c
@@ -41,7 +41,7 @@ EXPORT_SYMBOL(kunmap);
  * kmaps are appropriate for short, tight code paths only.
  */
 
-void *__kmap_atomic(struct page *page)
+void *kmap_atomic(struct page *page)
 {
 	unsigned long vaddr;
 	int idx, type;
@@ -62,7 +62,7 @@ void *__kmap_atomic(struct page *page)
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(__kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic);
 
 void __kunmap_atomic(void *kvaddr)
 {
diff --git a/arch/mn10300/include/asm/highmem.h b/arch/mn10300/include/asm/highmem.h
index bfe2d88..7c137cd 100644
--- a/arch/mn10300/include/asm/highmem.h
+++ b/arch/mn10300/include/asm/highmem.h
@@ -70,7 +70,7 @@ static inline void kunmap(struct page *page)
  * be used in IRQ contexts, so in some (very limited) cases we need
  * it.
  */
-static inline unsigned long __kmap_atomic(struct page *page)
+static inline unsigned long kmap_atomic(struct page *page)
 {
 	unsigned long vaddr;
 	int idx, type;
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index da601dd..9f21ab0 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -140,7 +140,7 @@ static inline void *kmap(struct page *page)
 
 #define kunmap(page)			kunmap_parisc(page_address(page))
 
-static inline void *__kmap_atomic(struct page *page)
+static inline void *kmap_atomic(struct page *page)
 {
 	pagefault_disable();
 	return page_address(page);
diff --git a/arch/powerpc/include/asm/highmem.h b/arch/powerpc/include/asm/highmem.h
index dbc2640..caaf6e0 100644
--- a/arch/powerpc/include/asm/highmem.h
+++ b/arch/powerpc/include/asm/highmem.h
@@ -79,7 +79,7 @@ static inline void kunmap(struct page *page)
 	kunmap_high(page);
 }
 
-static inline void *__kmap_atomic(struct page *page)
+static inline void *kmap_atomic(struct page *page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
 }
diff --git a/arch/sparc/include/asm/highmem.h b/arch/sparc/include/asm/highmem.h
index 3d7afbb..3b6e00d 100644
--- a/arch/sparc/include/asm/highmem.h
+++ b/arch/sparc/include/asm/highmem.h
@@ -70,7 +70,7 @@ static inline void kunmap(struct page *page)
 	kunmap_high(page);
 }
 
-extern void *__kmap_atomic(struct page *page);
+extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern struct page *kmap_atomic_to_page(void *vaddr);
 
diff --git a/arch/sparc/mm/highmem.c b/arch/sparc/mm/highmem.c
index 77140a0..055c66c 100644
--- a/arch/sparc/mm/highmem.c
+++ b/arch/sparc/mm/highmem.c
@@ -30,7 +30,7 @@
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 
-void *__kmap_atomic(struct page *page)
+void *kmap_atomic(struct page *page)
 {
 	unsigned long vaddr;
 	long idx, type;
@@ -64,7 +64,7 @@ void *__kmap_atomic(struct page *page)
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(__kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic);
 
 void __kunmap_atomic(void *kvaddr)
 {
diff --git a/arch/tile/include/asm/highmem.h b/arch/tile/include/asm/highmem.h
index b2a6c5d..fc8429a 100644
--- a/arch/tile/include/asm/highmem.h
+++ b/arch/tile/include/asm/highmem.h
@@ -59,7 +59,7 @@ void *kmap_fix_kpte(struct page *page, int finished);
 /* This macro is used only in map_new_virtual() to map "page". */
 #define kmap_prot page_to_kpgprot(page)
 
-void *__kmap_atomic(struct page *page);
+void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
diff --git a/arch/tile/mm/highmem.c b/arch/tile/mm/highmem.c
index 31dbbd9..ef8e5a6 100644
--- a/arch/tile/mm/highmem.c
+++ b/arch/tile/mm/highmem.c
@@ -224,12 +224,12 @@ void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 }
 EXPORT_SYMBOL(kmap_atomic_prot);
 
-void *__kmap_atomic(struct page *page)
+void *kmap_atomic(struct page *page)
 {
 	/* PAGE_NONE is a magic value that tells us to check immutability. */
 	return kmap_atomic_prot(page, PAGE_NONE);
 }
-EXPORT_SYMBOL(__kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic);
 
 void __kunmap_atomic(void *kvaddr)
 {
diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index 3bd0402..302a323 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -61,7 +61,7 @@ void *kmap(struct page *page);
 void kunmap(struct page *page);
 
 void *kmap_atomic_prot(struct page *page, pgprot_t prot);
-void *__kmap_atomic(struct page *page);
+void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index b499626..9f85499 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -50,11 +50,11 @@ void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 }
 EXPORT_SYMBOL(kmap_atomic_prot);
 
-void *__kmap_atomic(struct page *page)
+void *kmap_atomic(struct page *page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
 }
-EXPORT_SYMBOL(__kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic);
 
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 42ac049..9c1b442 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -55,12 +55,12 @@ static inline void kunmap(struct page *page)
 {
 }
 
-static inline void *__kmap_atomic(struct page *page)
+static inline void *kmap_atomic(struct page *page)
 {
 	pagefault_disable();
 	return page_address(page);
 }
-#define kmap_atomic_prot(page, prot)	__kmap_atomic(page)
+#define kmap_atomic_prot(page, prot)	kmap_atomic(page)
 
 static inline void __kunmap_atomic(void *addr)
 {
@@ -121,15 +121,10 @@ static inline void kmap_atomic_idx_pop(void)
 #define NARG_(_2, _1, n, ...) n
 #define NARG(...) NARG_(__VA_ARGS__, 2, 1, :)
 
-static inline void *kmap_atomic(struct page *page)
-{
-	return __kmap_atomic(page);
-}
-
 static inline void __deprecated *kmap_atomic_deprecated(struct page *page,
 							enum km_type km)
 {
-	return __kmap_atomic(page);
+	return kmap_atomic(page);
 }
 
 #define kmap_atomic1(...) kmap_atomic(__VA_ARGS__)
-- 
1.7.4.4

