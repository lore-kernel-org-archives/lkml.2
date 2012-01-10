Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab2AJSOn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 10 Jan 2012 13:14:43 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:38327 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab2AJSOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:14:40 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Tue, 10 Jan 2012 22:14:37 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.178.216.22
Message-ID: <NEXT-4f0c800d645e48.34497251@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >> So, I am building 3.2 with two patches: over/under-flow catcher (pity
 > >that
 >>> it seems to be on a multiple-times-per-second codepath and just leaving
 > >the
 >> > checks there for everyone is suboptimal) and allegedely proper fix.
 >Both
 > > > applied OK with a small offset.
 > > 
 > > as per our assumption, we should not see those over/underflow errors,
 > > with the patch
 > > above mentioned. please let us know if you hit upon this warnings,
 > > even after the proper fix.
 > 
 > 2 hours in. It looks like 10%-20% throughput loss (both up and down with 
 >similar ratio) relative to "remove suspicious code" build. It may be some 
 >other change, of course (slightly moving the notebook, removing USB device
 >
 > charging from the notebook or something like that)

Seems to be AP-dependent. 

I spent entire day on one AP with no problems, went across the building, 
roamed (went offline, found new AP) succesfully, and then ten minutes later:
(logs saved)

Jan 10 10:35:57 401a0bf1 kernel: [ 7681.407314] wlan0: deauthenticating from 
00:19:5b:be:3c:a7 by local choice (reason=3)
Jan 10 10:35:57 401a0bf1 kernel: [ 7681.427485] cfg80211: Calling CRDA to 
update world regulatory domain
Jan 10 10:35:57 401a0bf1 kernel: [ 7681.694908] ADDRCONF(NETDEV_UP): wlan0: 
link is not ready
Jan 10 10:35:58 401a0bf1 kernel: [ 7682.545018] wlan0: authenticate with 
00:19:5b:be:3c:a7 (try 1)
Jan 10 10:35:58 401a0bf1 kernel: [ 7682.546922] wlan0: authenticated
Jan 10 10:35:58 401a0bf1 kernel: [ 7682.546954] wlan0: associate with 
00:19:5b:be:3c:a7 (try 1)
Jan 10 10:35:58 401a0bf1 kernel: [ 7682.549414] wlan0: RX AssocResp from 
00:19:5b:be:3c:a7 (capab=0x431 status=0 aid=1)
Jan 10 10:35:58 401a0bf1 kernel: [ 7682.549421] wlan0: associated
Jan 10 10:35:58 401a0bf1 kernel: [ 7682.549900] ADDRCONF(NETDEV_CHANGE): 
wlan0: link becomes ready
Jan 10 10:36:09 401a0bf1 kernel: [ 7693.095841] wlan0: no IPv6 routers 
present
Jan 10 21:01:14 401a0bf1 kernel: [45162.286679] cfg80211: Calling CRDA to 
update world regulatory domain
Jan 10 21:01:14 401a0bf1 kernel: [45163.155037] wlan0: authenticate with 
00:24:8c:81:e1:76 (try 1)
Jan 10 21:01:14 401a0bf1 kernel: [45163.157132] wlan0: authenticated
Jan 10 21:01:14 401a0bf1 kernel: [45163.157159] wlan0: associate with 
00:24:8c:81:e1:76 (try 1)
Jan 10 21:01:14 401a0bf1 kernel: [45163.159708] wlan0: RX AssocResp from 
00:24:8c:81:e1:76 (capab=0x411 status=0 aid=2)
Jan 10 21:01:14 401a0bf1 kernel: [45163.159713] wlan0: associated
Jan 10 21:34:32 401a0bf1 kernel: [47159.166426] ath: Failed to wakeup in 
500us
Jan 10 21:34:34 401a0bf1 kernel: [47160.506049] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan 10 21:34:34 401a0bf1 kernel: [47160.518977] ath: DMA failed to stop in 
10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan 10 21:34:34 401a0bf1 kernel: [47160.518982] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan 10 21:34:34 401a0bf1 kernel: [47160.635143] ath: Chip reset failed
Jan 10 21:34:34 401a0bf1 kernel: [47160.635146] ath: Unable to reset 
channel, reset status -22
Jan 10 21:34:34 401a0bf1 kernel: [47161.226194] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan 10 21:34:34 401a0bf1 kernel: [47161.239098] ath: DMA failed to stop in 
10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan 10 21:34:34 401a0bf1 kernel: [47161.239103] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up


Jan 10 21:42:53 401a0bf1 kernel: [47659.159537] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan 10 21:42:53 401a0bf1 kernel: [47659.172508] ath: DMA failed to stop in 
10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan 10 21:42:53 401a0bf1 kernel: [47659.172510] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan 10 21:42:53 401a0bf1 kernel: [47659.288040] ath: Chip reset failed
Jan 10 21:42:53 401a0bf1 kernel: [47659.288045] ath: Unable to reset 
channel, reset status -22
Jan 10 21:42:53 401a0bf1 kernel: [47659.288091] ath: Unable to set channel
Jan 10 21:42:53 401a0bf1 kernel: [47659.353999] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan 10 21:42:53 401a0bf1 kernel: [47659.366852] ath: DMA failed to stop in 
10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan 10 21:42:53 401a0bf1 kernel: [47659.366857] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan 10 21:42:53 401a0bf1 kernel: [47659.482275] ath: Chip reset failed
Jan 10 21:42:53 401a0bf1 kernel: [47659.482280] ath: Unable to reset 
channel, reset status -22
Jan 10 21:42:53 401a0bf1 kernel: [47659.482302] ath: Unable to set channel
Jan 10 21:42:53 401a0bf1 kernel: [47659.548509] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan 10 21:42:53 401a0bf1 kernel: [47659.561477] ath: DMA failed to stop in 
10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan 10 21:42:53 401a0bf1 kernel: [47659.561481] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan 10 21:42:53 401a0bf1 kernel: [47659.677601] ath: Chip reset failed
Jan 10 21:42:53 401a0bf1 kernel: [47659.677604] ath: Unable to reset channel 
(2462 MHz), reset status -22
Jan 10 21:42:54 401a0bf1 kernel: [47660.682084] ath: Failed to wakeup in 
500us
Jan 10 21:42:55 401a0bf1 kernel: [47661.231280] ath: Failed to wakeup in 
500us
Jan 10 21:42:55 401a0bf1 kernel: [47661.245756] ath: Failed to wakeup in 
500us
Jan 10 21:42:55 401a0bf1 kernel: [47661.273456] ath: Failed to wakeup in 
500us
Jan 10 21:42:55 401a0bf1 kernel: [47661.284277] ath: Failed to wakeup in 
500us
Jan 10 21:42:55 401a0bf1 kernel: [47661.349214] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan 10 21:42:55 401a0bf1 kernel: [47661.362013] ath: DMA failed to stop in 
10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan 10 21:42:55 401a0bf1 kernel: [47661.362016] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan 10 21:42:55 401a0bf1 kernel: [47661.604443] ath: Failed to wakeup in 
500us
Jan 10 21:42:55 401a0bf1 kernel: [47661.670201] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan 10 21:42:55 401a0bf1 kernel: [47661.683148] ath: DMA failed to stop in 
10 ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan 10 21:42:55 401a0bf1 kernel: [47661.683152] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan 10 21:42:55 401a0bf1 kernel: [47661.799038] ath: Chip reset failed
Jan 10 21:42:55 401a0bf1 kernel: [47661.799043] ath: Unable to reset channel 
(2462 MHz), reset status -22
Jan 10 21:42:56 401a0bf1 kernel: [47662.373472] ath: Failed to wakeup in 
500us
Jan 10 21:42:56 401a0bf1 kernel: [47662.489762] ath: Chip reset failed
Jan 10 21:42:56 401a0bf1 kernel: [47662.489769] ath: Unable to reset 
hardware; reset status -22 (freq 2462 MHz)
Jan 10 21:42:59 401a0bf1 kernel: [47665.685279] ath: Failed to wakeup in 
500us
Jan 10 21:43:04 401a0bf1 kernel: [47670.688494] ath: Failed to wakeup in 
500us
Jan 10 21:43:09 401a0bf1 kernel: [47675.675943] ath: Failed to wakeup in 
500us
Jan 10 21:43:14 401a0bf1 kernel: [47680.663071] ath: Failed to wakeup in 
500us
Jan 10 21:43:19 401a0bf1 kernel: [47685.666297] ath: Failed to wakeup in 
500us
Jan 10 21:43:24 401a0bf1 kernel: [47690.669649] ath: Failed to wakeup in 
500us
Jan 10 21:43:25 401a0bf1 kernel: [47691.020335] ath: Failed to wakeup in 
500us
Jan 10 21:43:25 401a0bf1 kernel: [47691.135856] ath: Chip reset failed
Jan 10 21:43:25 401a0bf1 kernel: [47691.135861] ath: Unable to reset 
hardware; reset status -22 (freq 2462 MHz)
Jan 10 21:43:29 401a0bf1 kernel: [47695.656864] ath: Failed to wakeup in 
500us



Jan 10 21:44:01 401a0bf1 kernel: [47727.484465] ath9k: Driver unloaded
Jan 10 21:44:04 401a0bf1 kernel: [47729.913403] ath9k 0000:03:00.0: enabling 
device (0000 -> 0002)
Jan 10 21:44:04 401a0bf1 kernel: [47729.913414] ath9k 0000:03:00.0: PCI INT 
A -> GSI 17 (level, low) -> IRQ 17
Jan 10 21:44:04 401a0bf1 kernel: [47729.913427] ath9k 0000:03:00.0: setting 
latency timer to 64
Jan 10 21:44:04 401a0bf1 kernel: [47730.028960] ath: Couldn't reset chip
Jan 10 21:44:04 401a0bf1 kernel: [47730.028963] ath: Unable to initialize 
hardware; initialization status: -5
Jan 10 21:44:04 401a0bf1 kernel: [47730.028968] ath9k 0000:03:00.0: Failed 
to initialize device
Jan 10 21:44:04 401a0bf1 kernel: [47730.029010] ath9k 0000:03:00.0: PCI INT 
A disabled
Jan 10 21:44:04 401a0bf1 kernel: [47730.029033] ath9k: probe of 0000:03:00.0 
failed with error -5



03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at d7400000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-
,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<128ns, L1 <2us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ 
ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Capabilities: [170 v1] Power Budgeting <?>



