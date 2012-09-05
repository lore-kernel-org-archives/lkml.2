Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab2IEXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804Ab2IEXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/17] perf tools: remove unneeded include of network header files
Date: Wed,  5 Sep 2012 20:08:52 -0300
Message-Id: <1346886537-11621-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

perf does not have networking related functionality, and the inclusion
of these headers is one of the causes of compile failures for Android:

  https://lkml.org/lkml/2012/8/23/316
  https://lkml.org/lkml/2012/8/28/293

So, remove them.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346255732-93246-1-git-send-email-dsahern@gmail.com
[ committer note: fix trace-event-perl.c compile failure by reordering includes ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    8 ++++----
 tools/perf/util/util.h                             |    5 -----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index d280010..94e6736 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -25,16 +25,16 @@
 #include <ctype.h>
 #include <errno.h>
 
-#include "../../perf.h"
 #include "../util.h"
+#include <EXTERN.h>
+#include <perl.h>
+
+#include "../../perf.h"
 #include "../thread.h"
 #include "../event.h"
 #include "../trace-event.h"
 #include "../evsel.h"
 
-#include <EXTERN.h>
-#include <perl.h>
-
 void boot_Perf__Trace__Context(pTHX_ CV *cv);
 void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 00a93a9..67a3713 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -69,11 +69,6 @@
 #include <sys/poll.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
-#include <sys/select.h>
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-#include <arpa/inet.h>
-#include <netdb.h>
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 #include "types.h"
-- 
1.7.1

