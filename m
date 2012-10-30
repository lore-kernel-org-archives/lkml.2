Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2J3MCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:02:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2J3MCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:02:08 -0400
Date: Tue, 30 Oct 2012 05:00:59 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-4383db88a7afb2664941ef1e82d41f5aad8be2ec@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351372712-21104-3-git-send-email-jolsa@redhat.com>
References: <1351372712-21104-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move BUILD_ID_SIZE into build-id object
Git-Commit-ID: 4383db88a7afb2664941ef1e82d41f5aad8be2ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:01:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4383db88a7afb2664941ef1e82d41f5aad8be2ec
Gitweb:     http://git.kernel.org/tip/4383db88a7afb2664941ef1e82d41f5aad8be2ec
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 27 Oct 2012 23:18:29 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:35:32 -0200

perf tools: Move BUILD_ID_SIZE into build-id object

Moving BUILD_ID_SIZE define into build-id object, plus include related
changes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351372712-21104-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c |    1 +
 tools/perf/util/annotate.c         |    1 +
 tools/perf/util/build-id.h         |    6 +++++-
 tools/perf/util/event.h            |    3 +--
 tools/perf/util/symbol.h           |    3 +--
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
