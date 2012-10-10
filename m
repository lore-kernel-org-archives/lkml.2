Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2JJQkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:40:33 -0400
Received: from fep23.mx.upcmail.net ([62.179.121.43]:42706 "EHLO
	fep23.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab2JJQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:40:29 -0400
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <5075A4F6.6040608@odi.ch>
Date: Wed, 10 Oct 2012 18:40:22 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [BUG] drm/nouveau: NULL pointer dereference in nouveau_channel_new()
Content-Type: multipart/mixed;
 boundary="------------010406030907060703080303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010406030907060703080303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Current nouveau code in Linus' tree oopses with noaccel. Didn't happen 
in 3.6. Full dmesg attached.

Ortwin

BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
Oct 10 18:05:49 localhost kernel: IP: [<ffffffff8144082e>] 
nouveau_channel_new+0x41e/0x670
Oct 10 18:05:49 localhost kernel: PGD 22ddd7067 PUD 22f76f067 PMD 0
Oct 10 18:05:49 localhost kernel: Oops: 0000 [#1] PREEMPT SMP
Oct 10 18:05:49 localhost kernel: Modules linked in:
Oct 10 18:05:49 localhost kernel: CPU 0
Oct 10 18:05:49 localhost kernel: Pid: 2723, comm: X Not tainted 
3.7.0-pre #1 Hewlett-Packard HP EliteBook 8540w/1521
Oct 10 18:05:49 localhost kernel: RIP: 0010:[<ffffffff8144082e>] 
[<ffffffff8144082e>] nouveau_channel_new+0x41e/0x670
Oct 10 18:05:49 localhost kernel: RSP: 0018:ffff88023026bc68  EFLAGS: 
00010202
Oct 10 18:05:49 localhost kernel: RAX: 0000000000000000 RBX: 
ffff88022ceeca80 RCX: 0000000000000088
Oct 10 18:05:49 localhost kernel: RDX: ffffc900127e408c RSI: 
ffffc900127e408c RDI: ffff88022ceeca80
Oct 10 18:05:49 localhost kernel: RBP: ffff88023026bce8 R08: 
000000000000ffff R09: 0000000000000000
Oct 10 18:05:49 localhost kernel: R10: 0000000000000010 R11: 
000000000000000f R12: 0000000000000000
Oct 10 18:05:49 localhost kernel: R13: ffff880231f36800 R14: 
ffff88022f68ca00 R15: ffff88022f68ca00
Oct 10 18:05:49 localhost kernel: FS:  00007f129a597880(0000) 
GS:ffff88023bc00000(0000) knlGS:0000000000000000
Oct 10 18:05:49 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Oct 10 18:05:49 localhost kernel: CR2: 0000000000000018 CR3: 
00000002300a1000 CR4: 00000000000007f0
Oct 10 18:05:49 localhost kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct 10 18:05:49 localhost kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct 10 18:05:49 localhost kernel: Process X (pid: 2723, threadinfo 
ffff88023026a000, task ffff880231edbde0)
Oct 10 18:05:49 localhost kernel: Stack:
Oct 10 18:05:49 localhost kernel: ffff88023026bcb0 ffff88022f68ca00 
ffff88022f68caa8 ffff8802311be9c0
Oct 10 18:05:49 localhost kernel: d8000001d8000002 ffff88023026bc98 
0000200000000000 0000000000000000
Oct 10 18:05:49 localhost kernel: 000000ffffffffff ffff880231f9afa0 
ffffffffffffffff ffff8802323c0840
Oct 10 18:05:49 localhost kernel: Call Trace:
Oct 10 18:05:49 localhost kernel: [<ffffffff81448cbc>] 
nouveau_abi16_ioctl_channel_alloc+0x15c/0x360
Oct 10 18:05:49 localhost kernel: [<ffffffff813a9120>] drm_ioctl+0x2a0/0x4f0
Oct 10 18:05:49 localhost kernel: [<ffffffff81448b60>] ? 
nouveau_abi16_ioctl_setparam+0x10/0x10
Oct 10 18:05:49 localhost kernel: [<ffffffff81076be4>] ? 
__do_page_fault+0x1c4/0x490
Oct 10 18:05:49 localhost kernel: [<ffffffff81198eb7>] 
do_vfs_ioctl+0x97/0x4f0
Oct 10 18:05:49 localhost kernel: [<ffffffff81199367>] sys_ioctl+0x57/0x90
Oct 10 18:05:49 localhost kernel: [<ffffffff818635a2>] 
system_call_fastpath+0x16/0x1b
Oct 10 18:05:49 localhost kernel: Code: e2 02 48 89 df e8 d3 02 00 00 8b 
83 80 00 00 00 89 83 84 00 00 00 0f 1f 80 00 00 00 00 48 8b 43 08 48 89 
df 48 8b 80 f8 06 00 00 <ff> 50 18 41 89 c4 85 c0 0f 84 65 fd ff ff 0f 
1f 40 00 4c 89 ff
Oct 10 18:05:49 localhost kernel: RIP  [<ffffffff8144082e>] 
nouveau_channel_new+0x41e/0x670
Oct 10 18:05:49 localhost kernel: RSP <ffff88023026bc68>
Oct 10 18:05:49 localhost kernel: CR2: 0000000000000018
Oct 10 18:05:49 localhost kernel: ---[ end trace e23ae1067c361c88 ]---


--------------010406030907060703080303
Content-Type: text/plain; charset=UTF-8;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages"

Oct 10 18:05:42 localhost kernel: Initializing cgroup subsys cpu
Oct 10 18:05:42 localhost kernel: Linux version 3.7.0-pre (root@localhost) (gcc version 4.5.4 (Gentoo 4.5.4 p1.0, pie-0.4.7) ) #1 SMP PREEMPT Wed Oct 10 17:35:48 CEST 2012
Oct 10 18:05:42 localhost kernel: Command line: root=/dev/sda1 rootfstype=ext4 nouveau.noaccel=1
Oct 10 18:05:42 localhost kernel: e820: BIOS-provided physical RAM map:
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x0000000000100000-0x00000000befc1fff] usable
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000befc2000-0x00000000bf6c1fff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000bf6c2000-0x00000000bf7c1fff] ACPI NVS
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000bf7c2000-0x00000000bf7fefff] ACPI data
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000bf7ff000-0x00000000bf7fffff] usable
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000bf800000-0x00000000bfffffff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000fed1b000-0x00000000fed1ffff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x0000000100000000-0x00000001fbffffff] usable
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x00000001fc000000-0x00000001ffffffff] reserved
Oct 10 18:05:42 localhost kernel: BIOS-e820: [mem 0x0000000200000000-0x000000023bffffff] usable
Oct 10 18:05:42 localhost kernel: NX (Execute Disable) protection: active
Oct 10 18:05:42 localhost kernel: DMI 2.6 present.
Oct 10 18:05:42 localhost kernel: DMI: Hewlett-Packard HP EliteBook 8540w/1521, BIOS 68CVD Ver. F.0E 11/25/2010
Oct 10 18:05:42 localhost kernel: e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
Oct 10 18:05:42 localhost kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
Oct 10 18:05:42 localhost kernel: No AGP bridge found
Oct 10 18:05:42 localhost kernel: e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
Oct 10 18:05:42 localhost kernel: MTRR default type: uncachable
Oct 10 18:05:42 localhost kernel: MTRR fixed ranges enabled:
Oct 10 18:05:42 localhost kernel: 00000-9FFFF write-back
Oct 10 18:05:42 localhost kernel: A0000-BFFFF uncachable
Oct 10 18:05:42 localhost kernel: C0000-FFFFF write-protect
Oct 10 18:05:42 localhost kernel: MTRR variable ranges enabled:
Oct 10 18:05:42 localhost kernel: 0 base 0FFC00000 mask FFFC00000 write-protect
Oct 10 18:05:42 localhost kernel: 1 base 000000000 mask F80000000 write-back
Oct 10 18:05:42 localhost kernel: 2 base 080000000 mask FC0000000 write-back
Oct 10 18:05:42 localhost kernel: 3 base 100000000 mask F00000000 write-back
Oct 10 18:05:42 localhost kernel: 4 base 200000000 mask FC0000000 write-back
Oct 10 18:05:42 localhost kernel: 5 base 23C000000 mask FFC000000 uncachable
Oct 10 18:05:42 localhost kernel: 6 disabled
Oct 10 18:05:42 localhost kernel: 7 disabled
Oct 10 18:05:42 localhost kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Oct 10 18:05:42 localhost kernel: e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
Oct 10 18:05:42 localhost kernel: initial memory mapped: [mem 0x00000000-0x1fffffff]
Oct 10 18:05:42 localhost kernel: Base memory trampoline at [ffff880000099000] 99000 size 24576
Oct 10 18:05:42 localhost kernel: init_memory_mapping: [mem 0x00000000-0xbf7fffff]
Oct 10 18:05:42 localhost kernel: [mem 0x00000000-0xbf7fffff] page 2M
Oct 10 18:05:42 localhost kernel: kernel direct mapping tables up to 0xbf7fffff @ [mem 0x1fa00000-0x1fffffff]
Oct 10 18:05:42 localhost kernel: init_memory_mapping: [mem 0x100000000-0x23bffffff]
Oct 10 18:05:42 localhost kernel: [mem 0x100000000-0x23bffffff] page 2M
Oct 10 18:05:42 localhost kernel: kernel direct mapping tables up to 0x23bffffff @ [mem 0xbefb8000-0xbefc1fff]
Oct 10 18:05:42 localhost kernel: ACPI: RSDP 00000000000fddc0 00024 (v02 HPQOEM)
Oct 10 18:05:42 localhost kernel: ACPI: XSDT 00000000bf7fe120 00094 (v01 HPQOEM SLIC-MPC 0000000F      01000013)
Oct 10 18:05:42 localhost kernel: ACPI: FACP 00000000bf7fc000 000F4 (v03 HPQOEM 1521     0000000F HP   00000001)
Oct 10 18:05:42 localhost kernel: ACPI: DSDT 00000000bf7da000 1C77F (v02 HPQOEM 1521     00000001 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: FACS 00000000bf760000 00040
Oct 10 18:05:42 localhost kernel: ACPI: HPET 00000000bf7fb000 00038 (v01 HPQOEM 1521     00000001 HP   00000001)
Oct 10 18:05:42 localhost kernel: ACPI: APIC 00000000bf7fa000 000BC (v01 HPQOEM 1521     00000001 HP   00000001)
Oct 10 18:05:42 localhost kernel: ACPI: MCFG 00000000bf7f9000 0003C (v01 HPQOEM 1521     00000001 HP   00000001)
Oct 10 18:05:42 localhost kernel: ACPI: TCPA 00000000bf7f7000 00032 (v02 HPQOEM 1521     00000000 HP   00000001)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf7d7000 00135 (v01 HPQOEM SataAhci 00001000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf7d6000 00314 (v01 HPQOEM PtidDevc 00001000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: SLIC 00000000bf7d5000 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf7d1000 02576 (v01 HPQOEM NVIDIAGF 00000001 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: DMAR 00000000bf7d0000 00080 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf7cf000 00A10 (v01  PmRef    CpuPm 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf7ce000 00288 (v01  PmRef  Cpu0Tst 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf7cd000 00225 (v01  PmRef    ApTst 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: ASF! 00000000bf7f8000 000A0 (v32 HPQOEM 1521     00000001 HP   00000001)
Oct 10 18:05:42 localhost kernel: ACPI: Local APIC address 0xfee00000
Oct 10 18:05:42 localhost kernel: No NUMA configuration found
Oct 10 18:05:42 localhost kernel: Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
Oct 10 18:05:42 localhost kernel: Initmem setup node 0 [mem 0x00000000-0x23bffffff]
Oct 10 18:05:42 localhost kernel: NODE_DATA [mem 0x23bffc000-0x23bffffff]
Oct 10 18:05:42 localhost kernel: [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880233600000-ffff88023b5fffff] on node 0
Oct 10 18:05:42 localhost kernel: Zone ranges:
Oct 10 18:05:42 localhost kernel: DMA      [mem 0x00010000-0x00ffffff]
Oct 10 18:05:42 localhost kernel: DMA32    [mem 0x01000000-0xffffffff]
Oct 10 18:05:42 localhost kernel: Normal   [mem 0x100000000-0x23bffffff]
Oct 10 18:05:42 localhost kernel: Movable zone start for each node
Oct 10 18:05:42 localhost kernel: Early memory node ranges
Oct 10 18:05:42 localhost kernel: node   0: [mem 0x00010000-0x0009efff]
Oct 10 18:05:42 localhost kernel: node   0: [mem 0x00100000-0xbefc1fff]
Oct 10 18:05:42 localhost kernel: node   0: [mem 0xbf7ff000-0xbf7fffff]
Oct 10 18:05:42 localhost kernel: node   0: [mem 0x100000000-0x1fbffffff]
Oct 10 18:05:42 localhost kernel: node   0: [mem 0x200000000-0x23bffffff]
Oct 10 18:05:42 localhost kernel: On node 0 totalpages: 2060114
Oct 10 18:05:42 localhost kernel: DMA zone: 64 pages used for memmap
Oct 10 18:05:42 localhost kernel: DMA zone: 6 pages reserved
Oct 10 18:05:42 localhost kernel: DMA zone: 3913 pages, LIFO batch:0
Oct 10 18:05:42 localhost kernel: DMA32 zone: 16320 pages used for memmap
Oct 10 18:05:42 localhost kernel: DMA32 zone: 761859 pages, LIFO batch:31
Oct 10 18:05:42 localhost kernel: Normal zone: 20224 pages used for memmap
Oct 10 18:05:42 localhost kernel: Normal zone: 1257728 pages, LIFO batch:31
Oct 10 18:05:42 localhost kernel: ACPI: PM-Timer IO Port: 0x408
Oct 10 18:05:42 localhost kernel: ACPI: Local APIC address 0xfee00000
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
Oct 10 18:05:42 localhost kernel: ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Oct 10 18:05:42 localhost kernel: IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
Oct 10 18:05:42 localhost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Oct 10 18:05:42 localhost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Oct 10 18:05:42 localhost kernel: ACPI: IRQ0 used by override.
Oct 10 18:05:42 localhost kernel: ACPI: IRQ2 used by override.
Oct 10 18:05:42 localhost kernel: ACPI: IRQ9 used by override.
Oct 10 18:05:42 localhost kernel: Using ACPI (MADT) for SMP configuration information
Oct 10 18:05:42 localhost kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Oct 10 18:05:42 localhost kernel: smpboot: Allowing 8 CPUs, 4 hotplug CPUs
Oct 10 18:05:42 localhost kernel: nr_irqs_gsi: 40
Oct 10 18:05:42 localhost kernel: e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
Oct 10 18:05:42 localhost kernel: setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8 nr_node_ids:1
Oct 10 18:05:42 localhost kernel: PERCPU: Embedded 27 pages/cpu @ffff88023bc00000 s78848 r8192 d23552 u262144
Oct 10 18:05:42 localhost kernel: pcpu-alloc: s78848 r8192 d23552 u262144 alloc=1*2097152
Oct 10 18:05:42 localhost kernel: pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Oct 10 18:05:42 localhost kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2023500
Oct 10 18:05:42 localhost kernel: Policy zone: Normal
Oct 10 18:05:42 localhost kernel: Kernel command line: root=/dev/sda1 rootfstype=ext4 nouveau.noaccel=1
Oct 10 18:05:42 localhost kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Oct 10 18:05:42 localhost kernel: __ex_table already sorted, skipping sort
Oct 10 18:05:42 localhost kernel: Checking aperture...
Oct 10 18:05:42 localhost kernel: No AGP bridge found
Oct 10 18:05:42 localhost kernel: Memory: 8028500k/9371648k available (8610k kernel code, 1131192k absent, 211956k reserved, 3426k data, 832k init)
Oct 10 18:05:42 localhost kernel: SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Oct 10 18:05:42 localhost kernel: Preemptible hierarchical RCU implementation.
Oct 10 18:05:42 localhost kernel: 	Dump stacks of tasks blocking RCU-preempt GP.
Oct 10 18:05:42 localhost kernel: 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
Oct 10 18:05:42 localhost kernel: NR_IRQS:4352 nr_irqs:744 16
Oct 10 18:05:42 localhost kernel: Extended CMOS year: 2000
Oct 10 18:05:42 localhost kernel: Console: colour VGA+ 80x25
Oct 10 18:05:42 localhost kernel: console [tty0] enabled
Oct 10 18:05:42 localhost kernel: hpet clockevent registered
Oct 10 18:05:42 localhost kernel: tsc: Fast TSC calibration failed
Oct 10 18:05:42 localhost kernel: tsc: PIT calibration matches HPET. 1 loops
Oct 10 18:05:42 localhost kernel: tsc: Detected 2660.575 MHz processor
Oct 10 18:05:42 localhost kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 5321.15 BogoMIPS (lpj=10642300)
Oct 10 18:05:42 localhost kernel: pid_max: default: 32768 minimum: 301
Oct 10 18:05:42 localhost kernel: Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Oct 10 18:05:42 localhost kernel: Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Oct 10 18:05:42 localhost kernel: Mount-cache hash table entries: 256
Oct 10 18:05:42 localhost kernel: CPU: Physical Processor ID: 0
Oct 10 18:05:42 localhost kernel: CPU: Processor Core ID: 0
Oct 10 18:05:42 localhost kernel: mce: CPU supports 9 MCE banks
Oct 10 18:05:42 localhost kernel: CPU0: Thermal monitoring enabled (TM1)
Oct 10 18:05:42 localhost kernel: process: using mwait in idle threads
Oct 10 18:05:42 localhost kernel: Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Oct 10 18:05:42 localhost kernel: Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
Oct 10 18:05:42 localhost kernel: tlb_flushall_shift: 6
Oct 10 18:05:42 localhost kernel: Freeing SMP alternatives: 28k freed
Oct 10 18:05:42 localhost kernel: ACPI: Core revision 20120913
Oct 10 18:05:42 localhost kernel: ftrace: allocating 30283 entries in 119 pages
Oct 10 18:05:42 localhost kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Oct 10 18:05:42 localhost kernel: smpboot: CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz (fam: 06, model: 25, stepping: 05)
Oct 10 18:05:42 localhost kernel: Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
Oct 10 18:05:42 localhost kernel: perf_event_intel: CPUID marked event: 'bus cycles' unavailable
Oct 10 18:05:42 localhost kernel: ... version:                3
Oct 10 18:05:42 localhost kernel: ... bit width:              48
Oct 10 18:05:42 localhost kernel: ... generic registers:      4
Oct 10 18:05:42 localhost kernel: ... value mask:             0000ffffffffffff
Oct 10 18:05:42 localhost kernel: ... max period:             000000007fffffff
Oct 10 18:05:42 localhost kernel: ... fixed-purpose events:   3
Oct 10 18:05:42 localhost kernel: ... event mask:             000000070000000f
Oct 10 18:05:42 localhost kernel: smpboot: Booting Node   0, Processors  #1 #2 #3
Oct 10 18:05:42 localhost kernel: Brought up 4 CPUs
Oct 10 18:05:42 localhost kernel: smpboot: Total of 4 processors activated (21284.60 BogoMIPS)
Oct 10 18:05:42 localhost kernel: devtmpfs: initialized
Oct 10 18:05:42 localhost kernel: PM: Registering ACPI NVS region [mem 0xbf6c2000-0xbf7c1fff] (1048576 bytes)
Oct 10 18:05:42 localhost kernel: NET: Registered protocol family 16
Oct 10 18:05:42 localhost kernel: ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Oct 10 18:05:42 localhost kernel: ACPI: bus type pci registered
Oct 10 18:05:42 localhost kernel: dca service started, version 1.12.1
Oct 10 18:05:42 localhost kernel: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Oct 10 18:05:42 localhost kernel: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
Oct 10 18:05:42 localhost kernel: PCI: Using configuration type 1 for base access
Oct 10 18:05:42 localhost kernel: bio: create slab <bio-0> at 0
Oct 10 18:05:42 localhost kernel: ACPI: Added _OSI(Module Device)
Oct 10 18:05:42 localhost kernel: ACPI: Added _OSI(Processor Device)
Oct 10 18:05:42 localhost kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Oct 10 18:05:42 localhost kernel: ACPI: Added _OSI(Processor Aggregator Device)
Oct 10 18:05:42 localhost kernel: ACPI: EC: Look up EC in DSDT
Oct 10 18:05:42 localhost kernel: [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf6bba18 0047D (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 10 18:05:42 localhost kernel: ACPI: SSDT           (null) 0047D (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf6b9018 008AA (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 10 18:05:42 localhost kernel: ACPI: SSDT           (null) 008AA (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf6baa98 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 10 18:05:42 localhost kernel: ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: SSDT 00000000bf6b8d98 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: Dynamic OEM Table Load:
Oct 10 18:05:42 localhost kernel: ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
Oct 10 18:05:42 localhost kernel: ACPI: Interpreter enabled
Oct 10 18:05:42 localhost kernel: ACPI: (supports S0 S3 S5)
Oct 10 18:05:42 localhost kernel: ACPI: Using IOAPIC for interrupt routing
Oct 10 18:05:42 localhost kernel: ACPI: Power Resource [APPR] (off)
Oct 10 18:05:42 localhost kernel: ACPI: Power Resource [COMP] (on)
Oct 10 18:05:42 localhost kernel: ACPI: Power Resource [LPP] (on)
Oct 10 18:05:42 localhost kernel: ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
Oct 10 18:05:42 localhost kernel: ACPI: No dock devices found.
Oct 10 18:05:42 localhost kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Oct 10 18:05:42 localhost kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
Oct 10 18:05:42 localhost kernel: PCI host bridge to bus 0000:00
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: root bus resource [bus 00-fe]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfedfffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
Oct 10 18:05:42 localhost kernel: DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
Oct 10 18:05:42 localhost kernel: pci 0000:00:16.0: reg 10: [mem 0xd7524000-0xd752400f 64bit]
Oct 10 18:05:42 localhost kernel: pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
Oct 10 18:05:42 localhost kernel: pci 0000:00:16.3: reg 10: [io  0x6050-0x6057]
Oct 10 18:05:42 localhost kernel: pci 0000:00:16.3: reg 14: [mem 0xd752b000-0xd752bfff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
Oct 10 18:05:42 localhost kernel: pci 0000:00:19.0: reg 10: [mem 0xd7500000-0xd751ffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:19.0: reg 14: [mem 0xd752a000-0xd752afff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:19.0: reg 18: [io  0x6020-0x603f]
Oct 10 18:05:42 localhost kernel: pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
Oct 10 18:05:42 localhost kernel: pci 0000:00:1a.0: reg 10: [mem 0xd7529000-0xd75293ff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
Oct 10 18:05:42 localhost kernel: pci 0000:00:1b.0: reg 10: [mem 0xd7520000-0xd7523fff 64bit]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.7: [8086:3b50] type 01 class 0x060400
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
Oct 10 18:05:42 localhost kernel: pci 0000:00:1d.0: reg 10: [mem 0xd7528000-0xd75283ff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: reg 10: [io  0x6048-0x604f]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: reg 14: [io  0x605c-0x605f]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: reg 18: [io  0x6040-0x6047]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: reg 1c: [io  0x6058-0x605b]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: reg 20: [io  0x6000-0x601f]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: reg 24: [mem 0xd7527000-0xd75277ff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.2: PME# supported from D3hot
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
Oct 10 18:05:42 localhost kernel: pci 0000:00:1f.6: reg 10: [mem 0xd7526000-0xd7526fff 64bit]
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: [10de:0cbc] type 00 class 0x030000
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: reg 10: [mem 0xd2000000-0xd2ffffff]
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: reg 24: [io  0x5000-0x507f]
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.1: [10de:0be4] type 00 class 0x040300
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.1: reg 10: [mem 0xd3000000-0xd3003fff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xd2000000-0xd30fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.0:   bridge window [mem 0xd7400000-0xd74fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1: PCI bridge to [bus 03-43]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xd3400000-0xd73fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:44:00.0: [8086:4238] type 00 class 0x028000
Oct 10 18:05:42 localhost kernel: pci 0000:44:00.0: reg 10: [mem 0xd3300000-0xd3301fff 64bit]
Oct 10 18:05:42 localhost kernel: pci 0000:44:00.0: PME# supported from D0 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.3: PCI bridge to [bus 44]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.3:   bridge window [mem 0xd3300000-0xd33fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:45:00.0: [1033:0194] type 00 class 0x0c0330
Oct 10 18:05:42 localhost kernel: pci 0000:45:00.0: reg 10: [mem 0xd3200000-0xd3201fff 64bit]
Oct 10 18:05:42 localhost kernel: pci 0000:45:00.0: PME# supported from D0 D3hot
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.7: PCI bridge to [bus 45]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.7:   bridge window [mem 0xd3200000-0xd32fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.0: [1180:0832] type 00 class 0x0c0010
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.0: proprietary Ricoh MMC controller disabled (via firewire function)
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.0: MMC cards are now supported by standard SDHCI controller
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.0: reg 10: [mem 0xd3101000-0xd31017ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.0: supports D1 D2
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.0: PME# supported from D0 D1 D2 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.1: [1180:0822] type 00 class 0x080500
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.1: reg 10: [mem 0xd3105000-0xd31050ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.1: supports D1 D2
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.1: PME# supported from D0 D1 D2 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.2: [1180:0592] type 00 class 0x088000
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.2: reg 10: [mem 0xd3103000-0xd31030ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.2: supports D1 D2
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.2: PME# supported from D0 D1 D2 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.3: [1180:0852] type 00 class 0x088000
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.3: reg 10: [mem 0xd3102000-0xd31020ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.3: supports D1 D2
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.3: PME# supported from D0 D1 D2 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: [1180:0476] type 02 class 0x060700
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: reg 10: [mem 0xd3100000-0xd3100fff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: supports D1 D2
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: PME# supported from D0 D1 D2 D3hot D3cold
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0: PCI bridge to [bus 46-47] (subtractive decode)
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xd3100000-0xd31fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfedfffff] (subtractive decode)
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive decode)
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: busn_res: can not insert [bus 47-ff] under [bus 46-47] (conflicts with (null) [bus 46-47])
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: busn_res: [bus 47-ff] end is updated to 4a
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: busn_res: can not insert [bus 47-4a] under [bus 46-47] (conflicts with (null) [bus 46-47])
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: [bus 47-4a] partially hidden behind transparent bridge 0000:46 [bus 46-47]
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
Oct 10 18:05:42 localhost kernel: pci0000:00: Requesting ACPI _OSC control (0x1d)
Oct 10 18:05:42 localhost kernel: pci0000:00: ACPI _OSC control (0x1d) granted
Oct 10 18:05:42 localhost kernel: ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
Oct 10 18:05:42 localhost kernel: PCI host bridge to bus 0000:ff
Oct 10 18:05:42 localhost kernel: pci_bus 0000:ff: root bus resource [bus ff]
Oct 10 18:05:42 localhost kernel: pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
Oct 10 18:05:42 localhost kernel: pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
Oct 10 18:05:42 localhost kernel: pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
Oct 10 18:05:42 localhost kernel: pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
Oct 10 18:05:42 localhost kernel: pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
Oct 10 18:05:42 localhost kernel: pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
Oct 10 18:05:42 localhost kernel: pci0000:ff: ACPI _OSC support notification failed, disabling PCIe ASPM
Oct 10 18:05:42 localhost kernel: pci0000:ff: Unable to request _OSC control (_OSC support mask: 0x08)
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 15)
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Oct 10 18:05:42 localhost kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Oct 10 18:05:42 localhost kernel: vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Oct 10 18:05:42 localhost kernel: vgaarb: loaded
Oct 10 18:05:42 localhost kernel: vgaarb: bridge control possible 0000:01:00.0
Oct 10 18:05:42 localhost kernel: SCSI subsystem initialized
Oct 10 18:05:42 localhost kernel: ACPI: bus type scsi registered
Oct 10 18:05:42 localhost kernel: libata version 3.00 loaded.
Oct 10 18:05:42 localhost kernel: ACPI: bus type usb registered
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver usbfs
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver hub
Oct 10 18:05:42 localhost kernel: usbcore: registered new device driver usb
Oct 10 18:05:42 localhost kernel: Linux video capture interface: v2.00
Oct 10 18:05:42 localhost kernel: wmi: Mapper loaded
Oct 10 18:05:42 localhost kernel: Advanced Linux Sound Architecture Driver Initialized.
Oct 10 18:05:42 localhost kernel: PCI: Using ACPI for IRQ routing
Oct 10 18:05:42 localhost kernel: PCI: pci_cache_line_size set to 64 bytes
Oct 10 18:05:42 localhost kernel: e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
Oct 10 18:05:42 localhost kernel: e820: reserve RAM buffer [mem 0xbefc2000-0xbfffffff]
Oct 10 18:05:42 localhost kernel: e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
Oct 10 18:05:42 localhost kernel: Bluetooth: Core ver 2.16
Oct 10 18:05:42 localhost kernel: NET: Registered protocol family 31
Oct 10 18:05:42 localhost kernel: Bluetooth: HCI device and connection manager initialized
Oct 10 18:05:42 localhost kernel: Bluetooth: HCI socket layer initialized
Oct 10 18:05:42 localhost kernel: Bluetooth: L2CAP socket layer initialized
Oct 10 18:05:42 localhost kernel: Bluetooth: SCO socket layer initialized
Oct 10 18:05:42 localhost kernel: cfg80211: Calling CRDA to update world regulatory domain
Oct 10 18:05:42 localhost kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Oct 10 18:05:42 localhost kernel: hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Oct 10 18:05:42 localhost kernel: Switching to clocksource hpet
Oct 10 18:05:42 localhost kernel: pnp: PnP ACPI init
Oct 10 18:05:42 localhost kernel: ACPI: bus type pnp registered
Oct 10 18:05:42 localhost kernel: pnp 00:00: [bus 00-fe]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [io  0x0000-0x0cf7 window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [io  0x0cf8-0x0cff]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [io  0x0d00-0xffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000a0000-0x000bffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000c0000-0x000c3fff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000c4000-0x000c7fff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000c8000-0x000cbfff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000cc000-0x000cffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000d0000-0x000d3fff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000d4000-0x000d7fff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000d8000-0x000dbfff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000dc000-0x000dffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000e0000-0x000e3fff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000e4000-0x000e7fff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000e8000-0x000ebfff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000ec000-0x000effff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0x000f0000-0x000fffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0xc0000000-0xdfffffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0xf0000000-0xfedfffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: [mem 0xfee01000-0xffffffff window]
Oct 10 18:05:42 localhost kernel: pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfed10000-0xfed13fff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfed1b000-0xfed1bfff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfed19000-0xfed19fff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xd7600000-0xd7600fff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xe0000000-0xefffffff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfed20000-0xfed3ffff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfed90000-0xfed93fff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfed45000-0xfed8ffff]
Oct 10 18:05:42 localhost kernel: pnp 00:01: [mem 0xfec00000-0xfec00fff]
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xd7600000-0xd7600fff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
Oct 10 18:05:42 localhost kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:02: [io  0x0000-0x001f]
Oct 10 18:05:42 localhost kernel: pnp 00:02: [io  0x0081-0x0091]
Oct 10 18:05:42 localhost kernel: pnp 00:02: [io  0x0093-0x009f]
Oct 10 18:05:42 localhost kernel: pnp 00:02: [io  0x00c0-0x00df]
Oct 10 18:05:42 localhost kernel: pnp 00:02: [dma 4]
Oct 10 18:05:42 localhost kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:03: [mem 0xff000000-0xffffffff]
Oct 10 18:05:42 localhost kernel: pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:04: [io  0xfe00-0xfe0f]
Oct 10 18:05:42 localhost kernel: pnp 00:04: [io  0xfe80-0xfe8f]
Oct 10 18:05:42 localhost kernel: pnp 00:04: [mem 0xfed40000-0xfed44fff]
Oct 10 18:05:42 localhost kernel: pnp 00:04: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:05: [mem 0xfed00000-0xfed003ff]
Oct 10 18:05:42 localhost kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:06: [io  0x00f0]
Oct 10 18:05:42 localhost kernel: pnp 00:06: [irq 13]
Oct 10 18:05:42 localhost kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x002e-0x002f]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x004e-0x004f]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0061]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0063]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0065]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0067]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0070]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0080]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0092]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x00b2-0x00b3]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0200-0x027f]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x1000-0x100f]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0xffff]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0xffff]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0400-0x047f]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0x0500-0x057f]
Oct 10 18:05:42 localhost kernel: pnp 00:07: [io  0xef80-0xef9f]
Oct 10 18:05:42 localhost kernel: system 00:07: [io  0x0200-0x027f] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:07: [io  0x1000-0x100f] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:07: [io  0xffff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:07: [io  0xffff] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:07: [io  0x0400-0x047f] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:07: [io  0x0500-0x057f] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:07: [io  0xef80-0xef9f] has been reserved
Oct 10 18:05:42 localhost kernel: system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:08: [io  0x0070-0x0077]
Oct 10 18:05:42 localhost kernel: pnp 00:08: [irq 8]
Oct 10 18:05:42 localhost kernel: pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:09: [io  0x03f8-0x03ff]
Oct 10 18:05:42 localhost kernel: pnp 00:09: [irq 4]
Oct 10 18:05:42 localhost kernel: pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:0a: [io  0x0378-0x037f]
Oct 10 18:05:42 localhost kernel: pnp 00:0a: [io  0x0778-0x077a]
Oct 10 18:05:42 localhost kernel: pnp 00:0a: [irq 5]
Oct 10 18:05:42 localhost kernel: pnp 00:0a: [dma 0 disabled]
Oct 10 18:05:42 localhost kernel: pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:0b: [io  0x0060]
Oct 10 18:05:42 localhost kernel: pnp 00:0b: [io  0x0064]
Oct 10 18:05:42 localhost kernel: pnp 00:0b: [irq 1]
Oct 10 18:05:42 localhost kernel: pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:0c: [irq 12]
Oct 10 18:05:42 localhost kernel: pnp 00:0c: Plug and Play ACPI device, IDs SYN0166 SYN0100 SYN0002 PNP0f13 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:0d: [irq 23]
Oct 10 18:05:42 localhost kernel: pnp 00:0d: Plug and Play ACPI device, IDs HPQ0004 (active)
Oct 10 18:05:42 localhost kernel: pnp 00:0e: [bus ff]
Oct 10 18:05:42 localhost kernel: pnp 00:0e: Plug and Play ACPI device, IDs PNP0a03 (active)
Oct 10 18:05:42 localhost kernel: pnp: PnP ACPI: found 15 devices
Oct 10 18:05:42 localhost kernel: ACPI: ACPI bus type pnp unregistered
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03-43] add_size 200000
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0: bridge window [mem 0x04000000-0x03ffffff pref] to [bus 46-47] add_size 4000000
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0: BAR 9: assigned [mem 0xd8000000-0xdbffffff pref]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1: BAR 9: assigned [mem 0xd7700000-0xd78fffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: BAR 6: assigned [mem 0xd3080000-0xd30fffff pref]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0: PCI bridge to [bus 01]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xd2000000-0xd30fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.0: PCI bridge to [bus 02]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.0:   bridge window [mem 0xd7400000-0xd74fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1: PCI bridge to [bus 03-43]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xd3400000-0xd73fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.1:   bridge window [mem 0xd7700000-0xd78fffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.3: PCI bridge to [bus 44]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.3:   bridge window [mem 0xd3300000-0xd33fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.7: PCI bridge to [bus 45]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1c.7:   bridge window [mem 0xd3200000-0xd32fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: BAR 9: assigned [mem 0xd8000000-0xdbffffff pref]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: BAR 10: assigned [mem 0xdc000000-0xdfffffff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: BAR 7: assigned [io  0x2000-0x20ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: BAR 8: assigned [io  0x2400-0x24ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: CardBus bridge to [bus 47-4a]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4:   bridge window [io  0x2000-0x20ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4:   bridge window [io  0x2400-0x24ff]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4:   bridge window [mem 0xd8000000-0xdbffffff pref]
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4:   bridge window [mem 0xdc000000-0xdfffffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0: PCI bridge to [bus 46-47]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xd3100000-0xd31fffff]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
Oct 10 18:05:42 localhost kernel: pci 0000:00:1e.0: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: pci 0000:46:06.4: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: resource 7 [mem 0xc0000000-0xdfffffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfedfffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:00: resource 9 [mem 0xfee01000-0xffffffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:01: resource 1 [mem 0xd2000000-0xd30fffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:02: resource 1 [mem 0xd7400000-0xd74fffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:03: resource 1 [mem 0xd3400000-0xd73fffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:03: resource 2 [mem 0xd7700000-0xd78fffff 64bit pref]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:44: resource 1 [mem 0xd3300000-0xd33fffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:45: resource 1 [mem 0xd3200000-0xd32fffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 0 [io  0x2000-0x2fff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 1 [mem 0xd3100000-0xd31fffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 2 [mem 0xd8000000-0xdbffffff pref]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 4 [io  0x0000-0x0cf7]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 5 [io  0x0d00-0xffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 6 [mem 0x000a0000-0x000bffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 7 [mem 0xc0000000-0xdfffffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 8 [mem 0xf0000000-0xfedfffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: resource 9 [mem 0xfee01000-0xffffffff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: resource 0 [io  0x2000-0x20ff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: resource 1 [io  0x2400-0x24ff]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: resource 2 [mem 0xd8000000-0xdbffffff pref]
Oct 10 18:05:42 localhost kernel: pci_bus 0000:47: resource 3 [mem 0xdc000000-0xdfffffff]
Oct 10 18:05:42 localhost kernel: NET: Registered protocol family 2
Oct 10 18:05:42 localhost kernel: TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Oct 10 18:05:42 localhost kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Oct 10 18:05:42 localhost kernel: TCP: Hash tables configured (established 524288 bind 65536)
Oct 10 18:05:42 localhost kernel: TCP: reno registered
Oct 10 18:05:42 localhost kernel: UDP hash table entries: 4096 (order: 5, 131072 bytes)
Oct 10 18:05:42 localhost kernel: UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Oct 10 18:05:42 localhost kernel: NET: Registered protocol family 1
Oct 10 18:05:42 localhost kernel: RPC: Registered named UNIX socket transport module.
Oct 10 18:05:42 localhost kernel: RPC: Registered udp transport module.
Oct 10 18:05:42 localhost kernel: RPC: Registered tcp transport module.
Oct 10 18:05:42 localhost kernel: RPC: Registered tcp NFSv4.1 backchannel transport module.
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: Boot video device
Oct 10 18:05:42 localhost kernel: PCI: CLS 64 bytes, default 64
Oct 10 18:05:42 localhost kernel: dmar: Host address width 36
Oct 10 18:05:42 localhost kernel: dmar: DRHD base: 0x000000fed90000 flags: 0x0
Oct 10 18:05:42 localhost kernel: dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
Oct 10 18:05:42 localhost kernel: dmar: DRHD base: 0x000000fed93000 flags: 0x1
Oct 10 18:05:42 localhost kernel: dmar: IOMMU 1: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
Oct 10 18:05:42 localhost kernel: dmar: RMRR base: 0x00000000000000 end: 0x00000000000fff
Oct 10 18:05:42 localhost kernel: DMAR: No ATSR found
Oct 10 18:05:42 localhost kernel: IOMMU 0 0xfed90000: using Register based invalidation
Oct 10 18:05:42 localhost kernel: IOMMU 1 0xfed93000: using Register based invalidation
Oct 10 18:05:42 localhost kernel: IOMMU: Setting RMRR:
Oct 10 18:05:42 localhost kernel: IOMMU: Setting identity map for device 0000:00:1d.0 [0x0 - 0xfff]
Oct 10 18:05:42 localhost kernel: IOMMU: Setting identity map for device 0000:00:1a.0 [0x0 - 0xfff]
Oct 10 18:05:42 localhost kernel: IOMMU: Prepare 0-16MiB unity mapping for LPC
Oct 10 18:05:42 localhost kernel: IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
Oct 10 18:05:42 localhost kernel: PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
Oct 10 18:05:42 localhost kernel: kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
Oct 10 18:05:42 localhost kernel: microcode: CPU0 sig=0x20655, pf=0x10, revision=0x2
Oct 10 18:05:42 localhost kernel: microcode: CPU1 sig=0x20655, pf=0x10, revision=0x2
Oct 10 18:05:42 localhost kernel: microcode: CPU2 sig=0x20655, pf=0x10, revision=0x2
Oct 10 18:05:42 localhost kernel: microcode: CPU3 sig=0x20655, pf=0x10, revision=0x2
Oct 10 18:05:42 localhost kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Oct 10 18:05:42 localhost kernel: audit: initializing netlink socket (disabled)
Oct 10 18:05:42 localhost kernel: type=2000 audit(1349885130.816:1): initialized
Oct 10 18:05:42 localhost kernel: HugeTLB registered 2 MB page size, pre-allocated 0 pages
Oct 10 18:05:42 localhost kernel: NFS: Registering the id_resolver key type
Oct 10 18:05:42 localhost kernel: Key type id_resolver registered
Oct 10 18:05:42 localhost kernel: Key type id_legacy registered
Oct 10 18:05:42 localhost kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Oct 10 18:05:42 localhost kernel: msgmni has been set to 15809
Oct 10 18:05:42 localhost kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
Oct 10 18:05:42 localhost kernel: io scheduler noop registered
Oct 10 18:05:42 localhost kernel: io scheduler deadline registered (default)
Oct 10 18:05:42 localhost kernel: io scheduler cfq registered
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.0: irq 43 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.1: irq 44 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.3: irq 45 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.7: irq 46 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pci 0000:44:00.0: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
Oct 10 18:05:42 localhost kernel: pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pci 0000:45:00.0: Signaling PME through PCIe PME interrupt
Oct 10 18:05:42 localhost kernel: pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
Oct 10 18:05:42 localhost kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Oct 10 18:05:42 localhost kernel: pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 3b44 ss_vid 103c ss_did 1521
Oct 10 18:05:42 localhost kernel: pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
Oct 10 18:05:42 localhost kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Oct 10 18:05:42 localhost kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Oct 10 18:05:42 localhost kernel: acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Oct 10 18:05:42 localhost kernel: intel_idle: MWAIT substates: 0x1120
Oct 10 18:05:42 localhost kernel: intel_idle: v0.4 model 0x25
Oct 10 18:05:42 localhost kernel: intel_idle: lapic_timer_reliable_states 0xffffffff
Oct 10 18:05:42 localhost kernel: ACPI: AC Adapter [AC] (on-line)
Oct 10 18:05:42 localhost kernel: input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
Oct 10 18:05:42 localhost kernel: ACPI: Sleep Button [SLPB]
Oct 10 18:05:42 localhost kernel: input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
Oct 10 18:05:42 localhost kernel: ACPI: Lid Switch [LID]
Oct 10 18:05:42 localhost kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Oct 10 18:05:42 localhost kernel: ACPI: Power Button [PWRF]
Oct 10 18:05:42 localhost kernel: acpi device:04: registered as cooling_device0
Oct 10 18:05:42 localhost kernel: ACPI: Can't attach device
Oct 10 18:05:42 localhost kernel: video: probe of LNXVIDEO:00 failed with error -2
Oct 10 18:05:42 localhost kernel: ACPI: Requesting acpi_cpufreq
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:00: registered as thermal_zone0
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [EXTZ] (58 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:01: registered as thermal_zone1
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [EX2Z] (0 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:02: registered as thermal_zone2
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [PWMZ] (53 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:03: registered as thermal_zone3
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [LOCZ] (49 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:04: registered as thermal_zone4
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [GFXZ] (0 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:05: registered as thermal_zone5
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [BATZ] (37 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:06: registered as thermal_zone6
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [EGXZ] (70 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:07: registered as thermal_zone7
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [CPUZ] (57 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:08: registered as thermal_zone8
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [MCHZ] (61 C)
Oct 10 18:05:42 localhost kernel: thermal LNXTHERM:09: registered as thermal_zone9
Oct 10 18:05:42 localhost kernel: ACPI: Thermal Zone [PCHZ] (74 C)
Oct 10 18:05:42 localhost kernel: ioatdma: Intel(R) QuickData Technology Driver 4.00
Oct 10 18:05:42 localhost kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Oct 10 18:05:42 localhost kernel: 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Oct 10 18:05:42 localhost kernel: 0000:00:16.3: ttyS1 at I/O 0x6050 (irq = 17) is a 16550A
Oct 10 18:05:42 localhost kernel: Non-volatile memory driver v1.3
Oct 10 18:05:42 localhost kernel: Linux agpgart interface v0.103
Oct 10 18:05:42 localhost kernel: Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
Oct 10 18:05:42 localhost kernel: Hangcheck: Using getrawmonotonic().
Oct 10 18:05:42 localhost kernel: [drm] Initialized drm 1.1.0 20060810
Oct 10 18:05:42 localhost kernel: MXM: GUID detected in BIOS
Oct 10 18:05:42 localhost kernel: nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a3e00a2
Oct 10 18:05:42 localhost kernel: nouveau  [  DEVICE][0000:01:00.0] Chipset: GT215 (NVA3)
Oct 10 18:05:42 localhost kernel: nouveau  [  DEVICE][0000:01:00.0] Family : NV50
Oct 10 18:05:42 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
Oct 10 18:05:42 localhost kernel: ACPI: Battery Slot [BAT0] (battery present)
Oct 10 18:05:42 localhost kernel: ACPI: Battery Slot [BAT1] (battery absent)
Oct 10 18:05:42 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
Oct 10 18:05:42 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
Oct 10 18:05:42 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] BIT signature found
Oct 10 18:05:42 localhost kernel: nouveau  [   VBIOS][0000:01:00.0] version 70.15.43.00
Oct 10 18:05:42 localhost kernel: nouveau  [     MXM][0000:01:00.0] BIOS version 3.0
Oct 10 18:05:42 localhost kernel: nouveau  [     MXM][0000:01:00.0] MXMS Version 3.0
Oct 10 18:05:42 localhost kernel: nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
Oct 10 18:05:42 localhost kernel: nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
Oct 10 18:05:42 localhost kernel: tsc: Refined TSC clocksource calibration: 2660.457 MHz
Oct 10 18:05:42 localhost kernel: Switching to clocksource tsc
Oct 10 18:05:42 localhost kernel: [TTM] Zone  kernel: Available graphics memory: 4047240 kiB
Oct 10 18:05:42 localhost kernel: [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
Oct 10 18:05:42 localhost kernel: [TTM] Initializing pool allocator
Oct 10 18:05:42 localhost kernel: [TTM] Initializing DMA pool allocator
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] VRAM: 1024 MiB
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] GART: 512 MiB
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] BIT BIOS found
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] Bios version 70.15.43.00
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] TMDS table version 2.0
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB version 4.0
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 00: 01000313 00010034
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 03: 080153d6 0f220020
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 04: 08015392 00020020
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 05: 080143c6 0f220010
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 06: 08014382 00020010
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 08: 040383b6 0f230014
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 10: 020273a6 0f220010
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 11: 02027362 00020010
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB outp 13: 02049300 00000000
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 00: 00000040
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 01: 00001161
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 02: 00001231
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 03: 01000331
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 04: 01000446
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 05: 02000546
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 06: 00010631
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 07: 00010746
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 08: 00020847
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] DCB conn 09: 00000900
Oct 10 18:05:42 localhost kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Oct 10 18:05:42 localhost kernel: [drm] No driver support for vblank timestamp query.
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] ACPI backlight interface available, not registering our own
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] 3 available performance level(s)
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] 0: core 135MHz shader 270MHz memory 135MHz voltage 800mV
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] 1: core 405MHz shader 810MHz memory 324MHz voltage 850mV
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] 3: core 561MHz shader 1125MHz memory 1099MHz voltage 1000mV
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] c: core 405MHz shader 810MHz memory 324MHz voltage 1000mV
Oct 10 18:05:42 localhost kernel: nouveau  [     DRM] allocated 1680x1050 fb: 0xd0000, bo ffff880231f65c00
Oct 10 18:05:42 localhost kernel: fbcon: nouveaufb (fb0) is primary device
Oct 10 18:05:42 localhost kernel: Console: switching to colour frame buffer device 210x65
Oct 10 18:05:42 localhost kernel: fb0: nouveaufb frame buffer device
Oct 10 18:05:42 localhost kernel: drm: registered panic notifier
Oct 10 18:05:42 localhost kernel: [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 0
Oct 10 18:05:42 localhost kernel: brd: module loaded
Oct 10 18:05:42 localhost kernel: loop: module loaded
Oct 10 18:05:42 localhost kernel: ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
Oct 10 18:05:42 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 10 18:05:42 localhost kernel: ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
Oct 10 18:05:42 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 10 18:05:42 localhost kernel: ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
Oct 10 18:05:42 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 10 18:05:42 localhost kernel: ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
Oct 10 18:05:42 localhost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 10 18:05:42 localhost kernel: lpc_ich: Resource conflict(s) found affecting gpio_ich
Oct 10 18:05:42 localhost kernel: ahci 0000:00:1f.2: version 3.0
Oct 10 18:05:42 localhost kernel: ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: ahci: SSS flag set, parallel bus scan disabled
Oct 10 18:05:42 localhost kernel: ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x37 impl SATA mode
Oct 10 18:05:42 localhost kernel: ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
Oct 10 18:05:42 localhost kernel: ahci 0000:00:1f.2: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: scsi0 : ahci
Oct 10 18:05:42 localhost kernel: scsi1 : ahci
Oct 10 18:05:42 localhost kernel: scsi2 : ahci
Oct 10 18:05:42 localhost kernel: scsi3 : ahci
Oct 10 18:05:42 localhost kernel: scsi4 : ahci
Oct 10 18:05:42 localhost kernel: scsi5 : ahci
Oct 10 18:05:42 localhost kernel: ata1: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527100 irq 47
Oct 10 18:05:42 localhost kernel: ata2: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527180 irq 47
Oct 10 18:05:42 localhost kernel: ata3: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527200 irq 47
Oct 10 18:05:42 localhost kernel: ata4: DUMMY
Oct 10 18:05:42 localhost kernel: ata5: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527300 irq 47
Oct 10 18:05:42 localhost kernel: ata6: SATA max UDMA/133 abar m2048@0xd7527000 port 0xd7527380 irq 47
Oct 10 18:05:42 localhost kernel: r852 0000:46:06.3: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: r852: driver loaded successfully
Oct 10 18:05:42 localhost kernel: tun: Universal TUN/TAP device driver, 1.6
Oct 10 18:05:42 localhost kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Oct 10 18:05:42 localhost kernel: e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
Oct 10 18:05:42 localhost kernel: e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
Oct 10 18:05:42 localhost kernel: e1000e 0000:00:19.0: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Oct 10 18:05:42 localhost kernel: e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 68:b5:99:f2:f0:3d
Oct 10 18:05:42 localhost kernel: e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
Oct 10 18:05:42 localhost kernel: e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: 2052FF-0FF
Oct 10 18:05:42 localhost kernel: Intel(R) Wireless WiFi driver for Linux, in-tree:
Oct 10 18:05:42 localhost kernel: Copyright(c) 2003-2012 Intel Corporation
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: pci_resource_len = 0x00002000
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: pci_resource_base = ffffc900115f0000
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: HW Revision ID = 0x35
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: irq 49 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
Oct 10 18:05:42 localhost kernel: iwldvm: Copyright(c) 2003-2012 Intel Corporation
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver asix
Oct 10 18:05:42 localhost kernel: yenta_cardbus 0000:46:06.4: CardBus bridge found [103c:1521]
Oct 10 18:05:42 localhost kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 10 18:05:42 localhost kernel: ata1.00: unexpected _GTF length (8)
Oct 10 18:05:42 localhost kernel: ata1.00: ATA-8: ST93205620AS, SD28, max UDMA/133
Oct 10 18:05:42 localhost kernel: ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
Oct 10 18:05:42 localhost kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
Oct 10 18:05:42 localhost kernel: ata1.00: unexpected _GTF length (8)
Oct 10 18:05:42 localhost kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
Oct 10 18:05:42 localhost kernel: ata1.00: configured for UDMA/133
Oct 10 18:05:42 localhost kernel: scsi 0:0:0:0: Direct-Access     ATA      ST93205620AS     SD28 PQ: 0 ANSI: 5
Oct 10 18:05:42 localhost kernel: sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
Oct 10 18:05:42 localhost kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct 10 18:05:42 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 10 18:05:42 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 10 18:05:42 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 10 18:05:42 localhost kernel: sda: sda1
Oct 10 18:05:42 localhost kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Oct 10 18:05:42 localhost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct 10 18:05:42 localhost kernel: ata2.00: unexpected _GTF length (8)
Oct 10 18:05:42 localhost kernel: ata2.00: ATAPI: hp BD-ROM BC-5501H, 2.90, max UDMA/100
Oct 10 18:05:42 localhost kernel: ata2.00: unexpected _GTF length (8)
Oct 10 18:05:42 localhost kernel: ata2.00: configured for UDMA/100
Oct 10 18:05:42 localhost kernel: scsi 1:0:0:0: CD-ROM            hp       BD ROM BC-5501H  2.90 PQ: 0 ANSI: 5
Oct 10 18:05:42 localhost kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Oct 10 18:05:42 localhost kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Oct 10 18:05:42 localhost kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
Oct 10 18:05:42 localhost kernel: sr 1:0:0:0: Attached scsi generic sg1 type 5
Oct 10 18:05:42 localhost kernel: ACPI: Invalid Power Resource to register!
Oct 10 18:05:42 localhost kernel: ACPI: Invalid Power Resource to register!<6>ata3: SATA link down (SStatus 0 SControl 300)
Oct 10 18:05:42 localhost kernel: ata5: SATA link down (SStatus 0 SControl 300)
Oct 10 18:05:42 localhost kernel: ata6: SATA link down (SStatus 0 SControl 300)
Oct 10 18:05:42 localhost kernel: yenta_cardbus 0000:46:06.4: ISA IRQ mask 0x0cb8, PCI irq 22
Oct 10 18:05:42 localhost kernel: yenta_cardbus 0000:46:06.4: Socket status: 30000810
Oct 10 18:05:42 localhost kernel: pci_bus 0000:46: Raising subordinate bus# of parent bus (#46) from #47 to #4a
Oct 10 18:05:42 localhost kernel: yenta_cardbus 0000:46:06.4: pcmcia: parent PCI bridge window: [io  0x2000-0x2fff]
Oct 10 18:05:42 localhost kernel: yenta_cardbus 0000:46:06.4: pcmcia: parent PCI bridge window: [mem 0xd3100000-0xd31fffff]
Oct 10 18:05:42 localhost kernel: pcmcia_socket pcmcia_socket0: cs: memory probe 0xd3100000-0xd31fffff:
Oct 10 18:05:42 localhost kernel: excluding 0xd3100000-0xd310ffff
Oct 10 18:05:42 localhost kernel: yenta_cardbus 0000:46:06.4: pcmcia: parent PCI bridge window: [mem 0xd8000000-0xdbffffff pref]
Oct 10 18:05:42 localhost kernel: pcmcia_socket pcmcia_socket0: cs: memory probe 0xd8000000-0xdbffffff:
Oct 10 18:05:42 localhost kernel: excluding 0xd8000000-0xdbffffff
Oct 10 18:05:42 localhost kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1a.0: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1a.0: EHCI Host Controller
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1a.0: debug port 2
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd7529000
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Oct 10 18:05:42 localhost kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Oct 10 18:05:42 localhost kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 10 18:05:42 localhost kernel: usb usb1: Product: EHCI Host Controller
Oct 10 18:05:42 localhost kernel: usb usb1: Manufacturer: Linux 3.7.0-pre ehci_hcd
Oct 10 18:05:42 localhost kernel: usb usb1: SerialNumber: 0000:00:1a.0
Oct 10 18:05:42 localhost kernel: hub 1-0:1.0: USB hub found
Oct 10 18:05:42 localhost kernel: hub 1-0:1.0: 3 ports detected
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1d.0: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1d.0: EHCI Host Controller
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1d.0: debug port 2
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1d.0: irq 20, io mem 0xd7528000
Oct 10 18:05:42 localhost kernel: ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Oct 10 18:05:42 localhost kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Oct 10 18:05:42 localhost kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 10 18:05:42 localhost kernel: usb usb2: Product: EHCI Host Controller
Oct 10 18:05:42 localhost kernel: usb usb2: Manufacturer: Linux 3.7.0-pre ehci_hcd
Oct 10 18:05:42 localhost kernel: usb usb2: SerialNumber: 0000:00:1d.0
Oct 10 18:05:42 localhost kernel: hub 2-0:1.0: USB hub found
Oct 10 18:05:42 localhost kernel: hub 2-0:1.0: 3 ports detected
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: xHCI Host Controller
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: new USB bus registered, assigned bus number 3
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: irq 19, io mem 0xd3200000
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: irq 50 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: irq 51 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: irq 52 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: irq 53 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: irq 54 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
Oct 10 18:05:42 localhost kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 10 18:05:42 localhost kernel: usb usb3: Product: xHCI Host Controller
Oct 10 18:05:42 localhost kernel: usb usb3: Manufacturer: Linux 3.7.0-pre xhci_hcd
Oct 10 18:05:42 localhost kernel: usb usb3: SerialNumber: 0000:45:00.0
Oct 10 18:05:42 localhost kernel: xHCI xhci_add_endpoint called for root hub
Oct 10 18:05:42 localhost kernel: xHCI xhci_check_bandwidth called for root hub
Oct 10 18:05:42 localhost kernel: hub 3-0:1.0: USB hub found
Oct 10 18:05:42 localhost kernel: hub 3-0:1.0: 2 ports detected
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: xHCI Host Controller
Oct 10 18:05:42 localhost kernel: xhci_hcd 0000:45:00.0: new USB bus registered, assigned bus number 4
Oct 10 18:05:42 localhost kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
Oct 10 18:05:42 localhost kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 10 18:05:42 localhost kernel: usb usb4: Product: xHCI Host Controller
Oct 10 18:05:42 localhost kernel: usb usb4: Manufacturer: Linux 3.7.0-pre xhci_hcd
Oct 10 18:05:42 localhost kernel: usb usb4: SerialNumber: 0000:45:00.0
Oct 10 18:05:42 localhost kernel: xHCI xhci_add_endpoint called for root hub
Oct 10 18:05:42 localhost kernel: xHCI xhci_check_bandwidth called for root hub
Oct 10 18:05:42 localhost kernel: hub 4-0:1.0: USB hub found
Oct 10 18:05:42 localhost kernel: hub 4-0:1.0: 2 ports detected
Oct 10 18:05:42 localhost kernel: Initializing USB Mass Storage driver...
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver usb-storage
Oct 10 18:05:42 localhost kernel: USB Mass Storage support registered.
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver usbserial
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver usbserial_generic
Oct 10 18:05:42 localhost kernel: usbserial: USB Serial support registered for generic
Oct 10 18:05:42 localhost kernel: i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Oct 10 18:05:42 localhost kernel: i8042: Detected active multiplexing controller, rev 1.1
Oct 10 18:05:42 localhost kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 10 18:05:42 localhost kernel: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Oct 10 18:05:42 localhost kernel: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Oct 10 18:05:42 localhost kernel: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Oct 10 18:05:42 localhost kernel: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Oct 10 18:05:42 localhost kernel: mousedev: PS/2 mouse device common for all mice
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver synaptics_usb
Oct 10 18:05:42 localhost kernel: rtc_cmos 00:08: RTC can wake from S4
Oct 10 18:05:42 localhost kernel: rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
Oct 10 18:05:42 localhost kernel: rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
Oct 10 18:05:42 localhost kernel: i2c /dev entries driver
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver uvcvideo
Oct 10 18:05:42 localhost kernel: USB Video Class driver (1.1.1)
Oct 10 18:05:42 localhost kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
Oct 10 18:05:42 localhost kernel: iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x0460)
Oct 10 18:05:42 localhost kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Oct 10 18:05:42 localhost kernel: iTCO_vendor_support: vendor-support=0
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver btusb
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver ath3k
Oct 10 18:05:42 localhost kernel: EDAC MC: Ver: 3.0.0
Oct 10 18:05:42 localhost kernel: cpuidle: using governor ladder
Oct 10 18:05:42 localhost kernel: cpuidle: using governor menu
Oct 10 18:05:42 localhost kernel: sdhci: Secure Digital Host Controller Interface driver
Oct 10 18:05:42 localhost kernel: sdhci: Copyright(c) Pierre Ossman
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: SDHCI controller found [1180:0822] (rev 25)
Oct 10 18:05:42 localhost kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 10 18:05:42 localhost kernel: Registered led device: mmc0::
Oct 10 18:05:42 localhost kernel: mmc0: SDHCI controller on PCI [0000:46:06.1] using DMA
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver ushc
Oct 10 18:05:42 localhost kernel: r592 0000:46:06.2: setting latency timer to 64
Oct 10 18:05:42 localhost kernel: r592: driver successfully loaded
Oct 10 18:05:42 localhost kernel: EFI Variables Facility v0.08 2004-May-17
Oct 10 18:05:42 localhost kernel: usbcore: registered new interface driver usbhid
Oct 10 18:05:42 localhost kernel: usbhid: USB HID core driver
Oct 10 18:05:42 localhost kernel: hp_accel: hardware type NC854xx found
Oct 10 18:05:42 localhost kernel: lis3lv02d: 8 bits sensor found
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 10 18:05:42 localhost kernel: input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input4
Oct 10 18:05:42 localhost kernel: Registered led device: hp::hddprotect
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 10 18:05:42 localhost kernel: usb 1-1: new high-speed USB device number 2 using ehci_hcd
Oct 10 18:05:42 localhost kernel: sdhci-pci 0000:46:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
Oct 10 18:05:42 localhost kernel: usb 1-1: New USB device found, idVendor=8087, idProduct=0020
Oct 10 18:05:42 localhost kernel: usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 10 18:05:42 localhost kernel: hub 1-1:1.0: USB hub found
Oct 10 18:05:42 localhost kernel: hub 1-1:1.0: 6 ports detected
Oct 10 18:05:42 localhost kernel: input: HP WMI hotkeys as /devices/virtual/input/input5
Oct 10 18:05:42 localhost kernel: usb 2-1: new high-speed USB device number 2 using ehci_hcd
Oct 10 18:05:42 localhost kernel: usb 2-1: New USB device found, idVendor=8087, idProduct=0020
Oct 10 18:05:42 localhost kernel: usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 10 18:05:42 localhost kernel: hub 2-1:1.0: USB hub found
Oct 10 18:05:42 localhost kernel: hub 2-1:1.0: 8 ports detected
Oct 10 18:05:42 localhost kernel: usb 1-1.1: new full-speed USB device number 3 using ehci_hcd
Oct 10 18:05:42 localhost kernel: pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
Oct 10 18:05:42 localhost kernel: pcmcia_socket pcmcia_socket0: cs: memory probe 0xd3110000-0xd31fffff:
Oct 10 18:05:42 localhost kernel: excluding 0xd31fe000-0xd320bfff
Oct 10 18:05:42 localhost kernel: pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 22)
Oct 10 18:05:42 localhost kernel: usb 1-1.1: New USB device found, idVendor=03f0, idProduct=231d
Oct 10 18:05:42 localhost kernel: usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct 10 18:05:42 localhost kernel: usb 1-1.1: Product: HP Integrated Module
Oct 10 18:05:42 localhost kernel: usb 1-1.1: Manufacturer: Broadcom Corp
Oct 10 18:05:42 localhost kernel: input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input6
Oct 10 18:05:42 localhost kernel: snd_hda_intel 0000:00:1b.0: irq 55 for MSI/MSI-X
Oct 10 18:05:42 localhost kernel: hda-codec: No codec parser is available
Oct 10 18:05:42 localhost kernel: usb 1-1.3: new full-speed USB device number 4 using ehci_hcd
Oct 10 18:05:42 localhost kernel: usb 1-1.3: New USB device found, idVendor=138a, idProduct=0007
Oct 10 18:05:42 localhost kernel: usb 1-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
Oct 10 18:05:42 localhost kernel: usb 1-1.3: SerialNumber: 0030b05b7486
Oct 10 18:05:42 localhost kernel: usb 1-1.4: new high-speed USB device number 5 using ehci_hcd
Oct 10 18:05:42 localhost kernel: usb 1-1.4: New USB device found, idVendor=0424, idProduct=2514
Oct 10 18:05:42 localhost kernel: usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 10 18:05:42 localhost kernel: hub 1-1.4:1.0: USB hub found
Oct 10 18:05:42 localhost kernel: hub 1-1.4:1.0: 4 ports detected
Oct 10 18:05:42 localhost kernel: usb 1-1.5: new high-speed USB device number 6 using ehci_hcd
Oct 10 18:05:42 localhost kernel: usb 1-1.5: New USB device found, idVendor=04f2, idProduct=b15e
Oct 10 18:05:42 localhost kernel: usb 1-1.5: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Oct 10 18:05:42 localhost kernel: usb 1-1.5: Product: HP Webcam [2 MP Macro]
Oct 10 18:05:42 localhost kernel: usb 1-1.5: Manufacturer: Chicony Electronics Co., Ltd.
Oct 10 18:05:42 localhost kernel: uvcvideo: Found UVC 1.00 device HP Webcam [2 MP Macro] (04f2:b15e)
Oct 10 18:05:42 localhost kernel: usb 1-1.4.3: new low-speed USB device number 7 using ehci_hcd
Oct 10 18:05:42 localhost kernel: psmouse serio4: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd44773/0xa40000/0xa0000, board id: 3655, fw id: 651432
Oct 10 18:05:42 localhost kernel: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
Oct 10 18:05:42 localhost kernel: usb 1-1.4.3: New USB device found, idVendor=046d, idProduct=c30e
Oct 10 18:05:42 localhost kernel: usb 1-1.4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct 10 18:05:42 localhost kernel: usb 1-1.4.3: Product: HID compliant keyboard
Oct 10 18:05:42 localhost kernel: usb 1-1.4.3: Manufacturer: Logitech
Oct 10 18:05:42 localhost kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4.3/1-1.4.3:1.0/input/input8
Oct 10 18:05:42 localhost kernel: hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.4.3/input0
Oct 10 18:05:42 localhost kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4.3/1-1.4.3:1.1/input/input9
Oct 10 18:05:42 localhost kernel: hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.4.3/input1
Oct 10 18:05:42 localhost kernel: usb 1-1.4.4: new low-speed USB device number 8 using ehci_hcd
Oct 10 18:05:42 localhost kernel: usb 1-1.4.4: New USB device found, idVendor=046d, idProduct=c03f
Oct 10 18:05:42 localhost kernel: usb 1-1.4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct 10 18:05:42 localhost kernel: usb 1-1.4.4: Product: USB-PS/2 Optical Mouse
Oct 10 18:05:42 localhost kernel: usb 1-1.4.4: Manufacturer: Logitech
Oct 10 18:05:42 localhost kernel: input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4.4/1-1.4.4:1.0/input/input10
Oct 10 18:05:42 localhost kernel: hid-generic 0003:046D:C03F.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.4.4/input0
Oct 10 18:05:42 localhost kernel: input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
Oct 10 18:05:42 localhost kernel: input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
Oct 10 18:05:42 localhost kernel: input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
Oct 10 18:05:42 localhost kernel: input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
Oct 10 18:05:42 localhost kernel: hda_intel: Disabling MSI
Oct 10 18:05:42 localhost kernel: hda-codec: No codec parser is available
Oct 10 18:05:42 localhost kernel: hda-codec: No codec parser is available
Oct 10 18:05:42 localhost kernel: hda-codec: No codec parser is available
Oct 10 18:05:42 localhost kernel: hda-codec: No codec parser is available
Oct 10 18:05:42 localhost kernel: u32 classifier
Oct 10 18:05:42 localhost kernel: Netfilter messages via NETLINK v0.30.
Oct 10 18:05:42 localhost kernel: nfnl_acct: registering with nfnetlink.
Oct 10 18:05:42 localhost kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Oct 10 18:05:42 localhost kernel: ctnetlink v0.93: registering with nfnetlink.
Oct 10 18:05:42 localhost kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Oct 10 18:05:42 localhost kernel: TCP: cubic registered
Oct 10 18:05:42 localhost kernel: Initializing XFRM netlink socket
Oct 10 18:05:42 localhost kernel: NET: Registered protocol family 10
Oct 10 18:05:42 localhost kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
Oct 10 18:05:42 localhost kernel: NET: Registered protocol family 17
Oct 10 18:05:42 localhost kernel: NET: Registered protocol family 15
Oct 10 18:05:42 localhost kernel: Bridge firewalling registered
Oct 10 18:05:42 localhost kernel: Bluetooth: RFCOMM socket layer initialized
Oct 10 18:05:42 localhost kernel: Bluetooth: RFCOMM ver 1.11
Oct 10 18:05:42 localhost kernel: Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Oct 10 18:05:42 localhost kernel: Bluetooth: HIDP socket layer initialized
Oct 10 18:05:42 localhost kernel: 8021q: 802.1Q VLAN Support v1.8
Oct 10 18:05:42 localhost kernel: Key type dns_resolver registered
Oct 10 18:05:42 localhost kernel: registered taskstats version 1
Oct 10 18:05:42 localhost kernel: rtc_cmos 00:08: setting system clock to 2012-10-10 16:05:37 UTC (1349885137)
Oct 10 18:05:42 localhost kernel: ALSA device list:
Oct 10 18:05:42 localhost kernel: #0: HDA Intel MID at 0xd7520000 irq 55
Oct 10 18:05:42 localhost kernel: #1: HDA NVidia at 0xd3000000 irq 17
Oct 10 18:05:42 localhost kernel: EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Oct 10 18:05:42 localhost kernel: VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
Oct 10 18:05:42 localhost kernel: devtmpfs: mounted
Oct 10 18:05:42 localhost kernel: Freeing unused kernel memory: 832k freed
Oct 10 18:05:42 localhost udevd[1451]: starting version 171
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: loaded firmware version 9.221.4.1 build 25532
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUG disabled
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_P2P disabled
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: L1 Disabled; Enabling L0S
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: RF_KILL bit toggled to disable radio.
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: device EEPROM VER=0x436, CALIB=0x6
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: Device SKU: 0x1F0
Oct 10 18:05:42 localhost kernel: iwlwifi 0000:44:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
Oct 10 18:05:42 localhost kernel: Registered led device: phy0-led
Oct 10 18:05:42 localhost kernel: ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
Oct 10 18:05:42 localhost kernel: microcode: CPU0 updated to revision 0x3, date = 2011-09-01
Oct 10 18:05:42 localhost kernel: microcode: CPU1 updated to revision 0x3, date = 2011-09-01
Oct 10 18:05:42 localhost kernel: microcode: CPU2 updated to revision 0x3, date = 2011-09-01
Oct 10 18:05:42 localhost kernel: microcode: CPU3 updated to revision 0x3, date = 2011-09-01
Oct 10 18:05:42 localhost kernel: EXT4-fs (sda1): re-mounted. Opts: (null)
Oct 10 18:05:42 localhost kernel: tty_init_dev: 34 callbacks suppressed
Oct 10 18:05:44 localhost kernel: e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
Oct 10 18:05:44 localhost kernel: e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
Oct 10 18:05:44 localhost kernel: IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
Oct 10 18:05:47 localhost kernel: e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
Oct 10 18:05:47 localhost kernel: IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Oct 10 18:05:47 localhost kernel: nf_conntrack: automatic helper assignment is deprecated and it will be removed soon. Use the iptables CT target to attach helpers instead.
Oct 10 18:05:49 localhost kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
Oct 10 18:05:49 localhost kernel: IP: [<ffffffff8144082e>] nouveau_channel_new+0x41e/0x670
Oct 10 18:05:49 localhost kernel: PGD 22ddd7067 PUD 22f76f067 PMD 0 
Oct 10 18:05:49 localhost kernel: Oops: 0000 [#1] PREEMPT SMP 
Oct 10 18:05:49 localhost kernel: Modules linked in:
Oct 10 18:05:49 localhost kernel: CPU 0 
Oct 10 18:05:49 localhost kernel: Pid: 2723, comm: X Not tainted 3.7.0-pre #1 Hewlett-Packard HP EliteBook 8540w/1521
Oct 10 18:05:49 localhost kernel: RIP: 0010:[<ffffffff8144082e>]  [<ffffffff8144082e>] nouveau_channel_new+0x41e/0x670
Oct 10 18:05:49 localhost kernel: RSP: 0018:ffff88023026bc68  EFLAGS: 00010202
Oct 10 18:05:49 localhost kernel: RAX: 0000000000000000 RBX: ffff88022ceeca80 RCX: 0000000000000088
Oct 10 18:05:49 localhost kernel: RDX: ffffc900127e408c RSI: ffffc900127e408c RDI: ffff88022ceeca80
Oct 10 18:05:49 localhost kernel: RBP: ffff88023026bce8 R08: 000000000000ffff R09: 0000000000000000
Oct 10 18:05:49 localhost kernel: R10: 0000000000000010 R11: 000000000000000f R12: 0000000000000000
Oct 10 18:05:49 localhost kernel: R13: ffff880231f36800 R14: ffff88022f68ca00 R15: ffff88022f68ca00
Oct 10 18:05:49 localhost kernel: FS:  00007f129a597880(0000) GS:ffff88023bc00000(0000) knlGS:0000000000000000
Oct 10 18:05:49 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct 10 18:05:49 localhost kernel: CR2: 0000000000000018 CR3: 00000002300a1000 CR4: 00000000000007f0
Oct 10 18:05:49 localhost kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 10 18:05:49 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 10 18:05:49 localhost kernel: Process X (pid: 2723, threadinfo ffff88023026a000, task ffff880231edbde0)
Oct 10 18:05:49 localhost kernel: Stack:
Oct 10 18:05:49 localhost kernel: ffff88023026bcb0 ffff88022f68ca00 ffff88022f68caa8 ffff8802311be9c0
Oct 10 18:05:49 localhost kernel: d8000001d8000002 ffff88023026bc98 0000200000000000 0000000000000000
Oct 10 18:05:49 localhost kernel: 000000ffffffffff ffff880231f9afa0 ffffffffffffffff ffff8802323c0840
Oct 10 18:05:49 localhost kernel: Call Trace:
Oct 10 18:05:49 localhost kernel: [<ffffffff81448cbc>] nouveau_abi16_ioctl_channel_alloc+0x15c/0x360
Oct 10 18:05:49 localhost kernel: [<ffffffff813a9120>] drm_ioctl+0x2a0/0x4f0
Oct 10 18:05:49 localhost kernel: [<ffffffff81448b60>] ? nouveau_abi16_ioctl_setparam+0x10/0x10
Oct 10 18:05:49 localhost kernel: [<ffffffff81076be4>] ? __do_page_fault+0x1c4/0x490
Oct 10 18:05:49 localhost kernel: [<ffffffff81198eb7>] do_vfs_ioctl+0x97/0x4f0
Oct 10 18:05:49 localhost kernel: [<ffffffff81199367>] sys_ioctl+0x57/0x90
Oct 10 18:05:49 localhost kernel: [<ffffffff818635a2>] system_call_fastpath+0x16/0x1b
Oct 10 18:05:49 localhost kernel: Code: e2 02 48 89 df e8 d3 02 00 00 8b 83 80 00 00 00 89 83 84 00 00 00 0f 1f 80 00 00 00 00 48 8b 43 08 48 89 df 48 8b 80 f8 06 00 00 <ff> 50 18 41 89 c4 85 c0 0f 84 65 fd ff ff 0f 1f 40 00 4c 89 ff 
Oct 10 18:05:49 localhost kernel: RIP  [<ffffffff8144082e>] nouveau_channel_new+0x41e/0x670
Oct 10 18:05:49 localhost kernel: RSP <ffff88023026bc68>
Oct 10 18:05:49 localhost kernel: CR2: 0000000000000018
Oct 10 18:05:49 localhost kernel: ---[ end trace e23ae1067c361c88 ]---
Oct 10 18:05:49 localhost kernel: [drm:drm_release] *ERROR* Device busy: 1
Oct 10 18:05:49 localhost kdm[2711]: X server died during startup
Oct 10 18:05:49 localhost kdm[2711]: X server for display :0 cannot be started, session disabled

--------------010406030907060703080303--
