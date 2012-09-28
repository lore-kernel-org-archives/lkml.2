Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2I1Jml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:42:41 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47736 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab2I1JkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:20 -0400
X-AuditID: 9c930197-b7b6dae000000e70-64-506570826a0f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 02/12] perf tools: Remove unused PYRF_OBJS variable on Makefile
Date: Fri, 28 Sep 2012 18:31:58 +0900
Message-Id: <1348824728-14025-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It seems that the PYRF_OBJS variable is not used anymore or has no
effect at least.  The util/setup.py tracks its dependency using
util/python-ext-sources file and resulting objects are saved under
python_ext_build/tmp/.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 834f09fa5c62..9cd49130f438 100644
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
-- 
1.7.11.4

