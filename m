Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1LMT0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:26:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35444 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab1LMT0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:26:09 -0500
Date: Tue, 13 Dec 2011 20:26:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
Message-ID: <20111213192556.GD2421@somewhere.redhat.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 04:52:18PM -0500, Seiji Aguchi wrote:
> Hi,
> 
> I'm interested in these tracepoints.
> But this patch removed from -mm tree for some reason.
> 
> http://www.spinics.net/lists/mm-commits/msg85707.html
> 
> Do you plan to update it and push to upstream?

Oh weird. Doesn't seem to be in -tip either. Anybody has
any clue about where this patch went?

> 
> >@@ -859,7 +860,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
> > 	 */
> > 	exit_idle();
> > 	irq_enter();
> >+	trace_irq_vector_entry(LOCAL_TIMER_VECTOR);
> > 	local_apic_timer_interrupt();
> >+	trace_irq_vector_exit(LOCAL_TIMER_VECTOR);
> > 	irq_exit();
> 
> It would be better if you add "regs" to the argument of trace_irq_vector_entry()/ trace_irq_vector_exit().
> 
> With "regs", we are able to know what part of the system CPUs execute periodically. 
> This information really helps us find a root cause of system slowdown or hung up.

What about using perf for that?

Just run:

	perf record -ag
	^C
	perf report

And you should find in the callchains some informations about where your CPUs
are spending time.

If you system is too slow for that but you're doing background tracing with
ftrace, you can use stacktrace with ftrace.

If it's hung up then we have the watchdog lockup detector.
