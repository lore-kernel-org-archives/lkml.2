Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab0FRFFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 01:05:40 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:52552 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab0FRFFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 01:05:37 -0400
Date: Fri, 18 Jun 2010 07:05:19 +0200
From: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
To: linux-kernel@vger.kernel.org
Subject: Re: Very slow disk speed after "IRQ: nobody cared"
Message-ID: <20100618050519.GO1635@myhost.felk.cvut.cz>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20100615092818.GF1635@myhost.felk.cvut.cz>
 <4C18BB0B.4050100@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3bc47Eih9dS+biPM"
Content-Disposition: inline
In-Reply-To: <4C18BB0B.4050100@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-FELK-MailScanner-Information: 
X-MailScanner-ID: o5I55KZj010015
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.9,
	required 6, autolearn=not spam, BAYES_00 -1.90)
X-FELK-MailScanner-From: michal.svoboda@agents.felk.cvut.cz
X-FELK-MailScanner-To: linux-kernel@vger.kernel.org
X-FELK-MailScanner-Watermark: 1277442325.33965@SToksyHb7gVBTrJnal2stg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3bc47Eih9dS+biPM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Tejun Heo wrote:
> Can you please post full boot log?

Yes, see below.

> Also, can you give a shot at the following git tree?

Is that a kernel branch? There are some obstacles. First, it's a
production system, I can't experiment with swapping kernels too much. If
I had a lead on a solution I would need to confirm that it worked/didn't
work. Which is the second obstacle. The problem seems to appear at
random with a very low frequency. I don't know how to reliably reproduce
it. Do you have any advice on these?

Michal Svoboda


[    0.000000] Linux version 2.6.33 (pht@peashooter.felk.cvut.cz) (gcc vers=
ion 4.5.0 (GCC) ) #1 SMP PREEMPT Wed May 12 06:47:52 CEST 2010
[    0.000000] Command line: auto BOOT_IMAGE=3Dlinux ro root=3D802
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009bdf9c00 (usable)
[    0.000000]  BIOS-e820: 000000009bdf9c00 - 000000009be4bc00 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000009be4bc00 - 000000009be4dc00 (ACPI data)
[    0.000000]  BIOS-e820: 000000009be4dc00 - 000000009c000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fc000000 - 00000000fd000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000664000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x664000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DBFFF write-protect
[    0.000000]   DC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 009BF00000 mask FFFFF00000 uncachable
[    0.000000]   1 base 009C000000 mask FFFC000000 uncachable
[    0.000000]   2 base 00A0000000 mask FFE0000000 uncachable
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0x9bdf9 max_arch_pfn =3D 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009dc00 (usable)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000009bdf9c00 (usable)
[    0.000000]  modified: 000000009bdf9c00 - 000000009be4bc00 (ACPI NVS)
[    0.000000]  modified: 000000009be4bc00 - 000000009be4dc00 (ACPI data)
[    0.000000]  modified: 000000009be4dc00 - 000000009c000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fc000000 - 00000000fd000000 (reserved)
[    0.000000]  modified: 00000000fe000000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000664000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000009bdf9000
[    0.000000]  0000000000 - 009bc00000 page 2M
[    0.000000]  009bc00000 - 009bdf9000 page 4k
[    0.000000] kernel direct mapping tables up to 9bdf9000 @ 12000-17000
[    0.000000] init_memory_mapping: 0000000100000000-0000000664000000
[    0.000000]  0100000000 - 0664000000 page 2M
[    0.000000] kernel direct mapping tables up to 664000000 @ 15000-30000
[    0.000000] ACPI: RSDP 00000000000febf0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fcc3c 00084 (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fcd34 000F4 (v03 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000ffe9a3e5 0574C (v01   DELL    dt_ex 00001=
000 INTL 20050624)
[    0.000000] ACPI: FACS 000000009bdf9c00 00040
[    0.000000] ACPI: SSDT 00000000ffe9fc52 000AC (v01   DELL    st_ex 00001=
000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fce28 0016A (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fcf92 00028 (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fcfba 00096 (v32 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd050 0003E (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd08e 00038 (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fd2ea 00032 (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: DMAR 00000000000fd31c 000F8 (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000000fd0c6 00176 (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: _RAT 00000000000fdece 00030 (v01 DELL    B10K    00000=
015 ASL  00000061)
[    0.000000] ACPI: SSDT 000000009be4dc00 024DC (v01  INTEL PPM RCM  80000=
001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 0664000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 000169361c]    TEXT DATA BSS =3D=3D> [000=
1000000 - 000169361c]
[    0.000000]   #2 [000009dc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009dc00 - 0000100000]
[    0.000000]   #3 [0001694000 - 000169420c]              BRK =3D=3D> [000=
1694000 - 000169420c]
[    0.000000]   #4 [0000010000 - 0000012000]       TRAMPOLINE =3D=3D> [000=
0010000 - 0000012000]
[    0.000000]   #5 [0000012000 - 0000015000]          PGTABLE =3D=3D> [000=
0012000 - 0000015000]
[    0.000000]   #6 [0000015000 - 000002b000]          PGTABLE =3D=3D> [000=
0015000 - 000002b000]
[    0.000000]  [ffffea0000000000-ffffea00167fffff] PMD -> [ffff88002860000=
0-ffff88003d9fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00664000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0009bdf9
[    0.000000]     0: 0x00100000 -> 0x00664000
[    0.000000] On node 0 totalpages: 6290823
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 126 pages reserved
[    0.000000]   DMA zone: 3800 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 620081 pages, LIFO batch:31
[    0.000000]   Normal zone: 77280 pages used for memmap
[    0.000000]   Normal zone: 5575200 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24=
-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec88000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec88000, GSI 4=
8-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 32 CPUs, 24 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] Allocating PCI resources starting at 9c000000 (gap: 9c000000=
:44000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:32 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88003da00000 s77464 r8192=
 d20840 u131072
[    0.000000] pcpu-alloc: s77464 r8192 d20840 u131072 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14=
 15=20
[    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30=
 31=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 6199081
[    0.000000] Kernel command line: auto BOOT_IMAGE=3Dlinux ro root=3D802
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 4194304 (order: 13, 3355443=
2 bytes)
[    0.000000] Inode-cache hash table entries: 2097152 (order: 12, 16777216=
 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 24688684k/26804224k available (4187k kernel code, 16=
40932k absent, 473720k reserved, 1675k data, 396k init)
[    0.000000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D32, Nodes=3D1
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1480
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2394.031 MHz processor.
[    0.000005] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4788.06 BogoMIPS (lpj=3D2394031)
[    0.000241] Mount-cache hash table entries: 256
[    0.000430] CPU: Physical Processor ID: 0
[    0.000539] CPU: Processor Core ID: 0
[    0.000650] mce: CPU supports 9 MCE banks
[    0.000766] CPU0: Thermal monitoring enabled (TM1)
[    0.000886] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
[    0.001329] using mwait in idle threads.
[    0.001437] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.001661] ... version:                3
[    0.001769] ... bit width:              48
[    0.001884] ... generic registers:      4
[    0.001993] ... value mask:             0000ffffffffffff
[    0.002104] ... max period:             000000007fffffff
[    0.002215] ... fixed-purpose events:   3
[    0.002323] ... event mask:             000000070000000f
[    0.002445] ACPI: Core revision 20091214
[    0.258374] DMAR: Host address width 40
[    0.258484] DMAR: DRHD base: 0x0000009fffe000 flags: 0x0
[    0.258602] IOMMU 9fffe000: ver 1:0 cap c90780106f0462 ecap f020fe
[    0.258715] DMAR: DRHD base: 0x000000fedc0000 flags: 0x1
[    0.258831] IOMMU fedc0000: ver 1:0 cap c90780106f0462 ecap f020f6
[    0.258944] DMAR: RMRR base: 0x0000009be58000 end: 0x0000009be6ffff
[    0.259057] DMAR: ATSR flags: 0x0
[    0.259164] DMAR: ATSR flags: 0x0
[    0.259277] Setting APIC routing to physical flat
[    0.259987] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.270084] CPU0: Intel(R) Xeon(R) CPU           E5530  @ 2.40GHz steppi=
ng 05
[    0.375177] Booting Node   0, Processors  #1
[    0.446050] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.468007]  #2
[    0.538877] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.560833]  #3
[    0.632702] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.654658]  #4
[    0.725531] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.747490]  #5
[    0.818360] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.840320]  #6
[    0.911188] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.933144]  #7
[    1.004015] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.024026] Brought up 8 CPUs
[    1.024347] Total of 8 processors activated (38298.22 BogoMIPS).
[    1.027572] NET: Registered protocol family 16
[    1.027817] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    1.027982] ACPI: bus type pci registered
[    1.028144] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    1.028310] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.033110] PCI: Using configuration type 1 for base access
[    1.035225] bio: create slab <bio-0> at 0
[    1.036126] ACPI: EC: Look up EC in DSDT
[    1.113543] ACPI: BIOS _OSI(Linux) query ignored
[    1.132019] ACPI: Interpreter enabled
[    1.132129] ACPI: (supports S0 S5)
[    1.132351] ACPI: Using IOAPIC for interrupt routing
[    1.227633] ACPI Warning: Incorrect checksum in table [TCPA] - 00, shoul=
d be 7F (20091214/tbutils-314)
[    1.227914] ACPI Warning: Incorrect checksum in table [_RAT] - 00, shoul=
d be 63 (20091214/tbutils-314)
[    1.228266] ACPI: No dock devices found.
[    1.242617] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.242757] pci_root PNP0A03:00: ignoring host bridge windows from ACPI;=
 boot with "pci=3Duse_crs" to use them
[    1.271350] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    1.271352] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    1.271354] pci_root PNP0A03:00: host bridge window [io  0xf000-0xffff] =
(ignored)
[    1.271356] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    1.271358] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x00=
0effff] (ignored)
[    1.271360] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x00=
0fffff] (ignored)
[    1.271362] pci_root PNP0A03:00: host bridge window [mem 0xa0000000-0xdf=
ffffff] (ignored)
[    1.271364] pci_root PNP0A03:00: host bridge window [mem 0x9bf00000-0xa0=
000000] invalid; aligning end to 16-byte boundary
[    1.271366] pci_root PNP0A03:00: host bridge window [mem 0x9bf00000-0x9f=
ffffff] (ignored)
[    1.271368] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfb=
ffffff] (ignored)
[    1.271369] pci_root PNP0A03:00: host bridge window [mem 0xff980000-0xff=
980fff] (ignored)
[    1.271371] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff=
97ffff] (ignored)
[    1.271373] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfe=
d9ffff] (ignored)
[    1.271422] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.271425] pci 0000:00:00.0: PME# disabled
[    1.271476] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.271479] pci 0000:00:01.0: PME# disabled
[    1.271532] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.271534] pci 0000:00:03.0: PME# disabled
[    1.271591] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.271594] pci 0000:00:07.0: PME# disabled
[    1.271761] pci 0000:00:1a.0: reg 20: [io  0x1f20-0x1f3f]
[    1.271817] pci 0000:00:1a.1: reg 20: [io  0x1f00-0x1f1f]
[    1.271873] pci 0000:00:1a.2: reg 20: [io  0x1c00-0x1c1f]
[    1.271928] pci 0000:00:1a.7: reg 10: [mem 0xdfffa000-0xdfffa3ff]
[    1.271977] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.271980] pci 0000:00:1a.7: PME# disabled
[    1.272009] pci 0000:00:1b.0: reg 10: [mem 0xdfffc000-0xdfffffff 64bit]
[    1.272045] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.272048] pci 0000:00:1b.0: PME# disabled
[    1.272104] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.272107] pci 0000:00:1c.0: PME# disabled
[    1.272168] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.272171] pci 0000:00:1c.5: PME# disabled
[    1.272215] pci 0000:00:1d.0: reg 20: [io  0x1f80-0x1f9f]
[    1.272271] pci 0000:00:1d.1: reg 20: [io  0x1f60-0x1f7f]
[    1.272327] pci 0000:00:1d.2: reg 20: [io  0x1f40-0x1f5f]
[    1.272383] pci 0000:00:1d.7: reg 10: [mem 0xff980000-0xff9803ff]
[    1.272431] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.272435] pci 0000:00:1d.7: PME# disabled
[    1.272537] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6=
 ACPI/GPIO/TCO
[    1.272702] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6=
 GPIO
[    1.272818] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (=
mask 007f)
[    1.272981] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (=
mask 0007)
[    1.273144] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0900 (=
mask 003f)
[    1.273351] pci 0000:00:1f.2: reg 10: [io  0x1e00-0x1e07]
[    1.273355] pci 0000:00:1f.2: reg 14: [io  0x1e10-0x1e13]
[    1.273360] pci 0000:00:1f.2: reg 18: [io  0x1e20-0x1e27]
[    1.273364] pci 0000:00:1f.2: reg 1c: [io  0x1e30-0x1e33]
[    1.273369] pci 0000:00:1f.2: reg 20: [io  0x1ec0-0x1edf]
[    1.273373] pci 0000:00:1f.2: reg 24: [mem 0xff970000-0xff9707ff]
[    1.273400] pci 0000:00:1f.2: PME# supported from D3hot
[    1.273403] pci 0000:00:1f.2: PME# disabled
[    1.273426] pci 0000:00:1f.3: reg 10: [mem 0xdfffb000-0xdfffb0ff 64bit]
[    1.273437] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
[    1.273509] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.273512] pci 0000:01:00.0: PME# disabled
[    1.273543] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.273657] pci 0000:00:01.0:   bridge window [mem 0xdbe00000-0xdbefffff]
[    1.273698] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    1.273848] pci 0000:03:00.0: reg 10: [mem 0xde000000-0xdeffffff]
[    1.273858] pci 0000:03:00.0: reg 14: [mem 0xa0000000-0xbfffffff 64bit p=
ref]
[    1.273868] pci 0000:03:00.0: reg 1c: [mem 0xdc000000-0xddffffff 64bit]
[    1.273874] pci 0000:03:00.0: reg 24: [io  0xdc80-0xdcff]
[    1.273879] pci 0000:03:00.0: reg 30: [mem 0xdfe00000-0xdfe7ffff pref]
[    1.273942] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    1.274054] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    1.274057] pci 0000:00:03.0:   bridge window [mem 0xdc000000-0xdfefffff]
[    1.274061] pci 0000:00:03.0:   bridge window [mem 0xa0000000-0xbfffffff=
 64bit pref]
[    1.274080] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    1.274193] pci 0000:00:07.0:   bridge window [mem 0xdbf00000-0xdbffffff]
[    1.274221] pci 0000:05:00.0: reg 10: [io  0xcc00-0xccff]
[    1.274232] pci 0000:05:00.0: reg 14: [mem 0xdbcec000-0xdbceffff 64bit]
[    1.274243] pci 0000:05:00.0: reg 1c: [mem 0xdbcf0000-0xdbcfffff 64bit]
[    1.274254] pci 0000:05:00.0: reg 30: [mem 0xdbd00000-0xdbdfffff pref]
[    1.274281] pci 0000:05:00.0: supports D1 D2
[    1.274298] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    1.274488] pci 0000:00:1c.0: PCI bridge to [bus 05-05]
[    1.274602] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.274605] pci 0000:00:1c.0:   bridge window [mem 0xdbc00000-0xdbdfffff]
[    1.274666] pci 0000:06:00.0: reg 10: [mem 0xdbbe0000-0xdbbeffff 64bit]
[    1.274683] pci 0000:06:00.0: reg 18: [mem 0xdbbf0000-0xdbbfffff 64bit]
[    1.274761] pci 0000:06:00.0: PME# supported from D3hot D3cold
[    1.274767] pci 0000:06:00.0: PME# disabled
[    1.274827] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
[    1.274941] pci 0000:00:1c.5:   bridge window [mem 0xdbb00000-0xdbbfffff]
[    1.274981] pci 0000:07:0a.0: reg 10: [mem 0xdbafb000-0xdbafb7ff]
[    1.274986] pci 0000:07:0a.0: reg 14: [mem 0xdbafc000-0xdbafffff]
[    1.275025] pci 0000:07:0a.0: supports D1 D2
[    1.275026] pci 0000:07:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.275030] pci 0000:07:0a.0: PME# disabled
[    1.275059] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive dec=
ode)
[    1.275177] pci 0000:00:1e.0:   bridge window [mem 0xdba00000-0xdbafffff]
[    1.275200] pci_bus 0000:00: on NUMA node 0
[    1.275204] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.275867] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    1.276159] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    1.276451] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
[    1.276746] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    1.277021] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI5._PRT]
[    1.277300] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI6._PRT]
[    2.246728] ACPI: PCI Root Bridge [PCI7] (0000:80)
[    2.246866] pci_root PNP0A03:01: ignoring host bridge windows from ACPI;=
 boot with "pci=3Duse_crs" to use them
[    2.262547] pci_root PNP0A03:01: host bridge window [io  0xf000-0xffff] =
(ignored)
[    2.262549] pci_root PNP0A03:01: host bridge window [mem 0x9f000000-0x9f=
ffffff] (ignored)
[    2.262602] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    2.262605] pci 0000:80:03.0: PME# disabled
[    2.262670] pci 0000:80:07.0: PME# supported from D0 D3hot D3cold
[    2.262672] pci 0000:80:07.0: PME# disabled
[    2.262736] pci 0000:80:09.0: PME# supported from D0 D3hot D3cold
[    2.262739] pci 0000:80:09.0: PME# disabled
[    2.262918] pci 0000:80:03.0: PCI bridge to [bus 81-81]
[    2.263033] pci 0000:80:03.0:   bridge window [mem 0x9fe00000-0x9fefffff]
[    2.263059] pci 0000:80:07.0: PCI bridge to [bus 82-82]
[    2.263174] pci 0000:80:07.0:   bridge window [mem 0x9fd00000-0x9fdfffff]
[    2.263200] pci 0000:80:09.0: PCI bridge to [bus 83-83]
[    2.263314] pci 0000:80:09.0:   bridge window [mem 0x9fc00000-0x9fcfffff]
[    2.263328] pci_bus 0000:80: on NUMA node 0
[    2.263332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI7._PRT]
[    2.263940] ACPI: PCI Interrupt Routing Table [\_SB_.PCI7.PCI9._PRT]
[    2.264230] ACPI: PCI Interrupt Routing Table [\_SB_.PCI7.PCIA._PRT]
[    2.264526] ACPI: PCI Interrupt Routing Table [\_SB_.PCI7.PCIB._PRT]
[    2.366119] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 =
15)
[    2.367674] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 =
15)
[    2.369226] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 =
15)
[    2.370778] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 1=
5) *0, disabled.
[    2.372489] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 =
15)
[    2.374033] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 1=
5) *0, disabled.
[    2.375748] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 =
15)
[    2.377299] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 =
15)
[    2.378342] vgaarb: device added: PCI:0000:03:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    2.378510] vgaarb: loaded
[    2.378697] SCSI subsystem initialized
[    2.378891] libata version 3.00 loaded.
[    2.378981] usbcore: registered new interface driver usbfs
[    2.379111] usbcore: registered new interface driver hub
[    2.379245] usbcore: registered new device driver usb
[    2.379454] PCI: Using ACPI for IRQ routing
[    2.379566] PCI: pci_cache_line_size set to 64 bytes
[    2.379728] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    2.379846] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    2.380232] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    2.387479] Switching to clocksource tsc
[    2.387760] pnp: PnP ACPI init
[    2.387874] ACPI: bus type pnp registered
[    2.404919] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps=
 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.405087] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps=
 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    2.445981] pnp: PnP ACPI: found 10 devices
[    2.446091] ACPI: ACPI bus type pnp unregistered
[    2.446206] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    2.451157] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    2.451269] pci 0000:01:00.0:   bridge window [io  disabled]
[    2.451384] pci 0000:01:00.0:   bridge window [mem disabled]
[    2.451497] pci 0000:01:00.0:   bridge window [mem pref disabled]
[    2.451613] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.451726] pci 0000:00:01.0:   bridge window [io  disabled]
[    2.451840] pci 0000:00:01.0:   bridge window [mem 0xdbe00000-0xdbefffff]
[    2.451955] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    2.452070] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    2.452182] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    2.452296] pci 0000:00:03.0:   bridge window [mem 0xdc000000-0xdfefffff]
[    2.452412] pci 0000:00:03.0:   bridge window [mem 0xa0000000-0xbfffffff=
 64bit pref]
[    2.452576] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    2.452688] pci 0000:00:07.0:   bridge window [io  disabled]
[    2.452802] pci 0000:00:07.0:   bridge window [mem 0xdbf00000-0xdbffffff]
[    2.452917] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    2.453032] pci 0000:00:1c.0: PCI bridge to [bus 05-05]
[    2.453143] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    2.453259] pci 0000:00:1c.0:   bridge window [mem 0xdbc00000-0xdbdfffff]
[    2.453374] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    2.453490] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
[    2.453600] pci 0000:00:1c.5:   bridge window [io  disabled]
[    2.453716] pci 0000:00:1c.5:   bridge window [mem 0xdbb00000-0xdbbfffff]
[    2.453831] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    2.453947] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    2.454057] pci 0000:00:1e.0:   bridge window [io  disabled]
[    2.454171] pci 0000:00:1e.0:   bridge window [mem 0xdba00000-0xdbafffff]
[    2.454287] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.454407]   alloc irq_desc for 16 on node -1
[    2.454409]   alloc kstat_irqs on node -1
[    2.454412] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.454528] pci 0000:00:01.0: setting latency timer to 64
[    2.454534]   alloc irq_desc for 28 on node -1
[    2.454535]   alloc kstat_irqs on node -1
[    2.454538] pci 0000:01:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    2.454655] pci 0000:01:00.0: setting latency timer to 64
[    2.454661] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.454776] pci 0000:00:03.0: setting latency timer to 64
[    2.454781] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.454896] pci 0000:00:07.0: setting latency timer to 64
[    2.454902] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.455018] pci 0000:00:1c.0: setting latency timer to 64
[    2.455024]   alloc irq_desc for 17 on node -1
[    2.455025]   alloc kstat_irqs on node -1
[    2.455027] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.455142] pci 0000:00:1c.5: setting latency timer to 64
[    2.455147] pci 0000:00:1e.0: setting latency timer to 64
[    2.455152] pci 0000:80:03.0: PCI bridge to [bus 81-81]
[    2.455263] pci 0000:80:03.0:   bridge window [io  disabled]
[    2.455377] pci 0000:80:03.0:   bridge window [mem 0x9fe00000-0x9fefffff]
[    2.455492] pci 0000:80:03.0:   bridge window [mem pref disabled]
[    2.455610] pci 0000:80:07.0: PCI bridge to [bus 82-82]
[    2.455720] pci 0000:80:07.0:   bridge window [io  disabled]
[    2.455835] pci 0000:80:07.0:   bridge window [mem 0x9fd00000-0x9fdfffff]
[    2.455950] pci 0000:80:07.0:   bridge window [mem pref disabled]
[    2.456066] pci 0000:80:09.0: PCI bridge to [bus 83-83]
[    2.456176] pci 0000:80:09.0:   bridge window [io  disabled]
[    2.456290] pci 0000:80:09.0:   bridge window [mem 0x9fc00000-0x9fcfffff]
[    2.456405] pci 0000:80:09.0:   bridge window [mem pref disabled]
[    2.456525] pci 0000:80:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.456642] pci 0000:80:03.0: setting latency timer to 64
[    2.456648] pci 0000:80:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.456763] pci 0000:80:07.0: setting latency timer to 64
[    2.456769] pci 0000:80:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.456884] pci 0000:80:09.0: setting latency timer to 64
[    2.456886] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    2.456888] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffff=
ff]
[    2.456890] pci_bus 0000:01: resource 1 [mem 0xdbe00000-0xdbefffff]
[    2.456891] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    2.456893] pci_bus 0000:03: resource 1 [mem 0xdc000000-0xdfefffff]
[    2.456894] pci_bus 0000:03: resource 2 [mem 0xa0000000-0xbfffffff 64bit=
 pref]
[    2.456896] pci_bus 0000:04: resource 1 [mem 0xdbf00000-0xdbffffff]
[    2.456898] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    2.456899] pci_bus 0000:05: resource 1 [mem 0xdbc00000-0xdbdfffff]
[    2.456901] pci_bus 0000:06: resource 1 [mem 0xdbb00000-0xdbbfffff]
[    2.456902] pci_bus 0000:07: resource 1 [mem 0xdba00000-0xdbafffff]
[    2.456904] pci_bus 0000:07: resource 3 [io  0x0000-0xffff]
[    2.456905] pci_bus 0000:07: resource 4 [mem 0x00000000-0xffffffffffffff=
ff]
[    2.456907] pci_bus 0000:80: resource 0 [io  0x0000-0xffff]
[    2.456908] pci_bus 0000:80: resource 1 [mem 0x00000000-0xffffffffffffff=
ff]
[    2.456910] pci_bus 0000:81: resource 1 [mem 0x9fe00000-0x9fefffff]
[    2.456911] pci_bus 0000:82: resource 1 [mem 0x9fd00000-0x9fdfffff]
[    2.456913] pci_bus 0000:83: resource 1 [mem 0x9fc00000-0x9fcfffff]
[    2.456926] NET: Registered protocol family 2
[    2.457075] IP route cache hash table entries: 524288 (order: 10, 419430=
4 bytes)
[    2.457684] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    2.458465] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.458722] TCP: Hash tables configured (established 262144 bind 65536)
[    2.458836] TCP reno registered
[    2.458946] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    2.459147] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    2.459445] NET: Registered protocol family 1
[    2.459578] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd =3D 0x0080
[    2.459579] pci 0000:00:1a.0: Performing full reset
[    2.459595] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd =3D 0x0080
[    2.459596] pci 0000:00:1a.1: Performing full reset
[    2.459612] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd =3D 0x0080
[    2.459614] pci 0000:00:1a.2: Performing full reset
[    2.459655] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd =3D 0x0080
[    2.459656] pci 0000:00:1d.0: Performing full reset
[    2.459671] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd =3D 0x0080
[    2.459673] pci 0000:00:1d.1: Performing full reset
[    2.459687] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd =3D 0x0080
[    2.459689] pci 0000:00:1d.2: Performing full reset
[    2.459741] pci 0000:03:00.0: Boot video device
[    2.459763] PCI: CLS 64 bytes, default 64
[    2.459824] IOMMU 0x9fffe000: using Queued invalidation
[    2.459938] IOMMU 0xfedc0000: using Queued invalidation
[    2.460051] IOMMU: Setting RMRR:
[    2.460167] IOMMU: Setting identity map for device 0000:00:1d.0 [0x9be58=
000 - 0x9be70000]
[    2.460360] IOMMU: Setting identity map for device 0000:00:1d.1 [0x9be58=
000 - 0x9be70000]
[    2.460548] IOMMU: Setting identity map for device 0000:00:1d.2 [0x9be58=
000 - 0x9be70000]
[    2.460737] IOMMU: Setting identity map for device 0000:00:1d.7 [0x9be58=
000 - 0x9be70000]
[    2.460925] IOMMU: Setting identity map for device 0000:00:1a.0 [0x9be58=
000 - 0x9be70000]
[    2.461112] IOMMU: Setting identity map for device 0000:00:1a.1 [0x9be58=
000 - 0x9be70000]
[    2.461298] IOMMU: Setting identity map for device 0000:00:1a.2 [0x9be58=
000 - 0x9be70000]
[    2.461484] IOMMU: Setting identity map for device 0000:00:1a.7 [0x9be58=
000 - 0x9be70000]
[    2.461665] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    2.461783] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
x1000000]
[    2.462052]   alloc irq_desc for 72 on node 0
[    2.462054]   alloc kstat_irqs on node 0
[    2.462079]   alloc irq_desc for 73 on node 0
[    2.462080]   alloc kstat_irqs on node 0
[    2.462094] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    2.463678] Simple Boot Flag at 0x7a set to 0x1
[    2.465205] microcode: CPU0 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.465322] microcode: CPU1 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.465439] microcode: CPU2 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.465555] microcode: CPU3 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.465673] microcode: CPU4 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.465788] microcode: CPU5 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.466818] microcode: CPU6 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.466935] microcode: CPU7 sig=3D0x106a5, pf=3D0x1, revision=3D0x11
[    2.467072] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.467236] Scanning for low memory corruption every 60 seconds
[    2.468115] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.470026] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, no debug enabled
[    2.470662] msgmni has been set to 32768
[    2.470874] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    2.471036] io scheduler noop registered
[    2.471145] io scheduler deadline registered
[    2.471314] io scheduler cfq registered (default)
[    2.471491] pcieport 0000:00:01.0: setting latency timer to 64
[    2.471515]   alloc irq_desc for 74 on node -1
[    2.471517]   alloc kstat_irqs on node -1
[    2.471522] pcieport 0000:00:01.0: irq 74 for MSI/MSI-X
[    2.471598] pcieport 0000:00:03.0: setting latency timer to 64
[    2.471621]   alloc irq_desc for 75 on node -1
[    2.471622]   alloc kstat_irqs on node -1
[    2.471626] pcieport 0000:00:03.0: irq 75 for MSI/MSI-X
[    2.471776] pcieport 0000:00:07.0: setting latency timer to 64
[    2.471799]   alloc irq_desc for 76 on node -1
[    2.471800]   alloc kstat_irqs on node -1
[    2.471804] pcieport 0000:00:07.0: irq 76 for MSI/MSI-X
[    2.471873] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.471899]   alloc irq_desc for 77 on node -1
[    2.471900]   alloc kstat_irqs on node -1
[    2.471905] pcieport 0000:00:1c.0: irq 77 for MSI/MSI-X
[    2.471976] pcieport 0000:00:1c.5: setting latency timer to 64
[    2.472001]   alloc irq_desc for 78 on node -1
[    2.472003]   alloc kstat_irqs on node -1
[    2.472008] pcieport 0000:00:1c.5: irq 78 for MSI/MSI-X
[    2.472086] pcieport 0000:80:03.0: setting latency timer to 64
[    2.472112]   alloc irq_desc for 79 on node -1
[    2.472113]   alloc kstat_irqs on node -1
[    2.472118] pcieport 0000:80:03.0: irq 79 for MSI/MSI-X
[    2.472191] pcieport 0000:80:07.0: setting latency timer to 64
[    2.472217]   alloc irq_desc for 80 on node -1
[    2.472218]   alloc kstat_irqs on node -1
[    2.472223] pcieport 0000:80:07.0: irq 80 for MSI/MSI-X
[    2.472299] pcieport 0000:80:09.0: setting latency timer to 64
[    2.472325]   alloc irq_desc for 81 on node -1
[    2.472326]   alloc kstat_irqs on node -1
[    2.472331] pcieport 0000:80:09.0: irq 81 for MSI/MSI-X
[    2.472421] aer 0000:00:01.0:pcie02: AER service couldn't init device: n=
o _OSC support
[    2.472425] aer 0000:00:03.0:pcie02: AER service couldn't init device: n=
o _OSC support
[    2.472429] aer 0000:00:07.0:pcie02: AER service couldn't init device: n=
o _OSC support
[    2.472432] aer 0000:80:03.0:pcie02: AER service couldn't init device: n=
o _OSC support
[    2.472436] aer 0000:80:07.0:pcie02: AER service couldn't init device: n=
o _OSC support
[    2.472439] aer 0000:80:09.0:pcie02: AER service couldn't init device: n=
o _OSC support
[    2.472492] pci-stub: invalid id string ""
[    2.472707] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    2.472875] ACPI: Power Button [VBTN]
[    2.473025] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    2.473186] ACPI: Power Button [PWRF]
[    2.473621] Monitor-Mwait will be used to enter C-1 state
[    2.473634] Monitor-Mwait will be used to enter C-2 state
[    2.473645] Monitor-Mwait will be used to enter C-3 state
[    2.558238] Linux agpgart interface v0.103
[    2.558395] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.802104] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.802503] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.802737] parport_pc 00:06: reported by Plug and Play ACPI
[    2.802900] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSP=
P,TRISTATE,COMPAT,ECP]
[    2.886506] loop: module loaded
[    2.886784] ahci 0000:00:1f.2: version 3.0
[    2.886793]   alloc irq_desc for 20 on node -1
[    2.886794]   alloc kstat_irqs on node -1
[    2.886798] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    2.886940]   alloc irq_desc for 82 on node -1
[    2.886941]   alloc kstat_irqs on node -1
[    2.886946] ahci 0000:00:1f.2: irq 82 for MSI/MSI-X
[    2.886995] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x=
27 impl SATA mode
[    2.887159] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio ccc ems=
 sxs=20
[    2.887276] ahci 0000:00:1f.2: setting latency timer to 64
[    2.893892] scsi0 : ahci
[    2.894071] scsi1 : ahci
[    2.894235] scsi2 : ahci
[    2.894397] scsi3 : ahci
[    2.894550] scsi4 : ahci
[    2.894708] scsi5 : ahci
[    2.894857] ata1: SATA max UDMA/133 abar m2048@0xff970000 port 0xff97010=
0 irq 82
[    2.895021] ata2: SATA max UDMA/133 abar m2048@0xff970000 port 0xff97018=
0 irq 82
[    2.895183] ata3: SATA max UDMA/133 abar m2048@0xff970000 port 0xff97020=
0 irq 82
[    2.895343] ata4: DUMMY
[    2.895448] ata5: DUMMY
[    2.895555] ata6: SATA max UDMA/133 abar m2048@0xff970000 port 0xff97038=
0 irq 82
[    2.895771] tg3.c:v3.106 (January 12, 2010)
[    2.895896] tg3 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.896015] tg3 0000:06:00.0: setting latency timer to 64
[    2.911076] eth0: Tigon3 [partno(BCM95761) rev 5761100] (PCI Express) MA=
C address 00:23:ae:90:91:d8
[    2.911242] eth0: attached PHY is 5761 (10/100/1000Base-T Ethernet) (Wir=
eSpeed[1])
[    2.911403] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.911516] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.911652] tun: Universal TUN/TAP device driver, 1.6
[    2.911763] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.911906] Fusion MPT base driver 3.04.13
[    2.912016] Copyright (c) 1999-2008 LSI Corporation
[    2.912128] Fusion MPT SAS Host driver 3.04.13
[    2.912254] mptsas 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[    2.912400] mptbase: ioc0: Initiating bringup
[    3.189311] ioc0: LSISAS1068E B3: Capabilities=3D{Initiator}
[    3.189661] mptsas 0000:05:00.0: setting latency timer to 64
[    3.199303] ata3: SATA link down (SStatus 4 SControl 300)
[    3.199305] ata6: SATA link down (SStatus 0 SControl 300)
[    3.199332] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.199340] ata2: SATA link down (SStatus 4 SControl 300)
[    3.205937] ata1.00: ATAPI: Optiarc DVD+/-RW AD-7230S, 100B, max UDMA/10=
0, ATAPI AN
[    3.217670] ata1.00: configured for UDMA/100
[    3.244208] scsi 0:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-7230S 10=
0B PQ: 0 ANSI: 5
[    3.282108] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    3.282281] Uniform CD-ROM driver Revision: 3.20
[    3.282467] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.282522] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   19.704101] scsi6 : ioc0: LSISAS1068E B3, FwRev=3D00192f00h, Ports=3D1, =
MaxQ=3D266, IRQ=3D16
[   19.738868] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 0, =
phy 0, sas_addr 0x1221000000000000
[   19.741512] scsi 6:0:0:0: Direct-Access     ATA      ST3500418AS      CC=
44 PQ: 0 ANSI: 5
[   19.743172] sd 6:0:0:0: Attached scsi generic sg1 type 0
[   19.744088] sd 6:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[   19.744694] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 1, =
phy 1, sas_addr 0x1221000001000000
[   19.747321] scsi 6:0:1:0: Direct-Access     ATA      ST3500418AS      CC=
44 PQ: 0 ANSI: 5
[   19.749072] sd 6:0:1:0: Attached scsi generic sg2 type 0
[   19.749981] sd 6:0:1:0: [sdb] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[   19.750585] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 2, =
phy 2, sas_addr 0x1221000002000000
[   19.755407] scsi 6:0:2:0: Direct-Access     ATA      WDC WD15EARS-00Z 0A=
80 PQ: 0 ANSI: 5
[   19.757058] sd 6:0:2:0: Attached scsi generic sg3 type 0
[   19.757474] sd 6:0:2:0: [sdc] 2930277168 512-byte logical blocks: (1.50 =
TB/1.36 TiB)
[   19.758646] Fusion MPT misc device (ioctl) driver 3.04.13
[   19.758788] mptctl: Registered with Fusion MPT base driver
[   19.758901] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   19.759015] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   19.759129] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[   19.759143]   alloc irq_desc for 22 on node -1
[   19.759144]   alloc kstat_irqs on node -1
[   19.759147] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[   19.759272] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   19.759274] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   19.759394] drivers/usb/core/inode.c: creating file 'devices'
[   19.759396] drivers/usb/core/inode.c: creating file '001'
[   19.759399] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[   19.759565] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=3D1 cc=
=3D3 pcc=3D2 ordered !ppc ports=3D6
[   19.759568] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 ufram=
es 1024 64 bit addr
[   19.759596] ehci_hcd 0000:00:1a.7: debug port 1
[   19.759708] ehci_hcd 0000:00:1a.7: reset command 000002 (park)=3D0 ithre=
sh=3D0 period=3D1024 Reset HALT
[   19.763590] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   19.763592] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[   19.763602] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xdfffa000
[   19.763716] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=3D0 ithre=
sh=3D8 period=3D1024 Reset HALT
[   19.767579] ehci_hcd 0000:00:1a.7: init command 010001 (park)=3D0 ithres=
h=3D1 period=3D1024 RUN
[   19.769078] sd 6:0:2:0: [sdc] Write Protect is off
[   19.769193] sd 6:0:2:0: [sdc] Mode Sense: 73 00 00 08
[   19.772944] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   19.773074] usb usb1: default language 0x0409
[   19.773079] usb usb1: udev 1, busnum 1, minor =3D 0
[   19.773080] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   19.773194] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.773361] usb usb1: Product: EHCI Host Controller
[   19.773471] usb usb1: Manufacturer: Linux 2.6.33 ehci_hcd
[   19.773582] usb usb1: SerialNumber: 0000:00:1a.7
[   19.773721] sd 6:0:2:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   19.773910] usb usb1: usb_probe_device
[   19.773912] usb usb1: configuration #1 chosen from 1 choice
[   19.773917] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   19.773948] hub 1-0:1.0: usb_probe_interface
[   19.773950] hub 1-0:1.0: usb_probe_interface - got id
[   19.773951] hub 1-0:1.0: USB hub found
[   19.774069] hub 1-0:1.0: 6 ports detected
[   19.774179] hub 1-0:1.0: standalone hub
[   19.774180] hub 1-0:1.0: no power switching (usb 1.0)
[   19.774181] hub 1-0:1.0: individual port over-current protection
[   19.774182] hub 1-0:1.0: power on to power good time: 20ms
[   19.774185] hub 1-0:1.0: local power source is good
[   19.774187] hub 1-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.774207] drivers/usb/core/inode.c: creating file '001'
[   19.774225]   alloc irq_desc for 23 on node -1
[   19.774226]   alloc kstat_irqs on node -1
[   19.774229] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[   19.774353] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   19.774355] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   19.774468] drivers/usb/core/inode.c: creating file '002'
[   19.774470] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[   19.774635] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=3D1 cc=
=3D3 pcc=3D2 ordered !ppc ports=3D6
[   19.774638] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 ufram=
es 1024 64 bit addr
[   19.774666] ehci_hcd 0000:00:1d.7: debug port 1
[   19.774777] ehci_hcd 0000:00:1d.7: reset command 000002 (park)=3D0 ithre=
sh=3D0 period=3D1024 Reset HALT
[   19.778640] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   19.778642] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   19.778651] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980000
[   19.778764] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=3D0 ithre=
sh=3D8 period=3D1024 Reset HALT
[   19.782629] ehci_hcd 0000:00:1d.7: init command 010001 (park)=3D0 ithres=
h=3D1 period=3D1024 RUN
[   19.787918] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   19.788043] usb usb2: default language 0x0409
[   19.788047] usb usb2: udev 1, busnum 2, minor =3D 128
[   19.788049] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   19.788163] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.788324] usb usb2: Product: EHCI Host Controller
[   19.788434] usb usb2: Manufacturer: Linux 2.6.33 ehci_hcd
[   19.788545] usb usb2: SerialNumber: 0000:00:1d.7
[   19.788698] usb usb2: usb_probe_device
[   19.788700] usb usb2: configuration #1 chosen from 1 choice
[   19.788704] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   19.788738] hub 2-0:1.0: usb_probe_interface
[   19.788740] hub 2-0:1.0: usb_probe_interface - got id
[   19.788741] hub 2-0:1.0: USB hub found
[   19.788852] hub 2-0:1.0: 6 ports detected
[   19.788963] hub 2-0:1.0: standalone hub
[   19.788964] hub 2-0:1.0: no power switching (usb 1.0)
[   19.788965] hub 2-0:1.0: individual port over-current protection
[   19.788967] hub 2-0:1.0: power on to power good time: 20ms
[   19.788969] hub 2-0:1.0: local power source is good
[   19.788970] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.788993] drivers/usb/core/inode.c: creating file '001'
[   19.789026] uhci_hcd: USB Universal Host Controller Interface driver
[   19.789189] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   19.789308] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   19.789310] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   19.789423] drivers/usb/core/inode.c: creating file '003'
[   19.789426] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[   19.789591] uhci_hcd 0000:00:1a.0: detected 2 ports
[   19.789703] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   19.789705] uhci_hcd 0000:00:1a.0: Performing full reset
[   19.789717] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   19.789721] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001f20
[   19.789864] usb usb3: default language 0x0409
[   19.789867] usb usb3: udev 1, busnum 3, minor =3D 256
[   19.789869] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   19.789985] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.790146] usb usb3: Product: UHCI Host Controller
[   19.790256] usb usb3: Manufacturer: Linux 2.6.33 uhci_hcd
[   19.790368] usb usb3: SerialNumber: 0000:00:1a.0
[   19.790517] usb usb3: usb_probe_device
[   19.790519] usb usb3: configuration #1 chosen from 1 choice
[   19.790522] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   19.790551] hub 3-0:1.0: usb_probe_interface
[   19.790553] hub 3-0:1.0: usb_probe_interface - got id
[   19.790554] hub 3-0:1.0: USB hub found
[   19.790665] hub 3-0:1.0: 2 ports detected
[   19.790773] hub 3-0:1.0: standalone hub
[   19.790774] hub 3-0:1.0: no power switching (usb 1.0)
[   19.790775] hub 3-0:1.0: individual port over-current protection
[   19.790777] hub 3-0:1.0: power on to power good time: 2ms
[   19.790779] hub 3-0:1.0: local power source is good
[   19.790780] hub 3-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.790789] drivers/usb/core/inode.c: creating file '001'
[   19.790809] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[   19.790930] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   19.790932] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   19.791047] drivers/usb/core/inode.c: creating file '004'
[   19.791049] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[   19.791215] uhci_hcd 0000:00:1a.1: detected 2 ports
[   19.791327] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   19.791328] uhci_hcd 0000:00:1a.1: Performing full reset
[   19.791341] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[   19.791350] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00001f00
[   19.791493] usb usb4: default language 0x0409
[   19.791497] usb usb4: udev 1, busnum 4, minor =3D 384
[   19.791498] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   19.791612] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.791773] usb usb4: Product: UHCI Host Controller
[   19.791884] usb usb4: Manufacturer: Linux 2.6.33 uhci_hcd
[   19.791997] usb usb4: SerialNumber: 0000:00:1a.1
[   19.792147] usb usb4: usb_probe_device
[   19.792149] usb usb4: configuration #1 chosen from 1 choice
[   19.792153] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   19.792180] hub 4-0:1.0: usb_probe_interface
[   19.792181] hub 4-0:1.0: usb_probe_interface - got id
[   19.792183] hub 4-0:1.0: USB hub found
[   19.792293] hub 4-0:1.0: 2 ports detected
[   19.792401] hub 4-0:1.0: standalone hub
[   19.792402] hub 4-0:1.0: no power switching (usb 1.0)
[   19.792403] hub 4-0:1.0: individual port over-current protection
[   19.792405] hub 4-0:1.0: power on to power good time: 2ms
[   19.792407] hub 4-0:1.0: local power source is good
[   19.792408] hub 4-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.792418] drivers/usb/core/inode.c: creating file '001'
[   19.792438] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[   19.792555] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   19.792557] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   19.792670] drivers/usb/core/inode.c: creating file '005'
[   19.792672] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[   19.792838] uhci_hcd 0000:00:1a.2: detected 2 ports
[   19.792953] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   19.792954] uhci_hcd 0000:00:1a.2: Performing full reset
[   19.792966] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[   19.792971] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00001c00
[   19.793114] usb usb5: default language 0x0409
[   19.793117] usb usb5: udev 1, busnum 5, minor =3D 512
[   19.793119] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   19.793233] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.793394] usb usb5: Product: UHCI Host Controller
[   19.793504] usb usb5: Manufacturer: Linux 2.6.33 uhci_hcd
[   19.793615] usb usb5: SerialNumber: 0000:00:1a.2
[   19.793765] usb usb5: usb_probe_device
[   19.793767] usb usb5: configuration #1 chosen from 1 choice
[   19.793771] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   19.793798] hub 5-0:1.0: usb_probe_interface
[   19.793799] hub 5-0:1.0: usb_probe_interface - got id
[   19.793800] hub 5-0:1.0: USB hub found
[   19.794836] hub 5-0:1.0: 2 ports detected
[   19.794946] hub 5-0:1.0: standalone hub
[   19.794947] hub 5-0:1.0: no power switching (usb 1.0)
[   19.794948] hub 5-0:1.0: individual port over-current protection
[   19.794950] hub 5-0:1.0: power on to power good time: 2ms
[   19.794952] hub 5-0:1.0: local power source is good
[   19.794954] hub 5-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.794963] drivers/usb/core/inode.c: creating file '001'
[   19.794991] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[   19.795113] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   19.795116] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   19.795232] drivers/usb/core/inode.c: creating file '006'
[   19.795235] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[   19.795403] uhci_hcd 0000:00:1d.0: detected 2 ports
[   19.795517] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   19.795519] uhci_hcd 0000:00:1d.0: Performing full reset
[   19.795532] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   19.795536] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001f80
[   19.795687] usb usb6: default language 0x0409
[   19.795693] usb usb6: udev 1, busnum 6, minor =3D 640
[   19.795695] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   19.795811] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.795977] usb usb6: Product: UHCI Host Controller
[   19.796090] usb usb6: Manufacturer: Linux 2.6.33 uhci_hcd
[   19.796203] usb usb6: SerialNumber: 0000:00:1d.0
[   19.796361] usb usb6: usb_probe_device
[   19.796363] usb usb6: configuration #1 chosen from 1 choice
[   19.796367] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   19.796398] hub 6-0:1.0: usb_probe_interface
[   19.796399] hub 6-0:1.0: usb_probe_interface - got id
[   19.796400] hub 6-0:1.0: USB hub found
[   19.796511] hub 6-0:1.0: 2 ports detected
[   19.796620] hub 6-0:1.0: standalone hub
[   19.796621] hub 6-0:1.0: no power switching (usb 1.0)
[   19.796622] hub 6-0:1.0: individual port over-current protection
[   19.796623] hub 6-0:1.0: power on to power good time: 2ms
[   19.796625] hub 6-0:1.0: local power source is good
[   19.796627] hub 6-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.796635] drivers/usb/core/inode.c: creating file '001'
[   19.796655] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[   19.796773] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   19.796775] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   19.796888] drivers/usb/core/inode.c: creating file '007'
[   19.796890] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[   19.797058] uhci_hcd 0000:00:1d.1: detected 2 ports
[   19.797170] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   19.797172] uhci_hcd 0000:00:1d.1: Performing full reset
[   19.797184] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   19.797187] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001f60
[   19.797331] usb usb7: default language 0x0409
[   19.797335] usb usb7: udev 1, busnum 7, minor =3D 768
[   19.797337] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   19.797451] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.797612] usb usb7: Product: UHCI Host Controller
[   19.797722] usb usb7: Manufacturer: Linux 2.6.33 uhci_hcd
[   19.797833] usb usb7: SerialNumber: 0000:00:1d.1
[   19.797987] usb usb7: usb_probe_device
[   19.797989] usb usb7: configuration #1 chosen from 1 choice
[   19.797993] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   19.798021] hub 7-0:1.0: usb_probe_interface
[   19.798022] hub 7-0:1.0: usb_probe_interface - got id
[   19.798023] hub 7-0:1.0: USB hub found
[   19.798133] hub 7-0:1.0: 2 ports detected
[   19.798242] hub 7-0:1.0: standalone hub
[   19.798243] hub 7-0:1.0: no power switching (usb 1.0)
[   19.798244] hub 7-0:1.0: individual port over-current protection
[   19.798245] hub 7-0:1.0: power on to power good time: 2ms
[   19.798248] hub 7-0:1.0: local power source is good
[   19.798249] hub 7-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.798257] drivers/usb/core/inode.c: creating file '001'
[   19.798279]   alloc irq_desc for 18 on node -1
[   19.798280]   alloc kstat_irqs on node -1
[   19.798283] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[   19.798401] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   19.798412] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   19.798528] drivers/usb/core/inode.c: creating file '008'
[   19.798531] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[   19.798699] uhci_hcd 0000:00:1d.2: detected 2 ports
[   19.798813] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   19.798815] uhci_hcd 0000:00:1d.2: Performing full reset
[   19.798828] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   19.798838] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001f40
[   19.798990] usb usb8: default language 0x0409
[   19.798995] usb usb8: udev 1, busnum 8, minor =3D 896
[   19.798997] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   19.799114] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   19.799277] usb usb8: Product: UHCI Host Controller
[   19.799389] usb usb8: Manufacturer: Linux 2.6.33 uhci_hcd
[   19.799503] usb usb8: SerialNumber: 0000:00:1d.2
[   19.799659] usb usb8: usb_probe_device
[   19.799661] usb usb8: configuration #1 chosen from 1 choice
[   19.799664] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[   19.799696] hub 8-0:1.0: usb_probe_interface
[   19.799697] hub 8-0:1.0: usb_probe_interface - got id
[   19.799698] hub 8-0:1.0: USB hub found
[   19.799809] hub 8-0:1.0: 2 ports detected
[   19.799919] hub 8-0:1.0: standalone hub
[   19.799920] hub 8-0:1.0: no power switching (usb 1.0)
[   19.799921] hub 8-0:1.0: individual port over-current protection
[   19.799923] hub 8-0:1.0: power on to power good time: 2ms
[   19.799925] hub 8-0:1.0: local power source is good
[   19.799926] hub 8-0:1.0: trying to enable port power on non-switchable h=
ub
[   19.799937] drivers/usb/core/inode.c: creating file '001'
[   19.799979] Initializing USB Mass Storage driver...
[   19.800134] usbcore: registered new interface driver usb-storage
[   19.800247] USB Mass Storage support registered.
[   19.800446] PNP: No PS/2 controller found. Probing ports directly.
[   19.802173]  sdc:
[   19.803307] serio: i8042 KBD port at 0x60,0x64 irq 1
[   19.803521] serio: i8042 AUX port at 0x60,0x64 irq 12
[   19.803678] mice: PS/2 mouse device common for all mice
[   19.803913] rtc_cmos 00:05: RTC can wake from S4
[   19.804062] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   19.804196] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[   19.804338] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 20 (level, low) ->=
 IRQ 20
[   19.805159] cpuidle: using governor ladder
[   19.806492] cpuidle: using governor menu
[   19.807327] usbcore: registered new interface driver hiddev
[   19.807462] usbcore: registered new interface driver usbhid
[   19.807575] usbhid: USB HID core driver
[   19.807684] Netfilter messages via NETLINK v0.30.
[   19.807802] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   19.808091] ctnetlink v0.93: registering with nfnetlink.
[   19.808428] ip_tables: (C) 2000-2006 Netfilter Core Team
[   19.808551] TCP cubic registered
[   19.808834] NET: Registered protocol family 10
[   19.809603] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   19.809747] NET: Registered protocol family 17
[   19.809882] Bridge firewalling registered
[   19.810420] sd 6:0:1:0: [sdb] Write Protect is off
[   19.810533] sd 6:0:1:0: [sdb] Mode Sense: 73 00 00 08
[   19.812782] sd 6:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   19.814242] sd 6:0:0:0: [sda] Write Protect is off
[   19.814360] sd 6:0:0:0: [sda] Mode Sense: 73 00 00 08
[   19.816696] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   19.854168]  sdb:
[   19.858056]  sda:
[   19.873928] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   19.880101]  sdb1
[   19.887956] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   19.889901] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.891900] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.892288]  sda1 sda2
[   19.894873] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.895871] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.897861] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.899858] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   19.945761] sd 6:0:1:0: [sdb] Attached SCSI disk
[   19.957969] sd 6:0:0:0: [sda] Attached SCSI disk
[   20.282684]  sdc1
[   20.309377] sd 6:0:2:0: [sdc] Attached SCSI disk
[   20.393590] XFS mounting filesystem sda2
[   20.528870] Ending clean XFS mount for filesystem: sda2
[   20.529040] VFS: Mounted root (xfs filesystem) readonly on device 8:2.
[   20.529175] Freeing unused kernel memory: 396k freed
[   20.904019] usb usb3: suspend_rh (auto-stop)
[   20.904039] usb usb4: suspend_rh (auto-stop)
[   20.904059] usb usb5: suspend_rh (auto-stop)
[   20.904078] usb usb6: suspend_rh (auto-stop)
[   20.904097] usb usb7: suspend_rh (auto-stop)
[   20.904116] usb usb8: suspend_rh (auto-stop)
[   22.451502] udev: starting version 151
[   22.571378] sd 6:0:1:0: [sdb] Sense Key : Recovered Error [current] [des=
criptor]
[   22.571383] Descriptor sense data with sense descriptors (in hex):
[   22.571385]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00=20
[   22.571393]         00 00 00 00 00 00=20
[   22.571397] sd 6:0:1:0: [sdb] Add. Sense: ATA pass through information a=
vailable
[   22.573041] sd 6:0:2:0: [sdc] Sense Key : Recovered Error [current] [des=
criptor]
[   22.573044] Descriptor sense data with sense descriptors (in hex):
[   22.573046]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00=20
[   22.573051]         00 00 00 00 00 00=20
[   22.573054] sd 6:0:2:0: [sdc] Add. Sense: ATA pass through information a=
vailable
[   22.635819] sd 6:0:0:0: [sda] Sense Key : Recovered Error [current] [des=
criptor]
[   22.635824] Descriptor sense data with sense descriptors (in hex):
[   22.635826]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00=20
[   22.635835]         00 00 00 00 00 00=20
[   22.635839] sd 6:0:0:0: [sda] Add. Sense: ATA pass through information a=
vailable
[   23.160550] ppdev: user-space parallel port driver
[   23.757262] XFS mounting filesystem sdc1
[   23.966707] Ending clean XFS mount for filesystem: sdc1
[   24.025216] Adding 33559744k swap on /dev/sda1.  Priority:-1 extents:1 a=
cross:33559744k=20
[   29.028262] device eth0 entered promiscuous mode
[   29.029429]   alloc irq_desc for 83 on node -1
[   29.029432]   alloc kstat_irqs on node -1
[   29.029449] tg3 0000:06:00.0: irq 83 for MSI/MSI-X
[   29.695255] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   29.915793] device tapvista entered promiscuous mode
[   29.915814] br0: port 2(tapvista) entering learning state
[   29.921182] device tapflowmon entered promiscuous mode
[   29.921201] br0: port 3(tapflowmon) entering learning state
[   29.926751] device tapbackup entered promiscuous mode
[   29.926772] br0: port 4(tapbackup) entering learning state
[   40.052308] tapbackup: no IPv6 routers present
[   40.096174] tapvista: no IPv6 routers present
[   40.221030] tapflowmon: no IPv6 routers present
[   40.232010] br0: no IPv6 routers present
[   44.890057] br0: port 2(tapvista) entering forwarding state
[   44.895035] br0: port 3(tapflowmon) entering forwarding state
[   44.901023] br0: port 4(tapbackup) entering forwarding state
[  202.078556] irq 16: nobody cared (try booting with the "irqpoll" option)
[  202.078561] Pid: 0, comm: swapper Not tainted 2.6.33 #1
[  202.078563] Call Trace:
[  202.078565]  <IRQ>  [<ffffffff8106ef16>] __report_bad_irq+0x26/0xa0
[  202.078574]  [<ffffffff8106f11a>] note_interrupt+0x18a/0x1d0
[  202.078578]  [<ffffffff8106da0a>] ? handle_IRQ_event+0x4a/0xf0
[  202.078582]  [<ffffffff8106fe3d>] handle_fasteoi_irq+0xcd/0x100
[  202.078587]  [<ffffffff810055dd>] handle_irq+0x1d/0x30
[  202.078590]  [<ffffffff81005257>] do_IRQ+0x67/0xf0
[  202.078595]  [<ffffffff81414493>] ret_from_intr+0x0/0xa
[  202.078597]  <EOI>  [<ffffffff81211b48>] ? acpi_idle_enter_bm+0x224/0x24d
[  202.078606]  [<ffffffff81211b3e>] ? acpi_idle_enter_bm+0x21a/0x24d
[  202.078611]  [<ffffffff8131c72b>] cpuidle_idle_call+0x9b/0x100
[  202.078615]  [<ffffffff8100099c>] cpu_idle+0x9c/0xf0
[  202.078618]  [<ffffffff81003290>] ? kernel_thread_helper+0x0/0x10
[  202.078624]  [<ffffffff813fd9bf>] rest_init+0x8f/0xa0
[  202.078628]  [<ffffffff815ceb31>] start_kernel+0x322/0x32d
[  202.078632]  [<ffffffff815ce2e7>] x86_64_start_reservations+0xf7/0xfb
[  202.078636]  [<ffffffff815ce3d3>] x86_64_start_kernel+0xe8/0xef
[  202.078638] handlers:
[  202.078639] [<ffffffff812af0e0>] (mpt_interrupt+0x0/0x990)
[  202.078645] [<ffffffff812d6ed0>] (usb_hcd_irq+0x0/0x70)
[  202.078649] Disabling IRQ #16
[  217.333019] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[  217.333023] tg3: eth0: Flow control is off for TX and off for RX.
[  217.334768] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  217.334821] br0: port 1(eth0) entering learning state
[  227.325947] eth0: no IPv6 routers present
[  232.308454] br0: port 1(eth0) entering forwarding state
[ 1183.273396] kvm: 2305: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 1183.273400] kvm: 2305: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b737a
[ 1183.273404] kvm: 2305: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[ 1741.298850] kvm: 5030: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 1741.298854] kvm: 5030: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b7827
[ 1741.298858] kvm: 5030: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[ 1741.369075] kvm: 5030: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 1741.369078] kvm: 5030: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b7827
[ 1741.369083] kvm: 5030: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[ 2447.714833] kvm: 5138: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 2447.714837] kvm: 5138: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b7cd0
[ 2447.714841] kvm: 5138: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[ 2857.176544] kvm: 5261: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 2857.176548] kvm: 5261: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b7825
[ 2857.176555] kvm: 5261: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[ 2857.246264] kvm: 5261: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 2857.246267] kvm: 5261: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b7825
[ 2857.246272] kvm: 5261: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[ 3257.329504] CE: hpet increasing min_delta_ns to 15000 nsec
[ 5035.893063] kvm: 5798: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 5035.893067] kvm: 5798: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b7828
[ 5035.893071] kvm: 5798: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[ 5035.963095] kvm: 5798: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x13=
0079
[ 5035.963099] kvm: 5798: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xffd=
b7828
[ 5035.963106] kvm: 5798: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x53=
0079
[151482.168292] device br0 entered promiscuous mode
[151483.154562] device br0 left promiscuous mode
[151484.336534] device br0 entered promiscuous mode
[151491.117066] device br0 left promiscuous mode
[151523.606682] device tapbackup left promiscuous mode
[151523.606687] br0: port 4(tapbackup) entering disabled state
[151526.082144] device tapbackup entered promiscuous mode
[151526.082167] br0: port 4(tapbackup) entering learning state
[151541.056428] br0: port 4(tapbackup) entering forwarding state
[153358.892091] elevator: type cfg not found
[242451.777341] kvm: 32341: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x=
130079
[242451.777349] kvm: 32341: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xf=
fdb7826
[242451.777354] kvm: 32341: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x=
530079
[242451.847666] kvm: 32341: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x=
130079
[242451.847669] kvm: 32341: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xf=
fdb7826
[242451.847673] kvm: 32341: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x=
530079
[243239.702211] kvm: 32420: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x=
130079
[243239.702218] kvm: 32420: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xf=
fdb781f
[243239.702222] kvm: 32420: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x=
530079
[243239.772562] kvm: 32420: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x=
130079
[243239.772565] kvm: 32420: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xf=
fdb781f
[243239.772570] kvm: 32420: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x=
530079
[415355.980245] hrtimer: interrupt took 43190 ns
[429297.874565] CE: hpet increasing min_delta_ns to 22500 nsec
[516064.945188] kvm: 26388: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x=
130079
[516064.945192] kvm: 26388: cpu0 unimplemented perfctr wrmsr: 0xc1 data 0xf=
fdb7828
[516064.945197] kvm: 26388: cpu0 unimplemented perfctr wrmsr: 0x186 data 0x=
530079
[516065.015505] kvm: 26388: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x=
130079
[516065.015509] kvm: 26388: cpu1 unimplemented perfctr wrmsr: 0xc1 data 0xf=
fdb7828
[516065.015513] kvm: 26388: cpu1 unimplemented perfctr wrmsr: 0x186 data 0x=
530079

--3bc47Eih9dS+biPM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwa/o8ACgkQg/fU9pp1uX6pSgCgrfQFBMDvSZ4/zn7F5cwELUhy
tV0AoJ/nMO95Zj71XLxrL0SLJZMm0/t2
=mVsA
-----END PGP SIGNATURE-----

--3bc47Eih9dS+biPM--
