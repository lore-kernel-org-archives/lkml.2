Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2A3NVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:21:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2A3NVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:21:21 -0500
Date: Mon, 30 Jan 2012 05:20:51 -0800
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-d0caf292505d051b1026e85faf3a85e907566f31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, dan.carpenter@oracle.com,
        clemens@ladisch.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, fweisbec@gmail.com,
        tglx@linutronix.de, clemens@ladisch.de, mingo@elte.hu,
        dan.carpenter@oracle.com
In-Reply-To: <20120128105246.GA25092@elgon.mountain>
References: <20120128105246.GA25092@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/dumpstack:
  Remove unneeded check in dump_trace()
Git-Commit-ID: d0caf292505d051b1026e85faf3a85e907566f31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jan 2012 05:20:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0caf292505d051b1026e85faf3a85e907566f31
Gitweb:     http://git.kernel.org/tip/d0caf292505d051b1026e85faf3a85e907566f31
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Sat, 28 Jan 2012 13:52:46 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Jan 2012 13:09:06 +0100

x86/dumpstack: Remove unneeded check in dump_trace()

Smatch complains that we have some inconsistent NULL checking.

If "task" were NULL then it would lead to a NULL dereference
later. We can remove this test because earlier on in the
function we have:

 if (!task)
	task = current;

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Clemens Ladisch <clemens@ladisch.de>
Link: http://lkml.kernel.org/r/20120128105246.GA25092@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/dumpstack_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6d728d9..af7785f 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -129,7 +129,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!stack) {
 		if (regs)
 			stack = (unsigned long *)regs->sp;
-		else if (task && task != current)
+		else if (task != current)
 			stack = (unsigned long *)task->thread.sp;
 		else
 			stack = &dummy;
