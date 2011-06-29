Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1F2Gz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:55:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:22977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab1F2Gzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:55:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,442,1304319600"; 
   d="scan'208";a="24134904"
Subject: Re: power increase issue on light load
From: "Alex,Shi" <alex.shi@intel.com>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
In-Reply-To: <1309317764.14604.92.camel@debian>
References: <1308797024.23204.95.camel@debian>
	 <1308819748.1022.69.camel@twins> <1308876099.23204.124.camel@debian>
	 <1309219329.14604.11.camel@debian> <1309273180.6701.213.camel@twins>
	 <BANLkTi=KvKZtjFuDNxfKKAxysWUw4CiJecG8wnckYPvv9BzNrA@mail.gmail.com>
	 <CAOM-RdPBc2kcWDtUvTDe9PqQMq=u5qcEprDbC9guVi+wX+9bRg@mail.gmail.com>
	 <1309317764.14604.92.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 14:55:46 +0800
Message-ID: <1309330546.14604.97.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 11:22 +0800, Alex,Shi wrote:
> > 
> > Looking at the schedstat data Alex posted:
> > - Distribution of load balances across cores looks about the same.
> > - Load balancer does more idle balances on 3.0-rc4 as compared to
> > 2.6.39 on SMT and NUMA domains. Busy and newidle balances are a mixed
> > bag.
> > - I see far fewer affine wakeups on 3.0-rc4 as compared to 2.6.39.
> > About half as many affine wakeups on SMT and about a quarter as many
> > on NUMA.
> > 
> > I'm investigating the impact of the load resolution patchset on
> > effective load and wake affine calculations. This seems to be the most
> > obvious difference from the schedstat data.
> > 
> > Alex -- I have a couple of questions about your test setup and results.
> > - What is the impact on throughput of these benchmarks?
> 
> both on bltk-office and light load specpower, 10%/20%/30% load, the
> throughput almost have no change on my NHM-EP server and t410 laptop.
> > - Would it be possible to get a "perf sched" trace on these two kernels?

I tried the 'perf sched record' and then 'perf sched trace' as usage
show. but in fact, the 'perf sched' doesn't support 'trace' command now.
since the 'perf sched record' is using 'perf record -e sched:xxx' to do
record. I used 'perf record' directly. The follow info collected in 300'
on my NHM-EP for benchmark bltk-office. 

[alexs@lkp-ne01 ~]$ grep -e Events.*sched
linux-2.6/perf-report-3.0.0-rc5  
# Events: 11K sched:sched_wakeup
# Events: 1K sched:sched_wakeup_new
# Events: 24K sched:sched_switch
# Events: 3K sched:sched_migrate_task
# Events: 851  sched:sched_process_free
# Events: 1K sched:sched_process_exit
# Events: 1K sched:sched_process_wait
# Events: 1K sched:sched_process_fork
# Events: 12K sched:sched_stat_wait
# Events: 9K sched:sched_stat_sleep
# Events: 452  sched:sched_stat_iowait
# Events: 16K sched:sched_stat_runtime
[alexs@lkp-ne01 ~]$ 
[alexs@lkp-ne01 ~]$ 
[alexs@lkp-ne01 ~]$ grep -e
Events.*sched /mnt/linux-2.6.39/perf-report-2.6.39 
# Events: 5K sched:sched_wakeup
# Events: 615  sched:sched_wakeup_new
# Events: 11K sched:sched_switch
# Events: 2K sched:sched_migrate_task
# Events: 541  sched:sched_process_free
# Events: 692  sched:sched_process_exit
# Events: 1K sched:sched_process_wait
# Events: 615  sched:sched_process_fork
# Events: 6K sched:sched_stat_wait
# Events: 4K sched:sched_stat_sleep
# Events: 178  sched:sched_stat_iowait
# Events: 9K sched:sched_stat_runtime


