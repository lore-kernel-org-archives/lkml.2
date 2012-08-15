Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2HOO6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:58:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40597 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2HOO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:58:47 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] perf ui/tui: Add tui.h header
Date: Wed, 15 Aug 2012 23:57:32 +0900
Message-Id: <1345042655-27862-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1345042655-27862-1-git-send-email-namhyung@kernel.org>
References: <1345042655-27862-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate TUI-relate header files and declarations into tui.h.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile          |    1 +
 tools/perf/ui/helpline.h     |    2 --
 tools/perf/ui/tui/helpline.c |    5 +----
 tools/perf/ui/tui/setup.c    |   12 +-----------
 tools/perf/ui/tui/tui.h      |   21 +++++++++++++++++++++
 tools/perf/ui/tui/util.c     |   10 +---------
 6 files changed, 25 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/ui/tui/tui.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 483fb69fa4ae..14c0b744d98e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -581,6 +581,7 @@ else
 		LIB_H += ui/progress.h
 		LIB_H += ui/util.h
 		LIB_H += ui/ui.h
+		LIB_H += ui/tui/tui.h
 	endif
 endif
 
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index eee8e2ff51d8..7e2d4fb10ebd 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -11,8 +11,6 @@ struct perf_helpline {
 
 extern struct perf_helpline *helpline_fns;
 
-void ui_helpline__init(void);
-
 void ui_helpline__pop(void);
 void ui_helpline__push(const char *msg);
 void ui_helpline__vpush(const char *fmt, va_list ap);
diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
index b63a9326d06b..a8e67e4a84ea 100644
--- a/tools/perf/ui/tui/helpline.c
+++ b/tools/perf/ui/tui/helpline.c
@@ -3,10 +3,7 @@
 #include <string.h>
 #include <pthread.h>
 
-#include "../../util/debug.h"
-#include "../helpline.h"
-#include "../ui.h"
-#include "../libslang.h"
+#include "tui.h"
 
 
 static void tui_helpline__pop(void)
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index e813c1d17346..e247bf51d247 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -1,22 +1,12 @@
-#include <newt.h>
 #include <signal.h>
 #include <stdbool.h>
 
-#include "../../util/cache.h"
-#include "../../util/debug.h"
-#include "../browser.h"
-#include "../helpline.h"
-#include "../ui.h"
-#include "../util.h"
-#include "../libslang.h"
-#include "../keysyms.h"
+#include "tui.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
 static volatile int ui__need_resize;
 
-extern struct perf_error_ops perf_tui_eops;
-
 void ui__refresh_dimensions(bool force)
 {
 	if (force || ui__need_resize) {
diff --git a/tools/perf/ui/tui/tui.h b/tools/perf/ui/tui/tui.h
new file mode 100644
index 000000000000..17da45ed8ca4
--- /dev/null
+++ b/tools/perf/ui/tui/tui.h
@@ -0,0 +1,21 @@
+#ifndef _PERF_TUI_H_
+#define _PERF_TUI_H_
+
+#include <newt.h>
+
+#include "../../util/debug.h"
+#include "../../util/cache.h"
+#include "../ui.h"
+#include "../util.h"
+#include "../browser.h"
+#include "../helpline.h"
+#include "../libslang.h"
+#include "../keysyms.h"
+
+extern struct perf_error_ops perf_tui_eops;
+
+extern struct perf_helpline tui_helpline_fns;
+
+void ui_helpline__init(void);
+
+#endif /* _PERF_TUI_H */
diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
index 092902e30cee..b555ae839b2a 100644
--- a/tools/perf/ui/tui/util.c
+++ b/tools/perf/ui/tui/util.c
@@ -1,17 +1,9 @@
-#include "../../util/util.h"
 #include <signal.h>
 #include <stdbool.h>
 #include <string.h>
 #include <sys/ttydefaults.h>
 
-#include "../../util/cache.h"
-#include "../../util/debug.h"
-#include "../browser.h"
-#include "../keysyms.h"
-#include "../helpline.h"
-#include "../ui.h"
-#include "../util.h"
-#include "../libslang.h"
+#include "tui.h"
 
 static void ui_browser__argv_write(struct ui_browser *browser,
 				   void *entry, int row)
-- 
1.7.9.2

