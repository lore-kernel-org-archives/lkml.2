Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1I1EPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:15:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50723 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1I1EPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:15:09 -0400
Date: Wed, 28 Sep 2011 09:45:01 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venki Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110928041501.GH4357@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
 <1317167376.11592.53.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317167376.11592.53.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2011-09-27 16:49:36]:

> One of the reasons why we saw lib_cpu not idle is probably because that
> info was stale.
> 
> Consider this scenario.
> 
> a. got a tick when the cpu was busy, so idle_at_tick was not set
> b. cpu went idle
> c. same cpu got the kick IPI from other busy cpu
> d. and as it has idle_at_tick not set, it couldn't proceed with the nohz
> idle balance.

Good point ..we chould use idle_cpu() instead there ..

> I think we are mostly likely seeing the above mentioned scenario.
> 
> Also Vatsa, there is a deadlock associated by using
> __smp_call_funciton_single() in the nohz_balancer_kick(). So I am
> planning to remove the IPI that is used to kick the nohz balancer and
> instead use the resched_cpu logic to kick the nohz balancer.
> 
> I will post this patch mostly tomorrow. That patch will not use the
> idle_at_tick check in the nohz_idle_balance(). So that should address
> your issue in some cases if not most.

Ok ..would be glad to test your change ..I am however doubtfull if it
will eliminate rest of the issues I pointed out with nohz load balancer.

- vatsa
