Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0DNQUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:20:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58338 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab0DNQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:20:24 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 3/3] Stop tracing on a schedule bug
Date: Wed, 14 Apr 2010 12:20:16 -0400
Message-Id: <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a tracing_off_event() call to stop tracing on schedule
bugs unless tracing_off=none was specified on the commandline.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..439f036 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3590,6 +3590,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	tracing_off_event(TRACE_EVENT_BUG);
+
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 
-- 
1.7.0

