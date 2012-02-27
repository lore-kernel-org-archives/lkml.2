Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2B0MnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:43:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2B0Mm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:42:57 -0500
Date: Mon, 27 Feb 2012 13:42:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>
Subject: hibernate random memory corruption, workaround i915.modeset=0
Message-ID: <20120227124243.GG4104@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi.

I'm able to reproduce random memory corruption after hibernate.
Corruption is not reproducible when I disable mode setting, what
seems to blame i915 driver or generic DRM kernel code.

I'm able to reproduce bug on Fedora 11 with 2.6.30 kernel (first
fedora with KMS support) and on the latest 3.3-rc kernels. So this
issue is there from very beginning, hence it is not bisectable.

I'm attaching script to reproduce (with accompanying memory checker
program). Script is basically sequence of hibernate - reset - check
memory. Kernel should be compiled with CONFIG_DEBUG_SLAB to detect
poison/redzone overwrites.
 
I already tried to debug this using CONFIG_DEBUG_PAGEALLOC and new
kernel option debug_guardpage_minorder, but without any success.
Seems corruption happen behind CPU MMU, i.e. is DMA unit programming
bug. I'm not able to turn on IOMMU on that hardware.

This happen on T500 laptop with, lspci output attached.

I'm attaching also dmesg's with poison/redzone overwrites from
3.3-rc4 and 2.6.30 kernels.

Some more information can be found on:
https://bugzilla.redhat.com/show_bug.cgi?id=746169
https://bugzilla.redhat.com/show_bug.cgi?id=701857

i.e there is invalid DMA address warning that could be a good hint:
https://bugzilla.redhat.com/show_bug.cgi?id=746169#c7

I would appreciate any help with solving this issue. I think many
people are hitting this, but since corruption happens at random,
not many people notice it, or when notice, did not find out that
this could be i915/DRM issue.

Thanks
Stanislaw

--W/nzBZO5zC0uMSeA
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="hib_corruption_reproducer.tar.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWblvNM4AA9j/hMiwAQB////fv+/eX//v//4AAgAIUAWsCNtpsto80DlLbIZE
QTCGTTRJ4aU2moeUHppkmanqDQ8U9IAeTU9Q9QMUaBT0Kn6Uae1HqRtTIAGjaJhBpkAAABoB
IiJBpqaZTaR6mTagYgGmgAAADRoMQAcaGgaNMjTRpkBiYIAAaA0BpkBgTIEkiZBMSep4jVPC
DSHpBk0ANAAADQAGm07NNnkF3/OmEKCQ+CSEQklocoCoTReobTdIDxWPIoBKVKtSOc0ENMab
TGMGl/YjZagTGNNoaYDGMabENptttNjBpjTTGmxtqbxT+WQmfXQ6UdCD6smpXYmSjimbWquJ
rFi19LepWxk4fe4qWDKmnWkwN4qxSlsQ6EDWzF6YxNZXDmYWHfip83oZxP1diLGYdJ0B5uzr
6VAvtu/ECmwCTSrCprLTVepf1OJfra3rM7GPtrq3jCcN3uvjbgrwiKkBAUuooUC7iY0IIl33
LIbB6DUQIlhHgNa+dFKAI+kF07sBDCN8jAq1bVO3wcUOdfej6q8rZa+HhiimtwB4SIIP4J7n
iIvXoBcghXitJ8EKFchIQMlbCxUtNuCf5HOmxwXUDZqiWNt8elcF+dd6Anydrhtz9s7l4cjr
I+WRttbn+6cQ1dQPyDCGG6PWfaYYNXd0b+ixHMW0pofeCSiJgc5g5nq0FzkiU1TC1gDbHlCl
AyP06s4WiaIaEEhsG6z5c2tTvTlhqhVr07NzSpIXZdRMGfY2lqLlIZ0ZAXekiWWErJJJI1A6
tPonZHeTQsOFMtujyMqCTpegQTYtbsdOOZt9o7L4BnOBpYADkyZwfoheHhClSNhv+o0oDCmR
5B7Mq/0Ia4IFrTBdeuU+2/FIUQzA1HrxqEY7KFptBDmAyiWkpQYdgUjANe+1MymibXl1DA5I
PakL4AuUz2RxAZ/h3DlGuJPMneNtnO6JD0Q5GzZm815eG86XmaYWURiOBU02htHHYbMa5JMk
Qw3OEukNJwDLXzEMHz5d043ZszIAi9zdvUPzwMbLKvwnl3zlzfw52lpy4R+h19hJLD2xe+de
TI3sPpCyiQw1QJYjLDWLQdoOTt+MzgdffiYGWJmBXXANBjHYBjPrv9uNL+EaBc6GAc79ar7j
qAt4ygkGo1suIsFYQz4Z+IEEQErXrIyAda1Swx8wdAScOPETKDCWJSy7ECEZ9PEVSPaxQFn1
2oCzTsVpqQzesL5f0ovJGbETiNlFL4HXVBPElaqsHjOeYqLLJka+LHNXOJwM5J4SPMQbCdFD
FYZjlLab0P0xkpBMHs45lJSxpMXG7nkRlaLSXxvtOhThi+zTJZys28QaU8RYEUTP7EdN9CIt
sFtgfi3AWFSe9ywMzXRoRLO7d0A5D2U1JnpRWEkHiYjIlAyMlpRtg9f5gsfzuR/koMOeEkwT
hZFGyMky4V3FLo1AYI1BeKei4RllDgChRk1dtEyngMzNjM7xmezswt6hA4p0hStbMDhMZaH7
ABbaZeOAPxyDsj1NIS7dKHLhxQgDkrAmaWQGJTdNUyMgPx5nM1RGfMSRa6rHmMj7MEurg/wq
lGr8QLPYtsJCiMRhyjYWIsHDqqsVsBLJQGJGcOSonULVdi6KMj9DSgTIyjtrAT9xg3yy4mKk
XMqqUOZ3GNvbrlcrFjNUVMm4429q5aMGRDkzjjkDTTUhk5kThtK3t3N0VYi2od4aLhZy3KxM
bGiU0WCrcsYpMLuLXjOSCpusKQ3GZ0lfBClSBeFy+VZETyTL+3CeAkVkmcT/TWZFQhNUpRoR
NVg45kYoDTwjFXBZWBxmNdRiwTAjKjYnkoOXcLJmdaVm7G2wwTjHi36ZCCCoTrr3ZSoXMV9y
GKFQ1pk1hWRFso8GegOsriG0yYGLidEpoZk6vl7ww0QKiyFqReK+A+sD90u1REQJw55SQv+L
uSKcKEhct5pnAA==

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci.txt"

00:00.0 Host bridge [0600]: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub [8086:2a40] (rev 07)
	Subsystem: Lenovo Device [17aa:20e0]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a42] (rev 07) (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device [17aa:20e4]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 29
	Region 0: Memory at f4400000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Mask- 64bit- Count=1/1 Enable+
		Address: fee0200c  Data: 41b1
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a43] (rev 07)
	Subsystem: Lenovo Device [17aa:20e4]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f4200000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller [0780]: Intel Corporation Mobile 4 Series Chipset MEI Controller [8086:2a44] (rev 07)
	Subsystem: Lenovo Device [17aa:20e6]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fc226800 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000

00:03.2 IDE interface [0101]: Intel Corporation Mobile 4 Series Chipset PT IDER Controller [8086:2a46] (rev 07) (prog-if 85 [Master SecO PriO])
	Subsystem: Lenovo Device [17aa:20ea]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: I/O ports at 1828 [size=8]
	Region 1: I/O ports at 180c [size=4]
	Region 2: I/O ports at 1820 [size=8]
	Region 3: I/O ports at 1808 [size=4]
	Region 4: I/O ports at 1810 [size=16]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel modules: ata_generic, pata_acpi

00:03.3 Serial controller [0700]: Intel Corporation Mobile 4 Series Chipset AMT SOL Redirection [8086:2a47] (rev 07) (prog-if 02 [16550])
	Subsystem: Lenovo Device [17aa:20ec]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 1830 [size=8]
	Region 1: Memory at fc024000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: serial

00:19.0 Ethernet controller [0200]: Intel Corporation 82567LM Gigabit Network Connection [8086:10f5] (rev 03)
	Subsystem: Lenovo Device [17aa:20ee]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 30
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at fc025000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1840 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Mask- 64bit+ Count=1/1 Enable+
		Address: 00000000fee0200c  Data: 41d1
	Capabilities: [e0] PCIe advanced features <?>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 [8086:2937] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device [17aa:20f0]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1860 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 [8086:2938] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device [17aa:20f0]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1880 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 [8086:2939] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device [17aa:20f0]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 4: I/O ports at 18a0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 [8086:293c] (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:20f1]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at fc226c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Audio Controller [8086:293e] (rev 03)
	Subsystem: Lenovo Device [17aa:20f2]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fc020000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 [8086:2940] (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Mask- 64bit- Count=1/1 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Lenovo Device [17aa:20f3]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.1 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 [8086:2942] (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: f4300000-f43fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  1, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Mask- 64bit- Count=1/1 Enable+
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Lenovo Device [17aa:20f3]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.3 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 [8086:2946] (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f8000000-f9ffffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f40fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Mask- 64bit- Count=1/1 Enable+
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Lenovo Device [17aa:20f3]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.4 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 [8086:2948] (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fa000000-fbffffff
	Prefetchable memory behind bridge: 00000000f4100000-00000000f41fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  4, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Mask- 64bit- Count=1/1 Enable+
		Address: fee0300c  Data: 4181
	Capabilities: [90] Subsystem: Lenovo Device [17aa:20f3]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 [8086:2934] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device [17aa:20f0]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18c0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 [8086:2935] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device [17aa:20f0]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 18e0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 [8086:2936] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device [17aa:20f0]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1c00 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 [8086:293a] (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device [17aa:20f1]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fc227000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
	I/O behind bridge: 00004000-00007fff
	Memory behind bridge: f4800000-f7ffffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f3ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Lenovo Device [17aa:20f4]

00:1f.0 ISA bridge [0601]: Intel Corporation ICH9M-E LPC Interface Controller [8086:2917] (rev 03)
	Subsystem: Lenovo Device [17aa:20f5]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller [0106]: Intel Corporation ICH9M/M-E SATA AHCI Controller [8086:2929] (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device [17aa:20f8]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 28
	Region 0: I/O ports at 1c48 [size=8]
	Region 1: I/O ports at 183c [size=4]
	Region 2: I/O ports at 1c40 [size=8]
	Region 3: I/O ports at 1838 [size=4]
	Region 4: I/O ports at 1c20 [size=32]
	Region 5: Memory at fc226000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Mask- 64bit- Count=1/16 Enable+
		Address: fee0100c  Data: 4191
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus Controller [8086:2930] (rev 03)
	Subsystem: Lenovo Device [17aa:20f9]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fc227400 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c60 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

03:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection [8086:4237]
	Subsystem: Intel Corporation Device [8086:1211]
	Physical Slot: 1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Mask- 64bit+ Count=1/1 Enable+
		Address: 00000000fee0300c  Data: 41c1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 70-3b-fe-ff-ff-fa-22-00
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

15:00.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev ba)
	Subsystem: Lenovo Device [17aa:20c6]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f4800000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
	Memory window 0: f0000000-f3fff000 (prefetchable)
	Memory window 1: 80000000-83fff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

15:00.1 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394 Controller [1180:0832] (rev 04) (prog-if 10 [OHCI])
	Subsystem: Lenovo Device [17aa:20c7]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at f4801000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME+
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

15:00.2 SD Host controller [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter [1180:0822] (rev 21)
	Subsystem: Lenovo Device [17aa:20c8]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f4801800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci

15:00.3 System peripheral [0880]: Ricoh Co Ltd R5C843 MMC Host Controller [1180:0843] (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: ricoh-mmc
	Kernel modules: ricoh_mmc

15:00.4 System peripheral [0880]: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter [1180:0592] (rev 11)
	Subsystem: Lenovo ThinkPad T61 [17aa:20ca]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4802000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

15:00.5 System peripheral [0880]: Ricoh Co Ltd xD-Picture Card Controller [1180:0852] (rev 11)
	Subsystem: Lenovo Device [17aa:20cb]
	Physical Slot: 1-1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f4802400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="2.6.30_corruption.txt"
Content-Transfer-Encoding: quoted-printable

 groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: disassociating by local choice (reason=3D3)
wlan0: direct probe to AP 54:e6:fc:98:63:fe try 1
wlan0: deauthenticating by local choice (reason=3D3)
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08done (42574 pages freed)
PM: Freed 170296 kbytes in 5.93 seconds (28.71 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125990 pages
PM: Normal pages needed: 125990 + 1024 + 38, available pages: 383456
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.04 BogoMIPS (lpj=3D27=
93022)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 02:24:8c:7f:51:0a try 1
wlan0: direct probe to AP 02:24:8c:7f:51:0a try 2
wlan0 direct probe responded
wlan0: authenticate with AP 02:24:8c:7f:51:0a
wlan0: authenticated
wlan0: associate with AP 02:24:8c:7f:51:0a
wlan0: associate with AP 02:24:8c:7f:51:0a
wlan0: RX AssocResp from 02:24:8c:7f:51:0a (capab=3D0x401 status=3D0 aid=3D=
1)
wlan0: associated
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: disassociating by local choice (reason=3D3)
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: direct probe to AP 54:e6:fc:98:63:fe try 1
wlan0 direct probe responded
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
wlan0: deauthenticating by local choice (reason=3D3)
wlan0: No STA entry for own AP 54:e6:fc:98:63:fe
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08done (7=
5567 pages freed)
PM: Freed 302268 kbytes in 11.38 seconds (26.56 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 126288 pages
PM: Normal pages needed: 126288 + 1024 + 38, available pages: 383154
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.02 BogoMIPS (lpj=3D27=
93011)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 02:24:8c:7f:51:0a try 1
wlan0: direct probe to AP 02:24:8c:7f:51:0a try 1
wlan0 direct probe responded
wlan0: authenticate with AP 02:24:8c:7f:51:0a
wlan0: authenticated
wlan0: associate with AP 02:24:8c:7f:51:0a
wlan0: RX AssocResp from 02:24:8c:7f:51:0a (capab=3D0x401 status=3D0 aid=3D=
1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: direct probe to AP 54:e6:fc:98:63:fe try 1
wlan0: direct probe to AP 54:e6:fc:98:63:fe try 1
wlan0 direct probe responded
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08done (105268 pages freed)
PM: Freed 421072 kbytes in 14.56 seconds (28.91 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 126129 pages
PM: Normal pages needed: 126129 + 1024 + 38, available pages: 383314
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.09 BogoMIPS (lpj=3D27=
93045)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 1
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 1
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 2
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 3
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 timed out
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 1
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08|=08/=08done (140671 pages freed)
PM: Freed 562684 kbytes in 17.17 seconds (32.77 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125929 pages
PM: Normal pages needed: 125929 + 1024 + 38, available pages: 383507
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5585.97 BogoMIPS (lpj=3D27=
92985)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... <5>firewire_core: rediscovered device fw0
done.
PM: Basic memory bitmaps freed
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: disassociating by local choice (reason=3D3)
wlan0: deauthenticating by local choice (reason=3D3)
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08|=08/=08-=08\=08|=08done (169560 pages freed)
PM: Freed 678240 kbytes in 25.43 seconds (26.67 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125839 pages
PM: Normal pages needed: 125839 + 1024 + 38, available pages: 383604
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.01 BogoMIPS (lpj=3D27=
93008)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: disassociating by local choice (reason=3D3)
wlan0: deauthenticating by local choice (reason=3D3)
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08done (205017 pages freed)
PM: Freed 820068 kbytes in 31.90 seconds (25.70 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 126130 pages
PM: Normal pages needed: 126130 + 1024 + 38, available pages: 383311
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.06 BogoMIPS (lpj=3D27=
93033)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 2
wlan0 direct probe responded
wlan0: authenticate with AP 00:15:f2:88:fa:36
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08done (234403 pages f=
reed)
PM: Freed 937612 kbytes in 29.57 seconds (31.70 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125947 pages
PM: Normal pages needed: 125947 + 1024 + 38, available pages: 383489
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5164.33 BogoMIPS (lpj=3D25=
82166)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 02:24:8c:7f:51:0a try 1
wlan0 direct probe responded
wlan0: authenticate with AP 02:24:8c:7f:51:0a
wlan0: authenticated
wlan0: associate with AP 02:24:8c:7f:51:0a
wlan0: RX AssocResp from 02:24:8c:7f:51:0a (capab=3D0x401 status=3D0 aid=3D=
1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: no IPv6 routers present
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: disassociating by local choice (reason=3D3)
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: deauthenticating by local choice (reason=3D3)
wlan0: direct probe to AP 00:00:00:00:00:00 try 1
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08done (44042 pages freed)
PM: Freed 176168 kbytes in 7.30 seconds (24.13 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 126254 pages
PM: Normal pages needed: 126254 + 1024 + 38, available pages: 383184
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.05 BogoMIPS (lpj=3D27=
93026)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08done (74193=
 pages freed)
PM: Freed 296772 kbytes in 9.22 seconds (32.18 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125862 pages
PM: Normal pages needed: 125862 + 1024 + 38, available pages: 383583
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.01 BogoMIPS (lpj=3D27=
93005)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: deauthenticating by local choice (reason=3D3)
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08done (108485 pages freed)
PM: Freed 433940 kbytes in 12.78 seconds (33.95 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125855 pages
PM: Normal pages needed: 125855 + 1024 + 38, available pages: 383591
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4839.78 BogoMIPS (lpj=3D24=
19893)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: deauthenticating by local choice (reason=3D3)
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08|=08/=08done (137790 pages freed)
PM: Freed 551160 kbytes in 19.65 seconds (28.04 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125948 pages
PM: Normal pages needed: 125948 + 1024 + 38, available pages: 383498
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.02 BogoMIPS (lpj=3D27=
93012)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: deauthenticating by local choice (reason=3D3)
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08|=08/=08-=08\=08|=08/=08done (172227 pages freed)
PM: Freed 688908 kbytes in 30.31 seconds (22.72 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 126287 pages
PM: Normal pages needed: 126287 + 1024 + 38, available pages: 383151
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6396.11 BogoMIPS (lpj=3D31=
98057)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... done.
PM: Basic memory bitmaps freed
firewire_core: rediscovered device fw0
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 1
wlan0: direct probe to AP 00:15:f2:88:fa:36 try 2
wlan0 direct probe responded
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 00:15:f2:88:fa:36
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authentication with AP 00:15:f2:88:fa:36 timed out
wlan0: authenticate with AP 00:15:f2:88:fa:36
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: deauthenticating by local choice (reason=3D3)
PM: Hibernation mode set to 'reboot'
PM: Marking nosave pages: 000000000009e000 - 0000000000100000
PM: Marking nosave pages: 000000007c4a1000 - 000000007c4a7000
PM: Marking nosave pages: 000000007c5b7000 - 000000007c60f000
PM: Marking nosave pages: 000000007c6c6000 - 000000007c9ff000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=
=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08done (202233 pages freed)
PM: Freed 808932 kbytes in 31.48 seconds (25.69 MB/s)
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
ACPI handle has no context!
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ACPI handle has no context!
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PME# disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed pipe 0
ricoh-mmc: Suspending.
ricoh-mmc: Controller is now re-enabled.
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 125990 pages
PM: Normal pages needed: 125990 + 1024 + 38, available pages: 383453
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
CPU0: Thermal monitoring handled by SMI
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.02 BogoMIPS (lpj=3D27=
93014)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
CPU1 is up
pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00005, writi=
ng 0xb00001)
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106,=
 writing 0x100102)
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, wri=
ting 0x2b00407)
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, wr=
iting 0x100506)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0xf (was 0x780=
010b, writing 0x580010b)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x3 (was 0x822=
010, writing 0x82a810)
yenta_cardbus 0000:15:00.0: restoring config space at offset 0x1 (was 0x210=
0107, writing 0x2100007)
ricoh-mmc: Resuming.
ricoh-mmc: Controller is now disabled.
i915 0000:00:02.0: setting latency timer to 64
[drm] LVDS-8: set mode 1680x1050 11
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
BUG kmalloc-192 (Not tainted): Poison overwritten
---------------------------------------------------------------------------=
--

INFO: 0xffff880079198340-0xffff88007919835f. First byte 0x0 instead of 0x6b
INFO: Allocated in fib_create_info+0x331/0xbaf age=3D89259 cpu=3D0 pid=3D17=
15
INFO: Freed in free_fib_info+0x59/0x5b age=3D32977 cpu=3D1 pid=3D1715
INFO: Slab 0xffffe200031325c0 objects=3D31 used=3D27 fp=3D0xffff88007919831=
8 flags=3D0x200000000040c3
INFO: Object 0xffff880079198318 @offset=3D792 fp=3D0xffff880079198108

Bytes b4 0xffff880079198308:  e8 4c 21 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a =
5a =E8L!.....ZZZZZZZZ
  Object 0xffff880079198318:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880079198328:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880079198338:  6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 00 00 00 =
00 kkkkkkkk........
  Object 0xffff880079198348:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 ................
  Object 0xffff880079198358:  00 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b =
6b ........kkkkkkkk
  Object 0xffff880079198368:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880079198378:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880079198388:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff880079198398:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff8800791983a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff8800791983b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b kkkkkkkkkkkkkkkk
  Object 0xffff8800791983c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
a5 kkkkkkkkkkkkkkk=A5
 Redzone 0xffff8800791983d8:  bb bb bb bb bb bb bb bb                      =
   =BB=BB=BB=BB=BB=BB=BB=BB       =20
 Padding 0xffff880079198418:  5a 5a 5a 5a 5a 5a 5a 5a                      =
   ZZZZZZZZ       =20
Pid: 12350, comm: pm-hibernate Not tainted 2.6.30.10-105.2.23.fc11.x86_64.d=
ebug #1
Call Trace:
 [<ffffffff810e6e2b>] print_trailer+0x140/0x149
 [<ffffffff810e74fb>] check_bytes_and_report+0xba/0xeb
 [<ffffffff810e75f6>] check_object+0xca/0x1ae
 [<ffffffff810e9330>] __slab_alloc+0x2f9/0x3a3
 [<ffffffffa0062a3b>] ? kcalloc.clone.0+0x2f/0x31 [i915]
 [<ffffffff810eab66>] __kmalloc+0x116/0x196
 [<ffffffffa0062a3b>] ? kcalloc.clone.0+0x2f/0x31 [i915]
 [<ffffffffa0062a3b>] kcalloc.clone.0+0x2f/0x31 [i915]
 [<ffffffffa0066750>] i915_gem_init_object+0x20/0x64 [i915]
 [<ffffffffa0027939>] drm_gem_object_alloc+0xb0/0xeb [drm]
 [<ffffffffa0064bff>] i915_gem_init_ringbuffer+0x1cd/0x47e [i915]
 [<ffffffffa005c0b4>] i915_resume+0x9d/0xc7 [i915]
 [<ffffffffa005c0f3>] i915_pci_resume+0x15/0x17 [i915]
 [<ffffffff811f6adb>] pci_legacy_resume+0x38/0x47
 [<ffffffff811f6b3e>] pci_pm_restore+0x54/0x87
 [<ffffffff812990ba>] pm_op+0xbd/0xea
 [<ffffffff81299c0f>] device_resume+0xec/0x469
 [<ffffffff8107d969>] hibernation_snapshot+0x1e8/0x22c
 [<ffffffff8107da92>] hibernate+0xe5/0x1a9
 [<ffffffff8107c43e>] state_store+0x5c/0xd3
 [<ffffffff811de557>] kobj_attr_store+0x17/0x19
 [<ffffffff81146363>] sysfs_write_file+0xfb/0x137
 [<ffffffff810f372b>] vfs_write+0xae/0x10b
 [<ffffffff810f3848>] sys_write+0x4a/0x6e
 [<ffffffff81010c82>] system_call_fastpath+0x16/0x1b
FIX kmalloc-192: Restoring 0xffff880079198340-0xffff88007919835f=3D0x6b

FIX kmalloc-192: Marking all objects used
pci 0000:00:02.1: PME# disabled
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: PME# disabled
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
firewire_core: skipped bus generations, destroying all nodes
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata1: irq_stat 0x00400040, connection status changed
ata1.00: configured for UDMA/100
ata1: EH complete
PM: Image restored successfully.
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
Restarting tasks ... <5>firewire_core: rediscovered device fw0
done.
PM: Basic memory bitmaps freed
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata2: irq_stat 0x40000001
ata2.00: configured for UDMA/133
ata2: EH complete
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 1
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 2
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 try 3
wlan0: direct probe to AP 00:60:b3:c5:c3:d3 timed out
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: authenticate with AP 54:e6:fc:98:63:fe
wlan0: authenticated
wlan0: associate with AP 54:e6:fc:98:63:fe
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=3D0x431 status=3D0 aid=3D=
2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3.3-rc4_corruption.txt"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.3.0-rc4-wl+ (test@dhcp-27-55.brq.redhat.com) (gcc version 4.4.6 20110731 (Red Hat 4.4.6-3) (GCC) ) #1 SMP Wed Feb 22 20:05:27 CET 2012
Command line: root=/dev/mapper/vg_dhcp2755-lv_root ro rd_LVM_LV=vg_dhcp2755/lv_root rd_LVM_LV=vg_dhcp2755/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us crashkernel=196M rhgb drm.debug=0x04 console=ttyS0,115200 console=tty0 audit=0 selinux=0
Disabled fast string operations
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007c4a1000 (usable)
 BIOS-e820: 000000007c4a1000 - 000000007c4a7000 (reserved)
 BIOS-e820: 000000007c4a7000 - 000000007c5b7000 (usable)
 BIOS-e820: 000000007c5b7000 - 000000007c60f000 (reserved)
 BIOS-e820: 000000007c60f000 - 000000007c6c6000 (usable)
 BIOS-e820: 000000007c6c6000 - 000000007c6d1000 (ACPI NVS)
 BIOS-e820: 000000007c6d1000 - 000000007c6d4000 (ACPI data)
 BIOS-e820: 000000007c6d4000 - 000000007c6d8000 (reserved)
 BIOS-e820: 000000007c6d8000 - 000000007c6dc000 (ACPI NVS)
 BIOS-e820: 000000007c6dc000 - 000000007c6df000 (reserved)
 BIOS-e820: 000000007c6df000 - 000000007c706000 (ACPI NVS)
 BIOS-e820: 000000007c706000 - 000000007c708000 (ACPI data)
 BIOS-e820: 000000007c708000 - 000000007c90f000 (reserved)
 BIOS-e820: 000000007c90f000 - 000000007c99f000 (ACPI NVS)
 BIOS-e820: 000000007c99f000 - 000000007c9ff000 (ACPI data)
 BIOS-e820: 000000007c9ff000 - 000000007ca00000 (usable)
 BIOS-e820: 000000007cc00000 - 000000007f000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI present.
DMI: LENOVO 2241B48/2241B48, BIOS 6FET66WW (2.16 ) 04/22/2009
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x7ca00 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-DBFFF uncachable
  DC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 07D000000 mask FFF000000 uncachable
  1 base 07E000000 mask FFE000000 uncachable
  2 base 000000000 mask F80000000 write-back
  3 base 07CE00000 mask FFFE00000 uncachable
  4 disabled
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 2000MB, range: 16MB, type UC
reg 1, base: 2016MB, range: 32MB, type UC
reg 2, base: 0GB, range: 2GB, type WB
reg 3, base: 1998MB, range: 2MB, type UC
total RAM covered: 1998M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 1998MB, range: 2MB, type UC
reg 2, base: 2000MB, range: 16MB, type UC
reg 3, base: 2016MB, range: 32MB, type UC
found SMP MP-table at [ffff8800000f6570] f6570
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000099000] 99000 size 20480
init_memory_mapping: 0000000000000000-000000007ca00000
 0000000000 - 007ca00000 page 2M
kernel direct mapping tables up to 7ca00000 @ 1fffd000-20000000
RAMDISK: 36c9b000 - 37ff0000
Reserving 196MB of memory at 656MB for crashkernel (System RAM: 1994MB)
ACPI: RSDP 00000000000f6530 00024 (v02 LENOVO)
ACPI: XSDT 000000007c96a3f1 00094 (v01 LENOVO TP-6F    00002160  LTP 00000000)
ACPI: FACP 000000007c96a500 000F4 (v03 LENOVO TP-6F    00002160 LNVO 00000001)
ACPI: DSDT 000000007c96a8db 0F3FB (v01 LENOVO TP-6F    00002160 MSFT 03000000)
ACPI: FACS 000000007c98e000 00040
ACPI: SSDT 000000007c96a6b4 00227 (v01 LENOVO TP-6F    00002160 MSFT 03000000)
ACPI: ECDT 000000007c979cd6 00052 (v01 LENOVO TP-6F    00002160 LNVO 00000001)
ACPI: APIC 000000007c979d28 00078 (v01 LENOVO TP-6F    00002160 LNVO 00000001)
ACPI: MCFG 000000007c979da0 0003C (v01 LENOVO TP-6F    00002160 LNVO 00000001)
ACPI: HPET 000000007c979ddc 00038 (v01 LENOVO TP-6F    00002160 LNVO 00000001)
ACPI: BOOT 000000007c979f38 00028 (v01 LENOVO TP-6F    00002160  LTP 00000001)
ACPI: ASF! 000000007c979f60 000A0 (v16 LENOVO TP-6F    00002160 PTL  00000001)
ACPI: SSDT 000000007c98d213 0054F (v01 LENOVO TP-6F    00002160 INTL 20050513)
ACPI: TCPA 000000007c707000 00032 (v00                 00000000      00000000)
ACPI: DMAR 000000007c706000 00120 (v01               ? 00000001      00000000)
ACPI: SSDT 000000007c6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: SSDT 000000007c6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 000000007c6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
ACPI: DMI detected: Lenovo ThinkPad T500
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000007ca00000
Initmem setup node 0 0000000000000000-000000007ca00000
  NODE_DATA [000000007c69f000 - 000000007c6c5fff]
 [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880079c00000-ffff88007b7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009e
    0: 0x00000100 -> 0x0007c4a1
    0: 0x0007c4a7 -> 0x0007c5b7
    0: 0x0007c60f -> 0x0007c6c6
    0: 0x0007c9ff -> 0x0007ca00
On node 0 totalpages: 509431
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3921 pages, LIFO batch:0
  DMA32 zone: 6923 pages used for memmap
  DMA32 zone: 498526 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
PM: Registered nosave memory: 000000007c4a1000 - 000000007c4a7000
PM: Registered nosave memory: 000000007c5b7000 - 000000007c60f000
PM: Registered nosave memory: 000000007c6c6000 - 000000007c6d1000
PM: Registered nosave memory: 000000007c6d1000 - 000000007c6d4000
PM: Registered nosave memory: 000000007c6d4000 - 000000007c6d8000
PM: Registered nosave memory: 000000007c6d8000 - 000000007c6dc000
PM: Registered nosave memory: 000000007c6dc000 - 000000007c6df000
PM: Registered nosave memory: 000000007c6df000 - 000000007c706000
PM: Registered nosave memory: 000000007c706000 - 000000007c708000
PM: Registered nosave memory: 000000007c708000 - 000000007c90f000
PM: Registered nosave memory: 000000007c90f000 - 000000007c99f000
PM: Registered nosave memory: 000000007c99f000 - 000000007c9ff000
Allocating PCI resources starting at 7f000000 (gap: 7f000000:61000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 476 pages/cpu @ffff88007bc00000 s1919360 r8192 d22144 u2097152
pcpu-alloc: s1919360 r8192 d22144 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 502447
Policy zone: DMA32
Kernel command line: root=/dev/mapper/vg_dhcp2755-lv_root ro rd_LVM_LV=vg_dhcp2755/lv_root rd_LVM_LV=vg_dhcp2755/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us crashkernel=196M rhgb drm.debug=0x04 console=ttyS0,115200 console=tty0 audit=0 selinux=0
audit: disabled (until reboot)
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 1754192k/2041856k available (5401k kernel code, 4132k absent, 283532k reserved, 3548k data, 3452k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:712 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
allocated 8388608 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
ODEBUG: 14 of 14 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2793.117 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.23 BogoMIPS (lpj=2793117)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20120111
ftrace: allocating 20841 entries in 82 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T9600  @ 2.80GHz stepping 06
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog enabled, takes one hw-pmu counter.
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 99000
Disabled fast string operations
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (11172.46 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at 7c6c6000 (45056 bytes)
PM: Registering ACPI NVS region at 7c6d8000 (16384 bytes)
PM: Registering ACPI NVS region at 7c6df000 (159744 bytes)
PM: Registering ACPI NVS region at 7c90f000 (589824 bytes)
print_constraints: dummy: 
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Added _OSI(Linux)
ACPI: EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
ACPI: SSDT 000000007c6d6aa0 0030A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0030A (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 000000007c6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
ACPI: SSDT 000000007c6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
ACPI: SSDT 000000007c6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [PUBS] (on)
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x7f000000-0xfebfffff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: root bus resource [mem 0x7f000000-0xfebfffff]
pci 0000:00:00.0: [8086:2a40] type 0 class 0x000600
pci 0000:00:02.0: [8086:2a42] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
pci 0000:00:02.1: [8086:2a43] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
pci 0000:00:03.0: [8086:2a44] type 0 class 0x000780
pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.2: [8086:2a46] type 0 class 0x000101
pci 0000:00:03.2: reg 10: [io  0x1828-0x182f]
pci 0000:00:03.2: reg 14: [io  0x180c-0x180f]
pci 0000:00:03.2: reg 18: [io  0x1820-0x1827]
pci 0000:00:03.2: reg 1c: [io  0x1808-0x180b]
pci 0000:00:03.2: reg 20: [io  0x1810-0x181f]
pci 0000:00:03.3: [8086:2a47] type 0 class 0x000700
pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
pci 0000:00:03.3: reg 14: [mem 0xfc024000-0xfc024fff]
pci 0000:00:19.0: [8086:10f5] type 0 class 0x000200
pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
pci 0000:00:1a.2: [8086:2939] type 0 class 0x000c03
pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:2942] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:2946] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:2948] type 1 class 0x000604
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2917] type 0 class 0x000601
pci 0000:00:1f.2: [8086:2929] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:03:00.0: [8086:4237] type 0 class 0x000280
pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
pci 0000:15:00.0: [1180:0476] type 2 class 0x000607
pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.1: [1180:0832] type 0 class 0x000c00
pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
pci 0000:15:00.1: supports D1 D2
pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.2: [1180:0822] type 0 class 0x000805
pci 0000:15:00.2: reg 10: [mem 0xf4801800-0xf48018ff]
pci 0000:15:00.2: supports D1 D2
pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.3: [1180:0843] type 0 class 0x000880
pci 0000:15:00.3: reg 10: [mem 0xf4801c00-0xf4801cff]
pci 0000:15:00.3: supports D1 D2
pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.4: [1180:0592] type 0 class 0x000880
pci 0000:15:00.4: reg 10: [mem 0xf4802000-0xf48020ff]
pci 0000:15:00.4: supports D1 D2
pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.5: [1180:0852] type 0 class 0x000880
pci 0000:15:00.5: reg 10: [mem 0xf4802400-0xf48024ff]
pci 0000:15:00.5: supports D1 D2
pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x7f000000-0xfebfffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
reserve RAM buffer: 000000007c4a1000 - 000000007fffffff 
reserve RAM buffer: 000000007c5b7000 - 000000007fffffff 
reserve RAM buffer: 000000007c6c6000 - 000000007fffffff 
reserve RAM buffer: 000000007ca00000 - 000000007fffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000c0000-0x000c3fff]
pnp 00:00: [mem 0x000c4000-0x000c7fff]
pnp 00:00: [mem 0x000c8000-0x000cbfff]
pnp 00:00: [mem 0x000cc000-0x000cffff]
pnp 00:00: [mem 0x000d0000-0x000d3fff]
pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
pnp 00:00: [mem 0x000dc000-0x000dffff]
pnp 00:00: [mem 0x000e0000-0x000e3fff]
pnp 00:00: [mem 0x000e4000-0x000e7fff]
pnp 00:00: [mem 0x000e8000-0x000ebfff]
pnp 00:00: [mem 0x000ec000-0x000effff]
pnp 00:00: [mem 0x000f0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7effffff]
pnp 00:00: [mem 0xfec00000-0xfed3ffff]
pnp 00:00: [mem 0xfed4c000-0xffffffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x7effffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x000c0000-0x000c3fff window]
pnp 00:01: [mem 0x000c4000-0x000c7fff window]
pnp 00:01: [mem 0x000c8000-0x000cbfff window]
pnp 00:01: [mem 0x000cc000-0x000cffff window]
pnp 00:01: [mem 0x000d0000-0x000d3fff window]
pnp 00:01: [mem 0x000d4000-0x000d7fff window]
pnp 00:01: [mem 0x000d8000-0x000dbfff window]
pnp 00:01: [mem 0x000dc000-0x000dffff window]
pnp 00:01: [mem 0x000e0000-0x000e3fff window]
pnp 00:01: [mem 0x000e4000-0x000e7fff window]
pnp 00:01: [mem 0x000e8000-0x000ebfff window]
pnp 00:01: [mem 0x000ec000-0x000effff window]
pnp 00:01: [mem 0x7f000000-0xfebfffff window]
pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0090-0x009f]
pnp 00:02: [io  0x0024-0x0025]
pnp 00:02: [io  0x0028-0x0029]
pnp 00:02: [io  0x002c-0x002d]
pnp 00:02: [io  0x0030-0x0031]
pnp 00:02: [io  0x0034-0x0035]
pnp 00:02: [io  0x0038-0x0039]
pnp 00:02: [io  0x003c-0x003d]
pnp 00:02: [io  0x00a4-0x00a5]
pnp 00:02: [io  0x00a8-0x00a9]
pnp 00:02: [io  0x00ac-0x00ad]
pnp 00:02: [io  0x00b0-0x00b5]
pnp 00:02: [io  0x00b8-0x00b9]
pnp 00:02: [io  0x00bc-0x00bd]
pnp 00:02: [io  0x0050-0x0053]
pnp 00:02: [io  0x0072-0x0077]
pnp 00:02: [io  0x002e-0x002f]
pnp 00:02: [io  0x1000-0x107f]
pnp 00:02: [io  0x1180-0x11ff]
pnp 00:02: [io  0x0800-0x080f]
pnp 00:02: [io  0x15e0-0x15ef]
pnp 00:02: [io  0x1600-0x167f]
pnp 00:02: [io  0x1680-0x169f]
pnp 00:02: [mem 0xe0000000-0xefffffff]
pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
pnp 00:02: [mem 0xfed10000-0xfed13fff]
pnp 00:02: [mem 0xfed18000-0xfed18fff]
pnp 00:02: [mem 0xfed19000-0xfed19fff]
pnp 00:02: [mem 0xfed45000-0xfed4bfff]
system 00:02: [io  0x1000-0x107f] has been reserved
system 00:02: [io  0x1180-0x11ff] has been reserved
system 00:02: [io  0x0800-0x080f] has been reserved
system 00:02: [io  0x15e0-0x15ef] has been reserved
system 00:02: [io  0x1600-0x167f] has been reserved
system 00:02: [io  0x1680-0x169f] has been reserved
system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [mem 0xfed00000-0xfed003ff]
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x0070-0x0071]
pnp 00:07: [irq 8]
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: [irq 12]
pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
pnp 00:0a: [mem 0xfed40000-0xfed44fff]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 2 pci_try_num: 3
pci 0000:00:1c.1: BAR 15: assigned [mem 0x7f000000-0x7f1fffff 64bit pref]
pci 0000:00:1c.1: BAR 13: assigned [io  0x8000-0x8fff]
pci 0000:00:1c.0: BAR 14: assigned [mem 0x7f200000-0x7f3fffff]
pci 0000:00:1c.0: BAR 15: assigned [mem 0x7f400000-0x7f5fffff 64bit pref]
pci 0000:00:1c.0: BAR 13: assigned [io  0x9000-0x9fff]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x9000-0x9fff]
pci 0000:00:1c.0:   bridge window [mem 0x7f200000-0x7f3fffff]
pci 0000:00:1c.0:   bridge window [mem 0x7f400000-0x7f5fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x8000-0x8fff]
pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
pci 0000:00:1c.1:   bridge window [mem 0x7f000000-0x7f1fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
pci 0000:15:00.0: BAR 16: assigned [mem 0x80000000-0x83ffffff]
pci 0000:15:00.0: BAR 15: assigned [mem 0xf0000000-0xf3ffffff pref]
pci 0000:15:00.0: BAR 14: assigned [io  0x4000-0x40ff]
pci 0000:15:00.0: BAR 13: assigned [io  0x4400-0x44ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0x80000000-0x83ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0x7f000000-0xfebfffff]
pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
pci_bus 0000:02: resource 1 [mem 0x7f200000-0x7f3fffff]
pci_bus 0000:02: resource 2 [mem 0x7f400000-0x7f5fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x8000-0x8fff]
pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
pci_bus 0000:03: resource 2 [mem 0x7f000000-0x7f1fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit pref]
pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:15: resource 9 [mem 0x7f000000-0xfebfffff]
pci_bus 0000:16: resource 0 [io  0x4400-0x44ff]
pci_bus 0000:16: resource 1 [io  0x4000-0x40ff]
pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
pci_bus 0000:16: resource 3 [mem 0x80000000-0x83ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 5, 196608 bytes)
UDP-Lite hash table entries: 1024 (order: 5, 196608 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 19796k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
Simple Boot Flag at 0x35 set to 0x1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3464
cryptomgr_test used greatest stack depth: 6536 bytes left
cryptomgr_test used greatest stack depth: 6344 bytes left
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
start plist test
end plist test
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 2948 ss_vid 17aa ss_did 20f3
pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
intel_idle: MWAIT substates: 0x3122220
intel_idle: does not run on family 6 model 23
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (63 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (67 C)
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
0000:00:03.3: ttyS0 at I/O 0x1830 (irq = 17) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel GM45 Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 32768K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
tpm_tis 00:0a: Intel iTPM workaround enabled
tpm_tis 00:0a: A TPM error (6) occurred attempting to read a pcr value
tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.3.0-rc4-wl+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.3.0-rc4-wl+ ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.3.0-rc4-wl+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.3.0-rc4-wl+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.3.0-rc4-wl+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.3.0-rc4-wl+ uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.3.0-rc4-wl+ uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 3.3.0-rc4-wl+ uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
tpm_tis 00:0a: A TPM error (6) occurred attempting to read a pcr value
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:07: setting system clock to 2012-02-23 10:30:44 UTC (1329993044)
Initializing network drop monitor service
usb 1-6: new high-speed USB device number 2 using ehci_hcd
usb 1-6: New USB device found, idVendor=17ef, idProduct=4807
usb 1-6: New USB device strings: Mfr=1, Product=0, SerialNumber=0
usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery present)
Freeing unused kernel memory: 3452k freed
mknod used greatest stack depth: 5408 bytes left
mount used greatest stack depth: 5232 bytes left
dracut: dracut-004-252.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
modprobe used greatest stack depth: 5056 bytes left
psmouse serio1: synaptics: Touchpad model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000/0x20000
udev: starting version 147
psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
udevd (78): /proc/78/oom_adj is deprecated, please use /proc/78/oom_score_adj instead.
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 44 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
[drm:init_vbt_defaults], Set default to SSC at 100MHz
[drm:intel_parse_bios], Using VBT from OpRegion: $VBT CANTIGA        d
[drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 1 lvds_ssc_freq 100 display_clock_mode 0
[drm:parse_general_definitions], crt_ddc_bus_pin: 2
[drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1680x1050" 0 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x8 0xa
[drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[drm:intel_dsm_pci_probe], no _DSM method for intel device
[drm:intel_modeset_init], 2 display pipes available.
[drm:intel_modeset_init], plane 0 init failed: -19
[drm:intel_modeset_init], plane 1 init failed: -19
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm:intel_setup_outputs], probing SDVOB
[drm:intel_sdvo_read_byte], i2c transfer returned -6
[drm:intel_sdvo_init], No SDVO device found on SDVOB
[drm:intel_setup_outputs], probing HDMI on SDVOB
[drm:intel_setup_outputs], probing DP_B
[drm:intel_dp_i2c_init], i2c_init DPDDC-B
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[drm:intel_setup_outputs], probing SDVOC
[drm:intel_sdvo_read_byte], i2c transfer returned -6
[drm:intel_sdvo_init], No SDVO device found on SDVOC
[drm:intel_setup_outputs], probing HDMI on SDVOC
[drm:intel_setup_outputs], probing DP_C
[drm:intel_dp_i2c_init], i2c_init DPDDC-C
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[drm:intel_setup_outputs], probing DP_D
[drm:intel_dp_i2c_init], i2c_init DPDDC-D
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[drm:intel_tv_init], Integrated TV is not present.
[drm:i915_get_vblank_timestamp], crtc 0 is disabled
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=2, cursor=2, SR: plane=0, cursor=0
[drm:i915_get_vblank_timestamp], crtc 1 is disabled
[drm:intel_update_fbc], 
[drm:intel_update_fbc], no output, disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=2, cursor=2, SR: plane=0, cursor=0
[drm:init_ring_common], render ring head not reset to zero ctl 00000000 head 00001000 tail 00000000 start 00001000
[drm:i915_setup_compression], FBC base 0x7d000000, ll base 0x00000000, size 28M
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_setup_crtcs], 
[drm:drm_enable_connectors], connector 5 enabled? yes
[drm:drm_enable_connectors], connector 12 enabled? no
[drm:drm_enable_connectors], connector 15 enabled? no
[drm:drm_enable_connectors], connector 18 enabled? no
[drm:drm_enable_connectors], connector 21 enabled? no
[drm:drm_enable_connectors], connector 22 enabled? no
[drm:drm_enable_connectors], connector 24 enabled? no
[drm:drm_target_preferred], looking for cmdline mode on connector 5
[drm:drm_target_preferred], looking for preferred mode on connector 5
[drm:drm_target_preferred], found mode 1680x1050
[drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[drm:drm_setup_crtcs], desired mode 1680x1050 set on crtc 4
[drm:intelfb_create], allocated 1680x1050 fb: 0x00042000, bo ffff880037f788f8
fbcon: inteldrmfb (fb0) is primary device
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[drm:drm_mode_debug_printmodeline], Modeline 8:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 8:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_crtc_helper_set_mode], [CRTC:4]
[drm:i9xx_crtc_mode_set], using SSC reference clock of 100 MHz
[drm:i9xx_crtc_mode_set], Mode for pipe B:
[drm:drm_mode_debug_printmodeline], Modeline 8:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:i9xx_crtc_mode_set], disabling CxSR downclocking
[drm:i9xx_update_plane], Writing base 00042000 00000000 0 0 6720
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:8:1680x1050]
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:intel_lvds_enable], applying panel-fitter: 0, 0
[drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[drm:drm_crtc_helper_set_config], 	[CONNECTOR:5:LVDS-1] set DPMS on
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
Console: switching to colour frame buffer device 210x65
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
acpi device:02: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
modprobe used greatest stack depth: 2784 bytes left
dracut: Starting plymouth daemon
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
ata_generic 0000:00:03.2: setting latency timer to 64
scsi0 : ata_generic
scsi1 : ata_generic
ata1: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
ata2: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
ahci 0000:00:1f.2: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 45
ata4: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 45
ata5: DUMMY
ata6: DUMMY
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ATA-8: FUJITSU MHZ2160BJ G1, 00840022, max UDMA/100
ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      FUJITSU MHZ2160B 0084 PQ: 0 ANSI: 5
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: configured for UDMA/133
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX12 PQ: 0 ANSI: 5
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000006
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x4000-0x7fff]
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf4800000-0xf7ffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4800000-0xf7ffffff: excluding 0xf4800000-0xf4b7ffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf3ffffff 64bit pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xf3ffffff: excluding 0xf0000000-0xf3ffffff
firewire_ohci: Added fw-ohci device 0000:15:00.1, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x11
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
mmc0: no vmmc regulator found
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
Registered led device: mmc0::
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
sdhci-pci 0000:15:00.3: SDHCI controller found [1180:0843] (rev 11)
mmc1: no vmmc regulator found
Registered led device: mmc1::
mmc1: SDHCI controller on PCI [0000:15:00.3] using DMA
sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
 sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
firewire_core: created device fw0: GUID 00061b032a3cb74a, S400
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
dracut: Scanning devices sda2  for LVM logical volumes vg_dhcp2755/lv_root vg_dhcp2755/lv_swap 
dracut: inactive '/dev/vg_dhcp2755/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_dhcp2755/lv_home' [94.75 GiB] inherit
dracut: inactive '/dev/vg_dhcp2755/lv_swap' [3.81 GiB] inherit
EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
EXT4-fs (dm-0): write access will be enabled during recovery
EXT4-fs (dm-0): orphan cleanup on readonly fs
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232069
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232068
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232067
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232066
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232065
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232064
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232062
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232052
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 2232037
EXT4-fs (dm-0): 9 orphan inodes deleted
EXT4-fs (dm-0): recovery complete
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/vg_dhcp2755-lv_root
dracut: Switching root
udev: starting version 147
WARNING! power/level is deprecated; use power/control instead
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:21:HDMI-A-2] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:22:DP-2] status updated from 2 to 2
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:24:DP-3] status updated from 2 to 2
e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:24:7e:16:ad:58
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
hda_codec: CX20561 (Hermosa): BIOS auto-probing.
ALSA sound/pci/hda/hda_codec.c:4923 autoconfig: line_outs=1 (0x1a/0x0/0x0/0x0/0x0) type:speaker
ALSA sound/pci/hda/hda_codec.c:4927    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4931    hp_outs=2 (0x19/0x16/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4932    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:4936    inputs:
ALSA sound/pci/hda/hda_codec.c:4940  Dock Mic=0x17
ALSA sound/pci/hda/hda_codec.c:4940  Mic=0x18
ALSA sound/pci/hda/hda_codec.c:4940  Internal Mic=0x1d
ALSA sound/pci/hda/hda_codec.c:4942 
input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
cfg80211: Calling CRDA to update world regulatory domain
Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
Copyright(c) 2003-2012 Intel Corporation
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc90004e04000
iwlwifi 0000:03:00.0: HW Revision ID = 0x0
iwlwifi 0000:03:00.0: irq 48 for MSI/MSI-X
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
iwlwifi 0000:03:00.0: Device SKU: 0xF0
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
Registered led device: phy0-led
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
input: PC Speaker as /devices/platform/pcspkr/input/input11
microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device <unnamed> (17ef:4807)
input: UVC Camera (17ef:4807) as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/1-6:1.0/input/input12
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
sd 2:0:0:0: Attached scsi generic sg0 type 0
sr 3:0:0:0: Attached scsi generic sg1 type 5
wmi: Mapper loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 6FET66WW (2.16 ), EC 7VHT12WW-1.01
thinkpad_acpi: Lenovo ThinkPad T500, model 2241B48
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
Registered led device: tpacpi::thinkvantage
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input13
r592: driver successfully loaded
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xdc000-0xfffff
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
usb 4-2: new full-speed USB device number 2 using uhci_hcd
usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
usb 4-2: Manufacturer: Lenovo Computer Corp
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
usbcore: registered new interface driver btusb
EXT4-fs (dm-0): re-mounted. Opts: (null)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
Adding 3997692k swap on /dev/mapper/vg_dhcp2755-lv_swap.  Priority:-1 extents:1 across:3997692k 
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[7] ENCODERS[7]
[drm:drm_mode_getresources], CRTC[2] CONNECTORS[7] ENCODERS[7]
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_addfb], [FB:28]
[drm:drm_mode_setcrtc], [CRTC:4]
[drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:i9xx_update_plane], Writing base 006FD000 00000000 0 0 7168
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:intel_crtc_cursor_set], 
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:21:HDMI-A-2] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:22:DP-2] status updated from 2 to 2
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:24:DP-3] status updated from 2 to 2
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
fuse init (API version 7.18)
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
wlan0: authenticate with 54:e6:fc:98:63:fe
wlan0: send auth to 54:e6:fc:98:63:fe (try 1/3)
wlan0: send auth to 54:e6:fc:98:63:fe (try 2/3)
wlan0: authenticated
wlan0: associate with 54:e6:fc:98:63:fe (try 1/3)
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=0x431 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Intel AES-NI instructions are not detected.
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:21:HDMI-A-2] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:22:DP-2] status updated from 2 to 2
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:24:DP-3] status updated from 2 to 2
wlan0: no IPv6 routers present
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
usb 4-2: USB disconnect, device number 2
wlan0: deauthenticating from 54:e6:fc:98:63:fe by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:i9xx_update_plane], Writing base 00042000 00000000 0 0 6720
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 315136 pages)
PM: Allocated 1260544 kbytes in 3.37 seconds (374.04 MB/s)
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
ACPI handle has no context!
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
sd 2:0:0:0: [sda] Synchronizing SCSI cache
PM: freeze of devices complete after 237.282 msecs
PM: late freeze of devices complete after 1.466 msecs
Disabling non-boot CPUs ...
Broke affinity for irq 9
Broke affinity for irq 12
Broke affinity for irq 21
Broke affinity for irq 23
CPU 1 is now offline
lockdep: fixing up alternatives.
Extended CMOS year: 2000
PM: Creating hibernation image:
PM: Need to copy 180084 pages
Extended CMOS year: 2000
microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 99000
Disabled fast string operations
Calibrating delay loop (skipped) already calibrated this CPU
NMI watchdog enabled, takes one hw-pmu counter.
microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
CPU1 is up
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
PM: early restore of devices complete after 24.733 msecs
i915 0000:00:02.0: setting latency timer to 64
ata_generic 0000:00:03.2: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1a.2: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb7: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb8: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb2: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
[drm:init_ring_common], render ring head not reset to zero ctl 00000000 head 00001000 tail 00000000 start 00001000
[drm:drm_crtc_helper_set_mode], [CRTC:4]
dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -19
PM: Device 00:0a failed to restore: error -19
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:i9xx_crtc_mode_set], using SSC reference clock of 100 MHz
[drm:i9xx_crtc_mode_set], Mode for pipe B:
[drm:drm_mode_debug_printmodeline], Modeline 8:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:i9xx_crtc_mode_set], disabling CxSR downclocking
firewire_core: skipped bus generations, destroying all nodes
[drm:i9xx_update_plane], Writing base 00042000 00000000 0 0 6720
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:8:1680x1050]
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: configured for UDMA/100
sd 2:0:0:0: [sda] Starting disk
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: configured for UDMA/133
usb 1-6: reset high-speed USB device number 2 using ehci_hcd
firewire_core: rediscovered device fw0
PM: restore of devices complete after 670.351 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[drm:drm_mode_setcrtc], [CRTC:4]
[drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:i9xx_update_plane], Writing base 006FD000 00000000 0 0 7168
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:21:HDMI-A-2] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:22:DP-2] status updated from 2 to 2
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:24:DP-3] status updated from 2 to 2
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
usb 4-2: new full-speed USB device number 3 using uhci_hcd
usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
usb 4-2: Manufacturer: Lenovo Computer Corp
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:21:HDMI-A-2] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:22:DP-2] status updated from 2 to 2
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:24:DP-3] status updated from 2 to 2
wlan0: authenticate with 54:e6:fc:98:63:fe
wlan0: send auth to 54:e6:fc:98:63:fe (try 1/3)
wlan0: send auth to 54:e6:fc:98:63:fe (try 2/3)
wlan0: authenticated
wlan0: associate with 54:e6:fc:98:63:fe (try 1/3)
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=0x31 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
usb 4-2: USB disconnect, device number 3
wlan0: deauthenticating from 54:e6:fc:98:63:fe by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:i9xx_update_plane], Writing base 00042000 00000000 0 0 6720
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.03 seconds) done.
PM: Preallocating image memory... done (allocated 315118 pages)
PM: Allocated 1260472 kbytes in 3.95 seconds (319.10 MB/s)
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
ACPI handle has no context!
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
sd 2:0:0:0: [sda] Synchronizing SCSI cache
PM: freeze of devices complete after 201.946 msecs
PM: late freeze of devices complete after 1.700 msecs
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
Extended CMOS year: 2000
PM: Creating hibernation image:
PM: Need to copy 179648 pages
Extended CMOS year: 2000
microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 99000
Disabled fast string operations
Calibrating delay loop (skipped) already calibrated this CPU
NMI watchdog enabled, takes one hw-pmu counter.
microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
CPU1 is up
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
PM: early restore of devices complete after 23.901 msecs
i915 0000:00:02.0: setting latency timer to 64
ata_generic 0000:00:03.2: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1a.2: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb7: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb8: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb2: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -19
PM: Device 00:0a failed to restore: error -19
[drm:init_ring_common], render ring head not reset to zero ctl 00000000 head 00001000 tail 00000000 start 00001000
[drm:drm_crtc_helper_set_mode], [CRTC:4]
firewire_core: skipped bus generations, destroying all nodes
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:i9xx_crtc_mode_set], using SSC reference clock of 100 MHz
[drm:i9xx_crtc_mode_set], Mode for pipe B:
[drm:drm_mode_debug_printmodeline], Modeline 8:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:i9xx_crtc_mode_set], disabling CxSR downclocking
[drm:i9xx_update_plane], Writing base 00042000 00000000 0 0 6720
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:8:1680x1050]
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: configured for UDMA/100
sd 2:0:0:0: [sda] Starting disk
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: configured for UDMA/133
usb 1-6: reset high-speed USB device number 2 using ehci_hcd
firewire_core: rediscovered device fw0
PM: restore of devices complete after 662.503 msecs
psmouse serio1: synaptics: device claims to have max coordinates query, but I'm not able to read it.
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[drm:drm_mode_setcrtc], [CRTC:4]
[drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:i9xx_update_plane], Writing base 006FD000 00000000 0 0 7168
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
usb 4-2: new full-speed USB device number 4 using uhci_hcd
usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
usb 4-2: Manufacturer: Lenovo Computer Corp
wlan0: authenticate with 54:e6:fc:98:63:fe
wlan0: send auth to 54:e6:fc:98:63:fe (try 1/3)
wlan0: authenticated
wlan0: associate with 54:e6:fc:98:63:fe (try 1/3)
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=0x431 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:21:HDMI-A-2] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:22:DP-2] status updated from 2 to 2
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:24:DP-3] status updated from 2 to 2
wlan0: no IPv6 routers present
Slab corruption (Not tainted): dentry start=ffff8800715b28d0, len=264
Redzone: 0x9f911029d74e35b/0xaaaaaa00aaaaaa.
Last user: [<ffffffff8119e862>](__d_free+0x52/0x70)
0f0: aa aa aa 00 aa aa aa 00 aa aa aa 00 aa aa aa 00  ................
100: aa aa aa 00 aa aa aa 00                          ........
Prev obj: start=ffff8800715b27b0, len=264
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<ffffffff8119e4b7>](__d_alloc+0x37/0x1a0)
000: c0 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
010: c0 76 1e 00 00 c9 ff ff 30 23 8a 76 00 88 ff ff  .v......0#.v....
Next obj: start=ffff8800715b29f0, len=264
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<ffffffff8119e4b7>](__d_alloc+0x37/0x1a0)
000: 8c 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
010: f8 01 1c 00 00 c9 ff ff 30 5c 5b 71 00 88 ff ff  ........0\[q....
slab error in cache_alloc_debugcheck_after(): cache `dentry': double free, or memory outside object was overwritten
Pid: 4369, comm: rhsmd Not tainted 3.3.0-rc4-wl+ #1
Call Trace:
 [<ffffffff8116ea26>] __slab_error+0x26/0x30
 [<ffffffff8116fc05>] cache_alloc_debugcheck_after+0x75/0x230
 [<ffffffff8119e4b7>] ? __d_alloc+0x37/0x1a0
 [<ffffffff811729a9>] kmem_cache_alloc+0x149/0x260
 [<ffffffff8119e4b7>] __d_alloc+0x37/0x1a0
 [<ffffffff8119e728>] d_alloc+0x28/0x80
 [<ffffffff8119361d>] d_alloc_and_lookup+0x2d/0x90
 [<ffffffff8119f585>] ? d_lookup+0x35/0x60
 [<ffffffff811955ba>] do_lookup+0x28a/0x3b0
 [<ffffffff8119429c>] ? inode_permission+0x4c/0x110
 [<ffffffff81195de1>] do_last+0xe1/0x830
 [<ffffffff81197439>] path_openat+0xd9/0x3e0
 [<ffffffff8108bca8>] ? sched_clock_cpu+0xb8/0x110
 [<ffffffff810ae47d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8108bd6f>] ? local_clock+0x6f/0x80
 [<ffffffff81197859>] do_filp_open+0x49/0xa0
 [<ffffffff81539d6b>] ? _raw_spin_unlock+0x2b/0x40
 [<ffffffff811a54db>] ? alloc_fd+0xab/0x160
 [<ffffffff81187498>] do_sys_open+0x108/0x1e0
 [<ffffffff811875b1>] sys_open+0x21/0x30
 [<ffffffff81542469>] system_call_fastpath+0x16/0x1b
ffff8800715b28c8: redzone 1:0x9f911029d74e35b, redzone 2:0xaaaaaa00aaaaaa
EXT4-fs (dm-0): error count: 29
EXT4-fs (dm-0): initial error at 1324291853: ext4_mb_generate_buddy:739
EXT4-fs (dm-0): last error at 1328623521: ext4_new_inode:941: block 2277397
usb 4-2: USB disconnect, device number 4
wlan0: deauthenticating from 54:e6:fc:98:63:fe by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:i9xx_update_plane], Writing base 00042000 00000000 0 0 6720
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 315128 pages)
PM: Allocated 1260512 kbytes in 6.49 seconds (194.22 MB/s)
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 2:0:0:0: [sda] Synchronizing SCSI cache
pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
ACPI handle has no context!
PM: freeze of devices complete after 173.327 msecs
PM: late freeze of devices complete after 1.700 msecs
Disabling non-boot CPUs ...
CPU 1 is now offline
lockdep: fixing up alternatives.
Extended CMOS year: 2000
PM: Creating hibernation image:
PM: Need to copy 179791 pages
Extended CMOS year: 2000
microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 99000
Disabled fast string operations
Calibrating delay loop (skipped) already calibrated this CPU
NMI watchdog enabled, takes one hw-pmu counter.
microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
CPU1 is up
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
PM: early restore of devices complete after 24.743 msecs
i915 0000:00:02.0: setting latency timer to 64
ata_generic 0000:00:03.2: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1a.2: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: setting latency timer to 64
usb usb1: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
pciehp 0000:00:1c.4:pcie04: pciehp_resume ENTRY
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb7: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb8: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
usb usb2: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
pci 0000:00:1e.0: setting latency timer to 64
ahci 0000:00:1f.2: setting latency timer to 64
dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -19
PM: Device 00:0a failed to restore: error -19
[drm:init_ring_common], render ring head not reset to zero ctl 00000000 head 00001000 tail 00000000 start 00001000
[drm:drm_crtc_helper_set_mode], [CRTC:4]
Extended CMOS year: 2000
firewire_core: skipped bus generations, destroying all nodes
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:i9xx_crtc_mode_set], using SSC reference clock of 100 MHz
[drm:i9xx_crtc_mode_set], Mode for pipe B:
[drm:drm_mode_debug_printmodeline], Modeline 8:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:i9xx_crtc_mode_set], disabling CxSR downclocking
[drm:i9xx_update_plane], Writing base 00042000 00000000 0 0 6720
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:8:1680x1050]
[drm:g4x_check_srwm], SR watermark: display plane 94, cursor 6
[drm:g4x_check_srwm], display watermark is too large(94/63), disabling
[drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=41, cursor=6, SR: plane=94, cursor=6
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata3.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: configured for UDMA/100
sd 2:0:0:0: [sda] Starting disk
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
ata4.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
ata4.00: configured for UDMA/133
usb 1-6: reset high-speed USB device number 2 using ehci_hcd
firewire_core: rediscovered device fw0
PM: restore of devices complete after 661.493 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
[drm:drm_mode_setcrtc], [CRTC:4]
[drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
[drm:drm_crtc_helper_set_config], 
[drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:4]
[drm:i9xx_update_plane], Writing base 006FD000 00000000 0 0 7168
[drm:intel_update_fbc], 
[drm:intel_update_fbc], fbc set to per-chip default
[drm:intel_update_fbc], fbc disabled per module param
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[drm:drm_mode_debug_printmodeline], Modeline 26:"1680x1050" 60 122000 1680 1712 1776 1904 1050 1051 1054 1066 0x48 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"1680x1050" 50 101670 1680 1712 1776 1904 1050 1051 1054 1066 0x40 0xa
[drm:drm_mode_getconnector], [CONNECTOR:5:?]
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:12:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:15:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:18:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DP-1] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:21:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:22:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2]
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:22:DP-2] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:drm_mode_getconnector], [CONNECTOR:24:?]
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3]
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:drm_helper_probe_single_connector_modes], [CONNECTOR:24:DP-3] disconnected
[drm:intel_crt_detect], CRT not detected via hotplug
[drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:18:DP-1] status updated from 2 to 2
[drm:output_poll_execute], [CONNECTOR:21:HDMI-A-2] status updated from 2 to 2
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:22:DP-2] status updated from 2 to 2
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
[drm:intel_dp_detect], DPCD: 0000000000000000
[drm:output_poll_execute], [CONNECTOR:24:DP-3] status updated from 2 to 2
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
ADDRCONF(NETDEV_UP): wlan0: link is not ready
usb 4-2: new full-speed USB device number 5 using uhci_hcd
usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
usb 4-2: Manufacturer: Lenovo Computer Corp
wlan0: authenticate with 54:e6:fc:98:63:fe
wlan0: send auth to 54:e6:fc:98:63:fe (try 1/3)
wlan0: send auth to 54:e6:fc:98:63:fe (try 2/3)
wlan0: authenticated
wlan0: associate with 54:e6:fc:98:63:fe (try 1/3)
wlan0: RX AssocResp from 54:e6:fc:98:63:fe (capab=0x431 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], 
[drm:intel_crtc_cursor_set], cursor off

--W/nzBZO5zC0uMSeA--
