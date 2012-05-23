Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab2EWPXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:23:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab2EWPXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:23:30 -0400
Date: Wed, 23 May 2012 08:23:09 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-59f3bea53bfe2f395d548906fa39d01df620f0ac@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
References: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Rename libparsevent to libtraceevent in Makefile
Git-Commit-ID: 59f3bea53bfe2f395d548906fa39d01df620f0ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:23:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59f3bea53bfe2f395d548906fa39d01df620f0ac
Gitweb:     http://git.kernel.org/tip/59f3bea53bfe2f395d548906fa39d01df620f0ac
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 May 2012 18:03:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:34:52 -0300

perf tools: Rename libparsevent to libtraceevent in Makefile

Change some variable names according to new library name.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1337677434-4881-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b246236..ef75a55 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -155,7 +155,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(EVENT_PARSE_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -184,16 +184,16 @@ $(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
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
@@ -317,7 +317,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
-LIB_H += $(EVENT_PARSE_DIR)event-parse.h
+LIB_H += $(TRACE_EVENT_DIR)event-parse.h
 LIB_H += util/target.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
@@ -417,7 +417,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
-PERFLIBS = $(LIB_FILE) $(LIBPARSEVENT)
+PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
 # Files needed for the python binding, perf.so
 # pyrf is just an internal name needed for all those wrappers.
@@ -826,9 +826,9 @@ $(sort $(dir $(DIRECTORY_DEPS))):
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
