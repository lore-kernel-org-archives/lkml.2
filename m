Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1GEPOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:14:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:36236 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1GEPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:14:04 -0400
Date: Tue, 5 Jul 2011 10:14:02 -0500
From: scameron@beardog.cce.hp.com
To: Joe Jin <joe.jin@oracle.com>
Cc: mike.miller@hp.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "GURUDAS,PAI" <gurudas.pai@oracle.com>,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        scameron@beardog.cce.hp.com
Subject: Re: "use new doorbell-bit-5 reset method" failed to reset the controller
Message-ID: <20110705151402.GK31485@beardog.cce.hp.com>
References: <4E0C3892.2010507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0C3892.2010507@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:49:22PM +0800, Joe Jin wrote:
> Hi Stephen,
> 
> With linux the latest kernel, when do kdump test on HP DL585G7
> we found it failed to reset the controller, driver complained
> "'Bit 2 doorbell reset' is supported, but not 'bit 5 doorbell 
> reset', Firmware update is recommended", we have upgraded the
> firmware to the latest but kdump kernel still failed with
> the message.

What firmware revision do you have?

I think you need 5.06, which just came out on June 24.

http://bizsupport1.austin.hp.com/bizsupport/TechSupport/SoftwareIndex.jsp?lang=en&cc=us&prodNameId=3902575&prodTypeId=329290&prodSeriesId=3902574&swLang=8&swEnvOID=2023&printver=true

-- steve




> 
> After revert commit cf0b08d0cd87ada9d284925834d08fb8026da888,
> kdump work fine. 
> 
> Here is the device info:
> 03:00.0 0104: 103c:323a (rev 01)
>         Subsystem: 103c:3245
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at e0200000 (64-bit, non-prefetchable) [size=2M]
>         Region 2: Memory at e0002000 (64-bit, non-prefetchable) [size=4K]
>         Region 4: I/O ports at 4000 [size=256]
>         [virtual] Expansion ROM at d0500000 [disabled] [size=512K]
>         Capabilities: [40] Power Management version 3
>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [70] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <512ns, L1 <64us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB
>         Capabilities: [ac] MSI-X: Enable+ Count=16 Masked-
>                 Vector table: BAR=0 offset=001c2000
>                 PBA: BAR=0 offset=001c4000
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                 UESvrt: DLP+ SDES+ TLP+ FCP+ CmpltTO+ CmpltAbrt+ UnxCmplt+ RxOF+ MalfTLP+ ECRC- UnsupReq+ ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                 CEMsk:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>         Kernel driver in use: hpsa
>         Kernel modules: hpsa
> 
> 
> Seems doorbell-bit-5 reset method did not work properly with the device?
> Any input will appreciate.
> 
> Thanks,
> Joe
