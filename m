Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab2GFLRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:17:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab2GFLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:16:59 -0400
Date: Fri, 6 Jul 2012 04:16:24 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-3831a42deba59bf26618b0dd6fa1320a0a94ebd9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, bp@alien8.de,
        namhyung@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@infradead.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com, namhyung@gmail.com, bp@alien8.de,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@infradead.org, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1335157118-14658-7-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-7-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Pass string type argument to args
Git-Commit-ID: 3831a42deba59bf26618b0dd6fa1320a0a94ebd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:16:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3831a42deba59bf26618b0dd6fa1320a0a94ebd9
Gitweb:     http://git.kernel.org/tip/3831a42deba59bf26618b0dd6fa1320a0a94ebd9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 23 Apr 2012 13:58:33 +0900
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:31 +0900

tools lib traceevent: Pass string type argument to args

It seems PEVENT_FUNC_ARG_STRING missed passing the allocated string to
the args array.  Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1335157118-14658-7-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 05eb6b4..337ca02 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3489,6 +3489,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			if (!string->str)
 				die("malloc str");
 
+			args[i] = (unsigned long long)string->str;
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
