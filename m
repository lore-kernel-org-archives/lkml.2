Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1JWTMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:12:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53963 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1JWTMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:12:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf hists browser: Refuse 'a' hotkey on non symbolic views
Date: Sun, 23 Oct 2011 17:12:22 -0200
Message-Id: <1319397143-20301-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319397143-20301-1-git-send-email-acme@infradead.org>
References: <1319397143-20301-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We don't allocate the histogram data structures for --sort lists without
"sym", so, just like was done for the menu, don't try to annotate when
'a' is pressed, just warn the user about it.

Reported-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-27mjg02s2mbw8lfxqv7jpzec@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index af12e6f..4663dcb 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -882,6 +882,13 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			 */
 			goto out_free_stack;
 		case 'a':
+			if (!browser->has_symbols) {
+				ui__warning(
+			"Annotation is only available for symbolic views, "
+			"include \"sym\" in --sort to use it.");
+				continue;
+			}
+
 			if (browser->selection == NULL ||
 			    browser->selection->sym == NULL ||
 			    browser->selection->map->dso->annotate_warned)
-- 
1.6.2.5

