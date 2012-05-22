Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2EVJGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:06:03 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47070 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2EVJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:06:00 -0400
X-AuditID: 9c93016f-b7c3cae000001954-00-4fbb56f4abf9
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] perf tools: Always try to build libtraceevent
Date: Tue, 22 May 2012 18:03:54 +0900
Message-Id: <1337677434-4881-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
References: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although perf depends on the libtraceevent, it cannot know
when it needs to be rebuilt. So just try to rebuild it
always in order to make sure we use the latest version.

While at it, silence annoying directory change messages.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 022845e51937..a3d2324b9cd7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -821,7 +821,7 @@ $(LIB_FILE): $(LIB_OBJS)
 
 # libtraceevent.a
 $(LIBTRACEEVENT):
-	$(MAKE) -C $(TRACE_EVENT_DIR) $(COMMAND_O) libtraceevent.a
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) $(COMMAND_O) libtraceevent.a
 
 help:
 	@echo 'Perf make targets:'
@@ -969,6 +969,6 @@ clean:
 	$(RM) $(OUTPUT)util/*-{bison,flex}*
 	$(python-clean)
 
-.PHONY: all install clean strip
+.PHONY: all install clean strip $(LIBTRACEEVENT)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
-- 
1.7.10.1

