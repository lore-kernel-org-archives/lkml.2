Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381Ab2EWPYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:24:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab2EWPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:24:17 -0400
Date: Wed, 23 May 2012 08:23:59 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e33387fc2748ac78fd577dee2c914fc3ea0ba0cd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1337677434-4881-2-git-send-email-namhyung.kim@lge.com>
References: <1337677434-4881-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Always try to build libtraceevent
Git-Commit-ID: e33387fc2748ac78fd577dee2c914fc3ea0ba0cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:24:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e33387fc2748ac78fd577dee2c914fc3ea0ba0cd
Gitweb:     http://git.kernel.org/tip/e33387fc2748ac78fd577dee2c914fc3ea0ba0cd
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 May 2012 18:03:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:35:29 -0300

perf tools: Always try to build libtraceevent

Although perf depends on the libtraceevent, it cannot know when it needs
to be rebuilt. So just try to rebuild it always in order to make sure we
use the latest version.

While at it, silence annoying directory change messages.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1337677434-4881-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ef75a55..1d3d513 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -828,7 +828,7 @@ $(LIB_FILE): $(LIB_OBJS)
 
 # libtraceevent.a
 $(LIBTRACEEVENT):
-	$(MAKE) -C $(TRACE_EVENT_DIR) $(COMMAND_O) libtraceevent.a
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) $(COMMAND_O) libtraceevent.a
 
 help:
 	@echo 'Perf make targets:'
@@ -976,6 +976,6 @@ clean:
 	$(RM) $(OUTPUT)util/*-{bison,flex}*
 	$(python-clean)
 
-.PHONY: all install clean strip
+.PHONY: all install clean strip $(LIBTRACEEVENT)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
