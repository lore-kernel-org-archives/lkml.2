Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1AUVuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:50:24 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53687 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1AUVuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:50:23 -0500
Date: Fri, 21 Jan 2011 13:50:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        roland@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] perf: perf_event_exit_task_context:
 s/rcu_dereference/rcu_dereference_raw/
Message-ID: <20110121215016.GO17752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110119182207.GB12183@redhat.com>
 <tip-dbe08d82ce3967ccdf459f7951d02589cf967300@git.kernel.org>
 <20110121152939.GA28552@elte.hu>
 <20110121155323.GA2988@redhat.com>
 <20110121174547.GA8796@redhat.com>
 <20110121175345.GB8796@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121175345.GB8796@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 06:53:45PM +0100, Oleg Nesterov wrote:
> On 01/21, Oleg Nesterov wrote:
> >
> > In theory, almost every user of task->child->perf_event_ctxp[]
> > is wrong. find_get_context() can install the new context at any
> > moment, we need read_barrier_depends().
> 
> And perhaps it makes sense to fix them all, although the problem
> is only theoretical.
> 
> > dbe08d82ce3967ccdf459f7951d02589cf967300 "perf: Fix
> > find_get_context() vs perf_event_exit_task() race" added
> > rcu_dereference() into perf_event_exit_task_context() to make
> > the precedent, but this makes __rcu_dereference_check() unhappy.
> > Use rcu_dereference_raw() to shut up the warning.
> 
> But rcu_dereference_raw() looks a bit confusing, and it is not
> very convenient to use read_barrier_depends() directly.
> 
> Paul, may be it makes sense to add the new trivial helper which
> can be used instead?
> 
> Yes, this is only cosmetic issue, I know ;)

Cosmetic issues can be pretty important to the poor guy trying to read
the code.  ;-)

What keeps the structure that rcu_dereference_raw() returns a pointer
to from going away?  Best would be if a lockdep condition could be
constructed from the answer to this question and added to the appropriate
rcu_dereference() primitive.

							Thanx, Paul
