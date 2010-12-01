Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0LADjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 22:39:32 -0500
Received: from lo.gmane.org ([80.91.229.12]:38647 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0LADjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 22:39:31 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
Date: Tue, 30 Nov 2010 19:39:09 -0800
Message-ID: <4CF5C35D.1060003@google.com>
References: <20101121133744.GA10765@elte.hu>	 <1290700829.4759.16.camel@maggy.simson.net> <1290954299.30515.15.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: 216-239-45-4.google.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
In-Reply-To: <1290954299.30515.15.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/10 06:24, Mike Galbraith wrote:
> On Thu, 2010-11-25 at 09:00 -0700, Mike Galbraith wrote:
>
>> My vacation is (sniff) over, so I won't get a fully tested patch out the
>> door for review until I get back home.
>
> Either I forgot to pack my eyeballs, or laptop is just too dinky and
> annoying.  Now back home on beloved box, this little bugger poked me
> dead in the eye.
>
> Something else is seriously wrong though.  36.1 with attached (plus
> sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> 37.git and tip with fixlet below both suck rocks.  With a make -j40
> running, wakeup-latency is showing latencies of>100ms, amarok skips,
> mouse lurches badly.. generally horrid.  Something went south.
>

I'm looking at this.

The share:share ratios looked good in static testing, but perhaps we 
need a little more wake-up boost to improve interactivity.

Should have something tomorrow.

- Paul

> sched: fix 3d4b47b4 typo.
>
> Signed-off-by: Mike Galbraith<efault@gmx.de>
> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar<mingo@elte.hu>
> LKML-Reference: new submission
> ---
>   kernel/sched.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -8087,7 +8087,6 @@ static inline void unregister_fair_sched
>   {
>   	struct rq *rq = cpu_rq(cpu);
>   	unsigned long flags;
> -	int i;
>
>   	/*
>   	* Only empty task groups can be destroyed; so we can speculatively
> @@ -8097,7 +8096,7 @@ static inline void unregister_fair_sched
>   		return;
>
>   	raw_spin_lock_irqsave(&rq->lock, flags);
> -	list_del_leaf_cfs_rq(tg->cfs_rq[i]);
> +	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
>   	raw_spin_unlock_irqrestore(&rq->lock, flags);
>   }
>   #else /* !CONFG_FAIR_GROUP_SCHED */
>


