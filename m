Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab1KCRMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:12:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46553 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab1KCRMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:12:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf top tui: Don't recalc column widths considering just the first page
Date: Thu,  3 Nov 2011 15:11:45 -0200
Message-Id: <1320340306-24062-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1320340306-24062-1-git-send-email-acme@infradead.org>
References: <1320340306-24062-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It makes sense for the stdio where we can't navigate to the other pages.

On the TUI it breaks as soon as we navigate to other pages that have,
DSOs with longer names than the ones on the first page.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zvqfp18mw229agb43cikgb0k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8577bfe..a13f887 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -564,7 +564,6 @@ static void perf_top__sort_new_samples(void *arg)
 	hists__decay_entries_threaded(&t->sym_evsel->hists,
 				      top.hide_user_symbols,
 				      top.hide_kernel_symbols);
-	hists__output_recalc_col_len(&t->sym_evsel->hists, winsize.ws_row - 3);
 }
 
 static void *display_thread_tui(void *arg __used)
-- 
1.6.2.5

