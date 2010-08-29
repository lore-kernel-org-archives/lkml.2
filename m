Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0H2MDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 08:03:32 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:40718 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752902Ab0H2MD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 08:03:28 -0400
Date: Sun, 29 Aug 2010 08:03:13 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <779893521.1479771283083393771.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C7A49F9.1030400@kernel.org>
Subject: Re: kdump regression compared to v2.6.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Tejun Heo" <tj@kernel.org> wrote:

> On 08/29/2010 01:56 PM, CAI Qian wrote:
> > It is easy to reproduce by passing maxcpus=1 to the first kernel.
> 
> Do you mean booting w/ maxcpus=1 hangs the first kernel even w/o
> kdump?
Yes, here was the log,

Linux version 2.6.36-rc2-mm1-orig+ (root@intel-s3e36-01.lab.bos.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #3 SMP Sun Aug 29 07:27:06 EDT 2010
Command line: ro root=/dev/mapper/vg_intels3e3601-lv_root rd_LVM_LV=vg_intels3e3601/lv_root rd_LVM_LV=vg_intels3e3601/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us console=ttyS0,115200n81 crashkernel=128M maxcpus=1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
 BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000078c51000 (usable)
 BIOS-e820: 0000000078c51000 - 0000000078e66000 (ACPI NVS)
 BIOS-e820: 0000000078e66000 - 0000000079238000 (ACPI data)
 BIOS-e820: 0000000079238000 - 00000000792ac000 (reserved)
 BIOS-e820: 00000000792ac000 - 00000000792b9000 (ACPI data)
 BIOS-e820: 00000000792b9000 - 00000000792ce000 (reserved)
 BIOS-e820: 00000000792ce000 - 00000000792e1000 (ACPI data)
 BIOS-e820: 00000000792e1000 - 00000000792e3000 (reserved)
 BIOS-e820: 00000000792e3000 - 00000000792ec000 (ACPI data)
 BIOS-e820: 00000000792ec000 - 00000000792f8000 (reserved)
 BIOS-e820: 00000000792f8000 - 00000000792f9000 (ACPI data)
 BIOS-e820: 00000000792f9000 - 00000000792ff000 (reserved)
 BIOS-e820: 00000000792ff000 - 0000000079320000 (ACPI data)
 BIOS-e820: 0000000079320000 - 0000000079341000 (reserved)
 BIOS-e820: 0000000079341000 - 0000000079370000 (ACPI data)
 BIOS-e820: 0000000079370000 - 00000000793b1000 (reserved)
 BIOS-e820: 00000000793b1000 - 000000007996a000 (ACPI data)
 BIOS-e820: 000000007996a000 - 0000000079b6a000 (ACPI NVS)
 BIOS-e820: 0000000079b6a000 - 0000000079cae000 (ACPI data)
 BIOS-e820: 0000000079cae000 - 0000000079cde000 (reserved)
 BIOS-e820: 0000000079cde000 - 0000000079d72000 (ACPI data)
 BIOS-e820: 0000000079d72000 - 0000000079d75000 (reserved)
 BIOS-e820: 0000000079d75000 - 0000000079e05000 (ACPI data)
 BIOS-e820: 0000000079e05000 - 0000000079e70000 (reserved)
 BIOS-e820: 0000000079e70000 - 000000007bd5f000 (ACPI data)
 BIOS-e820: 000000007bd5f000 - 000000007be4f000 (reserved)
 BIOS-e820: 000000007be4f000 - 000000007bf87000 (ACPI data)
 BIOS-e820: 000000007bf87000 - 000000007bfcf000 (ACPI NVS)
 BIOS-e820: 000000007bfcf000 - 000000007bfff000 (ACPI data)
 BIOS-e820: 000000007bfff000 - 0000000090000000 (reserved)
 BIOS-e820: 00000000fc000000 - 00000000fd000000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000001080000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
No AGP bridge found
last_pfn = 0x1080000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0x78c51 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff8800000fdd80] fdd80
init_memory_mapping: 0000000000000000-0000000078c51000
init_memory_mapping: 0000000100000000-0000001080000000
RAMDISK: 3754d000 - 37ff0000
Reserving 128MB of memory at 48MB for crashkernel (System RAM: 67584MB)
ACPI: RSDP 00000000000f0410 00024 (v02 QUANTA)
ACPI: XSDT 000000007bffe120 000B4 (v01 QUANTA QSSC-S4R 00000000      01000013)
ACPI: FACP 000000007bffd000 000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
ACPI: DSDT 000000007bfe3000 19F6A (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
ACPI: FACS 000000007bf87000 00040
ACPI: APIC 000000007bfe2000 003E4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
ACPI: MSCT 000000007bfe1000 00090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
ACPI: MCFG 000000007bfe0000 0003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
ACPI: HPET 000000007bfdf000 00038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
ACPI: SLIT 000000007bfde000 0003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
ACPI: SRAT 000000007bfdd000 00930 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
ACPI: SPCR 000000007bfdc000 00050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
ACPI: WDDT 000000007bfdb000 00040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
ACPI: SSDT 000000007bf4a000 3CFA4 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
ACPI: SSDT 000000007bfda000 00174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
ACPI: PMCT 000000007bfd9000 00060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
ACPI: MIGT 000000007bfd8000 00040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
ACPI: TCPA 000000007bfd5000 00032 (v00 QUANTA QSSC-S4R 00000000      00000000)
ACPI: HEST 000000007bfd4000 000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
ACPI: BERT 000000007bfd3000 00030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
ACPI: ERST 000000007bfd2000 00230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
ACPI: EINJ 000000007bfd1000 00130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 2 -> APIC 0x40 -> Node 1
SRAT: PXM 1 -> APIC 0x20 -> Node 2
SRAT: PXM 3 -> APIC 0x60 -> Node 3
SRAT: PXM 0 -> APIC 0x02 -> Node 0
SRAT: PXM 2 -> APIC 0x42 -> Node 1
SRAT: PXM 1 -> APIC 0x22 -> Node 2
SRAT: PXM 3 -> APIC 0x62 -> Node 3
SRAT: PXM 0 -> APIC 0x04 -> Node 0
SRAT: PXM 2 -> APIC 0x44 -> Node 1
SRAT: PXM 1 -> APIC 0x24 -> Node 2
SRAT: PXM 3 -> APIC 0x64 -> Node 3
SRAT: PXM 0 -> APIC 0x06 -> Node 0
SRAT: PXM 2 -> APIC 0x46 -> Node 1
SRAT: PXM 1 -> APIC 0x26 -> Node 2
SRAT: PXM 3 -> APIC 0x66 -> Node 3
SRAT: PXM 0 -> APIC 0x10 -> Node 0
SRAT: PXM 2 -> APIC 0x50 -> Node 1
SRAT: PXM 1 -> APIC 0x30 -> Node 2
SRAT: PXM 3 -> APIC 0x70 -> Node 3
SRAT: PXM 0 -> APIC 0x12 -> Node 0
SRAT: PXM 2 -> APIC 0x52 -> Node 1
SRAT: PXM 1 -> APIC 0x32 -> Node 2
SRAT: PXM 3 -> APIC 0x72 -> Node 3
SRAT: PXM 0 -> APIC 0x14 -> Node 0
SRAT: PXM 2 -> APIC 0x54 -> Node 1
SRAT: PXM 1 -> APIC 0x34 -> Node 2
SRAT: PXM 3 -> APIC 0x74 -> Node 3
SRAT: PXM 0 -> APIC 0x16 -> Node 0
SRAT: PXM 2 -> APIC 0x56 -> Node 1
SRAT: PXM 1 -> APIC 0x36 -> Node 2
SRAT: PXM 3 -> APIC 0x76 -> Node 3
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: PXM 2 -> APIC 0x41 -> Node 1
SRAT: PXM 1 -> APIC 0x21 -> Node 2
SRAT: PXM 3 -> APIC 0x61 -> Node 3
SRAT: PXM 0 -> APIC 0x03 -> Node 0
SRAT: PXM 2 -> APIC 0x43 -> Node 1
SRAT: PXM 1 -> APIC 0x23 -> Node 2
SRAT: PXM 3 -> APIC 0x63 -> Node 3
SRAT: PXM 0 -> APIC 0x05 -> Node 0
SRAT: PXM 2 -> APIC 0x45 -> Node 1
SRAT: PXM 1 -> APIC 0x25 -> Node 2
SRAT: PXM 3 -> APIC 0x65 -> Node 3
SRAT: PXM 0 -> APIC 0x07 -> Node 0
SRAT: PXM 2 -> APIC 0x47 -> Node 1
SRAT: PXM 1 -> APIC 0x27 -> Node 2
SRAT: PXM 3 -> APIC 0x67 -> Node 3
SRAT: PXM 0 -> APIC 0x11 -> Node 0
SRAT: PXM 2 -> APIC 0x51 -> Node 1
SRAT: PXM 1 -> APIC 0x31 -> Node 2
SRAT: PXM 3 -> APIC 0x71 -> Node 3
SRAT: PXM 0 -> APIC 0x13 -> Node 0
SRAT: PXM 2 -> APIC 0x53 -> Node 1
SRAT: PXM 1 -> APIC 0x33 -> Node 2
SRAT: PXM 3 -> APIC 0x73 -> Node 3
SRAT: PXM 0 -> APIC 0x15 -> Node 0
SRAT: PXM 2 -> APIC 0x55 -> Node 1
SRAT: PXM 1 -> APIC 0x35 -> Node 2
SRAT: PXM 3 -> APIC 0x75 -> Node 3
SRAT: PXM 0 -> APIC 0x17 -> Node 0
SRAT: PXM 2 -> APIC 0x57 -> Node 1
SRAT: PXM 1 -> APIC 0x37 -> Node 2
SRAT: PXM 3 -> APIC 0x77 -> Node 3
SRAT: Node 0 PXM 0 0-80000000
SRAT: Node 0 PXM 0 100000000-480000000
SRAT: Node 2 PXM 1 480000000-880000000
SRAT: Node 1 PXM 2 880000000-c80000000
SRAT: Node 3 PXM 3 c80000000-1080000000
SRAT: Node 0 PXM 0 1100000000-3100000000
SRAT: Hotplug area 17825792 -> 51380224 has existing memory
SRAT: Node 0 PXM 0 3100000000-5100000000
SRAT: Hotplug area 51380224 -> 84934656 has existing memory
SRAT: Node 2 PXM 1 5100000000-7100000000
SRAT: Hotplug area 84934656 -> 118489088 has existing memory
SRAT: Node 2 PXM 1 7100000000-9100000000
SRAT: Hotplug area 118489088 -> 152043520 has existing memory
SRAT: Node 1 PXM 2 9100000000-b100000000
SRAT: Hotplug area 152043520 -> 185597952 has existing memory
SRAT: Node 1 PXM 2 b100000000-d100000000
SRAT: Hotplug area 185597952 -> 219152384 has existing memory
SRAT: Node 3 PXM 3 d100000000-f100000000
SRAT: Hotplug area 219152384 -> 252706816 has existing memory
SRAT: Node 3 PXM 3 f100000000-11100000000
SRAT: Hotplug area 252706816 -> 286261248 has existing memory
SRAT: Node 0 [0,80000000) + [100000000,480000000) -> [0,480000000)
SRAT: Node 0 [1100000000,3100000000) + [3100000000,5100000000) -> [1100000000,5100000000)
SRAT: Node 2 [5100000000,7100000000) + [7100000000,9100000000) -> [5100000000,9100000000)
SRAT: Node 1 [9100000000,b100000000) + [b100000000,d100000000) -> [9100000000,d100000000)
SRAT: Node 3 [d100000000,f100000000) + [f100000000,11100000000) -> [d100000000,11100000000)
Initmem setup node 0 0000000000000000-0000000480000000
  NODE_DATA [0000000100000000 - 0000000100026fff]
Initmem setup node 1 0000000880000000-0000000c80000000
  NODE_DATA [0000000880000000 - 0000000880026fff]
Initmem setup node 2 0000000480000000-0000000880000000
  NODE_DATA [0000000480000000 - 0000000480026fff]
Initmem setup node 3 0000000c80000000-0000001080000000
  NODE_DATA [0000000c80000000 - 0000000c80026fff]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x01080000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000010 -> 0x00000099
    0: 0x00000100 -> 0x00078c51
    0: 0x00100000 -> 0x00480000
    2: 0x00480000 -> 0x00880000
    1: 0x00880000 -> 0x00c80000
    3: 0x00c80000 -> 0x01080000
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a401 base: 0xfed00000
SMP: Allowing 64 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 0000000000099000 - 000000000009a000
PM: Registered nosave memory: 000000000009a000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 0000000078c51000 - 0000000078e66000
PM: Registered nosave memory: 0000000078e66000 - 0000000079238000
PM: Registered nosave memory: 0000000079238000 - 00000000792ac000
PM: Registered nosave memory: 00000000792ac000 - 00000000792b9000
PM: Registered nosave memory: 00000000792b9000 - 00000000792ce000
PM: Registered nosave memory: 00000000792ce000 - 00000000792e1000
PM: Registered nosave memory: 00000000792e1000 - 00000000792e3000
PM: Registered nosave memory: 00000000792e3000 - 00000000792ec000
PM: Registered nosave memory: 00000000792ec000 - 00000000792f8000
PM: Registered nosave memory: 00000000792f8000 - 00000000792f9000
PM: Registered nosave memory: 00000000792f9000 - 00000000792ff000
PM: Registered nosave memory: 00000000792ff000 - 0000000079320000
PM: Registered nosave memory: 0000000079320000 - 0000000079341000
PM: Registered nosave memory: 0000000079341000 - 0000000079370000
PM: Registered nosave memory: 0000000079370000 - 00000000793b1000
PM: Registered nosave memory: 00000000793b1000 - 000000007996a000
PM: Registered nosave memory: 000000007996a000 - 0000000079b6a000
PM: Registered nosave memory: 0000000079b6a000 - 0000000079cae000
PM: Registered nosave memory: 0000000079cae000 - 0000000079cde000
PM: Registered nosave memory: 0000000079cde000 - 0000000079d72000
PM: Registered nosave memory: 0000000079d72000 - 0000000079d75000
PM: Registered nosave memory: 0000000079d75000 - 0000000079e05000
PM: Registered nosave memory: 0000000079e05000 - 0000000079e70000
PM: Registered nosave memory: 0000000079e70000 - 000000007bd5f000
PM: Registered nosave memory: 000000007bd5f000 - 000000007be4f000
PM: Registered nosave memory: 000000007be4f000 - 000000007bf87000
PM: Registered nosave memory: 000000007bf87000 - 000000007bfcf000
PM: Registered nosave memory: 000000007bfcf000 - 000000007bfff000
PM: Registered nosave memory: 000000007bfff000 - 0000000090000000
PM: Registered nosave memory: 0000000090000000 - 00000000fc000000
PM: Registered nosave memory: 00000000fc000000 - 00000000fd000000
PM: Registered nosave memory: 00000000fd000000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at 90000000 (gap: 90000000:6c000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:64 nr_cpu_ids:64 nr_node_ids:4
PERCPU: Embedded 30 pages/cpu @ffff880002400000 s90368 r8192 d24320 u131072
pcpu-alloc: s90368 r8192 d24320 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 04 08 12 16 20 24 28 32 36 40 44 48 52 56 60 
pcpu-alloc: [1] 01 05 09 13 17 21 25 29 33 37 41 45 49 53 57 61 
pcpu-alloc: [2] 02 06 10 14 18 22 26 30 34 38 42 46 50 54 58 62 
pcpu-alloc: [3] 03 07 11 15 19 23 27 31 35 39 43 47 51 55 59 63 
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 16510938
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_intels3e3601-lv_root rd_LVM_LV=vg_intels3e3601/lv_root rd_LVM_LV=vg_intels3e3601/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us console=ttyS0,115200n81 crashkernel=128M maxcpus=1
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Subtract (169 early reservations)
  #1 [0001000000 - 00022a0408]   TEXT DATA BSS
  #2 [003754d000 - 0037ff0000]         RAMDISK
  #3 [00022a1000 - 00022a1354]             BRK
  #4 [0000099800 - 00000fdd80]   BIOS reserved
  #5 [00000fdd90 - 0000100000]   BIOS reserved
  #6 [00000fdd80 - 00000fdd90]    MP-table mpf
  #7 [0000000012 - 000000f012]    MP-table mpc
  #8 [0000010000 - 0000012000]      TRAMPOLINE
  #9 [0000012000 - 0000016000]     ACPI WAKEUP
  #10 [0000016000 - 0000018000]         PGTABLE
  #11 [0000018000 - 0000056000]         PGTABLE
  #12 [0003000000 - 000b000000]    CRASH KERNEL
  #13 [0000056000 - 000005603c]       ACPI SLIT
  #14 [0000056040 - 00000564c0]      MEMNODEMAP
  #15 [0100000000 - 0100027000]       NODE_DATA
  #16 [0880000000 - 0880027000]       NODE_DATA
  #17 [0480000000 - 0480027000]       NODE_DATA
  #18 [0c80000000 - 0c80027000]       NODE_DATA
  #19 [00022a1380 - 00022a2380]         BOOTMEM
  #20 [00022a2380 - 00022a3380]         BOOTMEM
  #21 [0480027000 - 0480028000]         BOOTMEM
  #22 [0880027000 - 0880028000]         BOOTMEM
  #23 [0c80027000 - 0c80028000]         BOOTMEM
  #24 [00026a3380 - 00026a3f80]         BOOTMEM
  #25 [0480028000 - 0480028c00]         BOOTMEM
  #26 [0880028000 - 0880028c00]         BOOTMEM
  #27 [0c80028000 - 0c80028c00]         BOOTMEM
  #28 [0100027000 - 0100028000]         BOOTMEM
  #29 [0100028000 - 0100029000]         BOOTMEM
  #30 [0100200000 - 010e200000]        MEMMAP 0
  #31 [0480200000 - 048e200000]        MEMMAP 2
  #32 [0880200000 - 088e200000]        MEMMAP 1
  #33 [0c80200000 - 0c8e200000]        MEMMAP 3
  #34 [00022a3380 - 00022bb380]         BOOTMEM
  #35 [00022bb380 - 00022d3380]         BOOTMEM
  #36 [00022d3380 - 00022eb380]         BOOTMEM
  #37 [0880028c00 - 0880040c00]         BOOTMEM
  #38 [0480028c00 - 0480040c00]         BOOTMEM
  #39 [0c80028c00 - 0c80040c00]         BOOTMEM
  #40 [00022ec000 - 00022ed000]         BOOTMEM
  #41 [00022a0440 - 00022a0481]         BOOTMEM
  #42 [00022a04c0 - 00022a0589]         BOOTMEM
  #43 [00022a05c0 - 00022a0e10]         BOOTMEM
  #44 [00022a0e40 - 00022a0ea8]         BOOTMEM
  #45 [00022a0ec0 - 00022a0f28]         BOOTMEM
  #46 [00022a0f40 - 00022a0fa8]         BOOTMEM
  #47 [00022eb380 - 00022eb3e8]         BOOTMEM
  #48 [00022eb400 - 00022eb468]         BOOTMEM
  #49 [00022eb480 - 00022eb4e8]         BOOTMEM
  #50 [00022eb500 - 00022eb568]         BOOTMEM
  #51 [00022eb580 - 00022eb5e8]         BOOTMEM
  #52 [00022eb600 - 00022eb668]         BOOTMEM
  #53 [00022eb680 - 00022eb6e8]         BOOTMEM
  #54 [00022eb700 - 00022eb768]         BOOTMEM
  #55 [00022eb780 - 00022eb7e8]         BOOTMEM
  #56 [00022eb800 - 00022eb868]         BOOTMEM
  #57 [00022eb880 - 00022eb8e8]         BOOTMEM
  #58 [00022eb900 - 00022eb968]         BOOTMEM
  #59 [00022eb980 - 00022eb9e8]         BOOTMEM
  #60 [00022eba00 - 00022eba68]         BOOTMEM
  #61 [00022eba80 - 00022ebae8]         BOOTMEM
  #62 [00022ebb00 - 00022ebb68]         BOOTMEM
  #63 [00022ebb80 - 00022ebbe8]         BOOTMEM
  #64 [00022ebc00 - 00022ebc68]         BOOTMEM
  #65 [00022ebc80 - 00022ebce8]         BOOTMEM
  #66 [00022ebd00 - 00022ebd68]         BOOTMEM
  #67 [00022ebd80 - 00022ebde8]         BOOTMEM
  #68 [00022ebe00 - 00022ebe68]         BOOTMEM
  #69 [00022ebe80 - 00022ebee8]         BOOTMEM
  #70 [00022ebf00 - 00022ebf68]         BOOTMEM
  #71 [00022ebf80 - 00022ebfe8]         BOOTMEM
  #72 [00022ed000 - 00022ed068]         BOOTMEM
  #73 [00022ed080 - 00022ed0e8]         BOOTMEM
  #74 [00022ed100 - 00022ed168]         BOOTMEM
  #75 [00022ed180 - 00022ed1e8]         BOOTMEM
  #76 [00022ed200 - 00022ed268]         BOOTMEM
  #77 [00022ed280 - 00022ed2e8]         BOOTMEM
  #78 [00022ed300 - 00022ed368]         BOOTMEM
  #79 [00022ed380 - 00022ed3e8]         BOOTMEM
  #80 [00022ed400 - 00022ed468]         BOOTMEM
  #81 [00022a0fc0 - 00022a0fe0]         BOOTMEM
  #82 [00022ed480 - 00022ed4a0]         BOOTMEM
  #83 [00022ed4c0 - 00022ed5c7]         BOOTMEM
  #84 [00022ed600 - 00022ed707]         BOOTMEM
  #85 [0002400000 - 000241e000]         BOOTMEM
  #86 [0002420000 - 000243e000]         BOOTMEM
  #87 [0002440000 - 000245e000]         BOOTMEM
  #88 [0002460000 - 000247e000]         BOOTMEM
  #89 [0002480000 - 000249e000]         BOOTMEM
  #90 [00024a0000 - 00024be000]         BOOTMEM
  #91 [00024c0000 - 00024de000]         BOOTMEM
  #92 [00024e0000 - 00024fe000]         BOOTMEM
  #93 [0002500000 - 000251e000]         BOOTMEM
  #94 [0002520000 - 000253e000]         BOOTMEM
  #95 [0002540000 - 000255e000]         BOOTMEM
  #96 [0002560000 - 000257e000]         BOOTMEM
  #97 [0002580000 - 000259e000]         BOOTMEM
  #98 [00025a0000 - 00025be000]         BOOTMEM
  #99 [00025c0000 - 00025de000]         BOOTMEM
  #100 [00025e0000 - 00025fe000]         BOOTMEM
  #101 [088e200000 - 088e21e000]         BOOTMEM
  #102 [088e220000 - 088e23e000]         BOOTMEM
  #103 [088e240000 - 088e25e000]         BOOTMEM
  #104 [088e260000 - 088e27e000]         BOOTMEM
  #105 [088e280000 - 088e29e000]         BOOTMEM
  #106 [088e2a0000 - 088e2be000]         BOOTMEM
  #107 [088e2c0000 - 088e2de000]         BOOTMEM
  #108 [088e2e0000 - 088e2fe000]         BOOTMEM
  #109 [088e300000 - 088e31e000]         BOOTMEM
  #110 [088e320000 - 088e33e000]         BOOTMEM
  #111 [088e340000 - 088e35e000]         BOOTMEM
  #112 [088e360000 - 088e37e000]         BOOTMEM
  #113 [088e380000 - 088e39e000]         BOOTMEM
  #114 [088e3a0000 - 088e3be000]         BOOTMEM
  #115 [088e3c0000 - 088e3de000]         BOOTMEM
  #116 [088e3e0000 - 088e3fe000]         BOOTMEM
  #117 [048e200000 - 048e21e000]         BOOTMEM
  #118 [048e220000 - 048e23e000]         BOOTMEM
  #119 [048e240000 - 048e25e000]         BOOTMEM
  #120 [048e260000 - 048e27e000]         BOOTMEM
  #121 [048e280000 - 048e29e000]         BOOTMEM
  #122 [048e2a0000 - 048e2be000]         BOOTMEM
  #123 [048e2c0000 - 048e2de000]         BOOTMEM
  #124 [048e2e0000 - 048e2fe000]         BOOTMEM
  #125 [048e300000 - 048e31e000]         BOOTMEM
  #126 [048e320000 - 048e33e000]         BOOTMEM
  #127 [048e340000 - 048e35e000]         BOOTMEM
  #128 [048e360000 - 048e37e000]         BOOTMEM
  #129 [048e380000 - 048e39e000]         BOOTMEM
  #130 [048e3a0000 - 048e3be000]         BOOTMEM
  #131 [048e3c0000 - 048e3de000]         BOOTMEM
  #132 [048e3e0000 - 048e3fe000]         BOOTMEM
  #133 [0c8e200000 - 0c8e21e000]         BOOTMEM
  #134 [0c8e220000 - 0c8e23e000]         BOOTMEM
  #135 [0c8e240000 - 0c8e25e000]         BOOTMEM
  #136 [0c8e260000 - 0c8e27e000]         BOOTMEM
  #137 [0c8e280000 - 0c8e29e000]         BOOTMEM
  #138 [0c8e2a0000 - 0c8e2be000]         BOOTMEM
  #139 [0c8e2c0000 - 0c8e2de000]         BOOTMEM
  #140 [0c8e2e0000 - 0c8e2fe000]         BOOTMEM
  #141 [0c8e300000 - 0c8e31e000]         BOOTMEM
  #142 [0c8e320000 - 0c8e33e000]         BOOTMEM
  #143 [0c8e340000 - 0c8e35e000]         BOOTMEM
  #144 [0c8e360000 - 0c8e37e000]         BOOTMEM
  #145 [0c8e380000 - 0c8e39e000]         BOOTMEM
  #146 [0c8e3a0000 - 0c8e3be000]         BOOTMEM
  #147 [0c8e3c0000 - 0c8e3de000]         BOOTMEM
  #148 [0c8e3e0000 - 0c8e3fe000]         BOOTMEM
  #149 [00022ef740 - 00022ef760]         BOOTMEM
  #150 [00022ef780 - 00022ef7a0]         BOOTMEM
  #151 [00022ef7c0 - 00022ef8c0]         BOOTMEM
  #152 [00022ef8c0 - 00022efac0]         BOOTMEM
  #153 [00022efac0 - 00022efbd0]         BOOTMEM
  #154 [00022efc00 - 00022efc48]         BOOTMEM
  #155 [00022efc80 - 00022efcc8]         BOOTMEM
  #156 [00022ed740 - 00022ed940]         BOOTMEM
  #157 [00022ed940 - 00022edb40]         BOOTMEM
  #158 [00022edb40 - 00022edd40]         BOOTMEM
  #159 [00022edd40 - 00022edf40]         BOOTMEM
  #160 [00022edf40 - 00022ee140]         BOOTMEM
  #161 [00022ee140 - 00022ee340]         BOOTMEM
  #162 [00022ee340 - 00022ee540]         BOOTMEM
  #163 [00022ee540 - 00022ee740]         BOOTMEM
  #164 [00022efd00 - 00022f7d00]         BOOTMEM
  #165 [000b000000 - 000f000000]         BOOTMEM
  #166 [00022f7d00 - 0002317d00]         BOOTMEM
  #167 [0002317d00 - 0002357d00]         BOOTMEM
  #168 [0000059cc0 - 0000061cc0]         BOOTMEM
Memory: 65836168k/69206016k available (4775k kernel code, 2216088k absent, 1153760k reserved, 7568k data, 1444k init)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:262400 nr_irqs:2008
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [ttyS0] enabled
allocated 671088640 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 1995.288 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.57 BogoMIPS (lpj=1995288)
pid_max: default: 65536 minimum: 512
Security Framework initialized
SELinux:  Initializing.
Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 22 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
SMP alternatives: switching to UP code
ACPI: Core revision 20100702
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 18528 entries in 73 pages
Not enabling x2apic, Intr-remapping init failed.
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X7550  @ 2.00GHz stepping 06
Brought up 1 CPUs
Total of 1 processors activated (3990.57 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0

> Thanks.
> 
> -- 
> tejun
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
