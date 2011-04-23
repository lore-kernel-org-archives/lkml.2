Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1DWQ37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35126 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1DWQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:54 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/18] perf: Drop redundant FD macro definitions
Date: Sat, 23 Apr 2011 18:28:11 +0200
Message-Id: <1303576100-425-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Put a single define in the util/util.h header which should be generic
enough and included by all builtin commands.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/perf/builtin-record.c |    2 --
 tools/perf/builtin-top.c    |    2 --
 tools/perf/util/evlist.c    |    3 ---
 tools/perf/util/evsel.c     |    2 --
 tools/perf/util/util.h      |    3 +++
 5 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4165382..4497a38 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -30,8 +30,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7e3d6e3..7fd50c1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -62,8 +62,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 static struct perf_top top = {
 	.count_filter		= 5,
 	.delay_secs		= 2,
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 45da8d1..65a8031 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -19,9 +19,6 @@
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-#define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
-
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
 {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d6fd59b..13ee267 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -13,8 +13,6 @@
 #include "cpumap.h"
 #include "thread_map.h"
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index fc78428..c32d66d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -39,6 +39,9 @@
 /* Approximation of the length of the decimal representation of this type. */
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
+#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
+
 #define _ALL_SOURCE 1
 #define _GNU_SOURCE 1
 #define _BSD_SOURCE 1
-- 
1.7.4.rc2

