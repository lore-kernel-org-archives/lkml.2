Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab1DWQae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:30:34 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40237 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab1DWQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:30:29 -0400
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
Subject: [PATCH 16/18] perf: Export ctype.c
Date: Sat, 23 Apr 2011 18:28:18 +0200
Message-Id: <1303576100-425-17-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is needed when linking against libtrace.a

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile               |    1 +
 tools/{perf/util => lib/lk}/ctype.c |    2 +-
 tools/perf/Makefile                 |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/{perf/util => lib/lk}/ctype.c (98%)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 228b033..d444c5b 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -11,6 +11,7 @@ LIB_H += cpumap.h
 LIB_H += thread_map.h
 LIB_H += xyarray.h
 
+LIB_OBJS += ctype.o
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
 LIB_OBJS += util.o
diff --git a/tools/perf/util/ctype.c b/tools/lib/lk/ctype.c
similarity index 98%
rename from tools/perf/util/ctype.c
rename to tools/lib/lk/ctype.c
index 3507362..aada3ac 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/lib/lk/ctype.c
@@ -3,7 +3,7 @@
  *
  * No surprises, and works with signed and unsigned chars.
  */
-#include "cache.h"
+#include "util.h"
 
 enum {
 	S = GIT_SPACE,
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2edfa70..eb7f370 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -244,7 +244,6 @@ LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
-LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
-- 
1.7.4.rc2

