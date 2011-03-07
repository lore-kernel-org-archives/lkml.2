Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1CGI2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:28:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:32839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1CGI16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:27:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,276,1297065600"; 
   d="scan'208";a="609822724"
Subject: Re: [RFC -tip] perf, x86: P4 PMU -- Address erratum 15 and 17
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D724D95.3060808@gmail.com>
References: <4D7141FC.8000504@gmail.com> <1299334487.2324.1.camel@localhost>
	 <4D724D95.3060808@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 16:27:32 +0800
Message-ID: <1299486452.2908.47.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 22:49 +0800, Cyrill Gorcunov wrote:
> On 03/05/2011 05:14 PM, Lin Ming wrote:
> > On Sat, 2011-03-05 at 03:48 +0800, Cyrill Gorcunov wrote:
> >> Errata N15 and 17 of 249199-071 should be taken
> >> into account. They are mostly hard to hit at moment
> >> i believe but still better to be fixed.
> >>
> >> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> >> ---
> >>
> >> Ming, mind to give it a shot? I seems will be able to test myself
> >> at Wednesday only. And I would like to get a review first to eliminate
> >> some silly mistakes ;)
> > 
> > I'll test this next Monday when I back to office.
> > 
> > Thanks.
> > 
> 
> Great, no hurry.

This patch causes problem.

# perf top -e instructions

Pid: 1963, comm: perf Not tainted 2.6.38-rc7-tip-mlin+ #88 Dell Computer
Corporation Dimension 4600               /02Y832
EIP: 0060:[<c010ee9e>] EFLAGS: 00210016 CPU: 0
EIP is at p4_pmu_disable_all+0x54/0xfa
EAX: ffffffff EBX: 0000000c ECX: 00000318 EDX: f6627c00
ESI: f6627cc8 EDI: 00000318 EBP: f5b99ccc ESP: f5b99ca0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process perf (pid: 1963, ti=f5b98000 task=f548d7c0 task.ti=f5b98000)
Stack:
 00000000 00000000 f6627c00 c01265bd 0000000c f68014e0 8061b54b 000000db
 00000000 f6807abc 00000000 f5b99cd4 c010e499 f5b99cdc c0189993 f5b99d08
 c018ec40 f6803600 f68036e4 f6807ba0 00000000 003d09fa 00000000 c0710380
Call Trace:
 [<c01265bd>] ? cpuacct_charge+0x72/0x7a
 [<c010e499>] x86_pmu_disable+0x3b/0x3d
 [<c0189993>] perf_pmu_disable+0x1c/0x1e
 [<c018ec40>] perf_event_task_tick+0xd6/0x1ef
 [<c012a485>] scheduler_tick+0x9c/0x1dd
 [<c013dc6a>] update_process_times+0x4c/0x58
 [<c0156b46>] tick_sched_timer+0x6e/0x9c
 [<c014cfd0>] __run_hrtimer+0x97/0x10e
 [<c070641b>] ? _raw_spin_lock+0x22/0x2a
 [<c0156ad8>] ? tick_sched_timer+0x0/0x9c
 [<c014d111>] hrtimer_interrupt+0xca/0x1e0
 [<c0118a20>] smp_apic_timer_interrupt+0x69/0x7c
 [<c0706fbb>] apic_timer_interrupt+0x2f/0x34
 [<c0341e0a>] ? memset+0xf/0x19
 [<c0197706>] get_page_from_freelist+0x307/0x38a
 [<c01978d6>] __alloc_pages_nodemask+0x137/0x5a3
 [<c01597d7>] ? trace_hardirqs_on+0xb/0xd
 [<c0190908>] ? perf_mmap+0x1a8/0x2cf
 [<c018c3f2>] perf_mmap_alloc_page+0x16/0x28
 [<c0190930>] perf_mmap+0x1d0/0x2cf
 [<c01acf20>] mmap_region+0x1e5/0x398
 [<c01ad304>] do_mmap_pgoff+0x231/0x293
 [<c01ad4cf>] sys_mmap_pgoff+0x169/0x18a
 [<c01027f0>] sysenter_do_call+0x12/0x36
Code: e8 8b 5d e4 8b 14 91 89 55 dc 0f a3 99 00 01 00 00 19 c0 85 c0 0f
84 9c 00 00 00 89 d6 81 c6 c8 00 00 00 8b 7e 18 03 7e 14 89 f9 <0f> 32
89 55 f0 8b 55 dc 89 45 ec 8b 8a c8 00 00 00 c7 45 d8 00 
EIP: [<c010ee9e>] p4_pmu_disable_all+0x54/0xfa SS:ESP 0068:f5b99ca0
---[ end trace cd06b2a54d3444fb ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 1963, comm: perf Tainted: G      D     2.6.38-rc7-tip-mlin+ #88
Call Trace:
 [<c0133c6d>] ? panic+0x58/0x15b
 [<c0707ad9>] ? oops_end+0x8b/0x9a
 [<c0104b91>] ? die+0x53/0x59
 [<c07077d5>] ? do_general_protection+0x10a/0x112
 [<c07076cb>] ? do_general_protection+0x0/0x112
 [<c07071f7>] ? error_code+0x5f/0x64
 [<c01200d8>] ? change_page_attr_set_clr+0x1a4/0x2a6
 [<c07076cb>] ? do_general_protection+0x0/0x112
 [<c010ee9e>] ? p4_pmu_disable_all+0x54/0xfa
 [<c01265bd>] ? cpuacct_charge+0x72/0x7a
 [<c010e499>] ? x86_pmu_disable+0x3b/0x3d
 [<c0189993>] ? perf_pmu_disable+0x1c/0x1e
 [<c018ec40>] ? perf_event_task_tick+0xd6/0x1ef
 [<c012a485>] ? scheduler_tick+0x9c/0x1dd
 [<c013dc6a>] ? update_process_times+0x4c/0x58
 [<c0156b46>] ? tick_sched_timer+0x6e/0x9c
 [<c014cfd0>] ? __run_hrtimer+0x97/0x10e
 [<c070641b>] ? _raw_spin_lock+0x22/0x2a
 [<c0156ad8>] ? tick_sched_timer+0x0/0x9c
 [<c014d111>] ? hrtimer_interrupt+0xca/0x1e0
 [<c0118a20>] ? smp_apic_timer_interrupt+0x69/0x7c
 [<c0706fbb>] ? apic_timer_interrupt+0x2f/0x34
 [<c0341e0a>] ? memset+0xf/0x19
 [<c0197706>] ? get_page_from_freelist+0x307/0x38a
 [<c01978d6>] ? __alloc_pages_nodemask+0x137/0x5a3
 [<c01597d7>] ? trace_hardirqs_on+0xb/0xd
 [<c0190908>] ? perf_mmap+0x1a8/0x2cf
 [<c018c3f2>] ? perf_mmap_alloc_page+0x16/0x28
 [<c0190930>] ? perf_mmap+0x1d0/0x2cf
 [<c01acf20>] ? mmap_region+0x1e5/0x398
 [<c01ad304>] ? do_mmap_pgoff+0x231/0x293
 [<c01ad4cf>] ? sys_mmap_pgoff+0x169/0x18a
 [<c01027f0>] ? sysenter_do_call+0x12/0x36




