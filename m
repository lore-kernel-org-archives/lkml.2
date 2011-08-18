Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1HRTDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:03:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44277 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1HRTDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:03:20 -0400
Date: Thu, 18 Aug 2011 20:03:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 26/91] um: merge arch/um/sys-{i386,x86_64}
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7s7-0007cM-Cg@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                                   |    6 +-
 arch/um/Makefile-i386                              |    2 +-
 arch/um/Makefile-x86_64                            |    2 +-
 arch/um/sys-i386/Makefile                          |   24 ---------
 arch/um/sys-i386/bug.c                             |   21 --------
 arch/um/sys-i386/ksyms.c                           |    5 --
 arch/um/sys-i386/user-offsets.c                    |   53 --------------------
 arch/um/sys-x86/Makefile                           |   45 +++++++++++++++++
 arch/um/{sys-x86_64 => sys-x86}/bug.c              |    0
 arch/um/{sys-i386/bugs.c => sys-x86/bugs_32.c}     |    0
 arch/um/{sys-x86_64/bugs.c => sys-x86/bugs_64.c}   |    0
 .../{sys-i386/checksum.S => sys-x86/checksum_32.S} |    0
 arch/um/{sys-i386/delay.c => sys-x86/delay_32.c}   |    0
 arch/um/{sys-x86_64/delay.c => sys-x86/delay_64.c} |    0
 arch/um/{sys-i386 => sys-x86}/elfcore.c            |    0
 arch/um/{sys-i386 => sys-x86}/fault.c              |    0
 arch/um/{sys-x86_64 => sys-x86}/ksyms.c            |    2 +
 arch/um/{sys-i386 => sys-x86}/ldt.c                |    0
 arch/um/{sys-i386/mem.c => sys-x86/mem_32.c}       |    0
 arch/um/{sys-x86_64/mem.c => sys-x86/mem_64.c}     |    0
 arch/um/{sys-i386/ptrace.c => sys-x86/ptrace_32.c} |    0
 .../{sys-x86_64/ptrace.c => sys-x86/ptrace_64.c}   |    0
 arch/um/{sys-i386 => sys-x86}/ptrace_user.c        |    2 +-
 arch/um/{sys-i386/setjmp.S => sys-x86/setjmp_32.S} |    0
 .../{sys-x86_64/setjmp.S => sys-x86/setjmp_64.S}   |    0
 arch/um/{sys-i386/signal.c => sys-x86/signal_32.c} |    0
 .../{sys-x86_64/signal.c => sys-x86/signal_64.c}   |    0
 arch/um/{sys-i386/stub.S => sys-x86/stub_32.S}     |    0
 arch/um/{sys-x86_64/stub.S => sys-x86/stub_64.S}   |    0
 .../stub_segv.c => sys-x86/stub_segv_32.c}         |    0
 .../stub_segv.c => sys-x86/stub_segv_64.c}         |    0
 .../sys_call_table_32.S}                           |    0
 .../sys_call_table_64.c}                           |    0
 .../{sys-i386/syscalls.c => sys-x86/syscalls_32.c} |    0
 .../syscalls.c => sys-x86/syscalls_64.c}           |    0
 arch/um/{sys-i386/sysrq.c => sys-x86/sysrq_32.c}   |    0
 arch/um/{sys-x86_64/sysrq.c => sys-x86/sysrq_64.c} |    0
 arch/um/{sys-i386/tls.c => sys-x86/tls_32.c}       |    0
 arch/um/{sys-x86_64/tls.c => sys-x86/tls_64.c}     |    0
 arch/um/{sys-x86_64 => sys-x86}/user-offsets.c     |   33 ++++++++++--
 arch/um/{sys-x86_64 => sys-x86}/vdso/Makefile      |    0
 arch/um/{sys-x86_64 => sys-x86}/vdso/checkundef.sh |    0
 arch/um/{sys-x86_64 => sys-x86}/vdso/um_vdso.c     |    0
 .../{sys-x86_64 => sys-x86}/vdso/vdso-layout.lds.S |    0
 arch/um/{sys-x86_64 => sys-x86}/vdso/vdso-note.S   |    0
 arch/um/{sys-x86_64 => sys-x86}/vdso/vdso.S        |    2 +-
 arch/um/{sys-x86_64 => sys-x86}/vdso/vdso.lds.S    |    0
 arch/um/{sys-x86_64 => sys-x86}/vdso/vma.c         |    0
 arch/um/sys-x86_64/Makefile                        |   27 ----------
 arch/um/sys-x86_64/fault.c                         |   28 ----------
 arch/um/sys-x86_64/ptrace_user.c                   |   22 --------
 51 files changed, 81 insertions(+), 193 deletions(-)
 delete mode 100644 arch/um/sys-i386/Makefile
 delete mode 100644 arch/um/sys-i386/bug.c
 delete mode 100644 arch/um/sys-i386/ksyms.c
 delete mode 100644 arch/um/sys-i386/user-offsets.c
 create mode 100644 arch/um/sys-x86/Makefile
 rename arch/um/{sys-x86_64 => sys-x86}/bug.c (100%)
 rename arch/um/{sys-i386/bugs.c => sys-x86/bugs_32.c} (100%)
 rename arch/um/{sys-x86_64/bugs.c => sys-x86/bugs_64.c} (100%)
 rename arch/um/{sys-i386/checksum.S => sys-x86/checksum_32.S} (100%)
 rename arch/um/{sys-i386/delay.c => sys-x86/delay_32.c} (100%)
 rename arch/um/{sys-x86_64/delay.c => sys-x86/delay_64.c} (100%)
 rename arch/um/{sys-i386 => sys-x86}/elfcore.c (100%)
 rename arch/um/{sys-i386 => sys-x86}/fault.c (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/ksyms.c (90%)
 rename arch/um/{sys-i386 => sys-x86}/ldt.c (100%)
 rename arch/um/{sys-i386/mem.c => sys-x86/mem_32.c} (100%)
 rename arch/um/{sys-x86_64/mem.c => sys-x86/mem_64.c} (100%)
 rename arch/um/{sys-i386/ptrace.c => sys-x86/ptrace_32.c} (100%)
 rename arch/um/{sys-x86_64/ptrace.c => sys-x86/ptrace_64.c} (100%)
 rename arch/um/{sys-i386 => sys-x86}/ptrace_user.c (94%)
 rename arch/um/{sys-i386/setjmp.S => sys-x86/setjmp_32.S} (100%)
 rename arch/um/{sys-x86_64/setjmp.S => sys-x86/setjmp_64.S} (100%)
 rename arch/um/{sys-i386/signal.c => sys-x86/signal_32.c} (100%)
 rename arch/um/{sys-x86_64/signal.c => sys-x86/signal_64.c} (100%)
 rename arch/um/{sys-i386/stub.S => sys-x86/stub_32.S} (100%)
 rename arch/um/{sys-x86_64/stub.S => sys-x86/stub_64.S} (100%)
 rename arch/um/{sys-i386/stub_segv.c => sys-x86/stub_segv_32.c} (100%)
 rename arch/um/{sys-x86_64/stub_segv.c => sys-x86/stub_segv_64.c} (100%)
 rename arch/um/{sys-i386/sys_call_table.S => sys-x86/sys_call_table_32.S} (100%)
 rename arch/um/{sys-x86_64/syscall_table.c => sys-x86/sys_call_table_64.c} (100%)
 rename arch/um/{sys-i386/syscalls.c => sys-x86/syscalls_32.c} (100%)
 rename arch/um/{sys-x86_64/syscalls.c => sys-x86/syscalls_64.c} (100%)
 rename arch/um/{sys-i386/sysrq.c => sys-x86/sysrq_32.c} (100%)
 rename arch/um/{sys-x86_64/sysrq.c => sys-x86/sysrq_64.c} (100%)
 rename arch/um/{sys-i386/tls.c => sys-x86/tls_32.c} (100%)
 rename arch/um/{sys-x86_64/tls.c => sys-x86/tls_64.c} (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/user-offsets.c (70%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/Makefile (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/checkundef.sh (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/um_vdso.c (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/vdso-layout.lds.S (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/vdso-note.S (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/vdso.S (69%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/vdso.lds.S (100%)
 rename arch/um/{sys-x86_64 => sys-x86}/vdso/vma.c (100%)
 delete mode 100644 arch/um/sys-x86_64/Makefile
 delete mode 100644 arch/um/sys-x86_64/fault.c
 delete mode 100644 arch/um/sys-x86_64/ptrace_user.c

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 184494d..bd0587e 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -121,8 +121,8 @@ archclean:
 
 # Generated files
 
-$(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s: FORCE
-	$(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(SUBARCH) $@
+$(ARCH_DIR)/sys-$(HEADER_ARCH)/user-offsets.s: FORCE
+	$(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(HEADER_ARCH) $@
 
 define filechk_gen-asm-offsets
         (set -e; \
@@ -137,7 +137,7 @@ define filechk_gen-asm-offsets
          echo ""; )
 endef
 
-include/generated/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
+include/generated/user_constants.h: $(ARCH_DIR)/sys-$(HEADER_ARCH)/user-offsets.s
 	$(call filechk,gen-asm-offsets)
 
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 302cbe5..7e5f1ba 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -1,4 +1,4 @@
-core-y += arch/um/sys-i386/ arch/x86/crypto/
+core-y += arch/um/sys-x86/ arch/x86/crypto/
 
 TOP_ADDR := $(CONFIG_TOP_ADDR)
 
diff --git a/arch/um/Makefile-x86_64 b/arch/um/Makefile-x86_64
index a9cd7e7..92d8f8f 100644
--- a/arch/um/Makefile-x86_64
+++ b/arch/um/Makefile-x86_64
@@ -1,7 +1,7 @@
 # Copyright 2003 - 2004 Pathscale, Inc
 # Released under the GPL
 
-core-y += arch/um/sys-x86_64/ arch/x86/crypto/
+core-y += arch/um/sys-x86/ arch/x86/crypto/
 START := 0x60000000
 
 _extra_flags_ = -fno-builtin -m64
diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
deleted file mode 100644
index 231bb98..0000000
--- a/arch/um/sys-i386/Makefile
+++ /dev/null
@@ -1,24 +0,0 @@
-#
-# Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
-#
-
-obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
-	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o mem.o
-
-obj-$(CONFIG_BINFMT_ELF) += elfcore.o
-
-subarch-obj-y = lib/string_32.o lib/atomic64_32.o lib/atomic64_cx8_32.o
-subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
-subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
-subarch-obj-$(CONFIG_MODULES) += kernel/module.o
-
-USER_OBJS := bugs.o ptrace_user.o fault.o
-
-extra-y += user-offsets.s
-$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS)
-
-UNPROFILE_OBJS := stub_segv.o
-CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
-
-include arch/um/scripts/Makefile.rules
diff --git a/arch/um/sys-i386/bug.c b/arch/um/sys-i386/bug.c
deleted file mode 100644
index 8d4f273..0000000
--- a/arch/um/sys-i386/bug.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * Copyright (C) 2006 Jeff Dike (jdike@addtoit.com)
- * Licensed under the GPL V2
- */
-
-#include <linux/uaccess.h>
-#include <asm/errno.h>
-
-/* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
- * that's not relevant in skas mode.
- */
-
-int is_valid_bugaddr(unsigned long eip)
-{
-	unsigned short ud2;
-
-	if (probe_kernel_address((unsigned short __user *)eip, ud2))
-		return 0;
-
-	return ud2 == 0x0b0f;
-}
diff --git a/arch/um/sys-i386/ksyms.c b/arch/um/sys-i386/ksyms.c
deleted file mode 100644
index bfbefd3..0000000
--- a/arch/um/sys-i386/ksyms.c
+++ /dev/null
@@ -1,5 +0,0 @@
-#include "linux/module.h"
-#include "asm/checksum.h"
-
-/* Networking helper routines. */
-EXPORT_SYMBOL(csum_partial);
diff --git a/arch/um/sys-i386/user-offsets.c b/arch/um/sys-i386/user-offsets.c
deleted file mode 100644
index 5f883bf..0000000
--- a/arch/um/sys-i386/user-offsets.c
+++ /dev/null
@@ -1,53 +0,0 @@
-#include <stdio.h>
-#include <stddef.h>
-#include <signal.h>
-#include <sys/poll.h>
-#include <sys/user.h>
-#include <sys/mman.h>
-#include <asm/ptrace.h>
-
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define DEFINE_LONGS(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val/sizeof(unsigned long)))
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));
-
-void foo(void)
-{
-	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
-	OFFSET(HOST_SC_ERR, sigcontext, err);
-	OFFSET(HOST_SC_CR2, sigcontext, cr2);
-
-	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
-	DEFINE_LONGS(HOST_FPX_SIZE, sizeof(struct user_fpxregs_struct));
-
-	DEFINE(HOST_IP, EIP);
-	DEFINE(HOST_SP, UESP);
-	DEFINE(HOST_EFLAGS, EFL);
-	DEFINE(HOST_EAX, EAX);
-	DEFINE(HOST_EBX, EBX);
-	DEFINE(HOST_ECX, ECX);
-	DEFINE(HOST_EDX, EDX);
-	DEFINE(HOST_ESI, ESI);
-	DEFINE(HOST_EDI, EDI);
-	DEFINE(HOST_EBP, EBP);
-	DEFINE(HOST_CS, CS);
-	DEFINE(HOST_SS, SS);
-	DEFINE(HOST_DS, DS);
-	DEFINE(HOST_FS, FS);
-	DEFINE(HOST_ES, ES);
-	DEFINE(HOST_GS, GS);
-	DEFINE(UM_FRAME_SIZE, sizeof(struct user_regs_struct));
-
-	/* XXX Duplicated between i386 and x86_64 */
-	DEFINE(UM_POLLIN, POLLIN);
-	DEFINE(UM_POLLPRI, POLLPRI);
-	DEFINE(UM_POLLOUT, POLLOUT);
-
-	DEFINE(UM_PROT_READ, PROT_READ);
-	DEFINE(UM_PROT_WRITE, PROT_WRITE);
-	DEFINE(UM_PROT_EXEC, PROT_EXEC);
-}
diff --git a/arch/um/sys-x86/Makefile b/arch/um/sys-x86/Makefile
new file mode 100644
index 0000000..671de0b
--- /dev/null
+++ b/arch/um/sys-x86/Makefile
@@ -0,0 +1,45 @@
+#
+# Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+#
+
+ifeq ($(CONFIG_X86_32),y)
+	BITS := 32
+else
+	BITS := 64
+endif
+
+obj-y = bug.o bugs_$(BITS).o delay_$(BITS).o fault.o ksyms.o ldt.o \
+	ptrace_$(BITS).o ptrace_user.o setjmp_$(BITS).o signal_$(BITS).o \
+	stub_$(BITS).o stub_segv_$(BITS).o syscalls_$(BITS).o \
+	sys_call_table_$(BITS).o sysrq_$(BITS).o tls_$(BITS).o mem_$(BITS).o
+
+ifeq ($(CONFIG_X86_32),y)
+
+obj-y += checksum_32.o
+obj-$(CONFIG_BINFMT_ELF) += elfcore.o
+
+subarch-obj-y = lib/string_32.o lib/atomic64_32.o lib/atomic64_cx8_32.o
+subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
+subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
+subarch-obj-$(CONFIG_MODULES) += kernel/module.o
+
+else
+
+obj-y += vdso/
+
+subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
+		lib/rwsem.o
+
+endif
+
+subarch-obj-$(CONFIG_MODULES) += kernel/module.o
+
+USER_OBJS := bugs_$(BITS).o ptrace_user.o fault.o
+
+extra-y += user-offsets.s
+$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS)
+
+UNPROFILE_OBJS := stub_segv.o
+CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
+
+include arch/um/scripts/Makefile.rules
diff --git a/arch/um/sys-x86_64/bug.c b/arch/um/sys-x86/bug.c
similarity index 100%
rename from arch/um/sys-x86_64/bug.c
rename to arch/um/sys-x86/bug.c
diff --git a/arch/um/sys-i386/bugs.c b/arch/um/sys-x86/bugs_32.c
similarity index 100%
rename from arch/um/sys-i386/bugs.c
rename to arch/um/sys-x86/bugs_32.c
diff --git a/arch/um/sys-x86_64/bugs.c b/arch/um/sys-x86/bugs_64.c
similarity index 100%
rename from arch/um/sys-x86_64/bugs.c
rename to arch/um/sys-x86/bugs_64.c
diff --git a/arch/um/sys-i386/checksum.S b/arch/um/sys-x86/checksum_32.S
similarity index 100%
rename from arch/um/sys-i386/checksum.S
rename to arch/um/sys-x86/checksum_32.S
diff --git a/arch/um/sys-i386/delay.c b/arch/um/sys-x86/delay_32.c
similarity index 100%
rename from arch/um/sys-i386/delay.c
rename to arch/um/sys-x86/delay_32.c
diff --git a/arch/um/sys-x86_64/delay.c b/arch/um/sys-x86/delay_64.c
similarity index 100%
rename from arch/um/sys-x86_64/delay.c
rename to arch/um/sys-x86/delay_64.c
diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-x86/elfcore.c
similarity index 100%
rename from arch/um/sys-i386/elfcore.c
rename to arch/um/sys-x86/elfcore.c
diff --git a/arch/um/sys-i386/fault.c b/arch/um/sys-x86/fault.c
similarity index 100%
rename from arch/um/sys-i386/fault.c
rename to arch/um/sys-x86/fault.c
diff --git a/arch/um/sys-x86_64/ksyms.c b/arch/um/sys-x86/ksyms.c
similarity index 90%
rename from arch/um/sys-x86_64/ksyms.c
rename to arch/um/sys-x86/ksyms.c
index 1db2fce..2e8f43e 100644
--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86/ksyms.c
@@ -2,10 +2,12 @@
 #include <asm/string.h>
 #include <asm/checksum.h>
 
+#ifndef CONFIG_X86_32
 /*XXX: we need them because they would be exported by x86_64 */
 #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
 EXPORT_SYMBOL(memcpy);
 #else
 EXPORT_SYMBOL(__memcpy);
 #endif
+#endif
 EXPORT_SYMBOL(csum_partial);
diff --git a/arch/um/sys-i386/ldt.c b/arch/um/sys-x86/ldt.c
similarity index 100%
rename from arch/um/sys-i386/ldt.c
rename to arch/um/sys-x86/ldt.c
diff --git a/arch/um/sys-i386/mem.c b/arch/um/sys-x86/mem_32.c
similarity index 100%
rename from arch/um/sys-i386/mem.c
rename to arch/um/sys-x86/mem_32.c
diff --git a/arch/um/sys-x86_64/mem.c b/arch/um/sys-x86/mem_64.c
similarity index 100%
rename from arch/um/sys-x86_64/mem.c
rename to arch/um/sys-x86/mem_64.c
diff --git a/arch/um/sys-i386/ptrace.c b/arch/um/sys-x86/ptrace_32.c
similarity index 100%
rename from arch/um/sys-i386/ptrace.c
rename to arch/um/sys-x86/ptrace_32.c
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86/ptrace_64.c
similarity index 100%
rename from arch/um/sys-x86_64/ptrace.c
rename to arch/um/sys-x86/ptrace_64.c
diff --git a/arch/um/sys-i386/ptrace_user.c b/arch/um/sys-x86/ptrace_user.c
similarity index 94%
rename from arch/um/sys-i386/ptrace_user.c
rename to arch/um/sys-x86/ptrace_user.c
index 0b10c3e..3960ca1 100644
--- a/arch/um/sys-i386/ptrace_user.c
+++ b/arch/um/sys-x86/ptrace_user.c
@@ -4,7 +4,7 @@
  */
 
 #include <errno.h>
-#include <sys/ptrace.h>
+#include "ptrace_user.h"
 
 int ptrace_getregs(long pid, unsigned long *regs_out)
 {
diff --git a/arch/um/sys-i386/setjmp.S b/arch/um/sys-x86/setjmp_32.S
similarity index 100%
rename from arch/um/sys-i386/setjmp.S
rename to arch/um/sys-x86/setjmp_32.S
diff --git a/arch/um/sys-x86_64/setjmp.S b/arch/um/sys-x86/setjmp_64.S
similarity index 100%
rename from arch/um/sys-x86_64/setjmp.S
rename to arch/um/sys-x86/setjmp_64.S
diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-x86/signal_32.c
similarity index 100%
rename from arch/um/sys-i386/signal.c
rename to arch/um/sys-x86/signal_32.c
diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86/signal_64.c
similarity index 100%
rename from arch/um/sys-x86_64/signal.c
rename to arch/um/sys-x86/signal_64.c
diff --git a/arch/um/sys-i386/stub.S b/arch/um/sys-x86/stub_32.S
similarity index 100%
rename from arch/um/sys-i386/stub.S
rename to arch/um/sys-x86/stub_32.S
diff --git a/arch/um/sys-x86_64/stub.S b/arch/um/sys-x86/stub_64.S
similarity index 100%
rename from arch/um/sys-x86_64/stub.S
rename to arch/um/sys-x86/stub_64.S
diff --git a/arch/um/sys-i386/stub_segv.c b/arch/um/sys-x86/stub_segv_32.c
similarity index 100%
rename from arch/um/sys-i386/stub_segv.c
rename to arch/um/sys-x86/stub_segv_32.c
diff --git a/arch/um/sys-x86_64/stub_segv.c b/arch/um/sys-x86/stub_segv_64.c
similarity index 100%
rename from arch/um/sys-x86_64/stub_segv.c
rename to arch/um/sys-x86/stub_segv_64.c
diff --git a/arch/um/sys-i386/sys_call_table.S b/arch/um/sys-x86/sys_call_table_32.S
similarity index 100%
rename from arch/um/sys-i386/sys_call_table.S
rename to arch/um/sys-x86/sys_call_table_32.S
diff --git a/arch/um/sys-x86_64/syscall_table.c b/arch/um/sys-x86/sys_call_table_64.c
similarity index 100%
rename from arch/um/sys-x86_64/syscall_table.c
rename to arch/um/sys-x86/sys_call_table_64.c
diff --git a/arch/um/sys-i386/syscalls.c b/arch/um/sys-x86/syscalls_32.c
similarity index 100%
rename from arch/um/sys-i386/syscalls.c
rename to arch/um/sys-x86/syscalls_32.c
diff --git a/arch/um/sys-x86_64/syscalls.c b/arch/um/sys-x86/syscalls_64.c
similarity index 100%
rename from arch/um/sys-x86_64/syscalls.c
rename to arch/um/sys-x86/syscalls_64.c
diff --git a/arch/um/sys-i386/sysrq.c b/arch/um/sys-x86/sysrq_32.c
similarity index 100%
rename from arch/um/sys-i386/sysrq.c
rename to arch/um/sys-x86/sysrq_32.c
diff --git a/arch/um/sys-x86_64/sysrq.c b/arch/um/sys-x86/sysrq_64.c
similarity index 100%
rename from arch/um/sys-x86_64/sysrq.c
rename to arch/um/sys-x86/sysrq_64.c
diff --git a/arch/um/sys-i386/tls.c b/arch/um/sys-x86/tls_32.c
similarity index 100%
rename from arch/um/sys-i386/tls.c
rename to arch/um/sys-x86/tls_32.c
diff --git a/arch/um/sys-x86_64/tls.c b/arch/um/sys-x86/tls_64.c
similarity index 100%
rename from arch/um/sys-x86_64/tls.c
rename to arch/um/sys-x86/tls_64.c
diff --git a/arch/um/sys-x86_64/user-offsets.c b/arch/um/sys-x86/user-offsets.c
similarity index 70%
rename from arch/um/sys-x86_64/user-offsets.c
rename to arch/um/sys-x86/user-offsets.c
index 9735854..718f0c0 100644
--- a/arch/um/sys-x86_64/user-offsets.c
+++ b/arch/um/sys-x86/user-offsets.c
@@ -9,20 +9,41 @@
 #include <asm/types.h>
 
 #define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
 
 #define DEFINE_LONGS(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val/sizeof(unsigned long)))
+	asm volatile("\n->" #sym " %0 " #val : : "i" (val/sizeof(unsigned long)))
 
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
 void foo(void)
 {
-	OFFSET(HOST_SC_CR2, sigcontext, cr2);
-	OFFSET(HOST_SC_ERR, sigcontext, err);
 	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
+	OFFSET(HOST_SC_ERR, sigcontext, err);
+	OFFSET(HOST_SC_CR2, sigcontext, cr2);
 
+#ifdef __i386__
+	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
+	DEFINE_LONGS(HOST_FPX_SIZE, sizeof(struct user_fpxregs_struct));
+
+	DEFINE(HOST_IP, EIP);
+	DEFINE(HOST_SP, UESP);
+	DEFINE(HOST_EFLAGS, EFL);
+	DEFINE(HOST_EAX, EAX);
+	DEFINE(HOST_EBX, EBX);
+	DEFINE(HOST_ECX, ECX);
+	DEFINE(HOST_EDX, EDX);
+	DEFINE(HOST_ESI, ESI);
+	DEFINE(HOST_EDI, EDI);
+	DEFINE(HOST_EBP, EBP);
+	DEFINE(HOST_CS, CS);
+	DEFINE(HOST_SS, SS);
+	DEFINE(HOST_DS, DS);
+	DEFINE(HOST_FS, FS);
+	DEFINE(HOST_ES, ES);
+	DEFINE(HOST_GS, GS);
+#else
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
 	DEFINE_LONGS(HOST_RBX, RBX);
 	DEFINE_LONGS(HOST_RCX, RCX);
@@ -52,9 +73,9 @@ void foo(void)
 
 	DEFINE_LONGS(HOST_IP, RIP);
 	DEFINE_LONGS(HOST_SP, RSP);
-	DEFINE(UM_FRAME_SIZE, sizeof(struct user_regs_struct));
+#endif
 
-	/* XXX Duplicated between i386 and x86_64 */
+	DEFINE(UM_FRAME_SIZE, sizeof(struct user_regs_struct));
 	DEFINE(UM_POLLIN, POLLIN);
 	DEFINE(UM_POLLPRI, POLLPRI);
 	DEFINE(UM_POLLOUT, POLLOUT);
diff --git a/arch/um/sys-x86_64/vdso/Makefile b/arch/um/sys-x86/vdso/Makefile
similarity index 100%
rename from arch/um/sys-x86_64/vdso/Makefile
rename to arch/um/sys-x86/vdso/Makefile
diff --git a/arch/um/sys-x86_64/vdso/checkundef.sh b/arch/um/sys-x86/vdso/checkundef.sh
similarity index 100%
rename from arch/um/sys-x86_64/vdso/checkundef.sh
rename to arch/um/sys-x86/vdso/checkundef.sh
diff --git a/arch/um/sys-x86_64/vdso/um_vdso.c b/arch/um/sys-x86/vdso/um_vdso.c
similarity index 100%
rename from arch/um/sys-x86_64/vdso/um_vdso.c
rename to arch/um/sys-x86/vdso/um_vdso.c
diff --git a/arch/um/sys-x86_64/vdso/vdso-layout.lds.S b/arch/um/sys-x86/vdso/vdso-layout.lds.S
similarity index 100%
rename from arch/um/sys-x86_64/vdso/vdso-layout.lds.S
rename to arch/um/sys-x86/vdso/vdso-layout.lds.S
diff --git a/arch/um/sys-x86_64/vdso/vdso-note.S b/arch/um/sys-x86/vdso/vdso-note.S
similarity index 100%
rename from arch/um/sys-x86_64/vdso/vdso-note.S
rename to arch/um/sys-x86/vdso/vdso-note.S
diff --git a/arch/um/sys-x86_64/vdso/vdso.S b/arch/um/sys-x86/vdso/vdso.S
similarity index 69%
rename from arch/um/sys-x86_64/vdso/vdso.S
rename to arch/um/sys-x86/vdso/vdso.S
index ec82c16..03b0532 100644
--- a/arch/um/sys-x86_64/vdso/vdso.S
+++ b/arch/um/sys-x86/vdso/vdso.S
@@ -4,7 +4,7 @@ __INITDATA
 
 	.globl vdso_start, vdso_end
 vdso_start:
-	.incbin "arch/um/sys-x86_64/vdso/vdso.so"
+	.incbin "arch/um/sys-x86/vdso/vdso.so"
 vdso_end:
 
 __FINIT
diff --git a/arch/um/sys-x86_64/vdso/vdso.lds.S b/arch/um/sys-x86/vdso/vdso.lds.S
similarity index 100%
rename from arch/um/sys-x86_64/vdso/vdso.lds.S
rename to arch/um/sys-x86/vdso/vdso.lds.S
diff --git a/arch/um/sys-x86_64/vdso/vma.c b/arch/um/sys-x86/vdso/vma.c
similarity index 100%
rename from arch/um/sys-x86_64/vdso/vma.c
rename to arch/um/sys-x86/vdso/vma.c
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
deleted file mode 100644
index 0971846..0000000
--- a/arch/um/sys-x86_64/Makefile
+++ /dev/null
@@ -1,27 +0,0 @@
-#
-# Copyright 2003 PathScale, Inc.
-#
-# Licensed under the GPL
-#
-
-obj-y = bug.o bugs.o delay.o fault.o ldt.o ptrace.o ptrace_user.o mem.o \
-	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
-	sysrq.o ksyms.o tls.o
-
-obj-y += vdso/
-
-subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
-		lib/rwsem.o
-subarch-obj-$(CONFIG_MODULES) += kernel/module.o
-
-ldt-y = ../sys-i386/ldt.o
-
-USER_OBJS := ptrace_user.o
-
-extra-y += user-offsets.s
-$(obj)/user-offsets.s: c_flags = -Wp,-MD,$(depfile) $(USER_CFLAGS)
-
-UNPROFILE_OBJS := stub_segv.o
-CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
-
-include arch/um/scripts/Makefile.rules
diff --git a/arch/um/sys-x86_64/fault.c b/arch/um/sys-x86_64/fault.c
deleted file mode 100644
index ce85117..0000000
--- a/arch/um/sys-x86_64/fault.c
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#include "sysdep/ptrace.h"
-
-/* These two are from asm-um/uaccess.h and linux/module.h, check them. */
-struct exception_table_entry
-{
-	unsigned long insn;
-	unsigned long fixup;
-};
-
-const struct exception_table_entry *search_exception_tables(unsigned long add);
-
-int arch_fixup(unsigned long address, struct uml_pt_regs *regs)
-{
-	const struct exception_table_entry *fixup;
-
-	fixup = search_exception_tables(address);
-	if (fixup != 0) {
-		UPT_IP(regs) = fixup->fixup;
-		return 1;
-	}
-	return 0;
-}
diff --git a/arch/um/sys-x86_64/ptrace_user.c b/arch/um/sys-x86_64/ptrace_user.c
deleted file mode 100644
index c57a496..0000000
--- a/arch/um/sys-x86_64/ptrace_user.c
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#include <errno.h>
-#include "ptrace_user.h"
-
-int ptrace_getregs(long pid, unsigned long *regs_out)
-{
-	if (ptrace(PTRACE_GETREGS, pid, 0, regs_out) < 0)
-		return -errno;
-	return(0);
-}
-
-int ptrace_setregs(long pid, unsigned long *regs_out)
-{
-	if (ptrace(PTRACE_SETREGS, pid, 0, regs_out) < 0)
-		return -errno;
-	return(0);
-}
-- 
1.7.2.5


