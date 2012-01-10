Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2AIK5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:57:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:59989 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab2AIK5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:57:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110208614"
Date: Mon, 9 Jan 2012 19:14:45 -0500
From: Youquan Song <youquan.song@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120110001445.GA20542@linux-youquan.bj.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com> <1326103578.2442.50.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326103578.2442.50.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes it is.. also that knob should die! Like i've been saying for way too
> long. I'm >< close to committing a patch removing all the power_saving
> magic from the scheduler.
Sorry. I do not notice it.
But currently in many real tests, the knob prove to save power in semi-idle system.
They are useful in many user scenarios currently.

> That's the most convoluted way I've seen that stated in a while. What
> you're saying is that all threads (of a socket) should be used before
> spilling over to another socket.
Only touch half. 
Another half: in ideal, all threads in one core be used before spilling over to another
core.

> Hell no, that's completely the wrong thing to do. I think you want to
> frob at the group_capacity computation in update_sg_lb_stats.
> 

Yes. It also can do in the ways you said. 
I have following testing code before which is changed in update_sg_lb_stats, 
but there are more refresh code required for fix. 
Fine, I will base your suggestion to develop another patch soon.

Thanks
-Youquan

@@ -3923,6 +3923,10 @@ static inline void update_sg_lb_stats(struct
sched_domain *sd,
                                                SCHED_POWER_SCALE);
        if (!sgs->group_capacity)
                sgs->group_capacity = fix_small_capacity(sd, group);
+
+       if (sched_smt_power_savings)
+               sgs->group_capacity *= 2;
+
        sgs->group_weight = group->group_weight;

        if (sgs->group_capacity > sgs->sum_nr_running)

