Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1AMRdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:33:33 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53712 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1AMRd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:33:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qs5XF1SRZss82RAAerAlacN1t+4BSqOt2Jq2J4aHxC2VpxVFoQymddcxKWRd7TUXQg
         jEpP0o9QGMdoyKqP3e/S3gdzFNvzvQzYC2DZ5oUchFTW8U9D/rqg6SIPnr/SHnzT7I8k
         JJuSoXXubuLK7sTXGt9112C87kQhWGVJtzHTw=
MIME-Version: 1.0
In-Reply-To: <20110113172205.GA30866@kryptos.osrc.amd.com>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
	<1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
	<20110113164616.GB21289@srcf.ucam.org>
	<alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
	<20110113172205.GA30866@kryptos.osrc.amd.com>
Date: Thu, 13 Jan 2011 11:33:27 -0600
X-Google-Sender-Auth: 6dVQgJW0mpuy-_-eTV_3zu5VhDQ
Message-ID: <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav,

Please see below lspci and dmesg output from AMD based ThinkPad Edge 11.

lspci
=====
00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] RS780 Host
Bridge Alternate [1022:9601]
	Subsystem: Lenovo Device [17aa:21ca]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to
PCI bridge (int gfx) [1022:9602] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: d0400000-d05fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] RS780 PCI
to PCI bridge (int gfx) [1022:9602]
	Kernel modules: shpchp

00:04.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to
PCI bridge (PCIE port 0) [1022:9604] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=07, sec-latency=0
	I/O behind bridge: 0000a000-0000bfff
	Memory behind bridge: 80000000-800fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+


dmesg
=======
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-24-generic-pae (buildd@platinum)
(gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) )
#42sutton03-Ubuntu SMP Thu Dec 16 03:27:29 UTC 2010 (Ubuntu
2.6.35-24.42sutton03-generic-pae 2.6.35.8)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000006fe8e000 (usable)
[    0.000000]  BIOS-e820: 000000006fe8e000 - 000000006fea0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000006fea0000 - 000000006feb1000 (ACPI data)
[    0.000000]  BIOS-e820: 000000006feb1000 - 000000006feb3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000006feb3000 - 000000006feff000 (reserved)
[    0.000000]  BIOS-e820: 000000006ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x6fe8e max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFFC0000000 write-back
[    0.000000]   1 base 000040000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 000060000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000002000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (reserved)
[    0.000000]  modified: 0000000000001000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000006fe8e000 (usable)
[    0.000000]  modified: 000000006fe8e000 - 000000006fea0000 (ACPI NVS)
[    0.000000]  modified: 000000006fea0000 - 000000006feb1000 (ACPI data)
[    0.000000]  modified: 000000006feb1000 - 000000006feb3000 (ACPI NVS)
[    0.000000]  modified: 000000006feb3000 - 000000006feff000 (reserved)
[    0.000000]  modified: 000000006ff00000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00e00000
[    0.000000] found SMP MP-table at [c00f7970] f7970
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 15000-1a000
[    0.000000] RAMDISK: 370bf000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00a05000 - 01935f93
[    0.000000] Move RAMDISK from 00000000370bf000 - 0000000037feff92
to 00a05000 - 01935f92
[    0.000000] ACPI: RSDP 000f78c0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 6fea234c 00084 (v01 LENOVO TP-87    00001080
 LTP 00000000)
[    0.000000] ACPI: FACP 6feb0083 000F4 (v03 LENOVO TP-87    00001080
AMD  000F4240)
[    0.000000] ACPI: DSDT 6fea23d0 0DCB3 (v01 LENOVO TP-87    00001080
MSFT 03000001)
[    0.000000] ACPI: FACS 6feb2fc0 00040
[    0.000000] ACPI: TCPA 6feb01eb 00032 (v02 LENOVO TP-87    00001080
PTEC 00000000)
[    0.000000] ACPI: EINJ 6feb021d 001B0 (v01 LENOVO TP-87    00001080
PTL  00000001)
[    0.000000] ACPI: HEST 6feb03cd 002E4 (v01 LENOVO TP-87    00001080
PTL  00000001)
[    0.000000] ACPI: BERT 6feb06b1 00030 (v01 LENOVO TP-87    00001080
PTL  00000001)
[    0.000000] ACPI: SSDT 6feb06e1 000E1 (v01 LENOVO TP-87    00001080
INTL 20050624)
[    0.000000] ACPI: ERST 6feb07c2 00270 (v01 LENOVO TP-87    00001080
PTL  00000001)
[    0.000000] ACPI: SSDT 6feb0a32 00386 (v01 LENOVO TP-87    00001080
AMD  00000001)
[    0.000000] ACPI: APIC 6feb0db8 0005E (v01 LENOVO TP-87    00001080
 LTP 00000000)
[    0.000000] ACPI: MCFG 6feb0e16 0003C (v01 LENOVO TP-87    00001080
 LTP 00000000)
[    0.000000] ACPI: HPET 6feb0e52 00038 (v01 LENOVO TP-87    00001080
 LTP 00000001)
[    0.000000] ACPI: SLIC 6feb0e8a 00176 (v01 LENOVO TP-87    00001080
 LTP 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 898MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0006fe8e
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0006fe8e
[    0.000000] On node 0 totalpages: 458268
[    0.000000] free_area_init_node: node 0, pgdat c0840a00,
node_mem_map c1937020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1798 pages used for memmap
[    0.000000]   HighMem zone: 228234 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [16000 - 167ff]
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
80000000:7ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages/cpu @c2800000 s39872 r0 d21568 u1048576
[    0.000000] pcpu-alloc: s39872 r0 d21568 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 454686
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic-pae
root=UUID=92ad553f-5b69-41ed-a84b-04cbe048efbd ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 9167620 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Subtract (52 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 00009fc65c]   TEXT DATA BSS
[    0.000000]   #3 [00009fd000 - 0000a04130]             BRK
[    0.000000]   #4 [00000f7980 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f7970 - 00000f7980]    MP-table mpf
[    0.000000]   #6 [000009dc00 - 000009e071]   BIOS reserved
[    0.000000]   #7 [000009e1bd - 00000f7970]   BIOS reserved
[    0.000000]   #8 [000009e071 - 000009e1bd]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #10 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #11 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #12 [0000a05000 - 0001936000]     NEW RAMDISK
[    0.000000]   #13 [0001936000 - 0001937000]         BOOTMEM
[    0.000000]   #14 [0001937000 - 0002737000]         BOOTMEM
[    0.000000]   #15 [0002737000 - 0002737004]         BOOTMEM
[    0.000000]   #16 [0002737040 - 0002737100]         BOOTMEM
[    0.000000]   #17 [0002737100 - 00027371a8]         BOOTMEM
[    0.000000]   #18 [00027371c0 - 000273a1c0]         BOOTMEM
[    0.000000]   #19 [000273a1c0 - 000273a26c]         BOOTMEM
[    0.000000]   #20 [000273a280 - 000273d280]         BOOTMEM
[    0.000000]   #21 [000273d280 - 000273d2ad]         BOOTMEM
[    0.000000]   #22 [000273d2c0 - 000273d2ef]         BOOTMEM
[    0.000000]   #23 [000273d300 - 000273d51c]         BOOTMEM
[    0.000000]   #24 [000273d540 - 000273d580]         BOOTMEM
[    0.000000]   #25 [000273d580 - 000273d5c0]         BOOTMEM
[    0.000000]   #26 [000273d5c0 - 000273d600]         BOOTMEM
[    0.000000]   #27 [000273d600 - 000273d640]         BOOTMEM
[    0.000000]   #28 [000273d640 - 000273d680]         BOOTMEM
[    0.000000]   #29 [000273d680 - 000273d6c0]         BOOTMEM
[    0.000000]   #30 [000273d6c0 - 000273d700]         BOOTMEM
[    0.000000]   #31 [000273d700 - 000273d740]         BOOTMEM
[    0.000000]   #32 [000273d740 - 000273d780]         BOOTMEM
[    0.000000]   #33 [000273d780 - 000273d7c0]         BOOTMEM
[    0.000000]   #34 [000273d7c0 - 000273d800]         BOOTMEM
[    0.000000]   #35 [000273d800 - 000273d840]         BOOTMEM
[    0.000000]   #36 [000273d840 - 000273d850]         BOOTMEM
[    0.000000]   #37 [000273d880 - 000273d890]         BOOTMEM
[    0.000000]   #38 [000273d8c0 - 000273d92e]         BOOTMEM
[    0.000000]   #39 [000273d940 - 000273d9ae]         BOOTMEM
[    0.000000]   #40 [0002800000 - 000280f000]         BOOTMEM
[    0.000000]   #41 [0002900000 - 000290f000]         BOOTMEM
[    0.000000]   #42 [000273f9c0 - 000273f9c4]         BOOTMEM
[    0.000000]   #43 [000273fa00 - 000273fa04]         BOOTMEM
[    0.000000]   #44 [000273fa40 - 000273fa48]         BOOTMEM
[    0.000000]   #45 [000273fa80 - 000273fa88]         BOOTMEM
[    0.000000]   #46 [000273fac0 - 000273fb60]         BOOTMEM
[    0.000000]   #47 [000273fb80 - 000273fbc8]         BOOTMEM
[    0.000000]   #48 [000273fc00 - 0002743c00]         BOOTMEM
[    0.000000]   #49 [0002743c00 - 00027c3c00]         BOOTMEM
[    0.000000]   #50 [000280f000 - 000284f000]         BOOTMEM
[    0.000000]   #51 [000290f000 - 00031cd304]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (00037bfe:0006fe8e)
[    0.000000] Memory: 1784020k/1833528k available (5088k kernel code,
49052k reserved, 2437k data, 704k init, 920128k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc085a000 - 0xc090a000   ( 704 kB)
[    0.000000]       .data : 0xc05f80da - 0xc0859648   (2437 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05f80da   (5088 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1296.592 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated
using timer frequency.. 2593.18 BogoMIPS (lpj=5186368)
[    0.004014] pid_max: default: 32768 minimum: 301
[    0.004038] Security Framework initialized
[    0.004060] AppArmor: AppArmor initialized
[    0.004063] Yama: becoming mindful.
[    0.004135] Mount-cache hash table entries: 512
[    0.004285] Initializing cgroup subsys ns
[    0.004290] Initializing cgroup subsys cpuacct
[    0.004296] Initializing cgroup subsys memory
[    0.004307] Initializing cgroup subsys devices
[    0.004311] Initializing cgroup subsys freezer
[    0.004314] Initializing cgroup subsys net_cls
[    0.004345] CPU: Physical Processor ID: 0
[    0.004348] CPU: Processor Core ID: 0
[    0.004352] mce: CPU supports 6 MCE banks
[    0.004366] using C1E aware idle routine
[    0.004375] Performance Events: AMD PMU driver.
[    0.004381] ... version:                0
[    0.004384] ... bit width:              48
[    0.004386] ... generic registers:      4
[    0.004389] ... value mask:             0000ffffffffffff
[    0.004392] ... max period:             00007fffffffffff
[    0.004395] ... fixed-purpose events:   0
[    0.004398] ... event mask:             000000000000000f
[    0.011320] ACPI: Core revision 20100428
[    0.032031] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.032044] ftrace: allocating 22392 entries in 44 pages
[    0.036105] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.036459] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.078719] CPU0: AMD Athlon(tm) II Neo K325 Dual-Core Processor stepping 03
[    0.080000] Booting Node   0, Processors  #1 Ok.
[    0.008000] Initializing CPU#1
[    0.168013] Brought up 2 CPUs
[    0.168018] Total of 2 processors activated (5186.73 BogoMIPS).
[    0.168030] System has AMD C1E enabled
[    0.168051] Switch to broadcast mode on CPU1
[    0.168408] Switch to broadcast mode on CPU0
[    0.168408] devtmpfs: initialized
[    0.169521] regulator: core version 0.5
[    0.169586] Time:  3:11:58  Date: 01/07/11
[    0.169644] NET: Registered protocol family 16
[    0.169706] Trying to unpack rootfs image as initramfs...
[    0.169819] EISA bus registered
[    0.169827] node 0 link 0: io port [1000, ffff]
[    0.169833] TOM: 0000000080000000 aka 2048M
[    0.169836] Fam 10h mmconf [e0000000, efffffff]
[    0.169840] node 0 link 0: mmio [80000000, bfffffff]
[    0.169845] node 0 link 0: mmio [c0000000, cfffffff]
[    0.169850] node 0 link 0: mmio [d0000000, d03fffff]
[    0.169854] node 0 link 0: mmio [d0400000, d05fffff]
[    0.169859] node 0 link 0: mmio [d0600000, dfffffff]
[    0.169863] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.169868] node 0 link 0: mmio [f0000000, febfffff]
[    0.169873] node 0 link 0: mmio [fec00000, ffffffff]
[    0.169877] bus: [00, 1f] on node 0 link 0
[    0.169882] bus: 00 index 0 [io  0x0000-0xffff]
[    0.169886] bus: 00 index 1 [mem 0x80000000-0xdfffffff]
[    0.169890] bus: 00 index 2 [mem 0xf0000000-0xfcffffffff]
[    0.169903] ACPI: bus type pci registered
[    0.170036] PCI: MMCONFIG for domain 0000 [bus 00-08] at [mem
0xe0000000-0xe08fffff] (base 0xe0000000)
[    0.170040] PCI: not using MMCONFIG
[    0.170395] PCI: PCI BIOS revision 2.10 entry at 0xfdc8a, last bus=9
[    0.170398] PCI: Using configuration type 1 for base access
[    0.170400] PCI: Using configuration type 1 for extended access
[    0.170426] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.170428] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.170431] mtrr: probably your BIOS does not setup all CPUs.
[    0.170433] mtrr: corrected configuration.
[    0.176221] bio: create slab <bio-0> at 0
[    0.179314] ACPI: EC: Look up EC in DSDT
[    0.179725] \_SB_:_OSC evaluation returned wrong type
[    0.179728] _OSC request data:1 7
[    0.188000] ACPI: BIOS _OSI(Linux) query ignored
[    0.188000] ACPI: OEMN 6feb1ab3 00131 (v01 AMD    NAHP     00000001
MSFT 03000001)
[    0.188000] ACPI: Enabled 1 new runtime GPEs, added 0 new wakeup GPEs
[    0.188000] ACPI: Dynamic OEM Table Load:
[    0.188000] ACPI: OEMN (null) 00131 (v01 AMD    NAHP     00000001
MSFT 03000001)
[    0.192266] ACPI: Interpreter enabled
[    0.192275] ACPI: (supports S0 S3 S4 S5)
[    0.192310] ACPI: Using IOAPIC for interrupt routing
[    0.192914] PCI: MMCONFIG for domain 0000 [bus 00-08] at [mem
0xe0000000-0xe08fffff] (base 0xe0000000)
[    0.193347] [Firmware Bug]: PCI: MMCONFIG at [mem
0xe0000000-0xe08fffff] not reserved in ACPI motherboard resources
[    0.193347] PCI: not using MMCONFIG
[    0.193347] [Firmware Bug]: ACPI: ACPI brightness control misses
_BQC function
[    0.193462] [Firmware Bug]: ACPI: ACPI brightness control misses
_BQC function
[    0.200143] [Firmware Bug]: ACPI: ACPI brightness control misses
_BQC function
[    0.211970] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.211970] ACPI: No dock devices found.
[    0.211970] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.211970] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.215620] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.215627] pci_root PNP0A08:00: host bridge window [mem
0x80000000-0xdfffffff]
[    0.215631] pci_root PNP0A08:00: host bridge window [mem
0xf0000000-0xffffffff]
[    0.215636] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.215640] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.215840] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.215844] pci 0000:00:04.0: PME# disabled
[    0.215902] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.215906] pci 0000:00:05.0: PME# disabled
[    0.216018] pci 0000:00:11.0: reg 10: [io  0x8440-0x8447]
[    0.216027] pci 0000:00:11.0: reg 14: [io  0x8430-0x8433]
[    0.216036] pci 0000:00:11.0: reg 18: [io  0x8420-0x8427]
[    0.216045] pci 0000:00:11.0: reg 1c: [io  0x8410-0x8413]
[    0.216053] pci 0000:00:11.0: reg 20: [io  0x8400-0x840f]
[    0.216063] pci 0000:00:11.0: reg 24: [mem 0xd0906800-0xd0906bff]
[    0.216136] pci 0000:00:12.0: reg 10: [mem 0xd0904000-0xd0904fff]
[    0.216214] pci 0000:00:12.2: reg 10: [mem 0xd0906000-0xd09060ff]
[    0.216273] pci 0000:00:12.2: supports D1 D2
[    0.216276] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.216282] pci 0000:00:12.2: PME# disabled
[    0.216318] pci 0000:00:13.0: reg 10: [mem 0xd0905000-0xd0905fff]
[    0.216396] pci 0000:00:13.2: reg 10: [mem 0xd0906400-0xd09064ff]
[    0.216456] pci 0000:00:13.2: supports D1 D2
[    0.216459] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.216465] pci 0000:00:13.2: PME# disabled
[    0.216573] pci 0000:00:14.2: reg 10: [mem 0xd0900000-0xd0903fff 64bit]
[    0.216623] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.216629] pci 0000:00:14.2: PME# disabled
[    0.216908] pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.216914] pci 0000:01:05.0: reg 14: [io  0x9000-0x90ff]
[    0.216921] pci 0000:01:05.0: reg 18: [mem 0xd0500000-0xd050ffff]
[    0.216932] pci 0000:01:05.0: reg 24: [mem 0xd0400000-0xd04fffff]
[    0.216952] pci 0000:01:05.0: supports D1 D2
[    0.216976] pci 0000:01:05.1: reg 10: [mem 0xd0510000-0xd0513fff]
[    0.217008] pci 0000:01:05.1: supports D1 D2
[    0.217060] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.217066] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.217072] pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
[    0.217078] pci 0000:00:01.0:   bridge window [mem
0xc0000000-0xcfffffff 64bit pref]
[    0.217144] pci 0000:02:00.0: reg 10: [io  0xbc00-0xbcff]
[    0.217164] pci 0000:02:00.0: reg 18: [mem 0xd0200000-0xd0200fff 64bit pref]
[    0.217179] pci 0000:02:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.217188] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.217226] pci 0000:02:00.0: supports D1 D2
[    0.217229] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.217235] pci 0000:02:00.0: PME# disabled
[    0.224044] pci 0000:00:04.0: PCI bridge to [bus 02-07]
[    0.224055] pci 0000:00:04.0:   bridge window [io  0xa000-0xbfff]
[    0.224061] pci 0000:00:04.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.224069] pci 0000:00:04.0:   bridge window [mem
0xd0000000-0xd03fffff 64bit pref]
[    0.224150] pci 0000:08:00.0: reg 10: [io  0xc000-0xc0ff]
[    0.224174] pci 0000:08:00.0: reg 18: [mem 0xd0600000-0xd0603fff 64bit]
[    0.224236] pci 0000:08:00.0: supports D1 D2
[    0.224239] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.224247] pci 0000:08:00.0: PME# disabled
[    0.232044] pci 0000:00:05.0: PCI bridge to [bus 08-08]
[    0.232054] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.232060] pci 0000:00:05.0:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.232066] pci 0000:00:05.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.232150] pci 0000:00:14.4: PCI bridge to [bus 09-09] (subtractive decode)
[    0.232156] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.232163] pci 0000:00:14.4:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.232169] pci 0000:00:14.4:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.232174] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.232179] pci 0000:00:14.4:   bridge window [mem
0x80000000-0xdfffffff] (subtractive decode)
[    0.232183] pci 0000:00:14.4:   bridge window [mem
0xf0000000-0xffffffff] (subtractive decode)
[    0.232187] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.232192] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.232211] pci_bus 0000:00: on NUMA node 0
[    0.232223] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.232605] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
[    0.232734] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    0.232929] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.233082] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.240060] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
[    0.240402] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
[    0.240726] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
[    0.241081] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
[    0.241400] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
[    0.241619] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
[    0.241844] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
[    0.242070] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
[    0.242253] HEST: HEST table parsing is initialized.
[    0.242372] vgaarb: device added:
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.242378] vgaarb: loaded
[    0.242577] SCSI subsystem initialized
[    0.244000] libata version 3.00 loaded.
[    0.244000] usbcore: registered new interface driver usbfs
[    0.244000] usbcore: registered new interface driver hub
[    0.244000] usbcore: registered new device driver usb
[    0.244000] ACPI: WMI: Mapper loaded
[    0.244000] PCI: Using ACPI for IRQ routing
[    0.244000] PCI: pci_cache_line_size set to 64 bytes
[    0.244000] reserve RAM buffer: 0000000000002000 - 000000000000ffff
[    0.244000] reserve RAM buffer: 000000000009dc00 - 000000000009ffff
[    0.244000] reserve RAM buffer: 000000006fe8e000 - 000000006fffffff
[    0.244000] NetLabel: Initializing
[    0.244000] NetLabel:  domain hash size = 128
[    0.244000] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.244000] NetLabel:  unlabeled traffic allowed by default
[    0.244000] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.244000] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.245044] Switching to clocksource tsc
[    0.260247] AppArmor: AppArmor Filesystem Enabled
[    0.260269] pnp: PnP ACPI init
[    0.260294] ACPI: bus type pnp registered
[    0.267443] pnp: PnP ACPI: found 10 devices
[    0.267449] ACPI: ACPI bus type pnp unregistered
[    0.267454] PnPBIOS: Disabled by ACPI PNP
[    0.267483] system 00:01: [io  0x0f50-0x0f51] has been reserved
[    0.267490] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.267495] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.267510] system 00:08: [io  0x0220-0x022f] has been reserved
[    0.267515] system 00:08: [io  0x040b] has been reserved
[    0.267519] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.267523] system 00:08: [io  0x04d6] has been reserved
[    0.267527] system 00:08: [io  0x0530-0x0537] has been reserved
[    0.267532] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.267536] system 00:08: [io  0x0c14] has been reserved
[    0.267540] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    0.267544] system 00:08: [io  0x0c6c] has been reserved
[    0.267547] system 00:08: [io  0x0c6f] has been reserved
[    0.267551] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    0.267556] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    0.267560] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    0.267564] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    0.267568] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    0.267573] system 00:08: [io  0x8000-0x805f] has been reserved
[    0.267577] system 00:08: [io  0x8100-0x81ff window] has been reserved
[    0.267582] system 00:08: [io  0x8200-0x82ff window] has been reserved
[    0.267586] system 00:08: [io  0x0f40-0x0f47] has been reserved
[    0.267590] system 00:08: [io  0x087f] has been reserved
[    0.267600] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.267605] system 00:09: [mem 0xffe00000-0xffffffff] could not be reserved
[    0.267610] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.267614] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.267619] system 00:09: [mem 0xfed61000-0xfed613ff] has been reserved
[    0.267624] system 00:09: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.267629] system 00:09: [mem 0xfffffd00-0x10001fcff] could not be reserved
[    0.304254] pci 0000:00:04.0: BAR 14: assigned [mem 0x80000000-0x800fffff]
[    0.304260] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.304265] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.304271] pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd05fffff]
[    0.304276] pci 0000:00:01.0:   bridge window [mem
0xc0000000-0xcfffffff 64bit pref]
[    0.304284] pci 0000:02:00.0: BAR 6: assigned [mem
0xd0020000-0xd003ffff pref]
[    0.304289] pci 0000:00:04.0: PCI bridge to [bus 02-07]
[    0.304293] pci 0000:00:04.0:   bridge window [io  0xa000-0xbfff]
[    0.304298] pci 0000:00:04.0:   bridge window [mem 0x80000000-0x800fffff]
[    0.304304] pci 0000:00:04.0:   bridge window [mem
0xd0000000-0xd03fffff 64bit pref]
[    0.304310] pci 0000:00:05.0: PCI bridge to [bus 08-08]
[    0.304315] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.304320] pci 0000:00:05.0:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.304324] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    0.304331] pci 0000:00:14.4: PCI bridge to [bus 09-09]
[    0.304334] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.304340] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.304346] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.304368]   alloc irq_desc for 16 on node -1
[    0.304371]   alloc kstat_irqs on node -1
[    0.304381] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.304386] pci 0000:00:04.0: setting latency timer to 64
[    0.304394]   alloc irq_desc for 17 on node -1
[    0.304397]   alloc kstat_irqs on node -1
[    0.304403] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.304408] pci 0000:00:05.0: setting latency timer to 64
[    0.304419] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    0.304423] pci_bus 0000:00: resource 5 [mem 0x80000000-0xdfffffff]
[    0.304427] pci_bus 0000:00: resource 6 [mem 0xf0000000-0xffffffff]
[    0.304431] pci_bus 0000:00: resource 7 [io  0x0000-0x0cf7]
[    0.304434] pci_bus 0000:00: resource 8 [io  0x0d00-0xffff]
[    0.304438] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
[    0.304442] pci_bus 0000:01: resource 1 [mem 0xd0400000-0xd05fffff]
[    0.304446] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff
64bit pref]
[    0.304451] pci_bus 0000:02: resource 0 [io  0xa000-0xbfff]
[    0.304455] pci_bus 0000:02: resource 1 [mem 0x80000000-0x800fffff]
[    0.304459] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd03fffff
64bit pref]
[    0.304463] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.304466] pci_bus 0000:08: resource 1 [mem 0xd0600000-0xd06fffff]
[    0.304471] pci_bus 0000:09: resource 4 [mem 0x000a0000-0x000bffff]
[    0.304475] pci_bus 0000:09: resource 5 [mem 0x80000000-0xdfffffff]
[    0.304479] pci_bus 0000:09: resource 6 [mem 0xf0000000-0xffffffff]
[    0.304485] pci_bus 0000:09: resource 7 [io  0x0000-0x0cf7]
[    0.304489] pci_bus 0000:09: resource 8 [io  0x0d00-0xffff]
[    0.304538] NET: Registered protocol family 2
[    0.304621] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.304935] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.305756] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.306221] TCP: Hash tables configured (established 131072 bind 65536)
[    0.306225] TCP reno registered
[    0.306230] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.306245] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.306366] NET: Registered protocol family 1
[    0.306387] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.341965] pci 0000:01:05.0: Boot video device
[    0.341983] PCI: CLS 32 bytes, default 64
[    0.342278] cpufreq-nforce2: No nForce2 chipset.
[    0.342315] Scanning for low memory corruption every 60 seconds
[    0.342492] audit: initializing netlink socket (disabled)
[    0.342508] type=2000 audit(1294369916.340:1): initialized
[    0.358258] highmem bounce pool size: 64 pages
[    0.358264] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.360125] VFS: Disk quotas dquot_6.5.2
[    0.360207] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.360990] fuse init (API version 7.14)
[    0.361108] msgmni has been set to 1687
[    0.361561] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.361566] io scheduler noop registered
[    0.361569] io scheduler deadline registered
[    0.361589] io scheduler cfq registered (default)
[    0.361734] pcieport 0000:00:04.0: setting latency timer to 64
[    0.361768]   alloc irq_desc for 40 on node -1
[    0.361771]   alloc kstat_irqs on node -1
[    0.361782] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    0.361870] pcieport 0000:00:05.0: setting latency timer to 64
[    0.361900]   alloc irq_desc for 41 on node -1
[    0.361902]   alloc kstat_irqs on node -1
[    0.361909] pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
[    0.362013] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.362041] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.363676] ACPI: AC Adapter [ACAD] (on-line)
[    0.363770] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.363777] ACPI: Power Button [PWRB]
[    0.363859] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.364372] ACPI: Lid Switch [LID]
[    0.364465] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.364472] ACPI: Power Button [PWRF]
[    0.364792] ACPI: acpi_idle registered with cpuidle
[    0.364829] ACPI: processor limited to max C-state 1
[    0.370190] thermal LNXTHERM:01: registered as thermal_zone0
[    0.370206] ACPI: Thermal Zone [TZ00] (41 C)
[    0.370412] [Firmware Bug]: ERST: ERST table is invalid
[    0.370642] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.372489] brd: module loaded
[    0.373169] loop: module loaded
[    0.373831] Fixed MDIO Bus: probed
[    0.373891] PPP generic driver version 2.4.2
[    0.373934] tun: Universal TUN/TAP device driver, 1.6
[    0.373936] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.374041] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.374106] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.374131] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.374173] ehci_hcd 0000:00:12.2: new USB bus registered, assigned
bus number 1
[    0.374215] ehci_hcd 0000:00:12.2: debug port 1
[    0.374245] ehci_hcd 0000:00:12.2: irq 17, io mem 0xd0906000
[    0.374371] isapnp: Scanning for PnP cards...
[    0.428833] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.429010] hub 1-0:1.0: USB hub found
[    0.429017] hub 1-0:1.0: 5 ports detected
[    0.429135] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.429149] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.429192] ehci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 2
[    0.429228] ehci_hcd 0000:00:13.2: debug port 1
[    0.429242] ehci_hcd 0000:00:13.2: irq 17, io mem 0xd0906400
[    0.478125] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.478286] hub 2-0:1.0: USB hub found
[    0.478291] hub 2-0:1.0: 5 ports detected
[    0.478383] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.478424]   alloc irq_desc for 18 on node -1
[    0.478427]   alloc kstat_irqs on node -1
[    0.478436] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.478449] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.478500] ohci_hcd 0000:00:12.0: new USB bus registered, assigned
bus number 3
[    0.478536] ohci_hcd 0000:00:12.0: irq 18, io mem 0xd0904000
[    0.580378] hub 3-0:1.0: USB hub found
[    0.580390] hub 3-0:1.0: 5 ports detected
[    0.580469] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.580482] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.580523] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 4
[    0.580551] ohci_hcd 0000:00:13.0: irq 18, io mem 0xd0905000
[    0.675992] hub 4-0:1.0: USB hub found
[    0.676004] hub 4-0:1.0: 5 ports detected
[    0.676088] uhci_hcd: USB Universal Host Controller Interface driver
[    0.676189] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at
0x60,0x64 irq 1,12
[    0.697065] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.702697] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.702706] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.702742] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.702773] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.702804] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.702957] mice: PS/2 mouse device common for all mice
[    0.703167] rtc_cmos 00:04: RTC can wake from S4
[    0.703212] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.703246] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.703383] device-mapper: uevent: version 1.0.3
[    0.710195] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05)
initialised: dm-devel@redhat.com
[    0.794534] isapnp: No Plug & Play device found
[    0.794680] device-mapper: multipath: version 1.1.1 loaded
[    0.794685] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.794841] EISA: Probing bus 0 at eisa.0
[    0.794844] EISA: Cannot allocate resource for mainboard
[    0.794848] Cannot allocate resource for EISA slot 1
[    0.794851] Cannot allocate resource for EISA slot 2
[    0.794853] Cannot allocate resource for EISA slot 3
[    0.794856] Cannot allocate resource for EISA slot 4
[    0.794859] Cannot allocate resource for EISA slot 5
[    0.794862] Cannot allocate resource for EISA slot 6
[    0.794864] Cannot allocate resource for EISA slot 7
[    0.794867] Cannot allocate resource for EISA slot 8
[    0.794870] EISA: Detected 0 cards.
[    0.794961] cpuidle: using governor ladder
[    0.794964] cpuidle: using governor menu
[    0.795399] TCP cubic registered
[    0.795574] NET: Registered protocol family 10
[    0.796116] lo: Disabled Privacy Extensions
[    0.796453] NET: Registered protocol family 17
[    0.796487] powernow-k8: Found 1 AMD Athlon(tm) II Neo K325
Dual-Core Processor (2 cpu cores) (version 2.20.00)
[    0.796536] powernow-k8:    0 : pstate 0 (1300 MHz)
[    0.796539] powernow-k8:    1 : pstate 1 (1100 MHz)
[    0.796542] powernow-k8:    2 : pstate 2 (800 MHz)
[    0.796861] Using IPI No-Shortcut mode
[    0.796988] PM: Resume from disk failed.
[    0.797010] registered taskstats version 1
[    0.797357]   Magic number: 11:424:158
[    0.797407] wmi ABBC0F40-8EA1-11D1-00A0-C90629100000: hash matches
[    0.797427] acpi device:25: hash matches
[    0.797479] rtc_cmos 00:04: setting system clock to 2011-01-07
03:11:59 UTC (1294369919)
[    0.797484] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.797487] EDD information not available.
[    0.817858] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    0.829968] Freeing initrd memory: 15556k freed
[    0.839686] Freeing unused kernel memory: 704k freed
[    0.840412] Write protecting the kernel text: 5092k
[    0.840543] Write protecting the kernel read-only data: 2016k
[    0.853188] ACPI: Battery Slot [BAT1] (battery present)
[    0.853979] usb 1-2: new high speed USB device using ehci_hcd and address 2
[    0.877010] udev[78]: starting version 163
[    1.077638] [Firmware Bug]: ACPI: ACPI brightness control misses
_BQC function
[    1.079294] acpi device:30: registered as cooling_device2
[    1.079513] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:2f/LNXVIDEO:02/input/input4
[    1.079587] ACPI: Video Device [VGA2] (multi-head: yes  rom: no  post: no)
[    1.090750] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.090782] r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.090842] r8169 0000:02:00.0: setting latency timer to 64
[    1.090885]   alloc irq_desc for 42 on node -1
[    1.090889]   alloc kstat_irqs on node -1
[    1.090906] r8169 0000:02:00.0: irq 42 for MSI/MSI-X
[    1.091723] r8169 0000:02:00.0: eth0: RTL8168d/8111d at 0xf8524000,
60:eb:69:03:1e:9a, XID 083000c0 IRQ 42
[    1.126040] ahci 0000:00:11.0: version 3.0
[    1.126068]   alloc irq_desc for 19 on node -1
[    1.126072]   alloc kstat_irqs on node -1
[    1.126085] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.126143]   alloc irq_desc for 43 on node -1
[    1.126146]   alloc kstat_irqs on node -1
[    1.126161] ahci 0000:00:11.0: irq 43 for MSI/MSI-X
[    1.126246] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    1.126253] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part sxs
[    1.126885] Initializing USB Mass Storage driver...
[    1.126971] scsi0 : ahci
[    1.127243] scsi2 : ahci
[    1.127500] ata1: SATA max UDMA/133 abar m1024@0xd0906800 port
0xd0906900 irq 43
[    1.127506] ata2: SATA max UDMA/133 abar m1024@0xd0906800 port
0xd0906980 irq 43
[    1.127886] scsi1 : usb-storage 1-2:1.0
[    1.128065] usbcore: registered new interface driver usb-storage
[    1.128069] USB Mass Storage support registered.
[    1.139408] Linux agpgart interface v0.103
[    1.240100] usb 1-5: new high speed USB device using ehci_hcd and address 4
[    1.374185] usb 1-5: config 1 has an invalid interface number: 1 but max is 0
[    1.374193] usb 1-5: config 1 has no interface number 0
[    1.448122] ata2: SATA link down (SStatus 0 SControl 300)
[    1.620135] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.621298] ata1.00: ATA-8: HITACHI HTS545025B9A300, PB2ZC61H, max UDMA/100
[    1.621306] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.622715] ata1.00: configured for UDMA/100
[    1.637398] scsi 0:0:0:0: Direct-Access     ATA      HITACHI
HTS54502 PB2Z PQ: 0 ANSI: 5
[    1.637686] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.637778] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:
(250 GB/232 GiB)
[    1.637922] sd 0:0:0:0: [sda] Write Protect is off
[    1.637928] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.637987] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.638866]  sda:
[    1.644127] usb 3-4: new full speed USB device using ohci_hcd and address 2
[    1.660163]  sda1 sda2 < sda5 >
[    1.688709] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.726148] [drm] Initialized drm 1.1.0 20060810
[    1.789898] [drm] radeon defaulting to kernel modesetting.
[    1.789904] [drm] radeon kernel modesetting enabled.
[    1.790033] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.790041] radeon 0000:01:05.0: setting latency timer to 64
[    1.792820] [drm] initializing kernel modesetting (RS880 0x1002:0x9712).
[    1.792989] [drm] register mmio base: 0xD0500000
[    1.792993] [drm] register mmio size: 65536
[    1.793200] ATOM BIOS: Lenovo_PS2A
[    1.793228] [drm] Clocks initialized !
[    1.793244] radeon 0000:01:05.0: VRAM: 256M 0xC0000000 - 0xCFFFFFFF
(256M used)
[    1.793250] radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
[    1.793752] [drm] Detected VRAM RAM=256M, BAR=256M
[    1.793760] [drm] RAM width 32bits DDR
[    1.793898] [TTM] Zone  kernel: Available graphics memory: 440076 kiB.
[    1.793905] [TTM] Zone highmem: Available graphics memory: 900140 kiB.
[    1.793909] [TTM] Initializing pool allocator.
[    1.793948] [drm] radeon: 256M of VRAM memory ready
[    1.793952] [drm] radeon: 512M of GTT memory ready.
[    1.794004] [drm] radeon: irq initialized.
[    1.794010] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.795262] [drm] Loading RS780 Microcode
[    1.839816] [drm] ring test succeeded in 0 usecs
[    1.840097] [drm] radeon: ib pool ready.
[    1.840216] [drm] ib test succeeded in 0 usecs
[    1.840221] [drm] Enabling audio support
[    1.840583] [drm] Unknown TV standard; defaulting to NTSC
[    1.840829] [drm] Radeon Display Connectors
[    1.840833] [drm] Connector 0:
[    1.840836] [drm]   VGA
[    1.840841] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48
0x7e4c 0x7e4c
[    1.840844] [drm]   Encoders:
[    1.840847] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.840850] [drm] Connector 1:
[    1.840852] [drm]   LVDS
[    1.840856] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58
0x7e5c 0x7e5c
[    1.840860] [drm]   Encoders:
[    1.840862] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[    1.840865] [drm] Connector 2:
[    1.840868] [drm]   HDMI-A
[    1.840870] [drm]   HPD1
[    1.840874] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28
0x7e2c 0x7e2c
[    1.840877] [drm]   Encoders:
[    1.840880] [drm]     DFP1: INTERNAL_UNIPHY
[    1.902731] [drm] radeon: power management initialized
[    1.940057] usb 2-2: new high speed USB device using ehci_hcd and address 2
[    1.988180] [drm] fb mappable at 0xC0141000
[    1.988186] [drm] vram apper at 0xC0000000
[    1.988189] [drm] size 4325376
[    1.988192] [drm] fb depth is 24
[    1.988195] [drm]    pitch is 5632
[    2.089292] scsi3 : usb-storage 2-2:1.0
[    2.133608] scsi 1:0:0:0: Direct-Access     USB      Driver
  0.00 PQ: 0 ANSI: 0 CCS
[    2.134978] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.136326] sd 1:0:0:0: [sdb] 3913728 512-byte logical blocks:
(2.00 GB/1.86 GiB)
[    2.136920] sd 1:0:0:0: [sdb] Write Protect is off
[    2.136928] sd 1:0:0:0: [sdb] Mode Sense: 23 00 00 00
[    2.136932] sd 1:0:0:0: [sdb] Assuming drive cache: write through
[    2.139591] sd 1:0:0:0: [sdb] Assuming drive cache: write through
[    2.139603]  sdb: sdb1
[    2.142692] sd 1:0:0:0: [sdb] Assuming drive cache: write through
[    2.142701] sd 1:0:0:0: [sdb] Attached SCSI removable disk
[    2.201080] usb 2-3: new high speed USB device using ehci_hcd and address 3
[    2.940570] Console: switching to colour frame buffer device 170x48
[    2.955935] fb0: radeondrmfb frame buffer device
[    2.955938] drm: registered panic notifier
[    2.955965] Slow work thread pool: Starting up
[    2.956100] Slow work thread pool: Ready
[    2.956110] [drm] Initialized radeon 2.5.0 20080528 for
0000:01:05.0 on minor 0
[    3.091585] scsi 3:0:0:0: Direct-Access     Generic- Multi-Card
  1.00 PQ: 0 ANSI: 0 CCS
[    3.092487] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    3.097900] sd 3:0:0:0: [sdc] Attached SCSI removable disk
[    3.467006] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[   14.201980] udev[449]: starting version 163
[   14.265615] lp: driver loaded but no devices found
[   14.298076] Adding 9936892k swap on /dev/sda5.  Priority:-1
extents:1 across:9936892k
[   14.382614] shpchp 0000:00:01.0: HPC vendor_id 1022 device_id 9602
ss_vid 1022 ss_did 9602
[   14.382624] shpchp 0000:00:01.0: Cannot reserve MMIO region
[   14.382664] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.413302] ACPI: resource piix4_smbus [io  0x8040-0x8047]
conflicts with ACPI region SMB0 [??? 0x00008040-0x0000804f flags 0x30]
[   14.413309] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[   14.525535] Non-volatile memory driver v1.3
[   14.718003] Linux video capture interface: v2.00
[   14.734712] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   14.751879] Bluetooth: Core ver 2.15
[   14.751959] NET: Registered protocol family 31
[   14.751963] Bluetooth: HCI device and connection manager initialized
[   14.751969] Bluetooth: HCI socket layer initialized
[   14.760604] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   14.761863] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b1b4)
[   14.765077] usbcore: registered new interface driver usbserial
[   14.765136] USB Serial support registered for generic
[   14.768300] input: Integrated Camera as
/devices/pci0000:00/0000:00:13.2/usb2/2-3/2-3:1.0/input/input5
[   14.768511] usbcore: registered new interface driver uvcvideo
[   14.768515] USB Video Class driver (v0.1.0)
[   14.776728] usbcore: registered new interface driver btusb
[   14.777567] usbcore: registered new interface driver usbserial_generic
[   14.777572] usbserial: USB Serial Driver core
[   14.818412] USB Serial support registered for Qualcomm USB modem
[   14.818496] qcserial 1-5:1.1: Qualcomm USB modem converter detected
[   14.818762] usb 1-5: Qualcomm USB modem converter now attached to ttyUSB0
[   14.818839] usbcore: registered new interface driver qcserial
[   14.895307] type=1400 audit(1294369933.595:2): apparmor="STATUS"
operation="profile_load" name="/sbin/dhclient3" pid=782
comm="apparmor_parser"
[   14.895846] type=1400 audit(1294369933.595:3): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=782
comm="apparmor_parser"
[   14.896153] type=1400 audit(1294369933.595:4): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=782
comm="apparmor_parser"
[   14.992303] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   14.992309] thinkpad_acpi: http://ibm-acpi.sf.net/
[   14.992313] thinkpad_acpi: ThinkPad BIOS 87ET34WW (1.08 ), EC
87HT20WW-1.165000
[   14.992319] thinkpad_acpi: Lenovo ThinkPad Edge, model 254523U
[   15.006640] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[   15.007789] thinkpad_acpi: radio switch found; radios are enabled
[   15.007861] thinkpad_acpi: possible tablet mode switch found;
ThinkPad in laptop mode
[   15.007891] thinkpad_acpi: This ThinkPad has standard ACPI
backlight brightness control, supported by the ACPI video driver
[   15.007896] thinkpad_acpi: Disabling thinkpad-acpi brightness
events by default...
[   15.011945] thinkpad_acpi: asked for hotkey mask 0x04000070, but
firmware forced it to 0x00000070
[   15.040283] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio
is unblocked
[   15.067434] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[   15.067531] Registered led device: tpacpi::thinklight
[   15.067569] Registered led device: tpacpi::power
[   15.067599] Registered led device: tpacpi::standby
[   15.067623] Registered led device: tpacpi::thinkvantage
[   15.079219] thinkpad_acpi: Standard ACPI backlight interface
available, not loading native one.
[   15.079384] thinkpad_acpi: Console audio control enabled, mode:
monitor (read only)
[   15.093653] input: ThinkPad Extra Buttons as
/devices/platform/thinkpad_acpi/input/input6
[   15.157239] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   15.235606] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[   15.235708] HDA Intel 0000:01:05.1: setting latency timer to 64
[   15.254961] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_delete_codec_preset
[   15.254970] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_delete_codec_preset (err -22)
[   15.255133] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_multi_out_dig_open
[   15.255139] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_multi_out_dig_open (err -22)
[   15.255320] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_multi_out_dig_close
[   15.255326] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_multi_out_dig_close (err -22)
[   15.255493] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_sequence_write
[   15.255498] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_sequence_write (err -22)
[   15.255665] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_codec_write
[   15.255669] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_codec_write (err -22)
[   15.255838] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_add_codec_preset
[   15.255843] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_add_codec_preset (err -22)
[   15.256081] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_create_spdif_out_ctls
[   15.256087] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_create_spdif_out_ctls (err -22)
[   15.256277] snd_hda_codec_atihdmi: disagrees about version of
symbol snd_hda_multi_out_dig_prepare
[   15.256282] snd_hda_codec_atihdmi: Unknown symbol
snd_hda_multi_out_dig_prepare (err -22)
[   15.277247] type=1400 audit(1294369933.979:5): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=994
comm="apparmor_parser"
[   15.277796] type=1400 audit(1294369933.979:6): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=994
comm="apparmor_parser"
[   15.278105] type=1400 audit(1294369933.979:7): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=994
comm="apparmor_parser"
[   15.284010] type=1400 audit(1294369933.983:8): apparmor="STATUS"
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
pid=993 comm="apparmor_parser"
[   15.318946] type=1400 audit(1294369934.019:9): apparmor="STATUS"
operation="profile_load" name="/usr/bin/evince" pid=999
comm="apparmor_parser"
[   15.330945] type=1400 audit(1294369934.031:10): apparmor="STATUS"
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
pid=1010 comm="apparmor_parser"
[   15.331646] type=1400 audit(1294369934.031:11): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/cupsd" pid=1010
comm="apparmor_parser"
[   15.351151] r8169 0000:02:00.0: eth0: link down
[   15.351559] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.610863] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1,
caps: 0xd047b1/0xb40000/0xa0000
[   15.610873] serio: Synaptics pass-through port at isa0060/serio4/input0
[   15.661451] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio4/input/input7
[   15.802107] Bluetooth: L2CAP ver 2.14
[   15.802114] Bluetooth: L2CAP socket layer initialized
[   15.818872] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.818878] Bluetooth: BNEP filters: protocol multicast
[   15.834172] Bluetooth: SCO (Voice Link) ver 0.6
[   15.834178] Bluetooth: SCO socket layer initialized
[   15.871607] ppdev: user-space parallel port driver
[   15.943030] Bluetooth: RFCOMM TTY layer initialized
[   15.943039] Bluetooth: RFCOMM socket layer initialized
[   15.943044] Bluetooth: RFCOMM ver 1.11
[   16.820230] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   18.847072] psmouse serio5: ID: 10 00 64
[   19.327610] hda-intel: IRQ timing workaround is activated for card
#1. Suggest a bigger bdl_pos_adj.
[   19.929294] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   23.425785] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   23.725857] input: TPPS/2 IBM TrackPoint as
/devices/platform/i8042/serio4/serio5/input/input8
[   89.163657] audit_printk_skb: 9 callbacks suppressed
[   89.163666] type=1400 audit(1294370007.859:15): apparmor="DENIED"
operation="open" parent=1793 profile="/usr/sbin/cupsd"
name="/dev/ttyUSB0" pid=1794 comm="serial" requested_mask="w"
denied_mask="w" fsuid=0 ouid=0
[  546.725041] usb 1-2: USB disconnect, address 2
[  687.096156] usb 1-2: new high speed USB device using ehci_hcd and address 5
[  687.240271] scsi4 : usb-storage 1-2:1.0
[  688.241869] scsi 4:0:0:0: Direct-Access     USB      Driver
  0.00 PQ: 0 ANSI: 0 CCS
[  688.243993] sd 4:0:0:0: Attached scsi generic sg1 type 0
[  688.473681] sd 4:0:0:0: [sdb] 3913728 512-byte logical blocks:
(2.00 GB/1.86 GiB)
[  688.474336] sd 4:0:0:0: [sdb] Write Protect is off
[  688.474349] sd 4:0:0:0: [sdb] Mode Sense: 23 00 00 00
[  688.474356] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  688.477701] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  688.477720]  sdb: sdb1
[  688.480932] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  688.480945] sd 4:0:0:0: [sdb] Attached SCSI removable disk


On Thu, Jan 13, 2011 at 11:22 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Thu, Jan 13, 2011 at 06:10:01PM +0100, Thomas Gleixner wrote:
>> On Thu, 13 Jan 2011, Matthew Garrett wrote:
>>
>> > On Thu, Jan 13, 2011 at 10:02:22AM -0600, Manoj Iyer wrote:
>> > > Set acpi_skip_timer_override to force ignoring BIOS
>> > > IRQ0 pin2 override. This fixes resume from suspend on
>> > > AMD based ThinkPad Edge 11,13,14 and 15.
>> >
>> > This was originally there because of a quirk in some ati chipsets,
>> > coupled with DSDT insanity on HP's part. The Thinkpad Edges seem to be
>> > Intel machines, so it's not the same underlying issue. Do we have any
>>
>> The patch description above talks explictely about AMD based ThinkPad
>> Edge. So it might be as well the same underlying problem.
>
> Hmm, that's strange, I have an Edge 13 machine here, although not the
> exact same model as the ones listed in the patch, mine is:
>
> Handle 0x0001, DMI type 1, 27 bytes
> System Information
>        Manufacturer: LENOVO
>        Product Name: 01972NG
>        Version: ThinkPad Edge 13"IAL#
>
> and it suspends/resumes just fine.
>
> Manoj, can you send us dmesg and lspci -vv outputs, please?
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632
>



-- 
--manjo
