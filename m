Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab1IGTTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:19:21 -0400
Received: from peace.netnation.com ([204.174.223.2]:49183 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab1IGTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:19:05 -0400
Date: Wed, 7 Sep 2011 12:18:59 -0700
From: Simon Kirby <sim@hostway.ca>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Jon Mason <mason@myri.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Sven Schnelle <svens@stackframe.org>,
        linux-kernel@vger.kernel.org, Jordan_Hargrave@dell.com
Subject: Re: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max
	Payload Size on fabric"
Message-ID: <20110907191859.GB14950@hostway.ca>
References: <20110906173605.GA12577@hostway.ca> <87aaag9vb8.fsf@begreifnix.stackframe.org> <CA+5PVA5aEAgdKexWK_cg2zRJk5CFsg6rhp9Wx+80GjR7iaLkOA@mail.gmail.com> <20110907104432.2f9d8b0a@jbarnes-x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907104432.2f9d8b0a@jbarnes-x220>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 10:44:32AM -0700, Jesse Barnes wrote:

> On Wed, 7 Sep 2011 12:52:25 -0400
> Josh Boyer <jwboyer@gmail.com> wrote:
> 
> > On Wed, Sep 7, 2011 at 12:22 PM, Sven Schnelle <svens@stackframe.org>
> > wrote:
> > > Simon Kirby <sim@hostway.ca> writes:
> > >
> > >> Hello!
> > >>
> > >> Since trying 3.1-rc4 on a few Dell servers, all of them have
> > >> booted up with the amber error LED lit. "ipmitool sel list" shows:
> > >>
> > >> ?? ??1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 | Log
> > >> area reset/cleared | Asserted 2 | 09/06/2011 | 17:25:38 | Critical
> > >> Interrupt #0x18 | Bus Fatal Error | Asserted 3 | 09/06/2011 |
> > >> 17:25:38 | Unknown #0x1a | 4 | 09/06/2011 | 17:25:38 | Unknown
> > >> #0x1a |
> > >
> > > I'm seeing exact the same issue on a Dell 1950 Server. If anyone
> > > wants me to try additional debugging/patches, feel free to do
> > > so. Unfortunately i don't have the time/knowledge to debug that by
> > > myself.
> > 
> > I thought Jesse or Jon had a revert or partial fix queued up to send
> > to Linus, but I don't see anything in or post -rc5 yet.  That was
> > indicated in https://bugzilla.kernel.org/show_bug.cgi?id=42162
> > 
> > Jesse, Jon?
> 
> kernel.org is still down and I haven't pushed anything to github.  I
> asked Jon to send his patch directly to Linus today instead.

FWIW, this patch didn't seem to fix it:
https://bugzilla.kernel.org/attachment.cgi?id=71222

dmesg used to say:

pci 0000:00:02.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:02.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:06:00.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:06:00.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:08:00.0: MPS configured higher than maximum supported by the device.  If a bus issue occurs, try running with pci=pcie_bus_safe.
pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
Uhhuh. NMI received for unknown reason 21 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
pci 0000:07:01.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:07:01.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:06:00.3: Dev MPS 128 MPSS 256 MRRS 256
pci 0000:06:00.3: Dev MPS 256 MPSS 256 MRRS 256
pci 0000:00:03.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:03.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:01:00.0: Dev MPS 256 MPSS 256 MRRS 512
pci 0000:01:00.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:01:00.2: Dev MPS 256 MPSS 256 MRRS 512
pci 0000:01:00.2: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:04.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:04.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:05.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:05.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:06.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:06.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:07.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:07.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:04:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:04:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci_bus 0000:00: on NUMA node 0

with the patch, I see:

pci 0000:00:02.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:02.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:06:00.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:06:00.0: Dev MPS 256 MPSS 256 MRRS 4096
pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 4096
pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:08:00.0: MPS configured higher than maximum supported by the
device.  If a bus issue occurs, try running with pci=pcie_bus_safe.
pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:07:01.0: Dev MPS 128 MPSS 256 MRRS 4096
pci 0000:07:01.0: Dev MPS 256 MPSS 256 MRRS 4096
pci 0000:06:00.3: Dev MPS 128 MPSS 256 MRRS 256
pci 0000:06:00.3: Dev MPS 256 MPSS 256 MRRS 256
pci 0000:00:03.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:03.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:01:00.0: Dev MPS 256 MPSS 256 MRRS 512
pci 0000:01:00.0: Dev MPS 256 MPSS 256 MRRS 512
pci 0000:01:00.2: Dev MPS 256 MPSS 256 MRRS 512
pci 0000:01:00.2: Dev MPS 256 MPSS 256 MRRS 512
pci 0000:00:04.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:04.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:05.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:05.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:06.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:06.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:07.0: Dev MPS 128 MPSS 256 MRRS 128
pci 0000:00:07.0: Dev MPS 256 MPSS 256 MRRS 128
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:04:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci 0000:04:00.0: Dev MPS 128 MPSS 128 MRRS 128
pci_bus 0000:00: on NUMA node 0
...later on...
PCI: max bus depth: 4 pci_try_num: 5
Uhhuh. NMI received for unknown reason 31 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
pci 0000:08:00.0: PCI bridge to [bus 09-09]
pci 0000:08:00.0:   bridge window [mem 0xf4000000-0xf7ffffff]
pci 0000:07:00.0: PCI bridge to [bus 08-09]
pci 0000:07:00.0:   bridge window [mem 0xf4000000-0xf7ffffff]

...and the error still shows up in the IPMI SEL. 
If I also add "pci=pcie_bus_safe", I _still_ get the same output and bus
error. Maybe this is two issues?

# lspci
00:00.0 Host bridge: Intel Corporation 5000X Chipset Memory Controller Hub (rev 12)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 2 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 3 (rev 12)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 4-5 (rev 12)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 5 (rev 12)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 6-7 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 7 (rev 12)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev 12)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev 12)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev 12)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev 12)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev 12)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev 12)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev 12)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to-PCI Express Bridge
01:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to-PCI Express Bridge
02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5
04:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c2)
05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 11)
06:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01)
06:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01)
07:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01)
07:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E2 (rev 01)
08:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c2)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 11)
10:0d.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

# lspci -v -s 08:00.0
08:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c2) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=08, secondary=09, subordinate=09, sec-latency=64
        Memory behind bridge: f4000000-f7ffffff
        Capabilities: [60] Express PCI/PCI-X Bridge, MSI 00
        Capabilities: [90] PCI-X bridge device
        Capabilities: [b0] Power Management version 2

# lspci -v  -v -s 08:00.0
08:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c2) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=08, secondary=09, subordinate=09, sec-latency=64
        Memory behind bridge: f4000000-f7ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [60] Express (v1) PCI/PCI-X Bridge, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <16us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- BrConfRtry-
                        MaxPayload 256 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr+ UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
                Status: Dev=08:00.0 64bit- 133MHz- SCD- USC- SCO- SRD-
                Upstream: Capacity=0 CommitmentLimit=0
                Downstream: Capacity=0 CommitmentLimit=0
        Capabilities: [b0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Simon-
