Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1LFGhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:37:55 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37271 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab1LFGhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:37:54 -0500
Date: Tue, 6 Dec 2011 12:07:36 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
Subject: Re: [patch v3 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
Message-ID: <20111206063736.GA18040@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
 <20111202010832.602203411@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111202010832.602203411@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120606-1976-0000-0000-0000084989FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2011-12-01 17:07:34]:

> @@ -5090,7 +5019,7 @@ static void nohz_idle_balance(int this_c
>  		goto end;
> 
>  	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
> -		if (balance_cpu == this_cpu)
> +		if (balance_cpu == this_cpu || !idle_cpu(this_cpu))
>  			continue;

Hmm ..did you mean to use '!idle_cpu(balance_cpu)' there? If the intent
was on checking this_cpu becoming busy, then we'd rather do a break on
that condition rather than continuing with the loop?

- vatsa

