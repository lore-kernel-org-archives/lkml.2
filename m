Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab2IFTbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:31:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759680Ab2IFTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:31:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Joel Uckelman <joel@lightboxtechnologies.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/8] perf tools: Fix cache event name generation
Date: Thu,  6 Sep 2012 16:31:21 -0300
Message-Id: <1346959881-22427-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346959881-22427-1-git-send-email-acme@infradead.org>
References: <1346959881-22427-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

If the event name is specified with all 3 components, the last one
overwrites the previous one during the name composing within the
parse_events_add_cache function.

Fixing this by properly adjusting the string index.

Reported-by: Joel Uckelman <joel@lightboxtechnologies.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joel Uckelman <joel@lightboxtechnologies.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LPU-Reference: 20120905175133.GA18352@krava.brq.redhat.com
[ committer note: Remove the newline fix, done already in 42e1fb7 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 66d235e..a031ee1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -308,7 +308,7 @@ int parse_events_add_cache(struct list_head **list, int *idx,
 	for (i = 0; (i < 2) && (op_result[i]); i++) {
 		char *str = op_result[i];
 
-		snprintf(name + n, MAX_NAME_LEN - n, "-%s", str);
+		n += snprintf(name + n, MAX_NAME_LEN - n, "-%s", str);
 
 		if (cache_op == -1) {
 			cache_op = parse_aliases(str, perf_evsel__hw_cache_op,
-- 
1.7.9.2.358.g22243

