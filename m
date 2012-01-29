Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2A2I4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 03:56:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2A2I4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 03:56:12 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] perf tools: Remove unnecessary ctype.h inclusion
Date: Sun, 29 Jan 2012 17:55:55 +0900
Message-Id: <1327827356-8786-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are unnecessary #include <ctype.h> out there, and they might
cause a nasty build failure in some environment. As we already have
most of ctype macros in util.h, just get rid of them.

A few of exceptions are util/symbol.c which needs isupper() macro
util.h doesn't provide and perl scripting support code which includes
ctype.h internally.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
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
index 6ad2b1c6b27b..71557225bf92 100644
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
index 59d4933eff44..e9079185bd72 100644
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
index 5d732621a462..67dc4aed721c 100644
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
index 0b2a48783172..c2623c6f9b51 100644
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
index 1a8d4dc4f386..e0a4f652f289 100644
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
index f55cc3a765a1..b9592e0de8d7 100644
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
index a3fdf55f317b..18ae6c1831d3 100644
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
index 6905bcc8be2d..eca6575abfd0 100644
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
1.7.8.2

