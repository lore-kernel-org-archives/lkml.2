Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab1E0Ijh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:39:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:46038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab1E0Ije (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:39:34 -0400
Date: Fri, 27 May 2011 08:39:25 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-incpt6y26yd8586idx65t9ll@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, asm: Clean up desc.h a bit
Git-Commit-ID: 9a3865b185e77d1a4ca2d8356e37c19b78168961
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 May 2011 08:39:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a3865b185e77d1a4ca2d8356e37c19b78168961
Gitweb:     http://git.kernel.org/tip/9a3865b185e77d1a4ca2d8356e37c19b78168961
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 27 May 2011 09:29:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 May 2011 09:30:50 +0200

x86, asm: Clean up desc.h a bit

I have looked at this file and found it rather ugly - improve
readability a bit. No change in functionality.

Link: http://lkml.kernel.org/n/tip-incpt6y26yd8586idx65t9ll@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/desc.h |  152 +++++++++++++++++++++---------------------
 1 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 617bd56..7b439d9 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -4,30 +4,33 @@
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
+
 #include <linux/smp.h>
 
-static inline void fill_ldt(struct desc_struct *desc,
-			    const struct user_desc *info)
-{
-	desc->limit0 = info->limit & 0x0ffff;
-	desc->base0 = info->base_addr & 0x0000ffff;
-
-	desc->base1 = (info->base_addr & 0x00ff0000) >> 16;
-	desc->type = (info->read_exec_only ^ 1) << 1;
-	desc->type |= info->contents << 2;
-	desc->s = 1;
-	desc->dpl = 0x3;
-	desc->p = info->seg_not_present ^ 1;
-	desc->limit = (info->limit & 0xf0000) >> 16;
-	desc->avl = info->useable;
-	desc->d = info->seg_32bit;
-	desc->g = info->limit_in_pages;
-	desc->base2 = (info->base_addr & 0xff000000) >> 24;
+static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *info)
+{
+	desc->limit0		= info->limit & 0x0ffff;
+
+	desc->base0		= (info->base_addr & 0x0000ffff);
+	desc->base1		= (info->base_addr & 0x00ff0000) >> 16;
+
+	desc->type		= (info->read_exec_only ^ 1) << 1;
+	desc->type	       |= info->contents << 2;
+
+	desc->s			= 1;
+	desc->dpl		= 0x3;
+	desc->p			= info->seg_not_present ^ 1;
+	desc->limit		= (info->limit & 0xf0000) >> 16;
+	desc->avl		= info->useable;
+	desc->d			= info->seg_32bit;
+	desc->g			= info->limit_in_pages;
+
+	desc->base2		= (info->base_addr & 0xff000000) >> 24;
 	/*
 	 * Don't allow setting of the lm bit. It is useless anyway
 	 * because 64bit system calls require __USER_CS:
 	 */
-	desc->l = 0;
+	desc->l			= 0;
 }
 
 extern struct desc_ptr idt_descr;
@@ -36,6 +39,7 @@ extern gate_desc idt_table[];
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
 } __attribute__((aligned(PAGE_SIZE)));
+
 DECLARE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page);
 
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
@@ -48,16 +52,16 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
-	gate->offset_low = PTR_LOW(func);
-	gate->segment = __KERNEL_CS;
-	gate->ist = ist;
-	gate->p = 1;
-	gate->dpl = dpl;
-	gate->zero0 = 0;
-	gate->zero1 = 0;
-	gate->type = type;
-	gate->offset_middle = PTR_MIDDLE(func);
-	gate->offset_high = PTR_HIGH(func);
+	gate->offset_low	= PTR_LOW(func);
+	gate->segment		= __KERNEL_CS;
+	gate->ist		= ist;
+	gate->p			= 1;
+	gate->dpl		= dpl;
+	gate->zero0		= 0;
+	gate->zero1		= 0;
+	gate->type		= type;
+	gate->offset_middle	= PTR_MIDDLE(func);
+	gate->offset_high	= PTR_HIGH(func);
 }
 
 #else
@@ -66,8 +70,7 @@ static inline void pack_gate(gate_desc *gate, unsigned char type,
 			     unsigned short seg)
 {
 	gate->a = (seg << 16) | (base & 0xffff);
-	gate->b = (base & 0xffff0000) |
-		  (((0x80 | type | (dpl << 5)) & 0xff) << 8);
+	gate->b = (base & 0xffff0000) | (((0x80 | type | (dpl << 5)) & 0xff) << 8);
 }
 
 #endif
@@ -75,31 +78,29 @@ static inline void pack_gate(gate_desc *gate, unsigned char type,
 static inline int desc_empty(const void *ptr)
 {
 	const u32 *desc = ptr;
+
 	return !(desc[0] | desc[1]);
 }
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define load_TR_desc() native_load_tr_desc()
-#define load_gdt(dtr) native_load_gdt(dtr)
-#define load_idt(dtr) native_load_idt(dtr)
-#define load_tr(tr) asm volatile("ltr %0"::"m" (tr))
-#define load_ldt(ldt) asm volatile("lldt %0"::"m" (ldt))
-
-#define store_gdt(dtr) native_store_gdt(dtr)
-#define store_idt(dtr) native_store_idt(dtr)
-#define store_tr(tr) (tr = native_store_tr())
-
-#define load_TLS(t, cpu) native_load_tls(t, cpu)
-#define set_ldt native_set_ldt
-
-#define write_ldt_entry(dt, entry, desc)	\
-	native_write_ldt_entry(dt, entry, desc)
-#define write_gdt_entry(dt, entry, desc, type)		\
-	native_write_gdt_entry(dt, entry, desc, type)
-#define write_idt_entry(dt, entry, g)		\
-	native_write_idt_entry(dt, entry, g)
+#define load_TR_desc()				native_load_tr_desc()
+#define load_gdt(dtr)				native_load_gdt(dtr)
+#define load_idt(dtr)				native_load_idt(dtr)
+#define load_tr(tr)				asm volatile("ltr %0"::"m" (tr))
+#define load_ldt(ldt)				asm volatile("lldt %0"::"m" (ldt))
+
+#define store_gdt(dtr)				native_store_gdt(dtr)
+#define store_idt(dtr)				native_store_idt(dtr)
+#define store_tr(tr)				(tr = native_store_tr())
+
+#define load_TLS(t, cpu)			native_load_tls(t, cpu)
+#define set_ldt					native_set_ldt
+
+#define write_ldt_entry(dt, entry, desc)	native_write_ldt_entry(dt, entry, desc)
+#define write_gdt_entry(dt, entry, desc, type)	native_write_gdt_entry(dt, entry, desc, type)
+#define write_idt_entry(dt, entry, g)		native_write_idt_entry(dt, entry, g)
 
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
@@ -112,33 +113,27 @@ static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
 
 #define store_ldt(ldt) asm("sldt %0" : "=m"(ldt))
 
-static inline void native_write_idt_entry(gate_desc *idt, int entry,
-					  const gate_desc *gate)
+static inline void native_write_idt_entry(gate_desc *idt, int entry, const gate_desc *gate)
 {
 	memcpy(&idt[entry], gate, sizeof(*gate));
 }
 
-static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
-					  const void *desc)
+static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry, const void *desc)
 {
 	memcpy(&ldt[entry], desc, 8);
 }
 
-static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
-					  const void *desc, int type)
+static inline void
+native_write_gdt_entry(struct desc_struct *gdt, int entry, const void *desc, int type)
 {
 	unsigned int size;
+
 	switch (type) {
-	case DESC_TSS:
-		size = sizeof(tss_desc);
-		break;
-	case DESC_LDT:
-		size = sizeof(ldt_desc);
-		break;
-	default:
-		size = sizeof(struct desc_struct);
-		break;
+	case DESC_TSS:	size = sizeof(tss_desc);	break;
+	case DESC_LDT:	size = sizeof(ldt_desc);	break;
+	default:	size = sizeof(*gdt);		break;
 	}
+
 	memcpy(&gdt[entry], desc, size);
 }
 
@@ -154,20 +149,21 @@ static inline void pack_descriptor(struct desc_struct *desc, unsigned long base,
 }
 
 
-static inline void set_tssldt_descriptor(void *d, unsigned long addr,
-					 unsigned type, unsigned size)
+static inline void set_tssldt_descriptor(void *d, unsigned long addr, unsigned type, unsigned size)
 {
 #ifdef CONFIG_X86_64
 	struct ldttss_desc64 *desc = d;
+
 	memset(desc, 0, sizeof(*desc));
-	desc->limit0 = size & 0xFFFF;
-	desc->base0 = PTR_LOW(addr);
-	desc->base1 = PTR_MIDDLE(addr) & 0xFF;
-	desc->type = type;
-	desc->p = 1;
-	desc->limit1 = (size >> 16) & 0xF;
-	desc->base2 = (PTR_MIDDLE(addr) >> 8) & 0xFF;
-	desc->base3 = PTR_HIGH(addr);
+
+	desc->limit0		= size & 0xFFFF;
+	desc->base0		= PTR_LOW(addr);
+	desc->base1		= PTR_MIDDLE(addr) & 0xFF;
+	desc->type		= type;
+	desc->p			= 1;
+	desc->limit1		= (size >> 16) & 0xF;
+	desc->base2		= (PTR_MIDDLE(addr) >> 8) & 0xFF;
+	desc->base3		= PTR_HIGH(addr);
 #else
 	pack_descriptor((struct desc_struct *)d, addr, size, 0x80 | type, 0);
 #endif
@@ -237,14 +233,16 @@ static inline void native_store_idt(struct desc_ptr *dtr)
 static inline unsigned long native_store_tr(void)
 {
 	unsigned long tr;
+
 	asm volatile("str %0":"=r" (tr));
+
 	return tr;
 }
 
 static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
-	unsigned int i;
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+	unsigned int i;
 
 	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
@@ -313,6 +311,7 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
 	gate_desc s;
+
 	pack_gate(&s, type, (unsigned long)addr, dpl, ist, seg);
 	/*
 	 * does not need to be atomic because it is only done once at
@@ -343,8 +342,9 @@ static inline void alloc_system_vector(int vector)
 		set_bit(vector, used_vectors);
 		if (first_system_vector > vector)
 			first_system_vector = vector;
-	} else
+	} else {
 		BUG();
+	}
 }
 
 static inline void alloc_intr_gate(unsigned int n, void *addr)
