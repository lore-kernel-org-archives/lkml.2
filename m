Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2AXXKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:10:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59175 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2AXXIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/9] perf probe: Usability fixes
Date: Tue, 24 Jan 2012 21:08:00 -0200
Message-Id: <1327446481-5505-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Ingo pointed out few perf probe usability related errors during his
review of uprobes.

Since these issues are independent of uprobes, fixing them in a separate
patch.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20120120121354.GL15447@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29cb654..b9bbdd2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1729,7 +1729,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	printf("Add new event%s\n", (ntevs > 1) ? "s:" : ":");
+	printf("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
 	for (i = 0; i < ntevs; i++) {
 		tev = &tevs[i];
 		if (pev->event)
@@ -1784,7 +1784,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 
 	if (ret >= 0) {
 		/* Show how to use the event. */
-		printf("\nYou can now use it on all perf tools, such as:\n\n");
+		printf("\nYou can now use it in all perf tools, such as:\n\n");
 		printf("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
 			 tev->event);
 	}
@@ -1959,7 +1959,7 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
 		goto error;
 	}
 
-	printf("Remove event: %s\n", ent->s);
+	printf("Removed event: %s\n", ent->s);
 	return 0;
 error:
 	pr_warning("Failed to delete event: %s\n", strerror(-ret));
-- 
1.7.9.rc2.1.g69204

