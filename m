Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0KZKb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:31:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:43616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0KZKb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:31:56 -0500
Date: Fri, 26 Nov 2010 10:31:19 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, yakui.zhao@intel.com,
        mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, rostedt@goodmis.org,
        ling.ma@intel.com, tglx@linutronix.de, miaox@cn.fujitsu.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, yakui.zhao@intel.com,
        mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, ling.ma@intel.com,
        rostedt@goodmis.org, miaox@cn.fujitsu.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1290668693-27068-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1290668693-27068-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Add feature that measures the performance of the arch/x86/lib/memcpy_64.S memcpy routines via 'perf bench mem'
Message-ID: <tip-ea7872b9d6a81101f6ba0ec141544a62fea35876@git.kernel.org>
Git-Commit-ID: ea7872b9d6a81101f6ba0ec141544a62fea35876
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:31:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea7872b9d6a81101f6ba0ec141544a62fea35876
Gitweb:     http://git.kernel.org/tip/ea7872b9d6a81101f6ba0ec141544a62fea35876
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 25 Nov 2010 16:04:53 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 08:15:57 +0100

perf bench: Add feature that measures the performance of the arch/x86/lib/memcpy_64.S memcpy routines via 'perf bench mem'

This patch ports arch/x86/lib/memcpy_64.S to perf bench mem
memcpy for benchmarking memcpy() in userland with tricky and
dirty way.

util/include/asm/cpufeature.h, util/include/asm/dwarf2.h, and
util/include/linux/linkage.h are mostly dummy files with small
wrappers, so that we are able to include memcpy_64.S
unmodified.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: h.mitake@gmail.com
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <1290668693-27068-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile                          |   11 +++++++++++
 tools/perf/bench/mem-memcpy-arch.h           |   12 ++++++++++++
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |    4 ++++
 tools/perf/bench/mem-memcpy-x86-64-asm.S     |    2 ++
 tools/perf/util/include/asm/cpufeature.h     |    9 +++++++++
 tools/perf/util/include/asm/dwarf2.h         |   11 +++++++++++
 tools/perf/util/include/linux/linkage.h      |   13 +++++++++++++
 7 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74b684d..e0db197 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -185,7 +185,10 @@ ifeq ($(ARCH),i386)
         ARCH := x86
 endif
 ifeq ($(ARCH),x86_64)
+	RAW_ARCH := x86_64
         ARCH := x86
+	ARCH_CFLAGS := -DARCH_X86_64
+	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
 endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
@@ -375,6 +378,7 @@ LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
+LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
@@ -383,6 +387,8 @@ LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
 LIB_H += util/include/dwarf-regs.h
+LIB_H += util/include/asm/dwarf2.h
+LIB_H += util/include/asm/cpufeature.h
 LIB_H += perf.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
@@ -417,6 +423,7 @@ LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/cpumap.h
+LIB_H += $(ARCH_INCLUDE)
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -472,6 +479,9 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
+ifeq ($(RAW_ARCH),x86_64)
+BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
+endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
@@ -898,6 +908,7 @@ BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
 LIB_OBJS += $(COMPAT_OBJS)
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
+ALL_CFLAGS += $(ARCH_CFLAGS)
 ALL_LDFLAGS += $(BASIC_LDFLAGS)
 
 export TAR INSTALL DESTDIR SHELL_PATH
diff --git a/tools/perf/bench/mem-memcpy-arch.h b/tools/perf/bench/mem-memcpy-arch.h
new file mode 100644
index 0000000..a72e36c
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy-arch.h
@@ -0,0 +1,12 @@
+
+#ifdef ARCH_X86_64
+
+#define MEMCPY_FN(fn, name, desc)		\
+	extern void *fn(void *, const void *, size_t);
+
+#include "mem-memcpy-x86-64-asm-def.h"
+
+#undef MEMCPY_FN
+
+#endif
+
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
new file mode 100644
index 0000000..d588b87
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
@@ -0,0 +1,4 @@
+
+MEMCPY_FN(__memcpy,
+	"x86-64-unrolled",
+	"unrolled memcpy() in arch/x86/lib/memcpy_64.S")
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
new file mode 100644
index 0000000..a57b66e
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -0,0 +1,2 @@
+
+#include "../../../arch/x86/lib/memcpy_64.S"
diff --git a/tools/perf/util/include/asm/cpufeature.h b/tools/perf/util/include/asm/cpufeature.h
new file mode 100644
index 0000000..acffd5e
--- /dev/null
+++ b/tools/perf/util/include/asm/cpufeature.h
@@ -0,0 +1,9 @@
+
+#ifndef PERF_CPUFEATURE_H
+#define PERF_CPUFEATURE_H
+
+/* cpufeature.h ... dummy header file for including arch/x86/lib/memcpy_64.S */
+
+#define X86_FEATURE_REP_GOOD 0
+
+#endif	/* PERF_CPUFEATURE_H */
diff --git a/tools/perf/util/include/asm/dwarf2.h b/tools/perf/util/include/asm/dwarf2.h
new file mode 100644
index 0000000..bb4198e
--- /dev/null
+++ b/tools/perf/util/include/asm/dwarf2.h
@@ -0,0 +1,11 @@
+
+#ifndef PERF_DWARF2_H
+#define PERF_DWARF2_H
+
+/* dwarf2.h ... dummy header file for including arch/x86/lib/memcpy_64.S */
+
+#define CFI_STARTPROC
+#define CFI_ENDPROC
+
+#endif	/* PERF_DWARF2_H */
+
diff --git a/tools/perf/util/include/linux/linkage.h b/tools/perf/util/include/linux/linkage.h
new file mode 100644
index 0000000..06387cf
--- /dev/null
+++ b/tools/perf/util/include/linux/linkage.h
@@ -0,0 +1,13 @@
+
+#ifndef PERF_LINUX_LINKAGE_H_
+#define PERF_LINUX_LINKAGE_H_
+
+/* linkage.h ... for including arch/x86/lib/memcpy_64.S */
+
+#define ENTRY(name)				\
+	.globl name;				\
+	name:
+
+#define ENDPROC(name)
+
+#endif	/* PERF_LINUX_LINKAGE_H_ */
