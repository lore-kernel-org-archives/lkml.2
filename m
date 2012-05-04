Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805Ab2EDVV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:21:29 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:34997 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755132Ab2EDUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:43:53 -0400
Message-ID: <4FA43F83.8090706@fold.natur.cuni.cz>
Date: Fri, 04 May 2012 22:43:47 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
CC: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com> <4F8BEB1D.9080903@fold.natur.cuni.cz> <CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com> <4F8C6E4E.1000205@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com> <4FA3FC9B.9050600@fold.natur.cuni.cz>
In-Reply-To: <4FA3FC9B.9050600@fold.natur.cuni.cz>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------080703070708050409030101"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080703070708050409030101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Here I am showing that weird thing happen when ASPM is enabled. There I can much more differences
between the cards.

When DeLock card slips out during insert I get:

-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR+ <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-

When Evolve card with NEC slips out, I get same like when they were unplugged intentionally.

# diff -u -w 7_unplugged_DeLock.txt 8_Evolve_slipped_out.txt (or unplugged Evolve/Zalman)
--- 7_unplugged_DeLock.txt      2012-05-04 21:30:40.000000000 +0200
+++ 8_Evolve_slipped_out.txt    2012-05-04 21:31:36.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 04 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 40 00 11 50 60 b2 3c 00 28 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 
#
# diff -u -w 7_unplugged_DeLock.txt 10_unplugged_Evolve.txt 
--- 7_unplugged_DeLock.txt      2012-05-04 21:30:40.000000000 +0200
+++ 10_unplugged_Evolve.txt     2012-05-04 21:32:12.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 04 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 40 00 11 50 60 b2 3c 00 28 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 
#


The bad thing is that when the NEC-based card slips out or is removed, *when pcie_aspm is on*,
it always leaves the slot in PresDet+ (on the SltSta: line). On the "Changed:" line it stays
as PresDet- as always. This is the real issue?
Evolve and Zalman inserted or unplugged states are same. Also when cards slips out or is intentionally
removed results in same, bad state.


It seems to me another difference is that in unplugged state of eSATA and FireWire cards
leave the slot in either <MAbort+/- <SERR- and <SERR+ but those based on NEC alway leave <MAbort- <SERR-.

Finally, unplugging NEC-bnased cards does not clear DLActive+ to DLActive-.



# diff -u -w 2_card_slipped_out.txt 7_unplugged_DeLock.txt 
--- 2_card_slipped_out.txt      2012-05-04 21:25:41.000000000 +0200
+++ 7_unplugged_DeLock.txt      2012-05-04 21:30:40.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR+ <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -45,7 +45,7 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 04 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 60
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08

#


# diff -u -w 8_Evolve_slipped_out.txt 17_unplugged_Axago_firewire.txt 
--- 8_Evolve_slipped_out.txt    2012-05-04 21:31:36.000000000 +0200
+++ 17_unplugged_Axago_firewire.txt     2012-05-04 21:34:55.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -16,16 +16,16 @@
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
+               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 04 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 43 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 4c 12 08
+50: 00 00 11 50 60 b2 3c 00 28 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00


#



The FireWire card leaves ASPM disables like sata_sil24 is forcing over the eSATA card from DeLock.

Like with pcie_aspm=off, NEC fiddles with

-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+

while at least the eSATA card based on Sil3132 (sata_sil24) says:

[ 1417.874596] pci 0000:11:00.0: [1095:3132] type 00 class 0x018000
[ 1417.874864] pci 0000:11:00.0: supports D1 D2
[ 1417.874890] pci 0000:11:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'

So do those NEC cards ignore the pcie_aspm=off parameter?


Here is the full diff:

# diff -u -w 7_unplugged_DeLock.txt 10_unplugged_Evolve.txt 
--- 7_unplugged_DeLock.txt      2012-05-04 21:30:40.000000000 +0200
+++ 10_unplugged_Evolve.txt     2012-05-04 21:32:12.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 04 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 40 00 11 50 60 b2 3c 00 28 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 
#



Finally to say, when ASPM is not forbidden in kernel by pcie_aspm=off, there is not much difference
between inserted states. But, there is a difference in the unplugged slot state:

# diff -u -w 6_re-inserted-DeLock.txt 9_inserted-Evolve.txt 
--- 6_re-inserted-DeLock.txt    2012-05-04 21:30:27.000000000 +0200
+++ 9_inserted-Evolve.txt       2012-05-04 21:31:57.000000000 +0200
@@ -18,7 +18,7 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
@@ -49,7 +49,7 @@
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 40 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 
# diff -u -w 7_unplugged_DeLock.txt 10_unplugged_Evolve.txt 
--- 7_unplugged_DeLock.txt      2012-05-04 21:30:40.000000000 +0200
+++ 10_unplugged_Evolve.txt     2012-05-04 21:32:12.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -18,14 +18,14 @@
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 04 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
 40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 40 00 11 50 60 b2 3c 00 28 00 00 01 00 00 00 00
+50: 43 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 
#

# diff -u -w 10_unplugged_Evolve.txt 12_unplugged_Zalman.txt 
# diff -u -w 10_unplugged_Evolve.txt 15_unplugged_Axago_firewire.txt 
--- 10_unplugged_Evolve.txt     2012-05-04 21:32:12.000000000 +0200
+++ 15_unplugged_Axago_firewire.txt     2012-05-04 21:34:28.000000000 +0200
@@ -6,7 +6,7 @@
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f6c00000-f7cfffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f10fffff
-       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
+       Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
@@ -16,16 +16,16 @@
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
+               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #7, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
@@ -45,11 +45,11 @@
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport
 00: 86 80 1e 1c 07 04 10 00 b5 00 04 06 10 00 81 00
-10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
+10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 20
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 43 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 4c 12 08
+50: 00 00 11 50 60 b2 3c 00 28 00 00 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00

# diff -u -w 15_unplugged_Axago_firewire.txt 17_unplugged_Axago_firewire.txt 
#



The one below I cannot comment, I do not what is it about at all:

# diff -u -w 3_re-inserted-DeLock.txt 14_inserted_Axago_firewire.txt 
--- 3_re-inserted-DeLock.txt    2012-05-04 21:29:11.000000000 +0200
+++ 14_inserted_Axago_firewire.txt      2012-05-04 21:34:13.000000000 +0200
@@ -16,9 +16,9 @@
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
+               LnkCap: Port #8, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
                        ClockPM- Surprise- LLActRep+ BwNot-
-               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
+               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
@@ -48,8 +48,8 @@
 10: 00 00 00 00 00 00 00 00 00 11 16 00 c0 d0 00 00
 20: c0 f6 c0 f7 01 f0 01 f1 00 00 00 00 00 00 00 00
 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 04 10 00
-40: 10 80 42 01 00 80 00 00 00 00 11 00 12 3c 12 08
-50: 40 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
+40: 10 80 42 01 00 80 00 00 00 00 11 00 12 4c 12 08
+50: 00 00 11 70 60 b2 3c 00 28 00 40 01 00 00 00 00
 60: 00 00 00 00 16 00 00 00 00 00 00 00 00 00 00 00
 70: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 05 90 01 00 18 03 e0 fe 00 00 00 00 00 00 00 00
@@ -58,6 +58,6 @@
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 01 02 0b 00 00 02 80 11 c1 00 00 00 00
-e0: 00 03 00 00 00 00 00 00 01 00 00 00 00 00 00 00
+e0: 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 87 0f 06 08 00 00 00 00
 


All of the above was done with:

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

and with no extra disabling of ASPM on the kernel commandline (what was in previous email).


I think I did quite some testing. Would somebody please step in and say what is BIOS/hardware related
and what is a linux software issue?

Thanks,
Martin


--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="1_fresh_after_bootup.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="1_fresh_after_bootup.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8MXVzLCBMMSA8MTZ1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0g
TExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBMMSBFbmFibGVkOyBSQ0IgNjQgYnl0
ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgwLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01n
bXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0g
SG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50
ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1S
TC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3Rh
OglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQtIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUtCgkJUm9vdEN0
bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0g
Q1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBs
ZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2QtCgkJTG5r
Q3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3Bl
ZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJn
aW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0
YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29t
cGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxp
dGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlB
ZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5
c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAgYjUgMDAg
MDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDExIDE2
IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDEwIDAwIDEy
IDRjIDEyIDA4CjUwOiAwMiAwMCAwMSAxMCA2MCBiMiAzYyAwMCAyOCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
YTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApjMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZDA6IDAw
IDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUwOiAwMCAw
MyAwMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="2_card_slipped_out.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="2_card_slipped_out.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSKyA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0
ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQrIEFCV01n
bXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0g
SG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50
ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1S
TC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3Rh
OglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQtIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdEN0
bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0g
Q1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBs
ZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2QtCgkJTG5r
Q3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3Bl
ZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJn
aW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0
YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29t
cGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxp
dGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlB
ZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5
c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAgYjUgMDAg
MDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDExIDE2
IDAwIGMwIGQwIDAwIDYwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDExIDAwIDEy
IDNjIDEyIDA4CjUwOiA0MCAwMCAxMSA1MCA2MCBiMiAzYyAwMCAyOCAwMCAwMCAwMSAwMCAw
MCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
YTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApjMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZDA6IDAw
IDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUwOiAwMCAw
MyAwMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="3_re-inserted-DeLock.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="3_re-inserted-DeLock.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0
ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQrIEFCV01n
bXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0g
SG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50
ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1S
TC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3Rh
OglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdEN0
bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0g
Q1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBs
ZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2QtCgkJTG5r
Q3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3Bl
ZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJn
aW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0
YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29t
cGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxp
dGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlB
ZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5
c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAgYjUgMDAg
MDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDExIDE2
IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDExIDAwIDEy
IDNjIDEyIDA4CjUwOiA0MCAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAwMSAwMCAw
MCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
YTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApjMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZDA6IDAw
IDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUwOiAwMCAw
MyAwMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="4_unplugged_DeLock.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="4_unplugged_DeLock.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0
ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQrIEFCV01n
bXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0g
SG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50
ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1S
TC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3Rh
OglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQtIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdEN0
bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0g
Q1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBs
ZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2QtCgkJTG5r
Q3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3Bl
ZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJn
aW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0
YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29t
cGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxp
dGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlB
ZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5
c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAgYjUgMDAg
MDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDExIDE2
IDAwIGMwIGQwIDAwIDIwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDExIDAwIDEy
IDNjIDEyIDA4CjUwOiA0MCAwMCAxMSA1MCA2MCBiMiAzYyAwMCAyOCAwMCAwMCAwMSAwMCAw
MCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
YTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApjMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZDA6IDAw
IDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUwOiAwMCAw
MyAwMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="5_card_slipped_out.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="5_card_slipped_out.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0
ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQrIEFCV01n
bXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0g
SG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50
ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1S
TC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3Rh
OglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQtIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdEN0
bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0g
Q1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBs
ZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2QtCgkJTG5r
Q3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3Bl
ZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJn
aW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0
YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29t
cGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxp
dGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlB
ZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5
c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAgYjUgMDAg
MDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDExIDE2
IDAwIGMwIGQwIDAwIDIwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDExIDAwIDEy
IDNjIDEyIDA4CjUwOiA0MCAwMCAxMSA1MCA2MCBiMiAzYyAwMCAyOCAwMCAwMCAwMSAwMCAw
MCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
YTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApjMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZDA6IDAw
IDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUwOiAwMCAw
MyAwMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="6_re-inserted-DeLock.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="6_re-inserted-DeLock.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0
ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQrIEFCV01n
bXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0g
SG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50
ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1S
TC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3Rh
OglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdEN0
bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0g
Q1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBs
ZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2QtCgkJTG5r
Q3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3Bl
ZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJn
aW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0
YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29t
cGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxp
dGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlB
ZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5
c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAgYjUgMDAg
MDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDExIDE2
IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDExIDAwIDEy
IDNjIDEyIDA4CjUwOiA0MCAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAwMSAwMCAw
MCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
YTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApjMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZDA6IDAw
IDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUwOiAwMCAw
MyAwMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="7_unplugged_DeLock.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="7_unplugged_DeLock.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0
ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQrIEFCV01n
bXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0g
SG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50
ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1S
TC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5J
bmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3Rh
OglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQtIElu
dGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdEN0
bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUludEVuYS0g
Q1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJ
RCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBU
aW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6IENvbXBs
ZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2QtCgkJTG5r
Q3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5jZS0gU3Bl
ZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21pdCBNYXJn
aW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBD
b21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0
YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29t
cGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBF
cXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxp
dGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlB
ZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5
c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFn
ZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJl
bnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5lbCBkcml2
ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAgYjUgMDAg
MDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDExIDE2
IDAwIGMwIGQwIDAwIDIwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDExIDAwIDEy
IDNjIDEyIDA4CjUwOiA0MCAwMCAxMSA1MCA2MCBiMiAzYyAwMCAyOCAwMCAwMCAwMSAwMCAw
MCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
YTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApjMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZDA6IDAw
IDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUwOiAwMCAw
MyAwMCAwMCAwMCAwMCAwMCAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="8_Evolve_slipped_out.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="8_Evolve_slipped_out.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwwcyBMMSBFbmFibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9j
a1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQr
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3
ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JG
bHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNE
ZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBN
RSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6
IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2Qt
CgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5j
ZS0gU3BlZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21p
dCBNYXJnaW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlh
bmNlLSBDb21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJ
CUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0
aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFz
ZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNh
cGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBd
IFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6
IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAg
YjUgMDAgMDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDExIDE2IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDEx
IDAwIDEyIDNjIDEyIDA4CjUwOiA0MyAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAw
MSAwMCAwMCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKYTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCmIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MApjMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
ZDA6IDAwIDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUw
OiAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="9_inserted-Evolve.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="9_inserted-Evolve.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwwcyBMMSBFbmFibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9j
a1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQr
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3
ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JG
bHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNE
ZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBN
RSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6
IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2Qt
CgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5j
ZS0gU3BlZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21p
dCBNYXJnaW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlh
bmNlLSBDb21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJ
CUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0
aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFz
ZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNh
cGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBd
IFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6
IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAg
YjUgMDAgMDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDExIDE2IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDEx
IDAwIDEyIDNjIDEyIDA4CjUwOiA0MyAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAw
MSAwMCAwMCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKYTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCmIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MApjMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
ZDA6IDAwIDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUw
OiAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="10_unplugged_Evolve.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="10_unplugged_Evolve.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwwcyBMMSBFbmFibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9j
a1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQr
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3
ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JG
bHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNE
ZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBN
RSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6
IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2Qt
CgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5j
ZS0gU3BlZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21p
dCBNYXJnaW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlh
bmNlLSBDb21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJ
CUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0
aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFz
ZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNh
cGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBd
IFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6
IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAg
YjUgMDAgMDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDExIDE2IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDEx
IDAwIDEyIDNjIDEyIDA4CjUwOiA0MyAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAw
MSAwMCAwMCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKYTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCmIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MApjMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
ZDA6IDAwIDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUw
OiAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="11_inserted_Zalman.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="11_inserted_Zalman.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwwcyBMMSBFbmFibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9j
a1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQr
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3
ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JG
bHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNE
ZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBN
RSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6
IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2Qt
CgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5j
ZS0gU3BlZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21p
dCBNYXJnaW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlh
bmNlLSBDb21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJ
CUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0
aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFz
ZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNh
cGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBd
IFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6
IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAg
YjUgMDAgMDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDExIDE2IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDEx
IDAwIDEyIDNjIDEyIDA4CjUwOiA0MyAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAw
MSAwMCAwMCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKYTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCmIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MApjMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
ZDA6IDAwIDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUw
OiAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="12_unplugged_Zalman.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="12_unplugged_Zalman.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwwcyBMMSBFbmFibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9j
a1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQr
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3
ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JG
bHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNE
ZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBN
RSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6
IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2Qt
CgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5j
ZS0gU3BlZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21p
dCBNYXJnaW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlh
bmNlLSBDb21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJ
CUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0
aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFz
ZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNh
cGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBd
IFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6
IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAg
YjUgMDAgMDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDExIDE2IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDEx
IDAwIDEyIDNjIDEyIDA4CjUwOiA0MyAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAw
MSAwMCAwMCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKYTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCmIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MApjMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
ZDA6IDAwIDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUw
OiAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="13_inserted_Zalman.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="13_inserted_Zalman.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNl
LSBMTEFjdFJlcCsgQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwwcyBMMSBFbmFibGVkOyBSQ0Ig
NjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9j
a1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdU
L3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQr
IEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3
ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzcsIFBvd2VyTGltaXQgMTAuMDAw
VzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JG
bHQtIE1STC0gUHJlc0RldCsgQ21kQ3BsdC0gSFBJcnErIExpbmtDaGctCgkJCUNvbnRyb2w6
IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJ
U2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNE
ZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJ
Um9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwtIFBNRUlu
dEVuYS0gQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBN
RSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBCQywgVGltZW91dERpcysgQVJJRndkLQoJCURldkN0bDI6
IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlzLSBBUklGd2Qt
CgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVyQ29tcGxpYW5j
ZS0gU3BlZWREaXMtLCBTZWxlY3RhYmxlIERlLWVtcGhhc2lzOiAtNmRCCgkJCSBUcmFuc21p
dCBNYXJnaW46IE5vcm1hbCBPcGVyYXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlh
bmNlLSBDb21wbGlhbmNlU09TLQoJCQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJ
CUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0
aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFz
ZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNh
cGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMDMxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbOTBd
IFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDRiMwoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6
IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAowMDogODYgODAgMWUgMWMgMDcgMDQgMTAgMDAg
YjUgMDAgMDQgMDYgMTAgMDAgODEgMDAKMTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDExIDE2IDAwIGMwIGQwIDAwIDAwCjIwOiBjMCBmNiBjMCBmNyAwMSBmMCAwMSBmMSAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAozMDogMDAgMDAgMDAgMDAgNDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMGEgMDQgMTAgMDAKNDA6IDEwIDgwIDQyIDAxIDAwIDgwIDAwIDAwIDAwIDAwIDEx
IDAwIDEyIDNjIDEyIDA4CjUwOiA0MyAwMCAxMSA3MCA2MCBiMiAzYyAwMCAyOCAwMCA0MCAw
MSAwMCAwMCAwMCAwMAo2MDogMDAgMDAgMDAgMDAgMTYgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKNzA6IDAxIDAwIDAxIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCjgwOiAwNSA5MCAwMSAwMCAxOCAwMyBlMCBmZSAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo5MDogMGQgYTAgMDAgMDAgMjggMTAgYjMgMDQgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKYTA6IDAxIDAwIDAyIGM4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCmIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MApjMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
ZDA6IDAwIDAwIDAwIDAxIDAyIDBiIDAwIDAwIDAyIDgwIDExIGMxIDAwIDAwIDAwIDAwCmUw
OiAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMyAwMCAwMCAwMCAwMCAwMCAwMCAwMApmMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgODcgMGYgMDYgMDggMDAgMDAgMDAgMDAKCg==
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="14_inserted_Axago_firewire.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="14_inserted_Axago_firewire.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8MXVzLCBMMSA8MTZ1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0g
TExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVz
IERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0
V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0
aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZSsgQldNZ210KyBBQldNZ210
LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhv
dFBsdWcrIFN1cnByaXNlKwoJCQlTbG90ICM3LCBQb3dlckxpbWl0IDEwLjAwMFc7IEludGVy
bG9jay0gTm9Db21wbCsKCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwt
IFByZXNEZXQrIENtZENwbHQtIEhQSXJxKyBMaW5rQ2hnLQoJCQlDb250cm9sOiBBdHRuSW5k
IFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNsdFN0YToJ
U3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0KyBJbnRl
cmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRlKwoJCVJvb3RDdGw6
IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEtIENS
U1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQTUUgUmVxSUQg
MDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJCURldkNhcDI6IENvbXBsZXRpb24gVGlt
ZW91dDogUmFuZ2UgQkMsIFRpbWVvdXREaXMrIEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21wbGV0
aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0gQVJJRndkLQoJCUxua0N0
bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAyLjVHVC9zLCBFbnRlckNvbXBsaWFuY2UtIFNwZWVk
RGlzLSwgU2VsZWN0YWJsZSBEZS1lbXBoYXNpczogLTZkQgoJCQkgVHJhbnNtaXQgTWFyZ2lu
OiBOb3JtYWwgT3BlcmF0aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29t
cGxpYW5jZVNPUy0KCQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtTdGEy
OiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtMy41ZEIsIEVxdWFsaXphdGlvbkNvbXBs
ZXRlLSwgRXF1YWxpemF0aW9uUGhhc2UxLQoJCQkgRXF1YWxpemF0aW9uUGhhc2UyLSwgRXF1
YWxpemF0aW9uUGhhc2UzLSwgTGlua0VxdWFsaXphdGlvblJlcXVlc3QtCglDYXBhYmlsaXRp
ZXM6IFs4MF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRk
cmVzczogZmVlMDAzMTggIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0
ZW06IERlbGwgRGV2aWNlIDA0YjMKCUNhcGFiaWxpdGllczogW2EwXSBQb3dlciBNYW5hZ2Vt
ZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50
PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1Nv
ZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJpdmVy
IGluIHVzZTogcGNpZXBvcnQKMDA6IDg2IDgwIDFlIDFjIDA3IDA0IDEwIDAwIGI1IDAwIDA0
IDA2IDEwIDAwIDgxIDAwCjEwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAxMSAxNiAw
MCBjMCBkMCAwMCAwMAoyMDogYzAgZjYgYzAgZjcgMDEgZjAgMDEgZjEgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKMzA6IDAwIDAwIDAwIDAwIDQwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDBh
IDA0IDEwIDAwCjQwOiAxMCA4MCA0MiAwMSAwMCA4MCAwMCAwMCAwMCAwMCAxMSAwMCAxMiA0
YyAxMiAwOAo1MDogMDAgMDAgMTEgNzAgNjAgYjIgM2MgMDAgMjggMDAgNDAgMDEgMDAgMDAg
MDAgMDAKNjA6IDAwIDAwIDAwIDAwIDE2IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjcwOiAwMSAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo4MDogMDUgOTAgMDEgMDAgMTggMDMgZTAgZmUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
OTA6IDBkIGEwIDAwIDAwIDI4IDEwIGIzIDA0IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmEw
OiAwMSAwMCAwMiBjOCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApiMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKYzA6IDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmQwOiAwMCAw
MCAwMCAwMSAwMiAwYiAwMCAwMCAwMiA4MCAxMSBjMSAwMCAwMCAwMCAwMAplMDogMDAgMDMg
MDAgMDAgMDAgMDAgMDAgMDAgMDMgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZjA6IDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDg3IDBmIDA2IDA4IDAwIDAwIDAwIDAwCgo=
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="15_unplugged_Axago_firewire.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="15_unplugged_Axago_firewire.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8MXVzLCBMMSA8MTZ1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0g
TExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVz
IERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0
V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0
aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldNZ210KyBBQldNZ210
LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhv
dFBsdWcrIFN1cnByaXNlKwoJCQlTbG90ICM3LCBQb3dlckxpbWl0IDEwLjAwMFc7IEludGVy
bG9jay0gTm9Db21wbCsKCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwt
IFByZXNEZXQrIENtZENwbHQtIEhQSXJxKyBMaW5rQ2hnLQoJCQlDb250cm9sOiBBdHRuSW5k
IFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNsdFN0YToJ
U3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0LSBJbnRl
cmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRlKwoJCVJvb3RDdGw6
IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEtIENS
U1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQTUUgUmVxSUQg
MDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJCURldkNhcDI6IENvbXBsZXRpb24gVGlt
ZW91dDogUmFuZ2UgQkMsIFRpbWVvdXREaXMrIEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21wbGV0
aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0gQVJJRndkLQoJCUxua0N0
bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAyLjVHVC9zLCBFbnRlckNvbXBsaWFuY2UtIFNwZWVk
RGlzLSwgU2VsZWN0YWJsZSBEZS1lbXBoYXNpczogLTZkQgoJCQkgVHJhbnNtaXQgTWFyZ2lu
OiBOb3JtYWwgT3BlcmF0aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29t
cGxpYW5jZVNPUy0KCQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtTdGEy
OiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtMy41ZEIsIEVxdWFsaXphdGlvbkNvbXBs
ZXRlLSwgRXF1YWxpemF0aW9uUGhhc2UxLQoJCQkgRXF1YWxpemF0aW9uUGhhc2UyLSwgRXF1
YWxpemF0aW9uUGhhc2UzLSwgTGlua0VxdWFsaXphdGlvblJlcXVlc3QtCglDYXBhYmlsaXRp
ZXM6IFs4MF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRk
cmVzczogZmVlMDAzMTggIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0
ZW06IERlbGwgRGV2aWNlIDA0YjMKCUNhcGFiaWxpdGllczogW2EwXSBQb3dlciBNYW5hZ2Vt
ZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50
PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1Nv
ZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJpdmVy
IGluIHVzZTogcGNpZXBvcnQKMDA6IDg2IDgwIDFlIDFjIDA3IDA0IDEwIDAwIGI1IDAwIDA0
IDA2IDEwIDAwIDgxIDAwCjEwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAxMSAxNiAw
MCBjMCBkMCAwMCAyMAoyMDogYzAgZjYgYzAgZjcgMDEgZjAgMDEgZjEgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKMzA6IDAwIDAwIDAwIDAwIDQwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDBh
IDA0IDEwIDAwCjQwOiAxMCA4MCA0MiAwMSAwMCA4MCAwMCAwMCAwMCAwMCAxMSAwMCAxMiA0
YyAxMiAwOAo1MDogMDAgMDAgMTEgNTAgNjAgYjIgM2MgMDAgMjggMDAgMDAgMDEgMDAgMDAg
MDAgMDAKNjA6IDAwIDAwIDAwIDAwIDE2IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjcwOiAwMSAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo4MDogMDUgOTAgMDEgMDAgMTggMDMgZTAgZmUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
OTA6IDBkIGEwIDAwIDAwIDI4IDEwIGIzIDA0IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmEw
OiAwMSAwMCAwMiBjOCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApiMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKYzA6IDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmQwOiAwMCAw
MCAwMCAwMSAwMiAwYiAwMCAwMCAwMiA4MCAxMSBjMSAwMCAwMCAwMCAwMAplMDogMDAgMDMg
MDAgMDAgMDAgMDAgMDAgMDAgMDMgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZjA6IDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDg3IDBmIDA2IDA4IDAwIDAwIDAwIDAwCgo=
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="16_reinserted_Axago_firewire.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="16_reinserted_Axago_firewire.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8MXVzLCBMMSA8MTZ1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0g
TExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVz
IERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0
V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0
aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZSsgQldNZ210KyBBQldNZ210
LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhv
dFBsdWcrIFN1cnByaXNlKwoJCQlTbG90ICM3LCBQb3dlckxpbWl0IDEwLjAwMFc7IEludGVy
bG9jay0gTm9Db21wbCsKCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwt
IFByZXNEZXQrIENtZENwbHQtIEhQSXJxKyBMaW5rQ2hnLQoJCQlDb250cm9sOiBBdHRuSW5k
IFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNsdFN0YToJ
U3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0KyBJbnRl
cmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRlKwoJCVJvb3RDdGw6
IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEtIENS
U1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQTUUgUmVxSUQg
MDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJCURldkNhcDI6IENvbXBsZXRpb24gVGlt
ZW91dDogUmFuZ2UgQkMsIFRpbWVvdXREaXMrIEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21wbGV0
aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0gQVJJRndkLQoJCUxua0N0
bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAyLjVHVC9zLCBFbnRlckNvbXBsaWFuY2UtIFNwZWVk
RGlzLSwgU2VsZWN0YWJsZSBEZS1lbXBoYXNpczogLTZkQgoJCQkgVHJhbnNtaXQgTWFyZ2lu
OiBOb3JtYWwgT3BlcmF0aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29t
cGxpYW5jZVNPUy0KCQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtTdGEy
OiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtMy41ZEIsIEVxdWFsaXphdGlvbkNvbXBs
ZXRlLSwgRXF1YWxpemF0aW9uUGhhc2UxLQoJCQkgRXF1YWxpemF0aW9uUGhhc2UyLSwgRXF1
YWxpemF0aW9uUGhhc2UzLSwgTGlua0VxdWFsaXphdGlvblJlcXVlc3QtCglDYXBhYmlsaXRp
ZXM6IFs4MF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRk
cmVzczogZmVlMDAzMTggIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0
ZW06IERlbGwgRGV2aWNlIDA0YjMKCUNhcGFiaWxpdGllczogW2EwXSBQb3dlciBNYW5hZ2Vt
ZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50
PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1Nv
ZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJpdmVy
IGluIHVzZTogcGNpZXBvcnQKMDA6IDg2IDgwIDFlIDFjIDA3IDA0IDEwIDAwIGI1IDAwIDA0
IDA2IDEwIDAwIDgxIDAwCjEwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAxMSAxNiAw
MCBjMCBkMCAwMCAwMAoyMDogYzAgZjYgYzAgZjcgMDEgZjAgMDEgZjEgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKMzA6IDAwIDAwIDAwIDAwIDQwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDBh
IDA0IDEwIDAwCjQwOiAxMCA4MCA0MiAwMSAwMCA4MCAwMCAwMCAwMCAwMCAxMSAwMCAxMiA0
YyAxMiAwOAo1MDogMDAgMDAgMTEgNzAgNjAgYjIgM2MgMDAgMjggMDAgNDAgMDEgMDAgMDAg
MDAgMDAKNjA6IDAwIDAwIDAwIDAwIDE2IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjcwOiAwMSAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo4MDogMDUgOTAgMDEgMDAgMTggMDMgZTAgZmUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
OTA6IDBkIGEwIDAwIDAwIDI4IDEwIGIzIDA0IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmEw
OiAwMSAwMCAwMiBjOCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApiMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKYzA6IDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmQwOiAwMCAw
MCAwMCAwMSAwMiAwYiAwMCAwMCAwMiA4MCAxMSBjMSAwMCAwMCAwMCAwMAplMDogMDAgMDMg
MDAgMDAgMDAgMDAgMDAgMDAgMDMgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZjA6IDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDg3IDBmIDA2IDA4IDAwIDAwIDAwIDAwCgo=
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="17_unplugged_Axago_firewire.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="17_unplugged_Axago_firewire.txt"

MDA6MWMuNyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA2IFNlcmllcy9DMjAwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgOCAocmV2IGI1KSAo
cHJvZy1pZiAwMCBbTm9ybWFsIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRl
cwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MTEsIHN1Ym9yZGluYXRlPTE2LCBzZWMt
bGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGMwMDAtMDAwMGRmZmYKCU1lbW9y
eSBiZWhpbmQgYnJpZGdlOiBmNmMwMDAwMC1mN2NmZmZmZgoJUHJlZmV0Y2hhYmxlIG1lbW9y
eSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwMDAwMDAwLTAwMDAwMDAwZjEwZmZmZmYKCVNl
Y29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5U
QWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0bDogUGFy
aXR5LSBTRVJSLSBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQcmlE
aXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJ
CURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEww
cyA8NjRucywgTDEgPDF1cwoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRl
ZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglD
b3JyRXJyKyBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQ
ZW5kLQoJCUxua0NhcDoJUG9ydCAjOCwgU3BlZWQgNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8MXVzLCBMMSA8MTZ1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0g
TExBY3RSZXArIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVz
IERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xrLQoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0
V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0
aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldNZ210KyBBQldNZ210
LQoJCVNsdENhcDoJQXR0bkJ0bi0gUHdyQ3RybC0gTVJMLSBBdHRuSW5kLSBQd3JJbmQtIEhv
dFBsdWcrIFN1cnByaXNlKwoJCQlTbG90ICM3LCBQb3dlckxpbWl0IDEwLjAwMFc7IEludGVy
bG9jay0gTm9Db21wbCsKCQlTbHRDdGw6CUVuYWJsZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwt
IFByZXNEZXQrIENtZENwbHQtIEhQSXJxKyBMaW5rQ2hnLQoJCQlDb250cm9sOiBBdHRuSW5k
IFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2NrLQoJCVNsdFN0YToJ
U3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVzRGV0LSBJbnRl
cmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRlKwoJCVJvb3RDdGw6
IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEtIENS
U1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQTUUgUmVxSUQg
MDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJCURldkNhcDI6IENvbXBsZXRpb24gVGlt
ZW91dDogUmFuZ2UgQkMsIFRpbWVvdXREaXMrIEFSSUZ3ZC0KCQlEZXZDdGwyOiBDb21wbGV0
aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0gQVJJRndkLQoJCUxua0N0
bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAyLjVHVC9zLCBFbnRlckNvbXBsaWFuY2UtIFNwZWVk
RGlzLSwgU2VsZWN0YWJsZSBEZS1lbXBoYXNpczogLTZkQgoJCQkgVHJhbnNtaXQgTWFyZ2lu
OiBOb3JtYWwgT3BlcmF0aW5nIFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29t
cGxpYW5jZVNPUy0KCQkJIENvbXBsaWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtTdGEy
OiBDdXJyZW50IERlLWVtcGhhc2lzIExldmVsOiAtMy41ZEIsIEVxdWFsaXphdGlvbkNvbXBs
ZXRlLSwgRXF1YWxpemF0aW9uUGhhc2UxLQoJCQkgRXF1YWxpemF0aW9uUGhhc2UyLSwgRXF1
YWxpemF0aW9uUGhhc2UzLSwgTGlua0VxdWFsaXphdGlvblJlcXVlc3QtCglDYXBhYmlsaXRp
ZXM6IFs4MF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRk
cmVzczogZmVlMDAzMTggIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0
ZW06IERlbGwgRGV2aWNlIDA0YjMKCUNhcGFiaWxpdGllczogW2EwXSBQb3dlciBNYW5hZ2Vt
ZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50
PTBtQSBQTUUoRDArLEQxLSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1Nv
ZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJpdmVy
IGluIHVzZTogcGNpZXBvcnQKMDA6IDg2IDgwIDFlIDFjIDA3IDA0IDEwIDAwIGI1IDAwIDA0
IDA2IDEwIDAwIDgxIDAwCjEwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAxMSAxNiAw
MCBjMCBkMCAwMCAyMAoyMDogYzAgZjYgYzAgZjcgMDEgZjAgMDEgZjEgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKMzA6IDAwIDAwIDAwIDAwIDQwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDBh
IDA0IDEwIDAwCjQwOiAxMCA4MCA0MiAwMSAwMCA4MCAwMCAwMCAwMCAwMCAxMSAwMCAxMiA0
YyAxMiAwOAo1MDogMDAgMDAgMTEgNTAgNjAgYjIgM2MgMDAgMjggMDAgMDAgMDEgMDAgMDAg
MDAgMDAKNjA6IDAwIDAwIDAwIDAwIDE2IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwCjcwOiAwMSAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo4MDogMDUgOTAgMDEgMDAgMTggMDMgZTAgZmUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAK
OTA6IDBkIGEwIDAwIDAwIDI4IDEwIGIzIDA0IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmEw
OiAwMSAwMCAwMiBjOCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApiMDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKYzA6IDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmQwOiAwMCAw
MCAwMCAwMSAwMiAwYiAwMCAwMCAwMiA4MCAxMSBjMSAwMCAwMCAwMCAwMAplMDogMDAgMDMg
MDAgMDAgMDAgMDAgMDAgMDAgMDMgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZjA6IDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDg3IDBmIDA2IDA4IDAwIDAwIDAwIDAwCgo=
--------------080703070708050409030101
Content-Type: text/plain; charset=us-ascii;
 name="README.TXT"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="README.TXT"

IyBsc3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+IDFfZnJlc2hfYWZ0ZXJfYm9vdHVwLnR4dAog
IyBpbnNlcnRpbmcgRGVMb2NrIGNhcmQKIyBsc3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+IDJf
Y2FyZF9zbGlwcGVkX291dC50eHQKIyAjIHJlLWluc2VydGluZyB0aGUgY2FyZAojIGxzcGNp
IC12dnh4eCAtcyAwMDoxYy43ID4gM19yZS1pbnNlcnRlZC1EZUxvY2sudHh0CiMgIyB1bnBs
dWdnaWJnCiMgbHNwY2kgLXZ2eHh4IC1zIDAwOjFjLjcgPiA0X3VucGx1Z2dlZF9EZUxvY2su
dHh0CiMgIyByZS1pbnNlcnRpbmcgdGhlIGNhcmQKIyAjIHNsaXBwZWQgb3V0CiMgbHNwY2kg
LXZ2eHh4IC1zIDAwOjFjLjcgPiA1X2NhcmRfc2xpcHBlZF9vdXQudHh0CiMgIyByZS1pbnNl
cnRpbmcKIyBsc3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+IDZfcmUtaW5zZXJ0ZWQtRGVMb2Nr
LnR4dAojICMgcmVtb3ZpbmcKIyBsc3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+IDdfdW5wbHVn
Z2VkX0RlTG9jay50eHQKIyAjIGluc2VydGluZyBFdm9sdmUKIyBsc3BjaSAtdnZ4eHggLXMg
MDA6MWMuNyA+IDhfRXZvbHZlX3NsaXBwZWRfb3V0LnR4dAojICMgcmUtaW5zZXJ0aW5nCiMg
bHNwY2kgLXZ2eHh4IC1zIDAwOjFjLjcgPiA5X2luc2VydGVkLUV2b2x2ZS50eHQKIyAjIHVu
cGx1Z2dpbmcKIyBsc3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+IDEwX3VucGx1Z2dlZF9Fdm9s
dmUudHh0CiMgIyBpbnNlcnRlZCBaYWxtYW4KIyBsc3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+
IDExX2luc2VydGVkX1phbG1hbi50eHQKIyAjIHJlbW92aW5nCiMgbHNwY2kgLXZ2eHh4IC1z
IDAwOjFjLjcgPiAxMl91bnBsdWdnZWRfWmFsbWFuLnR4dAojICMgcmVpbnNlcnRpbmcKIyBs
c3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+IDEzX2luc2VydGVkX1phbG1hbi50eHQKIyAjIHVu
cGx1Z2dpbmcKIyAjIGluc2VydGluZyBmaXJld2lyZQojIGxzcGNpIC12dnh4eCAtcyAwMDox
Yy43ID4gMTRfaW5zZXJ0ZWRfQXhhZ29fZmlyZXdpcmUudHh0CiMgIyB1bnBsdWdnaW5nCiMg
bHNwY2kgLXZ2eHh4IC1zIDAwOjFjLjcgPiAxNV91bnBsdWdnZWRfQXhhZ29fZmlyZXdpcmUu
dHh0CiMgIyByZS1pbnNlcnRpbmcKIyBsc3BjaSAtdnZ4eHggLXMgMDA6MWMuNyA+IDE2X3Jl
aW5zZXJ0ZWRfQXhhZ29fZmlyZXdpcmUudHh0CiMgIyB1bnBsdWdnaW5uZwojIGxzcGNpIC12
dnh4eCAtcyAwMDoxYy43ID4gMTdfdW5wbHVnZ2VkX0F4YWdvX2ZpcmV3aXJlLnR4dAo=
--------------080703070708050409030101--
