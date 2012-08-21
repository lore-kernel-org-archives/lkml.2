Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2HUPUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:20:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2HUPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:20:15 -0400
Date: Tue, 21 Aug 2012 08:19:51 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-tzb7srmsl7a6o3icw592iv2o@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header:
  Set the tracepoint names on PERF_RECORD_HEADER_TRACING_DATA
Git-Commit-ID: 8b6ee4c5d48d93527dcf6e36c51cbb7703d7fffb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:19:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b6ee4c5d48d93527dcf6e36c51cbb7703d7fffb
Gitweb:     http://git.kernel.org/tip/8b6ee4c5d48d93527dcf6e36c51cbb7703d7fffb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 7 Aug 2012 23:36:16 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Aug 2012 23:36:16 -0300

perf header: Set the tracepoint names on PERF_RECORD_HEADER_TRACING_DATA

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
 1 files changed, 2 insertions(+), 0 deletions(-)

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
 
