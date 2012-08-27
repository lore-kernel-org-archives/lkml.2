Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2H0RC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:02:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab2H0RC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:02:57 -0400
Date: Mon, 27 Aug 2012 10:02:37 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f63fe79fa0b1362e8ea1c1e4996cf70d14917b02@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1345707420-21767-1-git-send-email-namhyung@kernel.org>
References: <1345707420-21767-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Fix off-by-one bug in pevent_strerror()
Git-Commit-ID: f63fe79fa0b1362e8ea1c1e4996cf70d14917b02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:02:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f63fe79fa0b1362e8ea1c1e4996cf70d14917b02
Gitweb:     http://git.kernel.org/tip/f63fe79fa0b1362e8ea1c1e4996cf70d14917b02
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Aug 2012 16:37:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 23 Aug 2012 11:29:20 -0300

tools lib traceevent: Fix off-by-one bug in pevent_strerror()

As pevent_errno is defined using PEVENT_ERRORS which uses _PE macro
magic, the first errno is bigger than __PEVENT_ERRNO_START by 1. So we
need to subtract the 1 also when calculating the index of the error
strings.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1345707420-21767-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f978c59..b5b4d80 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4822,7 +4822,7 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
 	    errnum >= __PEVENT_ERRNO__END)
 		return -1;
 
-	idx = errnum - __PEVENT_ERRNO__START;
+	idx = errnum - __PEVENT_ERRNO__START - 1;
 	msg = pevent_error_str[idx];
 
 	switch (errnum) {
