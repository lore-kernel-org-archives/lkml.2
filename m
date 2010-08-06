Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227Ab0HFBqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:46:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935206Ab0HFBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:46:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrea Gelmini <andrea.gelmini@gelma.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf trace: Clean up #includes
Date: Thu,  5 Aug 2010 22:46:15 -0300
Message-Id: <1281059177-18747-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281059177-18747-1-git-send-email-acme@infradead.org>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>

Removed duplicated #includes util/trace-event.h and
util/exec_cmd.h.
Grouped and sorted all the #includes.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1281016299-23958-14-git-send-email-andrea.gelmini@gelma.net>
Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 294da72..40a6a29 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,13 +1,16 @@
 #include "builtin.h"
 
-#include "util/util.h"
+#include "perf.h"
 #include "util/cache.h"
+#include "util/debug.h"
+#include "util/exec_cmd.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/header.h"
-#include "util/exec_cmd.h"
 #include "util/trace-event.h"
-#include "util/session.h"
+#include "util/util.h"
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -59,14 +62,6 @@ static int cleanup_scripting(void)
 	return scripting_ops->stop_script();
 }
 
-#include "util/parse-options.h"
-
-#include "perf.h"
-#include "util/debug.h"
-
-#include "util/trace-event.h"
-#include "util/exec_cmd.h"
-
 static char const		*input_name = "perf.data";
 
 static int process_sample_event(event_t *event, struct perf_session *session)
-- 
1.6.2.5

