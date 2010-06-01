Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0FAHFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:05:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:57868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0FAHFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:05:31 -0400
Date: Tue, 1 Jun 2010 07:04:44 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, bp@alien8.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, bp@alien8.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100531211818.GA30175@liondog.tnic>
References: <20100531211818.GA30175@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf-record: Check correct pid when forking
Message-ID: <tip-2fb750e825b5347de0390315f4284f13709a9856@git.kernel.org>
Git-Commit-ID: 2fb750e825b5347de0390315f4284f13709a9856
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Jun 2010 07:04:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fb750e825b5347de0390315f4284f13709a9856
Gitweb:     http://git.kernel.org/tip/2fb750e825b5347de0390315f4284f13709a9856
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 31 May 2010 23:18:18 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 1 Jun 2010 00:57:14 +0200

perf-record: Check correct pid when forking

When forking the child to be traced, we should check the correct
return value from fork() and not a local variable which is otherwise
unused.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100531211818.GA30175@liondog.tnic>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-record.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9bc8905..dc3435e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -503,7 +503,6 @@ static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	struct stat st;
-	pid_t pid = 0;
 	int flags;
 	int err;
 	unsigned long waking = 0;
@@ -572,7 +571,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	if (forks) {
 		child_pid = fork();
-		if (pid < 0) {
+		if (child_pid < 0) {
 			perror("failed to fork");
 			exit(-1);
 		}
