Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031Ab0KQRI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:08:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:45614 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934954Ab0KQRI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:08:26 -0500
Date: Wed, 17 Nov 2010 18:08:22 +0100
From: Marcus Meissner <meissner@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/time: Make /proc/timer_list mode 0400
Message-ID: <20101117170822.GW20727@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

/proc/timer_list contains kernel addresses, like e.g.:
 #0: <c000000001404158>, tick_sched_timer, S:01, .tick_nohz_restart_sched_tick, swapper/0
 ...

Avoid leaking them to user space to make writing kernel exploits a bit harder.

(I currently cannot think of a userland tool that uses this, this is
likely pretty much root-only.)

Ciao, Marcus

Signed-off-by: Marcus Meissner <meissner@suse.de>
---
 kernel/time/timer_list.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index ab8f5e3..5ae1ce3 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -293,7 +293,7 @@ static int __init init_timer_list_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
+	pe = proc_create("timer_list", 0400, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
-- 
1.7.1

