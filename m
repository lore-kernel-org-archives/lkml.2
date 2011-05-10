Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1EJHWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:22:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38631 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1EJHWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:22:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E780.6020306@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:21:36 +0900
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
Subject: Re: [patch 05/15] sched: add a timer to handle CFS bandwidth refresh
References: <20110503092846.022272244@google.com> <20110503092904.895444153@google.com>
In-Reply-To: <20110503092904.895444153@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:28), Paul Turner wrote:
> @@ -250,6 +253,9 @@ struct cfs_bandwidth {
>  	ktime_t period;
>  	u64 quota;
>  	s64 hierarchal_quota;
> +
> +	int idle;
> +	struct hrtimer period_timer;
>  #endif
>  };
>  

"idle" is not used yet.  How about adding it in later patch?
Plus, comment explaining how it is used would be appreciated.

>  static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>  {
>  	raw_spin_lock_init(&cfs_b->lock);
>  	cfs_b->quota = RUNTIME_INF;
>  	cfs_b->period = ns_to_ktime(default_cfs_period());
> +
> +	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	cfs_b->period_timer.function = sched_cfs_period_timer;
> +
>  }

Nit: blank line?

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

