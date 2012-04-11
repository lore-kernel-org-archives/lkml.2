Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2DKVGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:06:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:45999 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761242Ab2DKVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter@infradead.org, "Zijlstra <a.p.zijlstra"@chello.nl,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/13] perf tools: Move UI bits to tools/perf/ui directory
Date: Wed, 11 Apr 2012 18:05:21 -0300
Message-Id: <1334178325-19148-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Move those files to new directory in order to be prepared to further UI
work. Makefile and header file pathes are adjusted accordingly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/1333523666-12057-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                          |   40 +++++++++++++-------------
 tools/perf/{util => }/ui/browser.c           |    0
 tools/perf/{util => }/ui/browser.h           |    0
 tools/perf/{util => }/ui/browsers/annotate.c |   10 +++----
 tools/perf/{util => }/ui/browsers/hists.c    |   12 ++++----
 tools/perf/{util => }/ui/browsers/map.c      |    6 ++--
 tools/perf/{util => }/ui/browsers/map.h      |    0
 tools/perf/{util => }/ui/helpline.c          |    0
 tools/perf/{util => }/ui/helpline.h          |    0
 tools/perf/{util => }/ui/keysyms.h           |    0
 tools/perf/{util => }/ui/libslang.h          |    0
 tools/perf/{util => }/ui/progress.c          |    0
 tools/perf/{util => }/ui/progress.h          |    0
 tools/perf/{util => }/ui/setup.c             |    0
 tools/perf/{util => }/ui/ui.h                |    0
 tools/perf/{util => }/ui/util.c              |    0
 tools/perf/{util => }/ui/util.h              |    0
 tools/perf/util/debug.h                      |    2 +-
 tools/perf/util/hist.h                       |    2 +-
 19 files changed, 36 insertions(+), 36 deletions(-)
 rename tools/perf/{util => }/ui/browser.c (100%)
 rename tools/perf/{util => }/ui/browser.h (100%)
 rename tools/perf/{util => }/ui/browsers/annotate.c (99%)
 rename tools/perf/{util => }/ui/browsers/hists.c (99%)
 rename tools/perf/{util => }/ui/browsers/map.c (97%)
 rename tools/perf/{util => }/ui/browsers/map.h (100%)
 rename tools/perf/{util => }/ui/helpline.c (100%)
 rename tools/perf/{util => }/ui/helpline.h (100%)
 rename tools/perf/{util => }/ui/keysyms.h (100%)
 rename tools/perf/{util => }/ui/libslang.h (100%)
 rename tools/perf/{util => }/ui/progress.c (100%)
 rename tools/perf/{util => }/ui/progress.h (100%)
 rename tools/perf/{util => }/ui/setup.c (100%)
 rename tools/perf/{util => }/ui/ui.h (100%)
 rename tools/perf/{util => }/ui/util.c (100%)
 rename tools/perf/{util => }/ui/util.h (100%)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b28b610..af6ccf8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -473,22 +473,22 @@ else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
 		BASIC_CFLAGS += -I/usr/include/slang
 		EXTLIBS += -lnewt -lslang
-		LIB_OBJS += $(OUTPUT)util/ui/setup.o
-		LIB_OBJS += $(OUTPUT)util/ui/browser.o
-		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
-		LIB_OBJS += $(OUTPUT)util/ui/browsers/hists.o
-		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
-		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
-		LIB_OBJS += $(OUTPUT)util/ui/progress.o
-		LIB_OBJS += $(OUTPUT)util/ui/util.o
-		LIB_H += util/ui/browser.h
-		LIB_H += util/ui/browsers/map.h
-		LIB_H += util/ui/helpline.h
-		LIB_H += util/ui/keysyms.h
-		LIB_H += util/ui/libslang.h
-		LIB_H += util/ui/progress.h
-		LIB_H += util/ui/util.h
-		LIB_H += util/ui/ui.h
+		LIB_OBJS += $(OUTPUT)ui/setup.o
+		LIB_OBJS += $(OUTPUT)ui/browser.o
+		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
+		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
+		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+		LIB_OBJS += $(OUTPUT)ui/helpline.o
+		LIB_OBJS += $(OUTPUT)ui/progress.o
+		LIB_OBJS += $(OUTPUT)ui/util.o
+		LIB_H += ui/browser.h
+		LIB_H += ui/browsers/map.h
+		LIB_H += ui/helpline.h
+		LIB_H += ui/keysyms.h
+		LIB_H += ui/libslang.h
+		LIB_H += ui/progress.h
+		LIB_H += ui/util.h
+		LIB_H += ui/ui.h
 	endif
 endif
 
@@ -755,16 +755,16 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-$(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
+$(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
+$(OUTPUT)ui/browsers/annotate.o: ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
+$(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
+$(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/ui/browser.c
similarity index 100%
rename from tools/perf/util/ui/browser.c
rename to tools/perf/ui/browser.c
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/ui/browser.h
similarity index 100%
rename from tools/perf/util/ui/browser.h
rename to tools/perf/ui/browser.h
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
similarity index 99%
rename from tools/perf/util/ui/browsers/annotate.c
rename to tools/perf/ui/browsers/annotate.c
index c2cfeed..4db5186 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -1,13 +1,13 @@
-#include "../../util.h"
+#include "../../util/util.h"
 #include "../browser.h"
 #include "../helpline.h"
 #include "../libslang.h"
 #include "../ui.h"
 #include "../util.h"
-#include "../../annotate.h"
-#include "../../hist.h"
-#include "../../sort.h"
-#include "../../symbol.h"
+#include "../../util/annotate.h"
+#include "../../util/hist.h"
+#include "../../util/sort.h"
+#include "../../util/symbol.h"
 #include <pthread.h>
 #include <newt.h>
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
similarity index 99%
rename from tools/perf/util/ui/browsers/hists.c
rename to tools/perf/ui/browsers/hists.c
index 1b820ed..466827e 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -5,12 +5,12 @@
 #include <newt.h>
 #include <linux/rbtree.h>
 
-#include "../../evsel.h"
-#include "../../evlist.h"
-#include "../../hist.h"
-#include "../../pstack.h"
-#include "../../sort.h"
-#include "../../util.h"
+#include "../../util/evsel.h"
+#include "../../util/evlist.h"
+#include "../../util/hist.h"
+#include "../../util/pstack.h"
+#include "../../util/sort.h"
+#include "../../util/util.h"
 
 #include "../browser.h"
 #include "../helpline.h"
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
similarity index 97%
rename from tools/perf/util/ui/browsers/map.c
rename to tools/perf/ui/browsers/map.c
index eca6575..98851d5 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -5,9 +5,9 @@
 #include <sys/ttydefaults.h>
 #include <string.h>
 #include <linux/bitops.h>
-#include "../../util.h"
-#include "../../debug.h"
-#include "../../symbol.h"
+#include "../../util/util.h"
+#include "../../util/debug.h"
+#include "../../util/symbol.h"
 #include "../browser.h"
 #include "../helpline.h"
 #include "map.h"
diff --git a/tools/perf/util/ui/browsers/map.h b/tools/perf/ui/browsers/map.h
similarity index 100%
rename from tools/perf/util/ui/browsers/map.h
rename to tools/perf/ui/browsers/map.h
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/ui/helpline.c
similarity index 100%
rename from tools/perf/util/ui/helpline.c
rename to tools/perf/ui/helpline.c
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/ui/helpline.h
similarity index 100%
rename from tools/perf/util/ui/helpline.h
rename to tools/perf/ui/helpline.h
diff --git a/tools/perf/util/ui/keysyms.h b/tools/perf/ui/keysyms.h
similarity index 100%
rename from tools/perf/util/ui/keysyms.h
rename to tools/perf/ui/keysyms.h
diff --git a/tools/perf/util/ui/libslang.h b/tools/perf/ui/libslang.h
similarity index 100%
rename from tools/perf/util/ui/libslang.h
rename to tools/perf/ui/libslang.h
diff --git a/tools/perf/util/ui/progress.c b/tools/perf/ui/progress.c
similarity index 100%
rename from tools/perf/util/ui/progress.c
rename to tools/perf/ui/progress.c
diff --git a/tools/perf/util/ui/progress.h b/tools/perf/ui/progress.h
similarity index 100%
rename from tools/perf/util/ui/progress.h
rename to tools/perf/ui/progress.h
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/ui/setup.c
similarity index 100%
rename from tools/perf/util/ui/setup.c
rename to tools/perf/ui/setup.c
diff --git a/tools/perf/util/ui/ui.h b/tools/perf/ui/ui.h
similarity index 100%
rename from tools/perf/util/ui/ui.h
rename to tools/perf/ui/ui.h
diff --git a/tools/perf/util/ui/util.c b/tools/perf/ui/util.c
similarity index 100%
rename from tools/perf/util/ui/util.c
rename to tools/perf/ui/util.c
diff --git a/tools/perf/util/ui/util.h b/tools/perf/ui/util.h
similarity index 100%
rename from tools/perf/util/ui/util.h
rename to tools/perf/ui/util.h
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index f2ce88d..6bebe7f 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -26,7 +26,7 @@ static inline void ui_progress__update(u64 curr __used, u64 total __used,
 #else
 extern char ui_helpline__last_msg[];
 int ui_helpline__show_help(const char *format, va_list ap);
-#include "ui/progress.h"
+#include "../ui/progress.h"
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #endif
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2cae9df..cfc64e2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -138,7 +138,7 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
 #define K_LEFT -1
 #define K_RIGHT -2
 #else
-#include "ui/keysyms.h"
+#include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 			     void(*timer)(void *arg), void *arg, int delay_secs);
 
-- 
1.7.9.2.358.g22243

