Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2HPGmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:42:46 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35159 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2HPGmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:42:45 -0400
Message-ID: <502C98E8.20800@linux.vnet.ibm.com>
Date: Thu, 16 Aug 2012 12:23:28 +0530
From: preeti <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
In-Reply-To: <1345028738.31459.82.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12081606-7014-0000-0000-000001BBF516
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi everyone,

>From what I have understood so far,I try to summarise pin pointed
differences between the performance and power policies as found
relevant to the scheduler-load balancing mechanism.Any thoughts?

*Performance policy*:

Q1.Who triggers load_balance?
Load balance is triggered when a cpu is found to be idle.(Pull mechanism)

Q2.How is load_balance handled?
When triggered,the load is looked to be pulled from its sched domain.
First the sched groups in the domain the cpu belongs to is queried
followed by the runqueues in the busiest group.then the tasks are moved.

This course of action is found analogous to the performance policy because:

1.First the idle cpu initiates the pull action
2.The busiest cpu hands over the load to this cpu.A person who can
handle any work is querying as to who cannot handle more work.

*Power policy*:

So how is power policy different? As Peter says,'pack more than spread
more'.

Q1.Who triggers load balance?
It is the cpu which cannot handle more work.Idle cpu is left to remain
idle.(Push mechanism)

Q2.How is load_balance handled?
First the least busy runqueue,from within the sched_group that the busy
cpu belongs to is queried.if none exist,ie all the runqueues are equally
busy then move on to the other sched groups.

Here again the 'least busy' policy should be applied,first at
group level then at the runqueue level.

This course of action is found analogous to the power policy because as
much as possible busy and capable cpus within a small range try to
handle the existing load.

Regards
Preeti


