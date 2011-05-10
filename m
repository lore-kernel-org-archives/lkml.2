Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1EJH2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:28:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46774 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1EJH2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:28:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E8EF.8030109@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:27:43 +0900
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
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [patch 13/15] sched: add exports tracking cfs bandwidth control
 statistics
References: <20110503092846.022272244@google.com> <20110503092905.606935177@google.com>
In-Reply-To: <20110503092905.606935177@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:28), Paul Turner wrote:
> From: Nikhil Rao <ncrao@google.com>
> 
> This change introduces statistics exports for the cpu sub-system, these are
> added through the use of a stat file similar to that exported by other
> subsystems.
> 
> The following exports are included:
> 
> nr_periods:	number of periods in which execution occurred
> nr_throttled:	the number of periods above in which execution was throttle
> throttled_time:	cumulative wall-time that any cpus have been throttled for
> this group
> 
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched.c      |   22 ++++++++++++++++++++++
>  kernel/sched_fair.c |    9 +++++++++
>  2 files changed, 31 insertions(+)
> 
> Index: tip/kernel/sched.c
> ===================================================================
> --- tip.orig/kernel/sched.c
> +++ tip/kernel/sched.c
> @@ -260,6 +260,10 @@ struct cfs_bandwidth {
>  	struct hrtimer period_timer;
>  	struct list_head throttled_cfs_rq;
>  
> +	/* statistics */
> +	int nr_periods, nr_throttled;
> +	u64 throttled_time;
> +
>  #endif
>  };
>  

Nit: blank line?

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thanks,
H.Seto

