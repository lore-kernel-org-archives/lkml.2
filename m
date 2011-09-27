Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1I0S2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:28:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab1I0S2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:28:37 -0400
Message-ID: <4E8215B6.1020108@redhat.com>
Date: Tue, 27 Sep 2011 21:28:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jon Mason <mason@myri.com>
CC: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [REGRESSION] e1000e failure triggered by "PCI: Remove MRRS modification
 from MPS setting code"
References: <4E82017C.3010304@redhat.com> <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
In-Reply-To: <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 08:59 PM, Jon Mason wrote:
> On Tue, Sep 27, 2011 at 12:01 PM, Avi Kivity<avi@redhat.com>  wrote:
> >  Commit ed2888e906b567 (merged 3.1-rc6) causes a reproducible failure with my
> >  e1000e card here.  Starting a kvm guest (which mostly consists of shoving
> >  display updates over X over ssh, as far as the network is concerned) locks
> >  up the card hard.
> >
> >  The failure is easily reproducible, will gladly test patches.
>
> Does the problem occur with the adapter assigned to the kvm guest or
> the host?

The host.  It's not even using vhost-net or tap or bridge.  In fact the 
failure happens before the guest has set up neworking itself (in grub, 
while clearing the screen); all of the networking load is due to 
tunnelling X over ssh.

> I assume that you are running with the default behavior and
> not with the boot arg "pci=pcie_bus_perf".

Correct.

> Can you get the dmesg
> output (specifically the lines that have "Dev MPS")

(this is with the patch reverted)

Sep 27 20:42:48 violet-regb kernel: pci 0000:02:02.0: PCI bridge to [bus 
04-04]
Sep 27 20:42:48 violet-regb kernel: pci 0000:01:00.3: PCI bridge to [bus 
05-05]
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:03.0: PCI bridge to [bus 
06-06]
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:1c.0: PCI bridge to [bus 
07-07]
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:1e.0: PCI bridge to [bus 
08-08] (subtractive decode)
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:02.0: Dev MPS 128 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:02.0: Dev MPS 256 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:01:00.0: Dev MPS 128 MPSS 
256 MRRS 4096
Sep 27 20:42:48 violet-regb kernel: pci 0000:01:00.0: Dev MPS 256 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:02:00.0: Dev MPS 128 MPSS 
256 MRRS 2048
Sep 27 20:42:48 violet-regb kernel: pci 0000:02:00.0: Dev MPS 256 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:02:02.0: Dev MPS 128 MPSS 
256 MRRS 2048
Sep 27 20:42:48 violet-regb kernel: pci 0000:02:02.0: Dev MPS 256 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:04:00.0: Dev MPS 128 MPSS 
256 MRRS 512
Sep 27 20:42:48 violet-regb kernel: pci 0000:04:00.0: Dev MPS 256 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:04:00.1: Dev MPS 128 MPSS 
256 MRRS 512
Sep 27 20:42:48 violet-regb kernel: pci 0000:04:00.1: Dev MPS 256 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:01:00.3: Dev MPS 256 MPSS 
256 MRRS 256
Sep 27 20:42:48 violet-regb kernel: pci 0000:01:00.3: Dev MPS 256 MPSS 
256 MRRS 256
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:03.0: Dev MPS 128 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:03.0: Dev MPS 256 MPSS 
256 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:1c.0: Dev MPS 128 MPSS 
128 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci 0000:00:1c.0: Dev MPS 128 MPSS 
128 MRRS 128
Sep 27 20:42:48 violet-regb kernel: pci0000:00: Requesting ACPI _OSC 
control (0x1d)
Sep 27 20:42:48 violet-regb kernel: pci0000:00: ACPI _OSC request failed 
(AE_NOT_FOUND), returned control mask: 0x1d
Sep 27 20:42:48 violet-regb kernel: ACPI _OSC control for PCIe not 
granted, disabling ASPM
Sep 27 20:42:48 violet-regb kernel: ACPI: PCI Interrupt Link [LNKA] 
(IRQs 3 4 5 6 *7 10 11 14 15)
Sep 27 20:42:48 violet-regb kernel: ACPI: PCI Interrupt Link [LNKB] 
(IRQs 3 4 *5 6 7 10 11 14 15)
Sep 27 20:42:48 violet-regb kernel: ACPI: PCI Interrupt Link [LNKC] 
(IRQs 3 4 5 6 7 *10 11 14 15)
Sep 27 20:42:48 violet-regb kernel: ACPI: PCI Interrupt Link [LNKD] 
(IRQs 3 4 5 6 7 10 *11 14 15)
Sep 27 20:42:48 violet-regb kernel: ACPI: PCI Interrupt Link [LNKE] 
(IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
Sep 27 20:42:48 violet-regb kernel: ACPI: PCI Interrupt Link [LNKF] 
(IRQs 4 5 6 7 10 11 14 15) *0, disabled.
Sep 27 20:42:48 violet-regb kernel: ACPI: PCI Interrupt Link [LNKG] 
(IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.


>   and lspci -vvv on
> the host?

# lspci -vvv
00:00.0 Host bridge: Intel Corporation 5000V Chipset Memory Controller 
Hub (rev 92)
     Subsystem: Tyan Computer Device 5372
     Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 0
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable- Count=1/2 Maskable- 64bit-
         Address: fee00000  Data: 0000
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol+
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol+
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 15, GenCap- CGenEn- ChkCap- ChkEn-

00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 2-3 (rev 92) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=01, subordinate=05, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: df100000-df2fffff
     Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable- Count=1/2 Maskable- 64bit-
         Address: fee00000  Data: 0000
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable+ ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 3 (rev 92) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: fff00000-000fffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable- Count=1/2 Maskable- 64bit-
         Address: fee00000  Data: 0000
     Capabilities: [6c] Express (v1) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #3, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise+ LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         RootCtl: ErrCorrectable+ ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport

00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA 
Engine (rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 0
     Region 0: Memory at fe700000 (64-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: fee00000  Data: 0000
     Capabilities: [6c] Express (v1) Root Complex Integrated Endpoint, 
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-

00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev 92)
     Subsystem: Intel Corporation Device 8086
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
     I/O behind bridge: 00004000-00004fff
     Memory behind bridge: d0100000-d02fffff
     Prefetchable memory behind bridge: 00000000d0300000-00000000d04fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag+ RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn+ PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Off, PwrInd Off, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 4151
     Capabilities: [90] Subsystem: Tyan Computer Device 5372
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=01 ComponentID=02 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09) (prog-if 00 [UHCI])
     Subsystem: Tyan Computer Device 5372
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 17
     Region 4: I/O ports at 1800 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09) (prog-if 00 [UHCI])
     Subsystem: Tyan Computer Device 5372
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 4: I/O ports at 1820 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09) (prog-if 00 [UHCI])
     Subsystem: Tyan Computer Device 5372
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 18
     Region 4: I/O ports at 1840 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #4 (rev 09) (prog-if 00 [UHCI])
     Subsystem: Tyan Computer Device 5372
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin D routed to IRQ 16
     Region 4: I/O ports at 1860 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09) (prog-if 20 [EHCI])
     Subsystem: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 
Controller
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 17
     Region 0: Memory at df500000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9) (prog-if 
01 [Subtractive decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Bus: primary=00, secondary=08, subordinate=08, sec-latency=32
     I/O behind bridge: 00003000-00003fff
     Memory behind bridge: df000000-df0fffff
     Prefetchable memory behind bridge: 00000000de000000-00000000deffffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Subsystem: Tyan Computer Device 5372

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
     Subsystem: Tyan Computer Device 5372
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0

00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset 
SATA IDE Controller (rev 09) (prog-if 80 [Master])
     Subsystem: Tyan Computer Device 5372
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 0: I/O ports at 01f0 [size=8]
     Region 1: I/O ports at 03f4 [size=1]
     Region 2: I/O ports at 0170 [size=8]
     Region 3: I/O ports at 0374 [size=1]
     Region 4: I/O ports at 18b0 [size=16]
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: ata_piix
     Kernel modules: ata_generic, pata_acpi

00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus 
Controller (rev 09)
     Subsystem: Tyan Computer Device 5372
     Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin C routed to IRQ 18
     Region 4: I/O ports at 1100 [size=32]
     Kernel driver in use: i801_smbus
     Kernel modules: i2c-i801

01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=01, secondary=02, subordinate=04, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: df200000-df2fffff
     Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) Upstream Port, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- 
FLReset-SlotPowerLimit 0.000W
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Tyan Computer Device 5372
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport

01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to 
PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=01, secondary=05, subordinate=05, sec-latency=64
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: fff00000-000fffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) PCI/PCI-X Bridge, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal+ 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
             MaxPayload 256 bytes, MaxReadReq 256 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [6c] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Tyan Computer Device 5372
     Capabilities: [d8] PCI-X bridge device
         Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
         Status: Dev=00:00.3 64bit- 133MHz- SCD- USC- SCO- SRD-
         Upstream: Capacity=65535 CommitmentLimit=65535
         Downstream: Capacity=65535 CommitmentLimit=65535
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-

02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=02, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: fff00000-000fffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) Downstream Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency 
L0 <512ns, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Tyan Computer Device 5372
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport

02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E3 (rev 01) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=02, secondary=04, subordinate=04, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: df200000-df2fffff
     Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [44] Express (v1) Downstream Port (Slot-), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] Subsystem: Tyan Computer Device 5372
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Kernel driver in use: pcieport

04:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
     Subsystem: Tyan Computer Device 5300
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 65
     Region 0: Memory at df220000 (32-bit, non-prefetchable) [size=128K]
     Region 1: Memory at df200000 (32-bit, non-prefetchable) [size=128K]
     Region 2: I/O ports at 2000 [size=32]
     [virtual] Expansion ROM at d0000000 [disabled] [size=64K]
     Capabilities: [c8] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0100c  Data: 4179
     Capabilities: [e0] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, 
Latency L0 <128ns, L1 <64us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [140 v1] Device Serial Number 00-e0-81-ff-ff-44-3f-4e
     Kernel driver in use: e1000e
     Kernel modules: e1000e

04:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
     Subsystem: Tyan Computer Device 5300
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin B routed to IRQ 66
     Region 0: Memory at df260000 (32-bit, non-prefetchable) [size=128K]
     Region 1: Memory at df240000 (32-bit, non-prefetchable) [size=128K]
     Region 2: I/O ports at 2020 [size=32]
     [virtual] Expansion ROM at d0010000 [disabled] [size=64K]
     Capabilities: [c8] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0200c  Data: 4189
     Capabilities: [e0] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, 
Latency L0 <128ns, L1 <64us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [140 v1] Device Serial Number 00-e0-81-ff-ff-44-3f-4e
     Kernel driver in use: e1000e
     Kernel modules: e1000e

08:01.0 VGA compatible controller: XGI Technology Inc. (eXtreme Graphics 
Innovation) Z7/Z9 (XG20 core) (prog-if 00 [VGA controller])
     Subsystem: XGI Technology Inc. (eXtreme Graphics Innovation) Z7/Z9 
(XG20 core)
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     BIST result: 00
     Region 0: Memory at de000000 (32-bit, prefetchable) [size=16M]
     Region 1: Memory at df000000 (32-bit, non-prefetchable) [size=256K]
     Region 2: I/O ports at 3000 [size=128]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [40] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

08:02.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet 
Pro 100 (rev 10)
     Subsystem: Intel Corporation EtherExpress PRO/100 S Server Adapter
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 66 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 10
     Region 0: Memory at df060000 (32-bit, non-prefetchable) [size=4K]
     Region 1: I/O ports at 3080 [size=64]
     Region 2: Memory at df040000 (32-bit, non-prefetchable) [size=128K]
     Capabilities: [dc] Power Management version 2
         Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-


> Is this an e1000e 4port adapter?

Dual port.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

