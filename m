Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0JTSLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:11:54 -0400
Received: from mail.perches.com ([173.55.12.10]:3379 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0JTSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:11:53 -0400
Subject: [PATCH] arch/blackfin/kernel/module.c: Use more standard pr_fmt
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 11:11:51 -0700
Message-ID: <1287598311.1813.225.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed pr_fmt(fmt) to make the format arguments match the format.
Changed an argument name in apply_relocate from me to mod
so that the pr_err is consistent with the other uses.
Added missing '\n' to a format.

Uncompiled/untested.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/blackfin/kernel/module.c |   49 ++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index a6dfa6b..33b3a95 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -4,7 +4,7 @@
  * Licensed under the GPL-2 or later
  */
 
-#define pr_fmt(fmt) "module %s: " fmt
+#define pr_fmt(fmt) "module %s: " fmt, mod->name
 
 #include <linux/moduleloader.h>
 #include <linux/elf.h>
@@ -57,8 +57,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l1_inst_sram_alloc(s->sh_size);
 			mod->arch.text_l1 = dest;
 			if (dest == NULL) {
-				pr_err("L1 inst memory allocation failed\n",
-					mod->name);
+				pr_err("L1 inst memory allocation failed\n");
 				return -1;
 			}
 			dma_memcpy(dest, (void *)s->sh_addr, s->sh_size);
@@ -70,8 +69,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l1_data_sram_alloc(s->sh_size);
 			mod->arch.data_a_l1 = dest;
 			if (dest == NULL) {
-				pr_err("L1 data memory allocation failed\n",
-					mod->name);
+				pr_err("L1 data memory allocation failed\n");
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
@@ -83,8 +81,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l1_data_sram_zalloc(s->sh_size);
 			mod->arch.bss_a_l1 = dest;
 			if (dest == NULL) {
-				pr_err("L1 data memory allocation failed\n",
-					mod->name);
+				pr_err("L1 data memory allocation failed\n");
 				return -1;
 			}
 
@@ -93,8 +90,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l1_data_B_sram_alloc(s->sh_size);
 			mod->arch.data_b_l1 = dest;
 			if (dest == NULL) {
-				pr_err("L1 data memory allocation failed\n",
-					mod->name);
+				pr_err("L1 data memory allocation failed\n");
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
@@ -104,8 +100,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l1_data_B_sram_alloc(s->sh_size);
 			mod->arch.bss_b_l1 = dest;
 			if (dest == NULL) {
-				pr_err("L1 data memory allocation failed\n",
-					mod->name);
+				pr_err("L1 data memory allocation failed\n");
 				return -1;
 			}
 			memset(dest, 0, s->sh_size);
@@ -117,8 +112,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l2_sram_alloc(s->sh_size);
 			mod->arch.text_l2 = dest;
 			if (dest == NULL) {
-				pr_err("L2 SRAM allocation failed\n",
-					mod->name);
+				pr_err("L2 SRAM allocation failed\n");
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
@@ -130,8 +124,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l2_sram_alloc(s->sh_size);
 			mod->arch.data_l2 = dest;
 			if (dest == NULL) {
-				pr_err("L2 SRAM allocation failed\n",
-					mod->name);
+				pr_err("L2 SRAM allocation failed\n");
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
@@ -143,8 +136,7 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 			dest = l2_sram_zalloc(s->sh_size);
 			mod->arch.bss_l2 = dest;
 			if (dest == NULL) {
-				pr_err("L2 SRAM allocation failed\n",
-					mod->name);
+				pr_err("L2 SRAM allocation failed\n");
 				return -1;
 			}
 
@@ -160,9 +152,9 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 
 int
 apply_relocate(Elf_Shdr * sechdrs, const char *strtab,
-	       unsigned int symindex, unsigned int relsec, struct module *me)
+	       unsigned int symindex, unsigned int relsec, struct module *mod)
 {
-	pr_err(".rel unsupported\n", me->name);
+	pr_err(".rel unsupported\n");
 	return -ENOEXEC;
 }
 
@@ -186,8 +178,8 @@ apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	Elf32_Sym *sym;
 	unsigned long location, value, size;
 
-	pr_debug("applying relocate section %u to %u\n", mod->name,
-		relsec, sechdrs[relsec].sh_info);
+	pr_debug("applying relocate section %u to %u\n",
+		 relsec, sechdrs[relsec].sh_info);
 
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		/* This is where to make the change */
@@ -203,14 +195,14 @@ apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 
 #ifdef CONFIG_SMP
 		if (location >= COREB_L1_DATA_A_START) {
-			pr_err("cannot relocate in L1: %u (SMP kernel)",
-				mod->name, ELF32_R_TYPE(rel[i].r_info));
+			pr_err("cannot relocate in L1: %u (SMP kernel)\n",
+			       ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
 #endif
 
 		pr_debug("location is %lx, value is %lx type is %d\n",
-			mod->name, location, value, ELF32_R_TYPE(rel[i].r_info));
+			 location, value, ELF32_R_TYPE(rel[i].r_info));
 
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
 
@@ -230,12 +222,12 @@ apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 		case R_BFIN_PCREL12_JUMP_S:
 		case R_BFIN_PCREL10:
 			pr_err("unsupported relocation: %u (no -mlong-calls?)\n",
-				mod->name, ELF32_R_TYPE(rel[i].r_info));
+			       ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 
 		default:
-			pr_err("unknown relocation: %u\n", mod->name,
-				ELF32_R_TYPE(rel[i].r_info));
+			pr_err("unknown relocation: %u\n",
+			       ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
 
@@ -251,8 +243,7 @@ apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 			isram_memcpy((void *)location, &value, size);
 			break;
 		default:
-			pr_err("invalid relocation for %#lx\n",
-				mod->name, location);
+			pr_err("invalid relocation for %#lx\n", location);
 			return -ENOEXEC;
 		}
 	}


