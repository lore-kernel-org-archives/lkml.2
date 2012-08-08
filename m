Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab2HHDV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:21:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2HHDVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:21:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf header: Set the tracepoint names on PERF_RECORD_HEADER_TRACING_DATA
Date: Wed,  8 Aug 2012 00:20:52 -0300
Message-Id: <1344396057-10540-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344396057-10540-1-git-send-email-acme@infradead.org>
References: <1344396057-10540-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We only have access to pevent after processing that event, so set the
tracepoint names there.

Right now this isn't a problem as we're deferring resolving the
tracepoint names to when we process samples, but in the next patches we
will be doing it in advance, to avoid relookups, so do it earlier, as
soon as we process the tracing data event.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tzb7srmsl7a6o3icw592iv2o@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 74ea3c2..e2b4864 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2452,6 +2452,8 @@ int perf_event__process_tracing_data(union perf_event *event,
 	if (size_read + padding != size)
 		die("tracing data size mismatch");
 
+	perf_evlist__set_tracepoint_names(session->evlist, session->pevent);
+
 	return size_read + padding;
 }
 
-- 
1.7.9.2.358.g22243

