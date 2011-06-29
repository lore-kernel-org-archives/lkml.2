Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1F2DXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 23:23:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:34590 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1F2DWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 23:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,441,1304319600"; 
   d="scan'208";a="21325863"
Subject: Re: power increase issue on light load
From: "Alex,Shi" <alex.shi@intel.com>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
In-Reply-To: <CAOM-RdPBc2kcWDtUvTDe9PqQMq=u5qcEprDbC9guVi+wX+9bRg@mail.gmail.com>
References: <1308797024.23204.95.camel@debian>
	 <1308819748.1022.69.camel@twins> <1308876099.23204.124.camel@debian>
	 <1309219329.14604.11.camel@debian> <1309273180.6701.213.camel@twins>
	 <BANLkTi=KvKZtjFuDNxfKKAxysWUw4CiJecG8wnckYPvv9BzNrA@mail.gmail.com>
	 <CAOM-RdPBc2kcWDtUvTDe9PqQMq=u5qcEprDbC9guVi+wX+9bRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 11:22:44 +0800
Message-ID: <1309317764.14604.92.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Looking at the schedstat data Alex posted:
> - Distribution of load balances across cores looks about the same.
> - Load balancer does more idle balances on 3.0-rc4 as compared to
> 2.6.39 on SMT and NUMA domains. Busy and newidle balances are a mixed
> bag.
> - I see far fewer affine wakeups on 3.0-rc4 as compared to 2.6.39.
> About half as many affine wakeups on SMT and about a quarter as many
> on NUMA.
> 
> I'm investigating the impact of the load resolution patchset on
> effective load and wake affine calculations. This seems to be the most
> obvious difference from the schedstat data.
> 
> Alex -- I have a couple of questions about your test setup and results.
> - What is the impact on throughput of these benchmarks?

both on bltk-office and light load specpower, 10%/20%/30% load, the
throughput almost have no change on my NHM-EP server and t410 laptop.
> - Would it be possible to get a "perf sched" trace on these two kernels?

I will run the testing again and give you data later. but I didn't find
more useful data in 'perf record -e sched*'. 
> - I'm assuming the three sched domains are SMT, MC and NUMA. Is that
> right? Do you have any powersavings balance or special sched domain
> flags enabled?

Yes, and the sched_mc_power_savings and sched_smt_power_savings were
both set. the NHM-EP domain like below: 

CPU15 attaching sched-domain:
 domain 0: span 7,15 level SIBLING
  groups: 15 (cpu_power = 589) 7 (cpu_power = 589)
  domain 1: span 1,3,5,7,9,11,13,15 level MC
   groups: 7,15 (cpu_power = 1178) 1,9 (cpu_power = 1178) 3,11 (cpu_power = 1178) 5,13 (cpu_power = 1178)
   domain 2: span 0-15 level NODE
    groups: 1,3,5,7,9,11,13,15 (cpu_power = 4712) 0,2,4,6,8,10,12,14 (cpu_power = 4712)

> - Are you using group scheduling? If so, what does your setup look like?

I enabled the FAIR group default. But I have tried to disable it. the
problem is same. so, it isn't related to group. 
> 
> -Thanks,
> Nikhil


