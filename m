Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0KZVsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:48:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:53117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab0KZVrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:47:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/5] perf events: Default to using event__process_lost
Date: Fri, 26 Nov 2010 19:47:18 -0200
Message-Id: <1290808041-16535-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290808041-16535-1-git-send-email-acme@infradead.org>
References: <1290808041-16535-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Tool developers have to fill in a 'perf_event_ops' method table to
specify how to handle each event, so far the ones that were not
explicitely especified would get a stub that would just discard the
event.

Change that so that tool developers can get the lost event details and
the total number of such events at the end of 'perf report -D' output.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fa9d652..3d56047 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -262,7 +262,7 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->exit == NULL)
 		handler->exit = process_event_stub;
 	if (handler->lost == NULL)
-		handler->lost = process_event_stub;
+		handler->lost = event__process_lost;
 	if (handler->read == NULL)
 		handler->read = process_event_stub;
 	if (handler->throttle == NULL)
-- 
1.6.2.5

