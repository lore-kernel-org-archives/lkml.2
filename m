Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2HUPxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:53:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60361 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2HUPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:53:46 -0400
Date: Tue, 21 Aug 2012 08:53:05 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-6a40cd90f5deb6dec322eeb54587ae55a934db2c@git.kernel.org>
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
In-Reply-To: <1344345647-11536-10-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-10-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add libunwind dependency for DWARF CFI unwinding
Git-Commit-ID: 6a40cd90f5deb6dec322eeb54587ae55a934db2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:53:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a40cd90f5deb6dec322eeb54587ae55a934db2c
Gitweb:     http://git.kernel.org/tip/6a40cd90f5deb6dec322eeb54587ae55a934db2c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Aug 2012 15:20:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 16:46:07 -0300

perf tools: Add libunwind dependency for DWARF CFI unwinding

Adding libunwind to be linked with perf if available. It's required
for the to get dwarf cfi unwinding support.

Also building perf with the dwarf call frame informations by default,
so that we can unwind callchains in perf itself.

Adding LIBUNWIND_DIR Makefile variable allowing user to specify
the directory with libunwind to be linked. This is used for
debug purposes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>
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
Link: http://lkml.kernel.org/r/1344345647-11536-10-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |   29 ++++++++++++++++++++++++++++-
 tools/perf/config/feature-tests.mak |   25 +++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 27ae84b..0aee6a9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -43,6 +43,8 @@ include config/utilities.mak
 #
 # Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
 #
+# Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
+# backtrace post unwind.
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -64,6 +66,7 @@ AR = $(CROSS_COMPILE)ar
 ifeq ($(ARCH),i386)
 	ARCH := x86
 	NO_PERF_REGS := 0
+	LIBUNWIND_LIBS = -lunwind -lunwind-x86
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
@@ -77,6 +80,7 @@ ifeq ($(ARCH),x86_64)
 		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
 	endif
 	NO_PERF_REGS := 0
+	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
 endif
 
 # Treat warnings as errors unless directed not to
@@ -97,7 +101,7 @@ ifdef PARSER_DEBUG
 	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
@@ -476,6 +480,21 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 endif
 endif # NO_LIBELF
 
+ifndef NO_LIBUNWIND
+# for linking with debug library, run like:
+# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+ifdef LIBUNWIND_DIR
+	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+endif
+
+FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
+	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
+	NO_LIBUNWIND := 1
+endif # Libunwind support
+endif # NO_LIBUNWIND
+
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
@@ -522,6 +541,14 @@ endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 endif # NO_LIBELF
 
+ifdef NO_LIBUNWIND
+	BASIC_CFLAGS += -DNO_LIBUNWIND_SUPPORT
+else
+	EXTLIBS += $(LIBUNWIND_LIBS)
+	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
+endif
+
 ifdef NO_NEWT
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 else
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 6c18785..2f1156a 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -154,3 +154,28 @@ int main(void)
 	return 0;
 }
 endef
+
+ifndef NO_LIBUNWIND
+define SOURCE_LIBUNWIND
+#include <libunwind.h>
+#include <stdlib.h>
+
+extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
+                                      unw_word_t ip,
+                                      unw_dyn_info_t *di,
+                                      unw_proc_info_t *pi,
+                                      int need_unwind_info, void *arg);
+
+
+#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
+
+int main(void)
+{
+	unw_addr_space_t addr_space;
+	addr_space = unw_create_addr_space(NULL, 0);
+	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+	return 0;
+}
+endef
+endif
