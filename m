Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2BBJPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:15:49 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:13305 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188Ab2BBJPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:15:46 -0500
X-IronPort-AV: E=Sophos;i="4.71,608,1320620400"; 
   d="scan'208";a="142523009"
Date: Thu, 2 Feb 2012 10:15:45 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Josh Triplett <josh@joshtriplett.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH RFC tip/core/rcu 31/41] rcu: Add CPU-stall capability to
 rcutorture
In-Reply-To: <20120202055310.GR29058@leaf>
Message-ID: <alpine.DEB.2.02.1202021014480.1928@localhost6.localdomain6>
References: <20120201194131.GA10028@linux.vnet.ibm.com> <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com> <1328125319-5205-31-git-send-email-paulmck@linux.vnet.ibm.com> <20120202055310.GR29058@leaf>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Feb 2012, Josh Triplett wrote:

> On Wed, Feb 01, 2012 at 11:41:49AM -0800, Paul E. McKenney wrote:
>> --- a/kernel/rcutorture.c
>> +++ b/kernel/rcutorture.c
>> +/* Spawn CPU-stall kthread, if stall_cpu specified. */
>> +static int __init rcu_torture_stall_init(void)
>> +{
>> +	if (stall_cpu <= 0)
>> +		return 0;
>> +	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
>> +	if (IS_ERR(stall_task)) {
>> +		stall_task = NULL;
>> +		return PTR_ERR(stall_task);
>
> This seems...unlikely to produce the desired result. :)
>
> A quick check turns up the same bug in rcutorture_onoff_init.
>
> This suggests a possible Coccinelle check, for uses of PTR_ERR(foo) after
> foo = (any constant other than ERR_PTR(foo)).

Indeed, it seems to be a popular idiom :)  I'll send some patches later 
today.

julia
