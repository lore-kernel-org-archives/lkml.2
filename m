Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2AKEUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 23:20:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:62361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab2AKEUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 23:20:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110947564"
Date: Wed, 11 Jan 2012 12:37:44 -0500
From: Youquan Song <youquan.song@intel.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120111173744.GA27967@linux-youquan.bj.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com> <1326103578.2442.50.camel@twins> <20120110001445.GA20542@linux-youquan.bj.intel.com> <1326107156.2442.59.camel@twins> <20120110055856.GA23741@linux-youquan.bj.intel.com> <1326153163.2366.7.camel@sbsiddha-mobl2> <20120110165426.GA20681@linux-youquan.bj.intel.com> <20120110165129.GC17432@dirshya.in.ibm.com> <1326222073.6283.9.camel@sbsiddha-mobl2> <20120111035156.GB7988@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111035156.GB7988@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had tested sched_mc_powersavings=2 on dual socket quad core HT
> nehalem.  It worked as expected.  Let me check the
> sched_mc_powersavings=1 case.  I will not be surprised if it is
> broken.
> 
 
In my opinion. When CPU cores > 8, sched_mc will have issue of course.
What's more, when CPU cores increase it will be abviously if following
current CPU power capability calcaluation logic.

If CPU has 8 cores and if HT enabled, its power capability > 9 cores. 
Current logic, HT enable core power capability = 1178,  1178 * 8
/ 1024 > 9.2. So scheduler will try to schedule >8 threads to meet its
power capability before use other socket if sched_mc used.

So it will be better, like this: Of course, It is only sample code
and I do not try it yet.

For MC:
+       if (sched_mc_power_savings)
+               sgs->group_capacity = group->group_weight/2;

For SMT:
+       if (sched_smt_power_savings && !(sd->flags & SD_SHARE_CPUPOWER))
+               sgs->group_capacity = group->group_weight;


Thanks
-Youquan
