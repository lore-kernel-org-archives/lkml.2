Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab1FTNUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:20:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1FTNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:20:19 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=Caq5pGLvaXcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=cJUtO60uO9aLoGLuUPgA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: update cpupri for runqueue when its priority
 changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikm1h45+sCYeKOXBhw1haQAHO1uPA@mail.gmail.com>
References: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
	 <1308275405.9218.156.camel@gandalf.stny.rr.com>
	 <BANLkTik8PpdwGgLOE7rAauXqGYdnT53GpQ@mail.gmail.com>
	 <1308322563.9218.184.camel@gandalf.stny.rr.com>
	 <BANLkTimUd3BWFg4hi6OWLjUYsxvWRRBUZg@mail.gmail.com>
	 <1308417114.9218.220.camel@gandalf.stny.rr.com>
	 <BANLkTikm1h45+sCYeKOXBhw1haQAHO1uPA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Jun 2011 09:20:16 -0400
Message-ID: <1308576016.531.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-19 at 16:33 +0800, Hillf Danton wrote:
> On Sun, Jun 19, 2011 at 1:11 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> There are two cases that NULL is returned in _pick_next_task_rt(), it is the
> >> second case, after checking rt_rq->rt_nr_running, that is captured, and if
> >> NULL is returned in the second case, the CPU priority does change.
> >
> > The two cases are:
> >
> > 1) no rt task exists
> > 2) the runqueue is throttled.
> >
> > We already talked about the throttled case. The case where no rt task
> > exists means that the last rt task has been dequeued. When that happens,
> > the cpupri is updated then. I don't see any bug. There's no need to
> > update cpupri at this point.
> >
> 
> In case 2) , the CPU will be held then by non-RT task, and we have to
> update priority.
> 
> I understand 1) and 2) to be, there has RT tasks on runqueue but they
> could not run at the moment.
> 
> If throttled RQ == no RT tasks, please drop this patch directly.

Yes a throttled RQ means that there are no RT tasks on it. That's
because when we throttle an RQ, we dequeue the RT tasks from it. Which
means the cpupri will be updated at that time.

-- Steve


