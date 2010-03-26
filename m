Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0CZNsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:48:00 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:35270 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab0CZNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rryDOh5FfMgjAbBlyvDLiVAEZorw6yWluXglwh8QoBWEaIS6GA0JNPoUS4gv+sgTgv
         /FO0nwxgjb2sVC2/3T0TVSOh96o86hDo4CSUYrch1N3ZZgsQuLAjLHqm+OOLE0Lpcf3d
         jwaW2+puxAnkE1+Iq6eRMSE9DembrOXQmAXOI=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Andrea Gelmini <andrea.gelmini@gelma.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] Tools perf builtin-trace.c: #includes cleanup
Date: Fri, 26 Mar 2010 14:47:50 +0100
Message-Id: <1269611272-29406-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <20100326080226.GC27394@elte.hu>
References: <20100326080226.GC27394@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed util/exec_cmd.h and util/trace-event.h included more than once.
Grouped and ordered includes.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 tools/perf/builtin-trace.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 407041d..c743c86 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,13 +1,16 @@
 #include "builtin.h"
+#include "perf.h"
 
-#include "util/util.h"
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
@@ -54,14 +57,6 @@ static int cleanup_scripting(void)
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
1.7.0.3.296.g9776a

