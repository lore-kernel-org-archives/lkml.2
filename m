Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0ESTFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:05:09 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37996 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752561Ab0ESTFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:05:06 -0400
Date: Wed, 19 May 2010 15:05:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] Unified Ring Buffer (Next Generation)
Message-ID: <20100519190504.GB19522@Krystal>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274291514.26328.930.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:56:33 up 116 days, 21:33,  9 users,  load average: 0.35, 0.27,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> Unfortunately, we are now back with more than one ring buffer in the
> kernel. What's worse, neither of them can perform all the features
> needed. This is putting a bit of stress on the users of these tools, not
> to mention the stress on the developers as well.
[...]
> This email is about finding a solution to the problem. If we can once
> again create a generic ring buffer that handles all requirements, then
> we can also merge the functionality of ftrace into perf, and lower the
> duplication of code within the kernel.
> 
> 
> This time around, I'm asking Mathieu Desnoyers to come to the plate, and
> see if he can handle the task.
> 
> I'm hoping that this email will start a thread that gets everyone into
> agreement and produces something that will make everyone happy.

I also hope this will get us to a state of concensus.

For the records: I'm willing to handle that task. I plan to use the

  git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-ringbuffer.git

git tree to publish my work (and to submit occasional rounds of patches to LKML
too)

The current state of that tree is that it includes only the bare-bone ring
buffer core, without the filesystem operations, only for per-cpu buffers, and
still needs a bit of cleanup. It's currently in kernel/trace/, but, as we
discussed, it's probably better if I move it to kernel/ringbuffer/, because it
does not have to be tied specifically to tracers. I'm doing it with tracing in
mind, but it could be reused as generic ring buffer in the future.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
