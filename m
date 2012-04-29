Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2D2Qp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:45:28 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:49540 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2D2Qp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:45:26 -0400
From: Nix <nix@esperi.org.uk>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Chris Boot <bootc@bootc.net>, <e1000-devel@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <carolyn.wyborny@intel.com>
Subject: Re: [PATCH RFC 0/2] e1000e: 82574 also needs ASPM L1 completely disabled
References: <9BBC4E0CF881AA4299206E2E1412B6260E512E0C@ORSMSX102.amr.corp.intel.com>
	<1335216578-21542-1-git-send-email-bootc@bootc.net>
	<20120423161119.0000022f@unknown>
Emacs: the prosecution rests its case.
Date: Sun, 29 Apr 2012 17:45:10 +0100
In-Reply-To: <20120423161119.0000022f@unknown> (Jesse Brandeburg's message of
	"Mon, 23 Apr 2012 16:11:19 -0700")
Message-ID: <87y5pe1o89.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Apr 2012, Jesse Brandeburg outgrape:

> Please let us know the results of your testing, we will let you know if
> we see any issues as well.

Alas, it has no effect at all here; L0s and L1 claim to be being
disabled at boot time, but if you ask with lspci you see that they are
not. I strongly suspect that they *are* being disabled, but then get
re-enabled by something else, because even if I force them off with
setpci in the boot scripts, by the time the scripts have finished
executing and I've got to a root prompt where I can run setpci, L0s and
L1 are always back on again.

I may try simply running setpci between every line of my boot scripts
just to see if it's something I'm doing there, but I very much doubt it,
since I see these symptoms even if I run setpci at a point in the boot
scripts after all the network interface setup is over.

I suspect it's more to do with the link stabilizing or something. (But
this is purest guesswork.)

[    1.087592] e1000e 0000:03:00.0: Disabling ASPM L0s L1
[    1.211748] e1000e 0000:02:00.0: Disabling ASPM L0s L1

spindle# setpci -s 02:00.0 CAP_EXP+10.b
43
spindle# setpci -s 03:00.0 CAP_EXP+10.b
43

spindle:/etc/rc.d# lspci -vv -s 02:00.0
02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
        Subsystem: Intel Corporation Device 0000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at fbce0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at dc00 [size=32]
        Region 3: Memory at fbcdc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
                Vector table: BAR=3 offset=00000000
                PBA: BAR=3 offset=00002000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP+ BadDLLP+ Rollover- Timeout+ NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: e1000e

spindle:/etc/rc.d# lspci -vv -s 03:00.0
03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
        Subsystem: Intel Corporation Device 0000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fbde0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at ec00 [size=32]
        Region 3: Memory at fbddc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
                Vector table: BAR=3 offset=00000000
                PBA: BAR=3 offset=00002000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: e1000e

Note in particular that L0s and L1 are still listed as enabled.

(So I forced them off with setpci again, by hand.)

-- 
NULL && (void)
