Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966213Ab0CPNfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:35:37 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51655 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754674Ab0CPNfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:35:36 -0400
Date: Tue, 16 Mar 2010 09:35:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Chris Friesen <cfriesen@nortel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
	barrier (v9)
Message-ID: <20100316133534.GB22578@Krystal>
References: <20100225232316.GA30196@Krystal> <20100304122304.GA6864@elte.hu> <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain> <20100304175659.GA3255@Krystal> <20100315205312.GA31231@Krystal> <20100316073635.GC18448@elte.hu> <20100316075709.GL2869@laptop> <20100316131336.GB24808@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316131336.GB24808@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:30:00 up 52 days, 16:07,  5 users,  load average: 0.08, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Tue, Mar 16, 2010 at 08:36:35AM +0100, Ingo Molnar wrote:
> > > 
> > > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > 
> > > > Unless this question is answered, Ingo's SA_RUNNING signal proposal, as 
> > > > appealing as it may look at a first glance, falls into the 
> > > > "fundamentally broken" category. [...]
> > > 
> > > How is it different from your syscall? I.e. which lines of code make the 
> > > difference? We could certainly apply the (trivial) barrier change to 
> > > context_switch().
> > 
> > I think it is just easy for userspace to misuse or think it does something 
> > that it doesn't (because of races).
> 
> That wasnt my question though. The question i asked Mathieu was to show how 
> SA_RUNNING is "fundamentally broken" for librcu use while sys_membarrier() is 
> not?
> 
> This is really what he claims above. (i preserved the quote)
> 
> It must be a misunderstanding either on my side or on his side. (Once that is 
> cleared we can discuss further usecases for SA_RUNNING.)

Well, it's not broken for sys_membarrier() specifically if we add the proper
memory barriers to the scheduler, but it's broken when we try to use it for
anything else. What makes it broken is that it requires that the scheduler
switch guarantee to have the same side-effect on a running thread than execution
on the per-running-thread signal handler.

What's different with the sys_membarrier system call is that it does not try to
make generic something that should probably stay case-specific due to its
close coupling with the scheduler.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
