Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab1GANDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:03:24 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45923 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1GANDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:03:19 -0400
Date: Fri, 1 Jul 2011 18:33:13 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [BUG] kprobes crashing because of preempt count
Message-ID: <20110701130313.GA10935@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1309440213.26417.76.camel@gandalf.stny.rr.com> <4E0D1EE3.6080607@hitachi.com> <20110701113626.GB23752@in.ibm.com> <4E0DB6FC.20904@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0DB6FC.20904@hitachi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 09:01:00PM +0900, Masami Hiramatsu wrote:
> (2011/07/01 20:36), Ananth N Mavinakayanahalli wrote:
> > On Fri, Jul 01, 2011 at 10:12:03AM +0900, Masami Hiramatsu wrote:
> >> (2011/06/30 22:23), Steven Rostedt wrote:
> > 
> > ...
> > 
> >>> Do we really need to have preemption disabled throughout this? Is it
> >>> because we don't want to migrate or call schedule? Not sure what the
> >>> best way to fix this is. Perhaps we add a kprobe_preempt_disable() that
> >>> is checked as well?
> >>
> >> I think the best way to do that is just removing preemption disabling
> >> code, because
> >> - breakpoint exception itself disables interrupt (at least on x86)
> >> - While single stepping, interrupts also be disabled.
> > 
> > On 64-bit powerpc, kprobe handlers are run with interrupts enabled
> > (MSR_EE = 1), but most instructions (including loads/stores) are
> > emulated, so for the most part, we don't take the sstep exception.
> 
> Yeah, it seems that same thing is done on arm too. And I'm sure that
> However, I'm still not sure that entire int3 exec path can run without
> calling inc_preempt_count.
> It seems that the function is very primitive, and I doubt we can
> allow to put kprobes on that...

Right. I think all preempt manipulation routines need to be __kprobes.

Also, Steve is testing the -rt tree where artefacts related to
locking/preemption are possibly quite different from the mainline that
may also be at play here.

Ananth
