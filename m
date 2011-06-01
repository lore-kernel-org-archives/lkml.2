Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161002Ab1FACVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:21:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42534 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758562Ab1FACVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:21:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/9nu9RJy79io3p7SKwQ9sSfVb3bWFHc+SvOGEj95
	pR1vVjK6qKd047
Subject: Re: [PATCH] sched: fix rt_nr_migratory corruption raised in
 push_rt_task()
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTi=YXK7pCJqei6oz4dzLzHgJC_m=2g@mail.gmail.com>
References: <BANLkTimfOsJ91_PJdB5-H02EGS0S5eJ5cA@mail.gmail.com>
	 <1306827397.7536.10.camel@marge.simson.net>
	 <BANLkTi=YXK7pCJqei6oz4dzLzHgJC_m=2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 04:21:26 +0200
Message-ID: <1306894886.4791.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 21:56 +0800, Hillf Danton wrote:
> On Tue, May 31, 2011 at 3:36 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Mon, 2011-05-30 at 21:39 +0800, Hillf Danton wrote:
> >> When pushing, if a pushable task could not be pushed, it is dequeued with no
> >> updating the rt_nr_migratory element of RT run-queue, then rt_nr_migratory is
> >> corrupted, which is fixed by removing the dequeue operation.
> >
> > Hm.  I think you're right that this dequeue_pushable_task() call can be
> > removed, at least I didn't see it's reason for existing.  I'd word it a
> > bit differently though, and not return 1 unless we really did push.
> >
> 
> Hi Mike
> 
> Your message shows what is called professional work, but something lost,
> 
> > From: Hillf Danton <dhillf@gmail.com>
> >
> > sched, rt: fix rq->rt.pushable_tasks bug in push_rt_task()
> >
> > Do not call dequeue_pushable_task() when failing to push an eligible
> > task, as it remains pushable, merely not at this particular moment.
> >
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> right?

Well, you did the legwork, but I resent it as requested.

> > ---
> >  kernel/sched_rt.c |   15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > Index: linux-2.6.40.git/kernel/sched_rt.c
> > ===================================================================
> 
> And how to drive git to print the above two lines?

That's easy, I used quilt :)  I'm no master of git-fu (wimpy whitebelt),
use git for hunting, but quilt for twiddling.

	-Mike

