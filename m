Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1BWPCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:02:09 -0500
Received: from blu0-omc1-s32.blu0.hotmail.com ([65.55.116.43]:35710 "EHLO
	blu0-omc1-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab1BWPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:02:07 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP11F8F588EC47CF2C6BAA5896DB0@phx.gbl>
Date: Wed, 23 Feb 2011 10:02:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 05/11] rcu: add comment saying why
	DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT.
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com> <1298431409.7666.76.camel@gandalf.stny.rr.com> <BLU0-SMTP615CB0BE0A2623EF62925096DB0@phx.gbl> <1298472914.7666.85.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1298472914.7666.85.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:01:54 up 322 days, 51 min,  6 users,  load average: 1.68,
	1.48, 1.48
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 15:02:06.0710 (UTC) FILETIME=[A3220160:01CBD36A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-02-23 at 08:59 -0500, Mathieu Desnoyers wrote:
> 
> > #ifdef CONFIG_PREEMPT
> >                 /*
> >                  * Ensure that queued callbacks are all executed.
> >                  * If we detect that we are nested in a RCU read-side
> >                  * critical
> >                  * section, we should simply fail, otherwise we would
> >                  * deadlock.
> >                  */
> >                 if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
> >                     irqs_disabled()) {
> >                         WARN_ON(1);
> >                         return 0;
> >                 }
> >                 rcu_barrier();
> >                 rcu_barrier_sched();
> >                 rcu_barrier_bh();
> >                 debug_object_init(head, &rcuhead_debug_descr);
> >                 return 1;
> > #else
> > 		return 0;
> > #endif
> > 
> > instead, no ?
> 
> BTW, if you do end up doing such a thing...
> 
> #ifndef CONFIG_PREEMPT
> 	return 0;
> #endif
> 
> before all that would be much cleaner.
> 
> Just make sure any non defined in PREEMPT macros/functions are defined
> as nops in !CONFIG_PREEMPT

Good point, thanks !

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
