Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2K2Atg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:49:36 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41238 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2K2Ate convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:49:34 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Robert Hancock'" <hancockrwd@gmail.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>,
        <support@supermicro.com>, <linux-kernel@vger.kernel.org>,
        "'Dan Williams'" <djbw@fb.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com> <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com> <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com> <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com> <50B6ADA5.2030205@gmail.com>
In-Reply-To: <50B6ADA5.2030205@gmail.com>
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Wed, 28 Nov 2012 19:49:32 -0500
Message-ID: <04b301cdcdcb$65e2f400$31a8dc00$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH421ylXKr/7aSEd56ctRShmAJ9gwGHtGctAMAwLAsA1DUSgwLbZdCZAXol/xoByREOOQK10CNCAnA9sI2XNtejIA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Robert Hancock [mailto:hancockrwd@gmail.com] 
Sent: Wednesday, November 28, 2012 7:35 PM
To: Justin Piszcz
Cc: 'Bjorn Helgaas'; 'Bruno Prémont'; support@supermicro.com;
linux-kernel@vger.kernel.org; 'Dan Williams'
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
bug question


What does lspci -vv show on that controller? Not sure what actual 
chipset that controller is, but there's a known issue with some Marvell 
6Gbps SATA controllers with DMAR enabled - it seems the device issues 
memory read/write requests from the wrong PCI function ID and the IOMMU 
rightly denies access as the function listed in the requests doesn't 
have any mapping to that memory. I don't think there's presently a 
workaround other than disabling DMAR. We could (and likely should) be 
detecting that device and adding some kind of quirk for it.

That sounds likely...
It is shown below:

Card name: HighPoint Rocket 620 Dual Port SATA 6 Gbps PCI Express 2.0 Host
Adapter

lspci -vv output:

84:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe SATA
6.0 Gb/s controller (rev 11) (prog-if 01 [AHCI 1.0])
  Subsystem: Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s
controller
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 256 bytes
  Interrupt: pin A routed to IRQ 119
  Region 0: I/O ports at e000 [size=8]
  Region 1: I/O ports at dc00 [size=4]
  Region 2: I/O ports at ec00 [size=8]
  Region 3: I/O ports at e800 [size=4]
  Region 4: I/O ports at e400 [size=16]
  Region 5: Memory at cfeee000 (32-bit, non-prefetchable) [size=2K]
  Expansion ROM at cfef0000 [disabled] [size=64K]
  Capabilities: [40] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-
    Address: fee20000  Data: 4076
  Capabilities: [70] Express (v2) Legacy Endpoint, MSI 00
    DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
      ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 256 bytes, MaxReadReq 512 bytes
    DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
    LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns,
L1 <64us
      ClockPM- Surprise- LLActRep- BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
    DevCap2: Completion Timeout: Not Supported, TimeoutDis+
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [100 v1] Advanced Error Reporting
    UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
    UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
    UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
    CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
    CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
    AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
  Kernel driver in use: ahci

>
> --
>
>
> ==> Further issues with the X9SRL-F -- does this board support ASPM or is
> this a Linux/ASPM implementation issue?
> [    0.632170]  pci0000:ff: ACPI _OSC support notification failed,
disabling
> PCIe ASPM
> [    0.632239]  pci0000:ff: Unable to request _OSC control (_OSC support
> mask: 0x08)

What's the full dmesg from this machine (or is it already posted somewhere)?

It is now available here:
http://home.comcast.net/~jpiszcz/20121128/dmesg.txt

Justin.


