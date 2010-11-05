Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0KETMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:12:08 -0400
Received: from mail32c40.carrierzone.com ([209.235.156.172]:54117 "EHLO
	mail32c40.carrierzone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab0KETME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:12:04 -0400
X-Authenticated-User: mdekoker.signatec.com
From: "Mike DeKoker" <mdekoker@signatec.com>
To: "'Kenji Kaneshige'" <kaneshige.kenji@jp.fujitsu.com>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, "'Bjorn Helgaas'" <bjorn.helgaas@hp.com>
References: <007f01cb7bc5$76c99fd0$645cdf70$@com> <201011040606.33889.rjw@sisk.pl> <4CD39CE2.5010905@jp.fujitsu.com>
In-Reply-To: <4CD39CE2.5010905@jp.fujitsu.com>
Subject: RE: pciehp - Problems with ExpressCard hotplug
Date: Fri, 5 Nov 2010 12:11:17 -0700
Organization: Signatec, Inc.
Message-ID: <003a01cb7d1d$3adbad70$b0930850$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Act8roD22zBN7XjnQRS/NJOwGA1+YgAa23nA
Content-Language: en-us
x-cr-hashedpuzzle: AFQ6 FAP3 K426 QYF7 Qg9B S+qq UttJ X0Wo X9nM Z/vg eR0+ fluk fpSO jzNE nR26 ovbx;5;YgBqAG8AcgBuAC4AaABlAGwAZwBhAGEAcwBAAGgAcAAuAGMAbwBtADsAawBhAG4AZQBzAGgAaQBnAGUALgBrAGUAbgBqAGkAQABqAHAALgBmAHUAagBpAHQAcwB1AC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AcABjAGkAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAagB3AEAAcwBpAHMAawAuAHAAbAA=;Sosha1_v1;7;{33693A47-00DA-4041-9C39-03A5E4577BD1};bQBkAGUAawBvAGsAZQByAEAAcwBpAGcAbgBhAHQAZQBjAC4AYwBvAG0A;Fri, 05 Nov 2010 19:11:07 GMT;UgBFADoAIABwAGMAaQBlAGgAcAAgAC0AIABQAHIAbwBiAGwAZQBtAHMAIAB3AGkAdABoACAARQB4AHAAcgBlAHMAcwBDAGEAcgBkACAAaABvAHQAcABsAHUAZwA=
x-cr-puzzleid: {33693A47-00DA-4041-9C39-03A5E4577BD1}
X-CSC: 0
X-CHA: v=1.1 cv=/R9yLkzXQF1AkW1rvynMMP1Ds2c3RiDiXcXDyRV60RM= c=1 sm=1
		a=U9szkaT8RkQA:10 a=kj9zAlcOel0A:10 a=1FqhxYnyYMgbpOE3yW0okQ==:17
		a=13T92cdfG1QoG1sc418A:9 a=pm0E8VCgKdCUYhkgqr8A:7
		a=8u-j6qqO9SzlNTu4Xo5ExbqJM0oA:4 a=CjuIK1q_8ugA:10 a=Sf_gFPzhefAA:10
		a=0r07juaMFAkDAze2:21 a=_BzGP0ApJdVrpWE-:21 a=1FqhxYnyYMgbpOE3yW0okQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>(2010/11/04 14:06), Rafael J. Wysocki wrote:
>> [CCing linux-pci and Bjorn]
>>
>> On Thursday, November 04, 2010, Mike DeKoker wrote:
>>> Hello everyone, I hope this is the correct forum.
>>>
>>> I'm having a problem with hotplug working for a PCIe-based ExpressCard
>>> device that I'm developing a driver module for. If not hot-plugged,
>>> everything works great. Further, running the exact same laptop/device
>>> hardware but different OS (XP or Win7-64) hot-plugging works okay so I
don't
>>> think this is a simple hardware/BIOS error.
>>>
>>> I've tried several stock kernel versions from 2.6.18 (the version my
>>> customer intends to use) up to 2.6.34.7 (version for all verbiage below)
and
>>> have had fairly consistent behavior.
>>>
>>> The driver module (sig_ec14) is using the pci_register_driver interface
and
>>> in the subsequent probe callback function (after a hot-plug) an error
occurs
>>> when calling pci_enable_device. Here's the relevant dmesg data:
>>>
>>> Insert device:
SNIP
>>>
>>> It looks like the requested memory spaces are not allocated properly.
I'm a
>>> little uncertain about the entity that's actually responsible for
allocating
>>> the resources. Is this a failure of the BIOS or does system software
play a
>>> role in PNP resource allocation for hot-plug? I'm a little out of my
element
>>> here.
>>>
>>> I've also run with pciehp_debug=1 in the event that the extra info makes
>>> sense to someone:
>>>
SNIP
>>>
>>> That 'Surprise Removal' immediately following the 'Card present on
Slot(5)'
>>> message looks like a potential culprit.
>
>I believe this is just an message problem.
>
>It looks like resource allocation code doesn't work for your
>end device...
>
>Could you send the following information
>
>  - whole dmesg output after hot-plugging the device (with pciehp_debug=1)
>  - lspci -vvvxxx output after boot with and without your device (no
>    hotplug operation required)

------- lspci -vvvxxx (Pre device insertion):

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>
00: 86 80 40 2a 06 00 90 20 07 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 90 d1 fe 00 00 00 00 01 00 d1 fe 00 00 00 00
50: 00 00 02 00 03 00 00 00 00 00 00 00 00 00 00 00
60: 05 00 00 f8 00 00 00 00 01 80 d1 fe 00 00 00 00
70: 00 00 00 00 00 00 00 00 01 04 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 11 11 11 11 33 33 00 40 00 4f 00 00 1a 39 00
a0: 20 00 00 14 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 30 02 00 00
e0: 09 00 0a 11 86 7c 40 1c 01 90 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 a0 0f 07 00 00 00 00 00

00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express
Graphics Port (rev 07) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: d0000000-d2ffffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4161
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
HPIrq+ LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 41 2a 07 04 10 00 07 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 70 70 00 00
20: 00 d0 f0 d2 01 c0 f1 cf 00 00 00 00 00 00 00 00
30: 00 00 00 00 88 00 00 00 00 00 00 00 ff 01 08 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
80: 01 90 03 c8 00 00 00 00 0d 80 00 00 3c 10 f4 30
90: 05 a0 01 00 0c 30 e0 fe 61 41 00 00 00 00 00 00
a0: 10 00 41 01 00 80 00 00 00 00 01 00 01 2d 01 02
b0: 43 00 01 11 c0 25 0c 00 e8 01 40 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 01 07 04 00 00 a0 a0 0f 07 00 13 40 00 00

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 80e0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 37 29 05 00 90 02 03 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: e1 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 80c0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 38 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: c1 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at df004c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
00: 86 80 3c 29 06 00 90 02 03 20 03 0c 00 00 00 00
10: 00 4c 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 01 00 00 00 00 01 00 00 01 00 00 08 a0
70: 00 00 c7 03 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 11 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 03 00 0a 17 02 20

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 34
	Region 0: Memory at df000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0200c  Data: 41c9
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint,
MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=7f
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel
00: 86 80 3e 29 06 04 10 00 03 00 03 04 10 00 00 00
10: 04 00 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 01 00 00 07 00 00 00 00 00 00 00 00 00 80 00 00
50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 70 81 00 0c 20 e0 fe 00 00 00 00 c9 41 00 00
70: 10 00 91 00 00 00 00 10 00 08 10 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 04 00 01 00 00 00 00 31 00 a3 02 00 00 00 00
d0: 61 00 a3 02 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: de000000-deffffff
	Prefetchable memory behind bridge: 00000000d3000000-00000000d3ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 40 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 60 60 00 00
20: 00 de f0 de 01 d3 f1 d3 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 01 00 00
40: 10 80 41 01 00 80 00 00 00 00 11 00 11 2c 11 01
50: 43 00 11 30 e0 a0 00 00 38 00 40 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 69 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 33 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: dd000000-ddffffff
	Prefetchable memory behind bridge: 00000000d4000000-00000000d4ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 42 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 50 50 00 00
20: 00 dd f0 dd 01 d4 f1 d4 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 02 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 4c 11 02
50: 00 00 01 10 e0 a0 08 00 38 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 71 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
3 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: dc000000-dcffffff
	Prefetchable memory behind bridge: 00000000d5000000-00000000d5ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=03 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 44 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 40 40 00 00
20: 00 dc f0 dc 01 d5 f1 d5 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 03 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 4c 11 03
50: 00 00 01 10 e0 a0 10 00 38 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 79 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
4 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: db000000-dbffffff
	Prefetchable memory behind bridge: 00000000d6000000-00000000d6ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4181
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=04 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 46 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 05 05 00 30 30 00 00
20: 00 db f0 db 01 d6 f1 d6 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 04 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 2c 11 04
50: 41 00 11 30 e0 a0 18 00 38 00 40 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 81 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 33 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
5 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: da000000-daffffff
	Prefetchable memory behind bridge: 00000000d7000000-00000000d7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4189
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=05 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 48 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 06 06 00 20 20 00 00
20: 00 da f0 da 01 d7 f1 d7 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 01 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 2c 11 05
50: 40 00 11 30 e0 a0 20 00 38 00 40 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 89 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
6 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=07, subordinate=09, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d9000000-d9ffffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000d8ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4191
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=06 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 4a 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 07 09 00 10 10 00 00
20: 00 d9 f0 d9 01 d8 f1 d8 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 02 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 4c 11 06
50: 00 00 01 10 e0 a0 28 00 38 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 91 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 80a0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 34 29 05 00 90 02 03 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at 8080 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 35 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 8060 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 36 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #6 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at 8040 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 39 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at df004800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
00: 86 80 3a 29 06 00 90 02 03 20 03 0c 00 00 00 00
10: 00 48 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 01 00 00 00 00 01 00 00 01 00 00 08 a0
70: 00 00 df 3f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 11 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 03 00 0a 17 02 20

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 30f4
00: 86 80 48 24 07 00 10 00 93 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 0a 0a 20 f0 00 80 22
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 12 00 00
50: 0d 00 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev
03)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel modules: iTCO_wdt
00: 86 80 19 29 07 00 10 02 03 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 04 00 00 80 00 00 00 01 05 00 00 10 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 8b 8a 8b 8b d0 00 00 00 8b 8b 8b 80 f8 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 00 0c 69 00 04 00 61 fd 04 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: a4 0a 00 00 00 02 80 00 2b 1c 0a 00 00 03 00 40
b0: 00 00 f0 00 00 00 00 00 04 80 81 08 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 33 22 11 00 67 45 00 00 cf ff 00 00 08 00 00 00
e0: 09 00 0c 10 20 02 24 03 64 00 00 00 00 00 00 00
f0: 01 c0 d1 fe 00 00 00 00 86 0f 03 00 00 00 00 00

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller
(rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 31
	Region 0: I/O ports at 8108 [size=8]
	Region 1: I/O ports at 8114 [size=4]
	Region 2: I/O ports at 8100 [size=8]
	Region 3: I/O ports at 8110 [size=4]
	Region 4: I/O ports at 8020 [size=32]
	Region 5: Memory at df004000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee0100c  Data: 41a1
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci
00: 86 80 29 29 07 04 b0 02 03 01 06 01 00 00 00 00
10: 09 81 00 00 15 81 00 00 01 81 00 00 11 81 00 00
20: 21 80 00 00 00 40 00 df 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 02 00 00
40: 00 80 00 80 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 a8 03 40 08 00 00 00 00 00 00 00 00 00 00 00
80: 05 70 09 00 0c 10 e0 fe a1 41 00 00 00 00 00 00
90: 60 0e 31 91 93 01 00 0c 00 00 00 00 0c 00 00 00
a0: ac 00 00 00 0a 00 12 00 12 b0 10 00 48 00 00 00
b0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev
03)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at df005000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 8000 [size=32]
	Kernel modules: i2c-i801
00: 86 80 30 29 03 00 80 02 03 00 05 0c 00 00 00 00
10: 04 50 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 02 04 04 00 f0 00 08 08 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

01:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600M GT]
(rev a1) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at d0000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at 7000 [size=128]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1,
Latency L0 <512ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled-
Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1
Len=024 <?>
	Kernel driver in use: nouveau
	Kernel modules: nouveau, nvidiafb
00: de 10 49 06 07 00 10 00 a1 00 00 03 00 00 00 00
10: 00 00 00 d2 0c 00 00 c0 00 00 00 00 04 00 00 d0
20: 00 00 00 00 01 70 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 f8 ff 60 00 00 00 00 00 00 00 0b 01 00 00
40: 3c 10 f4 30 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 03 00 08 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 b4 02 00 e0 84 2c 01
80: 10 28 00 00 02 3d 00 00 4b 00 01 11 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 10 00 00 00
a0: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00
b0: 00 00 00 00 09 00 14 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh]
Network Connection
	Subsystem: Intel Corporation WiFi Link 5100 AGN
	Physical Slot: 0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 33
	Region 0: Memory at de000000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41c1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-21-6b-ff-ff-43-4d-82
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn
00: 86 80 37 42 06 00 10 00 00 00 80 02 00 00 00 00
10: 04 00 00 de 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 11 12
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 23 c8 00 00 00 0d
d0: 05 e0 81 00 0c 30 e0 fe 00 00 00 00 c1 41 00 00
e0: 10 00 01 00 c0 8e 00 10 10 08 19 00 11 9c 06 00
f0: 43 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00

05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B
PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 32
	Region 0: I/O ports at 3000 [size=256]
	Region 2: Memory at d6010000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at d6000000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at d6020000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0200c  Data: 41b9
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP+ Rollover- Timeout+
NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169
	Kernel modules: r8169
00: ec 10 68 81 07 04 10 00 02 00 00 02 10 00 00 00
10: 01 30 00 00 00 00 00 00 0c 00 01 d6 00 00 00 00
20: 0c 00 00 d6 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 ff ff 40 00 00 00 00 00 00 00 0b 01 00 00
40: 01 50 c3 ff 08 00 00 00 00 00 00 00 00 00 00 00
50: 05 70 83 00 0c 20 e0 fe 00 00 00 00 b9 41 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 b0 01 02 c1 86 04 05 10 50 19 00 11 3c 07 00
80: 41 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 11 d0 01 00 04 00 00 00 04 08 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 03 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

06:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host
Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at da000d00 (32-bit, non-prefetchable) [size=128]
	Region 4: Memory at da000c80 (32-bit, non-prefetchable) [size=128]
	Region 5: Memory at da000c00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci
00: 7b 19 80 23 07 00 10 00 00 10 00 0c 00 00 80 00
10: 00 00 00 da 00 0d 00 da 00 00 00 00 00 00 00 00
20: 80 0c 00 da 00 0c 00 da 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 01 80 03 00 08 80 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 89 44 6d 95 48 d4 54 a1 12 00 40 90 80 00 00 00
70: 01 00 00 18 00 00 00 00 00 00 00 00 8f ff 90 72
80: 10 94 01 00 00 80 00 00 10 20 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000b00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci
00: 7b 19 82 23 07 00 10 00 00 00 80 08 00 00 80 00
10: 00 0b 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host
Controller (prog-if 01)
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000a00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel modules: sdhci-pci
00: 7b 19 81 23 03 00 10 00 00 01 05 08 00 00 80 00
10: 00 0a 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.3 System peripheral: JMicron Technology Corp. MS Host Controller
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000900 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel driver in use: jmb38x_ms
	Kernel modules: jmb38x_ms
00: 7b 19 83 23 07 00 10 00 00 00 80 08 00 00 80 00
10: 00 09 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.4 System peripheral: JMicron Technology Corp. xD Host Controller
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at da000800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
00: 7b 19 84 23 07 00 10 00 00 00 80 08 00 00 80 00
10: 00 08 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

------- lspci -vvvxxx (Post device insertion):
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>
00: 86 80 40 2a 06 00 90 20 07 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 90 d1 fe 00 00 00 00 01 00 d1 fe 00 00 00 00
50: 00 00 02 00 03 00 00 00 00 00 00 00 00 00 00 00
60: 05 00 00 f8 00 00 00 00 01 80 d1 fe 00 00 00 00
70: 00 00 00 00 00 00 00 00 01 04 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 11 11 11 11 33 33 00 40 00 4f 00 00 1a 39 00
a0: 20 00 00 14 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 30 02 00 00
e0: 09 00 0a 11 86 7c 40 1c 01 90 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 a0 0f 07 00 00 00 00 00

00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express
Graphics Port (rev 07) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: d0000000-d2ffffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4161
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
HPIrq+ LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 41 2a 07 04 10 00 07 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 70 70 00 00
20: 00 d0 f0 d2 01 c0 f1 cf 00 00 00 00 00 00 00 00
30: 00 00 00 00 88 00 00 00 00 00 00 00 ff 01 08 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
80: 01 90 03 c8 00 00 00 00 0d 80 00 00 3c 10 f4 30
90: 05 a0 01 00 0c 30 e0 fe 61 41 00 00 00 00 00 00
a0: 10 00 41 01 00 80 00 00 00 00 01 00 01 2d 01 02
b0: 43 00 01 11 c0 25 0c 00 e8 01 40 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 01 07 04 00 00 a0 a0 0f 07 00 13 40 00 00

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 80e0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 37 29 05 00 90 02 03 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: e1 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 80c0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 38 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: c1 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at df004c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
00: 86 80 3c 29 06 00 90 02 03 20 03 0c 00 00 00 00
10: 00 4c 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 01 00 00 00 00 01 00 00 01 00 00 08 a0
70: 00 00 c7 03 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 11 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 03 00 0a 17 02 20

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 34
	Region 0: Memory at df000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0200c  Data: 41c9
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint,
MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=7f
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel
00: 86 80 3e 29 06 04 10 00 03 00 03 04 10 00 00 00
10: 04 00 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 01 00 00 07 00 00 00 00 00 00 00 00 00 80 00 00
50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 70 81 00 0c 20 e0 fe 00 00 00 00 c9 41 00 00
70: 10 00 91 00 00 00 00 10 00 08 10 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 04 00 01 00 00 00 00 31 00 a3 02 00 00 00 00
d0: 61 00 a3 02 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: de000000-deffffff
	Prefetchable memory behind bridge: 00000000d3000000-00000000d3ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 40 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 60 60 00 00
20: 00 de f0 de 01 d3 f1 d3 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 01 00 00
40: 10 80 41 01 00 80 00 00 00 00 11 00 11 2c 11 01
50: 43 00 11 30 e0 a0 00 00 38 00 40 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 69 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 33 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: dd000000-ddffffff
	Prefetchable memory behind bridge: 00000000d4000000-00000000d4ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 42 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 50 50 00 00
20: 00 dd f0 dd 01 d4 f1 d4 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 02 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 4c 11 02
50: 00 00 01 10 e0 a0 08 00 38 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 71 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
3 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: dc000000-dcffffff
	Prefetchable memory behind bridge: 00000000d5000000-00000000d5ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=03 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 44 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 40 40 00 00
20: 00 dc f0 dc 01 d5 f1 d5 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 03 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 4c 11 03
50: 00 00 01 10 e0 a0 10 00 38 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 79 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
4 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: db000000-dbffffff
	Prefetchable memory behind bridge: 00000000d6000000-00000000d6ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4181
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=04 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 46 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 05 05 00 30 30 00 00
20: 00 db f0 db 01 d6 f1 d6 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 04 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 2c 11 04
50: 41 00 11 30 e0 a0 18 00 38 00 40 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 81 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 33 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
5 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: da000000-daffffff
	Prefetchable memory behind bridge: 00000000d7000000-00000000d7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4189
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=05 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 48 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 06 06 00 20 20 00 00
20: 00 da f0 da 01 d7 f1 d7 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 01 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 2c 11 05
50: 40 00 11 30 e0 a0 20 00 38 00 40 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 30 e0 fe 89 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
6 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=07, subordinate=09, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d9000000-d9ffffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000d8ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
			Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+
HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0200c  Data: 4191
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 30f4
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=06 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: 86 80 4a 29 07 04 10 00 03 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 07 09 00 10 10 00 00
20: 00 d9 f0 d9 01 d8 f1 d8 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 02 00 00
40: 10 80 41 01 00 80 00 00 00 00 10 00 11 4c 11 06
50: 00 00 11 30 e0 a0 28 00 38 00 40 01 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 05 90 01 00 0c 20 e0 fe 91 41 00 00 00 00 00 00
90: 0d a0 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 11 48 00 00 00 00
e0: 00 0f c7 00 06 07 08 00 31 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 80a0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 34 29 05 00 90 02 03 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at 8080 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 35 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 8060 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 36 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #6 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at 8040 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
00: 86 80 39 29 05 00 90 02 03 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 2f 00 00 00 00 00 00 00 00 01 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at df004800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
00: 86 80 3a 29 06 00 90 02 03 20 03 0c 00 00 00 00
10: 00 48 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 58 c2 c9 00 00 00 00 0a 98 a0 20 00 00 00 00
60: 20 20 ff 01 00 00 00 00 01 00 00 01 00 00 08 a0
70: 00 00 df 3f 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 11 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 13 00 06 03 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 88 85 40 00 86 0f 03 00 0a 17 02 20

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 30f4
00: 86 80 48 24 07 00 10 00 93 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 0a 0a 20 f0 00 80 22
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 12 00 00
50: 0d 00 00 00 3c 10 f4 30 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev
03)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel modules: iTCO_wdt
00: 86 80 19 29 07 00 10 02 03 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 04 00 00 80 00 00 00 01 05 00 00 10 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 8b 8a 8b 8b d0 00 00 00 8b 8b 8b 80 f8 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 00 0c 69 00 04 00 61 fd 04 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: a4 0a 00 00 00 02 80 00 2b 1c 0a 00 00 03 00 40
b0: 00 00 f0 00 00 00 00 00 04 80 81 08 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 33 22 11 00 67 45 00 00 cf ff 00 00 08 00 00 00
e0: 09 00 0c 10 20 02 24 03 64 00 00 00 00 00 00 00
f0: 01 c0 d1 fe 00 00 00 00 86 0f 03 00 00 00 00 00

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller
(rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 31
	Region 0: I/O ports at 8108 [size=8]
	Region 1: I/O ports at 8114 [size=4]
	Region 2: I/O ports at 8100 [size=8]
	Region 3: I/O ports at 8110 [size=4]
	Region 4: I/O ports at 8020 [size=32]
	Region 5: Memory at df004000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee0100c  Data: 41a1
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci
00: 86 80 29 29 07 04 b0 02 03 01 06 01 00 00 00 00
10: 09 81 00 00 15 81 00 00 01 81 00 00 11 81 00 00
20: 21 80 00 00 00 40 00 df 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 02 00 00
40: 00 80 00 80 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 a8 03 40 08 00 00 00 00 00 00 00 00 00 00 00
80: 05 70 09 00 0c 10 e0 fe a1 41 00 00 00 00 00 00
90: 60 0e 31 91 93 01 00 0c 00 00 00 00 0c 00 00 00
a0: ac 00 00 00 0a 00 12 00 12 b0 10 00 48 00 00 00
b0: 13 00 06 03 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev
03)
	Subsystem: Hewlett-Packard Company Device 30f4
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at df005000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 8000 [size=32]
	Kernel modules: i2c-i801
00: 86 80 30 29 03 00 80 02 03 00 05 0c 00 00 00 00
10: 04 50 00 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 80 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 02 04 04 00 f0 00 08 08 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 86 0f 03 00 00 00 00 00

01:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600M GT]
(rev a1) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at d0000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at 7000 [size=128]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1,
Latency L0 <512ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled-
Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1
Len=024 <?>
	Kernel driver in use: nouveau
	Kernel modules: nouveau, nvidiafb
00: de 10 49 06 07 00 10 00 a1 00 00 03 00 00 00 00
10: 00 00 00 d2 0c 00 00 c0 00 00 00 00 04 00 00 d0
20: 00 00 00 00 01 70 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 f8 ff 60 00 00 00 00 00 00 00 0b 01 00 00
40: 3c 10 f4 30 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 03 00 08 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 b4 02 00 e0 84 2c 01
80: 10 28 00 00 02 3d 00 00 4b 00 01 11 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 10 00 00 00
a0: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00
b0: 00 00 00 00 09 00 14 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh]
Network Connection
	Subsystem: Intel Corporation WiFi Link 5100 AGN
	Physical Slot: 0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 33
	Region 0: Memory at de000000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41c1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-21-6b-ff-ff-43-4d-82
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn
00: 86 80 37 42 06 00 10 00 00 00 80 02 00 00 00 00
10: 04 00 00 de 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 11 12
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 01 d0 23 c8 00 00 00 0d
d0: 05 e0 81 00 0c 30 e0 fe 00 00 00 00 c1 41 00 00
e0: 10 00 01 00 c0 8e 00 10 10 08 19 00 11 9c 06 00
f0: 43 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00

05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B
PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 32
	Region 0: I/O ports at 3000 [size=256]
	Region 2: Memory at d6010000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at d6000000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at d6020000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0200c  Data: 41b9
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP+ Rollover- Timeout+
NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169
	Kernel modules: r8169
00: ec 10 68 81 07 04 10 00 02 00 00 02 10 00 00 00
10: 01 30 00 00 00 00 00 00 0c 00 01 d6 00 00 00 00
20: 0c 00 00 d6 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 ff ff 40 00 00 00 00 00 00 00 0b 01 00 00
40: 01 50 c3 ff 08 00 00 00 00 00 00 00 00 00 00 00
50: 05 70 83 00 0c 20 e0 fe 00 00 00 00 b9 41 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 b0 01 02 c1 86 04 05 10 50 19 00 11 3c 07 00
80: 41 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 11 d0 01 00 04 00 00 00 04 08 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 03 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

06:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host
Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at da000d00 (32-bit, non-prefetchable) [size=128]
	Region 4: Memory at da000c80 (32-bit, non-prefetchable) [size=128]
	Region 5: Memory at da000c00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci
00: 7b 19 80 23 07 00 10 00 00 10 00 0c 00 00 80 00
10: 00 00 00 da 00 0d 00 da 00 00 00 00 00 00 00 00
20: 80 0c 00 da 00 0c 00 da 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 01 80 03 00 08 80 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 89 44 6d 95 48 d4 54 a1 12 00 40 90 80 00 00 00
70: 01 00 00 18 00 00 00 00 00 00 00 00 8f ff 90 72
80: 10 94 01 00 00 80 00 00 10 20 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000b00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci
00: 7b 19 82 23 07 00 10 00 00 00 80 08 00 00 80 00
10: 00 0b 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host
Controller (prog-if 01)
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000a00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel modules: sdhci-pci
00: 7b 19 81 23 03 00 10 00 00 01 05 08 00 00 80 00
10: 00 0a 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.3 System peripheral: JMicron Technology Corp. MS Host Controller
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at da000900 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
	Kernel driver in use: jmb38x_ms
	Kernel modules: jmb38x_ms
00: 7b 19 83 23 07 00 10 00 00 00 80 08 00 00 80 00
10: 00 09 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

06:00.4 System peripheral: JMicron Technology Corp. xD Host Controller
	Subsystem: Hewlett-Packard Company Device 30f4
	Physical Slot: 4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at da000800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: fffffffc  Data: 0000
00: 7b 19 84 23 07 00 10 00 00 00 80 08 00 00 80 00
10: 00 08 00 da 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f4 30
30: 00 00 00 00 a4 00 00 00 00 00 00 00 0b 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 94 01 00 00 80 00 00 10 00 00 00 11 fc 03 01
90: 40 00 11 10 05 00 00 00 fc ff ff ff 00 00 00 00
a0: 00 00 00 00 01 80 03 00 08 00 00 00 09 11 47 88
b0: 20 30 88 7f 0c 00 00 80 22 11 a2 00 00 00 00 00
c0: 43 8a 38 a0 03 45 02 02 00 00 00 08 7f 00 00 30
d0: 28 00 00 80 07 08 00 10 00 00 eb 00 ff ff a0 00
e0: 0f cc 06 00 59 19 ff ff ff 71 10 00 b2 3d 07 00
f0: 00 00 00 00 27 bf e0 8b 00 40 00 40 00 00 10 80

07:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI Express-to-PCI
Bridge (rev aa) (prog-if 00 [Normal decode])
	Physical Slot: 5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=07, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: d9000000-d90fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR+ <PERR+
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
BrConfRtry-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Power Budgeting <?>
	Kernel modules: shpchp
00: b5 10 12 81 06 00 10 00 aa 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 07 08 08 00 f0 00 20 e2
20: 00 d9 00 d9 f0 ff 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00
40: 01 50 02 5a 00 00 00 00 10 20 0e 00 00 00 00 00
50: 05 60 80 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 71 00 00 00 04 05 00 20 0a 00 11 4c 02 00
70: 00 00 11 00 80 0c 00 00 00 00 40 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 33 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

08:00.0 Non-VGA unclassified device: Device 1b94:ec14
	Subsystem: Device 1b94:ec14
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 255
	Kernel modules: sig_ec14
00: 94 1b 14 ec 00 00 20 02 00 00 00 00 00 40 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 94 1b 14 ec
30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

-------- dmesg (post device insertion)
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.34.7-61.fc13.x86_64
(mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.4.4 20100630 (Red
Hat 4.4.4-10) (GCC) ) #1 SMP Tue Oct 19 04:06:30 UTC 2010
Command line: ro root=/dev/mapper/VolGroup-lv_root
rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD
rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us rhgb quiet
pciehp.pciehp_force=1 pciehp.pciehp_debug=1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
 BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfd6b000 (usable)
 BIOS-e820: 00000000bfd6b000 - 00000000bfdbf000 (reserved)
 BIOS-e820: 00000000bfdbf000 - 00000000bfe83000 (usable)
 BIOS-e820: 00000000bfe83000 - 00000000bfebf000 (ACPI NVS)
 BIOS-e820: 00000000bfebf000 - 00000000bfedf000 (usable)
 BIOS-e820: 00000000bfedf000 - 00000000bfef6000 (ACPI data)
 BIOS-e820: 00000000bfef6000 - 00000000bfefe000 (usable)
 BIOS-e820: 00000000bfefe000 - 00000000bfeff000 (ACPI data)
 BIOS-e820: 00000000bfeff000 - 00000000bff00000 (usable)
 BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==>
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x140000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 base 0FFF00000 mask FFFF00000 write-protect
  3 base 0BFF00000 mask FFFF00000 uncachable
  4 base 100000000 mask FC0000000 write-back
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xbff00 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000bff00000
 0000000000 - 00bfe00000 page 2M
 00bfe00000 - 00bff00000 page 4k
kernel direct mapping tables up to bff00000 @ 8000-d000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ b000-11000
RAMDISK: 373b6000 - 37ff0000
ACPI: RSDP 00000000000fe020 00024 (v02 HP    )
ACPI: XSDT 00000000bfefe120 00074 (v01 HPQOEM SLIC-MPC 00000001
01000013)
ACPI: FACP 00000000bfef3000 000F4 (v04 HP     VADER    00000001 MSFT
01000013)
ACPI: DSDT 00000000bfee4000 0A652 (v01 HP     VADER    00000001 MSFT
01000013)
ACPI: FACS 00000000bfe8c000 00040
ACPI: DMAR 00000000bfef5000 00098 (v01               ? 00000001
00000000)
ACPI: SSDT 00000000bfef4000 00655 (v01  PmRef    CpuPm 00003000 INTL
20060912)
ACPI: HPET 00000000bfef2000 00038 (v01 HPQOEM SLIC-MPC 00000001 MSFT
01000013)
ACPI: APIC 00000000bfef1000 0006C (v02 HPQOEM SLIC-MPC 00000001 MSFT
01000013)
ACPI: MCFG 00000000bfef0000 0003C (v01 HPQOEM SLIC-MPC 00000001 MSFT
01000013)
ACPI: ASF! 00000000bfeef000 000A5 (v32 HPQOEM SLIC-MPC 00000001 MSFT
01000013)
ACPI: SLIC 00000000bfee3000 00176 (v01 HPQOEM SLIC-MPC 00000001 LOHR
000F4240)
ACPI: BOOT 00000000bfee2000 00028 (v01 HPQOEM SLIC-MPC 00000001 MSFT
01000013)
ACPI: SSDT 00000000bfee1000 00296 (v01 INTEL  SataAhci 00001000 INTL
20060912)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000140000000
Initmem setup node 0 0000000000000000-0000000140000000
  NODE_DATA [0000000100000000 - 0000000100013fff]
  bootmap [0000000100014000 -  000000010003bfff] pages 28
(10/32 early reservations) ==> bootmem [0000000000 - 0140000000]
  #0 [0001000000 - 0001e0be88]    TEXT DATA BSS ==> [0001000000 -
0001e0be88]
  #1 [00373b6000 - 0037ff0000]          RAMDISK ==> [00373b6000 -
0037ff0000]
  #2 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 -
0000100000]
  #3 [0001e0c000 - 0001e0c208]              BRK ==> [0001e0c000 -
0001e0c208]
  #4 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 -
0000003000]
  #5 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 -
0000007000]
  #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 -
000000b000]
  #7 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 -
000000c000]
  #8 [0100000000 - 0100014000]        NODE_DATA ==> [0100000000 -
0100014000]
  #9 [0100014000 - 010003c000]          BOOTMAP ==> [0100014000 -
010003c000]
 [ffffea0000000000-ffffea00045fffff] PMD ->
[ffff880100600000-ffff880103dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000001 -> 0x0000009e
    0: 0x00000100 -> 0x000bfd6b
    0: 0x000bfdbf -> 0x000bfe83
    0: 0x000bfebf -> 0x000bfedf
    0: 0x000bfef6 -> 0x000bfefe
    0: 0x000bfeff -> 0x000bff00
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1048053
  DMA zone: 56 pages used for memmap
  DMA zone: 108 pages reserved
  DMA zone: 3833 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 767632 pages, LIFO batch:31
  Normal zone: 3584 pages used for memmap
  Normal zone: 258560 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bfd6b000 - 00000000bfdbf000
PM: Registered nosave memory: 00000000bfe83000 - 00000000bfebf000
PM: Registered nosave memory: 00000000bfedf000 - 00000000bfef6000
PM: Registered nosave memory: 00000000bfefe000 - 00000000bfeff000
PM: Registered nosave memory: 00000000bff00000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000f8000000
PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 29 pages/cpu @ffff880002000000 s89768 r8192 d20824 u524288
pcpu-alloc: s89768 r8192 d20824 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030025
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/VolGroup-lv_root
rd_LVM_LV=VolGroup/lv_root rd_LVM_LV=VolGroup/lv_swap rd_NO_LUKS rd_NO_MD
rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us rhgb quiet
pciehp.pciehp_force=1 pciehp.pciehp_debug=1
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
------------[ cut here ]------------
WARNING: at drivers/pci/dmar.c:648 check_zero_address+0x96/0x19b()
Hardware name: HP Pavilion dv7 Notebook PC
Your BIOS is broken; DMAR reported at address zero!
BIOS vendor: Hewlett-Packard; Ver: F.23; Product Version: F.23
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.34.7-61.fc13.x86_64 #1
Call Trace:
 [<ffffffff8104d14f>] warn_slowpath_common+0x7c/0x94
 [<ffffffff81454e14>] ? _etext+0x0/0x17c
 [<ffffffff8104d1be>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff81bd9c6e>] check_zero_address+0x96/0x19b
 [<ffffffff81276f71>] ? acpi_tb_verify_table+0x57/0x5b
 [<ffffffff81276867>] ? acpi_get_table_with_size+0x5a/0xb4
 [<ffffffff81454e14>] ? _etext+0x0/0x17c
 [<ffffffff81bd9d85>] detect_intel_iommu+0x12/0x95
 [<ffffffff81bb6839>] pci_iommu_alloc+0x1c/0x28
 [<ffffffff81bc584b>] mem_init+0x19/0xec
 [<ffffffff81bafc86>] start_kernel+0x22a/0x41e
 [<ffffffff81baf2c8>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff81baf3c4>] x86_64_start_kernel+0xf8/0x107
---[ end trace a7919e7f17c0a725 ]---
Memory: 4041060k/5242880k available (4435k kernel code, 1050668k absent,
151152k reserved, 7432k data, 920k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:16640 nr_irqs:440
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2394.193 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency..
4788.38 BogoMIPS (lpj=2394193)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
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
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20100121
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20500 entries in 81 pages
DMAR: Host address width 36
DMAR: DRHD base: 0x00000000000000 flags: 0x1
DMAR: parse DMAR table failure.
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
Booting Node   0, Processors  #1
Brought up 2 CPUs
Total of 2 processors activated (9576.13 BogoMIPS).
sizeof(vma)=184 bytes
sizeof(page)=56 bytes
sizeof(inode)=584 bytes
sizeof(dentry)=192 bytes
sizeof(ext3inode)=800 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=6000 bytes
devtmpfs: initialized
Time: 18:16:34  Date: 11/05/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff]
(base 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000bfd6ec18 00265 (v01  PmRef  Cpu0Ist 00003000 INTL
20060912)
ACPI: SSDT 00000000bfd6c618 005B3 (v01  PmRef  Cpu0Cst 00003001 INTL
20060912)
ACPI: SSDT 00000000bfd6de18 001CF (v01  PmRef    ApIst 00003000 INTL
20060912)
ACPI: SSDT 00000000bfd6ef18 0008D (v01  PmRef    ApCst 00003000 INTL
20060912)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
[Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
[Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: Power Resource [FN00] (on)
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs"
and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
(ignored)
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
(ignored)
DMAR: Forcing write-buffer flush capability
DMAR: Disabling IOMMU for graphics on this chipset
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x80e0-0x80ff]
pci 0000:00:1a.1: reg 20: [io  0x80c0-0x80df]
pci 0000:00:1a.7: reg 10: [mem 0xdf004c00-0xdf004fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xdf000000-0xdf003fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x80a0-0x80bf]
pci 0000:00:1d.1: reg 20: [io  0x8080-0x809f]
pci 0000:00:1d.2: reg 20: [io  0x8060-0x807f]
pci 0000:00:1d.3: reg 20: [io  0x8040-0x805f]
pci 0000:00:1d.7: reg 10: [mem 0xdf004800-0xdf004bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: reg 10: [io  0x8108-0x810f]
pci 0000:00:1f.2: reg 14: [io  0x8114-0x8117]
pci 0000:00:1f.2: reg 18: [io  0x8100-0x8107]
pci 0000:00:1f.2: reg 1c: [io  0x8110-0x8113]
pci 0000:00:1f.2: reg 20: [io  0x8020-0x803f]
pci 0000:00:1f.2: reg 24: [mem 0xdf004000-0xdf0047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xdf005000-0xdf0050ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x8000-0x801f]
pci 0000:01:00.0: reg 10: [mem 0xd2000000-0xd2ffffff]
pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit]
pci 0000:01:00.0: reg 24: [io  0x7000-0x707f]
pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:02:00.0: reg 10: [mem 0xde000000-0xde001fff 64bit]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.0:   bridge window [mem 0xde000000-0xdeffffff]
pci 0000:00:1c.0:   bridge window [mem 0xd3000000-0xd3ffffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.1:   bridge window [mem 0xdd000000-0xddffffff]
pci 0000:00:1c.1:   bridge window [mem 0xd4000000-0xd4ffffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-04]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xdc000000-0xdcffffff]
pci 0000:00:1c.2:   bridge window [mem 0xd5000000-0xd5ffffff 64bit pref]
pci 0000:05:00.0: reg 10: [io  0x3000-0x30ff]
pci 0000:05:00.0: reg 18: [mem 0xd6010000-0xd6010fff 64bit pref]
pci 0000:05:00.0: reg 20: [mem 0xd6000000-0xd600ffff 64bit pref]
pci 0000:05:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
pci 0000:05:00.0: supports D1 D2
pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:00:1c.3: PCI bridge to [bus 05-05]
pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.3:   bridge window [mem 0xdb000000-0xdbffffff]
pci 0000:00:1c.3:   bridge window [mem 0xd6000000-0xd6ffffff 64bit pref]
pci 0000:06:00.0: reg 10: [mem 0xda000000-0xda0007ff]
pci 0000:06:00.0: reg 14: [mem 0xda000d00-0xda000d7f]
pci 0000:06:00.0: reg 20: [mem 0xda000c80-0xda000cff]
pci 0000:06:00.0: reg 24: [mem 0xda000c00-0xda000c7f]
pci 0000:06:00.1: reg 10: [mem 0xda000b00-0xda000bff]
pci 0000:06:00.2: reg 10: [mem 0xda000a00-0xda000aff]
pci 0000:06:00.3: reg 10: [mem 0xda000900-0xda0009ff]
pci 0000:06:00.4: reg 10: [mem 0xda000800-0xda0008ff]
pci 0000:00:1c.4: PCI bridge to [bus 06-06]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xda000000-0xdaffffff]
pci 0000:00:1c.4:   bridge window [mem 0xd7000000-0xd7ffffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 07-09]
pci 0000:00:1c.5:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.5:   bridge window [mem 0xd9000000-0xd9ffffff]
pci 0000:00:1c.5:   bridge window [mem 0xd8000000-0xd8ffffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref]
(disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffffffffffff]
(subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP6._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009e000 - 000000000009ffff 
reserve RAM buffer: 00000000bfd6b000 - 00000000bfffffff 
reserve RAM buffer: 00000000bfe83000 - 00000000bfffffff 
reserve RAM buffer: 00000000bfedf000 - 00000000bfffffff 
reserve RAM buffer: 00000000bfefe000 - 00000000bfffffff 
reserve RAM buffer: 00000000bff00000 - 00000000bfffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:01: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.5
BAR 13 [io  0x1000-0x1fff]
  alloc irq_desc for 23 on node 0
  alloc kstat_irqs on node 0
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [io  0x0600-0x060f] has been reserved
system 00:01: [io  0x0610] has been reserved
system 00:01: [io  0x0800-0x080f] has been reserved
system 00:01: [io  0x0810-0x0817] has been reserved
system 00:01: [io  0x0820-0x0823] has been reserved
system 00:01: [io  0x0400-0x047f] has been reserved
system 00:01: [io  0x0500-0x053f] has been reserved
system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff
pref]
pci 0000:05:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff
pref]
pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x80000)
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.0:   bridge window [mem 0xde000000-0xdeffffff]
pci 0000:00:1c.0:   bridge window [mem 0xd3000000-0xd3ffffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-03]
pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.1:   bridge window [mem 0xdd000000-0xddffffff]
pci 0000:00:1c.1:   bridge window [mem 0xd4000000-0xd4ffffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-04]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xdc000000-0xdcffffff]
pci 0000:00:1c.2:   bridge window [mem 0xd5000000-0xd5ffffff 64bit pref]
pci 0000:05:00.0: BAR 6: assigned [mem 0xd6020000-0xd602ffff pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-05]
pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.3:   bridge window [mem 0xdb000000-0xdbffffff]
pci 0000:00:1c.3:   bridge window [mem 0xd6000000-0xd6ffffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 06-06]
pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.4:   bridge window [mem 0xda000000-0xdaffffff]
pci 0000:00:1c.4:   bridge window [mem 0xd7000000-0xd7ffffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 07-09]
pci 0000:00:1c.5:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.5:   bridge window [mem 0xd9000000-0xd9ffffff]
pci 0000:00:1c.5:   bridge window [mem 0xd8000000-0xd8ffffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 18 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
pci_bus 0000:01: resource 1 [mem 0xd0000000-0xd2ffffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:02: resource 1 [mem 0xde000000-0xdeffffff]
pci_bus 0000:02: resource 2 [mem 0xd3000000-0xd3ffffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:03: resource 1 [mem 0xdd000000-0xddffffff]
pci_bus 0000:03: resource 2 [mem 0xd4000000-0xd4ffffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:04: resource 1 [mem 0xdc000000-0xdcffffff]
pci_bus 0000:04: resource 2 [mem 0xd5000000-0xd5ffffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:05: resource 1 [mem 0xdb000000-0xdbffffff]
pci_bus 0000:05: resource 2 [mem 0xd6000000-0xd6ffffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:06: resource 1 [mem 0xda000000-0xdaffffff]
pci_bus 0000:06: resource 2 [mem 0xd7000000-0xd7ffffff 64bit pref]
pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:07: resource 1 [mem 0xd9000000-0xd9ffffff]
pci_bus 0000:07: resource 2 [mem 0xd8000000-0xd8ffffff 64bit pref]
pci_bus 0000:0a: resource 4 [io  0x0000-0xffff]
pci_bus 0000:0a: resource 5 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:01:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 12520k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff88000219d000 - ffff88000619d000
software IO TLB at phys 0x219d000 - 0x619d000
Simple Boot Flag value 0x5 read from CMOS RAM was invalid
Simple Boot Flag at 0x44 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1288980997.059:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7917
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 24 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 25 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 26 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
  alloc irq_desc for 27 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.2: irq 27 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
  alloc irq_desc for 28 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.3: irq 28 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
  alloc irq_desc for 29 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.4: irq 29 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
  alloc irq_desc for 30 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.5: irq 30 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:01.0:pcie04: Bypassing BIOS check for pciehp use on
0000:00:01.0
pciehp 0000:00:01.0:pcie04: Hotplug Controller:
pciehp 0000:00:01.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:01.0 IRQ 24
pciehp 0000:00:01.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:01.0:pcie04:   Device ID            : 0x2a41
pciehp 0000:00:01.0:pcie04:   Subsystem ID         : 0x30f4
pciehp 0000:00:01.0:pcie04:   Subsystem Vendor ID  : 0x103c
pciehp 0000:00:01.0:pcie04:   PCIe Cap offset      : 0xa0
pciehp 0000:00:01.0:pcie04:   PCI resource [13]     : [io  0x7000-0x7fff]
pciehp 0000:00:01.0:pcie04:   PCI resource [14]     : [mem
0xd0000000-0xd2ffffff]
pciehp 0000:00:01.0:pcie04:   PCI resource [15]     : [mem
0xc0000000-0xcfffffff 64bit pref]
pciehp 0000:00:01.0:pcie04: Slot Capabilities      : 0x000c25c0
pciehp 0000:00:01.0:pcie04:   Physical Slot Number : 1
pciehp 0000:00:01.0:pcie04:   Attention Button     :  no
pciehp 0000:00:01.0:pcie04:   Power Controller     :  no
pciehp 0000:00:01.0:pcie04:   MRL Sensor           :  no
pciehp 0000:00:01.0:pcie04:   Attention Indicator  :  no
pciehp 0000:00:01.0:pcie04:   Power Indicator      :  no
pciehp 0000:00:01.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:00:01.0:pcie04:   EMI Present          :  no
pciehp 0000:00:01.0:pcie04:   Command Completed    :  no
pciehp 0000:00:01.0:pcie04: Slot Status            : 0x0048
pciehp 0000:00:01.0:pcie04: Slot Control           : 0x01c0
pciehp 0000:00:01.0:pcie04: HPC vendor_id 8086 device_id 2a41 ss_vid 103c
ss_did 30f4
pciehp 0000:00:01.0:pcie04: Registering domain:bus:dev=0000:01:00 sun=1
pciehp 0000:00:01.0:pcie04: pciehp_get_power_status: SLOTCTRL b8 value read
1e8
pciehp 0000:00:01.0:pcie04: pciehp_check_link_status: lnk_status = 1101
pciehp 0000:00:01.0:pcie04: Device 0000:01:00.0 already exists at
0000:01:00, cannot hot-add
pciehp 0000:00:01.0:pcie04: Cannot add device at 0000:01:00
pciehp 0000:00:01.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.0:pcie04: Bypassing BIOS check for pciehp use on
0000:00:1c.0
pciehp 0000:00:1c.0:pcie04: Hotplug Controller:
pciehp 0000:00:1c.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.0 IRQ 25
pciehp 0000:00:1c.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:1c.0:pcie04:   Device ID            : 0x2940
pciehp 0000:00:1c.0:pcie04:   Subsystem ID         : 0x30f4
pciehp 0000:00:1c.0:pcie04:   Subsystem Vendor ID  : 0x103c
pciehp 0000:00:1c.0:pcie04:   PCIe Cap offset      : 0x40
pciehp 0000:00:1c.0:pcie04:   PCI resource [13]     : [io  0x6000-0x6fff]
pciehp 0000:00:1c.0:pcie04:   PCI resource [14]     : [mem
0xde000000-0xdeffffff]
pciehp 0000:00:1c.0:pcie04:   PCI resource [15]     : [mem
0xd3000000-0xd3ffffff 64bit pref]
pciehp 0000:00:1c.0:pcie04: Slot Capabilities      : 0x0000a0e0
pciehp 0000:00:1c.0:pcie04:   Physical Slot Number : 0
pciehp 0000:00:1c.0:pcie04:   Attention Button     :  no
pciehp 0000:00:1c.0:pcie04:   Power Controller     :  no
pciehp 0000:00:1c.0:pcie04:   MRL Sensor           :  no
pciehp 0000:00:1c.0:pcie04:   Attention Indicator  :  no
pciehp 0000:00:1c.0:pcie04:   Power Indicator      :  no
pciehp 0000:00:1c.0:pcie04:   Hot-Plug Surprise    : yes
pciehp 0000:00:1c.0:pcie04:   EMI Present          :  no
pciehp 0000:00:1c.0:pcie04:   Command Completed    : yes
pciehp 0000:00:1c.0:pcie04: Slot Status            : 0x0040
pciehp 0000:00:1c.0:pcie04: Slot Control           : 0x0009
pciehp 0000:00:1c.0:pcie04: Link Active Reporting supported
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 103c
ss_did 30f4
pciehp 0000:00:1c.0:pcie04: Registering domain:bus:dev=0000:02:00 sun=0
pciehp 0000:00:1c.0:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read
38
pciehp 0000:00:1c.0:pcie04: pciehp_check_link_status: lnk_status = 3011
pciehp 0000:00:1c.0:pcie04: Device 0000:02:00.0 already exists at
0000:02:00, cannot hot-add
pciehp 0000:00:1c.0:pcie04: Cannot add device at 0000:02:00
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.1:pcie04: Bypassing BIOS check for pciehp use on
0000:00:1c.1
pciehp 0000:00:1c.1:pcie04: Hotplug Controller:
pciehp 0000:00:1c.1:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.1 IRQ 26
pciehp 0000:00:1c.1:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:1c.1:pcie04:   Device ID            : 0x2942
pciehp 0000:00:1c.1:pcie04:   Subsystem ID         : 0x30f4
pciehp 0000:00:1c.1:pcie04:   Subsystem Vendor ID  : 0x103c
pciehp 0000:00:1c.1:pcie04:   PCIe Cap offset      : 0x40
pciehp 0000:00:1c.1:pcie04:   PCI resource [13]     : [io  0x5000-0x5fff]
pciehp 0000:00:1c.1:pcie04:   PCI resource [14]     : [mem
0xdd000000-0xddffffff]
pciehp 0000:00:1c.1:pcie04:   PCI resource [15]     : [mem
0xd4000000-0xd4ffffff 64bit pref]
pciehp 0000:00:1c.1:pcie04: Slot Capabilities      : 0x0008a0e0
pciehp 0000:00:1c.1:pcie04:   Physical Slot Number : 1
pciehp 0000:00:1c.1:pcie04:   Attention Button     :  no
pciehp 0000:00:1c.1:pcie04:   Power Controller     :  no
pciehp 0000:00:1c.1:pcie04:   MRL Sensor           :  no
pciehp 0000:00:1c.1:pcie04:   Attention Indicator  :  no
pciehp 0000:00:1c.1:pcie04:   Power Indicator      :  no
pciehp 0000:00:1c.1:pcie04:   Hot-Plug Surprise    : yes
pciehp 0000:00:1c.1:pcie04:   EMI Present          :  no
pciehp 0000:00:1c.1:pcie04:   Command Completed    : yes
pciehp 0000:00:1c.1:pcie04: Slot Status            : 0x0000
pciehp 0000:00:1c.1:pcie04: Slot Control           : 0x0009
pciehp 0000:00:1c.1:pcie04: Link Active Reporting supported
pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 103c
ss_did 30f4
pciehp 0000:00:1c.1:pcie04: Registering domain:bus:dev=0000:03:00 sun=1
pciehp 0000:00:1c.1:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read
38
pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.2:pcie04: Bypassing BIOS check for pciehp use on
0000:00:1c.2
pciehp 0000:00:1c.2:pcie04: Hotplug Controller:
pciehp 0000:00:1c.2:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.2 IRQ 27
pciehp 0000:00:1c.2:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:1c.2:pcie04:   Device ID            : 0x2944
pciehp 0000:00:1c.2:pcie04:   Subsystem ID         : 0x30f4
pciehp 0000:00:1c.2:pcie04:   Subsystem Vendor ID  : 0x103c
pciehp 0000:00:1c.2:pcie04:   PCIe Cap offset      : 0x40
pciehp 0000:00:1c.2:pcie04:   PCI resource [13]     : [io  0x4000-0x4fff]
pciehp 0000:00:1c.2:pcie04:   PCI resource [14]     : [mem
0xdc000000-0xdcffffff]
pciehp 0000:00:1c.2:pcie04:   PCI resource [15]     : [mem
0xd5000000-0xd5ffffff 64bit pref]
pciehp 0000:00:1c.2:pcie04: Slot Capabilities      : 0x0010a0e0
pciehp 0000:00:1c.2:pcie04:   Physical Slot Number : 2
pciehp 0000:00:1c.2:pcie04:   Attention Button     :  no
pciehp 0000:00:1c.2:pcie04:   Power Controller     :  no
pciehp 0000:00:1c.2:pcie04:   MRL Sensor           :  no
pciehp 0000:00:1c.2:pcie04:   Attention Indicator  :  no
pciehp 0000:00:1c.2:pcie04:   Power Indicator      :  no
pciehp 0000:00:1c.2:pcie04:   Hot-Plug Surprise    : yes
pciehp 0000:00:1c.2:pcie04:   EMI Present          :  no
pciehp 0000:00:1c.2:pcie04:   Command Completed    : yes
pciehp 0000:00:1c.2:pcie04: Slot Status            : 0x0000
pciehp 0000:00:1c.2:pcie04: Slot Control           : 0x0009
pciehp 0000:00:1c.2:pcie04: Link Active Reporting supported
pciehp 0000:00:1c.2:pcie04: HPC vendor_id 8086 device_id 2944 ss_vid 103c
ss_did 30f4
pciehp 0000:00:1c.2:pcie04: Registering domain:bus:dev=0000:04:00 sun=2
pciehp 0000:00:1c.2:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read
38
pciehp 0000:00:1c.2:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.3:pcie04: Bypassing BIOS check for pciehp use on
0000:00:1c.3
pciehp 0000:00:1c.3:pcie04: Hotplug Controller:
pciehp 0000:00:1c.3:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.3 IRQ 28
pciehp 0000:00:1c.3:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:1c.3:pcie04:   Device ID            : 0x2946
pciehp 0000:00:1c.3:pcie04:   Subsystem ID         : 0x30f4
pciehp 0000:00:1c.3:pcie04:   Subsystem Vendor ID  : 0x103c
pciehp 0000:00:1c.3:pcie04:   PCIe Cap offset      : 0x40
pciehp 0000:00:1c.3:pcie04:   PCI resource [13]     : [io  0x3000-0x3fff]
pciehp 0000:00:1c.3:pcie04:   PCI resource [14]     : [mem
0xdb000000-0xdbffffff]
pciehp 0000:00:1c.3:pcie04:   PCI resource [15]     : [mem
0xd6000000-0xd6ffffff 64bit pref]
pciehp 0000:00:1c.3:pcie04: Slot Capabilities      : 0x0018a0e0
pciehp 0000:00:1c.3:pcie04:   Physical Slot Number : 3
pciehp 0000:00:1c.3:pcie04:   Attention Button     :  no
pciehp 0000:00:1c.3:pcie04:   Power Controller     :  no
pciehp 0000:00:1c.3:pcie04:   MRL Sensor           :  no
pciehp 0000:00:1c.3:pcie04:   Attention Indicator  :  no
pciehp 0000:00:1c.3:pcie04:   Power Indicator      :  no
pciehp 0000:00:1c.3:pcie04:   Hot-Plug Surprise    : yes
pciehp 0000:00:1c.3:pcie04:   EMI Present          :  no
pciehp 0000:00:1c.3:pcie04:   Command Completed    : yes
pciehp 0000:00:1c.3:pcie04: Slot Status            : 0x0040
pciehp 0000:00:1c.3:pcie04: Slot Control           : 0x0009
pciehp 0000:00:1c.3:pcie04: Link Active Reporting supported
pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 103c
ss_did 30f4
pciehp 0000:00:1c.3:pcie04: Registering domain:bus:dev=0000:05:00 sun=3
pciehp 0000:00:1c.3:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read
38
pciehp 0000:00:1c.3:pcie04: pciehp_check_link_status: lnk_status = 3011
pciehp 0000:00:1c.3:pcie04: Device 0000:05:00.0 already exists at
0000:05:00, cannot hot-add
pciehp 0000:00:1c.3:pcie04: Cannot add device at 0000:05:00
pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.4:pcie04: Bypassing BIOS check for pciehp use on
0000:00:1c.4
pciehp 0000:00:1c.4:pcie04: Hotplug Controller:
pciehp 0000:00:1c.4:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.4 IRQ 29
pciehp 0000:00:1c.4:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:1c.4:pcie04:   Device ID            : 0x2948
pciehp 0000:00:1c.4:pcie04:   Subsystem ID         : 0x30f4
pciehp 0000:00:1c.4:pcie04:   Subsystem Vendor ID  : 0x103c
pciehp 0000:00:1c.4:pcie04:   PCIe Cap offset      : 0x40
pciehp 0000:00:1c.4:pcie04:   PCI resource [13]     : [io  0x2000-0x2fff]
pciehp 0000:00:1c.4:pcie04:   PCI resource [14]     : [mem
0xda000000-0xdaffffff]
pciehp 0000:00:1c.4:pcie04:   PCI resource [15]     : [mem
0xd7000000-0xd7ffffff 64bit pref]
pciehp 0000:00:1c.4:pcie04: Slot Capabilities      : 0x0020a0e0
pciehp 0000:00:1c.4:pcie04:   Physical Slot Number : 4
pciehp 0000:00:1c.4:pcie04:   Attention Button     :  no
pciehp 0000:00:1c.4:pcie04:   Power Controller     :  no
pciehp 0000:00:1c.4:pcie04:   MRL Sensor           :  no
pciehp 0000:00:1c.4:pcie04:   Attention Indicator  :  no
pciehp 0000:00:1c.4:pcie04:   Power Indicator      :  no
pciehp 0000:00:1c.4:pcie04:   Hot-Plug Surprise    : yes
pciehp 0000:00:1c.4:pcie04:   EMI Present          :  no
pciehp 0000:00:1c.4:pcie04:   Command Completed    : yes
pciehp 0000:00:1c.4:pcie04: Slot Status            : 0x0040
pciehp 0000:00:1c.4:pcie04: Slot Control           : 0x0009
pciehp 0000:00:1c.4:pcie04: Link Active Reporting supported
pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 2948 ss_vid 103c
ss_did 30f4
pciehp 0000:00:1c.4:pcie04: Registering domain:bus:dev=0000:06:00 sun=4
pciehp 0000:00:1c.4:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read
38
pciehp 0000:00:1c.4:pcie04: pciehp_check_link_status: lnk_status = 3011
pciehp 0000:00:1c.4:pcie04: Device 0000:06:00.0 already exists at
0000:06:00, cannot hot-add
pciehp 0000:00:1c.4:pcie04: Cannot add device at 0000:06:00
pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.5:pcie04: Bypassing BIOS check for pciehp use on
0000:00:1c.5
pciehp 0000:00:1c.5:pcie04: Hotplug Controller:
pciehp 0000:00:1c.5:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.5 IRQ 30
pciehp 0000:00:1c.5:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:1c.5:pcie04:   Device ID            : 0x294a
pciehp 0000:00:1c.5:pcie04:   Subsystem ID         : 0x30f4
pciehp 0000:00:1c.5:pcie04:   Subsystem Vendor ID  : 0x103c
pciehp 0000:00:1c.5:pcie04:   PCIe Cap offset      : 0x40
pciehp 0000:00:1c.5:pcie04:   PCI resource [13]     : [io  0x1000-0x1fff]
pciehp 0000:00:1c.5:pcie04:   PCI resource [14]     : [mem
0xd9000000-0xd9ffffff]
pciehp 0000:00:1c.5:pcie04:   PCI resource [15]     : [mem
0xd8000000-0xd8ffffff 64bit pref]
pciehp 0000:00:1c.5:pcie04: Slot Capabilities      : 0x0028a0e0
pciehp 0000:00:1c.5:pcie04:   Physical Slot Number : 5
pciehp 0000:00:1c.5:pcie04:   Attention Button     :  no
pciehp 0000:00:1c.5:pcie04:   Power Controller     :  no
pciehp 0000:00:1c.5:pcie04:   MRL Sensor           :  no
pciehp 0000:00:1c.5:pcie04:   Attention Indicator  :  no
pciehp 0000:00:1c.5:pcie04:   Power Indicator      :  no
pciehp 0000:00:1c.5:pcie04:   Hot-Plug Surprise    : yes
pciehp 0000:00:1c.5:pcie04:   EMI Present          :  no
pciehp 0000:00:1c.5:pcie04:   Command Completed    : yes
pciehp 0000:00:1c.5:pcie04: Slot Status            : 0x0000
pciehp 0000:00:1c.5:pcie04: Slot Control           : 0x0009
pciehp 0000:00:1c.5:pcie04: Link Active Reporting supported
pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086 device_id 294a ss_vid 103c
ss_did 30f4
pciehp 0000:00:1c.5:pcie04: Registering domain:bus:dev=0000:07:00 sun=5
pciehp 0000:00:1c.5:pcie04: pciehp_get_power_status: SLOTCTRL 58 value read
38
pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
pciehp: pcie_port_service_register = 0
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
ACPI: AC Adapter [AC] (on-line)
input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID0]
input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
ACPI: Fan [FAN] (on)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
Switching to clocksource hpet
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (49 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
  alloc irq_desc for 21 on node -1
  alloc kstat_irqs on node -1
ahci 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
  alloc irq_desc for 31 on node -1
  alloc kstat_irqs on node -1
ahci 0000:00:1f.2: irq 31 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA
mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum
part ccc ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xdf004000 port 0xdf004100 irq 31
ata2: SATA max UDMA/133 abar m2048@0xdf004000 port 0xdf004180 irq 31
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq
31
ata6: SATA max UDMA/133 abar m2048@0xdf004000 port 0xdf004380 irq 31
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xdf004c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
  alloc irq_desc for 20 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdf004800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000080e0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x000080c0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000080a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
  alloc irq_desc for 22 on node -1
  alloc kstat_irqs on node -1
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00008080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00008060
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00008040
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.34.7-61.fc13.x86_64 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.3
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised:
dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
PM: Resume from disk failed.
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
  Magic number: 2:36:291
tty tty24: hash matches
rtc_cmos 00:03: setting system clock to 2010-11-05 18:16:39 UTC (1288980999)
Initalizing network drop monitor service
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
ACPI: Battery Slot [BAT0] (battery present)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51
Err=0x04)
ata1.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
usb 2-5: new high speed USB device using ehci_hcd and address 3
ata1.00: ATA-8: ST9500420ASG, 0002SDM1, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51
Err=0x04)
ata1.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9500420ASG     0002 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
usb 2-5: New USB device found, idVendor=046d, idProduct=09b8
usb 2-5: New USB device strings: Mfr=0, Product=2, SerialNumber=0
usb 2-5: Product: HP Webcam 
usb 3-1: new full speed USB device using uhci_hcd and address 2
ata2: SATA link down (SStatus 4 SControl 300)
usb 3-1: New USB device found, idVendor=03f0, idProduct=171d
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: HP Integrated Module
usb 3-1: Manufacturer: Broadcom Corp
usb 5-1: new low speed USB device using uhci_hcd and address 2
usb 5-1: New USB device found, idVendor=045e, idProduct=0095
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: Microsoft IntelliMouseR Explorer
usb 5-1: Manufacturer: Microsoft
input: Microsoft Microsoft IntelliMouseR Explorer as
/devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input5
generic-usb 0003:045E:0095.0001: input,hidraw0: USB HID v1.11 Mouse
[Microsoft Microsoft IntelliMouseR Explorer] on usb-0000:00:1d.0-1/input0
Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1a0b1, caps:
0xd04751/0xa00000/0x20000
input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input6
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51
Err=0x04)
ata5.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata5.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: ATAPI: HL-DT-ST BDDVDRW CT10L, YC07, max UDMA/100
ata5.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51
Err=0x04)
ata5.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata5.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata5.00: configured for UDMA/100
scsi 4:0:0:0: CD-ROM            HL-DT-ST BDDVDRW CT10L    YC07 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
ata6: SATA link down (SStatus 0 SControl 300)
Freeing unused kernel memory: 920k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1688k freed
Freeing unused kernel memory: 1944k freed
dracut: dracut-005-3.fc13
dracut: rd_NO_LUKS: removing cryptoluks activation
udev: starting version 153
[Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
acpi device:06: registered as cooling_device3
input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:05/LNXVIDEO:01/input/inpu
t7
ACPI: Video Device [EVGA] (multi-head: yes  rom: no  post: no)
[drm] Initialized drm 1.1.0 20060810
nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nouveau 0000:01:00.0: setting latency timer to 64
[drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x096480c1)
[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[drm] nouveau 0000:01:00.0: ... appears to be valid
[drm] nouveau 0000:01:00.0: BIT BIOS found
[drm] nouveau 0000:01:00.0: Bios version 62.94.4a.00
[drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not currently supported
[drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000323 00010034
[drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02011300 00000028
[drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02032332 00020010
[drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000
[drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[drm] nouveau 0000:01:00.0:   2: 0x00001261: type 0x61 idx 2 tag 0x07
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xCFAA
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD3F7
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xE447
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xE590
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xE7FC
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xE861
[drm] nouveau 0000:01:00.0: 0xE861: Condition still not met after 20ms,
skipping following opcodes
[drm] nouveau 0000:01:00.0: 0xBB58: parsing output script 0
[drm] nouveau 0000:01:00.0: 0xBF7C: parsing output script 0
[drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
[TTM] Zone  kernel: Available graphics memory: 2029066 kiB.
[TTM] Initializing pool allocator.
[drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[drm] nouveau 0000:01:00.0: gpio tag 0xff not found
[drm] nouveau 0000:01:00.0: gpio tag 0xff not found
[drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
Slow work thread pool: Starting up
Slow work thread pool: Ready
[drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x40240000, bo
ffff880137eb9000
fbcon: nouveaufb (fb0) is primary device
[drm] nouveau 0000:01:00.0: 0xBA13: parsing clock script 0
Console: switching to colour frame buffer device 180x56
fb0: nouveaufb frame buffer device
drm: registered panic notifier
[drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
dracut: Starting plymouth daemon
[drm] nouveau 0000:01:00.0: 0xBB53: parsing clock script 1
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
firewire_ohci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
firewire_ohci 0000:06:00.0: setting latency timer to 64
firewire_ohci: Added fw-ohci device 0000:06:00.0, OHCI v1.10, 4 IR + 4 IT
contexts, quirks 0x0
dracut: Scanning devices sda2  for LVM logical volumes VolGroup/lv_root
VolGroup/lv_swap 
dracut: inactive '/dev/VolGroup/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/VolGroup/lv_home' [409.38 GiB] inherit
dracut: inactive '/dev/VolGroup/lv_swap' [5.88 GiB] inherit
firewire_core: created device fw0: GUID 8c3f0200741f40d9, S400
EXT4-fs (dm-0): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/mapper/VolGroup-lv_root
dracut: Loading SELinux policy
type=1404 audit(1288981005.444:2): enforcing=1 old_enforcing=0
auid=4294967295 ses=4294967295
SELinux: 2048 avtab hash slots, 201384 rules.
SELinux: 2048 avtab hash slots, 201384 rules.
SELinux:  9 users, 13 roles, 3341 types, 172 bools, 1 sens, 1024 cats
SELinux:  77 classes, 201384 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses
genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1288981005.794:3): policy loaded auid=4294967295
ses=4294967295
dracut: Switching root
readahead: starting
udev: starting version 153
lis3lv02d: hardware type DV7 found.
lis3lv02d: 8 bits sensor found
lirc_dev: IR Remote Control driver registered, major 249 
enecir 00:0a: lirc_dev: driver enecir registered at minor = 0
enecir: KB3926C detected, driver support is not complete!
enecir: chip is 0x3926 - 0x00, 0xc0
enecir: hardware features:
enecir: learning and tx off, gpio40_learn off, fan_in off
enecir: driver has been succesfully loaded
input: ST LIS3LV02DL Accelerometer as
/devices/platform/lis3lv02d/input/input8
Registered led device: hp::hddprotect
lis3lv02d driver loaded.
ACPI: WMI: Skipping duplicate GUID 05901221-D566-11D1-B2F0-00A0C9062910
ACPI: WMI: Mapper loaded
microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>,
Peter Oruba
jmb38x_ms 0000:06:00.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
jmb38x_ms 0000:06:00.3: setting latency timer to 64
cfg80211: Calling CRDA to update world regulatory domain
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:06:00.1: SDHCI controller found [197b:2382] (rev 0)
sdhci-pci 0000:06:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sdhci-pci 0000:06:00.1: setting latency timer to 64
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:06:00.1] using DMA
sdhci-pci 0000:06:00.2: SDHCI controller found [197b:2381] (rev 0)
sdhci-pci 0000:06:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sdhci-pci 0000:06:00.2: Refusing to bind to secondary interface.
sdhci-pci 0000:06:00.2: PCI INT A disabled
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: resource 0000:00:1f.3 [io  0x8000-0x801f] conflicts with ACPI region
SMBI [io  0x8000-0x800f 64bit window disabled]
ACPI: If an ACPI driver is available for this device, you should use it
instead of the native driver
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
input: HP WMI hotkeys as /devices/virtual/input/input9
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Linux video capture interface: v2.00
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
uvcvideo: Found UVC 1.00 device HP Webcam  (046d:09b8)
input: HP Webcam  as
/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input10
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
r8169 0000:05:00.0: setting latency timer to 64
  alloc irq_desc for 32 on node -1
  alloc kstat_irqs on node -1
r8169 0000:05:00.0: irq 32 for MSI/MSI-X
r8169 0000:05:00.0: eth0: RTL8168c/8111c at 0xffffc90008e9c000,
00:1e:ec:fc:96:43, XID 1c4000c0 IRQ 32
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
iwlagn 0000:02:00.0: setting latency timer to 64
iwlagn 0000:02:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
type=1400 audit(1288981010.024:4): avc:  denied  { mmap_zero } for  pid=688
comm="vbetool" scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023
tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
  alloc irq_desc for 33 on node -1
  alloc kstat_irqs on node -1
iwlagn 0000:02:00.0: irq 33 for MSI/MSI-X
iwlagn 0000:02:00.0: firmware: requesting iwlwifi-5000-2.ucode
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 22 (level, low) -> IRQ 22
  alloc irq_desc for 34 on node -1
  alloc kstat_irqs on node -1
HDA Intel 0000:00:1b.0: irq 34 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
iwlagn 0000:02:00.0: loaded firmware version 8.24.2.12
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
    (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
phy0: Selected rate control algorithm 'iwl-agn-rs'
ALSA sound/pci/hda/patch_sigmatel.c:5725: mute LED gpio 1 polarity 1
ALSA sound/pci/hda/hda_codec.c:4385: autoconfig: line_outs=1
(0xd/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4389:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4393:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4394:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:4397:    dig-out=0x1e/0x0
ALSA sound/pci/hda/hda_codec.c:4405:    inputs: mic=0xb, fmic=0x0, line=0x0,
fline=0x0, cd=0x0, aux=0x0
ALSA sound/pci/hda/patch_sigmatel.c:3014: stac92xx: dac_nids=1
(0x10/0x0/0x0/0x0/0x0)
input: HDA Intel Mic at Ext Front Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
input: HDA Intel HP Out at Ext Front Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
EXT4-fs (sda1): mounted filesystem with ordered data mode
SELinux: initialized (dev sda1, type ext4), uses xattr
EXT4-fs (dm-2): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-2, type ext4), uses xattr
Adding 6160380k swap on /dev/mapper/VolGroup-lv_swap.  Priority:-1 extents:1
across:6160380k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses
genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
ADDRCONF(NETDEV_UP): wlan0: link is not ready
r8169 0000:05:00.0: eth0: link up
r8169 0000:05:00.0: eth0: link up
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
[drm] nouveau 0000:01:00.0: Allocating FIFO number 2
[drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 2
eth0: no IPv6 routers present
fuse init (API version 7.13)
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
pciehp 0000:00:1c.5:pcie04: pcie_isr: intr_loc 8
pciehp 0000:00:1c.5:pcie04: Presence/Notify input change
pciehp 0000:00:1c.5:pcie04: Card present on Slot(5)
pciehp 0000:00:1c.5:pcie04: Surprise Removal
pciehp 0000:00:1c.5:pcie04: pciehp_check_link_status: lnk_status = 3011
pci 0000:07:00.0: supports D1
pci 0000:07:00.0: PME# supported from D0 D1 D3hot
pci 0000:07:00.0: PME# disabled
pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it
with 'pcie_aspm=force'
pci 0000:08:00.0: reg 10: [mem 0x00000000-0x0000001f]
pci 0000:08:00.0: reg 14: [mem 0x00000000-0x0000007f]
pci 0000:08:00.0: reg 18: [mem 0x00000000-0x0000003f]
pci 0000:07:00.0: PCI bridge to [bus 08-ff]
pci 0000:07:00.0:   bridge window [io  0x0000-0x0000] (disabled)
pci 0000:07:00.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
pci 0000:07:00.0:   bridge window [mem 0x00000000-0x000fffff pref]
(disabled)
pci 0000:07:00.0: BAR 14: assigned [mem 0xd9000000-0xd90fffff]
pci 0000:07:00.0: PCI bridge to [bus 08-08]
pci 0000:07:00.0:   bridge window [io  disabled]
pci 0000:07:00.0:   bridge window [mem 0xd9000000-0xd90fffff]
pci 0000:07:00.0:   bridge window [mem pref disabled]
pcieport 0000:00:1c.5: PCI bridge to [bus 07-09]
pcieport 0000:00:1c.5:   bridge window [io  0x1000-0x1fff]
pcieport 0000:00:1c.5:   bridge window [mem 0xd9000000-0xd9ffffff]
pcieport 0000:00:1c.5:   bridge window [mem 0xd8000000-0xd8ffffff 64bit
pref]
pcieport 0000:00:1c.5: setting latency timer to 64
pci 0000:07:00.0: enabling device (0000 -> 0002)
pci 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:07:00.0: setting latency timer to 64
pci 0000:07:00.0: no hotplug settings from platform
pci 0000:08:00.0: no hotplug settings from platform
pci 0000:08:00.0: using default PCI settings
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
sig_ec14 : Signatec EC14 driver module loading
sig_ec14 :  Verbose module output enabled (development build)
sig_ec14 : Dynamic major number: 248
sig_ec14 : PCI probe: New EC14 device
sig_ec14 0000:08:00.0: device not available (can't reserve [mem
0x00000000-0x0000001f])
sig_ec14 : Failed to enable PCI device: -22
sig_ec14: probe of 0000:08:00.0 failed with error -22

Note: There's a problem with drivers/pci/dmar.c in dmesg data. I've only
been getting this with this latest kernel (2.6.34.7). In terms of my
particular problem, I had the same behavior with 2.6.27 and no reported
problems with whatever dmar.c belongs to.

Thank you,
Mike DeKoker.

