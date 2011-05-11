Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1EKREx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:04:53 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:50316 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab1EKREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:04:52 -0400
Date: Wed, 11 May 2011 16:13:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110511141342.GA19053@elte.hu>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
 <20110511140208.GD25827@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511140208.GD25827@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Wed, May 11, 2011 at 09:46:40AM -0400, Peter Zijlstra wrote:
> > On Wed, 2011-05-11 at 14:11 +0200, Borislav Petkov wrote:
> > >  include/linux/perf_event.h |  138 ++++++++++++-
> > 
> > I don't like exposing all that in a kernel wide header.. should we maybe
> > have kernel/events/internal.h?
> 
> Sounds prudent. Maybe add a patch ontop that moves all perf_event.h
> exports which are shared _only_ between kernel/events/*.c compilation
> units to an internal.h header? Ingo?

There's not that many that are in perf_event.h and are only used in 
kernel/event/core.c.

Below is a generated list of all exported functions and their usage sites. Out 
of 40 functions 7 should not be exported:

 __perf_sw_event()
 perf_swevent_put_recursion_context()
 perf_pmu_unregister()
 perf_output_copy()
 __perf_event_task_sched_in()
 __perf_event_task_sched_out()
 perf_event_read_value()

Thanks,

	Ingo


perf_bp_event():
arch/arm/kernel/hw_breakpoint.c
arch/powerpc/kernel/hw_breakpoint.c
arch/sh/kernel/hw_breakpoint.c
arch/x86/kernel/hw_breakpoint.c
include/linux/perf_event.h
kernel/events/core.c

perf_callchain_kernel():
arch/arm/kernel/perf_event.c
arch/mips/kernel/perf_event.c
arch/powerpc/kernel/perf_callchain.c
arch/sh/kernel/perf_callchain.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
include/linux/perf_event.h
kernel/events/core.c

perf_callchain_user():
arch/arm/kernel/perf_event.c
arch/mips/kernel/perf_event.c
arch/powerpc/kernel/perf_callchain.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
include/linux/perf_event.h
kernel/events/core.c

perf_event_comm():
fs/exec.c
include/linux/perf_event.h
kernel/events/core.c

perf_event_delayed_put():
include/linux/perf_event.h
kernel/events/core.c
kernel/exit.c

perf_event_disable():
arch/powerpc/kernel/hw_breakpoint.c
include/linux/perf_event.h
kernel/events/core.c
kernel/events/hw_breakpoint.c
kernel/watchdog.c

perf_event_enable():
include/linux/perf_event.h
kernel/events/core.c
kernel/events/hw_breakpoint.c
kernel/watchdog.c

perf_event_exit_task():
fs/exec.c
include/linux/perf_event.h
kernel/events/core.c
kernel/exit.c

perf_event_fork():
include/linux/perf_event.h
kernel/events/core.c
kernel/fork.c

perf_event_free_task():
include/linux/perf_event.h
kernel/events/core.c
kernel/fork.c

perf_event_init():
arch/alpha/kernel/perf_event.c
arch/arm/kernel/perf_event.c
arch/mips/kernel/perf_event.c
arch/mips/kernel/perf_event_mipsxx.c
arch/sh/kernel/perf_event.c
include/linux/perf_event.h
init/main.c
kernel/events/core.c
kernel/fork.c
tools/perf/design.txt

perf_event_init_task():
include/linux/perf_event.h
kernel/events/core.c
kernel/fork.c

perf_event_mmap():
include/linux/perf_event.h
kernel/events/core.c
mm/mmap.c
mm/mprotect.c
tools/perf/design.txt
tools/perf/perf.h
tools/perf/util/event.c

perf_event_overflow():
arch/alpha/kernel/perf_event.c
arch/arm/kernel/perf_event_v6.c
arch/arm/kernel/perf_event_v7.c
arch/arm/kernel/perf_event_xscale.c
arch/mips/kernel/perf_event.c
arch/powerpc/kernel/perf_event.c
arch/powerpc/kernel/perf_event_fsl_emb.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
arch/x86/kernel/cpu/perf_event_intel.c
arch/x86/kernel/cpu/perf_event_intel_ds.c
arch/x86/kernel/cpu/perf_event_p4.c
include/linux/perf_event.h
kernel/events/core.c

perf_event_print_debug():
arch/alpha/kernel/perf_event.c
arch/powerpc/kernel/perf_event.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
arch/x86/kernel/cpu/perf_event_intel.c
drivers/tty/sysrq.c
include/linux/perf_event.h
kernel/events/core.c

perf_event_read_value():
include/linux/perf_event.h
kernel/events/core.c

perf_event_release_kernel():
drivers/oprofile/oprofile_perf.c
include/linux/perf_event.h
kernel/events/core.c
kernel/events/hw_breakpoint.c
kernel/watchdog.c

perf_event_task_disable():
include/linux/perf_event.h
kernel/events/core.c
kernel/sys.c

perf_event_task_enable():
include/linux/perf_event.h
kernel/events/core.c
kernel/sys.c

__perf_event_task_sched_in():
include/linux/perf_event.h
kernel/events/core.c

__perf_event_task_sched_out():
include/linux/perf_event.h
kernel/events/core.c

perf_event_task_tick():
include/linux/perf_event.h
kernel/events/core.c
kernel/sched.c

perf_event_update_userpage():
arch/alpha/kernel/perf_event.c
arch/arm/kernel/perf_event.c
arch/mips/kernel/perf_event.c
arch/powerpc/kernel/perf_event.c
arch/powerpc/kernel/perf_event_fsl_emb.c
arch/sh/kernel/perf_event.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
include/linux/perf_event.h
kernel/events/core.c

perf_num_counters():
arch/arm/kernel/perf_event.c
arch/sh/kernel/perf_event.c
arch/sh/oprofile/common.c
drivers/oprofile/oprofile_perf.c
include/linux/perf_event.h

perf_output_begin():
arch/x86/kernel/cpu/perf_event_intel_ds.c
include/linux/perf_event.h
kernel/events/core.c

perf_output_copy():
include/linux/perf_event.h
kernel/events/core.c

perf_output_end():
arch/x86/kernel/cpu/perf_event_intel_ds.c
include/linux/perf_event.h
kernel/events/core.c

perf_output_sample():
arch/x86/kernel/cpu/perf_event_intel_ds.c
include/linux/perf_event.h
kernel/events/core.c

perf_pmu_disable():
arch/alpha/kernel/perf_event.c
arch/arm/kernel/perf_event.c
arch/mips/kernel/perf_event.c
arch/powerpc/kernel/perf_event.c
arch/powerpc/kernel/perf_event_fsl_emb.c
arch/sh/kernel/perf_event.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
include/linux/perf_event.h
kernel/events/core.c

perf_pmu_enable():
arch/alpha/kernel/perf_event.c
arch/arm/kernel/perf_event.c
arch/mips/kernel/perf_event.c
arch/powerpc/kernel/perf_event.c
arch/powerpc/kernel/perf_event_fsl_emb.c
arch/sh/kernel/perf_event.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
include/linux/perf_event.h
kernel/events/core.c

perf_pmu_register():
arch/alpha/kernel/perf_event.c
arch/arm/kernel/perf_event.c
arch/mips/kernel/perf_event_mipsxx.c
arch/powerpc/kernel/perf_event.c
arch/powerpc/kernel/perf_event_fsl_emb.c
arch/sh/kernel/perf_event.c
arch/sparc/kernel/perf_event.c
arch/x86/kernel/cpu/perf_event.c
include/linux/perf_event.h
kernel/events/core.c
kernel/events/hw_breakpoint.c

perf_pmu_unregister():
include/linux/perf_event.h
kernel/events/core.c

perf_prepare_sample():
arch/x86/kernel/cpu/perf_event_intel_ds.c
include/linux/perf_event.h
kernel/events/core.c

perf_proc_update_handler():
include/linux/perf_event.h
kernel/events/core.c
kernel/sysctl.c

perf_register_guest_info_callbacks():
arch/x86/kvm/x86.c
include/linux/perf_event.h
kernel/events/core.c

__perf_sw_event():
include/linux/perf_event.h
kernel/events/core.c

perf_swevent_get_recursion_context():
include/linux/perf_event.h
kernel/events/core.c
kernel/trace/trace_event_perf.c

perf_swevent_put_recursion_context():
include/linux/perf_event.h
kernel/events/core.c

perf_tp_event():
include/linux/ftrace_event.h
include/linux/perf_event.h
include/trace/ftrace.h
kernel/events/core.c

perf_unregister_guest_info_callbacks():
arch/x86/kvm/x86.c
include/linux/perf_event.h
kernel/events/core.c
