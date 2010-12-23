Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0LWKRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:17:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:13321 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0LWKRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:17:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="586596481"
Date: Thu, 23 Dec 2010 18:26:04 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: "Niemi, David" <dniemi@verisign.com>
Cc: Youquan Song <youquan.song@intel.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org, venki@google.com,
        davej@redhat.com, suresh.b.siddha@intel.com, kent.liu@intel.com,
        chaohong.guo@intel.com
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand
	governor power efficiency
Message-ID: <20101223232604.GA25890@linux-youquan.bj.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com> <BBBDBC5FD59D92459FAEF7D8EA3361C402A1A424@DUL1WNEXMB05.vcorp.ad.vrsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BBBDBC5FD59D92459FAEF7D8EA3361C402A1A424@DUL1WNEXMB05.vcorp.ad.vrsn.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 01:50:45AM -0500, Niemi, David wrote:
> The ondemand governor does tend to go all or nothing with respect to CPU
> frequency.  That is not entirely laziness, it has some logic to compute
> optimum frequency but doesn't generally use it.  There is some evidence
> intermediate frequencies are a waste of effort.
Thanks a lot! David. Merry Christmas!
That'true, intermediate frequencies are waste of
effort. Pn ~ P1 actually have not much different conside of power saving.
In the patchset, It will not add the intermediate frequencies except
that I add P1 evaluation before direct go to P0, because I know that P0 
(turbo mode) have much power consumption than P1 while P1 frequency often 
double of the Pn(lowest) frequency, when Pn 100% workload only
reach 50% of P1 workload capability, so if P1 can meet the current
workload requirement, it will save some power. 
I really test, the 6th patch: "Evaluate P1 before enter turbo
mode" has a little function to save power, but not much.    

> Please consider a couple of things:
> 1) Most Intel CPUs do most of their power savings through C-states, not
> by reducing clock frequency.  That may have something to do with why you
> see modest power savings between ondemand and performance.  Recent AMD
> CPUs, on the other hand, rely a lot more on reducing clock frequency to
> save power.  Down the road, we'll need to be doing both effectively.
> But even going to the very lowest clock frequency on a Nehalem EP will
> not save very much power -- and increased use of intermediate
> frequencies will help less.  That said, minimizing turbo boost usage
> will likely save quite a bit of power (at the expense of reduced
> performance).
If the system is truly busy, my patchset will increase turbo mode usage,
and decrease the dangle between P0 and Pn. If systme is truly idle, not
instant busy, it will decrease the turbo mode usage.

>
> It would definitely be nice to see results on a variety of modern CPUs
> for a major patch like this.
I have no such test environment. Who can help?
 
> 2) Please consider the case where per performance really does matter
> when heavy loads are present, but we'd like to save power when the
> system is lightly loaded.  This is different from the laptop case, where
> saving power under load is probably as important as the performance, and
> if you are truly idle you are turning things off altogether.  Your claim
> of matching the performance governor's performance is a great aspiration
> but it'll need to be demonstrated on a variety of CPUs and workloads,
> this is not usually easy to accomplish.
> 
In nature, my patchset only add sampling window for ondemand
governor,which will large the sampling rating 10ms to special sampling
window time frame. It will truly reflect the system workload busy or
idle and not instant phenomena, which will avoid instant busy cause
frequently change between turbo mode and lowest frequency.

patchset provide dynamic sampling window function, which will auto ajust
sampling window size according to current workload busy or idle. 
When system is idle the sampling window will be samller, which will
response quickly to instant requirement, when system is busy, the
sampling window will bigger, it will keep CPU work at high frequency
without ajust to frequency for instant workload idle.
when sampling window equal to sampling rate (10ms), the sampling window
will roll back and works the same as the orignial ondemand governor.

When workload is high( > 80%), the patched ondemand work very close to
performance because its sampling window is large, the average workload
during the sampling window will also almost be above 60%, so the large
frequency will be continously used. 

Maybe, you can really test it. when you have questions or comments, please
 contact with me.

Thanks
-Youquan
 




