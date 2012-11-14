Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423369Ab2KNTKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:10:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161019Ab2KNTJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:09:44 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=l7AnKNi4SmEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-dphR07E_gAA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=QyXUC8HyAAAA:8 a=7I-WM2Tu0kzRU4XDQ84A:9 a=QEXdDO2ut3YA:10 a=92Q717GQZsEA:10 a=UTB_XpHje0EA:10 a=LI9Vle30uBYA:10 a=EvKJbDF4Ut8A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=V5hK7GhE1yDobOG71nsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121114190942.292605134@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 13:53:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 1/4] tracing,x86: Add a TSC trace_clock
References: <20121114185333.818952665@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-x86-Add-a-TSC-trace_clock.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Sharp <dhsharp@google.com>

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
v7:
Generic arch bits in Kbuild.

Google-Bug-Id: 6980623
Link: http://lkml.kernel.org/r/1352837903-32191-1-git-send-email-dhsharp@go=
ogle.com

Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: David Sharp <dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/alpha/include/asm/Kbuild      |    1 +
 arch/arm/include/asm/Kbuild        |    1 +
 arch/arm64/include/asm/Kbuild      |    1 +
 arch/avr32/include/asm/Kbuild      |    1 +
 arch/blackfin/include/asm/Kbuild   |    1 +
 arch/c6x/include/asm/Kbuild        |    1 +
 arch/cris/include/asm/Kbuild       |    1 +
 arch/frv/include/asm/Kbuild        |    1 +
 arch/h8300/include/asm/Kbuild      |    1 +
 arch/hexagon/include/asm/Kbuild    |    1 +
 arch/ia64/include/asm/Kbuild       |    1 +
 arch/m32r/include/asm/Kbuild       |    1 +
 arch/m68k/include/asm/Kbuild       |    1 +
 arch/microblaze/include/asm/Kbuild |    1 +
 arch/mips/include/asm/Kbuild       |    1 +
 arch/mn10300/include/asm/Kbuild    |    1 +
 arch/openrisc/include/asm/Kbuild   |    1 +
 arch/parisc/include/asm/Kbuild     |    1 +
 arch/powerpc/include/asm/Kbuild    |    1 +
 arch/s390/include/asm/Kbuild       |    1 +
 arch/score/include/asm/Kbuild      |    1 +
 arch/sh/include/asm/Kbuild         |    1 +
 arch/sparc/include/asm/Kbuild      |    1 +
 arch/tile/include/asm/Kbuild       |    1 +
 arch/um/include/asm/Kbuild         |    1 +
 arch/unicore32/include/asm/Kbuild  |    1 +
 arch/x86/include/asm/trace_clock.h |   20 ++++++++++++++++++++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/trace_clock.c      |   21 +++++++++++++++++++++
 arch/xtensa/include/asm/Kbuild     |    1 +
 include/asm-generic/trace_clock.h  |   16 ++++++++++++++++
 include/linux/trace_clock.h        |    2 ++
 kernel/trace/trace.c               |    1 +
 33 files changed, 88 insertions(+)
 create mode 100644 arch/x86/include/asm/trace_clock.h
 create mode 100644 arch/x86/kernel/trace_clock.c
 create mode 100644 include/asm-generic/trace_clock.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 64ffc9e..dcfabb9 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -11,3 +11,4 @@ header-y +=3D reg.h
 header-y +=3D regdef.h
 header-y +=3D sysinfo.h
 generic-y +=3D exec.h
+generic-y +=3D trace_clock.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index f70ae17..514e398 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -31,5 +31,6 @@ generic-y +=3D sockios.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
 generic-y +=3D timex.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D unaligned.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index a581a22..6e9ca46 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -43,6 +43,7 @@ generic-y +=3D swab.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D unaligned.h
 generic-y +=3D user.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 4807ded..4dd4f78 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,4 @@
=20
 generic-y	+=3D clkdev.h
 generic-y	+=3D exec.h
+generic-y	+=3D trace_clock.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/K=
build
index 5a0625a..27d7075 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -38,6 +38,7 @@ generic-y +=3D statfs.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D ucontext.h
 generic-y +=3D unaligned.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 112a496..eae7b59 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -49,6 +49,7 @@ generic-y +=3D termbits.h
 generic-y +=3D termios.h
 generic-y +=3D tlbflush.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D ucontext.h
 generic-y +=3D user.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 6d43a95..15a122c 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -11,3 +11,4 @@ header-y +=3D sync_serial.h
 generic-y +=3D clkdev.h
 generic-y +=3D exec.h
 generic-y +=3D module.h
+generic-y +=3D trace_clock.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 4a159da..c5d7670 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -1,3 +1,4 @@
=20
 generic-y +=3D clkdev.h
 generic-y +=3D exec.h
+generic-y +=3D trace_clock.h
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 50bbf38..4bc8ae7 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 generic-y +=3D clkdev.h
 generic-y +=3D exec.h
 generic-y +=3D module.h
+generic-y +=3D trace_clock.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbu=
ild
index 3bfa9b3..bdb54ce 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -48,6 +48,7 @@ generic-y +=3D stat.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D ucontext.h
 generic-y +=3D unaligned.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index dd02f09..05b03ec 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y +=3D clkdev.h
 generic-y +=3D exec.h
 generic-y +=3D kvm_para.h
+generic-y +=3D trace_clock.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 50bbf38..4bc8ae7 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 generic-y +=3D clkdev.h
 generic-y +=3D exec.h
 generic-y +=3D module.h
+generic-y +=3D trace_clock.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 88fa3ac..7f1949c 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -24,6 +24,7 @@ generic-y +=3D sections.h
 generic-y +=3D siginfo.h
 generic-y +=3D statfs.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D word-at-a-time.h
 generic-y +=3D xor.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/a=
sm/Kbuild
index 8653072..2957fcc 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 header-y  +=3D elf.h
 generic-y +=3D clkdev.h
 generic-y +=3D exec.h
+generic-y +=3D trace_clock.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 533053d..9b54b7a 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1 +1,2 @@
 # MIPS headers
+generic-y +=3D trace_clock.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbu=
ild
index 4a159da..c5d7670 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,3 +1,4 @@
=20
 generic-y +=3D clkdev.h
 generic-y +=3D exec.h
+generic-y +=3D trace_clock.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/K=
build
index 78de680..8971026 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -60,6 +60,7 @@ generic-y +=3D swab.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D ucontext.h
 generic-y +=3D user.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index bac8deb..ff4c9fa 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y +=3D word-at-a-time.h auxvec.h user.h cputime.h e=
mergency-restart.h \
 	  segment.h topology.h vga.h device.h percpu.h hw_irq.h mutex.h \
 	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
 	  poll.h xor.h clkdev.h exec.h
+generic-y +=3D trace_clock.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbu=
ild
index a4fe15e..2d62b48 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -2,3 +2,4 @@
=20
 generic-y +=3D clkdev.h
 generic-y +=3D rwsem.h
+generic-y +=3D trace_clock.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 0633dc6..f313f9c 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -1,3 +1,4 @@
=20
=20
 generic-y +=3D clkdev.h
+generic-y +=3D trace_clock.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index ec697ae..16e41fe 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 header-y +=3D
=20
 generic-y +=3D clkdev.h
+generic-y +=3D trace_clock.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 29f83be..280bea9 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -31,5 +31,6 @@ generic-y +=3D socket.h
 generic-y +=3D statfs.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
+generic-y +=3D trace_clock.h
 generic-y +=3D ucontext.h
 generic-y +=3D xor.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 645a58d..e26d430 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -8,4 +8,5 @@ generic-y +=3D local64.h
 generic-y +=3D irq_regs.h
 generic-y +=3D local.h
 generic-y +=3D module.h
+generic-y +=3D trace_clock.h
 generic-y +=3D word-at-a-time.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 6948015..b17b9b8 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -34,5 +34,6 @@ generic-y +=3D sockios.h
 generic-y +=3D statfs.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D xor.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 0f6e7b3..b30f34a 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -2,3 +2,4 @@ generic-y +=3D bug.h cputime.h device.h emergency-restart.h=
 futex.h hardirq.h
 generic-y +=3D hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h=
 xor.h
 generic-y +=3D ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y +=3D switch_to.h clkdev.h
+generic-y +=3D trace_clock.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm=
/Kbuild
index c910c98..7be503e 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -54,6 +54,7 @@ generic-y +=3D syscalls.h
 generic-y +=3D termbits.h
 generic-y +=3D termios.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D types.h
 generic-y +=3D ucontext.h
 generic-y +=3D unaligned.h
diff --git a/arch/x86/include/asm/trace_clock.h b/arch/x86/include/asm/trac=
e_clock.h
new file mode 100644
index 0000000..5c16527
--- /dev/null
+++ b/arch/x86/include/asm/trace_clock.h
@@ -0,0 +1,20 @@
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
+#else /* !CONFIG_X86_TSC */
+
+#define ARCH_TRACE_CLOCKS
+
+#endif
+
+#endif  /* _ASM_X86_TRACE_CLOCK_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9fd5eed..34e923a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_X86_REBOOTFIXUPS)	+=3D reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+=3D ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) +=3D ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+=3D ftrace.o
+obj-$(CONFIG_X86_TSC)		+=3D trace_clock.o
 obj-$(CONFIG_KEXEC)		+=3D machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+=3D relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+=3D crash_dump_$(BITS).o
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
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 6d13027..095f0a2 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -25,4 +25,5 @@ generic-y +=3D siginfo.h
 generic-y +=3D statfs.h
 generic-y +=3D termios.h
 generic-y +=3D topology.h
+generic-y +=3D trace_clock.h
 generic-y +=3D xor.h
diff --git a/include/asm-generic/trace_clock.h b/include/asm-generic/trace_=
clock.h
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
=20
+#include <asm/trace_clock.h>
+
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c1434b5..0d20620 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -488,6 +488,7 @@ static struct {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
 	{ trace_clock_counter,	"counter" },
+	ARCH_TRACE_CLOCKS
 };
=20
 int trace_clock_id;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQo+x2AAoJEOdOSU1xswtMxc0H/0oNOJDb7i08fgMzLCUtEwGl
X8/HNBbnSUgNDv2hmh2Xq22j/0HmmCVbDIGD/vl/TLBlUC0eGrk1HV5SjKddYa4Z
VpTQUn2pZJgf4hkfpASas/dI2znu1t6jbmjg9VLqQIe5xUGPTKXYrmytLT4ZbpAz
tkXMt1ohkeoCTpZI92fGo6BhD3UkrrYXbSict9V0gUP5rU8dQX0UNZ4f7uzPGXgR
24PzDJ45A0Oh4UFX7Ld8rgmdDNBJN7DDo32FPUv+CkDs5MJJ+/Kpbr9Bms+ZJGxJ
9ci5jai8iauPccp3TOzVJkK28fYS7ojbxR9hWfIUai8QDX7o1RsvkKnNfCpYSx0=
=UJ7C
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
