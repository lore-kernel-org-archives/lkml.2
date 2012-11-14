Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2KNGkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:40:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab2KNGj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:39:59 -0500
Date: Tue, 13 Nov 2012 22:39:37 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-945aea220bb8f4bb37950549cc0b93bbec24c460@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-3-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Move test objects into 'tests'
  directory
Git-Commit-ID: 945aea220bb8f4bb37950549cc0b93bbec24c460
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:39:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  945aea220bb8f4bb37950549cc0b93bbec24c460
Gitweb:     http://git.kernel.org/tip/945aea220bb8f4bb37950549cc0b93bbec24c460
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:43 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 16:19:19 -0200

perf tests: Move test objects into 'tests' directory

Separating test objects into 'tests' directory.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                                |    9 +++++----
 tools/perf/{ => tests}/builtin-test.c              |    8 ++++----
 .../{util/dso-test-data.c => tests/dso-data.c}     |    0
 .../parse-events-test.c => tests/parse-events.c}   |    0
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3e807d7..2d3427f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -Iutil -I. -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
@@ -371,7 +371,6 @@ LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
-LIB_OBJS += $(OUTPUT)util/parse-events-test.o
 LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/bitmap.o
@@ -389,7 +388,6 @@ LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/dso.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
 LIB_OBJS += $(OUTPUT)util/symbol-elf.o
-LIB_OBJS += $(OUTPUT)util/dso-test-data.o
 LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
@@ -430,6 +428,9 @@ LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
 LIB_OBJS += $(OUTPUT)arch/common.o
 
+LIB_OBJS += $(OUTPUT)tests/parse-events.o
+LIB_OBJS += $(OUTPUT)tests/dso-data.o
+
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
@@ -459,8 +460,8 @@ BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
-BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 
 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
diff --git a/tools/perf/builtin-test.c b/tools/perf/tests/builtin-test.c
similarity index 99%
rename from tools/perf/builtin-test.c
rename to tools/perf/tests/builtin-test.c
index a04276e..f6c6424 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -318,7 +318,7 @@ static int test__open_syscall_event(void)
 			 nr_open_calls, evsel->counts->cpu[0].val);
 		goto out_close_fd;
 	}
-	
+
 	err = 0;
 out_close_fd:
 	perf_evsel__close_fd(evsel, 1, threads->nr);
@@ -1344,8 +1344,8 @@ static int test__syscall_open_tp_fields(void)
 	perf_evlist__enable(evlist);
 
 	/*
- 	 * Generate the event:
- 	 */
+	 * Generate the event:
+	 */
 	open(filename, flags);
 
 	while (1) {
@@ -1495,7 +1495,7 @@ static int __cmd_test(int argc, const char *argv[])
 			width = len;
 		++i;
 	}
-		
+
 	i = 0;
 	while (tests[i].func) {
 		int curr = i++, err;
diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/tests/dso-data.c
similarity index 100%
rename from tools/perf/util/dso-test-data.c
rename to tools/perf/tests/dso-data.c
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/tests/parse-events.c
similarity index 100%
rename from tools/perf/util/parse-events-test.c
rename to tools/perf/tests/parse-events.c
