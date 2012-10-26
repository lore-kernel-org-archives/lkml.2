Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2JZL5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:57:11 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62360 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab2JZL5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:57:05 -0400
Message-ID: <508A7A8A.7030908@suse.cz>
Date: Fri, 26 Oct 2012 13:56:58 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: jgarzik@pobox.com
CC: linux-ide@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: ata1: COMRESET failed
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/mixed;
 boundary="------------070200040404090508050709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070200040404090508050709
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Hello,

at every boot I'm seeing:

At 5th second:
ata1: link is slow to respond, please be patient (ready=0)

At 10th second:
ata1: COMRESET failed (errno=-16)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5


So that I have to wait 10 s for the disk to come up. I tried 3.4.15 and
3.6.3, both with the same result.

00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset
Family 6-port SATA Controller [AHCI mode] [8086:1e03] (rev 04)

Any ideas what is going on?

thanks,
-- 
js
suse labs

--------------070200040404090508050709
Content-Type: text/plain; charset=UTF-8;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci"

00:00.0 Host bridge [0600]: Intel Corporation 3rd Gen Core processor DRAM Controller [8086:0154] (rev 09)
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: agpgart-intel
00: 86 80 54 01 06 00 90 20 09 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 90 d1 fe 00 00 00 00 01 00 d1 fe 00 00 00 00
50: 11 02 00 00 11 00 00 00 07 00 90 df 01 00 00 db
60: 05 00 00 f8 00 00 00 00 01 80 d1 fe 00 00 00 00
70: 00 00 00 fe 00 00 00 00 00 0c 00 fe 7f 00 00 00
80: 10 11 11 11 11 11 11 00 1a 00 00 00 00 00 00 00
90: 01 00 00 00 01 00 00 00 01 00 50 1e 01 00 00 00
a0: 01 00 00 00 01 00 00 00 01 00 60 1e 01 00 00 00
b0: 01 00 a0 db 01 00 80 db 01 00 00 db 01 00 a0 df
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 09 00 0c 01 9b 61 00 e2 d0 00 e8 14 00 00 00 00
f0: 00 00 00 01 00 00 00 00 c8 0f 09 00 00 00 00 00

00:02.0 VGA compatible controller [0300]: Intel Corporation 3rd Gen Core processor Graphics Controller [8086:0166] (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 5000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee00018  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: i915
00: 86 80 66 01 07 04 90 00 09 00 00 03 00 00 00 00
10: 04 00 00 f0 00 00 00 00 0c 00 00 e0 00 00 00 00
20: 01 50 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00
40: 09 00 0c 01 9b 61 00 e2 d0 00 e8 14 00 00 00 00
50: 11 02 00 00 11 00 00 00 00 00 00 00 01 00 a0 db
60: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 01 00 18 00 e0 fe 00 00 00 00 00 00 00 00
a0: 00 00 00 00 13 00 06 03 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 a4 22 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 01 00 00 00 00 80 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 09 00 18 50 f5 da

00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at f2520000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
		Address: 00000000fee00338  Data: 0000
	Kernel driver in use: xhci_hcd
00: 86 80 31 1e 06 04 90 02 04 30 03 0c 00 00 00 00
10: 04 00 52 f2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 70 00 00 00 00 00 00 00 0b 01 00 00
40: fd 07 0e 80 39 c2 03 80 00 00 00 00 00 00 00 00
50: 17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 30 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 80 c2 c1 08 00 00 00 00 00 00 00 00 00 00 00
80: 05 00 87 00 38 03 e0 fe 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 8f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 02 00 04 00 00 00 00 00 00 00 00 00 00 00 00
d0: 0f 00 00 00 0f 00 00 00 0f 00 00 00 0f 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 87 0f 04 08 00 00 00 00

00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at f2535000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee003b8  Data: 0000
	Kernel driver in use: mei
00: 86 80 3a 1e 06 04 10 00 04 00 80 07 00 00 80 00
10: 04 50 53 f2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 45 02 00 1e 20 00 01 80 06 01 00 69 e0 0f 00 10
50: 01 8c 03 c8 08 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 05 00 81 00
90: b8 03 e0 fe 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 c0
c0: 92 40 ac 72 ed 68 05 d5 6d 06 98 b9 a5 3d 03 81
d0: 97 bf 26 f6 42 99 7f fe db 47 62 d0 db f8 9b f5
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:16.3 Serial controller [0700]: Intel Corporation 7 Series/C210 Series Chipset Family KT Controller [8086:1e3d] (rev 04) (prog-if 02 [16550])
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 50b0 [size=8]
	Region 1: Memory at f253c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: serial
00: 86 80 3d 1e 03 00 b0 00 04 02 00 07 00 00 00 00
10: b1 50 00 00 00 c0 53 f2 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 c8 00 00 00 00 00 00 00 07 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 23 00 08 00 00 00
d0: 05 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit Network Connection [8086:1502] (rev 04)
	Subsystem: Lenovo Device [17aa:21f3]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at f2500000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f253b000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 5080 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00378  Data: 0000
	Capabilities: [e0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: e1000e
00: 86 80 02 15 07 04 10 00 04 00 00 02 00 00 00 00
10: 00 00 50 f2 00 b0 53 f2 81 50 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 f3 21
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 22 c8 00 20 00 07
d0: 05 e0 81 00 78 03 e0 fe 00 00 00 00 00 00 00 00
e0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f253a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP+
	Kernel driver in use: ehci_hcd
00: 86 80 2d 1e 06 00 90 02 04 20 03 0c 00 00 00 00
10: 00 a0 53 f2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 a7 07 00 00 00 00 01 00 00 01 00 00 08 c0
70: 00 00 df 3f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 80 00 11 88 0c 93 30 0d 00 24 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 01 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 a4 12 80 7f
f0: 00 00 00 00 88 85 80 00 87 0f 04 08 08 17 5b 20

00:1b.0 Audio device [0403]: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller [8086:1e20] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 48
	Region 0: Memory at f2530000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee003f8  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=22
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel
00: 86 80 20 1e 06 04 10 00 04 00 03 04 10 00 00 00
10: 04 00 53 f2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 01 00 00 45 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 70 81 00 f8 03 e0 fe 00 00 00 00 00 00 00 00
70: 10 00 91 00 00 00 00 10 00 00 10 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 04 02 01 02 24 00 40 00 0c a3 82 10 00 33 02
d0: 00 0c a3 02 10 00 33 02 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 87 0f 04 08 00 00 00 00

00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 [8086:1e10] (rev c4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: f1d00000-f24fffff
	Prefetchable memory behind bridge: 00000000f0400000-00000000f0bfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Lenovo Device [17aa:21fa]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport
00: 86 80 10 1e 07 00 10 00 c4 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 40 40 00 00
20: d0 f1 40 f2 41 f0 b1 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 01
50: 42 00 11 70 60 b2 04 00 08 00 40 00 00 00 00 00
60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
70: 02 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 0d a0 00 00 aa 17 fa 21 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
e0: 00 3f 00 00 00 00 00 00 01 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 87 0f 04 08 00 00 00 00

00:1c.1 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 [8086:1e12] (rev c4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: f1c00000-f1cfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Lenovo Device [17aa:21fa]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport
00: 86 80 12 1e 07 00 10 00 c4 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f0 00 00 20
20: c0 f1 c0 f1 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 02 00 00
40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 02
50: 42 00 11 70 00 b2 0c 00 00 00 40 01 00 00 00 00
60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
70: 02 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 0d a0 00 00 aa 17 fa 21 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 01 02 0b 00 00 00 80 11 81 00 00 00 00
e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 87 0f 04 08 00 00 00 00

00:1c.2 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 [8086:1e14] (rev c4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=0b, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f1400000-f1bfffff
	Prefetchable memory behind bridge: 00000000f0c00000-00000000f13fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Lenovo Device [17aa:21fa]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport
00: 86 80 14 1e 07 00 10 00 c4 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 04 0b 00 30 30 00 00
20: 40 f1 b0 f1 c1 f0 31 f1 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 07 03 00 00
40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 03
50: 03 00 01 10 60 b2 14 00 08 00 00 00 00 00 00 00
60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
70: 02 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 0d a0 00 00 aa 17 fa 21 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 87 0f 04 08 00 00 00 00

00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f2539000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
00: 86 80 26 1e 06 00 90 02 04 20 03 0c 00 00 00 00
10: 00 90 53 f2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 47 06 00 00 00 00 01 00 00 01 00 00 08 c0
70: 00 00 df 3f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 80 00 11 88 0c 93 30 0d 00 24 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 0a 64 20 00 02 38 ca 14 04 30 c0 36
f0: 00 00 00 00 88 85 80 00 87 0f 04 08 08 17 5b 20

00:1f.0 ISA bridge [0601]: Intel Corporation QM77 Express Chipset LPC Controller [8086:1e55] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
00: 86 80 55 1e 07 00 10 02 04 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 04 00 00 80 00 00 00 01 05 00 00 10 00 00 00
50: f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 8b 8a 87 87 90 00 00 00 8b 8a 8a 8b f8 f0 00 00
70: 78 f0 78 f0 78 f0 78 f0 78 f0 78 f0 78 f0 78 f0
80: 10 00 0f 3f 01 16 7c 00 e1 15 0c 00 00 00 00 00
90: a1 06 0c 00 00 0f 00 00 00 00 00 00 00 00 00 00
a0: 14 0e a0 00 39 29 06 00 00 47 00 00 00 00 00 80
b0: 00 00 00 00 00 00 00 00 08 00 02 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 0f 00 00 00 67 45 00 00 c0 ff 00 00 08 00 00 00
e0: 09 00 0c 10 00 00 00 00 b3 02 e4 06 00 00 00 00
f0: 01 c0 d1 fe 00 00 00 00 87 0f 04 08 00 00 00 00

00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] [8086:1e03] (rev 04) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 42
	Region 0: I/O ports at 50a8 [size=8]
	Region 1: I/O ports at 50bc [size=4]
	Region 2: I/O ports at 50a0 [size=8]
	Region 3: I/O ports at 50b8 [size=4]
	Region 4: I/O ports at 5060 [size=32]
	Region 5: Memory at f2538000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee00318  Data: 0000
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci
00: 86 80 03 1e 07 04 b0 02 04 01 06 01 00 00 00 00
10: a9 50 00 00 bd 50 00 00 a1 50 00 00 b9 50 00 00
20: 61 50 00 00 00 80 53 f2 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 80 00 00 00 00 00 00 00 07 02 00 00
40: 00 80 00 80 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 a8 03 40 08 00 00 00 00 00 00 00 00 00 00 00
80: 05 70 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00
90: 60 2c 13 81 83 01 00 2c 08 42 5c 01 00 00 00 00
a0: e0 00 00 00 39 00 00 00 12 b0 10 00 48 00 00 00
b0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 87 0f 04 08 00 00 00 00

00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller [8086:1e22] (rev 04)
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f2534000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at efa0 [size=32]
	Kernel driver in use: i801_smbus
00: 86 80 22 1e 03 00 80 02 04 00 05 0c 00 00 00 00
10: 04 40 53 f2 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 ef 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 00 00 00 00 00 00 00 00 07 03 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 03 04 04 00 00 00 08 08 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 87 0f 04 08 00 00 00 00

02:00.0 System peripheral [0880]: Ricoh Co Ltd MMC/SD Host Controller [1180:e822] (rev 07) (prog-if 01)
	Subsystem: Lenovo Device [17aa:21fa]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f1d00000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [800 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: sdhci-pci
00: 80 11 22 e8 06 00 10 00 07 01 80 08 10 00 00 00
10: 00 00 d0 f1 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 60 61 82 01 00 00 00 00 00 00 00 00
50: 05 78 80 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 11 78 00 00 00 00 00 00
70: 01 00 00 00 00 00 00 00 01 80 03 fe 00 40 00 48
80: 10 00 01 00 c0 ff 90 05 10 28 09 00 11 ec 07 01
90: 42 01 11 10 00 00 00 00 c0 03 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
b0: 04 00 00 00 00 00 00 00 00 00 00 00 a0 00 00 00
c0: 00 30 00 00 00 01 00 05 00 00 00 87 00 98 00 00
d0: 00 00 00 00 20 40 00 00 33 00 00 00 20 00 11 d9
e0: b2 32 e8 21 73 80 00 00 40 00 00 00 00 00 00 00
f0: 30 00 fe 00 00 00 00 00 18 00 00 02 00 00 02 00

03:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6205 [8086:0085] (rev 34)
	Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN [8086:1311]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00398  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 60-67-20-ff-ff-81-4a-dc
	Kernel driver in use: iwlwifi
00: 86 80 85 00 06 00 10 00 34 00 80 02 10 00 00 00
10: 04 00 c0 f1 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 11 13
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 23 c8 00 00 00 0d
d0: 05 e0 81 00 98 03 e0 fe 00 00 00 00 00 00 00 00
e0: 10 00 01 00 c0 8e 00 10 10 08 19 00 11 ec 06 00
f0: 42 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00


--------------070200040404090508050709
Content-Type: text/plain; charset=UTF-8;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.15-2-desktop (geeko@buildhost) (gcc version 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEMPT Thu Oct 25 19:43:32 UTC 2012 (11dd65d)
[    0.000000] Command line: root=UUID=e7b4ee26-6ea3-4db2-8250-e66a8a5542e3 reboot=w commit=60 resume=/dev/sda2 ipv6.disable=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040004000 (usable)
[    0.000000]  BIOS-e820: 0000000040004000 - 0000000040005000 (reserved)
[    0.000000]  BIOS-e820: 0000000040005000 - 00000000d0680000 (usable)
[    0.000000]  BIOS-e820: 00000000d0680000 - 00000000dae9f000 (reserved)
[    0.000000]  BIOS-e820: 00000000dae9f000 - 00000000daf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000daf9f000 - 00000000dafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dafff000 - 00000000dfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011e600000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: LENOVO 23252SG/23252SG, BIOS G2ET33WW (1.13 ) 07/24/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x11e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask FE0000000 write-back
[    0.000000]   7 base 11F000000 mask FFF000000 uncachable
[    0.000000]   8 base 11E800000 mask FFF800000 uncachable
[    0.000000]   9 base 11E600000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] last_pfn = 0xd0680 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f0100] f0100
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000d0680000
[    0.000000]  0000000000 - 00d0600000 page 2M
[    0.000000]  00d0600000 - 00d0680000 page 4k
[    0.000000] kernel direct mapping tables up to d0680000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000011e600000
[    0.000000]  0100000000 - 011e600000 page 2M
[    0.000000] kernel direct mapping tables up to 11e600000 @ d067a000-d0680000
[    0.000000] RAMDISK: 7f435000 - 7fff3000
[    0.000000] ACPI: RSDP 00000000000f0120 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe170 000BC (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: FACP 00000000dafe5000 000F4 (v04 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafe8000 102C8 (v01 LENOVO TP-G2    00001130 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf5a000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 LENOVO TP-G2    00001130 PTL  00000001)
[    0.000000] ACPI: TCPA 00000000daffc000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000daffb000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daff9000 007A8 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe4000 00038 (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe3000 00098 (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe2000 0003C (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe1000 00052 (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: FPDT 00000000dafe0000 00054 (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafe7000 000A5 (v32 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafdf000 0003E (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafde000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: POAT 00000000dafdd000 00055 (v03 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000dafdc000 00C79 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafdb000 00A7E (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafda000 000B8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafd9000 002A6 (v01 LENOVO TP-G2    00001130 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000011e600000
[    0.000000] Initmem setup node 0 0000000000000000-000000011e600000
[    0.000000]   NODE_DATA [000000011e5ec000 - 000000011e5fffff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880119e00000-ffff88011d5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0011e600
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040004
[    0.000000]     0: 0x00040005 -> 0x000d0680
[    0.000000]     0: 0x00100000 -> 0x0011e600
[    0.000000] On node 0 totalpages: 977420
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 834743 pages, LIFO batch:31
[    0.000000]   Normal zone: 1701 pages used for memmap
[    0.000000]   Normal zone: 122715 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
[    0.000000] PM: Registered nosave memory: 00000000d0680000 - 00000000dae9f000
[    0.000000] PM: Registered nosave memory: 00000000dae9f000 - 00000000daf9f000
[    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
[    0.000000] PM: Registered nosave memory: 00000000dafff000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
[    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
[    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dfa00000 (gap: dfa00000:18600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88011e200000 s80256 r8192 d22144 u262144
[    0.000000] pcpu-alloc: s80256 r8192 d22144 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 961378
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=e7b4ee26-6ea3-4db2-8250-e66a8a5542e3 reboot=w commit=60 resume=/dev/sda2 ipv6.disable=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3759244k/4691968k available (5731k kernel code, 782288k absent, 150436k reserved, 5203k data, 944k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2594.001 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5188.00 BogoMIPS (lpj=2594001)
[    0.000151] pid_max: default: 32768 minimum: 301
[    0.000247] Security Framework initialized
[    0.000332] AppArmor: AppArmor initialized
[    0.000603] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001541] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002007] Mount-cache hash table entries: 256
[    0.002200] Initializing cgroup subsys cpuacct
[    0.002275] Initializing cgroup subsys memory
[    0.002356] Initializing cgroup subsys devices
[    0.002432] Initializing cgroup subsys freezer
[    0.002506] Initializing cgroup subsys net_cls
[    0.002578] Initializing cgroup subsys blkio
[    0.002654] Initializing cgroup subsys perf_event
[    0.002746] CPU: Physical Processor ID: 0
[    0.002822] CPU: Processor Core ID: 0
[    0.003193] mce: CPU supports 7 MCE banks
[    0.003275] CPU0: Thermal LVT vector (0xfa) already installed
[    0.003280] using mwait in idle threads.
[    0.004042] ACPI: Core revision 20120320
[    0.010035] DMAR: Host address width 36
[    0.010131] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.010229] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.010372] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.010470] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.010612] DMAR: RMRR base: 0x000000da2f0000 end: 0x000000da306fff
[    0.010708] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.010881] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.010977] HPET id 0 under DRHD base 0xfed91000
[    0.011245] Enabled IRQ remapping in x2apic mode
[    0.011790] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023060] CPU0: Intel(R) Core(TM) i5-3320M CPU @ 2.60GHz stepping 09
[    0.124628] Performance Events: PEBS fmt1+, generic architected perfmon, Intel PMU driver.
[    0.124897] ... version:                3
[    0.124990] ... bit width:              48
[    0.125082] ... generic registers:      4
[    0.125176] ... value mask:             0000ffffffffffff
[    0.125272] ... max period:             000000007fffffff
[    0.125368] ... fixed-purpose events:   3
[    0.125461] ... event mask:             000000070000000f
[    0.132764] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.138619] Booting Node   0, Processors  #1
[    0.150034] CPU1: Thermal LVT vector (0xfa) already installed
[    0.152144] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.155591]  #2
[    0.166958] CPU2: Thermal LVT vector (0xfa) already installed
[    0.169066] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.172557]  #3
[    0.183918] CPU3: Thermal LVT vector (0xfa) already installed
[    0.186025] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.186236] Brought up 4 CPUs
[    0.186330] Total of 4 processors activated (20752.00 BogoMIPS).
[    0.188943] devtmpfs: initialized
[    0.189716] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.189931] RTC time: 13:44:53, date: 10/26/12
[    0.190059] NET: Registered protocol family 16
[    0.190287] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.190432] ACPI: bus type pci registered
[    0.190689] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.190836] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.198609] PCI: Using configuration type 1 for base access
[    0.199296] bio: create slab <bio-0> at 0
[    0.199456] ACPI: Added _OSI(Module Device)
[    0.199555] ACPI: Added _OSI(Processor Device)
[    0.199647] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.199742] ACPI: Added _OSI(Processor Aggregator Device)
[    0.201132] ACPI: EC: EC description table is found, configuring boot EC
[    0.205054] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.207557] ACPI: SSDT 00000000dae3a018 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.208139] ACPI: Dynamic OEM Table Load:
[    0.208318] ACPI: SSDT           (null) 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.208778] ACPI: SSDT 00000000dae3ba98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.209393] ACPI: Dynamic OEM Table Load:
[    0.209578] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.209906] ACPI: SSDT 00000000dae39d98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.210480] ACPI: Dynamic OEM Table Load:
[    0.210659] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.211439] ACPI: Interpreter enabled
[    0.211540] ACPI: (supports S0 S3 S4 S5)
[    0.211821] ACPI: Using IOAPIC for interrupt routing
[    0.214073] ACPI: Power Resource [PUBS] (on)
[    0.216876] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.218083] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.218184] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.218394] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.218512] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.218614] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.218710] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.218852] pci_root PNP0A08:00: host bridge window [mem 0xdfa00000-0xfebfffff]
[    0.218994] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    0.219155] PCI host bridge to bus 0000:00
[    0.219250] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.219347] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.219447] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.219545] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.219642] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.219745] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.219778] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.219786] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.219790] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.219794] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.219840] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.219860] pci 0000:00:14.0: reg 10: [mem 0xf2520000-0xf252ffff 64bit]
[    0.219926] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.219948] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.219969] pci 0000:00:16.0: reg 10: [mem 0xf2535000-0xf253500f 64bit]
[    0.220041] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.220063] pci 0000:00:16.3: [8086:1e3d] type 00 class 0x070002
[    0.220080] pci 0000:00:16.3: reg 10: [io  0x50b0-0x50b7]
[    0.220089] pci 0000:00:16.3: reg 14: [mem 0xf253c000-0xf253cfff]
[    0.220181] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.220197] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.220206] pci 0000:00:19.0: reg 14: [mem 0xf253b000-0xf253bfff]
[    0.220214] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.220271] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.220297] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.220316] pci 0000:00:1a.0: reg 10: [mem 0xf253a000-0xf253a3ff]
[    0.220401] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.220426] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.220442] pci 0000:00:1b.0: reg 10: [mem 0xf2530000-0xf2533fff 64bit]
[    0.220504] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.220530] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.220661] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.220699] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.220829] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.220867] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.220995] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.221037] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.221056] pci 0000:00:1d.0: reg 10: [mem 0xf2539000-0xf25393ff]
[    0.221140] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.221164] pci 0000:00:1f.0: [8086:1e55] type 00 class 0x060100
[    0.221281] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.221297] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.221305] pci 0000:00:1f.2: reg 14: [io  0x50bc-0x50bf]
[    0.221311] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.221319] pci 0000:00:1f.2: reg 1c: [io  0x50b8-0x50bb]
[    0.221326] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.221333] pci 0000:00:1f.2: reg 24: [mem 0xf2538000-0xf25387ff]
[    0.221374] pci 0000:00:1f.2: PME# supported from D3hot
[    0.221391] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.221405] pci 0000:00:1f.3: reg 10: [mem 0xf2534000-0xf25340ff 64bit]
[    0.221424] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.221731] pci 0000:02:00.0: [1180:e822] type 00 class 0x088001
[    0.221757] pci 0000:02:00.0: reg 10: [mem 0xf1d00000-0xf1d000ff]
[    0.221957] pci 0000:02:00.0: supports D1 D2
[    0.221959] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.223662] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.223761] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.223766] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.223774] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.224000] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.224165] pci 0000:03:00.0: reg 10: [mem 0xf1c00000-0xf1c01fff 64bit]
[    0.224887] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.226561] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.226664] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
[    0.226742] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.226841] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.226845] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.226853] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.226878] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.226951] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.226977] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.226997] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.227085]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.227277]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.227425] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.229348] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.230040] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.230725] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.231415] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.232097] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.232781] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.233474] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.234153] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.234848] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.234996] vgaarb: loaded
[    0.235087] vgaarb: bridge control possible 0000:00:02.0
[    0.235259] SCSI subsystem initialized
[    0.235380] libata version 3.00 loaded.
[    0.235407] usbcore: registered new interface driver usbfs
[    0.235511] usbcore: registered new interface driver hub
[    0.235619] usbcore: registered new device driver usb
[    0.235748] PCI: Using ACPI for IRQ routing
[    0.237460] PCI: pci_cache_line_size set to 64 bytes
[    0.237898] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.237899] reserve RAM buffer: 0000000040004000 - 0000000043ffffff 
[    0.237901] reserve RAM buffer: 00000000d0680000 - 00000000d3ffffff 
[    0.237902] reserve RAM buffer: 000000011e600000 - 000000011fffffff 
[    0.237961] NetLabel: Initializing
[    0.238056] NetLabel:  domain hash size = 128
[    0.238150] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.238250] NetLabel:  unlabeled traffic allowed by default
[    0.238365] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.238836] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.240940] Switching to clocksource hpet
[    0.242490] AppArmor: AppArmor Filesystem Enabled
[    0.242602] pnp: PnP ACPI init
[    0.242699] ACPI: bus type pnp registered
[    0.243137] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.243138] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.243139] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.243140] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.243142] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.243143] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.243144] pnp 00:00: [mem 0x000d4000-0x000d7fff]
[    0.243145] pnp 00:00: [mem 0x000d8000-0x000dbfff]
[    0.243146] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.243147] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.243148] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.243149] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.243150] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.243151] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.243153] pnp 00:00: [mem 0x00100000-0xdf9fffff]
[    0.243154] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.243155] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.243188] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.243289] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.243386] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.243484] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.243580] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.243677] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.243774] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.243872] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.243970] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.244075] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.244175] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.244273] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.244370] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.244468] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.244565] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.244664] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.244762] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.244860] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.244875] pnp 00:01: [bus 00-3f]
[    0.244877] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.244878] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.244879] pnp 00:01: [io  0x0d00-0xffff window]
[    0.244880] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.244881] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.244883] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.244884] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.244885] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.244886] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.244887] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.244889] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.244891] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.244892] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.244893] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.244894] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.244895] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.244896] pnp 00:01: [mem 0xdfa00000-0xfebfffff window]
[    0.244898] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.244931] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.244981] pnp 00:02: [io  0x0010-0x001f]
[    0.244983] pnp 00:02: [io  0x0090-0x009f]
[    0.244984] pnp 00:02: [io  0x0024-0x0025]
[    0.244985] pnp 00:02: [io  0x0028-0x0029]
[    0.244986] pnp 00:02: [io  0x002c-0x002d]
[    0.244987] pnp 00:02: [io  0x0030-0x0031]
[    0.244988] pnp 00:02: [io  0x0034-0x0035]
[    0.244989] pnp 00:02: [io  0x0038-0x0039]
[    0.244990] pnp 00:02: [io  0x003c-0x003d]
[    0.244991] pnp 00:02: [io  0x00a4-0x00a5]
[    0.244992] pnp 00:02: [io  0x00a8-0x00a9]
[    0.244993] pnp 00:02: [io  0x00ac-0x00ad]
[    0.244994] pnp 00:02: [io  0x00b0-0x00b5]
[    0.244995] pnp 00:02: [io  0x00b8-0x00b9]
[    0.244996] pnp 00:02: [io  0x00bc-0x00bd]
[    0.244997] pnp 00:02: [io  0x0050-0x0053]
[    0.244998] pnp 00:02: [io  0x0072-0x0077]
[    0.244999] pnp 00:02: [io  0x0400-0x047f]
[    0.245000] pnp 00:02: [io  0x0500-0x057f]
[    0.245001] pnp 00:02: [io  0x0800-0x080f]
[    0.245002] pnp 00:02: [io  0x15e0-0x15ef]
[    0.245003] pnp 00:02: [io  0x1600-0x167f]
[    0.245004] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    0.245006] pnp 00:02: [mem 0xfffff000-0xffffffff]
[    0.245007] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.245008] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.245009] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.245010] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.245011] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.245044] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.245150] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.245246] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.245343] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.245441] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.245537] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.245634] system 00:02: [mem 0xfffff000-0xffffffff] has been reserved
[    0.245732] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.245829] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.245927] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.246024] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.246127] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.246226] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.246260] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.246278] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.246285] pnp 00:04: [io  0x0000-0x000f]
[    0.246286] pnp 00:04: [io  0x0080-0x008f]
[    0.246287] pnp 00:04: [io  0x00c0-0x00df]
[    0.246289] pnp 00:04: [dma 4]
[    0.246302] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.246308] pnp 00:05: [io  0x0061]
[    0.246322] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.246328] pnp 00:06: [io  0x00f0]
[    0.246341] pnp 00:06: [irq 13]
[    0.246356] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.246361] pnp 00:07: [io  0x0070-0x0071]
[    0.246370] pnp 00:07: [irq 8]
[    0.246385] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.246391] pnp 00:08: [io  0x0060]
[    0.246392] pnp 00:08: [io  0x0064]
[    0.246400] pnp 00:08: [irq 1]
[    0.246415] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.246428] pnp 00:09: [irq 12]
[    0.246443] pnp 00:09: Plug and Play ACPI device, IDs LEN0020 PNP0f13 (active)
[    0.246471] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.246488] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.246894] pnp: PnP ACPI: found 11 devices
[    0.246991] ACPI: ACPI bus type pnp unregistered
[    0.253326] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.253426] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.253527] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.253628] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.253777] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.253876] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
[    0.253982] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.254084] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.254186] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.254286] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.254465] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.254466] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.254468] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.254469] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.254470] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.254472] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.254473] pci_bus 0000:02: resource 1 [mem 0xf1d00000-0xf24fffff]
[    0.254474] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.254476] pci_bus 0000:03: resource 1 [mem 0xf1c00000-0xf1cfffff]
[    0.254477] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.254478] pci_bus 0000:04: resource 1 [mem 0xf1400000-0xf1bfffff]
[    0.254479] pci_bus 0000:04: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.254546] NET: Registered protocol family 2
[    0.254727] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.255384] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.256991] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.257289] TCP: Hash tables configured (established 524288 bind 65536)
[    0.257388] TCP: reno registered
[    0.257486] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.257599] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.257800] NET: Registered protocol family 1
[    0.257904] pci 0000:00:02.0: Boot video device
[    0.257916] pci 0000:00:14.0: power state changed by ACPI to D0
[    0.258017] pci 0000:00:14.0: power state changed by ACPI to D0
[    0.258190] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.258287] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.258422] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.258519] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.258824] PCI: CLS 64 bytes, default 64
[    0.258853] Unpacking initramfs...
[    0.396931] Freeing initrd memory: 12024k freed
[    0.399468] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.399574] Placing 64MB software IO TLB between ffff8800cc67a000 - ffff8800d067a000
[    0.399716] software IO TLB at phys 0xcc67a000 - 0xd067a000
[    0.400320] audit: initializing netlink socket (disabled)
[    0.400428] type=2000 audit(1351259093.293:1): initialized
[    0.413476] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.414032] VFS: Disk quotas dquot_6.5.2
[    0.414150] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.414500] msgmni has been set to 7365
[    0.414737] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.414934] io scheduler noop registered
[    0.415027] io scheduler deadline registered
[    0.415139] io scheduler cfq registered (default)
[    0.415542] intel_idle: does not run on family 6 model 58
[    0.415561] GHES: HEST is not enabled!
[    0.415685] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.436467] 0000:00:16.3: ttyS4 at I/O 0x50b0 (irq = 19) is a 16550A
[    0.436735] Non-volatile memory driver v1.3
[    0.436831] Linux agpgart interface v0.103
[    0.436970] agpgart-intel 0000:00:00.0: Intel Ivybridge Chipset
[    0.437151] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.438102] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.438293] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.438466] ahci 0000:00:1f.2: version 3.0
[    0.438517] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    0.438539] ahci: SSS flag set, parallel bus scan disabled
[    0.448712] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
[    0.448870] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs apst 
[    0.449016] ahci 0000:00:1f.2: setting latency timer to 64
[    0.452973] scsi0 : ahci
[    0.453135] scsi1 : ahci
[    0.453267] scsi2 : ahci
[    0.453400] scsi3 : ahci
[    0.453535] scsi4 : ahci
[    0.453679] scsi5 : ahci
[    0.454371] ata1: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538100 irq 42
[    0.454513] ata2: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538180 irq 42
[    0.454653] ata3: DUMMY
[    0.454751] ata4: DUMMY
[    0.454841] ata5: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538300 irq 42
[    0.454983] ata6: DUMMY
[    0.455106] Fixed MDIO Bus: probed
[    0.455274] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.455381] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.455479] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.455591] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.455594] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.455710] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.455872] ehci_hcd 0000:00:1a.0: debug port 2
[    0.459841] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.459851] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf253a000
[    0.465659] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.465787] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.465885] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.466027] usb usb1: Product: EHCI Host Controller
[    0.466121] usb usb1: Manufacturer: Linux 3.4.15-2-desktop ehci_hcd
[    0.466217] usb usb1: SerialNumber: 0000:00:1a.0
[    0.466377] hub 1-0:1.0: USB hub found
[    0.466474] hub 1-0:1.0: 3 ports detected
[    0.466609] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.466715] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.466825] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.466827] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.466925] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.467085] ehci_hcd 0000:00:1d.0: debug port 2
[    0.471049] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.471058] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf2539000
[    0.476637] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.476760] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.476859] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.476999] usb usb2: Product: EHCI Host Controller
[    0.477094] usb usb2: Manufacturer: Linux 3.4.15-2-desktop ehci_hcd
[    0.477191] usb usb2: SerialNumber: 0000:00:1d.0
[    0.477337] hub 2-0:1.0: USB hub found
[    0.477433] hub 2-0:1.0: 3 ports detected
[    0.477560] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.477671] uhci_hcd: USB Universal Host Controller Interface driver
[    0.477803] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.479532] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.479637] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.479808] mousedev: PS/2 mouse device common for all mice
[    0.479967] rtc_cmos 00:07: RTC can wake from S4
[    0.480183] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.480311] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.480412] cpuidle: using governor ladder
[    0.480504] cpuidle: using governor menu
[    0.480597] EFI Variables Facility v0.08 2004-May-17
[    0.480795] usbcore: registered new interface driver usbhid
[    0.480892] usbhid: USB HID core driver
[    0.481086] TCP: cubic registered
[    0.481181] IPv6: Loaded, but administratively disabled, reboot required to enable
[    0.481327] lib80211: common routines for IEEE802.11 drivers
[    0.481424] lib80211_crypt: registered algorithm 'NULL'
[    0.481426] Registering the dns_resolver key type
[    0.481673] PM: Checking hibernation image partition /dev/sda2
[    0.482342] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.767101] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    0.881199] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    0.881316] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.881607] hub 1-1:1.0: USB hub found
[    0.881820] hub 1-1:1.0: 6 ports detected
[    0.984677] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.098786] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.098900] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.099193] hub 2-1:1.0: USB hub found
[    1.099411] hub 2-1:1.0: 8 ports detected
[    1.173405] usb 1-1.3: new full-speed USB device number 3 using ehci_hcd
[    1.235561] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd002a3/0x940300/0x123800
[    1.235726] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    1.259361] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2020
[    1.259475] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.259610] usb 1-1.3: Product: Biometric Coprocessor
[    1.259700] usb 1-1.3: Manufacturer: Auth
[    1.270054] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input1
[    1.333102] usb 1-1.4: new full-speed USB device number 4 using ehci_hcd
[    1.399903] Refined TSC clocksource calibration: 2594.115 MHz.
[    1.400017] Switching to clocksource tsc
[    1.421302] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=21e6
[    1.421417] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.421553] usb 1-1.4: Product: BCM20702A0
[    1.421648] usb 1-1.4: Manufacturer: Broadcom Corp
[    1.421736] usb 1-1.4: SerialNumber: 083E8EE1B689
[    1.494790] usb 1-1.6: new high-speed USB device number 5 using ehci_hcd
[    1.586991] usb 1-1.6: New USB device found, idVendor=5986, idProduct=02d2
[    1.587106] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.587241] usb 1-1.6: Product: Integrated Camera
[    1.587332] usb 1-1.6: Manufacturer: Ricoh Company Ltd.
[    5.798635] ata1: link is slow to respond, please be patient (ready=0)
[    6.071518] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    6.261069] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input2
[   10.481848] ata1: COMRESET failed (errno=-16)
[   10.786279] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   10.786710] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   10.786715] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   10.787088] ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
[   10.787210] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   10.787643] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   10.787648] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   10.788019] ata1.00: configured for UDMA/133
[   10.788287] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
[   10.788529] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[   10.788719] sd 0:0:0:0: [sda] Write Protect is off
[   10.788815] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.788829] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.789460]  sda: sda1 sda2 sda3
[   10.789763] sd 0:0:0:0: [sda] Attached SCSI disk
[   11.094699] ata2: SATA link down (SStatus 0 SControl 300)
[   11.401123] ata5: SATA link down (SStatus 0 SControl 300)

--------------070200040404090508050709--
