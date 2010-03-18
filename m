Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0CRNtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:49:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39722 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0CRNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:48:58 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/3] Stop tracing on a schedule bug
Date: Thu, 18 Mar 2010 09:48:52 -0400
Message-Id: <1268920132-30512-3-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268920132-30512-1-git-send-email-chase.douglas@canonical.com>
References: <1268920132-30512-1-git-send-email-chase.douglas@canonical.com>
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
index 150b698..bfe4f05 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3589,6 +3589,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	tracing_off_event(TRACE_EVENT_BUG);
+
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 
-- 
1.6.3.3

