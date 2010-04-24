Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0DXCGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:06:13 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61498 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0DXCFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=DH8zWslPyKJpF7voCIJogRK9/ApxHXH3KHRcyHk2BJeDkU+oFKmeL2eaXZ0B/3qXCt
         bVH2MkSIfhVqeVC0lhk0UrsX5B2FJAlYvhLBFJ3Rjlx8aBS395tKyI53SytCG77tFnKQ
         WvXCK5OZh8qIBS9m7JxbQKMySQxto0vjkr2GU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/9] perf: Use generic sample reordering in perf sched
Date: Sat, 24 Apr 2010 04:05:37 +0200
Message-Id: <1272074742-3654-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic sample events reordering from perf sched,
this drops the need of multiplexing the buffers on record time,
improving the scalability of perf sched.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 09ddc8e..94453f1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1651,9 +1651,10 @@ static int process_lost_event(event_t *event __used,
 }
 
 static struct perf_event_ops event_ops = {
-	.sample	= process_sample_event,
-	.comm	= event__process_comm,
-	.lost	= process_lost_event,
+	.sample			= process_sample_event,
+	.comm			= event__process_comm,
+	.lost			= process_lost_event,
+	.ordered_samples	= true,
 };
 
 static int read_events(void)
@@ -1850,7 +1851,6 @@ static const char *record_args[] = {
 	"record",
 	"-a",
 	"-R",
-	"-M",
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-- 
1.6.2.3

