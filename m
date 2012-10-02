Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2JBDbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:31:42 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:38091 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2JBDbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:31:40 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v5 1/3] tracing,x86: Add a TSC trace_clock
Date: Mon,  1 Oct 2012 20:31:18 -0700
Message-Id: <1349148680-9509-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to promote interoperability between userspace tracers and ftrace,
add a trace_clock that reports raw TSC values which will then be recorded
in the ring buffer. Userspace tracers that also record TSCs are then on
exactly the same time base as the kernel and events can be unambiguously
interlaced.

Tested: Enabled a tracepoint and the "tsc" trace_clock and saw very large
timestamp values.

v2:
Move arch-specific bits out of generic code.
v3:
Rename "x86-tsc", cleanups

Google-Bug-Id: 6980623
Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/trace_clock.h      |    6 ++++++
 arch/arm/include/asm/trace_clock.h        |    6 ++++++
 arch/avr32/include/asm/trace_clock.h      |    6 ++++++
 arch/blackfin/include/asm/trace_clock.h   |    6 ++++++
 arch/c6x/include/asm/trace_clock.h        |    6 ++++++
 arch/cris/include/asm/trace_clock.h       |    6 ++++++
 arch/frv/include/asm/trace_clock.h        |    6 ++++++
 arch/h8300/include/asm/trace_clock.h      |    6 ++++++
 arch/hexagon/include/asm/trace_clock.h    |    6 ++++++
 arch/ia64/include/asm/trace_clock.h       |    6 ++++++
 arch/m32r/include/asm/trace_clock.h       |    6 ++++++
 arch/m68k/include/asm/trace_clock.h       |    6 ++++++
 arch/microblaze/include/asm/trace_clock.h |    6 ++++++
 arch/mips/include/asm/trace_clock.h       |    6 ++++++
 arch/mn10300/include/asm/trace_clock.h    |    6 ++++++
 arch/openrisc/include/asm/trace_clock.h   |    6 ++++++
 arch/parisc/include/asm/trace_clock.h     |    6 ++++++
 arch/powerpc/include/asm/trace_clock.h    |    6 ++++++
 arch/s390/include/asm/trace_clock.h       |    6 ++++++
 arch/score/include/asm/trace_clock.h      |    6 ++++++
 arch/sh/include/asm/trace_clock.h         |    6 ++++++
 arch/sparc/include/asm/trace_clock.h      |    6 ++++++
 arch/tile/include/asm/trace_clock.h       |    6 ++++++
 arch/um/include/asm/trace_clock.h         |    6 ++++++
 arch/unicore32/include/asm/trace_clock.h  |    6 ++++++
 arch/x86/include/asm/trace_clock.h        |   16 ++++++++++++++++
 arch/x86/kernel/Makefile                  |    1 +
 arch/x86/kernel/trace_clock.c             |   21 +++++++++++++++++++++
 arch/xtensa/include/asm/trace_clock.h     |    6 ++++++
 include/asm-generic/trace_clock.h         |   16 ++++++++++++++++
 include/linux/trace_clock.h               |    2 ++
 kernel/trace/trace.c                      |    1 +
 32 files changed, 213 insertions(+), 0 deletions(-)
 create mode 100644 arch/alpha/include/asm/trace_clock.h
 create mode 100644 arch/arm/include/asm/trace_clock.h
 create mode 100644 arch/avr32/include/asm/trace_clock.h
 create mode 100644 arch/blackfin/include/asm/trace_clock.h
 create mode 100644 arch/c6x/include/asm/trace_clock.h
 create mode 100644 arch/cris/include/asm/trace_clock.h
 create mode 100644 arch/frv/include/asm/trace_clock.h
 create mode 100644 arch/h8300/include/asm/trace_clock.h
 create mode 100644 arch/hexagon/include/asm/trace_clock.h
 create mode 100644 arch/ia64/include/asm/trace_clock.h
 create mode 100644 arch/m32r/include/asm/trace_clock.h
 create mode 100644 arch/m68k/include/asm/trace_clock.h
 create mode 100644 arch/microblaze/include/asm/trace_clock.h
 create mode 100644 arch/mips/include/asm/trace_clock.h
 create mode 100644 arch/mn10300/include/asm/trace_clock.h
 create mode 100644 arch/openrisc/include/asm/trace_clock.h
 create mode 100644 arch/parisc/include/asm/trace_clock.h
 create mode 100644 arch/powerpc/include/asm/trace_clock.h
 create mode 100644 arch/s390/include/asm/trace_clock.h
 create mode 100644 arch/score/include/asm/trace_clock.h
 create mode 100644 arch/sh/include/asm/trace_clock.h
 create mode 100644 arch/sparc/include/asm/trace_clock.h
 create mode 100644 arch/tile/include/asm/trace_clock.h
 create mode 100644 arch/um/include/asm/trace_clock.h
 create mode 100644 arch/unicore32/include/asm/trace_clock.h
 create mode 100644 arch/x86/include/asm/trace_clock.h
 create mode 100644 arch/x86/kernel/trace_clock.c
 create mode 100644 arch/xtensa/include/asm/trace_clock.h
 create mode 100644 include/asm-generic/trace_clock.h

diff --git a/arch/alpha/include/asm/trace_clock.h b/arch/alpha/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/alpha/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/arm/include/asm/trace_clock.h b/arch/arm/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/arm/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/avr32/include/asm/trace_clock.h b/arch/avr32/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/avr32/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/blackfin/include/asm/trace_clock.h b/arch/blackfin/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/blackfin/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/c6x/include/asm/trace_clock.h b/arch/c6x/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/c6x/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/cris/include/asm/trace_clock.h b/arch/cris/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/cris/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/frv/include/asm/trace_clock.h b/arch/frv/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/frv/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/h8300/include/asm/trace_clock.h b/arch/h8300/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/h8300/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/hexagon/include/asm/trace_clock.h b/arch/hexagon/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/hexagon/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/ia64/include/asm/trace_clock.h b/arch/ia64/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/ia64/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/m32r/include/asm/trace_clock.h b/arch/m32r/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/m32r/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/m68k/include/asm/trace_clock.h b/arch/m68k/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/m68k/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/microblaze/include/asm/trace_clock.h b/arch/microblaze/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/microblaze/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/mips/include/asm/trace_clock.h b/arch/mips/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/mips/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/mn10300/include/asm/trace_clock.h b/arch/mn10300/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/mn10300/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/openrisc/include/asm/trace_clock.h b/arch/openrisc/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/openrisc/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/parisc/include/asm/trace_clock.h b/arch/parisc/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/parisc/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/powerpc/include/asm/trace_clock.h b/arch/powerpc/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/powerpc/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/s390/include/asm/trace_clock.h b/arch/s390/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/s390/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/score/include/asm/trace_clock.h b/arch/score/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/score/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/sh/include/asm/trace_clock.h b/arch/sh/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/sh/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/sparc/include/asm/trace_clock.h b/arch/sparc/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/sparc/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/tile/include/asm/trace_clock.h b/arch/tile/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/tile/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/um/include/asm/trace_clock.h b/arch/um/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/um/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/unicore32/include/asm/trace_clock.h b/arch/unicore32/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/unicore32/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/arch/x86/include/asm/trace_clock.h b/arch/x86/include/asm/trace_clock.h
new file mode 100644
index 0000000..7ee0d8c
--- /dev/null
+++ b/arch/x86/include/asm/trace_clock.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_X86_TRACE_CLOCK_H
+#define _ASM_X86_TRACE_CLOCK_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_X86_TSC
+
+extern u64 notrace trace_clock_x86_tsc(void);
+
+# define ARCH_TRACE_CLOCKS \
+	{ trace_clock_x86_tsc,	"x86-tsc" },
+
+#endif
+
+#endif  /* _ASM_X86_TRACE_CLOCK_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8215e56..0ee9344 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
+obj-$(CONFIG_X86_TSC)		+= trace_clock.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
diff --git a/arch/x86/kernel/trace_clock.c b/arch/x86/kernel/trace_clock.c
new file mode 100644
index 0000000..25b9937
--- /dev/null
+++ b/arch/x86/kernel/trace_clock.c
@@ -0,0 +1,21 @@
+/*
+ * X86 trace clocks
+ */
+#include <asm/trace_clock.h>
+#include <asm/barrier.h>
+#include <asm/msr.h>
+
+/*
+ * trace_clock_x86_tsc(): A clock that is just the cycle counter.
+ *
+ * Unlike the other clocks, this is not in nanoseconds.
+ */
+u64 notrace trace_clock_x86_tsc(void)
+{
+	u64 ret;
+
+	rdtsc_barrier();
+	rdtscll(ret);
+
+	return ret;
+}
diff --git a/arch/xtensa/include/asm/trace_clock.h b/arch/xtensa/include/asm/trace_clock.h
new file mode 100644
index 0000000..f35fab8
--- /dev/null
+++ b/arch/xtensa/include/asm/trace_clock.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_TRACE_CLOCK_H
+#define _ASM_TRACE_CLOCK_H
+
+#include <asm-generic/trace_clock.h>
+
+#endif
diff --git a/include/asm-generic/trace_clock.h b/include/asm-generic/trace_clock.h
new file mode 100644
index 0000000..6726f1b
--- /dev/null
+++ b/include/asm-generic/trace_clock.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_GENERIC_TRACE_CLOCK_H
+#define _ASM_GENERIC_TRACE_CLOCK_H
+/*
+ * Arch-specific trace clocks.
+ */
+
+/*
+ * Additional trace clocks added to the trace_clocks
+ * array in kernel/trace/trace.c
+ * None if the architecture has not defined it.
+ */
+#ifndef ARCH_TRACE_CLOCKS
+# define ARCH_TRACE_CLOCKS
+#endif
+
+#endif  /* _ASM_GENERIC_TRACE_CLOCK_H */
diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 4eb4902..d563f37 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -12,6 +12,8 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
+#include <asm/trace_clock.h>
+
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c38c81..92fb08e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -480,6 +480,7 @@ static struct {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
 	{ trace_clock_counter,	"counter" },
+	ARCH_TRACE_CLOCKS
 };
 
 int trace_clock_id;
-- 
1.7.7.3

