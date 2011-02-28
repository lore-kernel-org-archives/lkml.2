Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1B1J0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:26:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50731 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752781Ab1B1J0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:26:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+oM0xpfOmoq11rYPkny+DDF2j8jAr2u+O4rbMzq9
	IcMuMazhNr6/Z+
Subject: Re: [tip:sched/core] sched: Add yield_to(task, preempt)
 functionality
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: Venkatesh Pallipadi <venki@google.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        mtosatti@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D689346.1090002@redhat.com>
References: <20110201095051.4ddb7738@annuminas.surriel.com>
	 <tip-d95f412200652694e63e64bfd49f0ae274a54479@git.kernel.org>
	 <AANLkTi=b-tyXEUfBKJH1RbENsqq8a-NRF54dSS6E3WGf@mail.gmail.com>
	 <4D689346.1090002@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 10:26:29 +0100
Message-ID: <1298885189.9501.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-26 at 00:44 -0500, Rik van Riel wrote:
> On 02/25/2011 07:43 PM, Venkatesh Pallipadi wrote:

> > The below comment says about rescheduling p's CPU. But the rq variable
> > we have here is the curr_rq and not p_rq. So, should this be done in
> > yield_to() with p_rq. I did try to see the discussion on other
> > versions of this patch. v3 and before had -
> > "resched_task(task_of(p_cfs_rq->curr));" which seems to be correct...
> 
> You are correct.  We are calling resched_task on the wrong task,
> we should call it on p's runqueue's current task...

Are you going to send a fix?

> >> +
> >> +       /* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
> >> +       if (preempt)
> >> +               resched_task(rq->curr);


