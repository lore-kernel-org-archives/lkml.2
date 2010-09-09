Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0IIMQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:16:45 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:35399 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab0IIMQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:16:39 -0400
Message-ID: <de55082de958760245f23930b79ab42b7c54c838@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Date: Thu, 9 Sep 2010 13:16:33 +0100
Subject: GA-MA69VM-S2 requires pci=nocrs with 2.6.35.4
From: "Simon Arlott" <simon@fire.lp0.eu>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100909131633_40936"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20100909131633_40936
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

With a Gigabyte GA-MA69VM-S2 690V motherboard, it stalls in
qurk_usb_early_handoff unless pci=nocrs is used:

[  299.177004] calling  pci_apply_final_quirks+0x0/0x11e @ 1
[  299.177004] pci 0000:00:00.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x5dd
[  299.177004] pci 0000:00:00.0: calling pci_fixup_video+0x0/0x9c
[  299.177004] pci 0000:00:01.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x5dd
[  299.177004] pci 0000:00:01.0: calling pci_fixup_video+0x0/0x9c
[  299.177004] pci 0000:00:12.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x5dd
[  299.177004] pci 0000:00:12.0: calling pci_fixup_video+0x0/0x9c
[  299.177004] pci 0000:00:13.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x5dd

Full dmesg with/without pci=nocrs attached.

-- 
Simon Arlott
------=_20100909131633_40936
Content-Type: text/plain; name="stalled.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="stalled.txt"

[    0.000000] Linux version 2.6.35.4-git+ (byte@proxima) (gcc version 4.3.1 (Gentoo 4.3.1 p1.0) ) #git+ SMP PREEMPT 2010-08-25T23:29:08+0100
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007dee0000 (usable)
[    0.000000]  BIOS-e820: 000000007dee0000 - 000000007dee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007dee3000 - 000000007def0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007def0000 - 000000007df00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7dee0 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [c00f5140] f5140
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000] ACPI: RSDP 000f6b00 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 7dee3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 7dee3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 7dee30c0 049B3 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 7dee0000 00040
[    0.000000] ACPI: SSDT 7dee7b40 00248 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 7dee7dc0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 7dee7e00 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 7dee7a80 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] 1122MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0007dee0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007dee0
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at 7df00000 (gap: 7df00000:62100000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @c2000000 s30400 r0 d22848 u1048576
[    0.000000] pcpu-alloc: s30400 r0 d22848 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 511680
[    0.000000] Kernel command line: root=/dev/sda1 ro panic=10 init=/startup sysrq_always_enabled console=ttyS0,115200 vga=0xf07 initcall_debug=1 tsc=reliable
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Subtract (44 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0000c781e4]   TEXT DATA BSS
[    0.000000]   #3 [0000c79000 - 0000c810fe]             BRK
[    0.000000]   #4 [00000f5150 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f5140 - 00000f5150]    MP-table mpf
[    0.000000]   #6 [000009f800 - 00000f0f00]   BIOS reserved
[    0.000000]   #7 [00000f1054 - 00000f5140]   BIOS reserved
[    0.000000]   #8 [00000f0f00 - 00000f1054]    MP-table mpc
[    0.000000]   #9 [0000002000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #11 [0001000000 - 0001001000]         BOOTMEM
[    0.000000]   #12 [0001001000 - 0001fc1000]         BOOTMEM
[    0.000000]   #13 [0001fc1000 - 0001fc1004]         BOOTMEM
[    0.000000]   #14 [0001fc1040 - 0001fc1280]         BOOTMEM
[    0.000000]   #15 [0001fc1280 - 0001fc1328]         BOOTMEM
[    0.000000]   #16 [0001fc1340 - 0001fca340]         BOOTMEM
[    0.000000]   #17 [0001fca340 - 0001fca414]         BOOTMEM
[    0.000000]   #18 [0001fca440 - 0001fdc440]         BOOTMEM
[    0.000000]   #19 [0001fdc440 - 0001fdc46d]         BOOTMEM
[    0.000000]   #20 [0001fdc480 - 0001fdc4af]         BOOTMEM
[    0.000000]   #21 [0001fdc4c0 - 0001fdc628]         BOOTMEM
[    0.000000]   #22 [0001fdc640 - 0001fdc680]         BOOTMEM
[    0.000000]   #23 [0001fdc680 - 0001fdc6c0]         BOOTMEM
[    0.000000]   #24 [0001fdc6c0 - 0001fdc700]         BOOTMEM
[    0.000000]   #25 [0001fdc700 - 0001fdc740]         BOOTMEM
[    0.000000]   #26 [0001fdc740 - 0001fdc780]         BOOTMEM
[    0.000000]   #27 [0001fdc780 - 0001fdc7c0]         BOOTMEM
[    0.000000]   #28 [0001fdc7c0 - 0001fdc800]         BOOTMEM
[    0.000000]   #29 [0001fdc800 - 0001fdc840]         BOOTMEM
[    0.000000]   #30 [0001fdc840 - 0001fdc880]         BOOTMEM
[    0.000000]   #31 [0001fdc880 - 0001fdc8fb]         BOOTMEM
[    0.000000]   #32 [0001fdc900 - 0001fdc97b]         BOOTMEM
[    0.000000]   #33 [0002000000 - 000200d000]         BOOTMEM
[    0.000000]   #34 [0002100000 - 000210d000]         BOOTMEM
[    0.000000]   #35 [0001fde980 - 0001fde984]         BOOTMEM
[    0.000000]   #36 [0001fde9c0 - 0001fde9c4]         BOOTMEM
[    0.000000]   #37 [0001fdea00 - 0001fdea08]         BOOTMEM
[    0.000000]   #38 [0001fdea40 - 0001fdea48]         BOOTMEM
[    0.000000]   #39 [0001fdea80 - 0001fdeb20]         BOOTMEM
[    0.000000]   #40 [0001fdeb40 - 0001fdeb88]         BOOTMEM
[    0.000000]   #41 [0001fdebc0 - 0001fe2bc0]         BOOTMEM
[    0.000000]   #42 [000200d000 - 000208d000]         BOOTMEM
[    0.000000]   #43 [000208d000 - 00020cd000]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (00037bfe:0007dee0)
[    0.000000] Memory: 2034932k/2063232k available (3157k kernel code, 27908k reserved, 1766k data, 376k init, 1149832k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc06cf000 - 0xc072d000   ( 376 kB)
[    0.000000]       .data : 0xc0515612 - 0xc06ceff4   (1766 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0515612   (3157 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2305.362 MHz processor.
[    0.003003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4610.72 BogoMIPS (lpj=2305362)
[    0.005004] pid_max: default: 32768 minimum: 301
[    0.006071] Security Framework initialized
[    0.007065] TCP/UDP port access control v1.1 LSM initialised
[    0.008045] Mount-cache hash table entries: 512
[    0.010056] CPU: Physical Processor ID: 0
[    0.011003] CPU: Processor Core ID: 0
[    0.012004] mce: CPU supports 5 MCE banks
[    0.013011] using C1E aware idle routine
[    0.014009] Performance Events: AMD PMU driver.
[    0.016010] ... version:                0
[    0.017003] ... bit width:              48
[    0.018003] ... generic registers:      4
[    0.019003] ... value mask:             0000ffffffffffff
[    0.020003] ... max period:             00007fffffffffff
[    0.021003] ... fixed-purpose events:   0
[    0.022003] ... event mask:             000000000000000f
[    0.024284] Freeing SMP alternatives: 16k freed
[    0.025017] ACPI: Core revision 20100428
[    0.037039] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.038565] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.049049] CPU0: AMD Athlon(tm) Dual Core Processor 4450e stepping 02
[    0.052999] calling  migration_init+0x0/0x47 @ 1
[    0.053007] initcall migration_init+0x0/0x47 returned 0 after 0 usecs
[    0.054003] calling  spawn_ksoftirqd+0x0/0x43 @ 1
[    0.056043] initcall spawn_ksoftirqd+0x0/0x43 returned 0 after 976 usecs
[    0.057004] calling  init_call_single_data+0x0/0x80 @ 1
[    0.058004] initcall init_call_single_data+0x0/0x80 returned 0 after 0 usecs
[    0.059004] calling  cpu_stop_init+0x0/0x9b @ 1
[    0.061016] initcall cpu_stop_init+0x0/0x9b returned 0 after 976 usecs
[    0.062003] calling  spawn_softlockup_task+0x0/0x5f @ 1
[    0.064016] initcall spawn_softlockup_task+0x0/0x5f returned 0 after 976 usecs
[    0.067009] lockdep: fixing up alternatives.
[    0.068103] Booting Node   0, Processors  #1 Ok.
[    0.003999] Initializing CPU#1
[    0.141083] Brought up 2 CPUs
[    0.142003] Total of 2 processors activated (9221.11 BogoMIPS).
[    0.144267] calling  init_mmap_min_addr+0x0/0x11 @ 1
[    0.149007] initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
[    0.156005] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.162007] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.171004] calling  net_ns_init+0x0/0x162 @ 1
[    0.175032] initcall net_ns_init+0x0/0x162 returned 0 after 0 usecs
[    0.182004] calling  cpufreq_tsc+0x0/0x25 @ 1
[    0.186004] initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
[    0.192004] calling  pci_reboot_init+0x0/0x11 @ 1
[    0.197006] initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.203004] calling  reboot_init+0x0/0x11 @ 1
[    0.208011] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.214003] calling  init_lapic_sysfs+0x0/0x28 @ 1
[    0.219064] initcall init_lapic_sysfs+0x0/0x28 returned 0 after 0 usecs
[    0.226007] calling  init_smp_flush+0x0/0x2a @ 1
[    0.230004] initcall init_smp_flush+0x0/0x2a returned 0 after 0 usecs
[    0.237004] calling  sysctl_init+0x0/0x2d @ 1
[    0.241006] initcall sysctl_init+0x0/0x2d returned 0 after 0 usecs
[    0.247004] calling  ksysfs_init+0x0/0x74 @ 1
[    0.251012] initcall ksysfs_init+0x0/0x74 returned 0 after 976 usecs
[    0.258003] calling  async_init+0x0/0x50 @ 1
[    0.262017] initcall async_init+0x0/0x50 returned 0 after 0 usecs
[    0.263004] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.264005] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.265003] calling  pm_init+0x0/0x2d @ 1
[    0.266010] initcall pm_init+0x0/0x2d returned 0 after 0 usecs
[    0.267003] calling  init_hw_breakpoint+0x0/0xaf @ 1
[    0.268005] initcall init_hw_breakpoint+0x0/0xaf returned 0 after 0 usecs
[    0.270004] calling  init_zero_pfn+0x0/0x14 @ 1
[    0.271003] initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
[    0.272003] calling  filelock_init+0x0/0x27 @ 1
[    0.273013] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.274004] calling  init_script_binfmt+0x0/0x11 @ 1
[    0.275021] initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.276003] calling  init_elf_binfmt+0x0/0x11 @ 1
[    0.277003] initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.278004] calling  random32_init+0x0/0xa8 @ 1
[    0.279004] initcall random32_init+0x0/0xa8 returned 0 after 0 usecs
[    0.280004] calling  cpufreq_core_init+0x0/0x7b @ 1
[    0.281007] initcall cpufreq_core_init+0x0/0x7b returned 0 after 0 usecs
[    0.282004] calling  cpuidle_init+0x0/0x32 @ 1
[    0.283011] initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
[    0.284004] calling  sock_init+0x0/0x51 @ 1
[    0.285123] initcall sock_init+0x0/0x51 returned 0 after 0 usecs
[    0.286004] calling  netlink_proto_init+0x0/0x108 @ 1
[    0.287040] NET: Registered protocol family 16
[    0.288055] initcall netlink_proto_init+0x0/0x108 returned 0 after 976 usecs
[    0.289003] calling  bdi_class_init+0x0/0x2f @ 1
[    0.290031] initcall bdi_class_init+0x0/0x2f returned 0 after 0 usecs
[    0.291005] calling  kobject_uevent_init+0x0/0x1e @ 1
[    0.292017] initcall kobject_uevent_init+0x0/0x1e returned 0 after 0 usecs
[    0.293003] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.295030] initcall pcibus_class_init+0x0/0x14 returned 0 after 976 usecs
[    0.296004] calling  pci_driver_init+0x0/0xf @ 1
[    0.297039] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    0.298005] calling  tty_class_init+0x0/0x2f @ 1
[    0.299029] initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs
[    0.300005] calling  vtconsole_class_init+0x0/0xa1 @ 1
[    0.301075] initcall vtconsole_class_init+0x0/0xa1 returned 0 after 0 usecs
[    0.302005] calling  i2c_init+0x0/0x57 @ 1
[    0.303061] initcall i2c_init+0x0/0x57 returned 0 after 0 usecs
[    0.304008] calling  amd_postcore_init+0x0/0xa72 @ 1
[    0.305010] TOM: 0000000080000000 aka 2048M
[    0.306038] initcall amd_postcore_init+0x0/0xa72 returned 0 after 976 usecs
[    0.307004] calling  arch_kdebugfs_init+0x0/0x11 @ 1
[    0.308004] initcall arch_kdebugfs_init+0x0/0x11 returned 0 after 0 usecs
[    0.309003] calling  init_pit_clocksource+0x0/0x98 @ 1
[    0.310003] initcall init_pit_clocksource+0x0/0x98 returned 0 after 0 usecs
[    0.311003] calling  mtrr_if_init+0x0/0x44 @ 1
[    0.312008] initcall mtrr_if_init+0x0/0x44 returned 0 after 0 usecs
[    0.313003] calling  ffh_cstate_init+0x0/0x27 @ 1
[    0.314003] initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usecs
[    0.315004] initcall ffh_cstate_init+0x0/0x27 returned with error code -1 
[    0.316004] calling  acpi_pci_init+0x0/0x51 @ 1
[    0.317019] ACPI: bus type pci registered
[    0.318003] initcall acpi_pci_init+0x0/0x51 returned 0 after 976 usecs
[    0.319003] calling  dmi_id_init+0x0/0x26e @ 1
[    0.320081] initcall dmi_id_init+0x0/0x26e returned 0 after 0 usecs
[    0.321008] calling  pci_arch_init+0x0/0x62 @ 1
[    0.322035] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.323004] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.324002] PCI: Using MMCONFIG for extended config space
[    0.325003] PCI: Using configuration type 1 for base access
[    0.326015] initcall pci_arch_init+0x0/0x62 returned 0 after 3906 usecs
[    0.327003] calling  topology_init+0x0/0x46 @ 1
[    0.328050] initcall topology_init+0x0/0x46 returned 0 after 0 usecs
[    0.329010] calling  mtrr_init_finialize+0x0/0x35 @ 1
[    0.330004] initcall mtrr_init_finialize+0x0/0x35 returned 0 after 0 usecs
[    0.331003] calling  param_sysfs_init+0x0/0x18e @ 1
[    0.342111] initcall param_sysfs_init+0x0/0x18e returned 0 after 9765 usecs
[    0.343048] calling  pm_sysrq_init+0x0/0x16 @ 1
[    0.344022] initcall pm_sysrq_init+0x0/0x16 returned 0 after 0 usecs
[    0.345004] calling  init_slow_work+0x0/0x32 @ 1
[    0.346004] initcall init_slow_work+0x0/0x32 returned 0 after 0 usecs
[    0.347005] calling  default_bdi_init+0x0/0xa4 @ 1
[    0.348090] initcall default_bdi_init+0x0/0xa4 returned 0 after 0 usecs
[    0.349055] calling  init_bio+0x0/0xb9 @ 1
[    0.350112] bio: create slab <bio-0> at 0
[    0.351012] initcall init_bio+0x0/0xb9 returned 0 after 976 usecs
[    0.352003] calling  fsnotify_init+0x0/0x19 @ 1
[    0.353008] initcall fsnotify_init+0x0/0x19 returned 0 after 0 usecs
[    0.354003] calling  fsnotify_notification_init+0x0/0xe7 @ 1
[    0.355023] initcall fsnotify_notification_init+0x0/0xe7 returned 0 after 0 usecs
[    0.356003] calling  cryptomgr_init+0x0/0xf @ 1
[    0.357005] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    0.358003] calling  blk_settings_init+0x0/0x1d @ 1
[    0.359003] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    0.360003] calling  blk_ioc_init+0x0/0x24 @ 1
[    0.361013] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    0.362003] calling  blk_softirq_init+0x0/0x51 @ 1
[    0.363004] initcall blk_softirq_init+0x0/0x51 returned 0 after 0 usecs
[    0.364003] calling  blk_iopoll_setup+0x0/0x51 @ 1
[    0.365004] initcall blk_iopoll_setup+0x0/0x51 returned 0 after 0 usecs
[    0.366003] calling  genhd_device_init+0x0/0x50 @ 1
[    0.367051] initcall genhd_device_init+0x0/0x50 returned 0 after 0 usecs
[    0.368010] calling  pci_slot_init+0x0/0x3b @ 1
[    0.369006] initcall pci_slot_init+0x0/0x3b returned 0 after 0 usecs
[    0.370003] calling  acpi_init+0x0/0x2b6 @ 1
[    0.378873] ACPI: Executed 1 blocks of module-level executable AML code
[    0.392585] ACPI: Interpreter enabled
[    0.396003] ACPI: (supports S0 S5)
[    0.399586] ACPI: Using IOAPIC for interrupt routing
[    0.419060] initcall acpi_init+0x0/0x2b6 returned 0 after 46875 usecs
[    0.425024] calling  dock_init+0x0/0x81 @ 1
[    0.430047] ACPI: No dock devices found.
[    0.434004] initcall dock_init+0x0/0x81 returned 0 after 4882 usecs
[    0.440004] calling  acpi_pci_root_init+0x0/0x2a @ 1
[    0.445005] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.454232] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.461348] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.468004] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.474004] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.481004] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.489004] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.496049] pci 0000:00:00.0: calling quirk_no_ata_d3+0x0/0x1c
[    0.502029] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.509067] pci 0000:00:01.0: calling quirk_no_ata_d3+0x0/0x1c
[    0.515020] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.521079] pci 0000:00:12.0: calling quirk_no_ata_d3+0x0/0x1c
[    0.527074] pci 0000:00:12.0: calling quirk_amd_ide_mode+0x0/0xc2
[    0.533006] pci 0000:00:12.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.540058] pci 0000:00:13.0: calling quirk_no_ata_d3+0x0/0x1c
[    0.546061] pci 0000:00:13.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.553023] pci 0000:00:13.1: calling quirk_no_ata_d3+0x0/0x1c
[    0.559060] pci 0000:00:13.1: calling quirk_resource_alignment+0x0/0x1cf
[    0.565024] pci 0000:00:13.2: calling quirk_no_ata_d3+0x0/0x1c
[    0.571060] pci 0000:00:13.2: calling quirk_resource_alignment+0x0/0x1cf
[    0.578023] pci 0000:00:13.3: calling quirk_no_ata_d3+0x0/0x1c
[    0.584060] pci 0000:00:13.3: calling quirk_resource_alignment+0x0/0x1cf
[    0.591024] pci 0000:00:13.4: calling quirk_no_ata_d3+0x0/0x1c
[    0.596060] pci 0000:00:13.4: calling quirk_resource_alignment+0x0/0x1cf
[    0.603039] pci 0000:00:13.5: calling quirk_no_ata_d3+0x0/0x1c
[    0.609060] pci 0000:00:13.5: calling quirk_resource_alignment+0x0/0x1cf
[    0.616079] pci 0000:00:14.0: calling quirk_no_ata_d3+0x0/0x1c
[    0.622004] pci 0000:00:14.0: calling sb600_disable_hpet_bar+0x0/0x4f
[    0.628068] pci 0000:00:14.0: calling force_disable_hpet_msi+0x0/0xc
[    0.635004] pci 0000:00:14.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.641052] pci 0000:00:14.1: calling quirk_no_ata_d3+0x0/0x1c
[    0.647073] pci 0000:00:14.1: calling quirk_resource_alignment+0x0/0x1cf
[    0.654061] pci 0000:00:14.2: calling quirk_no_ata_d3+0x0/0x1c
[    0.660060] pci 0000:00:14.2: calling quirk_resource_alignment+0x0/0x1cf
[    0.667061] pci 0000:00:14.3: calling quirk_no_ata_d3+0x0/0x1c
[    0.673034] pci 0000:00:14.3: calling quirk_resource_alignment+0x0/0x1cf
[    0.679037] pci 0000:00:14.4: calling quirk_no_ata_d3+0x0/0x1c
[    0.685027] pci 0000:00:14.4: calling quirk_resource_alignment+0x0/0x1cf
[    0.692053] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.699045] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x1cf
[    0.705036] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x1cf
[    0.712039] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x1cf
[    0.719076] pci 0000:01:05.0: calling quirk_no_ata_d3+0x0/0x1c
[    0.725044] pci 0000:01:05.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.732044] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.737166] pci 0000:02:07.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.744006] pci 0000:02:07.0: calling pci_fixup_transparent_bridge+0x0/0x2b
[    0.751179] pci 0000:02:07.1: calling quirk_resource_alignment+0x0/0x1cf
[    0.758004] pci 0000:02:07.1: calling pci_fixup_transparent_bridge+0x0/0x2b
[    0.765127] pci 0000:02:0f.0: calling quirk_resource_alignment+0x0/0x1cf
[    0.771083] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.823054] initcall acpi_pci_root_init+0x0/0x2a returned 0 after 369140 usecs
[    0.830005] calling  acpi_pci_link_init+0x0/0x3f @ 1
[    0.835182] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.843150] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.851093] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.858345] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.866343] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.874342] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.882346] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.890148] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.898018] initcall acpi_pci_link_init+0x0/0x3f returned 0 after 61523 usecs
[    0.899005] calling  pnp_init+0x0/0xf @ 1
[    0.900043] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    0.901004] calling  misc_init+0x0/0x9b @ 1
[    0.902057] initcall misc_init+0x0/0x9b returned 0 after 0 usecs
[    0.903005] calling  vga_arb_device_init+0x0/0x68 @ 1
[    0.904140] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.905012] vgaarb: loaded
[    0.906003] initcall vga_arb_device_init+0x0/0x68 returned 0 after 1953 usecs
[    0.907003] calling  init_scsi+0x0/0x74 @ 1
[    0.909059] SCSI subsystem initialized
[    0.912009] initcall init_scsi+0x0/0x74 returned 0 after 3906 usecs
[    0.919003] calling  ata_init+0x0/0x2ab @ 1
[    0.923021] initcall ata_init+0x0/0x2ab returned 0 after 0 usecs
[    0.924007] calling  usb_init+0x0/0xfa @ 1
[    0.925078] usbcore: registered new interface driver usbfs
[    0.926067] usbcore: registered new interface driver hub
[    0.927050] usbcore: registered new device driver usb
[    0.932006] initcall usb_init+0x0/0xfa returned 0 after 6835 usecs
[    0.939003] calling  serio_init+0x0/0x73 @ 1
[    0.943046] initcall serio_init+0x0/0x73 returned 0 after 0 usecs
[    0.944009] calling  input_init+0x0/0x10f @ 1
[    0.946000] initcall input_init+0x0/0x10f returned 0 after 976 usecs
[    0.952009] calling  power_supply_class_init+0x0/0x39 @ 1
[    0.957032] initcall power_supply_class_init+0x0/0x39 returned 0 after 0 usecs
[    0.965005] calling  hwmon_init+0x0/0xf3 @ 1
[    0.969033] initcall hwmon_init+0x0/0xf3 returned 0 after 0 usecs
[    0.975006] calling  thermal_init+0x0/0x46 @ 1
[    0.980029] initcall thermal_init+0x0/0x46 returned 0 after 976 usecs
[    0.986005] calling  md_init+0x0/0xb7 @ 1
[    0.990013] initcall md_init+0x0/0xb7 returned 0 after 0 usecs
[    0.996004] calling  init_soundcore+0x0/0x83 @ 1
[    1.001026] initcall init_soundcore+0x0/0x83 returned 0 after 976 usecs
[    1.007004] calling  alsa_sound_init+0x0/0x88 @ 1
[    1.012074] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    1.018004] initcall alsa_sound_init+0x0/0x88 returned 0 after 5859 usecs
[    1.025004] calling  pci_subsys_init+0x0/0x44 @ 1
[    1.030002] PCI: Using ACPI for IRQ routing
[    1.034049] pci 0000:00:14.0: no compatible bridge window for [mem 0xfed00000-0xfed003ff]
[    1.042119] calling  proto_init+0x0/0xf @ 1
[    1.047009] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    1.053004] calling  net_dev_init+0x0/0x1d5 @ 1
[    1.058013] initcall net_dev_init+0x0/0x1d5 returned 0 after 976 usecs
[    1.064004] calling  neigh_init+0x0/0x66 @ 1
[    1.068004] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    1.074003] calling  fib_rules_init+0x0/0x99 @ 1
[    1.079005] initcall fib_rules_init+0x0/0x99 returned 0 after 0 usecs
[    1.086003] calling  pktsched_init+0x0/0xce @ 1
[    1.090024] initcall pktsched_init+0x0/0xce returned 0 after 0 usecs
[    1.096003] calling  tc_filter_init+0x0/0x43 @ 1
[    1.101003] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    1.108003] calling  tc_action_init+0x0/0x43 @ 1
[    1.112004] initcall tc_action_init+0x0/0x43 returned 0 after 0 usecs
[    1.119003] calling  genl_init+0x0/0x77 @ 1
[    1.123070] initcall genl_init+0x0/0x77 returned 0 after 0 usecs
[    1.129004] calling  atm_init+0x0/0xbc @ 1
[    1.133004] NET: Registered protocol family 8
[    1.137002] NET: Registered protocol family 20
[    1.142031] initcall atm_init+0x0/0xbc returned 0 after 8789 usecs
[    1.148009] calling  sysctl_init+0x0/0x3b @ 1
[    1.152005] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    1.159004] calling  print_ICs+0x0/0x4e1 @ 1
[    1.163003] initcall print_ICs+0x0/0x4e1 returned 0 after 0 usecs
[    1.169003] calling  hpet_late_init+0x0/0x22e @ 1
[    1.174010] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.179199] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.187003] initcall hpet_late_init+0x0/0x22e returned 0 after 12695 usecs
[    1.194003] calling  init_k8_nbs+0x0/0x21 @ 1
[    1.198067] initcall init_k8_nbs+0x0/0x21 returned 0 after 0 usecs
[    1.204004] calling  clocksource_done_booting+0x0/0x53 @ 1
[    1.210005] Switching to clocksource hpet
[    1.214099] initcall clocksource_done_booting+0x0/0x53 returned 0 after 3926 usecs
[    1.221608] calling  init_pipe_fs+0x0/0x3d @ 1
[    1.226144] initcall init_pipe_fs+0x0/0x3d returned 0 after 77 usecs
[    1.232501] calling  eventpoll_init+0x0/0xb9 @ 1
[    1.237178] initcall eventpoll_init+0x0/0xb9 returned 0 after 47 usecs
[    1.243717] calling  anon_inode_init+0x0/0xf5 @ 1
[    1.248499] initcall anon_inode_init+0x0/0xf5 returned 0 after 65 usecs
[    1.255122] calling  blk_scsi_ioctl_init+0x0/0x294 @ 1
[    1.260275] initcall blk_scsi_ioctl_init+0x0/0x294 returned 0 after 2 usecs
[    1.267246] calling  acpi_event_init+0x0/0x46 @ 1
[    1.271975] initcall acpi_event_init+0x0/0x46 returned 0 after 14 usecs
[    1.278599] calling  pnpacpi_init+0x0/0x7b @ 1
[    1.283053] pnp: PnP ACPI init
[    1.286148] ACPI: bus type pnp registered
[    1.291339] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:02:0f.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    1.308933] pnp: PnP ACPI: found 14 devices
[    1.313140] ACPI: ACPI bus type pnp unregistered
[    1.317770] initcall pnpacpi_init+0x0/0x7b returned 0 after 33901 usecs
[    1.324396] calling  pnp_system_init+0x0/0xf @ 1
[    1.329050] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    1.334980] system 00:01: [io  0x0220-0x0225] has been reserved
[    1.340907] system 00:01: [io  0x0290-0x0294] has been reserved
[    1.346843] system 00:02: [io  0x4100-0x411f] has been reserved
[    1.352774] system 00:02: [io  0x0228-0x022f] has been reserved
[    1.358700] system 00:02: [io  0x040b] has been reserved
[    1.364023] system 00:02: [io  0x04d6] has been reserved
[    1.369344] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    1.375273] system 00:02: [io  0x0c14] has been reserved
[    1.380593] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    1.386520] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    1.392449] system 00:02: [io  0x0c6f] has been reserved
[    1.397770] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    1.403697] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    1.409626] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    1.415557] system 00:02: [io  0x4000-0x40fe] has been reserved
[    1.421482] system 00:02: [io  0x4210-0x4217] has been reserved
[    1.427412] system 00:02: [io  0x0b00-0x0b1f] could not be reserved
[    1.433686] system 00:02: [io  0x0238-0x023f] has been reserved
[    1.439615] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    1.446852] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.453478] system 00:0d: [mem 0x000cd400-0x000cffff] has been reserved
[    1.460102] system 00:0d: [mem 0x000f0000-0x000f7fff] could not be reserved
[    1.467069] system 00:0d: [mem 0x000f8000-0x000fbfff] could not be reserved
[    1.474038] system 00:0d: [mem 0x000fc000-0x000fffff] could not be reserved
[    1.481014] system 00:0d: [mem 0x7dee0000-0x7defffff] could not be reserved
[    1.487984] system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
[    1.494604] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.501572] system 00:0d: [mem 0x00100000-0x7dedffff] could not be reserved
[    1.508542] system 00:0d: [mem 0x7dff0000-0x7ffeffff] could not be reserved
[    1.515510] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.522476] system 00:0d: [mem 0xfee00000-0xfee00fff] could not be reserved
[    1.529445] system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
[    1.536141] initcall pnp_system_init+0x0/0xf returned 0 after 202260 usecs
[    1.543033] calling  chr_dev_init+0x0/0xb0 @ 1
[    1.554552] initcall chr_dev_init+0x0/0xb0 returned 0 after 6894 usecs
[    1.561142] calling  firmware_class_init+0x0/0x14 @ 1
[    1.566352] initcall firmware_class_init+0x0/0x14 returned 0 after 79 usecs
[    1.573333] calling  ieee1394_init+0x0/0x208 @ 1
[    1.578505] initcall ieee1394_init+0x0/0x208 returned 0 after 529 usecs
[    1.585129] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    1.590906] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 22 usecs
[    1.598568] calling  init_acpi_pm_clocksource+0x0/0x1a7 @ 1
[    1.638698] initcall init_acpi_pm_clocksource+0x0/0x1a7 returned 0 after 33736 usecs
[    1.646443] calling  pcibios_assign_resources+0x0/0x81 @ 1
[    1.651998] pci 0000:00:14.0: BAR 1: assigned [mem 0x80000000-0x800003ff]
[    1.658796] pci 0000:00:14.0: BAR 1: set to [mem 0x80000000-0x800003ff] (PCI address [0x80000000-0x800003ff]
[  299.177004] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[  299.177004] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[  299.177004] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[  299.177004] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[  299.177004] pci 0000:02:0f.0: BAR 6: assigned [mem 0xfdc00000-0xfdc1ffff pref]
[  299.177004] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[  299.177004] pci 0000:00:14.4:   bridge window [io  0xd000-0xdfff]
[  299.177004] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
[  299.177004] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[  299.177004] initcall pcibios_assign_resources+0x0/0x81 returned 0 after 290550845 usecs
[  299.177004] calling  sysctl_core_init+0x0/0x2d @ 1
[  299.177004] initcall sysctl_core_init+0x0/0x2d returned 0 after 0 usecs
[  299.177004] calling  inet_init+0x0/0x1f6 @ 1
[  299.177004] NET: Registered protocol family 2
[  299.177004] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[  299.177004] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[  299.177004] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[  299.177004] TCP: Hash tables configured (established 131072 bind 65536)
[  299.177004] TCP reno registered
[  299.177004] UDP hash table entries: 512 (order: 3, 40960 bytes)
[  299.177004] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[  299.177004] initcall inet_init+0x0/0x1f6 returned 0 after 0 usecs
[  299.177004] calling  af_unix_init+0x0/0x47 @ 1
[  299.177004] NET: Registered protocol family 1
[  299.177004] initcall af_unix_init+0x0/0x47 returned 0 after 0 usecs
[  299.177004] calling  pci_apply_final_quirks+0x0/0x11e @ 1
[  299.177004] pci 0000:00:00.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x5dd
[  299.177004] pci 0000:00:00.0: calling pci_fixup_video+0x0/0x9c
[  299.177004] pci 0000:00:01.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x5dd
[  299.177004] pci 0000:00:01.0: calling pci_fixup_video+0x0/0x9c
[  299.177004] pci 0000:00:12.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x5dd
[  299.177004] pci 0000:00:12.0: calling pci_fixup_video+0x0/0x9c
[  299.177004] pci 0000:00:13.0: pci_apply_final_quirks
[  299.177004] pci 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x21
[  299.177004] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x5dd
=stalled=
------=_20100909131633_40936
Content-Type: text/plain; name="pci=nocrs.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="pci=nocrs.txt"

[    0.000000] Linux version 2.6.35.4-git+ (byte@proxima) (gcc version 4.3.1 (Gentoo 4.3.1 p1.0) ) #git+ SMP PREEMPT 2010-08-25T23:29:08+0100
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007dee0000 (usable)
[    0.000000]  BIOS-e820: 000000007dee0000 - 000000007dee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007dee3000 - 000000007def0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007def0000 - 000000007df00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7dee0 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 007DF00000 mask FFFFF00000 uncachable
[    0.000000]   2 base 007E000000 mask FFFE000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] found SMP MP-table at [c00f5140] f5140
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000f6b00 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 7dee3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 7dee3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 7dee30c0 049B3 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 7dee0000 00040
[    0.000000] ACPI: SSDT 7dee7b40 00248 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 7dee7dc0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 7dee7e00 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 7dee7a80 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1122MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0007dee0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007dee0
[    0.000000] On node 0 totalpages: 515710
[    0.000000] free_area_init_node: node 0, pgdat c06ca980, node_mem_map c1001020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3966 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2246 pages used for memmap
[    0.000000]   HighMem zone: 285212 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [3000 - 37ff]
[    0.000000] Allocating PCI resources starting at 7df00000 (gap: 7df00000:62100000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @c2000000 s30400 r0 d22848 u1048576
[    0.000000] pcpu-alloc: s30400 r0 d22848 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 511680
[    0.000000] Kernel command line: root=/dev/sda1 ro panic=10 init=/startup sysrq_always_enabled console=ttyS0,115200 vga=0xf07 initcall_debug=1 tsc=reliable pci=nocrs
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Subtract (44 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0000c781e4]   TEXT DATA BSS
[    0.000000]   #3 [0000c79000 - 0000c810fe]             BRK
[    0.000000]   #4 [00000f5150 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f5140 - 00000f5150]    MP-table mpf
[    0.000000]   #6 [000009f800 - 00000f0f00]   BIOS reserved
[    0.000000]   #7 [00000f1054 - 00000f5140]   BIOS reserved
[    0.000000]   #8 [00000f0f00 - 00000f1054]    MP-table mpc
[    0.000000]   #9 [0000002000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #11 [0001000000 - 0001001000]         BOOTMEM
[    0.000000]   #12 [0001001000 - 0001fc1000]         BOOTMEM
[    0.000000]   #13 [0001fc1000 - 0001fc1004]         BOOTMEM
[    0.000000]   #14 [0001fc1040 - 0001fc1280]         BOOTMEM
[    0.000000]   #15 [0001fc1280 - 0001fc1328]         BOOTMEM
[    0.000000]   #16 [0001fc1340 - 0001fca340]         BOOTMEM
[    0.000000]   #17 [0001fca340 - 0001fca414]         BOOTMEM
[    0.000000]   #18 [0001fca440 - 0001fdc440]         BOOTMEM
[    0.000000]   #19 [0001fdc440 - 0001fdc46d]         BOOTMEM
[    0.000000]   #20 [0001fdc480 - 0001fdc4af]         BOOTMEM
[    0.000000]   #21 [0001fdc4c0 - 0001fdc628]         BOOTMEM
[    0.000000]   #22 [0001fdc640 - 0001fdc680]         BOOTMEM
[    0.000000]   #23 [0001fdc680 - 0001fdc6c0]         BOOTMEM
[    0.000000]   #24 [0001fdc6c0 - 0001fdc700]         BOOTMEM
[    0.000000]   #25 [0001fdc700 - 0001fdc740]         BOOTMEM
[    0.000000]   #26 [0001fdc740 - 0001fdc780]         BOOTMEM
[    0.000000]   #27 [0001fdc780 - 0001fdc7c0]         BOOTMEM
[    0.000000]   #28 [0001fdc7c0 - 0001fdc800]         BOOTMEM
[    0.000000]   #29 [0001fdc800 - 0001fdc840]         BOOTMEM
[    0.000000]   #30 [0001fdc840 - 0001fdc880]         BOOTMEM
[    0.000000]   #31 [0001fdc880 - 0001fdc905]         BOOTMEM
[    0.000000]   #32 [0001fdc940 - 0001fdc9c5]         BOOTMEM
[    0.000000]   #33 [0002000000 - 000200d000]         BOOTMEM
[    0.000000]   #34 [0002100000 - 000210d000]         BOOTMEM
[    0.000000]   #35 [0001fdea00 - 0001fdea04]         BOOTMEM
[    0.000000]   #36 [0001fdea40 - 0001fdea44]         BOOTMEM
[    0.000000]   #37 [0001fdea80 - 0001fdea88]         BOOTMEM
[    0.000000]   #38 [0001fdeac0 - 0001fdeac8]         BOOTMEM
[    0.000000]   #39 [0001fdeb00 - 0001fdeba0]         BOOTMEM
[    0.000000]   #40 [0001fdebc0 - 0001fdec08]         BOOTMEM
[    0.000000]   #41 [0001fdec40 - 0001fe2c40]         BOOTMEM
[    0.000000]   #42 [000200d000 - 000208d000]         BOOTMEM
[    0.000000]   #43 [000208d000 - 00020cd000]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (00037bfe:0007dee0)
[    0.000000] Memory: 2034932k/2063232k available (3157k kernel code, 27908k reserved, 1766k data, 376k init, 1149832k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc06cf000 - 0xc072d000   ( 376 kB)
[    0.000000]       .data : 0xc05155ca - 0xc06ceff4   (1766 kB)
[    0.000000]       .text : 0xc0200000 - 0xc05155ca   (3157 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2305.745 MHz processor.
[    0.003003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4611.49 BogoMIPS (lpj=2305745)
[    0.005004] pid_max: default: 32768 minimum: 301
[    0.006071] Security Framework initialized
[    0.007065] TCP/UDP port access control v1.1 LSM initialised
[    0.008045] Mount-cache hash table entries: 512
[    0.010052] CPU: Physical Processor ID: 0
[    0.011003] CPU: Processor Core ID: 0
[    0.012004] mce: CPU supports 5 MCE banks
[    0.013011] using C1E aware idle routine
[    0.014010] Performance Events: AMD PMU driver.
[    0.016010] ... version:                0
[    0.017003] ... bit width:              48
[    0.018003] ... generic registers:      4
[    0.019003] ... value mask:             0000ffffffffffff
[    0.020003] ... max period:             00007fffffffffff
[    0.021003] ... fixed-purpose events:   0
[    0.022004] ... event mask:             000000000000000f
[    0.024109] Freeing SMP alternatives: 16k freed
[    0.025017] ACPI: Core revision 20100428
[    0.035210] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.037335] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.048354] CPU0: AMD Athlon(tm) Dual Core Processor 4450e stepping 02
[    0.051999] calling  migration_init+0x0/0x47 @ 1
[    0.052006] initcall migration_init+0x0/0x47 returned 0 after 0 usecs
[    0.053003] calling  spawn_ksoftirqd+0x0/0x43 @ 1
[    0.055043] initcall spawn_ksoftirqd+0x0/0x43 returned 0 after 976 usecs
[    0.056004] calling  init_call_single_data+0x0/0x80 @ 1
[    0.057004] initcall init_call_single_data+0x0/0x80 returned 0 after 0 usecs
[    0.058003] calling  cpu_stop_init+0x0/0x9b @ 1
[    0.060017] initcall cpu_stop_init+0x0/0x9b returned 0 after 976 usecs
[    0.061003] calling  spawn_softlockup_task+0x0/0x5f @ 1
[    0.063016] initcall spawn_softlockup_task+0x0/0x5f returned 0 after 976 usecs
[    0.066008] lockdep: fixing up alternatives.
[    0.067104] Booting Node   0, Processors  #1 Ok.
[    0.003999] Initializing CPU#1
[    0.140099] Brought up 2 CPUs
[    0.141003] Total of 2 processors activated (9221.86 BogoMIPS).
[    0.144065] calling  init_mmap_min_addr+0x0/0x11 @ 1
[    0.145005] initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
[    0.146004] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.147006] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.148026] calling  net_ns_init+0x0/0x162 @ 1
[    0.149027] initcall net_ns_init+0x0/0x162 returned 0 after 0 usecs
[    0.150004] calling  cpufreq_tsc+0x0/0x25 @ 1
[    0.151003] initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
[    0.152005] calling  pci_reboot_init+0x0/0x11 @ 1
[    0.153006] initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.154003] calling  reboot_init+0x0/0x11 @ 1
[    0.155011] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.157003] calling  init_lapic_sysfs+0x0/0x28 @ 1
[    0.158038] initcall init_lapic_sysfs+0x0/0x28 returned 0 after 0 usecs
[    0.159018] calling  init_smp_flush+0x0/0x2a @ 1
[    0.160004] initcall init_smp_flush+0x0/0x2a returned 0 after 0 usecs
[    0.161003] calling  sysctl_init+0x0/0x2d @ 1
[    0.162005] initcall sysctl_init+0x0/0x2d returned 0 after 0 usecs
[    0.163004] calling  ksysfs_init+0x0/0x74 @ 1
[    0.164010] initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
[    0.165003] calling  async_init+0x0/0x50 @ 1
[    0.166017] initcall async_init+0x0/0x50 returned 0 after 0 usecs
[    0.172006] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.177006] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.184004] calling  pm_init+0x0/0x2d @ 1
[    0.188015] initcall pm_init+0x0/0x2d returned 0 after 0 usecs
[    0.194004] calling  init_hw_breakpoint+0x0/0xaf @ 1
[    0.199005] initcall init_hw_breakpoint+0x0/0xaf returned 0 after 0 usecs
[    0.206003] calling  init_zero_pfn+0x0/0x14 @ 1
[    0.210003] initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
[    0.217003] calling  filelock_init+0x0/0x27 @ 1
[    0.221027] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.228004] calling  init_script_binfmt+0x0/0x11 @ 1
[    0.233023] initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.240003] calling  init_elf_binfmt+0x0/0x11 @ 1
[    0.244004] initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.251004] calling  random32_init+0x0/0xa8 @ 1
[    0.255004] initcall random32_init+0x0/0xa8 returned 0 after 0 usecs
[    0.262004] calling  cpufreq_core_init+0x0/0x7b @ 1
[    0.267007] initcall cpufreq_core_init+0x0/0x7b returned 0 after 0 usecs
[    0.273003] calling  cpuidle_init+0x0/0x32 @ 1
[    0.278008] initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
[    0.284004] calling  sock_init+0x0/0x51 @ 1
[    0.288146] initcall sock_init+0x0/0x51 returned 0 after 0 usecs
[    0.294004] calling  netlink_proto_init+0x0/0x108 @ 1
[    0.299043] NET: Registered protocol family 16
[    0.304056] initcall netlink_proto_init+0x0/0x108 returned 0 after 4882 usecs
[    0.311003] calling  bdi_class_init+0x0/0x2f @ 1
[    0.316033] initcall bdi_class_init+0x0/0x2f returned 0 after 0 usecs
[    0.322009] calling  kobject_uevent_init+0x0/0x1e @ 1
[    0.327028] initcall kobject_uevent_init+0x0/0x1e returned 0 after 0 usecs
[    0.334004] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.339062] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.346006] calling  pci_driver_init+0x0/0xf @ 1
[    0.350040] initcall pci_driver_init+0x0/0xf returned 0 after 976 usecs
[    0.357010] calling  tty_class_init+0x0/0x2f @ 1
[    0.362031] initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs
[    0.368005] calling  vtconsole_class_init+0x0/0xa1 @ 1
[    0.374063] initcall vtconsole_class_init+0x0/0xa1 returned 0 after 976 usecs
[    0.381008] calling  i2c_init+0x0/0x57 @ 1
[    0.385061] initcall i2c_init+0x0/0x57 returned 0 after 0 usecs
[    0.391006] calling  amd_postcore_init+0x0/0xa72 @ 1
[    0.396006] node 0 link 0: io port [d000, ffff]
[    0.396010] TOM: 0000000080000000 aka 2048M
[    0.400003] node 0 link 0: mmio [a0000, bffff]
[    0.400007] node 0 link 0: mmio [fc000000, fe02ffff]
[    0.400011] node 0 link 0: mmio [80000000, f9ffffff]
[    0.400014] node 0 link 0: mmio [fa000000, fbffffff]
[    0.400018] node 0 link 0: mmio [e0000000, efffffff]
[    0.400022] bus: [00, 02] on node 0 link 0
[    0.400025] bus: 00 index 0 [io  0x0000-0xffff]
[    0.400027] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.400030] bus: 00 index 2 [mem 0xfa000000-0xfcffffffff]
[    0.400033] bus: 00 index 3 [mem 0x80000000-0xf9ffffff]
[    0.400038] initcall amd_postcore_init+0x0/0xa72 returned 0 after 3906 usecs
[    0.407004] calling  arch_kdebugfs_init+0x0/0x11 @ 1
[    0.412004] initcall arch_kdebugfs_init+0x0/0x11 returned 0 after 0 usecs
[    0.419003] calling  init_pit_clocksource+0x0/0x98 @ 1
[    0.424004] initcall init_pit_clocksource+0x0/0x98 returned 0 after 0 usecs
[    0.431004] calling  mtrr_if_init+0x0/0x44 @ 1
[    0.436007] initcall mtrr_if_init+0x0/0x44 returned 0 after 0 usecs
[    0.442004] calling  ffh_cstate_init+0x0/0x27 @ 1
[    0.447004] initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usecs
[    0.453004] initcall ffh_cstate_init+0x0/0x27 returned with error code -1 
[    0.460004] calling  acpi_pci_init+0x0/0x51 @ 1
[    0.465018] ACPI: bus type pci registered
[    0.469004] initcall acpi_pci_init+0x0/0x51 returned 0 after 3906 usecs
[    0.475003] calling  dmi_id_init+0x0/0x26e @ 1
[    0.480081] initcall dmi_id_init+0x0/0x26e returned 0 after 0 usecs
[    0.486011] calling  pci_arch_init+0x0/0x62 @ 1
[    0.491038] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.500004] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.507002] PCI: Using MMCONFIG for extended config space
[    0.512002] PCI: Using configuration type 1 for base access
[    0.518015] initcall pci_arch_init+0x0/0x62 returned 0 after 26367 usecs
[    0.524003] calling  topology_init+0x0/0x46 @ 1
[    0.529046] initcall topology_init+0x0/0x46 returned 0 after 0 usecs
[    0.535021] calling  mtrr_init_finialize+0x0/0x35 @ 1
[    0.541004] initcall mtrr_init_finialize+0x0/0x35 returned 0 after 0 usecs
[    0.547004] calling  param_sysfs_init+0x0/0x18e @ 1
[    0.562114] initcall param_sysfs_init+0x0/0x18e returned 0 after 9765 usecs
[    0.569045] calling  pm_sysrq_init+0x0/0x16 @ 1
[    0.574018] initcall pm_sysrq_init+0x0/0x16 returned 0 after 0 usecs
[    0.580004] calling  init_slow_work+0x0/0x32 @ 1
[    0.585004] initcall init_slow_work+0x0/0x32 returned 0 after 0 usecs
[    0.591003] calling  default_bdi_init+0x0/0xa4 @ 1
[    0.596091] initcall default_bdi_init+0x0/0xa4 returned 0 after 0 usecs
[    0.603044] calling  init_bio+0x0/0xb9 @ 1
[    0.607092] bio: create slab <bio-0> at 0
[    0.611012] initcall init_bio+0x0/0xb9 returned 0 after 3906 usecs
[    0.617003] calling  fsnotify_init+0x0/0x19 @ 1
[    0.622008] initcall fsnotify_init+0x0/0x19 returned 0 after 0 usecs
[    0.628003] calling  fsnotify_notification_init+0x0/0xe7 @ 1
[    0.634023] initcall fsnotify_notification_init+0x0/0xe7 returned 0 after 0 usecs
[    0.641004] calling  cryptomgr_init+0x0/0xf @ 1
[    0.646004] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    0.652003] calling  blk_settings_init+0x0/0x1d @ 1
[    0.657004] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    0.664003] calling  blk_ioc_init+0x0/0x24 @ 1
[    0.668013] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    0.675003] calling  blk_softirq_init+0x0/0x51 @ 1
[    0.679004] initcall blk_softirq_init+0x0/0x51 returned 0 after 0 usecs
[    0.686003] calling  blk_iopoll_setup+0x0/0x51 @ 1
[    0.691004] initcall blk_iopoll_setup+0x0/0x51 returned 0 after 0 usecs
[    0.697003] calling  genhd_device_init+0x0/0x50 @ 1
[    0.702054] initcall genhd_device_init+0x0/0x50 returned 0 after 0 usecs
[    0.709043] calling  pci_slot_init+0x0/0x3b @ 1
[    0.714007] initcall pci_slot_init+0x0/0x3b returned 0 after 0 usecs
[    0.720004] calling  acpi_init+0x0/0x2b6 @ 1
[    0.728497] ACPI: EC: Look up EC in DSDT
[    0.732519] ACPI: Executed 1 blocks of module-level executable AML code
[    0.742159] ACPI: Interpreter enabled
[    0.743002] ACPI: (supports S0 S5)
[    0.745290] ACPI: Using IOAPIC for interrupt routing
[    0.760150] initcall acpi_init+0x0/0x2b6 returned 0 after 35156 usecs
[    0.761048] calling  dock_init+0x0/0x81 @ 1
[    0.762323] ACPI: No dock devices found.
[    0.763004] initcall dock_init+0x0/0x81 returned 0 after 976 usecs
[    0.764004] calling  acpi_pci_root_init+0x0/0x2a @ 1
[    0.765007] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.766234] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.768134] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.768138] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.768141] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.768144] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.768147] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
[    0.768375] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
[    0.768385] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
[    0.768394] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
[    0.768403] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
[    0.768413] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
[    0.768423] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.768499] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.768574] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.768650] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
[    0.768725] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.768801] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.768892] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.768965] pci 0000:00:13.5: supports D1 D2
[    0.768967] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.768974] pci 0000:00:13.5: PME# disabled
[    0.769033] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.769042] pci 0000:00:14.0: reg 14: [mem 0xfed00000-0xfed003ff]
[    0.769151] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.769160] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.769169] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.769178] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.769187] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
[    0.769281] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.769347] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.769353] pci 0000:00:14.2: PME# disabled
[    0.769659] PCI: peer root bus 00 res updated from pci conf
[    0.769725] pci 0000:01:05.0: reg 10: [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.769735] pci 0000:01:05.0: reg 18: [mem 0xfdff0000-0xfdffffff 64bit]
[    0.769741] pci 0000:01:05.0: reg 20: [io  0xee00-0xeeff]
[    0.769747] pci 0000:01:05.0: reg 24: [mem 0xfde00000-0xfdefffff]
[    0.769769] pci 0000:01:05.0: supports D1 D2
[    0.769802] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.770006] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.770011] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.770017] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.770112] pci 0000:02:07.0: reg 10: [mem 0xfdda0000-0xfddbffff 64bit]
[    0.770140] pci 0000:02:07.0: reg 20: [io  0xdf00-0xdf3f]
[    0.770201] pci 0000:02:07.0: PME# supported from D0 D3hot D3cold
[    0.770207] pci 0000:02:07.0: PME# disabled
[    0.770286] pci 0000:02:07.1: reg 10: [mem 0xfddc0000-0xfdddffff 64bit]
[    0.770314] pci 0000:02:07.1: reg 20: [io  0xde00-0xde3f]
[    0.770374] pci 0000:02:07.1: PME# supported from D0 D3hot D3cold
[    0.770380] pci 0000:02:07.1: PME# disabled
[    0.770467] pci 0000:02:0f.0: reg 10: [io  0xdc00-0xdcff]
[    0.770477] pci 0000:02:0f.0: reg 14: [mem 0xfddff000-0xfddff0ff]
[    0.770519] pci 0000:02:0f.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.770551] pci 0000:02:0f.0: supports D1 D2
[    0.770553] pci 0000:02:0f.0: PME# supported from D1 D2 D3hot D3cold
[    0.770560] pci 0000:02:0f.0: PME# disabled
[    0.770606] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.771006] pci 0000:00:14.4:   bridge window [io  0xd000-0xdfff]
[    0.771013] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.771019] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    0.771023] pci 0000:00:14.4:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.771026] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.771030] pci 0000:00:14.4:   bridge window [mem 0xfa000000-0xfcffffffff] (subtractive decode)
[    0.771033] pci 0000:00:14.4:   bridge window [mem 0x80000000-0xf9ffffff] (subtractive decode)
[    0.771048] pci_bus 0000:00: on NUMA node 0
[    0.771055] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.772440] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.772753] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.815099] initcall acpi_pci_root_init+0x0/0x2a returned 0 after 48828 usecs
[    0.816011] calling  acpi_pci_link_init+0x0/0x3f @ 1
[    0.817181] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.821350] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.825347] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.829349] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.834152] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.839023] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.843349] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.847349] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.851272] initcall acpi_pci_link_init+0x0/0x3f returned 0 after 33203 usecs
[    0.852022] calling  pnp_init+0x0/0xf @ 1
[    0.853038] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    0.854009] calling  misc_init+0x0/0x9b @ 1
[    0.855055] initcall misc_init+0x0/0x9b returned 0 after 0 usecs
[    0.856006] calling  vga_arb_device_init+0x0/0x68 @ 1
[    0.858092] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.859012] vgaarb: loaded
[    0.860003] initcall vga_arb_device_init+0x0/0x68 returned 0 after 2929 usecs
[    0.861003] calling  init_scsi+0x0/0x74 @ 1
[    0.862143] SCSI subsystem initialized
[    0.863009] initcall init_scsi+0x0/0x74 returned 0 after 976 usecs
[    0.864003] calling  ata_init+0x0/0x2ab @ 1
[    0.865027] libata version 3.00 loaded.
[    0.865027] initcall ata_init+0x0/0x2ab returned 0 after 0 usecs
[    0.871008] calling  usb_init+0x0/0xfa @ 1
[    0.876055] usbcore: registered new interface driver usbfs
[    0.881064] usbcore: registered new interface driver hub
[    0.887050] usbcore: registered new device driver usb
[    0.888005] initcall usb_init+0x0/0xfa returned 0 after 12695 usecs
[    0.889003] calling  serio_init+0x0/0x73 @ 1
[    0.890048] initcall serio_init+0x0/0x73 returned 0 after 0 usecs
[    0.896009] calling  input_init+0x0/0x10f @ 1
[    0.901039] initcall input_init+0x0/0x10f returned 0 after 0 usecs
[    0.907010] calling  power_supply_class_init+0x0/0x39 @ 1
[    0.913028] initcall power_supply_class_init+0x0/0x39 returned 0 after 0 usecs
[    0.920008] calling  hwmon_init+0x0/0xf3 @ 1
[    0.924032] initcall hwmon_init+0x0/0xf3 returned 0 after 0 usecs
[    0.930008] calling  thermal_init+0x0/0x46 @ 1
[    0.935031] initcall thermal_init+0x0/0x46 returned 0 after 0 usecs
[    0.941005] calling  md_init+0x0/0xb7 @ 1
[    0.945014] initcall md_init+0x0/0xb7 returned 0 after 0 usecs
[    0.951004] calling  init_soundcore+0x0/0x83 @ 1
[    0.956029] initcall init_soundcore+0x0/0x83 returned 0 after 0 usecs
[    0.962010] calling  alsa_sound_init+0x0/0x88 @ 1
[    0.967075] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.973004] initcall alsa_sound_init+0x0/0x88 returned 0 after 5859 usecs
[    0.980004] calling  pci_subsys_init+0x0/0x44 @ 1
[    0.985002] PCI: Using ACPI for IRQ routing
[    0.989004] PCI: pci_cache_line_size set to 64 bytes
[    0.989156] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.989160] reserve RAM buffer: 000000007dee0000 - 000000007fffffff initcall pci_subsys_init+0x0/0x44 returned 0 after 3906 usecs
[    0.989170] calling  proto_init+0x0/0xf @ 1
[    0.993009] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    0.999004] calling  net_dev_init+0x0/0x1d5 @ 1
[    1.004248] initcall net_dev_init+0x0/0x1d5 returned 0 after 0 usecs
[    1.011007] calling  neigh_init+0x0/0x66 @ 1
[    1.015005] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    1.021004] calling  fib_rules_init+0x0/0x99 @ 1
[    1.026006] initcall fib_rules_init+0x0/0x99 returned 0 after 0 usecs
[    1.032003] calling  pktsched_init+0x0/0xce @ 1
[    1.037025] initcall pktsched_init+0x0/0xce returned 0 after 0 usecs
[    1.043003] calling  tc_filter_init+0x0/0x43 @ 1
[    1.048003] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    1.054011] calling  tc_action_init+0x0/0x43 @ 1
[    1.059003] initcall tc_action_init+0x0/0x43 returned 0 after 0 usecs
[    1.065003] calling  genl_init+0x0/0x77 @ 1
[    1.069052] initcall genl_init+0x0/0x77 returned 0 after 0 usecs
[    1.075004] calling  atm_init+0x0/0xbc @ 1
[    1.079004] NET: Registered protocol family 8
[    1.084002] NET: Registered protocol family 20
[    1.088031] initcall atm_init+0x0/0xbc returned 0 after 8789 usecs
[    1.095014] calling  sysctl_init+0x0/0x3b @ 1
[    1.099005] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    1.105004] calling  print_ICs+0x0/0x4e1 @ 1
[    1.109004] initcall print_ICs+0x0/0x4e1 returned 0 after 0 usecs
[    1.115003] calling  hpet_late_init+0x0/0x22e @ 1
[    1.120010] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.125760] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.133003] initcall hpet_late_init+0x0/0x22e returned 0 after 12695 usecs
[    1.140005] calling  init_k8_nbs+0x0/0x21 @ 1
[    1.145039] initcall init_k8_nbs+0x0/0x21 returned 0 after 0 usecs
[    1.151005] calling  clocksource_done_booting+0x0/0x53 @ 1
[    1.156006] Switching to clocksource hpet
[    1.160092] initcall clocksource_done_booting+0x0/0x53 returned 0 after 3929 usecs
[    1.167607] calling  init_pipe_fs+0x0/0x3d @ 1
[    1.172153] initcall init_pipe_fs+0x0/0x3d returned 0 after 84 usecs
[    1.178512] calling  eventpoll_init+0x0/0xb9 @ 1
[    1.183193] initcall eventpoll_init+0x0/0xb9 returned 0 after 50 usecs
[    1.189727] calling  anon_inode_init+0x0/0xf5 @ 1
[    1.194507] initcall anon_inode_init+0x0/0xf5 returned 0 after 63 usecs
[    1.201132] calling  blk_scsi_ioctl_init+0x0/0x294 @ 1
[    1.206282] initcall blk_scsi_ioctl_init+0x0/0x294 returned 0 after 1 usecs
[    1.213248] calling  acpi_event_init+0x0/0x46 @ 1
[    1.217974] initcall acpi_event_init+0x0/0x46 returned 0 after 9 usecs
[    1.224506] calling  pnpacpi_init+0x0/0x7b @ 1
[    1.228960] pnp: PnP ACPI init
[    1.232055] ACPI: bus type pnp registered
[    1.237220] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:02:0f.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    1.254826] pnp: PnP ACPI: found 14 devices
[    1.259032] ACPI: ACPI bus type pnp unregistered
[    1.263666] initcall pnpacpi_init+0x0/0x7b returned 0 after 33890 usecs
[    1.270284] calling  pnp_system_init+0x0/0xf @ 1
[    1.274936] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    1.280868] system 00:01: [io  0x0220-0x0225] has been reserved
[    1.286796] system 00:01: [io  0x0290-0x0294] has been reserved
[    1.292729] system 00:02: [io  0x4100-0x411f] has been reserved
[    1.298661] system 00:02: [io  0x0228-0x022f] has been reserved
[    1.304587] system 00:02: [io  0x040b] has been reserved
[    1.309909] system 00:02: [io  0x04d6] has been reserved
[    1.315230] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    1.321159] system 00:02: [io  0x0c14] has been reserved
[    1.326481] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    1.332410] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    1.338337] system 00:02: [io  0x0c6f] has been reserved
[    1.343661] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    1.349587] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    1.355514] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    1.361442] system 00:02: [io  0x4000-0x40fe] has been reserved
[    1.367371] system 00:02: [io  0x4210-0x4217] has been reserved
[    1.373298] system 00:02: [io  0x0b00-0x0b1f] could not be reserved
[    1.379573] system 00:02: [io  0x0238-0x023f] has been reserved
[    1.385502] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    1.392738] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    1.399368] system 00:0d: [mem 0x000cd400-0x000cffff] has been reserved
[    1.405993] system 00:0d: [mem 0x000f0000-0x000f7fff] could not be reserved
[    1.412959] system 00:0d: [mem 0x000f8000-0x000fbfff] could not be reserved
[    1.419925] system 00:0d: [mem 0x000fc000-0x000fffff] could not be reserved
[    1.426893] system 00:0d: [mem 0x7dee0000-0x7defffff] could not be reserved
[    1.433862] system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
[    1.440484] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.447450] system 00:0d: [mem 0x00100000-0x7dedffff] could not be reserved
[    1.454419] system 00:0d: [mem 0x7dff0000-0x7ffeffff] could not be reserved
[    1.461388] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.468356] system 00:0d: [mem 0xfee00000-0xfee00fff] could not be reserved
[    1.475323] system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
[    1.482028] initcall pnp_system_init+0x0/0xf returned 0 after 202260 usecs
[    1.488914] calling  chr_dev_init+0x0/0xb0 @ 1
[    1.500397] initcall chr_dev_init+0x0/0xb0 returned 0 after 6860 usecs
[    1.506991] calling  firmware_class_init+0x0/0x14 @ 1
[    1.512152] initcall firmware_class_init+0x0/0x14 returned 0 after 73 usecs
[    1.519168] calling  ieee1394_init+0x0/0x208 @ 1
[    1.524366] initcall ieee1394_init+0x0/0x208 returned 0 after 549 usecs
[    1.530992] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    1.536772] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 23 usecs
[    1.544432] calling  init_acpi_pm_clocksource+0x0/0x1a7 @ 1
[    1.584559] initcall init_acpi_pm_clocksource+0x0/0x1a7 returned 0 after 33735 usecs
[    1.592309] calling  pcibios_assign_resources+0x0/0x81 @ 1
[    1.597859] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.603097] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.609200] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    1.615996] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    1.623747] pci 0000:02:0f.0: BAR 6: assigned [mem 0xfdc00000-0xfdc1ffff pref]
[    1.630978] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    1.636214] pci 0000:00:14.4:   bridge window [io  0xd000-0xdfff]
[    1.642319] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
[    1.649121] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    1.656368] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.656371] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    1.656374] pci_bus 0000:00: resource 6 [mem 0xfa000000-0xfcffffffff]
[    1.656378] pci_bus 0000:00: resource 7 [mem 0x80000000-0xf9ffffff]
[    1.656381] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    1.656384] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdffffff]
[    1.656387] pci_bus 0000:01: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    1.656391] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    1.656394] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    1.656397] pci_bus 0000:02: resource 2 [mem 0xfdc00000-0xfdcfffff pref]
[    1.656400] pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
[    1.656403] pci_bus 0000:02: resource 5 [mem 0x000a0000-0x000bffff]
[    1.656406] pci_bus 0000:02: resource 6 [mem 0xfa000000-0xfcffffffff]
[    1.656409] pci_bus 0000:02: resource 7 [mem 0x80000000-0xf9ffffff]
[    1.656415] initcall pcibios_assign_resources+0x0/0x81 returned 0 after 57237 usecs
[    1.664078] calling  sysctl_core_init+0x0/0x2d @ 1
[    1.668897] initcall sysctl_core_init+0x0/0x2d returned 0 after 16 usecs
[    1.675604] calling  inet_init+0x0/0x1f6 @ 1
[    1.679964] NET: Registered protocol family 2
[    1.684497] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.692105] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.700213] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.711683] TCP: Hash tables configured (established 131072 bind 65536)
[    1.718339] TCP reno registered
[    1.721501] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    1.727507] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    1.734118] initcall inet_init+0x0/0x1f6 returned 0 after 52958 usecs
[    1.740571] calling  af_unix_init+0x0/0x47 @ 1
[    1.745042] NET: Registered protocol family 1
[    1.749416] initcall af_unix_init+0x0/0x47 returned 0 after 4286 usecs
[    1.755954] calling  pci_apply_final_quirks+0x0/0xea @ 1
[    1.826074] pci 0000:01:05.0: Boot video device
[    1.826092] PCI: CLS 4 bytes, default 64
[    1.826097] initcall pci_apply_final_quirks+0x0/0xea returned 0 after 63300 usecs
[    1.833585] calling  default_rootfs+0x0/0x65 @ 1
[    1.838293] initcall default_rootfs+0x0/0x65 returned 0 after 75 usecs
[    1.844832] calling  pci_iommu_init+0x0/0xd @ 1
[    1.849377] initcall pci_iommu_init+0x0/0xd returned 0 after 1 usecs
[    1.855735] calling  i8259A_init_sysfs+0x0/0x2b @ 1
[    1.860790] initcall i8259A_init_sysfs+0x0/0x2b returned 0 after 162 usecs
[    1.867669] calling  sbf_init+0x0/0xdd @ 1
[    1.871778] initcall sbf_init+0x0/0xdd returned 0 after 1 usecs
[    1.877705] calling  i8237A_init_sysfs+0x0/0x1d @ 1
[    1.882730] initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 133 usecs
[    1.889619] calling  add_rtc_cmos+0x0/0x9d @ 1
[    1.894081] initcall add_rtc_cmos+0x0/0x9d returned 0 after 3 usecs
[    1.900360] calling  cache_sysfs_init+0x0/0x2c5 @ 1
[    1.905864] initcall cache_sysfs_init+0x0/0x2c5 returned 0 after 600 usecs
[    1.912753] calling  mcheck_init_device+0x0/0x262 @ 1
[    1.918179] initcall mcheck_init_device+0x0/0x262 returned 0 after 355 usecs
[    1.925242] calling  threshold_init_device+0x0/0x6f @ 1
[    1.930492] initcall threshold_init_device+0x0/0x6f returned 0 after 14 usecs
[    1.937634] calling  thermal_throttle_init_device+0x0/0x5f @ 1
[    1.943478] initcall thermal_throttle_init_device+0x0/0x5f returned 0 after 1 usecs
[    1.951138] calling  msr_init+0x0/0x11c @ 1
[    1.955612] initcall msr_init+0x0/0x11c returned 0 after 270 usecs
[    1.961807] calling  cpuid_init+0x0/0x11c @ 1
[    1.966447] initcall cpuid_init+0x0/0x11c returned 0 after 264 usecs
[    1.972815] calling  ioapic_init_sysfs+0x0/0x84 @ 1
[    1.977842] initcall ioapic_init_sysfs+0x0/0x84 returned 0 after 135 usecs
[    1.984733] calling  add_pcspkr+0x0/0x24 @ 1
[    1.989097] initcall add_pcspkr+0x0/0x24 returned 0 after 84 usecs
[    1.995296] calling  aes_init+0x0/0xf @ 1
[    1.999529] initcall aes_init+0x0/0xf returned 0 after 206 usecs
[    2.005559] calling  init_sched_debug_procfs+0x0/0x27 @ 1
[    2.010975] initcall init_sched_debug_procfs+0x0/0x27 returned 0 after 8 usecs
[    2.018204] calling  proc_schedstat_init+0x0/0x1c @ 1
[    2.023269] initcall proc_schedstat_init+0x0/0x1c returned 0 after 3 usecs
[    2.030155] calling  proc_execdomains_init+0x0/0x1c @ 1
[    2.035394] initcall proc_execdomains_init+0x0/0x1c returned 0 after 3 usecs
[    2.042453] calling  ioresources_init+0x0/0x31 @ 1
[    2.047268] initcall ioresources_init+0x0/0x31 returned 0 after 5 usecs
[    2.053894] calling  uid_cache_init+0x0/0x78 @ 1
[    2.058565] initcall uid_cache_init+0x0/0x78 returned 0 after 40 usecs
[    2.065100] calling  init_posix_timers+0x0/0x14c @ 1
[    2.070092] initcall init_posix_timers+0x0/0x14c returned 0 after 14 usecs
[    2.076975] calling  init_posix_cpu_timers+0x0/0xb8 @ 1
[    2.082211] initcall init_posix_cpu_timers+0x0/0xb8 returned 0 after 1 usecs
[    2.089271] calling  nsproxy_cache_init+0x0/0x27 @ 1
[    2.094271] initcall nsproxy_cache_init+0x0/0x27 returned 0 after 23 usecs
[    2.101154] calling  timekeeping_init_device+0x0/0x1d @ 1
[    2.106719] initcall timekeeping_init_device+0x0/0x1d returned 0 after 153 usecs
[    2.114130] calling  init_clocksource_sysfs+0x0/0x43 @ 1
[    2.119599] initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 135 usecs
[    2.126925] calling  init_timer_list_procfs+0x0/0x27 @ 1
[    2.132262] initcall init_timer_list_procfs+0x0/0x27 returned 0 after 10 usecs
[    2.139494] calling  init_tstats_procfs+0x0/0x27 @ 1
[    2.144475] initcall init_tstats_procfs+0x0/0x27 returned 0 after 3 usecs
[    2.151273] calling  lockdep_proc_init+0x0/0x4f @ 1
[    2.156171] initcall lockdep_proc_init+0x0/0x4f returned 0 after 8 usecs
[    2.162879] calling  futex_init+0x0/0x70 @ 1
[    2.167190] initcall futex_init+0x0/0x70 returned 0 after 28 usecs
[    2.173384] calling  proc_dma_init+0x0/0x1c @ 1
[    2.177929] initcall proc_dma_init+0x0/0x1c returned 0 after 3 usecs
[    2.184295] calling  proc_modules_init+0x0/0x1c @ 1
[    2.189187] initcall proc_modules_init+0x0/0x1c returned 0 after 3 usecs
[    2.195900] calling  kallsyms_init+0x0/0x1f @ 1
[    2.200447] initcall kallsyms_init+0x0/0x1f returned 0 after 3 usecs
[    2.206812] calling  ikconfig_init+0x0/0x3a @ 1
[    2.211355] initcall ikconfig_init+0x0/0x3a returned 0 after 3 usecs
[    2.217721] calling  hung_task_init+0x0/0x42 @ 1
[    2.222397] initcall hung_task_init+0x0/0x42 returned 0 after 44 usecs
[    2.228938] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    2.234001] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 3 usecs
[    2.240885] calling  init_lstats_procfs+0x0/0x1f @ 1
[    2.245872] initcall init_lstats_procfs+0x0/0x1f returned 0 after 10 usecs
[    2.252752] calling  perf_event_sysfs_init+0x0/0x14 @ 1
[    2.257993] initcall perf_event_sysfs_init+0x0/0x14 returned 0 after 6 usecs
[    2.265048] calling  init_per_zone_wmark_min+0x0/0x59 @ 1
[    2.270558] initcall init_per_zone_wmark_min+0x0/0x59 returned 0 after 98 usecs
[    2.277876] calling  kswapd_init+0x0/0x13 @ 1
[    2.282302] initcall kswapd_init+0x0/0x13 returned 0 after 54 usecs
[    2.288585] calling  setup_vmstat+0x0/0xa8 @ 1
[    2.293063] initcall setup_vmstat+0x0/0xa8 returned 0 after 16 usecs
[    2.299424] calling  mm_sysfs_init+0x0/0x22 @ 1
[    2.303970] initcall mm_sysfs_init+0x0/0x22 returned 0 after 4 usecs
[    2.310335] calling  proc_vmalloc_init+0x0/0x1f @ 1
[    2.315227] initcall proc_vmalloc_init+0x0/0x1f returned 0 after 3 usecs
[    2.321940] calling  init_emergency_pool+0x0/0x57 @ 1
[    2.327048] highmem bounce pool size: 64 pages
[    2.331508] initcall init_emergency_pool+0x0/0x57 returned 0 after 4399 usecs
[    2.338649] calling  procswaps_init+0x0/0x1c @ 1
[    2.343283] initcall procswaps_init+0x0/0x1c returned 0 after 3 usecs
[    2.349733] calling  hugetlb_init+0x0/0x2e2 @ 1
[    2.354277] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.360649] initcall hugetlb_init+0x0/0x2e2 returned 0 after 6222 usecs
[    2.367276] calling  slab_proc_init+0x0/0x1f @ 1
[    2.371907] initcall slab_proc_init+0x0/0x1f returned 0 after 3 usecs
[    2.378361] calling  cpucache_init+0x0/0x36 @ 1
[    2.382907] initcall cpucache_init+0x0/0x36 returned 0 after 4 usecs
[    2.389273] calling  fasync_init+0x0/0x24 @ 1
[    2.393657] initcall fasync_init+0x0/0x24 returned 0 after 16 usecs
[    2.399930] calling  proc_filesystems_init+0x0/0x1c @ 1
[    2.405173] initcall proc_filesystems_init+0x0/0x1c returned 0 after 4 usecs
[    2.412230] calling  dnotify_init+0x0/0x6f @ 1
[    2.416736] initcall dnotify_init+0x0/0x6f returned 0 after 50 usecs
[    2.423098] calling  inotify_setup+0x0/0x11 @ 1
[    2.427641] initcall inotify_setup+0x0/0x11 returned 0 after 1 usecs
[    2.434001] calling  inotify_user_setup+0x0/0x65 @ 1
[    2.439015] initcall inotify_user_setup+0x0/0x65 returned 0 after 28 usecs
[    2.445899] calling  aio_setup+0x0/0x8c @ 1
[    2.450218] initcall aio_setup+0x0/0x8c returned 0 after 118 usecs
[    2.456406] calling  proc_locks_init+0x0/0x1c @ 1
[    2.461125] initcall proc_locks_init+0x0/0x1c returned 0 after 4 usecs
[    2.467662] calling  init_mbcache+0x0/0x11 @ 1
[    2.472122] initcall init_mbcache+0x0/0x11 returned 0 after 1 usecs
[    2.478401] calling  dquot_init+0x0/0xf6 @ 1
[    2.482681] VFS: Disk quotas dquot_6.5.2
[    2.486650] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.493188] initcall dquot_init+0x0/0xf6 returned 0 after 10259 usecs
[    2.499635] calling  init_v2_quota_format+0x0/0x1d @ 1
[    2.504809] initcall init_v2_quota_format+0x0/0x1d returned 0 after 23 usecs
[    2.511864] calling  quota_init+0x0/0x20 @ 1
[    2.516153] initcall quota_init+0x0/0x20 returned 0 after 8 usecs
[    2.522260] calling  proc_cmdline_init+0x0/0x1c @ 1
[    2.527156] initcall proc_cmdline_init+0x0/0x1c returned 0 after 4 usecs
[    2.533869] calling  proc_cpuinfo_init+0x0/0x1c @ 1
[    2.538761] initcall proc_cpuinfo_init+0x0/0x1c returned 0 after 3 usecs
[    2.545475] calling  proc_devices_init+0x0/0x1c @ 1
[    2.550367] initcall proc_devices_init+0x0/0x1c returned 0 after 3 usecs
[    2.557079] calling  proc_interrupts_init+0x0/0x1c @ 1
[    2.562230] initcall proc_interrupts_init+0x0/0x1c returned 0 after 3 usecs
[    2.569204] calling  proc_loadavg_init+0x0/0x1c @ 1
[    2.574097] initcall proc_loadavg_init+0x0/0x1c returned 0 after 3 usecs
[    2.580807] calling  proc_meminfo_init+0x0/0x1c @ 1
[    2.585701] initcall proc_meminfo_init+0x0/0x1c returned 0 after 4 usecs
[    2.592412] calling  proc_stat_init+0x0/0x1c @ 1
[    2.597045] initcall proc_stat_init+0x0/0x1c returned 0 after 3 usecs
[    2.603498] calling  proc_uptime_init+0x0/0x1c @ 1
[    2.608303] initcall proc_uptime_init+0x0/0x1c returned 0 after 3 usecs
[    2.614929] calling  proc_version_init+0x0/0x1c @ 1
[    2.619820] initcall proc_version_init+0x0/0x1c returned 0 after 3 usecs
[    2.626534] calling  proc_softirqs_init+0x0/0x1c @ 1
[    2.631513] initcall proc_softirqs_init+0x0/0x1c returned 0 after 3 usecs
[    2.638312] calling  proc_kcore_init+0x0/0xa2 @ 1
[    2.643052] initcall proc_kcore_init+0x0/0xa2 returned 0 after 23 usecs
[    2.649675] calling  proc_kmsg_init+0x0/0x1f @ 1
[    2.654307] initcall proc_kmsg_init+0x0/0x1f returned 0 after 3 usecs
[    2.660759] calling  proc_page_init+0x0/0x37 @ 1
[    2.665396] initcall proc_page_init+0x0/0x37 returned 0 after 6 usecs
[    2.671843] calling  init_devpts_fs+0x0/0x3d @ 1
[    2.676550] initcall init_devpts_fs+0x0/0x3d returned 0 after 75 usecs
[    2.683086] calling  init_ext3_fs+0x0/0x64 @ 1
[    2.687594] initcall init_ext3_fs+0x0/0x64 returned 0 after 53 usecs
[    2.693960] calling  init_ext2_fs+0x0/0x64 @ 1
[    2.698448] initcall init_ext2_fs+0x0/0x64 returned 0 after 29 usecs
[    2.704812] calling  journal_init+0x0/0x85 @ 1
[    2.709322] initcall journal_init+0x0/0x85 returned 0 after 52 usecs
[    2.715689] calling  init_ramfs_fs+0x0/0xf @ 1
[    2.720147] initcall init_ramfs_fs+0x0/0xf returned 0 after 2 usecs
[    2.726428] calling  init_hugetlbfs_fs+0x0/0x82 @ 1
[    2.731428] initcall init_hugetlbfs_fs+0x0/0x82 returned 0 after 108 usecs
[    2.738310] calling  init_nls_utf8+0x0/0x1f @ 1
[    2.742872] initcall init_nls_utf8+0x0/0x1f returned 0 after 19 usecs
[    2.749324] calling  ipc_init+0x0/0x20 @ 1
[    2.753439] msgmni has been set to 1728
[    2.757295] initcall ipc_init+0x0/0x20 returned 0 after 3770 usecs
[    2.763485] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    2.768204] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 2 usecs
[    2.774744] calling  init_mqueue_fs+0x0/0xa3 @ 1
[    2.779490] initcall init_mqueue_fs+0x0/0xa3 returned 0 after 114 usecs
[    2.786117] calling  crypto_wq_init+0x0/0x2f @ 1
[    2.790834] initcall crypto_wq_init+0x0/0x2f returned 0 after 88 usecs
[    2.797374] calling  crypto_algapi_init+0x0/0xc @ 1
[    2.802264] initcall crypto_algapi_init+0x0/0xc returned 0 after 4 usecs
[    2.808977] calling  skcipher_module_init+0x0/0x2c @ 1
[    2.814126] initcall skcipher_module_init+0x0/0x2c returned 0 after 0 usecs
[    2.821091] calling  chainiv_module_init+0x0/0xf @ 1
[    2.826078] initcall chainiv_module_init+0x0/0xf returned 0 after 9 usecs
[    2.832872] calling  eseqiv_module_init+0x0/0xf @ 1
[    2.837761] initcall eseqiv_module_init+0x0/0xf returned 0 after 1 usecs
[    2.844466] calling  hmac_module_init+0x0/0xf @ 1
[    2.849185] initcall hmac_module_init+0x0/0xf returned 0 after 1 usecs
[    2.855717] calling  md5_mod_init+0x0/0xf @ 1
[    2.860182] initcall md5_mod_init+0x0/0xf returned 0 after 93 usecs
[    2.866465] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    2.871691] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 77 usecs
[    2.878756] calling  sha256_generic_mod_init+0x0/0x33 @ 1
[    2.884314] initcall sha256_generic_mod_init+0x0/0x33 returned 0 after 147 usecs
[    2.891723] calling  sha512_generic_mod_init+0x0/0x33 @ 1
[    2.897384] initcall sha512_generic_mod_init+0x0/0x33 returned 0 after 242 usecs
[    2.904789] calling  crypto_ecb_module_init+0x0/0xf @ 1
[    2.910023] initcall crypto_ecb_module_init+0x0/0xf returned 0 after 1 usecs
[    2.917076] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    2.922313] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 1 usecs
[    2.929364] calling  des_generic_mod_init+0x0/0x33 @ 1
[    2.934664] initcall des_generic_mod_init+0x0/0x33 returned 0 after 146 usecs
[    2.941809] calling  aes_init+0x0/0xf @ 1
[    2.945926] initcall aes_init+0x0/0xf returned 0 after 85 usecs
[    2.951860] calling  arc4_init+0x0/0xf @ 1
[    2.956067] initcall arc4_init+0x0/0xf returned 0 after 99 usecs
[    2.962089] calling  deflate_mod_init+0x0/0xf @ 1
[    2.967307] initcall deflate_mod_init+0x0/0xf returned 0 after 484 usecs
[    2.974019] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    2.979601] initcall crypto_authenc_module_init+0x0/0xf returned 0 after 1 usecs
[    2.986999] calling  krng_mod_init+0x0/0xf @ 1
[    2.991506] alg: No test for stdrng (krng)
[    2.995633] initcall krng_mod_init+0x0/0xf returned 0 after 4076 usecs
[    3.002172] calling  proc_genhd_init+0x0/0x31 @ 1
[    3.006906] initcall proc_genhd_init+0x0/0x31 returned 0 after 12 usecs
[    3.013532] calling  noop_init+0x0/0x11 @ 1
[    3.017760] io scheduler noop registered
[    3.021695] initcall noop_init+0x0/0x11 returned 0 after 3875 usecs
[    3.027970] calling  deadline_init+0x0/0x11 @ 1
[    3.032510] io scheduler deadline registered
[    3.036793] initcall deadline_init+0x0/0x11 returned 0 after 4181 usecs
[    3.043415] calling  cfq_init+0x0/0x89 @ 1
[    3.047562] io scheduler cfq registered (default)
[    3.052281] initcall cfq_init+0x0/0x89 returned 0 after 4645 usecs
[    3.058468] calling  percpu_counter_startup+0x0/0x29 @ 1
[    3.063791] initcall percpu_counter_startup+0x0/0x29 returned 0 after 0 usecs
[    3.070930] calling  pci_proc_init+0x0/0x5b @ 1
[    3.075581] initcall pci_proc_init+0x0/0x5b returned 0 after 105 usecs
[    3.082119] calling  pcie_portdrv_init+0x0/0x4b @ 1
[    3.087299] initcall pcie_portdrv_init+0x0/0x4b returned 0 after 280 usecs
[    3.094188] calling  aer_service_init+0x0/0x28 @ 1
[    3.099071] initcall aer_service_init+0x0/0x28 returned 0 after 73 usecs
[    3.105786] calling  ioapic_init+0x0/0x16 @ 1
[    3.110252] initcall ioapic_init+0x0/0x16 returned 0 after 91 usecs
[    3.116530] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    3.121865] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 6 usecs
[    3.129007] calling  irqrouter_init_sysfs+0x0/0x33 @ 1
[    3.134296] initcall irqrouter_init_sysfs+0x0/0x33 returned 0 after 135 usecs
[    3.141449] calling  acpi_ac_init+0x0/0x25 @ 1
[    3.146025] initcall acpi_ac_init+0x0/0x25 returned 0 after 114 usecs
[    3.152478] calling  acpi_button_init+0x0/0x4a @ 1
[    3.157531] input: Power Button as /class/input/input0
[    3.162737] ACPI: Power Button [PWRB]
[    3.166601] input: Power Button as /class/input/input1
[    3.171758] ACPI: Power Button [PWRF]
[    3.175528] initcall acpi_button_init+0x0/0x4a returned 0 after 17820 usecs
[    3.182504] calling  acpi_fan_init+0x0/0x15 @ 1
[    3.187147] initcall acpi_fan_init+0x0/0x15 returned 0 after 93 usecs
[    3.193603] calling  acpi_pci_slot_init+0x0/0x1b @ 1
[    3.199075] initcall acpi_pci_slot_init+0x0/0x1b returned 0 after 478 usecs
[    3.206047] calling  acpi_processor_init+0x0/0x81 @ 1
[    3.211132] ACPI: acpi_idle registered with cpuidle
[    3.211770] initcall acpi_processor_init+0x0/0x81 returned 0 after 645 usecs
[    3.218833] calling  acpi_thermal_init+0x0/0x6f @ 1
[    3.223849] initcall acpi_thermal_init+0x0/0x6f returned 0 after 117 usecs
[    3.230741] calling  rand_initialize+0x0/0x25 @ 1
[    3.235514] initcall rand_initialize+0x0/0x25 returned 0 after 50 usecs
[    3.242135] calling  pty_init+0x0/0x40d @ 1
[    3.299967] initcall pty_init+0x0/0x40d returned 0 after 52375 usecs
[    3.306386] calling  sysrq_init+0x0/0x6d @ 1
[    3.310688] initcall sysrq_init+0x0/0x6d returned 0 after 14 usecs
[    3.316879] calling  n_hdlc_init+0x0/0x81 @ 1
[    3.321245] HDLC line discipline maxframe=4096
[    3.325699] N_HDLC line discipline registered.
[    3.330154] initcall n_hdlc_init+0x0/0x81 returned 0 after 8698 usecs
[    3.336603] calling  rtc_init+0x0/0xf8 @ 1
[    3.340824] Real Time Clock Driver v1.12b
[    3.344877] initcall rtc_init+0x0/0xf8 returned 0 after 4068 usecs
[    3.351067] calling  hpet_init+0x0/0x57 @ 1
[    3.355669] initcall hpet_init+0x0/0x57 returned 0 after 396 usecs
[    3.361870] calling  nvram_init+0x0/0x70 @ 1
[    3.366296] Non-volatile memory driver v1.3
[    3.370495] initcall nvram_init+0x0/0x70 returned 0 after 4236 usecs
[    3.376860] calling  agp_init+0x0/0x21 @ 1
[    3.380966] Linux agpgart interface v0.103
[    3.385076] initcall agp_init+0x0/0x21 returned 0 after 4012 usecs
[    3.391264] calling  agp_amd64_mod_init+0x0/0xa @ 1
[    3.396611] initcall agp_amd64_mod_init+0x0/0xa returned -19 after 448 usecs
[    3.403666] calling  hangcheck_init+0x0/0x99 @ 1
[    3.408295] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    3.417261] Hangcheck: Using getrawmonotonic().
[    3.421812] initcall hangcheck_init+0x0/0x99 returned 0 after 13198 usecs
[    3.428609] calling  serial8250_init+0x0/0x14d @ 1
[    3.433410] Serial: 8250/16550 driver, 2 ports, IRQ sharing enabled
[    3.439958] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.446372] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.452609] initcall serial8250_init+0x0/0x14d returned 0 after 18747 usecs
[    3.459587] calling  serial8250_pnp_init+0x0/0xf @ 1
[    3.465449] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.471629] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.477463] initcall serial8250_pnp_init+0x0/0xf returned 0 after 12588 usecs
[    3.484609] calling  serial8250_pci_init+0x0/0x16 @ 1
[    3.489791] initcall serial8250_pci_init+0x0/0x16 returned 0 after 112 usecs
[    3.496863] calling  topology_sysfs_init+0x0/0x47 @ 1
[    3.501951] initcall topology_sysfs_init+0x0/0x47 returned 0 after 18 usecs
[    3.508924] calling  loop_init+0x0/0x16c @ 1
[    3.515032] loop: module loaded
[    3.518215] initcall loop_init+0x0/0x16c returned 0 after 4891 usecs
[    3.524577] calling  net_olddevs_init+0x0/0x82 @ 1
[    3.529385] initcall net_olddevs_init+0x0/0x82 returned 0 after 5 usecs
[    3.536008] calling  tun_init+0x0/0x79 @ 1
[    3.540117] tun: Universal TUN/TAP device driver, 1.6
[    3.545175] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.551502] initcall tun_init+0x0/0x79 returned 0 after 11117 usecs
[    3.557807] calling  rtl8169_init_module+0x0/0x16 @ 1
[    3.562892] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.568546] r8169 0000:02:0f.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.575466] r8169 0000:02:0f.0: (unregistered net_device): no PCI Express capability
[    3.583581] r8169 0000:02:0f.0: eth0: RTL8169sc/8110sc at 0xf848c000, 00:1f:d0:5b:61:a9, XID 18000000 IRQ 23
[    3.598366] initcall rtl8169_init_module+0x0/0x16 returned 0 after 34666 usecs
[    3.605602] calling  spi_transport_init+0x0/0x65 @ 1
[    3.610746] initcall spi_transport_init+0x0/0x65 returned 0 after 163 usecs
[    3.617722] calling  init_sd+0x0/0x125 @ 1
[    3.622029] initcall init_sd+0x0/0x125 returned 0 after 184 usecs
[    3.628141] calling  init_sg+0x0/0xaf @ 1
[    3.632285] initcall init_sg+0x0/0xaf returned 0 after 113 usecs
[    3.638303] calling  ahci_init+0x0/0x16 @ 1
[    3.642536] ahci 0000:00:12.0: version 3.0
[    3.642562] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.649387] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    3.656576] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    3.664678] ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio ccc 
[    3.672063] scsi0 : ahci
[    3.675033] scsi1 : ahci
[    3.677812] scsi2 : ahci
[    3.680544] scsi3 : ahci
[    3.683534] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    3.690937] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    3.698337] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    3.705897] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    3.713409] calling  1_async_port_probe+0x0/0x9d @ 1023
[    3.713512] initcall ahci_init+0x0/0x16 returned 0 after 69345 usecs
[    3.713516] calling  atiixp_init+0x0/0x16 @ 1
[    3.713567] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.713753] scsi4 : pata_atiixp
[    3.713890] scsi5 : pata_atiixp
[    3.715869] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
[    3.715871] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf908 irq 15
[    3.715961] initcall atiixp_init+0x0/0x16 returned 0 after 2382 usecs
[    3.715964] calling  ohci1394_init+0x0/0x16 @ 1
[    3.716050] initcall ohci1394_init+0x0/0x16 returned 0 after 79 usecs
[    3.716054] calling  ohci_hcd_mod_init+0x0/0x75 @ 1
[    3.716057] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.716060] ohci_hcd: block sizes: ed 64 td 64
[    3.716083] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.716110] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.716512] drivers/usb/core/inode.c: creating file 'devices'
[    3.716591] drivers/usb/core/inode.c: creating file '001'
[    3.716621] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[    3.716640] ohci_hcd 0000:00:13.0: created debug files
[    3.716642] ohci_hcd 0000:00:13.0: supports USB remote wakeup
[    3.716680] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[    3.718304] calling  2_async_port_probe+0x0/0x9d @ 1024
[    3.718494] calling  3_async_port_probe+0x0/0x9d @ 1032
[    3.718552] calling  4_async_port_probe+0x0/0x9d @ 1033
[    3.718588] calling  5_async_port_probe+0x0/0x9d @ 1034
[    3.718802] calling  6_async_port_probe+0x0/0x9d @ 1035
[    3.771334] ohci_hcd 0000:00:13.0: OHCI controller state
[    3.771340] ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
[    3.771346] ohci_hcd 0000:00:13.0: control 0x283 RWC HCFS=operational CBSR=3
[    3.771351] ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
[    3.771355] ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
[    3.771361] ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
[    3.771381] ohci_hcd 0000:00:13.0: hcca frame #0005
[    3.771385] ohci_hcd 0000:00:13.0: roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
[    3.771390] ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
[    3.771396] ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
[    3.771403] ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00010101 CSC PPS CCS
[    3.771408] ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00010301 CSC LSDA PPS CCS
[    3.771561] usb usb1: default language 0x0409
[    3.771577] usb usb1: udev 1, busnum 1, minor = 0
[    3.771579] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    3.771582] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.771585] usb usb1: Product: OHCI Host Controller
[    3.771587] usb usb1: Manufacturer: Linux 2.6.35.4-git+ ohci_hcd
[    3.771589] usb usb1: SerialNumber: 0000:00:13.0
[    3.771976] usb usb1: usb_probe_device
[    3.771979] usb usb1: configuration #1 chosen from 1 choice
[    3.772124] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    3.772323] hub 1-0:1.0: usb_probe_interface
[    3.772326] hub 1-0:1.0: usb_probe_interface - got id
[    3.772328] hub 1-0:1.0: USB hub found
[    3.772378] hub 1-0:1.0: 2 ports detected
[    3.772381] hub 1-0:1.0: standalone hub
[    3.772383] hub 1-0:1.0: no power switching (usb 1.0)
[    3.772385] hub 1-0:1.0: global over-current protection
[    3.772387] hub 1-0:1.0: power on to power good time: 4ms
[    3.772496] hub 1-0:1.0: local power source is good
[    3.772498] hub 1-0:1.0: no over-current condition exists
[    3.772501] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    3.772883] drivers/usb/core/inode.c: creating file '001'
[    3.773008] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.773034] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.773045] drivers/usb/core/inode.c: creating file '002'
[    3.773055] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
[    3.773074] ohci_hcd 0000:00:13.1: created debug files
[    3.773076] ohci_hcd 0000:00:13.1: supports USB remote wakeup
[    3.773115] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[    3.827296] ohci_hcd 0000:00:13.1: OHCI controller state
[    3.827302] ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
[    3.827308] ohci_hcd 0000:00:13.1: control 0x283 RWC HCFS=operational CBSR=3
[    3.827313] ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
[    3.827318] ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
[    3.827323] ohci_hcd 0000:00:13.1: intrenable 0x8000005a MIE RHSC UE RD WDH
[    3.827342] ohci_hcd 0000:00:13.1: hcca frame #0005
[    3.827347] ohci_hcd 0000:00:13.1: roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
[    3.827352] ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
[    3.827356] ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
[    3.827360] ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00010101 CSC PPS CCS
[    3.827366] ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00010301 CSC LSDA PPS CCS
[    3.827390] usb usb2: default language 0x0409
[    3.827405] usb usb2: udev 1, busnum 2, minor = 128
[    3.827407] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.827410] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.827412] usb usb2: Product: OHCI Host Controller
[    3.827414] usb usb2: Manufacturer: Linux 2.6.35.4-git+ ohci_hcd
[    3.827417] usb usb2: SerialNumber: 0000:00:13.1
[    3.827590] usb usb2: usb_probe_device
[    3.827593] usb usb2: configuration #1 chosen from 1 choice
[    3.827606] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.827711] hub 2-0:1.0: usb_probe_interface
[    3.827713] hub 2-0:1.0: usb_probe_interface - got id
[    3.827716] hub 2-0:1.0: USB hub found
[    3.827729] hub 2-0:1.0: 2 ports detected
[    3.827732] hub 2-0:1.0: standalone hub
[    3.827733] hub 2-0:1.0: no power switching (usb 1.0)
[    3.827735] hub 2-0:1.0: global over-current protection
[    3.827738] hub 2-0:1.0: power on to power good time: 4ms
[    3.827752] hub 2-0:1.0: local power source is good
[    3.827754] hub 2-0:1.0: no over-current condition exists
[    3.827756] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    3.827874] drivers/usb/core/inode.c: creating file '001'
[    3.827949] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.827967] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    3.827977] drivers/usb/core/inode.c: creating file '003'
[    3.827986] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[    3.828005] ohci_hcd 0000:00:13.2: created debug files
[    3.828007] ohci_hcd 0000:00:13.2: supports USB remote wakeup
[    3.828046] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[    3.881543] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
[    3.881550] hub 1-0:1.0: port 1: status 0101 change 0001
[    3.881643] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010301 CSC LSDA PPS CCS
[    3.881648] hub 1-0:1.0: port 2: status 0301 change 0001
[    3.881664] async_waiting @ 1035
[    3.885704] ohci_hcd 0000:00:13.2: OHCI controller state
[    3.885708] ohci_hcd 0000:00:13.2: OHCI 1.0, NO legacy support registers
[    3.885712] ohci_hcd 0000:00:13.2: control 0x283 RWC HCFS=operational CBSR=3
[    3.885718] ohci_hcd 0000:00:13.2: cmdstatus 0x00000 SOC=0
[    3.885722] ohci_hcd 0000:00:13.2: intrstatus 0x00000004 SF
[    3.885728] ohci_hcd 0000:00:13.2: intrenable 0x8000005a MIE RHSC UE RD WDH
[    3.885748] ohci_hcd 0000:00:13.2: hcca frame #0005
[    3.885752] ohci_hcd 0000:00:13.2: roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
[    3.885757] ohci_hcd 0000:00:13.2: roothub.b 00000000 PPCM=0000 DR=0000
[    3.885761] ohci_hcd 0000:00:13.2: roothub.status 00008000 DRWE
[    3.885767] ohci_hcd 0000:00:13.2: roothub.portstatus [0] 0x00010101 CSC PPS CCS
[    3.885773] ohci_hcd 0000:00:13.2: roothub.portstatus [1] 0x00010101 CSC PPS CCS
[    3.885794] usb usb3: default language 0x0409
[    3.885809] usb usb3: udev 1, busnum 3, minor = 256
[    3.885811] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.885814] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.885816] usb usb3: Product: OHCI Host Controller
[    3.885818] usb usb3: Manufacturer: Linux 2.6.35.4-git+ ohci_hcd
[    3.885821] usb usb3: SerialNumber: 0000:00:13.2
[    3.886007] usb usb3: usb_probe_device
[    3.886010] usb usb3: configuration #1 chosen from 1 choice
[    3.886023] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    3.886141] hub 3-0:1.0: usb_probe_interface
[    3.886144] hub 3-0:1.0: usb_probe_interface - got id
[    3.886146] hub 3-0:1.0: USB hub found
[    3.886160] hub 3-0:1.0: 2 ports detected
[    3.886162] hub 3-0:1.0: standalone hub
[    3.886164] hub 3-0:1.0: no power switching (usb 1.0)
[    3.886166] hub 3-0:1.0: global over-current protection
[    3.886169] hub 3-0:1.0: power on to power good time: 4ms
[    3.886182] hub 3-0:1.0: local power source is good
[    3.886184] hub 3-0:1.0: no over-current condition exists
[    3.886187] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    3.886328] drivers/usb/core/inode.c: creating file '001'
[    3.886401] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.886423] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    3.886434] drivers/usb/core/inode.c: creating file '004'
[    3.886443] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
[    3.886461] ohci_hcd 0000:00:13.3: created debug files
[    3.886463] ohci_hcd 0000:00:13.3: supports USB remote wakeup
[    3.886472] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[    3.896272] async_waiting @ 1034
[    3.927286] ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
[    3.927292] hub 2-0:1.0: port 1: status 0101 change 0001
[    3.927328] ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [1] = 0x00010301 CSC LSDA PPS CCS
[    3.927333] hub 2-0:1.0: port 2: status 0301 change 0001
[    3.941296] ohci_hcd 0000:00:13.3: OHCI controller state
[    3.941300] ohci_hcd 0000:00:13.3: OHCI 1.0, NO legacy support registers
[    3.941307] ohci_hcd 0000:00:13.3: control 0x283 RWC HCFS=operational CBSR=3
[    3.941312] ohci_hcd 0000:00:13.3: cmdstatus 0x00000 SOC=0
[    3.941316] ohci_hcd 0000:00:13.3: intrstatus 0x00000004 SF
[    3.941322] ohci_hcd 0000:00:13.3: intrenable 0x8000005a MIE RHSC UE RD WDH
[    3.941342] ohci_hcd 0000:00:13.3: hcca frame #0005
[    3.941346] ohci_hcd 0000:00:13.3: roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
[    3.941351] ohci_hcd 0000:00:13.3: roothub.b 00000000 PPCM=0000 DR=0000
[    3.941356] ohci_hcd 0000:00:13.3: roothub.status 00008000 DRWE
[    3.941362] ohci_hcd 0000:00:13.3: roothub.portstatus [0] 0x00010101 CSC PPS CCS
[    3.941367] ohci_hcd 0000:00:13.3: roothub.portstatus [1] 0x00010101 CSC PPS CCS
[    3.941388] usb usb4: default language 0x0409
[    3.941403] usb usb4: udev 1, busnum 4, minor = 384
[    3.941405] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.941408] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.941411] usb usb4: Product: OHCI Host Controller
[    3.941413] usb usb4: Manufacturer: Linux 2.6.35.4-git+ ohci_hcd
[    3.941415] usb usb4: SerialNumber: 0000:00:13.3
[    3.941600] usb usb4: usb_probe_device
[    3.941603] usb usb4: configuration #1 chosen from 1 choice
[    3.941616] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    3.941718] hub 4-0:1.0: usb_probe_interface
[    3.941720] hub 4-0:1.0: usb_probe_interface - got id
[    3.941722] hub 4-0:1.0: USB hub found
[    3.941741] hub 4-0:1.0: 2 ports detected
[    3.941743] hub 4-0:1.0: standalone hub
[    3.941745] hub 4-0:1.0: no power switching (usb 1.0)
[    3.941747] hub 4-0:1.0: global over-current protection
[    3.941749] hub 4-0:1.0: power on to power good time: 4ms
[    3.941763] hub 4-0:1.0: local power source is good
[    3.941765] hub 4-0:1.0: no over-current condition exists
[    3.941768] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    3.941888] drivers/usb/core/inode.c: creating file '001'
[    3.941958] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.941976] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    3.941987] drivers/usb/core/inode.c: creating file '005'
[    3.942008] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 5
[    3.942025] ohci_hcd 0000:00:13.4: created debug files
[    3.942027] ohci_hcd 0000:00:13.4: supports USB remote wakeup
[    3.942036] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[    3.981317] hub 1-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    3.981337] hub 1-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    3.985294] ohci_hcd 0000:00:13.2: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
[    3.985299] hub 3-0:1.0: port 1: status 0101 change 0001
[    3.985334] ohci_hcd 0000:00:13.2: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
[    3.985340] hub 3-0:1.0: port 2: status 0101 change 0001
[    3.996296] ohci_hcd 0000:00:13.4: OHCI controller state
[    3.996300] ohci_hcd 0000:00:13.4: OHCI 1.0, NO legacy support registers
[    3.996306] ohci_hcd 0000:00:13.4: control 0x283 RWC HCFS=operational CBSR=3
[    3.996311] ohci_hcd 0000:00:13.4: cmdstatus 0x00000 SOC=0
[    3.996316] ohci_hcd 0000:00:13.4: intrstatus 0x00000004 SF
[    3.996321] ohci_hcd 0000:00:13.4: intrenable 0x8000005a MIE RHSC UE RD WDH
[    3.996342] ohci_hcd 0000:00:13.4: hcca frame #0005
[    3.996347] ohci_hcd 0000:00:13.4: roothub.a 02000202 POTPGT=2 NPS NDP=2(2)
[    3.996352] ohci_hcd 0000:00:13.4: roothub.b 00000000 PPCM=0000 DR=0000
[    3.996356] ohci_hcd 0000:00:13.4: roothub.status 00008000 DRWE
[    3.996363] ohci_hcd 0000:00:13.4: roothub.portstatus [0] 0x00010101 CSC PPS CCS
[    3.996368] ohci_hcd 0000:00:13.4: roothub.portstatus [1] 0x00010101 CSC PPS CCS
[    3.996389] usb usb5: default language 0x0409
[    3.996404] usb usb5: udev 1, busnum 5, minor = 512
[    3.996407] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.996410] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.996412] usb usb5: Product: OHCI Host Controller
[    3.996414] usb usb5: Manufacturer: Linux 2.6.35.4-git+ ohci_hcd
[    3.996417] usb usb5: SerialNumber: 0000:00:13.4
[    3.996654] usb usb5: usb_probe_device
[    3.996657] usb usb5: configuration #1 chosen from 1 choice
[    3.996670] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    3.996769] hub 5-0:1.0: usb_probe_interface
[    3.996772] hub 5-0:1.0: usb_probe_interface - got id
[    3.996774] hub 5-0:1.0: USB hub found
[    3.996788] hub 5-0:1.0: 2 ports detected
[    3.996790] hub 5-0:1.0: standalone hub
[    3.996792] hub 5-0:1.0: no power switching (usb 1.0)
[    3.996794] hub 5-0:1.0: global over-current protection
[    3.996797] hub 5-0:1.0: power on to power good time: 4ms
[    3.996810] hub 5-0:1.0: local power source is good
[    3.996812] hub 5-0:1.0: no over-current condition exists
[    3.996815] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    3.996934] drivers/usb/core/inode.c: creating file '001'
[    3.997075] initcall ohci_hcd_mod_init+0x0/0x75 returned 0 after 274427 usecs
[    3.997078] calling  usb_stor_init+0x0/0x38 @ 1
[    3.997081] Initializing USB Mass Storage driver...
[    3.997177] usbcore: registered new interface driver usb-storage
[    3.997179] USB Mass Storage support registered.
[    3.997184] initcall usb_stor_init+0x0/0x38 returned 0 after 98 usecs
[    3.997187] calling  i8042_init+0x0/0x334 @ 1
[    3.997587] PNP: No PS/2 controller found. Probing ports directly.
[    3.998361] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.998394] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.998464] initcall i8042_init+0x0/0x334 returned 0 after 1241 usecs
[    3.998467] calling  evdev_init+0x0/0xf @ 1
[    3.998838] initcall evdev_init+0x0/0xf returned 0 after 357 usecs
[    3.998841] calling  atkbd_init+0x0/0x20 @ 1
[    3.998925] initcall atkbd_init+0x0/0x20 returned 0 after 77 usecs
[    3.998928] calling  i2c_dev_init+0x0/0x9c @ 1
[    3.998932] i2c /dev entries driver
[    3.999066] initcall i2c_dev_init+0x0/0x9c returned 0 after 129 usecs
[    3.999070] calling  sm_it87_init+0x0/0x36c @ 1
[    3.999132] it87: Found IT8716F chip at 0x228, revision 3
[    3.999158] it87: in3 is VCC (+5V)
[    3.999160] it87: in7 is VCCH (+5V Stand-By)
[    3.999167] it87: Beeping is supported
[    3.999977] initcall sm_it87_init+0x0/0x36c returned 0 after 880 usecs
[    3.999980] calling  raid_init+0x0/0xf @ 1
[    4.000014] md: raid1 personality registered for level 1
[    4.000020] initcall raid_init+0x0/0xf returned 0 after 34 usecs
[    4.000023] calling  dm_init+0x0/0x38 @ 1
[    4.274390] ata3: SATA link down (SStatus 0 SControl 300)
[    4.274433] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    4.279857] ohci_hcd 0000:00:13.3: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
[    4.279865] hub 4-0:1.0: port 1: status 0101 change 0001
[    4.279896] ohci_hcd 0000:00:13.3: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
[    4.279902] hub 4-0:1.0: port 2: status 0101 change 0001
[    4.279917] ohci_hcd 0000:00:13.4: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
[    4.279923] hub 5-0:1.0: port 1: status 0101 change 0001
[    4.279953] ohci_hcd 0000:00:13.4: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
[    4.279958] hub 5-0:1.0: port 2: status 0101 change 0001
[    4.279990] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    4.288444] initcall dm_init+0x0/0x38 returned 0 after 281653 usecs
[    4.290274] async_waiting @ 1032
[    4.297955] calling  dm_crypt_init+0x0/0x5a @ 1
[    4.302516] initcall dm_crypt_init+0x0/0x5a returned 0 after 19 usecs
[    4.308962] calling  cpufreq_stats_init+0x0/0x84 @ 1
[    4.313968] initcall cpufreq_stats_init+0x0/0x84 returned 0 after 31 usecs
[    4.320853] calling  cpufreq_gov_powersave_init+0x0/0xf @ 1
[    4.326441] initcall cpufreq_gov_powersave_init+0x0/0xf returned 0 after 2 usecs
[    4.326459] usb 1-1: new full speed USB device using ohci_hcd and address 2
[    4.340803] calling  cpufreq_gov_userspace_init+0x0/0xf @ 1
[    4.346386] initcall cpufreq_gov_userspace_init+0x0/0xf returned 0 after 1 usecs
[    4.353785] calling  cpufreq_gov_dbs_init+0x0/0xd1 @ 1
[    4.359380] initcall cpufreq_gov_dbs_init+0x0/0xd1 returned 0 after 433 usecs
[    4.366537] calling  init_ladder+0x0/0xf @ 1
[    4.370849] cpuidle: using governor ladder
[    4.374962] initcall init_ladder+0x0/0xf returned 0 after 4044 usecs
[    4.381327] calling  init_menu+0x0/0xf @ 1
[    4.385439] cpuidle: using governor menu
[    4.389377] initcall init_menu+0x0/0xf returned 0 after 3845 usecs
[    4.389389] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    4.395572] calling  hid_init+0x0/0x51 @ 1
[    4.399849] initcall hid_init+0x0/0x51 returned 0 after 166 usecs
[    4.405980] calling  hid_init+0x0/0xb0 @ 1
[    4.410326] usbcore: registered new interface driver hiddev
[    4.415998] usbcore: registered new interface driver usbhid
[    4.421580] usbhid: USB HID core driver
[    4.425428] initcall hid_init+0x0/0xb0 returned 0 after 14980 usecs
[    4.431706] calling  alsa_timer_init+0x0/0x134 @ 1
[    4.436881] initcall alsa_timer_init+0x0/0x134 returned 0 after 358 usecs
[    4.437277] ata4: softreset failed (device not ready)
[    4.437282] ata4: applying SB600 PMP SRST workaround and retrying
[    4.454835] calling  rtctimer_init+0x0/0xf3 @ 1
[    4.455290] ata2: softreset failed (device not ready)
[    4.455295] ata2: applying SB600 PMP SRST workaround and retrying
[    4.470533] initcall rtctimer_init+0x0/0xf3 returned 0 after 3 usecs
[    4.476900] calling  alsa_pcm_init+0x0/0x4d @ 1
[    4.481476] initcall alsa_pcm_init+0x0/0x4d returned 0 after 32 usecs
[    4.487924] calling  snd_mem_init+0x0/0x24 @ 1
[    4.489363] usb 1-1: default language 0x0409
[    4.491363] usb 1-1: udev 2, busnum 1, minor = 1
[    4.491366] usb 1-1: New USB device found, idVendor=05e3, idProduct=0608
[    4.491369] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    4.491371] usb 1-1: Product: USB2.0 Hub
[    4.491579] usb 1-1: usb_probe_device
[    4.491583] usb 1-1: configuration #1 chosen from 1 choice
[    4.493385] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    4.493485] hub 1-1:1.0: usb_probe_interface
[    4.493488] hub 1-1:1.0: usb_probe_interface - got id
[    4.493490] hub 1-1:1.0: USB hub found
[    4.495366] hub 1-1:1.0: 4 ports detected
[    4.495368] hub 1-1:1.0: standalone hub
[    4.495370] hub 1-1:1.0: ganged power switching
[    4.495372] hub 1-1:1.0: global over-current protection
[    4.495375] hub 1-1:1.0: TT requires at most 32 FS bit times (2664 ns)
[    4.495377] hub 1-1:1.0: Port indicators are supported
[    4.495380] hub 1-1:1.0: power on to power good time: 100ms
[    4.499383] hub 1-1:1.0: local power source is good
[    4.499385] hub 1-1:1.0: no over-current condition exists
[    4.499388] hub 1-1:1.0: enabling power on all ports
[    4.507500] drivers/usb/core/inode.c: creating file '002'
[    4.507546] hub 1-0:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[    4.517905] initcall snd_mem_init+0x0/0x24 returned 0 after 8 usecs
[    4.524185] calling  alsa_mixer_oss_init+0x0/0x2d @ 1
[    4.529249] initcall alsa_mixer_oss_init+0x0/0x2d returned 0 after 0 usecs
[    4.536135] calling  alsa_pcm_oss_init+0x0/0x72 @ 1
[    4.541055] initcall alsa_pcm_oss_init+0x0/0x72 returned 0 after 28 usecs
[    4.547855] calling  patch_realtek_init+0x0/0xf @ 1
[    4.552768] initcall patch_realtek_init+0x0/0xf returned 0 after 23 usecs
[    4.559563] calling  patch_cirrus_init+0x0/0xf @ 1
[    4.564367] initcall patch_cirrus_init+0x0/0xf returned 0 after 1 usecs
[    4.570994] calling  patch_ca0110_init+0x0/0xf @ 1
[    4.571284] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100303 PRSC LSDA PPS PES CCS
[    4.575799] initcall patch_ca0110_init+0x0/0xf returned 0 after 1 usecs
[    4.582425] calling  alsa_card_azx_init+0x0/0x16 @ 1
[    4.587512] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.594811] HDA Intel 0000:00:14.2: irq 40 for MSI/MSI-X
[    4.595361] hub 1-1:1.0: port 4: status 0101 change 0001
[    4.605285] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.609767] initcall alsa_card_azx_init+0x0/0x16 returned 0 after 21837 usecs
[    4.609772] calling  alsa_sound_last_init+0x0/0x50 @ 1
[    4.609775] ALSA device list:
[    4.609777]   #0: HDA ATI SB at 0xfe024000 irq 40
[    4.609782] initcall alsa_sound_last_init+0x0/0x50 returned 0 after 5 usecs
[    4.609786] calling  flow_cache_init_global+0x0/0x13a @ 1
[    4.643779] initcall flow_cache_init_global+0x0/0x13a returned 0 after 33190 usecs
[    4.643808] ata1: SATA link down (SStatus 0 SControl 300)
[    4.643860] usb 1-2: new low speed USB device using ohci_hcd and address 3
[    4.643875] async_waiting @ 1023
[    4.643881] async_continuing @ 1023 after 2 usec
[    4.643887] initcall 1_async_port_probe+0x0/0x9d returned 0 after 360743 usecs
[    4.643985] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.644968] ata2.00: HPA detected: current 976771055, native 976773168
[    4.645069] ata2.00: ATA-8: WDC WD5000AAKS-00V1A0, 05.01D05, max UDMA/133
[    4.645072] ata2.00: 976771055 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.645091] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.646272] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.646275] ata2.00: configured for UDMA/133
[    4.646288] async_waiting @ 1024
[    4.646295] async_continuing @ 1024 after 2 usec
[    4.646891] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 05.0 PQ: 0 ANSI: 5
[    4.647576] calling  7_sd_probe_async+0x0/0x1b6 @ 1023
[    4.647655] sd 1:0:0:0: [sda] 976771055 512-byte logical blocks: (500 GB/465 GiB)
[    4.647748] sd 1:0:0:0: [sda] Write Protect is off
[    4.647751] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.647790] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.651352] ata4.00: ATA-8: WDC WD5000AAKS-00V1A0, 05.01D05, max UDMA/133
[    4.651355] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.651374] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.652508] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.652511] ata4.00: configured for UDMA/133
[    4.794187] calling  llc_init+0x0/0x1b @ 1
[    4.798302] initcall llc_init+0x0/0x1b returned 0 after 2 usecs
[    4.804233] calling  snap_init+0x0/0x31 @ 1
[    4.808459] initcall snap_init+0x0/0x31 returned 0 after 30 usecs
[    4.814564] calling  blackhole_module_init+0x0/0xf @ 1
[    4.819717] initcall blackhole_module_init+0x0/0xf returned 0 after 2 usecs
[    4.826690] calling  sysctl_ipv4_init+0x0/0x71 @ 1
[    4.831506] initcall sysctl_ipv4_init+0x0/0x71 returned 0 after 14 usecs
[    4.838216] calling  ipip_init+0x0/0x50 @ 1
[    4.842412] IPv4 over IPv4 tunneling driver
[    4.846768] async_waiting @ 1033
[    4.847031] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100303 PRSC LSDA PPS PES CCS
[    4.847157]  sda:
[    4.847920] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    4.847941] initcall 2_async_port_probe+0x0/0x9d returned 0 after 1103153 usecs
[    4.847954] async_continuing @ 1032 after 544606 usec
[    4.847958] initcall 3_async_port_probe+0x0/0x9d returned 0 after 1102988 usecs
[    4.848148] initcall ipip_init+0x0/0x50 returned 0 after 5599 usecs
[    4.848152] calling  ipgre_init+0x0/0x8b @ 1
[    4.848155] GRE over IPv4 tunneling driver
[    4.848399] initcall ipgre_init+0x0/0x8b returned 0 after 236 usecs
[    4.848402] calling  init_syncookies+0x0/0x16 @ 1
[    4.848446] initcall init_syncookies+0x0/0x16 returned 0 after 39 usecs
[    4.848449] calling  ah4_init+0x0/0x5a @ 1
[    4.848457] initcall ah4_init+0x0/0x5a returned 0 after 2 usecs
[    4.848460] calling  esp4_init+0x0/0x5a @ 1
[    4.848468] initcall esp4_init+0x0/0x5a returned 0 after 2 usecs
[    4.848471] calling  ipcomp4_init+0x0/0x5a @ 1
[    4.848479] initcall ipcomp4_init+0x0/0x5a returned 0 after 2 usecs
[    4.848482] calling  ipip_init+0x0/0x88 @ 1
[    4.848490] initcall ipip_init+0x0/0x88 returned 0 after 2 usecs
[    4.848493] calling  xfrm4_beet_init+0x0/0x14 @ 1
[    4.848501] initcall xfrm4_beet_init+0x0/0x14 returned 0 after 2 usecs
[    4.848504] calling  tunnel4_init+0x0/0x5a @ 1
[    4.848512] initcall tunnel4_init+0x0/0x5a returned 0 after 2 usecs
[    4.848515] calling  xfrm4_transport_init+0x0/0x14 @ 1
[    4.848523] initcall xfrm4_transport_init+0x0/0x14 returned 0 after 2 usecs
[    4.848526] calling  xfrm4_mode_tunnel_init+0x0/0x14 @ 1
[    4.848534] initcall xfrm4_mode_tunnel_init+0x0/0x14 returned 0 after 2 usecs
[    4.848539] calling  ipv4_netfilter_init+0x0/0xf @ 1
[    4.848574] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 30 usecs
[    4.848577] calling  inet_diag_init+0x0/0x5d @ 1
[    4.848596] initcall inet_diag_init+0x0/0x5d returned 0 after 13 usecs
[    4.848599] calling  tcp_diag_init+0x0/0xf @ 1
[    4.848628] initcall tcp_diag_init+0x0/0xf returned 0 after 23 usecs
[    4.848631] calling  bictcp_register+0x0/0xf @ 1
[    4.848636] TCP bic registered
[    4.848640] initcall bictcp_register+0x0/0xf returned 0 after 3 usecs
[    4.848643] calling  cubictcp_register+0x0/0x7f @ 1
[    4.848647] TCP cubic registered
[    4.848651] initcall cubictcp_register+0x0/0x7f returned 0 after 2 usecs
[    4.848654] calling  tcp_westwood_register+0x0/0xf @ 1
[    4.848658] TCP westwood registered
[    4.848662] initcall tcp_westwood_register+0x0/0xf returned 0 after 2 usecs
[    4.848665] calling  hstcp_register+0x0/0xf @ 1
[    4.848669] TCP highspeed registered
[    4.848673] initcall hstcp_register+0x0/0xf returned 0 after 2 usecs
[    4.848676] calling  hybla_register+0x0/0xf @ 1
[    4.848680] TCP hybla registered
[    4.848684] initcall hybla_register+0x0/0xf returned 0 after 2 usecs
[    4.848687] calling  htcp_register+0x0/0xf @ 1
[    4.848691] TCP htcp registered
[    4.848695] initcall htcp_register+0x0/0xf returned 0 after 3 usecs
[    4.848698] calling  tcp_vegas_register+0x0/0x11 @ 1
[    4.848702] TCP vegas registered
[    4.848708] initcall tcp_vegas_register+0x0/0x11 returned 0 after 4 usecs
[    4.848711] calling  tcp_veno_register+0x0/0x11 @ 1
[    4.848715] TCP veno registered
[    4.848719] initcall tcp_veno_register+0x0/0x11 returned 0 after 2 usecs
[    4.848722] calling  tcp_scalable_register+0x0/0xf @ 1
[    4.848726] TCP scalable registered
[    4.848730] initcall tcp_scalable_register+0x0/0xf returned 0 after 2 usecs
[    4.848733] calling  tcp_lp_register+0x0/0xf @ 1
[    4.848737] TCP lp registered
[    4.848741] initcall tcp_lp_register+0x0/0xf returned 0 after 2 usecs
[    4.848744] calling  tcp_yeah_register+0x0/0x11 @ 1
[    4.848748] TCP yeah registered
[    4.848752] initcall tcp_yeah_register+0x0/0x11 returned 0 after 2 usecs
[    4.848755] calling  tcp_illinois_register+0x0/0xf @ 1
[    4.848759] TCP illinois registered
[    4.848763] initcall tcp_illinois_register+0x0/0xf returned 0 after 2 usecs
[    4.848767] calling  xfrm_user_init+0x0/0x40 @ 1
[    4.848770] Initializing XFRM netlink socket
[    4.848801] initcall xfrm_user_init+0x0/0x40 returned 0 after 28 usecs
[    4.848804] calling  inet6_init+0x0/0x2a2 @ 1
[    5.226733] async_continuing @ 1033 after 1 usec
[    5.226742] NET: Registered protocol family 10
[    5.235982] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 05.0 PQ: 0 ANSI: 5
[    5.236092] lo: Disabled Privacy Extensions
[    5.236434] tunl0: Disabled Privacy Extensions
[    5.236566] initcall inet6_init+0x0/0x2a2 returned 0 after 378667 usecs
[    5.236569] calling  ah6_init+0x0/0x5a @ 1
[    5.236576] initcall ah6_init+0x0/0x5a returned 0 after 2 usecs
[    5.236579] calling  esp6_init+0x0/0x5a @ 1
[    5.236587] initcall esp6_init+0x0/0x5a returned 0 after 2 usecs
[    5.236590] calling  ipcomp6_init+0x0/0x5a @ 1
[    5.236598] initcall ipcomp6_init+0x0/0x5a returned 0 after 2 usecs
[    5.236601] calling  xfrm6_tunnel_init+0x0/0xbc @ 1
[    5.295128] initcall xfrm6_tunnel_init+0x0/0xbc returned 0 after 57149 usecs
[    5.295405] calling  8_sd_probe_async+0x0/0x1b6 @ 1032
[    5.295484] sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    5.295580] sd 3:0:0:0: [sdb] Write Protect is off
[    5.295583] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.295623] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.312478] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    5.312496] initcall 4_async_port_probe+0x0/0x9d returned 0 after 1556579 usecs
[    5.312508] async_continuing @ 1034 after 1383039 usec
[    5.312512] initcall 5_async_port_probe+0x0/0x9d returned 0 after 1556561 usecs
[    5.312520] async_continuing @ 1035 after 1397316 usec
[    5.312524] initcall 6_async_port_probe+0x0/0x9d returned 0 after 1556365 usecs
[    5.366129] calling  tunnel6_init+0x0/0x5a @ 1
[    5.370584] initcall tunnel6_init+0x0/0x5a returned 0 after 1 usecs
[    5.376855] calling  xfrm6_transport_init+0x0/0x14 @ 1
[    5.382012] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 1 usecs
[    5.388979] calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1
[    5.394304] initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after 1 usecs
[    5.401441] calling  xfrm6_ro_init+0x0/0x14 @ 1
[    5.405985] initcall xfrm6_ro_init+0x0/0x14 returned 0 after 1 usecs
[    5.412344] calling  xfrm6_beet_init+0x0/0x14 @ 1
[    5.417063] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 1 usecs
[    5.423594] calling  mip6_init+0x0/0xa7 @ 1
[    5.427789] Mobile IPv6
[    5.430252] initcall mip6_init+0x0/0xa7 returned 0 after 2404 usecs
[    5.436526] calling  sit_init+0x0/0x50 @ 1
[    5.440633] IPv6 over IPv4 tunneling driver
[    5.444965]  sda1 sda2 sda3
[    5.448220] sit0: Disabled Privacy Extensions
[    5.452643] initcall sit_init+0x0/0x50 returned 0 after 11725 usecs
[    5.458920] calling  ip6_tunnel_init+0x0/0x7a @ 1
[    5.463915] ip6tnl0: Disabled Privacy Extensions
[    5.468580] initcall ip6_tunnel_init+0x0/0x7a returned 0 after 4827 usecs
[    5.475380] calling  packet_init+0x0/0x39 @ 1
[    5.479747] NET: Registered protocol family 17
[    5.484213] initcall packet_init+0x0/0x39 returned 0 after 4360 usecs
[    5.490659] calling  ipsec_pfkey_init+0x0/0x6b @ 1
[    5.495464] NET: Registered protocol family 15
[    5.499916] initcall ipsec_pfkey_init+0x0/0x6b returned 0 after 4351 usecs
[    5.506795] calling  br_init+0x0/0xa7 @ 1
[    5.510918] Bridge firewalling registered
[    5.514972] initcall br_init+0x0/0xa7 returned 0 after 4056 usecs
[    5.521070] calling  vlan_proto_init+0x0/0x8d @ 1
[    5.525784] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    5.532579] All bugs added by David S. Miller <davem@redhat.com>
[    5.538632] initcall vlan_proto_init+0x0/0x8d returned 0 after 12545 usecs
[    5.545513] calling  powernowk8_init+0x0/0x141 @ 1
[    5.550315] powernow-k8: Found 1 AMD Athlon(tm) Dual Core Processor 4450e (2 cpu cores) (version 2.20.00)
[    5.560127] powernow-k8:    0 : fid 0xf (2300 MHz), vid 0xe
[    5.565706] powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xf
[    5.571285] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x11
[    5.576954] powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x13
[    5.582620] powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x16
[    5.588668] usb 1-2: skipped 1 descriptor after interface
[    5.588751] initcall powernowk8_init+0x0/0x141 returned 0 after 37536 usecs
[    5.590378] usb 1-2: default language 0x0409
[    5.595728] calling  hpet_insert_resource+0x0/0x1e @ 1
[    5.600880] initcall hpet_insert_resource+0x0/0x1e returned 0 after 3 usecs
[    5.607849] calling  update_mp_table+0x0/0x58d @ 1
[    5.612654] initcall update_mp_table+0x0/0x58d returned 0 after 0 usecs
[    5.617373] usb 1-2: udev 3, busnum 1, minor = 2
[    5.617376] usb 1-2: New USB device found, idVendor=051d, idProduct=0002
[    5.617378] usb 1-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    5.617381] usb 1-2: Product: Back-UPS BR  800 FW:9.o5 .I USB FW:o5 
[    5.617383] usb 1-2: Manufacturer: American Power Conversion
[    5.617386] usb 1-2: SerialNumber: 5B1018T25266  
[    5.649806] calling  lapic_insert_resource+0x0/0x45 @ 1
[    5.655043] initcall lapic_insert_resource+0x0/0x45 returned 0 after 1 usecs
[    5.662094] calling  print_ipi_mode+0x0/0x26 @ 1
[    5.666724] Using IPI Shortcut mode
[    5.670226] initcall print_ipi_mode+0x0/0x26 returned 0 after 3419 usecs
[    5.676933] calling  init_lapic_nmi_sysfs+0x0/0x33 @ 1
[    5.682084] initcall init_lapic_nmi_sysfs+0x0/0x33 returned 0 after 0 usecs
[    5.689050] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[    5.694200] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 1 usecs
[    5.701166] calling  check_early_ioremap_leak+0x0/0x5e @ 1
[    5.706667] initcall check_early_ioremap_leak+0x0/0x5e returned 0 after 0 usecs
[    5.714059] calling  sched_init_debug+0x0/0x7 @ 1
[    5.718779] initcall sched_init_debug+0x0/0x7 returned 0 after 1 usecs
[    5.725311] calling  init_oops_id+0x0/0x3a @ 1
[    5.729772] initcall init_oops_id+0x0/0x3a returned 0 after 5 usecs
[    5.736049] calling  disable_boot_consoles+0x0/0x41 @ 1
[    5.741286] initcall disable_boot_consoles+0x0/0x41 returned 0 after 1 usecs
[    5.748340] calling  pm_qos_power_init+0x0/0xae @ 1
[    5.753377]  sdb:
[    5.755234] usb 1-2: usb_probe_device
[    5.755414] initcall pm_qos_power_init+0x0/0xae returned 0 after 2133 usecs
[    5.755418] calling  max_swapfiles_check+0x0/0x7 @ 1
[    5.755426] initcall max_swapfiles_check+0x0/0x7 returned 0 after 2 usecs
[    5.755430] calling  random32_reseed+0x0/0x83 @ 1
[    5.755450] initcall random32_reseed+0x0/0x83 returned 0 after 15 usecs
[    5.755454] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[    5.755464] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 5 usecs
[    5.755468] calling  pci_sysfs_init+0x0/0x44 @ 1
[    5.755850] initcall pci_sysfs_init+0x0/0x44 returned 0 after 369 usecs
[    5.755853] calling  seqgen_init+0x0/0xe @ 1
[    5.755874] initcall seqgen_init+0x0/0xe returned 0 after 15 usecs
[    5.755879] calling  scsi_complete_async_scans+0x0/0xe6 @ 1
[    5.755886] initcall scsi_complete_async_scans+0x0/0xe6 returned 0 after 2 usecs
[    5.755890] calling  memmap_init+0x0/0x2c @ 1
[    5.755954] initcall memmap_init+0x0/0x2c returned 0 after 58 usecs
[    5.755958] calling  pci_mmcfg_late_insert_resources+0x0/0x59 @ 1
[    5.755966] initcall pci_mmcfg_late_insert_resources+0x0/0x59 returned 0 after 2 usecs
[    5.755969] calling  tcp_congestion_default+0x0/0xf @ 1
[    5.755976] initcall tcp_congestion_default+0x0/0xf returned 0 after 2 usecs
[    5.755980] calling  initialize_hashrnd+0x0/0x16 @ 1
[    5.755990] initcall initialize_hashrnd+0x0/0x16 returned 0 after 4 usecs
[    5.765987]  sdb1 sdb2 sdb3
[    5.885892] usb 1-2: configuration #1 chosen from 1 choice
[    5.886396] sd 1:0:0:0: [sda] Attached SCSI disk
[    5.891133] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[    5.891219] initcall 7_sd_probe_async+0x0/0x1b6 returned 0 after 1214488 usecs
[    5.899061] usbhid 1-2:1.0: usb_probe_interface
[    5.899065] usbhid 1-2:1.0: usb_probe_interface - got id
[    5.899767] sd 3:0:0:0: [sdb] Attached SCSI disk
[    5.904686] initcall 8_sd_probe_async+0x0/0x1b6 returned 0 after 594994 usecs
[    6.213412] drivers/usb/core/file.c: looking for a minor, starting at 96
[    6.214445] generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.10 Device [American Power Conversion Back-UPS BR  800 FW:9.o5 .I USB FW:o5 ] on usb-0000:00:13.0-2/input0
[    6.231708] drivers/usb/core/inode.c: creating file '003'
[    6.231733] async_waiting @ 1
[    6.231754] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    6.231768] hub 2-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    6.231777] hub 2-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.234942] async_continuing @ 1 after 1 usec
[    6.239564] md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
[    6.293032] ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    6.330625] EXT3-fs: barriers not enabled
[    6.344028] usb 2-1: new full speed USB device using ohci_hcd and address 2
[    6.361609] kjournald starting.  Commit interval 5 seconds
[    6.361831] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    6.361919] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    6.361928] async_waiting @ 1
[    6.361933] async_continuing @ 1 after 2 usec
[    6.389058] Freeing unused kernel memory: 376k freed
[    6.394694] Write protecting the kernel text: 3160k
[    6.400051] Write protecting the kernel read-only data: 1344k
[    6.440028] ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    6.519363] usb 2-1: default language 0x0409
[    6.531358] usb 2-1: udev 2, busnum 2, minor = 129
[    6.531362] usb 2-1: New USB device found, idVendor=0572, idProduct=cafe
[    6.539724] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.548227] usb 2-1: Product: ADSL USB MODEM
[    6.552784] usb 2-1: Manufacturer: -
[    6.556562] usb 2-1: SerialNumber: 28217989
[    6.578311] usb 2-1: usb_probe_device
[    6.578318] usb 2-1: configuration #1 chosen from 1 choice
[    6.579369] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    6.579815] drivers/usb/core/inode.c: creating file '002'
[    6.579871] hub 2-0:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[    6.641296] ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [1] = 0x00100303 PRSC LSDA PPS PES CCS
[    6.692286] usb 2-2: new low speed USB device using ohci_hcd and address 3
[    6.764022] ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [1] = 0x00100303 PRSC LSDA PPS PES CCS
[    6.835353] usb 2-2: skipped 1 descriptor after interface
[    6.837350] usb 2-2: default language 0x0409
[    6.843351] usb 2-2: udev 3, busnum 2, minor = 130
[    6.843354] usb 2-2: New USB device found, idVendor=077d, idProduct=1016
[    6.850518] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.858083] usb 2-2: Product: AirClick USB
[    6.862410] usb 2-2: Manufacturer: Griffin Technology, Inc.
[    6.868574] usb 2-2: usb_probe_device
[    6.868578] usb 2-2: configuration #1 chosen from 1 choice
[    6.872352] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    6.874510] usbhid 2-2:1.0: usb_probe_interface
[    6.874513] usbhid 2-2:1.0: usb_probe_interface - got id
[    6.880365] drivers/usb/core/file.c: looking for a minor, starting at 96
[    6.880657] generic-usb 0003:077D:1016.0002: hiddev97,hidraw1: USB HID v1.00 Device [Griffin Technology, Inc. AirClick USB] on usb-0000:00:13.1-2/input0
[    6.895364] drivers/usb/core/inode.c: creating file '003'
[    6.895420] hub 3-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    6.895434] hub 3-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.958022] ohci_hcd 0000:00:13.2: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    7.008038] usb 3-1: new full speed USB device using ohci_hcd and address 2
[    7.077043] ohci_hcd 0000:00:13.2: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    7.141267] usb 3-1: ep0 maxpacket = 8
[    7.147765] usb 3-1: default language 0x0409
[    7.151764] usb 3-1: udev 2, busnum 3, minor = 257
[    7.151767] usb 3-1: New USB device found, idVendor=0a5c, idProduct=4500
[    7.158897] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.166477] usb 3-1: Product: BCM2045B2
[    7.170634] usb 3-1: Manufacturer: Broadcom
[    7.175385] usb 3-1: usb_probe_device
[    7.175390] usb 3-1: configuration #1 chosen from 1 choice
[    7.175771] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    7.175885] hub 3-1:1.0: usb_probe_interface
[    7.175888] hub 3-1:1.0: usb_probe_interface - got id
[    7.175891] hub 3-1:1.0: USB hub found
[    7.180765] hub 3-1:1.0: 3 ports detected
[    7.185140] hub 3-1:1.0: compound device; port removable status: FFF
[    7.185143] hub 3-1:1.0: ganged power switching
[    7.185145] hub 3-1:1.0: global over-current protection
[    7.185148] hub 3-1:1.0: power on to power good time: 100ms
[    7.185765] hub 3-1:1.0: hub controller current requirement: 100mA
[    7.185768] hub 3-1:1.0: 100mA bus power budget for each child
[    7.187764] hub 3-1:1.0: no over-current condition exists
[    7.187767] hub 3-1:1.0: enabling power on all ports
[    7.193904] drivers/usb/core/inode.c: creating file '002'
[    7.193952] hub 3-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    7.235456] md: md0 stopped.
[    7.240505] md: bind<sdb3>
[    7.243697] md: bind<sda3>
[    7.246923] md/raid1:md0: active with 2 out of 2 mirrors
[    7.255279] ohci_hcd 0000:00:13.2: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[    7.293770] hub 3-1:1.0: port 1: status 0101 change 0001
[    7.296997] md0: bitmap initialized from disk: read 8/8 pages, set 206 bits
[    7.304411] created bitmap (117 pages) for device md0
[    7.309989] usb 3-2: new full speed USB device using ohci_hcd and address 3
[    7.324101] md0: detected capacity change from 0 to 498484727808
[    7.332199] md0: detected capacity change from 0 to 498484727808
[    7.339884]  md0: unknown partition table
[    7.381034] ohci_hcd 0000:00:13.2: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[    7.438487] EXT3-fs: barriers not enabled
[    7.446025] usb 3-2: ep0 maxpacket = 8
[    7.446889] kjournald starting.  Commit interval 5 seconds
[    7.447150] EXT3-fs (md0): mounted filesystem with ordered data mode
[    7.462778] usb 3-2: default language 0x0409
[    7.470774] usb 3-2: udev 3, busnum 3, minor = 258
[    7.470777] usb 3-2: New USB device found, idVendor=0403, idProduct=6001
[    7.477868] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.485456] usb 3-2: Product: USB-to-Serial
[    7.489891] usb 3-2: Manufacturer: FTDI
[    7.493993] usb 3-2: SerialNumber: FTB3ODJO
[    7.498747] usb 3-2: usb_probe_device
[    7.498752] usb 3-2: configuration #1 chosen from 1 choice
[    7.499776] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[    7.632101] drivers/usb/core/inode.c: creating file '003'
[    7.632146] hub 4-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    7.632160] hub 4-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    7.694029] ohci_hcd 0000:00:13.3: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    7.745274] usb 4-1: new full speed USB device using ohci_hcd and address 2
[    7.815028] ohci_hcd 0000:00:13.3: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    7.879271] usb 4-1: ep0 maxpacket = 8
[    7.886370] usb 4-1: default language 0x0409
[    7.888371] usb 4-1: udev 2, busnum 4, minor = 385
[    7.888374] usb 4-1: New USB device found, idVendor=4348, idProduct=5523
[    7.895483] usb 4-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    7.903041] usb 4-1: Product: USB-SER!
[    7.907750] usb 4-1: usb_probe_device
[    7.907755] usb 4-1: configuration #1 chosen from 1 choice
[    7.908377] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    7.910049] drivers/usb/core/inode.c: creating file '002'
[    7.910119] hub 4-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    7.971034] ohci_hcd 0000:00:13.3: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[    8.022284] usb 4-2: new full speed USB device using ohci_hcd and address 3
[    8.092038] ohci_hcd 0000:00:13.3: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[    8.163378] usb 4-2: default language 0x0409
[    8.165378] usb 4-2: udev 3, busnum 4, minor = 386
[    8.165382] usb 4-2: New USB device found, idVendor=05e3, idProduct=0608
[    8.172480] usb 4-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    8.180153] usb 4-2: Product: USB2.0 Hub
[    8.184660] usb 4-2: usb_probe_device
[    8.184665] usb 4-2: configuration #1 chosen from 1 choice
[    8.185376] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    8.185566] hub 4-2:1.0: usb_probe_interface
[    8.185570] hub 4-2:1.0: usb_probe_interface - got id
[    8.185572] hub 4-2:1.0: USB hub found
[    8.190380] hub 4-2:1.0: 4 ports detected
[    8.194692] hub 4-2:1.0: standalone hub
[    8.194695] hub 4-2:1.0: individual port power switching
[    8.194698] hub 4-2:1.0: individual port over-current protection
[    8.194701] hub 4-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[    8.194704] hub 4-2:1.0: Port indicators are supported
[    8.194706] hub 4-2:1.0: power on to power good time: 100ms
[    8.197372] hub 4-2:1.0: local power source is good
[    8.197378] hub 4-2:1.0: enabling power on all ports
[    8.205648] drivers/usb/core/inode.c: creating file '003'
[    8.205705] hub 5-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    8.205718] hub 5-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    8.267035] ohci_hcd 0000:00:13.4: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    8.311378] hub 4-2:1.0: port 4: status 0101 change 0001
[    8.318029] usb 5-1: new full speed USB device using ohci_hcd and address 2
[    8.388029] ohci_hcd 0000:00:13.4: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
[    8.458373] usb 5-1: default language 0x0409
[    8.460377] usb 5-1: udev 2, busnum 5, minor = 513
[    8.460380] usb 5-1: New USB device found, idVendor=05e3, idProduct=0608
[    8.467461] usb 5-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    8.475116] usb 5-1: Product: USB2.0 Hub
[    8.479674] usb 5-1: usb_probe_device
[    8.479679] usb 5-1: configuration #1 chosen from 1 choice
[    8.480378] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[    8.480569] hub 5-1:1.0: usb_probe_interface
[    8.480573] hub 5-1:1.0: usb_probe_interface - got id
[    8.480575] hub 5-1:1.0: USB hub found
[    8.485383] hub 5-1:1.0: 4 ports detected
[    8.489669] hub 5-1:1.0: standalone hub
[    8.489671] hub 5-1:1.0: individual port power switching
[    8.489674] hub 5-1:1.0: individual port over-current protection
[    8.489677] hub 5-1:1.0: TT requires at most 32 FS bit times (2664 ns)
[    8.489680] hub 5-1:1.0: Port indicators are supported
[    8.489682] hub 5-1:1.0: power on to power good time: 100ms
[    8.492373] hub 5-1:1.0: local power source is good
[    8.492379] hub 5-1:1.0: enabling power on all ports
[    8.500660] drivers/usb/core/inode.c: creating file '002'
[    8.500722] hub 5-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    8.562039] ohci_hcd 0000:00:13.4: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[    8.606377] hub 5-1:1.0: port 4: status 0101 change 0001
[    8.613036] usb 5-2: new full speed USB device using ohci_hcd and address 3
[    8.675281] ohci_hcd 0000:00:13.4: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[    8.739022] usb 5-2: ep0 maxpacket = 8
[    8.745380] usb 5-2: default language 0x0409
[    8.747382] usb 5-2: udev 3, busnum 5, minor = 514
[    8.747385] usb 5-2: New USB device found, idVendor=4348, idProduct=5523
[    8.747389] usb 5-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    8.747392] usb 5-2: Product: USB-SER!
[    8.747768] usb 5-2: usb_probe_device
[    8.747772] usb 5-2: configuration #1 chosen from 1 choice
[    8.749380] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    8.750640] drivers/usb/core/inode.c: creating file '003'
[    8.750698] hub 1-1:1.0: state 7 ports 4 chg 0010 evt 0000
[    8.751427] hub 1-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    8.817416] usb 1-1.4: new full speed USB device using ohci_hcd and address 4
[    8.905422] usb 1-1.4: default language 0x0409
[    8.909421] usb 1-1.4: udev 4, busnum 1, minor = 3
[    8.909425] usb 1-1.4: New USB device found, idVendor=12d1, idProduct=1003
[    8.909428] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.909431] usb 1-1.4: Product: HUAWEI Mobile
[    8.909434] usb 1-1.4: Manufacturer: HUAWEI Technologies
[    8.909807] usb 1-1.4: usb_probe_device
[    8.909812] usb 1-1.4: configuration #1 chosen from 1 choice
[    8.911424] usb 1-1.4: adding 1-1.4:1.0 (config #1, interface 0)
[    8.913611] usb-storage 1-1.4:1.0: usb_probe_interface
[    8.913616] usb-storage 1-1.4:1.0: usb_probe_interface - got id
[    8.913943] usb 1-1.4: adding 1-1.4:1.1 (config #1, interface 1)
[    8.915576] usb-storage 1-1.4:1.1: usb_probe_interface
[    8.915581] usb-storage 1-1.4:1.1: usb_probe_interface - got id
[    8.916471] usb 1-1.4: adding 1-1.4:1.2 (config #1, interface 2)
[    8.916712] usb-storage 1-1.4:1.2: usb_probe_interface
[    8.916717] usb-storage 1-1.4:1.2: usb_probe_interface - got id
[    8.919511] scsi8 : usb-storage 1-1.4:1.2
[    8.920005] drivers/usb/core/inode.c: creating file '004'
[    8.920049] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    8.920065] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    8.920075] hub 3-1:1.0: state 7 ports 3 chg 0002 evt 0000
[    8.920798] hub 3-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    8.984801] usb 3-1.1: new full speed USB device using ohci_hcd and address 4
[    9.069808] usb 3-1.1: skipped 1 descriptor after interface
[    9.071792] usb 3-1.1: default language 0x0409
[    9.075794] usb 3-1.1: udev 4, busnum 3, minor = 259
[    9.075797] usb 3-1.1: New USB device found, idVendor=0a5c, idProduct=2039
[    9.075800] usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.075803] usb 3-1.1: Product: BCM92045B3 ROM
[    9.075806] usb 3-1.1: Manufacturer: Broadcom Corp
[    9.075998] usb 3-1.1: usb_probe_device
[    9.076002] usb 3-1.1: configuration #1 chosen from 1 choice
[    9.077806] usb 3-1.1: adding 3-1.1:1.0 (config #1, interface 0)
[    9.077934] usb 3-1.1: adding 3-1.1:1.1 (config #1, interface 1)
[    9.078028] usb 3-1.1: adding 3-1.1:1.2 (config #1, interface 2)
[    9.078124] usb 3-1.1: adding 3-1.1:1.3 (config #1, interface 3)
[    9.078215] drivers/usb/core/inode.c: creating file '004'
[    9.078267] hub 3-1:1.0: 300mA power budget left
[    9.078273] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    9.078286] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    9.078297] hub 4-2:1.0: state 7 ports 4 chg 0010 evt 0000
[    9.079383] hub 4-2:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    9.146395] usb 4-2.4: new full speed USB device using ohci_hcd and address 4
[    9.235390] usb 4-2.4: default language 0x0409
[    9.239388] usb 4-2.4: udev 4, busnum 4, minor = 387
[    9.239391] usb 4-2.4: New USB device found, idVendor=12d1, idProduct=1003
[    9.239395] usb 4-2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.239398] usb 4-2.4: Product: HUAWEI Mobile
[    9.239401] usb 4-2.4: Manufacturer: HUAWEI Technologies
[    9.239667] usb 4-2.4: usb_probe_device
[    9.239672] usb 4-2.4: configuration #1 chosen from 1 choice
[    9.241397] usb 4-2.4: adding 4-2.4:1.0 (config #1, interface 0)
[    9.243424] usb-storage 4-2.4:1.0: usb_probe_interface
[    9.243429] usb-storage 4-2.4:1.0: usb_probe_interface - got id
[    9.243641] usb 4-2.4: adding 4-2.4:1.1 (config #1, interface 1)
[    9.245418] usb-storage 4-2.4:1.1: usb_probe_interface
[    9.245423] usb-storage 4-2.4:1.1: usb_probe_interface - got id
[    9.245561] usb 4-2.4: adding 4-2.4:1.2 (config #1, interface 2)
[    9.245628] usb-storage 4-2.4:1.2: usb_probe_interface
[    9.245633] usb-storage 4-2.4:1.2: usb_probe_interface - got id
[    9.247424] scsi11 : usb-storage 4-2.4:1.2
[    9.247659] drivers/usb/core/inode.c: creating file '004'
[    9.247701] hub 5-1:1.0: state 7 ports 4 chg 0010 evt 0000
[    9.248386] hub 5-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    9.316391] usb 5-1.4: new full speed USB device using ohci_hcd and address 4
[    9.399287] usb 5-1.4: ep0 maxpacket = 8
[    9.406514] usb 5-1.4: default language 0x0409
[    9.408574] usb 5-1.4: udev 4, busnum 5, minor = 515
[    9.408579] usb 5-1.4: New USB device found, idVendor=4348, idProduct=5523
[    9.408582] usb 5-1.4: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    9.408585] usb 5-1.4: Product: USB-SER!
[    9.408835] usb 5-1.4: usb_probe_device
[    9.408840] usb 5-1.4: configuration #1 chosen from 1 choice
[    9.410448] usb 5-1.4: adding 5-1.4:1.0 (config #1, interface 0)
[    9.410670] drivers/usb/core/inode.c: creating file '004'
[    9.410727] hub 1-1:1.0: state 7 ports 4 chg 0000 evt 0010
[    9.415269] hub 3-1:1.0: state 7 ports 3 chg 0000 evt 0002
[    9.415802] hub 4-2:1.0: state 7 ports 4 chg 0000 evt 0010
[    9.416387] hub 5-1:1.0: state 7 ports 4 chg 0000 evt 0010
[    9.477401] calling  usb_serial_init+0x0/0x1d0 [usbserial] @ 1297
[    9.478329] usbcore: registered new interface driver usbserial
[    9.478591] USB Serial support registered for generic
[    9.478624] usbserial_generic 2-1:1.0: usb_probe_interface
[    9.478627] usbserial_generic 2-1:1.0: usb_probe_interface - got id
[    9.478660] usbserial_generic 3-2:1.0: usb_probe_interface
[    9.478663] usbserial_generic 3-2:1.0: usb_probe_interface - got id
[    9.478678] usbserial_generic 4-1:1.0: usb_probe_interface
[    9.478681] usbserial_generic 4-1:1.0: usb_probe_interface - got id
[    9.478700] usbserial_generic 5-2:1.0: usb_probe_interface
[    9.478703] usbserial_generic 5-2:1.0: usb_probe_interface - got id
[    9.478718] usbserial_generic 1-1.4:1.0: usb_probe_interface
[    9.478721] usbserial_generic 1-1.4:1.0: usb_probe_interface - got id
[    9.478735] usbserial_generic 1-1.4:1.1: usb_probe_interface
[    9.478738] usbserial_generic 1-1.4:1.1: usb_probe_interface - got id
[    9.478754] usbserial_generic 3-1.1:1.0: usb_probe_interface
[    9.478757] usbserial_generic 3-1.1:1.0: usb_probe_interface - got id
[    9.478771] usbserial_generic 3-1.1:1.1: usb_probe_interface
[    9.478774] usbserial_generic 3-1.1:1.1: usb_probe_interface - got id
[    9.478788] usbserial_generic 3-1.1:1.2: usb_probe_interface
[    9.478790] usbserial_generic 3-1.1:1.2: usb_probe_interface - got id
[    9.478804] usbserial_generic 3-1.1:1.3: usb_probe_interface
[    9.478806] usbserial_generic 3-1.1:1.3: usb_probe_interface - got id
[    9.478821] usbserial_generic 4-2.4:1.0: usb_probe_interface
[    9.478824] usbserial_generic 4-2.4:1.0: usb_probe_interface - got id
[    9.478839] usbserial_generic 4-2.4:1.1: usb_probe_interface
[    9.478841] usbserial_generic 4-2.4:1.1: usb_probe_interface - got id
[    9.478857] usbserial_generic 5-1.4:1.0: usb_probe_interface
[    9.478860] usbserial_generic 5-1.4:1.0: usb_probe_interface - got id
[    9.479286] usbcore: registered new interface driver usbserial_generic
[    9.479289] usbserial: USB Serial Driver core
[    9.479300] initcall usb_serial_init+0x0/0x1d0 [usbserial] returned 0 after 1842 usecs
[    9.503208] calling  option_init+0x0/0x4c [option] @ 1296
[    9.503691] USB Serial support registered for GSM modem (1-port)
[    9.503927] option 1-1.4:1.0: usb_probe_interface
[    9.503931] option 1-1.4:1.0: usb_probe_interface - got id
[    9.503941] option 1-1.4:1.0: GSM modem (1-port) converter detected
[    9.505023] usb 1-1.4: GSM modem (1-port) converter now attached to ttyUSB0
[    9.505044] option 1-1.4:1.1: usb_probe_interface
[    9.505048] option 1-1.4:1.1: usb_probe_interface - got id
[    9.505054] option 1-1.4:1.1: GSM modem (1-port) converter detected
[    9.505266] usb 1-1.4: GSM modem (1-port) converter now attached to ttyUSB1
[    9.505325] option 4-2.4:1.0: usb_probe_interface
[    9.505329] option 4-2.4:1.0: usb_probe_interface - got id
[    9.505339] option 4-2.4:1.0: GSM modem (1-port) converter detected
[    9.505621] usb 4-2.4: GSM modem (1-port) converter now attached to ttyUSB2
[    9.505635] option 4-2.4:1.1: usb_probe_interface
[    9.505639] option 4-2.4:1.1: usb_probe_interface - got id
[    9.505644] option 4-2.4:1.1: GSM modem (1-port) converter detected
[    9.505785] usb 4-2.4: GSM modem (1-port) converter now attached to ttyUSB3
[    9.505827] usbcore: registered new interface driver option
[    9.505829] option: v0.7.2:USB Driver for GSM modems
[    9.505843] initcall option_init+0x0/0x4c [option] returned 0 after 2559 usecs
[    9.507266] calling  ch341_init+0x0/0x3d [ch341] @ 1354
[    9.507304] USB Serial support registered for ch341-uart
[    9.507337] ch341 4-1:1.0: usb_probe_interface
[    9.507340] ch341 4-1:1.0: usb_probe_interface - got id
[    9.507345] ch341 4-1:1.0: ch341-uart converter detected
[    9.533771] usb 4-1: ch341-uart converter now attached to ttyUSB4
[    9.533794] ch341 5-2:1.0: usb_probe_interface
[    9.533797] ch341 5-2:1.0: usb_probe_interface - got id
[    9.533805] ch341 5-2:1.0: ch341-uart converter detected
[    9.556597] usb 5-2: ch341-uart converter now attached to ttyUSB5
[    9.556627] ch341 5-1.4:1.0: usb_probe_interface
[    9.556630] ch341 5-1.4:1.0: usb_probe_interface - got id
[    9.556636] ch341 5-1.4:1.0: ch341-uart converter detected
[    9.580678] usb 5-1.4: ch341-uart converter now attached to ttyUSB6
[    9.580712] usbcore: registered new interface driver ch341
[    9.580722] initcall ch341_init+0x0/0x3d [ch341] returned 0 after 71724 usecs
[    9.610497] udev: renamed network interface eth0 to re0
[    9.925502] scsi 8:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
[    9.925808] scsi 8:0:0:0: Attached scsi generic sg2 type 5
[   10.253450] scsi 11:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
[   10.253762] scsi 11:0:0:0: Attached scsi generic sg3 type 5
[   10.374382] calling  ftdi_init+0x0/0xb6 [ftdi_sio] @ 2534
[   10.374427] USB Serial support registered for FTDI USB Serial Device
[   10.374513] ftdi_sio 3-2:1.0: usb_probe_interface
[   10.374516] ftdi_sio 3-2:1.0: usb_probe_interface - got id
[   10.374524] ftdi_sio 3-2:1.0: FTDI USB Serial Device converter detected
[   10.374583] usb 3-2: Detected FT232BM
[   10.374586] usb 3-2: Number of endpoints 2
[   10.374588] usb 3-2: Endpoint 1 MaxPacketSize 64
[   10.374591] usb 3-2: Endpoint 2 MaxPacketSize 64
[   10.374593] usb 3-2: Setting MaxPacketSize 64
[   10.387298] usb 3-2: FTDI USB Serial Device converter now attached to ttyUSB7
[   10.387430] usbcore: registered new interface driver ftdi_sio
[   10.387433] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[   10.387449] initcall ftdi_init+0x0/0xb6 [ftdi_sio] returned 0 after 12743 usecs
[   10.390333] calling  usbatm_usb_init+0x0/0x40 [usbatm] @ 2528
[   10.390342] initcall usbatm_usb_init+0x0/0x40 [usbatm] returned 0 after 0 usecs
[   10.402959] calling  cxacru_init+0x0/0x19 [cxacru] @ 2528
[   10.402993] cxacru 2-1:1.0: usb_probe_interface
[   10.402996] cxacru 2-1:1.0: usb_probe_interface - got id
[   10.456230] calling  bt_init+0x0/0x50 [bluetooth] @ 2531
[   10.456236] Bluetooth: Core ver 2.15
[   10.456411] NET: Registered protocol family 31
[   10.456414] Bluetooth: HCI device and connection manager initialized
[   10.456516] Bluetooth: HCI socket layer initialized
[   10.456526] initcall bt_init+0x0/0x50 [bluetooth] returned 0 after 276 usecs
[   10.472632] calling  btusb_init+0x0/0x28 [btusb] @ 2536
[   10.472637] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   10.472682] btusb 3-1.1:1.0: usb_probe_interface
[   10.472686] btusb 3-1.1:1.0: usb_probe_interface - got id
[   10.482336] btusb 3-1.1:1.2: usb_probe_interface
[   10.482341] btusb 3-1.1:1.2: usb_probe_interface - got id
[   10.482358] btusb 3-1.1:1.3: usb_probe_interface
[   10.482361] btusb 3-1.1:1.3: usb_probe_interface - got id
[   10.482401] usbcore: registered new interface driver btusb
[   10.482411] initcall btusb_init+0x0/0x28 [btusb] returned 0 after 9540 usecs
[   10.501532] cxacru0: ADSL USB MODEM (usb-0000:00:13.1-1) 00:05:b4:12:05:30
[   10.501775] calling  e1000_init_module+0x0/0x71 [e1000] @ 2603
[   10.501780] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[   10.501783] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   10.501857] e1000 0000:02:07.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   10.535811] ATM dev 0: ADSL state: running
[   10.535816] ATM dev 0: ADSL line: up (8128 kb/s down | 832 kb/s up)
[   10.536070] usbcore: registered new interface driver cxacru
[   10.536081] initcall cxacru_init+0x0/0x19 [cxacru] returned 0 after 129990 usecs
[   10.801390] e1000 0000:02:07.0: eth0: (PCI:33MHz:32-bit) 00:04:23:a8:25:f0
[   10.801581] e1000 0000:02:07.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.801617] e1000 0000:02:07.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[   11.099268] e1000 0000:02:07.1: eth1: (PCI:33MHz:32-bit) 00:04:23:a8:25:f1
[   11.099272] e1000 0000:02:07.1: eth1: Intel(R) PRO/1000 Network Connection
[   11.099313] initcall e1000_init_module+0x0/0x71 [e1000] returned 0 after 583520 usecs
[   11.105180] udev: renamed network interface eth1 to em1
[   11.109430] udev: renamed network interface eth0 to em0
[   11.825034] EXT3-fs (md0): using internal journal
[   12.743479] EXT3-fs: barriers not enabled
[   12.752551] kjournald starting.  Commit interval 5 seconds
[   12.752771] EXT3-fs (sda1): using internal journal
[   12.752782] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   12.756934] EXT3-fs: barriers not enabled
[   12.757096] kjournald starting.  Commit interval 5 seconds
[   12.757308] EXT3-fs (sdb1): using internal journal
[   12.757317] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[   12.823409] Adding 1060284k swap on /dev/sda2.  Priority:-1 extents:1 across:1060284k 
[   12.840170] Adding 1060284k swap on /dev/sdb2.  Priority:-2 extents:1 across:1060284k 
[   14.877252] calling  ifb_init_module+0x0/0x9a [ifb] @ 2842
[   14.878928] initcall ifb_init_module+0x0/0x9a [ifb] returned 0 after 1618 usecs
[   14.902377] calling  teql_init+0x0/0xc3 [sch_teql] @ 2847
[   14.904074] initcall teql_init+0x0/0xc3 [sch_teql] returned 0 after 1650 usecs
[   14.918894] calling  dummy_init_module+0x0/0x95 [dummy] @ 2872
[   14.919184] initcall dummy_init_module+0x0/0x95 [dummy] returned 0 after 275 usecs
[   14.957702] calling  ppp_init+0x0/0xc8 [ppp_generic] @ 2901
[   14.957708] PPP generic driver version 2.4.2
[   14.957939] initcall ppp_init+0x0/0xc8 [ppp_generic] returned 0 after 222 usecs
------=_20100909131633_40936
Content-Type: application/octet-stream; name="config"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="config"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4zNS40CiMgU3VuIEF1ZyAyOSAxNTo1Nzo1MSAyMDEwCiMK
IyBDT05GSUdfNjRCSVQgaXMgbm90IHNldApDT05GSUdfWDg2XzMyPXkKIyBDT05GSUdfWDg2XzY0
IGlzIG5vdCBzZXQKQ09ORklHX1g4Nj15CkNPTkZJR19JTlNUUlVDVElPTl9ERUNPREVSPXkKQ09O
RklHX09VVFBVVF9GT1JNQVQ9ImVsZjMyLWkzODYiCkNPTkZJR19BUkNIX0RFRkNPTkZJRz0iYXJj
aC94ODYvY29uZmlncy9pMzg2X2RlZmNvbmZpZyIKQ09ORklHX0dFTkVSSUNfVElNRT15CkNPTkZJ
R19HRU5FUklDX0NNT1NfVVBEQVRFPXkKQ09ORklHX0NMT0NLU09VUkNFX1dBVENIRE9HPXkKQ09O
RklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFM9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19CUk9B
RENBU1Q9eQpDT05GSUdfTE9DS0RFUF9TVVBQT1JUPXkKQ09ORklHX1NUQUNLVFJBQ0VfU1VQUE9S
VD15CkNPTkZJR19IQVZFX0xBVEVOQ1lUT1BfU1VQUE9SVD15CkNPTkZJR19NTVU9eQpDT05GSUdf
Wk9ORV9ETUE9eQojIENPTkZJR19ORUVEX0RNQV9NQVBfU1RBVEUgaXMgbm90IHNldApDT05GSUdf
TkVFRF9TR19ETUFfTEVOR1RIPXkKQ09ORklHX0dFTkVSSUNfSVNBX0RNQT15CkNPTkZJR19HRU5F
UklDX0lPTUFQPXkKQ09ORklHX0dFTkVSSUNfQlVHPXkKQ09ORklHX0dFTkVSSUNfSFdFSUdIVD15
CkNPTkZJR19BUkNIX01BWV9IQVZFX1BDX0ZEQz15CiMgQ09ORklHX1JXU0VNX0dFTkVSSUNfU1BJ
TkxPQ0sgaXMgbm90IHNldApDT05GSUdfUldTRU1fWENIR0FERF9BTEdPUklUSE09eQpDT05GSUdf
QVJDSF9IQVNfQ1BVX0lETEVfV0FJVD15CkNPTkZJR19HRU5FUklDX0NBTElCUkFURV9ERUxBWT15
CiMgQ09ORklHX0dFTkVSSUNfVElNRV9WU1lTQ0FMTCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0hB
U19DUFVfUkVMQVg9eQpDT05GSUdfQVJDSF9IQVNfREVGQVVMVF9JRExFPXkKQ09ORklHX0FSQ0hf
SEFTX0NBQ0hFX0xJTkVfU0laRT15CkNPTkZJR19IQVZFX1NFVFVQX1BFUl9DUFVfQVJFQT15CkNP
TkZJR19ORUVEX1BFUl9DUFVfRU1CRURfRklSU1RfQ0hVTks9eQpDT05GSUdfTkVFRF9QRVJfQ1BV
X1BBR0VfRklSU1RfQ0hVTks9eQojIENPTkZJR19IQVZFX0NQVU1BU0tfT0ZfQ1BVX01BUCBpcyBu
b3Qgc2V0CkNPTkZJR19BUkNIX0hJQkVSTkFUSU9OX1BPU1NJQkxFPXkKQ09ORklHX0FSQ0hfU1VT
UEVORF9QT1NTSUJMRT15CiMgQ09ORklHX1pPTkVfRE1BMzIgaXMgbm90IHNldApDT05GSUdfQVJD
SF9QT1BVTEFURVNfTk9ERV9NQVA9eQojIENPTkZJR19BVURJVF9BUkNIIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfU1VQUE9SVFNfT1BUSU1JWkVEX0lOTElOSU5HPXkKQ09ORklHX0FSQ0hfU1VQUE9S
VFNfREVCVUdfUEFHRUFMTE9DPXkKQ09ORklHX0hBVkVfRUFSTFlfUkVTPXkKQ09ORklHX0dFTkVS
SUNfSEFSRElSUVM9eQpDT05GSUdfR0VORVJJQ19IQVJESVJRU19OT19fRE9fSVJRPXkKQ09ORklH
X0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX0dFTkVSSUNfUEVORElOR19JUlE9eQpDT05GSUdf
VVNFX0dFTkVSSUNfU01QX0hFTFBFUlM9eQpDT05GSUdfWDg2XzMyX1NNUD15CkNPTkZJR19YODZf
SFQ9eQpDT05GSUdfWDg2X1RSQU1QT0xJTkU9eQpDT05GSUdfWDg2XzMyX0xBWllfR1M9eQpDT05G
SUdfQVJDSF9IV0VJR0hUX0NGTEFHUz0iLWZjYWxsLXNhdmVkLWVjeCAtZmNhbGwtc2F2ZWQtZWR4
IgpDT05GSUdfS1RJTUVfU0NBTEFSPXkKQ09ORklHX0RFRkNPTkZJR19MSVNUPSIvbGliL21vZHVs
ZXMvJFVOQU1FX1JFTEVBU0UvLmNvbmZpZyIKQ09ORklHX0NPTlNUUlVDVE9SUz15CgojCiMgR2Vu
ZXJhbCBzZXR1cAojCkNPTkZJR19FWFBFUklNRU5UQUw9eQpDT05GSUdfTE9DS19LRVJORUw9eQpD
T05GSUdfSU5JVF9FTlZfQVJHX0xJTUlUPTMyCkNPTkZJR19DUk9TU19DT01QSUxFPSIiCkNPTkZJ
R19MT0NBTFZFUlNJT049Ii1naXQiCiMgQ09ORklHX0xPQ0FMVkVSU0lPTl9BVVRPIGlzIG5vdCBz
ZXQKQ09ORklHX0hBVkVfS0VSTkVMX0daSVA9eQpDT05GSUdfSEFWRV9LRVJORUxfQlpJUDI9eQpD
T05GSUdfSEFWRV9LRVJORUxfTFpNQT15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk89eQojIENPTkZJ
R19LRVJORUxfR1pJUCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9CWklQMiBpcyBub3Qgc2V0
CkNPTkZJR19LRVJORUxfTFpNQT15CiMgQ09ORklHX0tFUk5FTF9MWk8gaXMgbm90IHNldApDT05G
SUdfU1dBUD15CkNPTkZJR19TWVNWSVBDPXkKQ09ORklHX1NZU1ZJUENfU1lTQ1RMPXkKQ09ORklH
X1BPU0lYX01RVUVVRT15CkNPTkZJR19QT1NJWF9NUVVFVUVfU1lTQ1RMPXkKIyBDT05GSUdfQlNE
X1BST0NFU1NfQUNDVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RBU0tTVEFUUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0FVRElUIGlzIG5vdCBzZXQKCiMKIyBSQ1UgU3Vic3lzdGVtCiMKQ09ORklHX1RSRUVf
UkNVPXkKIyBDT05GSUdfVFJFRV9QUkVFTVBUX1JDVSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTllf
UkNVIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX1RSQUNFIGlzIG5vdCBzZXQKQ09ORklHX1JDVV9G
QU5PVVQ9MzIKIyBDT05GSUdfUkNVX0ZBTk9VVF9FWEFDVCBpcyBub3Qgc2V0CiMgQ09ORklHX1JD
VV9GQVNUX05PX0haIGlzIG5vdCBzZXQKIyBDT05GSUdfVFJFRV9SQ1VfVFJBQ0UgaXMgbm90IHNl
dApDT05GSUdfSUtDT05GSUc9eQpDT05GSUdfSUtDT05GSUdfUFJPQz15CkNPTkZJR19MT0dfQlVG
X1NISUZUPTE4CkNPTkZJR19IQVZFX1VOU1RBQkxFX1NDSEVEX0NMT0NLPXkKIyBDT05GSUdfQ0dS
T1VQUyBpcyBub3Qgc2V0CkNPTkZJR19TWVNGU19ERVBSRUNBVEVEPXkKQ09ORklHX1NZU0ZTX0RF
UFJFQ0FURURfVjI9eQojIENPTkZJR19SRUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX05BTUVTUEFD
RVMgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0lOSVRSRCBpcyBub3Qgc2V0CkNPTkZJR19D
Q19PUFRJTUlaRV9GT1JfU0laRT15CkNPTkZJR19TWVNDVEw9eQpDT05GSUdfQU5PTl9JTk9ERVM9
eQpDT05GSUdfRU1CRURERUQ9eQpDT05GSUdfVUlEMTY9eQpDT05GSUdfU1lTQ1RMX1NZU0NBTEw9
eQpDT05GSUdfS0FMTFNZTVM9eQpDT05GSUdfS0FMTFNZTVNfQUxMPXkKIyBDT05GSUdfS0FMTFNZ
TVNfRVhUUkFfUEFTUyBpcyBub3Qgc2V0CkNPTkZJR19IT1RQTFVHPXkKQ09ORklHX1BSSU5USz15
CkNPTkZJR19CVUc9eQpDT05GSUdfRUxGX0NPUkU9eQpDT05GSUdfUENTUEtSX1BMQVRGT1JNPXkK
Q09ORklHX0JBU0VfRlVMTD15CkNPTkZJR19GVVRFWD15CkNPTkZJR19FUE9MTD15CkNPTkZJR19T
SUdOQUxGRD15CkNPTkZJR19USU1FUkZEPXkKQ09ORklHX0VWRU5URkQ9eQpDT05GSUdfU0hNRU09
eQpDT05GSUdfQUlPPXkKQ09ORklHX0hBVkVfUEVSRl9FVkVOVFM9eQoKIwojIEtlcm5lbCBQZXJm
b3JtYW5jZSBFdmVudHMgQW5kIENvdW50ZXJzCiMKQ09ORklHX1BFUkZfRVZFTlRTPXkKIyBDT05G
SUdfUEVSRl9DT1VOVEVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1BFUkZfVVNFX1ZNQUxM
T0MgaXMgbm90IHNldApDT05GSUdfVk1fRVZFTlRfQ09VTlRFUlM9eQpDT05GSUdfUENJX1FVSVJL
Uz15CiMgQ09ORklHX0NPTVBBVF9CUksgaXMgbm90IHNldApDT05GSUdfU0xBQj15CiMgQ09ORklH
X1NMVUIgaXMgbm90IHNldAojIENPTkZJR19TTE9CIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPRklM
SU5HIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfT1BST0ZJTEU9eQojIENPTkZJR19LUFJPQkVTIGlz
IG5vdCBzZXQKQ09ORklHX0hBVkVfRUZGSUNJRU5UX1VOQUxJR05FRF9BQ0NFU1M9eQpDT05GSUdf
VVNFUl9SRVRVUk5fTk9USUZJRVI9eQpDT05GSUdfSEFWRV9JT1JFTUFQX1BST1Q9eQpDT05GSUdf
SEFWRV9LUFJPQkVTPXkKQ09ORklHX0hBVkVfS1JFVFBST0JFUz15CkNPTkZJR19IQVZFX09QVFBS
T0JFUz15CkNPTkZJR19IQVZFX0FSQ0hfVFJBQ0VIT09LPXkKQ09ORklHX0hBVkVfRE1BX0FUVFJT
PXkKQ09ORklHX0hBVkVfUkVHU19BTkRfU1RBQ0tfQUNDRVNTX0FQST15CkNPTkZJR19IQVZFX0RN
QV9BUElfREVCVUc9eQpDT05GSUdfSEFWRV9IV19CUkVBS1BPSU5UPXkKQ09ORklHX0hBVkVfTUlY
RURfQlJFQUtQT0lOVFNfUkVHUz15CkNPTkZJR19IQVZFX1VTRVJfUkVUVVJOX05PVElGSUVSPXkK
CiMKIyBHQ09WLWJhc2VkIGtlcm5lbCBwcm9maWxpbmcKIwpDT05GSUdfU0xPV19XT1JLPXkKQ09O
RklHX0hBVkVfR0VORVJJQ19ETUFfQ09IRVJFTlQ9eQpDT05GSUdfU0xBQklORk89eQpDT05GSUdf
UlRfTVVURVhFUz15CkNPTkZJR19CQVNFX1NNQUxMPTAKQ09ORklHX01PRFVMRVM9eQpDT05GSUdf
TU9EVUxFX0ZPUkNFX0xPQUQ9eQpDT05GSUdfTU9EVUxFX1VOTE9BRD15CkNPTkZJR19NT0RVTEVf
Rk9SQ0VfVU5MT0FEPXkKIyBDT05GSUdfTU9EVkVSU0lPTlMgaXMgbm90IHNldAojIENPTkZJR19N
T0RVTEVfU1JDVkVSU0lPTl9BTEwgaXMgbm90IHNldApDT05GSUdfU1RPUF9NQUNISU5FPXkKQ09O
RklHX0JMT0NLPXkKQ09ORklHX0xCREFGPXkKIyBDT05GSUdfQkxLX0RFVl9CU0cgaXMgbm90IHNl
dAojIENPTkZJR19CTEtfREVWX0lOVEVHUklUWSBpcyBub3Qgc2V0CgojCiMgSU8gU2NoZWR1bGVy
cwojCkNPTkZJR19JT1NDSEVEX05PT1A9eQpDT05GSUdfSU9TQ0hFRF9ERUFETElORT15CkNPTkZJ
R19JT1NDSEVEX0NGUT15CiMgQ09ORklHX0RFRkFVTFRfREVBRExJTkUgaXMgbm90IHNldApDT05G
SUdfREVGQVVMVF9DRlE9eQojIENPTkZJR19ERUZBVUxUX05PT1AgaXMgbm90IHNldApDT05GSUdf
REVGQVVMVF9JT1NDSEVEPSJjZnEiCkNPTkZJR19QUkVFTVBUX05PVElGSUVSUz15CiMgQ09ORklH
X0lOTElORV9TUElOX1RSWUxPQ0sgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9UUllM
T0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DSyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lOTElORV9TUElOX0xPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJ
Tl9MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX0xPQ0tfSVJRU0FWRSBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX1VOTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOTElORV9TUElOX1VOTE9DS19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX1VO
TE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9VTkxPQ0tfSVJRUkVTVE9S
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX1RSWUxPQ0sgaXMgbm90IHNldAojIENP
TkZJR19JTkxJTkVfUkVBRF9MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfTE9D
S19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX0xPQ0tfSVJRIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5MSU5FX1JFQURfTE9DS19JUlFTQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5M
SU5FX1JFQURfVU5MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLX0JI
IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLX0lSUSBpcyBub3Qgc2V0CiMg
Q09ORklHX0lOTElORV9SRUFEX1VOTE9DS19JUlFSRVNUT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5MSU5FX1dSSVRFX1RSWUxPQ0sgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9D
SyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9MT0NLX0JIIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5MSU5FX1dSSVRFX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1dS
SVRFX0xPQ0tfSVJRU0FWRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9VTkxPQ0sg
aXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfVU5MT0NLX0JIIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVf
V1JJVEVfVU5MT0NLX0lSUVJFU1RPUkUgaXMgbm90IHNldAojIENPTkZJR19NVVRFWF9TUElOX09O
X09XTkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfRlJFRVpFUiBpcyBub3Qgc2V0CgojCiMgUHJvY2Vz
c29yIHR5cGUgYW5kIGZlYXR1cmVzCiMKQ09ORklHX1RJQ0tfT05FU0hPVD15CkNPTkZJR19OT19I
Wj15CkNPTkZJR19ISUdIX1JFU19USU1FUlM9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19C
VUlMRD15CkNPTkZJR19TTVA9eQojIENPTkZJR19TUEFSU0VfSVJRIGlzIG5vdCBzZXQKQ09ORklH
X1g4Nl9NUFBBUlNFPXkKIyBDT05GSUdfWDg2X0JJR1NNUCBpcyBub3Qgc2V0CkNPTkZJR19YODZf
RVhURU5ERURfUExBVEZPUk09eQojIENPTkZJR19YODZfRUxBTiBpcyBub3Qgc2V0CiMgQ09ORklH
X1g4Nl9NUlNUIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1JEQzMyMVggaXMgbm90IHNldAojIENP
TkZJR19YODZfMzJfTk9OX1NUQU5EQVJEIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9TVVBQT1JUU19N
RU1PUllfRkFJTFVSRT15CkNPTkZJR19TQ0hFRF9PTUlUX0ZSQU1FX1BPSU5URVI9eQojIENPTkZJ
R19QQVJBVklSVF9HVUVTVCBpcyBub3Qgc2V0CkNPTkZJR19OT19CT09UTUVNPXkKIyBDT05GSUdf
TUVNVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX00zODYgaXMgbm90IHNldAojIENPTkZJR19NNDg2
IGlzIG5vdCBzZXQKIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZUU0MgaXMg
bm90IHNldAojIENPTkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKIyBDT05GSUdfTTY4NiBpcyBub3Qg
c2V0CiMgQ09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTUlJSSBp
cyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNTSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVN
NCBpcyBub3Qgc2V0CiMgQ09ORklHX01LNiBpcyBub3Qgc2V0CiMgQ09ORklHX01LNyBpcyBub3Qg
c2V0CkNPTkZJR19NSzg9eQojIENPTkZJR19NQ1JVU09FIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVG
RklDRU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVBDNiBpcyBub3Qgc2V0CiMgQ09ORklH
X01XSU5DSElQM0QgaXMgbm90IHNldAojIENPTkZJR19NR0VPREVHWDEgaXMgbm90IHNldAojIENP
TkZJR19NR0VPREVfTFggaXMgbm90IHNldAojIENPTkZJR19NQ1lSSVhJSUkgaXMgbm90IHNldAoj
IENPTkZJR19NVklBQzNfMiBpcyBub3Qgc2V0CiMgQ09ORklHX01WSUFDNyBpcyBub3Qgc2V0CiMg
Q09ORklHX01QU0MgaXMgbm90IHNldAojIENPTkZJR19NQ09SRTIgaXMgbm90IHNldAojIENPTkZJ
R19NQVRPTSBpcyBub3Qgc2V0CiMgQ09ORklHX0dFTkVSSUNfQ1BVIGlzIG5vdCBzZXQKIyBDT05G
SUdfWDg2X0dFTkVSSUMgaXMgbm90IHNldApDT05GSUdfWDg2X0NQVT15CkNPTkZJR19YODZfSU5U
RVJOT0RFX0NBQ0hFX1NISUZUPTYKQ09ORklHX1g4Nl9DTVBYQ0hHPXkKQ09ORklHX1g4Nl9MMV9D
QUNIRV9TSElGVD02CkNPTkZJR19YODZfWEFERD15CkNPTkZJR19YODZfV1BfV09SS1NfT0s9eQpD
T05GSUdfWDg2X0lOVkxQRz15CkNPTkZJR19YODZfQlNXQVA9eQpDT05GSUdfWDg2X1BPUEFEX09L
PXkKQ09ORklHX1g4Nl9JTlRFTF9VU0VSQ09QWT15CkNPTkZJR19YODZfVVNFX1BQUk9fQ0hFQ0tT
VU09eQpDT05GSUdfWDg2X1RTQz15CkNPTkZJR19YODZfQ01QWENIRzY0PXkKQ09ORklHX1g4Nl9D
TU9WPXkKQ09ORklHX1g4Nl9NSU5JTVVNX0NQVV9GQU1JTFk9NQpDT05GSUdfWDg2X0RFQlVHQ1RM
TVNSPXkKQ09ORklHX1BST0NFU1NPUl9TRUxFQ1Q9eQojIENPTkZJR19DUFVfU1VQX0lOVEVMIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1BVX1NVUF9DWVJJWF8zMiBpcyBub3Qgc2V0CkNPTkZJR19DUFVf
U1VQX0FNRD15CkNPTkZJR19DUFVfU1VQX0NFTlRBVVI9eQojIENPTkZJR19DUFVfU1VQX1RSQU5T
TUVUQV8zMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9TVVBfVU1DXzMyIGlzIG5vdCBzZXQKQ09O
RklHX0hQRVRfVElNRVI9eQpDT05GSUdfSFBFVF9FTVVMQVRFX1JUQz15CkNPTkZJR19ETUk9eQoj
IENPTkZJR19JT01NVV9IRUxQRVIgaXMgbm90IHNldAojIENPTkZJR19JT01NVV9BUEkgaXMgbm90
IHNldApDT05GSUdfTlJfQ1BVUz0yCiMgQ09ORklHX1NDSEVEX1NNVCBpcyBub3Qgc2V0CkNPTkZJ
R19TQ0hFRF9NQz15CiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0CiMgQ09ORklHX1BS
RUVNUFRfVk9MVU5UQVJZIGlzIG5vdCBzZXQKQ09ORklHX1BSRUVNUFQ9eQpDT05GSUdfWDg2X0xP
Q0FMX0FQSUM9eQpDT05GSUdfWDg2X0lPX0FQSUM9eQojIENPTkZJR19YODZfUkVST1VURV9GT1Jf
QlJPS0VOX0JPT1RfSVJRUyBpcyBub3Qgc2V0CkNPTkZJR19YODZfTUNFPXkKQ09ORklHX1g4Nl9N
Q0VfSU5URUw9eQpDT05GSUdfWDg2X01DRV9BTUQ9eQojIENPTkZJR19YODZfQU5DSUVOVF9NQ0Ug
aXMgbm90IHNldApDT05GSUdfWDg2X01DRV9USFJFU0hPTEQ9eQojIENPTkZJR19YODZfTUNFX0lO
SkVDVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfVEhFUk1BTF9WRUNUT1I9eQpDT05GSUdfVk04Nj15
CiMgQ09ORklHX1RPU0hJQkEgaXMgbm90IHNldAojIENPTkZJR19JOEsgaXMgbm90IHNldAojIENP
TkZJR19YODZfUkVCT09URklYVVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlDUk9DT0RFIGlzIG5v
dCBzZXQKQ09ORklHX1g4Nl9NU1I9eQpDT05GSUdfWDg2X0NQVUlEPXkKIyBDT05GSUdfTk9ISUdI
TUVNIGlzIG5vdCBzZXQKIyBDT05GSUdfSElHSE1FTTRHIGlzIG5vdCBzZXQKQ09ORklHX0hJR0hN
RU02NEc9eQpDT05GSUdfVk1TUExJVF8zRz15CiMgQ09ORklHX1ZNU1BMSVRfM0dfT1BUIGlzIG5v
dCBzZXQKIyBDT05GSUdfVk1TUExJVF8yRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZNU1BMSVRfMkdf
T1BUIGlzIG5vdCBzZXQKIyBDT05GSUdfVk1TUExJVF8xRyBpcyBub3Qgc2V0CkNPTkZJR19QQUdF
X09GRlNFVD0weEMwMDAwMDAwCkNPTkZJR19ISUdITUVNPXkKQ09ORklHX1g4Nl9QQUU9eQpDT05G
SUdfQVJDSF9QSFlTX0FERFJfVF82NEJJVD15CkNPTkZJR19BUkNIX0ZMQVRNRU1fRU5BQkxFPXkK
Q09ORklHX0FSQ0hfU1BBUlNFTUVNX0VOQUJMRT15CkNPTkZJR19BUkNIX1NFTEVDVF9NRU1PUllf
TU9ERUw9eQpDT05GSUdfSUxMRUdBTF9QT0lOVEVSX1ZBTFVFPTAKQ09ORklHX1NFTEVDVF9NRU1P
UllfTU9ERUw9eQpDT05GSUdfRkxBVE1FTV9NQU5VQUw9eQojIENPTkZJR19ESVNDT05USUdNRU1f
TUFOVUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BBUlNFTUVNX01BTlVBTCBpcyBub3Qgc2V0CkNP
TkZJR19GTEFUTUVNPXkKQ09ORklHX0ZMQVRfTk9ERV9NRU1fTUFQPXkKQ09ORklHX1NQQVJTRU1F
TV9TVEFUSUM9eQpDT05GSUdfUEFHRUZMQUdTX0VYVEVOREVEPXkKQ09ORklHX1NQTElUX1BUTE9D
S19DUFVTPTk5OTk5OQojIENPTkZJR19DT01QQUNUSU9OIGlzIG5vdCBzZXQKQ09ORklHX1BIWVNf
QUREUl9UXzY0QklUPXkKQ09ORklHX1pPTkVfRE1BX0ZMQUc9MQpDT05GSUdfQk9VTkNFPXkKQ09O
RklHX1ZJUlRfVE9fQlVTPXkKQ09ORklHX01NVV9OT1RJRklFUj15CiMgQ09ORklHX0tTTSBpcyBu
b3Qgc2V0CkNPTkZJR19ERUZBVUxUX01NQVBfTUlOX0FERFI9NDA5NgpDT05GSUdfQVJDSF9TVVBQ
T1JUU19NRU1PUllfRkFJTFVSRT15CiMgQ09ORklHX01FTU9SWV9GQUlMVVJFIGlzIG5vdCBzZXQK
Q09ORklHX0hJR0hQVEU9eQojIENPTkZJR19YODZfQ0hFQ0tfQklPU19DT1JSVVBUSU9OIGlzIG5v
dCBzZXQKQ09ORklHX1g4Nl9SRVNFUlZFX0xPV182NEs9eQojIENPTkZJR19NQVRIX0VNVUxBVElP
TiBpcyBub3Qgc2V0CkNPTkZJR19NVFJSPXkKQ09ORklHX01UUlJfU0FOSVRJWkVSPXkKQ09ORklH
X01UUlJfU0FOSVRJWkVSX0VOQUJMRV9ERUZBVUxUPTAKQ09ORklHX01UUlJfU0FOSVRJWkVSX1NQ
QVJFX1JFR19OUl9ERUZBVUxUPTEKQ09ORklHX1g4Nl9QQVQ9eQpDT05GSUdfQVJDSF9VU0VTX1BH
X1VOQ0FDSEVEPXkKIyBDT05GSUdfRUZJIGlzIG5vdCBzZXQKQ09ORklHX1NFQ0NPTVA9eQojIENP
TkZJR19DQ19TVEFDS1BST1RFQ1RPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzEwMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0haXzI1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzMwMCBpcyBub3Qgc2V0
CkNPTkZJR19IWl8xMDAwPXkKQ09ORklHX0haPTEwMDAKQ09ORklHX1NDSEVEX0hSVElDSz15CiMg
Q09ORklHX0tFWEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JBU0hfRFVNUCBpcyBub3Qgc2V0CkNP
TkZJR19QSFlTSUNBTF9TVEFSVD0weDIwMDAwMAojIENPTkZJR19SRUxPQ0FUQUJMRSBpcyBub3Qg
c2V0CkNPTkZJR19QSFlTSUNBTF9BTElHTj0weDIwMDAwMAojIENPTkZJR19IT1RQTFVHX0NQVSBp
cyBub3Qgc2V0CiMgQ09ORklHX0NPTVBBVF9WRFNPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ01ETElO
RV9CT09MIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfRU5BQkxFX01FTU9SWV9IT1RQTFVHPXkKCiMK
IyBQb3dlciBtYW5hZ2VtZW50IGFuZCBBQ1BJIG9wdGlvbnMKIwpDT05GSUdfUE09eQojIENPTkZJ
R19QTV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJ
R19ISUJFUk5BVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1BNX1JVTlRJTUUgaXMgbm90IHNldApD
T05GSUdfQUNQST15CiMgQ09ORklHX0FDUElfUFJPQ0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQ
SV9QUk9DRlNfUE9XRVIgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX1BPV0VSX01FVEVSIGlzIG5v
dCBzZXQKQ09ORklHX0FDUElfU1lTRlNfUE9XRVI9eQojIENPTkZJR19BQ1BJX1BST0NfRVZFTlQg
aXMgbm90IHNldApDT05GSUdfQUNQSV9BQz15CiMgQ09ORklHX0FDUElfQkFUVEVSWSBpcyBub3Qg
c2V0CkNPTkZJR19BQ1BJX0JVVFRPTj15CkNPTkZJR19BQ1BJX0ZBTj15CkNPTkZJR19BQ1BJX0RP
Q0s9eQpDT05GSUdfQUNQSV9QUk9DRVNTT1I9eQojIENPTkZJR19BQ1BJX1BST0NFU1NPUl9BR0dS
RUdBVE9SIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfVEhFUk1BTD15CiMgQ09ORklHX0FDUElfQ1VT
VE9NX0RTRFQgaXMgbm90IHNldApDT05GSUdfQUNQSV9CTEFDS0xJU1RfWUVBUj0wCkNPTkZJR19B
Q1BJX0RFQlVHPXkKIyBDT05GSUdfQUNQSV9ERUJVR19GVU5DX1RSQUNFIGlzIG5vdCBzZXQKQ09O
RklHX0FDUElfUENJX1NMT1Q9eQpDT05GSUdfWDg2X1BNX1RJTUVSPXkKIyBDT05GSUdfQUNQSV9D
T05UQUlORVIgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX1NCUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FDUElfSEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9BUEVJIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0ZJIGlzIG5vdCBzZXQKCiMKIyBDUFUgRnJlcXVlbmN5IHNjYWxpbmcKIwpDT05GSUdfQ1BV
X0ZSRVE9eQpDT05GSUdfQ1BVX0ZSRVFfVEFCTEU9eQpDT05GSUdfQ1BVX0ZSRVFfREVCVUc9eQpD
T05GSUdfQ1BVX0ZSRVFfU1RBVD15CkNPTkZJR19DUFVfRlJFUV9TVEFUX0RFVEFJTFM9eQpDT05G
SUdfQ1BVX0ZSRVFfREVGQVVMVF9HT1ZfUEVSRk9STUFOQ0U9eQojIENPTkZJR19DUFVfRlJFUV9E
RUZBVUxUX0dPVl9QT1dFUlNBVkUgaXMgbm90IHNldAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxU
X0dPVl9VU0VSU1BBQ0UgaXMgbm90IHNldAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9P
TkRFTUFORCBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX0NPTlNFUlZB
VElWRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9HT1ZfUEVSRk9STUFOQ0U9eQpDT05GSUdf
Q1BVX0ZSRVFfR09WX1BPV0VSU0FWRT15CkNPTkZJR19DUFVfRlJFUV9HT1ZfVVNFUlNQQUNFPXkK
Q09ORklHX0NQVV9GUkVRX0dPVl9PTkRFTUFORD15CiMgQ09ORklHX0NQVV9GUkVRX0dPVl9DT05T
RVJWQVRJVkUgaXMgbm90IHNldAoKIwojIENQVUZyZXEgcHJvY2Vzc29yIGRyaXZlcnMKIwojIENP
TkZJR19YODZfUENDX0NQVUZSRVEgaXMgbm90IHNldAojIENPTkZJR19YODZfQUNQSV9DUFVGUkVR
IGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1BPV0VSTk9XX0s2IGlzIG5vdCBzZXQKIyBDT05GSUdf
WDg2X1BPV0VSTk9XX0s3IGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9QT1dFUk5PV19LOD15CiMgQ09O
RklHX1g4Nl9HWF9TVVNQTU9EIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1NQRUVEU1RFUF9DRU5U
UklOTyBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9TUEVFRFNURVBfSUNIIGlzIG5vdCBzZXQKIyBD
T05GSUdfWDg2X1NQRUVEU1RFUF9TTUkgaXMgbm90IHNldAojIENPTkZJR19YODZfUDRfQ0xPQ0tN
T0QgaXMgbm90IHNldAojIENPTkZJR19YODZfQ1BVRlJFUV9ORk9SQ0UyIGlzIG5vdCBzZXQKIyBD
T05GSUdfWDg2X0xPTkdSVU4gaXMgbm90IHNldAojIENPTkZJR19YODZfTE9OR0hBVUwgaXMgbm90
IHNldAojIENPTkZJR19YODZfRV9QT1dFUlNBVkVSIGlzIG5vdCBzZXQKCiMKIyBzaGFyZWQgb3B0
aW9ucwojCiMgQ09ORklHX1g4Nl9TUEVFRFNURVBfTElCIGlzIG5vdCBzZXQKQ09ORklHX0NQVV9J
RExFPXkKQ09ORklHX0NQVV9JRExFX0dPVl9MQURERVI9eQpDT05GSUdfQ1BVX0lETEVfR09WX01F
TlU9eQoKIwojIEJ1cyBvcHRpb25zIChQQ0kgZXRjLikKIwpDT05GSUdfUENJPXkKIyBDT05GSUdf
UENJX0dPQklPUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSV9HT01NQ09ORklHIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENJX0dPRElSRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX0dPT0xQQyBpcyBu
b3Qgc2V0CkNPTkZJR19QQ0lfR09BTlk9eQpDT05GSUdfUENJX0JJT1M9eQpDT05GSUdfUENJX0RJ
UkVDVD15CkNPTkZJR19QQ0lfTU1DT05GSUc9eQpDT05GSUdfUENJX0RPTUFJTlM9eQojIENPTkZJ
R19QQ0lfQ05CMjBMRV9RVUlSSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNQVIgaXMgbm90IHNldApD
T05GSUdfUENJRVBPUlRCVVM9eQpDT05GSUdfUENJRUFFUj15CiMgQ09ORklHX1BDSUVfRUNSQyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BDSUVBRVJfSU5KRUNUIGlzIG5vdCBzZXQKQ09ORklHX1BDSUVB
U1BNPXkKIyBDT05GSUdfUENJRUFTUE1fREVCVUcgaXMgbm90IHNldApDT05GSUdfQVJDSF9TVVBQ
T1JUU19NU0k9eQpDT05GSUdfUENJX01TST15CiMgQ09ORklHX1BDSV9ERUJVRyBpcyBub3Qgc2V0
CiMgQ09ORklHX1BDSV9TVFVCIGlzIG5vdCBzZXQKQ09ORklHX0hUX0lSUT15CiMgQ09ORklHX1BD
SV9JT1YgaXMgbm90IHNldApDT05GSUdfUENJX0lPQVBJQz15CkNPTkZJR19JU0FfRE1BX0FQST15
CiMgQ09ORklHX0lTQSBpcyBub3Qgc2V0CiMgQ09ORklHX01DQSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDeDIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX09MUEMgaXMgbm90IHNldApDT05GSUdfSzhfTkI9
eQojIENPTkZJR19QQ0NBUkQgaXMgbm90IHNldAojIENPTkZJR19IT1RQTFVHX1BDSSBpcyBub3Qg
c2V0CgojCiMgRXhlY3V0YWJsZSBmaWxlIGZvcm1hdHMgLyBFbXVsYXRpb25zCiMKQ09ORklHX0JJ
TkZNVF9FTEY9eQojIENPTkZJR19DT1JFX0RVTVBfREVGQVVMVF9FTEZfSEVBREVSUyBpcyBub3Qg
c2V0CkNPTkZJR19IQVZFX0FPVVQ9eQojIENPTkZJR19CSU5GTVRfQU9VVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0JJTkZNVF9NSVNDIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVRPTUlDX0lPTUFQPXkK
Q09ORklHX05FVD15CgojCiMgTmV0d29ya2luZyBvcHRpb25zCiMKQ09ORklHX1BBQ0tFVD15CkNP
TkZJR19VTklYPXkKQ09ORklHX1hGUk09eQpDT05GSUdfWEZSTV9VU0VSPXkKIyBDT05GSUdfWEZS
TV9TVUJfUE9MSUNZIGlzIG5vdCBzZXQKIyBDT05GSUdfWEZSTV9NSUdSQVRFIGlzIG5vdCBzZXQK
IyBDT05GSUdfWEZSTV9TVEFUSVNUSUNTIGlzIG5vdCBzZXQKQ09ORklHX1hGUk1fSVBDT01QPXkK
Q09ORklHX05FVF9LRVk9eQojIENPTkZJR19ORVRfS0VZX01JR1JBVEUgaXMgbm90IHNldApDT05G
SUdfSU5FVD15CkNPTkZJR19JUF9NVUxUSUNBU1Q9eQpDT05GSUdfSVBfQURWQU5DRURfUk9VVEVS
PXkKQ09ORklHX0FTS19JUF9GSUJfSEFTSD15CiMgQ09ORklHX0lQX0ZJQl9UUklFIGlzIG5vdCBz
ZXQKQ09ORklHX0lQX0ZJQl9IQVNIPXkKQ09ORklHX0lQX01VTFRJUExFX1RBQkxFUz15CiMgQ09O
RklHX0lQX1JPVVRFX01VTFRJUEFUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX1JPVVRFX1ZFUkJP
U0UgaXMgbm90IHNldAojIENPTkZJR19JUF9QTlAgaXMgbm90IHNldApDT05GSUdfTkVUX0lQSVA9
eQpDT05GSUdfTkVUX0lQR1JFPXkKQ09ORklHX05FVF9JUEdSRV9CUk9BRENBU1Q9eQpDT05GSUdf
SVBfTVJPVVRFPXkKQ09ORklHX0lQX01ST1VURV9NVUxUSVBMRV9UQUJMRVM9eQpDT05GSUdfSVBf
UElNU01fVjE9eQpDT05GSUdfSVBfUElNU01fVjI9eQojIENPTkZJR19BUlBEIGlzIG5vdCBzZXQK
Q09ORklHX1NZTl9DT09LSUVTPXkKQ09ORklHX0lORVRfQUg9eQpDT05GSUdfSU5FVF9FU1A9eQpD
T05GSUdfSU5FVF9JUENPTVA9eQpDT05GSUdfSU5FVF9YRlJNX1RVTk5FTD15CkNPTkZJR19JTkVU
X1RVTk5FTD15CkNPTkZJR19JTkVUX1hGUk1fTU9ERV9UUkFOU1BPUlQ9eQpDT05GSUdfSU5FVF9Y
RlJNX01PREVfVFVOTkVMPXkKQ09ORklHX0lORVRfWEZSTV9NT0RFX0JFRVQ9eQpDT05GSUdfSU5F
VF9MUk89eQpDT05GSUdfSU5FVF9ESUFHPXkKQ09ORklHX0lORVRfVENQX0RJQUc9eQpDT05GSUdf
VENQX0NPTkdfQURWQU5DRUQ9eQpDT05GSUdfVENQX0NPTkdfQklDPXkKQ09ORklHX1RDUF9DT05H
X0NVQklDPXkKQ09ORklHX1RDUF9DT05HX1dFU1RXT09EPXkKQ09ORklHX1RDUF9DT05HX0hUQ1A9
eQpDT05GSUdfVENQX0NPTkdfSFNUQ1A9eQpDT05GSUdfVENQX0NPTkdfSFlCTEE9eQpDT05GSUdf
VENQX0NPTkdfVkVHQVM9eQpDT05GSUdfVENQX0NPTkdfU0NBTEFCTEU9eQpDT05GSUdfVENQX0NP
TkdfTFA9eQpDT05GSUdfVENQX0NPTkdfVkVOTz15CkNPTkZJR19UQ1BfQ09OR19ZRUFIPXkKQ09O
RklHX1RDUF9DT05HX0lMTElOT0lTPXkKIyBDT05GSUdfREVGQVVMVF9CSUMgaXMgbm90IHNldApD
T05GSUdfREVGQVVMVF9DVUJJQz15CiMgQ09ORklHX0RFRkFVTFRfSFRDUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFRkFVTFRfSFlCTEEgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX1ZFR0FTIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9WRU5PIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVM
VF9XRVNUV09PRCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfUkVOTyBpcyBub3Qgc2V0CkNP
TkZJR19ERUZBVUxUX1RDUF9DT05HPSJjdWJpYyIKQ09ORklHX1RDUF9NRDVTSUc9eQpDT05GSUdf
SVBWNj15CkNPTkZJR19JUFY2X1BSSVZBQ1k9eQpDT05GSUdfSVBWNl9ST1VURVJfUFJFRj15CkNP
TkZJR19JUFY2X1JPVVRFX0lORk89eQojIENPTkZJR19JUFY2X09QVElNSVNUSUNfREFEIGlzIG5v
dCBzZXQKQ09ORklHX0lORVQ2X0FIPXkKQ09ORklHX0lORVQ2X0VTUD15CkNPTkZJR19JTkVUNl9J
UENPTVA9eQpDT05GSUdfSVBWNl9NSVA2PXkKQ09ORklHX0lORVQ2X1hGUk1fVFVOTkVMPXkKQ09O
RklHX0lORVQ2X1RVTk5FTD15CkNPTkZJR19JTkVUNl9YRlJNX01PREVfVFJBTlNQT1JUPXkKQ09O
RklHX0lORVQ2X1hGUk1fTU9ERV9UVU5ORUw9eQpDT05GSUdfSU5FVDZfWEZSTV9NT0RFX0JFRVQ9
eQpDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1JPVVRFT1BUSU1JWkFUSU9OPXkKQ09ORklHX0lQVjZf
U0lUPXkKIyBDT05GSUdfSVBWNl9TSVRfNlJEIGlzIG5vdCBzZXQKQ09ORklHX0lQVjZfTkRJU0Nf
Tk9ERVRZUEU9eQpDT05GSUdfSVBWNl9UVU5ORUw9eQpDT05GSUdfSVBWNl9NVUxUSVBMRV9UQUJM
RVM9eQpDT05GSUdfSVBWNl9TVUJUUkVFUz15CkNPTkZJR19JUFY2X01ST1VURT15CkNPTkZJR19J
UFY2X01ST1VURV9NVUxUSVBMRV9UQUJMRVM9eQpDT05GSUdfSVBWNl9QSU1TTV9WMj15CiMgQ09O
RklHX05FVExBQkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUV09SS19TRUNNQVJLIGlzIG5vdCBz
ZXQKQ09ORklHX05FVEZJTFRFUj15CiMgQ09ORklHX05FVEZJTFRFUl9ERUJVRyBpcyBub3Qgc2V0
CkNPTkZJR19ORVRGSUxURVJfQURWQU5DRUQ9eQpDT05GSUdfQlJJREdFX05FVEZJTFRFUj15Cgoj
CiMgQ29yZSBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCkNPTkZJR19ORVRGSUxURVJfTkVUTElO
Sz1tCkNPTkZJR19ORVRGSUxURVJfTkVUTElOS19RVUVVRT1tCkNPTkZJR19ORVRGSUxURVJfTkVU
TElOS19MT0c9bQpDT05GSUdfTkZfQ09OTlRSQUNLPW0KQ09ORklHX05GX0NUX0FDQ1Q9eQpDT05G
SUdfTkZfQ09OTlRSQUNLX01BUks9eQpDT05GSUdfTkZfQ09OTlRSQUNLX1pPTkVTPXkKQ09ORklH
X05GX0NPTk5UUkFDS19FVkVOVFM9eQpDT05GSUdfTkZfQ1RfUFJPVE9fRENDUD1tCkNPTkZJR19O
Rl9DVF9QUk9UT19HUkU9bQpDT05GSUdfTkZfQ1RfUFJPVE9fU0NUUD1tCkNPTkZJR19ORl9DVF9Q
Uk9UT19VRFBMSVRFPW0KQ09ORklHX05GX0NPTk5UUkFDS19BTUFOREE9bQpDT05GSUdfTkZfQ09O
TlRSQUNLX0ZUUD1tCkNPTkZJR19ORl9DT05OVFJBQ0tfSDMyMz1tCkNPTkZJR19ORl9DT05OVFJB
Q0tfSVJDPW0KQ09ORklHX05GX0NPTk5UUkFDS19ORVRCSU9TX05TPW0KQ09ORklHX05GX0NPTk5U
UkFDS19QUFRQPW0KQ09ORklHX05GX0NPTk5UUkFDS19TQU5FPW0KQ09ORklHX05GX0NPTk5UUkFD
S19TSVA9bQpDT05GSUdfTkZfQ09OTlRSQUNLX1RGVFA9bQpDT05GSUdfTkZfQ1RfTkVUTElOSz1t
CkNPTkZJR19ORVRGSUxURVJfVFBST1hZPW0KQ09ORklHX05FVEZJTFRFUl9YVEFCTEVTPW0KCiMK
IyBYdGFibGVzIGNvbWJpbmVkIG1vZHVsZXMKIwpDT05GSUdfTkVURklMVEVSX1hUX01BUks9bQpD
T05GSUdfTkVURklMVEVSX1hUX0NPTk5NQVJLPW0KCiMKIyBYdGFibGVzIHRhcmdldHMKIwpDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9DTEFTU0lGWT1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFS
R0VUX0NPTk5NQVJLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfQ1Q9bQpDT05GSUdfTkVU
RklMVEVSX1hUX1RBUkdFVF9EU0NQPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfSEw9bQpD
T05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9NQVJLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJH
RVRfTkZMT0c9bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORlFVRVVFPW0KQ09ORklHX05F
VEZJTFRFUl9YVF9UQVJHRVRfTk9UUkFDSz1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1JB
VEVFU1Q9bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9URUU9bQpDT05GSUdfTkVURklMVEVS
X1hUX1RBUkdFVF9UUFJPWFk9bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9UUkFDRT1tCkNP
TkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1RDUE1TUz1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFS
R0VUX1RDUE9QVFNUUklQPW0KCiMKIyBYdGFibGVzIG1hdGNoZXMKIwpDT05GSUdfTkVURklMVEVS
X1hUX01BVENIX0NMVVNURVI9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTU1FTlQ9bQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTk5CWVRFUz1tCkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfQ09OTkxJTUlUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTUFSSz1tCkNP
TkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTlRSQUNLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9N
QVRDSF9EQ0NQPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9EU0NQPW0KQ09ORklHX05FVEZJ
TFRFUl9YVF9NQVRDSF9FU1A9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0hBU0hMSU1JVD1t
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSEVMUEVSPW0KQ09ORklHX05FVEZJTFRFUl9YVF9N
QVRDSF9ITD1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSVBSQU5HRT1tCkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfTEVOR1RIPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MSU1JVD1t
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTUFDPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRD
SF9NQVJLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NVUxUSVBPUlQ9bQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX09TRj1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfT1dORVI9bQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX1BPTElDWT1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfUEhZU0RFVj1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUEtUVFlQRT1tCkNPTkZJR19O
RVRGSUxURVJfWFRfTUFUQ0hfUVVPVEE9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JBVEVF
U1Q9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JFQUxNPW0KQ09ORklHX05FVEZJTFRFUl9Y
VF9NQVRDSF9SRUNFTlQ9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NDVFA9bQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX1NPQ0tFVD1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RB
VEU9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NUQVRJU1RJQz1tCkNPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfU1RSSU5HPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9UQ1BNU1M9bQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX1RJTUU9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X1UzMj1tCiMgQ09ORklHX0lQX1ZTIGlzIG5vdCBzZXQKCiMKIyBJUDogTmV0ZmlsdGVyIENvbmZp
Z3VyYXRpb24KIwpDT05GSUdfTkZfREVGUkFHX0lQVjQ9bQpDT05GSUdfTkZfQ09OTlRSQUNLX0lQ
VjQ9bQpDT05GSUdfTkZfQ09OTlRSQUNLX1BST0NfQ09NUEFUPXkKIyBDT05GSUdfSVBfTkZfUVVF
VUUgaXMgbm90IHNldApDT05GSUdfSVBfTkZfSVBUQUJMRVM9bQpDT05GSUdfSVBfTkZfTUFUQ0hf
QUREUlRZUEU9bQpDT05GSUdfSVBfTkZfTUFUQ0hfQUg9bQpDT05GSUdfSVBfTkZfTUFUQ0hfRUNO
PW0KQ09ORklHX0lQX05GX01BVENIX1RUTD1tCkNPTkZJR19JUF9ORl9GSUxURVI9bQpDT05GSUdf
SVBfTkZfVEFSR0VUX1JFSkVDVD1tCkNPTkZJR19JUF9ORl9UQVJHRVRfTE9HPW0KQ09ORklHX0lQ
X05GX1RBUkdFVF9VTE9HPW0KQ09ORklHX05GX05BVD1tCkNPTkZJR19ORl9OQVRfTkVFREVEPXkK
Q09ORklHX0lQX05GX1RBUkdFVF9NQVNRVUVSQURFPW0KQ09ORklHX0lQX05GX1RBUkdFVF9ORVRN
QVA9bQpDT05GSUdfSVBfTkZfVEFSR0VUX1JFRElSRUNUPW0KQ09ORklHX05GX05BVF9TTk1QX0JB
U0lDPW0KQ09ORklHX05GX05BVF9QUk9UT19EQ0NQPW0KQ09ORklHX05GX05BVF9QUk9UT19HUkU9
bQpDT05GSUdfTkZfTkFUX1BST1RPX1VEUExJVEU9bQpDT05GSUdfTkZfTkFUX1BST1RPX1NDVFA9
bQpDT05GSUdfTkZfTkFUX0ZUUD1tCkNPTkZJR19ORl9OQVRfSVJDPW0KQ09ORklHX05GX05BVF9U
RlRQPW0KQ09ORklHX05GX05BVF9BTUFOREE9bQpDT05GSUdfTkZfTkFUX1BQVFA9bQpDT05GSUdf
TkZfTkFUX0gzMjM9bQpDT05GSUdfTkZfTkFUX1NJUD1tCkNPTkZJR19JUF9ORl9NQU5HTEU9bQpD
T05GSUdfSVBfTkZfVEFSR0VUX0NMVVNURVJJUD1tCkNPTkZJR19JUF9ORl9UQVJHRVRfRUNOPW0K
Q09ORklHX0lQX05GX1RBUkdFVF9UVEw9bQpDT05GSUdfSVBfTkZfUkFXPW0KIyBDT05GSUdfSVBf
TkZfU0VDVVJJVFkgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9BUlBUQUJMRVMgaXMgbm90IHNl
dAoKIwojIElQdjY6IE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKQ09ORklHX05GX0NPTk5UUkFD
S19JUFY2PW0KIyBDT05GSUdfSVA2X05GX1FVRVVFIGlzIG5vdCBzZXQKQ09ORklHX0lQNl9ORl9J
UFRBQkxFUz1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfQUg9bQpDT05GSUdfSVA2X05GX01BVENIX0VV
STY0PW0KQ09ORklHX0lQNl9ORl9NQVRDSF9GUkFHPW0KQ09ORklHX0lQNl9ORl9NQVRDSF9PUFRT
PW0KQ09ORklHX0lQNl9ORl9NQVRDSF9ITD1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfSVBWNkhFQURF
Uj1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfTUg9bQpDT05GSUdfSVA2X05GX01BVENIX1JUPW0KQ09O
RklHX0lQNl9ORl9UQVJHRVRfSEw9bQpDT05GSUdfSVA2X05GX1RBUkdFVF9MT0c9bQpDT05GSUdf
SVA2X05GX0ZJTFRFUj1tCkNPTkZJR19JUDZfTkZfVEFSR0VUX1JFSkVDVD1tCkNPTkZJR19JUDZf
TkZfTUFOR0xFPW0KQ09ORklHX0lQNl9ORl9SQVc9bQojIENPTkZJR19JUDZfTkZfU0VDVVJJVFkg
aXMgbm90IHNldApDT05GSUdfQlJJREdFX05GX0VCVEFCTEVTPW0KQ09ORklHX0JSSURHRV9FQlRf
QlJPVVRFPW0KQ09ORklHX0JSSURHRV9FQlRfVF9GSUxURVI9bQpDT05GSUdfQlJJREdFX0VCVF9U
X05BVD1tCkNPTkZJR19CUklER0VfRUJUXzgwMl8zPW0KQ09ORklHX0JSSURHRV9FQlRfQU1PTkc9
bQpDT05GSUdfQlJJREdFX0VCVF9BUlA9bQpDT05GSUdfQlJJREdFX0VCVF9JUD1tCkNPTkZJR19C
UklER0VfRUJUX0lQNj1tCkNPTkZJR19CUklER0VfRUJUX0xJTUlUPW0KQ09ORklHX0JSSURHRV9F
QlRfTUFSSz1tCkNPTkZJR19CUklER0VfRUJUX1BLVFRZUEU9bQpDT05GSUdfQlJJREdFX0VCVF9T
VFA9bQpDT05GSUdfQlJJREdFX0VCVF9WTEFOPW0KQ09ORklHX0JSSURHRV9FQlRfQVJQUkVQTFk9
bQpDT05GSUdfQlJJREdFX0VCVF9ETkFUPW0KQ09ORklHX0JSSURHRV9FQlRfTUFSS19UPW0KQ09O
RklHX0JSSURHRV9FQlRfUkVESVJFQ1Q9bQpDT05GSUdfQlJJREdFX0VCVF9TTkFUPW0KQ09ORklH
X0JSSURHRV9FQlRfTE9HPW0KQ09ORklHX0JSSURHRV9FQlRfVUxPRz1tCkNPTkZJR19CUklER0Vf
RUJUX05GTE9HPW0KQ09ORklHX0lQX0RDQ1A9bQpDT05GSUdfSU5FVF9EQ0NQX0RJQUc9bQoKIwoj
IERDQ1AgQ0NJRHMgQ29uZmlndXJhdGlvbiAoRVhQRVJJTUVOVEFMKQojCiMgQ09ORklHX0lQX0RD
Q1BfQ0NJRDJfREVCVUcgaXMgbm90IHNldApDT05GSUdfSVBfRENDUF9DQ0lEMz15CiMgQ09ORklH
X0lQX0RDQ1BfQ0NJRDNfREVCVUcgaXMgbm90IHNldApDT05GSUdfSVBfRENDUF9DQ0lEM19SVE89
MTAwCkNPTkZJR19JUF9EQ0NQX1RGUkNfTElCPXkKCiMKIyBEQ0NQIEtlcm5lbCBIYWNraW5nCiMK
IyBDT05GSUdfSVBfRENDUF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19JUF9TQ1RQPW0KIyBDT05G
SUdfU0NUUF9EQkdfTVNHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NUUF9EQkdfT0JKQ05UIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NUUF9ITUFDX05PTkUgaXMgbm90IHNldAojIENPTkZJR19TQ1RQX0hN
QUNfU0hBMSBpcyBub3Qgc2V0CkNPTkZJR19TQ1RQX0hNQUNfTUQ1PXkKQ09ORklHX1JEUz1tCkNP
TkZJR19SRFNfVENQPW0KIyBDT05GSUdfUkRTX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfVElQ
QyBpcyBub3Qgc2V0CkNPTkZJR19BVE09eQojIENPTkZJR19BVE1fQ0xJUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUTV9MQU5FIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNX0JSMjY4NCBpcyBub3Qgc2V0
CkNPTkZJR19MMlRQPW0KIyBDT05GSUdfTDJUUF9WMyBpcyBub3Qgc2V0CkNPTkZJR19TVFA9eQpD
T05GSUdfQlJJREdFPXkKQ09ORklHX0JSSURHRV9JR01QX1NOT09QSU5HPXkKQ09ORklHX1ZMQU5f
ODAyMVE9eQojIENPTkZJR19WTEFOXzgwMjFRX0dWUlAgaXMgbm90IHNldAojIENPTkZJR19ERUNO
RVQgaXMgbm90IHNldApDT05GSUdfTExDPXkKIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0CkNPTkZJ
R19JUFg9bQojIENPTkZJR19JUFhfSU5URVJOIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBTEsgaXMg
bm90IHNldAojIENPTkZJR19YMjUgaXMgbm90IHNldAojIENPTkZJR19MQVBCIGlzIG5vdCBzZXQK
IyBDT05GSUdfRUNPTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfV0FOX1JPVVRFUiBpcyBub3Qgc2V0
CiMgQ09ORklHX1BIT05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lFRUU4MDIxNTQgaXMgbm90IHNl
dApDT05GSUdfTkVUX1NDSEVEPXkKCiMKIyBRdWV1ZWluZy9TY2hlZHVsaW5nCiMKQ09ORklHX05F
VF9TQ0hfQ0JRPW0KQ09ORklHX05FVF9TQ0hfSFRCPW0KQ09ORklHX05FVF9TQ0hfSEZTQz1tCkNP
TkZJR19ORVRfU0NIX0FUTT1tCkNPTkZJR19ORVRfU0NIX1BSSU89bQpDT05GSUdfTkVUX1NDSF9N
VUxUSVE9bQpDT05GSUdfTkVUX1NDSF9SRUQ9bQpDT05GSUdfTkVUX1NDSF9TRlE9bQpDT05GSUdf
TkVUX1NDSF9URVFMPW0KQ09ORklHX05FVF9TQ0hfVEJGPW0KQ09ORklHX05FVF9TQ0hfR1JFRD1t
CkNPTkZJR19ORVRfU0NIX0RTTUFSSz1tCkNPTkZJR19ORVRfU0NIX05FVEVNPW0KQ09ORklHX05F
VF9TQ0hfRFJSPW0KQ09ORklHX05FVF9TQ0hfSU5HUkVTUz1tCgojCiMgQ2xhc3NpZmljYXRpb24K
IwpDT05GSUdfTkVUX0NMUz15CkNPTkZJR19ORVRfQ0xTX0JBU0lDPW0KQ09ORklHX05FVF9DTFNf
VENJTkRFWD1tCkNPTkZJR19ORVRfQ0xTX1JPVVRFND1tCkNPTkZJR19ORVRfQ0xTX1JPVVRFPXkK
Q09ORklHX05FVF9DTFNfRlc9bQpDT05GSUdfTkVUX0NMU19VMzI9bQpDT05GSUdfQ0xTX1UzMl9Q
RVJGPXkKQ09ORklHX0NMU19VMzJfTUFSSz15CkNPTkZJR19ORVRfQ0xTX1JTVlA9bQpDT05GSUdf
TkVUX0NMU19SU1ZQNj1tCkNPTkZJR19ORVRfQ0xTX0ZMT1c9bQpDT05GSUdfTkVUX0VNQVRDSD15
CkNPTkZJR19ORVRfRU1BVENIX1NUQUNLPTMyCkNPTkZJR19ORVRfRU1BVENIX0NNUD1tCkNPTkZJ
R19ORVRfRU1BVENIX05CWVRFPW0KQ09ORklHX05FVF9FTUFUQ0hfVTMyPW0KQ09ORklHX05FVF9F
TUFUQ0hfTUVUQT1tCkNPTkZJR19ORVRfRU1BVENIX1RFWFQ9bQpDT05GSUdfTkVUX0NMU19BQ1Q9
eQpDT05GSUdfTkVUX0FDVF9QT0xJQ0U9bQpDT05GSUdfTkVUX0FDVF9HQUNUPW0KQ09ORklHX0dB
Q1RfUFJPQj15CkNPTkZJR19ORVRfQUNUX01JUlJFRD1tCkNPTkZJR19ORVRfQUNUX0lQVD1tCkNP
TkZJR19ORVRfQUNUX05BVD1tCkNPTkZJR19ORVRfQUNUX1BFRElUPW0KQ09ORklHX05FVF9BQ1Rf
U0lNUD1tCkNPTkZJR19ORVRfQUNUX1NLQkVESVQ9bQpDT05GSUdfTkVUX0NMU19JTkQ9eQpDT05G
SUdfTkVUX1NDSF9GSUZPPXkKIyBDT05GSUdfRENCIGlzIG5vdCBzZXQKQ09ORklHX1JQUz15Cgoj
CiMgTmV0d29yayB0ZXN0aW5nCiMKIyBDT05GSUdfTkVUX1BLVEdFTiBpcyBub3Qgc2V0CiMgQ09O
RklHX0hBTVJBRElPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQKIyBDT05GSUdf
SVJEQSBpcyBub3Qgc2V0CkNPTkZJR19CVD1tCkNPTkZJR19CVF9MMkNBUD1tCkNPTkZJR19CVF9M
MkNBUF9FWFRfRkVBVFVSRVM9eQpDT05GSUdfQlRfU0NPPW0KQ09ORklHX0JUX1JGQ09NTT1tCkNP
TkZJR19CVF9SRkNPTU1fVFRZPXkKQ09ORklHX0JUX0JORVA9bQpDT05GSUdfQlRfQk5FUF9NQ19G
SUxURVI9eQpDT05GSUdfQlRfQk5FUF9QUk9UT19GSUxURVI9eQojIENPTkZJR19CVF9ISURQIGlz
IG5vdCBzZXQKCiMKIyBCbHVldG9vdGggZGV2aWNlIGRyaXZlcnMKIwpDT05GSUdfQlRfSENJQlRV
U0I9bQojIENPTkZJR19CVF9IQ0lVQVJUIGlzIG5vdCBzZXQKQ09ORklHX0JUX0hDSUJDTTIwM1g9
bQojIENPTkZJR19CVF9IQ0lCUEExMFggaXMgbm90IHNldAojIENPTkZJR19CVF9IQ0lCRlVTQiBp
cyBub3Qgc2V0CiMgQ09ORklHX0JUX0hDSVZIQ0kgaXMgbm90IHNldAojIENPTkZJR19CVF9NUlZM
IGlzIG5vdCBzZXQKIyBDT05GSUdfQlRfQVRIM0sgaXMgbm90IHNldAojIENPTkZJR19BRl9SWFJQ
QyBpcyBub3Qgc2V0CkNPTkZJR19GSUJfUlVMRVM9eQpDT05GSUdfV0lSRUxFU1M9eQojIENPTkZJ
R19DRkc4MDIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQjgwMjExIGlzIG5vdCBzZXQKCiMKIyBD
Rkc4MDIxMSBuZWVkcyB0byBiZSBlbmFibGVkIGZvciBNQUM4MDIxMQojCgojCiMgU29tZSB3aXJl
bGVzcyBkcml2ZXJzIHJlcXVpcmUgYSByYXRlIGNvbnRyb2wgYWxnb3JpdGhtCiMKIyBDT05GSUdf
V0lNQVggaXMgbm90IHNldAojIENPTkZJR19SRktJTEwgaXMgbm90IHNldAojIENPTkZJR19ORVRf
OVAgaXMgbm90IHNldAojIENPTkZJR19DQUlGIGlzIG5vdCBzZXQKCiMKIyBEZXZpY2UgRHJpdmVy
cwojCgojCiMgR2VuZXJpYyBEcml2ZXIgT3B0aW9ucwojCkNPTkZJR19VRVZFTlRfSEVMUEVSX1BB
VEg9Ii9zYmluL2hvdHBsdWciCiMgQ09ORklHX0RFVlRNUEZTIGlzIG5vdCBzZXQKQ09ORklHX1NU
QU5EQUxPTkU9eQpDT05GSUdfUFJFVkVOVF9GSVJNV0FSRV9CVUlMRD15CkNPTkZJR19GV19MT0FE
RVI9eQpDT05GSUdfRklSTVdBUkVfSU5fS0VSTkVMPXkKQ09ORklHX0VYVFJBX0ZJUk1XQVJFPSIi
CiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0RFVlJFUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NZU19IWVBFUlZJU09SIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09O
TkVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFSUE9S
VCBpcyBub3Qgc2V0CkNPTkZJR19QTlA9eQpDT05GSUdfUE5QX0RFQlVHX01FU1NBR0VTPXkKCiMK
IyBQcm90b2NvbHMKIwpDT05GSUdfUE5QQUNQST15CkNPTkZJR19CTEtfREVWPXkKIyBDT05GSUdf
QkxLX0RFVl9GRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19DUFFfREEgaXMgbm90IHNldAojIENP
TkZJR19CTEtfQ1BRX0NJU1NfREEgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RBQzk2MCBp
cyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfVU1FTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19E
RVZfQ09XX0NPTU1PTiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0xPT1A9eQojIENPTkZJR19C
TEtfREVWX0NSWVBUT0xPT1AgaXMgbm90IHNldAoKIwojIERSQkQgZGlzYWJsZWQgYmVjYXVzZSBQ
Uk9DX0ZTLCBJTkVUIG9yIENPTk5FQ1RPUiBub3Qgc2VsZWN0ZWQKIwojIENPTkZJR19CTEtfREVW
X05CRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfU1g4IGlzIG5vdCBzZXQKIyBDT05GSUdf
QkxLX0RFVl9VQiBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfUkFNIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0RST01fUEtUQ0RWRCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQV9PVkVSX0VUSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSEQgaXMgbm90IHNldApDT05GSUdfTUlTQ19ERVZJQ0VT
PXkKIyBDT05GSUdfQUQ1MjVYX0RQT1QgaXMgbm90IHNldAojIENPTkZJR19JQk1fQVNNIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEhBTlRPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NHSV9JT0M0IGlzIG5v
dCBzZXQKIyBDT05GSUdfVElGTV9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSUNTOTMyUzQwMSBp
cyBub3Qgc2V0CiMgQ09ORklHX0VOQ0xPU1VSRV9TRVJWSUNFUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0NTNTUzNV9NRkdQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0hQX0lMTyBpcyBub3Qgc2V0CiMgQ09O
RklHX0lTTDI5MDAzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UU0wyNTUwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFMxNjgyIGlzIG5vdCBzZXQKIyBDT05GSUdfVk1XQVJFX0JBTExPT04gaXMg
bm90IHNldAojIENPTkZJR19DMlBPUlQgaXMgbm90IHNldAoKIwojIEVFUFJPTSBzdXBwb3J0CiMK
IyBDT05GSUdfRUVQUk9NX0FUMjQgaXMgbm90IHNldAojIENPTkZJR19FRVBST01fTEVHQUNZIGlz
IG5vdCBzZXQKIyBDT05GSUdfRUVQUk9NX01BWDY4NzUgaXMgbm90IHNldAojIENPTkZJR19FRVBS
T01fOTNDWDYgaXMgbm90IHNldAojIENPTkZJR19DQjcxMF9DT1JFIGlzIG5vdCBzZXQKQ09ORklH
X0hBVkVfSURFPXkKIyBDT05GSUdfSURFIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIGRldmljZSBzdXBw
b3J0CiMKQ09ORklHX1NDU0lfTU9EPXkKIyBDT05GSUdfUkFJRF9BVFRSUyBpcyBub3Qgc2V0CkNP
TkZJR19TQ1NJPXkKQ09ORklHX1NDU0lfRE1BPXkKIyBDT05GSUdfU0NTSV9UR1QgaXMgbm90IHNl
dAojIENPTkZJR19TQ1NJX05FVExJTksgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1BST0NfRlMg
aXMgbm90IHNldAoKIwojIFNDU0kgc3VwcG9ydCB0eXBlIChkaXNrLCB0YXBlLCBDRC1ST00pCiMK
Q09ORklHX0JMS19ERVZfU0Q9eQojIENPTkZJR19DSFJfREVWX1NUIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ0hSX0RFVl9PU1NUIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9TUiBpcyBub3Qgc2V0
CkNPTkZJR19DSFJfREVWX1NHPXkKIyBDT05GSUdfQ0hSX0RFVl9TQ0ggaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX01VTFRJX0xVTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQ09OU1RBTlRTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0NTSV9MT0dHSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9T
Q0FOX0FTWU5DIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfV0FJVF9TQ0FOPW0KCiMKIyBTQ1NJIFRy
YW5zcG9ydHMKIwpDT05GSUdfU0NTSV9TUElfQVRUUlM9eQojIENPTkZJR19TQ1NJX0ZDX0FUVFJT
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JU0NTSV9BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfU0FTX0xJQlNBUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU1JQX0FUVFJTIGlzIG5v
dCBzZXQKQ09ORklHX1NDU0lfTE9XTEVWRUw9eQojIENPTkZJR19JU0NTSV9UQ1AgaXMgbm90IHNl
dAojIENPTkZJR19TQ1NJX0JOWDJfSVNDU0kgaXMgbm90IHNldAojIENPTkZJR19CRTJJU0NTSSBp
cyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfM1dfWFhYWF9SQUlEIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0NTSV9IUFNBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV8zV185WFhYIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0NTSV8zV19TQVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FDQVJEIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9BQUNSQUlEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9BSUM3
WFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9BSUM3WFhYX09MRCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NDU0lfQUlDNzlYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQUlDOTRYWCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfTVZTQVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RQVF9JMk8g
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FEVkFOU1lTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9BUkNNU1IgaXMgbm90IHNldAojIENPTkZJR19NRUdBUkFJRF9ORVdHRU4gaXMgbm90IHNldAoj
IENPTkZJR19NRUdBUkFJRF9MRUdBQ1kgaXMgbm90IHNldAojIENPTkZJR19NRUdBUkFJRF9TQVMg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX01QVDJTQVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJ
X0hQVElPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQlVTTE9HSUMgaXMgbm90IHNldAojIENP
TkZJR19WTVdBUkVfUFZTQ1NJIGlzIG5vdCBzZXQKIyBDT05GSUdfTElCRkMgaXMgbm90IHNldAoj
IENPTkZJR19MSUJGQ09FIGlzIG5vdCBzZXQKIyBDT05GSUdfRkNPRSBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZDT0VfRk5JQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRE1YMzE5MUQgaXMgbm90IHNl
dAojIENPTkZJR19TQ1NJX0VBVEEgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0ZVVFVSRV9ET01B
SU4gaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0dEVEggaXMgbm90IHNldAojIENPTkZJR19TQ1NJ
X0lQUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSU5JVElPIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0NTSV9JTklBMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TVEVYIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0NTSV9TWU01M0M4WFhfMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSVBSIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9RTE9HSUNfMTI4MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lf
UUxBX0ZDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9RTEFfSVNDU0kgaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX0xQRkMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RDMzk1eCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfREMzOTBUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9OU1AzMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1BNQ1JB
SUQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1BNODAwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
U0lfU1JQIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9CRkFfRkMgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX0RIIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9PU0RfSU5JVElBVE9SIGlzIG5vdCBz
ZXQKQ09ORklHX0FUQT15CiMgQ09ORklHX0FUQV9OT05TVEFOREFSRCBpcyBub3Qgc2V0CkNPTkZJ
R19BVEFfVkVSQk9TRV9FUlJPUj15CkNPTkZJR19BVEFfQUNQST15CkNPTkZJR19TQVRBX1BNUD15
CgojCiMgQ29udHJvbGxlcnMgd2l0aCBub24tU0ZGIG5hdGl2ZSBpbnRlcmZhY2UKIwpDT05GSUdf
U0FUQV9BSENJPXkKIyBDT05GSUdfU0FUQV9BSENJX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0FUQV9JTklDMTYyWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfU0lMMjQgaXMgbm90IHNl
dApDT05GSUdfQVRBX1NGRj15CgojCiMgU0ZGIGNvbnRyb2xsZXJzIHdpdGggY3VzdG9tIERNQSBp
bnRlcmZhY2UKIwojIENPTkZJR19QRENfQURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfUVNU
T1IgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NYNCBpcyBub3Qgc2V0CkNPTkZJR19BVEFfQk1E
TUE9eQoKIwojIFNBVEEgU0ZGIGNvbnRyb2xsZXJzIHdpdGggQk1ETUEKIwojIENPTkZJR19BVEFf
UElJWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfTVYgaXMgbm90IHNldAojIENPTkZJR19TQVRB
X05WIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9QUk9NSVNFIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0FUQV9TSUwgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NJUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NBVEFfU1ZXIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9VTEkgaXMgbm90IHNldAojIENPTkZJ
R19TQVRBX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfVklURVNTRSBpcyBub3Qgc2V0Cgoj
CiMgUEFUQSBTRkYgY29udHJvbGxlcnMgd2l0aCBCTURNQQojCiMgQ09ORklHX1BBVEFfQUxJIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9BTUQgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0FSVE9Q
IGlzIG5vdCBzZXQKQ09ORklHX1BBVEFfQVRJSVhQPXkKIyBDT05GSUdfUEFUQV9BVFA4NjdYIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DTUQ2NFggaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NT
NTUyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1NTMwIGlzIG5vdCBzZXQKIyBDT05GSUdf
UEFUQV9DUzU1MzUgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NTNTUzNiBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfQ1lQUkVTUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfRUZBUiBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfSFBUMzY2IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzN1gg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDNYMk4gaXMgbm90IHNldAojIENPTkZJR19QQVRB
X0hQVDNYMyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSVQ4MjEzIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9JVDgyMVggaXMgbm90IHNldAojIENPTkZJR19QQVRBX0pNSUNST04gaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX01BUlZFTEwgaXMgbm90IHNldAojIENPTkZJR19QQVRBX05FVENFTEwg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX05JTkpBMzIgaXMgbm90IHNldAojIENPTkZJR19QQVRB
X05TODc0MTUgaXMgbm90IHNldAojIENPTkZJR19QQVRBX09MRFBJSVggaXMgbm90IHNldAojIENP
TkZJR19QQVRBX09QVElETUEgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1BEQzIwMjdYIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFUQV9QRENfT0xEIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9SQURJ
U1lTIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9SREMgaXMgbm90IHNldAojIENPTkZJR19QQVRB
X1NDMTIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0NIIGlzIG5vdCBzZXQKIyBDT05GSUdf
UEFUQV9TRVJWRVJXT1JLUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0lMNjgwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUEFUQV9TSVMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1RPU0hJQkEgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX1RSSUZMRVggaXMgbm90IHNldAojIENPTkZJR19QQVRBX1ZJ
QSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfV0lOQk9ORCBpcyBub3Qgc2V0CgojCiMgUElPLW9u
bHkgU0ZGIGNvbnRyb2xsZXJzCiMKIyBDT05GSUdfUEFUQV9DTUQ2NDBfUENJIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEFUQV9NUElJWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTlM4NzQxMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfT1BUSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUExBVEZP
Uk0gaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JaMTAwMCBpcyBub3Qgc2V0CgojCiMgR2VuZXJp
YyBmYWxsYmFjayAvIGxlZ2FjeSBkcml2ZXJzCiMKIyBDT05GSUdfUEFUQV9BQ1BJIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVRBX0dFTkVSSUMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0xFR0FDWSBp
cyBub3Qgc2V0CkNPTkZJR19NRD15CkNPTkZJR19CTEtfREVWX01EPXkKIyBDT05GSUdfTURfQVVU
T0RFVEVDVCBpcyBub3Qgc2V0CiMgQ09ORklHX01EX0xJTkVBUiBpcyBub3Qgc2V0CiMgQ09ORklH
X01EX1JBSUQwIGlzIG5vdCBzZXQKQ09ORklHX01EX1JBSUQxPXkKIyBDT05GSUdfTURfUkFJRDEw
IGlzIG5vdCBzZXQKIyBDT05GSUdfTURfUkFJRDQ1NiBpcyBub3Qgc2V0CiMgQ09ORklHX01EX01V
TFRJUEFUSCBpcyBub3Qgc2V0CiMgQ09ORklHX01EX0ZBVUxUWSBpcyBub3Qgc2V0CkNPTkZJR19C
TEtfREVWX0RNPXkKIyBDT05GSUdfRE1fREVCVUcgaXMgbm90IHNldApDT05GSUdfRE1fQ1JZUFQ9
eQojIENPTkZJR19ETV9TTkFQU0hPVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX01JUlJPUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RNX1pFUk8gaXMgbm90IHNldAojIENPTkZJR19ETV9NVUxUSVBBVEgg
aXMgbm90IHNldAojIENPTkZJR19ETV9ERUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX1VFVkVO
VCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZVU0lPTiBpcyBub3Qgc2V0CgojCiMgSUVFRSAxMzk0IChG
aXJlV2lyZSkgc3VwcG9ydAojCgojCiMgWW91IGNhbiBlbmFibGUgb25lIG9yIGJvdGggRmlyZVdp
cmUgZHJpdmVyIHN0YWNrcy4KIwoKIwojIFRoZSBuZXdlciBzdGFjayBpcyByZWNvbW1lbmRlZC4K
IwojIENPTkZJR19GSVJFV0lSRSBpcyBub3Qgc2V0CkNPTkZJR19JRUVFMTM5ND15CkNPTkZJR19J
RUVFMTM5NF9PSENJMTM5ND15CiMgQ09ORklHX0lFRUUxMzk0X1BDSUxZTlggaXMgbm90IHNldAoj
IENPTkZJR19JRUVFMTM5NF9TQlAyIGlzIG5vdCBzZXQKIyBDT05GSUdfSUVFRTEzOTRfRVRIMTM5
NF9ST01fRU5UUlkgaXMgbm90IHNldAojIENPTkZJR19JRUVFMTM5NF9FVEgxMzk0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfSUVFRTEzOTRfUkFXSU8gaXMgbm90IHNldAojIENPTkZJR19JRUVFMTM5NF9W
SURFTzEzOTQgaXMgbm90IHNldAojIENPTkZJR19JRUVFMTM5NF9EVjEzOTQgaXMgbm90IHNldAoj
IENPTkZJR19JRUVFMTM5NF9WRVJCT1NFREVCVUcgaXMgbm90IHNldAojIENPTkZJR19JMk8gaXMg
bm90IHNldAojIENPTkZJR19NQUNJTlRPU0hfRFJJVkVSUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRE
RVZJQ0VTPXkKQ09ORklHX0lGQj1tCkNPTkZJR19EVU1NWT1tCiMgQ09ORklHX0JPTkRJTkcgaXMg
bm90IHNldAojIENPTkZJR19NQUNWTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfRVFVQUxJWkVSIGlz
IG5vdCBzZXQKQ09ORklHX1RVTj15CiMgQ09ORklHX1ZFVEggaXMgbm90IHNldAojIENPTkZJR19O
RVRfU0IxMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVUX0VUSEVSTkVUIGlzIG5vdCBzZXQKQ09ORklHX01JST15CkNPTkZJR19ORVRERVZfMTAwMD15
CiMgQ09ORklHX0FDRU5JQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RMMksgaXMgbm90IHNldApDT05G
SUdfRTEwMDA9bQojIENPTkZJR19FMTAwMEUgaXMgbm90IHNldAojIENPTkZJR19JUDEwMDAgaXMg
bm90IHNldAojIENPTkZJR19JR0IgaXMgbm90IHNldAojIENPTkZJR19JR0JWRiBpcyBub3Qgc2V0
CiMgQ09ORklHX05TODM4MjAgaXMgbm90IHNldAojIENPTkZJR19IQU1BQ0hJIGlzIG5vdCBzZXQK
IyBDT05GSUdfWUVMTE9XRklOIGlzIG5vdCBzZXQKQ09ORklHX1I4MTY5PXkKQ09ORklHX1I4MTY5
X1ZMQU49eQojIENPTkZJR19TSVMxOTAgaXMgbm90IHNldAojIENPTkZJR19TS0dFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0tZMiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJQV9WRUxPQ0lUWSBpcyBub3Qg
c2V0CiMgQ09ORklHX1RJR09OMyBpcyBub3Qgc2V0CiMgQ09ORklHX0JOWDIgaXMgbm90IHNldAoj
IENPTkZJR19DTklDIGlzIG5vdCBzZXQKIyBDT05GSUdfUUxBM1hYWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FUTDEgaXMgbm90IHNldAojIENPTkZJR19BVEwxRSBpcyBub3Qgc2V0CiMgQ09ORklHX0FU
TDFDIGlzIG5vdCBzZXQKIyBDT05GSUdfSk1FIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUREVWXzEw
MDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVFIgaXMgbm90IHNldApDT05GSUdfV0xBTj15CiMgQ09O
RklHX0FJUk8gaXMgbm90IHNldAojIENPTkZJR19BVE1FTCBpcyBub3Qgc2V0CiMgQ09ORklHX1BS
SVNNNTQgaXMgbm90IHNldAojIENPTkZJR19VU0JfWkQxMjAxIGlzIG5vdCBzZXQKIyBDT05GSUdf
SE9TVEFQIGlzIG5vdCBzZXQKCiMKIyBFbmFibGUgV2lNQVggKE5ldHdvcmtpbmcgb3B0aW9ucykg
dG8gc2VlIHRoZSBXaU1BWCBkcml2ZXJzCiMKCiMKIyBVU0IgTmV0d29yayBBZGFwdGVycwojCiMg
Q09ORklHX1VTQl9DQVRDIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0tBV0VUSCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9QRUdBU1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1JUTDgxNTAgaXMg
bm90IHNldAojIENPTkZJR19VU0JfVVNCTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lQSEVU
SCBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0CkNPTkZJR19BVE1fRFJJVkVSUz15
CiMgQ09ORklHX0FUTV9EVU1NWSBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTV9UQ1AgaXMgbm90IHNl
dAojIENPTkZJR19BVE1fTEFOQUkgaXMgbm90IHNldAojIENPTkZJR19BVE1fRU5JIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVRNX0ZJUkVTVFJFQU0gaXMgbm90IHNldAojIENPTkZJR19BVE1fWkFUTSBp
cyBub3Qgc2V0CiMgQ09ORklHX0FUTV9OSUNTVEFSIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNX0lE
VDc3MjUyIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNX0FNQkFTU0FET1IgaXMgbm90IHNldAojIENP
TkZJR19BVE1fSE9SSVpPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTV9JQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUTV9GT1JFMjAwRSBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTV9IRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FUTV9TT0xPUyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZEREkgaXMgbm90IHNldAoj
IENPTkZJR19ISVBQSSBpcyBub3Qgc2V0CkNPTkZJR19QUFA9bQpDT05GSUdfUFBQX01VTFRJTElO
Sz15CkNPTkZJR19QUFBfRklMVEVSPXkKQ09ORklHX1BQUF9BU1lOQz1tCkNPTkZJR19QUFBfU1lO
Q19UVFk9bQpDT05GSUdfUFBQX0RFRkxBVEU9bQpDT05GSUdfUFBQX0JTRENPTVA9bQpDT05GSUdf
UFBQX01QUEU9bQpDT05GSUdfUFBQT0U9bQpDT05GSUdfUFBQT0FUTT1tCkNPTkZJR19QUFBPTDJU
UD1tCiMgQ09ORklHX1NMSVAgaXMgbm90IHNldApDT05GSUdfU0xIQz1tCiMgQ09ORklHX05FVF9G
QyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVENPTlNPTEUgaXMgbm90IHNldAojIENPTkZJR19ORVRQ
T0xMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUiBpcyBub3Qgc2V0CiMg
Q09ORklHX1ZNWE5FVDMgaXMgbm90IHNldAojIENPTkZJR19JU0ROIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEhPTkUgaXMgbm90IHNldAoKIwojIElucHV0IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0lO
UFVUPXkKIyBDT05GSUdfSU5QVVRfRkZfTUVNTEVTUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVU
X1BPTExERVYgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9TUEFSU0VLTUFQIGlzIG5vdCBzZXQK
CiMKIyBVc2VybGFuZCBpbnRlcmZhY2VzCiMKIyBDT05GSUdfSU5QVVRfTU9VU0VERVYgaXMgbm90
IHNldAojIENPTkZJR19JTlBVVF9KT1lERVYgaXMgbm90IHNldApDT05GSUdfSU5QVVRfRVZERVY9
eQojIENPTkZJR19JTlBVVF9FVkJVRyBpcyBub3Qgc2V0CgojCiMgSW5wdXQgRGV2aWNlIERyaXZl
cnMKIwpDT05GSUdfSU5QVVRfS0VZQk9BUkQ9eQojIENPTkZJR19LRVlCT0FSRF9BRFA1NTg4IGlz
IG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX0FUS0JEPXkKIyBDT05GSUdfS0VZQk9BUkRfUVQyMTYw
IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTEtLQkQgaXMgbm90IHNldAojIENPTkZJR19L
RVlCT0FSRF9UQ0E2NDE2IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFYNzM1OSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJP
QVJEX09QRU5DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NUT1dBV0FZIGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfU1VOS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9B
UkRfWFRLQkQgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9NT1VTRSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX0pPWVNUSUNLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfVEFCTEVUIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5QVVRfVE9VQ0hTQ1JFRU4gaXMgbm90IHNldAojIENPTkZJR19JTlBV
VF9NSVNDIGlzIG5vdCBzZXQKCiMKIyBIYXJkd2FyZSBJL08gcG9ydHMKIwpDT05GSUdfU0VSSU89
eQpDT05GSUdfU0VSSU9fSTgwNDI9eQojIENPTkZJR19TRVJJT19TRVJQT1JUIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VSSU9fQ1Q4MkM3MTAgaXMgbm90IHNldAojIENPTkZJR19TRVJJT19QQ0lQUzIg
aXMgbm90IHNldApDT05GSUdfU0VSSU9fTElCUFMyPXkKIyBDT05GSUdfU0VSSU9fUkFXIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VSSU9fQUxURVJBX1BTMiBpcyBub3Qgc2V0CiMgQ09ORklHX0dBTUVQ
T1JUIGlzIG5vdCBzZXQKCiMKIyBDaGFyYWN0ZXIgZGV2aWNlcwojCkNPTkZJR19WVD15CkNPTkZJ
R19DT05TT0xFX1RSQU5TTEFUSU9OUz15CkNPTkZJR19WVF9DT05TT0xFPXkKQ09ORklHX0hXX0NP
TlNPTEU9eQojIENPTkZJR19WVF9IV19DT05TT0xFX0JJTkRJTkcgaXMgbm90IHNldApDT05GSUdf
REVWS01FTT15CkNPTkZJR19TRVJJQUxfTk9OU1RBTkRBUkQ9eQojIENPTkZJR19DT01QVVRPTkUg
aXMgbm90IHNldAojIENPTkZJR19ST0NLRVRQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1lDTEFE
RVMgaXMgbm90IHNldAojIENPTkZJR19ESUdJRVBDQSBpcyBub3Qgc2V0CiMgQ09ORklHX01PWEFf
SU5URUxMSU8gaXMgbm90IHNldAojIENPTkZJR19NT1hBX1NNQVJUSU8gaXMgbm90IHNldAojIENP
TkZJR19JU0kgaXMgbm90IHNldAojIENPTkZJR19TWU5DTElOSyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NZTkNMSU5LTVAgaXMgbm90IHNldAojIENPTkZJR19TWU5DTElOS19HVCBpcyBub3Qgc2V0CkNP
TkZJR19OX0hETEM9eQojIENPTkZJR19OX0dTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1JJU0NPTTgg
aXMgbm90IHNldAojIENPTkZJR19TUEVDSUFMSVggaXMgbm90IHNldAojIENPTkZJR19TVEFMRFJW
IGlzIG5vdCBzZXQKIyBDT05GSUdfTk9aT01JIGlzIG5vdCBzZXQKCiMKIyBTZXJpYWwgZHJpdmVy
cwojCkNPTkZJR19TRVJJQUxfODI1MD15CkNPTkZJR19TRVJJQUxfODI1MF9DT05TT0xFPXkKQ09O
RklHX0ZJWF9FQVJMWUNPTl9NRU09eQpDT05GSUdfU0VSSUFMXzgyNTBfUENJPXkKQ09ORklHX1NF
UklBTF84MjUwX1BOUD15CkNPTkZJR19TRVJJQUxfODI1MF9OUl9VQVJUUz0yCkNPTkZJR19TRVJJ
QUxfODI1MF9SVU5USU1FX1VBUlRTPTIKQ09ORklHX1NFUklBTF84MjUwX0VYVEVOREVEPXkKIyBD
T05GSUdfU0VSSUFMXzgyNTBfTUFOWV9QT1JUUyBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfODI1
MF9TSEFSRV9JUlE9eQojIENPTkZJR19TRVJJQUxfODI1MF9ERVRFQ1RfSVJRIGlzIG5vdCBzZXQK
Q09ORklHX1NFUklBTF84MjUwX1JTQT15CgojCiMgTm9uLTgyNTAgc2VyaWFsIHBvcnQgc3VwcG9y
dAojCkNPTkZJR19TRVJJQUxfQ09SRT15CkNPTkZJR19TRVJJQUxfQ09SRV9DT05TT0xFPXkKIyBD
T05GSUdfU0VSSUFMX0pTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9USU1CRVJEQUxFIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0FMVEVSQV9KVEFHVUFSVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFUklBTF9BTFRFUkFfVUFSVCBpcyBub3Qgc2V0CkNPTkZJR19VTklYOThfUFRZUz15CiMg
Q09ORklHX0RFVlBUU19NVUxUSVBMRV9JTlNUQU5DRVMgaXMgbm90IHNldApDT05GSUdfTEVHQUNZ
X1BUWVM9eQpDT05GSUdfTEVHQUNZX1BUWV9DT1VOVD0yNTYKIyBDT05GSUdfSVBNSV9IQU5ETEVS
IGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NIGlzIG5vdCBzZXQKQ09ORklHX05WUkFNPXkK
Q09ORklHX1JUQz15CiMgQ09ORklHX1IzOTY0IGlzIG5vdCBzZXQKIyBDT05GSUdfQVBQTElDT00g
aXMgbm90IHNldAojIENPTkZJR19TT05ZUEkgaXMgbm90IHNldAojIENPTkZJR19NV0FWRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BDODczNnhfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX05TQ19HUElP
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1M1NTM1X0dQSU8gaXMgbm90IHNldAojIENPTkZJR19SQVdf
RFJJVkVSIGlzIG5vdCBzZXQKQ09ORklHX0hQRVQ9eQpDT05GSUdfSFBFVF9NTUFQPXkKQ09ORklH
X0hBTkdDSEVDS19USU1FUj15CiMgQ09ORklHX1RDR19UUE0gaXMgbm90IHNldAojIENPTkZJR19U
RUxDTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19ERVZQT1JUPXkKIyBDT05GSUdfUkFNT09QUyBpcyBu
b3Qgc2V0CkNPTkZJR19JMkM9eQpDT05GSUdfSTJDX0JPQVJESU5GTz15CkNPTkZJR19JMkNfQ09N
UEFUPXkKQ09ORklHX0kyQ19DSEFSREVWPXkKQ09ORklHX0kyQ19IRUxQRVJfQVVUTz15CgojCiMg
STJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBQQyBTTUJ1cyBob3N0IGNvbnRyb2xsZXIg
ZHJpdmVycwojCiMgQ09ORklHX0kyQ19BTEkxNTM1IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FM
STE1NjMgaXMgbm90IHNldAojIENPTkZJR19JMkNfQUxJMTVYMyBpcyBub3Qgc2V0CiMgQ09ORklH
X0kyQ19BTUQ3NTYgaXMgbm90IHNldAojIENPTkZJR19JMkNfQU1EODExMSBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19JODAxIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0lTQ0ggaXMgbm90IHNldAoj
IENPTkZJR19JMkNfUElJWDQgaXMgbm90IHNldAojIENPTkZJR19JMkNfTkZPUkNFMiBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19TSVM1NTk1IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJUzYzMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0kyQ19TSVM5NlggaXMgbm90IHNldAojIENPTkZJR19JMkNfVklB
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1ZJQVBSTyBpcyBub3Qgc2V0CgojCiMgQUNQSSBkcml2
ZXJzCiMKIyBDT05GSUdfSTJDX1NDTUkgaXMgbm90IHNldAoKIwojIEkyQyBzeXN0ZW0gYnVzIGRy
aXZlcnMgKG1vc3RseSBlbWJlZGRlZCAvIHN5c3RlbS1vbi1jaGlwKQojCiMgQ09ORklHX0kyQ19P
Q09SRVMgaXMgbm90IHNldAojIENPTkZJR19JMkNfUENBX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBD
T05GSUdfSTJDX1NJTVRFQyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19YSUxJTlggaXMgbm90IHNl
dAoKIwojIEV4dGVybmFsIEkyQy9TTUJ1cyBhZGFwdGVyIGRyaXZlcnMKIwojIENPTkZJR19JMkNf
UEFSUE9SVF9MSUdIVCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19UQU9TX0VWTSBpcyBub3Qgc2V0
CiMgQ09ORklHX0kyQ19USU5ZX1VTQiBpcyBub3Qgc2V0CgojCiMgT3RoZXIgSTJDL1NNQnVzIGJ1
cyBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX1NUVUIgaXMgbm90IHNldAojIENPTkZJR19TQ3gyMDBf
QUNCIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0NPUkUgaXMgbm90IHNldAojIENPTkZJ
R19JMkNfREVCVUdfQUxHTyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19CVVMgaXMgbm90
IHNldAojIENPTkZJR19TUEkgaXMgbm90IHNldAoKIwojIFBQUyBzdXBwb3J0CiMKIyBDT05GSUdf
UFBTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9PUFRJT05BTF9HUElPTElCPXkKIyBDT05G
SUdfR1BJT0xJQiBpcyBub3Qgc2V0CiMgQ09ORklHX1cxIGlzIG5vdCBzZXQKQ09ORklHX1BPV0VS
X1NVUFBMWT15CiMgQ09ORklHX1BPV0VSX1NVUFBMWV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklH
X1BEQV9QT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfUE9XRVIgaXMgbm90IHNldAojIENP
TkZJR19CQVRURVJZX0RTMjc2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfRFMyNzgyIGlz
IG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9CUTI3eDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFU
VEVSWV9NQVgxNzA0MCBpcyBub3Qgc2V0CkNPTkZJR19IV01PTj15CkNPTkZJR19IV01PTl9WSUQ9
eQojIENPTkZJR19IV01PTl9ERUJVR19DSElQIGlzIG5vdCBzZXQKCiMKIyBOYXRpdmUgZHJpdmVy
cwojCiMgQ09ORklHX1NFTlNPUlNfQUJJVFVHVVJVIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BQklUVUdVUlUzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRDc0MTQgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX0FENzQxOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURN
MTAyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAyNSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfQURNMTAyNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAyOSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAzMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfQURNOTI0MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURUNzQxMSBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfQURUNzQ2MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
QURUNzQ3MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURUNzQ3NSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfQVNDNzYyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSzhURU1Q
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19LMTBURU1QIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19BU0IxMDAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FUWFAxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19EUzE2MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0k1
S19BTUIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0Y3MTgwNUYgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0Y3MTg4MkZHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GNzUzNzVT
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GU0NITUQgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0c3NjBBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HTDUxOFNNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19HTDUyMFNNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19D
T1JFVEVNUCBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0lUODc9eQojIENPTkZJR19TRU5TT1JT
X0xNNjMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNNzMgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0xNNzUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNNzcgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX0xNNzggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODAg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODMgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX0xNODUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODcgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0xNOTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNOTIgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0xNOTMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xU
QzQyMTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xUQzQyNDUgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0xNOTUyNDEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDE2MTkg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDY2NTAgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX1BDODczNjAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDODc0MjcgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX1BDRjg1OTEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X1NJUzU1OTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0RNRTE3MzcgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0VNQzE0MDMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NNU0M0
N00xIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TTVNDNDdNMTkyIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19TTVNDNDdCMzk3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFM3
ODI4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BTUM2ODIxIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19USE1DNTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RNUDEwMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVE1QNDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19UTVA0MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZJQV9DUFVURU1QIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19WSUE2ODZBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19W
VDEyMTEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZUODIzMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfVzgzNzgxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkxRCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkyRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfVzgzNzkzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODNMNzg1VFMgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX1c4M0w3ODZORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfVzgzNjI3SEYgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4MzYyN0VIRiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfSERBUFMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xJ
UzNfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BUFBMRVNNQyBpcyBub3Qgc2V0Cgoj
CiMgQUNQSSBkcml2ZXJzCiMKIyBDT05GSUdfU0VOU09SU19BVEswMTEwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MSVMzTFYwMkQgaXMgbm90IHNldApDT05GSUdfVEhFUk1BTD15CkNPTkZJ
R19USEVSTUFMX0hXTU9OPXkKIyBDT05GSUdfV0FUQ0hET0cgaXMgbm90IHNldApDT05GSUdfU1NC
X1BPU1NJQkxFPXkKCiMKIyBTb25pY3MgU2lsaWNvbiBCYWNrcGxhbmUKIwojIENPTkZJR19TU0Ig
aXMgbm90IHNldApDT05GSUdfTUZEX1NVUFBPUlQ9eQojIENPTkZJR19NRkRfQ09SRSBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF84OFBNODYwWCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9TTTUwMSBp
cyBub3Qgc2V0CiMgQ09ORklHX0hUQ19QQVNJQzMgaXMgbm90IHNldAojIENPTkZJR19UUFM2NTA3
WCBpcyBub3Qgc2V0CiMgQ09ORklHX1RXTDQwMzBfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01G
RF9UQzM1ODkyIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RNSU8gaXMgbm90IHNldAojIENPTkZJ
R19QTUlDX0RBOTAzWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BNSUNfQURQNTUyMCBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9NQVg4OTI1IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODQwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9XTTgzMVggaXMgbm90IHNldAojIENPTkZJR19NRkRfV004MzUw
X0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9XTTg5OTQgaXMgbm90IHNldAojIENPTkZJR19N
RkRfUENGNTA2MzMgaXMgbm90IHNldAojIENPTkZJR19BQlg1MDBfQ09SRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0xQQ19TQ0ggaXMgbm90IHNldAojIENPTkZJR19NRkRfUkRDMzIxWCBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9KQU5aX0NNT0RJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUiBp
cyBub3Qgc2V0CiMgQ09ORklHX01FRElBX1NVUFBPUlQgaXMgbm90IHNldAoKIwojIEdyYXBoaWNz
IHN1cHBvcnQKIwpDT05GSUdfQUdQPXkKIyBDT05GSUdfQUdQX0FMSSBpcyBub3Qgc2V0CiMgQ09O
RklHX0FHUF9BVEkgaXMgbm90IHNldAojIENPTkZJR19BR1BfQU1EIGlzIG5vdCBzZXQKQ09ORklH
X0FHUF9BTUQ2ND15CiMgQ09ORklHX0FHUF9JTlRFTCBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9O
VklESUEgaXMgbm90IHNldAojIENPTkZJR19BR1BfU0lTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUdQ
X1NXT1JLUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9WSUEgaXMgbm90IHNldAojIENPTkZJR19B
R1BfRUZGSUNFT04gaXMgbm90IHNldApDT05GSUdfVkdBX0FSQj15CkNPTkZJR19WR0FfQVJCX01B
WF9HUFVTPTE2CiMgQ09ORklHX1ZHQV9TV0lUQ0hFUk9PIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJN
IGlzIG5vdCBzZXQKIyBDT05GSUdfVkdBU1RBVEUgaXMgbm90IHNldAojIENPTkZJR19WSURFT19P
VVRQVVRfQ09OVFJPTCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkFDS0xJR0hUX0xDRF9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBEaXNwbGF5IGRldmljZSBzdXBw
b3J0CiMKIyBDT05GSUdfRElTUExBWV9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBDb25zb2xlIGRp
c3BsYXkgZHJpdmVyIHN1cHBvcnQKIwpDT05GSUdfVkdBX0NPTlNPTEU9eQpDT05GSUdfVkdBQ09O
X1NPRlRfU0NST0xMQkFDSz15CkNPTkZJR19WR0FDT05fU09GVF9TQ1JPTExCQUNLX1NJWkU9MTI4
CkNPTkZJR19EVU1NWV9DT05TT0xFPXkKQ09ORklHX1NPVU5EPXkKQ09ORklHX1NPVU5EX09TU19D
T1JFPXkKQ09ORklHX1NPVU5EX09TU19DT1JFX1BSRUNMQUlNPXkKQ09ORklHX1NORD15CkNPTkZJ
R19TTkRfVElNRVI9eQpDT05GSUdfU05EX1BDTT15CiMgQ09ORklHX1NORF9TRVFVRU5DRVIgaXMg
bm90IHNldApDT05GSUdfU05EX09TU0VNVUw9eQpDT05GSUdfU05EX01JWEVSX09TUz15CkNPTkZJ
R19TTkRfUENNX09TUz15CkNPTkZJR19TTkRfUENNX09TU19QTFVHSU5TPXkKIyBDT05GSUdfU05E
X0hSVElNRVIgaXMgbm90IHNldApDT05GSUdfU05EX1JUQ1RJTUVSPXkKIyBDT05GSUdfU05EX0RZ
TkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQKQ09ORklHX1NORF9TVVBQT1JUX09MRF9BUEk9eQpDT05G
SUdfU05EX1ZFUkJPU0VfUFJPQ0ZTPXkKIyBDT05GSUdfU05EX1ZFUkJPU0VfUFJJTlRLIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NORF9WTUFTVEVSPXkK
Q09ORklHX1NORF9ETUFfU0dCVUY9eQojIENPTkZJR19TTkRfUkFXTUlESV9TRVEgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfT1BMM19MSUJfU0VRIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX09QTDRf
TElCX1NFUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TQkFXRV9TRVEgaXMgbm90IHNldAojIENP
TkZJR19TTkRfRU1VMTBLMV9TRVEgaXMgbm90IHNldApDT05GSUdfU05EX0RSSVZFUlM9eQojIENP
TkZJR19TTkRfUENTUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9EVU1NWSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9NVFBBViBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TRVJJQUxfVTE2NTUwIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX01QVTQwMSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfUENJPXkK
IyBDT05GSUdfU05EX0FEMTg4OSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BTFMzMDAgaXMgbm90
IHNldAojIENPTkZJR19TTkRfQUxTNDAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BTEk1NDUx
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FTSUhQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9B
VElJWFAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQVRJSVhQX01PREVNIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX0FVODgxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BVTg4MjAgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfQVU4ODMwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FXMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9BWlQzMzI4IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0JUODdYIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0NBMDEwNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9DTUlQ
Q0kgaXMgbm90IHNldAojIENPTkZJR19TTkRfT1hZR0VOIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0NTNDI4MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9DUzQ2WFggaXMgbm90IHNldAojIENPTkZJ
R19TTkRfQ1M1NTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0NTNTUzNUFVRElPIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0NUWEZJIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0RBUkxBMjAgaXMg
bm90IHNldAojIENPTkZJR19TTkRfR0lOQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0xBWUxB
MjAgaXMgbm90IHNldAojIENPTkZJR19TTkRfREFSTEEyNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9HSU5BMjQgaXMgbm90IHNldAojIENPTkZJR19TTkRfTEFZTEEyNCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9NT05BIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01JQSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9FQ0hPM0cgaXMgbm90IHNldAojIENPTkZJR19TTkRfSU5ESUdPIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX0lORElHT0lPIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lORElHT0RKIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0lORElHT0lPWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9J
TkRJR09ESlggaXMgbm90IHNldAojIENPTkZJR19TTkRfRU1VMTBLMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9FTVUxMEsxWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FTlMxMzcwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0VOUzEzNzEgaXMgbm90IHNldAojIENPTkZJR19TTkRfRVMxOTM4IGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0VTMTk2OCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9GTTgw
MSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfSERBX0lOVEVMPXkKIyBDT05GSUdfU05EX0hEQV9IV0RF
UCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9IREFfSU5QVVRfQkVFUCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9IREFfSU5QVVRfSkFDSyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9IREFfUEFUQ0hf
TE9BREVSIGlzIG5vdCBzZXQKQ09ORklHX1NORF9IREFfQ09ERUNfUkVBTFRFSz15CiMgQ09ORklH
X1NORF9IREFfQ09ERUNfQU5BTE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9DT0RFQ19T
SUdNQVRFTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9IREFfQ09ERUNfVklBIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX0hEQV9DT0RFQ19BVElIRE1JIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hE
QV9DT0RFQ19OVkhETUkgaXMgbm90IHNldAojIENPTkZJR19TTkRfSERBX0NPREVDX0lOVEVMSERN
SSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfSERBX0NPREVDX0NJUlJVUz15CiMgQ09ORklHX1NORF9I
REFfQ09ERUNfQ09ORVhBTlQgaXMgbm90IHNldApDT05GSUdfU05EX0hEQV9DT0RFQ19DQTAxMTA9
eQojIENPTkZJR19TTkRfSERBX0NPREVDX0NNRURJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9I
REFfQ09ERUNfU0kzMDU0IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9HRU5FUklDIGlzIG5v
dCBzZXQKQ09ORklHX1NORF9IREFfUE9XRVJfU0FWRT15CkNPTkZJR19TTkRfSERBX1BPV0VSX1NB
VkVfREVGQVVMVD02MAojIENPTkZJR19TTkRfSERTUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9I
RFNQTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9ISUZJRVIgaXMgbm90IHNldAojIENPTkZJR19T
TkRfSUNFMTcxMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JQ0UxNzI0IGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX0lOVEVMOFgwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lOVEVMOFgwTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9LT1JHMTIxMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9MWDY0
NjRFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NQUVTVFJPMyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9NSVhBUlQgaXMgbm90IHNldAojIENPTkZJR19TTkRfTk0yNTYgaXMgbm90IHNldAojIENP
TkZJR19TTkRfUENYSFIgaXMgbm90IHNldAojIENPTkZJR19TTkRfUklQVElERSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9STUUzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9STUU5NiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NORF9STUU5NjUyIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NJUzcwMTkg
aXMgbm90IHNldAojIENPTkZJR19TTkRfU09OSUNWSUJFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9UUklERU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1ZJQTgyWFggaXMgbm90IHNldAojIENP
TkZJR19TTkRfVklBODJYWF9NT0RFTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9WSVJUVU9TTyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9WWDIyMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9ZTUZQ
Q0kgaXMgbm90IHNldAojIENPTkZJR19TTkRfVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NP
QyBpcyBub3Qgc2V0CiMgQ09ORklHX1NPVU5EX1BSSU1FIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9T
VVBQT1JUPXkKQ09ORklHX0hJRD15CkNPTkZJR19ISURSQVc9eQoKIwojIFVTQiBJbnB1dCBEZXZp
Y2VzCiMKQ09ORklHX1VTQl9ISUQ9eQojIENPTkZJR19ISURfUElEIGlzIG5vdCBzZXQKQ09ORklH
X1VTQl9ISURERVY9eQoKIwojIFNwZWNpYWwgSElEIGRyaXZlcnMKIwojIENPTkZJR19ISURfM01f
UENUIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0E0VEVDSCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
RF9BUFBMRSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9CRUxLSU4gaXMgbm90IHNldAojIENPTkZJ
R19ISURfQ0FORE8gaXMgbm90IHNldAojIENPTkZJR19ISURfQ0hFUlJZIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX0NISUNPTlkgaXMgbm90IHNldAojIENPTkZJR19ISURfUFJPRElLRVlTIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX0NZUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19ISURfRFJBR09O
UklTRSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9FR0FMQVggaXMgbm90IHNldAojIENPTkZJR19I
SURfRVpLRVkgaXMgbm90IHNldAojIENPTkZJR19ISURfS1lFIGlzIG5vdCBzZXQKIyBDT05GSUdf
SElEX0dZUkFUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1RXSU5IQU4gaXMgbm90IHNldAoj
IENPTkZJR19ISURfS0VOU0lOR1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9MT0dJVEVDSCBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9NSUNST1NPRlQgaXMgbm90IHNldAojIENPTkZJR19ISURf
TU9TQVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX01PTlRFUkVZIGlzIG5vdCBzZXQKIyBDT05G
SUdfSElEX05UUklHIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX09SVEVLIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX1BBTlRIRVJMT1JEIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1BFVEFMWU5YIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX1BJQ09MQ0QgaXMgbm90IHNldAojIENPTkZJR19ISURfUVVB
TlRBIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1JPQ0NBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
RF9ST0NDQVRfS09ORSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TQU1TVU5HIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX1NPTlkgaXMgbm90IHNldAojIENPTkZJR19ISURfU1RBTlRVTSBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9TVU5QTFVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0dSRUVOQVNJ
QSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TTUFSVEpPWVBMVVMgaXMgbm90IHNldAojIENPTkZJ
R19ISURfVE9QU0VFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9USFJVU1RNQVNURVIgaXMgbm90
IHNldAojIENPTkZJR19ISURfWkVST1BMVVMgaXMgbm90IHNldAojIENPTkZJR19ISURfWllEQUNS
T04gaXMgbm90IHNldApDT05GSUdfVVNCX1NVUFBPUlQ9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX0hD
RD15CkNPTkZJR19VU0JfQVJDSF9IQVNfT0hDST15CkNPTkZJR19VU0JfQVJDSF9IQVNfRUhDST15
CkNPTkZJR19VU0I9eQpDT05GSUdfVVNCX0RFQlVHPXkKQ09ORklHX1VTQl9BTk5PVU5DRV9ORVdf
REVWSUNFUz15CgojCiMgTWlzY2VsbGFuZW91cyBVU0Igb3B0aW9ucwojCkNPTkZJR19VU0JfREVW
SUNFRlM9eQpDT05GSUdfVVNCX0RFVklDRV9DTEFTUz15CiMgQ09ORklHX1VTQl9EWU5BTUlDX01J
Tk9SUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PVEdfV0hJVEVMSVNUIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX09UR19CTEFDS0xJU1RfSFVCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0ZBU1RC
T09UIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX01PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9X
VVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1dVU0JfQ0JBRiBpcyBub3Qgc2V0CgojCiMgVVNC
IEhvc3QgQ29udHJvbGxlciBEcml2ZXJzCiMKIyBDT05GSUdfVVNCX0M2N1gwMF9IQ0QgaXMgbm90
IHNldAojIENPTkZJR19VU0JfWEhDSV9IQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfRUhDSV9I
Q0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfT1hVMjEwSFBfSENEIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX0lTUDExNlhfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDE3NjBfSENEIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDEzNjJfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9P
SENJX0hDRD15CiMgQ09ORklHX1VTQl9PSENJX0JJR19FTkRJQU5fREVTQyBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9PSENJX0JJR19FTkRJQU5fTU1JTyBpcyBub3Qgc2V0CkNPTkZJR19VU0JfT0hD
SV9MSVRUTEVfRU5ESUFOPXkKIyBDT05GSUdfVVNCX1VIQ0lfSENEIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NMODExX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SOEE2NjU5N19IQ0QgaXMg
bm90IHNldAojIENPTkZJR19VU0JfV0hDSV9IQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfSFdB
X0hDRCBpcyBub3Qgc2V0CgojCiMgVVNCIERldmljZSBDbGFzcyBkcml2ZXJzCiMKIyBDT05GSUdf
VVNCX0FDTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9QUklOVEVSIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1dETSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9UTUMgaXMgbm90IHNldAoKIwojIE5P
VEU6IFVTQl9TVE9SQUdFIGRlcGVuZHMgb24gU0NTSSBidXQgQkxLX0RFVl9TRCBtYXkKIwoKIwoj
IGFsc28gYmUgbmVlZGVkOyBzZWUgVVNCX1NUT1JBR0UgSGVscCBmb3IgbW9yZSBpbmZvCiMKQ09O
RklHX1VTQl9TVE9SQUdFPXkKIyBDT05GSUdfVVNCX1NUT1JBR0VfREVCVUcgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU1RPUkFHRV9EQVRBRkFCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JB
R0VfRlJFRUNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0lTRDIwMCBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX1VTQkFUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NU
T1JBR0VfU0REUjA5IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfU0REUjU1IGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfSlVNUFNIT1QgaXMgbm90IHNldAojIENPTkZJR19V
U0JfU1RPUkFHRV9BTEFVREEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9PTkVUT1VD
SCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0tBUk1BIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NUT1JBR0VfQ1lQUkVTU19BVEFDQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MSUJV
U1VBTCBpcyBub3Qgc2V0CgojCiMgVVNCIEltYWdpbmcgZGV2aWNlcwojCiMgQ09ORklHX1VTQl9N
REM4MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTUlDUk9URUsgaXMgbm90IHNldAoKIwojIFVT
QiBwb3J0IGRyaXZlcnMKIwpDT05GSUdfVVNCX1NFUklBTD1tCiMgQ09ORklHX1VTQl9FWlVTQiBp
cyBub3Qgc2V0CkNPTkZJR19VU0JfU0VSSUFMX0dFTkVSSUM9eQojIENPTkZJR19VU0JfU0VSSUFM
X0FJUkNBQkxFIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9BUkszMTE2IGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1NFUklBTF9CRUxLSU4gaXMgbm90IHNldApDT05GSUdfVVNCX1NFUklB
TF9DSDM0MT1tCiMgQ09ORklHX1VTQl9TRVJJQUxfV0hJVEVIRUFUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NFUklBTF9ESUdJX0FDQ0VMRVBPUlQgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VS
SUFMX0NQMjEwWCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfQ1lQUkVTU19NOCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfRU1QRUcgaXMgbm90IHNldApDT05GSUdfVVNCX1NF
UklBTF9GVERJX1NJTz1tCiMgQ09ORklHX1VTQl9TRVJJQUxfRlVOU09GVCBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TRVJJQUxfVklTT1IgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0lQ
QVEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0lSIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1NFUklBTF9FREdFUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfRURHRVBP
UlRfVEkgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0dBUk1JTiBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TRVJJQUxfSVBXIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9JVVUg
aXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fUERBIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1NFUklBTF9LRVlTUEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9L
TFNJIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9LT0JJTF9TQ1QgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU0VSSUFMX01DVF9VMjMyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklB
TF9NT1M3NzIwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9NT1M3ODQwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1NFUklBTF9NT1RPUk9MQSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9T
RVJJQUxfTkFWTUFOIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TRVJJQUxfUEwyMzAzPW0KIyBDT05G
SUdfVVNCX1NFUklBTF9PVEk2ODU4IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9RQ0FV
WCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfUVVBTENPTU0gaXMgbm90IHNldAojIENP
TkZJR19VU0JfU0VSSUFMX1NQQ1A4WDUgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0hQ
NFggaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1NBRkUgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfU0VSSUFMX1NJRU1FTlNfTVBJIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9T
SUVSUkFXSVJFTEVTUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfU1lNQk9MIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9USSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJ
QUxfQ1lCRVJKQUNLIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9YSVJDT00gaXMgbm90
IHNldApDT05GSUdfVVNCX1NFUklBTF9XV0FOPW0KQ09ORklHX1VTQl9TRVJJQUxfT1BUSU9OPW0K
IyBDT05GSUdfVVNCX1NFUklBTF9PTU5JTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklB
TF9PUFRJQ09OIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9WSVZPUEFZX1NFUklBTCBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfWklPIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NFUklBTF9ERUJVRyBpcyBub3Qgc2V0CgojCiMgVVNCIE1pc2NlbGxhbmVvdXMgZHJpdmVycwoj
CiMgQ09ORklHX1VTQl9FTUk2MiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9FTUkyNiBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9BRFVUVVggaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VWU0VHIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1JJTzUwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUdP
VE9XRVIgaXMgbm90IHNldAojIENPTkZJR19VU0JfTENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X0xFRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9DWVBSRVNTX0NZN0M2MyBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9DWVRIRVJNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lETU9VU0UgaXMgbm90
IHNldAojIENPTkZJR19VU0JfRlRESV9FTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FQUExF
RElTUExBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9UUkFOQ0VWSUJSQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JT1dBUlJJT1IgaXMgbm90
IHNldAojIENPTkZJR19VU0JfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU0lHSFRGVyBp
cyBub3Qgc2V0CkNPTkZJR19VU0JfQVRNPW0KIyBDT05GSUdfVVNCX1NQRUVEVE9VQ0ggaXMgbm90
IHNldApDT05GSUdfVVNCX0NYQUNSVT1tCiMgQ09ORklHX1VTQl9VRUFHTEVBVE0gaXMgbm90IHNl
dAojIENPTkZJR19VU0JfWFVTQkFUTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVQgaXMg
bm90IHNldAoKIwojIE9URyBhbmQgcmVsYXRlZCBpbmZyYXN0cnVjdHVyZQojCiMgQ09ORklHX05P
UF9VU0JfWENFSVYgaXMgbm90IHNldAojIENPTkZJR19VV0IgaXMgbm90IHNldAojIENPTkZJR19N
TUMgaXMgbm90IHNldAojIENPTkZJR19NRU1TVElDSyBpcyBub3Qgc2V0CiMgQ09ORklHX05FV19M
RURTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNDRVNTSUJJTElUWSBpcyBub3Qgc2V0CiMgQ09ORklH
X0lORklOSUJBTkQgaXMgbm90IHNldAojIENPTkZJR19FREFDIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0NMQVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BREVWSUNFUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0FVWERJU1BMQVkgaXMgbm90IHNldAojIENPTkZJR19VSU8gaXMgbm90IHNldAojIENPTkZJ
R19TVEFHSU5HIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9QTEFURk9STV9ERVZJQ0VTPXkKIyBDT05G
SUdfQUNFUkhERiBpcyBub3Qgc2V0CiMgQ09ORklHX0FTVVNfTEFQVE9QIGlzIG5vdCBzZXQKIyBD
T05GSUdfVEMxMTAwX1dNSSBpcyBub3Qgc2V0CiMgQ09ORklHX1RISU5LUEFEX0FDUEkgaXMgbm90
IHNldAojIENPTkZJR19JTlRFTF9NRU5MT1cgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX1dNSSBp
cyBub3Qgc2V0CiMgQ09ORklHX0FDUElfQVNVUyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPUFNUQVJf
TEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9UT1NISUJBIGlzIG5vdCBzZXQKIyBDT05G
SUdfVE9TSElCQV9CVF9SRktJTEwgaXMgbm90IHNldAojIENPTkZJR19BQ1BJX0NNUEMgaXMgbm90
IHNldAoKIwojIEZpcm13YXJlIERyaXZlcnMKIwojIENPTkZJR19FREQgaXMgbm90IHNldApDT05G
SUdfRklSTVdBUkVfTUVNTUFQPXkKIyBDT05GSUdfREVMTF9SQlUgaXMgbm90IHNldAojIENPTkZJ
R19EQ0RCQVMgaXMgbm90IHNldApDT05GSUdfRE1JSUQ9eQojIENPTkZJR19JU0NTSV9JQkZUX0ZJ
TkQgaXMgbm90IHNldAoKIwojIEZpbGUgc3lzdGVtcwojCkNPTkZJR19FWFQyX0ZTPXkKQ09ORklH
X0VYVDJfRlNfWEFUVFI9eQpDT05GSUdfRVhUMl9GU19QT1NJWF9BQ0w9eQojIENPTkZJR19FWFQy
X0ZTX1NFQ1VSSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUMl9GU19YSVAgaXMgbm90IHNldApD
T05GSUdfRVhUM19GUz15CkNPTkZJR19FWFQzX0RFRkFVTFRTX1RPX09SREVSRUQ9eQpDT05GSUdf
RVhUM19GU19YQVRUUj15CkNPTkZJR19FWFQzX0ZTX1BPU0lYX0FDTD15CiMgQ09ORklHX0VYVDNf
RlNfU0VDVVJJVFkgaXMgbm90IHNldAojIENPTkZJR19FWFQ0X0ZTIGlzIG5vdCBzZXQKQ09ORklH
X0pCRD15CkNPTkZJR19GU19NQkNBQ0hFPXkKIyBDT05GSUdfUkVJU0VSRlNfRlMgaXMgbm90IHNl
dAojIENPTkZJR19KRlNfRlMgaXMgbm90IHNldApDT05GSUdfRlNfUE9TSVhfQUNMPXkKIyBDT05G
SUdfWEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfR0ZTMl9GUyBpcyBub3Qgc2V0CiMgQ09ORklH
X09DRlMyX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQlRSRlNfRlMgaXMgbm90IHNldAojIENPTkZJ
R19OSUxGUzJfRlMgaXMgbm90IHNldApDT05GSUdfRklMRV9MT0NLSU5HPXkKQ09ORklHX0ZTTk9U
SUZZPXkKQ09ORklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWT15CkNPTkZJR19JTk9USUZZX1VT
RVI9eQpDT05GSUdfUVVPVEE9eQpDT05GSUdfUVVPVEFfTkVUTElOS19JTlRFUkZBQ0U9eQpDT05G
SUdfUFJJTlRfUVVPVEFfV0FSTklORz15CiMgQ09ORklHX1FVT1RBX0RFQlVHIGlzIG5vdCBzZXQK
Q09ORklHX1FVT1RBX1RSRUU9eQojIENPTkZJR19RRk1UX1YxIGlzIG5vdCBzZXQKQ09ORklHX1FG
TVRfVjI9eQpDT05GSUdfUVVPVEFDVEw9eQojIENPTkZJR19BVVRPRlNfRlMgaXMgbm90IHNldAoj
IENPTkZJR19BVVRPRlM0X0ZTIGlzIG5vdCBzZXQKQ09ORklHX0ZVU0VfRlM9bQojIENPTkZJR19D
VVNFIGlzIG5vdCBzZXQKQ09ORklHX0dFTkVSSUNfQUNMPXkKCiMKIyBDYWNoZXMKIwojIENPTkZJ
R19GU0NBQ0hFIGlzIG5vdCBzZXQKCiMKIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zCiMKQ09ORklH
X0lTTzk2NjBfRlM9bQpDT05GSUdfSk9MSUVUPXkKQ09ORklHX1pJU09GUz15CkNPTkZJR19VREZf
RlM9bQpDT05GSUdfVURGX05MUz15CgojCiMgRE9TL0ZBVC9OVCBGaWxlc3lzdGVtcwojCkNPTkZJ
R19GQVRfRlM9bQpDT05GSUdfTVNET1NfRlM9bQpDT05GSUdfVkZBVF9GUz1tCkNPTkZJR19GQVRf
REVGQVVMVF9DT0RFUEFHRT04NTAKQ09ORklHX0ZBVF9ERUZBVUxUX0lPQ0hBUlNFVD0iaXNvODg1
OS0xIgojIENPTkZJR19OVEZTX0ZTIGlzIG5vdCBzZXQKCiMKIyBQc2V1ZG8gZmlsZXN5c3RlbXMK
IwpDT05GSUdfUFJPQ19GUz15CkNPTkZJR19QUk9DX0tDT1JFPXkKQ09ORklHX1BST0NfU1lTQ1RM
PXkKQ09ORklHX1BST0NfUEFHRV9NT05JVE9SPXkKQ09ORklHX1NZU0ZTPXkKQ09ORklHX1RNUEZT
PXkKQ09ORklHX1RNUEZTX1BPU0lYX0FDTD15CkNPTkZJR19IVUdFVExCRlM9eQpDT05GSUdfSFVH
RVRMQl9QQUdFPXkKIyBDT05GSUdfQ09ORklHRlNfRlMgaXMgbm90IHNldApDT05GSUdfTUlTQ19G
SUxFU1lTVEVNUz15CiMgQ09ORklHX0FERlNfRlMgaXMgbm90IHNldAojIENPTkZJR19BRkZTX0ZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfSEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSEZTUExVU19G
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0JFRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19CRlNfRlMg
aXMgbm90IHNldAojIENPTkZJR19FRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19MT0dGUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSQU1GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NRVUFTSEZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfVlhGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX01JTklYX0ZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfT01GU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hQRlNfRlMgaXMgbm90
IHNldAojIENPTkZJR19RTlg0RlNfRlMgaXMgbm90IHNldAojIENPTkZJR19ST01GU19GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NZU1ZfRlMgaXMgbm90IHNldAojIENPTkZJR19VRlNfRlMgaXMgbm90
IHNldApDT05GSUdfTkVUV09SS19GSUxFU1lTVEVNUz15CiMgQ09ORklHX05GU19GUyBpcyBub3Qg
c2V0CkNPTkZJR19ORlNEPW0KQ09ORklHX05GU0RfVjM9eQojIENPTkZJR19ORlNEX1YzX0FDTCBp
cyBub3Qgc2V0CiMgQ09ORklHX05GU0RfVjQgaXMgbm90IHNldApDT05GSUdfTE9DS0Q9bQpDT05G
SUdfTE9DS0RfVjQ9eQpDT05GSUdfRVhQT1JURlM9bQpDT05GSUdfTkZTX0NPTU1PTj15CkNPTkZJ
R19TVU5SUEM9bQojIENPTkZJR19SUENTRUNfR1NTX0tSQjUgaXMgbm90IHNldAojIENPTkZJR19S
UENTRUNfR1NTX1NQS00zIGlzIG5vdCBzZXQKQ09ORklHX1NNQl9GUz1tCkNPTkZJR19TTUJfTkxT
X0RFRkFVTFQ9eQpDT05GSUdfU01CX05MU19SRU1PVEU9IlVURi04IgojIENPTkZJR19DRVBIX0ZT
IGlzIG5vdCBzZXQKQ09ORklHX0NJRlM9bQojIENPTkZJR19DSUZTX1NUQVRTIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ0lGU19XRUFLX1BXX0hBU0ggaXMgbm90IHNldAojIENPTkZJR19DSUZTX1hBVFRS
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0lGU19ERUJVRzIgaXMgbm90IHNldAojIENPTkZJR19DSUZT
X0VYUEVSSU1FTlRBTCBpcyBub3Qgc2V0CiMgQ09ORklHX05DUF9GUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0NPREFfRlMgaXMgbm90IHNldAojIENPTkZJR19BRlNfRlMgaXMgbm90IHNldAoKIwojIFBh
cnRpdGlvbiBUeXBlcwojCiMgQ09ORklHX1BBUlRJVElPTl9BRFZBTkNFRCBpcyBub3Qgc2V0CkNP
TkZJR19NU0RPU19QQVJUSVRJT049eQpDT05GSUdfTkxTPXkKQ09ORklHX05MU19ERUZBVUxUPSJV
VEYtOCIKQ09ORklHX05MU19DT0RFUEFHRV80Mzc9bQojIENPTkZJR19OTFNfQ09ERVBBR0VfNzM3
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBub3Qgc2V0CkNPTkZJR19O
TFNfQ09ERVBBR0VfODUwPW0KIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1MiBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV84NTUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODU3IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MCBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV84NjEgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYy
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MyBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV84NjQgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY1IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NiBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19DT0RFUEFHRV84NjkgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTM2IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzk1MCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19D
T0RFUEFHRV85MzIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTQ5IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg3NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084
ODU5XzggaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfMTI1MCBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV8xMjUxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0FTQ0lJIGlz
IG5vdCBzZXQKQ09ORklHX05MU19JU084ODU5XzE9bQojIENPTkZJR19OTFNfSVNPODg1OV8yIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19J
U084ODU5XzQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV81IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX0lTTzg4NTlfNiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzcgaXMg
bm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV85IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lT
Tzg4NTlfMTMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8xNCBpcyBub3Qgc2V0CkNP
TkZJR19OTFNfSVNPODg1OV8xNT1tCiMgQ09ORklHX05MU19LT0k4X1IgaXMgbm90IHNldAojIENP
TkZJR19OTFNfS09JOF9VIGlzIG5vdCBzZXQKQ09ORklHX05MU19VVEY4PXkKIyBDT05GSUdfRExN
IGlzIG5vdCBzZXQKCiMKIyBLZXJuZWwgaGFja2luZwojCkNPTkZJR19UUkFDRV9JUlFGTEFHU19T
VVBQT1JUPXkKQ09ORklHX1BSSU5US19USU1FPXkKQ09ORklHX0VOQUJMRV9XQVJOX0RFUFJFQ0FU
RUQ9eQpDT05GSUdfRU5BQkxFX01VU1RfQ0hFQ0s9eQpDT05GSUdfRlJBTUVfV0FSTj0xMDI0CkNP
TkZJR19NQUdJQ19TWVNSUT15CiMgQ09ORklHX1NUUklQX0FTTV9TWU1TIGlzIG5vdCBzZXQKIyBD
T05GSUdfVU5VU0VEX1NZTUJPTFMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0hFQURFUlNfQ0hFQ0sgaXMgbm90IHNldApDT05GSUdfREVCVUdfS0VSTkVM
PXkKIyBDT05GSUdfREVCVUdfU0hJUlEgaXMgbm90IHNldApDT05GSUdfREVURUNUX1NPRlRMT0NL
VVA9eQojIENPTkZJR19CT09UUEFSQU1fU09GVExPQ0tVUF9QQU5JQyBpcyBub3Qgc2V0CkNPTkZJ
R19CT09UUEFSQU1fU09GVExPQ0tVUF9QQU5JQ19WQUxVRT0wCkNPTkZJR19ERVRFQ1RfSFVOR19U
QVNLPXkKIyBDT05GSUdfQk9PVFBBUkFNX0hVTkdfVEFTS19QQU5JQyBpcyBub3Qgc2V0CkNPTkZJ
R19CT09UUEFSQU1fSFVOR19UQVNLX1BBTklDX1ZBTFVFPTAKQ09ORklHX1NDSEVEX0RFQlVHPXkK
Q09ORklHX1NDSEVEU1RBVFM9eQpDT05GSUdfVElNRVJfU1RBVFM9eQojIENPTkZJR19ERUJVR19P
QkpFQ1RTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU0xBQiBpcyBub3Qgc2V0CiMgQ09ORklH
X0RFQlVHX0tNRU1MRUFLIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX1BSRUVNUFQ9eQpDT05GSUdf
REVCVUdfUlRfTVVURVhFUz15CkNPTkZJR19ERUJVR19QSV9MSVNUPXkKIyBDT05GSUdfUlRfTVVU
RVhfVEVTVEVSIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX1NQSU5MT0NLPXkKQ09ORklHX0RFQlVH
X01VVEVYRVM9eQpDT05GSUdfREVCVUdfTE9DS19BTExPQz15CkNPTkZJR19QUk9WRV9MT0NLSU5H
PXkKIyBDT05GSUdfUFJPVkVfUkNVIGlzIG5vdCBzZXQKQ09ORklHX0xPQ0tERVA9eQojIENPTkZJ
R19MT0NLX1NUQVQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19MT0NLREVQIGlzIG5vdCBzZXQK
Q09ORklHX1RSQUNFX0lSUUZMQUdTPXkKQ09ORklHX0RFQlVHX1NQSU5MT0NLX1NMRUVQPXkKIyBD
T05GSUdfREVCVUdfTE9DS0lOR19BUElfU0VMRlRFU1RTIGlzIG5vdCBzZXQKQ09ORklHX1NUQUNL
VFJBQ0U9eQojIENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdf
SElHSE1FTSBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19CVUdWRVJCT1NFPXkKIyBDT05GSUdfREVC
VUdfSU5GTyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZNIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfVklSVFVBTCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1dSSVRFQ09VTlQgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19NRU1PUllfSU5JVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X0xJU1QgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX05PVElGSUVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0NSRURFTlRJQUxTIGlzIG5v
dCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9GUkFNRV9QT0lOVEVSUz15CkNPTkZJR19GUkFNRV9QT0lO
VEVSPXkKIyBDT05GSUdfQk9PVF9QUklOVEtfREVMQVkgaXMgbm90IHNldAojIENPTkZJR19SQ1Vf
VE9SVFVSRV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX0NQVV9TVEFMTF9ERVRFQ1RPUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tUUkFDRV9TRUxGX1RFU1QgaXMgbm90IHNldAojIENPTkZJ
R19ERUJVR19CTE9DS19FWFRfREVWVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0ZPUkNFX1dF
QUtfUEVSX0NQVSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZBVUxUX0lOSkVDVElPTiBpcyBub3Qgc2V0
CkNPTkZJR19MQVRFTkNZVE9QPXkKIyBDT05GSUdfU1lTQ1RMX1NZU0NBTExfQ0hFQ0sgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19QQUdFQUxMT0MgaXMgbm90IHNldApDT05GSUdfVVNFUl9TVEFD
S1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9UUkFDRVI9eQpDT05GSUdfSEFW
RV9GVU5DVElPTl9HUkFQSF9UUkFDRVI9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9HUkFQSF9GUF9U
RVNUPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VfTUNPVU5UX1RFU1Q9eQpDT05GSUdfSEFW
RV9EWU5BTUlDX0ZUUkFDRT15CkNPTkZJR19IQVZFX0ZUUkFDRV9NQ09VTlRfUkVDT1JEPXkKQ09O
RklHX0hBVkVfU1lTQ0FMTF9UUkFDRVBPSU5UUz15CkNPTkZJR19UUkFDSU5HX1NVUFBPUlQ9eQpD
T05GSUdfRlRSQUNFPXkKIyBDT05GSUdfRlVOQ1RJT05fVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05G
SUdfSVJRU09GRl9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19QUkVFTVBUX1RSQUNFUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NZU1BST0ZfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NIRURf
VFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfRU5BQkxFX0RFRkFVTFRfVFJBQ0VSUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZUUkFDRV9TWVNDQUxMUyBpcyBub3Qgc2V0CiMgQ09ORklHX0JPT1RfVFJB
Q0VSIGlzIG5vdCBzZXQKQ09ORklHX0JSQU5DSF9QUk9GSUxFX05PTkU9eQojIENPTkZJR19QUk9G
SUxFX0FOTk9UQVRFRF9CUkFOQ0hFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BST0ZJTEVfQUxMX0JS
QU5DSEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfS1NZTV9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJ
R19TVEFDS19UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19LTUVNVFJBQ0UgaXMgbm90IHNldAoj
IENPTkZJR19XT1JLUVVFVUVfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JT19U
UkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX01NSU9UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1BS
T1ZJREVfT0hDSTEzOTRfRE1BX0lOSVQgaXMgbm90IHNldAojIENPTkZJR19ETUFfQVBJX0RFQlVH
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVRPTUlDNjRfU0VMRlRFU1QgaXMgbm90IHNldAojIENPTkZJ
R19TQU1QTEVTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LR0RCPXkKIyBDT05GSUdfS0dE
QiBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FSQ0hfS01FTUNIRUNLPXkKQ09ORklHX1NUUklDVF9E
RVZNRU09eQpDT05GSUdfWDg2X1ZFUkJPU0VfQk9PVFVQPXkKIyBDT05GSUdfRUFSTFlfUFJJTlRL
IGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX1NUQUNLT1ZFUkZMT1c9eQojIENPTkZJR19ERUJVR19T
VEFDS19VU0FHRSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1BFUl9DUFVfTUFQUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1g4Nl9QVERVTVAgaXMgbm90IHNldApDT05GSUdfREVCVUdfUk9EQVRBPXkK
IyBDT05GSUdfREVCVUdfUk9EQVRBX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19OWF9U
RVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfNEtTVEFDS1MgaXMgbm90IHNldApDT05GSUdfRE9VQkxF
RkFVTFQ9eQojIENPTkZJR19JT01NVV9TVFJFU1MgaXMgbm90IHNldApDT05GSUdfSEFWRV9NTUlP
VFJBQ0VfU1VQUE9SVD15CkNPTkZJR19JT19ERUxBWV9UWVBFXzBYODA9MApDT05GSUdfSU9fREVM
QVlfVFlQRV8wWEVEPTEKQ09ORklHX0lPX0RFTEFZX1RZUEVfVURFTEFZPTIKQ09ORklHX0lPX0RF
TEFZX1RZUEVfTk9ORT0zCkNPTkZJR19JT19ERUxBWV8wWDgwPXkKIyBDT05GSUdfSU9fREVMQVlf
MFhFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lPX0RFTEFZX1VERUxBWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lPX0RFTEFZX05PTkUgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9JT19ERUxBWV9UWVBF
PTAKIyBDT05GSUdfQ1BBX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfT1BUSU1JWkVfSU5MSU5J
TkcgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TVFJJQ1RfVVNFUl9DT1BZX0NIRUNLUyBpcyBu
b3Qgc2V0CgojCiMgU2VjdXJpdHkgb3B0aW9ucwojCiMgQ09ORklHX0tFWVMgaXMgbm90IHNldApD
T05GSUdfU0VDVVJJVFk9eQojIENPTkZJR19TRUNVUklUWUZTIGlzIG5vdCBzZXQKQ09ORklHX1NF
Q1VSSVRZX05FVFdPUks9eQojIENPTkZJR19TRUNVUklUWV9ORVRXT1JLX1hGUk0gaXMgbm90IHNl
dAojIENPTkZJR19TRUNVUklUWV9QQVRIIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZX1BPUlRB
Qz15CiMgQ09ORklHX1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CiMgQ09ORklHX0lNQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU0VMSU5VWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0RFRkFVTFRfU0VDVVJJVFlfU01BQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX1NF
Q1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX0RBQz15CkNP
TkZJR19ERUZBVUxUX1NFQ1VSSVRZPSIiCkNPTkZJR19DUllQVE89eQoKIwojIENyeXB0byBjb3Jl
IG9yIGhlbHBlcgojCkNPTkZJR19DUllQVE9fQUxHQVBJPXkKQ09ORklHX0NSWVBUT19BTEdBUEky
PXkKQ09ORklHX0NSWVBUT19BRUFEPXkKQ09ORklHX0NSWVBUT19BRUFEMj15CkNPTkZJR19DUllQ
VE9fQkxLQ0lQSEVSPXkKQ09ORklHX0NSWVBUT19CTEtDSVBIRVIyPXkKQ09ORklHX0NSWVBUT19I
QVNIPXkKQ09ORklHX0NSWVBUT19IQVNIMj15CkNPTkZJR19DUllQVE9fUk5HMj15CkNPTkZJR19D
UllQVE9fUENPTVA9eQpDT05GSUdfQ1JZUFRPX01BTkFHRVI9eQpDT05GSUdfQ1JZUFRPX01BTkFH
RVIyPXkKQ09ORklHX0NSWVBUT19NQU5BR0VSX1RFU1RTPXkKIyBDT05GSUdfQ1JZUFRPX0dGMTI4
TVVMIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX05VTEwgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fUENSWVBUIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19XT1JLUVVFVUU9eQojIENPTkZJ
R19DUllQVE9fQ1JZUFREIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19BVVRIRU5DPXkKIyBDT05G
SUdfQ1JZUFRPX1RFU1QgaXMgbm90IHNldAoKIwojIEF1dGhlbnRpY2F0ZWQgRW5jcnlwdGlvbiB3
aXRoIEFzc29jaWF0ZWQgRGF0YQojCiMgQ09ORklHX0NSWVBUT19DQ00gaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fR0NNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFUUlWIGlzIG5vdCBz
ZXQKCiMKIyBCbG9jayBtb2RlcwojCkNPTkZJR19DUllQVE9fQ0JDPXkKIyBDT05GSUdfQ1JZUFRP
X0NUUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19DVFMgaXMgbm90IHNldApDT05GSUdfQ1JZ
UFRPX0VDQj15CiMgQ09ORklHX0NSWVBUT19MUlcgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
UENCQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19YVFMgaXMgbm90IHNldAoKIwojIEhhc2gg
bW9kZXMKIwpDT05GSUdfQ1JZUFRPX0hNQUM9eQojIENPTkZJR19DUllQVE9fWENCQyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19WTUFDIGlzIG5vdCBzZXQKCiMKIyBEaWdlc3QKIwpDT05GSUdf
Q1JZUFRPX0NSQzMyQz1tCiMgQ09ORklHX0NSWVBUT19DUkMzMkNfSU5URUwgaXMgbm90IHNldAoj
IENPTkZJR19DUllQVE9fR0hBU0ggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTUQ0IGlzIG5v
dCBzZXQKQ09ORklHX0NSWVBUT19NRDU9eQojIENPTkZJR19DUllQVE9fTUlDSEFFTF9NSUMgaXMg
bm90IHNldAojIENPTkZJR19DUllQVE9fUk1EMTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRP
X1JNRDE2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQyNTYgaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fUk1EMzIwIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19TSEExPXkKQ09ORklH
X0NSWVBUT19TSEEyNTY9eQpDT05GSUdfQ1JZUFRPX1NIQTUxMj15CiMgQ09ORklHX0NSWVBUT19U
R1IxOTIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fV1A1MTIgaXMgbm90IHNldAoKIwojIENp
cGhlcnMKIwpDT05GSUdfQ1JZUFRPX0FFUz15CkNPTkZJR19DUllQVE9fQUVTXzU4Nj15CiMgQ09O
RklHX0NSWVBUT19BTlVCSVMgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0FSQzQ9eQpDT05GSUdf
Q1JZUFRPX0JMT1dGSVNIPW0KIyBDT05GSUdfQ1JZUFRPX0NBTUVMTElBIGlzIG5vdCBzZXQKQ09O
RklHX0NSWVBUT19DQVNUNT1tCkNPTkZJR19DUllQVE9fQ0FTVDY9bQpDT05GSUdfQ1JZUFRPX0RF
Uz15CiMgQ09ORklHX0NSWVBUT19GQ1JZUFQgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fS0hB
WkFEIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NBTFNBMjAgaXMgbm90IHNldAojIENPTkZJ
R19DUllQVE9fU0FMU0EyMF81ODYgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0VFRCBpcyBu
b3Qgc2V0CkNPTkZJR19DUllQVE9fU0VSUEVOVD1tCkNPTkZJR19DUllQVE9fVEVBPW0KQ09ORklH
X0NSWVBUT19UV09GSVNIPW0KQ09ORklHX0NSWVBUT19UV09GSVNIX0NPTU1PTj1tCkNPTkZJR19D
UllQVE9fVFdPRklTSF81ODY9bQoKIwojIENvbXByZXNzaW9uCiMKQ09ORklHX0NSWVBUT19ERUZM
QVRFPXkKIyBDT05GSUdfQ1JZUFRPX1pMSUIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTFpP
IGlzIG5vdCBzZXQKCiMKIyBSYW5kb20gTnVtYmVyIEdlbmVyYXRpb24KIwojIENPTkZJR19DUllQ
VE9fQU5TSV9DUFJORyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19IVyBpcyBub3Qgc2V0CkNP
TkZJR19IQVZFX0tWTT15CkNPTkZJR19IQVZFX0tWTV9JUlFDSElQPXkKQ09ORklHX0hBVkVfS1ZN
X0VWRU5URkQ9eQpDT05GSUdfS1ZNX0FQSUNfQVJDSElURUNUVVJFPXkKQ09ORklHX0tWTV9NTUlP
PXkKQ09ORklHX1ZJUlRVQUxJWkFUSU9OPXkKQ09ORklHX0tWTT1tCiMgQ09ORklHX0tWTV9JTlRF
TCBpcyBub3Qgc2V0CkNPTkZJR19LVk1fQU1EPW0KQ09ORklHX1ZIT1NUX05FVD1tCiMgQ09ORklH
X0xHVUVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJUlRJT19QQ0kgaXMgbm90IHNldAojIENPTkZJ
R19WSVJUSU9fQkFMTE9PTiBpcyBub3Qgc2V0CiMgQ09ORklHX0JJTkFSWV9QUklOVEYgaXMgbm90
IHNldAoKIwojIExpYnJhcnkgcm91dGluZXMKIwpDT05GSUdfQklUUkVWRVJTRT15CkNPTkZJR19H
RU5FUklDX0ZJTkRfRklSU1RfQklUPXkKQ09ORklHX0dFTkVSSUNfRklORF9ORVhUX0JJVD15CkNP
TkZJR19HRU5FUklDX0ZJTkRfTEFTVF9CSVQ9eQpDT05GSUdfQ1JDX0NDSVRUPXkKQ09ORklHX0NS
QzE2PW0KIyBDT05GSUdfQ1JDX1QxMERJRiBpcyBub3Qgc2V0CkNPTkZJR19DUkNfSVRVX1Q9bQpD
T05GSUdfQ1JDMzI9eQojIENPTkZJR19DUkM3IGlzIG5vdCBzZXQKQ09ORklHX0xJQkNSQzMyQz1t
CkNPTkZJR19aTElCX0lORkxBVEU9eQpDT05GSUdfWkxJQl9ERUZMQVRFPXkKQ09ORklHX1RFWFRT
RUFSQ0g9eQpDT05GSUdfVEVYVFNFQVJDSF9LTVA9bQpDT05GSUdfVEVYVFNFQVJDSF9CTT1tCkNP
TkZJR19URVhUU0VBUkNIX0ZTTT1tCkNPTkZJR19IQVNfSU9NRU09eQpDT05GSUdfSEFTX0lPUE9S
VD15CkNPTkZJR19IQVNfRE1BPXkKQ09ORklHX05MQVRUUj15
------=_20100909131633_40936--

