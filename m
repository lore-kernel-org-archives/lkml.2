Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1HaVbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109Ab1HaV2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:24 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 16/24] C6X: loadable module support
Date: Wed, 31 Aug 2011 17:26:51 -0400
Message-Id: <1314826019-22330-17-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/module.h |   33 +++++++
 arch/c6x/kernel/c6x_ksyms.c   |   68 ++++++++++++++
 arch/c6x/kernel/module.c      |  196 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 297 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/module.h
 create mode 100644 arch/c6x/kernel/c6x_ksyms.c
 create mode 100644 arch/c6x/kernel/module.c

diff --git a/arch/c6x/include/asm/module.h b/arch/c6x/include/asm/module.h
new file mode 100644
index 0000000..a453f97
--- /dev/null
+++ b/arch/c6x/include/asm/module.h
@@ -0,0 +1,33 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34 by: Mark Salter (msalter@redhat.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_MODULE_H
+#define _ASM_C6X_MODULE_H
+
+#define Elf_Shdr	Elf32_Shdr
+#define Elf_Sym		Elf32_Sym
+#define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Addr	Elf32_Addr
+#define Elf_Word	Elf32_Word
+
+/*
+ * This file contains the C6x architecture specific module code.
+ */
+struct mod_arch_specific {
+};
+
+struct loaded_sections {
+	unsigned int new_vaddr;
+	unsigned int loaded;
+};
+
+#endif /* _ASM_C6X_MODULE_H */
diff --git a/arch/c6x/kernel/c6x_ksyms.c b/arch/c6x/kernel/c6x_ksyms.c
new file mode 100644
index 0000000..358d097
--- /dev/null
+++ b/arch/c6x/kernel/c6x_ksyms.c
@@ -0,0 +1,68 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <asm/checksum.h>
+#include <linux/io.h>
+
+/*
+ * libgcc functions - used internally by the compiler...
+ */
+extern int __c6xabi_divi(int dividend, int divisor);
+EXPORT_SYMBOL(__c6xabi_divi);
+
+extern unsigned __c6xabi_divu(unsigned	dividend, unsigned divisor);
+EXPORT_SYMBOL(__c6xabi_divu);
+
+extern int __c6xabi_remi(int dividend, int divisor);
+EXPORT_SYMBOL(__c6xabi_remi);
+
+extern unsigned __c6xabi_remu(unsigned	dividend, unsigned divisor);
+EXPORT_SYMBOL(__c6xabi_remu);
+
+extern int __c6xabi_divremi(int dividend, int divisor);
+EXPORT_SYMBOL(__c6xabi_divremi);
+
+extern unsigned __c6xabi_divremu(unsigned  dividend, unsigned divisor);
+EXPORT_SYMBOL(__c6xabi_divremu);
+
+extern unsigned long long __c6xabi_mpyll(unsigned long long src1,
+					 unsigned long long src2);
+EXPORT_SYMBOL(__c6xabi_mpyll);
+
+extern long long __c6xabi_negll(long long src);
+EXPORT_SYMBOL(__c6xabi_negll);
+
+extern unsigned long long __c6xabi_llshl(unsigned long long src1, uint src2);
+EXPORT_SYMBOL(__c6xabi_llshl);
+
+extern long long __c6xabi_llshr(long long src1, uint src2);
+EXPORT_SYMBOL(__c6xabi_llshr);
+
+extern unsigned long long __c6xabi_llshru(unsigned long long src1, uint src2);
+EXPORT_SYMBOL(__c6xabi_llshru);
+
+extern void __c6xabi_strasgi(int *dst, const int *src, unsigned cnt);
+EXPORT_SYMBOL(__c6xabi_strasgi);
+
+extern void __c6xabi_push_rts(void);
+EXPORT_SYMBOL(__c6xabi_push_rts);
+
+extern void __c6xabi_pop_rts(void);
+EXPORT_SYMBOL(__c6xabi_pop_rts);
+
+extern void __c6xabi_strasgi_64plus(int *dst, const int *src, unsigned cnt);
+EXPORT_SYMBOL(__c6xabi_strasgi_64plus);
+
+/* lib functions */
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(ip_fast_csum);
diff --git a/arch/c6x/kernel/module.c b/arch/c6x/kernel/module.c
new file mode 100644
index 0000000..477fab8
--- /dev/null
+++ b/arch/c6x/kernel/module.c
@@ -0,0 +1,196 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2005, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Thomas Charleux (thomas.charleux@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+#include <linux/moduleloader.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/kernel.h>
+
+#ifdef DEBUG
+#define DBG(fmt...) pr_debug(fmt)
+#else
+#define DBG(fmt...)
+#endif
+
+static inline int fixup_pcr(u32 *ip, Elf32_Addr dest, u32 maskbits, int shift)
+{
+	u32 opcode;
+	long ep = (long)ip & ~31;
+	long delta = ((long)dest - ep) >> 2;
+	long mask = (1 << maskbits) - 1;
+
+	if ((delta >> (maskbits - 1)) == 0 ||
+	    (delta >> (maskbits - 1)) == -1) {
+		opcode = *ip;
+		opcode &= ~(mask << shift);
+		opcode |= ((delta & mask) << shift);
+		*ip = opcode;
+
+		DBG("REL PCR_S%d[%p] dest[0p] opcode[%08x]\n",
+		    maskbits, ip, (void *)dest, opcode);
+
+		return 0;
+	}
+	pr_err("PCR_S%d reloc %p -> %p out of range!\n",
+	       maskbits, ip, (void *)dest);
+
+	return -1;
+}
+
+/*
+ * apply a REL relocation
+ */
+int apply_relocate(Elf32_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	Elf32_Rel *rel = (void *) sechdrs[relsec].sh_addr;
+	Elf_Sym *sym;
+	u32 *location;
+	unsigned int i;
+	Elf32_Addr v;
+	Elf_Addr offset = 0;
+
+	DBG("Applying relocate section %u to %u with offset[0x%x]\n", relsec,
+	    sechdrs[relsec].sh_info, offset);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset - offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+
+		/* this is the adjustment to be made */
+		v = sym->st_value;
+
+		switch (ELF32_R_TYPE(rel[i].r_info)) {
+		case R_C6000_ABS32:
+			DBG("REL ABS32: [%p] = 0x%x\n", location, v);
+			*location = v;
+			break;
+		case R_C6000_ABS16:
+			DBG("REL ABS16: [%p] = 0x%x\n", location, v);
+			*(u16 *)location = v;
+			break;
+		case R_C6000_ABS8:
+			DBG("REL ABS8: [%p] = 0x%x\n", location, v);
+			*(u8 *)location = v;
+			break;
+		case R_C6000_PCR_S21:
+			if (fixup_pcr(location, v, 21, 7))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S12:
+			if (fixup_pcr(location, v, 12, 16))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S10:
+			if (fixup_pcr(location, v, 10, 13))
+				return -ENOEXEC;
+			break;
+		default:
+			pr_err("module %s: Unknown REL relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * apply a RELA relocation
+ */
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	Elf32_Rela *rel = (void *) sechdrs[relsec].sh_addr;
+	Elf_Sym *sym;
+	u32 *location, opcode;
+	unsigned int i;
+	Elf32_Addr v;
+	Elf_Addr offset = 0;
+
+	DBG("Applying relocate section %u to %u with offset 0x%x\n", relsec,
+	    sechdrs[relsec].sh_info, offset);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset - offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+
+		/* this is the adjustment to be made */
+		v = sym->st_value + rel[i].r_addend;
+
+		switch (ELF32_R_TYPE(rel[i].r_info)) {
+		case R_C6000_ABS32:
+			DBG("RELA ABS32: [%p] = 0x%x\n", location, v);
+			*location = v;
+			break;
+		case R_C6000_ABS16:
+			DBG("RELA ABS16: [%p] = 0x%x\n", location, v);
+			*(u16 *)location = v;
+			break;
+		case R_C6000_ABS8:
+			DBG("RELA ABS8: [%p] = 0x%x\n", location, v);
+			*(u8 *)location = v;
+			break;
+		case R_C6000_ABS_L16:
+			opcode = *location;
+			opcode &= ~0x7fff80;
+			opcode |= ((v & 0xffff) << 7);
+			DBG("RELA ABS_L16[%p] v[0x%x] opcode[0x%x]\n",
+			    location, v, opcode);
+			*location = opcode;
+			break;
+		case R_C6000_ABS_H16:
+			opcode = *location;
+			opcode &= ~0x7fff80;
+			opcode |= ((v >> 9) & 0x7fff80);
+			DBG("RELA ABS_H16[%p] v[0x%x] opcode[0x%x]\n",
+			    location, v, opcode);
+			*location = opcode;
+			break;
+		case R_C6000_PCR_S21:
+			if (fixup_pcr(location, v, 21, 7))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S12:
+			if (fixup_pcr(location, v, 12, 16))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S10:
+			if (fixup_pcr(location, v, 10, 13))
+				return -ENOEXEC;
+			break;
+		default:
+			pr_err("module %s: Unknown RELA relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+
+	return 0;
+}
-- 
1.7.6

