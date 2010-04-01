Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab0DASof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:44:35 -0400
Received: from mailsrv1.kielnet.net ([89.27.130.243]:35695 "EHLO
	mailsrv1.kielnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab0DASoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:44:32 -0400
X-Greylist: delayed 1421 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2010 14:44:31 EDT
Message-ID: <4BB4E400.5090602@kielnet.net>
Date: Thu, 01 Apr 2010 20:20:48 +0200
From: "Jan.Grossmann@kielnet.net" <Jan.Grossmann@kielnet.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "Han, Weidong" <weidong.han@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: null pointer deref in dmar_ir_support
References: <4BAD1676.9090704@kielnet.net>	 <1270057394.2866.9.camel@sbs-t61.sc.intel.com>	 <4BB395B0.6090007@kielnet.net> <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
Content-Type: multipart/mixed;
 boundary="------------030001000607030704020803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030001000607030704020803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Suresh Siddha wrote:
> [Problem is in the x86 portion of the code, so copying x86 folks for
> their attention]
>
> On Wed, 2010-03-31 at 11:34 -0700, Jan.Grossmann@kielnet.net wrote:
>   
>>>> [    0.144012] BUG: unable to handle kernel NULL pointer dereference at 
>>>> 0000000000000025
>>>> [    0.148000] IP: [<ffffffff81199c96>] dmar_ir_support+0xb/0x14
>>>> [    0.148000] PGD 0
>>>> [    0.148000] Oops: 0000 [#1] SMP
>>>> [    0.148000] last sysfs file:
>>>> [    0.148000] CPU 0
>>>> [    0.148000] Modules linked in:
>>>> [    0.148000]
>>>> [    0.148000] Pid: 1, comm: swapper Not tainted 2.6.34-rc2 #4 A8N-SLI 
>>>> Premium/System Product Name
>>>> [    0.148000] RIP: 0010:[<ffffffff81199c96>]  [<ffffffff81199c96>] 
>>>> dmar_ir_support+0xb/0x14
>>>> [    0.148000] RSP: 0018:ffff88007fbe3e30  EFLAGS: 00010046
>>>> [    0.148000] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
>>>> 000000000000004c
>>>> [    0.148000] RDX: ffffffff81762338 RSI: 0000000000000046 RDI: 
>>>> 0000000000000010
>>>> [    0.148000] RBP: ffff88007fbe3e30 R08: 0000000000000002 R09: 
>>>> 000000000000000a
>>>> [    0.148000] R10: 0000000000000005 R11: 0000000000000000 R12: 
>>>> 0000000000000010
>>>> [    0.148000] R13: 0000000000000246 R14: 0000000000000000 R15: 
>>>> 000000000000e850
>>>> [    0.148000] FS:  0000000000000000(0000) GS:ffff880001a00000(0000) 
>>>> knlGS:0000000000000000
>>>> [    0.148000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> [    0.148000] CR2: 0000000000000025 CR3: 0000000001625000 CR4: 
>>>> 00000000000006f0
>>>> [    0.148000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>>>> 0000000000000000
>>>> [    0.148000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
>>>> 0000000000000400
>>>> [    0.148000] Process swapper (pid: 1, threadinfo ffff88007fbe2000, 
>>>> task ffff88007fbde740)
>>>> [    0.148000] Stack:
>>>> [    0.148000]  ffff88007fbe3e40 ffffffff816d1f01 ffff88007fbe3e50 
>>>> ffffffff816b7fa6
>>>> [    0.148000] <0> ffff88007fbe3ea0 ffffffff816b8095 ffff88007fbe3ec0 
>>>> ffffffff8130122e
>>>> [    0.148000] <0> ffff880000000008 ffff88007fbe3ed0 ffffffff8168ec20 
>>>> 0000000000000200
>>>> [    0.148000] Call Trace:
>>>> [    0.148000]  [<ffffffff816d1f01>] intr_remapping_supported+0x12/0x45
>>>> [    0.148000]  [<ffffffff816b7fa6>] enable_IR+0x9/0x5d
>>>> [    0.148000]  [<ffffffff816b8095>] enable_IR_x2apic+0x9b/0x1b6
>>>> [    0.148000]  [<ffffffff8130122e>] ? printk+0x3c/0x3e
>>>> [    0.148000]  [<ffffffff816b81f7>] APIC_init_uniprocessor+0x47/0x105
>>>> [    0.148000]  [<ffffffff816b62cf>] native_smp_prepare_cpus+0x190/0x365
>>>> [    0.148000]  [<ffffffff816ab5f5>] kernel_init+0x71/0x1f0
>>>> [    0.148000]  [<ffffffff810097e4>] kernel_thread_helper+0x4/0x10
>>>> [    0.148000]  [<ffffffff816ab584>] ? kernel_init+0x0/0x1f0
>>>> [    0.148000]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
>>>> [    0.148000] Code: ff c7 06 00 00 00 00 48 8b 04 fd 80 ba 42 81 eb 0d 
>>>> c7 06 02 00 00 00 48 c7 c0 e8 30 4a 81 c9 c3 48 8b 05 0e 4c 56 00 55 48 
>>>> 89 e5 <0f> b6 40 25 c9 83 e0 01 c3 55 48 89 e5 e8 7c 8f 16 00 c9 c3 55
>>>> [    0.148000] RIP  [<ffffffff81199c96>] dmar_ir_support+0xb/0x14
>>>> [    0.148000]  RSP <ffff88007fbe3e30>
>>>> [    0.148000] CR2: 0000000000000025
>>>>     
>>>>         
>
> Jan, Problem is that your system doesn't have proper SMP tables and we
> were doing enable_IR_x2apic() twice finally leading to this panic. Can
> you please check if the appended patch fixes your issue? Thanks.
> ---
>
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: fix calling enable_IR_x2apic() twice with SMP kernel on !SMP boards
>
> Jan Grossmann reported kernel boot panic while booting SMP kernel on his
> system with a single core cpu. SMP kernels call enable_IR_x2apic() from
> native_smp_prepare_cpus() and on platforms where the kernel doesn't
> find SMP configuration we ended up again calling enable_IR_x2apic() from the
> APIC_init_uniprocessor() call in the smp_sanity_check(). Thus leading to
> kernel panic.
>
> Don't call enable_IR_x2apic() and default_setup_apic_routing()
> from APIC_init_uniprocessor() in CONFIG_SMP case.
>
> Reported-by: Jan.Grossmann@kielnet.net
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org [2.6.32, 2.6.33]
> ---
>
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 00187f1..e5a4a1e 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1640,8 +1640,10 @@ int __init APIC_init_uniprocessor(void)
>  	}
>  #endif
>  
> +#ifndef CONFIG_SMP
>  	enable_IR_x2apic();
>  	default_setup_apic_routing();
> +#endif
>  
>  	verify_local_APIC();
>  	connect_bsp_APIC();
>
>
>
>   
The patch seems to work,
but now my kernel won't find any IDE, SATA or USB drives anymore and 
then i end up with

Kernel panic - not syncing: VFS: Unable to mount root fs on 
unknown-block(0,0)

of course.
the full boot log is attached.
thanks
Jan

--------------030001000607030704020803
Content-Type: text/x-log;
 name="boot4.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot4.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc3 (root@masa-server) (gcc version 4.3.1 (Debian 4.3.1-9) ) #1 SMP Thu Apr 1 10:49:29 CEST 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.34-rc3 root=/dev/sda3 ro console=ttyS0,19200
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-000000007fff0000
[    0.000000] ACPI: RSDP 00000000000f7c60 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 000000007fff3040 00030 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000007fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000007fff3180 06A16 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000007fff0000 00040
[    0.000000] ACPI: SSDT 000000007fff9cc0 000D6 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: MCFG 000000007fff9e00 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fff0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007fff0000
[    0.000000]   NODE_DATA [0000000001580180 - 000000000158517f]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001600000 s81192 r8192 d21208 u2097152
[    0.000000] pcpu-alloc: s81192 r8192 d21208 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516991
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.34-rc3 root=/dev/sda3 ro console=ttyS0,19200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 308000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Subtract (37 early reservations)
[    0.000000]   #1 [0001000000 - 000157f244]   TEXT DATA BSS
[    0.000000]   #2 [000009f800 - 0000100000]   BIOS reserved
[    0.000000]   #3 [0001580000 - 000158015d]             BRK
[    0.000000]   #4 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #5 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #6 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #7 [0001580180 - 0001585180]       NODE_DATA
[    0.000000]   #8 [0001585180 - 0001586180]         BOOTMEM
[    0.000000]   #9 [000157f280 - 000157f400]         BOOTMEM
[    0.000000]   #10 [0001d87000 - 0001d88000]         BOOTMEM
[    0.000000]   #11 [0001d88000 - 0001d89000]         BOOTMEM
[    0.000000]   #12 [0001e00000 - 0003a00000]        MEMMAP 0
[    0.000000]   #13 [000157f400 - 000157f580]         BOOTMEM
[    0.000000]   #14 [0001586180 - 0001592180]         BOOTMEM
[    0.000000]   #15 [0001593000 - 0001594000]         BOOTMEM
[    0.000000]   #16 [000157f580 - 000157f778]         BOOTMEM
[    0.000000]   #17 [000157f780 - 000157f7e8]         BOOTMEM
[    0.000000]   #18 [000157f800 - 000157f868]         BOOTMEM
[    0.000000]   #19 [000157f880 - 000157f8e8]         BOOTMEM
[    0.000000]   #20 [000157f900 - 000157f968]         BOOTMEM
[    0.000000]   #21 [000157f980 - 000157f9e8]         BOOTMEM
[    0.000000]   #22 [000157fa00 - 000157fa68]         BOOTMEM
[    0.000000]   #23 [000157fa80 - 000157fae8]         BOOTMEM
[    0.000000]   #24 [000157fb00 - 000157fb68]         BOOTMEM
[    0.000000]   #25 [000157fb80 - 000157fba0]         BOOTMEM
[    0.000000]   #26 [000157fbc0 - 000157fc0a]         BOOTMEM
[    0.000000]   #27 [000157fc40 - 000157fc8a]         BOOTMEM
[    0.000000]   #28 [0001600000 - 000161b000]         BOOTMEM
[    0.000000]   #29 [000157fcc0 - 000157fcc8]         BOOTMEM
[    0.000000]   #30 [000157fd00 - 000157fd08]         BOOTMEM
[    0.000000]   #31 [000157fd40 - 000157fd44]         BOOTMEM
[    0.000000]   #32 [000157fd80 - 000157fd88]         BOOTMEM
[    0.000000]   #33 [000157fdc0 - 000157ff10]         BOOTMEM
[    0.000000]   #34 [000157ff40 - 000157ffc0]         BOOTMEM
[    0.000000]   #35 [0001592180 - 0001592200]         BOOTMEM
[    0.000000]   #36 [0001594000 - 000159c000]         BOOTMEM
[    0.000000] Memory: 2062072k/2097088k available (2753k kernel code, 452k absent, 34564k reserved, 1497k data, 548k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:256
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.419 MHz processor.
[    0.012005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.83 BogoMIPS (lpj=8041676)
[    0.020139] Security Framework initialized
[    0.024006] SELinux:  Disabled at boot.
[    0.028187] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.033340] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.036692] Mount-cache hash table entries: 256
[    0.040172] Initializing cgroup subsys ns
[    0.044004] Initializing cgroup subsys cpuacct
[    0.048005] Initializing cgroup subsys devices
[    0.052002] Initializing cgroup subsys freezer
[    0.056003] Initializing cgroup subsys net_cls
[    0.060054] mce: CPU supports 5 MCE banks
[    0.064011] Performance Events: AMD PMU driver.
[    0.072003] ... version:                0
[    0.076001] ... bit width:              48
[    0.080001] ... generic registers:      4
[    0.084001] ... value mask:             0000ffffffffffff
[    0.088002] ... max period:             00007fffffffffff
[    0.092001] ... fixed-purpose events:   0
[    0.096001] ... event mask:             000000000000000f
[    0.100023] SMP alternatives: switching to UP code
[    0.109528] Freeing SMP alternatives: 28k freed
[    0.112012] ACPI: Core revision 20100121
[    0.125041] ACPI: setting ELCR to 0200 (from 0828)
[    0.129306] Setting APIC routing to flat
[    0.132003] weird, boot CPU (#0) not listed by the BIOS.
[    0.136001] SMP motherboard not detected.
[    0.144000] SMP disabled
[    0.144127] Brought up 1 CPUs
[    0.148003] Total of 1 processors activated (4020.83 BogoMIPS).
[    0.152649] regulator: core version 0.5
[    0.156097] NET: Registered protocol family 16
[    0.160308] TOM: 0000000080000000 aka 2048M
[    0.164036] ACPI: bus type pci registered
[    0.168127] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.172017] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.194294] PCI: Using configuration type 1 for base access
[    0.201218] bio: create slab <bio-0> at 0
[    0.213918] ACPI: Interpreter enabled
[    0.216004] ACPI: (supports S0 S1 S3 S4 S5)
[    0.228006] ACPI: Using PIC for interrupt routing
[    0.245638] ACPI: No dock devices found.
[    0.248035] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.252127] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.256333] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.260655] pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.264044] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    0.268031] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.272031] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    0.276090] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    0.352743] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.377242] ACPI: PCI Interrupt Link [LNK2] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    0.397240] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.416148] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.441237] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.468138] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.493237] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.517237] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.541239] ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.560148] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.585239] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.612148] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.637237] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.661247] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.681819] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.701246] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.725262] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.737258] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.749258] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.761258] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.773196] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    0.788173] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    0.805266] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    0.821265] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
[    0.840175] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
[    0.861265] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    0.877265] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    0.896175] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    0.913265] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.929274] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    0.945274] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    0.964118] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    0.981280] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.984003] vgaarb: loaded
[    0.988080] usbcore: registered new interface driver usbfs
[    0.992066] usbcore: registered new interface driver hub
[    0.996044] usbcore: registered new device driver usb
[    1.000153] PCI: Using ACPI for IRQ routing
[    1.004022] pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
[    1.008038] Expanded resource reserved due to conflict with PCI Bus #00
[    1.012165] Switching to clocksource tsc
[    1.017377] pnp: PnP ACPI init
[    1.035676] ACPI: bus type pnp registered
[    1.065425] pnp: PnP ACPI: found 15 devices
[    1.090500] ACPI: ACPI bus type pnp unregistered
[    1.118158] system 00:01: [io  0x4000-0x407f] has been reserved
[    1.153607] system 00:01: [io  0x4080-0x40ff] has been reserved
[    1.189018] system 00:01: [io  0x4400-0x447f] has been reserved
[    1.224429] system 00:01: [io  0x4480-0x44ff] has been reserved
[    1.259837] system 00:01: [io  0x4800-0x487f] has been reserved
[    1.295247] system 00:01: [io  0x4880-0x48ff] has been reserved
[    1.330661] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    1.366067] system 00:02: [io  0x0800-0x087f] has been reserved
[    1.401477] system 00:02: [io  0x0290-0x0297] has been reserved
[    1.436893] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    1.476459] system 00:0e: [mem 0x000d5000-0x000d7fff] has been reserved
[    1.516028] system 00:0e: [mem 0x000f0000-0x000f7fff] could not be reserved
[    1.557677] system 00:0e: [mem 0x000f8000-0x000fbfff] could not be reserved
[    1.599327] system 00:0e: [mem 0x000fc000-0x000fffff] could not be reserved
[    1.640975] system 00:0e: [mem 0x7fff0000-0x7fffffff] could not be reserved
[    1.682626] system 00:0e: [mem 0xffff0000-0xffffffff] has been reserved
[    1.722195] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.763846] system 00:0e: [mem 0x00100000-0x7ffeffff] could not be reserved
[    1.805494] system 00:0e: [mem 0xfec00000-0xfec00fff] has been reserved
[    1.845065] system 00:0e: [mem 0xfee00000-0xfeefffff] has been reserved
[    1.884633] system 00:0e: [mem 0xfefff000-0xfeffffff] has been reserved
[    1.924202] system 00:0e: [mem 0xfff80000-0xfff80fff] has been reserved
[    1.963773] system 00:0e: [mem 0xfff90000-0xfffbffff] has been reserved
[    2.003346] system 00:0e: [mem 0xfffed000-0xfffeffff] has been reserved
[    2.047840] pci 0000:00:02.1: BAR 0: assigned [mem 0x80000000-0x800000ff]
[    2.088464] pci 0000:00:02.1: BAR 0: set to [mem 0x80000000-0x800000ff] (PCI address [0x80000000-0x800000ff]
[    2.147271] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    2.178523] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
[    2.214972] pci 0000:00:09.0:   bridge window [mem 0xd3000000-0xd4ffffff]
[    2.255580] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    2.292031] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    2.323278] pci 0000:00:0b.0:   bridge window [io  disabled]
[    2.357130] pci 0000:00:0b.0:   bridge window [mem disabled]
[    2.390980] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    2.427431] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    2.458679] pci 0000:00:0c.0:   bridge window [io  disabled]
[    2.492530] pci 0000:00:0c.0:   bridge window [mem disabled]
[    2.526381] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    2.562831] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    2.594078] pci 0000:00:0d.0:   bridge window [io  disabled]
[    2.627930] pci 0000:00:0d.0:   bridge window [mem disabled]
[    2.661781] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    2.698232] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    2.729480] pci 0000:00:0e.0:   bridge window [io  0x9000-0x9fff]
[    2.765930] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd2ffffff]
[    2.806541] pci 0000:00:0e.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    2.853009] NET: Registered protocol family 2
[    2.879198] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    2.922861] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    2.970234] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.010990] TCP: Hash tables configured (established 262144 bind 65536)
[    3.050567] TCP reno registered
[    3.069345] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    3.105341] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    3.144041] NET: Registered protocol family 1
[    3.183061] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.215915] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    3.249246] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.282054] pci 0000:00:0b.0: Linking AER extended capability
[    3.316453] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.349287] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    3.382619] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.415424] pci 0000:00:0c.0: Linking AER extended capability
[    3.449830] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.482659] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    3.515991] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.548797] pci 0000:00:0d.0: Linking AER extended capability
[    3.583203] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.616031] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    3.649364] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.682169] pci 0000:00:0e.0: Linking AER extended capability
[    3.717399] audit: initializing netlink socket (disabled)
[    3.749731] type=2000 audit(1270145375.749:1): initialized
[    3.782751] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.821027] VFS: Disk quotas dquot_6.5.2
[    3.844540] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.883157] msgmni has been set to 4027
[    3.906252] alg: No test for stdrng (krng)
[    3.930831] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.975123] io scheduler noop registered
[    3.998570] io scheduler deadline registered
[    4.024124] io scheduler cfq registered (default)
[    4.056052] Linux agpgart interface v0.103
[    4.080615] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.118458] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.154782] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.189941] brd: module loaded
[    4.208435] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    4.256734] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.286432] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.316808] mice: PS/2 mouse device common for all mice
[    4.348152] rtc_cmos 00:04: RTC can wake from S4
[    4.375833] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    4.412338] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    4.446772] cpuidle: using governor ladder
[    4.471289] cpuidle: using governor menu
[    4.494781] No iBFT detected.
[    4.512763] TCP cubic registered
[    4.532060] NET: Registered protocol family 17
[    4.558778] registered taskstats version 1
[    4.583502] rtc_cmos 00:04: setting system clock to 2010-04-01 18:09:43 UTC (1270145383)
[    4.646253] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.702763] List of all partitions:
[    4.723621] No filesystem could mount root, tried: 
[    4.752839] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    4.802290] Pid: 1, comm: swapper Not tainted 2.6.34-rc3 #1
[    4.835620] Call Trace:
[    4.850238]  [<ffffffff812ac0e1>] ? panic+0x85/0xff
[    4.879405]  [<ffffffff810cadd9>] ? interleave_nodes+0x51/0x70
[    4.914293]  [<ffffffff8111ee85>] ? __bdevname+0x29/0x2e
[    4.946064]  [<ffffffff8143d17b>] ? mount_block_root+0x25e/0x275
[    4.981994]  [<ffffffff81002930>] ? ret_from_sys_call+0x0/0x5
[    5.016363]  [<ffffffff8143d344>] ? prepare_namespace+0x163/0x18d
[    5.052814]  [<ffffffff8143c6e7>] ? kernel_init+0x1d9/0x1e9
[    5.086143]  [<ffffffff810036d4>] ? kernel_thread_helper+0x4/0x10
[    5.122594]  [<ffffffff8143c50e>] ? kernel_init+0x0/0x1e9
[    5.154882]  [<ffffffff810036d0>] ? kernel_thread_helper+0x0/0x10


--------------030001000607030704020803--
