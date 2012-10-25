Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789Ab2JYIH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:07:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934104Ab2JYIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:07:55 -0400
Date: Thu, 25 Oct 2012 01:07:29 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-q3ak0j8b81yxylykq5wp2uwi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Print the name of a syscall when failing to read its info
Git-Commit-ID: 814d7a4d2c33657489f7b45bc0b2dcaa0d88edc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 01:07:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  814d7a4d2c33657489f7b45bc0b2dcaa0d88edc0
Gitweb:     http://git.kernel.org/tip/814d7a4d2c33657489f7b45bc0b2dcaa0d88edc0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 24 Oct 2012 18:44:13 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 18:44:13 -0200

perf trace: Print the name of a syscall when failing to read its info

When failing to read the tracepoint event format, like currently with
sys_execve, that is not defined via SYSCALL_DEFINE macros and thus
doesn't have an entry in:

  $ ls -d /sys/kernel/debug/tracing/events/syscalls/sys_enter_*exec*
  /sys/kernel/debug/tracing/events/syscalls/sys_enter_kexec_load
  $

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
echo Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org
Link: http://lkml.kernel.org/n/tip-q3ak0j8b81yxylykq5wp2uwi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fb83cfe..ba05510 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -278,7 +278,10 @@ static struct syscall *trace__syscall_info(struct trace *trace,
 	return &trace->syscalls.table[id];
 
 out_cant_read:
-	printf("Problems reading syscall %d information\n", id);
+	printf("Problems reading syscall %d", id);
+	if (id <= trace->syscalls.max && trace->syscalls.table[id].name != NULL)
+		printf("(%s)", trace->syscalls.table[id].name);
+	puts(" information");
 	return NULL;
 }
 
