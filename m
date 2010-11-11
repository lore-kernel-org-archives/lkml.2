Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KKPfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:35:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0KKPfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:35:22 -0500
Date: Thu, 11 Nov 2010 16:27:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
	kthreads
Message-ID: <20101111152750.GA2510@redhat.com>
References: <1288333128.8661.137.camel@Palantir> <1288333876.8661.147.camel@Palantir> <1289486096.2084.123.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289486096.2084.123.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Peter Zijlstra wrote:
>
> On Fri, 2010-10-29 at 08:31 +0200, Raistlin wrote:
> > @@ -6071,7 +6104,7 @@ void sched_idle_next(void)
> >          */
> >         raw_spin_lock_irqsave(&rq->lock, flags);
> >
> > -       __setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
> > +       __setscheduler_dl_special(rq, p);
> >
> >         activate_task(rq, p, 0);
> >
>
> Ingo, happen to know if this is really needed these days? hotplug should
> have migrated all other tasks away, leaving only the idle task to run.

This is called before CPU_DEAD stage which migrates all tasks away.


Sorry, can't resist, off-topic quiestion. Do we really need
migration_call()->migrate_live_tasks() ?

With the recent changes, try_to_wake_up() can never choose
the dead (!cpu_online) cpu if the task was deactivated.

Looks like we should only worry about the running tasks, and
migrate_dead_tasks()->pick_next_task() loop seems to all work
we need.

(Of course, we can't just remove migrate_live_tasks(), at leat
 migrate_dead() needs simple changes).

What do you think?

Oleg.

