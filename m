Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab1EJHOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:14:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56854 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1EJHOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:14:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E5C2.9090701@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:14:10 +0900
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
Subject: Re: [patch 01/15] sched: (fixlet) dont update shares twice on on_rq
 parent
References: <20110503092846.022272244@google.com> <20110503092904.541414484@google.com>
In-Reply-To: <20110503092904.541414484@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:28), Paul Turner wrote:
> In dequeue_task_fair() we bail on dequeue when we encounter a parenting entity
> with additional weight.  However, we perform a double shares update on this
> entity since we continue the shares update traversal from that point, despite
> dequeue_entity() having already updated its queuing cfs_rq.
> 
> Avoid this by starting from the parent when we resume.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  kernel/sched_fair.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: tip/kernel/sched_fair.c
> ===================================================================
> --- tip.orig/kernel/sched_fair.c
> +++ tip/kernel/sched_fair.c
> @@ -1355,8 +1355,10 @@ static void dequeue_task_fair(struct rq 
>  		dequeue_entity(cfs_rq, se, flags);
>  
>  		/* Don't dequeue parent if it has other entities besides us */
> -		if (cfs_rq->load.weight)
> +		if (cfs_rq->load.weight) {
> +			se = parent_entity(se);
>  			break;
> +		}
>  		flags |= DEQUEUE_SLEEP;
>  	}
>  

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

This small fixlet can stand alone.
Peter, how about getting this into git tree first?


Thanks,
H.Seto

