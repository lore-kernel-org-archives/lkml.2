Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab2JAOoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:44:09 -0400
Received: from nm22.bullet.mail.sp2.yahoo.com ([98.139.91.92]:23408 "HELO
	nm22.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751165Ab2JAOoD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:44:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 334741.46096.bm@omp1023.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GA6Bg4MBWLWjiY6FerrOOZpk3+LCz9Ct0Y/nsIYQW5TGnvJwl1NPZD6lASO1oL/SdOWWJaPgwERebUBcM7EaKkoXXuFZlLOnzfTiMDZLTVXkxwsjwunA6f/aTLEe8MTPlTrtMYmNTgByjTwdyiedGiEwT2Ldt9JW+ZMU0odg8Ho=;
X-YMail-OSG: 7T8690YVM1m7kuQwIaPHC0_Jgg6VBbbGpg0l.g9xd5fNuF7
 5OEW3frcT2hY4cpyy0HCNi3ayrjrELRRLQdr.Kxu.f9aIkZb_rePhs.AgERI
 FsPrtYK0TEtdAiENBuQMe_CHw2tFnnEvZSr0egO5lhG33boWrDnCPeXzkZow
 rgBIR_DQfnyWv1HJIDj6Qn12hUmAb3gmeBt68Y.it8nhCHZB3JoM7L.mUe_e
 g5fFCBG_0QNqrhbiztbkBXEw6sZzMeVcWU07aSgA92KJe_XrXo1K.fgyJwUO
 Aqw782VBmlpBEecFUvk4TalvvwMArm.AdfsCTan8L_0QOvrQh7jMluyCp5Q8
 6Dg5dEdjWqQN0vxF0HlBCWYE5k74mX_JRC3avRNHFOts6gd.UhpiU7GoUbkV
 J2gNzj7ErgzUOz7t517XE5ZFAY7pHur5z_sJBh8V_.R_JVqk85BUW3_dfv5y
 .WjOkjWs..odXq54jhGBdg.gHXtoOK8XJremNFWEmcQMuzNjJi5KplvaW7Zq
 rPNSlZmimsAbJeHpt7h7PPY1iXQyTwhShR6tLNv6_etcH7529tKHXnwFWR7N
 jquor
X-Mailer: YahooMailWebService/0.8.122.442
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com> <20120928121917.GF5368@mwanda> <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com> <20120929072527.GA13767@mwanda>  
Message-ID: <1349102641.41622.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Mon, 1 Oct 2012 07:44:01 -0700 (PDT)
From: Kevin Cruz <skate_ops@yahoo.com>
Reply-To: Kevin Cruz <skate_ops@yahoo.com>
Subject: Re: iwlwifi can't connect to router after resuming from suspend.
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can compile it under ubuntu.  I looked on google to find

> directions but everyone had bad advice.  This might work:

> apt-get build-dep linux-image-$(uname -r)
> download and unpack the kernel from kernel.org
> make localmodconfig
> make
> make modules_install install
> reboot

> If it doesn't then having the dmesg from Sabayon live disk will have
> to be enough.  We can open a bug for that on bugzilla and CC the
> wireless people.

I was able to build and install the kernel (3.6-rc7) successfully but I
still can't connect after suspend.  I'm not sure it matters but for the
`make localmodconfig` I just answered each request with whichever was
capital, and for the multi options I just answered whichever had `>` which
was always 1.  The letter that is capital (like `N/y` or `Y/n`) is the
recommended answer, correct?  If needed I don't mind retrying to build it
with different configurations.

For right now, I'm gonna give some [boot options][1] I found a shot.

  [1]: http://ubuntuforums.org/showthread.php?t=1613132

Here's the dmesg from in my new Ubuntu kernel:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc7 (cyber@cyber-linux) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Sun Sep 30 09:51:00 EDT 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc7 root=UUID=4b13fd9f-6602-4289-b822-c0b28ed6f65b ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009ce3efff] usable
[    0.000000] BIOS-e820: [mem 0x000000009ce3f000-0x000000009cebefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009cebf000-0x000000009cfbefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009cfbf000-0x000000009cffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009cfff000-0x000000009cffffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d000000-0x000000009f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb00000-0x00000000feb03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000025fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: Hewlett-Packard HP Pavilion dv6 Notebook PC/17F9, BIOS F.19 05/21/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x25fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 09D000000 mask FFF000000 uncachable
[    0.000000]   3 base 09E000000 mask FFE000000 uncachable
[    0.000000]   4 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   5 base 100000000 mask F00000000 write-back
[    0.000000]   6 base 200000000 mask FC0000000 write-back
[    0.000000]   7 base 240000000 mask FF0000000 write-back
[    0.000000]   8 base 250000000 mask FF0000000 write-back
[    0.000000]   9 base 25FE00000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x9d000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fe1b0-0x000fe1bf] mapped at [ffff8800000fe1b0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x9cffffff]
[    0.000000]  [mem 0x00000000-0x9cffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x9cffffff @ [mem 0x1fb14000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x25fdfffff]
[    0.000000]  [mem 0x100000000-0x25fdfffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x25fdfffff @ [mem 0x9ce34000-0x9ce3efff]
[    0.000000] RAMDISK: [mem 0x37ae8000-0x37d6bfff]
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 000000009cffe120 00094 (v01 HPQOEM SLIC-MPC 00000001      01000013)
[    0.000000] ACPI: FACP 000000009cffc000 000F4 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000009cfeb000 0DAE4 (v01 HP     INSYDE   00000000 MSFT 01000013)
[    0.000000] ACPI: FACS 000000009cf6c000 00040
[    0.000000] ACPI: ASF! 000000009cffd000 000A5 (v32 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: HPET 000000009cffb000 00038 (v01 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000009cffa000 0008C (v02 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000009cff9000 0003C (v01 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 000000009cfea000 00176 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009cfe9000 0051F (v01 HP     INSYDE   00001000 MSFT 01000013)
[    0.000000] ACPI: BOOT 000000009cfe7000 00028 (v01 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: ASPT 000000009cfe4000 00034 (v07 HP     INSYDE   00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009cfe3000 0094E (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfe2000 00996 (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfe1000 002DA (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfe0000 0035D (v01 HP     INSYDE   00003000 INTL 20100121)
[    0.000000] ACPI: SSDT 000000009cfda000 024A1 (v01 HP     INSYDE   00001000 INTL 20100121)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000025fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x25fdfffff]
[    0.000000]   NODE_DATA [mem 0x25fdfc000-0x25fdfffff]
[    0.000000]  [ffffea0000000000-ffffea00097fffff] PMD -> [ffff880257400000-ffff88025f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x25fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x9ce3efff]
[    0.000000]   node   0: [mem 0x9cfff000-0x9cffffff]
[    0.000000]   node   0: [mem 0x100000000-0x25fdfffff]
[    0.000000] On node 0 totalpages: 2083789
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 622208 pages, LIFO batch:31
[    0.000000]   Normal zone: 22520 pages used for memmap
[    0.000000]   Normal zone: 1418760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000009ce3f000 - 000000009cebf000
[    0.000000] PM: Registered nosave memory: 000000009cebf000 - 000000009cfbf000
[    0.000000] PM: Registered nosave memory: 000000009cfbf000 - 000000009cfff000
[    0.000000] PM: Registered nosave memory: 000000009d000000 - 000000009fa00000
[    0.000000] PM: Registered nosave memory: 000000009fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
[    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
[    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
[    0.000000] e820: [mem 0x9fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88025fa00000 s84416 r8192 d22080 u262144
[    0.000000] pcpu-alloc: s84416 r8192 d22080 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2044879
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc7 root=UUID=4b13fd9f-6602-4289-b822-c0b28ed6f65b ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8118728k/9959424k available (6493k kernel code, 1624268k absent, 216428k reserved, 6677k data, 920k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]     RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2195.049 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.09 BogoMIPS (lpj=8780196)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000024] Security Framework initialized
[    0.000035] AppArmor: AppArmor initialized
[    0.000591] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002340] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003076] Mount-cache hash table entries: 256
[    0.003248] Initializing cgroup subsys cpuacct
[    0.003250] Initializing cgroup subsys devices
[    0.003251] Initializing cgroup subsys freezer
[    0.003253] Initializing cgroup subsys blkio
[    0.003254] Initializing cgroup subsys perf_event
[    0.003276] CPU: Physical Processor ID: 0
[    0.003277] CPU: Processor Core ID: 0
[    0.003281] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.003281] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.003284] mce: CPU supports 9 MCE banks
[    0.003295] CPU0: Thermal monitoring handled by SMI
[    0.003302] process: using mwait in idle threads
[    0.003305] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.003305] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.003305] tlb_flushall_shift is 0x5
[    0.005966] ACPI: Core revision 20120711
[    0.029862] ftrace: allocating 24288 entries in 95 pages
[    0.043241] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.082884] smpboot: CPU0: Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz stepping 07
[    0.188159] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.188165] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.188167] ... version:                3
[    0.188168] ... bit width:              48
[    0.188169] ... generic registers:      4
[    0.188170] ... value mask:             0000ffffffffffff
[    0.188171] ... max period:             000000007fffffff
[    0.188172] ... fixed-purpose events:   3
[    0.188173] ... event mask:             000000070000000f
[    0.188345] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.199570] CPU1: Thermal monitoring handled by SMI
[    0.212806] CPU2: Thermal monitoring handled by SMI
[    0.226026] CPU3: Thermal monitoring handled by SMI
[    0.239254] CPU4: Thermal monitoring handled by SMI
[    0.252480] CPU5: Thermal monitoring handled by SMI
[    0.265699] CPU6: Thermal monitoring handled by SMI
[    0.188444] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
[    0.278921] CPU7: Thermal monitoring handled by SMI
[    0.281060] Brought up 8 CPUs
[    0.281064] smpboot: Total of 8 processors activated (35120.78 BogoMIPS)
[    0.288921] devtmpfs: initialized
[    0.290044] EVM: security.selinux
[    0.290045] EVM: security.SMACK64
[    0.290046] EVM: security.capability
[    0.290086] PM: Registering ACPI NVS region [mem 0x9cebf000-0x9cfbefff] (1048576 bytes)
[    0.290820] dummy:
[    0.290851] RTC time: 10:54:11, date: 09/30/12
[    0.290888] NET: Registered protocol family 16
[    0.291025] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.291027] ACPI: bus type pci registered
[    0.291080] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.291083] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.313297] PCI: Using configuration type 1 for base access
[    0.314184] bio: create slab <bio-0> at 0
[    0.314250] ACPI: Added _OSI(Module Device)
[    0.314252] ACPI: Added _OSI(Processor Device)
[    0.314253] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.314255] ACPI: Added _OSI(Processor Aggregator Device)
[    0.316013] ACPI: EC: Look up EC in DSDT
[    0.317705] ACPI: Executed 1 blocks of module-level executable AML code
[    0.321454] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.321937] ACPI: SSDT 000000009ce70798 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20100121)
[    0.322389] ACPI: Dynamic OEM Table Load:
[    0.322392] ACPI: SSDT           (null) 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20100121)
[    0.322685] ACPI: SSDT 000000009ce71a98 00303 (v01  PmRef    ApIst 00003000 INTL 20100121)
[    0.323165] ACPI: Dynamic OEM Table Load:
[    0.323167] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20100121)
[    0.323302] ACPI: SSDT 000000009ce6fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20100121)
[    0.323745] ACPI: Dynamic OEM Table Load:
[    0.323748] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100121)
[    0.333502] ACPI: Interpreter enabled
[    0.333505] ACPI: (supports S0 S3 S4 S5)
[    0.333526] ACPI: Using IOAPIC for interrupt routing
[    0.341379] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.341741] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.341745] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.342026] \_SB_.PCI0:_OSC invalid UUID
[    0.342027] _OSC request data:1 8 1f
[    0.342032] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.342510] PCI host bridge to bus 0000:00
[    0.342514] pci_bus 0000:00: busn_res: [bus 00-fe] is inserted under domain [bus 00-ff]
[    0.342516] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.342518] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.342520] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.342522] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.342524] pci_bus 0000:00: root bus resource [mem 0x9fa00000-0xfeafffff]
[    0.342532] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.342570] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.342603] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.342624] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
[    0.342635] pci 0000:00:02.0: reg 10: [mem 0xc0000000-0xc03fffff 64bit]
[    0.342642] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.342646] pci 0000:00:02.0: reg 20: [io  0x6000-0x603f]
[    0.342703] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.342728] pci 0000:00:16.0: reg 10: [mem 0xc7504000-0xc750400f 64bit]
[    0.342807] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.342844] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.343221] pci 0000:00:1a.0: reg 10: [mem 0xc750a000-0xc750a3ff]
[    0.345413] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.345442] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.345458] pci 0000:00:1b.0: reg 10: [mem 0xc7500000-0xc7503fff 64bit]
[    0.345532] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.345558] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.345642] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.345669] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.345753] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.345782] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.345864] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.345892] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.345974] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.346013] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.346381] pci 0000:00:1d.0: reg 10: [mem 0xc7509000-0xc75093ff]
[    0.348578] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.348607] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    0.348738] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.348758] pci 0000:00:1f.2: reg 10: [io  0x6098-0x609f]
[    0.348767] pci 0000:00:1f.2: reg 14: [io  0x60bc-0x60bf]
[    0.348775] pci 0000:00:1f.2: reg 18: [io  0x6090-0x6097]
[    0.348784] pci 0000:00:1f.2: reg 1c: [io  0x60b8-0x60bb]
[    0.348793] pci 0000:00:1f.2: reg 20: [io  0x6060-0x607f]
[    0.348802] pci 0000:00:1f.2: reg 24: [mem 0xc7508000-0xc75087ff]
[    0.348850] pci 0000:00:1f.2: PME# supported from D3hot
[    0.348871] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.348887] pci 0000:00:1f.3: reg 10: [mem 0xc7506000-0xc75060ff 64bit]
[    0.348910] pci 0000:00:1f.3: reg 20: [io  0x6040-0x605f]
[    0.348962] pci_bus 0000:01: busn_res: [bus 01-06] is inserted under [bus 00-fe]
[    0.348975] pci 0000:01:00.0: [1002:6760] type 00 class 0x030000
[    0.348992] pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.349005] pci 0000:01:00.0: reg 18: [mem 0xc6500000-0xc651ffff 64bit]
[    0.349014] pci 0000:01:00.0: reg 20: [io  0x5000-0x50ff]
[    0.349031] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.349071] pci 0000:01:00.0: supports D1 D2
[    0.355991] pci 0000:00:01.0: PCI bridge to [bus 01-06]
[    0.355999] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.356006] pci 0000:00:01.0:   bridge window [mem 0xc6500000-0xc74fffff]
[    0.356015] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.356094] pci_bus 0000:07: busn_res: [bus 07-0c] is inserted under [bus 00-fe]
[    0.356121] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.356142] pci 0000:07:00.0: reg 10: [io  0x4000-0x40ff]
[    0.356178] pci 0000:07:00.0: reg 18: [mem 0xc0404000-0xc0404fff 64bit pref]
[    0.356200] pci 0000:07:00.0: reg 20: [mem 0xc0400000-0xc0403fff 64bit pref]
[    0.356295] pci 0000:07:00.0: supports D1 D2
[    0.356297] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.363989] pci 0000:00:1c.0: PCI bridge to [bus 07-0c]
[    0.363998] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.364008] pci 0000:00:1c.0:   bridge window [mem 0xc5500000-0xc64fffff]
[    0.364021] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc13fffff 64bit pref]
[    0.364093] pci_bus 0000:0d: busn_res: [bus 0d-12] is inserted under [bus 00-fe]
[    0.364263] pci 0000:0d:00.0: [8086:0084] type 00 class 0x028000
[    0.364418] pci 0000:0d:00.0: reg 10: [mem 0xc4500000-0xc4501fff 64bit]
[    0.365158] pci 0000:0d:00.0: PME# supported from D0 D3hot D3cold
[    0.372098] pci 0000:00:1c.1: PCI bridge to [bus 0d-12]
[    0.372103] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.372107] pci 0000:00:1c.1:   bridge window [mem 0xc4500000-0xc54fffff]
[    0.372114] pci 0000:00:1c.1:   bridge window [mem 0xc1400000-0xc23fffff 64bit pref]
[    0.372160] pci_bus 0000:13: busn_res: [bus 13-18] is inserted under [bus 00-fe]
[    0.372187] pci 0000:13:00.0: [10ec:5209] type 00 class 0xff0000
[    0.372212] pci 0000:13:00.0: reg 10: [mem 0xc3501000-0xc3501fff]
[    0.372301] pci 0000:13:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.372374] pci 0000:13:00.0: supports D1 D2
[    0.372375] pci 0000:13:00.0: PME# supported from D1 D2 D3hot
[    0.372429] pci 0000:13:00.1: [10ec:5209] type 00 class 0x080500
[    0.372454] pci 0000:13:00.1: reg 10: [mem 0xc3500000-0xc35000ff]
[    0.372610] pci 0000:13:00.1: supports D1 D2
[    0.372612] pci 0000:13:00.1: PME# supported from D1 D2 D3hot
[    0.379979] pci 0000:00:1c.2: PCI bridge to [bus 13-18]
[    0.379989] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.379998] pci 0000:00:1c.2:   bridge window [mem 0xc3500000-0xc44fffff]
[    0.380012] pci 0000:00:1c.2:   bridge window [mem 0xc2400000-0xc33fffff 64bit pref]
[    0.380079] pci_bus 0000:19: busn_res: [bus 19] is inserted under [bus 00-fe]
[    0.380183] pci 0000:19:00.0: [1033:0194] type 00 class 0x0c0330
[    0.380238] pci 0000:19:00.0: reg 10: [mem 0xc3400000-0xc3401fff 64bit]
[    0.380462] pci 0000:19:00.0: PME# supported from D0 D3hot D3cold
[    0.388016] pci 0000:00:1c.3: PCI bridge to [bus 19]
[    0.388037] pci 0000:00:1c.3:   bridge window [mem 0xc3400000-0xc34fffff]
[    0.388067] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.388187] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.388218] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.388246] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.388273] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.388312] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.388382] \_SB_.PCI0:_OSC invalid UUID
[    0.388383] _OSC request data:1 1f 1f
[    0.388386]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.388388]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.391593] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 11 12 14 15) *7
[    0.391638] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 *3 4 5 6 10 11 12 14 15)
[    0.391680] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 *4 5 6 10 11 12 14 15)
[    0.391724] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.391766] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.391810] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 *5 6 10 11 12 14 15)
[    0.391854] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.391896] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.391973] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.391980] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.391982] vgaarb: loaded
[    0.391983] vgaarb: bridge control possible 0000:01:00.0
[    0.391984] vgaarb: no bridge control possible 0000:00:02.0
[    0.392083] SCSI subsystem initialized
[    0.392085] ACPI: bus type scsi registered
[    0.392113] libata version 3.00 loaded.
[    0.392129] ACPI: bus type usb registered
[    0.392145] usbcore: registered new interface driver usbfs
[    0.392152] usbcore: registered new interface driver hub
[    0.392168] usbcore: registered new device driver usb
[    0.392229] PCI: Using ACPI for IRQ routing
[    0.400654] PCI: pci_cache_line_size set to 64 bytes
[    0.400839] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.400841] e820: reserve RAM buffer [mem 0x9ce3f000-0x9fffffff]
[    0.400843] e820: reserve RAM buffer [mem 0x9d000000-0x9fffffff]
[    0.400844] e820: reserve RAM buffer [mem 0x25fe00000-0x25fffffff]
[    0.400918] NetLabel: Initializing
[    0.400919] NetLabel:  domain hash size = 128
[    0.400920] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.400929] NetLabel:  unlabeled traffic allowed by default
[    0.400975] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.400981] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.402992] Switching to clocksource hpet
[    0.408439] AppArmor: AppArmor Filesystem Enabled
[    0.408457] pnp: PnP ACPI init
[    0.408471] ACPI: bus type pnp registered
[    0.408745] pnp 00:00: [bus 00-fe]
[    0.408748] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.408750] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.408752] pnp 00:00: [io  0x0d00-0xffff window]
[    0.408754] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.408756] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.408757] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.408759] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.408761] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.408763] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.408764] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.408766] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.408768] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.408770] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.408771] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.408773] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.408775] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.408777] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.408778] pnp 00:00: [mem 0x9fa00000-0xfeafffff window]
[    0.408832] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.408850] pnp 00:01: [io  0x0000-0x001f]
[    0.408853] pnp 00:01: [io  0x0081-0x0091]
[    0.408855] pnp 00:01: [io  0x0093-0x009f]
[    0.408856] pnp 00:01: [io  0x00c0-0x00df]
[    0.408858] pnp 00:01: [dma 4]
[    0.408877] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.408886] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.408903] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.408974] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.408993] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.409001] pnp 00:04: [io  0x00f0]
[    0.409011] pnp 00:04: [irq 13]
[    0.409027] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.409036] pnp 00:05: [io  0x002e-0x002f]
[    0.409038] pnp 00:05: [io  0x004e-0x004f]
[    0.409039] pnp 00:05: [io  0x0061]
[    0.409041] pnp 00:05: [io  0x0063]
[    0.409043] pnp 00:05: [io  0x0065]
[    0.409044] pnp 00:05: [io  0x0067]
[    0.409046] pnp 00:05: [io  0x0070]
[    0.409047] pnp 00:05: [io  0x0080]
[    0.409049] pnp 00:05: [io  0x0092]
[    0.409050] pnp 00:05: [io  0x00b2-0x00b3]
[    0.409052] pnp 00:05: [io  0x0680-0x069f]
[    0.409053] pnp 00:05: [io  0x1000-0x100f]
[    0.409055] pnp 00:05: [io  0x1010-0x1013]
[    0.409057] pnp 00:05: [io  0xffff]
[    0.409058] pnp 00:05: [io  0x0400-0x0453]
[    0.409060] pnp 00:05: [io  0x0458-0x047f]
[    0.409061] pnp 00:05: [io  0x0500-0x057f]
[    0.409063] pnp 00:05: [io  0x164e-0x164f]
[    0.409104] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.409106] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.409108] system 00:05: [io  0x1010-0x1013] has been reserved
[    0.409110] system 00:05: [io  0xffff] has been reserved
[    0.409112] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.409114] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.409116] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.409118] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.409121] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.409128] pnp 00:06: [io  0x0070-0x0077]
[    0.409133] pnp 00:06: [irq 8]
[    0.409150] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.409167] pnp 00:07: [io  0x0454-0x0457]
[    0.409196] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.409198] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.409225] pnp 00:08: [io  0x0060]
[    0.409227] pnp 00:08: [io  0x0064]
[    0.409232] pnp 00:08: [irq 1]
[    0.409251] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.409279] pnp 00:09: [irq 12]
[    0.409298] pnp 00:09: Plug and Play ACPI device, IDs SYN1e47 SYN1e00 SYN0002 PNP0f13 (active)
[    0.409386] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.409388] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    0.409390] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.409392] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.409393] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.409395] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.409397] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    0.409398] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.409400] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.409402] pnp 00:0a: [mem 0x9fa00000-0x9fa00fff]
[    0.409438] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.409440] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.409442] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.409444] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.409446] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.409448] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.409450] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.409452] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.409454] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.409456] system 00:0a: [mem 0x9fa00000-0x9fa00fff] has been reserved
[    0.409459] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.410493] pnp 00:0b: [irq 23]
[    0.410530] pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.410549] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.410551] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    0.410598] system 00:0c: [mem 0x20000000-0x201fffff] could not be reserved
[    0.410600] system 00:0c: [mem 0x40000000-0x401fffff] could not be reserved
[    0.410603] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.410619] pnp: PnP ACPI: found 13 devices
[    0.410620] ACPI: ACPI bus type pnp unregistered
[    0.416844] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.416848] pci 0000:13:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.416890] pci 0000:01:00.0: BAR 6: assigned [mem 0xc6520000-0xc653ffff pref]
[    0.416892] pci 0000:00:01.0: PCI bridge to [bus 01-06]
[    0.416895] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.416898] pci 0000:00:01.0:   bridge window [mem 0xc6500000-0xc74fffff]
[    0.416901] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.416904] pci 0000:00:1c.0: PCI bridge to [bus 07-0c]
[    0.416908] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.416913] pci 0000:00:1c.0:   bridge window [mem 0xc5500000-0xc64fffff]
[    0.416918] pci 0000:00:1c.0:   bridge window [mem 0xc0400000-0xc13fffff 64bit pref]
[    0.416925] pci 0000:00:1c.1: PCI bridge to [bus 0d-12]
[    0.416928] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.416933] pci 0000:00:1c.1:   bridge window [mem 0xc4500000-0xc54fffff]
[    0.416938] pci 0000:00:1c.1:   bridge window [mem 0xc1400000-0xc23fffff 64bit pref]
[    0.416945] pci 0000:13:00.0: BAR 6: assigned [mem 0xc2400000-0xc240ffff pref]
[    0.416947] pci 0000:00:1c.2: PCI bridge to [bus 13-18]
[    0.416950] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.416956] pci 0000:00:1c.2:   bridge window [mem 0xc3500000-0xc44fffff]
[    0.416960] pci 0000:00:1c.2:   bridge window [mem 0xc2400000-0xc33fffff 64bit pref]
[    0.416967] pci 0000:00:1c.3: PCI bridge to [bus 19]
[    0.416973] pci 0000:00:1c.3:   bridge window [mem 0xc3400000-0xc34fffff]
[    0.417016] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.417018] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.417020] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.417022] pci_bus 0000:00: resource 7 [mem 0x9fa00000-0xfeafffff]
[    0.417024] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    0.417026] pci_bus 0000:01: resource 1 [mem 0xc6500000-0xc74fffff]
[    0.417028] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff 64bit pref]
[    0.417030] pci_bus 0000:07: resource 0 [io  0x4000-0x4fff]
[    0.417031] pci_bus 0000:07: resource 1 [mem 0xc5500000-0xc64fffff]
[    0.417033] pci_bus 0000:07: resource 2 [mem 0xc0400000-0xc13fffff 64bit pref]
[    0.417035] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.417037] pci_bus 0000:0d: resource 1 [mem 0xc4500000-0xc54fffff]
[    0.417038] pci_bus 0000:0d: resource 2 [mem 0xc1400000-0xc23fffff 64bit pref]
[    0.417040] pci_bus 0000:13: resource 0 [io  0x2000-0x2fff]
[    0.417042] pci_bus 0000:13: resource 1 [mem 0xc3500000-0xc44fffff]
[    0.417044] pci_bus 0000:13: resource 2 [mem 0xc2400000-0xc33fffff 64bit pref]
[    0.417046] pci_bus 0000:19: resource 1 [mem 0xc3400000-0xc34fffff]
[    0.417072] NET: Registered protocol family 2
[    0.417652] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.418889] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.419037] TCP: Hash tables configured (established 524288 bind 65536)
[    0.419052] TCP: reno registered
[    0.419065] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.419097] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.419179] NET: Registered protocol family 1
[    0.419193] pci 0000:00:02.0: Boot video device
[    0.462894] PCI: CLS 64 bytes, default 64
[    0.462945] Trying to unpack rootfs image as initramfs...
[    0.510156] Freeing initrd memory: 2576k freed
[    0.510423] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.510426] software IO TLB [mem 0x98e34000-0x9ce33fff] (64MB) mapped at [ffff880098e34000-ffff88009ce33fff]
[    0.510460] Simple Boot Flag at 0x44 set to 0x1
[    0.510915] audit: initializing netlink socket (disabled)
[    0.510930] type=2000 audit(1349002450.384:1): initialized
[    0.531716] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.533314] VFS: Disk quotas dquot_6.5.2
[    0.533351] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.533709] fuse init (API version 7.20)
[    0.533775] msgmni has been set to 15861
[    0.534059] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.534084] io scheduler noop registered
[    0.534086] io scheduler deadline registered
[    0.534112] io scheduler cfq registered (default)
[    0.534201] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.534423] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.534441] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.534476] intel_idle: MWAIT substates: 0x21120
[    0.534478] intel_idle: v0.4 model 0x2A
[    0.534479] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.536573] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.537387] ACPI: AC Adapter [AC] (on-line)
[    0.537457] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/PNP0C0D:00/input/input0
[    0.543610] ACPI: Lid Switch [LID]
[    0.543651] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.543655] ACPI: Power Button [PWRB]
[    0.543684] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.543686] ACPI: Power Button [PWRF]
[    0.543746] ACPI: Requesting acpi_cpufreq
[    0.561004] thermal LNXTHERM:00: registered as thermal_zone0
[    0.561010] ACPI: Thermal Zone [THRM] (56 C)
[    0.561041] GHES: HEST is not enabled!
[    0.561097] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.567238] Linux agpgart interface v0.103
[    0.568356] brd: module loaded
[    0.568908] loop: module loaded
[    0.568992] ahci 0000:00:1f.2: version 3.0
[    0.569050] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.582847] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x21 impl SATA mode
[    0.582856] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst
[    0.582875] ahci 0000:00:1f.2: setting latency timer to 64
[    0.591201] scsi0 : ahci
[    0.591264] scsi1 : ahci
[    0.591322] scsi2 : ahci
[    0.591380] scsi3 : ahci
[    0.591433] scsi4 : ahci
[    0.591486] scsi5 : ahci
[    0.591517] ata1: SATA max UDMA/133 abar m2048@0xc7508000 port 0xc7508100 irq 41
[    0.591519] ata2: DUMMY
[    0.591520] ata3: DUMMY
[    0.591521] ata4: DUMMY
[    0.591522] ata5: DUMMY
[    0.591524] ata6: SATA max UDMA/133 abar m2048@0xc7508000 port 0xc7508380 irq 41
[    0.591791] libphy: Fixed MDIO Bus: probed
[    0.591803] tun: Universal TUN/TAP device driver, 1.6
[    0.591804] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.591840] PPP generic driver version 2.4.2
[    0.591907] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.591932] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.591935] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.591970] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.592546] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.592550] ACPI: Battery Slot [BAT0] (battery present)
[    0.595879] ehci_hcd 0000:00:1a.0: debug port 2
[    0.595888] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.595902] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xc750a000
[    0.606788] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.606947] hub 1-0:1.0: USB hub found
[    0.606950] hub 1-0:1.0: 2 ports detected
[    0.607012] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.607015] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.607054] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.610940] ehci_hcd 0000:00:1d.0: debug port 2
[    0.610947] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.610961] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xc7509000
[    0.622770] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.622910] hub 2-0:1.0: USB hub found
[    0.622913] hub 2-0:1.0: 2 ports detected
[    0.622958] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.622966] uhci_hcd: USB Universal Host Controller Interface driver
[    0.623006] xhci_hcd 0000:19:00.0: xHCI Host Controller
[    0.623039] xhci_hcd 0000:19:00.0: new USB bus registered, assigned bus number 3
[    0.623239] xhci_hcd 0000:19:00.0: irq 19, io mem 0xc3400000
[    0.623330] xhci_hcd 0000:19:00.0: irq 42 for MSI/MSI-X
[    0.623336] xhci_hcd 0000:19:00.0: irq 43 for MSI/MSI-X
[    0.623341] xhci_hcd 0000:19:00.0: irq 44 for MSI/MSI-X
[    0.623347] xhci_hcd 0000:19:00.0: irq 45 for MSI/MSI-X
[    0.623352] xhci_hcd 0000:19:00.0: irq 46 for MSI/MSI-X
[    0.623357] xhci_hcd 0000:19:00.0: irq 47 for MSI/MSI-X
[    0.623362] xhci_hcd 0000:19:00.0: irq 48 for MSI/MSI-X
[    0.623367] xhci_hcd 0000:19:00.0: irq 49 for MSI/MSI-X
[    0.623568] xHCI xhci_add_endpoint called for root hub
[    0.623569] xHCI xhci_check_bandwidth called for root hub
[    0.623586] hub 3-0:1.0: USB hub found
[    0.623594] hub 3-0:1.0: 2 ports detected
[    0.623644] xhci_hcd 0000:19:00.0: xHCI Host Controller
[    0.623671] xhci_hcd 0000:19:00.0: new USB bus registered, assigned bus number 4
[    0.626686] xHCI xhci_add_endpoint called for root hub
[    0.626687] xHCI xhci_check_bandwidth called for root hub
[    0.626703] hub 4-0:1.0: USB hub found
[    0.626716] hub 4-0:1.0: 2 ports detected
[    0.626836] usbcore: registered new interface driver libusual
[    0.626863] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.637542] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.637547] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.637645] mousedev: PS/2 mouse device common for all mice
[    0.637817] rtc_cmos 00:06: RTC can wake from S4
[    0.637929] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.637956] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.638012] device-mapper: uevent: version 1.0.3
[    0.638059] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    0.638198] cpuidle: using governor ladder
[    0.638373] cpuidle: using governor menu
[    0.638374] EFI Variables Facility v0.08 2004-May-17
[    0.638429] TCP: cubic registered
[    0.638506] NET: Registered protocol family 10
[    0.638644] NET: Registered protocol family 17
[    0.638652] Key type dns_resolver registered
[    0.638943] PM: Hibernation image not present or could not be loaded.
[    0.638953] registered taskstats version 1
[    0.640755] Key type trusted registered
[    0.642409] Key type encrypted registered
[    0.644556]   Magic number: 12:224:933
[    0.644662] rtc_cmos 00:06: setting system clock to 2012-09-30 10:54:11 UTC (1349002451)
[    0.646002] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.646003] EDD information not available.
[    0.646804] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.910539] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.913034] ata6.00: ATAPI: hp      BD E  DS6E2LH, FH62, max UDMA/100
[    0.914627] ata6.00: configured for UDMA/100
[    0.918528] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.918535] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    0.920148] ata1.00: ATA-8: Hitachi HTS547575A9E384, JE4OA50A, max UDMA/100
[    0.920158] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.921912] ata1.00: configured for UDMA/100
[    0.922155] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54757 JE4O PQ: 0 ANSI: 5
[    0.922324] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    0.922325] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.922328] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.922540] sd 0:0:0:0: [sda] Write Protect is off
[    0.922544] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.922657] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.926530] scsi 5:0:0:0: CD-ROM            hp       BD E  DS6E2LH    FH62 PQ: 0 ANSI: 5
[    0.930475] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.930483] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.930679] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    0.930836] sr 5:0:0:0: Attached scsi generic sg1 type 5
[    1.011958]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.013243] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.014402] Freeing unused kernel memory: 920k freed
[    1.014489] Write protecting the kernel read-only data: 12288k
[    1.018529] Freeing unused kernel memory: 1688k freed
[    1.021760] Freeing unused kernel memory: 1320k freed
[    1.034486] udevd[138]: starting version 175
[    1.050866] hub 1-1:1.0: USB hub found
[    1.050938] hub 1-1:1.0: 6 ports detected
[    1.058140] sdhci: Secure Digital Host Controller Interface driver
[    1.058143] sdhci: Copyright(c) Pierre Ossman
[    1.058848] sdhci-pci 0000:13:00.1: SDHCI controller found [10ec:5209] (rev 1)
[    1.058891] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.058897] mmc0: no vmmc regulator found
[    1.058915] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.058947] Registered led device: mmc0::
[    1.062500] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.062755] r8169 0000:07:00.0: irq 50 for MSI/MSI-X
[    1.062969] r8169 0000:07:00.0: eth0: RTL8168evl/8111evl at 0xffffc90000c7a000, 08:2e:5f:82:40:38, XID 0c900800 IRQ 50
[    1.062973] r8169 0000:07:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.090339] mmc0: SDHCI controller on PCI [0000:13:00.1] using DMA
[    1.093880] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.129843] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.162254] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.165862] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.201336] sdhci-pci 0000:13:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.294989] hub 2-1:1.0: USB hub found
[    1.295050] hub 2-1:1.0: 6 ports detected
[    1.366114] usb 1-1.1: new full-speed USB device number 3 using ehci_hcd
[    1.505874] tsc: Refined TSC clocksource calibration: 2195.015 MHz
[    1.505888] Switching to clocksource tsc
[    1.529982] usb 1-1.2: new high-speed USB device number 4 using ehci_hcd
[    1.750298] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    9.320288] udevd[448]: starting version 175
[    9.320895] Adding 12582908k swap on /dev/sda6.  Priority:-1 extents:1 across:12582908k
[    9.415485] type=1400 audit(1349016860.275:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=546 comm="apparmor_parser"
[    9.415494] type=1400 audit(1349016860.275:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=606 comm="apparmor_parser"
[    9.415761] type=1400 audit(1349016860.275:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=546 comm="apparmor_parser"
[    9.415770] type=1400 audit(1349016860.275:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=606 comm="apparmor_parser"
[    9.415918] type=1400 audit(1349016860.275:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=546 comm="apparmor_parser"
[    9.415929] type=1400 audit(1349016860.275:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=606 comm="apparmor_parser"
[    9.556661] wmi: Mapper loaded
[    9.849239] mei 0000:00:16.0: setting latency timer to 64
[    9.849294] mei 0000:00:16.0: irq 51 for MSI/MSI-X
[    9.860890] lp: driver loaded but no devices found
[    9.861904] mei 0000:00:16.0: wd: failed to find the client
[    9.983470] input: HP WMI hotkeys as /devices/virtual/input/input4
[   10.153427] rts_pstor: module is from the staging directory, the quality is unknown, you have been warned.
[   10.154072] Initializing Realtek PCIE storage driver...
[   10.154160] Resource length: 0x1000
[   10.154173] Original address: 0xc3501000, remapped address: 0xffffc90000c6c000
[   10.154176] pci->irq = 18
[   10.154177] rtsx_acquire_irq: chip->msi_en = 0, pci->irq = 18
[   10.356372] scsi6 : SCSI emulation for PCI-Express Mass Storage devices
[   10.356530] rts_pstor: waiting for device to settle before scanning
[   10.373036] cfg80211: Calling CRDA to update world regulatory domain
[   10.376044] cfg80211: World regulatory domain updated:
[   10.376047] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   10.376049] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.376050] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.376051] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   10.376052] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.376054] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   10.541266] hp_accel: laptop model unknown, using default axes configuration
[   10.624300] [drm] Initialized drm 1.1.0 20060810
[   10.669214] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.5, id: 0x1e0b1, caps: 0xd00073/0x240000/0xa0400, board id: 1680, fw id: 726294
[   10.713183] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[   11.056401] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   11.056403] Copyright(c) 2003-2012 Intel Corporation
[   11.056526] iwlwifi 0000:0d:00.0: pci_resource_len = 0x00002000
[   11.056528] iwlwifi 0000:0d:00.0: pci_resource_base = ffffc900118ac000
[   11.056529] iwlwifi 0000:0d:00.0: HW Revision ID = 0x0
[   11.056864] iwlwifi 0000:0d:00.0: irq 52 for MSI/MSI-X
[   11.108910] iwlwifi 0000:0d:00.0: loaded firmware version 39.31.5.1 build 35138
[   11.159845] lis3lv02d: 8 bits 3DC sensor found
[   11.355016] rts_pstor: device scan complete
[   11.355232] scsi 6:0:0:0: Direct-Access     Generic- xD/SD/M.S.       1.00 PQ: 0 ANSI: 0 CCS
[   11.355430] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    0.930948] ACPI: Invalid Power Resource to register!
[   11.355481] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   11.606830] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
[   11.607077] Registered led device: hp::hddprotect
[   11.607090] hp_accel: driver loaded
[   12.360896] pci 0000:00:00.0: Intel Sandybridge Chipset
[   12.360959] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   12.361920] pci 0000:00:00.0: detected 32768K stolen memory
[   12.362003] i915 0000:00:02.0: setting latency timer to 64
[   12.382707] i915 0000:00:02.0: irq 53 for MSI/MSI-X
[   12.382713] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   12.382714] [drm] Driver supports precise vblank timestamp query.
[   12.383447] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   12.383449] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[   12.439228] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   12.439231] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[   12.439244] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   12.439246] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[   12.439247] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   12.439248] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[   12.439249] iwlwifi 0000:0d:00.0: CONFIG_IWLWIFI_P2P enabled
[   12.439251] iwlwifi 0000:0d:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   12.439397] iwlwifi 0000:0d:00.0: L1 Enabled; Disabling L0S
[   12.446731] iwlwifi 0000:0d:00.0: RF_KILL bit toggled to enable radio.
[   12.460652] iwlwifi 0000:0d:00.0: device EEPROM VER=0x15d, CALIB=0x6
[   12.460654] iwlwifi 0000:0d:00.0: Device SKU: 0x50
[   12.460656] iwlwifi 0000:0d:00.0: Valid Tx ant: 0x1, Valid Rx ant: 0x3
[   12.460779] Registered led device: phy0-led
[   12.460797] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   12.488719] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.787134] [drm] radeon defaulting to kernel modesetting.
[   12.787137] [drm] radeon kernel modesetting enabled.
[   12.787148] VGA switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
[   12.787187] radeon 0000:01:00.0: enabling device (0000 -> 0003)
[   12.870146] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   13.008928] fbcon: inteldrmfb (fb0) is primary device
[   13.047695] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
[   13.209024] Console: switching to colour frame buffer device 170x48
[   13.210832] fb0: inteldrmfb frame buffer device
[   13.210833] drm: registered panic notifier
[   13.210960] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[   13.220013] acpi device:2f: registered as cooling_device8
[   13.220122] ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
[   13.220153] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2d/LNXVIDEO:00/input/input7
[   13.231301] acpi device:3c: registered as cooling_device9
[   13.231437] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   13.231475] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input8
[   13.231532] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   13.231671] snd_hda_intel 0000:00:1b.0: irq 54 for MSI/MSI-X
[   13.231842] [drm] initializing kernel modesetting (CAICOS 0x1002:0x6760 0x103C:0x1656).
[   13.231864] [drm] register mmio base: 0xC6500000
[   13.231865] [drm] register mmio size: 131072
[   13.231867] vga_switcheroo: enabled
[   13.231947] radeon atpx: version is 1
[   13.308468] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[   13.331906] ATOM BIOS: HP/Flex
[   13.332269] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[   13.332271] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[   13.332276] mtrr: no more MTRRs available
[   13.332278] [drm] Detected VRAM RAM=1024M, BAR=256M
[   13.332279] [drm] RAM width 64bits DDR
[   13.332316] [TTM] Zone  kernel: Available graphics memory: 4062616 kiB
[   13.332318] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   13.332319] [TTM] Initializing pool allocator
[   13.332321] [TTM] Initializing DMA pool allocator
[   13.332336] [drm] radeon: 1024M of VRAM memory ready
[   13.332338] [drm] radeon: 512M of GTT memory ready.
[   13.332351] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   13.332352] [drm] Driver supports precise vblank timestamp query.
[   13.332393] radeon 0000:01:00.0: irq 55 for MSI/MSI-X
[   13.332402] radeon 0000:01:00.0: radeon: using MSI.
[   13.332438] [drm] radeon: irq initialized.
[   13.332441] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   13.332719] [drm] probing gen 2 caps for device 8086:101 = 2/0
[   13.332721] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[   13.332780] [drm] Loading CAICOS Microcode
[   13.338674] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   13.338790] radeon 0000:01:00.0: WB enabled
[   13.338792] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff880251da5c00
[   13.355158] [drm] ring test on 0 succeeded in 3 usecs
[   13.355371] [drm] ib test on ring 0 succeeded in 0 usecs
[   13.355530] [drm] Radeon Display Connectors
[   13.360994] [drm] Internal thermal controller with fan control
[   13.361983] [drm] radeon: power management initialized
[   13.362053] No connectors reported connected with modes
[   13.362055] [drm] Cannot find any crtc or sizes - going 1024x768
[   13.363413] [drm] fb mappable at 0xA0142000
[   13.363414] [drm] vram apper at 0xA0000000
[   13.363415] [drm] size 3145728
[   13.363415] [drm] fb depth is 24
[   13.363416] [drm]    pitch is 4096
[   13.363512] fb1: radeondrmfb frame buffer device
[   13.363516] [drm] Initialized radeon 2.22.0 20080528 for 0000:01:00.0 on minor 1
[   13.565858] init: failsafe main process (869) killed by TERM signal
[   13.685961] ppdev: user-space parallel port driver
[   13.709743] type=1400 audit(1349016864.575:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=950 comm="apparmor_parser"
[   13.709753] type=1400 audit(1349016864.575:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=949 comm="apparmor_parser"
[   13.710027] type=1400 audit(1349016864.575:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=950 comm="apparmor_parser"
[   13.710189] type=1400 audit(1349016864.575:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=950 comm="apparmor_parser"
[   13.850352] r8169 0000:07:00.0: eth0: link down
[   13.850387] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.851907] iwlwifi 0000:0d:00.0: L1 Enabled; Disabling L0S
[   13.859309] iwlwifi 0000:0d:00.0: Radio type=0x0-0x0-0x3
[   13.891741] init: alsa-restore main process (1015) terminated with status 19
[   13.914638] iwlwifi 0000:0d:00.0: L1 Enabled; Disabling L0S
[   13.922059] iwlwifi 0000:0d:00.0: Radio type=0x0-0x0-0x3
[   13.977202] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.199758] Bluetooth: Core ver 2.16
[   14.199774] NET: Registered protocol family 31
[   14.199775] Bluetooth: HCI device and connection manager initialized
[   14.199776] Bluetooth: HCI socket layer initialized
[   14.199777] Bluetooth: L2CAP socket layer initialized
[   14.199780] Bluetooth: SCO socket layer initialized
[   14.200602] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   14.200680] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   14.200747] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   14.275702] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.275704] Bluetooth: BNEP filters: protocol multicast
[   14.317095] Bluetooth: RFCOMM TTY layer initialized
[   14.317100] Bluetooth: RFCOMM socket layer initialized
[   14.317101] Bluetooth: RFCOMM ver 1.11
[   14.580144] init: plymouth-stop pre-start process (1268) terminated with status 1
[   16.089581] wlan0: authenticate with 30:46:9a:68:a9:52
[   16.109633] wlan0: send auth to 30:46:9a:68:a9:52 (try 1/3)
[   16.111490] wlan0: authenticated
[   16.113740] wlan0: associate with 30:46:9a:68:a9:52 (try 1/3)
[   16.117539] wlan0: RX AssocResp from 30:46:9a:68:a9:52 (capab=0x411 status=0 aid=1)
[   16.120671] wlan0: associated
[   16.120693] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   21.358865] hp_wmi: Unknown event_id - 10 - 0x1
[  317.847375] audit_printk_skb: 45 callbacks suppressed
[  317.847378] type=1400 audit(1349017169.135:27): apparmor="DENIED" operation="capable" parent=1 profile="/usr/sbin/cupsd" pid=985 comm="cupsd" pid=985 comm="cupsd" capability=36  capname="block_suspend"
