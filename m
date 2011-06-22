Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1FVJjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:39:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59210 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab1FVJjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:39:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01B84D.4040001@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 18:39:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
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
Subject: Re: [patch 10/16] sched: throttle entities exceeding their allowed
 bandwidth
References: <20110621071649.862846205@google.com> <20110621071700.700763369@google.com>
In-Reply-To: <20110621071700.700763369@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/21 16:16), Paul Turner wrote:
> Add conditional checks time of put_prev_entity() and enqueue_entity() to detect
> when an active entity has exceeded its allowed bandwidth and requires
> throttling.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---
(snip)
> @@ -1403,7 +1412,7 @@ static void account_cfs_rq_runtime(struc
>  	 * if we're unable to extend our runtime we resched so that the active
>  	 * hierarchy can be throttled
>  	 */
> -	if (!assign_cfs_rq_runtime(cfs_rq))
> +	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
>  		resched_task(rq_of(cfs_rq)->curr);
>  }
>  

Nit: I think this hunk could be included in patch 08/16.

The rest is good.

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

