Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0CRRid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:38:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:55036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0CRRib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:38:31 -0400
Date: Thu, 18 Mar 2010 17:38:01 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
References: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Fix false positive build warning with older GCC's
Message-ID: <tip-55632770d7298835645489828af87f854c47749c@git.kernel.org>
Git-Commit-ID: 55632770d7298835645489828af87f854c47749c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Mar 2010 17:38:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55632770d7298835645489828af87f854c47749c
Gitweb:     http://git.kernel.org/tip/55632770d7298835645489828af87f854c47749c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 18 Mar 2010 16:51:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Mar 2010 17:03:24 +0100

perf events: Fix false positive build warning with older GCC's

gcc 4.2.1 produces:

 util/probe-event.c: In function 'add_perf_probe_events':
 util/probe-event.c:883: warning: 'tev' may be used uninitialized in this function
 make: *** [util/probe-event.o] Error 1

Newer GCCs get this right.

To work it around, initialize the variable to NULL so that older GCCs see
it as initialized too.

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f333269..c6603f3 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -880,7 +880,7 @@ static void __add_kprobe_trace_events(struct perf_probe_event *pev,
 				      int ntevs, bool allow_suffix)
 {
 	int i, fd;
-	struct kprobe_trace_event *tev;
+	struct kprobe_trace_event *tev = NULL;
 	char buf[64];
 	const char *event, *group;
 	struct strlist *namelist;
