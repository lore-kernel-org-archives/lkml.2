Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2JDS0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:26:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:39661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JDSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:08:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/42] perf tools: Remove unused PYRF_OBJS variable on Makefile
Date: Thu,  4 Oct 2012 15:08:02 -0300
Message-Id: <1349374122-27806-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
-- 
1.7.1

