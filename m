Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1ITSDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:03:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1ITSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:03:08 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=pJBYM6ilOsytkSDjBt0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@gentwo.org>,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110920172531.GA21179@Krystal>
References: <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <27409.1316522696@turing-police.cc.vt.edu>
	 <alpine.DEB.2.00.1109200955190.8056@router.home>
	 <1316531987.29966.65.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201108080.8056@router.home>
	 <1316536260.29966.93.camel@gandalf.stny.rr.com>
	 <1316537808.29966.98.camel@gandalf.stny.rr.com>
	 <1316538541.13664.60.camel@twins>
	 <1316538952.29966.105.camel@gandalf.stny.rr.com>
	 <20110920172531.GA21179@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 14:03:05 -0400
Message-ID: <1316541785.29966.108.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 13:25 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Tue, 2011-09-20 at 19:09 +0200, Peter Zijlstra wrote:
> > > On Tue, 2011-09-20 at 12:56 -0400, Steven Rostedt wrote:
> > > > random_cpu_*()    // Thomas's idea
> > > 
> > > I like this one best..
> > 
> > I like it too, but not really the most appropriate.
> > 
> > > 
> > > But you forgot do deal with the irqsafe_cpu() crap, that's the same
> > > brainfart as this_cpu() but more expensive because it frobs IRQ state.
> > 
> > But irqsafe_cpu_*() doesn't really have any real meaning to me. That is
> > something when I see it, I go and read the comments about it. It doesn't
> > contain "this_cpu" which is something that seems to explain what it is,
> > even though the obvious is not what it is.
> 
> Throwing ideas from the IRC discussion into the mix (Paul McKenney and I
> came up with it at the same time):
> 
> preempt_protected_percpu_*()
> irq_protected_percpu_*()
> 
> Seems to be quite self-explanatory.
> 

For use where the per_cpu data is protected with preemption disabled?
But isn't that the default case? Why make it hard to type for when you
should use it in the normal case.

It should be hard to type when it is a hack. As I recommended on IRC, we
probably should have it as:

use_this_if_you_really_do_not_care_what_cpu_you_are_on_but_are_anal_about_performance_cpu_*()

1) it is very self descriptive.
2) it would limit the usage as people wont like to have it in their
code ;)

-- Steve


