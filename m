Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1JSSXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:23:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:33409 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1JSSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/7] perf hists browser: Do not exit on tab key with single event
Date: Wed, 19 Oct 2011 16:23:38 -0200
Message-Id: <1319048618-9790-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319048618-9790-1-git-send-email-acme@infradead.org>
References: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

TUI help states for multiple event sessions the TAB/UNTAB keys are used
to switch events. For single event sessions (e.g., the default) the tab
key currently causes the tui to exit. Change that to do nothing since
there is not no second event to switch to.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1319045867-12728-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 94e1ab0..d762875 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -864,6 +864,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		switch (key) {
 		case NEWT_KEY_TAB:
 		case NEWT_KEY_UNTAB:
+			if (nr_events == 1)
+				continue;
 			/*
 			 * Exit the browser, let hists__browser_tree
 			 * go to the next or previous
-- 
1.6.2.5

