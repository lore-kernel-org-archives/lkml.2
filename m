Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2HUQNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:13:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2HUQM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:12:59 -0400
Date: Tue, 21 Aug 2012 09:12:36 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-d0d3913895e5b50623bd4dafd876e41c1169031d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
In-Reply-To: <1344909423-26384-1-git-send-email-namhyung@kernel.org>
References: <1344909423-26384-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix a NULL pointer dereference
Git-Commit-ID: d0d3913895e5b50623bd4dafd876e41c1169031d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:12:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0d3913895e5b50623bd4dafd876e41c1169031d
Gitweb:     http://git.kernel.org/tip/d0d3913895e5b50623bd4dafd876e41c1169031d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 14 Aug 2012 10:57:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Aug 2012 10:36:30 -0300

perf script: Fix a NULL pointer dereference

If 'perf script --gen-script' was called with a perf.data which contains
no tracepoint event, it'd segfault due to NULL pevent pointer. Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344909423-26384-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 4cb7f38..a5a554e 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -293,7 +293,7 @@ struct event_format *trace_find_next_event(struct pevent *pevent,
 {
 	static int idx;
 
-	if (!pevent->events)
+	if (!pevent || !pevent->events)
 		return NULL;
 
 	if (!event) {
