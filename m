Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1BFLPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:15:49 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:50257 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1BFLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:15:37 -0500
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/3] Add ioremap_cache and ioremap_wc to all architectures
Date: Sun, 6 Feb 2011 12:12:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic-pae; KDE/4.5.5; i686; ; )
Cc: Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201011271437.38126.thomas.schlichter@web.de> <20101130061051.GD17114@linux-sh.org> <201102061202.09503.thomas.schlichter@web.de>
In-Reply-To: <201102061202.09503.thomas.schlichter@web.de>
MIME-Version: 1.0
Message-Id: <201102061212.32528.thomas.schlichter@web.de>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gIoTNU8IklXLXxb"
X-Provags-ID: V01U2FsdGVkX18OCX/NjOsH9B1qSs/DVV7mY0sU5K/wdGZQGHoF
	J9rrh28Qc6VM+t9xy4DHkpeFo/Nh0tMf0jME28d1Eva34EDXIT
	6QBabZ/2UD7u1QOuxQfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_gIoTNU8IklXLXxb
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit



--Boundary-00=_gIoTNU8IklXLXxb
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="0002-Add-ioremap_cache-and-ioremap_wc-to-all-architecture.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0002-Add-ioremap_cache-and-ioremap_wc-to-all-architecture.patch"

>From 194ea8d7dc39c1587d0e38d2571775e73949953b Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Sat, 5 Feb 2011 15:07:41 +0100
Subject: [PATCH 2/3] Add ioremap_cache and ioremap_wc to all architectures

Establish ioremap_cache() and ioremap_wc() to be available besides
ioremap() and ioremap_nocache() on all architectures. This allows
generic drivers to use them without any ifdef-cludge.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/alpha/include/asm/io.h      |    3 +++
 arch/arm/include/asm/io.h        |    2 +-
 arch/arm/mm/mmu.c                |    2 +-
 arch/avr32/include/asm/io.h      |    6 ++++++
 arch/cris/include/asm/io.h       |    3 +++
 arch/frv/include/asm/io.h        |    1 +
 arch/h8300/include/asm/io.h      |    3 +++
 arch/ia64/include/asm/io.h       |    1 +
 arch/m32r/include/asm/io.h       |    2 ++
 arch/m68k/include/asm/io_mm.h    |    3 +++
 arch/m68k/include/asm/io_no.h    |    3 +++
 arch/microblaze/include/asm/io.h |    4 ++++
 arch/mips/include/asm/io.h       |    6 ++++--
 arch/mn10300/include/asm/io.h    |    1 +
 arch/parisc/include/asm/io.h     |    2 ++
 arch/powerpc/include/asm/io.h    |    2 ++
 arch/sh/include/asm/io.h         |    1 +
 arch/sparc/include/asm/io_32.h   |    1 +
 arch/sparc/include/asm/io_64.h   |    1 +
 arch/tile/include/asm/io.h       |    2 ++
 arch/x86/include/asm/io.h        |    2 --
 arch/xtensa/include/asm/io.h     |    3 +++
 drivers/mtd/maps/pxa2xx-flash.c  |    2 +-
 include/asm-generic/io.h         |    4 ++++
 include/asm-generic/iomap.h      |    4 ----
 25 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 56ff965..beb17bc 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -300,6 +300,9 @@ static inline void __iomem * ioremap_nocache(unsigned long offset,
 	return ioremap(offset, size);
 } 
 
+#define ioremap_cache ioremap
+#define ioremap_wc ioremap_nocache
+
 static inline void iounmap(volatile void __iomem *addr)
 {
 	IO_CONCAT(__IO_PREFIX,iounmap)(addr);
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d66605d..adb0e46 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -248,7 +248,7 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
 
 #define ioremap(cookie,size)		__arch_ioremap((cookie), (size), MT_DEVICE)
 #define ioremap_nocache(cookie,size)	__arch_ioremap((cookie), (size), MT_DEVICE)
-#define ioremap_cached(cookie,size)	__arch_ioremap((cookie), (size), MT_DEVICE_CACHED)
+#define ioremap_cache(cookie,size)	__arch_ioremap((cookie), (size), MT_DEVICE_CACHED)
 #define ioremap_wc(cookie,size)		__arch_ioremap((cookie), (size), MT_DEVICE_WC)
 #define iounmap				__arch_iounmap
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 3c67e92..d4bf66b 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -208,7 +208,7 @@ static struct mem_type mem_types[] = {
 		.prot_sect	= PROT_SECT_DEVICE,
 		.domain		= DOMAIN_IO,
 	},
-	[MT_DEVICE_CACHED] = {	  /* ioremap_cached */
+	[MT_DEVICE_CACHED] = {	  /* ioremap_cache */
 		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_CACHED,
 		.prot_l1	= PMD_TYPE_TABLE,
 		.prot_sect	= PROT_SECT_DEVICE | PMD_SECT_WB,
diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
index 22c97ef..35095c4 100644
--- a/arch/avr32/include/asm/io.h
+++ b/arch/avr32/include/asm/io.h
@@ -287,6 +287,12 @@ extern void __iounmap(void __iomem *addr);
 #define ioremap_nocache(offset, size)		\
 	__ioremap((offset), (size), 0)
 
+#define ioremap_cache(offset, size)		\
+	__ioremap((offset), (size), 0)
+
+#define ioremap_wc(offset, size)		\
+	__ioremap((offset), (size), 0)
+
 #define iounmap(addr)				\
 	__iounmap(addr)
 
diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 32567bc..9dad86e 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -45,6 +45,9 @@ extern void iounmap(volatile void * __iomem addr);
 
 extern void __iomem * ioremap_nocache(unsigned long offset, unsigned long size);
 
+#define ioremap_cache ioremap
+#define ioremap_wc ioremap_nocache
+
 /*
  * IO bus memory addresses are also 1:1 with the physical address
  */
diff --git a/arch/frv/include/asm/io.h b/arch/frv/include/asm/io.h
index ca7475e..44d0adf 100644
--- a/arch/frv/include/asm/io.h
+++ b/arch/frv/include/asm/io.h
@@ -271,6 +271,7 @@ static inline void __iomem *ioremap_fullcache(unsigned long physaddr, unsigned l
 	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
 }
 
+#define ioremap_cache ioremap_fullcache
 #define ioremap_wc ioremap_nocache
 
 extern void iounmap(void volatile __iomem *addr);
diff --git a/arch/h8300/include/asm/io.h b/arch/h8300/include/asm/io.h
index c1a8df2..f5e6aec 100644
--- a/arch/h8300/include/asm/io.h
+++ b/arch/h8300/include/asm/io.h
@@ -262,6 +262,9 @@ static inline void *ioremap_fullcache(unsigned long physaddr, unsigned long size
 	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
 }
 
+#define ioremap_cache ioremap_fullcache
+#define ioremap_wc ioremap_nocache
+
 extern void iounmap(void *addr);
 
 /* H8/300 internal I/O functions */
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index e5a6c35..9f9e156 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -431,6 +431,7 @@ static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned lo
 	return ioremap(phys_addr, size);
 }
 
+#define ioremap_wc ioremap_nocache
 
 /*
  * String version of IO memory access ops:
diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 4010f1f..0a4a2a9 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -67,6 +67,8 @@ static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 
 extern void iounmap(volatile void __iomem *addr);
 #define ioremap_nocache(off,size) ioremap(off,size)
+#define ioremap_cache(off,size)   ioremap(off,size)
+#define ioremap_wc(off,size)      ioremap(off,size)
 
 /*
  * IO bus memory addresses are also 1:1 with the physical address
diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
index 0fb3468..603b973 100644
--- a/arch/m68k/include/asm/io_mm.h
+++ b/arch/m68k/include/asm/io_mm.h
@@ -299,6 +299,9 @@ static inline void __iomem *ioremap_fullcache(unsigned long physaddr,
 	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
 }
 
+#define ioremap_cache ioremap_fullcache
+#define ioremap_wc ioremap_nocache
+
 static inline void memset_io(volatile void __iomem *addr, unsigned char val, int count)
 {
 	__builtin_memset((void __force *) addr, val, count);
diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index cf20f30..ecfead4 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -163,6 +163,9 @@ static inline void *ioremap_fullcache(unsigned long physaddr, unsigned long size
 	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
 }
 
+#define ioremap_cache ioremap_fullcache
+#define ioremap_wc ioremap_nocache
+
 extern void iounmap(void *addr);
 
 /*
diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
index eae3222..9af2203 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -153,6 +153,8 @@ extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
 #define ioremap_writethrough(addr, size) ioremap((addr), (size))
 #define ioremap_nocache(addr, size)      ioremap((addr), (size))
 #define ioremap_fullcache(addr, size)    ioremap((addr), (size))
+#define ioremap_cache(addr, size)        ioremap((addr), (size))
+#define ioremap_wc(addr, size)           ioremap((addr), (size))
 
 #else /* CONFIG_MMU */
 
@@ -203,6 +205,8 @@ static inline void __iomem *__ioremap(phys_addr_t address, unsigned long size,
 #define ioremap(physaddr, size)	((void __iomem *)(unsigned long)(physaddr))
 #define iounmap(addr)		((void)0)
 #define ioremap_nocache(physaddr, size)	ioremap(physaddr, size)
+#define ioremap_cache(physaddr, size)	ioremap(physaddr, size)
+#define ioremap_wc(physaddr, size)	ioremap(physaddr, size)
 
 #endif /* CONFIG_MMU */
 
diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
index 5b017f2..51dad4a 100644
--- a/arch/mips/include/asm/io.h
+++ b/arch/mips/include/asm/io.h
@@ -251,7 +251,7 @@ static inline void __iomem * __ioremap_mode(phys_t offset, unsigned long size,
 	__ioremap_mode((offset), (size), _CACHE_UNCACHED)
 
 /*
- * ioremap_cachable -   map bus memory into CPU space
+ * ioremap_cache -  map bus memory into CPU space
  * @offset:         bus address of the memory
  * @size:           size of the resource to map
  *
@@ -265,9 +265,11 @@ static inline void __iomem * __ioremap_mode(phys_t offset, unsigned long size,
  * the CPU.  Also enables full write-combining.  Useful for some
  * memory-like regions on I/O busses.
  */
-#define ioremap_cachable(offset, size)					\
+#define ioremap_cache(offset, size)					\
 	__ioremap_mode((offset), (size), _page_cachable_default)
 
+#define ioremap_wc ioremap_nocache
+
 /*
  * These two are MIPS specific ioremap variant.  ioremap_cacheable_cow
  * requests a cachable mapping, ioremap_uncached_accelerated requests a
diff --git a/arch/mn10300/include/asm/io.h b/arch/mn10300/include/asm/io.h
index 787255d..1ed75a0 100644
--- a/arch/mn10300/include/asm/io.h
+++ b/arch/mn10300/include/asm/io.h
@@ -272,6 +272,7 @@ static inline void *ioremap_nocache(unsigned long offset, unsigned long size)
 	return (void *) (offset | 0x20000000);
 }
 
+#define ioremap_cache ioremap
 #define ioremap_wc ioremap_nocache
 
 static inline void iounmap(void *addr)
diff --git a/arch/parisc/include/asm/io.h b/arch/parisc/include/asm/io.h
index 1f6d2ae..01edb85 100644
--- a/arch/parisc/include/asm/io.h
+++ b/arch/parisc/include/asm/io.h
@@ -137,6 +137,8 @@ static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
 	return __ioremap(offset, size, _PAGE_NO_CACHE);
 }
 #define ioremap_nocache(off, sz)	ioremap((off), (sz))
+#define ioremap_cache(off, sz)		ioremap((off), (sz))
+#define ioremap_wc(off, sz)		ioremap((off), (sz))
 
 extern void iounmap(const volatile void __iomem *addr);
 
diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 001f2f1..ee41d61 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -643,6 +643,8 @@ extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
 extern void __iomem *ioremap_flags(phys_addr_t address, unsigned long size,
 				   unsigned long flags);
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
+#define ioremap_cache(addr, size)	ioremap((addr), (size))
+#define ioremap_wc(addr, size)		ioremap((addr), (size))
 #define ioremap_prot(addr, size, prot)	ioremap_flags((addr), (size), (prot))
 
 extern void iounmap(volatile void __iomem *addr);
diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 28c5aa5..7dfbb47 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -369,6 +369,7 @@ static inline int iounmap_fixed(void __iomem *addr) { return -EINVAL; }
 #endif
 
 #define ioremap_nocache	ioremap
+#define ioremap_wc	ioremap
 #define iounmap		__iounmap
 
 /*
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index c2ced21..f0a8173 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -275,6 +275,7 @@ _memcpy_toio(volatile void __iomem *dst, const void *src, __kernel_size_t n)
  */
 extern void __iomem *ioremap(unsigned long offset, unsigned long size);
 #define ioremap_nocache(X,Y)	ioremap((X),(Y))
+#define ioremap_cache(X,Y)	ioremap((X),(Y))
 #define ioremap_wc(X,Y)		ioremap((X),(Y))
 extern void iounmap(volatile void __iomem *addr);
 
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 9c89654..08fcfdb 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -491,6 +491,7 @@ static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 }
 
 #define ioremap_nocache(X,Y)		ioremap((X),(Y))
+#define ioremap_cache(X,Y)		ioremap((X),(Y))
 #define ioremap_wc(X,Y)			ioremap((X),(Y))
 
 static inline void iounmap(volatile void __iomem *addr)
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index d3cbb9b..a9c5320 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -54,6 +54,8 @@ extern void iounmap(volatile void __iomem *addr);
 #define ioremap_nocache(physaddr, size)		ioremap(physaddr, size)
 #define ioremap_writethrough(physaddr, size)	ioremap(physaddr, size)
 #define ioremap_fullcache(physaddr, size)	ioremap(physaddr, size)
+#define ioremap_cache(physaddr, size)		ioremap(physaddr, size)
+#define ioremap_wc(physaddr, size)		ioremap(physaddr, size)
 
 #define mmiowb()
 
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 0722730..4977ddc 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -34,8 +34,6 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define ARCH_HAS_IOREMAP_WC
-
 #include <linux/string.h>
 #include <linux/compiler.h>
 #include <asm-generic/int-ll64.h>
diff --git a/arch/xtensa/include/asm/io.h b/arch/xtensa/include/asm/io.h
index d04cd3a..c392cd8 100644
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -93,6 +93,9 @@ static inline void *ioremap_nocache(unsigned long offset, unsigned long size)
 #endif
 }
 
+#define ioremap_cache ioremap
+#define ioremap_wc ioremap_nocache
+
 static inline void iounmap(void *addr)
 {
 }
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index d8ae634..2170634 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -81,7 +81,7 @@ static int __devinit pxa2xx_flash_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	info->map.cached =
-		ioremap_cached(info->map.phys, info->map.size);
+		ioremap_cache(info->map.phys, info->map.size);
 	if (!info->map.cached)
 		printk(KERN_WARNING "Failed to ioremap cached %s\n",
 		       info->map.name);
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 4644c9a..598d26c 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -318,6 +318,10 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifndef ioremap_cache
+#define ioremap_cache ioremap
+#endif
+
 static inline void iounmap(void *addr)
 {
 }
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 76b0cc5..67dc84c 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -60,10 +60,6 @@ extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long cou
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
 
-#ifndef ARCH_HAS_IOREMAP_WC
-#define ioremap_wc ioremap_nocache
-#endif
-
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-- 
1.7.1


--Boundary-00=_gIoTNU8IklXLXxb--
