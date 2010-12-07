Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0LGSc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:32:56 -0500
Received: from mail.agmk.net ([91.192.224.71]:34233 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab0LGScx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:32:53 -0500
X-Greylist: delayed 1551 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2010 13:32:53 EST
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.36.1] IGB driver handles all ethX interrupts on single cpu core.
Date: Tue, 7 Dec 2010 19:06:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.1-3; KDE/4.5.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3en/MtKHmTuU1fP"
Message-Id: <201012071906.47161.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_3en/MtKHmTuU1fP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

hi,

i'm currently testing a new server with 2x opteron-6128 with dual gigabit port
and observing that the igb driver uses only single core for all ethX interrupts.
is it a correct behaviour for this driver?

BR,
Pawel.

--Boundary-00=_3en/MtKHmTuU1fP
Content-Type: text/plain;
  charset="utf-8";
  name="log.interrupts"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="log.interrupts"

           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       CPU8       CPU9       CPU10      CPU11      CPU12      CPU13      CPU14      CPU15      
  0:        124          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      timer
  1:        114          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      i8042
  8:         17          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   acpi
 14:         59          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      ide0
 15:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      ide1
 16:          2          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb3, ohci_hcd:usb4
 17:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 18:         63          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
 19:          2          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 22:     551596          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   ahci
 40:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      AMD-Vi
 41:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0
 42:     168046          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-0
 43:     183393          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-1
 44:     313252          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-2
 45:     908442          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-3
 46:     162850          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-4
 47:     626848          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-5
 48:     275280          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-6
 49:     274253          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-7
 50:          1          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1
 51:      23554          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-0
 52:       9628          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-1
 53:       9588          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-2
 54:       9854          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-3
 55:      10620          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-4
 56:      10229          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-5
 57:      10454          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-6
 58:      10730          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth1-TxRx-7
NMI:        200        230        231        230        209        227        225        226        206        228        226        227        210        227        229        224   Non-maskable interrupts
LOC:    5490219    4753882    4793570    4743366    5376168    4813835    4745446    4853502    5134896    4931322    4848932    4907792    5222156    4770544    4816853    5321399   Local timer interrupts
SPU:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Spurious interrupts
PMI:        200        230        231        230        209        227        225        226        206        228        226        227        210        227        229        224   Performance monitoring interrupts
PND:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Performance pending work
RES:    3328333    1467370    1911150    1612000    2716828    1542951    2225417    2009596    2681422    1595419    1649479    1579074    2698131    1549933    1463377    1362412   Rescheduling interrupts
CAL:      71812      11687      10941      11900     115033      19104      24127      19611     111362      16100      20638      17738      92478      18765      14071      23404   Function call interrupts
TLB:      31442      11831       7863       8075      23527      14572      11969      11001      24502      14772      12014      10448      21578      15261       9655      16124   TLB shootdowns
TRM:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Machine check exceptions
MCP:         63         63         63         63         63         63         63         63         63         63         63         63         63         63         63         63   Machine check polls
ERR:          0
MIS:          0

--Boundary-00=_3en/MtKHmTuU1fP
Content-Type: text/plain;
  charset="utf-8";
  name="log.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="log.dmesg"

Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: OEMB 00000000dfeb2040 00075 (v01 090210 OEMB1459 20100902 MSFT 00000097)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: HPET 00000000dfeaa670 00038 (v01 090210 OEMHPET  20100902 MSFT 00000097)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: IVRS 00000000dfeaa6b0 000B0 (v01  AMD     RD890S 00202031 AMD  00000000)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: SRAT 00000000dfeaa760 00220 (v02 AMD    F10      00000001 AMD  00000001)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: SLIT 00000000dfeaa980 0003C (v01 AMD    F10      00000001 AMD  00000001)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: SSDT 00000000dfeaa9c0 02854 (v01 A M I  POWERNOW 00000001 AMD  00000001)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: EINJ 00000000dfead220 00130 (v01  AMIER AMI_EINJ 20100902 MSFT 00000097)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: BERT 00000000dfead3b0 00030 (v01  AMIER AMI_BERT 20100902 MSFT 00000097)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: ERST 00000000dfead3e0 001B0 (v01  AMIER AMI_ERST 20100902 MSFT 00000097)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: HEST 00000000dfead590 000A8 (v01  AMIER ABC_HEST 20100902 MSFT 00000097)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 2 -> APIC 0x24 -> Node 2
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 2 -> APIC 0x25 -> Node 2
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 2 -> APIC 0x26 -> Node 2
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 2 -> APIC 0x27 -> Node 2
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 3 -> APIC 0x20 -> Node 3
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 3 -> APIC 0x21 -> Node 3
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 3 -> APIC 0x22 -> Node 3
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: PXM 3 -> APIC 0x23 -> Node 3
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 0 PXM 0 0-a0000
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 0 PXM 0 100000-e0000000
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 0 PXM 0 100000000-420000000
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 1 PXM 1 420000000-820000000
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 2 PXM 2 820000000-c20000000
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 3 PXM 3 c20000000-1020000000
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 0 [0,a0000) + [100000,e0000000) -> [0,e0000000)
Dec  7 14:44:51 hal kernel: [    0.000000] SRAT: Node 0 [0,e0000000) + [100000000,420000000) -> [0,420000000)
Dec  7 14:44:51 hal kernel: [    0.000000] NUMA: Allocated memnodemap from 16040 - 16180
Dec  7 14:44:51 hal kernel: [    0.000000] NUMA: Using 29 for the hash shift.
Dec  7 14:44:51 hal kernel: [    0.000000] Initmem setup node 0 0000000000000000-0000000420000000
Dec  7 14:44:51 hal kernel: [    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
Dec  7 14:44:51 hal kernel: [    0.000000] Initmem setup node 1 0000000420000000-0000000820000000
Dec  7 14:44:51 hal kernel: [    0.000000]   NODE_DATA [0000000420000000 - 0000000420004fff]
Dec  7 14:44:51 hal kernel: [    0.000000] Initmem setup node 2 0000000820000000-0000000c20000000
Dec  7 14:44:51 hal kernel: [    0.000000]   NODE_DATA [0000000820000000 - 0000000820004fff]
Dec  7 14:44:51 hal kernel: [    0.000000] Initmem setup node 3 0000000c20000000-0000001020000000
Dec  7 14:44:51 hal kernel: [    0.000000]   NODE_DATA [0000000c20000000 - 0000000c20004fff]
Dec  7 14:44:51 hal kernel: [    0.000000] [ffffea000e700000-ffffea000e7fffff] potential offnode page_structs
Dec  7 14:44:51 hal kernel: [    0.000000]  [ffffea0000000000-ffffea000e7fffff] PMD -> [ffff880100200000-ffff88010e3fffff] on node 0
Dec  7 14:44:51 hal kernel: [    0.000000] [ffffea001c700000-ffffea001c7fffff] potential offnode page_structs
Dec  7 14:44:51 hal kernel: [    0.000000]  [ffffea000e800000-ffffea001c7fffff] PMD -> [ffff880420200000-ffff88042e1fffff] on node 1
Dec  7 14:44:51 hal kernel: [    0.000000] early_res array is doubled to 64 at [16180 - 1697f]
Dec  7 14:44:51 hal kernel: [    0.000000] [ffffea002a700000-ffffea002a7fffff] potential offnode page_structs
Dec  7 14:44:51 hal kernel: [    0.000000]  [ffffea001c800000-ffffea002a7fffff] PMD -> [ffff880820200000-ffff88082e1fffff] on node 2
Dec  7 14:44:51 hal kernel: [    0.000000]  [ffffea002a800000-ffffea00387fffff] PMD -> [ffff880c20200000-ffff880c2e1fffff] on node 3
Dec  7 14:44:51 hal kernel: [    0.000000] Zone PFN ranges:
Dec  7 14:44:51 hal kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Dec  7 14:44:51 hal kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal   0x00100000 -> 0x01020000
Dec  7 14:44:51 hal kernel: [    0.000000] Movable zone start PFN for each node
Dec  7 14:44:51 hal kernel: [    0.000000] early_node_map[6] active PFN ranges
Dec  7 14:44:51 hal kernel: [    0.000000]     0: 0x00000010 -> 0x00000096
Dec  7 14:44:51 hal kernel: [    0.000000]     0: 0x00000100 -> 0x000dfe90
Dec  7 14:44:51 hal kernel: [    0.000000]     0: 0x00100000 -> 0x00420000
Dec  7 14:44:51 hal kernel: [    0.000000]     1: 0x00420000 -> 0x00820000
Dec  7 14:44:51 hal kernel: [    0.000000]     2: 0x00820000 -> 0x00c20000
Dec  7 14:44:51 hal kernel: [    0.000000]     3: 0x00c20000 -> 0x01020000
Dec  7 14:44:51 hal kernel: [    0.000000] On node 0 totalpages: 4193814
Dec  7 14:44:51 hal kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Dec  7 14:44:51 hal kernel: [    0.000000]   DMA zone: 0 pages reserved
Dec  7 14:44:51 hal kernel: [    0.000000]   DMA zone: 3918 pages, LIFO batch:0
Dec  7 14:44:51 hal kernel: [    0.000000]   DMA32 zone: 14280 pages used for memmap
Dec  7 14:44:51 hal kernel: [    0.000000]   DMA32 zone: 898760 pages, LIFO batch:31
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 44800 pages used for memmap
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 3232000 pages, LIFO batch:31
Dec  7 14:44:51 hal kernel: [    0.000000] On node 1 totalpages: 4194304
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 57344 pages used for memmap
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
Dec  7 14:44:51 hal kernel: [    0.000000] On node 2 totalpages: 4194304
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 57344 pages used for memmap
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
Dec  7 14:44:51 hal kernel: [    0.000000] On node 3 totalpages: 4194304
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 57344 pages used for memmap
Dec  7 14:44:51 hal kernel: [    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x15] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x20] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x21] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x22] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x23] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x24] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x25] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x26] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x27] enabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
Dec  7 14:44:51 hal kernel: [    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: IRQ0 used by override.
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: IRQ2 used by override.
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: IRQ9 used by override.
Dec  7 14:44:51 hal kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Dec  7 14:44:51 hal kernel: [    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
Dec  7 14:44:51 hal kernel: [    0.000000] SMP: Allowing 24 CPUs, 8 hotplug CPUs
Dec  7 14:44:51 hal kernel: [    0.000000] nr_irqs_gsi: 40
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 0000000000096000 - 0000000000097000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000dfe90000 - 00000000dfe9e000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000dfe9e000 - 00000000dfea0000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000dfea0000 - 00000000dfeb2000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000dfeb2000 - 00000000dfee0000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000dfee0000 - 00000000f0000000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000ffe00000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
Dec  7 14:44:51 hal kernel: [    0.000000] Allocating PCI resources starting at f0000000 (gap: f0000000:fe00000)
Dec  7 14:44:51 hal kernel: [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:24 nr_node_ids:4
Dec  7 14:44:51 hal kernel: [    0.000000] early_res array is doubled to 128 at [16980 - 1797f]
Dec  7 14:44:51 hal kernel: [    0.000000] PERCPU: Embedded 24 pages/cpu @ffff880001a00000 s68864 r8192 d21248 u262144
Dec  7 14:44:51 hal kernel: [    0.000000] pcpu-alloc: s68864 r8192 d21248 u262144 alloc=1*2097152
Dec  7 14:44:51 hal kernel: [    0.000000] pcpu-alloc: [0] 00 01 02 03 16 20 -- -- [1] 04 05 06 07 17 21 -- -- 
Dec  7 14:44:51 hal kernel: [    0.000000] pcpu-alloc: [2] 08 09 10 11 19 23 -- -- [3] 12 13 14 15 18 22 -- -- 
Dec  7 14:44:51 hal kernel: [    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 16545558
Dec  7 14:44:51 hal kernel: [    0.000000] Policy zone: Normal
Dec  7 14:44:51 hal kernel: [    0.000000] Kernel command line: root=/dev/md0
Dec  7 14:44:51 hal kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Dec  7 14:44:51 hal kernel: [    0.000000] Checking aperture...
Dec  7 14:44:51 hal kernel: [    0.000000] No AGP bridge found
Dec  7 14:44:51 hal kernel: [    0.000000] Node 0: aperture @ 20000000 size 32 MB
Dec  7 14:44:51 hal kernel: [    0.000000] Aperture pointing to e820 RAM. Ignoring.
Dec  7 14:44:51 hal kernel: [    0.000000] Your BIOS doesn't leave a aperture memory hole
Dec  7 14:44:51 hal kernel: [    0.000000] Please enable the IOMMU option in the BIOS setup
Dec  7 14:44:51 hal kernel: [    0.000000] This costs you 64 MB of RAM
Dec  7 14:44:51 hal kernel: [    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
Dec  7 14:44:51 hal kernel: [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Dec  7 14:44:51 hal kernel: [    0.000000] Subtract (89 early reservations)
Dec  7 14:44:51 hal kernel: [    0.000000]   #1 [0001000000 - 000187ef88]   TEXT DATA BSS
Dec  7 14:44:51 hal kernel: [    0.000000]   #2 [0037f33000 - 0037ff0000]         RAMDISK
Dec  7 14:44:51 hal kernel: [    0.000000]   #3 [0000096800 - 0000100000]   BIOS reserved
Dec  7 14:44:51 hal kernel: [    0.000000]   #4 [000187f000 - 000187f26b]             BRK
Dec  7 14:44:51 hal kernel: [    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
Dec  7 14:44:51 hal kernel: [    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
Dec  7 14:44:51 hal kernel: [    0.000000]   #7 [0000100000 - 0000102000]         PGTABLE
Dec  7 14:44:51 hal kernel: [    0.000000]   #8 [0000102000 - 0000103000]         PGTABLE
Dec  7 14:44:51 hal kernel: [    0.000000]   #9 [0000016000 - 000001603c]       ACPI SLIT
Dec  7 14:44:51 hal kernel: [    0.000000]   #10 [0000016040 - 0000016180]      MEMNODEMAP
Dec  7 14:44:51 hal kernel: [    0.000000]   #11 [0100000000 - 0100005000]       NODE_DATA
Dec  7 14:44:51 hal kernel: [    0.000000]   #12 [0420000000 - 0420005000]       NODE_DATA
Dec  7 14:44:51 hal kernel: [    0.000000]   #13 [0820000000 - 0820005000]       NODE_DATA
Dec  7 14:44:51 hal kernel: [    0.000000]   #14 [0c20000000 - 0c20005000]       NODE_DATA
Dec  7 14:44:51 hal kernel: [    0.000000]   #15 [000187f280 - 0001880280]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #16 [0001880280 - 0001881280]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #17 [0420005000 - 0420006000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #18 [0820005000 - 0820006000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #19 [0c20005000 - 0c20006000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #20 [0100005000 - 0100005c00]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #21 [0420006000 - 0420006c00]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #22 [0820006000 - 0820006c00]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #23 [0c20006000 - 0c20006c00]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #24 [0100200000 - 010e400000]        MEMMAP 0
Dec  7 14:44:51 hal kernel: [    0.000000]   #25 [0420200000 - 042e200000]        MEMMAP 1
Dec  7 14:44:51 hal kernel: [    0.000000]   #26 [0820200000 - 082e200000]        MEMMAP 2
Dec  7 14:44:51 hal kernel: [    0.000000]   #27 [0c20200000 - 0c2e200000]        MEMMAP 3
Dec  7 14:44:51 hal kernel: [    0.000000]   #28 [0001881280 - 0001899280]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #29 [0001899280 - 00018b1280]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #30 [00018b1280 - 00018c9280]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #31 [0420006c00 - 042001ec00]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #32 [0820006c00 - 082001ec00]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #33 [0c20006c00 - 0c2001ec00]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #34 [00018c9280 - 00018c92c1]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #35 [00018c9300 - 00018c9343]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #36 [00018c9380 - 00018c95e8]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #37 [00018c9600 - 00018c9668]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #38 [00018c9680 - 00018c96e8]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #39 [00018c9700 - 00018c9768]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #40 [00018c9780 - 00018c97e8]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #41 [00018c9800 - 00018c9868]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #42 [00018c9880 - 00018c98e8]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #43 [00018c9900 - 00018c9968]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #44 [00018c9980 - 00018c99e8]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #45 [00018c9a00 - 00018c9a68]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #46 [00018c9a80 - 00018c9ae8]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #47 [000187efc0 - 000187efe0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #48 [00018c9b00 - 00018c9b20]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #49 [00018c9b40 - 00018c9b4e]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #50 [00018c9b80 - 00018c9b8e]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #51 [0001a00000 - 0001a18000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #52 [0001a40000 - 0001a58000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #53 [0001a80000 - 0001a98000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #54 [0001ac0000 - 0001ad8000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #55 [0001b00000 - 0001b18000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #56 [0001b40000 - 0001b58000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #57 [042e200000 - 042e218000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #58 [042e240000 - 042e258000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #59 [042e280000 - 042e298000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #60 [042e2c0000 - 042e2d8000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #61 [042e300000 - 042e318000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #62 [042e340000 - 042e358000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #63 [0c2e200000 - 0c2e218000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #64 [0c2e240000 - 0c2e258000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #65 [0c2e280000 - 0c2e298000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #66 [0c2e2c0000 - 0c2e2d8000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #67 [0c2e300000 - 0c2e318000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #68 [0c2e340000 - 0c2e358000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #69 [082e200000 - 082e218000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #70 [082e240000 - 082e258000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #71 [082e280000 - 082e298000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #72 [082e2c0000 - 082e2d8000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #73 [082e300000 - 082e318000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #74 [082e340000 - 082e358000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #75 [00018cbbc0 - 00018cbbe0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #76 [00018cbc00 - 00018cbc20]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #77 [00018cbc40 - 00018cbca0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #78 [00018cbcc0 - 00018cbd80]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #79 [00018cbd80 - 00018cbea0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #80 [00018cbec0 - 00018cbf08]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #81 [00018cbf40 - 00018cbf88]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #82 [00018cbfc0 - 00018d3fc0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #83 [0020000000 - 0024000000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #84 [00018c9bc0 - 00018c9be0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #85 [0001b58000 - 0005b58000]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #86 [00018d3fc0 - 00018f3fc0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #87 [00018f3fc0 - 0001933fc0]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000]   #88 [0000017980 - 000001f980]         BOOTMEM
Dec  7 14:44:51 hal kernel: [    0.000000] Memory: 66043328k/67633152k available (4392k kernel code, 526248k absent, 1063576k reserved, 2606k data, 484k init)
Dec  7 14:44:51 hal kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=4
Dec  7 14:44:51 hal kernel: [    0.000000] Hierarchical RCU implementation.
Dec  7 14:44:51 hal kernel: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
Dec  7 14:44:51 hal kernel: [    0.000000] 	RCU-based detection of stalled CPUs is disabled.
Dec  7 14:44:51 hal kernel: [    0.000000] 	Verbose stalled-CPUs detection is disabled.
Dec  7 14:44:51 hal kernel: [    0.000000] NR_IRQS:4352 nr_irqs:872
Dec  7 14:44:51 hal kernel: [    0.000000] Extended CMOS year: 2000
Dec  7 14:44:51 hal kernel: [    0.000000] Console: colour VGA+ 80x25
Dec  7 14:44:51 hal kernel: [    0.000000] console [tty0] enabled
Dec  7 14:44:51 hal kernel: [    0.000000] allocated 671088640 bytes of page_cgroup
Dec  7 14:44:51 hal kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Dec  7 14:44:51 hal kernel: [    0.000000] hpet clockevent registered
Dec  7 14:44:51 hal kernel: [    0.000000] Fast TSC calibration using PIT
Dec  7 14:44:51 hal kernel: [    0.000000] Detected 1999.985 MHz processor.
Dec  7 14:44:51 hal kernel: [    0.010012] Calibrating delay loop (skipped), value calculated using timer frequency.. 4001.63 BogoMIPS (lpj=6666610)
Dec  7 14:44:51 hal kernel: [    0.010204] pid_max: default: 32768 minimum: 501
Dec  7 14:44:51 hal kernel: [    0.010351] Security Framework initialized
Dec  7 14:44:51 hal kernel: [    0.010448] SELinux:  Disabled at boot.
Dec  7 14:44:51 hal kernel: [    0.010539] AppArmor: AppArmor disabled by boot time parameter
Dec  7 14:44:51 hal kernel: [    0.017708] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Dec  7 14:44:51 hal kernel: [    0.042373] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Dec  7 14:44:51 hal kernel: [    0.053098] Mount-cache hash table entries: 256
Dec  7 14:44:51 hal kernel: [    0.053365] Initializing cgroup subsys cpuacct
Dec  7 14:44:51 hal kernel: [    0.053463] Initializing cgroup subsys memory
Dec  7 14:44:51 hal kernel: [    0.053586] Initializing cgroup subsys devices
Dec  7 14:44:51 hal kernel: [    0.053679] Initializing cgroup subsys freezer
Dec  7 14:44:51 hal kernel: [    0.053771] Initializing cgroup subsys net_cls
Dec  7 14:44:51 hal kernel: [    0.053864] Initializing cgroup subsys blkio
Dec  7 14:44:51 hal kernel: [    0.053986] tseg: 00dff00000
Dec  7 14:44:51 hal kernel: [    0.053988] CPU: Physical Processor ID: 0
Dec  7 14:44:51 hal kernel: [    0.054079] CPU: Processor Core ID: 0
Dec  7 14:44:51 hal kernel: [    0.054170] mce: CPU supports 6 MCE banks
Dec  7 14:44:51 hal kernel: [    0.054268] Performance Events: AMD PMU driver.
Dec  7 14:44:51 hal kernel: [    0.054414] ... version:                0
Dec  7 14:44:51 hal kernel: [    0.054505] ... bit width:              48
Dec  7 14:44:51 hal kernel: [    0.054596] ... generic registers:      4
Dec  7 14:44:51 hal kernel: [    0.054687] ... value mask:             0000ffffffffffff
Dec  7 14:44:51 hal kernel: [    0.054783] ... max period:             00007fffffffffff
Dec  7 14:44:51 hal kernel: [    0.054878] ... fixed-purpose events:   0
Dec  7 14:44:51 hal kernel: [    0.054968] ... event mask:             000000000000000f
Dec  7 14:44:51 hal kernel: [    0.055207] ACPI: Core revision 20100702
Dec  7 14:44:51 hal kernel: [    0.063426] Setting APIC routing to physical flat
Dec  7 14:44:51 hal kernel: [    0.063815] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Dec  7 14:44:51 hal kernel: [    0.098419] CPU0: AMD Opteron(tm) Processor 6128 stepping 01
Dec  7 14:44:51 hal kernel: [    0.099999] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.099999] Booting Node   0, Processors  #1
Dec  7 14:44:51 hal kernel: [    0.193348] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.193592]  #2
Dec  7 14:44:51 hal kernel: [    0.290013] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.290252]  #3
Dec  7 14:44:51 hal kernel: [    0.386679] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.386924]  Ok.
Dec  7 14:44:51 hal kernel: [    0.387011] Booting Node   1, Processors  #4
Dec  7 14:44:51 hal kernel: [    0.483350] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.483603]  #5
Dec  7 14:44:51 hal kernel: [    0.580017] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.580282]  #6
Dec  7 14:44:51 hal kernel: [    0.676688] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.676944]  #7
Dec  7 14:44:51 hal kernel: [    0.773357] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.773614]  Ok.
Dec  7 14:44:51 hal kernel: [    0.773702] Booting Node   3, Processors  #8
Dec  7 14:44:51 hal kernel: [    0.870023] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.870275]  #9
Dec  7 14:44:51 hal kernel: [    0.966684] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    0.966938]  #10
Dec  7 14:44:51 hal kernel: [    1.063355] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    1.063612]  #11
Dec  7 14:44:51 hal kernel: [    1.160035] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    1.160293]  Ok.
Dec  7 14:44:51 hal kernel: [    1.160381] Booting Node   2, Processors  #12
Dec  7 14:44:51 hal kernel: [    1.256695] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    1.256957]  #13
Dec  7 14:44:51 hal kernel: [    1.353382] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    1.353641]  #14
Dec  7 14:44:51 hal kernel: [    1.450021] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    1.450276]  #15
Dec  7 14:44:51 hal kernel: [    1.546704] NMI watchdog enabled, takes one hw-pmu counter.
Dec  7 14:44:51 hal kernel: [    1.546919] Brought up 16 CPUs
Dec  7 14:44:51 hal kernel: [    1.547010] Total of 16 processors activated (64031.69 BogoMIPS).
Dec  7 14:44:51 hal kernel: [    1.550119] devtmpfs: initialized
Dec  7 14:44:51 hal kernel: [    1.611450] regulator: core version 0.5
Dec  7 14:44:51 hal kernel: [    1.611450] regulator: dummy: 
Dec  7 14:44:51 hal kernel: [    1.611450] NET: Registered protocol family 16
Dec  7 14:44:51 hal kernel: [    1.613598] node 0 link 3: io port [1000, ffffff]
Dec  7 14:44:51 hal kernel: [    1.613598] TOM: 00000000e0000000 aka 3584M
Dec  7 14:44:51 hal kernel: [    1.613598] Fam 10h mmconf [e0000000, efffffff]
Dec  7 14:44:51 hal kernel: [    1.613598] node 0 link 3: mmio [e0000000, efffffff] ==> none
Dec  7 14:44:51 hal kernel: [    1.613598] node 0 link 3: mmio [f0000000, ffffffff]
Dec  7 14:44:51 hal kernel: [    1.613598] node 0 link 3: mmio [a0000, bffff]
Dec  7 14:44:51 hal kernel: [    1.613598] TOM2: 0000001020000000 aka 66048M
Dec  7 14:44:51 hal kernel: [    1.613598] bus: [00, 1f] on node 0 link 3
Dec  7 14:44:51 hal kernel: [    1.613598] bus: 00 index 0 [io  0x0000-0xffff]
Dec  7 14:44:51 hal kernel: [    1.613598] bus: 00 index 1 [mem 0xf0000000-0xffffffff]
Dec  7 14:44:51 hal kernel: [    1.613598] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
Dec  7 14:44:51 hal kernel: [    1.613598] bus: 00 index 3 [mem 0x1020000000-0xfcffffffff]
Dec  7 14:44:51 hal kernel: [    1.613705] ACPI: bus type pci registered
Dec  7 14:44:51 hal kernel: [    1.615279] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Dec  7 14:44:51 hal kernel: [    1.615279] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
Dec  7 14:44:51 hal kernel: [    1.643724] PCI: Using configuration type 1 for base access
Dec  7 14:44:51 hal kernel: [    1.656755] bio: create slab <bio-0> at 0
Dec  7 14:44:51 hal kernel: [    1.657359] ACPI: EC: Look up EC in DSDT
Dec  7 14:44:51 hal kernel: [    1.658527] ACPI Error (dswload-0677): [PCI0] Namespace lookup failure, AE_NOT_FOUND
Dec  7 14:44:51 hal kernel: [    1.658774] ACPI Exception: AE_NOT_FOUND, During name lookup/catalog (20100702/psloop-231)
Dec  7 14:44:51 hal kernel: [    1.660177] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81870850), AE_NOT_FOUND
Dec  7 14:44:51 hal kernel: [    1.660520] ACPI: Executed 4 blocks of module-level executable AML code
Dec  7 14:44:51 hal kernel: [    1.666874] ACPI: Interpreter enabled
Dec  7 14:44:51 hal kernel: [    1.666971] ACPI: (supports S0 S1 S4 S5)
Dec  7 14:44:51 hal kernel: [    1.667293] ACPI: Using IOAPIC for interrupt routing
Dec  7 14:44:51 hal kernel: [    1.680126] ACPI Warning: Incorrect checksum in table [OEMB] - 0xB5, should be 0xB2 (20100702/tbutils-314)
Dec  7 14:44:51 hal kernel: [    1.680618] ACPI: No dock devices found.
Dec  7 14:44:51 hal kernel: [    1.680716] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Dec  7 14:44:51 hal kernel: [    1.680990] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Dec  7 14:44:51 hal kernel: [    1.683386] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
Dec  7 14:44:51 hal kernel: [    1.683494] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
Dec  7 14:44:51 hal kernel: [    1.683601] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
Dec  7 14:44:51 hal kernel: [    1.683731] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
Dec  7 14:44:51 hal kernel: [    1.683860] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
Dec  7 14:44:51 hal kernel: [    1.683989] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
Dec  7 14:44:51 hal kernel: [    1.684248] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
Dec  7 14:44:51 hal kernel: [    1.684251] pci 0000:00:04.0: PME# disabled
Dec  7 14:44:51 hal kernel: [    1.684301] pci 0000:00:11.0: reg 10: [io  0xd000-0xd007]
Dec  7 14:44:51 hal kernel: [    1.684310] pci 0000:00:11.0: reg 14: [io  0xc000-0xc003]
Dec  7 14:44:51 hal kernel: [    1.684320] pci 0000:00:11.0: reg 18: [io  0xb000-0xb007]
Dec  7 14:44:51 hal kernel: [    1.684329] pci 0000:00:11.0: reg 1c: [io  0xa000-0xa003]
Dec  7 14:44:51 hal kernel: [    1.684338] pci 0000:00:11.0: reg 20: [io  0x9000-0x900f]
Dec  7 14:44:51 hal kernel: [    1.684348] pci 0000:00:11.0: reg 24: [mem 0xfeafa400-0xfeafa7ff]
Dec  7 14:44:51 hal kernel: [    1.684405] pci 0000:00:12.0: reg 10: [mem 0xfeaf6000-0xfeaf6fff]
Dec  7 14:44:51 hal kernel: [    1.684476] pci 0000:00:12.1: reg 10: [mem 0xfeaf7000-0xfeaf7fff]
Dec  7 14:44:51 hal kernel: [    1.684557] pci 0000:00:12.2: reg 10: [mem 0xfeafa800-0xfeafa8ff]
Dec  7 14:44:51 hal kernel: [    1.684622] pci 0000:00:12.2: supports D1 D2
Dec  7 14:44:51 hal kernel: [    1.684624] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Dec  7 14:44:51 hal kernel: [    1.684628] pci 0000:00:12.2: PME# disabled
Dec  7 14:44:51 hal kernel: [    1.684660] pci 0000:00:13.0: reg 10: [mem 0xfeaf8000-0xfeaf8fff]
Dec  7 14:44:51 hal kernel: [    1.684730] pci 0000:00:13.1: reg 10: [mem 0xfeaf9000-0xfeaf9fff]
Dec  7 14:44:51 hal kernel: [    1.684813] pci 0000:00:13.2: reg 10: [mem 0xfeafac00-0xfeafacff]
Dec  7 14:44:51 hal kernel: [    1.684878] pci 0000:00:13.2: supports D1 D2
Dec  7 14:44:51 hal kernel: [    1.684880] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Dec  7 14:44:51 hal kernel: [    1.684884] pci 0000:00:13.2: PME# disabled
Dec  7 14:44:51 hal kernel: [    1.685005] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
Dec  7 14:44:51 hal kernel: [    1.685015] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
Dec  7 14:44:51 hal kernel: [    1.685024] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
Dec  7 14:44:51 hal kernel: [    1.685033] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
Dec  7 14:44:51 hal kernel: [    1.685042] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
Dec  7 14:44:51 hal kernel: [    1.685202] pci 0000:00:14.5: reg 10: [mem 0xfeafb000-0xfeafbfff]
Dec  7 14:44:51 hal kernel: [    1.685627] pci 0000:02:00.0: reg 10: [mem 0xfeb60000-0xfeb7ffff]
Dec  7 14:44:51 hal kernel: [    1.685636] pci 0000:02:00.0: reg 14: [mem 0xfeb40000-0xfeb5ffff]
Dec  7 14:44:51 hal kernel: [    1.685644] pci 0000:02:00.0: reg 18: [io  0xe400-0xe41f]
Dec  7 14:44:51 hal kernel: [    1.685652] pci 0000:02:00.0: reg 1c: [mem 0xfeb1c000-0xfeb1ffff]
Dec  7 14:44:51 hal kernel: [    1.685673] pci 0000:02:00.0: reg 30: [mem 0xfeb20000-0xfeb3ffff pref]
Dec  7 14:44:51 hal kernel: [    1.685704] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
Dec  7 14:44:51 hal kernel: [    1.685707] pci 0000:02:00.0: PME# disabled
Dec  7 14:44:51 hal kernel: [    1.685740] pci 0000:02:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.685758] pci 0000:02:00.0: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.685797] pci 0000:02:00.1: reg 10: [mem 0xfebe0000-0xfebfffff]
Dec  7 14:44:51 hal kernel: [    1.685805] pci 0000:02:00.1: reg 14: [mem 0xfebc0000-0xfebdffff]
Dec  7 14:44:51 hal kernel: [    1.685814] pci 0000:02:00.1: reg 18: [io  0xe800-0xe81f]
Dec  7 14:44:51 hal kernel: [    1.685822] pci 0000:02:00.1: reg 1c: [mem 0xfeb9c000-0xfeb9ffff]
Dec  7 14:44:51 hal kernel: [    1.685843] pci 0000:02:00.1: reg 30: [mem 0xfeba0000-0xfebbffff pref]
Dec  7 14:44:51 hal kernel: [    1.685873] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
Dec  7 14:44:51 hal kernel: [    1.685876] pci 0000:02:00.1: PME# disabled
Dec  7 14:44:51 hal kernel: [    1.685906] pci 0000:02:00.1: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.685923] pci 0000:02:00.1: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.690019] pci 0000:00:04.0: PCI bridge to [bus 02-02]
Dec  7 14:44:51 hal kernel: [    1.690121] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
Dec  7 14:44:51 hal kernel: [    1.690124] pci 0000:00:04.0:   bridge window [mem 0xfeb00000-0xfebfffff]
Dec  7 14:44:51 hal kernel: [    1.690128] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Dec  7 14:44:51 hal kernel: [    1.690183] pci 0000:01:04.0: reg 10: [mem 0xfc000000-0xfcffffff pref]
Dec  7 14:44:51 hal kernel: [    1.690198] pci 0000:01:04.0: reg 14: [mem 0xfdffc000-0xfdffffff]
Dec  7 14:44:51 hal kernel: [    1.690210] pci 0000:01:04.0: reg 18: [mem 0xfe000000-0xfe7fffff]
Dec  7 14:44:51 hal kernel: [    1.690320] pci 0000:00:14.4: PCI bridge to [bus 01-01] (subtractive decode)
Dec  7 14:44:51 hal kernel: [    1.690424] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
Dec  7 14:44:51 hal kernel: [    1.690429] pci 0000:00:14.4:   bridge window [mem 0xfdf00000-0xfe7fffff]
Dec  7 14:44:51 hal kernel: [    1.690433] pci 0000:00:14.4:   bridge window [mem 0xfc000000-0xfcffffff pref]
Dec  7 14:44:51 hal kernel: [    1.690436] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Dec  7 14:44:51 hal kernel: [    1.690439] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Dec  7 14:44:51 hal kernel: [    1.690442] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Dec  7 14:44:51 hal kernel: [    1.690444] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
Dec  7 14:44:51 hal kernel: [    1.690447] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
Dec  7 14:44:51 hal kernel: [    1.690450] pci 0000:00:14.4:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
Dec  7 14:44:51 hal kernel: [    1.690462] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Dec  7 14:44:51 hal kernel: [    1.690661] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
Dec  7 14:44:51 hal kernel: [    1.690704] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC04._PRT]
Dec  7 14:44:51 hal kernel: [    1.700310] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 *10 11 12 14 15)
Dec  7 14:44:51 hal kernel: [    1.700696] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
Dec  7 14:44:51 hal kernel: [    1.701309] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 *7 10 11 12 14 15)
Dec  7 14:44:51 hal kernel: [    1.703677] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
Dec  7 14:44:51 hal kernel: [    1.704290] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 12 14 15)
Dec  7 14:44:51 hal kernel: [    1.704899] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Dec  7 14:44:51 hal kernel: [    1.705643] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
Dec  7 14:44:51 hal kernel: [    1.706252] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Dec  7 14:44:51 hal kernel: [    1.706971] HEST: HEST table parsing is initialized.
Dec  7 14:44:51 hal kernel: [    1.706971] vgaarb: device added: PCI:0000:01:04.0,decodes=io+mem,owns=io+mem,locks=none
Dec  7 14:44:51 hal kernel: [    1.706971] vgaarb: loaded
Dec  7 14:44:51 hal kernel: [    1.706971] PCI: Using ACPI for IRQ routing
Dec  7 14:44:51 hal kernel: [    1.706971] PCI: pci_cache_line_size set to 64 bytes
Dec  7 14:44:51 hal kernel: [    1.706971] reserve RAM buffer: 0000000000096800 - 000000000009ffff 
Dec  7 14:44:51 hal kernel: [    1.706971] reserve RAM buffer: 00000000dfe90000 - 00000000dfffffff 
Dec  7 14:44:51 hal kernel: [    1.706971] NetLabel: Initializing
Dec  7 14:44:51 hal kernel: [    1.706971] NetLabel:  domain hash size = 128
Dec  7 14:44:51 hal kernel: [    1.706971] NetLabel:  protocols = UNLABELED CIPSOv4
Dec  7 14:44:51 hal kernel: [    1.710018] NetLabel:  unlabeled traffic allowed by default
Dec  7 14:44:51 hal kernel: [    1.710122] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Dec  7 14:44:51 hal kernel: [    1.710485] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Dec  7 14:44:51 hal kernel: [    1.712628] Switching to clocksource tsc
Dec  7 14:44:51 hal kernel: [    1.712841] pnp: PnP ACPI init
Dec  7 14:44:51 hal kernel: [    1.712841] ACPI: bus type pnp registered
Dec  7 14:44:51 hal kernel: [    1.715907] pnp: PnP ACPI: found 16 devices
Dec  7 14:44:51 hal kernel: [    1.716000] ACPI: ACPI bus type pnp unregistered
Dec  7 14:44:51 hal kernel: [    1.716107] system 00:02: [mem 0xf6000000-0xf6003fff] has been reserved
Dec  7 14:44:51 hal kernel: [    1.716212] system 00:08: [io  0x0a10-0x0a1f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.716315] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
Dec  7 14:44:51 hal kernel: [    1.716417] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
Dec  7 14:44:51 hal kernel: [    1.716520] system 00:0b: [io  0x0ca2-0x0ca3] has been reserved
Dec  7 14:44:51 hal kernel: [    1.716619] system 00:0b: [io  0x0550-0x0551] has been reserved
Dec  7 14:44:51 hal kernel: [    1.716723] system 00:0b: [io  0x04d0-0x04d1] has been reserved
Dec  7 14:44:51 hal kernel: [    1.716823] system 00:0b: [io  0x040b] has been reserved
Dec  7 14:44:51 hal kernel: [    1.716919] system 00:0b: [io  0x04d6] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717017] system 00:0b: [io  0x0c00-0x0c01] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717115] system 00:0b: [io  0x0c14] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717212] system 00:0b: [io  0x0c50-0x0c51] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717310] system 00:0b: [io  0x0c52] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717406] system 00:0b: [io  0x0c6c] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717502] system 00:0b: [io  0x0c6f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717598] system 00:0b: [io  0x0cd0-0x0cd1] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717697] system 00:0b: [io  0x0cd2-0x0cd3] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717795] system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717893] system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
Dec  7 14:44:51 hal kernel: [    1.717991] system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718090] system 00:0b: [io  0x0800-0x089f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718188] system 00:0b: [io  0x0b00-0x0b0f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718286] system 00:0b: [io  0x0b20-0x0b3f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718384] system 00:0b: [io  0x0900-0x090f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718482] system 00:0b: [io  0x0910-0x091f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718581] system 00:0b: [io  0xfe00-0xfefe] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718680] system 00:0b: [mem 0xffb80000-0xffbfffff] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718781] system 00:0b: [mem 0xfec10000-0xfec1001f] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718884] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
Dec  7 14:44:51 hal kernel: [    1.718988] system 00:0f: [mem 0x000c0000-0x000cffff] has been reserved
Dec  7 14:44:51 hal kernel: [    1.719089] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
Dec  7 14:44:51 hal kernel: [    1.719190] system 00:0f: [mem 0xfec00000-0xffffffff] could not be reserved
Dec  7 14:44:51 hal kernel: [    1.733923] pci 0000:02:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.733936] pci 0000:02:00.0: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.733947] pci 0000:02:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.733959] pci 0000:02:00.1: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.733970] pci 0000:02:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.733981] pci 0000:02:00.0: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.733992] pci 0000:02:00.1: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734004] pci 0000:02:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734015] pci 0000:02:00.0: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734026] pci 0000:02:00.1: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734037] pci 0000:02:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734048] pci 0000:02:00.0: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734052] pci 0000:02:00.0: BAR 7: can't assign mem (size 0x20000)
Dec  7 14:44:51 hal kernel: [    1.734165] pci 0000:02:00.0: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734176] pci 0000:02:00.0: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734179] pci 0000:02:00.0: BAR 10: can't assign mem (size 0x20000)
Dec  7 14:44:51 hal kernel: [    1.734288] pci 0000:02:00.1: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734299] pci 0000:02:00.1: reg 184: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734301] pci 0000:02:00.1: BAR 7: can't assign mem (size 0x20000)
Dec  7 14:44:51 hal kernel: [    1.734410] pci 0000:02:00.1: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734421] pci 0000:02:00.1: reg 190: [mem 0x00000000-0x00003fff 64bit]
Dec  7 14:44:51 hal kernel: [    1.734423] pci 0000:02:00.1: BAR 10: can't assign mem (size 0x20000)
Dec  7 14:44:51 hal kernel: [    1.734523] pci 0000:00:04.0: PCI bridge to [bus 02-02]
Dec  7 14:44:51 hal kernel: [    1.734619] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
Dec  7 14:44:51 hal kernel: [    1.734718] pci 0000:00:04.0:   bridge window [mem 0xfeb00000-0xfebfffff]
Dec  7 14:44:51 hal kernel: [    1.734819] pci 0000:00:04.0:   bridge window [mem pref disabled]
Dec  7 14:44:51 hal kernel: [    1.734919] pci 0000:00:14.4: PCI bridge to [bus 01-01]
Dec  7 14:44:51 hal kernel: [    1.735016] pci 0000:00:14.4:   bridge window [io  disabled]
Dec  7 14:44:51 hal kernel: [    1.735115] pci 0000:00:14.4:   bridge window [mem 0xfdf00000-0xfe7fffff]
Dec  7 14:44:51 hal kernel: [    1.735218] pci 0000:00:14.4:   bridge window [mem 0xfc000000-0xfcffffff pref]
Dec  7 14:44:51 hal kernel: [    1.735360]   alloc irq_desc for 16 on node 0
Dec  7 14:44:51 hal kernel: [    1.735364]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    1.735375] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec  7 14:44:51 hal kernel: [    1.735477] pci 0000:00:04.0: setting latency timer to 64
Dec  7 14:44:51 hal kernel: [    1.735485] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Dec  7 14:44:51 hal kernel: [    1.735487] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Dec  7 14:44:51 hal kernel: [    1.735489] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Dec  7 14:44:51 hal kernel: [    1.735492] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
Dec  7 14:44:51 hal kernel: [    1.735494] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]
Dec  7 14:44:51 hal kernel: [    1.735496] pci_bus 0000:00: resource 9 [mem 0xfed40000-0xfed44fff]
Dec  7 14:44:51 hal kernel: [    1.735498] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
Dec  7 14:44:51 hal kernel: [    1.735500] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
Dec  7 14:44:51 hal kernel: [    1.735503] pci_bus 0000:01: resource 1 [mem 0xfdf00000-0xfe7fffff]
Dec  7 14:44:51 hal kernel: [    1.735505] pci_bus 0000:01: resource 2 [mem 0xfc000000-0xfcffffff pref]
Dec  7 14:44:51 hal kernel: [    1.735507] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
Dec  7 14:44:51 hal kernel: [    1.735509] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
Dec  7 14:44:51 hal kernel: [    1.735512] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
Dec  7 14:44:51 hal kernel: [    1.735514] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
Dec  7 14:44:51 hal kernel: [    1.735516] pci_bus 0000:01: resource 8 [mem 0xf0000000-0xfebfffff]
Dec  7 14:44:51 hal kernel: [    1.735518] pci_bus 0000:01: resource 9 [mem 0xfed40000-0xfed44fff]
Dec  7 14:44:51 hal kernel: [    1.735558] NET: Registered protocol family 2
Dec  7 14:44:51 hal kernel: [    1.736151] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
Dec  7 14:44:51 hal kernel: [    1.738411] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Dec  7 14:44:51 hal kernel: [    1.741417] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Dec  7 14:44:51 hal kernel: [    1.741883] TCP: Hash tables configured (established 524288 bind 65536)
Dec  7 14:44:51 hal kernel: [    1.741983] TCP reno registered
Dec  7 14:44:51 hal kernel: [    1.742183] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
Dec  7 14:44:51 hal kernel: [    1.742836] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
Dec  7 14:44:51 hal kernel: [    1.743573] NET: Registered protocol family 1
Dec  7 14:44:51 hal kernel: [    2.506807] pci 0000:01:04.0: Boot video device
Dec  7 14:44:51 hal kernel: [    2.506813] PCI: CLS 64 bytes, default 64
Dec  7 14:44:51 hal kernel: [    2.506875] Trying to unpack rootfs image as initramfs...
Dec  7 14:44:51 hal kernel: [    2.637501] rootfs image is not initramfs (no cpio magic); looks like an initrd
Dec  7 14:44:51 hal kernel: [    2.638354] Freeing initrd memory: 756k freed
Dec  7 14:44:51 hal kernel: [    2.638722] pci 0000:00:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec  7 14:44:51 hal kernel: [    2.639213]   alloc irq_desc for 40 on node 0
Dec  7 14:44:51 hal kernel: [    2.639216]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    2.639224] pci 0000:00:00.2: irq 40 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    2.639242] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40
Dec  7 14:44:51 hal kernel: [    2.648960] AMD-Vi: Lazy IO/TLB flushing enabled
Dec  7 14:44:51 hal kernel: [    2.664754] Scanning for low memory corruption every 60 seconds
Dec  7 14:44:51 hal kernel: [    2.665579] audit: initializing netlink socket (disabled)
Dec  7 14:44:51 hal kernel: [    2.665687] type=2000 audit(1291729474.663:1): initialized
Dec  7 14:44:51 hal kernel: [    2.691385] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Dec  7 14:44:51 hal kernel: [    2.704817] VFS: Disk quotas dquot_6.5.2
Dec  7 14:44:51 hal kernel: [    2.705070] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Dec  7 14:44:51 hal kernel: [    2.705367] ROMFS MTD (C) 2007 Red Hat, Inc.
Dec  7 14:44:51 hal kernel: [    2.705598] msgmni has been set to 32768
Dec  7 14:44:51 hal kernel: [    2.706616] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Dec  7 14:44:51 hal kernel: [    2.706754] io scheduler noop registered
Dec  7 14:44:51 hal kernel: [    2.706845] io scheduler deadline registered
Dec  7 14:44:51 hal kernel: [    2.707183] io scheduler cfq registered (default)
Dec  7 14:44:51 hal kernel: [    2.708796] APEI: Can not request iomem region <00000000dfec60ea-00000000dfec60ec> for GARs.
Dec  7 14:44:51 hal kernel: [    2.784506] Linux agpgart interface v0.103
Dec  7 14:44:51 hal kernel: [    2.784715] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Dec  7 14:44:51 hal kernel: [    3.056846] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Dec  7 14:44:51 hal kernel: [    3.330174] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Dec  7 14:44:51 hal kernel: [    3.351777] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Dec  7 14:44:51 hal kernel: [    3.372821] 00:0d: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Dec  7 14:44:51 hal kernel: [    3.377581] brd: module loaded
Dec  7 14:44:51 hal kernel: [    3.377894] Fixed MDIO Bus: probed
Dec  7 14:44:51 hal kernel: [    3.378214] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Dec  7 14:44:51 hal kernel: [    3.378318] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Dec  7 14:44:51 hal kernel: [    3.379227] serio: i8042 KBD port at 0x60,0x64 irq 1
Dec  7 14:44:51 hal kernel: [    3.379737] mice: PS/2 mouse device common for all mice
Dec  7 14:44:51 hal kernel: [    3.379975] rtc_cmos 00:04: RTC can wake from S4
Dec  7 14:44:51 hal kernel: [    3.380227] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
Dec  7 14:44:51 hal kernel: [    3.380360] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Dec  7 14:44:51 hal kernel: [    3.380557] cpuidle: using governor ladder
Dec  7 14:44:51 hal kernel: [    3.380656] cpuidle: using governor menu
Dec  7 14:44:51 hal kernel: [    3.381032] TCP cubic registered
Dec  7 14:44:51 hal kernel: [    3.381851] NET: Registered protocol family 10
Dec  7 14:44:51 hal kernel: [    3.382772] lo: Disabled Privacy Extensions
Dec  7 14:44:51 hal kernel: [    3.382897] Mobile IPv6
Dec  7 14:44:51 hal kernel: [    3.382984] NET: Registered protocol family 17
Dec  7 14:44:51 hal kernel: [    3.383186] Registering the dns_resolver key type
Dec  7 14:44:51 hal kernel: [    3.383729] TuxOnIce: Ignoring late initcall, as requested.
Dec  7 14:44:51 hal kernel: [    3.383844] registered taskstats version 1
Dec  7 14:44:51 hal kernel: [    3.384467] rtc_cmos 00:04: setting system clock to 2010-12-07 13:44:36 UTC (1291729476)
Dec  7 14:44:51 hal kernel: [    3.384644] Initalizing network drop monitor service
Dec  7 14:44:51 hal kernel: [    3.407096] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Dec  7 14:44:51 hal kernel: [    3.407308] RAMDISK: lzma image found at block 0
Dec  7 14:44:51 hal kernel: [    3.541687] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
Dec  7 14:44:51 hal kernel: [    3.561862] SCSI subsystem initialized
Dec  7 14:44:51 hal kernel: [    3.578284] libata version 3.00 loaded.
Dec  7 14:44:51 hal kernel: [    3.586137] ahci 0000:00:11.0: version 3.0
Dec  7 14:44:51 hal kernel: [    3.586164]   alloc irq_desc for 22 on node 0
Dec  7 14:44:51 hal kernel: [    3.586169]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    3.586176] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Dec  7 14:44:51 hal kernel: [    3.586738] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Dec  7 14:44:51 hal kernel: [    3.586871] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Dec  7 14:44:51 hal kernel: [    3.587325] scsi0 : ahci
Dec  7 14:44:51 hal kernel: [    3.587963] scsi1 : ahci
Dec  7 14:44:51 hal kernel: [    3.588323] scsi2 : ahci
Dec  7 14:44:51 hal kernel: [    3.590143] scsi3 : ahci
Dec  7 14:44:51 hal kernel: [    3.590451] ata1: SATA max UDMA/133 abar m1024@0xfeafa400 port 0xfeafa500 irq 22
Dec  7 14:44:51 hal kernel: [    3.590583] ata2: SATA max UDMA/133 abar m1024@0xfeafa400 port 0xfeafa580 irq 22
Dec  7 14:44:51 hal kernel: [    3.590712] ata3: SATA max UDMA/133 abar m1024@0xfeafa400 port 0xfeafa600 irq 22
Dec  7 14:44:51 hal kernel: [    3.590841] ata4: SATA max UDMA/133 abar m1024@0xfeafa400 port 0xfeafa680 irq 22
Dec  7 14:44:51 hal kernel: [    4.076767] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec  7 14:44:51 hal kernel: [    4.076773] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec  7 14:44:51 hal kernel: [    4.076778] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec  7 14:44:51 hal kernel: [    4.076812] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec  7 14:44:51 hal kernel: [    4.077676] ata3.00: ATA-8: WDC WD1002FBYS-02A6B0, 03.00C06, max UDMA/133
Dec  7 14:44:51 hal kernel: [    4.077680] ata2.00: ATA-8: WDC WD1002FBYS-02A6B0, 03.00C06, max UDMA/133
Dec  7 14:44:51 hal kernel: [    4.077684] ata4.00: ATA-8: WDC WD1002FBYS-02A6B0, 03.00C06, max UDMA/133
Dec  7 14:44:51 hal kernel: [    4.077688] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Dec  7 14:44:51 hal kernel: [    4.077692] ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Dec  7 14:44:51 hal kernel: [    4.078084] ata1.00: ATA-8: WDC WD1002FBYS-02A6B0, 03.00C06, max UDMA/133
Dec  7 14:44:51 hal kernel: [    4.078087] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Dec  7 14:44:51 hal kernel: [    4.078410] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Dec  7 14:44:51 hal kernel: [    4.078632] ata4.00: configured for UDMA/133
Dec  7 14:44:51 hal kernel: [    4.078651] ata2.00: configured for UDMA/133
Dec  7 14:44:51 hal kernel: [    4.079039] ata1.00: configured for UDMA/133
Dec  7 14:44:51 hal kernel: [    4.079448] ata3.00: configured for UDMA/133
Dec  7 14:44:51 hal kernel: [    4.090298] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
Dec  7 14:44:51 hal kernel: [    4.091299] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
Dec  7 14:44:51 hal kernel: [    4.092249] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
Dec  7 14:44:51 hal kernel: [    4.093221] scsi 3:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
Dec  7 14:44:51 hal kernel: [    4.115839] md: raid1 personality registered for level 1
Dec  7 14:44:51 hal kernel: [    4.121257] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Dec  7 14:44:51 hal kernel: [    4.121458] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Dec  7 14:44:51 hal kernel: [    4.121570] sd 0:0:0:0: [sda] Write Protect is off
Dec  7 14:44:51 hal kernel: [    4.121574] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Dec  7 14:44:51 hal kernel: [    4.121617] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec  7 14:44:51 hal kernel: [    4.121716] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Dec  7 14:44:51 hal kernel: [    4.121835] sd 2:0:0:0: [sdc] Write Protect is off
Dec  7 14:44:51 hal kernel: [    4.121839] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Dec  7 14:44:51 hal kernel: [    4.121843] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Dec  7 14:44:51 hal kernel: [    4.121880] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec  7 14:44:51 hal kernel: [    4.121938] sd 3:0:0:0: [sdd] Write Protect is off
Dec  7 14:44:51 hal kernel: [    4.121941] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Dec  7 14:44:51 hal kernel: [    4.121985] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec  7 14:44:51 hal kernel: [    4.122580] sd 1:0:0:0: [sdb] Write Protect is off
Dec  7 14:44:51 hal kernel: [    4.122677] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Dec  7 14:44:51 hal kernel: [    4.122693] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec  7 14:44:51 hal kernel: [    4.140645]  sda: sda1 sda2 sda3 sda4
Dec  7 14:44:51 hal kernel: [    4.141691] sd 0:0:0:0: [sda] Attached SCSI disk
Dec  7 14:44:51 hal kernel: [    4.145626]  sdd: sdd1 sdd2 sdd3 sdd4
Dec  7 14:44:51 hal kernel: [    4.146657] sd 3:0:0:0: [sdd] Attached SCSI disk
Dec  7 14:44:51 hal kernel: [    4.148087]  sdc: sdc1 sdc2 sdc3 sdc4
Dec  7 14:44:51 hal kernel: [    4.149118] sd 2:0:0:0: [sdc] Attached SCSI disk
Dec  7 14:44:51 hal kernel: [    4.155151]  sdb: sdb1 sdb2 sdb3 sdb4
Dec  7 14:44:51 hal kernel: [    4.156063] sd 1:0:0:0: [sdb] Attached SCSI disk
Dec  7 14:44:51 hal kernel: [    4.291917] md: md0 stopped.
Dec  7 14:44:51 hal kernel: [    4.294394] md: bind<sdb1>
Dec  7 14:44:51 hal kernel: [    4.294709] md: bind<sdc1>
Dec  7 14:44:51 hal kernel: [    4.295034] md: bind<sdd1>
Dec  7 14:44:51 hal kernel: [    4.295346] md: bind<sda1>
Dec  7 14:44:51 hal kernel: [    4.295731] md/raid1:md0: active with 4 out of 4 mirrors
Dec  7 14:44:51 hal kernel: [    4.295863] md0: detected capacity change from 0 to 8192262144
Dec  7 14:44:51 hal kernel: [    4.298923]  md0: unknown partition table
Dec  7 14:44:51 hal kernel: [    4.317263] EXT3-fs: barriers not enabled
Dec  7 14:44:51 hal kernel: [    4.338429] kjournald starting.  Commit interval 5 seconds
Dec  7 14:44:51 hal kernel: [    4.338454] EXT3-fs (md0): mounted filesystem with writeback data mode
Dec  7 14:44:51 hal kernel: [    4.338470] VFS: Mounted root (ext3 filesystem) readonly on device 9:0.
Dec  7 14:44:51 hal kernel: [    4.338472] Trying to move old root to /initrd ... okay
Dec  7 14:44:51 hal kernel: [    4.383651] devtmpfs: mounted
Dec  7 14:44:51 hal kernel: [    4.383986] Freeing unused kernel memory: 484k freed
Dec  7 14:44:51 hal kernel: [    6.174967] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
Dec  7 14:44:51 hal kernel: [    6.174974] ACPI: Power Button [PWRB]
Dec  7 14:44:51 hal kernel: [    6.175025] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Dec  7 14:44:51 hal kernel: [    6.175028] ACPI: Power Button [PWRF]
Dec  7 14:44:51 hal kernel: [    6.177454] ACPI: acpi_idle registered with cpuidle
Dec  7 14:44:51 hal kernel: [    6.261502] input: PC Speaker as /devices/platform/pcspkr/input/input3
Dec  7 14:44:51 hal kernel: [    6.312959] sd 0:0:0:0: Attached scsi generic sg0 type 0
Dec  7 14:44:51 hal kernel: [    6.313054] sd 1:0:0:0: Attached scsi generic sg1 type 0
Dec  7 14:44:51 hal kernel: [    6.313149] sd 2:0:0:0: Attached scsi generic sg2 type 0
Dec  7 14:44:51 hal kernel: [    6.313217] sd 3:0:0:0: Attached scsi generic sg3 type 0
Dec  7 14:44:51 hal kernel: [    6.326841] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Dec  7 14:44:51 hal kernel: [    6.327941] GHES: Generic hardware error source: 0 notified via NMI is not supported!
Dec  7 14:44:51 hal kernel: [    6.349200] usbcore: registered new interface driver usbfs
Dec  7 14:44:51 hal kernel: [    6.349242] usbcore: registered new interface driver hub
Dec  7 14:44:51 hal kernel: [    6.349320] usbcore: registered new device driver usb
Dec  7 14:44:51 hal kernel: [    6.356780] EDAC MC: Ver: 2.1.0 Dec  2 2010
Dec  7 14:44:51 hal kernel: [    6.356905] GHES: Generic hardware error source: 1 notified via POLL is not supported!
Dec  7 14:44:51 hal kernel: [    6.357944] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Dec  7 14:44:51 hal kernel: [    6.371095] Uniform Multi-Platform E-IDE driver
Dec  7 14:44:51 hal kernel: [    6.372537] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Dec  7 14:44:51 hal kernel: [    6.373703] EDAC amd64_edac:  Ver: 3.3.0 Dec  2 2010
Dec  7 14:44:51 hal kernel: [    6.373877] EDAC amd64: ECC is enabled by BIOS.
Dec  7 14:44:51 hal kernel: [    6.373989] EDAC amd64: ECC is enabled by BIOS.
Dec  7 14:44:51 hal kernel: [    6.374139] EDAC amd64: ECC is enabled by BIOS.
Dec  7 14:44:51 hal kernel: [    6.374311] EDAC amd64: ECC is enabled by BIOS.
Dec  7 14:44:51 hal kernel: [    6.374439] EDAC MC: F10h CPU detected
Dec  7 14:44:51 hal kernel: [    6.374454] EDAC amd64: using x8 syndromes.
Dec  7 14:44:51 hal kernel: [    6.374456] EDAC MC: DCT0 chip selects:
Dec  7 14:44:51 hal kernel: [    6.374459] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374461] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374463] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.374465] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.374467] EDAC MC: DCT1 chip selects:
Dec  7 14:44:51 hal kernel: [    6.374469] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374471] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374472] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.374474] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.374542] EDAC MC0: Giving out device to 'amd64_edac' 'Family 10h': DEV 0000:00:18.2
Dec  7 14:44:51 hal kernel: [    6.374544] EDAC MC: F10h CPU detected
Dec  7 14:44:51 hal kernel: [    6.374558] EDAC amd64: using x8 syndromes.
Dec  7 14:44:51 hal kernel: [    6.374560] EDAC MC: DCT0 chip selects:
Dec  7 14:44:51 hal kernel: [    6.374561] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374563] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374565] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.374567] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.374568] EDAC MC: DCT1 chip selects:
Dec  7 14:44:51 hal kernel: [    6.374570] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374572] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374573] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.374575] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.374714] EDAC MC1: Giving out device to 'amd64_edac' 'Family 10h': DEV 0000:00:19.2
Dec  7 14:44:51 hal kernel: [    6.374717] EDAC MC: F10h CPU detected
Dec  7 14:44:51 hal kernel: [    6.374731] EDAC amd64: using x8 syndromes.
Dec  7 14:44:51 hal kernel: [    6.374732] EDAC MC: DCT0 chip selects:
Dec  7 14:44:51 hal kernel: [    6.374735] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374737] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374738] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.374740] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.374742] EDAC MC: DCT1 chip selects:
Dec  7 14:44:51 hal kernel: [    6.374744] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374746] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.374747] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.374749] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.375178] EDAC MC2: Giving out device to 'amd64_edac' 'Family 10h': DEV 0000:00:1a.2
Dec  7 14:44:51 hal kernel: [    6.375182] EDAC MC: F10h CPU detected
Dec  7 14:44:51 hal kernel: [    6.375198] EDAC amd64: using x8 syndromes.
Dec  7 14:44:51 hal kernel: [    6.375200] EDAC MC: DCT0 chip selects:
Dec  7 14:44:51 hal kernel: [    6.375203] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.375205] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.375207] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.375209] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.375210] EDAC MC: DCT1 chip selects:
Dec  7 14:44:51 hal kernel: [    6.375212] EDAC MC:  0:  2048MB 1:  2048MB
Dec  7 14:44:51 hal kernel: [    6.375214] EDAC MC:  2:  2048MB 3:  2048MB
Dec  7 14:44:51 hal kernel: [    6.375216] EDAC MC:  4:     0MB 5:     0MB
Dec  7 14:44:51 hal kernel: [    6.375217] EDAC MC:  6:     0MB 7:     0MB
Dec  7 14:44:51 hal kernel: [    6.375681] EDAC MC3: Giving out device to 'amd64_edac' 'Family 10h': DEV 0000:00:1b.2
Dec  7 14:44:51 hal kernel: [    6.375761] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
Dec  7 14:44:51 hal kernel: [    6.473958] dca service started, version 1.12.1
Dec  7 14:44:51 hal kernel: [    6.482136] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Dec  7 14:44:51 hal kernel: [    6.482232]   alloc irq_desc for 17 on node 0
Dec  7 14:44:51 hal kernel: [    6.482235]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.482243] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Dec  7 14:44:51 hal kernel: [    6.482364] ehci_hcd 0000:00:12.2: EHCI Host Controller
Dec  7 14:44:51 hal kernel: [    6.482402] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Dec  7 14:44:51 hal kernel: [    6.482443] ehci_hcd 0000:00:12.2: debug port 1
Dec  7 14:44:51 hal kernel: [    6.482467] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfeafa800
Dec  7 14:44:51 hal kernel: [    6.490031] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Dec  7 14:44:51 hal kernel: [    6.490062] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Dec  7 14:44:51 hal kernel: [    6.490065] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec  7 14:44:51 hal kernel: [    6.490068] usb usb1: Product: EHCI Host Controller
Dec  7 14:44:51 hal kernel: [    6.490071] usb usb1: Manufacturer: Linux 2.6.36.1-3 ehci_hcd
Dec  7 14:44:51 hal kernel: [    6.490074] usb usb1: SerialNumber: 0000:00:12.2
Dec  7 14:44:51 hal kernel: [    6.493529] hub 1-0:1.0: USB hub found
Dec  7 14:44:51 hal kernel: [    6.493539] hub 1-0:1.0: 6 ports detected
Dec  7 14:44:51 hal kernel: [    6.495115]   alloc irq_desc for 19 on node 0
Dec  7 14:44:51 hal kernel: [    6.495122]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.495129] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Dec  7 14:44:51 hal kernel: [    6.495166] ehci_hcd 0000:00:13.2: EHCI Host Controller
Dec  7 14:44:51 hal kernel: [    6.495191] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
Dec  7 14:44:51 hal kernel: [    6.495228] ehci_hcd 0000:00:13.2: debug port 1
Dec  7 14:44:51 hal kernel: [    6.495259] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfeafac00
Dec  7 14:44:51 hal kernel: [    6.503417] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Dec  7 14:44:51 hal kernel: [    6.503486] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Dec  7 14:44:51 hal kernel: [    6.503489] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec  7 14:44:51 hal kernel: [    6.503491] usb usb2: Product: EHCI Host Controller
Dec  7 14:44:51 hal kernel: [    6.503493] usb usb2: Manufacturer: Linux 2.6.36.1-3 ehci_hcd
Dec  7 14:44:51 hal kernel: [    6.503495] usb usb2: SerialNumber: 0000:00:13.2
Dec  7 14:44:51 hal kernel: [    6.504256] hub 2-0:1.0: USB hub found
Dec  7 14:44:51 hal kernel: [    6.504261] hub 2-0:1.0: 6 ports detected
Dec  7 14:44:51 hal kernel: [    6.504629] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
Dec  7 14:44:51 hal kernel: [    6.504639] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec  7 14:44:51 hal kernel: [    6.504661] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
Dec  7 14:44:51 hal kernel: [    6.504667]     ide0: BM-DMA at 0xff00-0xff07
Dec  7 14:44:51 hal kernel: [    6.504676]     ide1: BM-DMA at 0xff08-0xff0f
Dec  7 14:44:51 hal kernel: [    6.504681] Probing IDE interface ide0...
Dec  7 14:44:51 hal kernel: [    6.555880] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
Dec  7 14:44:51 hal kernel: [    6.555883] Copyright (c) 2007-2009 Intel Corporation.
Dec  7 14:44:51 hal kernel: [    6.556116] igb 0000:02:00.0: power state changed by ACPI to D0
Dec  7 14:44:51 hal kernel: [    6.556195] igb 0000:02:00.0: power state changed by ACPI to D0
Dec  7 14:44:51 hal kernel: [    6.556202] igb 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec  7 14:44:51 hal kernel: [    6.556215] igb 0000:02:00.0: setting latency timer to 64
Dec  7 14:44:51 hal kernel: [    6.556522]   alloc irq_desc for 41 on node 0
Dec  7 14:44:51 hal kernel: [    6.556524]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556529] igb 0000:02:00.0: irq 41 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556531]   alloc irq_desc for 42 on node 0
Dec  7 14:44:51 hal kernel: [    6.556533]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556535] igb 0000:02:00.0: irq 42 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556537]   alloc irq_desc for 43 on node 0
Dec  7 14:44:51 hal kernel: [    6.556538]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556540] igb 0000:02:00.0: irq 43 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556542]   alloc irq_desc for 44 on node 0
Dec  7 14:44:51 hal kernel: [    6.556543]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556546] igb 0000:02:00.0: irq 44 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556547]   alloc irq_desc for 45 on node 0
Dec  7 14:44:51 hal kernel: [    6.556549]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556551] igb 0000:02:00.0: irq 45 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556552]   alloc irq_desc for 46 on node 0
Dec  7 14:44:51 hal kernel: [    6.556554]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556556] igb 0000:02:00.0: irq 46 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556558]   alloc irq_desc for 47 on node 0
Dec  7 14:44:51 hal kernel: [    6.556559]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556561] igb 0000:02:00.0: irq 47 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556563]   alloc irq_desc for 48 on node 0
Dec  7 14:44:51 hal kernel: [    6.556564]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556566] igb 0000:02:00.0: irq 48 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556568]   alloc irq_desc for 49 on node 0
Dec  7 14:44:51 hal kernel: [    6.556569]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.556571] igb 0000:02:00.0: irq 49 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.556612] igb 0000:02:00.0: 0 vfs allocated
Dec  7 14:44:51 hal kernel: [    6.650840] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Dec  7 14:44:51 hal kernel: [    6.739443] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
Dec  7 14:44:51 hal kernel: [    6.739447] igb 0000:02:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:25:90:1d:0b:f6
Dec  7 14:44:51 hal kernel: [    6.739526] igb 0000:02:00.0: eth0: PBA No: ffffff-0ff
Dec  7 14:44:51 hal kernel: [    6.739528] igb 0000:02:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
Dec  7 14:44:51 hal kernel: [    6.739748] igb 0000:02:00.1: power state changed by ACPI to D0
Dec  7 14:44:51 hal kernel: [    6.739827] igb 0000:02:00.1: power state changed by ACPI to D0
Dec  7 14:44:51 hal kernel: [    6.739835] igb 0000:02:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Dec  7 14:44:51 hal kernel: [    6.739848] igb 0000:02:00.1: setting latency timer to 64
Dec  7 14:44:51 hal kernel: [    6.740163]   alloc irq_desc for 50 on node 0
Dec  7 14:44:51 hal kernel: [    6.740165]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740170] igb 0000:02:00.1: irq 50 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740172]   alloc irq_desc for 51 on node 0
Dec  7 14:44:51 hal kernel: [    6.740173]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740176] igb 0000:02:00.1: irq 51 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740178]   alloc irq_desc for 52 on node 0
Dec  7 14:44:51 hal kernel: [    6.740179]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740181] igb 0000:02:00.1: irq 52 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740183]   alloc irq_desc for 53 on node 0
Dec  7 14:44:51 hal kernel: [    6.740184]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740187] igb 0000:02:00.1: irq 53 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740188]   alloc irq_desc for 54 on node 0
Dec  7 14:44:51 hal kernel: [    6.740190]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740192] igb 0000:02:00.1: irq 54 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740194]   alloc irq_desc for 55 on node 0
Dec  7 14:44:51 hal kernel: [    6.740195]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740197] igb 0000:02:00.1: irq 55 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740199]   alloc irq_desc for 56 on node 0
Dec  7 14:44:51 hal kernel: [    6.740200]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740203] igb 0000:02:00.1: irq 56 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740204]   alloc irq_desc for 57 on node 0
Dec  7 14:44:51 hal kernel: [    6.740206]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740208] igb 0000:02:00.1: irq 57 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740210]   alloc irq_desc for 58 on node 0
Dec  7 14:44:51 hal kernel: [    6.740211]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    6.740213] igb 0000:02:00.1: irq 58 for MSI/MSI-X
Dec  7 14:44:51 hal kernel: [    6.740254] igb 0000:02:00.1: 0 vfs allocated
Dec  7 14:44:51 hal kernel: [    6.930433] igb 0000:02:00.1: Intel(R) Gigabit Ethernet Network Connection
Dec  7 14:44:51 hal kernel: [    6.930436] igb 0000:02:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:25:90:1d:0b:f7
Dec  7 14:44:51 hal kernel: [    6.930515] igb 0000:02:00.1: eth1: PBA No: ffffff-0ff
Dec  7 14:44:51 hal kernel: [    6.930517] igb 0000:02:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
Dec  7 14:44:51 hal kernel: [    7.526730] hdb: DV-28S-V, ATAPI CD/DVD-ROM drive
Dec  7 14:44:51 hal kernel: [    7.526778] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Dec  7 14:44:51 hal kernel: [    7.530601] hdb: UDMA/100 mode selected
Dec  7 14:44:51 hal kernel: [    7.531627] Probing IDE interface ide1...
Dec  7 14:44:51 hal kernel: [    8.073451] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec  7 14:44:51 hal kernel: [    8.078995] ide1 at 0x170-0x177,0x376 on irq 15
Dec  7 14:44:51 hal kernel: [    8.079259] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec  7 14:44:51 hal kernel: [    8.079318] ohci_hcd 0000:00:12.0: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.079334] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
Dec  7 14:44:51 hal kernel: [    8.079374] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfeaf6000
Dec  7 14:44:51 hal kernel: [    8.134106] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Dec  7 14:44:51 hal kernel: [    8.134110] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec  7 14:44:51 hal kernel: [    8.134113] usb usb3: Product: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.134115] usb usb3: Manufacturer: Linux 2.6.36.1-3 ohci_hcd
Dec  7 14:44:51 hal kernel: [    8.134117] usb usb3: SerialNumber: 0000:00:12.0
Dec  7 14:44:51 hal kernel: [    8.134284] hub 3-0:1.0: USB hub found
Dec  7 14:44:51 hal kernel: [    8.134295] hub 3-0:1.0: 3 ports detected
Dec  7 14:44:51 hal kernel: [    8.134505] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec  7 14:44:51 hal kernel: [    8.134559] ohci_hcd 0000:00:12.1: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.134574] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
Dec  7 14:44:51 hal kernel: [    8.134598] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfeaf7000
Dec  7 14:44:51 hal kernel: [    8.190779] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Dec  7 14:44:51 hal kernel: [    8.190782] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec  7 14:44:51 hal kernel: [    8.190784] usb usb4: Product: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.190786] usb usb4: Manufacturer: Linux 2.6.36.1-3 ohci_hcd
Dec  7 14:44:51 hal kernel: [    8.190788] usb usb4: SerialNumber: 0000:00:12.1
Dec  7 14:44:51 hal kernel: [    8.190907] hub 4-0:1.0: USB hub found
Dec  7 14:44:51 hal kernel: [    8.190916] hub 4-0:1.0: 3 ports detected
Dec  7 14:44:51 hal kernel: [    8.191111]   alloc irq_desc for 18 on node 0
Dec  7 14:44:51 hal kernel: [    8.191113]   alloc kstat_irqs on node 0
Dec  7 14:44:51 hal kernel: [    8.191119] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Dec  7 14:44:51 hal kernel: [    8.191139] ohci_hcd 0000:00:13.0: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.191154] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
Dec  7 14:44:51 hal kernel: [    8.191185] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfeaf8000
Dec  7 14:44:51 hal kernel: [    8.247439] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Dec  7 14:44:51 hal kernel: [    8.247442] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec  7 14:44:51 hal kernel: [    8.247445] usb usb5: Product: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.247447] usb usb5: Manufacturer: Linux 2.6.36.1-3 ohci_hcd
Dec  7 14:44:51 hal kernel: [    8.247448] usb usb5: SerialNumber: 0000:00:13.0
Dec  7 14:44:51 hal kernel: [    8.247567] hub 5-0:1.0: USB hub found
Dec  7 14:44:51 hal kernel: [    8.247576] hub 5-0:1.0: 3 ports detected
Dec  7 14:44:51 hal kernel: [    8.247772] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Dec  7 14:44:51 hal kernel: [    8.247791] ohci_hcd 0000:00:13.1: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.247806] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
Dec  7 14:44:51 hal kernel: [    8.247830] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfeaf9000
Dec  7 14:44:51 hal kernel: [    8.304114] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Dec  7 14:44:51 hal kernel: [    8.304117] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec  7 14:44:51 hal kernel: [    8.304119] usb usb6: Product: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.304121] usb usb6: Manufacturer: Linux 2.6.36.1-3 ohci_hcd
Dec  7 14:44:51 hal kernel: [    8.304123] usb usb6: SerialNumber: 0000:00:13.1
Dec  7 14:44:51 hal kernel: [    8.304237] hub 6-0:1.0: USB hub found
Dec  7 14:44:51 hal kernel: [    8.304247] hub 6-0:1.0: 3 ports detected
Dec  7 14:44:51 hal kernel: [    8.304490] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Dec  7 14:44:51 hal kernel: [    8.304544] ohci_hcd 0000:00:14.5: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.304558] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
Dec  7 14:44:51 hal kernel: [    8.304581] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfeafb000
Dec  7 14:44:51 hal kernel: [    8.360768] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Dec  7 14:44:51 hal kernel: [    8.360772] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec  7 14:44:51 hal kernel: [    8.360774] usb usb7: Product: OHCI Host Controller
Dec  7 14:44:51 hal kernel: [    8.360776] usb usb7: Manufacturer: Linux 2.6.36.1-3 ohci_hcd
Dec  7 14:44:51 hal kernel: [    8.360778] usb usb7: SerialNumber: 0000:00:14.5
Dec  7 14:44:51 hal kernel: [    8.360894] hub 7-0:1.0: USB hub found
Dec  7 14:44:51 hal kernel: [    8.360904] hub 7-0:1.0: 2 ports detected
Dec  7 14:44:51 hal kernel: [    8.382726] ide-cd driver 5.00
Dec  7 14:44:51 hal kernel: [    8.391222] ide-cd: hdb: ATAPI 24X DVD-ROM drive, 198kB Cache
Dec  7 14:44:51 hal kernel: [    8.391228] cdrom: Uniform CD-ROM driver Revision: 3.20
Dec  7 14:44:51 hal kernel: [    8.576728] usb 5-3: new full speed USB device using ohci_hcd and address 2
Dec  7 14:44:51 hal kernel: [    8.734472] usb 5-3: New USB device found, idVendor=0557, idProduct=2221
Dec  7 14:44:51 hal kernel: [    8.734475] usb 5-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Dec  7 14:44:51 hal kernel: [    8.734478] usb 5-3: Product: Hermon USB hidmouse Device
Dec  7 14:44:51 hal kernel: [    8.734480] usb 5-3: Manufacturer: Winbond Electronics Corp
Dec  7 14:44:51 hal kernel: [    8.761971] usbcore: registered new interface driver hiddev
Dec  7 14:44:51 hal kernel: [    8.764686] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:13.0/usb5/5-3/5-3:1.0/input/input4
Dec  7 14:44:51 hal kernel: [    8.764821] generic-usb 0003:0557:2221.0001: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:13.0-3/input0
Dec  7 14:44:51 hal kernel: [    8.768660] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:13.0/usb5/5-3/5-3:1.1/input/input5
Dec  7 14:44:51 hal kernel: [    8.768766] generic-usb 0003:0557:2221.0002: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:13.0-3/input1
Dec  7 14:44:51 hal kernel: [    8.768785] usbcore: registered new interface driver usbhid
Dec  7 14:44:51 hal kernel: [    8.768788] usbhid: USB HID core driver
Dec  7 14:44:51 hal kernel: [    8.852984] Adding 32001476k swap on /dev/sda2.  Priority:0 extents:1 across:32001476k 
Dec  7 14:44:51 hal kernel: [    8.861300] Adding 32001476k swap on /dev/sdb2.  Priority:0 extents:1 across:32001476k 
Dec  7 14:44:51 hal kernel: [    8.869384] Adding 32001476k swap on /dev/sdc2.  Priority:0 extents:1 across:32001476k 
Dec  7 14:44:51 hal kernel: [    8.877328] Adding 32001476k swap on /dev/sdd2.  Priority:0 extents:1 across:32001476k 
Dec  7 14:44:51 hal kernel: [    9.064835] EXT3-fs (md0): using internal journal
Dec  7 14:44:51 hal kernel: [    9.249553] aoe: AoE v47 initialised.
Dec  7 14:44:51 hal kernel: [    9.315218] uvesafb: Matrox, MGA-G200, 00, OEM: Matrox Graphics Inc., VBE v3.0
Dec  7 14:44:51 hal kernel: [   10.169609] uvesafb: VBIOS/hardware supports DDC2 transfers
Dec  7 14:44:51 hal kernel: [   11.019855] uvesafb: monitor limits: vf = 160 Hz, hf = 98 kHz, clk = 230 MHz
Dec  7 14:44:51 hal kernel: [   11.019978] uvesafb: scrolling: redraw
Dec  7 14:44:51 hal kernel: [   12.337257] Console: switching to colour frame buffer device 160x64
Dec  7 14:44:51 hal kernel: [   12.373226] uvesafb: framebuffer at 0xfc000000, mapped to 0xffffc90019000000, using 10240k, total 16384k
Dec  7 14:44:51 hal kernel: [   12.373228] fb0: VESA VGA frame buffer device
Dec  7 14:44:51 hal kernel: [   12.548523] device-mapper: uevent: version 1.0.3
Dec  7 14:44:51 hal kernel: [   12.549177] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
Dec  7 14:44:51 hal kernel: [   13.084182] md: md1 stopped.
Dec  7 14:44:51 hal kernel: [   13.100590] md: bind<sdb3>
Dec  7 14:44:51 hal kernel: [   13.100771] md: bind<sdc3>
Dec  7 14:44:51 hal kernel: [   13.100979] md: bind<sdd3>
Dec  7 14:44:51 hal kernel: [   13.101176] md: bind<sda3>
Dec  7 14:44:51 hal kernel: [   13.113028] md: raid0 personality registered for level 0
Dec  7 14:44:51 hal kernel: [   13.113158] md/raid0:md1: looking at sda3
Dec  7 14:44:51 hal kernel: [   13.113161] md/raid0:md1:   comparing sda3(1023996928) with sda3(1023996928)
Dec  7 14:44:51 hal kernel: [   13.113165] md/raid0:md1:   END
Dec  7 14:44:51 hal kernel: [   13.113166] md/raid0:md1:   ==> UNIQUE
Dec  7 14:44:51 hal kernel: [   13.113168] md/raid0:md1: 1 zones
Dec  7 14:44:51 hal kernel: [   13.113169] md/raid0:md1: looking at sdd3
Dec  7 14:44:51 hal kernel: [   13.113171] md/raid0:md1:   comparing sdd3(1023996928) with sda3(1023996928)
Dec  7 14:44:51 hal kernel: [   13.113173] md/raid0:md1:   EQUAL
Dec  7 14:44:51 hal kernel: [   13.113175] md/raid0:md1: looking at sdc3
Dec  7 14:44:51 hal kernel: [   13.113177] md/raid0:md1:   comparing sdc3(1023996928) with sda3(1023996928)
Dec  7 14:44:51 hal kernel: [   13.113179] md/raid0:md1:   EQUAL
Dec  7 14:44:51 hal kernel: [   13.113180] md/raid0:md1: looking at sdb3
Dec  7 14:44:51 hal kernel: [   13.113182] md/raid0:md1:   comparing sdb3(1023996928) with sda3(1023996928)
Dec  7 14:44:51 hal kernel: [   13.113184] md/raid0:md1:   EQUAL
Dec  7 14:44:51 hal kernel: [   13.113186] md/raid0:md1: FINAL 1 zones
Dec  7 14:44:51 hal kernel: [   13.113190] md/raid0:md1: done.
Dec  7 14:44:51 hal kernel: [   13.113192] md/raid0:md1: md_size is 4095987712 sectors.
Dec  7 14:44:51 hal kernel: [   13.113194] ******* md1 configuration *********
Dec  7 14:44:51 hal kernel: [   13.113196] zone0=[sda3/sdb3/sdc3/sdd3/]
Dec  7 14:44:51 hal kernel: [   13.113200]         zone offset=0kb device offset=0kb size=2047993856kb
Dec  7 14:44:51 hal kernel: [   13.113201] **********************************
Dec  7 14:44:51 hal kernel: [   13.113202] 
Dec  7 14:44:51 hal kernel: [   13.113212] md1: detected capacity change from 0 to 2097145708544
Dec  7 14:44:51 hal kernel: [   13.122110] md: md2 stopped.
Dec  7 14:44:51 hal kernel: [   13.123222] md: bind<sdb4>
Dec  7 14:44:51 hal kernel: [   13.123608] md: bind<sdc4>
Dec  7 14:44:51 hal kernel: [   13.123881] md: bind<sdd4>
Dec  7 14:44:51 hal kernel: [   13.124192] md: bind<sda4>
Dec  7 14:44:51 hal kernel: [   13.133655] md: raid10 personality registered for level 10
Dec  7 14:44:51 hal kernel: [   13.134318] md/raid10:md2: active with 4 out of 4 devices
Dec  7 14:44:51 hal kernel: [   13.134350] md2: detected capacity change from 0 to 869902843904
Dec  7 14:44:51 hal kernel: [   13.154594] md1: detected capacity change from 0 to 2097145708544
Dec  7 14:44:51 hal kernel: [   13.165211]  md1: unknown partition table
Dec  7 14:44:51 hal kernel: [   13.182754] md2: detected capacity change from 0 to 869902843904
Dec  7 14:44:51 hal kernel: [   13.198364]  md2: unknown partition table
Dec  7 14:44:51 hal kernel: [   13.922782] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
Dec  7 14:44:51 hal kernel: [   14.058428] EXT4-fs (md2): mounted filesystem with ordered data mode. Opts: (null)
Dec  7 14:44:51 hal kernel: [   14.732631] ip6_tables: (C) 2000-2006 Netfilter Core Team
Dec  7 14:44:51 hal kernel: [   14.808064] ip_tables: (C) 2000-2006 Netfilter Core Team
Dec  7 14:44:51 hal kernel: [   14.887486] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Dec  7 14:44:51 hal kernel: [   15.128010] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Dec  7 14:44:51 hal kernel: [   15.636269] ADDRCONF(NETDEV_UP): eth1: link is not ready
Dec  7 14:44:51 hal kernel: [   16.409179] RPC: Registered udp transport module.
Dec  7 14:44:51 hal kernel: [   16.409183] RPC: Registered tcp transport module.
Dec  7 14:44:51 hal kernel: [   16.409185] RPC: Registered tcp NFSv4.1 backchannel transport module.
Dec  7 14:44:51 hal kernel: [   16.444459] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Dec  7 14:44:51 hal kernel: [   16.863381] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Dec  7 14:44:51 hal kernel: [   16.869651] NFSD: starting 90-second grace period
Dec  7 14:44:51 hal kernel: [   17.407900] sshd (3241): /proc/3241/oom_adj is deprecated, please use /proc/3241/oom_score_adj instead.
Dec  7 14:44:51 hal kernel: [   17.737206] igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Dec  7 14:44:51 hal kernel: [   17.739667] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
Dec  7 13:45:08 hal kernel: [   25.443395] eth0: no IPv6 routers present
Dec  7 13:45:11 hal kernel: [   28.590079] eth1: no IPv6 routers present
Dec  7 13:45:23 hal kernel: [   40.966157] FS-Cache: Loaded
Dec  7 13:45:23 hal kernel: [   40.983919] FS-Cache: Netfs 'nfs' registered for caching

--Boundary-00=_3en/MtKHmTuU1fP--
