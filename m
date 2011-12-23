Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab1LWNTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:19:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab1LWNTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:19:01 -0500
Date: Fri, 23 Dec 2011 05:18:29 -0800
From: tip-bot for Dave Jones <davej@redhat.com>
Message-ID: <tip-664dfa65e84429d0b68694483e1de7365c7c56fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        davej@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
In-Reply-To: <20111222213929.GA4722@redhat.com>
References: <20111222213929.GA4722@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Disable scheduler warnings during oopses
Git-Commit-ID: 664dfa65e84429d0b68694483e1de7365c7c56fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 05:18:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  664dfa65e84429d0b68694483e1de7365c7c56fb
Gitweb:     http://git.kernel.org/tip/664dfa65e84429d0b68694483e1de7365c7c56fb
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Thu, 22 Dec 2011 16:39:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Dec 2011 11:20:50 +0100

sched: Disable scheduler warnings during oopses

The panic-on-framebuffer code seems to cause a schedule
to occur during an oops. This causes a bunch of extra
spew as can be seen in:

   https://bugzilla.redhat.com/attachment.cgi?id=549230

Don't do scheduler debug checks when we are oopsing already.

Signed-off-by: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/20111222213929.GA4722@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 081ece2..8ffe523 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3077,6 +3077,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	if (oops_in_progress)
+		return;
+
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 
