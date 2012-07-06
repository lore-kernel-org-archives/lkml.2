Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2GFK4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:56:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51448 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2GFK43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:56:29 -0400
Date: Fri, 6 Jul 2012 03:56:11 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-50d8f9e393c5a1a8864fda75e3a9f2b800497a61@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1339396133-9839-1-git-send-email-namhyung@kernel.org>
References: <1339396133-9839-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Replace malloc_or_die to plain malloc in alloc_event()
Git-Commit-ID: 50d8f9e393c5a1a8864fda75e3a9f2b800497a61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:56:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50d8f9e393c5a1a8864fda75e3a9f2b800497a61
Gitweb:     http://git.kernel.org/tip/50d8f9e393c5a1a8864fda75e3a9f2b800497a61
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 11 Jun 2012 15:28:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:13 -0300

tools lib traceevent: Replace malloc_or_die to plain malloc in alloc_event()

Because the only caller of the alloc_event() (pevent_parse_event) checks
return value properly, it can be changed to use plain malloc.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1339396133-9839-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b1abd39..83f0a8a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -616,7 +616,9 @@ static struct event_format *alloc_event(void)
 {
 	struct event_format *event;
 
-	event = malloc_or_die(sizeof(*event));
+	event = malloc(sizeof(*event));
+	if (!event)
+		return NULL;
 	memset(event, 0, sizeof(*event));
 
 	return event;
