Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1JMPIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:08:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:43429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1JMPId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:08:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/6] perf hists: Fix compilation when NO_NEWT_SUPPORT is set
Date: Thu, 13 Oct 2011 12:08:21 -0300
Message-Id: <1318518504-23299-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318518504-23299-1-git-send-email-acme@infradead.org>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch, relative to tip/master, makes perf compile when
NO_NEWT_SUPPORT is set.  It also fixes the line formatting to fit 80
columns.

Please test with NO_NEWT.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20111012120328.GA1619@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 7ea1e56..7416521 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -103,16 +103,20 @@ struct perf_evlist;
 #ifdef NO_NEWT_SUPPORT
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
-				  const char *help __used, void(*timer)(void *arg) __used, void *arg,
+				  const char *help __used,
+				  void(*timer)(void *arg) __used,
+				  void *arg __used,
 				  int refresh __used)
 {
 	return 0;
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
-					   int evidx __used, int nr_events __used,
+					   int evidx __used,
+					   int nr_events __used,
 					   void(*timer)(void *arg) __used,
-					   void *arg __used, int delay_secs __used);
+					   void *arg __used,
+					   int delay_secs __used)
 {
 	return 0;
 }
-- 
1.6.2.5

