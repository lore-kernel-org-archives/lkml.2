Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0ETKHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:07:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52905 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0ETKHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G3XPpbCkUa7MIh+kE327kUpmIsJkwQwuVTFpuWr1I0CxQgNp8C42AzbClgwSl8zhxp
         8q/n92j8Dgq1KHvEiQyUj47IddGbbA8Zc+A4XATHnTkvcTMiCI4ZRmbuIg9pCJRcG25U
         /KBBbp5p6rb4zIgVeb2PnZKmPwRlta/X3C/vQ=
Date: Thu, 20 May 2010 12:07:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20100520100732.GD5309@nowhere>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com> <20100520093131.GA30929@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520093131.GA30929@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 11:31:31AM +0200, Ingo Molnar wrote:
>  - [ While it's still a long way off, if this trend continues
>      we eventually might even be able to get rid of the 
>      /debug/tracing/ temporary debug API and get rid of 
>      the ugly in-kernel pretty-printing bits. This is 
>      good: it may make Andrew very happy for a change ;-)
> 
>      The main detail here to be careful of is that lots of
>      people are fond of the simplicity of the 
>      /debug/tracing/ debug UI, so when we replace it we 
>      want to do it by keeping that simple workflow (or 
>      best by making it even simpler). I have a few ideas 
>      how to do this.



How? We can emulate the /debug/tracing result with something
like perf trace, still that won't replace the immediate
availability of the result of any trace, which makes it
valuable for any simplest workflows.




> Regarding performance and complexity, which is our main 
> worry atm, fortunately there's work going on in that 
> direction - please see PeterZ's recent string of patches 
> on lkml:
> 
>   4f41c01: perf/ftrace: Optimize perf/tracepoint interaction for single events
>   a19d35c: perf: Optimize buffer placement by allocating buffers NUMA aware
>   ef60777: perf: Optimize the perf_output() path by removing IRQ-disables
>   fa58815: perf: Optimize the hotpath by converting the perf output buffer to local_t



I would like to highlight the following commit too that _totally_
changes the requirements of our next common ring buffer, whatever it is: 

    c792061: perf: Disallow mmap() on per-task inherited events

Now we only need to care about local contention, we have removed the
support for buffers that contend across cpus in a single process.

Do I understand it right?



> 3) Add the function-tracer and function-graph tracer
>    as an event and integrate it into perf.
> 
>    This will live-test the efficiency of the unification
>    and brings over the last big ftrace plugin to perf.


I may start to take care of this soon.

