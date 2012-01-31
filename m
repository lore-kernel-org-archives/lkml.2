Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2AaBZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:25:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:44366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2AaBYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/9] perf tools: Remove unnecessary ctype.h inclusion
Date: Mon, 30 Jan 2012 23:24:38 -0200
Message-Id: <1327973079-29426-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

There are unnecessary #include <ctype.h> out there, and they might cause
a nasty build failure in some environment. As we already have most of
ctype macros in util.h, just get rid of them.

A few of exceptions are util/symbol.c which needs isupper() macro util.h
doesn't provide and perl scripting support code which includes ctype.h
internally.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1327827356-8786-4-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c                      |    1 -
 tools/perf/bench/mem-memset.c                      |    1 -
 tools/perf/util/probe-finder.c                     |    1 -
 .../util/scripting-engines/trace-event-python.c    |    1 -
 tools/perf/util/trace-event-parse.c                |    1 -
 tools/perf/util/trace-event-read.c                 |    1 -
 tools/perf/util/trace-event-scripting.c            |    1 -
 tools/perf/util/ui/browsers/map.c                  |    2 +-
 8 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 6ad2b1c..7155722 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -5,7 +5,6 @@
  *
  * Written by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
  */
-#include <ctype.h>
 
 #include "../perf.h"
 #include "../util/util.h"
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 59d4933..e907918 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -5,7 +5,6 @@
  *
  * Trivial clone of mem-memcpy.c.
  */
-#include <ctype.h>
 
 #include "../perf.h"
 #include "../util/util.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..67dc4ae 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -30,7 +30,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
-#include <ctype.h>
 #include <dwarf-regs.h>
 
 #include <linux/bitops.h>
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 0b2a487..c2623c6 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -24,7 +24,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <ctype.h>
 #include <errno.h>
 
 #include "../../perf.h"
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 1a8d4dc..e0a4f65 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -25,7 +25,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <ctype.h>
 #include <errno.h>
 
 #include "../perf.h"
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index f55cc3a..b9592e0 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -33,7 +33,6 @@
 #include <pthread.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include <ctype.h>
 #include <errno.h>
 
 #include "../perf.h"
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index a3fdf55..18ae6c1 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -22,7 +22,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <ctype.h>
 #include <errno.h>
 
 #include "../perf.h"
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 6905bcc..eca6575 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -3,9 +3,9 @@
 #include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
-#include <ctype.h>
 #include <string.h>
 #include <linux/bitops.h>
+#include "../../util.h"
 #include "../../debug.h"
 #include "../../symbol.h"
 #include "../browser.h"
-- 
1.7.9.rc2.1.g69204

