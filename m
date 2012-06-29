Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2F2QQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:16:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2F2QQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:16:09 -0400
Date: Fri, 29 Jun 2012 09:15:45 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-35a468732289372aab506d7cf73f98f0379888ae@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1340268772-5737-1-git-send-email-namhyung@kernel.org>
References: <1340268772-5737-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Fix a build failure on cross compilation
Git-Commit-ID: 35a468732289372aab506d7cf73f98f0379888ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 29 Jun 2012 09:15:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35a468732289372aab506d7cf73f98f0379888ae
Gitweb:     http://git.kernel.org/tip/35a468732289372aab506d7cf73f98f0379888ae
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 21 Jun 2012 17:52:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Jun 2012 14:55:24 -0300

perf evsel: Fix a build failure on cross compilation

The commit c410431cefefd ("perf tools: Reconstruct event with modifiers
from perf_event_attr") added the line, but it's broken since it needs to
go up 3 directories to get to the kernel root directory, not 2.

However host gcc contains /usr/local/include in its search path, so that
it can find the perf_event.h in /usr/include. This why we didn't notice
the problem yet.  But when I tried to cross compile it appears like:

      CC util/evsel.o
  util/evsel.c:18:44: error: ../../include/linux/perf_event.h: No such file or directory
  make: *** [util/evsel.o] Error 1

Looking at the source, it isn't needed at all as evsel.h already
included the perf_event.h. So simply remove it would solve the problem.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340268772-5737-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 876f639..3d1f696 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,7 +15,6 @@
 #include "cpumap.h"
 #include "thread_map.h"
 #include "target.h"
-#include "../../include/linux/perf_event.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
