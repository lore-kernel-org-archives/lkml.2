Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0CXQJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab0CXQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:09:36 -0400
Date: Wed, 24 Mar 2010 17:07:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] move_task_off_dead_cpu: take rq->lock around
	select_fallback_rq()
Message-ID: <20100324160727.GA4121@redhat.com>
References: <20100315091010.GA9131@redhat.com> <1269445284.5109.360.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269445284.5109.360.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Peter Zijlstra wrote:
>
> On Mon, 2010-03-15 at 10:10 +0100, Oleg Nesterov wrote:
> >  static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
> >  {
> > +       struct rq *rq = cpu_rq(dead_cpu);
> > +       int needs_cpu, dest_cpu;
> > +       unsigned long flags;
> >  again:
> > +       local_irq_save(flags);
> > +
> > +       raw_spin_lock(&rq->lock);
> > +       needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
>
>                                        ^ 
> kernel/sched.c:5445: warning: ‘dest_cpu’ may be used uninitialized in this function

Hmm. looks like my gcc is more friendly...

OK. certainly I'll send the updated patch, if this series passes
your review otherwise.

Oleg.

