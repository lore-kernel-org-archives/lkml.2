Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2KNHqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:46:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2KNHqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:46:32 -0500
Date: Tue, 13 Nov 2012 23:46:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-stmix8hy4nu5ervpynn8yj2z@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Avoid comparisions between signed/unsigned
Git-Commit-ID: 8a38cce4c900307e947eda774f844caf5b9a7083
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:46:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a38cce4c900307e947eda774f844caf5b9a7083
Gitweb:     http://git.kernel.org/tip/8a38cce4c900307e947eda774f844caf5b9a7083
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 9 Nov 2012 15:32:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 17:34:58 -0300

tools lib traceevent: Avoid comparisions between signed/unsigned

Fixing this warning-as-error on f14 32-bit:

  tools/lib/traceevent/event-parse.c:5564:17: error: comparison between signed and unsigned integer expressions
  tools/lib/traceevent/event-parse.c:5586:17: error: comparison between signed and unsigned integer expressions

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-stmix8hy4nu5ervpynn8yj2z@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0dcc18c..6b647c1 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5561,7 +5561,7 @@ void pevent_free(struct pevent *pevent)
 	}
 
 	if (pevent->func_map) {
-		for (i = 0; i < pevent->func_count; i++) {
+		for (i = 0; i < (int)pevent->func_count; i++) {
 			free(pevent->func_map[i].func);
 			free(pevent->func_map[i].mod);
 		}
@@ -5583,7 +5583,7 @@ void pevent_free(struct pevent *pevent)
 	}
 
 	if (pevent->printk_map) {
-		for (i = 0; i < pevent->printk_count; i++)
+		for (i = 0; i < (int)pevent->printk_count; i++)
 			free(pevent->printk_map[i].printk);
 		free(pevent->printk_map);
 	}
