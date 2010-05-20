Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0ETLK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:10:27 -0400
Received: from www.tglx.de ([62.245.132.106]:53651 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0ETLKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:10:25 -0400
Date: Thu, 20 May 2010 13:07:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20100520100732.GD5309@nowhere>
Message-ID: <alpine.LFD.2.00.1005201256420.3368@localhost.localdomain>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100520093131.GA30929@elte.hu> <20100520100732.GD5309@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Frederic Weisbecker wrote:
> On Thu, May 20, 2010 at 11:31:31AM +0200, Ingo Molnar wrote:
> >  - [ While it's still a long way off, if this trend continues
> >      we eventually might even be able to get rid of the 
> >      /debug/tracing/ temporary debug API and get rid of 
> >      the ugly in-kernel pretty-printing bits. This is 
> >      good: it may make Andrew very happy for a change ;-)
> > 
> >      The main detail here to be careful of is that lots of
> >      people are fond of the simplicity of the 
> >      /debug/tracing/ debug UI, so when we replace it we 
> >      want to do it by keeping that simple workflow (or 
> >      best by making it even simpler). I have a few ideas 
> >      how to do this.
> 
> How? We can emulate the /debug/tracing result with something
> like perf trace, still that won't replace the immediate
> availability of the result of any trace, which makes it
> valuable for any simplest workflows.

I'm a bit torn about this. I really like the availability of the ascii
interface, but if we can come up with a very basic trace binary tool
which can be built for deep embedded w/o requiring the world and some
more libs to be available, then I might give up my resistance. Ideally
it should be done so it can be easily integrated into busybox.

I don't care whether I do

echo 1 >/debug/..../XXX/enable
cat /debug/tracing/trace

or

perfmini trace enable XXX
perfmini trace dump

as long as the tool is built in a way that it does not need updates
when we add trace points or other functionality to the kernel.

Thanks,

	tglx
