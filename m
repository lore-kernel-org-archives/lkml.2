Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab1LWVxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:53:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:50699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab1LWVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/15] perf script: look up thread using tid instead of pid
Date: Fri, 23 Dec 2011 19:53:07 -0200
Message-Id: <1324677198-5191-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This allows the thread name to be dispalyed when dumping
events:
           myapp 25118 [000] 450385.538815: context-switches ...
    myapp:worker 25119 [000] 450385.538894: context-switches ...

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1324578603-12762-4-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ea71c5e..d71b745 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -443,7 +443,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
-- 
1.7.8.rc0.35.gee6df

