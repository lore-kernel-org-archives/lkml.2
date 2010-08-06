Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978Ab0HFRG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:06:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:42651 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933750Ab0HFRGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:06:54 -0400
Date: Fri, 6 Aug 2010 17:06:19 GMT
From: tip-bot for Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, andrea.gelmini@gelma.net, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tzanussi@gmail.com,
        andrea.gelmini@gelma.net, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1281016299-23958-14-git-send-email-andrea.gelmini@gelma.net>
References: <1281016299-23958-14-git-send-email-andrea.gelmini@gelma.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Clean up #includes
Message-ID: <tip-b7eead86d2951dab733d36554e8166a2a91d7363@git.kernel.org>
Git-Commit-ID: b7eead86d2951dab733d36554e8166a2a91d7363
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:06:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7eead86d2951dab733d36554e8166a2a91d7363
Gitweb:     http://git.kernel.org/tip/b7eead86d2951dab733d36554e8166a2a91d7363
Author:     Andrea Gelmini <andrea.gelmini@gelma.net>
AuthorDate: Thu, 5 Aug 2010 15:51:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:38:02 -0300

perf trace: Clean up #includes

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
