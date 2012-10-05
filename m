Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2JEIaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:30:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2JEIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:30:19 -0400
Date: Fri, 5 Oct 2012 01:29:57 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e4898336a1b4d8a259663d15b12f359b6c2887a2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348824728-14025-3-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Remove unused PYRF_OBJS variable on Makefile
Git-Commit-ID: e4898336a1b4d8a259663d15b12f359b6c2887a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:30:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4898336a1b4d8a259663d15b12f359b6c2887a2
Gitweb:     http://git.kernel.org/tip/e4898336a1b4d8a259663d15b12f359b6c2887a2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:31:58 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Sep 2012 21:07:36 -0300

perf tools: Remove unused PYRF_OBJS variable on Makefile

It seems that the PYRF_OBJS variable is not used anymore or has no
effect at least.  The util/setup.py tracks its dependency using
util/python-ext-sources file and resulting objects are saved under
python_ext_build/tmp/.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 834f09f..9cd4913 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -185,7 +185,7 @@ strip-libs = $(filter-out -l%,$(1))
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
 
-$(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
+$(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
 	mkdir -p $(OUTPUT)python && \
@@ -446,20 +446,6 @@ BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
 PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
-# Files needed for the python binding, perf.so
-# pyrf is just an internal name needed for all those wrappers.
-# This has to be in sync with what is in the 'sources' variable in
-# tools/perf/util/setup.py
-
-PYRF_OBJS += $(OUTPUT)util/cpumap.o
-PYRF_OBJS += $(OUTPUT)util/ctype.o
-PYRF_OBJS += $(OUTPUT)util/evlist.o
-PYRF_OBJS += $(OUTPUT)util/evsel.o
-PYRF_OBJS += $(OUTPUT)util/python.o
-PYRF_OBJS += $(OUTPUT)util/thread_map.o
-PYRF_OBJS += $(OUTPUT)util/util.o
-PYRF_OBJS += $(OUTPUT)util/xyarray.o
-
 #
 # Platform specific tweaks
 #
