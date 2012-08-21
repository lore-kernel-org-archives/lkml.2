Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2HUPwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:52:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2HUPws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:52:48 -0400
Date: Tue, 21 Aug 2012 08:52:09 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-2bcd355b71dafa5793a680c5db043abe9f708418@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
In-Reply-To: <1344345647-11536-9-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-9-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add interface to arch registers sets
Git-Commit-ID: 2bcd355b71dafa5793a680c5db043abe9f708418
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:52:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bcd355b71dafa5793a680c5db043abe9f708418
Gitweb:     http://git.kernel.org/tip/2bcd355b71dafa5793a680c5db043abe9f708418
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Aug 2012 15:20:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 16:32:59 -0300

perf tools: Add interface to arch registers sets

Adding header files to access unified API for arch registers.

  util/perf_regs.h - global perf_reg declarations
  arch/x86/include/perf_regs.h - x86 arch specific

Adding perf_reg_name function to obtain register name based on the reg
ID value, and PERF_REGS_MASK macro with mask definition of all current
arch registers (will be used in unwind patches).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1344345647-11536-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                     |   13 +++++-
 tools/perf/arch/x86/include/perf_regs.h |   80 +++++++++++++++++++++++++++++++
 tools/perf/util/perf_regs.h             |   14 +++++
 3 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index de6aa8c..27ae84b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -55,13 +55,15 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ )
+NO_PERF_REGS := 1
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
-        ARCH := x86
+	ARCH := x86
+	NO_PERF_REGS := 0
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
@@ -74,6 +76,7 @@ ifeq ($(ARCH),x86_64)
 		ARCH_CFLAGS := -DARCH_X86_64
 		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
 	endif
+	NO_PERF_REGS := 0
 endif
 
 # Treat warnings as errors unless directed not to
@@ -326,6 +329,7 @@ LIB_H += $(TRACE_EVENT_DIR)event-parse.h
 LIB_H += util/target.h
 LIB_H += util/rblist.h
 LIB_H += util/intlist.h
+LIB_H += util/perf_regs.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -704,6 +708,13 @@ else
 	endif
 endif
 
+ifeq ($(NO_PERF_REGS),0)
+	ifeq ($(ARCH),x86)
+		LIB_H += arch/x86/include/perf_regs.h
+	endif
+else
+	BASIC_CFLAGS += -DNO_PERF_REGS
+endif
 
 ifdef NO_STRLCPY
 	BASIC_CFLAGS += -DNO_STRLCPY
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
new file mode 100644
index 0000000..46fc9f1
--- /dev/null
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -0,0 +1,80 @@
+#ifndef ARCH_PERF_REGS_H
+#define ARCH_PERF_REGS_H
+
+#include <stdlib.h>
+#include "../../util/types.h"
+#include "../../../../../arch/x86/include/asm/perf_regs.h"
+
+#ifndef ARCH_X86_64
+#define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
+#else
+#define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
+		       (1ULL << PERF_REG_X86_ES) | \
+		       (1ULL << PERF_REG_X86_FS) | \
+		       (1ULL << PERF_REG_X86_GS))
+#define PERF_REGS_MASK (((1ULL << PERF_REG_X86_64_MAX) - 1) & ~REG_NOSUPPORT)
+#endif
+#define PERF_REG_IP PERF_REG_X86_IP
+#define PERF_REG_SP PERF_REG_X86_SP
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+	case PERF_REG_X86_AX:
+		return "AX";
+	case PERF_REG_X86_BX:
+		return "BX";
+	case PERF_REG_X86_CX:
+		return "CX";
+	case PERF_REG_X86_DX:
+		return "DX";
+	case PERF_REG_X86_SI:
+		return "SI";
+	case PERF_REG_X86_DI:
+		return "DI";
+	case PERF_REG_X86_BP:
+		return "BP";
+	case PERF_REG_X86_SP:
+		return "SP";
+	case PERF_REG_X86_IP:
+		return "IP";
+	case PERF_REG_X86_FLAGS:
+		return "FLAGS";
+	case PERF_REG_X86_CS:
+		return "CS";
+	case PERF_REG_X86_SS:
+		return "SS";
+	case PERF_REG_X86_DS:
+		return "DS";
+	case PERF_REG_X86_ES:
+		return "ES";
+	case PERF_REG_X86_FS:
+		return "FS";
+	case PERF_REG_X86_GS:
+		return "GS";
+#ifdef ARCH_X86_64
+	case PERF_REG_X86_R8:
+		return "R8";
+	case PERF_REG_X86_R9:
+		return "R9";
+	case PERF_REG_X86_R10:
+		return "R10";
+	case PERF_REG_X86_R11:
+		return "R11";
+	case PERF_REG_X86_R12:
+		return "R12";
+	case PERF_REG_X86_R13:
+		return "R13";
+	case PERF_REG_X86_R14:
+		return "R14";
+	case PERF_REG_X86_R15:
+		return "R15";
+#endif /* ARCH_X86_64 */
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+#endif /* ARCH_PERF_REGS_H */
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
new file mode 100644
index 0000000..9bd6c4e
--- /dev/null
+++ b/tools/perf/util/perf_regs.h
@@ -0,0 +1,14 @@
+#ifndef __PERF_REGS_H
+#define __PERF_REGS_H
+
+#ifndef NO_PERF_REGS
+#include <perf_regs.h>
+#else
+#define PERF_REGS_MASK	0
+
+static inline const char *perf_reg_name(int id __used)
+{
+	return NULL;
+}
+#endif /* NO_PERF_REGS */
+#endif /* __PERF_REGS_H */
