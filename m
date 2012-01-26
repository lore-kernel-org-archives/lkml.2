Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2AZNgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:36:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2AZNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:36:01 -0500
Date: Thu, 26 Jan 2012 05:35:36 -0800
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-a844d1ef09872a8b8c66d431edd1b8a943e51c7a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120120121354.GL15447@linux.vnet.ibm.com>
References: <20120120121354.GL15447@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Usability fixes
Git-Commit-ID: a844d1ef09872a8b8c66d431edd1b8a943e51c7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:35:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a844d1ef09872a8b8c66d431edd1b8a943e51c7a
Gitweb:     http://git.kernel.org/tip/a844d1ef09872a8b8c66d431edd1b8a943e51c7a
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Fri, 20 Jan 2012 17:43:54 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 24 Jan 2012 20:31:02 -0200

perf probe: Usability fixes

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
