Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2KIVpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:45:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:38574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2KIVn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 18/21] tools lib traceevent: Avoid comparisions between signed/unsigned
Date: Fri,  9 Nov 2012 18:43:07 -0300
Message-Id: <1352497390-17716-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.7.9.2.358.g22243

