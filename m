Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1C3XdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:33:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55784 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1C3XdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:33:05 -0400
Message-ID: <4D93BDA9.1020107@canonical.com>
Date: Wed, 30 Mar 2011 18:32:57 -0500
From: Manoj <manoj.iyer@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com> <m34o6k43c4.fsf@pullcord.laptop.org>
In-Reply-To: <m34o6k43c4.fsf@pullcord.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> * turn on CONFIG_MMC_DEBUG and post output
> * see if sdhci.debug_quirks=1 helps

It could be that this card does not support MMC cards, it shows up as 
SDHCI controller and does not mention MMC, or may be they all come up as 
SDHCI, I dont know enough to make that assessment.

Here is the output with debug turned on. Sorry for the flood:

[    2.182294] sdhci-pci 0000:0d:00.0: SDHCI controller found 
[1180:e823] (rev 5)
[    1.182298] sdhci-pci 0000:0d:00.0: found 1 slot(s)
[    1.182318] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    1.182381] mmc0: Unknown controller version (2). You may experience 
problems.
[    1.182389] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[    1.182403] sdhci: ============== REGISTER DUMP ==============
[    1.182411] sdhci: Sys addr: 0x00000000 | Version:  0x00000502
[    1.182418] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[    1.182425] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[    1.182432] sdhci: Present:  0x01f20000 | Host ctl: 0x00000000
[    1.182436]   alloc irq_desc for 44 on node -1
[    1.182437]   alloc kstat_irqs on node -1
[    1.182439] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[    1.182444] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[    1.182451] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[    1.182456] sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
[    1.182463] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[    1.182470] sdhci: Caps:     0x21e8c8b2 | Max curr: 0x00000040
[    1.182477] sdhci: ADMA Err: 0x00000000 | ADMA Ptr: 0x00000000
[    1.182478] sdhci: ===========================================
[    1.182499] Registered led device: mmc0::
[    1.182518] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[    1.182574] mmc0: SDHCI controller on PCI [0000:0d:00.0] using ADMA
[    1.182578] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 
timing 0
[    1.195203] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[    1.211345] mmc0: starting CMD52 arg 00000c00 flags 00000195
[    1.213394] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 
00000000
[    1.213402] mmc0: starting CMD52 arg 80000c08 flags 00000195
[    1.215470] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 
00000000
[    1.215476] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 
width 0 timing 0
[    1.216473] mmc0: starting CMD0 arg 00000000 flags 000000c0
[    1.218477] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 
00000000
[    1.219472] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[    1.220469] mmc0: starting CMD8 arg 000001aa flags 000002f5
[    1.222472] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 
00000000
[    1.222476] mmc0: starting CMD5 arg 00000000 flags 000002e1
[    1.224479] mmc0: req failed (CMD5): -123, retrying...
[    1.226476] mmc0: req failed (CMD5): -123, retrying...
[    1.228478] mmc0: req failed (CMD5): -123, retrying...
[    1.230479] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 
00000000
[    1.230483] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.232489] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.232492] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.234496] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.234499] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.236507] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.236511] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.238521] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.238524] mmc0: starting CMD1 arg 00000000 flags 000000e1
[    1.240531] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 
00000000
[    1.240536] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[   30.617181] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
[   30.813108] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 
timing 0
[   30.829096] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[   30.845074] mmc0: starting CMD52 arg 00000c00 flags 00000195
[   30.845216] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.847216] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 
00000000
[   30.847224] mmc0: starting CMD52 arg 80000c08 flags 00000195
[   30.847303] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.849310] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 
00000000
[   30.849315] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 
width 0 timing 0
[   30.850310] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   30.850359] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.850364] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   30.851361] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[   30.852356] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   30.852399] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.854403] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 
00000000
[   30.854463] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   30.854501] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.856497] mmc0: req failed (CMD5): -110, retrying...
[   30.856535] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.858536] mmc0: req failed (CMD5): -110, retrying...
[   30.858569] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.860565] mmc0: req failed (CMD5): -110, retrying...
[   30.860599] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.862600] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 
00000000
[   30.862605] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.862642] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.864641] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   30.864645] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.864684] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.866682] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   30.866686] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.866764] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.868771] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   30.868776] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   30.868816] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.870821] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   30.870825] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   30.870856] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.870862] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.870868] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   30.870873] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 
width 0 timing 0
[   30.871869] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   30.871918] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.871923] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   30.872922] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   30.873918] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.873996] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.874015] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.889033] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.889095] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.889110] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.905020] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.905081] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.905096] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.921009] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.921087] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.921103] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.936994] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.937071] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.937087] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.952980] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.953057] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.953074] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.968961] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.969039] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.969055] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   30.984946] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   30.985024] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.985039] mmc0: req done (CMD1): 0: 803f8000 00000000 00000000 00000000
[   30.985054] mmc0: starting CMD2 arg 00000000 flags 00000067
[   30.985112] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   30.985135] mmc0: req done (CMD2): 0: ffffffff ffffffff ffffffff ffffff00
[   30.985151] mmc0: starting CMD3 arg 00010000 flags 00000015
[   30.985201] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.987204] mmc0: req failed (CMD3): -110, retrying...
[   30.987237] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.989232] mmc0: req failed (CMD3): -110, retrying...
[   30.989265] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.991262] mmc0: req failed (CMD3): -110, retrying...
[   30.991296] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   30.993295] mmc0: req done (CMD3): -110: 00000000 00000000 00000000 
00000000
[   30.993302] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[   30.993313] mmc0: error -110 whilst initialising MMC card
[   30.993315] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0


>
> If you have access to a scope, checking out the CMD line often hints at
> whether a problem is software or hardware.
>
> - Chris.
>
>>
>> ======= lspci -vvnn ==============
>> 0d:00.0 System peripheral [0880]: Ricoh Co Ltd Device [1180:e823] (rev
>> 05) (prog-if 01)
>> 	Subsystem: Lenovo Device [17aa:21ce]
>> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-
>> <TAbort-
>> <MAbort->SERR-<PERR- INTx-
>> 	Latency: 0, Cache Line Size: 64 bytes
>> 	Interrupt: pin A routed to IRQ 16
>> 	Region 0: Memory at d1400000 (32-bit, non-prefetchable) [size=256]
>> 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>> 		Address: 0000000000000000  Data: 0000
>> 	Capabilities: [78] Power Management version 3
>> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>> 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
>> 	Capabilities: [80] Express (v1) Endpoint, MSI 00
>> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>> unlimited, L1 unlimited
>> 			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
>> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
>> 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>> 		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0<4us, L1<64us
>> 			ClockPM+ Surprise- LLActRep- BwNot-
>> 		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>> 			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train-
>> SlotClk+ DLActive-
>> BWMgmt- ABWMgmt-
>> 	Capabilities: [100 v1] Virtual Channel
>> 		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
>> 		Arb:	Fixed- WRR32- WRR64- WRR128-
>> 		Ctrl:	ArbSelect=Fixed
>> 		Status:	InProgress-
>> 		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>> 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>> 			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>> 			Status:	NegoPending- InProgress-
>> 	Capabilities: [800 v1] Advanced Error Reporting
>> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF-
>> MalfTLP- ECRC- UnsupReq- ACSViol-
>> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
>> UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>> 		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>> 	Kernel driver in use: sdhci-pci
>> 	Kernel modules: sdhci-pci
>
