Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124Ab0E0SfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:35:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935012Ab0E0SfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:35:07 -0400
Date: Thu, 27 May 2010 20:33:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-ID: <20100527183319.GA22313@redhat.com>
References: <20100527180431.GP13035@uudg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527180431.GP13035@uudg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Luis Claudio R. Goncalves wrote:
>
> It sounds plausible giving the dying task an even higher priority to be
> sure it will be scheduled sooner and free the desired memory.

As usual, I can't really comment the changes in oom logic, just minor
nits...

> @@ -413,6 +415,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>  	 */
>  	p->rt.time_slice = HZ;
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
> +	param.sched_priority = MAX_RT_PRIO-1;
> +	sched_setscheduler(p, SCHED_FIFO, &param);
>
>  	force_sig(SIGKILL, p);

Probably sched_setscheduler_nocheck() makes more sense.

Minor, but perhaps it would be a bit better to send SIGKILL first,
then raise its prio.

Oleg.

