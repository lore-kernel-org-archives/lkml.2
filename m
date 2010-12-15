Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0LOWJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:09:23 -0500
Received: from smtp-out.google.com ([74.125.121.35]:63472 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab0LOWJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LPJn7H6wa2liPSAK1/seU/aKyL4mXoJoV0k4KnLTvMzS9//swMjrh4wt0wtx14K0km
         xDXbKqiOHGJXebneBQRQ==
MIME-Version: 1.0
In-Reply-To: <1290123161.2447.27.camel@zim>
References: <20101104041236.GA9389@helgaas.com>
	<1288937844.3234.1.camel@edumazet-laptop>
	<1289500084.2698.12.camel@zim>
	<201011121152.30204.knikanth@suse.de>
	<1289756161.2814.29.camel@zim>
	<AANLkTikUnLc8L_0+CQOwPgr-oifws=sqnFPxWz46MTCi@mail.gmail.com>
	<1290123161.2447.27.camel@zim>
Date: Wed, 15 Dec 2010 14:09:16 -0800
Message-ID: <AANLkTi=AzNLmX3tR9VUuiAmDdqgc0_TmwAOQ=f_kS_63@mail.gmail.com>
Subject: Re: divide error in select_task_rq_fair()
From: Venkatesh Pallipadi <venki@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Myron Stowe <myron.stowe@hp.com>, Nikanth Karthikesan <knikanth@suse.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, rjenties@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 3:32 PM, Myron Stowe <myron.stowe@hp.com> wrote:
> On Sun, 2010-11-14 at 11:11 -0800, Yinghai Lu wrote:
>> On Sun, Nov 14, 2010 at 9:36 AM, Myron Stowe <myron.stowe@hp.com> wrote:
>> >
>> > I got the same divide error with this latest patch (see attachment).  If
>> > I revert commit 50f2d7f682f9, the platform boots successfully.
>>
>> please check patch in
>> http://lkml.org/lkml/2010/11/13/181
>
> I was able to test this patch and with it applied the system did boot
> successfully.
>


I have the same failure on one of my test systems and the patch here
does not seem to help. I see the same panic even with the patch. Below
is the partial log of the failure with the patch. Let me know if you
need any more information on the failure.

Thanks,
Venki


---
[    0.000000] Kernel command line: oops=panic panic=10 io_delay=0xed
libata.force=qd1 nmi_watchdog=panic tco_start=1 auto BOOT_IMAGE=2637D
ro root=/dev/hda1,/dev/sda1 numa=fake=128M swiotlb=16000
console=ttyS0,115200n8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16487248k/17825792k available (4508k kernel
code, 1053252k absent, 285292k reserved, 4534k data, 1708k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=127
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2799.956 MHz processor.
[    0.002009] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5599.91 BogoMIPS (lpj=2799956)
[    0.004005] pid_max: default: 32768 minimum: 301
[    0.008464] Security Framework initialized
[    0.019786] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.037867] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.044401] Mount-cache hash table entries: 256
[    0.047866] Initializing cgroup subsys cpuacct
[    0.049064] CPU: Physical Processor ID: 0
[    0.050005] CPU: Processor Core ID: 0
[    0.051006] mce: CPU supports 4 MCE banks
[    0.052016] CPU0: Thermal monitoring enabled (TM1)
[    0.053009] using mwait in idle threads.
[    0.054004] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.057007] ... version:                0
[    0.058004] ... bit width:              40
[    0.059004] ... generic registers:      18
[    0.060004] ... value mask:             000000ffffffffff
[    0.061004] ... max period:             0000007fffffffff
[    0.062004] ... fixed-purpose events:   0
[    0.063004] ... event mask:             000000000003ffff
[    0.064031] Freeing SMP alternatives: 20k freed
[    0.065032] ACPI: Core revision 20101013
[    0.073487] ftrace: allocating 21860 entries in 86 pages
[    0.076205] Setting APIC routing to flat
[    0.077401] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.088085] CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
[    0.091999] Booting Node   1, Processors  #1 Ok.
[    0.164711] Booting Node   2, Processors  #2 Ok.
[    0.237728] Booting Node   3, Processors  #3 Ok.
[    0.311014] Brought up 4 CPUs
[    0.312006] Total of 4 processors activated (22399.68 BogoMIPS).
[    0.314669] divide error: 0000 [#1] SMP
[    0.314999] last sysfs file:
[    0.314999] CPU 1
[    0.314999] Modules linked in:
[    0.314999]
[    0.314999] Pid: 2, comm: kthreadd Not tainted 2.6.37-smp-DEV #4
Unicorn_QCS_00  /E7320,6300ESB
[    0.314999] RIP: 0010:[<ffffffff81062b55>]  [<ffffffff81062b55>]
select_task_rq_fair+0x5dd/0x70a
[    0.314999] RSP: 0000:ffff880008c65c00  EFLAGS: 00010046
[    0.314999] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[    0.314999] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000020
[    0.314999] RBP: ffff880008c65cd0 R08: 0000000000000000 R09: 0000000000000000
[    0.314999] R10: 000000000000037a R11: ffffffffffffffff R12: 0000000000011800
[    0.314999] R13: ffff880013a0dbb0 R14: 0000000000000001 R15: ffff880013435020
[    0.314999] FS:  0000000000000000(0000) GS:ffff880013a00000(0000)
knlGS:0000000000000000
[    0.314999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.314999] CR2: 0000000000000000 CR3: 0000000001803000 CR4: 00000000000006e0
[    0.314999] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.314999] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.314999] Process kthreadd (pid: 2, threadinfo ffff880008c64000,
task ffff88030f8387b0)
[    0.314999] Stack:
[    0.314999]  0000000000020010 ffff880013435038 ffffea0000437340
ffff880008c0b440
[    0.314999]  ffffffffffffffff 0000000000000000 000000000000037a
0000000000000000
[    0.314999]  ffff880000000000 ffff880013440000 0000000000011800
0000000000011800
[    0.314999] Call Trace:
[    0.314999]  [<ffffffff81067198>] select_task_rq+0x28/0x115
[    0.314999]  [<ffffffff810687e7>] wake_up_new_task+0x3d/0xe1
[    0.314999]  [<ffffffff8106c214>] do_fork+0x25f/0x2ab
[    0.314999]  [<ffffffff81032687>] ? __switch_to+0xea/0x212
[    0.314999]  [<ffffffff8103a25e>] kernel_thread+0x70/0x72
[    0.314999]  [<ffffffff81086771>] ? kthread+0x0/0x8a
[    0.314999]  [<ffffffff81034910>] ? kernel_thread_helper+0x0/0x10
[    0.314999]  [<ffffffff810868ec>] kthreadd+0xf1/0x12c
[    0.314999]  [<ffffffff81034914>] kernel_thread_helper+0x4/0x10
[    0.314999]  [<ffffffff810867fb>] ? kthreadd+0x0/0x12c
[    0.314999]  [<ffffffff81034910>] ? kernel_thread_helper+0x0/0x10
[    0.314999] Code: 8b 8d 68 ff ff ff 4c 8b 95 60 ff ff ff 4c 8b 9d
50 ff ff ff 0f 8c 50 ff ff ff 41 8b 57 08 48 8b 45 c8 48 c1 e0 0a 48
89 d6 31 d2 <48> f7 f6 45 85 c0 75 13 4c 39 d8 73 0b 49 89 c3 4d 89 f9
4c 89
[    0.314999] RIP  [<ffffffff81062b55>] select_task_rq_fair+0x5dd/0x70a
[    0.314999]  RSP <ffff880008c65c00>
[    0.345999] divide error: 0000 [#2]
[    0.314999] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.314999] Kernel panic - not syncing: Fatal exception
[    0.314999] Pid: 2, comm: kthreadd Tainted: G      D     2.6.37-smp-DEV #4
[    0.314999] Call Trace:
[    0.314999]  [<ffffffff8145bd81>] panic+0x91/0x199
[    0.314999]  [<ffffffff8106d748>] ? kmsg_dump+0x117/0x131
[    0.314999]  [<ffffffff8145ef22>] oops_end+0xae/0xbe
[    0.314999]  [<ffffffff81036d31>] die+0x5a/0x63
[    0.314999]  [<ffffffff8145e921>] do_trap+0x121/0x130
[    0.314999]  [<ffffffff810351d8>] do_divide_error+0x90/0x99
[    0.314999]  [<ffffffff81062b55>] ? select_task_rq_fair+0x5dd/0x70a
[    0.314999]  [<ffffffff810e3518>] ? __alloc_pages_nodemask+0x154/0x69c
[    0.314999]  [<ffffffff81034735>] divide_error+0x15/0x20
[    0.314999]  [<ffffffff81062b55>] ? select_task_rq_fair+0x5dd/0x70a
[    0.314999]  [<ffffffff81067198>] select_task_rq+0x28/0x115
[    0.314999]  [<ffffffff810687e7>] wake_up_new_task+0x3d/0xe1
[    0.314999]  [<ffffffff8106c214>] do_fork+0x25f/0x2ab
[    0.314999]  [<ffffffff81032687>] ? __switch_to+0xea/0x212
[    0.314999]  [<ffffffff8103a25e>] kernel_thread+0x70/0x72
[    0.314999]  [<ffffffff81086771>] ? kthread+0x0/0x8a
[    0.314999]  [<ffffffff81034910>] ? kernel_thread_helper+0x0/0x10
[    0.314999]  [<ffffffff810868ec>] kthreadd+0xf1/0x12c
[    0.314999]  [<ffffffff81034914>] kernel_thread_helper+0x4/0x10
[    0.314999]  [<ffffffff810867fb>] ? kthreadd+0x0/0x12c
[    0.314999]  [<ffffffff81034910>] ? kernel_thread_helper+0x0/0x10
[    0.345999] SMP
[    0.345999] last sysfs file:
[    0.345999] CPU 0
[    0.345999] Modules linked in:
[    0.345999]
[    0.345999] Pid: 0, comm: swapper Tainted: G      D
2.6.37-smp-DEV #4 Unicorn_QCS_00  /E7320,6300ESB
[    0.345999] RIP: 0010:[<ffffffff81063484>]  [<ffffffff81063484>]
find_busiest_group+0x3cb/0x946
[    0.345999] RSP: 0018:ffff88000bc03b60  EFLAGS: 00010246
[    0.345999] RAX: 0000000000000000 RBX: ffff88000bc0dbb0 RCX: 0000000000011800
[    0.345999] RDX: 0000000000000000 RSI: 0000000000000020 RDI: 0000000000000000
[    0.345999] RBP: ffff88000bc03d10 R08: 0000000000000000 R09: ffff880008c024b8
[    0.345999] R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
[    0.345999] R13: ffff880008c024a0 R14: 0000000000000002 R15: 0000000000011800
[    0.345999] FS:  0000000000000000(0000) GS:ffff88000bc00000(0000)
knlGS:0000000000000000
[    0.345999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.345999] CR2: 0000000000000000 CR3: 0000000001803000 CR4: 00000000000006f0
[    0.345999] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.345999] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.345999] Process swapper (pid: 0, threadinfo ffffffff81800000,
task ffffffff8180b020)
[    0.345999] Stack:
[    0.345999]  00000000ffffffff 0000000000000000 0000000000011800
0000000000011800
[    0.345999]  ffff88000bc03df0 0000000000011818 0000000000011800
ffff88000bc0d7e0
[    0.345999]  000000000000024d 0000000000000018 0000000000011800
ffff88000bc03dfc
[    0.345999] Call Trace:
[    0.345999]  <IRQ>
[    0.345999]  [<ffffffff81067a81>] load_balance+0xcb/0x6ab
[    0.345999]  [<ffffffff8108bead>] ? sched_clock_local+0x1c/0x82
---

> While I think you are on the correct path with respect to this issue I
> could not make any sense out of the patch heading and description.
> Worse - I'm thinking that it is even mis-leading as currently written
> (especially the patch heading).
>
> Thanks,
>
> Myron
>>
>> BTW, you also need to ask your BIOS guys to fix the SRAT table.
>> If you only have 128 cpu entries in MADT, SRAT table should have 128
>> cpu entries instead of 256 cpu entries
>> otherwise, RHEL 5.5 could have problem. it will throw away last cpu
>> entry in SRAT,
>>  (NR_CPUS is 255..., and last entry still could point the right cpu in MADT)
>> Also BIOS should keep cpu entries in SRAT have same order to that in MADT.
>>
>> Thanks
>>
>> Yinghai
>>
>
>
> --
> Myron Stowe                             Linux Kernel Developer
> Fort Collins, CO                        Office of Corporate Strategy and Technology
>
>
