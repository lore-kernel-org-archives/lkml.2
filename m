Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1GTSfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:35:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:30108 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1GTSfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:35:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,236,1309762800"; 
   d="scan'208";a="32631199"
Message-ID: <4E271FF2.70102@linux.intel.com>
Date: Wed, 20 Jul 2011 11:35:30 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Carsten Emde <ce@ceag.ch>, Clark Williams <williams@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [ANNOUNCE] 3.0-rc7-rt0 (hang then panic on dual socket xeon)
References: <alpine.LFD.2.02.1107200153070.2702@ionos> <4E270A10.4040202@linux.intel.com>
In-Reply-To: <4E270A10.4040202@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Full dmesg with LOG_BUF_SHIFT = 21 per tglx's request appended below:

On 07/20/2011 10:02 AM, Darren Hart wrote:
> On 07/19/2011 05:37 PM, Thomas Gleixner wrote:
>  
>>    What's needed?
>>
>>    - Testing, testing, testing ... you know the drill (good bug
>>      reports are 98% of the solution)
>>
> 
> Hi Thomas,
> 
> I built 3.0.0-rc7-rt0 for a dual socket xeon x5680 (12 cores, 24 threads), .config attached.


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc7-rt0+ (dvhart@rage) (gcc version 4.4.5
(Ubuntu/Linaro 4.4.4-14ubuntu5) ) #2 SMP PREEMPT Wed Jul 20 11:25:36 PDT 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.0.0-rc7-rt0+
root=UUID=3b6dee75-6fe1-4b61-ad27-51aa7d29daf9 ro console=tty0
console=ttyS1,115200n8
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
[    0.000000]  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000] RAMDISK: 36df9000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fabe0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 0006C (v01 SMCI            20110105
MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 000F4 (v03 010511 FACP1122 20110105
MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7906a0 0655C (v01  10006 10006000 00000000
INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 0011E (v01 010511 APIC1122 20110105
MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7904b0 0003C (v01 010511 OEMMCFG  20110105
MSFT 00000097)
[    0.000000] ACPI: SLIT 00000000bf7904f0 00030 (v01 010511 OEMSLIT  20110105
MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 00085 (v01 010511 OEMB1122 20110105
MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf79a6a0 00250 (v01 010511 OEMSRAT  00000001
INTL 00000001)
[    0.000000] ACPI: HPET 00000000bf79a8f0 00038 (v01 010511 OEMHPET  20110105
MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf79e0d0 00128 (v01    AMI  OEMDMAR 00000001
MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf7a6140 00363 (v01 DpgPmm    CpuPm 00000012
INTL 20051117)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-240000000
[    0.000000] SRAT: Node 1 PXM 1 240000000-440000000
[    0.000000] NUMA: Node 0 [0,a0000) + [100000,c0000000) -> [0,c0000000)
[    0.000000] NUMA: Node 0 [0,c0000000) + [100000000,240000000) ->
[0,240000000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000240000000
[    0.000000]   NODE_DATA [000000023fffb000 - 000000023fffffff]
[    0.000000] Initmem setup node 1 0000000240000000-0000000440000000
[    0.000000]   NODE_DATA [000000043fffa000 - 000000043fffefff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000]     1: 0x00240000 -> 0x00440000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 7, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 000000000009a000
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:24 nr_cpumask_bits:24 nr_cpu_ids:24
nr_node_ids:2
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88023fc00000 s72704 r8192
d21504 u131072
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total
pages: 4131092
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.0-rc7-rt0+
root=UUID=3b6dee75-6fe1-4b61-ad27-51aa7d29daf9 ro console=tty0
console=ttyS1,115200n8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16435728k/17825792k available (5986k kernel code,
1057692k absent, 332372k reserved, 5056k data, 836k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1280 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled

< Sits here for ~60 seconds >

[    0.000000] console [ttyS1] enabled
[    0.000000] allocated 536870912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want
memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 3333.451 MHz processor.
[    0.000006] Calibrating delay loop (skipped), value calculated using timer
frequency.. 6666.90 BogoMIPS (lpj=33334510)
[    0.000009] pid_max: default: 32768 minimum: 301
[    0.000152] Security Framework initialized
[    0.000162] AppArmor: AppArmor initialized
[    0.002594] Dentry cache hash table entries: 2097152 (order: 12, 16777216
bytes)
[    0.006613] Inode-cache hash table entries: 1048576 (order: 11, 8388608
bytes)
[    0.007978] Mount-cache hash table entries: 256
[    0.008219] Initializing cgroup subsys cpuacct
[    0.008224] Initializing cgroup subsys memory
[    0.008247] Initializing cgroup subsys devices
[    0.008249] Initializing cgroup subsys freezer
[    0.008250] Initializing cgroup subsys net_cls
[    0.008303] CPU: Physical Processor ID: 0
[    0.008303] CPU: Processor Core ID: 0
[    0.008307] mce: CPU supports 9 MCE banks
[    0.008315] CPU0: Thermal monitoring enabled (TM1)
[    0.008322] using mwait in idle threads.
[    0.008944] ACPI: Core revision 20110413
[    0.040258] ftrace: allocating 22348 entries in 88 pages
[    0.045593] DMAR: Host address width 40
[    0.045595] DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
[    0.045605] IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap
f020fe
[    0.045607] DMAR: RMRR base: 0x000000000e4000 end: 0x000000000e7fff
[    0.045608] DMAR: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
[    0.045609] DMAR: ATSR flags: 0x0
[    0.045708] IOAPIC id 6 under DRHD base  0xfbffe000 IOMMU 0
[    0.045709] IOAPIC id 7 under DRHD base  0xfbffe000 IOMMU 0
[    0.045879] Enabled Interrupt-remapping
[    0.045883] Switched APIC routing to physical flat.
[    0.046344] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.146290] CPU0: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz stepping 02
[    0.269078] APIC calibration not consistent with PM-Timer: 109ms instead of
100ms
[    0.269079] APIC delta adjusted to PM-Timer: 833362 (916698)
[    0.269084] Performance Events: PEBS fmt1+, Westmere events, Intel PMU
driver.
[    0.269088] ... version:                3
[    0.269089] ... bit width:              48
[    0.269090] ... generic registers:      4
[    0.269090] ... value mask:             0000ffffffffffff
[    0.269091] ... max period:             000000007fffffff
[    0.269092] ... fixed-purpose events:   3
[    0.269093] ... event mask:             000000070000000f
[    0.429024] Booting Node   0, Processors  #1
[    0.429028] smpboot cpu 1: start_ip = 94000
[    0.668891]  #2
[    0.668894] smpboot cpu 2: start_ip = 94000
[    0.908749]  #3
[    0.908752] smpboot cpu 3: start_ip = 94000
[    1.148594]  #4
[    1.148596] smpboot cpu 4: start_ip = 94000
[    1.388448]  #5
[    1.388451] smpboot cpu 5: start_ip = 94000
[    1.628301]  Ok.
[    1.628303] Booting Node   1, Processors  #6
[    1.628306] smpboot cpu 6: start_ip = 94000
[    1.868145]  #7
[    1.868147] smpboot cpu 7: start_ip = 94000
[    2.108000]  #8
[    2.108002] smpboot cpu 8: start_ip = 94000
[    2.347850]  #9
[    2.347852] smpboot cpu 9: start_ip = 94000
[    2.587708]  #10
[    2.587710] smpboot cpu 10: start_ip = 94000
[    2.827551]  #11
[    2.827553] smpboot cpu 11: start_ip = 94000
[    3.067411]  Ok.
[    3.067413] Booting Node   0, Processors  #12
[    3.067418] smpboot cpu 12: start_ip = 94000
[    3.307266]  #13
[    3.307269] smpboot cpu 13: start_ip = 94000
[    3.547112]  #14
[    3.547115] smpboot cpu 14: start_ip = 94000
[    3.786968]  #15
[    3.786972] smpboot cpu 15: start_ip = 94000
[    7.958852] calibrate_delay_direct() dropping max bogoMips estimate 4 =
13415527832
[   32.091103]  #16
[   32.091105] smpboot cpu 16: start_ip = 94000
[   37.133978] CPU16: Stuck ??
[   60.245289]  #17
[   60.245290] smpboot cpu 17: start_ip = 94000
[   65.288458] CPU17: Stuck ??
[   88.399516]  Ok.
[   88.399517] Booting Node   1, Processors  #18
[   88.399519] smpboot cpu 18: start_ip = 94000
[   92.421531] BUG: unable to handle kernel NULL pointer dereference at
(null)
[   92.421534] IP: [<ffffffff81154b2f>] kfree+0x15f/0x2f0
[   92.421540] PGD 0
[   92.421541] Oops: 0000 [#1] PREEMPT SMP
[   92.421544] CPU 16
[   92.421544] Modules linked in:
[   92.421546]
[   92.421547] Pid: 0, comm: kworker/0:1 Not tainted 3.0.0-rc7-rt0+ #2
Supermicro X8DTL/X8DTL
[   92.421550] RIP: 0010:[<ffffffff81154b2f>]  [<ffffffff81154b2f>]
kfree+0x15f/0x2f0
[   92.421553] RSP: 0000:ffff880227081e08  EFLAGS: 00010046
[   92.421555] RAX: 0000000000000000 RBX: ffff88023f800580 RCX: ffff880227623c40
[   92.421557] RDX: 0200000000000080 RSI: 0000000000000000 RDI: ffff88022778b3c0
[   92.421558] RBP: ffff880227081e48 R08: 0000000000000001 R09: 0000000000000000
[   92.421560] R10: 0000000000000009 R11: 00000000ffffffff R12: 0000000000000000
[   92.421562] R13: ffff88022778b3c0 R14: 0000000000000000 R15: 0000000000000000
[   92.421564] FS:  0000000000000000(0000) GS:ffff88023fd40000(0000)
knlGS:0000000000000000
[   92.421566] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   92.421568] CR2: 0000000000000000 CR3: 0000000001a06000 CR4: 00000000000006e0
[   92.421570] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   92.421572] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   92.421574] Process kworker/0:1 (pid: 0, threadinfo ffff880227080000, task
ffff88022707e1c0)
[   92.421576] Stack:
[   92.421577]  000000000000bb18 ffff88022778b3c0 0000000000000000
000000000000bc58
[   92.421579]  0000000000000010 0000000000000009 ffff88023fd4ad80
000000000000ad80
[   92.421582]  ffff880227081ea8 ffffffff8101c575 ffff880227081e88
ffffffff8102042b
[   92.421584] Call Trace:
[   92.421589]  [<ffffffff8101c575>] intel_pmu_cpu_starting+0x125/0x1b0
[   92.421591]  [<ffffffff8102042b>] ? __mcheck_cpu_init_timer+0xbb/0xc0
[   92.421595]  [<ffffffff815c1645>] x86_pmu_notifier+0x57/0x65
[   92.421599]  [<ffffffff815d1326>] notifier_call_chain+0x56/0x80
[   92.421603]  [<ffffffff81089a5e>] __raw_notifier_call_chain+0xe/0x10
[   92.421605]  [<ffffffff810610f0>] __cpu_notify+0x20/0x40
[   92.421608]  [<ffffffff815c4cda>] notify_cpu_starting+0x29/0x2b
[   92.421610]  [<ffffffff815c3435>] start_secondary+0x112/0x1c9
[   92.421612] Code: 0f 88 63 01 00 00 48 8b 10 84 d2 0f 89 54 01 00 00 48 8b 40
30 44 0f b7 78 28 65 8b 04 25 08 d5 00 00 41 39 c7 0f 85 cd 00 00 00
[   92.421622]  8b 06 41 3b 46 04 0f 83 ad 00 00 00 89 c2 83 c0 01 4d 89 6c
[   92.421627] RIP  [<ffffffff81154b2f>] kfree+0x15f/0x2f0
[   92.421629]  RSP <ffff880227081e08>
[   92.421630] CR2: 0000000000000000
[   93.033042] ---[ end trace 0000000000000001 ]---
[   93.033045] Kernel panic - not syncing: Attempted to kill the idle task!
[   93.033047] Pid: 0, comm: kworker/0:1 Tainted: G      D     3.0.0-rc7-rt0+ #2
[   93.033049] Call Trace:
[   93.033051]  [<ffffffff815cab60>] panic+0x9b/0x1a8
[   93.033054]  [<ffffffff81064093>] do_exit+0x6d3/0x910
[   93.033057]  [<ffffffff8105f732>] ? kmsg_dump+0xd2/0x110
[   93.033060]  [<ffffffff815ceec0>] oops_end+0xb0/0xf0
[   93.033063]  [<ffffffff8103c70b>] no_context+0xfb/0x260
[   93.033066]  [<ffffffff8103c995>] __bad_area_nosemaphore+0x125/0x1e0
[   93.033068]  [<ffffffff8103ca63>] bad_area_nosemaphore+0x13/0x20
[   93.033070]  [<ffffffff815d0f16>] do_page_fault+0x336/0x550
[   93.033073]  [<ffffffff815bea77>] ? cpuid4_cache_lookup_regs+0x3bf/0x427
[   93.033076]  [<ffffffff815ce245>] page_fault+0x25/0x30
[   93.033078]  [<ffffffff81154b2f>] ? kfree+0x15f/0x2f0
[   93.033080]  [<ffffffff81154ade>] ? kfree+0x10e/0x2f0
[   93.033082]  [<ffffffff8101c575>] intel_pmu_cpu_starting+0x125/0x1b0
[   93.033085]  [<ffffffff8102042b>] ? __mcheck_cpu_init_timer+0xbb/0xc0
[   93.033087]  [<ffffffff815c1645>] x86_pmu_notifier+0x57/0x65
[   93.033089]  [<ffffffff815d1326>] notifier_call_chain+0x56/0x80
[   93.033092]  [<ffffffff81089a5e>] __raw_notifier_call_chain+0xe/0x10
[   93.033094]  [<ffffffff810610f0>] __cpu_notify+0x20/0x40
[   93.033096]  [<ffffffff815c4cda>] notify_cpu_starting+0x29/0x2b
[   93.033098]  [<ffffffff815c3435>] start_secondary+0x112/0x1c9



-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
