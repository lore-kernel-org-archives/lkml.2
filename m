Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab2EKNjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:39:41 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60972 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751693Ab2EKNjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:39:40 -0400
Date: Fri, 11 May 2012 08:39:38 -0500
From: Robin Holt <holt@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Commit cb83b62 fails to boot with a divide by zero error.
Message-ID: <20120511133938.GG3751@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, there is a breakage in the x86/master branch.

While testing some of our configurations, we found they would not boot.
The following got things working:

--- linux.orig/kernel/sched/fair.c      2012-05-11 06:29:44.000000000 -0500
+++ linux/kernel/sched/fair.c   2012-05-11 06:31:52.217156410 -0500
@@ -3835,7 +3835,7 @@ static inline void update_sg_lb_stats(st
        }
 
        /* Adjust by relative CPU power of the group */
-       sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;
+       sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / max(group->sgp->power, 1);
 
        /*
         * Consider the group unbalanced when the imbalance is larger


We found that reverting the commit:
cb83b62 (x86/sched/core) sched/numa: Rewrite the CONFIG_NUMA sched domain support

also got things working.

Thanks,
Robin Holt
