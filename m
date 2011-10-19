Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1JSPt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:49:29 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40485 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab1JSPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:49:27 -0400
X-Sasl-enc: uoP0AvsCqokKgLGiM9GvzAVEt+Rm8+sPVbAbSFeGjT0m 1319039367
Date: Wed, 19 Oct 2011 08:49:10 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Simon Kirby <sim@hostway.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Patch Upstream: cputimer: Cure lock inversion
Message-ID: <20111019154910.GA9361@kroah.com>
References: <20111019153914.9153A2188@git.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019153914.9153A2188@git.kroah.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 11:39:14AM -0400, Gregs git-bot wrote:
> commit: bcd5cff7216f9b2de0a148cc355eac199dc6f1cf
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon, 17 Oct 2011 11:50:30 +0200
> Subject: cputimer: Cure lock inversion
> 
> There's a lock inversion between the cputimer->lock and rq->lock;
> notably the two callchains involved are:
> 
>  update_rlimit_cpu()
>    sighand->siglock
>    set_process_cpu_timer()
>      cpu_timer_sample_group()
>        thread_group_cputimer()
>          cputimer->lock
>          thread_group_cputime()
>            task_sched_runtime()
>              ->pi_lock
>              rq->lock
> 
>  scheduler_tick()
>    rq->lock
>    task_tick_fair()
>      update_curr()
>        account_group_exec()
>          cputimer->lock
> 
> Where the first one is enabling a CLOCK_PROCESS_CPUTIME_ID timer, and
> the second one is keeping up-to-date.
> 
> This problem was introduced by e8abccb7193 ("posix-cpu-timers: Cure
> SMP accounting oddities").

There is no such patch in Linus's tree that I can find.  So, what
problem is this really trying to cure here and what kernel did it show
up in?

confused,

greg k-h
