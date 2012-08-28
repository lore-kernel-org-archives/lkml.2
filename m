Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2H1WEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:04:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54398 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2H1WEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:04:37 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:04:17 +0300
Message-ID: <CANg8OWLm2XVG5WfLzNjgeF4Skj0511aSCCeTEg9-RQuedg7wvA@mail.gmail.com>
Subject: [PATCH 07/13] perf tools: fix missing winsize definition
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

In Android, struct winsize is not defined in
the headers already included in help.c.
This leads to a compile error.

Including termios.h fixes the compilation error
since it defines struct winsize.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
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
1.7.9.5
