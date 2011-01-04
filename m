Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1ADSxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:53:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41647 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751127Ab1ADSxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:53:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19BXvJ7QmlByqmUOKItcb/zCs+btITIdIL6i1RdgM
	ui3nVcbagpkoQP
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1294164289.2016.186.camel@laptop>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <1294164289.2016.186.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 19:53:33 +0100
Message-ID: <1294167213.9334.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 19:04 +0100, Peter Zijlstra wrote:

> > +		p_cfs_rq = cfs_rq_of(pse);
> > +		yield = 1;
> > +	}
> > +#endif
> > +
> > +	if (yield)
> > +		clear_buddies(cfs_rq, se);
> > +	else if (preempt)
> > +		clear_buddies(p_cfs_rq, curr);
> > +
> > +	/* Tell the scheduler that we'd really like pse to run next. */
> > +	p_cfs_rq->next = pse;
> > +
> > +	if (!yield && preempt)
> > +		resched_task(task_of(p_cfs_rq->curr));
> 
> I don't get this.. Why would you resched the remote cpu, surely you
> didn't just pull its current task over..

:) hope not.   Caller bails on task_running(p_rq, p).  wants a comment
too I suppose.

Target doesn't live here, preempt is still set/allowed, so we want the
remote cpu to schedule.

	-Mike

