Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab0IKTTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:19:50 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:56812 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750977Ab0IKTTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:19:46 -0400
X-Greylist: delayed 1977 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Sep 2010 15:19:45 EDT
Date: Sat, 11 Sep 2010 22:46:46 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: i915 blank screen and crash
Message-ID: <20100911184646.GA27154@ioremap.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David.

I use the latest git tree as well as 2.6.35, 2.6.32 (both ubuntu lucid)
and various 26-rc candidates with the same problem on Dell E4310 laptop:
screen blanks when getting to X start. System works ok, but without
screen (switch to text console does not help).

If I add 'i915.nomodeset xforcevese nomodeset' screen still blanks but
kernel panics. Unfortunately I can not connect it to any other computer
to get netconsole dump.

If I add 'i915.nomodeset xforcevese nomodeset single' kernel command
line then X can be started 'manually' in a failsafe mode (there is a
ncurses screen in ubuntu for that).

I read a lot of internets about this problem but neither solution helps
in my case. I added a small debug to intel_dp_link_required(), which
prints some params, namely whether device is edp/pch, pixel clocks and
returned value for the case when both edp and pch are set, which is not
the case for my hardware: pch is not set.

I attach dmesg and X log for successful failsafe start, hope it will
help.

Thank you.

-- 
	Evgeniy Polyakov

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc3-git3-zbr (root@gavana) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #6 SMP Sat Sep 11 20:52:04 MSD 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc3-git3-zbr root=UUID=3e0770ae-e3de-4db5-9c15-2a058ad91585 ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
[    0.000000]  BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000db65f000 (usable)
[    0.000000]  BIOS-e820: 00000000db65f000 - 00000000db67f000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000db67f000 - 00000000db76f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000db76f000 - 00000000dc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000dde00000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x11c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 100000000 mask FE0000000 write-back
[    0.000000]   5 base 11C000000 mask FFC000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dc000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdb65f max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ac00 (usable)
[    0.000000]  modified: 000000000009ac00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000db65f000 (usable)
[    0.000000]  modified: 00000000db65f000 - 00000000db67f000 (ACPI data)
[    0.000000]  modified: 00000000db67f000 - 00000000db76f000 (ACPI NVS)
[    0.000000]  modified: 00000000db76f000 - 00000000dc000000 (reserved)
[    0.000000]  modified: 00000000dde00000 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 000000011c000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f2280] f2280
[    0.000000] init_memory_mapping: 0000000000000000-00000000db65f000
[    0.000000]  0000000000 - 00db600000 page 2M
[    0.000000]  00db600000 - 00db65f000 page 4k
[    0.000000] kernel direct mapping tables up to db65f000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-000000011c000000
[    0.000000]  0100000000 - 011c000000 page 2M
[    0.000000] kernel direct mapping tables up to 11c000000 @ 1a000-20000
[    0.000000] RAMDISK: 37261000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000db67de18 0005C (v01 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000db75fc18 000F4 (v04 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20100702/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xDB76BF40/0x00000000DB76ED40, using 32 (20100702/tbfadt-486)
[    0.000000] ACPI: DSDT 00000000db750018 09760 (v01 DELL    E2      00001001 INTL 20080729)
[    0.000000] ACPI: FACS 00000000db76bf40 00040
[    0.000000] ACPI: APIC 00000000db67cf18 0008C (v02 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: MCFG 00000000db76dd18 0003C (v01 A M I  GMCH945. 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000db76dc98 00038 (v01 DELL    E2      00000001 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000db76dc18 00028 (v01 DELL   E2       06222004 AMI  00010013)
[    0.000000] ACPI: SLIC 00000000db766818 00176 (v03 DELL    E2      06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000db75e018 009F1 (v01  PmRef    CpuPm 00003000 INTL 20080729)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000011c000000
[    0.000000] Initmem setup node 0 0000000000000000-000000011c000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880100200000-ffff880103bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0011c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009a
[    0.000000]     0: 0x00000100 -> 0x000db65f
[    0.000000]     0: 0x00100000 -> 0x0011c000
[    0.000000] On node 0 totalpages: 1013225
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 880279 pages, LIFO batch:31
[    0.000000]   Normal zone: 1568 pages used for memmap
[    0.000000]   Normal zone: 113120 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1b000 - 1b7ff]
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 000000000009b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000db65f000 - 00000000db67f000
[    0.000000] PM: Registered nosave memory: 00000000db67f000 - 00000000db76f000
[    0.000000] PM: Registered nosave memory: 00000000db76f000 - 00000000dc000000
[    0.000000] PM: Registered nosave memory: 00000000dc000000 - 00000000dde00000
[    0.000000] PM: Registered nosave memory: 00000000dde00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880001e00000 s88384 r8192 d22208 u262144
[    0.000000] early_res array is doubled to 128 at [1b800 - 1c7ff]
[    0.000000] pcpu-alloc: s88384 r8192 d22208 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 997321
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc3-git3-zbr root=UUID=3e0770ae-e3de-4db5-9c15-2a058ad91585 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (65 early reservations)
[    0.000000]   #1 [0001000000 - 0001d14960]   TEXT DATA BSS
[    0.000000]   #2 [0037261000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d15000 - 0001d15251]             BRK
[    0.000000]   #4 [000009ac00 - 00000f2280]   BIOS reserved
[    0.000000]   #5 [00000f2280 - 00000f2290]    MP-table mpf
[    0.000000]   #6 [00000f2438 - 0000100000]   BIOS reserved
[    0.000000]   #7 [00000f2290 - 00000f2438]    MP-table mpc
[    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #9 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #10 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #11 [000001a000 - 000001b000]         PGTABLE
[    0.000000]   #12 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #13 [0001d15280 - 0001d16280]         BOOTMEM
[    0.000000]   #14 [0001d14980 - 0001d14c80]         BOOTMEM
[    0.000000]   #15 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #16 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #17 [0100200000 - 0103c00000]        MEMMAP 0
[    0.000000]   #18 [0001d14c80 - 0001d14e00]         BOOTMEM
[    0.000000]   #19 [0001d16280 - 0001d2e280]         BOOTMEM
[    0.000000]   #20 [0001d2e280 - 0001d31280]         BOOTMEM
[    0.000000]   #21 [0001d32000 - 0001d33000]         BOOTMEM
[    0.000000]   #22 [0001d14e00 - 0001d14e41]         BOOTMEM
[    0.000000]   #23 [0001d14e80 - 0001d14ec3]         BOOTMEM
[    0.000000]   #24 [0001d31280 - 0001d31638]         BOOTMEM
[    0.000000]   #25 [0001d14f00 - 0001d14f68]         BOOTMEM
[    0.000000]   #26 [0001d14f80 - 0001d14fe8]         BOOTMEM
[    0.000000]   #27 [0001d31640 - 0001d316a8]         BOOTMEM
[    0.000000]   #28 [0001d316c0 - 0001d31728]         BOOTMEM
[    0.000000]   #29 [0001d31740 - 0001d317a8]         BOOTMEM
[    0.000000]   #30 [0001d317c0 - 0001d31828]         BOOTMEM
[    0.000000]   #31 [0001d31840 - 0001d318a8]         BOOTMEM
[    0.000000]   #32 [0001d318c0 - 0001d31928]         BOOTMEM
[    0.000000]   #33 [0001d31940 - 0001d319a8]         BOOTMEM
[    0.000000]   #34 [0001d319c0 - 0001d31a28]         BOOTMEM
[    0.000000]   #35 [0001d31a40 - 0001d31aa8]         BOOTMEM
[    0.000000]   #36 [0001d31ac0 - 0001d31b28]         BOOTMEM
[    0.000000]   #37 [0001d31b40 - 0001d31ba8]         BOOTMEM
[    0.000000]   #38 [0001d31bc0 - 0001d31c28]         BOOTMEM
[    0.000000]   #39 [0001d31c40 - 0001d31ca8]         BOOTMEM
[    0.000000]   #40 [0001d31cc0 - 0001d31d28]         BOOTMEM
[    0.000000]   #41 [0001d31d40 - 0001d31d60]         BOOTMEM
[    0.000000]   #42 [0001d31d80 - 0001d31da0]         BOOTMEM
[    0.000000]   #43 [0001d31dc0 - 0001d31e1f]         BOOTMEM
[    0.000000]   #44 [0001d31e40 - 0001d31e9f]         BOOTMEM
[    0.000000]   #45 [0001e00000 - 0001e1d000]         BOOTMEM
[    0.000000]   #46 [0001e40000 - 0001e5d000]         BOOTMEM
[    0.000000]   #47 [0001e80000 - 0001e9d000]         BOOTMEM
[    0.000000]   #48 [0001ec0000 - 0001edd000]         BOOTMEM
[    0.000000]   #49 [0001f00000 - 0001f1d000]         BOOTMEM
[    0.000000]   #50 [0001f40000 - 0001f5d000]         BOOTMEM
[    0.000000]   #51 [0001f80000 - 0001f9d000]         BOOTMEM
[    0.000000]   #52 [0001fc0000 - 0001fdd000]         BOOTMEM
[    0.000000]   #53 [0001d31ec0 - 0001d31ec8]         BOOTMEM
[    0.000000]   #54 [0001d31f00 - 0001d31f08]         BOOTMEM
[    0.000000]   #55 [0001d31f40 - 0001d31f60]         BOOTMEM
[    0.000000]   #56 [0001d31f80 - 0001d31fc0]         BOOTMEM
[    0.000000]   #57 [0001d35000 - 0001d35120]         BOOTMEM
[    0.000000]   #58 [0001d35140 - 0001d35188]         BOOTMEM
[    0.000000]   #59 [0001d351c0 - 0001d35208]         BOOTMEM
[    0.000000]   #60 [0001d35240 - 0001d3d240]         BOOTMEM
[    0.000000]   #61 [0001fdd000 - 0005fdd000]         BOOTMEM
[    0.000000]   #62 [0001d3d240 - 0001d5d240]         BOOTMEM
[    0.000000]   #63 [0001d5d240 - 0001d9d240]         BOOTMEM
[    0.000000]   #64 [000001c800 - 0000024800]         BOOTMEM
[    0.000000] Memory: 3899116k/4653056k available (5657k kernel code, 600156k absent, 153784k reserved, 5412k data, 900k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2527.282 MHz processor.
[    0.000008] Calibrating delay loop (skipped), value calculated using timer frequency.. 5054.56 BogoMIPS (lpj=25272820)
[    0.000121] pid_max: default: 32768 minimum: 301
[    0.000192] Security Framework initialized
[    0.000259] AppArmor: AppArmor initialized
[    0.000660] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001691] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002157] Mount-cache hash table entries: 256
[    0.002311] Initializing cgroup subsys ns
[    0.002367] Initializing cgroup subsys cpuacct
[    0.002423] Initializing cgroup subsys memory
[    0.002483] Initializing cgroup subsys devices
[    0.002537] Initializing cgroup subsys freezer
[    0.002591] Initializing cgroup subsys net_cls
[    0.002666] CPU: Physical Processor ID: 0
[    0.002719] CPU: Processor Core ID: 0
[    0.002775] mce: CPU supports 9 MCE banks
[    0.002834] CPU0: Thermal monitoring handled by SMI
[    0.002841] using mwait in idle threads.
[    0.002894] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.003046] ... version:                3
[    0.003099] ... bit width:              48
[    0.003152] ... generic registers:      4
[    0.003204] ... value mask:             0000ffffffffffff
[    0.003260] ... max period:             000000007fffffff
[    0.003314] ... fixed-purpose events:   3
[    0.003369] ... event mask:             000000070000000f
[    0.005269] ACPI: Core revision 20100702
[    0.017666] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.017733] ftrace: allocating 21467 entries in 85 pages
[    0.023833] Setting APIC routing to flat
[    0.024210] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.124237] CPU0: Intel(R) Core(TM) i5 CPU       M 540  @ 2.53GHz stepping 02
[    0.244407] Booting Node   0, Processors  #1
[    0.404193] CPU1: Thermal monitoring handled by SMI
[    0.424399]  #2
[    0.584093] CPU2: Thermal monitoring handled by SMI
[    0.604234]  #3
[    0.763991] CPU3: Thermal monitoring handled by SMI
[    0.784109] Brought up 4 CPUs
[    0.784219] Total of 4 processors activated (20216.48 BogoMIPS).
[    0.785842] devtmpfs: initialized
[    0.786711] regulator: core version 0.5
[    0.786796] Time: 17:00:14  Date: 09/11/10
[    0.786882] NET: Registered protocol family 16
[    0.787017] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.787111] ACPI: bus type pci registered
[    0.787232] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.787335] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.793928] PCI: Using configuration type 1 for base access
[    0.794498] bio: create slab <bio-0> at 0
[    0.795879] ACPI: EC: Look up EC in DSDT
[    0.802569] ACPI: BIOS _OSI(Linux) query ignored
[    0.814090] ACPI: BIOS _OSI(Linux) query ignored
[    0.820221] ACPI: SSDT 00000000db7ea918 00432 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.820665] ACPI: Dynamic OEM Table Load:
[    0.820773] ACPI: SSDT (null) 00432 (v01  PmRef  Cpu0Ist 00003000 INTL 20080729)
[    0.821269] ACPI: SSDT 00000000db7e8018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.821692] ACPI: Dynamic OEM Table Load:
[    0.821801] ACPI: SSDT (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20080729)
[    0.822334] ACPI: SSDT 00000000db7e9a98 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.822813] ACPI: Dynamic OEM Table Load:
[    0.822923] ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20080729)
[    0.823197] ACPI: SSDT 00000000db7e7d98 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.823647] ACPI: Dynamic OEM Table Load:
[    0.823755] ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20080729)
[    0.825704] ACPI: Interpreter enabled
[    0.825763] ACPI: (supports S0 S3 S4 S5)
[    0.825940] ACPI: Using IOAPIC for interrupt routing
[    0.839365] ACPI: EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    0.840296] ACPI: No dock devices found.
[    0.840359] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.841131] \_SB_.PCI0:_OSC invalid UUID
[    0.841133] _OSC request data:1 8 1f 
[    0.841136] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.842386] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.842454] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.842523] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.842620] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfeafffff]
[    0.842757] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.842763] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.842767] pci 0000:00:02.0: reg 20: [io  0x60b0-0x60b7]
[    0.842852] pci 0000:00:19.0: reg 10: [mem 0xf5400000-0xf541ffff]
[    0.842863] pci 0000:00:19.0: reg 14: [mem 0xf5480000-0xf5480fff]
[    0.842874] pci 0000:00:19.0: reg 18: [io  0x6040-0x605f]
[    0.842943] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.842947] pci 0000:00:19.0: PME# disabled
[    0.842998] pci 0000:00:1a.0: reg 10: [mem 0xf5470000-0xf54703ff]
[    0.843083] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.843088] pci 0000:00:1a.0: PME# disabled
[    0.843135] pci 0000:00:1b.0: reg 10: [mem 0xf5460000-0xf5463fff 64bit]
[    0.843210] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.843214] pci 0000:00:1b.0: PME# disabled
[    0.843314] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.843318] pci 0000:00:1c.0: PME# disabled
[    0.843419] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.843424] pci 0000:00:1c.1: PME# disabled
[    0.843525] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.843529] pci 0000:00:1c.2: PME# disabled
[    0.843633] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.843637] pci 0000:00:1c.3: PME# disabled
[    0.843697] pci 0000:00:1d.0: reg 10: [mem 0xf5450000-0xf54503ff]
[    0.843783] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.843787] pci 0000:00:1d.0: PME# disabled
[    0.844022] pci 0000:00:1f.2: reg 10: [io  0x6090-0x6097]
[    0.844033] pci 0000:00:1f.2: reg 14: [io  0x6080-0x6083]
[    0.844043] pci 0000:00:1f.2: reg 18: [io  0x6070-0x6077]
[    0.844054] pci 0000:00:1f.2: reg 1c: [io  0x6060-0x6063]
[    0.844064] pci 0000:00:1f.2: reg 20: [io  0x6020-0x603f]
[    0.844075] pci 0000:00:1f.2: reg 24: [mem 0xf5440000-0xf54407ff]
[    0.844122] pci 0000:00:1f.2: PME# supported from D3hot
[    0.844126] pci 0000:00:1f.2: PME# disabled
[    0.844165] pci 0000:00:1f.3: reg 10: [mem 0xf5430000-0xf54300ff 64bit]
[    0.844194] pci 0000:00:1f.3: reg 20: [io  0x6000-0x601f]
[    0.844264] pci 0000:00:1f.6: reg 10: [mem 0xf5420000-0xf5420fff 64bit]
[    0.844399] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.844467] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.844471] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf53fffff]
[    0.844479] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.844646] pci 0000:02:00.0: reg 10: [mem 0xf2c00000-0xf2c01fff 64bit]
[    0.844824] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.844850] pci 0000:02:00.0: PME# disabled
[    0.844912] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.844977] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.844982] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf3ffffff]
[    0.844989] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.845133] pci 0000:03:00.0: reg 10: [mem 0xf1800000-0xf18000ff]
[    0.845266] pci 0000:03:00.0: supports D1 D2
[    0.845267] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.845273] pci 0000:03:00.0: PME# disabled
[    0.845301] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.845369] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.845374] pci 0000:00:1c.2:   bridge window [mem 0xf1800000-0xf2bfffff]
[    0.845381] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.845436] pci 0000:00:1c.3: PCI bridge to [bus 04-09]
[    0.845504] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.845509] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf17fffff]
[    0.845516] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.845586] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    0.845660] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.845665] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.845672] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.845674] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.845676] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.845678] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.845680] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    0.845710] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.845851] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.845951] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.846009] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.846068] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.846128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.846260] \_SB_.PCI0:_OSC invalid UUID
[    0.846262] _OSC request data:1 19 1f 
[    0.849097] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    0.849502] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.849965] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.850376] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.850785] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.851245] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.851653] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.852137] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    0.852548] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.853003] HEST: Table is not found!
[    0.853107] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.853207] vgaarb: loaded
[    0.853354] SCSI subsystem initialized
[    0.853446] libata version 3.00 loaded.
[    0.853479] usbcore: registered new interface driver usbfs
[    0.853550] usbcore: registered new interface driver hub
[    0.853631] usbcore: registered new device driver usb
[    0.853841] ACPI: WMI: Mapper loaded
[    0.853902] PCI: Using ACPI for IRQ routing
[    0.853963] PCI: pci_cache_line_size set to 64 bytes
[    0.854180] reserve RAM buffer: 000000000009ac00 - 000000000009ffff 
[    0.854182] reserve RAM buffer: 00000000db65f000 - 00000000dbffffff 
[    0.854248] NetLabel: Initializing
[    0.854308] NetLabel:  domain hash size = 128
[    0.854369] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.854440] NetLabel:  unlabeled traffic allowed by default
[    0.854536] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.854821] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.856900] Switching to clocksource tsc
[    0.861369] AppArmor: AppArmor Filesystem Enabled
[    0.861450] pnp: PnP ACPI init
[    0.861526] ACPI: bus type pnp registered
[    0.864050]   alloc irq_desc for 23 on node 0
[    0.864052]   alloc kstat_irqs on node 0
[    0.867298] pnp: PnP ACPI: found 13 devices
[    0.867363] ACPI: ACPI bus type pnp unregistered
[    0.867587] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.867654] system 00:05: [io  0x1000-0x1003] has been reserved
[    0.867722] system 00:05: [io  0x1004-0x1013] has been reserved
[    0.867938] system 00:05: [io  0xffff] has been reserved
[    0.868001] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.868065] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.868130] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.868198] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.868265] system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.868332] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.868399] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.868466] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.868532] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.868598] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.868669] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.868737] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.868807] system 00:0a: [mem 0xf54c0000-0xf54c0fff] has been reserved
[    0.874366] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.874462] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.874556] pci 0000:00:1c.2: BAR 15: assigned [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.874652] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.874746] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.874809] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    0.874878] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf53fffff]
[    0.874947] pci 0000:00:1c.0:   bridge window [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.875626] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.875692] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.875762] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf3ffffff]
[    0.875831] pci 0000:00:1c.1:   bridge window [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.875934] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.875999] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.876070] pci 0000:00:1c.2:   bridge window [mem 0xf1800000-0xf2bfffff]
[    0.876143] pci 0000:00:1c.2:   bridge window [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.876242] pci 0000:00:1c.3: PCI bridge to [bus 04-09]
[    0.876307] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.876378] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf17fffff]
[    0.876448] pci 0000:00:1c.3:   bridge window [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.876547] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    0.876609] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.876679] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.876745] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.876825]   alloc irq_desc for 16 on node -1
[    0.876826]   alloc kstat_irqs on node -1
[    0.876830] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.876904] pci 0000:00:1c.0: setting latency timer to 64
[    0.876913]   alloc irq_desc for 17 on node -1
[    0.876914]   alloc kstat_irqs on node -1
[    0.876917] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.876989] pci 0000:00:1c.1: setting latency timer to 64
[    0.876999]   alloc irq_desc for 18 on node -1
[    0.877000]   alloc kstat_irqs on node -1
[    0.877003] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.877071] pci 0000:00:1c.2: setting latency timer to 64
[    0.877080]   alloc irq_desc for 19 on node -1
[    0.877081]   alloc kstat_irqs on node -1
[    0.877084] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.877154] pci 0000:00:1c.3: setting latency timer to 64
[    0.877162] pci 0000:00:1e.0: setting latency timer to 64
[    0.877167] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.877168] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.877170] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.877172] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfeafffff]
[    0.877173] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    0.877175] pci_bus 0000:01: resource 1 [mem 0xf4000000-0xf53fffff]
[    0.877177] pci_bus 0000:01: resource 2 [mem 0xf5500000-0xf56fffff 64bit pref]
[    0.877179] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.877180] pci_bus 0000:02: resource 1 [mem 0xf2c00000-0xf3ffffff]
[    0.877182] pci_bus 0000:02: resource 2 [mem 0xf5700000-0xf58fffff 64bit pref]
[    0.877184] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.877186] pci_bus 0000:03: resource 1 [mem 0xf1800000-0xf2bfffff]
[    0.877187] pci_bus 0000:03: resource 2 [mem 0xf5900000-0xf5afffff 64bit pref]
[    0.877189] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.877191] pci_bus 0000:04: resource 1 [mem 0xf0400000-0xf17fffff]
[    0.877192] pci_bus 0000:04: resource 2 [mem 0xf5b00000-0xf5cfffff 64bit pref]
[    0.877194] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    0.877196] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    0.877198] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    0.877199] pci_bus 0000:0a: resource 7 [mem 0xe0000000-0xfeafffff]
[    0.877227] NET: Registered protocol family 2
[    0.877409] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.878397] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.880764] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.881107] TCP: Hash tables configured (established 524288 bind 65536)
[    0.881174] TCP reno registered
[    0.881239] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.881334] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.881516] NET: Registered protocol family 1
[    0.881594] pci 0000:00:02.0: Boot video device
[    0.881776] PCI: CLS 64 bytes, default 64
[    0.881824] Trying to unpack rootfs image as initramfs...
[    1.114779] Freeing initrd memory: 13884k freed
[    1.117752] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.117826] Placing 64MB software IO TLB between ffff880001fdd000 - ffff880005fdd000
[    1.117922] software IO TLB at phys 0x1fdd000 - 0x5fdd000
[    1.118031] Simple Boot Flag at 0xf1 set to 0x1
[    1.118315] Scanning for low memory corruption every 60 seconds
[    1.118520] audit: initializing netlink socket (disabled)
[    1.118593] type=2000 audit(1284224413.970:1): initialized
[    1.130386] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.131437] VFS: Disk quotas dquot_6.5.2
[    1.131540] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.132037] fuse init (API version 7.15)
[    1.132158] msgmni has been set to 7642
[    1.132371] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.132468] io scheduler noop registered
[    1.132528] io scheduler deadline registered
[    1.132612] io scheduler cfq registered (default)
[    1.132849] \_SB_.PCI0:_OSC invalid UUID
[    1.132850] _OSC request data:1 0 1d 
[    1.132907] \_SB_.PCI0:_OSC invalid UUID
[    1.132908] _OSC request data:1 0 1d 
[    1.132960] \_SB_.PCI0:_OSC invalid UUID
[    1.132961] _OSC request data:1 0 1d 
[    1.133013] \_SB_.PCI0:_OSC invalid UUID
[    1.133014] _OSC request data:1 0 1d 
[    1.133038] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.133117] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.133232] intel_idle: MWAIT substates: 0x1120
[    1.133233] intel_idle: v0.4 model 0x25
[    1.133234] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.133631] ACPI: AC Adapter [AC] (on-line)
[    1.133762] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.134201] ACPI: Lid Switch [LID]
[    1.134291] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.134391] ACPI: Power Button [PBTN]
[    1.134473] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    1.134571] ACPI: Sleep Button [SBTN]
[    1.134655] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.134752] ACPI: Power Button [PWRF]
[    1.134973] ACPI: acpi_idle yielding to intel_idle
[    1.139816] ERST: Table is not found!
[    1.140241] Linux agpgart interface v0.103
[    1.140323] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.141375] brd: module loaded
[    1.141826] loop: module loaded
[    1.142181] Fixed MDIO Bus: probed
[    1.142257] PPP generic driver version 2.4.2
[    1.142339] tun: Universal TUN/TAP device driver, 1.6
[    1.142436] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.142556] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.142645] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.142752] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.142756] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.142892] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.143013] ehci_hcd 0000:00:1a.0: debug port 2
[    1.146964] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.146981] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf5470000
[    1.159745] ACPI: Battery Slot [BAT0] (battery present)
[    1.160679] ACPI: Battery Slot [BAT1] (battery absent)
[    1.163901] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.164061] hub 1-0:1.0: USB hub found
[    1.164123] hub 1-0:1.0: 3 ports detected
[    1.164234] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.164315] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.164318] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.164402] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.164522] ehci_hcd 0000:00:1d.0: debug port 2
[    1.168460] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.168473] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xf5450000
[    1.186836] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.186985] hub 2-0:1.0: USB hub found
[    1.187048] hub 2-0:1.0: 3 ports detected
[    1.187149] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.187222] uhci_hcd: USB Universal Host Controller Interface driver
[    1.187357] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.188759] i8042.c: Warning: Keylock active.
[    1.190176] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.190244] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.190356] mice: PS/2 mouse device common for all mice
[    1.190519] rtc_cmos 00:06: RTC can wake from S4
[    1.190603] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.190710] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.190845] device-mapper: uevent: version 1.0.3
[    1.190960] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    1.191100] device-mapper: multipath: version 1.1.1 loaded
[    1.191165] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.191299] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.191470] cpuidle: using governor ladder
[    1.191640] cpuidle: using governor menu
[    1.191875] TCP cubic registered
[    1.192015] NET: Registered protocol family 10
[    1.192323] lo: Disabled Privacy Extensions
[    1.192520] NET: Registered protocol family 17
[    1.192590] Registering the dns_resolver key type
[    1.194040] PM: Resume from disk failed.
[    1.194047] registered taskstats version 1
[    1.194441]   Magic number: 10:608:36
[    1.194504] bdi 7:1: hash matches
[    1.194678] rtc_cmos 00:06: setting system clock to 2010-09-11 17:00:14 UTC (1284224414)
[    1.194781] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.194850] EDD information not available.
[    1.195016] Freeing unused kernel memory: 900k freed
[    1.195230] Write protecting the kernel read-only data: 10240k
[    1.197772] Freeing unused kernel memory: 468k freed
[    1.198067] Freeing unused kernel memory: 1696k freed
[    1.214035] udev: starting version 151
[    1.214127] udevd (73): /proc/73/oom_adj is deprecated, please use /proc/73/oom_score_adj instead.
[    1.233473] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.234472] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    1.250153] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    1.250227] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    1.300554] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    1.300643] ahci 0000:00:1f.2: version 3.0
[    1.300663] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.300769]   alloc irq_desc for 40 on node -1
[    1.300771]   alloc kstat_irqs on node -1
[    1.300786] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    1.300876] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    1.300980] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    1.301084] ahci 0000:00:1f.2: setting latency timer to 64
[    1.356879] scsi0 : ahci
[    1.357065] scsi1 : ahci
[    1.357178] scsi2 : ahci
[    1.357294] scsi3 : ahci
[    1.357409] scsi4 : ahci
[    1.357524] scsi5 : ahci
[    1.357966] ata1: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440100 irq 40
[    1.358063] ata2: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440180 irq 40
[    1.358159] ata3: DUMMY
[    1.358216] ata4: DUMMY
[    1.358274] ata5: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440300 irq 40
[    1.358367] ata6: SATA max UDMA/133 abar m2048@0xf5440000 port 0xf5440380 irq 40
[    1.358499]   alloc irq_desc for 20 on node -1
[    1.358502]   alloc kstat_irqs on node -1
[    1.358511] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.358587] e1000e 0000:00:19.0: setting latency timer to 64
[    1.358710]   alloc irq_desc for 41 on node -1
[    1.358713]   alloc kstat_irqs on node -1
[    1.358725] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    1.368637] [drm] Initialized drm 1.1.0 20060810
[    1.496706] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.573301] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:26:b9:e0:54:fd
[    1.573404] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.573525] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: 4041ff-0ff
[    1.647428] hub 1-1:1.0: USB hub found
[    1.647663] hub 1-1:1.0: 6 ports detected
[    1.706735] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.706742] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.706747] ata6: SATA link down (SStatus 0 SControl 300)
[    1.706801] ata5: SATA link down (SStatus 0 SControl 300)
[    1.707844] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.708914] ata2.00: ATAPI: MATSHITA DVD+/-RW UJ892, 1.04, max UDMA/100
[    1.709682] ata1.00: ATA-7: SAMSUNG SSD PM800 2.5" 256GB, VBM24D1Q, max UDMA/100
[    1.709865] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.710544] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.711800] ata1.00: configured for UDMA/100
[    1.711832] ata2.00: configured for UDMA/100
[    1.726927] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM80 VBM2 PQ: 0 ANSI: 5
[    1.727176] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.727254] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.727404] sd 0:0:0:0: [sda] Write Protect is off
[    1.727472] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.727485] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.728228]  sda: sda1 sda2 < sda5 >
[    1.728601] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.730205] scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ892    1.04 PQ: 0 ANSI: 5
[    1.736165] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.736266] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.736407] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.736451] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.755459] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.755526] i915 0000:00:02.0: setting latency timer to 64
[    1.776590] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    1.789298]   alloc irq_desc for 42 on node -1
[    1.789304]   alloc kstat_irqs on node -1
[    1.789321] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    1.789336] [drm] set up 31M of stolen space
[    1.797613] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.927274] hub 2-1:1.0: USB hub found
[    1.927462] hub 2-1:1.0: 8 ports detected
[    2.006708] usb 1-1.4: new high speed USB device using ehci_hcd and address 3
[    2.205944] intel_dp_link_required: is_edp: 1, is_pch_edp: 0, result: 162315, pixel_clock: 72140
[    2.205948] intel_dp_link_required: is_edp: 1, is_pch_edp: 0, result: 162315, pixel_clock: 72140
[    2.236591] usb 2-1.7: new full speed USB device using ehci_hcd and address 3
[    2.426475] usb 2-1.8: new full speed USB device using ehci_hcd and address 4
[    2.559494] usb 2-1.8: config 0 descriptor??
[    2.806445] Console: switching to colour frame buffer device 170x48
[    2.808908] fb0: inteldrmfb frame buffer device
[    2.808909] drm: registered panic notifier
[    2.815159] acpi device:37: registered as cooling_device4
[    2.815637] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    2.815774] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.815833] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.241889] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.655073] Adding 10173436k swap on /dev/sda5.  Priority:-1 extents:1 across:10173436k SS
[    3.658854] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    3.664947] udev: starting version 151
[    3.713437] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.718330] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value (found 25, expected 35)
[    3.718353] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.738666] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.753875] sdhci: Secure Digital Host Controller Interface driver
[    3.753879] sdhci: Copyright(c) Pierre Ossman
[    3.759268] lp: driver loaded but no devices found
[    3.760546] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 1)
[    3.760574] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.760674] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    3.760682] sdhci-pci 0000:03:00.0: setting latency timer to 64
[    3.760694] mmc0: no vmmc regulator found
[    3.760755] Registered led device: mmc0::
[    3.760942] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[    3.771889] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
[    3.787709] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    3.828982] cfg80211: Calling CRDA to update world regulatory domain
[    3.832566] apparmor_parser[749]: segfault at 0 ip 0000000000409eda sp 00007fff47a28e90 error 4 in apparmor_parser[400000+c8000]
[    3.834791] parport_pc 00:08: activated
[    3.834796] parport_pc 00:08: reported by Plug and Play ACPI
[    3.834953] parport_pc 00:08: disabled
[    3.910866] cfg80211: World regulatory domain updated:
[    3.910871]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    3.910874]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    3.910877]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    3.910879]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    3.910882]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    3.910884]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    3.914148] ppdev: user-space parallel port driver
[    3.923840] apparmor_parser[824]: segfault at 0 ip 0000000000409eda sp 00007fffe38e82c0 error 4 in apparmor_parser[400000+c8000]
[    3.931363] apparmor_parser[835]: segfault at 0 ip 0000000000409eda sp 00007ffff28b6120 error 4 in apparmor_parser[400000+c8000]
[    3.950333] Bluetooth: Core ver 2.15
[    3.950355] NET: Registered protocol family 31
[    3.950357] Bluetooth: HCI device and connection manager initialized
[    3.950359] Bluetooth: HCI socket layer initialized
[    3.957861] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    3.963215] usbcore: registered new interface driver btusb
[    3.972771] Linux video capture interface: v2.00
[    4.008871] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2M (0461:4db1)
[    4.025732] input: Laptop_Integrated_Webcam_2M as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input7
[    4.025804] usbcore: registered new interface driver uvcvideo
[    4.025807] USB Video Class driver (v0.1.0)
[    4.095740] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    4.165565] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    4.166086] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.596176] Bluetooth: L2CAP ver 2.15
[    4.596179] Bluetooth: L2CAP socket layer initialized
[    4.629086] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.629090] Bluetooth: BNEP filters: protocol multicast
[    5.108781]   alloc irq_desc for 22 on node -1
[    5.108785]   alloc kstat_irqs on node -1
[    5.108795] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.108876]   alloc irq_desc for 43 on node -1
[    5.108878]   alloc kstat_irqs on node -1
[    5.108891] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    5.108923] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.112807] Bridge firewalling registered
[    5.113117] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    5.113120] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    5.113234] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.113265] iwlagn 0000:02:00.0: setting latency timer to 64
[    5.113355] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    5.128446] Bluetooth: SCO (Voice Link) ver 0.6
[    5.128449] Bluetooth: SCO socket layer initialized
[    5.129455] iwlagn 0000:02:00.0: device EEPROM VER=0x436, CALIB=0x6
[    5.129483] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    5.129613]   alloc irq_desc for 44 on node -1
[    5.129614]   alloc kstat_irqs on node -1
[    5.129656] iwlagn 0000:02:00.0: irq 44 for MSI/MSI-X
[    5.132864] iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build 19710
[    5.141743] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.200612] Bluetooth: RFCOMM TTY layer initialized
[    5.200618] Bluetooth: RFCOMM socket layer initialized
[    5.200619] Bluetooth: RFCOMM ver 1.11
[    6.374062] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    6.534306] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    6.534388] input: HDA Intel Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    6.534447] input: HDA Intel Line Out at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    6.534571] input: HDA Intel HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    6.928074] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
[    7.374179] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20100702/evregion-474)
[    7.374235] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.ECDV.ECR1] (Node ffff88011763cbe0), AE_TIME
[    7.374247] ACPI Error (psparse-0537): Method parse/execution failed [\ECBT] (Node ffff88011763ccf8), AE_TIME
[    7.374255] ACPI Error (psparse-0537): Method parse/execution failed [\ECG2] (Node ffff88011763cde8), AE_TIME
[    7.374262] ACPI Error (psparse-0537): Method parse/execution failed [\ECG6] (Node ffff88011763ced8), AE_TIME
[    7.374270] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88011763e668), AE_TIME
[    7.374282] ACPI Exception: AE_TIME, Evaluating _BST (20100702/battery-439)
[    8.060062] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input12
[    9.733083] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[   14.730896] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[   29.724333] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[   44.717687] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[   56.499236] padlock: VIA PadLock not detected.

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="Xorg.0.log"
Content-Transfer-Encoding: 8bit


X.Org X Server 1.7.6
Release Date: 2010-03-17
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.24-27-server x86_64 Ubuntu
Current Operating System: Linux gavana 2.6.36-rc3-git3-zbr #6 SMP Sat Sep 11 20:52:04 MSD 2010 x86_64
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-rc3-git3-zbr root=UUID=3e0770ae-e3de-4db5-9c15-2a058ad91585 ro
Build Date: 21 July 2010  01:03:39PM
xorg-server 2:1.7.6-2ubuntu7.3 (For technical support please see http://www.ubuntu.com/support) 
Current version of pixman: 0.16.4
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sat Sep 11 21:00:18 2010
(==) Using config file: "/etc/X11/xorg.conf"
(==) Using config directory: "/usr/lib/X11/xorg.conf.d"
(==) ServerLayout "X.org Configured"
(**) |-->Screen "Screen0" (0)
(**) |   |-->Monitor "Monitor0"
(**) |   |-->Device "Card0"
(**) |-->Input Device "Mouse0"
(**) |-->Input Device "Keyboard0"
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(**) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins,
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
(**) ModulePath set to "/usr/lib/xorg/modules"
(WW) AllowEmptyInput is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
(WW) Disabling Mouse0
(WW) Disabling Keyboard0
(II) Loader magic: 0x7ca300
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 6.0
	X.Org XInput driver : 7.0
	X.Org Server Extension : 2.0
(++) using VT number 7

(--) PCI:*(0:0:2:0) 8086:0046:1028:0410 Intel Corporation Core Processor Integrated Graphics Controller rev 2, Mem @ 0xf0000000/4194304, 0xe0000000/268435456, I/O @ 0x000060b0/8
(II) Open ACPI successful (/var/run/acpid.socket)
(II) "extmod" will be loaded. This was enabled by default and also specified in the config file.
(II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
(II) "glx" will be loaded. This was enabled by default and also specified in the config file.
(II) "record" will be loaded. This was enabled by default and also specified in the config file.
(II) "dri" will be loaded. This was enabled by default and also specified in the config file.
(II) "dri2" will be loaded. This was enabled by default and also specified in the config file.
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.1.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions/librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions/libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions/libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "intel"
(II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
(II) Module intel: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 2.9.1
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 6.0
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, Clarkdale, Arrandale
(II) Primary Device is: PCI 00@00:02:0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: drmOpenMinor returns 9
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(==) intel(0): Depth 24, (--) framebuffer bpp 32
(==) intel(0): RGB weight 888
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) Arrandale
(--) intel(0): Chipset: "Arrandale"
(II) intel(0): Output (null)1 using monitor section Monitor0
(II) intel(0): Output VGA1 has no monitor section
(II) intel(0): Output HDMI1 has no monitor section
(II) intel(0): Output DP1 has no monitor section
(II) intel(0): Output HDMI2 has no monitor section
(II) intel(0): Output DP2 has no monitor section
(II) intel(0): EDID for output (null)1
(II) intel(0): Manufacturer: SEC  Model: 5441  Serial#: 0
(II) intel(0): Year: 2010  Week: 255
(II) intel(0): EDID Version: 1.4
(II) intel(0): Digital Display Input
(II) intel(0): 6 bits per channel
(II) intel(0): Digital interface is DisplayPort
(II) intel(0): Max Image Size [cm]: horiz.: 29  vert.: 16
(II) intel(0): Gamma: 2.20
(II) intel(0): No DPMS capabilities specified
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): Preferred mode is native pixel format and refresh rate
(II) intel(0): redX: 0.590 redY: 0.350   greenX: 0.320 greenY: 0.535
(II) intel(0): blueX: 0.155 blueY: 0.115   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 72.1 MHz   Image Size:  293 x 165 mm
(II) intel(0): h_active: 1366  h_sync: 1414  h_sync_end 1446 h_blank_end 1522 h_border: 0
(II) intel(0): v_active: 768  v_sync: 770  v_sync_end 775 v_blanking: 790 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 48.1 MHz   Image Size:  293 x 165 mm
(II) intel(0): h_active: 1366  h_sync: 1414  h_sync_end 1446 h_blank_end 1522 h_border: 0
(II) intel(0): v_active: 768  v_sync: 770  v_sync_end 775 v_blanking: 790 v_border: 0
(II) intel(0):  XF930€133AT
(II) intel(0): Unknown vendor-specific block 0
(II) intel(0): EDID (in hex):
(II) intel(0): 	00ffffffffffff004ca3415400000000
(II) intel(0): 	ff140104951d10780a20e59759528927
(II) intel(0): 	1d505400000001010101010101010101
(II) intel(0): 	0101010101012e1c569c500016303020
(II) intel(0): 	250025a51000001ac912569c50001630
(II) intel(0): 	3020250025a51000001a000000fe0058
(II) intel(0): 	463933308031333341540a2000000000
(II) intel(0): 	00004101160000000009010a2020009d
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): Printing probed modes for output (null)1
(II) intel(0): Modeline "1366x768"x60.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x40.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): EDID for output VGA1
(II) intel(0): EDID for output HDMI1
(II) intel(0): EDID for output DP1
(II) intel(0): EDID for output HDMI2
(II) intel(0): EDID for output DP2
(II) intel(0): Output (null)1 connected
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output HDMI1 disconnected
(II) intel(0): Output DP1 disconnected
(II) intel(0): Output HDMI2 disconnected
(II) intel(0): Output DP2 disconnected
(II) intel(0): Using exact sizes for initial modes
(II) intel(0): Output (null)1 using initial mode 1366x768
(II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
(==) intel(0): video overlay key set to 0x101fe
(**) intel(0): Display dimensions: (290, 160) mm
(**) intel(0): DPI set to (119, 121)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules/libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(==) Depth 24 pixmap format is 32 bpp
(II) intel(0): [DRI2] Setup complete
(**) intel(0): Framebuffer compression disabled
(**) intel(0): Tiling enabled
(**) intel(0): SwapBuffers wait enabled
(==) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.
(II) UXA(0): Driver registered support for the following operations:
(II)         solid
(II)         copy
(II)         composite (RENDER acceleration)
(==) intel(0): Backing store disabled
(==) intel(0): Silken mouse enabled
(II) intel(0): Initializing HW Cursor
(II) intel(0): No memory allocations
(II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
(==) intel(0): DPMS enabled
(==) intel(0): Intel XvMC decoder disabled
(II) intel(0): Set up textured video
(II) intel(0): direct rendering: DRI2 Enabled
(--) RandR disabled
(II) Initializing built-in extension Generic Event Extension
(II) Initializing built-in extension SHAPE
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension BIG-REQUESTS
(II) Initializing built-in extension SYNC
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-MISC
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
(II) AIGLX: enabled GLX_MESA_copy_sub_buffer
(II) AIGLX: enabled GLX_SGI_make_current_read
(II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
(II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
(II) AIGLX: Loaded and initialized /usr/lib/dri/i965_dri.so
(II) GLX: Initialized DRI2 GL provider for screen 0
(II) intel(0): Setting screen physical size to 361 x 203
(II) XKB: reuse xkmfile /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
(II) config/udev: Adding input device Power Button (/dev/input/event3)
(**) Power Button: Applying InputClass "evdev keyboard catchall"
(II) LoadModule: "evdev"
(II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
(II) Module evdev: vendor="X.Org Foundation"
	compiled for 1.7.6, module version = 2.3.2
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 7.0
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event3"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Video Bus (/dev/input/event5)
(**) Video Bus: Applying InputClass "evdev keyboard catchall"
(**) Video Bus: always reports core events
(**) Video Bus: Device: "/dev/input/event5"
(II) Video Bus: Found keys
(II) Video Bus: Configuring as keyboard
(II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Power Button (/dev/input/event1)
(**) Power Button: Applying InputClass "evdev keyboard catchall"
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event1"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Lid Switch (/dev/input/event0)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device Sleep Button (/dev/input/event2)
(**) Sleep Button: Applying InputClass "evdev keyboard catchall"
(**) Sleep Button: always reports core events
(**) Sleep Button: Device: "/dev/input/event2"
(II) Sleep Button: Found keys
(II) Sleep Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Laptop_Integrated_Webcam_2M (/dev/input/event7)
(**) Laptop_Integrated_Webcam_2M: Applying InputClass "evdev keyboard catchall"
(**) Laptop_Integrated_Webcam_2M: always reports core events
(**) Laptop_Integrated_Webcam_2M: Device: "/dev/input/event7"
(II) Laptop_Integrated_Webcam_2M: Found keys
(II) Laptop_Integrated_Webcam_2M: Configuring as keyboard
(II) XINPUT: Adding extended input device "Laptop_Integrated_Webcam_2M" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device HDA Intel Line Out at Sep Left Jack (/dev/input/event10)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Intel HP Out at Ext Left Jack (/dev/input/event11)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Intel Mic at Sep Left Jack (/dev/input/event8)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device HDA Intel Mic at Ext Left Jack (/dev/input/event9)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event4)
(**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
(**) AT Translated Set 2 keyboard: always reports core events
(**) AT Translated Set 2 keyboard: Device: "/dev/input/event4"
(II) AT Translated Set 2 keyboard: Found keys
(II) AT Translated Set 2 keyboard: Configuring as keyboard
(II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device Dell WMI hotkeys (/dev/input/event6)
(**) Dell WMI hotkeys: Applying InputClass "evdev keyboard catchall"
(**) Dell WMI hotkeys: always reports core events
(**) Dell WMI hotkeys: Device: "/dev/input/event6"
(II) Dell WMI hotkeys: Found keys
(II) Dell WMI hotkeys: Configuring as keyboard
(II) XINPUT: Adding extended input device "Dell WMI hotkeys" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/mouse0)
(II) No input driver/identifier specified (ignoring)
(II) config/udev: Adding input device PS/2 Generic Mouse (/dev/input/event12)
(**) PS/2 Generic Mouse: Applying InputClass "evdev pointer catchall"
(**) PS/2 Generic Mouse: always reports core events
(**) PS/2 Generic Mouse: Device: "/dev/input/event12"
(II) PS/2 Generic Mouse: Found 3 mouse buttons
(II) PS/2 Generic Mouse: Found relative axes
(II) PS/2 Generic Mouse: Found x and y relative axes
(II) PS/2 Generic Mouse: Configuring as mouse
(**) PS/2 Generic Mouse: YAxisMapping: buttons 4 and 5
(**) PS/2 Generic Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "PS/2 Generic Mouse" (type: MOUSE)
(II) PS/2 Generic Mouse: initialized for relative axes.
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) intel(0): EDID vendor "SEC", prod id 21569
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1366x768"x0.0   72.14  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (47.4 kHz)
(II) intel(0): Modeline "1366x768"x0.0   48.09  1366 1414 1446 1522  768 770 775 790 +hsync -vsync (31.6 kHz)
(II) AIGLX: Suspending AIGLX clients for VT switch
(II) PS/2 Generic Mouse: Close
(II) UnloadModule: "evdev"
(II) Dell WMI hotkeys: Close
(II) UnloadModule: "evdev"
(II) AT Translated Set 2 keyboard: Close
(II) UnloadModule: "evdev"
(II) Laptop_Integrated_Webcam_2M: Close
(II) UnloadModule: "evdev"
(II) Sleep Button: Close
(II) UnloadModule: "evdev"
(II) Power Button: Close
(II) UnloadModule: "evdev"
(II) Video Bus: Close
(II) UnloadModule: "evdev"
(II) Power Button: Close
(II) UnloadModule: "evdev"
 ddxSigGiveUp: Closing log

--y0ulUmNC+osPPQO6--
