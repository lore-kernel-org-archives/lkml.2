Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1LNNoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:44:15 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42689 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756498Ab1LNNoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:44:14 -0500
Date: Wed, 14 Dec 2011 08:44:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: Re: [RFC][PATCH 5/5 v2] x86: Allow NMIs to hit breakpoints in i386
Message-ID: <20111214134412.GC2882@Krystal>
References: <20111214025237.457632996@goodmis.org> <20111214025253.519573056@goodmis.org> <20111214133025.GA2882@Krystal> <1323870059.23971.23.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323870059.23971.23.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:43:44 up 385 days, 18:46,  2 users,  load average: 0.23, 0.08,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-12-14 at 08:30 -0500, Mathieu Desnoyers wrote:
> 
> > Just to make sure I understand: if an NMI nests over do_nmi between
> > nmi_postprocess() and the following iret (in which case the CPU is in
> > state NMI_NOT_RUNNING), we will end up with two NMI handlers nested on
> > the stack, right ? Given that there is no upper-bound on the nesting
> > level of this situation (although nesting like this more than once is
> > extremely unlikely), is this side-effect something we should care about
> > in terms of stack space usage ?
> 
> At that point, there's very little on the stack to begin with. Just the
> one irq frame, and saved regs, plus the stack frame of this function. If
> we are hitting that many NMIs to cause a stack overflow, then I believe
> there's more issues than the overflow itself. Say, a livelock of NMIs?

Yep, if it's small then it's fine I guess.

> 
> >  Also, is the stack dump OOPS handler
> > aware of this stack layout that was until now impossible ?
> 
> Since NMIs on i386 doesn't change the stack when interrupting the
> kernel, the OOPs handler never was aware of the NMI stack layout.

Makes sense, sounds good,

Thanks!

Mathieu

> 
> -- Steve
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
