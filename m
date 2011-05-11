Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1EKVGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:06:46 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756060Ab1EKVGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:44 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] C6X: add support for DSBT binary format
Date: Wed, 11 May 2011 16:14:03 -0400
Message-Id: <1305144843-5058-17-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-16-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
 <1305144843-5058-8-git-send-email-msalter@redhat.com>
 <1305144843-5058-9-git-send-email-msalter@redhat.com>
 <1305144843-5058-10-git-send-email-msalter@redhat.com>
 <1305144843-5058-11-git-send-email-msalter@redhat.com>
 <1305144843-5058-12-git-send-email-msalter@redhat.com>
 <1305144843-5058-13-git-send-email-msalter@redhat.com>
 <1305144843-5058-14-git-send-email-msalter@redhat.com>
 <1305144843-5058-15-git-send-email-msalter@redhat.com>
 <1305144843-5058-16-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the C6X-specifc bits to use the DSBT binary format.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/configs/ti_dsk6455_defconfig       |    1 +
 arch/c6x/configs/ti_evmc6457_defconfig      |    1 +
 arch/c6x/configs/ti_evmc6472_defconfig      |    1 +
 arch/c6x/configs/ti_evmc6474_defconfig      |    1 +
 arch/c6x/configs/ti_evmc6474_lite_defconfig |    1 +
 arch/c6x/include/asm/elf.h                  |   14 ++++++++++++++
 arch/c6x/include/asm/mmu.h                  |    4 ++++
 arch/c6x/include/asm/ptrace.h               |   12 ++++++++++++
 arch/c6x/kernel/ptrace.c                    |   25 ++++++++++++++++++++++++-
 9 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/arch/c6x/configs/ti_dsk6455_defconfig b/arch/c6x/configs/ti_dsk6455_defconfig
index 3487af4..8112a70 100644
--- a/arch/c6x/configs/ti_dsk6455_defconfig
+++ b/arch/c6x/configs/ti_dsk6455_defconfig
@@ -229,6 +229,7 @@ CONFIG_HIGH_RES_TIMERS=y
 #
 # Executable file formats
 #
+CONFIG_BINFMT_ELF_DSBT=y
 # CONFIG_BINFMT_FLAT is not set
 # CONFIG_HAVE_AOUT is not set
 # CONFIG_BINFMT_MISC is not set
diff --git a/arch/c6x/configs/ti_evmc6457_defconfig b/arch/c6x/configs/ti_evmc6457_defconfig
index e18b095..841f15a 100644
--- a/arch/c6x/configs/ti_evmc6457_defconfig
+++ b/arch/c6x/configs/ti_evmc6457_defconfig
@@ -229,6 +229,7 @@ CONFIG_HIGH_RES_TIMERS=y
 #
 # Executable file formats
 #
+CONFIG_BINFMT_ELF_DSBT=y
 # CONFIG_BINFMT_FLAT is not set
 # CONFIG_HAVE_AOUT is not set
 # CONFIG_BINFMT_MISC is not set
diff --git a/arch/c6x/configs/ti_evmc6472_defconfig b/arch/c6x/configs/ti_evmc6472_defconfig
index 14ae81b..b18e9ee 100644
--- a/arch/c6x/configs/ti_evmc6472_defconfig
+++ b/arch/c6x/configs/ti_evmc6472_defconfig
@@ -231,6 +231,7 @@ CONFIG_HIGH_RES_TIMERS=y
 #
 # Executable file formats
 #
+CONFIG_BINFMT_ELF_DSBT=y
 # CONFIG_BINFMT_FLAT is not set
 # CONFIG_HAVE_AOUT is not set
 # CONFIG_BINFMT_MISC is not set
diff --git a/arch/c6x/configs/ti_evmc6474_defconfig b/arch/c6x/configs/ti_evmc6474_defconfig
index 472ad6b..12f1808 100644
--- a/arch/c6x/configs/ti_evmc6474_defconfig
+++ b/arch/c6x/configs/ti_evmc6474_defconfig
@@ -229,6 +229,7 @@ CONFIG_HIGH_RES_TIMERS=y
 #
 # Executable file formats
 #
+CONFIG_BINFMT_ELF_DSBT=y
 # CONFIG_BINFMT_FLAT is not set
 # CONFIG_HAVE_AOUT is not set
 # CONFIG_BINFMT_MISC is not set
diff --git a/arch/c6x/configs/ti_evmc6474_lite_defconfig b/arch/c6x/configs/ti_evmc6474_lite_defconfig
index e25e8ac..044cf47 100644
--- a/arch/c6x/configs/ti_evmc6474_lite_defconfig
+++ b/arch/c6x/configs/ti_evmc6474_lite_defconfig
@@ -229,6 +229,7 @@ CONFIG_HIGH_RES_TIMERS=y
 #
 # Executable file formats
 #
+CONFIG_BINFMT_ELF_DSBT=y
 # CONFIG_BINFMT_FLAT is not set
 # CONFIG_HAVE_AOUT is not set
 # CONFIG_BINFMT_MISC is not set
diff --git a/arch/c6x/include/asm/elf.h b/arch/c6x/include/asm/elf.h
index 272c3ae..d57bb17 100644
--- a/arch/c6x/include/asm/elf.h
+++ b/arch/c6x/include/asm/elf.h
@@ -32,6 +32,7 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
  */
 #define elf_check_arch(x) ((x)->e_machine == EM_TI_C6000)
 
+#define elf_check_dsbt(x) (1)
 #define elf_check_const_displacement(x) (1)
 
 /*
@@ -67,6 +68,14 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
 
 #define ELF_PLATFORM  (NULL)
 
+#define ELF_DSBT_PLAT_INIT(_regs, _exec_map, _interp_map, _dynamic_addr, _dsbt_table) \
+do {								\
+	_regs->b4	= (_exec_map);				\
+	_regs->a6	= (_interp_map);			\
+	_regs->b6	= (_dynamic_addr);			\
+	_regs->dp	= (_dsbt_table);			\
+} while (0)
+
 #define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 /* C6X specific section types */
@@ -112,4 +121,9 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
 #define R_C6000_FPHEAD		254
 #define R_C6000_NOCMP		255
 
+/* for binfmt_elf_dsbt */
+#define DT_ARCH_DSBT_BASE  DT_C6000_DSBT_BASE
+#define DT_ARCH_DSBT_SIZE  DT_C6000_DSBT_SIZE
+#define DT_ARCH_DSBT_INDEX DT_C6000_DSBT_INDEX
+
 #endif /*_ASM_C6X_ELF_H */
diff --git a/arch/c6x/include/asm/mmu.h b/arch/c6x/include/asm/mmu.h
index 8d376e9..1d9e9c1 100644
--- a/arch/c6x/include/asm/mmu.h
+++ b/arch/c6x/include/asm/mmu.h
@@ -15,6 +15,10 @@
 
 typedef struct {
 	unsigned long		end_brk;
+#ifdef CONFIG_BINFMT_ELF_DSBT
+	unsigned long	exec_dsbt_loadmap;
+	unsigned long	interp_dsbt_loadmap;
+#endif
 } mm_context_t;
 
 #endif /* _ASM_C6X_MMU_H */
diff --git a/arch/c6x/include/asm/ptrace.h b/arch/c6x/include/asm/ptrace.h
index 7e94de8..437df6f 100644
--- a/arch/c6x/include/asm/ptrace.h
+++ b/arch/c6x/include/asm/ptrace.h
@@ -162,11 +162,23 @@ struct pt_regs {
 	REG_PAIR(sp, dp);
 };
 
+/*
+ * These are 'magic' values for PTRACE_PEEKUSR that return info about where a
+ * process is located in memory.
+ */
+#define PT_TEXT_ADDR		  0x10000
+#define PT_DATA_ADDR		  0x10004
+#define PT_TEXT_END_ADDR	  0x10008
+
 #define PTRACE_GETREGS		  12
 #define PTRACE_SETREGS		  13
 #define PTRACE_GETFPREGS	  14
 #define PTRACE_SETFPREGS	  15
 
+#define PTRACE_GETDSBT		 31	/* get the ELF DSBT loadmap address */
+#define PTRACE_GETDSBT_EXEC	  0	/* [addr] request the executable loadmap */
+#define PTRACE_GETDSBT_INTERP	  1	/* [addr] request the interpreter loadmap */
+
 #ifdef __KERNEL__
 
 #define DEFAULT_CSR		  0x0001	/* interrupt enable by default */
diff --git a/arch/c6x/kernel/ptrace.c b/arch/c6x/kernel/ptrace.c
index fd38463..aa853e4 100644
--- a/arch/c6x/kernel/ptrace.c
+++ b/arch/c6x/kernel/ptrace.c
@@ -167,7 +167,13 @@ static int ptrace_read_user(struct task_struct *tsk, unsigned long off,
 
 
 	tmp = 0;
-	if (off < PT_REG_SIZE)
+	if (index == PT_TEXT_ADDR)
+		tmp = tsk->mm->start_code;
+	else if (index == PT_DATA_ADDR)
+		tmp = tsk->mm->start_data;
+	else if (index == PT_TEXT_END_ADDR)
+		tmp = tsk->mm->end_code;
+	else if (off < PT_REG_SIZE)
 		tmp = get_reg(tsk, index);
 	else
 		return -EIO;
@@ -250,6 +256,23 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 		break;
 
+	case PTRACE_GETDSBT: {
+		tmp = 0;
+		switch (addr) {
+		case PTRACE_GETDSBT_EXEC:
+			tmp = child->mm->context.exec_dsbt_loadmap;
+			break;
+		case PTRACE_GETDSBT_INTERP:
+			tmp = child->mm->context.interp_dsbt_loadmap;
+			break;
+		default:
+			break;
+		}
+
+		ret = put_user(tmp, (unsigned long __user *)data);
+		break;
+	}
+
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
-- 
1.6.2.5

