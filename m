Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1KOG3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:29:34 -0500
Received: from mail2.unitix.de ([176.9.2.175]:60337 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab1KOG3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:29:33 -0500
Message-ID: <4EC206C9.10909@arndnet.de>
Date: Tue, 15 Nov 2011 07:29:29 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: 3.2rc1: bootup fails: DRHD: handling fault status reg 2
References: <4EC19738.8050007@arndnet.de> <4EC1B80D.5000102@arndnet.de> <4EC1EB39.1080705@gmail.com>
In-Reply-To: <4EC1EB39.1080705@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.11.2011 05:31, schrieb Robert Hancock:
> On 11/14/2011 06:53 PM, Arnd Hannemann wrote:
>> Hi,
>>
>> Am 14.11.2011 23:33, schrieb Arnd Hannemann:
>>
>>> when trying to boot kernel 3.2rc1 on my thinkpad t510 I get an endless loop of errors:
>>>
>>>   DRHD: handling fault status reg 2
>>>   DMAR: [DMA Read] Request device [0d:00.0] fault addr fffff000
>>>   DMAR: [fault reason 02] Present bit in context entry is clear
>>>
>>> screenshot can be found here:
>>> http://arndnet.de/lkml/screenshot3.2rc1.jpg
>>>
>>> kernel 3.1.1 is booting up flawlessly.
>>
>> I must have inadvertently enabled CONFIG_INTEL_IOMMU_DEFAULT_ON in my config
>> for 3.2-rc1.
>>
>> With disabled CONFIG_INTEL_IOMMU_DEFAULT_ON my thinkpad boots up again.
>> Not sure if this is expected?
> 
> No, that's not supposed to happen. Can you post the output of "lspci -vv"? Apparently that device 0d:00.0 is generating unexpected DMA accesses for some reason.

Looks lite a "Ricoh Co Ltd MMC/SD Host Controller" is the culprit:

0d:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
	Subsystem: Lenovo Device 2133
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f2500000 (32-bit, non-prefetchable) [size=256]
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
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
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
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci

Best regards,
Arnd
