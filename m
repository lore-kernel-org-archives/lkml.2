Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2IHLp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:45:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2IHLpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:45:54 -0400
Date: Sat, 8 Sep 2012 04:45:32 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-27683dc5cc9286ace82b6c900ab794428ed5e487@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347065004-15306-8-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-8-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: include missing pthread.h header
Git-Commit-ID: 27683dc5cc9286ace82b6c900ab794428ed5e487
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:45:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27683dc5cc9286ace82b6c900ab794428ed5e487
Gitweb:     http://git.kernel.org/tip/27683dc5cc9286ace82b6c900ab794428ed5e487
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Sat, 8 Sep 2012 03:43:19 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 22:08:09 -0300

perf tools: include missing pthread.h header

pthread variables are used in some files without explicitely including
pthread.h. This leads to compile errors on Android. e.g.: in annotate.h,
error: unknown type name 'pthread_mutex_t'

Including pthread.h explicitely in files that use it to have all definitions
included.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-8-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c          |    1 +
 tools/perf/util/annotate.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index e7840e5..fb8578c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,6 +14,7 @@
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include "util/debugfs.h"
+#include <pthread.h>
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a6d6bc5..62a6e7a 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -7,6 +7,7 @@
 #include "symbol.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <pthread.h>
 
 struct ins;
 
