Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0LQXcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:32:46 -0500
Received: from smtp-out.google.com ([74.125.121.67]:39254 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab0LQXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:32:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gYBf+qvSJUz5O4zVhC9iGD5ulBsqZbKQINxWJzwwoKlMdgwJlO+j4STbiSiCmgYspO
         U8T72lOK6HOisZVFcnYw==
MIME-Version: 1.0
In-Reply-To: <4D0BB9AD.90506@kernel.org>
References: <20101111100628.GA24728@localhost>
	<1289478978.2084.74.camel@laptop>
	<20101111124015.GA9706@localhost>
	<1289480656.2084.80.camel@laptop>
	<20101113084018.GA23098@localhost>
	<1289644224.2084.521.camel@laptop>
	<20101113120030.GA31517@localhost>
	<1289653078.2084.675.camel@laptop>
	<20101113131042.GA5522@localhost>
	<4CDEE314.6090107@kernel.org>
	<20101113235746.GA9458@localhost>
	<4CDF3DA1.2090806@kernel.org>
	<4D093ABB.4030206@zytor.com>
	<4D0943D5.1090404@kernel.org>
	<4D094703.7080701@zytor.com>
	<4D0AD464.2020408@kernel.org>
	<4D0AD486.9020704@kernel.org>
	<AANLkTin-LGig2RHHmvvy5H04jQRus_1mmS1Cr4KDWKsN@mail.gmail.com>
	<4D0BB9AD.90506@kernel.org>
Date: Fri, 17 Dec 2010 15:32:37 -0800
Message-ID: <AANLkTimw_nvDEb4t1nOQFCtY8fx6fvg5Mmy+6vZw8mw1@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] x86, acpi: Parse all SRAT cpu entries even have
 cpu num limitation
From: Venkatesh Pallipadi <venki@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:27 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On 12/17/2010 10:53 AM, Venkatesh Pallipadi wrote:
>> linus git + these two patches still fails on my test system with the
>> divide error. The failure dump is similar to what I reported here
>> http://lkml.indiana.edu/hypermail//linux/kernel/1012.1/03641.html
>>
>> This patch description talk about new Intel systems. The test system I
>> am seeing failure here is an ancient Intel (2 socket P4 HT) system.
>> AFAICS, it does not even have an SRAT table (no "ACPI: SRAT" message
>> in dmesg).
>
> that could be different cause.
>
> Do you have whole boot log with debug etc?
>
>

This regression seems to be specific to fake numa configuration. Boots
fine without "numa=fake=128M".
Also, I see that the problem started between 2.6.36 and 2.6.37-rc1. I
haven't done further bisect yet.

Below is the log with debug

Thanks,
Venki


[    0.000000] Linux version 2.6.37-smp-DEV
(venki@tippy.mtv.corp.google.com) (gcc version 4.4.0
(Google_crosstoolv13-gcc-4.4.0-glibc-2.3.6-grte) ) #8 SMP Fri Dec 17
14:58:29 PST 2010
[    0.000000] Command line: auto BOOT_IMAGE=2637D ro
root=/dev/hda1,/dev/sda1 oops=panic panic=10 io_delay=0xed
libata.force=qd1 nmi_watchdog=panic tco_start=1 auto BOOT_IMAGE=2637D
ro root=/dev/hda1,/dev/sda1 numa=fake=128M swiotlb=16000 debug
console=ttyS0,115200n8
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfbe2c00 (usable)
[    0.000000]  BIOS-e820: 00000000bfbe2c00 - 00000000bfbe7c00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfbe7c00 - 00000000bfbe8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfbe8000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.1 present.
[    0.000000] DMI: Unicorn_QCS_00  /E7320,6300ESB, BIOS 1.2.12 04/08/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FC0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfbe2 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff88000009d890] 9d890
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfbe2000
[    0.000000]  0000000000 - 00bfa00000 page 2M
[    0.000000]  00bfa00000 - 00bfbe2000 page 4k
[    0.000000] kernel direct mapping tables up to bfbe2000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 2M
[    0.000000] kernel direct mapping tables up to 440000000 @ bfbd0000-bfbe2000
[    0.000000] ACPI: RSDP 00000000000f61e0 00014 (v00 GOOGLE)
[    0.000000] ACPI: RSDT 00000000bfbe7000 00030 (v01 GOOGLE RSDT_UNI
00000001 MSFT 32303262)
[    0.000000] ACPI: FACP 00000000bfbe6c00 00074 (v01 GOOGLE FACP_UNI
00000001 MSFT 32303262)
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address
or length: 0x000000000000102C/0x0 (20101013/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000bfbe2c00 01E45 (v01 GOOGLE DSDT0001
00000001 MSFT 02000002)
[    0.000000] ACPI: FACS 00000000bfbe7c00 00040
[    0.000000] ACPI: APIC 00000000bfbe7400 00090 (v01 GOOGLE APIC_UNI
00000001 MSFT 32303262)
[    0.000000] ACPI: HPET 00000000bfbe7490 00038 (v01 GOOGLE HPET_UNI
00000001 MSFT 32303262)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Faking node 0 at 0000000000000000-000000000c000000 (192MB)
[    0.000000] Faking node 1 at 000000000c000000-0000000014000000 (128MB)

<snip other messages like this for remaining nodes>

[    0.000000] NUMA: Allocated memnodemap from 43ffffdc0 - 440000000
[    0.000000] NUMA: Using 26 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-000000000c000000
[    0.000000]   NODE_DATA [000000000bfec000 - 000000000bffffff]
[    0.000000] Initmem setup node 1 000000000c000000-0000000014000000
[    0.000000]   NODE_DATA [0000000013fec000 - 0000000013ffffff]

<snip other messages like this for remaining nodes>

[    0.000000] Faking PXM affinity for fake nodes on real topology.
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD ->
[ffff88000b200000-ffff88000b5fffff] on node 0
[    0.000000]  [ffffea0000400000-ffffea00005fffff] PMD ->
[ffff880013c00000-ffff880013dfffff] on node 1

<snip other messages like this for remaining nodes>

[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[128] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0000c000
[    0.000000]     1: 0x0000c000 -> 0x00014000

<snip other messages like this for remaining nodes>

[    0.000000] On node 0 totalpages: 49037
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3923 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 616 pages used for memmap
[    0.000000]   DMA32 zone: 44440 pages, LIFO batch:7
[    0.000000] On node 1 totalpages: 32768
[    0.000000]   DMA32 zone: 448 pages used for memmap
[    0.000000]   DMA32 zone: 32320 pages, LIFO batch:7

<snip other messages like this for remaining nodes>

[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 13, version 32, address 0xfec10000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32
nr_cpu_ids:4 nr_node_ids:127
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88000bc00000 s74752
r8192 d23552 u2097152
[    0.000000] pcpu-alloc: s74752 r8192 d23552 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [1] 1 [2] 2 [3] 3
[    0.000000] Built 127 zonelists in Node order, mobility grouping
on.  Total pages: 4135803
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: oops=panic panic=10 io_delay=0xed
libata.force=qd1 nmi_watchdog=panic tco_start=1 auto BOOT_IMAGE=2637D
ro root=/dev/hda1,/dev/sda1 oops=panic panic=10 io_delay=0xed
libata.force=qd1 nmi_watchdog=panic tco_start=1 auto BOOT_IMAGE=2637D
ro root=/dev/hda1,/dev/sda1 numa=fake=128M swiotlb=16000 debug
console=ttyS0,115200n8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16487120k/17825792k available (4507k kernel
code, 1053252k absent, 285420k reserved, 4535k data, 1708k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=127
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2799.987 MHz processor.
[    0.003008] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5599.97 BogoMIPS (lpj=2799987)
[    0.005004] pid_max: default: 32768 minimum: 301
[    0.009974] Security Framework initialized
[    0.019930] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.038319] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.045857] Mount-cache hash table entries: 256
[    0.048347] Initializing cgroup subsys cpuacct
[    0.050523] CPU: Physical Processor ID: 0
[    0.051004] CPU: Processor Core ID: 0
[    0.052004] mce: CPU supports 4 MCE banks
[    0.053016] CPU0: Thermal monitoring enabled (TM1)
[    0.054009] using mwait in idle threads.
[    0.055004] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.058007] ... version:                0
[    0.059003] ... bit width:              40
[    0.060003] ... generic registers:      18
[    0.061003] ... value mask:             000000ffffffffff
[    0.062003] ... max period:             0000007fffffffff
[    0.063003] ... fixed-purpose events:   0
[    0.064003] ... event mask:             000000000003ffff
[    0.065034] Freeing SMP alternatives: 20k freed
[    0.066032] ACPI: Core revision 20101013
[    0.073546] ftrace: allocating 21854 entries in 86 pages
[    0.077090] Setting APIC routing to flat
[    0.078402] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.089424] CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
[    0.092999] Booting Node   1, Processors  #1 Ok.
[    0.165701] Booting Node   2, Processors  #2 Ok.
[    0.246730] Booting Node   3, Processors  #3 Ok.
[    0.320014] Brought up 4 CPUs
[    0.321006] Total of 4 processors activated (22399.71 BogoMIPS).
[    0.323724] divide error: 0000 [#1] SMP
[    0.323999] last sysfs file:
[    0.323999] CPU 1
[    0.323999] Modules linked in:
[    0.323999]
[    0.323999] Pid: 2, comm: kthreadd Not tainted 2.6.37-smp-DEV #8
Unicorn_QCS_00  /E7320,6300ESB
[    0.323999] RIP: 0010:[<ffffffff81062a47>]  [<ffffffff81062a47>]
select_task_rq_fair+0x5dd/0x70a
[    0.323999] RSP: 0000:ffff880008c65c00  EFLAGS: 00010046
[    0.323999] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[    0.323999] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000020
[    0.323999] RBP: ffff880008c65cd0 R08: 0000000000000000 R09: 0000000000000000
[    0.323999] R10: 000000000000037a R11: ffffffffffffffff R12: 00000000000117c0
[    0.323999] R13: ffff880013a0db90 R14: 0000000000000001 R15: ffff880013435020
[    0.323999] FS:  0000000000000000(0000) GS:ffff880013a00000(0000)
knlGS:0000000000000000
[    0.323999] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.323999] CR2: 0000000000000000 CR3: 0000000001803000 CR4: 00000000000006e0
[    0.323999] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.323999] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.323999] Process kthreadd (pid: 2, threadinfo ffff880008c64000,
task ffff88030f8387b0)
[    0.323999] Stack:
[    0.323999]  0000000000020010 ffff880013435038 ffffea0000437340
ffff880008c0b440
[    0.323999]  ffffffffffffffff 0000000000000000 000000000000037a
0000000000000000
[    0.323999]  ffff880000000000 ffff880013440000 00000000000117c0
00000000000117c0
[    0.323999] Call Trace:
[    0.323999]  [<ffffffff810670a0>] select_task_rq+0x28/0x115
[    0.323999]  [<ffffffff810686ef>] wake_up_new_task+0x3d/0xe1
[    0.323999]  [<ffffffff8106bee0>] do_fork+0x25f/0x2ab
[    0.323999]  [<ffffffff81032687>] ? __switch_to+0xea/0x212
[    0.323999]  [<ffffffff8103a252>] kernel_thread+0x70/0x72
[    0.323999]  [<ffffffff81086405>] ? kthread+0x0/0x8a
[    0.323999]  [<ffffffff81034910>] ? kernel_thread_helper+0x0/0x10
[    0.323999]  [<ffffffff81086580>] kthreadd+0xf1/0x12c
[    0.323999]  [<ffffffff81034914>] kernel_thread_helper+0x4/0x10
[    0.323999]  [<ffffffff8108648f>] ? kthreadd+0x0/0x12c
[    0.323999]  [<ffffffff81034910>] ? kernel_thread_helper+0x0/0x10
[    0.323999] Code: 8b 8d 68 ff ff ff 4c 8b 95 60 ff ff ff 4c 8b 9d
50 ff ff ff 0f 8c 50 ff ff ff 41 8b 57 08 48 8b 45 c8 48 c1 e0 0a 48
89 d6 31 d2 <48> f7 f6 45 85 c0 75 13 4c 39 d8 73 0b 49 89 c3 4d 89 f9
4c 89
[    0.323999] RIP  [<ffffffff81062a47>] select_task_rq_fair+0x5dd/0x70a
[    0.323999]  RSP <ffff880008c65c00>
[    0.354999] divide error: 0000 [#2]
[    0.323999] ---[ end trace 4eaa2a86a8e2da22 ]---
