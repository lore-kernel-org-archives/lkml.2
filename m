Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0KRCiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:38:15 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35699 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751244Ab0KRCiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:38:14 -0500
Date: Wed, 17 Nov 2010 21:38:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        pierre-marc.fournier@polymtl.ca, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] New tools: lttngtrace and lttngreport
Message-ID: <20101118023809.GA700@Krystal>
References: <20101115134243.GA2772@Krystal> <20101115160745.GA7203@Krystal> <87y68sqiyb.fsf@basil.nowhere.org> <20101117173124.GB13717@Krystal> <20101117220152.GA2915@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117220152.GA2915@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:33:09 up 56 days,  6:35,  4 users,  load average: 0.09, 0.05,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Well, I'm afraid the collection approach "trace" is currently taking won't allow 
> > this kind of dependency wakeup chain tracking, because they focus on tracing 
> > operations happening on a thread and its children, but the reality is that the 
> > wakeup chains often spread outside of this scope.
> >
> > This is why lttngtrace gathers a system-wide trace even though we're mostly 
> > intested in the wait/wakeups of a specific PID.
> 
> Mathieu, what you say is factually wrong - of course perf events allows
> system-wide tracing, it always did.

Ah, good to know. Reading through your announcement, I thought that the "trace"
tool was only following processes and their children (I know that perf allows
system-wide tracing). However, there seems to be some incompatibilities between
the will to make the "trace" tool usable from non-root users and the will to
gather a system-wide trace.

I'm actually struggling with the same issue with lttngtrace. So far, I've taken
the approach to only allow root to perform this kind of operation, which is much
more limiting than what strace currently does.

I was wondering if you had thought about this problem.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
