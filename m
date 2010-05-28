Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab0E1CyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:54:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46674 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0E1CyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:54:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <20100527183319.GA22313@redhat.com>
References: <20100527180431.GP13035@uudg.org> <20100527183319.GA22313@redhat.com>
Message-Id: <20100528090357.7DFB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 28 May 2010 11:54:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> On 05/27, Luis Claudio R. Goncalves wrote:
> >
> > It sounds plausible giving the dying task an even higher priority to be
> > sure it will be scheduled sooner and free the desired memory.
> 
> As usual, I can't really comment the changes in oom logic, just minor
> nits...
> 
> > @@ -413,6 +415,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
> >  	 */
> >  	p->rt.time_slice = HZ;
> >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> > +	param.sched_priority = MAX_RT_PRIO-1;
> > +	sched_setscheduler(p, SCHED_FIFO, &param);
> >
> >  	force_sig(SIGKILL, p);
> 
> Probably sched_setscheduler_nocheck() makes more sense.
> 
> Minor, but perhaps it would be a bit better to send SIGKILL first,
> then raise its prio.

I have no objection too. but I don't think Oleg's pointed thing is minor.
Please send updated patch.

Thanks.


