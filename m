Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2EVJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:06:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47070 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab2EVJF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:05:58 -0400
X-AuditID: 9c93016f-b7c3cae000001954-fe-4fbb56f4c929
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] perf tools: Rename libparsevent to libtraceevent in Makefile
Date: Tue, 22 May 2012 18:03:53 +0900
Message-Id: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change some variable names according to new library name.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fa37cd53e9b9..022845e51937 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -149,7 +149,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(EVENT_PARSE_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -178,16 +178,16 @@ $(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-EVENT_PARSE_DIR = ../lib/traceevent/
+TRACE_EVENT_DIR = ../lib/traceevent/
 
 ifeq ("$(origin O)", "command line")
-	EP_PATH=$(OUTPUT)/
+	TE_PATH=$(OUTPUT)/
 else
-	EP_PATH=$(EVENT_PARSE_DIR)/
+	TE_PATH=$(TRACE_EVENT_DIR)/
 endif
 
-LIBPARSEVENT = $(EP_PATH)libtraceevent.a
-EP_LIB := -L$(EP_PATH) -ltraceevent
+LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
+TE_LIB := -L$(TE_PATH) -ltraceevent
 
 #
 # Single 'perf' binary right now:
@@ -311,7 +311,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
-LIB_H += $(EVENT_PARSE_DIR)event-parse.h
+LIB_H += $(TRACE_EVENT_DIR)event-parse.h
 LIB_H += util/target.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
@@ -410,7 +410,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
-PERFLIBS = $(LIB_FILE) $(LIBPARSEVENT)
+PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
 # Files needed for the python binding, perf.so
 # pyrf is just an internal name needed for all those wrappers.
@@ -819,9 +819,9 @@ $(sort $(dir $(DIRECTORY_DEPS))):
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
-# libparsevent.a
-$(LIBPARSEVENT):
-	make -C $(EVENT_PARSE_DIR) $(COMMAND_O) libtraceevent.a
+# libtraceevent.a
+$(LIBTRACEEVENT):
+	$(MAKE) -C $(TRACE_EVENT_DIR) $(COMMAND_O) libtraceevent.a
 
 help:
 	@echo 'Perf make targets:'
-- 
1.7.10.1

