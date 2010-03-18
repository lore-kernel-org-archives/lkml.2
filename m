Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0CRP4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:56:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0CRP4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:56:18 -0400
Date: Thu, 18 Mar 2010 16:56:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] x86,perf: add cache events in p4 PMU
Message-ID: <20100318155610.GA28061@elte.hu>
References: <1268908392.13901.128.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268908392.13901.128.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> Add cache events in p4 PMU.
> 
> Move the HT bit setting code from p4_pmu_event_map to p4_hw_config.
> So the cache events can get HT bit set correctly.
> 
> Tested on my P4 desktop, below 6 cache events work.
> L1-dcache-load-misses
> LLC-load-misses
> dTLB-load-misses
> dTLB-store-misses
> iTLB-loads
> iTLB-load-misses
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h     |    2 +
>  arch/x86/include/asm/perf_event_p4.h |   10 ++
>  arch/x86/kernel/cpu/perf_event_p4.c  |  153 ++++++++++++++++++++++++++++++++--
>  3 files changed, 159 insertions(+), 6 deletions(-)

i tried it on a Pentium-D box, and it works pretty well:

rhea:/home/mingo/tip> perf stat -a sleep 1

 Performance counter stats for 'sleep 1':

    2003.237268  task-clock-msecs         #      2.000 CPUs 
             11  context-switches         #      0.000 M/sec
              2  CPU-migrations           #      0.000 M/sec
            174  page-faults              #      0.000 M/sec
          47361  cycles                   #      0.024 M/sec  (scaled from 52.83%)
            430  instructions             #      0.009 IPC    (scaled from 74.58%)
          23873  branches                 #      0.012 M/sec  (scaled from 96.70%)
            193  branch-misses            #      0.808 %      (scaled from 49.64%)
            867  cache-references         #      0.000 M/sec  (scaled from 49.69%)
            504  cache-misses             #      0.000 M/sec  (scaled from 49.58%)

    1.001411586  seconds time elapsed

So i've applied your patches. Cyrill, what do you think?

	Ingo
