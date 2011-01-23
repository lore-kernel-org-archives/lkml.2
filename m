Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab1AWB4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 20:56:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1AWB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 20:56:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/6] perf tools: Fix build when using gcc 3.4.6
Date: Sat, 22 Jan 2011 23:56:16 -0200
Message-Id: <1295747778-26186-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295747778-26186-1-git-send-email-acme@infradead.org>
References: <1295747778-26186-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[acme@localhost linux]$ make O=~acme/git/build/perf -C tools/perf
make: Entering directory `/home/acme/git/linux/tools/perf'
Makefile:526: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
Makefile:582: newt not found, disables TUI support. Please install newt-devel or libnewt-dev
    CC /home/acme/git/build/perf/builtin-annotate.o
In file included from builtin-annotate.c:23:
util/parse-events.h:26: warning: declaration of 'evsel_list' shadows a global declaration
util/parse-events.h:12: warning: shadowed declaration is here
make: *** [/home/acme/git/build/perf/builtin-annotate.o] Error 1
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@localhost linux]$ gcc --version | head -1
gcc (GCC) 3.4.6 20060404 (Red Hat 3.4.6-11)
[acme@localhost linux]$

Fix it by renaming the parameter to evlist.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b82cafb..458e3ec 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -23,7 +23,7 @@ struct tracepoint_path {
 };
 
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
-extern bool have_tracepoints(struct list_head *evsel_list);
+extern bool have_tracepoints(struct list_head *evlist);
 
 extern int			nr_counters;
 
-- 
1.6.2.5

