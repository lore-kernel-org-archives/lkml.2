Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2FFHJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:09:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2FFHJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:09:08 -0400
Date: Wed, 6 Jun 2012 00:08:45 -0700
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-a23c4dc422cff7bd30f40f5dc7c9ac4a6339005a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        ananth@in.ibm.com, anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, acme@infradead.org, srikar@linux.vnet.ibm.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
        ananth@in.ibm.com, anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        acme@infradead.org, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120531114643.23691.38666.sendpatchset@srdronam.in.ibm.com>
References: <20120531114643.23691.38666.sendpatchset@srdronam.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf uprobes:
  Remove unnecessary check before strlist__delete
Git-Commit-ID: a23c4dc422cff7bd30f40f5dc7c9ac4a6339005a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:08:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a23c4dc422cff7bd30f40f5dc7c9ac4a6339005a
Gitweb:     http://git.kernel.org/tip/a23c4dc422cff7bd30f40f5dc7c9ac4a6339005a
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Thu, 31 May 2012 17:16:43 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 12:08:49 -0300

perf uprobes: Remove unnecessary check before strlist__delete

Since strlist__delete() itself checks, the additional check before
calling strlist__delete() is redundant.

No Functional change.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20120531114643.23691.38666.sendpatchset@srdronam.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
 
