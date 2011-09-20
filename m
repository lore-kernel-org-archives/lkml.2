Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab1ITRZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:25:34 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42803 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750919Ab1ITRZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:25:33 -0400
Date: Tue, 20 Sep 2011 13:25:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@gentwo.org>,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
	this_cpu_read/write()
Message-ID: <20110920172531.GA21179@Krystal>
References: <alpine.DEB.2.00.1109191644190.19059@router.home> <1316487977.29966.32.camel@gandalf.stny.rr.com> <27409.1316522696@turing-police.cc.vt.edu> <alpine.DEB.2.00.1109200955190.8056@router.home> <1316531987.29966.65.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1109201108080.8056@router.home> <1316536260.29966.93.camel@gandalf.stny.rr.com> <1316537808.29966.98.camel@gandalf.stny.rr.com> <1316538541.13664.60.camel@twins> <1316538952.29966.105.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316538952.29966.105.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:23:35 up 300 days, 22:26,  7 users,  load average: 0.54, 0.35,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-09-20 at 19:09 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-09-20 at 12:56 -0400, Steven Rostedt wrote:
> > > random_cpu_*()    // Thomas's idea
> > 
> > I like this one best..
> 
> I like it too, but not really the most appropriate.
> 
> > 
> > But you forgot do deal with the irqsafe_cpu() crap, that's the same
> > brainfart as this_cpu() but more expensive because it frobs IRQ state.
> 
> But irqsafe_cpu_*() doesn't really have any real meaning to me. That is
> something when I see it, I go and read the comments about it. It doesn't
> contain "this_cpu" which is something that seems to explain what it is,
> even though the obvious is not what it is.

Throwing ideas from the IRC discussion into the mix (Paul McKenney and I
came up with it at the same time):

preempt_protected_percpu_*()
irq_protected_percpu_*()

Seems to be quite self-explanatory.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
