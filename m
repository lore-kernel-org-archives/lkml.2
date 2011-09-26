Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1IZMCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:02:03 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60940 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1IZMCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:02:01 -0400
Date: Mon, 26 Sep 2011 17:31:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110926120105.GA8593@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110926115049.GA22604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11092612-3270-0000-0000-0000006BF7CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-26 17:20:49]:

> @@ -4695,8 +4719,11 @@ static inline int nohz_kick_needed(struc
>  	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
>  
>  	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
> -	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
> +	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu) {
> +		if (rq->nr_running > 1)
> +			return 1;
>  		return 0;
> +	}

I should have added a comment to explain this change ..will do it in
next version (along with any other changes suggested).

- vatsa

