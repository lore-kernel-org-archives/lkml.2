Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1AUPID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:08:03 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58515 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1AUPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:08:00 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 10/12] perf: Export ctype.c
Date: Fri, 21 Jan 2011 16:09:33 +0100
Message-Id: <1295622575-18607-11-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295622575-18607-1-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
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
index 2e7e02c..cb5587a 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -11,6 +11,7 @@ LIB_H += types.h
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
 LIB_OBJS += util.o
+LIB_OBJS += ctype.o
 
 LIBFILE = $(LIB_OUTPUT)liblk.a
 
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
index 2edc5d9..bb0a2f7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -394,7 +394,6 @@ LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
-LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evsel.o
-- 
1.7.4.rc2

