Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab1LFG1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:27:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab1LFG07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:26:59 -0500
Date: Mon, 5 Dec 2011 22:26:47 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-c7c6ec8becaf742b223c7b491f4893014be23a07@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rabin@rab.in, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, srostedt@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20111102150255.GA6973@debian>
References: <20111102150255.GA6973@debian>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Remove force undef config value left for testing
Git-Commit-ID: c7c6ec8becaf742b223c7b491f4893014be23a07
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 22:26:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7c6ec8becaf742b223c7b491f4893014be23a07
Gitweb:     http://git.kernel.org/tip/c7c6ec8becaf742b223c7b491f4893014be23a07
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 4 Nov 2011 10:45:23 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 5 Dec 2011 13:28:45 -0500

ftrace: Remove force undef config value left for testing

A forced undef of a config value was used for testing and was
accidently left in during the final commit. This causes x86 to
run slower than needed while running function tracing as well
as causes the function graph selftest to fail when DYNMAIC_FTRACE
is not set. This is because the code in MCOUNT expects the ftrace
code to be processed with the config value set that happened to
be forced not set.

The forced config option was left in by:
    commit 6331c28c962561aee59e5a493b7556a4bb585957
    ftrace: Fix dynamic selftest failure on some archs

Link: http://lkml.kernel.org/r/20111102150255.GA6973@debian

Cc: stable@vger.kernel.org
Reported-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 900b409..1276b3c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -152,7 +152,6 @@ void clear_ftrace_function(void)
 	ftrace_pid_function = ftrace_stub;
 }
 
-#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their
