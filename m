Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1BPByV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:54:21 -0500
Received: from kroah.org ([198.145.64.141]:49388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575Ab1BPBwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:05 2011
Message-Id: <20110216014704.947751476@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [107/115] sched: Export account_system_vtime()
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: b7dadc38797584f6203386da1947ed5edf516646 upstream

KVM uses it for example:

 ERROR: "account_system_vtime" [arch/x86/kvm/kvm.ko] undefined!

Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-3-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1889,6 +1889,7 @@ void account_system_vtime(struct task_st
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(account_system_vtime);
 
 static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
 {


