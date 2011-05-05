Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1EEQ3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:29:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38015 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1EEQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:29:18 -0400
Date: Thu, 5 May 2011 12:28:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>, hpa@linux.intel.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH] Two patches fixing regression introduced
 by 'x86-64, mm: Put early page table high' - does not work.
Message-ID: <20110505162849.GA482@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
 <4DBEEA69.7010000@zytor.com>
 <20110502180802.GA7498@dumpdata.com>
 <4DBEF8EC.7080301@zytor.com>
 <20110502193436.GA14666@dumpdata.com>
 <4DBF0D0C.8000105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBF0D0C.8000105@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DC2D052.014D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> OK, sounds like a plan then.  I like it because it doesn't affect the
> >> native kernel.
.. snip..

> First things first... are you pushing the workaround (you can add my
> Acked-by:) or should I?

Grrr.. While it works on my machines, it does not work on some of the AMD opteron
CPU machines. I asked Stefan Bader from Canonical to run a simple bootup test with
2.6.39-rc6 (Linus picked it already), and if it crashed, to use the 
one that Stefano came up with.

And sure enough - it crashed and Stefano's fix worked. I've Stefano's
patch in stable/bug-fixes-for-x86 and I am OK reverting the fix I came up.

Here is the email correspondence:

On 05/05/2011 04:56 PM, Konrad Rzeszutek Wilk wrote:
> On Thu, May 05, 2011 at 04:20:47PM +0200, Stefan Bader wrote:
>> On 05/04/2011 05:12 PM, Konrad Rzeszutek Wilk wrote:
>>> Hey Stefan,
>>>
>>> I have you as the only contact from Canonical who does Xen. Not sure
>>> if that is correct - if not, please forward me to the right person.
>>>
>>> When v2.6.39 merge window openned a patch from Yinghai ("Put early
>>> page table high") made x86_64 Linux kernels unbootable under Xen.
>>> A hack got added in v2.6.39-rc6 (git commit  a38647837a411f7df79623128421eef2118b5884)
>>> which takes care of it. But it is a hack, and the testing we did
>>> does include a lot of hardware and config options  - but not everything
>>> so we might have missed some edge cases where this particular fix
>>> won't work right.
>>>
>>> Hence I was wondering when you guys get to test this kernel (v2.6.39-rc6
>>> or later) under Xen if you could be mindful of this particular fix - and
>>> see if does the job or if it is insufficient. If it is insufficient
>>> there is a backup patch in 'stable/bug-fixes-for-x86'
>>> (git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git)
>>> that is more surgical in its fixing (but the x86 maintainers
>>> don't like it).
>>>
>>> Thanks,
>>>
>>> Konrad
>>
>> Hi Konrad,
>>
>> I just did the tests with the -rc6 kernel. While a smaller memory setup (615M,
>> one vcpu) boots successful, I see an eary crash with a bigger setup (7680M, 2
> 
> ok..
>> vcpus) which I do not get with a 2.6.38 based kernel (the crash log is attached
>> but I did not do any real analysis).
> 
> <nods>
>>
>> My test system is CentOS 5.6 based with Xen 3.4.3 (from gitco) on an AMD opteron
>> CPU. As said, I have not really looked into the dump as I wanted to let know
>> early. I would try the backup patch next and see how that goes.
> 
> Great!  Thank you. 
>>
>> -Stefan
> 
>> [    0.000000] 
>> <6>[    0.000000] Initializing cgroup subsys cpuset
>> <6>[    0.000000] Initializing cgroup subsys cpu
>> <5>[    0.000000] Linux version 2.6.39-0-virtual (root@tangerine) (gcc version 4.6.1 20110428 (prerelease) (Ubuntu 4.6.0-6ubuntu1) ) #6~smb1 SMP Thu May 5 09:28:20 UTC 2011 (Ubuntu 2.6.39-0.6~smb1-virtual 2.6.39-rc5)
>> <6>[    0.000000] Command line: root=LABEL=uec-rootfs ro console=hvc0 
>> <6>[    0.000000] KERNEL supported cpus:
>> <6>[    0.000000]   Intel GenuineIntel
>> <6>[    0.000000]   AMD AuthenticAMD
>> <6>[    0.000000]   Centaur CentaurHauls
>> <6>[    0.000000] ACPI in unprivileged domain disabled
>> <6>[    0.000000] released 0 pages of unused memory
>> <6>[    0.000000] Set 0 page(s) to 1-1 mapping.
>> <6>[    0.000000] BIOS-provided physical RAM map:
>> <6>[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
>> <6>[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
>> <6>[    0.000000]  Xen: 0000000000100000 - 00000001e0800000 (usable)
>> <6>[    0.000000] NX (Execute Disable) protection: active
>> <6>[    0.000000] DMI not present or invalid.
>> <7>[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
>> <7>[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
>> <6>[    0.000000] No AGP bridge found
>> <6>[    0.000000] last_pfn = 0x1e0800 max_arch_pfn = 0x400000000
>> <6>[    0.000000] last_pfn = 0x100000 max_arch_pfn = 0x400000000
>> <7>[    0.000000] initial memory mapped : 0 - 02c3a000
>> <7>[    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
>> <6>[    0.000000] init_memory_mapping: 0000000000000000-0000000100000000
>> <7>[    0.000000]  0000000000 - 0100000000 page 4k
>> <7>[    0.000000] kernel direct mapping tables up to 100000000 @ ff7fb000-100000000
>> <6>[    0.000000] init_memory_mapping: 0000000100000000-00000001e0800000
>> <7>[    0.000000]  0100000000 - 01e0800000 page 4k
>> <7>[    0.000000] kernel direct mapping tables up to 1e0800000 @ 1df0f3000-1e0000000
>> <7>[    0.000000] xen: setting RW the range fffdc000 - 100000000
>> <6>[    0.000000] RAMDISK: 0203b000 - 02c3a000
>> <6>[    0.000000] No NUMA configuration found
>> <6>[    0.000000] Faking a node at 0000000000000000-00000001e0800000
>> <7>[    0.000000] NUMA: Using 63 for the hash shift.
>> <6>[    0.000000] Initmem setup node 0 0000000000000000-00000001e0800000
>> <6>[    0.000000]   NODE_DATA [00000001dfffb000 - 00000001dfffffff]
>> <1>[    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> <1>[    0.000000] IP: [<ffffffff81cf6a75>] setup_node_bootmem+0x18a/0x1ea
>> <4>[    0.000000] PGD 0 
>> <0>[    0.000000] Oops: 0003 [#1] SMP 
>> <0>[    0.000000] last sysfs file: 
>> <4>[    0.000000] CPU 0 
>> <4>[    0.000000] Modules linked in:
>> <4>[    0.000000] 
>> <4>[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.39-0-virtual #6~smb1  
>> <4>[    0.000000] RIP: e030:[<ffffffff81cf6a75>]  [<ffffffff81cf6a75>] setup_node_bootmem+0x18a/0x1ea
>> <4>[    0.000000] RSP: e02b:ffffffff81c01e38  EFLAGS: 00010046
>> <4>[    0.000000] RAX: 0000000000000000 RBX: 00000001e0800000 RCX: 0000000000001040
>> <4>[    0.000000] RDX: 0000000000004100 RSI: 0000000000000000 RDI: ffff8801dfffb000
>> <4>[    0.000000] RBP: ffffffff81c01e58 R08: 0000000000000020 R09: 0000000000000000
>> <4>[    0.000000] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
>> <4>[    0.000000] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000bfe400
>> <4>[    0.000000] FS:  0000000000000000(0000) GS:ffffffff81cca000(0000) knlGS:0000000000000000
>> <4>[    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>> <4>[    0.000000] CR2: 0000000000000000 CR3: 0000000001c03000 CR4: 0000000000000660
>> <4>[    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> <4>[    0.000000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> <4>[    0.000000] Process swapper (pid: 0, threadinfo ffffffff81c00000, task ffffffff81c0b020)
>> <0>[    0.000000] Stack:
>> <4>[    0.000000]  0000000000000040 0000000000000001 0000000000000000 ffffffffffffffff
>> <4>[    0.000000]  ffffffff81c01e88 ffffffff81cf6c25 0000000000000000 0000000000000000
>> <4>[    0.000000]  ffffffff81cf687f 0000000000000000 ffffffff81c01ea8 ffffffff81cf6e45
>> <0>[    0.000000] Call Trace:
>> <4>[    0.000000]  [<ffffffff81cf6c25>] numa_register_memblks.constprop.3+0x150/0x181
>> <4>[    0.000000]  [<ffffffff81cf687f>] ? numa_add_memblk+0x7c/0x7c
>> <4>[    0.000000]  [<ffffffff81cf6e45>] numa_init.part.2+0x1c/0x7c
>> <4>[    0.000000]  [<ffffffff81cf687f>] ? numa_add_memblk+0x7c/0x7c
>> <4>[    0.000000]  [<ffffffff81cf6f67>] numa_init+0x6c/0x70
>> <4>[    0.000000]  [<ffffffff81cf7057>] initmem_init+0x39/0x3b
>> <4>[    0.000000]  [<ffffffff81ce5865>] setup_arch+0x64e/0x769
>> <4>[    0.000000]  [<ffffffff815e43c1>] ? printk+0x51/0x53
>> <4>[    0.000000]  [<ffffffff81cdf92b>] start_kernel+0xd4/0x3f3
>> <4>[    0.000000]  [<ffffffff81cdf388>] x86_64_start_reservations+0x132/0x136
>> <4>[    0.000000]  [<ffffffff81ce2ed4>] xen_start_kernel+0x588/0x58f
>> <0>[    0.000000] Code: 41 00 00 48 8b 3c c5 a0 24 cc 81 31 c0 40 f6 c7 01 74 05 aa 66 ba ff 40 40 f6 c7 02 74 05 66 ab 83 ea 02 89 d1 c1 e9 02 f6 c2 02 <f3> ab 74 02 66 ab 80 e2 01 74 01 aa 49 63 c4 48 c1 eb 0c 44 89 
>> <1>[    0.000000] RIP  [<ffffffff81cf6a75>] setup_node_bootmem+0x18a/0x1ea
>> <4>[    0.000000]  RSP <ffffffff81c01e38>
>> <0>[    0.000000] CR2: 0000000000000000
>> <4>[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
>> <0>[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
>> <4>[    0.000000] Pid: 0, comm: swapper Tainted: G      D     2.6.39-0-virtual #6~smb1
>> <4>[    0.000000] Call Trace:
>> <4>[    0.000000]  [<ffffffff815e426d>] panic+0x91/0x194
>> <4>[    0.000000]  [<ffffffff81063ffb>] do_exit+0x40b/0x440
>> <4>[    0.000000]  [<ffffffff815fb990>] oops_end+0xb0/0xf0
>> <4>[    0.000000]  [<ffffffff815e332b>] no_context+0x145/0x152
>> <4>[    0.000000]  [<ffffffff815e34c6>] __bad_area_nosemaphore+0x18e/0x1b1
>> <4>[    0.000000]  [<ffffffff815e34fc>] bad_area_nosemaphore+0x13/0x15
>> <4>[    0.000000]  [<ffffffff815fe29d>] do_page_fault+0x43d/0x530
>> <4>[    0.000000]  [<ffffffff815fa70e>] ? _raw_spin_unlock_irqrestore+0x1e/0x30
>> <4>[    0.000000]  [<ffffffff8100721f>] ? __raw_callee_save_xen_restore_fl+0x11/0x1e
>> <4>[    0.000000]  [<ffffffff81060161>] ? vprintk+0x231/0x4b0
>> <4>[    0.000000]  [<ffffffff815facd5>] page_fault+0x25/0x30
>> <4>[    0.000000]  [<ffffffff81cf6a75>] ? setup_node_bootmem+0x18a/0x1ea
>> <4>[    0.000000]  [<ffffffff81cf6a16>] ? setup_node_bootmem+0x12b/0x1ea
>> <4>[    0.000000]  [<ffffffff81cf6c25>] numa_register_memblks.constprop.3+0x150/0x181
>> <4>[    0.000000]  [<ffffffff81cf687f>] ? numa_add_memblk+0x7c/0x7c
>> <4>[    0.000000]  [<ffffffff81cf6e45>] numa_init.part.2+0x1c/0x7c
>> <4>[    0.000000]  [<ffffffff81cf687f>] ? numa_add_memblk+0x7c/0x7c
>> <4>[    0.000000]  [<ffffffff81cf6f67>] numa_init+0x6c/0x70
>> <4>[    0.000000]  [<ffffffff81cf7057>] initmem_init+0x39/0x3b
>> <4>[    0.000000]  [<ffffffff81ce5865>] setup_arch+0x64e/0x769
>> <4>[    0.000000]  [<ffffffff815e43c1>] ? printk+0x51/0x53
>> <4>[    0.000000]  [<ffffffff81cdf92b>] start_kernel+0xd4/0x3f3
>> <4>[    0.000000]  [<ffffffff81cdf388>] x86_64_start_reservations+0x132/0x136
>> <4>[    0.000000]  [<ffffffff81ce2ed4>] xen_start_kernel+0x588/0x58f
> 

This seems to work better. I reverted the work-around patch and applied the two
patches at the tip of your branch. Both configurations boot now. To get a bit
more coverage, I would also put this second version into some ec2 instances
(they usually are Intel based). But at least locally the second approach seems
better (even with x86 maintainer disklike ;)).

-Stefan


--------------000200000708070501040204
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-0-virtual (root@tangerine) (gcc version 4.6.1 20110428 (prerelease) (Ubuntu 4.6.0-6ubuntu1) ) #6~smb2 SMP Thu May 5 14:44:59 UTC 2011 (Ubuntu 2.6.39-0.6~smb2-virtual 2.6.39-rc5)
[    0.000000] Command line: root=LABEL=uec-rootfs ro console=hvc0 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] released 0 pages of unused memory
[    0.000000] Set 0 page(s) to 1-1 mapping.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 00000001e0800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1e0800 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0x100000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 02c3a000
[    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-0000000100000000
[    0.000000]  0000000000 - 0100000000 page 4k
[    0.000000] kernel direct mapping tables up to 100000000 @ ff7fb000-100000000
[    0.000000] xen: setting RW the range fffdc000 - 100000000
[    0.000000] init_memory_mapping: 0000000100000000-00000001e0800000
[    0.000000]  0100000000 - 01e0800000 page 4k
[    0.000000] kernel direct mapping tables up to 1e0800000 @ 1df0f3000-1e0000000
[    0.000000] xen: setting RW the range 1df7fb000 - 1e0000000
[    0.000000] RAMDISK: 0203b000 - 02c3a000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001e0800000
[    0.000000] NUMA: Using 63 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-00000001e0800000
[    0.000000]   NODE_DATA [00000001dfffb000 - 00000001dfffffff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001e0800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x001e0800
[    0.000000] On node 0 totalpages: 1968016
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3923 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 1030200 pages, LIFO batch:31
[    0.000000]   Normal zone: 12572 pages used for memmap
[    0.000000]   Normal zone: 906980 pages, LIFO batch:31
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PCI: Warning: Cannot find a gap in the 32bit address range
[    0.000000] PCI: Unassigned devices with 32bit resource registers may break!
[    0.000000] Allocating PCI resources starting at 1e0900000 (gap: 1e0900000:400000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 3.4.3 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8801dff74000 s84608 r8192 d21888 u114688
[    0.000000] pcpu-alloc: s84608 r8192 d21888 u114688 alloc=28*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1941103
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=LABEL=uec-rootfs ro console=hvc0 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7629212k/7872512k available (6169k kernel code, 448k absent, 242852k reserved, 6921k data, 912k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:288 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled
[    0.000000] allocated 63963136 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 2000.138 MHz processor.
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.27 BogoMIPS (lpj=20001380)
[    0.010000] pid_max: default: 32768 minimum: 301
[    0.010000] Security Framework initialized
[    0.010000] AppArmor: AppArmor initialized
[    0.010000] Yama: becoming mindful.
[    0.010000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.010000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Initializing cgroup subsys ns
[    0.010000] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.010000] Initializing cgroup subsys cpuacct
[    0.010000] Initializing cgroup subsys memory
[    0.010000] Initializing cgroup subsys devices
[    0.010000] Initializing cgroup subsys freezer
[    0.010000] Initializing cgroup subsys net_cls
[    0.010000] Initializing cgroup subsys blkio
[    0.010000] Initializing cgroup subsys perf_event
[    0.010000] tseg: 00dff00000
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] SMP alternatives: switching to UP code
[    0.010000] ftrace: allocating 25924 entries in 102 pages
[    0.010144] cpu 0 spinlock event irq 17
[    0.010188] Performance Events: 
[    0.010195] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.010204] no hardware sampling interrupt available.
[    0.010241] Broken PMU hardware detected, using software events only.
[    0.010952] installing Xen timer for CPU 1
[    0.010978] cpu 1 spinlock event irq 23
[    0.011022] SMP alternatives: switching to SMP code
[    0.020145] Brought up 2 CPUs
[    0.020248] devtmpfs: initialized
[    0.021630] Grant table initialized
[    0.021630] print_constraints: dummy: 
[    0.043023] Time: 165:165:165  Date: 165/165/65
[    0.043085] NET: Registered protocol family 16
[    0.043283] Trying to unpack rootfs image as initramfs...
[    0.050186] Extended Config Space enabled on 0 nodes
[    0.050794] PCI: setting up Xen PCI frontend stub
[    0.050794] PCI: pci_cache_line_size set to 64 bytes
[    0.052494] bio: create slab <bio-0> at 0
[    0.052633] ACPI: Interpreter disabled.
[    0.053004] xen/balloon: Initialising balloon driver.
[    0.053004] last_pfn = 0x1e0800 max_arch_pfn = 0x400000000
[    0.054255] xen-balloon: Initialising balloon driver.
[    0.054385] vgaarb: loaded
[    0.054385] SCSI subsystem initialized
[    0.054792] libata version 3.00 loaded.
[    0.054792] usbcore: registered new interface driver usbfs
[    0.054792] usbcore: registered new interface driver hub
[    0.054932] usbcore: registered new device driver usb
[    0.055054] PCI: System does not support PCI
[    0.055054] PCI: System does not support PCI
[    0.055144] NetLabel: Initializing
[    0.055144] NetLabel:  domain hash size = 128
[    0.055144] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.055144] NetLabel:  unlabeled traffic allowed by default
[    0.055144] Switching to clocksource xen
[    0.055446] Switched to NOHz mode on CPU #0
[    0.055443] Switched to NOHz mode on CPU #1
[    0.057737] AppArmor: AppArmor Filesystem Enabled
[    0.057771] pnp: PnP ACPI: disabled
[    0.059315] NET: Registered protocol family 2
[    0.059780] Freeing initrd memory: 12284k freed
[    0.059878] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.062730] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.066505] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.066992] TCP: Hash tables configured (established 524288 bind 65536)
[    0.067003] TCP reno registered
[    0.067043] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.067149] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.067347] NET: Registered protocol family 1
[    0.070009] PCI: CLS 0 bytes, default 64
[    0.070009] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.070009] Placing 64MB software IO TLB between ffff8800fb7fb000 - ffff8800ff7fb000
[    0.070009] software IO TLB at phys 0xfb7fb000 - 0xff7fb000
[    0.072259] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.072597] audit: initializing netlink socket (disabled)
[    0.072627] type=2000 audit(1304608433.099:1): initialized
[    0.096031] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.098001] VFS: Disk quotas dquot_6.5.2
[    0.098076] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.098825] fuse init (API version 7.16)
[    0.098933] msgmni has been set to 14924
[    0.099356] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.099423] io scheduler noop registered
[    0.099431] io scheduler deadline registered (default)
[    0.099487] io scheduler cfq registered
[    0.099580] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.099699] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.100155] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.440229] Linux agpgart interface v0.103
[    0.441329] brd: module loaded
[    0.441840] loop: module loaded
[    0.444335] blkfront device/vbd/2049 num-ring-pages 1 nr_ents 32.
[    0.448802] blkfront device/vbd/2050 num-ring-pages 1 nr_ents 32.
[    0.449898] blkfront: xvde1: barriers disabled
[    0.450534] Fixed MDIO Bus: probed
[    0.450575] PPP generic driver version 2.4.2
[    0.450642] Initialising Xen virtual ethernet driver.
[    0.453787] blkfront: xvde2: barriers disabled
[    0.453890] tun: Universal TUN/TAP device driver, 1.6
[    0.453902] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.454012] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.454033] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.454047] uhci_hcd: USB Universal Host Controller Interface driver
[    0.454104] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.454935] i8042: No controller found
[    0.455000] mousedev: PS/2 mouse device common for all mice
[    0.455045] Setting capacity to 24576000
[    0.455063] xvde2: detected capacity change from 0 to 12582912000
[    0.495214] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.495280] rtc_cmos: probe of rtc_cmos failed with error -38
[    0.495448] device-mapper: uevent: version 1.0.3
[    0.495539] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    0.495724] device-mapper: multipath: version 1.3.0 loaded
[    0.495734] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.495813] cpuidle: using governor ladder
[    0.495820] cpuidle: using governor menu
[    0.495825] EFI Variables Facility v0.08 2004-May-17
[    0.496143] TCP cubic registered
[    0.496282] NET: Registered protocol family 10
[    0.497112] NET: Registered protocol family 17
[    0.497137] Registering the dns_resolver key type
[    0.497188] powernow-k8: Found 1 AMD Opteron(tm) Processor 6128 (2 cpu cores) (version 2.20.00)
[    0.497216] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[    0.497218] [Firmware Bug]: powernow-k8: Try again with latest BIOS.
[    0.497312] PM: Hibernation image not present or could not be loaded.
[    0.497327] registered taskstats version 1
[    0.497356] XENBUS: Device with no driver: device/console/0
[    0.497376]   Magic number: 1:252:3141
[    0.497426] /home/smb/oneiric-amd64/ubuntu-2.6/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    0.497437] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.497444] EDD information not available.
[    0.498007] Freeing unused kernel memory: 912k freed
[    0.498343] Write protecting the kernel read-only data: 12288k
[    0.506235] Freeing unused kernel memory: 2004k freed
[    0.507671] Freeing unused kernel memory: 1380k freed
[    0.560935] udev[59]: starting version 167
[    0.692128] EXT4-fs (xvde1): mounted filesystem with ordered data mode. Opts: (null)
[    0.908740] EXT4-fs (xvde1): re-mounted. Opts: (null)
[    0.938669] udev[206]: starting version 167
[    0.968617] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.186280] type=1400 audit(1304608434.208:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=294 comm="apparmor_parser"
[    1.191109] type=1400 audit(1304608434.218:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=294 comm="apparmor_parser"
[    1.191399] type=1400 audit(1304608434.218:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=294 comm="apparmor_parser"
[    1.535007] type=1400 audit(1304608434.558:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=401 comm="apparmor_parser"
[    1.538107] type=1400 audit(1304608434.558:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=401 comm="apparmor_parser"
[    1.538405] type=1400 audit(1304608434.558:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=401 comm="apparmor_parser"
[    1.547190] type=1400 audit(1304608434.568:8): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=402 comm="apparmor_parser"
[   12.210059] eth0: no IPv6 routers present
