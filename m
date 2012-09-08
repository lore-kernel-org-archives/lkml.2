Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651Ab2IHCJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:09:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41332 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760320Ab2IHCH1 (ORCPT
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
Subject: [PATCH 08/13] perf tools: fix missing winsize definition
Date: Fri,  7 Sep 2012 23:07:07 -0300
Message-Id: <1347070032-4161-9-git-send-email-acme@infradead.org>
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

In Android, struct winsize is not defined in the headers already
included in help.c. This leads to a compile error.

Including termios.h fixes the compilation error since it defines struct winsize.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-7-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/help.c |    1 +
 tools/perf/util/top.h  |    1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..4fa764d 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -3,6 +3,7 @@
 #include "exec_cmd.h"
 #include "levenshtein.h"
 #include "help.h"
+#include <termios.h>
 
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 33347ca..86ff1b1 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -5,6 +5,7 @@
 #include "types.h"
 #include <stddef.h>
 #include <stdbool.h>
+#include <termios.h>
 
 struct perf_evlist;
 struct perf_evsel;
-- 
1.7.9.2.358.g22243

