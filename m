Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0HXMrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:47:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42808 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0HXMri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:47:38 -0400
Date: Tue, 24 Aug 2010 18:17:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
Message-ID: <20100824124726.GQ4684@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1279583835-22854-1-git-send-email-venki@google.com>
 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
 <1282636286.2605.2307.camel@laptop>
 <20100824080515.GK4684@balbir.in.ibm.com>
 <1282640953.2605.2428.camel@laptop>
 <20100824113801.GO4684@balbir.in.ibm.com>
 <1282650835.2605.2629.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1282650835.2605.2629.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-08-24 13:53:55]:

> On Tue, 2010-08-24 at 17:08 +0530, Balbir Singh wrote:
> > 
> > The point is for containers it is more likely to give the right answer
> > and so on. Yes, the results are not 100% accurate. 
> 
> Consider one group heavily dirtying pages, it stuffs the IO queues full
> and gets blocked on IO completion. Since the CPU is then free to
> schedule something else we start running things from another group,
> those IO completions will come in while we run other group and get
> accounted to other group -- FAIL.
> 
> s/group/task/ etc..
> 
> That just really doesn't work, accounting async work, esp stuff that is
> not under software control it very tricky indeed.

Yes, we don't have sufficient context to charge the correct context. I
think openvz has some technology there, we will too when we have I/O
cgroups at a cgroup level, but the instances of such operations are
too many to accurately identify them all.

> 
> So what are you wanting to do, and why. Do you really need accounting
> madness?

I think Venki gave the answer in the posting

"There are usecases where reporting this time against task
or task groups or cgroups will be useful for user/administrator
in terms of resource planning and utilization charging"

I don't have any specific use cases, I was just reviewing the patchset
and trying to understand how to solve the problem.


-- 
	Three Cheers,
	Balbir
