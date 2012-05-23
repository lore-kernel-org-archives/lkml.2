Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab2EWTNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:13:24 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57270 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab2EWTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:13:20 -0400
MIME-Version: 1.0
From: Comrade DOS <suloevdmitry@gmail.com>
Date: Thu, 24 May 2012 02:12:39 +0700
Message-ID: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
Subject: PROBLEM: Performance drop
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROBLEM: Performance drop

After the release of linux 3.4.0 I've updated the kernel on all my machines.
In most of the computer upgrade was successful.
However, on my old laptop (HP Compaq 6715b) after the upgrade was just
impossible to work.
I found that CPU frequency scaling no longer work properly on this machine.
After loading the CPU clock is reset to the minimum (800 MHz), and
remains so until you reboot.
Changing the type of governor is not helping.
Recompile the kernel without CPU frequency scaling has been to solve
the problem, but even after this performance leaves much to be desired
(although, according to /proc/cpuinfo CPU frequency set maximum).
In addition to the above-described problems, there is another - the
problem with rebooting and shutting down (and possibly also have a
problem with s2ram and/or s2disk, but I'm their functionality I have
not tested).
If you try to shut down or restart the laptop it hangs.

Information about my system (according to
http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html):

/proc/version
Linux version 3.4.0 (root@dos) (gcc version 4.6.3 (Gentoo 4.6.3 p1.0,
pie-0.5.1) ) #1 SMP PREEMPT Thu May 24 01:02:36 OMST 2012

ver_linux
Linux dos 3.4.0 #1 SMP PREEMPT Thu May 24 01:02:36 OMST 2012 x86_64
Mobile AMD Sempron(tm) Processor 3800+ AuthenticAMD GNU/Linux

Gnu C                  4.6.3
Gnu make               3.82
binutils               2.22
util-linux             ./ver_linux: line 23: fdformat: command not found
mount                  support
module-init-tools      found
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 UNKNOWN
Net-tools              1.60_p20120127084908
Kbd                    1.15.3wip
Sh-utils               8.17
Modules Loaded         aes_generic af_packet btusb bluetooth usbhid
b43 mac80211 cfg80211 rng_core ehci_hcd ohci_hcd tg3 usbcore libphy
ssb snd_hda_codec_analog sr_mod cdrom usb_common snd_hda_intel
snd_hda_codec snd_pcm snd_page_alloc snd_timer snd k8temp hp_accel
lis3lv02d input_polldev evdev unix

/proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 76
model name	: Mobile AMD Sempron(tm) Processor 3800+
stepping	: 2
cpu MHz		: 800.000
cache size	: 256 KB
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt rdtscp
lm 3dnowext 3dnow up rep_good nopl extd_apicid pni cx16 lahf_lm
extapic cr8_legacy
bogomips	: 1596.02
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

/proc/modules
aes_generic 25914 1 - Live 0xffffffffa00e5000
af_packet 25220 2 - Live 0xffffffffa007b000
btusb 10857 0 - Live 0xffffffffa008a000
bluetooth 179115 2 btusb, Live 0xffffffffa021c000
usbhid 18009 0 - Live 0xffffffffa003e000
b43 166907 0 - Live 0xffffffffa0169000
mac80211 197519 1 b43, Live 0xffffffffa0137000
cfg80211 161332 2 b43,mac80211, Live 0xffffffffa010e000
rng_core 3278 1 b43, Live 0xffffffffa000a000
ehci_hcd 39899 0 - Live 0xffffffffa0103000
ohci_hcd 20351 0 - Live 0xffffffffa0012000
tg3 133841 0 - Live 0xffffffffa01cd000
usbcore 124556 4 btusb,usbhid,ehci_hcd,ohci_hcd, Live 0xffffffffa00c5000
libphy 15486 1 tg3, Live 0xffffffffa00c0000
ssb 34730 1 b43, Live 0xffffffffa00b1000
snd_hda_codec_analog 75936 1 - Live 0xffffffffa0098000
sr_mod 13991 0 - Live 0xffffffffa0064000
cdrom 34578 1 sr_mod, Live 0xffffffffa008e000
usb_common 785 1 usbcore, Live 0xffffffffa0008000
snd_hda_intel 21683 0 - Live 0xffffffffa0083000
snd_hda_codec 58276 2 snd_hda_codec_analog,snd_hda_intel, Live
0xffffffffa006b000
snd_pcm 64122 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0053000
snd_page_alloc 6609 2 snd_hda_intel,snd_pcm, Live 0xffffffffa004e000
snd_timer 17914 1 snd_pcm, Live 0xffffffffa0045000
snd 52542 5 snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer,
Live 0xffffffffa0030000
k8temp 3211 0 - Live 0xffffffffa002c000
hp_accel 16008 0 - Live 0xffffffffa0025000
lis3lv02d 9820 1 hp_accel, Live 0xffffffffa001e000
input_polldev 2498 1 lis3lv02d, Live 0xffffffffa000c000
evdev 9178 6 - Live 0xffffffffa000e000
unix 26105 110 - Live 0xffffffffa0000000

/proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:14.1
    0170-0177 : pata_atiixp
  01f0-01f7 : 0000:00:14.1
    01f0-01f7 : pata_atiixp
  0376-0376 : 0000:00:14.1
    0376-0376 : pata_atiixp
  03c0-03df : vga+
  03f6-03f6 : 0000:00:14.1
    03f6-03f6 : pata_atiixp
  040b-040b : pnp 00:09
  04d0-04d1 : pnp 00:09
  04d6-04d6 : pnp 00:09
  0500-053f : pnp 00:09
  0c00-0c01 : pnp 00:09
  0c14-0c14 : pnp 00:09
  0c50-0c51 : pnp 00:09
  0c52-0c52 : pnp 00:09
  0c6c-0c6c : pnp 00:09
  0c6f-0c6f : pnp 00:09
  0cd0-0cdf : pnp 00:09
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1fff : PCI Bus 0000:02
    1000-10ff : PCI CardBus 0000:03
    1400-14ff : PCI CardBus 0000:03
  2000-3fff : PCI Bus 0000:20
  4000-4fff : PCI Bus 0000:01
    4000-40ff : 0000:01:05.0
  5018-501b : 0000:00:12.0
    5018-501b : ahci
  5020-502f : 0000:00:12.0
    5020-502f : ahci
  5040-504f : 0000:00:14.1
    5040-504f : pata_atiixp
  8000-802f : pnp 00:0b
    8000-8003 : ACPI PM1a_EVT_BLK
    8004-8005 : ACPI PM1a_CNT_BLK
    8008-800b : ACPI PM_TMR
    8010-8015 : ACPI CPU throttle
    8020-8027 : ACPI GPE0_BLK
  8100-811f : pnp 00:0b
    8104-8107 : ACPI PM1b_EVT_BLK
  8200-820f : 0000:00:14.0
  8800-8800 : ACPI PM2_CNT_BLK
  9000-9007 : 0000:00:12.0
    9000-9007 : ahci
  9008-900b : 0000:00:12.0
    9008-900b : ahci
  9010-9017 : 0000:00:12.0
    9010-9017 : ahci

/proc/iomem
00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cd3ff : Video ROM
000cd400-000cffff : pnp 00:0c
000d0000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-b7faffff : System RAM
  01000000-014319b1 : Kernel code
  014319b2-0161427f : Kernel data
  01686000-01715fff : Kernel bss
  ac000000-afffffff : GART
b7fb0000-b7fc7fff : reserved
b7fc8000-b7fe7fb7 : ACPI Non-volatile Storage
b7fe7fb8-bfffffff : reserved
c0000000-fedfffff : PCI Bus 0000:00
  c0000000-c7ffffff : PCI Bus 0000:01
    c0000000-c7ffffff : 0000:01:05.0
  c8000000-c80fffff : PCI Bus 0000:30
    c8000000-c8003fff : 0000:30:00.0
      c8000000-c8003fff : 0000:30:00.0
  c8100000-c8103fff : 0000:00:14.2
    c8100000-c8103fff : ICH HD audio
  cc000000-cfffffff : PCI Bus 0000:20
  d0000000-d00fffff : PCI Bus 0000:10
    d0000000-d000ffff : 0000:10:00.0
      d0000000-d000ffff : tg3
  d0100000-d03fffff : PCI Bus 0000:02
    d0100000-d0100fff : 0000:02:04.0
    d0101000-d01017ff : 0000:02:04.1
  d0400000-d05fffff : PCI Bus 0000:01
    d0400000-d040ffff : 0000:01:05.0
    d0500000-d05fffff : 0000:01:05.0
  d0601000-d0601fff : 0000:00:13.0
    d0601000-d0601fff : ohci_hcd
  d0602000-d0602fff : 0000:00:13.1
    d0602000-d0602fff : ohci_hcd
  d0603000-d0603fff : 0000:00:13.2
    d0603000-d0603fff : ohci_hcd
  d0604000-d0604fff : 0000:00:13.3
    d0604000-d0604fff : ohci_hcd
  d0605000-d0605fff : 0000:00:13.4
    d0605000-d0605fff : ohci_hcd
  d0606000-d06060ff : 0000:00:13.5
    d0606000-d06060ff : ehci_hcd
  d0609000-d06093ff : 0000:00:12.0
    d0609000-d06093ff : ahci
  d4000000-d7ffffff : PCI Bus 0000:02
    d4000000-d7ffffff : PCI CardBus 0000:03
  d8000000-dbffffff : PCI CardBus 0000:03
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : reserved
      e0000000-efffffff : pnp 00:0b
  fec00000-fec01fff : reserved
    fec00000-fec003ff : IOAPIC 0
  fed45000-fed8ffff : pnp 00:0b
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:0c
fee01000-ffffffff : PCI Bus 0000:00
  ffbc0000-ffcbffff : reserved
  fff00000-ffffffff : reserved
    fff00000-ffffffff : pnp 00:09
100000000-13fffffff : System RAM

lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RS690 Host Bridge
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 64

00:01.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RS690 PCI to
PCI Bridge (Internal gfx) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d0400000-d05fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000c7ffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: Hewlett-Packard Company Device 30c2

00:04.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI Device 7914
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=10, subordinate=10, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: d0000000-d00fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4159
	Capabilities: [b0] Subsystem: Hewlett-Packard Company Device 30c2
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:05.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RS690 PCI to
PCI Bridge (PCI Express Port 1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=20, subordinate=20, sec-latency=0
	I/O behind bridge: 00002000-00003fff
	Memory behind bridge: cc000000-cfffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #247, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4161
	Capabilities: [b0] Subsystem: Hewlett-Packard Company Device 30c2
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:06.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RS690 PCI to
PCI Bridge (PCI Express Port 2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=30, subordinate=30, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: c8000000-c80fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4169
	Capabilities: [b0] Subsystem: Hewlett-Packard Company Device 30c2
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:12.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB600
Non-Raid-5 SATA (prog-if 01 [AHCI 1.0])
	Subsystem: Advanced Micro Devices [AMD] nee ATI SB600 Non-Raid-5 SATA
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 9000 [size=8]
	Region 1: I/O ports at 9008 [size=4]
	Region 2: I/O ports at 9010 [size=8]
	Region 3: I/O ports at 5018 [size=4]
	Region 4: I/O ports at 5020 [size=16]
	Region 5: Memory at d0609000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ahci

00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI0) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d0601000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.1 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI1) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d0602000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI2) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 17
	Region 0: Memory at d0603000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.3 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI3) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d0604000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.4 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
(OHCI4) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 17
	Region 0: Memory at d0605000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.5 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB
Controller (EHCI) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at d0606000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus
Controller (rev 14)
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: I/O ports at 8200 [size=16]
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

00:14.1 IDE interface: Advanced Micro Devices [AMD] nee ATI SB600 IDE
(prog-if 82 [Master PriP])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 5040 [size=16]
	Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00
Azalia (Intel HDA)
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c8100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB600 PCI to LPC Bridge
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to
PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=03, sec-latency=64
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d0100000-d03fffff
	Prefetchable memory behind bridge: d4000000-d7ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=8
IsocEn- LSEn+ ExtCTL- 64b+
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 800MHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: k8temp

01:05.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
ATI RS690M [Radeon X1200 Series] (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at c0000000 (64-bit, prefetchable) [size=128M]
	Region 2: Memory at d0400000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at 4000 [size=256]
	Region 5: Memory at d0500000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

02:04.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b6)
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at d0100000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: d4000000-d7ffffff (prefetchable)
	Memory window 1: d8000000-dbffffff
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+
Postpcilib: sysfs_read_vpd: read failed: Connection timed out
Write+
	16-bit legacy interface ports at 0001

02:04.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
(rev 02) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 5
	Region 0: Memory at d0101000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-

10:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M
Gigabit Ethernet PCI Express (rev 02)
	Subsystem: Hewlett-Packard Company Device 30c2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at d0000000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
		Not readable
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [e8] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4189
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<4us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-1a-4b-ff-fe-76-46-6e
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: tg3

30:00.0 Network controller: Broadcom Corporation BCM4311 802.11a/b/g (rev 02)
	Subsystem: Hewlett-Packard Company Broadcom 802.11a/b/g WLAN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at c8000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Surprise+ LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number d6-9a-73-ff-ff-b5-00-1a
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: b43-pci-bridge

/proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST9120822AS      Rev: 3.BH
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: MATSHITA Model: DVD-RAM UJ-860H  Rev: 1.02
  Type:   CD-ROM                           ANSI  SCSI revision: 05
