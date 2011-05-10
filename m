Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1EJH22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:28:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46788 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1EJH20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:28:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E903.9080002@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:28:03 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 14/15] sched: return unused runtime on voluntary sleep
References: <20110503092846.022272244@google.com> <20110503092905.694819271@google.com>
In-Reply-To: <20110503092905.694819271@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:29), Paul Turner wrote:
> When a local cfs_rq blocks we return the majority of its remaining quota to the
> global bandwidth pool for use by other runqueues.
> 
> We do this only when the quota is current and there is more than 
> min_cfs_rq_quota [1ms by default] of runtime remaining on the rq.
> 
> In the case where there are throttled runqueues and we have sufficient
> bandwidth to meter out a slice, a second timer is kicked off to handle this
> delivery, unthrottling where appropriate.
> 
> Using a 'worst case' antagonist which executes on each cpu
> for 1ms before moving onto the next on a fairly large machine:
> 
> no quota generations:
>  197.47 ms       /cgroup/a/cpuacct.usage
>  199.46 ms       /cgroup/a/cpuacct.usage
>  205.46 ms       /cgroup/a/cpuacct.usage
>  198.46 ms       /cgroup/a/cpuacct.usage
>  208.39 ms       /cgroup/a/cpuacct.usage
> Since we are allowed to use "stale" quota our usage is effectively bounded by
> the rate of input into the global pool and performance is relatively stable.
> 
> with quota generations [1s increments]:
>  119.58 ms       /cgroup/a/cpuacct.usage
>  119.65 ms       /cgroup/a/cpuacct.usage
>  119.64 ms       /cgroup/a/cpuacct.usage
>  119.63 ms       /cgroup/a/cpuacct.usage
>  119.60 ms       /cgroup/a/cpuacct.usage
> The large deficit here is due to quota generations (/intentionally/) preventing
> us from now using previously stranded slack quota.  The cost is that this quota
> becomes unavailable.
> 
> with quota generations and quota return:
>  200.09 ms       /cgroup/a/cpuacct.usage
>  200.09 ms       /cgroup/a/cpuacct.usage
>  198.09 ms       /cgroup/a/cpuacct.usage
>  200.09 ms       /cgroup/a/cpuacct.usage
>  200.06 ms       /cgroup/a/cpuacct.usage
> By returning unused quota we're able to both stably consume our desired quota
> and prevent unintentional overages due to the abuse of slack quota from 
> previous quota periods (especially on a large machine).
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thanks,
H.Seto

