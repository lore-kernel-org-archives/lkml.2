Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0F1KKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:10:30 -0400
Received: from www.tglx.de ([62.245.132.106]:43237 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0F1KK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:10:29 -0400
Date: Mon, 28 Jun 2010 12:10:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.35
Message-ID: <alpine.LFD.2.00.1006281209310.2530@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Peter Zijlstra (1):
      nohz: Fix nohz ratelimit


 kernel/time/tick-sched.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1d7b9bc..783fbad 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -315,9 +315,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 		goto end;
 	}
 
-	if (nohz_ratelimit(cpu))
-		goto end;
-
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
@@ -328,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
