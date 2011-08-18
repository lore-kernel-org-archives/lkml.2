Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1HRTDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:03:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44274 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1HRTDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:03:10 -0400
Date: Thu, 18 Aug 2011 20:03:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 25/91] um: merge arch/um/sys-{i386,x86_64}/shared
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7rx-0007c8-CM@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                                   |    3 +-
 arch/um/sys-x86/shared/sysdep/archsetjmp.h         |    5 +
 .../shared/sysdep/archsetjmp_32.h}                 |    0
 .../shared/sysdep/archsetjmp_64.h}                 |    0
 arch/um/sys-x86/shared/sysdep/barrier.h            |    5 +
 .../shared/sysdep/barrier_32.h}                    |    0
 .../shared/sysdep/barrier_64.h}                    |    0
 arch/um/sys-x86/shared/sysdep/faultinfo.h          |    5 +
 .../shared/sysdep/faultinfo_32.h}                  |    0
 .../shared/sysdep/faultinfo_64.h}                  |    0
 arch/um/sys-x86/shared/sysdep/host_ldt.h           |    5 +
 .../shared/sysdep/host_ldt_32.h}                   |    0
 .../shared/sysdep/host_ldt_64.h}                   |    0
 arch/um/sys-x86/shared/sysdep/kernel-offsets.h     |    5 +
 .../shared/sysdep/kernel-offsets_32.h}             |    0
 .../shared/sysdep/kernel-offsets_64.h}             |    0
 arch/um/sys-x86/shared/sysdep/ptrace.h             |    5 +
 .../ptrace.h => sys-x86/shared/sysdep/ptrace_32.h} |    0
 .../ptrace.h => sys-x86/shared/sysdep/ptrace_64.h} |    0
 arch/um/sys-x86/shared/sysdep/ptrace_user.h        |    5 +
 .../shared/sysdep/ptrace_user_32.h}                |    0
 .../shared/sysdep/ptrace_user_64.h}                |    0
 arch/um/sys-x86/shared/sysdep/sigcontext.h         |    5 +
 .../shared/sysdep/sigcontext_32.h}                 |    0
 .../shared/sysdep/sigcontext_64.h}                 |    0
 arch/um/sys-x86/shared/sysdep/skas_ptrace.h        |    5 +
 .../shared/sysdep/skas_ptrace_32.h}                |    0
 .../shared/sysdep/skas_ptrace_64.h}                |    0
 arch/um/sys-x86/shared/sysdep/stub.h               |    5 +
 .../stub.h => sys-x86/shared/sysdep/stub_32.h}     |    0
 .../stub.h => sys-x86/shared/sysdep/stub_64.h}     |    0
 arch/um/sys-x86/shared/sysdep/syscalls.h           |    5 +
 .../shared/sysdep/syscalls_32.h}                   |    0
 .../shared/sysdep/syscalls_64.h}                   |    0
 .../{sys-i386 => sys-x86}/shared/sysdep/system.h   |    0
 arch/um/sys-x86/shared/sysdep/tls.h                |    5 +
 .../tls.h => sys-x86/shared/sysdep/tls_32.h}       |    0
 .../tls.h => sys-x86/shared/sysdep/tls_64.h}       |    0
 arch/um/sys-x86_64/shared/sysdep/system.h          |  132 --------------------
 39 files changed, 61 insertions(+), 134 deletions(-)
 create mode 100644 arch/um/sys-x86/shared/sysdep/archsetjmp.h
 rename arch/um/{sys-i386/shared/sysdep/archsetjmp.h => sys-x86/shared/sysdep/archsetjmp_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/archsetjmp.h => sys-x86/shared/sysdep/archsetjmp_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/barrier.h
 rename arch/um/{sys-i386/shared/sysdep/barrier.h => sys-x86/shared/sysdep/barrier_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/barrier.h => sys-x86/shared/sysdep/barrier_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/faultinfo.h
 rename arch/um/{sys-i386/shared/sysdep/faultinfo.h => sys-x86/shared/sysdep/faultinfo_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/faultinfo.h => sys-x86/shared/sysdep/faultinfo_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/host_ldt.h
 rename arch/um/{sys-i386/shared/sysdep/host_ldt.h => sys-x86/shared/sysdep/host_ldt_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/host_ldt.h => sys-x86/shared/sysdep/host_ldt_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/kernel-offsets.h
 rename arch/um/{sys-i386/shared/sysdep/kernel-offsets.h => sys-x86/shared/sysdep/kernel-offsets_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/kernel-offsets.h => sys-x86/shared/sysdep/kernel-offsets_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/ptrace.h
 rename arch/um/{sys-i386/shared/sysdep/ptrace.h => sys-x86/shared/sysdep/ptrace_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/ptrace.h => sys-x86/shared/sysdep/ptrace_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/ptrace_user.h
 rename arch/um/{sys-i386/shared/sysdep/ptrace_user.h => sys-x86/shared/sysdep/ptrace_user_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/ptrace_user.h => sys-x86/shared/sysdep/ptrace_user_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/sigcontext.h
 rename arch/um/{sys-i386/shared/sysdep/sigcontext.h => sys-x86/shared/sysdep/sigcontext_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/sigcontext.h => sys-x86/shared/sysdep/sigcontext_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/skas_ptrace.h
 rename arch/um/{sys-i386/shared/sysdep/skas_ptrace.h => sys-x86/shared/sysdep/skas_ptrace_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/skas_ptrace.h => sys-x86/shared/sysdep/skas_ptrace_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/stub.h
 rename arch/um/{sys-i386/shared/sysdep/stub.h => sys-x86/shared/sysdep/stub_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/stub.h => sys-x86/shared/sysdep/stub_64.h} (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/syscalls.h
 rename arch/um/{sys-i386/shared/sysdep/syscalls.h => sys-x86/shared/sysdep/syscalls_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/syscalls.h => sys-x86/shared/sysdep/syscalls_64.h} (100%)
 rename arch/um/{sys-i386 => sys-x86}/shared/sysdep/system.h (100%)
 create mode 100644 arch/um/sys-x86/shared/sysdep/tls.h
 rename arch/um/{sys-i386/shared/sysdep/tls.h => sys-x86/shared/sysdep/tls_32.h} (100%)
 rename arch/um/{sys-x86_64/shared/sysdep/tls.h => sys-x86/shared/sysdep/tls_64.h} (100%)
 delete mode 100644 arch/um/sys-x86_64/shared/sysdep/system.h

diff --git a/arch/um/Makefile b/arch/um/Makefile
index c121870..184494d 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -25,9 +25,8 @@ include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
 
 SHARED_HEADERS	:= $(ARCH_DIR)/include/shared
 ARCH_INCLUDE	:= -I$(srctree)/$(SHARED_HEADERS)
-ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
+ARCH_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/sys-$(HEADER_ARCH)/shared
 KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(HEADER_ARCH)
-KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 
 # -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
 # named - it's a common symbol in libpcap, so we get a binary which crashes.
diff --git a/arch/um/sys-x86/shared/sysdep/archsetjmp.h b/arch/um/sys-x86/shared/sysdep/archsetjmp.h
new file mode 100644
index 0000000..ff7766d
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/archsetjmp.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "archsetjmp_32.h"
+#else
+#include "archsetjmp_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/archsetjmp.h b/arch/um/sys-x86/shared/sysdep/archsetjmp_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/archsetjmp.h
rename to arch/um/sys-x86/shared/sysdep/archsetjmp_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/archsetjmp.h b/arch/um/sys-x86/shared/sysdep/archsetjmp_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/archsetjmp.h
rename to arch/um/sys-x86/shared/sysdep/archsetjmp_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/barrier.h b/arch/um/sys-x86/shared/sysdep/barrier.h
new file mode 100644
index 0000000..89ee23b
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/barrier.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "barrier_32.h"
+#else
+#include "barrier_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/barrier.h b/arch/um/sys-x86/shared/sysdep/barrier_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/barrier.h
rename to arch/um/sys-x86/shared/sysdep/barrier_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/barrier.h b/arch/um/sys-x86/shared/sysdep/barrier_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/barrier.h
rename to arch/um/sys-x86/shared/sysdep/barrier_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/faultinfo.h b/arch/um/sys-x86/shared/sysdep/faultinfo.h
new file mode 100644
index 0000000..862ecb1
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/faultinfo.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "faultinfo_32.h"
+#else
+#include "faultinfo_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/faultinfo.h b/arch/um/sys-x86/shared/sysdep/faultinfo_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/faultinfo.h
rename to arch/um/sys-x86/shared/sysdep/faultinfo_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/faultinfo.h b/arch/um/sys-x86/shared/sysdep/faultinfo_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/faultinfo.h
rename to arch/um/sys-x86/shared/sysdep/faultinfo_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/host_ldt.h b/arch/um/sys-x86/shared/sysdep/host_ldt.h
new file mode 100644
index 0000000..94518b3
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/host_ldt.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "host_ldt_32.h"
+#else
+#include "host_ldt_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/host_ldt.h b/arch/um/sys-x86/shared/sysdep/host_ldt_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/host_ldt.h
rename to arch/um/sys-x86/shared/sysdep/host_ldt_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/host_ldt.h b/arch/um/sys-x86/shared/sysdep/host_ldt_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/host_ldt.h
rename to arch/um/sys-x86/shared/sysdep/host_ldt_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/kernel-offsets.h b/arch/um/sys-x86/shared/sysdep/kernel-offsets.h
new file mode 100644
index 0000000..346bc08
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/kernel-offsets.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "kernel-offsets_32.h"
+#else
+#include "kernel-offsets_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/kernel-offsets.h b/arch/um/sys-x86/shared/sysdep/kernel-offsets_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/kernel-offsets.h
rename to arch/um/sys-x86/shared/sysdep/kernel-offsets_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/kernel-offsets.h b/arch/um/sys-x86/shared/sysdep/kernel-offsets_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/kernel-offsets.h
rename to arch/um/sys-x86/shared/sysdep/kernel-offsets_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace.h b/arch/um/sys-x86/shared/sysdep/ptrace.h
new file mode 100644
index 0000000..711b162
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/ptrace.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "ptrace_32.h"
+#else
+#include "ptrace_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/ptrace.h b/arch/um/sys-x86/shared/sysdep/ptrace_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/ptrace.h
rename to arch/um/sys-x86/shared/sysdep/ptrace_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/ptrace.h b/arch/um/sys-x86/shared/sysdep/ptrace_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/ptrace.h
rename to arch/um/sys-x86/shared/sysdep/ptrace_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/ptrace_user.h b/arch/um/sys-x86/shared/sysdep/ptrace_user.h
new file mode 100644
index 0000000..a92f883
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/ptrace_user.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "ptrace_user_32.h"
+#else
+#include "ptrace_user_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/ptrace_user.h b/arch/um/sys-x86/shared/sysdep/ptrace_user_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/ptrace_user.h
rename to arch/um/sys-x86/shared/sysdep/ptrace_user_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/ptrace_user.h b/arch/um/sys-x86/shared/sysdep/ptrace_user_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/ptrace_user.h
rename to arch/um/sys-x86/shared/sysdep/ptrace_user_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/sigcontext.h b/arch/um/sys-x86/shared/sysdep/sigcontext.h
new file mode 100644
index 0000000..f7f49f4
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/sigcontext.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "sigcontext_32.h"
+#else
+#include "sigcontext_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/sigcontext.h b/arch/um/sys-x86/shared/sysdep/sigcontext_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/sigcontext.h
rename to arch/um/sys-x86/shared/sysdep/sigcontext_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/sigcontext.h b/arch/um/sys-x86/shared/sysdep/sigcontext_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/sigcontext.h
rename to arch/um/sys-x86/shared/sysdep/sigcontext_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/skas_ptrace.h b/arch/um/sys-x86/shared/sysdep/skas_ptrace.h
new file mode 100644
index 0000000..e63b575
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/skas_ptrace.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "skas_ptrace_32.h"
+#else
+#include "skas_ptrace_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/skas_ptrace.h b/arch/um/sys-x86/shared/sysdep/skas_ptrace_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/skas_ptrace.h
rename to arch/um/sys-x86/shared/sysdep/skas_ptrace_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h b/arch/um/sys-x86/shared/sysdep/skas_ptrace_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h
rename to arch/um/sys-x86/shared/sysdep/skas_ptrace_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/stub.h b/arch/um/sys-x86/shared/sysdep/stub.h
new file mode 100644
index 0000000..13f523a
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/stub.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "stub_32.h"
+#else
+#include "stub_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/stub.h b/arch/um/sys-x86/shared/sysdep/stub_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/stub.h
rename to arch/um/sys-x86/shared/sysdep/stub_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/stub.h b/arch/um/sys-x86/shared/sysdep/stub_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/stub.h
rename to arch/um/sys-x86/shared/sysdep/stub_64.h
diff --git a/arch/um/sys-x86/shared/sysdep/syscalls.h b/arch/um/sys-x86/shared/sysdep/syscalls.h
new file mode 100644
index 0000000..bd9a89b
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/syscalls.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "syscalls_32.h"
+#else
+#include "syscalls_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/syscalls.h b/arch/um/sys-x86/shared/sysdep/syscalls_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/syscalls.h
rename to arch/um/sys-x86/shared/sysdep/syscalls_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/syscalls.h b/arch/um/sys-x86/shared/sysdep/syscalls_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/syscalls.h
rename to arch/um/sys-x86/shared/sysdep/syscalls_64.h
diff --git a/arch/um/sys-i386/shared/sysdep/system.h b/arch/um/sys-x86/shared/sysdep/system.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/system.h
rename to arch/um/sys-x86/shared/sysdep/system.h
diff --git a/arch/um/sys-x86/shared/sysdep/tls.h b/arch/um/sys-x86/shared/sysdep/tls.h
new file mode 100644
index 0000000..4d8f752
--- /dev/null
+++ b/arch/um/sys-x86/shared/sysdep/tls.h
@@ -0,0 +1,5 @@
+#ifdef __i386__
+#include "tls_32.h"
+#else
+#include "tls_64.h"
+#endif
diff --git a/arch/um/sys-i386/shared/sysdep/tls.h b/arch/um/sys-x86/shared/sysdep/tls_32.h
similarity index 100%
rename from arch/um/sys-i386/shared/sysdep/tls.h
rename to arch/um/sys-x86/shared/sysdep/tls_32.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/tls.h b/arch/um/sys-x86/shared/sysdep/tls_64.h
similarity index 100%
rename from arch/um/sys-x86_64/shared/sysdep/tls.h
rename to arch/um/sys-x86/shared/sysdep/tls_64.h
diff --git a/arch/um/sys-x86_64/shared/sysdep/system.h b/arch/um/sys-x86_64/shared/sysdep/system.h
deleted file mode 100644
index d1b93c4..0000000
--- a/arch/um/sys-x86_64/shared/sysdep/system.h
+++ /dev/null
@@ -1,132 +0,0 @@
-#ifndef _ASM_X86_SYSTEM_H_
-#define _ASM_X86_SYSTEM_H_
-
-#include <asm/asm.h>
-#include <asm/segment.h>
-#include <asm/cpufeature.h>
-#include <asm/cmpxchg.h>
-#include <asm/nops.h>
-
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-
-/* entries in ARCH_DLINFO: */
-#ifdef CONFIG_IA32_EMULATION
-# define AT_VECTOR_SIZE_ARCH 2
-#else
-# define AT_VECTOR_SIZE_ARCH 1
-#endif
-
-extern unsigned long arch_align_stack(unsigned long sp);
-
-void default_idle(void);
-
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- */
-#ifdef CONFIG_X86_32
-/*
- * Some non-Intel clones support out of order store. wmb() ceases to be a
- * nop for these.
- */
-#define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
-#define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
-#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
-#else
-#define mb() 	asm volatile("mfence":::"memory")
-#define rmb()	asm volatile("lfence":::"memory")
-#define wmb()	asm volatile("sfence" ::: "memory")
-#endif
-
-/**
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	b = 2;
- *	memory_barrier();
- *	p = &b;				q = p;
- *					read_barrier_depends();
- *					d = *q;
- * </programlisting>
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	a = 2;
- *	memory_barrier();
- *	b = 3;				y = b;
- *					read_barrier_depends();
- *					x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- **/
-
-#define read_barrier_depends()	do { } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#ifdef CONFIG_X86_PPRO_FENCE
-# define smp_rmb()	rmb()
-#else
-# define smp_rmb()	barrier()
-#endif
-#ifdef CONFIG_X86_OOSTORE
-# define smp_wmb() 	wmb()
-#else
-# define smp_wmb()	barrier()
-#endif
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#define set_mb(var, value) do { var = value; barrier(); } while (0)
-#endif
-
-/*
- * Stop RDTSC speculation. This is needed when you need to use RDTSC
- * (or get_cycles or vread that possibly accesses the TSC) in a defined
- * code region.
- *
- * (Could use an alternative three way for this if there was one.)
- */
-static inline void rdtsc_barrier(void)
-{
-	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
-	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
-}
-
-#endif
-- 
1.7.2.5


