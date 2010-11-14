Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab0KNSVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 13:21:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21423 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab0KNSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 13:21:09 -0500
Message-ID: <4CE02832.3020402@kernel.org>
Date: Sun, 14 Nov 2010 10:19:30 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] x86, acpi: Handle all SRAT cpu entries even have cpu
 num limitation
References: <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost> <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost> <4CDF3DA1.2090806@kernel.org> <20101114173208.GA23017@localhost>
In-Reply-To: <20101114173208.GA23017@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 09:32 AM, Wu Fengguang wrote:
> Hi,
> 
> I just found another problem. When passing "mem=256" to 2.6.37-rc1,
> it dies hard early (not able to print any boot log). With this patch
> applied, it's a bit better: it shows a kernel panic, but still dies
> hard (not able to reboot with "panic=10").
> 

if you did use "mem=256", you should get panic.

early console in setup code
Probing EDD (edd=off to disable)... ok
early console in decompress_kernel
decompress_kernel:
  input: [0x2431269-0x2e7fec6], output: 0x1000000, heap: [0x2e856c0-0x2e8c6bf]

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] bootconsole [uart0] enabled
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x01000000-0x01ce0e48]
[    0.000000] .rodata: [0x01ce6000-0x0240ffff]
[    0.000000]   .data: [0x02410000-0x025a50bf]
[    0.000000]   .init: [0x025a7000-0x0286afff]
[    0.000000]    .bss: [0x02875000-0x0348a6d7]
[    0.000000]    .brk: [0x0348b000-0x034aafff]
[    0.000000]     memblock_x86_reserve_range: [0x01000000-0x0348a6d7]    TEXT DATA BSS
[    0.000000]     memblock_x86_reserve_range: [0x7c59d000-0x7fffefff]          RAMDISK
[    0.000000]     memblock_x86_reserve_range: [0x0009fc00-0x000fffff]  * BIOS reserved
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc1-tip-yh-02102-g776a022-dirty (yhlu@linux-siqj.site) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #276 SMP Sat Nov 13 15:34:15 PST 2010
[    0.000000] Command line: BOOT_IMAGE=linux debug apic=debug ramdisk_size=262144 root=/dev/ram0 rw ip=dhcp mem=256 console=uart8250,io,0x3f8,115200 initrd=initrd.img
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: [0x00000000000000-0x0000000009fbff] (usable)
[    0.000000]  BIOS-e820: [0x0000000009fc00-0x0000000009ffff] (reserved)
[    0.000000]  BIOS-e820: [0x000000000f0000-0x000000000fffff] (reserved)
[    0.000000]  BIOS-e820: [0x00000000100000-0x0000002ffeffff] (usable)
[    0.000000]  BIOS-e820: [0x0000002fff0000-0x0000002fffffff] (ACPI data)
[    0.000000]  BIOS-e820: [0x000000fffc0000-0x000000ffffffff] (reserved)
[    0.000000] e820 remove range: [0x00000000000100-0xfffffffffffffffe] (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] user-defined physical RAM map:
[    0.000000]  user: [0x00000000000000-0x000000000000ff] (usable)
[    0.000000]  user: [0x0000000009fc00-0x0000000009ffff] (reserved)
[    0.000000]  user: [0x000000000f0000-0x000000000fffff] (reserved)
[    0.000000]  user: [0x0000002fff0000-0x0000002fffffff] (ACPI data)
[    0.000000]  user: [0x000000fffc0000-0x000000ffffffff] (reserved)
[    0.000000] e820 update range: [0x00000000000000-0x000000000000ff] (usable) ==> (reserved)
[    0.000000] aligned physical RAM map:
[    0.000000]  aligned: [0x00000000000000-0x000000000000ff] (reserved)
[    0.000000]  aligned: [0x0000000009fc00-0x0000000009ffff] (reserved)
[    0.000000]  aligned: [0x000000000f0000-0x000000000fffff] (reserved)
[    0.000000]  aligned: [0x0000002fff0000-0x0000002fffffff] (ACPI data)
[    0.000000]  aligned: [0x000000fffc0000-0x000000ffffffff] (reserved)
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: /VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000000] e820 update range: [0x00000000000000-0x0000000000ffff] (usable) ==> (reserved)
[    0.000000] e820 remove range: [0x000000000a0000-0x000000000fffff] (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR variable ranges disabled:
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] found SMP MP-table at [ffff88000009fff0] 9fff0
[    0.000000]     memblock_x86_reserve_range: [0x0009fff0-0x0009ffff]   * MP-table mpf
[    0.000000]   mpc: e1160-e1254
[    0.000000]     memblock_x86_reserve_range: [0x000e1160-0x000e1253]   * MP-table mpc
[    0.000000]     memblock_x86_reserve_range: [0x0348b000-0x0348b070]              BRK
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x0
[    0.000000]  memory.cnt  = 0x1
[    0.000000]  memory[0x0]     [0x00000000000000-0xffffffffffffffff], 0x0 bytes
[    0.000000]  reserved.cnt  = 0x6
[    0.000000]  reserved[0x0]   [0x0000000009fc00-0x000000000fffff], 0x60400 bytes
[    0.000000]  reserved[0x1]   [0x0000000009fff0-0x0000000009ffff], 0x10 bytes
[    0.000000]  reserved[0x2]   [0x000000000e1160-0x000000000e1253], 0xf4 bytes
[    0.000000]  reserved[0x3]   [0x00000001000000-0x0000000348a6d7], 0x248a6d8 bytes
[    0.000000]  reserved[0x4]   [0x0000000348b000-0x0000000348b070], 0x71 bytes
[    0.000000]  reserved[0x5]   [0x0000007c59d000-0x0000007fffefff], 0x3a62000 bytes
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Kernel panic - not syncing: Cannot allocate trampoline
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.37-rc1-tip-yh-02102-g776a022-dirty #276
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cd3f14>] panic+0x91/0x1a3
[    0.000000]  [<ffffffff82783490>] reserve_trampoline_memory+0x46/0x72
[    0.000000]  [<ffffffff827801fe>] setup_arch+0x5b0/0xae3
[    0.000000]  [<ffffffff827cb3a0>] ? boot_command_line+0x0/0x800
[    0.000000]  [<ffffffff81cd4067>] ? printk+0x41/0x43
[    0.000000]  [<ffffffff827cb3a0>] ? boot_command_line+0x0/0x800
[    0.000000]  [<ffffffff8277bb0d>] start_kernel+0xd7/0x3e8
[    0.000000]  [<ffffffff8277b2cc>] x86_64_start_reservations+0x9c/0xa0
[    0.000000]  [<ffffffff8277b3e4>] x86_64_start_kernel+0x114/0x11b
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/lockdep.c:2322 trace_hardirqs_on_caller+0xc3/0x178()
[    0.000000] Hardware name: VirtualBox
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.37-rc1-tip-yh-02102-g776a022-dirty #276
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8107bda0>] warn_slowpath_common+0x85/0x9d
[    0.000000]  [<ffffffff81cd3fe1>] ? panic+0x15e/0x1a3
[    0.000000]  [<ffffffff8107bdd2>] warn_slowpath_null+0x1a/0x1c
[    0.000000]  [<ffffffff810a8e59>] trace_hardirqs_on_caller+0xc3/0x178
[    0.000000]  [<ffffffff810a8f1b>] trace_hardirqs_on+0xd/0xf
[    0.000000]  [<ffffffff81cd3fe1>] panic+0x15e/0x1a3
[    0.000000]  [<ffffffff82783490>] reserve_trampoline_memory+0x46/0x72
[    0.000000]  [<ffffffff827801fe>] setup_arch+0x5b0/0xae3
[    0.000000]  [<ffffffff827cb3a0>] ? boot_command_line+0x0/0x800
[    0.000000]  [<ffffffff81cd4067>] ? printk+0x41/0x43
[    0.000000]  [<ffffffff827cb3a0>] ? boot_command_line+0x0/0x800
[    0.000000]  [<ffffffff8277bb0d>] start_kernel+0xd7/0x3e8
[    0.000000]  [<ffffffff8277b2cc>] x86_64_start_reservations+0x9c/0xa0
[    0.000000]  [<ffffffff8277b3e4>] x86_64_start_kernel+0x114/0x11b
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
