Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2AaNWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:22:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2AaNWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:22:51 -0500
Date: Tue, 31 Jan 2012 05:22:31 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-d30d4a080d195892091ad7d014fc9293cc08ea0f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1327827356-8786-4-git-send-email-namhyung@gmail.com>
References: <1327827356-8786-4-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unnecessary ctype.h inclusion
Git-Commit-ID: d30d4a080d195892091ad7d014fc9293cc08ea0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:22:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d30d4a080d195892091ad7d014fc9293cc08ea0f
Gitweb:     http://git.kernel.org/tip/d30d4a080d195892091ad7d014fc9293cc08ea0f
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 29 Jan 2012 17:55:55 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 18:37:35 -0200

perf tools: Remove unnecessary ctype.h inclusion

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
