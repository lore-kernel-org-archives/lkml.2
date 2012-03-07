Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946Ab2CGTqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:46:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759748Ab2CGTqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:46:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/29] Move all declarations of free_initmem() to linux/mm.h
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:46:02 +0000
Message-ID: <20120307194602.15987.77717.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all declarations of free_initmem() to linux/mm.h so that there's only one
and it's used by everything.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/c6x/include/asm/system.h        |    1 -
 arch/frv/include/asm/system.h        |    1 -
 arch/microblaze/include/asm/system.h |    1 -
 arch/sh/include/asm/system.h         |    1 -
 arch/sparc/mm/init_64.h              |    2 --
 arch/x86/include/asm/page_types.h    |    1 -
 include/linux/mm.h                   |    2 ++
 init/main.c                          |    1 -
 8 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/c6x/include/asm/system.h b/arch/c6x/include/asm/system.h
index e076dc0..7b1cfa9 100644
--- a/arch/c6x/include/asm/system.h
+++ b/arch/c6x/include/asm/system.h
@@ -160,7 +160,6 @@ struct pt_regs;
 extern void die(char *str, struct pt_regs *fp, int nr);
 extern asmlinkage int process_exception(struct pt_regs *regs);
 extern void time_init(void);
-extern void free_initmem(void);
 
 extern void (*c6x_restart)(void);
 extern void (*c6x_halt)(void);
diff --git a/arch/frv/include/asm/system.h b/arch/frv/include/asm/system.h
index 6c10fd2..769e66f 100644
--- a/arch/frv/include/asm/system.h
+++ b/arch/frv/include/asm/system.h
@@ -53,7 +53,6 @@ do {									\
 	do { var = (value); barrier(); } while (0)
 
 extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
-extern void free_initmem(void);
 
 #define arch_align_stack(x) (x)
 
diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
index 5a433cb..81f9f23 100644
--- a/arch/microblaze/include/asm/system.h
+++ b/arch/microblaze/include/asm/system.h
@@ -81,7 +81,6 @@ void default_idle(void);
 	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end);
-void free_initmem(void);
 extern char *klimit;
 extern void ret_from_fork(void);
 
diff --git a/arch/sh/include/asm/system.h b/arch/sh/include/asm/system.h
index 10c8b18..11fa6f3 100644
--- a/arch/sh/include/asm/system.h
+++ b/arch/sh/include/asm/system.h
@@ -117,7 +117,6 @@ static inline unsigned long __cmpxchg(volatile void * ptr, unsigned long old,
 struct pt_regs;
 
 extern void die(const char *str, struct pt_regs *regs, long err) __attribute__ ((noreturn));
-void free_initmem(void);
 void free_initrd_mem(unsigned long start, unsigned long end);
 
 extern void *set_exception_table_vec(unsigned int vec, void *handler);
diff --git a/arch/sparc/mm/init_64.h b/arch/sparc/mm/init_64.h
index 77d1b31..3e1ac8b 100644
--- a/arch/sparc/mm/init_64.h
+++ b/arch/sparc/mm/init_64.h
@@ -36,8 +36,6 @@ extern unsigned long kern_locked_tte_data;
 
 extern void prom_world(int enter);
 
-extern void free_initmem(void);
-
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 #define VMEMMAP_CHUNK_SHIFT	22
 #define VMEMMAP_CHUNK		(1UL << VMEMMAP_CHUNK_SHIFT)
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index bce688d..e21fdd1 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -55,7 +55,6 @@ extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
 extern void initmem_init(void);
-extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..5fcaeaa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1253,6 +1253,8 @@ static inline void pgtable_page_dtor(struct page *page)
 extern void free_area_init(unsigned long * zones_size);
 extern void free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
+extern void free_initmem(void);
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
  * With CONFIG_HAVE_MEMBLOCK_NODE_MAP set, an architecture may initialise its
diff --git a/init/main.c b/init/main.c
index ff49a6d..de41307 100644
--- a/init/main.c
+++ b/init/main.c
@@ -87,7 +87,6 @@ extern void mca_init(void);
 extern void sbus_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
-extern void free_initmem(void);
 #ifndef CONFIG_DEBUG_RODATA
 static inline void mark_rodata_ro(void) { }
 #endif

