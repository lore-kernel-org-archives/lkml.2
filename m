Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2DCSDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:03:36 -0400
Received: from serv04.lahn.de ([213.239.197.57]:56534 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab2DCSDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:03:34 -0400
Date: Tue, 3 Apr 2012 20:03:06 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: Kelly Anderson <kelly@silka.with-linux.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
Message-ID: <20120403200306.0afbb48b@xenia.leun.net>
In-Reply-To: <4F7AB6FE.3080009@silka.with-linux.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2012 02:38:22 -0600
Kelly Anderson <kelly@silka.with-linux.com> wrote:
[...]

I've trouble with db6a6a78d8602964c9dfb1d8ce18daefd92da0a7 /
c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to full-sleep
on PS idle also.

On my machine the card is detected as usual, connecting to an ap with
wpa2 the first time after driver was loaded does work, but after an
ifconfig wlan0 down / ifconfig wlan0 up it is not able to reconnect again:

Apr  3 19:34:35 jill kernel: [  986.012989] wlan0: authenticate with xx:xx:xx:xx:xx:xx (try 1)
Apr  3 19:34:35 jill kernel: [  986.213059] wlan0: authenticate with xx:xx:xx:xx:xx:xx (try 2)
Apr  3 19:34:35 jill kernel: [  986.413151] wlan0: authenticate with xx:xx:xx:xx:xx:xx (try 3)
Apr  3 19:34:35 jill kernel: [  986.613135] wlan0: authentication with xx:xx:xx:xx:xx:xx timed out
Apr  3 19:34:43 jill kernel: [  994.188209] wlan0: authenticate with xx:xx:xx:xx:xx:xx (try 1)
Apr  3 19:34:43 jill kernel: [  994.388148] wlan0: authenticate with xx:xx:xx:xx:xx:xx (try 2)
Apr  3 19:34:43 jill kernel: [  994.588132] wlan0: authenticate with xx:xx:xx:xx:xx:xx (try 3)
Apr  3 19:34:43 jill kernel: [  994.788044] wlan0: authentication with xx:xx:xx:xx:xx:xx timed out
[...]

rmmod ath9k
modprobe ath9k

Fixes that, after reloading the module it connects (once) again.

modprobe -v ath9k debug=0xe01 does not yield more information than above.

jill:/home/ml # lspci -vvvvvvxxx
[...]
02:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
        Subsystem: Hewlett-Packard Company Device 3042
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at d2500000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L1, Latency L0 <512ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] MSI-X: Enable- Count=1 Masked-
                Vector table: BAR=0 offset=00000000
                PBA: BAR=0 offset=00000000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: ath9k
00: 8c 16 2a 00 07 00 10 00 01 00 80 02 10 00 00 00
10: 04 00 50 d2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 42 30
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 01 50 c2 5b 00 00 00 00 00 00 00 00 00 00 00 00
50: 05 60 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 90 11 00 c0 0c 04 05 10 20 0a 00 11 38 03 00
70: 48 00 11 10 00 00 00 00 c0 03 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


After reverting db6a6a78d8602964c9dfb1d8ce18daefd92da0a7 in 3.3.1 it
works again as expected.


-- 
MfG,

Michael Leun

