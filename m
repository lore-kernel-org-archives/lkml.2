Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab2EUJqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:46:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2EUJqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:46:53 -0400
Date: Mon, 21 May 2012 02:46:33 -0700
From: tip-bot for Richard Weinberger <richard@nod.at>
Message-ID: <tip-895b67fd5830ce18a6f1375a7c062fcf84b4b874@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, richard@nod.at, tglx@linutronix.de
In-Reply-To: <1320654202-4433-1-git-send-email-richard@nod.at>
References: <1320654202-4433-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Remove kernel_lock annotations
Git-Commit-ID: 895b67fd5830ce18a6f1375a7c062fcf84b4b874
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:46:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  895b67fd5830ce18a6f1375a7c062fcf84b4b874
Gitweb:     http://git.kernel.org/tip/895b67fd5830ce18a6f1375a7c062fcf84b4b874
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Mon, 7 Nov 2011 09:23:22 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 19 May 2012 08:28:51 -0400

tracing: Remove kernel_lock annotations

The BKL is gone, these annotations are useless.

Link: http://lkml.kernel.org/r/1320654202-4433-1-git-send-email-richard@nod.at

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a44d4c6..b9a507c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -763,8 +763,6 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
  * Register a new plugin tracer.
  */
 int register_tracer(struct tracer *type)
-__releases(kernel_lock)
-__acquires(kernel_lock)
 {
 	struct tracer *t;
 	int ret = 0;
