Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab2H1WE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:04:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54398 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2H1WEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:04:55 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:04:34 +0300
Message-ID: <CANg8OWJLWGYfPmVbb3WJ5-Tbxob4URf49aUo7E_=ahSXKWvJPA@mail.gmail.com>
Subject: [PATCH 09/13] perf tools: include missing pthread.h header
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pthread variables are used in some files without explicitely
including pthread.h. This leads to compile errors on
Android. e.g.: in annotate.h, error: unknown type name 'pthread_mutex_t'

Including pthread.h explicitely in files that use it to have
all definitions included.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
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
index d6f1b4b..0c81586 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -7,6 +7,7 @@
 #include "symbol.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <pthread.h>

 struct ins;

--
1.7.9.5
