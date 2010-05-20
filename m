Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0ETWSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:18:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26902 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab0ETWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:18:46 -0400
Date: Thu, 20 May 2010 18:17:42 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] reduce runqueue lock contention
Message-ID: <20100520221742.GB20946@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	axboe@kernel.dk, linux-kernel@vger.kernel.org
References: <20100520204810.GA19188@think>
 <1274389786.1674.1653.camel@laptop>
 <1274390592.1674.1656.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274390592.1674.1656.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BF5B520.012B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 11:23:12PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-20 at 23:09 +0200, Peter Zijlstra wrote:
> 
> > int try_to_wake_up(struct task *p, unsigned int mask, wake_flags)
> > {
> >   int state = atomic_read(&p->state);
> > 
> >   do {
> >     if (!(state & mask))
> >       return 0;
> > 
> >     state = atomic_cmpxchg(&p->state, state, TASK_WAKING);
> >   } while (state != TASK_WAKING);
> 
>     cpu = select_task_rq()
> 
> and then somehow see we get set_task_cpu() done without races :-)
> 
> >   /* do this pending queue + ipi thing */
> > 
> >   return 1;
> > }

I tried not to set the task waking, since I was worried about races with
us getting queued somewhere else.  But, I don't have a good handle on
all of that so I kind of chickened out.  That's why my code falls back
to the full ttwu in a few cases.

Do you think the above could be an addition to my patch or that it's
required for my patch to work well?

-chris

