Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0ETLnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:43:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50201 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab0ETLnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:43:05 -0400
Date: Thu, 20 May 2010 13:42:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [RFD] Future tracing/instrumentation directions
Message-ID: <20100520114218.GA15531@elte.hu>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
 <20100520093131.GA30929@elte.hu>
 <20100520100732.GD5309@nowhere>
 <alpine.LFD.2.00.1005201256420.3368@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005201256420.3368@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 20 May 2010, Frederic Weisbecker wrote:
> > On Thu, May 20, 2010 at 11:31:31AM +0200, Ingo Molnar wrote:
> > >  - [ While it's still a long way off, if this trend continues
> > >      we eventually might even be able to get rid of the 
> > >      /debug/tracing/ temporary debug API and get rid of 
> > >      the ugly in-kernel pretty-printing bits. This is 
> > >      good: it may make Andrew very happy for a change ;-)
> > > 
> > >      The main detail here to be careful of is that lots of
> > >      people are fond of the simplicity of the 
> > >      /debug/tracing/ debug UI, so when we replace it we 
> > >      want to do it by keeping that simple workflow (or 
> > >      best by making it even simpler). I have a few ideas 
> > >      how to do this.
> > 
> > How? We can emulate the /debug/tracing result with something
> > like perf trace, still that won't replace the immediate
> > availability of the result of any trace, which makes it
> > valuable for any simplest workflows.
> 
> I'm a bit torn about this. I really like the availability of the ascii
> interface, but if we can come up with a very basic trace binary tool
> which can be built for deep embedded w/o requiring the world and some
> more libs to be available, then I might give up my resistance. Ideally
> it should be done so it can be easily integrated into busybox.
> 
> I don't care whether I do
> 
> echo 1 >/debug/..../XXX/enable
> cat /debug/tracing/trace
> 
> or
> 
> perfmini trace enable XXX
> perfmini trace dump

My suggestion for that flow is even shorter:

  trace --enable XXX
  trace

Plus:

  trace --list
  trace --enable
  trace --disable

> as long as the tool is built in a way that it does not 
> need updates when we add trace points or other 
> functionality to the kernel.

Yeah, most definitely. The sysfs event_source class will 
ensure that whatever (new) events are available propagate 
through the tool and are available to it.

Thanks,

	Ingo
