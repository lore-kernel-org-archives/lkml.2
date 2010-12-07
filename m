Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0LGMti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:38 -0500
Received: from www.tglx.de ([62.245.132.106]:46623 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0LGMt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:27 -0500
Message-Id: <20101207124550.818568607@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 5/9] perf: session: Add file_offset to event delivery function
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline;
	filename=perf-session-add-fileoffset-to-deliver.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for ordered output of perf report -D

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -465,7 +465,8 @@ static void perf_session_free_sample_buf
 static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
 				      struct sample_data *sample,
-				      struct perf_event_ops *ops);
+				      struct perf_event_ops *ops,
+				      u64 file_offset);
 
 static void flush_sample_queue(struct perf_session *s,
 			       struct perf_event_ops *ops)
@@ -485,7 +486,8 @@ static void flush_sample_queue(struct pe
 			break;
 
 		event__parse_sample(iter->event, s, &sample);
-		perf_session_deliver_event(s, iter->event, &sample, ops);
+		perf_session_deliver_event(s, iter->event, &sample, ops,
+					   iter->file_offset);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -699,7 +701,8 @@ static void dump_sample(struct perf_sess
 static int perf_session_deliver_event(struct perf_session *session,
 				      event_t *event,
 				      struct sample_data *sample,
-				      struct perf_event_ops *ops)
+				      struct perf_event_ops *ops,
+				      u64 file_offset __used)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
@@ -788,7 +791,8 @@ static int perf_session__process_event(s
 			return ret;
 	}
 
-	return perf_session_deliver_event(session, event, &sample, ops);
+	return perf_session_deliver_event(session, event, &sample, ops,
+					  file_offset);
 }
 
 void perf_event_header__bswap(struct perf_event_header *self)


