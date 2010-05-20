Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0ETNsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:48:42 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51546 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753102Ab0ETNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:48:41 -0400
Date: Thu, 20 May 2010 09:48:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20100520134838.GA26573@Krystal>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100519181001.GC18073@basil.fritz.box> <20100519184745.GA19522@Krystal> <20100520064139.GA15946@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520064139.GA15946@basil.fritz.box>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:46:38 up 117 days, 16:23,  9 users,  load average: 1.13, 1.23,
	1.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > The plan here is to create a ring buffer that supports per-buffer instance
> > "flags" that specify what must be supported: e.g. either splice() or mmap(),
> > global vs per-cpu buffers, etc.
> 
> And you plan to test all those flags in the hot path? 

No, I plan to make the hot path inline in the caller, so the flags can
statically select the proper behavior at compile-time. We can test flags
dynamically on the slow-path to save space.

[...]

> > 
> > But all in all, I think users needing _something_ to perform system-wide tracing
> > shout a lot louder than users who need to save a few bytes. So let's try to get
> > something good in first, while keeping an eye on the object size, and if it
> > happens to be too large for some users, then they can always implement a
> > slower and less efficient ring_buffer_tiny.c if they feel like it.
> 
> They don't need to, they already have kfifo.
> 

Right.

> > I totally agree with you. This is in good part why I spent a large part of 2009
> > writing papers explaining my ring buffer, doing Promela models and formal proofs
> > of correctness. I think after all that work, the abstractions I will use will be
> > much easier to grap by anyone willing to do a bit of reading.
> 
> Writing papers is not a replacement for simple maintainable code.

True. I rather mean "in addition to simple maintainable code".

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
