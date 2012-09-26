Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2IZQnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:43:33 -0400
Received: from wp118.webpack.hosteurope.de ([80.237.132.125]:46404 "EHLO
	wp118.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756896Ab2IZQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:43:31 -0400
Date: Wed, 26 Sep 2012 18:43:25 +0200
From: Florian Dazinger <florian@dazinger.net>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>
Subject: Re: 3.6-rc7 boot crash + bisection
Message-ID: <20120926184325.68e61717@brain.lan>
In-Reply-To: <20120926150407.GD10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
 <1348597970.28860.114.camel@bling.home>
 <20120925205420.0a07dea2@brain.lan>
 <1348602226.28860.132.camel@bling.home>
 <20120926010154.49cc2588@brain.lan>
 <20120926144345.GC10549@amd.com>
 <1348671121.28860.186.camel@bling.home>
 <20120926150407.GD10549@amd.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;florian@dazinger.net;1348677811;6a699eff;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 26 Sep 2012 17:04:07 +0200
schrieb "Roedel, Joerg" <Joerg.Roedel@amd.com>:

> On Wed, Sep 26, 2012 at 08:52:01AM -0600, Alex Williamson wrote:
> > Assuming this works, it may be ok as a 3.7 fix, but if there was
> > actually more than one device behind the alias we'd expose them as
> > separate iommu groups.  I don't think that's what we want.  Maybe it
> > should at least get a pr_warn.  Thanks,
> 
> True, we need something more generic as the real fix. When Florian
> reports success I'll try to get this still into 3.6, otherwise to
> -stable.
> 
> 
> 	Joerg
> 

it still fails with the card in a *different* slot. 
But with the patch applied, everything works, so this fixes it for me! Thanks a lot. Output of the relevant parts of dmesg and lspci see below. I'll still try the newest BIOS rev. and report back.
thx, Florian


dmesg (kernel-3.5.4):

[    0.448252] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.471021] pci 0000:01:00.0: Boot video device
[    1.471118] PCI: CLS 64 bytes, default 64
[    1.473864] AMD-Vi: device: 00:00.2 cap: 0040 seg: 0 flags: 3e info 1300
[    1.473902] AMD-Vi:        mmio-addr: 00000000feb20000
[    1.474119] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:00.0 flags: 00
[    1.474153] AMD-Vi:   DEV_RANGE_END           devid: 00:00.2
[    1.474187] AMD-Vi:   DEV_SELECT                      devid: 00:02.0 flags: 00
[    1.474220] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 01:00.0 flags: 00
[    1.474254] AMD-Vi:   DEV_RANGE_END           devid: 01:00.1
[    1.474287] AMD-Vi:   DEV_SELECT                      devid: 00:04.0 flags: 00
[    1.474321] AMD-Vi:   DEV_SELECT                      devid: 02:00.0 flags: 00
[    1.474354] AMD-Vi:   DEV_SELECT                      devid: 00:05.0 flags: 00
[    1.474388] AMD-Vi:   DEV_SELECT                      devid: 03:00.0 flags: 00
[    1.474421] AMD-Vi:   DEV_SELECT                      devid: 00:06.0 flags: 00
[    1.474455] AMD-Vi:   DEV_SELECT                      devid: 04:00.0 flags: 00
[    1.474488] AMD-Vi:   DEV_SELECT                      devid: 00:07.0 flags: 00
[    1.474522] AMD-Vi:   DEV_SELECT                      devid: 05:00.0 flags: 00
[    1.474555] AMD-Vi:   DEV_SELECT                      devid: 00:09.0 flags: 00
[    1.474589] AMD-Vi:   DEV_SELECT                      devid: 06:00.0 flags: 00
[    1.474622] AMD-Vi:   DEV_SELECT                      devid: 00:0d.0 flags: 00
[    1.474656] AMD-Vi:   DEV_SELECT                      devid: 07:00.0 flags: 00
[    1.474689] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 08:01.0 flags: 00 devid_to: 08:00.0
[    1.474726] AMD-Vi:   DEV_RANGE_END           devid: 08:1f.7
[    1.474764] AMD-Vi:   DEV_SELECT                      devid: 00:11.0 flags: 00
[    1.474798] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:12.0 flags: 00
[    1.474836] AMD-Vi:   DEV_RANGE_END           devid: 00:12.2
[    1.474870] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:13.0 flags: 00
[    1.474903] AMD-Vi:   DEV_RANGE_END           devid: 00:13.2
[    1.474937] AMD-Vi:   DEV_SELECT                      devid: 00:14.0 flags: d7
[    1.474970] AMD-Vi:   DEV_SELECT                      devid: 00:14.3 flags: 00
[    1.475004] AMD-Vi:   DEV_SELECT                      devid: 00:14.4 flags: 00
[    1.475038] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 09:00.0 flags: 00 devid_to: 00:14.4
[    1.475074] AMD-Vi:   DEV_RANGE_END           devid: 09:1f.7
[    1.475112] AMD-Vi:   DEV_SELECT                      devid: 00:14.5 flags: 00
[    1.475146] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:16.0 flags: 00
[    1.475180] AMD-Vi:   DEV_RANGE_END           devid: 00:16.2
[    1.475271] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40
[    1.529007] pci 0000:00:00.2: irq 72 for MSI/MSI-X
[    1.539126] AMD-Vi: Lazy IO/TLB flushing enabled
[    1.539750] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.539787] software IO TLB [mem 0xc9728000-0xcd727fff] (64MB) mapped at [ffff8800c9728000-ffff8800cd727fff]
[    1.539957] kvm: Nested Virtualization enabled

lspci (kernel-3.5.4):
00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (external gfx0 port B) (rev 02)
        Subsystem: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (external gfx0 port B)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Capabilities: [f0] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [c4] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=0 UnitCnt=20 MastHost- DefDir- DUL-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
                Revision ID: 3.00
                Link Frequency 0: [b]
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
                Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [40] HyperTransport: Retry Mode
        Capabilities: [54] HyperTransport: UnitID Clumping
        Capabilities: [9c] HyperTransport: #1a
        Capabilities: [70] MSI: Enable- Count=1/4 Maskable- 64bit-
                Address: 00000000  Data: 0000

00:00.2 IOMMU: Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory Management Unit (IOMMU)
        Subsystem: Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory Management Unit (IOMMU)
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 72
        Capabilities: [40] Secure device <?>
        Capabilities: [54] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 41a9
        Capabilities: [64] HyperTransport: MSI Mapping Enable+ Fixed+

00:02.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port B) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us, L1 <8us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #2, PowerLimit 75.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 5a14
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
        Capabilities: [190 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Kernel driver in use: pcieport

00:04.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fe900000-fe9fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, Latency L0 <1us, L1 <8us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
                        Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 5a14
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
        Capabilities: [190 v1] Access Control Services
                ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
                ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
        Kernel driver in use: pcieport


[...snip...]
07:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI Express-to-PCI Bridge (rev aa) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=07, secondary=08, subordinate=08, sec-latency=32
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Power Budgeting <?>

08:04.0 Multimedia audio controller: C-Media Electronics Inc CMI8788 [Oxygen HD Audio]
        Subsystem: ASUSTeK Computer Inc. Virtuoso 100 (Xonar Essence STX)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (500ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 40
        Region 0: I/O ports at b000 [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: snd_virtuoso

dmesg (rc7 + patch)
[    1.473964] pci 0000:01:00.0: Boot video device
[    1.474061] PCI: CLS 64 bytes, default 64
[    1.476724] AMD-Vi: device: 00:00.2 cap: 0040 seg: 0 flags: 3e info 1300
[    1.476762] AMD-Vi:        mmio-addr: 00000000feb20000
[    1.476840] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:00.0 flags: 00
[    1.476875] AMD-Vi:   DEV_RANGE_END           devid: 00:00.2
[    1.476908] AMD-Vi:   DEV_SELECT                      devid: 00:02.0 flags: 00
[    1.476942] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 01:00.0 flags: 00
[    1.476976] AMD-Vi:   DEV_RANGE_END           devid: 01:00.1
[    1.477009] AMD-Vi:   DEV_SELECT                      devid: 00:04.0 flags: 00
[    1.477043] AMD-Vi:   DEV_SELECT                      devid: 02:00.0 flags: 00
[    1.477076] AMD-Vi:   DEV_SELECT                      devid: 00:05.0 flags: 00
[    1.477110] AMD-Vi:   DEV_SELECT                      devid: 03:00.0 flags: 00
[    1.477143] AMD-Vi:   DEV_SELECT                      devid: 00:06.0 flags: 00
[    1.477176] AMD-Vi:   DEV_SELECT                      devid: 04:00.0 flags: 00
[    1.477210] AMD-Vi:   DEV_SELECT                      devid: 00:07.0 flags: 00
[    1.477244] AMD-Vi:   DEV_SELECT                      devid: 05:00.0 flags: 00
[    1.477277] AMD-Vi:   DEV_SELECT                      devid: 00:09.0 flags: 00
[    1.477311] AMD-Vi:   DEV_SELECT                      devid: 06:00.0 flags: 00
[    1.477344] AMD-Vi:   DEV_SELECT                      devid: 00:0d.0 flags: 00
[    1.477378] AMD-Vi:   DEV_SELECT                      devid: 07:00.0 flags: 00
[    1.477412] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 08:01.0 flags: 00 devid_to: 08:00.0
[    1.477449] AMD-Vi:   DEV_RANGE_END           devid: 08:1f.7
[    1.477486] AMD-Vi:   DEV_SELECT                      devid: 00:11.0 flags: 00
[    1.477520] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:12.0 flags: 00
[    1.477553] AMD-Vi:   DEV_RANGE_END           devid: 00:12.2
[    1.477587] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:13.0 flags: 00
[    1.477620] AMD-Vi:   DEV_RANGE_END           devid: 00:13.2
[    1.477654] AMD-Vi:   DEV_SELECT                      devid: 00:14.0 flags: d7
[    1.477688] AMD-Vi:   DEV_SELECT                      devid: 00:14.3 flags: 00
[    1.477721] AMD-Vi:   DEV_SELECT                      devid: 00:14.4 flags: 00
[    1.477755] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 09:00.0 flags: 00 devid_to: 00:14.4
[    1.477801] AMD-Vi:   DEV_RANGE_END           devid: 09:1f.7
[    1.477840] AMD-Vi:   DEV_SELECT                      devid: 00:14.5 flags: 00
[    1.477874] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:16.0 flags: 00
[    1.477908] AMD-Vi:   DEV_RANGE_END           devid: 00:16.2
[    1.532188] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    1.532224] 
[    1.532274] pci 0000:00:00.2: irq 72 for MSI/MSI-X
[    1.542311] AMD-Vi: Lazy IO/TLB flushing enabled
[    1.542349] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.542384] software IO TLB [mem 0xc9728000-0xcd727fff] (64MB) mapped at [ffff8800c9728000-ffff8800cd727fff]

lspci (rc7 + patch)
07:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI Express-to-PCI Bridge (rev aa) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=07, secondary=08, subordinate=08, sec-latency=32
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Power Budgeting <?>

08:04.0 Multimedia audio controller: C-Media Electronics Inc CMI8788 [Oxygen HD Audio]
	Subsystem: ASUSTeK Computer Inc. Virtuoso 100 (Xonar Essence STX)
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 40
	Region 0: I/O ports at b000 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_virtuoso


