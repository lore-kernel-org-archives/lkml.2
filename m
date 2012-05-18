Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab2ERLQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:16:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab2ERLQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:16:47 -0400
Date: Fri, 18 May 2012 04:16:32 -0700
From: tip-bot for Konstantin Khlebnikov <khlebnikov@openvz.org>
Message-ID: <tip-1c2927f18576d65631d8e0ddd19e1d023183222e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, khlebnikov@openvz.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, khlebnikov@openvz.org, tglx@linutronix.de
In-Reply-To: <20120510122004.4873.12726.stgit@zurg>
References: <20120510122004.4873.12726.stgit@zurg>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Taint kernel with TAINT_WARN after sleep-in-atomic bug
Git-Commit-ID: 1c2927f18576d65631d8e0ddd19e1d023183222e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 04:16:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c2927f18576d65631d8e0ddd19e1d023183222e
Gitweb:     http://git.kernel.org/tip/1c2927f18576d65631d8e0ddd19e1d023183222e
Author:     Konstantin Khlebnikov <khlebnikov@openvz.org>
AuthorDate: Thu, 10 May 2012 16:20:04 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 13:07:40 +0200

sched: Taint kernel with TAINT_WARN after sleep-in-atomic bug

Usually sleep-in-atomic bugs are followed by dozens other warnings.
This patch should help to figure out original source of problem.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120510122004.4873.12726.stgit@zurg
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24ca677..ab9745f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3138,6 +3138,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
+	add_taint(TAINT_WARN);
 }
 
 /*
