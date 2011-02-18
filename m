Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1BRPT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:19:59 -0500
Received: from mail.openrapids.net ([64.15.138.104]:45771 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751332Ab1BRPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:19:57 -0500
Date: Fri, 18 Feb 2011 10:19:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Dominique Toupin <dominique.toupin@ericsson.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
	for x86_64 right now)
Message-ID: <20110218151954.GA27834@Krystal>
References: <20110209200249.111932716@goodmis.org> <4D5D1672.6070206@hitachi.com> <1297948703.23343.907.camel@gandalf.stny.rr.com> <4D5D4013.4070602@hitachi.com> <1297957591.23343.921.camel@gandalf.stny.rr.com> <4D5D47C0.9020206@hitachi.com> <1297973501.23343.953.camel@gandalf.stny.rr.com> <4D5E5BCF.1040509@hitachi.com> <1298041659.23343.956.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298041659.23343.956.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:17:31 up 86 days, 20:20,  4 users,  load average: 0.12, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Dominique Toupin, from Ericsson, to CC list]

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2011-02-18 at 20:45 +0900, Masami Hiramatsu wrote:
> > (2011/02/18 5:11), Steven Rostedt wrote:
> > > On Fri, 2011-02-18 at 01:07 +0900, Masami Hiramatsu wrote:
> > > 
> > >> I just thought that frequent stop-machine is not so good from the user's
> > >> POV. I agree that disabled probe ignoring the call is enough.
> > >> Maybe, it could be done with the similar mechanism of jump optimization.
> > > 
> > > I thought jump optimization still calls stop_machine too?
> > 
> > Yes, but now it does batch optimization.
> > Even if hundreds kprobes are registered separately, jump optimization
> > has been done in background with a stop_machine per every 256 probes.
> > (Until optimizing, kprobes can use breakpoints instead)
> 
> But a single optimized kprobe still must use stopmachine.
> 
> But it is true that the function tracer does it as one big shot. That
> is, it will do all functions in a single stop machine that needs to be
> changed. It too is batched, but there is not a limit to that batch.
> 
> I would be interested in hearing from users and real use cases that
> someone would like to trace functions but stopmachine is too big of a
> hammer.

Hi Steven,

Telecom end users are one of such cases where the latency induced by stop
machine while the system is running is a problem. Dominique Toupin could
certainly tell us more about Ericsson's use-cases.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
