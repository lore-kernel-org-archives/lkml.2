Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1E0MqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:46:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1E0MqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:46:10 -0400
Date: Fri, 27 May 2011 14:46:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/12] [GIT PULL] tracing: fixes
Message-ID: <20110527124603.GA3168@elte.hu>
References: <20110526152541.995963172@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526152541.995963172@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This patch set contains all fixes. Some of the fixes are to get
> rid of warnings, but I think getting rid of warnings is a good thing
> during a merge window.
> 
> What's different about this and my last pull request:
> 
> 1) I removed the two patches that were not bug fixes and put them
>    in my queue for 2.6.41/3.1/2.8.1
> 
> 2) I added two patches, one that was a bug fix that caused a
>    triple fault when PROVE_RCU was set, and the other that caused
>    problems with truncating 64bit words in the trace events.
> 
> 3) I pulled out Masami's kprobe stack trace fix because it failed
>    on other archs. My last push request, I did compile test other
>    archs, but I only used the default config. This time, I enabled
>    tracing as well (doing it both with and without tracing enabled)
>    and when tracing was enabled, I detected the problem with the lack
>    of save_stack_trace_regs() in other archs.
> 
> I tested this on x86_64 and x86_32 as well as compiled tested for
> the following archs, with and without tracing enabled:
> 
>  alpha, arm, blackfin, ia64, parsic, ppc, ppc64, sparc
> 
> The following had failures for other reason (failed without this
> patch set):
> 
>   cris, cris32, m68k, mips64, mips32, parsic64, sh, xtensa, uml.
> 
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Jiri Olsa (1):
>       jump_label: Check entries limit in __jump_label_update
> 
> Rabin Vincent (1):
>       ftrace/recordmcount: Avoid STT_FUNC symbols as base on ARM
> 
> Rakib Mullick (1):
>       x86/ftrace: Fix compiler warning in ftrace.c
> 
> Steven Rostedt (7):
>       maccess,probe_kernel: Make write/read src const void *
>       scripts/tags.sh: Fix ctags for DEFINE_EVENT()
>       scripts/tags.sh: Add magic for trace-events for etags too
>       ftrace: Have ftrace_startup() return failure code
>       tracing: Have event with function tracer check error return
>       ftrace: Set ops->flag to enabled even on static function tracing
>       ftrace: Add internal recursive checks
> 
> liubo (2):
>       tracing: Add __print_symbolic_u64 to avoid warnings on 32bit machine
>       tracing: Update btrfs's tracepoints to use u64 interface
> 
> ----
>  arch/blackfin/mm/maccess.c   |    4 ++--
>  arch/s390/mm/maccess.c       |    4 ++--
>  arch/x86/kernel/ftrace.c     |   12 ++++++------
>  include/linux/ftrace_event.h |   12 ++++++++++++
>  include/linux/sched.h        |    2 +-
>  include/linux/uaccess.h      |    8 ++++----
>  include/trace/events/btrfs.h |    4 ++--
>  include/trace/ftrace.h       |   13 +++++++++++++
>  kernel/jump_label.c          |   18 +++++++++++++-----
>  kernel/trace/ftrace.c        |   31 ++++++++++++++++++++++++-------
>  kernel/trace/ring_buffer.c   |   10 +++++-----
>  kernel/trace/trace.h         |   15 +++++++++++++++
>  kernel/trace/trace_events.c  |    7 ++++++-
>  kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
>  mm/maccess.c                 |    8 ++++----
>  scripts/recordmcount.h       |    8 ++++++++
>  scripts/tags.sh              |    6 ++++--
>  17 files changed, 148 insertions(+), 41 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
