Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1AUQB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:01:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1AUQB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:01:27 -0500
Date: Fri, 21 Jan 2011 16:53:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, roland@redhat.com,
        tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf: Fix find_get_context() vs
	perf_event_exit_task() race
Message-ID: <20110121155323.GA2988@redhat.com>
References: <20110119182207.GB12183@redhat.com> <tip-dbe08d82ce3967ccdf459f7951d02589cf967300@git.kernel.org> <20110121152939.GA28552@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121152939.GA28552@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Ingo Molnar wrote:
>
> * tip-bot for Oleg Nesterov <oleg@redhat.com> wrote:
>
> > @@ -6127,7 +6133,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
> >  	 * scheduled, so we are now safe from rescheduling changing
> >  	 * our context.
> >  	 */
> > -	child_ctx = child->perf_event_ctxp[ctxn];
> > +	child_ctx = rcu_dereference(child->perf_event_ctxp[ctxn]);
> >  	task_ctx_sched_out(child_ctx, EVENT_ALL);
> >
> >  	/*
>
> hm, this one's causing:
>
>  [   25.557579] ===================================================
>  [   25.561361] [ INFO: suspicious rcu_dereference_check() usage. ]


Oh, indeed, I am stupid!

I added rcu_dereference() because it has smp_read_barrier_depends(),
but I forgot about rcu_dereference_check().

I'll send the fix soon...

Oleg.

