Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab1C3VHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:58294 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458Ab1C3VH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277692"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mingo@elte.hu, venki@google.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [106/275] sched: Export account_system_vtime()
Message-Id: <20110330210545.4208A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:03:00.369290720 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:54:58.088516087 -0700
@@ -1901,6 +1901,7 @@
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(account_system_vtime);
 
 static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
 {
