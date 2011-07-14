Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab1GNPWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:22:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab1GNPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:22:31 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=PY02sq4htjkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=Av4ZjPoEM6qFhRR84HAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Question] sched: migrate RT task on throttled leaf RT
 runqueue?
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <CAJd=RBC6O2KojRghA5gNWOmTeXaznr=UwKVonu482GcHqKxxQw@mail.gmail.com>
References: <CAJd=RBCB-GZh9jtWMkuJHQ5wJRJkMyCONh5JGH=DMpfco5juYg@mail.gmail.com>
	 <1310652552.27864.25.camel@gandalf.stny.rr.com>
	 <CAJd=RBC6O2KojRghA5gNWOmTeXaznr=UwKVonu482GcHqKxxQw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 11:22:27 -0400
Message-ID: <1310656947.27864.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 22:58 +0800, Hillf Danton wrote:
> On Thu, Jul 14, 2011 at 10:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 2011-07-14 at 21:43 +0800, Hillf Danton wrote:
> >> Hi Steven
> >>
> >> When a non-boosted RT task is enqueued, if it is attached to task group, as
> >> shown in the following diff format for clarity, and even if the RT runqueue
> >> owned by the task group is throttled, the rt_rq is loaded up as leaf and the
> >> task is added to pushable list if it is pushable.
> >>
> >> Since RT tasks on throttled rt_runqueue will not be picked to be the next task
> >> when scheduling, could they be migrated by pushing and pulling?
> >
> > Note, run queues are not throttled, groups are. And tasks on a throttled
> > group should not be touched by the push/pull algorithm.
> >
> 
> Task group is one of the hard to understand in RT scheduler, according to the
> following two functions, if task group is throttled, could say its ->rt_rq[cpu]
> also throttled, where cpu could be anyone of the active_cpu_mask?
> 
> And how to relate rt_rq_throttled(p->rt.rt_rq) to throttled task group?

Best to ask Peter, as that is his work.

-- Steve

> 
> Thanks,
> 	Hillf
> 
> /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
> static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
> {
> #ifdef CONFIG_FAIR_GROUP_SCHED
> 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
> 	p->se.parent = task_group(p)->se[cpu];
> #endif
> 
> #ifdef CONFIG_RT_GROUP_SCHED
> 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
> 	p->rt.parent = task_group(p)->rt_se[cpu];
> #endif
> }
> 
> static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
> {
> 	return rt_se->rt_rq;
> }


