Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0CXMFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:05:47 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:52702 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0CXMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XUNO80KscOosjqPjY7R2d8w8BocrZEL97n7G82dfyX/UHUfZJI62Cs5xmot6eJh8Z9
         fUb4KnNfEJkAXh+of7Etbf64saddy2r3LiT6pYcBAMgmUs7lzu3D0kQQ9j0QK1Ht4XlZ
         aevgJ9E/062zhV3oyPBOQpYKX/8F7WCeNwESk=
MIME-Version: 1.0
Date: Wed, 24 Mar 2010 14:05:41 +0200
Message-ID: <548cdfc21003240505t258a28a9s3a463c64e93fa7a9@mail.gmail.com>
Subject: My old laptop that is from Acer Aspire 1350 series doesn't halt with 
	2.6.34-rc[12]
From: Pauli Nieminen <suokkos@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just recently upgraded from 2.6.33-rc8 to 2.6.33-rc1 (just before
rc2 release).

When I try to shutdown the laptop it fails to halt. Result is that my
computer reboots. If I then select from grub old kernel I can still
correctly shutdown my computer.

Can I try to recompile only some specific module to try to find the
bad commit? I would prefer not to recompile whole kernel if try to
bisect.

lspci --vvvnn:
00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT8378 [KM400/A]
Chipset Host Bridge [1106:3205]
	Subsystem: VIA Technologies, Inc. Device [1106:7205]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 8
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Capabilities: [80] AGP version 3.5
		Status: RQ=32 Iso- ArqSz=0 Cal=2 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: agpgart-via
	Kernel modules: via-agp

00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8235 PCI Bridge [1106:b168]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: d8000000-dfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: shpchp

00:07.0 CardBus bridge [0607]: Texas Instruments PCI1410 PC card
Cardbus Controller [104c:ac50] (rev 02)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at 28000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 20000000-23fff000 (prefetchable)
	Memory window 1: 24000000-27fff000
	I/O window 0: 00002400-000024ff
	I/O window 1: 00002800-000028ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

00:08.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB21
IEEE-1394a-2000 Controller (PHY/Link) [104c:8026] (prog-if 10)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at d0004000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8180L 802.11b MAC [10ec:8180] (rev 20)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL8180L 802.11b MAC [10ec:8180]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at 1000 [size=256]
	Region 1: Memory at d0004800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: rtl8180
	Kernel modules: rtl8180

00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 4
	Region 4: I/O ports at 2000 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd

00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at 2020 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd

00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 9
	Region 4: I/O ports at 2040 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd

00:10.3 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0
[1106:3104] (rev 82) (prog-if 20)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at d0004c00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ehci_hcd

00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8235 ISA Bridge [1106:3177]
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: i2c-viapro, via-ircc

00:11.1 IDE interface [0101]: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
(rev 06) (prog-if 8a [Master SecP PriP])
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 4
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
[disabled] [size=1]
	Region 4: I/O ports at 2060 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_via

00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 50)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 9
	Region 0: I/O ports at 1400 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: VIA 82xx Audio
	Kernel modules: snd-via82xx

00:11.6 Communication controller [0780]: VIA Technologies, Inc. AC'97
Modem Controller [1106:3068] (rev 80)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 9
	Region 0: I/O ports at 1800 [size=256]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: VIA 82xx Modem
	Kernel modules: snd-via82xx-modem

00:12.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6102
[Rhine-II] [1106:3065] (rev 74)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (750ns min, 2000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 4
	Region 0: I/O ports at 1c00 [size=256]
	Region 1: Memory at d0005000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: via-rhine
	Kernel modules: via-rhine

01:00.0 VGA compatible controller [0300]: ATI Technologies Inc M9+
5C61 [Radeon Mobility 9200 (AGP)] [1002:5c61] (rev 01)
	Subsystem: Acer Incorporated [ALI] Device [1025:0033]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B+ DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 66 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 4
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at 9000 [size=256]
	Region 2: Memory at d0100000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0120000 [disabled] [size=128K]
	Capabilities: [58] AGP version 3.0
		Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans-
64bit- FW+ AGP3+ Rate=x4,x8
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: radeon
	Kernel modules: radeon, radeonfb

netconsole captured shutdown log:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc2 (root@pulu) (gcc version 4.4.1
(Ubuntu 4.4.1-4ubuntu9) ) #45 SMP PREEMPT Tue Mar 23 16:06:27 EET 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
[    0.000000]  BIOS-e820: 000000001fef0000 - 000000001fefb000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001fefb000 - 000000001ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001ff00000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU
or disabled in BIOS!
[    0.000000] DMI 2.3 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x1fef0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-D7FFF uncachable
[    0.000000]   D8000-DBFFF write-protect
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FE0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
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
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d8000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000001fef0000 (usable)
[    0.000000]  modified: 000000001fef0000 - 000000001fefb000 (ACPI data)
[    0.000000]  modified: 000000001fefb000 - 000000001ff00000 (ACPI NVS)
[    0.000000]  modified: 000000001ff00000 - 0000000020000000 (reserved)
[    0.000000]  modified: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01400000
[    0.000000] init_memory_mapping: 0000000000000000-000000001fef0000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 001fc00000 page 2M
[    0.000000]  001fc00000 - 001fef0000 page 4k
[    0.000000] kernel direct mapping tables up to 1fef0000 @ 15000-1a000
[    0.000000] RAMDISK: 1362c000 - 17f735ce
[    0.000000] ACPI: RSDP 000f68c0 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 1fef5b3e 0002C (v01 PTLTD    RSDT   06040000
 LTP 00000000)
[    0.000000] ACPI: FACP 1fefae74 00074 (v01 KN400  PTLTW    06040000
PTL_ 000F4240)
[    0.000000] ACPI: DSDT 1fef5b6a 0530A (v01  VIA   PTL_ACPI 06040000
MSFT 0100000E)
[    0.000000] ACPI: FACS 1fefbfc0 00040
[    0.000000] ACPI: SSDT 1fefaee8 00118 (v01 PTLTD  POWERNOW 06040000
 LTP 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 510MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1fef0000
[    0.000000]   low ram: 0 - 1fef0000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001fef0
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001fef0
[    0.000000] On node 0 totalpages: 130688
[    0.000000] free_area_init_node: node 0, pgdat c07efec0,
node_mem_map c1001020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3952 pages, LIFO batch:0
[    0.000000]   Normal zone: 990 pages used for memmap
[    0.000000]   Normal zone: 125714 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d8000
[    0.000000] PM: Registered nosave memory: 00000000000d8000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
20000000:dffe0000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1
nr_node_ids:1
[    0.000000] early_res array is doubled to 64 at [16000 - 167ff]
[    0.000000] PERCPU: Embedded 334 pages/cpu @c1800000 s1347092 r0
d20972 u4194304
[    0.000000] pcpu-alloc: s1347092 r0 d20972 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 129666
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc2
root=/dev/sda1 ro debug loglevel=6
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 2615980 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Subtract (39 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 0000f8fd44]   TEXT DATA BSS
[    0.000000]   #3 [001362c000 - 0017f735ce]         RAMDISK
[    0.000000]   #4 [000009f800 - 0000100000]   BIOS reserved
[    0.000000]   #5 [0000f90000 - 0000f95134]             BRK
[    0.000000]   #6 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #7 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #8 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #9 [0001000000 - 0001001000]         BOOTMEM
[    0.000000]   #10 [0001001000 - 0001401000]         BOOTMEM
[    0.000000]   #11 [0001401000 - 0001401004]         BOOTMEM
[    0.000000]   #12 [0001401040 - 0001401300]         BOOTMEM
[    0.000000]   #13 [0001401300 - 0001401330]         BOOTMEM
[    0.000000]   #14 [0001401340 - 0001406b40]         BOOTMEM
[    0.000000]   #15 [0001406b40 - 0001406c74]         BOOTMEM
[    0.000000]   #16 [0001406c80 - 0001406cc0]         BOOTMEM
[    0.000000]   #17 [0001406cc0 - 0001406d00]         BOOTMEM
[    0.000000]   #18 [0001406d00 - 0001406d40]         BOOTMEM
[    0.000000]   #19 [0001406d40 - 0001406d80]         BOOTMEM
[    0.000000]   #20 [0001406d80 - 0001406dc0]         BOOTMEM
[    0.000000]   #21 [0001406dc0 - 0001406e00]         BOOTMEM
[    0.000000]   #22 [0001406e00 - 0001406e40]         BOOTMEM
[    0.000000]   #23 [0001406e40 - 0001406e80]         BOOTMEM
[    0.000000]   #24 [0001406e80 - 0001406e90]         BOOTMEM
[    0.000000]   #25 [0001406ec0 - 0001406ed0]         BOOTMEM
[    0.000000]   #26 [0001406f00 - 0001406f42]         BOOTMEM
[    0.000000]   #27 [0001406f80 - 0001406fc2]         BOOTMEM
[    0.000000]   #28 [0001800000 - 000194e000]         BOOTMEM
[    0.000000]   #29 [0001409000 - 0001409004]         BOOTMEM
[    0.000000]   #30 [0001409040 - 0001409044]         BOOTMEM
[    0.000000]   #31 [0001409080 - 0001409084]         BOOTMEM
[    0.000000]   #32 [00014090c0 - 00014090c4]         BOOTMEM
[    0.000000]   #33 [0001409100 - 00014091b0]         BOOTMEM
[    0.000000]   #34 [00014091c0 - 0001409268]         BOOTMEM
[    0.000000]   #35 [0001407000 - 0001409000]         BOOTMEM
[    0.000000]   #36 [0001409280 - 0001449280]         BOOTMEM
[    0.000000]   #37 [0001449280 - 0001469280]         BOOTMEM
[    0.000000]   #38 [000146a000 - 00016e8aac]         BOOTMEM
[    0.000000]  16 20 - 80 9f
[    0.000000]  f96 fa0 - 1000 1000
[    0.000000]  16e9 1700 - 1800 1800
[    0.000000]  194e 1960 - 13620 1362c
[    0.000000]  17f74 17f80 - 1fee0 1fef0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 424336k/523200k available (4793k kernel code,
98416k reserved, 2415k data, 1892k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xe06f0000 - 0xff7fe000   ( 497 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdfef0000   ( 510 MB)
[    0.000000]       .init : 0xc080b000 - 0xc09e4000   (1892 kB)
[    0.000000]       .data : 0xc05ae58b - 0xc080a2e8   (2415 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05ae58b   (4793 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0,
CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 796.128 MHz processor.
[    0.004190] Calibrating delay loop (skipped), value calculated
using timer frequency.. 1592.25 BogoMIPS (lpj=3184512)
[    0.004620] Security Framework initialized
[    0.004640] SELinux:  Disabled at boot.
[    0.004811] Mount-cache hash table entries: 512
[    0.013598] Initializing cgroup subsys ns
[    0.013615] Initializing cgroup subsys cpuacct
[    0.013669] Initializing cgroup subsys memory
[    0.013967] Initializing cgroup subsys freezer
[    0.013981] Initializing cgroup subsys net_cls
[    0.014330] mce: CPU supports 4 MCE banks
[    0.014380] Performance Events:
[    0.014391] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.014403] no hardware sampling interrupt available.
[    0.014413] AMD PMU driver.
[    0.014948] ... version:                0
[    0.014958] ... bit width:              48
[    0.014967] ... generic registers:      4
[    0.014977] ... value mask:             0000ffffffffffff
[    0.014988] ... max period:             00007fffffffffff
[    0.014998] ... fixed-purpose events:   0
[    0.015007] ... event mask:             000000000000000f
[    0.015031] Checking 'hlt' instruction... OK.
[    0.029825] SMP alternatives: switching to UP code
[    0.045705] Freeing SMP alternatives: 16k freed
[    0.045791] ACPI: Core revision 20100121
[    0.079267] ACPI: setting ELCR to 0400 (from 0a30)
[    0.080054] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.080075] ftrace: allocating 19670 entries in 39 pages
[    0.084800] weird, boot CPU (#0) not listed by the BIOS.
[    0.084913] SMP motherboard not detected.
[    0.085006] Local APIC not detected. Using dummy APIC emulation.
[    0.085104] SMP disabled
[    0.101010] Brought up 1 CPUs
[    0.101021] Total of 1 processors activated (1592.25 BogoMIPS).
[    0.114437] regulator: core version 0.5
[    0.117724] regulator: dummy:
[    0.117772] Time: 11:50:06  Date: 03/24/10
[    0.118758] NET: Registered protocol family 16
[    0.125647] EISA bus registered
[    0.125800] ACPI: bus type pci registered
[    0.128408] PCI: PCI BIOS revision 2.10 entry at 0xfd65c, last bus=1
[    0.128419] PCI: Using configuration type 1 for base access
[    0.184496] bio: create slab <bio-0> at 0
[    0.215630] ACPI: EC: Look up EC in DSDT
[    0.259037] ACPI: Interpreter enabled
[    0.259055] ACPI: (supports S0 S3 S4 S5)
[    0.259285] ACPI: Using PIC for interrupt routing
[    0.334101] ACPI: EC: GPE = 0x1, I/O: command/status = 0x66, data = 0x62
[    0.337588] ACPI: No dock devices found.
[    0.337603] PCI: Ignoring host bridge windows from ACPI; if
necessary, use "pci=use_crs" and report a bug
[    0.340853] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.347571] pci_root PNP0A03:00: host bridge window [io
0x0000-0x0cf7] (ignored)
[    0.347584] pci_root PNP0A03:00: host bridge window [io
0x0d00-0xffff] (ignored)
[    0.347596] pci_root PNP0A03:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.347608] pci_root PNP0A03:00: host bridge window [mem
0x000d4000-0x000d7fff] (ignored)
[    0.347619] pci_root PNP0A03:00: host bridge window [mem
0x20000000-0xffe7ffff] (ignored)
[    0.347865] pci 0000:00:00.0: reg 10: [mem 0xe0000000-0xefffffff pref]
[    0.348619] pci 0000:00:01.0: supports D1
[    0.348816] pci 0000:00:07.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.348921] pci 0000:00:07.0: supports D1 D2
[    0.348930] pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.348954] pci 0000:00:07.0: PME# disabled
[    0.349109] pci 0000:00:08.0: reg 10: [mem 0xd0004000-0xd00047ff]
[    0.349144] pci 0000:00:08.0: reg 14: [mem 0xd0000000-0xd0003fff]
[    0.349362] pci 0000:00:08.0: supports D1 D2
[    0.349371] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot
[    0.349393] pci 0000:00:08.0: PME# disabled
[    0.349545] pci 0000:00:09.0: reg 10: [io  0x1000-0x10ff]
[    0.349580] pci 0000:00:09.0: reg 14: [mem 0xd0004800-0xd00048ff]
[    0.349799] pci 0000:00:09.0: supports D1 D2
[    0.349808] pci 0000:00:09.0: PME# supported from D1 D2 D3hot D3cold
[    0.349829] pci 0000:00:09.0: PME# disabled
[    0.350122] pci 0000:00:10.0: reg 20: [io  0x2000-0x201f]
[    0.350269] pci 0000:00:10.0: supports D1 D2
[    0.350278] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.350299] pci 0000:00:10.0: PME# disabled
[    0.350552] pci 0000:00:10.1: reg 20: [io  0x2020-0x203f]
[    0.350700] pci 0000:00:10.1: supports D1 D2
[    0.350709] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.350731] pci 0000:00:10.1: PME# disabled
[    0.350975] pci 0000:00:10.2: reg 20: [io  0x2040-0x205f]
[    0.351121] pci 0000:00:10.2: supports D1 D2
[    0.351130] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351152] pci 0000:00:10.2: PME# disabled
[    0.351303] pci 0000:00:10.3: reg 10: [mem 0xd0004c00-0xd0004cff]
[    0.351544] pci 0000:00:10.3: supports D1 D2
[    0.351553] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351574] pci 0000:00:10.3: PME# disabled
[    0.351902] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.351929] pci 0000:00:11.0: quirk: [io  0x4000-0x407f] claimed by vt8235 PM
[    0.351950] pci 0000:00:11.0: quirk: [io  0x8100-0x810f] claimed by
vt8235 SMB
[    0.352325] pci 0000:00:11.1: reg 20: [io  0x2060-0x206f]
[    0.352651] pci 0000:00:11.5: reg 10: [io  0x1400-0x14ff]
[    0.352891] pci 0000:00:11.5: supports D1 D2
[    0.353046] pci 0000:00:11.6: reg 10: [io  0x1800-0x18ff]
[    0.353290] pci 0000:00:11.6: supports D1 D2
[    0.353449] pci 0000:00:12.0: reg 10: [io  0x1c00-0x1cff]
[    0.353485] pci 0000:00:12.0: reg 14: [mem 0xd0005000-0xd00050ff]
[    0.353702] pci 0000:00:12.0: supports D1 D2
[    0.353711] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.353733] pci 0000:00:12.0: PME# disabled
[    0.354144] pci 0000:01:00.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    0.354179] pci 0000:01:00.0: reg 14: [io  0x9000-0x90ff]
[    0.354214] pci 0000:01:00.0: reg 18: [mem 0xd0100000-0xd010ffff]
[    0.354316] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.354447] pci 0000:01:00.0: supports D1 D2
[    0.354741] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.354764] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.354787] pci 0000:00:01.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.354810] pci 0000:00:01.0:   bridge window [mem
0xd8000000-0xdfffffff pref]
[    0.355046] pci_bus 0000:00: on NUMA node 0
[    0.355068] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.410088] ACPI: PCI Interrupt Link [LNKA] (IRQs *4)
[    0.410674] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.411281] ACPI: PCI Interrupt Link [LNKC] (IRQs *9)
[    0.411887] ACPI: PCI Interrupt Link [LNKD] (IRQs *11)
[    0.415894] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.415917] vgaarb: loaded
[    0.418662] SCSI subsystem initialized
[    0.420368] libata version 3.00 loaded.
[    0.422606] usbcore: registered new interface driver usbfs
[    0.423111] usbcore: registered new interface driver hub
[    0.423805] usbcore: registered new device driver usb
[    0.429539] ACPI: WMI: Mapper loaded
[    0.429550] PCI: Using ACPI for IRQ routing
[    0.429568] PCI: pci_cache_line_size set to 32 bytes
[    0.430180] reserve RAM buffer: 0000000000002000 - 000000000000ffff
[    0.430195] reserve RAM buffer: 000000000009f800 - 000000000009ffff
[    0.430210] reserve RAM buffer: 000000001fef0000 - 000000001fffffff
[    0.433678] NetLabel: Initializing
[    0.433688] NetLabel:  domain hash size = 128
[    0.433696] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.433965] NetLabel:  unlabeled traffic allowed by default
[    0.435203] Switching to clocksource tsc
[    0.622187] pnp: PnP ACPI init
[    0.622359] ACPI: bus type pnp registered
[    0.643961] pnp: PnP ACPI: found 10 devices
[    0.643975] ACPI: ACPI bus type pnp unregistered
[    0.643986] PnPBIOS: Disabled by ACPI PNP
[    0.644089] system 00:05: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.644109] system 00:05: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.644127] system 00:05: [mem 0xfff00000-0xffffffff] could not be reserved
[    0.644143] system 00:05: [mem 0xffee0000-0xffefffff] has been reserved
[    0.644159] system 00:05: [mem 0xfec00000-0xfec00fff] has been reserved
[    0.644175] system 00:05: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.644192] system 00:05: [mem 0xffc00000-0xffffffff] could not be reserved
[    0.644257] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.644273] system 00:06: [io  0xfe10-0xfe11] has been reserved
[    0.644288] system 00:06: [io  0x0600-0x060f] has been reserved
[    0.644303] system 00:06: [io  0xfe00] has been reserved
[    0.644318] system 00:06: [io  0x4000-0x407f] has been reserved
[    0.644334] system 00:06: [io  0x8100-0x811f] could not be reserved
[    0.686052] PCI: max bus depth: 1 pci_try_num: 2
[    0.686117] pci 0000:00:07.0: BAR 15: assigned [mem
0x20000000-0x23ffffff pref]
[    0.686136] pci 0000:00:07.0: BAR 16: assigned [mem 0x24000000-0x27ffffff]
[    0.686153] pci 0000:00:07.0: BAR 0: assigned [mem 0x28000000-0x28000fff]
[    0.686182] pci 0000:00:07.0: BAR 0: set to [mem
0x28000000-0x28000fff] (PCI address [0x28000000-0x28000fff]
[    0.686201] pci 0000:00:07.0: BAR 13: assigned [io  0x2400-0x24ff]
[    0.686218] pci 0000:00:07.0: BAR 14: assigned [io  0x2800-0x28ff]
[    0.686240] pci 0000:01:00.0: BAR 6: assigned [mem
0xd0120000-0xd013ffff pref]
[    0.686252] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.686269] pci 0000:00:01.0:   bridge window [io  0x9000-0x9fff]
[    0.686298] pci 0000:00:01.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.686321] pci 0000:00:01.0:   bridge window [mem
0xd8000000-0xdfffffff pref]
[    0.686355] pci 0000:00:07.0: CardBus bridge to [bus 02-05]
[    0.686365] pci 0000:00:07.0:   bridge window [io  0x2400-0x24ff]
[    0.686388] pci 0000:00:07.0:   bridge window [io  0x2800-0x28ff]
[    0.686411] pci 0000:00:07.0:   bridge window [mem
0x20000000-0x23ffffff pref]
[    0.686434] pci 0000:00:07.0:   bridge window [mem 0x24000000-0x27ffffff]
[    0.686508] pci 0000:00:01.0: setting latency timer to 64
[    0.687535] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
[    0.687649] PCI: setting IRQ 5 as level-triggered
[    0.687665] pci 0000:00:07.0: PCI INT A -> Link[LNKB] -> GSI 5
(level, low) -> IRQ 5
[    0.687690] pci 0000:00:07.0: setting latency timer to 64
[    0.687709] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.687720] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.687731] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
[    0.687741] pci_bus 0000:01: resource 1 [mem 0xd0100000-0xd01fffff]
[    0.687751] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff pref]
[    0.687761] pci_bus 0000:02: resource 0 [io  0x2400-0x24ff]
[    0.687771] pci_bus 0000:02: resource 1 [io  0x2800-0x28ff]
[    0.687781] pci_bus 0000:02: resource 2 [mem 0x20000000-0x23ffffff pref]
[    0.687791] pci_bus 0000:02: resource 3 [mem 0x24000000-0x27ffffff]
[    0.688169] NET: Registered protocol family 2
[    0.689291] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.693433] TCP established hash table entries: 16384 (order: 5,
131072 bytes)
[    0.693953] TCP bind hash table entries: 16384 (order: 7, 655360 bytes)
[    0.698544] TCP: Hash tables configured (established 16384 bind 16384)
[    0.698687] TCP reno registered
[    0.698712] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.698874] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.699945] NET: Registered protocol family 1
[    0.700095] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    0.700577] pci 0000:01:00.0: Boot video device
[    0.700602] PCI: CLS 32 bytes, default 32
[    0.701435] Trying to unpack rootfs image as initramfs...
[    7.043785] Freeing initrd memory: 75037k freed
[    7.317449] Scanning for low memory corruption every 60 seconds
[    7.321000] audit: initializing netlink socket (disabled)
[    7.321178] type=2000 audit(1269431412.320:1): initialized
[    7.333802] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    7.376263] VFS: Disk quotas dquot_6.5.2
[    7.377388] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    7.390854] fuse init (API version 7.13)
[    7.393122] msgmni has been set to 975
[    7.397766] alg: No test for stdrng (krng)
[    7.398398] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    7.398481] io scheduler noop registered
[    7.398494] io scheduler deadline registered
[    7.399278] io scheduler cfq registered (default)
[    7.400678] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.405999] ACPI: AC Adapter [ACAD] (on-line)
[    7.409088] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    7.409113] ACPI: Power Button [PWRB]
[    7.409933] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    7.409954] ACPI: Sleep Button [SLPB]
[    7.410847] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    7.411102] ACPI: Lid Switch [LID]
[    7.411929] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    7.411949] ACPI: Power Button [PWRF]
[    7.415142] Marking TSC unstable due to TSC halts in idle
[    7.418083] Switching to clocksource acpi_pm
[    7.441319] BUG: key cf51bf4c not in .data!
[    7.441422] ------------[ cut here ]------------
[    7.441533] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x10a/0x120()
[    7.441636] Hardware name: Aspire 1350
[    7.441724] Modules linked in:
[    7.441854] Pid: 1, comm: swapper Not tainted 2.6.34-rc2 #45
[    7.441951] Call Trace:
[    7.442050]  [<c0145bd2>] warn_slowpath_common+0x72/0xa0
[    7.442153]  [<c0178c3a>] ? lockdep_init_map+0x10a/0x120
[    7.442254]  [<c0178c3a>] ? lockdep_init_map+0x10a/0x120
[    7.442356]  [<c0145c1a>] warn_slowpath_null+0x1a/0x20
[    7.442457]  [<c0178c3a>] lockdep_init_map+0x10a/0x120
[    7.442565]  [<c026e17d>] sysfs_add_file_mode+0x5d/0xb0
[    7.442667]  [<c026e1e8>] sysfs_add_file+0x18/0x20
[    7.442766]  [<c026e21b>] sysfs_create_file+0x2b/0x40
[    7.442870]  [<c03efc58>] device_create_file+0x18/0x20
[    7.442976]  [<c049e221>] thermal_zone_device_register+0x341/0x830
[    7.443084]  [<c03b5d68>] acpi_thermal_add+0x229/0x48d
[    7.443186]  [<c026fba1>] ? sysfs_do_create_link+0xa1/0x140
[    7.443292]  [<c038e188>] acpi_device_probe+0x3f/0xf9
[    7.443395]  [<c03f2607>] driver_probe_device+0x77/0x170
[    7.443501]  [<c05a7b64>] ? _raw_spin_unlock_irqrestore+0x44/0x70
[    7.443607]  [<c03f2a11>] __driver_attach+0x91/0xa0
[    7.443706]  [<c03f1a03>] bus_for_each_dev+0x53/0x80
[    7.443807]  [<c03f249e>] driver_attach+0x1e/0x20
[    7.443905]  [<c03f2980>] ? __driver_attach+0x0/0xa0
[    7.444005]  [<c03f2147>] bus_add_driver+0xc7/0x2a0
[    7.444160]  [<c038e0b4>] ? acpi_device_remove+0x0/0x95
[    7.444265]  [<c03f2b5a>] driver_register+0x6a/0x120
[    7.444368]  [<c0261b18>] ? proc_mkdir_mode+0x38/0x60
[    7.444470]  [<c038ec02>] acpi_bus_register_driver+0x3f/0x41
[    7.444577]  [<c0830436>] acpi_thermal_init+0x4f/0x6e
[    7.444678]  [<c0101132>] do_one_initcall+0x32/0x1a0
[    7.444785]  [<c01a91a4>] ? irq_to_desc+0x14/0x20
[    7.444884]  [<c08303e7>] ? acpi_thermal_init+0x0/0x6e
[    7.444992]  [<c080b399>] kernel_init+0x132/0x1cd
[    7.445092]  [<c080b267>] ? kernel_init+0x0/0x1cd
[    7.445191]  [<c01037c2>] kernel_thread_helper+0x6/0x10
[    7.445305] ---[ end trace 93d72a36b9146f22 ]---
[    7.445408] BUG: key cf51bf7c not in .data!
[    7.445540] BUG: key df9ba5e8 not in .data!
[    7.446451] thermal LNXTHERM:01: registered as thermal_zone0
[    7.446589] ACPI: Thermal Zone [THRM] (67 C)
[    7.448330] isapnp: Scanning for PnP cards...
[    7.802925] isapnp: No Plug & Play device found
[    7.803750] ACPI: Battery Slot [BAT1] (battery present)
[    7.823558] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.838133] brd: module loaded
[    7.843899] loop: module loaded
[    7.856313] pata_via 0000:00:11.1: version 0.3.4
[    7.856604] pata_via 0000:00:11.1: power state changed by ACPI to D0
[    7.857366] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 4
[    7.857468] PCI: setting IRQ 4 as level-triggered
[    7.857570] pata_via 0000:00:11.1: PCI INT A -> Link[LNKA] -> GSI 4
(level, low) -> IRQ 4
[    7.857714] pata_via 0000:00:11.1: VIA VLink IRQ fixup, from 0 to 4
[    7.858335] scsi0 : pata_via
[    7.859160] scsi1 : pata_via
[    7.863133] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2060 irq 14
[    7.863242] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x2068 irq 15
[    7.873914] Fixed MDIO Bus: probed
[    7.874850] PPP generic driver version 2.4.2
[    7.876181] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.877149] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    7.877253] PCI: setting IRQ 11 as level-triggered
[    7.877355] ehci_hcd 0000:00:10.3: PCI INT D -> Link[LNKD] -> GSI
11 (level, low) -> IRQ 11
[    7.877500] ehci_hcd 0000:00:10.3: VIA VLink IRQ fixup, from 0 to 11
[    7.877662] ehci_hcd 0000:00:10.3: EHCI Host Controller
[    7.878197] ehci_hcd 0000:00:10.3: new USB bus registered, assigned
bus number 1
[    7.878463] ehci_hcd 0000:00:10.3: irq 11, io mem 0xd0004c00
[    7.888068] ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00
[    7.888986] hub 1-0:1.0: USB hub found
[    7.889115] hub 1-0:1.0: 6 ports detected
[    7.889751] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.890099] uhci_hcd: USB Universal Host Controller Interface driver
[    7.890339] uhci_hcd 0000:00:10.0: PCI INT A -> Link[LNKA] -> GSI 4
(level, low) -> IRQ 4
[    7.890483] uhci_hcd 0000:00:10.0: VIA VLink IRQ fixup, from 0 to 4
[    7.890616] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    7.891059] uhci_hcd 0000:00:10.0: new USB bus registered, assigned
bus number 2
[    7.891242] uhci_hcd 0000:00:10.0: irq 4, io base 0x00002000
[    7.892273] hub 2-0:1.0: USB hub found
[    7.892384] hub 2-0:1.0: 2 ports detected
[    7.892786] uhci_hcd 0000:00:10.1: PCI INT B -> Link[LNKB] -> GSI 5
(level, low) -> IRQ 5
[    7.892931] uhci_hcd 0000:00:10.1: VIA VLink IRQ fixup, from 0 to 5
[    7.893061] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    7.893527] uhci_hcd 0000:00:10.1: new USB bus registered, assigned
bus number 3
[    7.893707] uhci_hcd 0000:00:10.1: irq 5, io base 0x00002020
[    7.894655] hub 3-0:1.0: USB hub found
[    7.894765] hub 3-0:1.0: 2 ports detected
[    7.895867] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
[    7.895970] PCI: setting IRQ 9 as level-triggered
[    7.896211] uhci_hcd 0000:00:10.2: PCI INT C -> Link[LNKC] -> GSI 9
(level, low) -> IRQ 9
[    7.896355] uhci_hcd 0000:00:10.2: VIA VLink IRQ fixup, from 0 to 9
[    7.896486] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    7.896938] uhci_hcd 0000:00:10.2: new USB bus registered, assigned
bus number 4
[    7.897122] uhci_hcd 0000:00:10.2: irq 9, io base 0x00002040
[    7.898100] hub 4-0:1.0: USB hub found
[    7.898210] hub 4-0:1.0: 2 ports detected
[    7.899317] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at
0x60,0x64 irq 1,12
[    7.906210] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.906326] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.907660] mice: PS/2 mouse device common for all mice
[    7.909245] rtc_cmos 00:02: RTC can wake from S4
[    7.909721] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    7.909869] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    7.910667] EISA: Probing bus 0 at eisa.0
[    7.910775] Cannot allocate resource for EISA slot 1
[    7.910873] Cannot allocate resource for EISA slot 2
[    7.910982] Cannot allocate resource for EISA slot 4
[    7.911118] EISA: Detected 0 cards.
[    7.912788] cpuidle: using governor ladder
[    7.914107] cpuidle: using governor menu
[    7.916754] TCP cubic registered
[    7.918441] NET: Registered protocol family 10
[    7.920904] lo: Disabled Privacy Extensions
[    7.922654] NET: Registered protocol family 17
[    7.923292] powernow: PowerNOW! Technology present. Can scale:
frequency and voltage.
[    7.925996] powernow: SGTC: 13333
[    7.926087] powernow: Minimum speed 1459 MHz. Maximum speed 2123 MHz.
[    7.926701] Using IPI No-Shortcut mode
[    7.927315] PM: Resume from disk failed.
[    7.927432] registered taskstats version 1
[    7.927934]   Magic number: 2:737:833
[    7.928259] rtc_cmos 00:02: setting system clock to 2010-03-24
11:50:13 UTC (1269431413)
[    7.928379] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    7.928461] EDD information not available.
[    7.945822] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
[    8.371704] ata1.00: ATA-7: WDC WD800BEVE-00UYT0, 01.04A01, max UDMA/100
[    8.371793] ata1.00: 156301488 sectors, multi 16: LBA48
[    8.371907] ata1.00: limited to UDMA/33 due to 40-wire cable
[    8.384052] usb 2-2: new low speed USB device using uhci_hcd and address 2
[    8.388927] ata1.00: configured for UDMA/33
[    8.389293] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD800BEVE-00 01.0 PQ: 0 ANSI: 5
[    8.390413] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks:
(80.0 GB/74.5 GiB)
[    8.391141] sd 0:0:0:0: [sda] Write Protect is off
[    8.391225] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.391395] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    8.391715] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.392285]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 > sda3
[    8.448664] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.556433] ata2.00: ATAPI: QSI CD-RW/DVD-ROM SBW242C, UQ81, max UDMA/33
[    8.572305] ata2.00: configured for UDMA/33
[    8.573268] scsi 1:0:0:0: CD-ROM            QSI      CDRW/DVD
SBW242C UQ81 PQ: 0 ANSI: 5
[    8.576595] sr0: scsi3-mmc drive: 1x/24x writer cd/rw xa/form2 cdda tray
[    8.576684] Uniform CD-ROM driver Revision: 3.20
[    8.577191] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.577586] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    8.577879] Freeing unused kernel memory: 1892k freed
[    8.584326] Write protecting the kernel text: 4796k
[    8.584589] Write protecting the kernel read-only data: 1936k
[    9.225148] Linux agpgart interface v0.103
[    9.246476] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[    9.246668] via-rhine 0000:00:12.0: PCI INT A -> Link[LNKA] -> GSI
4 (level, low) -> IRQ 4
[    9.267134] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:01/LNXVIDEO:00/input/input5
[    9.267334] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    9.291291] usbcore: registered new interface driver hiddev
[    9.293171] eth0: VIA Rhine II at 0xd0005000, 00:c0:9f:36:b1:76, IRQ 4.
[    9.293967] eth0: MII PHY found at address 1, status 0x786d
advertising 05e1 Link 45e1.
[    9.294117] agpgart: Detected VIA KM400/KM400A chipset
[    9.308211] input: Logitech USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input6
[    9.308642] generic-usb 0003:046D:C00E.0001: input,hidraw0: USB HID
v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on
usb-0000:00:10.0-2/input0
[    9.309065] usbcore: registered new interface driver usbhid
[    9.309145] usbhid: USB HID core driver
[    9.349043] netconsole: local port 7768
[    9.349133] netconsole: local IP 192.168.1.102
[    9.349827] netconsole: interface eth0
[    9.349902] netconsole: remote port 6666
[    9.349977] netconsole: remote IP 192.168.1.163
[    9.350053] netconsole: remote ethernet address 90:e6:ba:25:5d:15
[    9.350137] netconsole: device eth0 not up yet, forcing it
[    9.350890] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[    9.351123] netconsole: carrier detect appears untrustworthy,
waiting 4 seconds
[    9.354014] agpgart-via 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   13.352116] netconsole: local port 7767
[   13.352207] netconsole: local IP 192.168.1.102
[   13.352287] netconsole: interface eth0
[   13.352364] netconsole: remote port 6666
[   13.352442] netconsole: remote IP 192.168.1.150
[   13.352522] netconsole: remote ethernet address 00:07:e9:82:f5:e6
[   13.416276] console [netcon0] enabled
[   13.416363] netconsole: network logging started
[   13.478177] [drm] Initialized drm 1.1.0 20060810
[   13.604659] [drm] radeon kernel modesetting enabled.
[   13.605039] radeon 0000:01:00.0: power state changed by ACPI to D0
[   13.605172] radeon 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 4
(level, low) -> IRQ 4
[   13.611456] [drm] radeon: Initializing kernel modesetting.
[   13.612121] [drm] register mmio base: 0xD0100000
[   13.612211] [drm] register mmio size: 65536
[   13.612989] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
[   13.613112] [drm] 2 Power State(s)
[   13.613197] [drm] State 0 Battery
[   13.613312] [drm] 	1 Clock Mode(s)
[   13.613399] [drm] 		0 engine/memory: 110000/110000
[   13.613504] [drm] State 1 Default (default)
[   13.613605] [drm] 	1 Clock Mode(s)
[   13.613718] [drm] 		0 engine/memory: 215000/200000
[   13.613840] [drm] radeon: power management initialized
[   13.614361] [drm] AGP mode requested: 4
[   13.614481] agpgart-via 0000:00:00.0: AGP 3.5 bridge
[   13.614621] agpgart-via 0000:00:00.0: putting AGP V3 device into 4x mode
[   13.614860] radeon 0000:01:00.0: putting AGP V3 device into 4x mode
[   13.614957] radeon 0000:01:00.0: GTT: 256M 0xE0000000 - 0xEFFFFFFF
[   13.615081] [drm] Generation 2 PCI interface, using max accessible memory
[   13.615179] radeon 0000:01:00.0: VRAM: 64M 0xD8000000 - 0xDBFFFFFF (64M used)
[   13.615347] [drm] radeon: irq initialized.
[   13.615805] [drm] Detected VRAM RAM=64M, BAR=128M
[   13.615923] [drm] RAM width 128bits DDR
[   13.616530] [TTM] Zone  kernel: Available graphics memory: 250644 kiB.
[   13.616620] [ttm] Initializing pool allocator.
[   13.616785] [drm] radeon: 64M of VRAM memory ready
[   13.616871] [drm] radeon: 256M of GTT memory ready.
[   13.617292] [drm] radeon: cp idle (0x02000603)
[   13.618297] [drm] Loading R200 Microcode
[   13.618384] platform radeon_cp.0: firmware: requesting radeon/R200_cp.bin
[   13.630180] [drm] radeon: ring at 0x00000000E0000000
[   13.630339] [drm] ring test succeeded in 0 usecs
[   13.632001] [drm] radeon: ib pool ready.
[   13.633152] [drm] ib test succeeded in 0 usecs
[   13.633925] [drm] Panel ID String: LGP
[   13.634013] [drm] Panel Size 1024x768
[   13.634304] [drm] Default TV standard: NTSC
[   13.634388] [drm] 27.000000000 MHz TV ref clk
[   13.634504] [drm] Default TV standard: NTSC
[   13.634585] [drm] 27.000000000 MHz TV ref clk
[   13.634831] [drm] Radeon Display Connectors
[   13.634914] [drm] Connector 0:
[   13.635020] [drm]   VGA
[   13.635098] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   13.635198] [drm]   Encoders:
[   13.635303] [drm]     CRT1: INTERNAL_DAC1
[   13.635384] [drm] Connector 1:
[   13.635475] [drm]   LVDS
[   13.635578] [drm]   Encoders:
[   13.635656] [drm]     LCD1: INTERNAL_LVDS
[   13.635750] [drm] Connector 2:
[   13.635842] [drm]   S-video
[   13.635945] [drm]   Encoders:
[   13.636084] [drm]     TV1: INTERNAL_DAC2
[   13.728476] [drm] fb mappable at 0xD8040000
[   13.728563] [drm] vram apper at 0xD8000000
[   13.728673] [drm] size 3145728
[   13.728751] [drm] fb depth is 24
[   13.728856] [drm]    pitch is 4096
[   13.729105] fb0: radeondrmfb frame buffer device
[   13.729189] registered panic notifier
[   13.729306] [drm] Initialized radeon 2.1.0 20080528 for
0000:01:00.0 on minor 0
[   13.845292] Console: switching to colour frame buffer device 128x48
[   14.399653] PM: Starting manual resume from disk
[   14.400346] PM: Resume from partition 8:5
[   14.400886] PM: Checking hibernation image.
[   14.401770] PM: Error -22 checking image file
[   14.402322] PM: Resume from disk failed.
[   14.500395] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   19.472043] eth0: no IPv6 routers present
[   41.284696] rtl8180 0000:00:09.0: PCI INT A -> Link[LNKC] -> GSI 9
(level, low) -> IRQ 9
[   41.805180] phy0: Selected rate control algorithm 'minstrel'
[   41.808848] phy0: hwaddr 00:0b:6b:28:ca:a0, RTL8180vF + Philips
[   42.460518] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   43.893139] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   43.926115] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
[   44.412864] VIA 82xx Audio 0000:00:11.5: power state changed by ACPI to D0
[   44.412944] VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[LNKC] ->
GSI 9 (level, low) -> IRQ 9
[   44.413353] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
[   44.607562] CPUFREQ: Per core ondemand sysfs interface is
deprecated - up_threshold
[   44.607717] CPUFREQ: Per core ondemand sysfs interface is
deprecated - up_threshold
[   44.953573] VIA 82xx Modem 0000:00:11.6: power state changed by ACPI to D0
[   44.953723] VIA 82xx Modem 0000:00:11.6: PCI INT C -> Link[LNKC] ->
GSI 9 (level, low) -> IRQ 9
[   44.957486] VIA 82xx Modem 0000:00:11.6: setting latency timer to 64
[   50.844191] wlan0: deauthenticating from 00:19:5b:de:4c:e2 by local
choice (reason=3)
[   50.924161] wlan0: authenticate with 00:19:5b:de:4c:e2 (try 1)
[   50.925603] wlan0: authenticated
[   50.964054] wlan0: associate with 00:19:5b:de:4c:e2 (try 1)
[   51.004061] wlan0: RX AssocResp from 00:19:5b:de:4c:e2 (capab=0x431
status=0 aid=1)
[   51.004089] wlan0: associated
[   51.004622] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   51.331239] padlock: VIA PadLock not detected.
[   61.584049] wlan0: no IPv6 routers present
[  129.402265] wlan0: deauthenticating from 00:19:5b:de:4c:e2 by local
choice (reason=3)
[  129.489399] cfg80211: All devices are disconnected, going to
restore regulatory settings
[  129.489545] cfg80211: Restoring regulatory settings
[  129.489562] cfg80211: Calling CRDA to update world regulatory domain
[  146.569219] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  146.586051] sd 0:0:0:0: [sda] Stopping disk

Pauli
