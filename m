Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab0KQBhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:37:11 -0500
Received: from THUNK.ORG ([69.25.196.29]:51047 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327Ab0KQBhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:37:09 -0500
Date: Tue, 16 Nov 2010 20:37:00 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117013700.GA3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Tom Zanussi <tzanussi@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:04:40PM +0100, Thomas Gleixner wrote:
> If you've booted the new kernel you can run 'trace check' to double
> check that all events used by the tool are available:
> 
>  $ trace check
> 
>  Checking whether the kernel has all required events ...
>   ... Checking event  raw_syscalls:sys_enter:r      : ok
>   ...
>   ... Checking event  sched:sched_stat_runtime:r    : ok
>  Good: all required event types are supported by this kernel.
>  The 'trace' utility will be fully functional.

For the benefit of people who create tracepoints, what restrictions
does trace have with respect to event types, and is this anticipated
to change in the future?

> The combo diffstat of the tool is appended at the end of the mail. The
> overwhelming majority of changes is on the tooling side - it uses
> existing perf events facilities and features to implement the tool.

What about the filtering and other general features/functionality of
ftrace?  Is the anticipation that this will be ported over to perf?
What about things like blktrace?

Not that I expect all of this will be working with this initial
release, but I'm curious about the long-term roadmap of this
interface.  (Obviously subject to change as we learn more, etc.  But
I'd love to hear what your current thoughts and plans are.)

Thanks,

						- Ted  

P.S.  What about sysrq-z?  Is that going to stay with ftrace side of
the tracing architecture?
