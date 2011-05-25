Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1EYSB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:01:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45239 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab1EYSB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:01:27 -0400
Date: Wed, 25 May 2011 11:01:00 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110525180100.GY19633@outflux.net>
References: <20110517131902.GF21441@elte.hu>
 <BANLkTikBK3-KZ10eErQ6Eex_L6Qe2aZang@mail.gmail.com>
 <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105251836030.3078@ionos>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 25, 2011 at 07:48:51PM +0200, Thomas Gleixner wrote:
> On Wed, 25 May 2011, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Tue, 24 May 2011, Ingo Molnar wrote:
> > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > 
> > > > > On Tue, 2011-05-24 at 10:59 -0500, Will Drewry wrote:
> > > > > >  include/linux/ftrace_event.h  |    4 +-
> > > > > >  include/linux/perf_event.h    |   10 +++++---
> > > > > >  kernel/perf_event.c           |   49 +++++++++++++++++++++++++++++++++++++---
> > > > > >  kernel/seccomp.c              |    8 ++++++
> > > > > >  kernel/trace/trace_syscalls.c |   27 +++++++++++++++++-----
> > > > > >  5 files changed, 82 insertions(+), 16 deletions(-) 
> > > > > 
> > > > > I strongly oppose to the perf core being mixed with any sekurity voodoo
> > > > > (or any other active role for that matter).
> > > > 
> > > > I'd object to invisible side-effects as well, and vehemently so. But note how 
> > > > intelligently it's used here: it's explicit in the code, it's used explicitly 
> > > > in kernel/seccomp.c and the event generation place in 
> > > > kernel/trace/trace_syscalls.c.
> > > > 
> > > > So this is a really flexible solution IMO and does not extend events with some 
> > > > invisible 'active' role. It extends the *call site* with an open-coded active 
> > > > role - which active role btw. already pre-existed.
> > > 
> > > We do _NOT_ make any decision based on the trace point so what's the
> > > "pre-existing" active role in the syscall entry code?
> > 
> > The seccomp code we are discussing in this thread.
> 
> That's proposed code and has absolutely nothing to do with the
> existing trace point semantics.
>  
> > > I'm all for code reuse and reuse of interfaces, but this is completely
> > > wrong. Instrumentation and security decisions are two fundamentally
> > > different things and we want them kept separate. Instrumentation is
> > > not meant to make decisions. Just because we can does not mean that it
> > > is a good idea.
> > 
> > Instrumentation does not 'make decisions': the calling site, which is 
> > already emitting both the event and wants to do decisions based on 
> > the data that also generates the event wants to do decisions.
> 
> You can repeat that as often as you want, it does not make it more
> true. Fact is that the decision is made in the middle of the perf code.

Can we just go back to the original spec? A lot of people were excited
about the prctl() API as done in Will's earlier patchset, we don't lose the
extremely useful "enable_on_exec" feature, and we can get away from all
this disagreement.

-Kees

-- 
Kees Cook
Ubuntu Security Team
