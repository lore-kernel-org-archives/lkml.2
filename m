Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195Ab2IGGFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:05:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135Ab2IGGFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:05:45 -0400
Date: Thu, 6 Sep 2012 23:05:29 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-12046099160e65cddb639f8b3dda2bd0701c09d6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346255732-93246-1-git-send-email-dsahern@gmail.com>
References: <1346255732-93246-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  remove unneeded include of network header files
Git-Commit-ID: 12046099160e65cddb639f8b3dda2bd0701c09d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:05:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12046099160e65cddb639f8b3dda2bd0701c09d6
Gitweb:     http://git.kernel.org/tip/12046099160e65cddb639f8b3dda2bd0701c09d6
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 29 Aug 2012 09:55:32 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:45:12 -0300

perf tools: remove unneeded include of network header files

perf does not have networking related functionality, and the inclusion
of these headers is one of the causes of compile failures for Android:

  https://lkml.org/lkml/2012/8/23/316
  https://lkml.org/lkml/2012/8/28/293

So, remove them.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346255732-93246-1-git-send-email-dsahern@gmail.com
[ committer note: fix trace-event-perl.c compile failure by reordering includes ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    8 ++++----
 tools/perf/util/util.h                             |    5 -----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index d280010..94e6736 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -25,16 +25,16 @@
 #include <ctype.h>
 #include <errno.h>
 
-#include "../../perf.h"
 #include "../util.h"
+#include <EXTERN.h>
+#include <perl.h>
+
+#include "../../perf.h"
 #include "../thread.h"
 #include "../event.h"
 #include "../trace-event.h"
 #include "../evsel.h"
 
-#include <EXTERN.h>
-#include <perl.h>
-
 void boot_Perf__Trace__Context(pTHX_ CV *cv);
 void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 00a93a9..67a3713 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -69,11 +69,6 @@
 #include <sys/poll.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
-#include <sys/select.h>
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-#include <arpa/inet.h>
-#include <netdb.h>
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 #include "types.h"
