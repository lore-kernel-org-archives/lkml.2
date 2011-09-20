Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1ITNvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:51:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:37870 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1ITNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:51:38 -0400
Date: Tue, 20 Sep 2011 15:51:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Valdis.Kletnieks@vt.edu
cc: Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@gentwo.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <27409.1316522696@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.2.02.1109201549520.2723@ionos>
References: <20110919212040.745370781@goodmis.org> <alpine.DEB.2.00.1109191644190.19059@router.home>            <1316487977.29966.32.camel@gandalf.stny.rr.com> <27409.1316522696@turing-police.cc.vt.edu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Valdis.Kletnieks@vt.edu wrote:

> On Mon, 19 Sep 2011 23:06:17 EDT, Steven Rostedt said:
> 
> > It is really confusing to know which version to use. I'm confused by the
> > this_cpu_*() compared with __this_cpu_*(). I'm guessing that most places
> > should use __this_cpu*(). But really this_cpu() should be the default,
> > and the places that can have it outside of preemption should have
> > another name. Maybe use the raw_this_cpu() or safe_this_cpu(), as there
> > is an irqsafe_this_cpu(). Maybe make a preemptsafe_cpu_*(). There should
> > only be a very few locations that are OK to have preemption enabled when
> > calling the this_cpu() code. Lets have those have the funny names and
> > not be the default "this_cpu_*()".
> 
> What's the latency hit on those very few locations if we simply put our
> collective foot down and not support a preemptable version of this_cpu_*()?
> "Yes, you *could* preempt here, but for our collective sanity that's not
> supported"...

Full ack.
 
> > All this_cpu*() code, except the funny named ones, should make sure
> > preemption is disabled, otherwise give a nasty warning. As that is
> > usually a bug if you are using a per cpu variable and can migrate away.
> > The next reference to that value may be incorrect.
> 
> You get a much prettier diffstat if you just nuke the funny named ones. ;)

Along with the maze of completely unused incarnations.
 
> But of course it's early morning and I'm still caffeine-deficient and probably
> overlooking some crucial use case. ;)

I doubt that.

Thanks,

	tglx
