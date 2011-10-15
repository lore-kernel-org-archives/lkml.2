Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1JOIng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 04:43:36 -0400
Received: from furry1.cpalmer.me.uk ([91.84.39.42]:35649 "EHLO
	furry1.cpalmer.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1JOIne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 04:43:34 -0400
Message-ID: <4E9947B1.4050100@pobox.com>
Date: Sat, 15 Oct 2011 09:43:29 +0100
From: Chris Palmer <chris.palmer@pobox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] ASUS Sandybridge motherboards + PCI not working (IRQ
 n: nobody cared)
References: <4E98175A.8040905@pobox.com> <4E98D402.2030600@gmail.com>
In-Reply-To: <4E98D402.2030600@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2011 01:29, Robert Hancock wrote:
> On 10/14/2011 05:04 AM, Chris Palmer wrote:
>> Interrupt handling for *PCI boards with ASUS Sandybridge motherboards*
>> seems to be broken.
>>
>> It has been seen with network and non-network PCI boards. PCIx network
>> boards work OK. And all reports are for ASUS motherboards.
>>
>> It always results in the infamous "IRQ n: nobody cared" message usually
>> within an hour. It is possible to restart things by rmmod/modprobe on
>> the appropriate PCI driver.
>>
>> Andrew Morton kindly took a quick look and thinks it is most likely an
>> ACPI bug.
>>
>> Configuration summary:
>>   - ASUS P8H67-V/R3 Motherboard (others have problems with similar M/Bs)
>>   - M/B BIOS 0804 (just updated to that - no change)
>>   - Core i5/2500K
>>   - Onboard ethernet (at11c driver - works)
>>   - Additional PCIx Intel ethernet board (e1000e driver - works)
>>   - Additional PCI Broadcom BCM5702X ethernet board (tg3 driver - fails)
>>     [ Also fails with other PCI boards such as RTL8139 ]
>>   - Kernel 3.0.6
>>
>>
>> Any help much appreciated...
>>
>> Previous references:
>>
>> https://lkml.org/lkml/2011/6/30/197
>> https://bugzilla.kernel.org/show_bug.cgi?id=38632
>> https://bugzilla.redhat.com/show_bug.cgi?id=713351
>> https://bugzilla.kernel.org/show_bug.cgi?id=35332
>> https://bugzilla.kernel.org/show_bug.cgi?id=34242
>> https://bugzilla.kernel.org/show_bug.cgi?id=32242
>> https://bugzilla.kernel.org/show_bug.cgi?id=39122
>
> The bugzilla reports aren't currently accessible so I don't know if it
> was posted there, but can you post the output of "lspci -vv" as root?
> Could be that some other device is configured on that IRQ and
> sometimes spuriously generates interrupts.
>

Robert

Various outputs below.

Many thanks
Chris

--------------------------------------------------------------------------------------------------------------------

/var/adm/messages at point of failure

Oct 13 22:12:43 woody1 kernel: [ 9958.088517] irq 16: nobody cared (try
booting with the "irqpoll" option)
Oct 13 22:12:43 woody1 kernel: [ 9958.088523] Pid: 0, comm: kworker/0:0
Not tainted 3.0.6 #1
Oct 13 22:12:43 woody1 kernel: [ 9958.088526] Call Trace:
Oct 13 22:12:43 woody1 kernel: [ 9958.088528]  <IRQ> 
[<ffffffff81082db7>] __report_bad_irq+0x37/0xc3
Oct 13 22:12:43 woody1 kernel: [ 9958.088540]  [<ffffffff8108317b>]
note_interrupt+0x151/0x1ca
Oct 13 22:12:43 woody1 kernel: [ 9958.088545]  [<ffffffff810817ed>]
handle_irq_event_percpu+0x179/0x197
Oct 13 22:12:43 woody1 kernel: [ 9958.088549]  [<ffffffff8108183c>]
handle_irq_event+0x31/0x4d
Oct 13 22:12:43 woody1 kernel: [ 9958.088554]  [<ffffffff81067467>] ?
arch_local_irq_save+0x18/0x1e
Oct 13 22:12:43 woody1 kernel: [ 9958.088558]  [<ffffffff81083919>]
handle_fasteoi_irq+0x77/0x98
Oct 13 22:12:43 woody1 kernel: [ 9958.088562]  [<ffffffff810042ed>]
handle_irq+0x88/0x90
Oct 13 22:12:43 woody1 kernel: [ 9958.088567]  [<ffffffff813d25fd>]
do_IRQ+0x4d/0xa5
Oct 13 22:12:43 woody1 kernel: [ 9958.088571]  [<ffffffff813d07d3>]
common_interrupt+0x13/0x13
Oct 13 22:12:43 woody1 kernel: [ 9958.088573]  <EOI> 
[<ffffffff81008809>] ? paravirt_read_tsc+0x9/0xd
Oct 13 22:12:43 woody1 kernel: [ 9958.088581]  [<ffffffff8121a577>] ?
intel_idle+0xd1/0xf8
Oct 13 22:12:43 woody1 kernel: [ 9958.088585]  [<ffffffff8121a559>] ?
intel_idle+0xb3/0xf8
Oct 13 22:12:43 woody1 kernel: [ 9958.088590]  [<ffffffff813066ff>]
cpuidle_idle_call+0xa1/0xe9
Oct 13 22:12:43 woody1 kernel: [ 9958.088595]  [<ffffffff8100130b>]
cpu_idle+0xaa/0xcc
Oct 13 22:12:43 woody1 kernel: [ 9958.088600]  [<ffffffff813cad33>]
start_secondary+0x248/0x24f
Oct 13 22:12:43 woody1 kernel: [ 9958.088603] handlers:
Oct 13 22:12:43 woody1 kernel: [ 9958.088614] [<ffffffffa0060919>]
tg3_interrupt_tagged
Oct 13 22:12:43 woody1 kernel: [ 9958.088617] Disabling IRQ #16

--------------------------------------------------------------------------------------------------------------

cat /proc/interrupts

           CPU0       CPU1       CPU2       CPU3
  0:        582          0          0          0   IO-APIC-edge      timer
  1:          4          0          0          0   IO-APIC-edge      i8042
  4:    1764360     147833          0          0   IO-APIC-edge      serial
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          5          0          0          0   IO-APIC-edge      i8042
 16:         28     299982          0          0   IO-APIC-fasteoi   eth2
 23:      57444          9          0          0   IO-APIC-fasteoi  
ehci_hcd:usb3, ehci_hcd:usb4
 40:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 41:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 42:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 43:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 44:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 45:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 46:          0          0          0          0   PCI-MSI-edge     
PCIe PME
 47:    2538605          0          0          0   PCI-MSI-edge      ahci
 48:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 49:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 50:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 51:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 52:          0          0          0          0   PCI-MSI-edge     
xhci_hcd
 53:     342497          0          0          0   PCI-MSI-edge     
eth0-rx-0
 54:     209063          0          0          0   PCI-MSI-edge     
eth0-tx-0
 55:          2          0          0          0   PCI-MSI-edge      eth0
 56:       7095          0       1839          0   PCI-MSI-edge      radeon
 57:    1850698          0          0          0   PCI-MSI-edge      eth1
NMI:          0          0          0          0   Non-maskable interrupts
LOC:   21319335   24311389   13606677    6465693   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:    1550702    2765775    1892119     902441   Rescheduling interrupts
CAL:     108068     117537      59700      44941   Function call interrupts
TLB:      70131      66583      70222      69524   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:        457        457        457        457   Machine check polls
ERR:          0
MIS:          0

--------------------------------------------------------------------------------------------------------------------

lspci -vv

00:00.0 Host bridge: Intel Corporation Sandy Bridge DRAM Controller (rev 09)
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Sandy Bridge PCI Express Root Port
(rev 09) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fe600000-fe6fffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [88] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4159
        Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #2, Speed 5GT/s, Width x16, ASPM unknown,
Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #0, PowerLimit 75.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [140 v1] Root Complex Link
                Desc:   PortNumber=02 ComponentID=01 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=01
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed19000
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:16.0 Communication controller: Intel Corporation Cougar Point HECI
Controller #1 (rev 04)
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fe708000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000

00:1a.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host
Controller #2 (rev 05) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at fe707000 (32-bit, non-prefetchable) [size=1K]
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
        Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation Cougar Point High Definition
Audio Controller (rev 05)
        Subsystem: ASUSTeK Computer Inc. Device 841b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at fe700000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated
Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=22
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=0f ComponentID=00 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=00
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed1c000

00:1c.0 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
1 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x2, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4161
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
3 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fe500000-fe5fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4169
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
4 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4171
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
5 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fe400000-fe4fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #5, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #4, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4179
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.5 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
6 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
        Memory behind bridge: fe300000-fe3fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #6, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4181
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.6 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port
7 (rev b5) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: fe200000-fe2fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #7, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #6, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna+ CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 4189
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.7 PCI bridge: Intel Corporation 82801 PCI Bridge (rev b5) (prog-if
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=08, subordinate=09, sec-latency=0
        Memory behind bridge: fe100000-fe1fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
Surprise-
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host
Controller #1 (rev 05) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at fe706000 (32-bit, non-prefetchable) [size=1K]
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
        Kernel modules: ehci-hcd

00:1f.0 ISA bridge: Intel Corporation Cougar Point LPC Controller (rev 05)
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI
Controller (rev 05) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 47
        Region 0: I/O ports at f070 [size=8]
        Region 1: I/O ports at f060 [size=4]
        Region 2: I/O ports at f050 [size=8]
        Region 3: I/O ports at f040 [size=4]
        Region 4: I/O ports at f020 [size=32]
        Region 5: Memory at fe705000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0100c  Data: 4199
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

00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 05)
        Subsystem: ASUSTeK Computer Inc. Device 844d
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at fe704000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at f000 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

01:00.0 VGA compatible controller: ATI Technologies Inc RV530LE [Radeon
X1600/X1650 PRO] (prog-if 00 [VGA controller])
        Subsystem: PC Partner Limited Device 0880
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 56
        Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 2: Memory at fe630000 (64-bit, non-prefetchable) [size=64K]
        Region 4: I/O ports at e000 [size=256]
        Expansion ROM at fe600000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0400c  Data: 4122
        Kernel driver in use: radeon
        Kernel modules: radeon

01:00.1 Display controller: ATI Technologies Inc RV530LE [Radeon X1650
PRO] (Secondary)
        Subsystem: PC Partner Limited Device 0881
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Region 0: Memory at fe620000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-

03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
Connection
        Subsystem: Intel Corporation Gigabit CT Desktop Adapter
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fe5c0000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at fe500000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at d000 [size=32]
        Region 3: Memory at fe5e0000 (32-bit, non-prefetchable) [size=16K]
        Expansion ROM at fe580000 [disabled] [size=256K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <128ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
                Vector table: BAR=3 offset=00000000
                PBA: BAR=3 offset=00002000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [140 v1] Device Serial Number 00-1b-21-ff-ff-ad-77-d1
        Kernel driver in use: e1000e
        Kernel modules: e1000e

05:00.0 IDE interface: VIA Technologies, Inc. PATA IDE Host Controller
(prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Device 838f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at c040 [size=8]
        Region 1: I/O ports at c030 [size=4]
        Region 2: I/O ports at c020 [size=8]
        Region 3: I/O ports at c010 [size=4]
        Region 4: I/O ports at c000 [size=16]
        Expansion ROM at fe400000 [disabled] [size=64K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [70] MSI: Enable- Count=1/1 Maskable+ 64bit+
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [90] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+
ChkEn-
        Capabilities: [130 v1] Device Serial Number 00-40-63-ff-ff-63-40-00
        Kernel modules: ata_generic

06:00.0 USB Controller: Device 1b21:1042 (prog-if 30)
        Subsystem: ASUSTeK Computer Inc. Device 8488
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at fe300000 (64-bit, non-prefetchable) [size=32K]
        Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
                Vector table: BAR=0 offset=00002000
                PBA: BAR=0 offset=00002080
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <2us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <2us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci-hcd

07:00.0 Ethernet controller: Atheros Communications Device 1083 (rev c0)
        Subsystem: ASUSTeK Computer Inc. Device 847e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 57
        Region 0: Memory at fe200000 (64-bit, non-prefetchable) [size=256K]
        Region 2: I/O ports at b000 [size=128]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 412a
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [6c] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
                Not readable
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+
ChkEn-
        Capabilities: [180 v1] Device Serial Number ff-e4-fa-01-bc-ae-c5-ff
        Kernel driver in use: atl1c
        Kernel modules: atl1c

08:00.0 PCI bridge: Device 1b21:1080 (rev 01) (prog-if 01 [Subtractive
decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=08, secondary=09, subordinate=09, sec-latency=32
        Memory behind bridge: fe100000-fe1fffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Device 8489

09:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5702X
Gigabit Ethernet (rev 02)
        Subsystem: 3Com Corporation Device 1100
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe100000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=1
                Status: Dev=ff:1f.1 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
                Product Name: 3Com 10/100/1000 PCI
                Read-only fields:
                        [PN] Part number: 3C1000B-T
                        [EC] Engineering changes: 109904-40
                        [SN] Serial number: HYFR00386E
                        [MN] Manufacture ID: 31 30 42 37
                        [V0] Vendor specific: N/A
                        [RV] Reserved: checksum bad, 47 byte(s) reserved
                Read/write fields:
                        [YA] Asset tag: XYZ01234567
                        [V1] Vendor specific: N/A
                        [RW] Read-write area: 101 byte(s) free
                End
        Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
                Address: efbfdbeebfefebfc  Data: fbfd
        Kernel driver in use: tg3
        Kernel modules: tg3

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/var/adm/messages during boot

Oct 13 19:27:05 woody1 kernel: [    0.539846] ACPI: Executed 1 blocks of
module-level executable AML code
Oct 13 19:27:05 woody1 kernel: [    0.542050] ACPI Error: [RAMB]
Namespace lookup failure, AE_NOT_FOUND (20110413/psargs-359)
Oct 13 19:27:05 woody1 kernel: [    0.542401] ACPI Exception:
AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region)
(20110413/nsinit-349)
Oct 13 19:27:05 woody1 kernel: [    0.542885] ACPI: SSDT
00000000cf5ddc18 0038C (v01    AMI      IST 00000001 MSFT 03000001)
Oct 13 19:27:05 woody1 kernel: [    0.543445] ACPI: Dynamic OEM Table Load:
Oct 13 19:27:05 woody1 kernel: [    0.543674] ACPI: SSDT          
(null) 0038C (v01    AMI      IST 00000001 MSFT 03000001)
Oct 13 19:27:05 woody1 kernel: [    0.543990] ACPI: SSDT
00000000cf5dee18 00084 (v01    AMI      CST 00000001 MSFT 03000001)
Oct 13 19:27:05 woody1 kernel: [    0.544505] ACPI: Dynamic OEM Table Load:
Oct 13 19:27:05 woody1 kernel: [    0.544730] ACPI: SSDT          
(null) 00084 (v01    AMI      CST 00000001 MSFT 03000001)
Oct 13 19:27:05 woody1 kernel: [    0.545425] ACPI: Interpreter enabled
Oct 13 19:27:05 woody1 kernel: [    0.545552] ACPI: (supports S0 S1 S3 S5)
Oct 13 19:27:05 woody1 kernel: [    0.545888] ACPI: Using IOAPIC for
interrupt routing
Oct 13 19:27:05 woody1 kernel: [    0.546032] PCI: MMCONFIG for domain
0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
Oct 13 19:27:05 woody1 kernel: [    0.546278] PCI: MMCONFIG at [mem
0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
Oct 13 19:27:05 woody1 kernel: [    0.551242] [Firmware Bug]: ACPI: BIOS
_OSI(Linux) query ignored
Oct 13 19:27:05 woody1 kernel: [    0.555191] PCI: Using host bridge
windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Oct 13 19:27:05 woody1 kernel: [    0.555540] ACPI: PCI Root Bridge
[PCI0] (domain 0000 [bus 00-ff])
Oct 13 19:27:05 woody1 kernel: [    0.555825] pci_root PNP0A08:00: host
bridge window [io  0x0000-0x0cf7]
Oct 13 19:27:05 woody1 kernel: [    0.555955] pci_root PNP0A08:00: host
bridge window [io  0x0d00-0xffff]
Oct 13 19:27:05 woody1 kernel: [    0.556084] pci_root PNP0A08:00: host
bridge window [mem 0x000a0000-0x000bffff]
Oct 13 19:27:05 woody1 kernel: [    0.556291] pci_root PNP0A08:00: host
bridge window [mem 0x000c8000-0x000dffff]
Oct 13 19:27:05 woody1 kernel: [    0.556496] pci_root PNP0A08:00: host
bridge window [mem 0xd0000000-0xffffffff]
Oct 13 19:27:05 woody1 kernel: [    0.556706] pci_root PNP0A08:00:
address space collision: host bridge window [mem 0x000c8000-0x000dffff]
conflicts with Video ROM [mem 0x000c0000-0x000cf5ff]
Oct 13 19:27:05 woody1 kernel: [    0.558418] pci 0000:01:00.0:
disabling ASPM on pre-1.1 PCIe device.  You can enable it with
'pcie_aspm=force'
Oct 13 19:27:05 woody1 kernel: [    0.558632] pci 0000:00:01.0: PCI
bridge to [bus 01-01]
Oct 13 19:27:05 woody1 kernel: [    0.558809] pci 0000:00:1c.0: PCI
bridge to [bus 02-02]
Oct 13 19:27:05 woody1 kernel: [    0.560679] pci 0000:00:1c.2: PCI
bridge to [bus 03-03]
Oct 13 19:27:05 woody1 kernel: [    0.563592] pci 0000:00:1c.3: PCI
bridge to [bus 04-04]
Oct 13 19:27:05 woody1 kernel: [    0.565670] pci 0000:00:1c.4: PCI
bridge to [bus 05-05]
Oct 13 19:27:05 woody1 kernel: [    0.567669] pci 0000:00:1c.5: PCI
bridge to [bus 06-06]
Oct 13 19:27:05 woody1 kernel: [    0.569669] pci 0000:00:1c.6: PCI
bridge to [bus 07-07]
Oct 13 19:27:05 woody1 kernel: [    0.569983] pci 0000:00:1c.7: PCI
bridge to [bus 08-09] (subtractive decode)
Oct 13 19:27:05 woody1 kernel: [    0.570470] pci 0000:08:00.0: PCI
bridge to [bus 09-09] (subtractive decode)
Oct 13 19:27:05 woody1 kernel: [    0.571016]  pci0000:00: Requesting
ACPI _OSC control (0x1d)
Oct 13 19:27:05 woody1 kernel: [    0.571297]  pci0000:00: ACPI _OSC
control (0x1c) granted
Oct 13 19:27:05 woody1 kernel: [    0.574307] ACPI: PCI Interrupt Link
[LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.575048] ACPI: PCI Interrupt Link
[LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.575791] ACPI: PCI Interrupt Link
[LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.576482] ACPI: PCI Interrupt Link
[LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.577172] ACPI: PCI Interrupt Link
[LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.577915] ACPI: PCI Interrupt Link
[LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.578649] ACPI: PCI Interrupt Link
[LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.579386] ACPI: PCI Interrupt Link
[LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Oct 13 19:27:05 woody1 kernel: [    0.580148] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Oct 13 19:27:05 woody1 kernel: [    0.580357] vgaarb: loaded
Oct 13 19:27:05 woody1 kernel: [    0.580484] vgaarb: bridge control
possible 0000:01:00.0
Oct 13 19:27:05 woody1 kernel: [    0.580658] SCSI subsystem initialized
Oct 13 19:27:05 woody1 kernel: [    0.580833] usbcore: registered new
interface driver usbfs
Oct 13 19:27:05 woody1 kernel: [    0.580969] usbcore: registered new
interface driver hub
Oct 13 19:27:05 woody1 kernel: [    0.581110] usbcore: registered new
device driver usb
Oct 13 19:27:05 woody1 kernel: [    0.581270] PCI: Using ACPI for IRQ
routing
Oct 13 19:27:05 woody1 kernel: [    0.582873] NetLabel: Initializing
Oct 13 19:27:05 woody1 kernel: [    0.583000] NetLabel:  domain hash
size = 128
Oct 13 19:27:05 woody1 kernel: [    0.583128] NetLabel:  protocols =
UNLABELED CIPSOv4
Oct 13 19:27:05 woody1 kernel: [    0.583262] NetLabel:  unlabeled
traffic allowed by default
Oct 13 19:27:05 woody1 kernel: [    0.583397] hpet0: at MMIO 0xfed00000,
IRQs 2, 8, 0, 0, 0, 0, 0, 0
Oct 13 19:27:05 woody1 kernel: [    0.583962] hpet0: 8 comparators,
64-bit 14.318180 MHz counter
Oct 13 19:27:05 woody1 kernel: [    0.587103] Switching to clocksource hpet
Oct 13 19:27:05 woody1 kernel: [    0.587638] Switched to NOHz mode on
CPU #0
Oct 13 19:27:05 woody1 kernel: [    0.587722] Switched to NOHz mode on
CPU #1
Oct 13 19:27:05 woody1 kernel: [    0.587753] Switched to NOHz mode on
CPU #3
Oct 13 19:27:05 woody1 kernel: [    0.587764] Switched to NOHz mode on
CPU #2
Oct 13 19:27:05 woody1 kernel: [    0.590969] pnp: PnP ACPI init
Oct 13 19:27:05 woody1 kernel: [    0.591107] ACPI: bus type pnp registered
Oct 13 19:27:05 woody1 kernel: [    0.591467] system 00:01: [mem
0xfed10000-0xfed19fff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.591597] system 00:01: [mem
0xe0000000-0xe3ffffff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.591725] system 00:01: [mem
0xfed90000-0xfed93fff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.591853] system 00:01: [mem
0xfed20000-0xfed3ffff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.591982] system 00:01: [mem
0xfee00000-0xfee0ffff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.592183] system 00:02: [io 
0x0290-0x029f] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.592540] system 00:06: [io 
0x04d0-0x04d1] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.593056] system 00:09: [io 
0x0400-0x0453] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.593186] system 00:09: [io 
0x0458-0x047f] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.593321] system 00:09: [io 
0x0500-0x057f] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.593451] system 00:09: [mem
0xfed1c000-0xfed1ffff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.593580] system 00:09: [mem
0xfec00000-0xfecfffff] could not be reserved
Oct 13 19:27:05 woody1 kernel: [    0.593709] system 00:09: [mem
0xfed08000-0xfed08fff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.593837] system 00:09: [mem
0xff000000-0xffffffff] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.594016] system 00:0a: [io 
0x0454-0x0457] has been reserved
Oct 13 19:27:05 woody1 kernel: [    0.594378] pnp: PnP ACPI: found 12
devices
Oct 13 19:27:05 woody1 kernel: [    0.594505] ACPI: ACPI bus type pnp
unregistered
Oct 13 19:27:05 woody1 kernel: [    0.600096] pci 0000:00:01.0: PCI
bridge to [bus 01-01]
Oct 13 19:27:05 woody1 kernel: [    0.600225] pci 0000:00:01.0:   bridge
window [io  0xe000-0xefff]
Oct 13 19:27:05 woody1 kernel: [    0.600359] pci 0000:00:01.0:   bridge
window [mem 0xfe600000-0xfe6fffff]
Oct 13 19:27:05 woody1 kernel: [    0.600490] pci 0000:00:01.0:   bridge
window [mem 0xd0000000-0xdfffffff 64bit pref]
Oct 13 19:27:05 woody1 kernel: [    0.600696] pci 0000:00:1c.0: PCI
bridge to [bus 02-02]
Oct 13 19:27:05 woody1 kernel: [    0.600824] pci 0000:00:1c.0:   bridge
window [io  disabled]
Oct 13 19:27:05 woody1 kernel: [    0.600956] pci 0000:00:1c.0:   bridge
window [mem disabled]
Oct 13 19:27:05 woody1 kernel: [    0.601085] pci 0000:00:1c.0:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.601218] pci 0000:00:1c.2: PCI
bridge to [bus 03-03]
Oct 13 19:27:05 woody1 kernel: [    0.601351] pci 0000:00:1c.2:   bridge
window [io  0xd000-0xdfff]
Oct 13 19:27:05 woody1 kernel: [    0.601484] pci 0000:00:1c.2:   bridge
window [mem 0xfe500000-0xfe5fffff]
Oct 13 19:27:05 woody1 kernel: [    0.601616] pci 0000:00:1c.2:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.601749] pci 0000:00:1c.3: PCI
bridge to [bus 04-04]
Oct 13 19:27:05 woody1 kernel: [    0.601877] pci 0000:00:1c.3:   bridge
window [io  disabled]
Oct 13 19:27:05 woody1 kernel: [    0.602009] pci 0000:00:1c.3:   bridge
window [mem disabled]
Oct 13 19:27:05 woody1 kernel: [    0.602139] pci 0000:00:1c.3:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.602271] pci 0000:00:1c.4: PCI
bridge to [bus 05-05]
Oct 13 19:27:05 woody1 kernel: [    0.602404] pci 0000:00:1c.4:   bridge
window [io  0xc000-0xcfff]
Oct 13 19:27:05 woody1 kernel: [    0.602538] pci 0000:00:1c.4:   bridge
window [mem 0xfe400000-0xfe4fffff]
Oct 13 19:27:05 woody1 kernel: [    0.602669] pci 0000:00:1c.4:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.602802] pci 0000:00:1c.5: PCI
bridge to [bus 06-06]
Oct 13 19:27:05 woody1 kernel: [    0.602928] pci 0000:00:1c.5:   bridge
window [io  disabled]
Oct 13 19:27:05 woody1 kernel: [    0.603060] pci 0000:00:1c.5:   bridge
window [mem 0xfe300000-0xfe3fffff]
Oct 13 19:27:05 woody1 kernel: [    0.603191] pci 0000:00:1c.5:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.603329] pci 0000:00:1c.6: PCI
bridge to [bus 07-07]
Oct 13 19:27:05 woody1 kernel: [    0.603458] pci 0000:00:1c.6:   bridge
window [io  0xb000-0xbfff]
Oct 13 19:27:05 woody1 kernel: [    0.603589] pci 0000:00:1c.6:   bridge
window [mem 0xfe200000-0xfe2fffff]
Oct 13 19:27:05 woody1 kernel: [    0.603719] pci 0000:00:1c.6:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.603852] pci 0000:08:00.0: PCI
bridge to [bus 09-09]
Oct 13 19:27:05 woody1 kernel: [    0.603982] pci 0000:08:00.0:   bridge
window [io  disabled]
Oct 13 19:27:05 woody1 kernel: [    0.604115] pci 0000:08:00.0:   bridge
window [mem 0xfe100000-0xfe1fffff]
Oct 13 19:27:05 woody1 kernel: [    0.604248] pci 0000:08:00.0:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.604388] pci 0000:00:1c.7: PCI
bridge to [bus 08-09]
Oct 13 19:27:05 woody1 kernel: [    0.604515] pci 0000:00:1c.7:   bridge
window [io  disabled]
Oct 13 19:27:05 woody1 kernel: [    0.604646] pci 0000:00:1c.7:   bridge
window [mem 0xfe100000-0xfe1fffff]
Oct 13 19:27:05 woody1 kernel: [    0.604778] pci 0000:00:1c.7:   bridge
window [mem pref disabled]
Oct 13 19:27:05 woody1 kernel: [    0.604919] pci 0000:00:01.0: PCI INT
A -> GSI 16 (level, low) -> IRQ 16
Oct 13 19:27:05 woody1 kernel: [    0.605056] pci 0000:00:1c.0: PCI INT
A -> GSI 17 (level, low) -> IRQ 17
Oct 13 19:27:05 woody1 kernel: [    0.605197] pci 0000:00:1c.2: PCI INT
C -> GSI 18 (level, low) -> IRQ 18
Oct 13 19:27:05 woody1 kernel: [    0.605341] pci 0000:00:1c.3: PCI INT
D -> GSI 19 (level, low) -> IRQ 19
Oct 13 19:27:05 woody1 kernel: [    0.605479] pci 0000:00:1c.4: PCI INT
A -> GSI 17 (level, low) -> IRQ 17
Oct 13 19:27:05 woody1 kernel: [    0.605616] pci 0000:00:1c.5: PCI INT
B -> GSI 16 (level, low) -> IRQ 16
Oct 13 19:27:05 woody1 kernel: [    0.605752] pci 0000:00:1c.6: PCI INT
C -> GSI 18 (level, low) -> IRQ 18
Oct 13 19:27:05 woody1 kernel: [    0.605890] pci 0000:00:1c.7: PCI INT
D -> GSI 19 (level, low) -> IRQ 19
Oct 13 19:27:05 woody1 kernel: [    0.606025] pci 0000:08:00.0: PCI INT
A -> GSI 17 (level, low) -> IRQ 17
Oct 13 19:27:05 woody1 kernel: [    0.606216] NET: Registered protocol
family 2
Oct 13 19:27:05 woody1 kernel: [    0.606567] IP route cache hash table
entries: 524288 (order: 10, 4194304 bytes)
Oct 13 19:27:05 woody1 kernel: [    0.607419] TCP established hash table
entries: 524288 (order: 11, 8388608 bytes)
Oct 13 19:27:05 woody1 kernel: [    0.608622] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Oct 13 19:27:05 woody1 kernel: [    0.608872] TCP: Hash tables
configured (established 524288 bind 65536)
Oct 13 19:27:05 woody1 kernel: [    0.608999] TCP reno registered
Oct 13 19:27:05 woody1 kernel: [    0.609141] UDP hash table entries:
8192 (order: 6, 262144 bytes)
Oct 13 19:27:05 woody1 kernel: [    0.609324] UDP-Lite hash table
entries: 8192 (order: 6, 262144 bytes)
Oct 13 19:27:05 woody1 kernel: [    0.609536] NET: Registered protocol
family 1
Oct 13 19:27:05 woody1 kernel: [    0.856196] Trying to unpack rootfs
image as initramfs...
Oct 13 19:27:05 woody1 kernel: [    0.926378] Freeing initrd memory:
5312k freed
Oct 13 19:27:05 woody1 kernel: [    0.926968] PCI-DMA: Using software
bounce buffering for IO (SWIOTLB)
Oct 13 19:27:05 woody1 kernel: [    0.927109] Placing 64MB software IO
TLB between ffff8800cb41b000 - ffff8800cf41b000
Oct 13 19:27:05 woody1 kernel: [    0.927315] software IO TLB at phys
0xcb41b000 - 0xcf41b000
Oct 13 19:27:05 woody1 kernel: [    0.927833] audit: initializing
netlink socket (disabled)
Oct 13 19:27:05 woody1 kernel: [    0.927966] type=2000
audit(1318530397.755:1): initialized
Oct 13 19:27:05 woody1 kernel: [    0.942596] HugeTLB registered 2 MB
page size, pre-allocated 0 pages
Oct 13 19:27:05 woody1 kernel: [    0.972545] msgmni has been set to 32126
Oct 13 19:27:05 woody1 kernel: [    0.972843] Block layer SCSI generic
(bsg) driver version 0.4 loaded (major 253)
Oct 13 19:27:05 woody1 kernel: [    0.973065] io scheduler noop registered
Oct 13 19:27:05 woody1 kernel: [    0.973194] io scheduler deadline
registered (default)
Oct 13 19:27:05 woody1 kernel: [    0.973344] io scheduler cfq registered
Oct 13 19:27:05 woody1 kernel: [    0.974175] pcieport 0000:00:01.0:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.974303] pci 0000:01:00.0:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.974432] pci 0000:01:00.1:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.974575] pcieport 0000:00:1c.0:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.974721] pcieport 0000:00:1c.2:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.974852] pci 0000:03:00.0:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975011] pcieport 0000:00:1c.3:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975156] pcieport 0000:00:1c.4:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975285] pci 0000:05:00.0:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975428] pcieport 0000:00:1c.5:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975557] pci 0000:06:00.0:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975700] pcieport 0000:00:1c.6:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975833] pci 0000:07:00.0:
Signaling PME through PCIe PME interrupt
Oct 13 19:27:05 woody1 kernel: [    0.975984] pci_hotplug: PCI Hot Plug
PCI Core version: 0.5
Oct 13 19:27:05 woody1 kernel: [    0.976218] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Oct 13 19:27:05 woody1 kernel: [    0.976426] ACPI: Power Button [PWRB]
Oct 13 19:27:05 woody1 kernel: [    0.976581] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Oct 13 19:27:05 woody1 kernel: [    0.976787] ACPI: Power Button [PWRF]
Oct 13 19:27:05 woody1 kernel: [    0.978510] Serial: 8250/16550 driver,
4 ports, IRQ sharing disabled
Oct 13 19:27:05 woody1 kernel: [    0.999177] serial8250: ttyS0 at I/O
0x3f8 (irq = 4) is a 16550A
Oct 13 19:27:05 woody1 kernel: [    1.052653] 00:08: ttyS0 at I/O 0x3f8
(irq = 4) is a 16550A
Oct 13 19:27:05 woody1 kernel: [    1.052983] Non-volatile memory driver
v1.3
Oct 13 19:27:05 woody1 kernel: [    1.053735] brd: module loaded
Oct 13 19:27:05 woody1 kernel: [    1.054163] loop: module loaded
Oct 13 19:27:05 woody1 kernel: [    1.054334] ahci 0000:00:1f.2: PCI INT
B -> GSI 20 (level, low) -> IRQ 20
Oct 13 19:27:05 woody1 kernel: [    1.064924] ahci 0000:00:1f.2: AHCI
0001.0300 32 slots 6 ports 6 Gbps 0x1c impl SATA mode
Oct 13 19:27:05 woody1 kernel: [    1.065145] ahci 0000:00:1f.2: flags:
64bit ncq sntf pm led clo pio slum part ems apst
Oct 13 19:27:05 woody1 kernel: [    1.069232] scsi0 : ahci
Oct 13 19:27:05 woody1 kernel: [    1.069413] scsi1 : ahci
Oct 13 19:27:05 woody1 kernel: [    1.069580] scsi2 : ahci
Oct 13 19:27:05 woody1 kernel: [    1.069745] scsi3 : ahci
Oct 13 19:27:05 woody1 kernel: [    1.069923] scsi4 : ahci
Oct 13 19:27:05 woody1 kernel: [    1.070094] scsi5 : ahci
Oct 13 19:27:05 woody1 kernel: [    1.070315] ata1: DUMMY
Oct 13 19:27:05 woody1 kernel: [    1.070441] ata2: DUMMY
Oct 13 19:27:05 woody1 kernel: [    1.070566] ata3: SATA max UDMA/133
abar m2048@0xfe705000 port 0xfe705200 irq 47
Oct 13 19:27:05 woody1 kernel: [    1.070773] ata4: SATA max UDMA/133
abar m2048@0xfe705000 port 0xfe705280 irq 47
Oct 13 19:27:05 woody1 kernel: [    1.070990] ata5: SATA max UDMA/133
abar m2048@0xfe705000 port 0xfe705300 irq 47
Oct 13 19:27:05 woody1 kernel: [    1.071196] ata6: DUMMY
Oct 13 19:27:05 woody1 kernel: [    1.071396] i8042: PNP: No PS/2
controller found. Probing ports directly.
Oct 13 19:27:05 woody1 kernel: [    1.074175] serio: i8042 KBD port at
0x60,0x64 irq 1
Oct 13 19:27:05 woody1 kernel: [    1.074306] serio: i8042 AUX port at
0x60,0x64 irq 12
Oct 13 19:27:05 woody1 kernel: [    1.074454] mousedev: PS/2 mouse
device common for all mice
Oct 13 19:27:05 woody1 kernel: [    1.074630] rtc_cmos 00:04: RTC can
wake from S4
Oct 13 19:27:05 woody1 kernel: [    1.074834] rtc_cmos 00:04: rtc core:
registered rtc_cmos as rtc0
Oct 13 19:27:05 woody1 kernel: [    1.074994] rtc0: alarms up to one
month, y3k, 114 bytes nvram, hpet irqs
Oct 13 19:27:05 woody1 kernel: [    1.077847] md: raid1 personality
registered for level 1
Oct 13 19:27:05 woody1 kernel: [    1.077982] md: raid6 personality
registered for level 6
Oct 13 19:27:05 woody1 kernel: [    1.078111] md: raid5 personality
registered for level 5
Oct 13 19:27:05 woody1 kernel: [    1.078240] md: raid4 personality
registered for level 4
Oct 13 19:27:05 woody1 kernel: [    1.078404] device-mapper: uevent:
version 1.0.3
Oct 13 19:27:05 woody1 kernel: [    1.078574] device-mapper: ioctl:
4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
Oct 13 19:27:05 woody1 kernel: [    1.078844] cpuidle: using governor ladder
Oct 13 19:27:05 woody1 kernel: [    1.079085] cpuidle: using governor menu
Oct 13 19:27:05 woody1 kernel: [    1.079213] EFI Variables Facility
v0.08 2004-May-17
Oct 13 19:27:05 woody1 kernel: [    1.079409] usbcore: registered new
interface driver usbhid
Oct 13 19:27:05 woody1 kernel: [    1.079537] usbhid: USB HID core driver
Oct 13 19:27:05 woody1 kernel: [    1.079676] nf_conntrack version 0.5.0
(16384 buckets, 65536 max)
Oct 13 19:27:05 woody1 kernel: [    1.079916] ip_tables: (C) 2000-2006
Netfilter Core Team
Oct 13 19:27:05 woody1 kernel: [    1.080051] TCP cubic registered
Oct 13 19:27:05 woody1 kernel: [    1.080179] Initializing XFRM netlink
socket
Oct 13 19:27:05 woody1 kernel: [    1.080310] NET: Registered protocol
family 17
Oct 13 19:27:05 woody1 kernel: [    1.080446] Registering the
dns_resolver key type
Oct 13 19:27:05 woody1 kernel: [    1.094904] IMA: No TPM chip found,
activating TPM-bypass!
Oct 13 19:27:05 woody1 kernel: [    1.095513] rtc_cmos 00:04: setting
system clock to 2011-10-13 18:26:38 UTC (1318530398)
Oct 13 19:27:05 woody1 kernel: [    1.095755] Initializing network drop
monitor service
Oct 13 19:27:05 woody1 kernel: [    1.375707] ata4: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Oct 13 19:27:05 woody1 kernel: [    1.375868] ata5: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Oct 13 19:27:05 woody1 kernel: [    1.376013] ata3: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Oct 13 19:27:05 woody1 kernel: [    1.377254] ata4.00: ATA-8:
ST31000333AS, SD1B, max UDMA/133
Oct 13 19:27:05 woody1 kernel: [    1.377399] ata4.00: 1953525168
sectors, multi 16: LBA48 NCQ (depth 31/32)
Oct 13 19:27:05 woody1 kernel: [    1.377573] ata3.00: ATA-8:
ST31000333AS, SD1B, max UDMA/133
Oct 13 19:27:05 woody1 kernel: [    1.377714] ata3.00: 1953525168
sectors, multi 16: LBA48 NCQ (depth 31/32)
Oct 13 19:27:05 woody1 kernel: [    1.377855] ata5.00: ATA-8:
ST3750330AS, SD15, max UDMA/133
Oct 13 19:27:05 woody1 kernel: [    1.377985] ata5.00: 1465149168
sectors, multi 16: LBA48 NCQ (depth 31/32)
Oct 13 19:27:05 woody1 kernel: [    1.379240] ata4.00: configured for
UDMA/133
Oct 13 19:27:05 woody1 kernel: [    1.379491] ata3.00: configured for
UDMA/133
Oct 13 19:27:05 woody1 kernel: [    1.379733] scsi 2:0:0:0:
Direct-Access     ATA      ST31000333AS     SD1B PQ: 0 ANSI: 5
Oct 13 19:27:05 woody1 kernel: [    1.380035] sd 2:0:0:0: Attached scsi
generic sg0 type 0
Oct 13 19:27:05 woody1 kernel: [    1.380062] ata5.00: configured for
UDMA/133
Oct 13 19:27:05 woody1 kernel: [    1.380173] sd 2:0:0:0: [sda]
1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Oct 13 19:27:05 woody1 kernel: [    1.380332] sd 2:0:0:0: [sda] Write
Protect is off
Oct 13 19:27:05 woody1 kernel: [    1.380369] sd 2:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 13 19:27:05 woody1 kernel: [    1.381066] scsi 3:0:0:0:
Direct-Access     ATA      ST31000333AS     SD1B PQ: 0 ANSI: 5
Oct 13 19:27:05 woody1 kernel: [    1.381334] sd 3:0:0:0: Attached scsi
generic sg1 type 0
Oct 13 19:27:05 woody1 kernel: [    1.381370] sd 3:0:0:0: [sdb]
1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Oct 13 19:27:05 woody1 kernel: [    1.381431] sd 3:0:0:0: [sdb] Write
Protect is off
Oct 13 19:27:05 woody1 kernel: [    1.381456] sd 3:0:0:0: [sdb] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 13 19:27:05 woody1 kernel: [    1.382137] scsi 4:0:0:0:
Direct-Access     ATA      ST3750330AS      SD15 PQ: 0 ANSI: 5
Oct 13 19:27:05 woody1 kernel: [    1.382402] sd 4:0:0:0: [sdc]
1465149168 512-byte logical blocks: (750 GB/698 GiB)
Oct 13 19:27:05 woody1 kernel: [    1.382405] sd 4:0:0:0: Attached scsi
generic sg2 type 0
Oct 13 19:27:05 woody1 kernel: [    1.382843] sd 4:0:0:0: [sdc] Write
Protect is off
Oct 13 19:27:05 woody1 kernel: [    1.382997] sd 4:0:0:0: [sdc] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 13 19:27:05 woody1 kernel: [    1.387499]  sda: sda1 sda2 sda4
Oct 13 19:27:05 woody1 kernel: [    1.387930] sd 2:0:0:0: [sda] Attached
SCSI disk
Oct 13 19:27:05 woody1 kernel: [    1.393659]  sdb: sdb1 sdb2 sdb4
Oct 13 19:27:05 woody1 kernel: [    1.394083] sd 3:0:0:0: [sdb] Attached
SCSI disk
Oct 13 19:27:05 woody1 kernel: [    1.405653]  sdc: sdc4
Oct 13 19:27:05 woody1 kernel: [    1.406042] sd 4:0:0:0: [sdc] Attached
SCSI disk
Oct 13 19:27:05 woody1 kernel: [    1.408239] Freeing unused kernel
memory: 1448k freed
Oct 13 19:27:05 woody1 kernel: [    1.408487] Write protecting the
kernel read-only data: 8192k
Oct 13 19:27:05 woody1 kernel: [    1.409360] Freeing unused kernel
memory: 156k freed
Oct 13 19:27:05 woody1 kernel: [    1.415478] Freeing unused kernel
memory: 2020k freed
Oct 13 19:27:05 woody1 kernel: [    1.942303] Refined TSC clocksource
calibration: 3311.144 MHz.
Oct 13 19:27:05 woody1 kernel: [    1.942447] Switching to clocksource tsc
Oct 13 19:27:05 woody1 kernel: [    6.595686] md: md2 stopped.
Oct 13 19:27:05 woody1 kernel: [    6.597044] md: bind<sda2>
Oct 13 19:27:05 woody1 kernel: [    6.597416] md: bind<sdb2>
Oct 13 19:27:05 woody1 kernel: [    6.598608] bio: create slab <bio-1> at 1
Oct 13 19:27:05 woody1 kernel: [    6.598831] md/raid1:md2: active with
2 out of 2 mirrors
Oct 13 19:27:05 woody1 kernel: [    6.598971] md2: detected capacity
change from 0 to 249836560384
Oct 13 19:27:05 woody1 kernel: [   11.609196]  md2: unknown partition table
Oct 13 19:27:05 woody1 kernel: [   16.790558] EXT4-fs (dm-0): mounted
filesystem with ordered data mode. Opts: (null)
Oct 13 19:27:05 woody1 kernel: [   22.364873] readahead-collector: starting
Oct 13 19:27:05 woody1 kernel: [   22.667897] udev[125]: starting
version 161
Oct 13 19:27:05 woody1 kernel: [   22.927556] microcode: CPU0
sig=0x206a7, pf=0x2, revision=0x1a
Oct 13 19:27:05 woody1 kernel: [   22.936043] input: PC Speaker as
/devices/platform/pcspkr/input/input2
Oct 13 19:27:05 woody1 kernel: [   22.942729] xhci_hcd 0000:06:00.0: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Oct 13 19:27:05 woody1 kernel: [   22.942916] xhci_hcd 0000:06:00.0:
xHCI Host Controller
Oct 13 19:27:05 woody1 kernel: [   22.943080] xhci_hcd 0000:06:00.0: new
USB bus registered, assigned bus number 1
Oct 13 19:27:05 woody1 kernel: [   22.950250] xhci_hcd 0000:06:00.0: irq
17, io mem 0xfe300000
Oct 13 19:27:05 woody1 kernel: [   22.950569] usb usb1: New USB device
found, idVendor=1d6b, idProduct=0002
Oct 13 19:27:05 woody1 kernel: [   22.950708] usb usb1: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Oct 13 19:27:05 woody1 kernel: [   22.950918] usb usb1: Product: xHCI
Host Controller
Oct 13 19:27:05 woody1 kernel: [   22.951046] usb usb1: Manufacturer:
Linux 3.0.6 xhci_hcd
Oct 13 19:27:05 woody1 kernel: [   22.951174] usb usb1: SerialNumber:
0000:06:00.0
Oct 13 19:27:05 woody1 kernel: [   22.951375] hub 1-0:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   22.951508] hub 1-0:1.0: 2 ports detected
Oct 13 19:27:05 woody1 kernel: [   22.951682] xhci_hcd 0000:06:00.0:
xHCI Host Controller
Oct 13 19:27:05 woody1 kernel: [   22.951838] xhci_hcd 0000:06:00.0: new
USB bus registered, assigned bus number 2
Oct 13 19:27:05 woody1 kernel: [   22.953141] i801_smbus 0000:00:1f.3:
PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct 13 19:27:05 woody1 kernel: [   22.955452] usb usb2: New USB device
found, idVendor=1d6b, idProduct=0003
Oct 13 19:27:05 woody1 kernel: [   22.955584] usb usb2: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Oct 13 19:27:05 woody1 kernel: [   22.955787] usb usb2: Product: xHCI
Host Controller
Oct 13 19:27:05 woody1 kernel: [   22.955911] usb usb2: Manufacturer:
Linux 3.0.6 xhci_hcd
Oct 13 19:27:05 woody1 kernel: [   22.956044] usb usb2: SerialNumber:
0000:06:00.0
Oct 13 19:27:05 woody1 kernel: [   22.956239] hub 2-0:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   22.956370] hub 2-0:1.0: 2 ports detected
Oct 13 19:27:05 woody1 kernel: [   22.958798] atl1c 0000:07:00.0: PCI
INT A -> GSI 18 (level, low) -> IRQ 18
Oct 13 19:27:05 woody1 kernel: [   22.974194] tg3.c:v3.119 (May 18, 2011)
Oct 13 19:27:05 woody1 kernel: [   22.974331] tg3 0000:09:01.0: PCI INT
A -> GSI 16 (level, low) -> IRQ 16
Oct 13 19:27:05 woody1 kernel: [   22.978516] e1000e: Intel(R) PRO/1000
Network Driver - 1.3.10-k2
Oct 13 19:27:05 woody1 kernel: [   22.978648] e1000e: Copyright(c) 1999
- 2011 Intel Corporation.
Oct 13 19:27:05 woody1 kernel: [   22.978785] e1000e 0000:03:00.0:
Disabling ASPM L0s
Oct 13 19:27:05 woody1 kernel: [   22.978923] e1000e 0000:03:00.0: PCI
INT A -> GSI 18 (level, low) -> IRQ 18
Oct 13 19:27:05 woody1 kernel: [   22.992670] tg3 0000:09:01.0: eth0:
Tigon3 [partno(3C1000B-T) rev 1002] (PCI:33MHz:32-bit) MAC address
00:0a:5e:00:38:6e
Oct 13 19:27:05 woody1 kernel: [   22.992882] tg3 0000:09:01.0: eth0:
attached PHY is 5703 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
Oct 13 19:27:05 woody1 kernel: [   22.993089] tg3 0000:09:01.0: eth0:
RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
Oct 13 19:27:05 woody1 kernel: [   22.993296] tg3 0000:09:01.0: eth0:
dma_rwctrl[763f0000] dma_mask[64-bit]
Oct 13 19:27:05 woody1 kernel: [   22.998267] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Oct 13 19:27:05 woody1 kernel: [   22.998417] ehci_hcd 0000:00:1a.0: PCI
INT A -> GSI 23 (level, low) -> IRQ 23
Oct 13 19:27:05 woody1 kernel: [   22.998611] ehci_hcd 0000:00:1a.0:
EHCI Host Controller
Oct 13 19:27:05 woody1 kernel: [   22.998774] ehci_hcd 0000:00:1a.0: new
USB bus registered, assigned bus number 3
Oct 13 19:27:05 woody1 kernel: [   22.999006] ehci_hcd 0000:00:1a.0:
debug port 2
Oct 13 19:27:05 woody1 kernel: [   23.001865] microcode: CPU1
sig=0x206a7, pf=0x2, revision=0x1a
Oct 13 19:27:05 woody1 kernel: [   23.002759] microcode: CPU2
sig=0x206a7, pf=0x2, revision=0x1a
Oct 13 19:27:05 woody1 kernel: [   23.003019] ehci_hcd 0000:00:1a.0: irq
23, io mem 0xfe707000
Oct 13 19:27:05 woody1 kernel: [   23.003769] microcode: CPU3
sig=0x206a7, pf=0x2, revision=0x1a
Oct 13 19:27:05 woody1 kernel: [   23.004279] [drm] Initialized drm
1.1.0 20060810
Oct 13 19:27:05 woody1 kernel: [   23.004785] microcode: Microcode
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Oct 13 19:27:05 woody1 kernel: [   23.012531] ehci_hcd 0000:00:1a.0: USB
2.0 started, EHCI 1.00
Oct 13 19:27:05 woody1 kernel: [   23.012700] usb usb3: New USB device
found, idVendor=1d6b, idProduct=0002
Oct 13 19:27:05 woody1 kernel: [   23.012830] usb usb3: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Oct 13 19:27:05 woody1 kernel: [   23.013041] usb usb3: Product: EHCI
Host Controller
Oct 13 19:27:05 woody1 kernel: [   23.013171] usb usb3: Manufacturer:
Linux 3.0.6 ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   23.013298] usb usb3: SerialNumber:
0000:00:1a.0
Oct 13 19:27:05 woody1 kernel: [   23.013502] hub 3-0:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   23.013638] hub 3-0:1.0: 2 ports detected
Oct 13 19:27:05 woody1 kernel: [   23.013820] ehci_hcd 0000:00:1d.0: PCI
INT A -> GSI 23 (level, low) -> IRQ 23
Oct 13 19:27:05 woody1 kernel: [   23.013975] ehci_hcd 0000:00:1d.0:
EHCI Host Controller
Oct 13 19:27:05 woody1 kernel: [   23.014137] ehci_hcd 0000:00:1d.0: new
USB bus registered, assigned bus number 4
Oct 13 19:27:05 woody1 kernel: [   23.014366] ehci_hcd 0000:00:1d.0:
debug port 2
Oct 13 19:27:05 woody1 kernel: [   23.018378] ehci_hcd 0000:00:1d.0: irq
23, io mem 0xfe706000
Oct 13 19:27:05 woody1 kernel: [   23.027524] ehci_hcd 0000:00:1d.0: USB
2.0 started, EHCI 1.00
Oct 13 19:27:05 woody1 kernel: [   23.027665] usb usb4: New USB device
found, idVendor=1d6b, idProduct=0002
Oct 13 19:27:05 woody1 kernel: [   23.027796] usb usb4: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Oct 13 19:27:05 woody1 kernel: [   23.028003] usb usb4: Product: EHCI
Host Controller
Oct 13 19:27:05 woody1 kernel: [   23.028132] usb usb4: Manufacturer:
Linux 3.0.6 ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   23.028261] usb usb4: SerialNumber:
0000:00:1d.0
Oct 13 19:27:05 woody1 kernel: [   23.028476] hub 4-0:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   23.028611] hub 4-0:1.0: 2 ports detected
Oct 13 19:27:05 woody1 kernel: [   23.036637] md: bind<sdc4>
Oct 13 19:27:05 woody1 kernel: [   23.060726] atl1c 0000:07:00.0:
version 1.0.1.0-NAPI
Oct 13 19:27:05 woody1 kernel: [   23.077700] e1000e 0000:03:00.0: eth2:
(PCI Express:2.5GT/s:Width x1) 00:1b:21:ad:77:d1
Oct 13 19:27:05 woody1 kernel: [   23.077907] e1000e 0000:03:00.0: eth2:
Intel(R) PRO/1000 Network Connection
Oct 13 19:27:05 woody1 kernel: [   23.078050] e1000e 0000:03:00.0: eth2:
MAC: 3, PHY: 8, PBA No: E46981-005
Oct 13 19:27:05 woody1 kernel: [   23.086538] udev[134]: renamed network
interface eth2 to eth2-eth0
Oct 13 19:27:05 woody1 kernel: [   23.107509] udev[131]: renamed network
interface eth0 to eth2
Oct 13 19:27:05 woody1 kernel: [   23.141511] udev[134]: renamed network
interface eth2-eth0 to eth0
Oct 13 19:27:05 woody1 kernel: [   23.179765] [drm] radeon defaulting to
kernel modesetting.
Oct 13 19:27:05 woody1 kernel: [   23.179896] [drm] radeon kernel
modesetting enabled.
Oct 13 19:27:05 woody1 kernel: [   23.180060] radeon 0000:01:00.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16
Oct 13 19:27:05 woody1 kernel: [   23.180333] [drm] initializing kernel
modesetting (RV530 0x1002:0x71C6 0x174B:0x0880).
Oct 13 19:27:05 woody1 kernel: [   23.180581] [drm] register mmio base:
0xFE630000
Oct 13 19:27:05 woody1 kernel: [   23.180709] [drm] register mmio size:
65536
Oct 13 19:27:05 woody1 kernel: [   23.180927] ATOM BIOS: A67105
Oct 13 19:27:05 woody1 kernel: [   23.181065] [drm] Generation 2 PCI
interface, using max accessible memory
Oct 13 19:27:05 woody1 kernel: [   23.181197] radeon 0000:01:00.0: VRAM:
256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
Oct 13 19:27:05 woody1 kernel: [   23.181406] radeon 0000:01:00.0: GTT:
512M 0x0000000010000000 - 0x000000002FFFFFFF
Oct 13 19:27:05 woody1 kernel: [   23.181635] [drm] Supports vblank
timestamp caching Rev 1 (10.10.2010).
Oct 13 19:27:05 woody1 kernel: [   23.181763] [drm] Driver supports
precise vblank timestamp query.
Oct 13 19:27:05 woody1 kernel: [   23.181924] radeon 0000:01:00.0:
radeon: using MSI.
Oct 13 19:27:05 woody1 kernel: [   23.182065] [drm] radeon: irq initialized.
Oct 13 19:27:05 woody1 kernel: [   23.183206] [drm] Detected VRAM
RAM=256M, BAR=256M
Oct 13 19:27:05 woody1 kernel: [   23.183338] [drm] RAM width 128bits DDR
Oct 13 19:27:05 woody1 kernel: [   23.183669] [TTM] Zone  kernel:
Available graphics memory: 8226086 kiB.
Oct 13 19:27:05 woody1 kernel: [   23.183801] [TTM] Zone   dma32:
Available graphics memory: 2097152 kiB.
Oct 13 19:27:05 woody1 kernel: [   23.183929] [TTM] Initializing pool
allocator.
Oct 13 19:27:05 woody1 kernel: [   23.184070] [drm] radeon: 256M of VRAM
memory ready
Oct 13 19:27:05 woody1 kernel: [   23.184199] [drm] radeon: 512M of GTT
memory ready.
Oct 13 19:27:05 woody1 kernel: [   23.184346] [drm] GART: num cpu pages
131072, num gpu pages 131072
Oct 13 19:27:05 woody1 kernel: [   23.185739] [drm] radeon: 1 quad
pipes, 2 z pipes initialized.
Oct 13 19:27:05 woody1 kernel: [   23.186403] [drm] PCIE GART of 512M
enabled (table at 0x00040000).
Oct 13 19:27:05 woody1 kernel: [   23.186544] radeon 0000:01:00.0: WB
enabled
Oct 13 19:27:05 woody1 kernel: [   23.186712] [drm] Loading R500 Microcode
Oct 13 19:27:05 woody1 kernel: [   23.219179] md: bind<sdb4>
Oct 13 19:27:05 woody1 kernel: [   23.234390] [drm] radeon: ring at
0x0000000010001000
Oct 13 19:27:05 woody1 kernel: [   23.234546] [drm] ring test succeeded
in 8 usecs
Oct 13 19:27:05 woody1 kernel: [   23.234734] [drm] radeon: ib pool ready.
Oct 13 19:27:05 woody1 kernel: [   23.234953] [drm] ib test succeeded in
0 usecs
Oct 13 19:27:05 woody1 kernel: [   23.235215] [drm] Radeon Display
Connectors
Oct 13 19:27:05 woody1 kernel: [   23.235348] [drm] Connector 0:
Oct 13 19:27:05 woody1 kernel: [   23.235475] [drm]   DVI-I
Oct 13 19:27:05 woody1 kernel: [   23.235601] [drm]   HPD2
Oct 13 19:27:05 woody1 kernel: [   23.235728] [drm]   DDC: 0x7e40 0x7e40
0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Oct 13 19:27:05 woody1 kernel: [   23.235933] [drm]   Encoders:
Oct 13 19:27:05 woody1 kernel: [   23.236060] [drm]     CRT1:
INTERNAL_KLDSCP_DAC1
Oct 13 19:27:05 woody1 kernel: [   23.236187] [drm]     DFP3: INTERNAL_LVTM1
Oct 13 19:27:05 woody1 kernel: [   23.236314] [drm] Connector 1:
Oct 13 19:27:05 woody1 kernel: [   23.236442] [drm]   S-video
Oct 13 19:27:05 woody1 kernel: [   23.236568] [drm]   Encoders:
Oct 13 19:27:05 woody1 kernel: [   23.236693] [drm]     TV1:
INTERNAL_KLDSCP_DAC2
Oct 13 19:27:05 woody1 kernel: [   23.236822] [drm] Connector 2:
Oct 13 19:27:05 woody1 kernel: [   23.236949] [drm]   DVI-I
Oct 13 19:27:05 woody1 kernel: [   23.237076] [drm]   HPD1
Oct 13 19:27:05 woody1 kernel: [   23.237203] [drm]   DDC: 0x7e50 0x7e50
0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Oct 13 19:27:05 woody1 kernel: [   23.237411] [drm]   Encoders:
Oct 13 19:27:05 woody1 kernel: [   23.237538] [drm]     CRT2:
INTERNAL_KLDSCP_DAC2
Oct 13 19:27:05 woody1 kernel: [   23.237665] [drm]     DFP1:
INTERNAL_KLDSCP_TMDS1
Oct 13 19:27:05 woody1 kernel: [   23.247573] [drm] Radeon display
connector DVI-I-1: No monitor connected or invalid EDID
Oct 13 19:27:05 woody1 kernel: [   23.268871] md: bind<sdb1>
Oct 13 19:27:05 woody1 kernel: [   23.300382] [drm] Radeon display
connector DVI-I-2: Found valid EDID
Oct 13 19:27:05 woody1 kernel: [   23.300441] [drm] Possible lm63
thermal controller at 0x4c
Oct 13 19:27:05 woody1 kernel: [   23.305241] md: bind<sda1>
Oct 13 19:27:05 woody1 kernel: [   23.306934] md/raid1:md1: active with
2 out of 2 mirrors
Oct 13 19:27:05 woody1 kernel: [   23.307073] md1: detected capacity
change from 0 to 209649664
Oct 13 19:27:05 woody1 kernel: [   23.308197]  md1: unknown partition table
Oct 13 19:27:05 woody1 kernel: [   23.316277] usb 3-1: new high speed
USB device number 2 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   23.339184] md: bind<sda4>
Oct 13 19:27:05 woody1 kernel: [   23.341348] md/raid:md3: device sda4
operational as raid disk 2
Oct 13 19:27:05 woody1 kernel: [   23.341487] md/raid:md3: device sdb4
operational as raid disk 0
Oct 13 19:27:05 woody1 kernel: [   23.341622] md/raid:md3: device sdc4
operational as raid disk 1
Oct 13 19:27:05 woody1 kernel: [   23.341944] md/raid:md3: allocated 3230kB
Oct 13 19:27:05 woody1 kernel: [   23.342094] md/raid:md3: raid level 5
active with 3 out of 3 devices, algorithm 2
Oct 13 19:27:05 woody1 kernel: [   23.342340] md3: detected capacity
change from 0 to 1500307259392
Oct 13 19:27:05 woody1 kernel: [   23.343367]  md3: unknown partition table
Oct 13 19:27:05 woody1 kernel: [   23.378931] [drm] fb mappable at
0xD00C0000
Oct 13 19:27:05 woody1 kernel: [   23.379062] [drm] vram apper at 0xD0000000
Oct 13 19:27:05 woody1 kernel: [   23.379190] [drm] size 5242880
Oct 13 19:27:05 woody1 kernel: [   23.379318] [drm] fb depth is 24
Oct 13 19:27:05 woody1 kernel: [   23.379443] [drm]    pitch is 5120
Oct 13 19:27:05 woody1 kernel: [   23.379611] fbcon: radeondrmfb (fb0)
is primary device
Oct 13 19:27:05 woody1 kernel: [   23.390012] Console: switching to
colour frame buffer device 160x64
Oct 13 19:27:05 woody1 kernel: [   23.394666] fb0: radeondrmfb frame
buffer device
Oct 13 19:27:05 woody1 kernel: [   23.394691] drm: registered panic notifier
Oct 13 19:27:05 woody1 kernel: [   23.394717] [drm] Initialized radeon
2.10.0 20080528 for 0000:01:00.0 on minor 0
Oct 13 19:27:05 woody1 kernel: [   23.430587] usb 3-1: New USB device
found, idVendor=8087, idProduct=0024
Oct 13 19:27:05 woody1 kernel: [   23.430638] usb 3-1: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Oct 13 19:27:05 woody1 kernel: [   23.430884] hub 3-1:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   23.430954] hub 3-1:1.0: 6 ports detected
Oct 13 19:27:05 woody1 kernel: [   23.533144] usb 4-1: new high speed
USB device number 2 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   23.648403] usb 4-1: New USB device
found, idVendor=8087, idProduct=0024
Oct 13 19:27:05 woody1 kernel: [   23.648454] usb 4-1: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Oct 13 19:27:05 woody1 kernel: [   23.648675] hub 4-1:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   23.648773] hub 4-1:1.0: 8 ports detected
Oct 13 19:27:05 woody1 kernel: [   23.923934] usb 4-1.1: new full speed
USB device number 3 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   24.009104] usb 4-1.1: New USB device
found, idVendor=0557, idProduct=7000
Oct 13 19:27:05 woody1 kernel: [   24.009156] usb 4-1.1: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Oct 13 19:27:05 woody1 kernel: [   24.009375] hub 4-1.1:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   24.009470] hub 4-1.1:1.0: 4 ports
detected
Oct 13 19:27:05 woody1 kernel: [   24.082800] usb 4-1.2: new low speed
USB device number 4 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   24.175392] usb 4-1.2: New USB device
found, idVendor=046d, idProduct=c521
Oct 13 19:27:05 woody1 kernel: [   24.175448] usb 4-1.2: New USB device
strings: Mfr=1, Product=2, SerialNumber=0
Oct 13 19:27:05 woody1 kernel: [   24.175489] usb 4-1.2: Product: USB
Receiver
Oct 13 19:27:05 woody1 kernel: [   24.175513] usb 4-1.2: Manufacturer:
Logitech
Oct 13 19:27:05 woody1 kernel: [   24.180952] input: Logitech USB
Receiver as
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.2/4-1.2:1.0/input/input3
Oct 13 19:27:05 woody1 kernel: [   24.181064] generic-usb
0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB
Receiver] on usb-0000:00:1d.0-1.2/input0
Oct 13 19:27:05 woody1 kernel: [   24.187424] input: Logitech USB
Receiver as
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.2/4-1.2:1.1/input/input4
Oct 13 19:27:05 woody1 kernel: [   24.187560] generic-usb
0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device
[Logitech USB Receiver] on usb-0000:00:1d.0-1.2/input1
Oct 13 19:27:05 woody1 kernel: [   24.260654] usb 4-1.6: new high speed
USB device number 5 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   24.347694] usb 4-1.6: New USB device
found, idVendor=05e3, idProduct=0608
Oct 13 19:27:05 woody1 kernel: [   24.347745] usb 4-1.6: New USB device
strings: Mfr=0, Product=1, SerialNumber=0
Oct 13 19:27:05 woody1 kernel: [   24.347796] usb 4-1.6: Product: USB2.0 Hub
Oct 13 19:27:05 woody1 kernel: [   24.348104] hub 4-1.6:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   24.348475] hub 4-1.6:1.0: 4 ports
detected
Oct 13 19:27:05 woody1 kernel: [   24.423521] usb 4-1.1.1: new low speed
USB device number 6 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   24.543035] usb 4-1.1.1: New USB
device found, idVendor=0d3d, idProduct=0001
Oct 13 19:27:05 woody1 kernel: [   24.543091] usb 4-1.1.1: New USB
device strings: Mfr=0, Product=2, SerialNumber=0
Oct 13 19:27:05 woody1 kernel: [   24.543133] usb 4-1.1.1: Product: USBPS2
Oct 13 19:27:05 woody1 kernel: [   24.582173] input: USBPS2 as
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.1/4-1.1.1/4-1.1.1:1.0/input/input5
Oct 13 19:27:05 woody1 kernel: [   24.583859] generic-usb
0003:0D3D:0001.0003: input,hidraw2: USB HID v1.00 Keyboard [USBPS2] on
usb-0000:00:1d.0-1.1.1/input0
Oct 13 19:27:05 woody1 kernel: [   24.627646] input: USBPS2 as
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.1/4-1.1.1/4-1.1.1:1.1/input/input6
Oct 13 19:27:05 woody1 kernel: [   24.629451] generic-usb
0003:0D3D:0001.0004: input,hidraw3: USB HID v1.00 Mouse [USBPS2] on
usb-0000:00:1d.0-1.1.1/input1
Oct 13 19:27:05 woody1 kernel: [   24.694419] usb 4-1.6.4: new full
speed USB device number 7 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   24.771091] usb 4-1.6.4: New USB
device found, idVendor=058f, idProduct=9254
Oct 13 19:27:05 woody1 kernel: [   24.772872] usb 4-1.6.4: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Oct 13 19:27:05 woody1 kernel: [   24.774633] usb 4-1.6.4: Product:
Generic USB Hub
Oct 13 19:27:05 woody1 kernel: [   24.776378] usb 4-1.6.4: Manufacturer:
ALCOR
Oct 13 19:27:05 woody1 kernel: [   24.778360] hub 4-1.6.4:1.0: USB hub found
Oct 13 19:27:05 woody1 kernel: [   24.780212] hub 4-1.6.4:1.0: 4 ports
detected
Oct 13 19:27:05 woody1 kernel: [   25.043997] usb 4-1.6.4.1: new full
speed USB device number 8 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   25.127252] usb 4-1.6.4.1: New USB
device found, idVendor=04b8, idProduct=0005
Oct 13 19:27:05 woody1 kernel: [   25.129108] usb 4-1.6.4.1: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Oct 13 19:27:05 woody1 kernel: [   25.130959] usb 4-1.6.4.1: Product:
USB Printer
Oct 13 19:27:05 woody1 kernel: [   25.132816] usb 4-1.6.4.1:
Manufacturer: EPSON
Oct 13 19:27:05 woody1 kernel: [   25.134677] usb 4-1.6.4.1:
SerialNumber: 123450610171029400
Oct 13 19:27:05 woody1 kernel: [   25.159808] usblp0: USB Bidirectional
printer dev 8 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
Oct 13 19:27:05 woody1 kernel: [   25.161685] usbcore: registered new
interface driver usblp
Oct 13 19:27:05 woody1 kernel: [   25.198864] usb 4-1.6.4.4: new full
speed USB device number 9 using ehci_hcd
Oct 13 19:27:05 woody1 kernel: [   25.286535] usb 4-1.6.4.4: not running
at top speed; connect to a high speed hub
Oct 13 19:27:05 woody1 kernel: [   25.290719] usb 4-1.6.4.4: New USB
device found, idVendor=04a9, idProduct=10d2
Oct 13 19:27:05 woody1 kernel: [   25.292628] usb 4-1.6.4.4: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Oct 13 19:27:05 woody1 kernel: [   25.294541] usb 4-1.6.4.4: Product:
iP4700 series
Oct 13 19:27:05 woody1 kernel: [   25.296430] usb 4-1.6.4.4:
Manufacturer: Canon
Oct 13 19:27:05 woody1 kernel: [   25.298308] usb 4-1.6.4.4:
SerialNumber: A109B0
Oct 13 19:27:05 woody1 kernel: [   25.304292] usblp1: USB Bidirectional
printer dev 9 if 0 alt 0 proto 2 vid 0x04A9 pid 0x10D2
Oct 13 19:27:05 woody1 kernel: [   25.433058] EXT4-fs (dm-0):
re-mounted. Opts: (null)
Oct 13 19:27:05 woody1 kernel: [   25.739926] EXT4-fs (md1): mounted
filesystem with ordered data mode. Opts: (null)
Oct 13 19:27:05 woody1 kernel: [   25.773623] EXT4-fs (dm-1): mounted
filesystem with ordered data mode. Opts: (null)
Oct 13 19:27:05 woody1 kernel: [   25.805764] EXT4-fs (dm-2): mounted
filesystem with ordered data mode. Opts: (null)
Oct 13 19:27:05 woody1 kernel: [   25.880740] EXT4-fs (dm-8): mounted
filesystem with ordered data mode. Opts: (null)
Oct 13 19:27:05 woody1 kernel: [   25.885594] EXT4-fs (dm-9): mounted
filesystem with ordered data mode. Opts: (null)
Oct 13 19:27:05 woody1 kernel: [   27.105218] Adding 2097148k swap on
/dev/mapper/vg1a-swap.  Priority:-1 extents:1 across:2097148k
Oct 13 19:27:05 woody1 kernel: [   27.343638] readahead-disable-service:
delaying service auditd
Oct 13 19:27:05 woody1 cpuspeed: Enabling ondemand cpu frequency scaling
governor
Oct 13 19:27:06 woody1 rpcbind: cannot create socket for udp6
Oct 13 19:27:06 woody1 rpcbind: cannot create socket for tcp6
Oct 13 19:27:06 woody1 rpc.statd[802]: Version 1.2.3 starting
Oct 13 19:27:06 woody1 sm-notify[803]: Version 1.2.3 starting
Oct 13 19:27:06 woody1 kernel: [   28.974702] RPC: Registered named UNIX
socket transport module.
Oct 13 19:27:06 woody1 kernel: [   28.976576] RPC: Registered udp
transport module.
Oct 13 19:27:06 woody1 kernel: [   28.976577] RPC: Registered tcp
transport module.
Oct 13 19:27:06 woody1 kernel: [   28.976578] RPC: Registered tcp
NFSv4.1 backchannel transport module.
Oct 13 19:27:07 woody1 kernel: [   29.579706] Bridge firewalling registered
Oct 13 19:27:08 woody1 kernel: [   31.046070] atl1c 0000:07:00.0: atl1c:
eth1 NIC Link is Up<1000 Mbps Full Duplex>
Oct 13 19:27:08 woody1 kernel: [   31.074431] tun: Universal TUN/TAP
device driver, 1.6
Oct 13 19:27:08 woody1 kernel: [   31.074435] tun: (C) 1999-2004 Max
Krasnyansky <maxk@qualcomm.com>
Oct 13 19:27:09 woody1 kernel: [   32.121206] device eth0 entered
promiscuous mode
Oct 13 19:27:09 woody1 kernel: [   32.123605] device tap10 entered
promiscuous mode
Oct 13 19:27:09 woody1 kernel: [   32.131482] device eth1 entered
promiscuous mode
Oct 13 19:27:09 woody1 kernel: [   32.133813] device tap11 entered
promiscuous mode
Oct 13 19:27:09 woody1 kernel: [   32.135467] br1: port 1(eth1) entering
forwarding state
Oct 13 19:27:09 woody1 kernel: [   32.135471] br1: port 1(eth1) entering
forwarding state
Oct 13 19:27:10 woody1 kernel: [   32.693502] e1000e: eth0 NIC Link is
Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
Oct 13 19:27:10 woody1 kernel: [   32.693508] e1000e 0000:03:00.0: eth0:
10/100 speed: disabling TSO
Oct 13 19:27:10 woody1 kernel: [   32.695107] br0: port 1(eth0) entering
forwarding state
Oct 13 19:27:10 woody1 kernel: [   32.695111] br0: port 1(eth0) entering
forwarding state
Oct 13 19:27:12 woody1 kernel: [   34.903067] tg3 0000:09:01.0: eth2:
Link is up at 1000 Mbps, full duplex
Oct 13 19:27:12 woody1 kernel: [   34.903072] tg3 0000:09:01.0: eth2:
Flow control is on for TX and on for RX



