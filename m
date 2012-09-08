Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427Ab2IHCJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:09:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41334 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760326Ab2IHCH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/13] perf tools: include missing pthread.h header
Date: Fri,  7 Sep 2012 23:07:08 -0300
Message-Id: <1347070032-4161-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

pthread variables are used in some files without explicitely including
pthread.h. This leads to compile errors on Android. e.g.: in annotate.h,
error: unknown type name 'pthread_mutex_t'

Including pthread.h explicitely in files that use it to have all definitions
included.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-8-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c          |    1 +
 tools/perf/util/annotate.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index e7840e5..fb8578c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,6 +14,7 @@
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include "util/debugfs.h"
+#include <pthread.h>
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a6d6bc5..62a6e7a 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -7,6 +7,7 @@
 #include "symbol.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <pthread.h>
 
 struct ins;
 
-- 
1.7.9.2.358.g22243

