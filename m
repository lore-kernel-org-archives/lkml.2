Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1C3W7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:59:08 -0400
Received: from void.printf.net ([89.145.121.20]:41987 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab1C3W7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:59:06 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj <manoj.iyer@canonical.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>
Date: Wed, 30 Mar 2011 19:04:59 -0400
In-Reply-To: <4D93AD5C.1070308@canonical.com> (Manoj's message of "Wed, 30 Mar
	2011 17:23:24 -0500")
Message-ID: <m34o6k43c4.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding linux-mmc@.)

On Wed, Mar 30 2011, Manoj wrote:
> The ricoh SD/MMC card reader [1180:e823] is able to read SD cards, I
> recently submitted a patch to enable this card reader
> (https://lkml.org/lkml/2011/2/11/309).
>
> But it is not able to mount MMC cards.
>
> When I insert an MMC card I get:
> mmc0: error -110 whilst initialising MMC card
>
> I traced it down to ETIMEDOUT coming from sdhci_cmd_irq() can someone
> give me a clue as to where I should start looking?

The timeout's being raised by the controller, so it could simply be a
bad card, or a controller that doesn't support MMC cards properly, or
similar.  You could start with:

* turn on CONFIG_MMC_DEBUG and post output
* see if sdhci.debug_quirks=1 helps

If you have access to a scope, checking out the CMD line often hints at
whether a problem is software or hardware.

- Chris.

>
> ======= lspci -vvnn ==============
> 0d:00.0 System peripheral [0880]: Ricoh Co Ltd Device [1180:e823] (rev
> 05) (prog-if 01)
> 	Subsystem: Lenovo Device [17aa:21ce]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- 
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- 
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at d1400000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> 		Address: 0000000000000000  Data: 0000
> 	Capabilities: [78] Power Management version 3
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
> 	Capabilities: [80] Express (v1) Endpoint, MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1 unlimited
> 			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
> 		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <4us, L1 <64us
> 			ClockPM+ Surprise- LLActRep- BwNot-
> 		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive- 
> BWMgmt- ABWMgmt-
> 	Capabilities: [100 v1] Virtual Channel
> 		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
> 		Arb:	Fixed- WRR32- WRR64- WRR128-
> 		Ctrl:	ArbSelect=Fixed
> 		Status:	InProgress-
> 		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> 			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
> 			Status:	NegoPending- InProgress-
> 	Capabilities: [800 v1] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- 
> MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- 
> MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> 		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
> 	Kernel driver in use: sdhci-pci
> 	Kernel modules: sdhci-pci

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
