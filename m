Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0D1OrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:47:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab0D1OrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:47:15 -0400
Message-ID: <4BD84A27.6010504@redhat.com>
Date: Wed, 28 Apr 2010 10:45:59 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10][RFC] tracing: Lowering the footprint of TRACE_EVENTs
References: <20100426195024.256424113@goodmis.org>
In-Reply-To: <20100426195024.256424113@goodmis.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> This is an RFC patch set that also affects kprobes and perf.
> 
> At the Linux Collaboration Summit, I talked with Mathieu and others about
> lowering the footprint of trace events. I spent all of last week
> trying to get the size as small as I could.
> 
> Currently, each TRACE_EVENT() macro adds 1 - 5K per tracepoint. I got various
> results by adding a TRACE_EVENT() with the compiler, depending on
> config options that did not seem related. The new tracepoint I added
> would add between 1 and 5K, but I did not investigate enough to
> see what the true size was.
> 
> What was consistent, was the DEFINE_EVENT(). Currently, it adds
> a little over 700 bytes per DEFINE_EVENT().
> 
> This patch series does not seem to affect TRACE_EVENT() much (had
> the same various sizes), but consistently brings DEFINE_EVENT()s
> down from 700 bytes to 250 bytes per DEFINE_EVENT(). Since syscalls
> use one "class" and are equivalent to DEFINE_EVENT() this can
> be a significant savings.
> 
> With events and syscalls (82 events and 616 syscalls), before this
> patch series, the size of vmlinux was: 16161794, and afterward: 16058182.
> 
> That is 103,612 bytes in savings! (over 100K)
> 
> 
> Without tracing syscalls (82 events), it brought the size of vmlinux
> down from 1591046 to 15999394.
> 
> 22,071 bytes in savings.
> 
> This is just an RFC (for now), to get peoples opinions on the changes.
> It does a bit of rewriting of the CPP macros, just to warning you ;-)

Hm, at least for kprobe tracer, this change is ok, 
even though it isn't much worth as for tracepoints.
I think, if we have ftrace_event_ops, it will help reducing
the size of dynamic events a bit (not so much).


Thank you,


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
