Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab2IGGLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:11:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2IGGLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:11:21 -0400
Date: Thu, 6 Sep 2012 23:11:04 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-eea9b6842950924876a1a21ca197f189f8bb335a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1346892816-61779-1-git-send-email-dsahern@gmail.com>
References: <1346892816-61779-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Clean target should do clean for lib/
 traceevent too
Git-Commit-ID: eea9b6842950924876a1a21ca197f189f8bb335a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:11:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eea9b6842950924876a1a21ca197f189f8bb335a
Gitweb:     http://git.kernel.org/tip/eea9b6842950924876a1a21ca197f189f8bb335a
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 5 Sep 2012 18:53:36 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Sep 2012 10:47:29 -0300

perf tools: Clean target should do clean for lib/traceevent too

It's built as part of perf, so it should be cleaned too.

Tested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1346892816-61779-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 939cf6d..afd5075 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -917,6 +917,9 @@ $(LIB_FILE): $(LIB_OBJS)
 $(LIBTRACEEVENT):
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
 
+$(LIBTRACEEVENT)-clean:
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+
 help:
 	@echo 'Perf make targets:'
 	@echo '  doc		- make *all* documentation (see below)'
@@ -1056,7 +1059,7 @@ quick-install-html:
 
 ### Cleaning rules
 
-clean:
+clean: $(LIBTRACEEVENT)-clean
 	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
