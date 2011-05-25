Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1EYEon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:44:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46277 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751180Ab1EYEol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:44:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+QpPIDwo+QKMVO0TSKGLjazITqNtVN5/8HWNEIf1
	UMLSOKb8KHMExE
Subject: Re: [PATCH] sched: fix need_resched() when checking peempt
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <BANLkTi=7C1jkKau_Lt7BxJ_PKrzE67incg@mail.gmail.com>
References: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
	 <1306244383.1465.59.camel@gandalf.stny.rr.com>
	 <BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
	 <BANLkTi=-c_XQOP4FAQEH6FN-9D62HS+tLw@mail.gmail.com>
	 <BANLkTi=7C1jkKau_Lt7BxJ_PKrzE67incg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 06:44:37 +0200
Message-ID: <1306298677.4819.35.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 12:34 +0800, Yong Zhang wrote:
> On Wed, May 25, 2011 at 11:24 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Tue, May 24, 2011 at 9:50 PM, Hillf Danton <dhillf@gmail.com> wrote:
> >> On Tue, May 24, 2011 at 9:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>> On Tue, 2011-05-24 at 21:27 +0800, Hillf Danton wrote:
> >>>> When checking if current task could be preempted by a newly woken task,
> >>>> further check could be bypassed if the current thread is different from
> >>>> the current task of run-queue, and it is corrected accordingly.
> >>>
> >>> Ug, that change log is an obfuscated mess. But looking at the actual
> >>> patch, I figured what you wanted to say. How about this:
> >>>
> >>> ----
> >>> The RT preempt check tests the wrong task if NEED_RESCHED is set. It
> >>> currently checks the local CPU task. It is suppose to check the task
> >>> that is running on the run queue we are about to wake another task on.
> >>> ----
> >>>
> >> Thanks, it is great changelog:)
> >
> > Good catch.
> >
> > Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
> >
> > BTW, this may be the reason for we could trigger
> > WARN_ON_ONCE(test_tsk_need_resched(next));
> > https://lkml.org/lkml/2010/12/20/28
> >
> > Peter, Mike, how do you think about it?
> 
> Since rq->lock protects both, that issue needs more digging :)

Yeah, good rainy day project.

	-Mike

