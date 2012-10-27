Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab2J0VS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2J0VSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:18:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf tool: Move BUILD_ID_SIZE into build-id object
Date: Sat, 27 Oct 2012 23:18:29 +0200
Message-Id: <1351372712-21104-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
References: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving BUILD_ID_SIZE define into build-id object,
plus include related changes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c | 1 +
 tools/perf/util/annotate.c         | 1 +
 tools/perf/util/build-id.h         | 6 +++++-
 tools/perf/util/event.h            | 3 +--
 tools/perf/util/symbol.h           | 3 +--
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index edb26ea..fae8b25 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/strlist.h"
 #include "util/build-id.h"
+#include "util/symbol.h"
 
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
 {
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f0a9103..7a34dd1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "annotate.h"
 #include <pthread.h>
+#include <linux/bitops.h>
 
 const char 	*disassembler_style;
 const char	*objdump_path;
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index f6d9ff9..a811f5c 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -1,9 +1,13 @@
 #ifndef PERF_BUILD_ID_H_
 #define PERF_BUILD_ID_H_ 1
 
-#include "session.h"
+#define BUILD_ID_SIZE 20
+
+#include "tool.h"
+#include "types.h"
 
 extern struct perf_tool build_id__mark_dso_hit_ops;
+struct dso;
 
 int build_id__sprintf(const u8 *build_id, int len, char *bf);
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index da97aff..0d573ff 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -6,6 +6,7 @@
 
 #include "../perf.h"
 #include "map.h"
+#include "build-id.h"
 
 /*
  * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
@@ -96,8 +97,6 @@ struct perf_sample {
 	struct stack_dump user_stack;
 };
 
-#define BUILD_ID_SIZE 20
-
 struct build_id_event {
 	struct perf_event_header header;
 	pid_t			 pid;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d70f676..6eb7d3b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <byteswap.h>
 #include <libgen.h>
+#include "build-id.h"
 
 #ifdef LIBELF_SUPPORT
 #include <libelf.h>
@@ -57,8 +58,6 @@ char *strxfrchar(char *s, char from, char to);
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
 
-#define BUILD_ID_SIZE 20
-
 /** struct symbol - symtab entry
  *
  * @ignore - resolvable but tools ignore it (e.g. idle routines)
-- 
1.7.11.7

