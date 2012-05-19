Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab2ESKWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:22:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab2ESKWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:22:13 -0400
Date: Sat, 19 May 2012 03:20:53 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-0a3d7ce7e6caa8c39cb5184bd9047a01a40abc2a@git.kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        namhyung.kim@lge.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        namhyung.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1335143517-2285-1-git-send-email-namhyung.kim@lge.com>
References: <1335143517-2285-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Check return value of tracing_dentry_percpu()
Git-Commit-ID: 0a3d7ce7e6caa8c39cb5184bd9047a01a40abc2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 19 May 2012 03:21:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a3d7ce7e6caa8c39cb5184bd9047a01a40abc2a
Gitweb:     http://git.kernel.org/tip/0a3d7ce7e6caa8c39cb5184bd9047a01a40abc2a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 23 Apr 2012 10:11:57 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 16 May 2012 19:50:37 -0400

tracing: Check return value of tracing_dentry_percpu()

If tracing_dentry_percpu() failed, tracing_init_debugfs_percpu()
will try to create each cpu directories on debugfs' root directory
as d_percpu is NULL.

Link: http://lkml.kernel.org/r/1335143517-2285-1-git-send-email-namhyung.kim@lge.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dfbd86c..0ed4df0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4474,6 +4474,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
 
+	if (!d_percpu)
+		return;
+
 	snprintf(cpu_dir, 30, "cpu%ld", cpu);
 	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
