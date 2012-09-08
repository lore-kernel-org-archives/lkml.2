Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab2IHLo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:44:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2IHLoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:44:54 -0400
Date: Sat, 8 Sep 2012 04:44:36 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-57ec0a942d6855cd7a5711fcf4adb57c51259659@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347065004-15306-7-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-7-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: fix missing winsize definition
Git-Commit-ID: 57ec0a942d6855cd7a5711fcf4adb57c51259659
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:44:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57ec0a942d6855cd7a5711fcf4adb57c51259659
Gitweb:     http://git.kernel.org/tip/57ec0a942d6855cd7a5711fcf4adb57c51259659
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Sat, 8 Sep 2012 03:43:18 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 22:07:32 -0300

perf tools: fix missing winsize definition

In Android, struct winsize is not defined in the headers already
included in help.c. This leads to a compile error.

Including termios.h fixes the compilation error since it defines struct winsize.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-7-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/help.c |    1 +
 tools/perf/util/top.h  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..4fa764d 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -3,6 +3,7 @@
 #include "exec_cmd.h"
 #include "levenshtein.h"
 #include "help.h"
+#include <termios.h>
 
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 33347ca..86ff1b1 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -5,6 +5,7 @@
 #include "types.h"
 #include <stddef.h>
 #include <stdbool.h>
+#include <termios.h>
 
 struct perf_evlist;
 struct perf_evsel;
