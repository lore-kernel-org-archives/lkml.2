Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1JDKnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:43:08 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60790 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1JDKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:43:05 -0400
X-AuditID: b753bd60-a16a6ba000005c89-8b-4e8ae337a093
X-AuditID: b753bd60-a16a6ba000005c89-8b-4e8ae337a093
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 4/4] [BUGFIX] perf probe: Fix to show correct error string
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 04 Oct 2011 19:45:04 +0900
Message-ID: <20111004104504.14591.41266.stgit@fedora15>
In-Reply-To: <20111004104438.14591.6553.stgit@fedora15>
References: <20111004104438.14591.6553.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix perf probe to show correct error string when it
fails to delete an event. The write(2) returns -1
if failed, and errno stores real error number.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 tools/perf/util/probe-event.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1c7bfa5..eb25900 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1956,8 +1956,10 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
 
 	pr_debug("Writing event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
-	if (ret < 0)
+	if (ret < 0) {
+		ret = -errno;
 		goto error;
+	}
 
 	printf("Remove event: %s\n", ent->s);
 	return 0;

