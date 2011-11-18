Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab1KRXMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:12:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab1KRXMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:12:30 -0500
Date: Fri, 18 Nov 2011 15:12:05 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-8ee3c92b7f2751c392be2d8fc360a410480b8757@git.kernel.org>
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
Git-Commit-ID: 8ee3c92b7f2751c392be2d8fc360a410480b8757
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:12:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ee3c92b7f2751c392be2d8fc360a410480b8757
Gitweb:     http://git.kernel.org/tip/8ee3c92b7f2751c392be2d8fc360a410480b8757
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 4 Nov 2011 10:45:23 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Nov 2011 11:02:33 -0500

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
index 077d853..0fcc6ca 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -151,7 +151,6 @@ void clear_ftrace_function(void)
 	ftrace_pid_function = ftrace_stub;
 }
 
-#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their
