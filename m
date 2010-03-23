Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0CWM1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:27:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47224 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752416Ab0CWM1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:27:50 -0400
Date: Tue, 23 Mar 2010 08:27:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@MIT.EDU>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Douglas Santos <douglas.santos@polymtl.ca>
Subject: Re: [PATCH 0/18] Allow different tracers to be compiled
	independently
Message-ID: <20100323122747.GA14954@Krystal>
References: <1269304340-25372-1-git-send-email-jack@suse.cz> <20100323010419.GA8292@nowhere> <DA3F0457-83D6-4A95-AC86-188BC1C9B2F0@mit.edu> <20100323080526.GB4848@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323080526.GB4848@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:18:57 up 59 days, 14:56,  4 users,  load average: 1.25, 1.09,
	1.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Theodore Tso <tytso@MIT.EDU> wrote:
> 
> > 
> > On Mar 22, 2010, at 9:04 PM, Frederic Weisbecker wrote:
> > > 
> > > I don't know. Yeah this first looks like a good idea but once 
> > > CONFIG_EVENT_TRACING is enabled, each tracepoint is a lightweight thing 
> > > and induce a tiny overhead, probably hard to notice, and this is going to 
> > > be even more the case after the jmp label optimization patches.
> > > 
> > > I liked the fact we had a general tracing kernel once the above config is 
> > > selected. And we don't bother telling people that to use tool X you need 
> > > CONFIG_EVENT_Y, and you need to rebuild your kernel, etc...
> > 
> > Indeed, a lot of the value of tracepoints goes away if people are compiling 
> > kernels without them and we need to get a special "tracing kernel" installed 
> > before we can debug a problem.
> > 
> > So I'd hope we can do the necessary optimization work so people don't feel 
> > it's necessary to enable or disable tracepoints by subsystem....
> 
> Yeah, agreed. Ultra-embedded can disable them all, but other than that i think 
> we should not make it too finegrained as a lot of tooling value is in the 
> 'critical mass' that tracepoints have achieved. The power events tracepoints 
> are most useful when combined with scheduling events, etc.
> 

We're in complete agreement here. When I considered if it was worth it to create
such a per-tracepoint group compile-time disabling in the first place, I decided
not to do it precisely due to the added-value that comes with the availability
of system-wide tracepoints. And I think with the static jump patching, we are
now at a point where the overhead is stunningly low.

Now, space-wise, the one thing I would consider appropriate as a compromise for
small embedded systems would be to allow the TRACE_EVENT probes to be compiled
as modules.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
