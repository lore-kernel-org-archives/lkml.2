Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0CSVwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:52:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:20111 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0CSVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ecRXnouyuggdegWpcJuFXyYs3p7TvQ8spgMPnZotaYbt9GRd2WP8yFqA+fi7NP3D2e
         QPUMTgHrA8qpSeGblzH2/Ew9b05FG7LOM6phPXj46E76cOmkUdT8wI2Vvue24xeAIyAi
         c4ZmnMj23aCT6vbg4dAatQeUYaSmWhEM9yLmM=
Message-ID: <4BA3F21F.2090700@googlemail.com>
Date: Fri, 19 Mar 2010 22:52:31 +0100
From: Maik Masling <maik.masling@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10pre) Gecko/20100318 Shredder/3.0.5pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jpiszcz@lucidpixels.com
Subject: Fwd: [Bug 541749] Re: PCIExpress 1.0 16x Port (nforce 630i) and 16x-Card
 8600 GTS only synced at bus-type-speed 4x
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel-Team,
I need to report a malfuction of pcieport or others,

cosmichaos@cosmichaos-desktop:~$ sudo gzip /lib/modules/2.6.32-16-preempt/updates/dkms/nvidia-current.ko
cosmichaos@cosmichaos-desktop:~$ reboot
...
cosmichaos@cosmichaos-desktop:~$ dmesg | grep -i taint
cosmichaos@cosmichaos-desktop:~$ sudo lspci -s 02:00.0 -vv
[sudo] password for cosmichaos:
*02:00.0 VGA compatible controller: nVidia Corporation G84 [GeForce 8600 GTS] (rev a1)*
...
		*LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0<512ns, L1<4us*
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		*LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-*
...
for more see below, with tainted nvidia because its overall the same.


Ubuntu-Bug description:
*00:0b.0 PCI bridge [0604]: nVidia Corporation MCP73 PCI Express bridge [10de:056e] (rev a1)*
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fa000000-febfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort-<SERR-<PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort->Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: nVidia Corporation Device [10de:07d7]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4149
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s<64ns, L1<1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		*LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0<512ns, L1<4us*
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		*LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-*
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  1, PowerLimit 75.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel<?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00: de 10 6e 05 07 04 10 00 a1 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 e1 e1 00 00
20: 00 fa b0 fe 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 1a 00
40: 0d 48 00 00 de 10 d7 07 01 50 02 f8 00 00 00 00
50: 05 80 83 00 0c 30 e0 fe 00 00 00 00 49 41 00 00
60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 41 01 21 80 00 00 10 28 01 00 01 3d 11 00
90: 00 00 41 30 80 25 08 00 c0 01 48 01 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
...
*02:00.0 VGA compatible controller [0300]: nVidia Corporation G84 [GeForce 8600 GTS] [10de:0400] (rev a1)*
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at ec00 [size=128]
	[virtual] Expansion ROM at febe0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s<512ns, L1<4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		*LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0<512ns, L1<4us*
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		*LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-*
	Capabilities: [100] Virtual Channel<?>
	Capabilities: [128] Power Budgeting<?>
	Capabilities: [600] Vendor Specific Information<?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia-current, nouveau, nvidiafb
00: de 10 00 04 07 00 10 00 a1 00 00 03 00 00 00 00
10: 00 00 00 fd 0c 00 00 d0 00 00 00 00 04 00 00 fa
20: 00 00 00 00 01 ec 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 60 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 02 00 00 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 00 01 00 e0 84 2c 01
80: 10 29 00 00 01 3d 01 00 08 00 41 10 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


