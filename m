Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903Ab2KBOIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:08:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762774Ab2KBOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:08:32 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=KqlczPgA0IEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=YMdICt6sTIYA:10 a=VwQbUJbxAAAA:8 a=Fe8jaAz3P3G3c-r-knUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351865311.4004.136.camel@gandalf.local.home>
Subject: Re: [PATCH 00/22] [GIT PULL][3.8] tracing: updates
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Date: Fri, 02 Nov 2012 10:08:31 -0400
In-Reply-To: <20121102133251.998500247@goodmis.org>
References: <20121102133251.998500247@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 09:32 -0400, Steven Rostedt wrote:
> Ingo,

Hold off on pulling this. Fengguang found some subtle bugs in David's
patches and I'm going to rebase (again) without them. I don't want to
hold up the rest of the patches for these few bugs.

I'll post a tip/perf/core-2 soon.

-- Steve

> 
> I've been focusing on -rt related things lately and let my tracing
> queue pile up on me. I've ran these through my own vigorous tests,
> and think they are ready for 3.8.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 9b194e6cb864506da693d26149370cb7272af99f
> 
> 
> Daniel Walter (1):
>       tracing: Replace strict_strto* with kstrto*
> 
> David Sharp (4):
>       tracing: Trivial cleanup
>       tracing,x86: Add a TSC trace_clock
>       tracing: Reset ring buffer when changing trace_clocks
>       tracing: Format non-nanosec times from tsc clock without a decimal point.
> 
> Hiraku Toyooka (1):
>       tracing: Change tracer's integer flags to bool
> 
> Michal Hocko (1):
>       linux/kernel.h: Remove duplicate trace_printk declaration
> 
> Slava Pestov (1):
>       ring-buffer: Add a 'dropped events' counter
> 
> Steven Rostedt (11):
>       tracing: Allow tracers to start at core initcall
>       tracing: Expand ring buffer when trace_printk() is used
>       tracing: Enable comm recording if trace_printk() is used
>       tracing: Have tracing_sched_wakeup_trace() use standard unlock_commit
>       tracing: Cache comms only after an event occurred
>       tracing: Separate open function from set_event and available_events
>       tracing: Remove unused function unregister_tracer()
>       tracing: Make tracing_enabled be equal to tracing_on
>       tracing: Remove deprecated tracing_enabled file
>       tracing: Use irq_work for wake ups and remove *_nowake_*() functions
>       tracing: Add trace_options kernel command line parameter
> 
> Vaibhav Nagarnaik (1):
>       tracing: Cleanup unnecessary function declarations
> 
> Yoshihiro YUNOMAE (2):
>       ring-buffer: Change unsigned long type of ring_buffer_oldest_event_ts() to u64
>       tracing: Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock
> 
> ----
>  Documentation/kernel-parameters.txt  |   16 ++
>  arch/alpha/include/asm/Kbuild        |    1 +
>  arch/arm/include/asm/Kbuild          |    1 +
>  arch/arm64/include/asm/Kbuild        |    1 +
>  arch/avr32/include/asm/Kbuild        |    1 +
>  arch/blackfin/include/asm/Kbuild     |    1 +
>  arch/c6x/include/asm/Kbuild          |    1 +
>  arch/cris/include/asm/Kbuild         |    1 +
>  arch/frv/include/asm/Kbuild          |    1 +
>  arch/h8300/include/asm/Kbuild        |    1 +
>  arch/hexagon/include/asm/Kbuild      |    1 +
>  arch/ia64/include/asm/Kbuild         |    1 +
>  arch/m32r/include/asm/Kbuild         |    1 +
>  arch/m68k/include/asm/Kbuild         |    1 +
>  arch/microblaze/include/asm/Kbuild   |    1 +
>  arch/mips/include/asm/Kbuild         |    1 +
>  arch/mn10300/include/asm/Kbuild      |    1 +
>  arch/openrisc/include/asm/Kbuild     |    1 +
>  arch/parisc/include/asm/Kbuild       |    2 +-
>  arch/powerpc/include/asm/Kbuild      |    1 +
>  arch/s390/include/asm/Kbuild         |    1 +
>  arch/score/include/asm/Kbuild        |    1 +
>  arch/sh/include/asm/Kbuild           |    1 +
>  arch/sparc/include/asm/Kbuild        |    1 +
>  arch/tile/include/asm/Kbuild         |    1 +
>  arch/um/include/asm/Kbuild           |    1 +
>  arch/unicore32/include/asm/Kbuild    |    1 +
>  arch/x86/include/asm/trace_clock.h   |   16 ++
>  arch/x86/kernel/Makefile             |    1 +
>  arch/x86/kernel/trace_clock.c        |   21 ++
>  arch/xtensa/include/asm/Kbuild       |    1 +
>  include/asm-generic/trace_clock.h    |   16 ++
>  include/linux/ftrace_event.h         |   20 +-
>  include/linux/kernel.h               |    7 +-
>  include/linux/ring_buffer.h          |    3 +-
>  include/linux/trace_clock.h          |    2 +
>  include/trace/ftrace.h               |    3 +-
>  include/trace/syscall.h              |   23 --
>  kernel/trace/Kconfig                 |    1 +
>  kernel/trace/ftrace.c                |    6 +-
>  kernel/trace/ring_buffer.c           |   51 ++++-
>  kernel/trace/trace.c                 |  411 ++++++++++++++++++----------------
>  kernel/trace/trace.h                 |   18 +-
>  kernel/trace/trace_branch.c          |    4 +-
>  kernel/trace/trace_events.c          |   51 +++--
>  kernel/trace/trace_events_filter.c   |    4 +-
>  kernel/trace/trace_functions.c       |    5 +-
>  kernel/trace/trace_functions_graph.c |    6 +-
>  kernel/trace/trace_irqsoff.c         |   14 +-
>  kernel/trace/trace_kprobe.c          |   10 +-
>  kernel/trace/trace_output.c          |   80 ++++---
>  kernel/trace/trace_probe.c           |   14 +-
>  kernel/trace/trace_sched_switch.c    |    4 +-
>  kernel/trace/trace_sched_wakeup.c    |   10 +-
>  kernel/trace/trace_selftest.c        |   13 +-
>  kernel/trace/trace_syscalls.c        |   61 +++--
>  kernel/trace/trace_uprobe.c          |    2 +-
>  57 files changed, 539 insertions(+), 382 deletions(-)


