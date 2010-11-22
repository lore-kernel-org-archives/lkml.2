Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0KVVZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:25:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40571 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab0KVVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:25:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZKqJU3e1D2HJPWtl+X/R9twOPaw9zrzFcUSIEkRPkraoNRBVFJhBxEEORDmwG8zEXY
         gccCvN+bmeF7UcV40F3lFHQFeULgXgh3sr21JxV1dRj07NLlhFX3M6PNoaAJ/YNftuzc
         SxClmdMFvmzdo+Ifxiv/N6WgCZ8KF/fun1Qvk=
Subject: sata_sil24: external raid storage mistaken as port multiplier
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 22:24:33 +0100
Message-ID: <1290461073.12443.21.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a regression regarding the sata_sil24 driver:

My RaidSonic Stardom SR3620-2S-SB2 is mistaken as a port multiplier,
it did work with Linux 2.6.23.

Maybe an module option to disable port multiplier support would already help.

-Tobias

Linux Tobias-Karnat 2.6.35-22-generic #35-Ubuntu SMP Sat Oct 16 20:45:36 UTC 2010 x86_64 GNU/Linux

02:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
	Subsystem: Silicon Image, Inc. Device 7132
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fadfbf80 (64-bit, non-prefetchable) [size=128]
	Region 2: Memory at fadfc000 (64-bit, non-prefetchable) [size=16K]
	Region 4: I/O ports at cc80 [size=128]
	Expansion ROM at fae00000 [disabled] [size=512K]
	Capabilities: [54] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: sata_sil24
	Kernel modules: sata_sil24

[ 2044.110031] ata3: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
[ 2044.110036] ata3: irq_stat 0x00b40090, PHY RDY changed
[ 2044.110044] ata3: hard resetting link
[ 2046.330028] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[ 2047.110026] ata3.15: Port Multiplier 1.1, 0x1095:0x4723 r28, 3 ports, feat 0x1/0x9
[ 2047.510027] ata3.00: hard resetting link
[ 2050.320020] ata3.00: failed to resume link (SControl 0)
[ 2050.540038] ata3.00: softreset failed (SRST command error)
[ 2050.720037] ata3.00: failed to read SCR 0 (Emask=0x1)
[ 2050.720040] ata3.00: reset failed, giving up
[ 2050.720046] ata3.15: hard resetting link
[ 2050.720048] ata3: controller in dubious state, performing PORT_RST
[ 2052.980030] ata3.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[ 2053.720024] ata3.00: hard resetting link
[ 2056.520040] ata3.00: failed to resume link (SControl 0)
[ 2057.420721] ata3.00: SATA link down (SStatus 0 SControl 0)
[ 2057.620025] ata3.01: hard resetting link
[ 2060.440045] ata3.01: failed to resume link (SControl 0)
[ 2067.620038] ata3.01: softreset failed (timeout)
[ 2067.650049] ata3.01: hard resetting link
[ 2070.450048] ata3.01: failed to resume link (SControl 0)
[ 2077.660099] ata3.01: softreset failed (timeout)
[ 2077.760064] ata3.01: hard resetting link
[ 2080.561452] ata3.01: failed to resume link (SControl 0)
[ 2112.750663] ata3.01: softreset failed (timeout)
[ 2112.890033] ata3.01: limiting SATA link speed to 1.5 Gbps
[ 2112.890038] ata3.01: hard resetting link
[ 2115.690110] ata3.01: failed to resume link (SControl 0)
[ 2117.900038] ata3.01: softreset failed (timeout)
[ 2117.990048] ata3.01: reset failed, giving up
[ 2117.990055] ata3.15: hard resetting link
[ 2120.220030] ata3.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[ 2121.000053] ata3.01: hard resetting link
[ 2123.800040] ata3.01: failed to resume link (SControl 0)
[ 2131.000059] ata3.01: softreset failed (timeout)
[ 2131.100045] ata3.01: hard resetting link
[ 2133.900047] ata3.01: failed to resume link (SControl 0)
[ 2141.100154] ata3.01: softreset failed (timeout)
[ 2141.200046] ata3.01: hard resetting link
[ 2144.010034] ata3.01: failed to resume link (SControl 0)
[ 2176.200663] ata3.01: softreset failed (timeout)
[ 2176.200670] ata3.01: failed to read SCR 0 (Emask=0x40)
[ 2176.200674] ata3.01: reset failed, giving up
[ 2176.200680] ata3.15: hard resetting link
[ 2178.290030] ata3.15: SATA link down (SStatus 0 SControl 0)
[ 2181.294766] ata3.15: qc timeout (cmd 0xe4)
[ 2181.294795] ata3.15: failed to read PMP GSCR[0] (Emask=0x5)
[ 2181.294799] ata3.15: PMP revalidation failed (errno=-5)
[ 2183.290042] ata3.15: hard resetting link
[ 2185.382136] ata3.15: SATA link down (SStatus 0 SControl 0)
[ 2188.382646] ata3.15: qc timeout (cmd 0xe4)
[ 2188.382675] ata3.15: failed to read PMP GSCR[0] (Emask=0x5)
[ 2188.382680] ata3.15: PMP revalidation failed (errno=-5)
[ 2188.382685] ata3.15: limiting SATA link speed to 1.5 Gbps
[ 2190.390642] ata3.15: hard resetting link
[ 2192.480655] ata3.15: SATA link down (SStatus 0 SControl 10)
[ 2195.480021] ata3.15: qc timeout (cmd 0xe4)
[ 2195.480050] ata3.15: failed to read PMP GSCR[0] (Emask=0x5)
[ 2195.480054] ata3.15: PMP revalidation failed (errno=-5)
[ 2197.480016] ata3.15: hard resetting link
[ 2199.570662] ata3.15: SATA link down (SStatus 0 SControl 10)
[ 2202.570646] ata3.15: qc timeout (cmd 0xe4)
[ 2202.570675] ata3.15: failed to read PMP GSCR[0] (Emask=0x5)
[ 2202.570680] ata3.15: PMP revalidation failed (errno=-5)
[ 2204.570638] ata3.15: hard resetting link
[ 2206.670025] ata3.15: SATA link down (SStatus 0 SControl 10)
[ 2209.670020] ata3.15: qc timeout (cmd 0xe4)
[ 2209.670049] ata3.15: failed to read PMP GSCR[0] (Emask=0x5)
[ 2209.670053] ata3.15: PMP revalidation failed (errno=-5)
[ 2209.670056] ata3.15: failed to recover PMP after 5 tries, giving up
[ 2209.670059] ata3.15: Port Multiplier detaching
[ 2209.670088] ata3.00: disabled
[ 2209.670104] ata3: hard resetting link
[ 2211.760652] ata3: SATA link down (SStatus 0 SControl 10)
[ 2211.760664] ata3: EH complete

