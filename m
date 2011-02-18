Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab1BRKjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:39:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:53348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab1BRKjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:39:14 -0500
Date: Fri, 18 Feb 2011 10:38:24 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Tell the user when a perf.data file has no samples
Message-ID: <tip-74cfc17dc1a69c37ce6c8a76c1ce84bcb796eb0e@git.kernel.org>
Git-Commit-ID: 74cfc17dc1a69c37ce6c8a76c1ce84bcb796eb0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:38:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74cfc17dc1a69c37ce6c8a76c1ce84bcb796eb0e
Gitweb:     http://git.kernel.org/tip/74cfc17dc1a69c37ce6c8a76c1ce84bcb796eb0e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Feb 2011 14:40:46 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Feb 2011 14:40:46 -0200

perf report: Tell the user when a perf.data file has no samples

[root@emilia ~]# perf report --stdio
The perf.data file has no samples!
[root@emilia ~]#

The TUI shows a popup warning message with the same message.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f9a99a1..dddcc7e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -350,6 +350,12 @@ static int __cmd_report(void)
 		perf_session__fprintf_dsos(session, stdout);
 
 	next = rb_first(&session->hists_tree);
+
+	if (next == NULL) {
+		ui__warning("The %s file has no samples!\n", input_name);
+		goto out_delete;
+	}
+
 	while (next) {
 		struct hists *hists;
 
