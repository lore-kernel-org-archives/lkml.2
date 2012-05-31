Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2EaI0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:26:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48391 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2EaI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:26:10 -0400
Message-ID: <4FC72B9F.3040301@linaro.org>
Date: Thu, 31 May 2012 12:28:15 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: Perf record format portability
References: <4FB275EB.5050904@linaro.org> <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org> <20120516145927.GC7864@infradead.org> <1337187503.6724.50.camel@gandalf.stny.rr.com> <4FB4885F.4000002@linaro.org> <1337255326.6724.92.camel@gandalf.stny.rr.com> <4FB5E2AA.1030907@linaro.org> <20120529151020.GB10334@infradead.org>
In-Reply-To: <20120529151020.GB10334@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------080209030205070807090402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080209030205070807090402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/29/2012 07:10 PM, Arnaldo Carvalho de Melo wrote:

> I haven't tested this, but libtraceevent is now in, perhaps it works for
> you now? Can you check?

It doesn't work. Attempt to do 'perf report' on ARM for the data collected on
x86 shows 'unknown:unknown' for event names (see report_x86_on_ARM.txt),
and 'perf report' on x86 for the data collected on ARM shows invalid event names
(see report_ARM_on_x86.txt).

Dmitry

--------------080209030205070807090402
Content-Type: text/plain; charset=UTF-8;
 name="report_x86_on_ARM.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="report_x86_on_ARM.txt"

# ========
# captured on: Thu May 31 08:15:47 2012
# hostname : notebook
# os release : 3.3.7-1.fc16.x86_64
# perf version : 3.4.9208.gaf56e0
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz
# cpuid : GenuineIntel,6,42,7
# total memory : 3934652 kB
# cmdline : /tmp/perf record -a -R -f -m 8192 -c 1 -e sched:sched_switch -e sched:sched_process_exit -e sched:sched_process_fork -e sched:sched_wakeup -e sched:sched_migrate_task /bin/ls -la / 
# event : name = sched:sched_switch, type = 2, config = 0x117, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 45, 46, 47, 48 }
# event : name = sched:sched_process_exit, type = 2, config = 0x114, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 49, 50, 51, 52 }
# event : name = sched:sched_process_fork, type = 2, config = 0x111, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 53, 54, 55, 56 }
# event : name = sched:sched_wakeup, type = 2, config = 0x119, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 57, 58, 59, 60 }
# event : name = sched:sched_migrate_task, type = 2, config = 0x116, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 61, 62, 63, 64 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# ========
#
# Samples: 223  of event 'unknown:unknown'
# Event count (approx.): 223
#
# Overhead      Command      Shared Object          Symbol
# ........  ...........  .................  ..............
#
    25.56%           ls  [kernel.kallsyms]  [k] __schedule
    25.11%      swapper  [kernel.kallsyms]  [k] __schedule
    24.66%  kworker/1:1  [kernel.kallsyms]  [k] __schedule
    23.77%        urxvt  [kernel.kallsyms]  [k] __schedule
     0.45%         perf  [kernel.kallsyms]  [k] __schedule
     0.45%  migration/2  [kernel.kallsyms]  [k] __schedule


# Samples: 1  of event 'unknown:unknown'
# Event count (approx.): 1
#
# Overhead  Command      Shared Object       Symbol
# ........  .......  .................  ...........
#
   100.00%       ls  [kernel.kallsyms]  [k] do_exit


# Samples: 0  of event 'unknown:unknown'
# Event count (approx.): 0
#
# Overhead  Command  Shared Object  Symbol
# ........  .......  .............  ......
#


# Samples: 138  of event 'unknown:unknown'
# Event count (approx.): 138
#
# Overhead      Command      Shared Object              Symbol
# ........  ...........  .................  ..................
#
    60.87%           ls  [kernel.kallsyms]  [k] ttwu_do_wakeup
    38.41%  kworker/1:1  [kernel.kallsyms]  [k] ttwu_do_wakeup
     0.72%         perf  [kernel.kallsyms]  [k] ttwu_do_wakeup


# Samples: 2  of event 'unknown:unknown'
# Event count (approx.): 2
#
# Overhead      Command      Shared Object            Symbol
# ........  ...........  .................  ................
#
    50.00%         perf  [kernel.kallsyms]  [k] set_task_cpu
    50.00%  migration/2  [kernel.kallsyms]  [k] set_task_cpu


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--------------080209030205070807090402
Content-Type: text/plain; charset=UTF-8;
 name="report_ARM_on_x86.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="report_ARM_on_x86.txt"

# ========
# captured on: Thu May 31 12:19:45 2012
# hostname : linaro-developer
# os release : 3.4.0+
# perf version : 3.4.0
# arch : armv7l
# nrcpus online : 2
# nrcpus avail : 2
# cpudesc : ARMv7 Processor rev 2 (v7l)
# total memory : 1022872 kB
# cmdline : /usr/bin/perf record -a -R -f -m 8192 -c 1 -e sched:sched_switch -e sched:sched_process_exit -e sched:sched_process_fork -e sched:sched_wakeup -e sched:sched_migrate_task /bin/ls -la / 
# event : name = sched:sched_switch, type = 2, config = 0x37, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 11, 12 }
# event : name = sched:sched_process_exit, type = 2, config = 0x34, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 13, 14 }
# event : name = sched:sched_process_fork, type = 2, config = 0x31, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 15, 16 }
# event : name = sched:sched_wakeup, type = 2, config = 0x39, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 17, 18 }
# event : name = sched:sched_migrate_task, type = 2, config = 0x36, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 19, 20 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# ========
#
# Samples: 148  of event 'syscalls:sys_exit_unshare'
# Event count (approx.): 148
#
# Overhead      Command     Shared Object  Symbol
# ........  ...........  ................  ......
#
    38.51%           ls  [unknown]         [.] 0000000000000000              
    37.84%  kworker/1:1  [unknown]         [.] 0000000000000000              
    12.16%      swapper  [unknown]         [.] 0000000000000000              
    10.81%         sshd  [unknown]         [.] 0000000000000000              
     0.68%         perf  [unknown]         [.] 0000000000000000              


# Samples: 1  of event 'raw_syscalls:sys_exit'
# Event count (approx.): 1
#
# Overhead  Command     Shared Object  Symbol
# ........  .......  ................  ......
#
   100.00%       ls  [unknown]         [.] 0000000000000000              


# Samples: 0  of event 'syscalls:sys_exit_mmap'
# Event count (approx.): 0
#
# Overhead  Command  Shared Object  Symbol
# ........  .......  .............  ......
#


# Samples: 103  of event 'syscalls:sys_exit_set_tid_address'
# Event count (approx.): 103
#
# Overhead      Command     Shared Object  Symbol
# ........  ...........  ................  ......
#
    80.58%           ls  [unknown]         [.] 0000000000000000              
    15.53%  kworker/1:1  [unknown]         [.] 0000000000000000              
     1.94%         sshd  [unknown]         [.] 0000000000000000              
     0.97%      swapper  [unknown]         [.] 0000000000000000              
     0.97%         perf  [unknown]         [.] 0000000000000000              


# Samples: 1  of event 'mce:mce_record'
# Event count (approx.): 1
#
# Overhead  Command     Shared Object  Symbol
# ........  .......  ................  ......
#
   100.00%  swapper  [unknown]         [.] 0000000000000000              


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--------------080209030205070807090402--
