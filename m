Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab1JGHmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:42:06 -0400
Received: from ezo.ezono.com ([50.22.105.208]:45328 "EHLO ezo.ezono.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1JGHmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:42:05 -0400
X-Greylist: delayed 1537 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Oct 2011 03:42:05 EDT
Message-ID: <4E8EA746.6030103@ezono.com>
Date: Fri, 07 Oct 2011 09:16:22 +0200
From: Abdelghani Ouchabane <abdelghani@ezono.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Abdelghani Ouchabane <abdelghani@ezono.com>
Subject: PCIe can not rescan for new PCIe device ( FPGA board )
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ezo.ezono.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ezono.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

   We are developing a FPGA board connected to a Fedora 15 PC host over PCIe. Right now, in the implementation and debug phase, I often need to power off and
power on the device or try different boards. This causes a problem with the Fedora 15 running on the AMD PC.

Typically the PC is booted when I need to insert the device under test. As expected, the Linux doesn't find the device and the software app cannot talk to it.

 * If I do "lspci -v" then it does not list our device.

 * Then I execute "echo 1 > /sys/bus/pci/rescan"

 * Now "lspci -v" lists our device.

 * But our software returns : 0xFFFFFFFF

************************************************************************************************************************************************************
[root@localhost ~]# show_regs
resource file = /sys/bus/pci/devices/0000:02:00.0/resource
base address  = 0x40241000
    0x40241000    0x00000000    0xFFFFFFFF    0xFFFFFFFF
    0x40241008    0x00000008    0xFFFFFFFF    0xFFFFFFFF
    0x40241010    0x00000010    0xFFFFFFFF    0xFFFFFFFF
    0x40241018    0x00000018    0xFFFFFFFF    0xFFFFFFFF
    0x40241020    0x00000020    0xFFFFFFFF    0xFFFFFFFF
    0x40241028    0x00000028    0xFFFFFFFF    0xFFFFFFFF
    0x40241030    0x00000030    0xFFFFFFFF    0xFFFFFFFF
    0x40241038    0x00000038    0xFFFFFFFF    0xFFFFFFFF
    0x40241040    0x00000040    0xFFFFFFFF    0xFFFFFFFF
    0x40241048    0x00000048    0xFFFFFFFF    0xFFFFFFFF
    0x40241050    0x00000050    0xFFFFFFFF    0xFFFFFFFF
    0x40241058    0x00000058    0xFFFFFFFF    0xFFFFFFFF


************************************************************************************************************************************************************
lspci -vvv

02:00.0 Signal processing controller: eZono AG eZono Malta - 32 channels ultrasound front end (rev 01)
	Subsystem: eZono AG Device 0001
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at 40240000 (64-bit, prefetchable) [size=4K]
	Region 2: Memory at 40200000 (64-bit, prefetchable) [size=256K]
	Region 4: Memory at 40241000 (64-bit, prefetchable) [size=4K]
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 2048 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <1us, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-


************************************************************************************************************************************************************
lspci -xxx

02:00.0 Signal processing controller: eZono AG eZono Malta - 32 channels ultrasound front end (rev 01)
00: 34 12 02 00 02 00 10 00 01 00 80 11 00 00 00 00
10: 0c 00 24 40 00 00 00 00 0c 00 20 40 00 00 00 00
20: 0c 10 24 40 00 00 00 00 00 00 00 00 34 12 01 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 01 00 00
40: 00 00 00 00 70 61 62 01 00 00 00 00 00 00 00 00
50: 05 78 80 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 01 80 03 00 00 00 00 00
80: 10 00 01 00 04 80 2c 01 10 28 00 00 11 44 00 01
90: 01 00 11 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

************************************************************************************************************************************************************

It looks that 'rescan' is not enough to handle cases like this? Or, is there a
way to "insert" the FPGAs later after the kernel boots up?


Many thanks in advance, 
Ghani


