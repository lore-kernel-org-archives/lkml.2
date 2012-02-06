Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2BFKMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:12:19 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45964 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2BFKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:12:14 -0500
Message-ID: <1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Date: Mon, 06 Feb 2012 11:12:10 +0100
In-Reply-To: <CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
References: <20120202211709.GA1642@x4> <20120202213220.GB1642@x4>
	 <CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	 <20120204135110.GA6437@elte.hu>
	 <CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
	 <CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 février 2012 à 10:54 +0100, Stephane Eranian a écrit :
> On Sat, Feb 4, 2012 at 7:09 PM, Stephane Eranian <eranian@google.com> wrote:
> > I am working on it. It is hard to reproduce for me.
> >
> What did you run to trigger this warning? What system is this on?
> 
> > On Sat, Feb 4, 2012 at 2:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> there's yet another one triggering at:
> >>
> >> [89214.962603] ------------[ cut here ]------------
> >> [89214.967441] WARNING: at arch/x86/kernel/cpu/perf_event.c:995 x86_pmu_start+0x79/0xd4()
> >> [89214.975825] Hardware name: X8DTN
> >> [89214.979268] Modules linked in:
> >> [89214.982560] Pid: 0, comm: swapper/6 Not tainted 3.3.0-rc2-tip+ #1
> >> [89214.988865] Call Trace:
> >> [89214.991533]  <IRQ>  [<ffffffff81065cc7>] warn_slowpath_common+0x7e/0x97
> >> [89214.998379]  [<ffffffff81065cf5>] warn_slowpath_null+0x15/0x17
> >> [89215.004428]  [<ffffffff8103f626>] x86_pmu_start+0x79/0xd4
> >> [89215.010042]  [<ffffffff810e30d1>] perf_adjust_freq_unthr_context.part.63+0xef/0x123
> >> [89215.018123]  [<ffffffff810e318c>] perf_event_task_tick+0x87/0x1c1
> >> [89215.024463]  [<ffffffff810a2370>] ? tick_nohz_handler+0xda/0xda
> >> [89215.030595]  [<ffffffff8108b819>] scheduler_tick+0xd1/0xf3
> >> [89215.036296]  [<ffffffff810720b0>] update_process_times+0x5e/0x6f
> >> [89215.042512]  [<ffffffff810a23e0>] tick_sched_timer+0x70/0x99
> >> [89215.048387]  [<ffffffff810823f9>] __run_hrtimer+0x8c/0x148
> >> [89215.054087]  [<ffffffff81082add>] hrtimer_interrupt+0xc1/0x18c
> >>
> >> Thanks,
> >>
> >>        Ingo

Stephane, I trigger this as well very easily on my machine, 32bit
kernel, using the following :


perf record -a -g hackbench 10 thread 4000


[ 1205.338006] ------------[ cut here ]------------
[ 1205.338028] WARNING: at arch/x86/kernel/cpu/perf_event.c:989
x86_pmu_start+0xba/0xf0()
[ 1205.338044] Hardware name: ProLiant BL460c G1
[ 1205.338053] Modules linked in: xt_hashlimit af_packet tg3 bonding
[ 1205.338076] Pid: 0, comm: swapper/5 Not tainted
3.3.0-rc2-00172-g23783f8 #55
[ 1205.338090] Call Trace:
[ 1205.338100]  [<c0609e06>] ? printk+0x1d/0x1f
[ 1205.338111]  [<c022b012>] warn_slowpath_common+0x72/0xa0
[ 1205.338123]  [<c021072a>] ? x86_pmu_start+0xba/0xf0
[ 1205.338134]  [<c021072a>] ? x86_pmu_start+0xba/0xf0
[ 1205.338145]  [<c022b062>] warn_slowpath_null+0x22/0x30
[ 1205.338157]  [<c021072a>] x86_pmu_start+0xba/0xf0
[ 1205.338170]  [<c02aba7b>] perf_adjust_freq_unthr_context.part.75
+0xfb/0x180
[ 1205.338185]  [<c02abd21>] perf_event_task_tick+0x221/0x290
[ 1205.338199]  [<c0258dee>] ? update_cpu_load+0xbe/0xf0
[ 1205.338210]  [<c0259728>] scheduler_tick+0x98/0xf0
[ 1205.338222]  [<c0239c6a>] update_process_times+0x5a/0x70
[ 1205.338235]  [<c026bb10>] tick_sched_timer+0x60/0x1f0
[ 1205.338248]  [<c024f1c0>] ? __remove_hrtimer+0x40/0xa0
[ 1205.338260]  [<c024f3f7>] __run_hrtimer+0x67/0x1e0
[ 1205.338270]  [<c026bab0>] ? tick_init_highres+0x20/0x20
[ 1205.338297]  [<c02501b0>] hrtimer_interrupt+0xe0/0x260
[ 1205.338323]  [<c025c207>] ? sched_clock_cpu+0xd7/0x160
[ 1205.338350]  [<c025c841>] ? set_next_entity+0x31/0x70
[ 1205.338380]  [<c0610804>] smp_apic_timer_interrupt+0x54/0x88
[ 1205.338407]  [<c060fcda>] apic_timer_interrupt+0x2a/0x30
[ 1205.338439]  [<c0209efc>] ? mwait_idle+0x7c/0x1d0
[ 1205.338470]  [<c0201606>] cpu_idle+0x66/0xa0
[ 1205.338495]  [<c060500f>] start_secondary+0x1bf/0x1c5
[ 1205.338520] ---[ end trace 94f790d96c8679f1 ]---
[ 1211.617012] Uhhuh. NMI received for unknown reason 21 on CPU 0.
[ 1211.617049] Do you have a strange power saving mode enabled?
[ 1211.617075] Dazed and confused, but trying to continue
[ 1211.970013] Uhhuh. NMI received for unknown reason 31 on CPU 7.
[ 1211.970050] Do you have a strange power saving mode enabled?
[ 1211.970076] Dazed and confused, but trying to continue
[ 1214.440012] Uhhuh. NMI received for unknown reason 21 on CPU 3.
[ 1214.440048] Do you have a strange power saving mode enabled?
[ 1214.440074] Dazed and confused, but trying to continue
[ 1214.634012] Uhhuh. NMI received for unknown reason 31 on CPU 4.
[ 1214.634047] Do you have a strange power saving mode enabled?
[ 1214.634073] Dazed and confused, but trying to continue
[ 1216.568016] Uhhuh. NMI received for unknown reason 31 on CPU 1.
[ 1216.568052] Do you have a strange power saving mode enabled?
[ 1216.568078] Dazed and confused, but trying to continue
[ 1217.309010] Uhhuh. NMI received for unknown reason 31 on CPU 2.
[ 1217.309044] Do you have a strange power saving mode enabled?
[ 1217.309070] Dazed and confused, but trying to continue




processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz
stepping	: 6


