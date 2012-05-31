Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab2EaLth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:49:37 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58058 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2EaLtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:49:36 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Date: Thu, 31 May 2012 17:16:43 +0530
Message-Id: <20120531114643.23691.38666.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 2/3] perf/uprobes: Remove unnecessary check before strlist__delete
x-cbid: 12053101-0260-0000-0000-000001450B4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Since strlist__delete() itself checks, the additional check
before calling strlist__delete() is redundant.

No Functional change.

Suggested-by: Arnaldo Carvalho de Melo <acme@infradead.org>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 tools/perf/util/probe-event.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 59dccc9..0dda25d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2164,16 +2164,12 @@ int del_perf_probe_events(struct strlist *dellist)
 
 error:
 	if (kfd >= 0) {
-		if (namelist)
-			strlist__delete(namelist);
-
+		strlist__delete(namelist);
 		close(kfd);
 	}
 
 	if (ufd >= 0) {
-		if (unamelist)
-			strlist__delete(unamelist);
-
+		strlist__delete(unamelist);
 		close(ufd);
 	}
 


