Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab2EJXmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:42:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab2EJXml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:42:41 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/29] MODSIGN: Add indications of module ELF types [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:42:31 +0100
Message-ID: <20120510234231.4137.83659.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add per-arch indications of module ELF types and relocation table entry types.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 arch/alpha/include/asm/module.h   |    3 +++
 arch/arm/include/asm/module.h     |    5 +++++
 arch/cris/include/asm/module.h    |    5 +++++
 arch/h8300/include/asm/module.h   |    5 +++++
 arch/ia64/include/asm/module.h    |    5 +++++
 arch/m32r/include/asm/module.h    |    5 +++++
 arch/m68k/include/asm/module.h    |    5 +++++
 arch/mips/include/asm/module.h    |   12 ++++++++++--
 arch/parisc/include/asm/module.h  |    8 ++++++++
 arch/powerpc/include/asm/module.h |   10 ++++++++++
 arch/s390/include/asm/module.h    |    3 +++
 arch/x86/include/asm/module.h     |    6 ++++++
 include/asm-generic/module.h      |   10 ++++++++++
 13 files changed, 80 insertions(+), 2 deletions(-)


diff --git a/arch/alpha/include/asm/module.h b/arch/alpha/include/asm/module.h
index 7b63743..3d5a3ea 100644
--- a/arch/alpha/include/asm/module.h
+++ b/arch/alpha/include/asm/module.h
@@ -6,6 +6,7 @@ struct mod_arch_specific
 	unsigned int gotsecindex;
 };
 
+#define MODULES_ARE_ELF64
 #define Elf_Sym Elf64_Sym
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Ehdr Elf64_Ehdr
@@ -13,6 +14,8 @@ struct mod_arch_specific
 #define Elf_Dyn Elf64_Dyn
 #define Elf_Rel Elf64_Rel
 #define Elf_Rela Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 
 #define ARCH_SHF_SMALL SHF_ALPHA_GPREL
 
diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 6c6809f..f47d9cd 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -1,9 +1,14 @@
 #ifndef _ASM_ARM_MODULE_H
 #define _ASM_ARM_MODULE_H
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 struct unwind_table;
 
diff --git a/arch/cris/include/asm/module.h b/arch/cris/include/asm/module.h
index 7ee7231..03f7b2e 100644
--- a/arch/cris/include/asm/module.h
+++ b/arch/cris/include/asm/module.h
@@ -3,7 +3,12 @@
 /* cris is simple */
 struct mod_arch_specific { };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #endif /* _ASM_CRIS_MODULE_H */
diff --git a/arch/h8300/include/asm/module.h b/arch/h8300/include/asm/module.h
index 8e46724..5140128 100644
--- a/arch/h8300/include/asm/module.h
+++ b/arch/h8300/include/asm/module.h
@@ -4,8 +4,13 @@
  * This file contains the H8/300 architecture specific module code.
  */
 struct mod_arch_specific { };
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #endif /* _ASM_H8/300_MODULE_H */
diff --git a/arch/ia64/include/asm/module.h b/arch/ia64/include/asm/module.h
index 908eaef..3c4cd94 100644
--- a/arch/ia64/include/asm/module.h
+++ b/arch/ia64/include/asm/module.h
@@ -29,9 +29,14 @@ struct mod_arch_specific {
 	unsigned int next_got_entry;	/* index of next available got entry */
 };
 
+#define MODULES_ARE_ELF64
 #define Elf_Shdr	Elf64_Shdr
 #define Elf_Sym		Elf64_Sym
 #define Elf_Ehdr	Elf64_Ehdr
+#define Elf_Rel		Elf64_Rel
+#define Elf_Rela	Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 
 #define MODULE_PROC_FAMILY	"ia64"
 #define MODULE_ARCH_VERMAGIC	MODULE_PROC_FAMILY \
diff --git a/arch/m32r/include/asm/module.h b/arch/m32r/include/asm/module.h
index eb73ee0..7146455 100644
--- a/arch/m32r/include/asm/module.h
+++ b/arch/m32r/include/asm/module.h
@@ -3,8 +3,13 @@
 
 struct mod_arch_specific { };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #endif /* _ASM_M32R_MODULE_H */
diff --git a/arch/m68k/include/asm/module.h b/arch/m68k/include/asm/module.h
index edffe66..9e2cd74 100644
--- a/arch/m68k/include/asm/module.h
+++ b/arch/m68k/include/asm/module.h
@@ -36,8 +36,13 @@ struct module;
 extern void module_fixup(struct module *mod, struct m68k_fixup_info *start,
 			 struct m68k_fixup_info *end);
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #endif /* _ASM_M68K_MODULE_H */
diff --git a/arch/mips/include/asm/module.h b/arch/mips/include/asm/module.h
index 7467d1d..4404cca 100644
--- a/arch/mips/include/asm/module.h
+++ b/arch/mips/include/asm/module.h
@@ -33,11 +33,15 @@ typedef struct {
 } Elf64_Mips_Rela;
 
 #ifdef CONFIG_32BIT
-
+#define MODULES_ARE_ELF32
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define Elf_Ehdr	Elf32_Ehdr
 #define Elf_Addr	Elf32_Addr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #define Elf_Mips_Rel	Elf32_Rel
 #define Elf_Mips_Rela	Elf32_Rela
@@ -48,11 +52,15 @@ typedef struct {
 #endif
 
 #ifdef CONFIG_64BIT
-
+#define MODULES_ARE_ELF64
 #define Elf_Shdr	Elf64_Shdr
 #define Elf_Sym		Elf64_Sym
 #define Elf_Ehdr	Elf64_Ehdr
 #define Elf_Addr	Elf64_Addr
+#define Elf_Rel		Elf64_Rel
+#define Elf_Rela	Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 
 #define Elf_Mips_Rel	Elf64_Mips_Rel
 #define Elf_Mips_Rela	Elf64_Mips_Rela
diff --git a/arch/parisc/include/asm/module.h b/arch/parisc/include/asm/module.h
index 1f41234..3e13f69 100644
--- a/arch/parisc/include/asm/module.h
+++ b/arch/parisc/include/asm/module.h
@@ -4,17 +4,25 @@
  * This file contains the parisc architecture specific module code.
  */
 #ifdef CONFIG_64BIT
+#define MODULES_ARE_ELF64
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Sym Elf64_Sym
 #define Elf_Ehdr Elf64_Ehdr
 #define Elf_Addr Elf64_Addr
+#define Elf_Rel	 Elf64_Rel
 #define Elf_Rela Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 #else
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
 #define Elf_Addr Elf32_Addr
+#define Elf_Rel  Elf32_Rel
 #define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #endif
 
 struct unwind_table;
diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index 0192a4e..e949704 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -60,16 +60,26 @@ struct mod_arch_specific {
  */
 
 #ifdef __powerpc64__
+#    define MODULES_ARE_ELF64
 #    define Elf_Shdr	Elf64_Shdr
 #    define Elf_Sym	Elf64_Sym
 #    define Elf_Ehdr	Elf64_Ehdr
+#    define Elf_Rel Elf64_Rel
+#    define Elf_Rela Elf64_Rela
+#    define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#    define ELF_R_SYM(X)	ELF64_R_SYM(X)
 #    ifdef MODULE
 	asm(".section .stubs,\"ax\",@nobits; .align 3; .previous");
 #    endif
 #else
+#    define MODULES_ARE_ELF32
 #    define Elf_Shdr	Elf32_Shdr
 #    define Elf_Sym	Elf32_Sym
 #    define Elf_Ehdr	Elf32_Ehdr
+#    define Elf_Rel Elf32_Rel
+#    define Elf_Rela Elf32_Rela
+#    define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#    define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #    ifdef MODULE
 	asm(".section .plt,\"ax\",@nobits; .align 3; .previous");
 	asm(".section .init.plt,\"ax\",@nobits; .align 3; .previous");
diff --git a/arch/s390/include/asm/module.h b/arch/s390/include/asm/module.h
index 1cc1c5a..b64dab0 100644
--- a/arch/s390/include/asm/module.h
+++ b/arch/s390/include/asm/module.h
@@ -29,14 +29,17 @@ struct mod_arch_specific
 };
 
 #ifdef __s390x__
+#define MODULES_ARE_ELF64
 #define ElfW(x) Elf64_ ## x
 #define ELFW(x) ELF64_ ## x
 #else
+#define MODULES_ARE_ELF32
 #define ElfW(x) Elf32_ ## x
 #define ELFW(x) ELF32_ ## x
 #endif
 
 #define Elf_Addr ElfW(Addr)
+#define Elf_Rel ElfW(Rel)
 #define Elf_Rela ElfW(Rela)
 #define Elf_Shdr ElfW(Shdr)
 #define Elf_Sym ElfW(Sym)
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 9eae775..724f173 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -63,4 +63,10 @@
 # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
 #endif
 
+#ifdef CONFIG_X86_32
+#define MODULE_HAS_ELF_REL_ONLY
+#else
+#define MODULE_HAS_ELF_RELA_ONLY
+#endif
+
 #endif /* _ASM_X86_MODULE_H */
diff --git a/include/asm-generic/module.h b/include/asm-generic/module.h
index ed5b44d..e053617b 100644
--- a/include/asm-generic/module.h
+++ b/include/asm-generic/module.h
@@ -10,13 +10,23 @@ struct mod_arch_specific
 };
 
 #ifdef CONFIG_64BIT
+#define MODULES_ARE_ELF64
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Sym Elf64_Sym
 #define Elf_Ehdr Elf64_Ehdr
+#define Elf_Rel		Elf64_Rel
+#define Elf_Rela	Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 #else
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #endif
 
 #endif /* __ASM_GENERIC_MODULE_H */

