Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0ETGlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 02:41:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51271 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0ETGlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 02:41:46 -0400
Date: Thu, 20 May 2010 08:41:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] Unified Ring Buffer (Next Generation)
Message-ID: <20100520064139.GA15946@basil.fritz.box>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100519181001.GC18073@basil.fritz.box> <20100519184745.GA19522@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519184745.GA19522@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The plan here is to create a ring buffer that supports per-buffer instance
> "flags" that specify what must be supported: e.g. either splice() or mmap(),
> global vs per-cpu buffers, etc.

And you plan to test all those flags in the hot path? 

> The new implementation I propose lessens the complexity level, presents clear
> abstractions to deal with that complexity, and comes with a formal proof of
> correctness, all of which I think is really very important to give a good level
> of insurance that the ring buffer works as expected.

Any simplifcation for the ftrace buffer would be a good thing IMHO.

> > For debugging kernels etc. with tracing that's not that big an issue, but
> > I think it's a problem for "non debugging" use. After all Linux
> > still has the goal to be at least configurable as a low footprint operating
> > system.
> 
> My implementation, at the moment, has 50% less lines of code and is 25% smaller
> in object size than the current ring buffer.

Good.

> 
> But all in all, I think users needing _something_ to perform system-wide tracing
> shout a lot louder than users who need to save a few bytes. So let's try to get
> something good in first, while keeping an eye on the object size, and if it
> happens to be too large for some users, then they can always implement a
> slower and less efficient ring_buffer_tiny.c if they feel like it.

They don't need to, they already have kfifo.

> I totally agree with you. This is in good part why I spent a large part of 2009
> writing papers explaining my ring buffer, doing Promela models and formal proofs
> of correctness. I think after all that work, the abstractions I will use will be
> much easier to grap by anyone willing to do a bit of reading.

Writing papers is not a replacement for simple maintainable code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
