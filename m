Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0ESSKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:10:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39997 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab0ESSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:10:07 -0400
Date: Wed, 19 May 2010 20:10:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] Unified Ring Buffer (Next Generation)
Message-ID: <20100519181001.GC18073@basil.fritz.box>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274291514.26328.930.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:51:54PM -0400, Steven Rostedt wrote:

Hi Steven,

> More than a year and a half ago (September 2008), at Linux Plumbers, we
> had a meeting with several kernel developers to come up with a unified
> ring buffer. A generic ring buffer in the kernel that any subsystem
> could use. After coming up with a set of requirements, I worked on

If we take a step back.

Why do you want a single ring buffer for everyone?

A lot more low profile subsystems subsystems simply use kfifo
(which is also actively developed by Stefanie). In fact there
are far more users of it than of your ring buffer. And it's 
really quite simple and easy to use. And it works fine for them.

I don't think it's that great a goal to have a single ring buffer
for all possible ring buffer needs. After all the requirements
are quite different.

Some want a simple ring buffer with minimal overhead
and simple interface, others need a mmaped one or have other special 
requirements. One size doesn't fit all. 

It's also not that we're talking about gigantic amounts of code
in all cases where there is a pressing need to unify.

If perf's current ring buffer works for it why not keep using it? 

One problem I always had with your version was that it's quite 
bloated frankly, especially in terms of code size, but 
also in its data structures and in the interface complexity.

For debugging kernels etc. with tracing that's not that big an issue, but
I think it's a problem for "non debugging" use. After all Linux
still has the goal to be at least configurable as a low footprint operating
system.

Part of the reason for its big code size seems to be that 
it tries to support everyone's requirements, which unsurprisingly
leads to some bloat both in implementation and interface.

Also to be honest it's so clever now that at least I have
a hard time understanding it, and I personally prefer code
that I can understand over too clever code. After all if there
is a bug in there and you need to be more clever than the programmer
to debug it, how would that be done? 

Perhaps a better goal would be to have a smaller simpler more
maintainable buffer for ftrace and let the other users their own?

Just my 0.05 cent.

-Andi

