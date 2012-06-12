Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2FLUJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:09:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56767 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2FLUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:09:20 -0400
MIME-Version: 1.0
Date: Tue, 12 Jun 2012 22:09:19 +0200
X-Google-Sender-Auth: RuniD0fmlbGH6cxtIoS2lFiFrIM
Message-ID: <CAGh0HCDhF_nKP+YKQDyfuYKcx2YKBuAPkMHxa0x265Rgs0haMg@mail.gmail.com>
Subject: PROBLEM: Keyboard/mouse freeze with high network usage (r8169/brcmsmac/broadcom-wl)
From: Guillaume Bouchard <guillaume.bouchard@liris.cnrs.fr>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel hackers,

The builtin keyboard and mouse of my laptop randomly freeze during usage.

It can happen on console or under X (for the mouse I'm not sure it
freezes on console because I have no console mouse installed). But
other parts of the computer are still perfectly alive (ie,
applications continue to work, movie to play, computer can be reach by
SSH).

My computer is an HP dm1 4131ef. Important stuff about this computer are:

- An AMD E450 CPU with intergrated AMD graphics. I'm using the
catalyst proprietary driver, but some users in arch linux forum
complains about the same issue with the radeon module.
- Distribution is arch linux. I'm up to date on the testing repository
- kernel version: Linux version 3.4.2-2-ARCH (tobias@T-POWA-LX) (gcc
version 4.7.0 20120505 (prerelease) (GCC) ) #1 SMP PREEMPT Mon Jun 11
22:27:17 CEST 2012

- cpuinfo

---------------------
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 20
model		: 2
model name	: AMD E-450 APU with Radeon(tm) HD Graphics
stepping	: 0
microcode	: 0x5000101
cpu MHz		: 1646.418
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
aperfmperf pni monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch ibs skinit wdt
arat hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips	: 3294.03
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 20
model		: 2
model name	: AMD E-450 APU with Radeon(tm) HD Graphics
stepping	: 0
microcode	: 0x5000101
cpu MHz		: 1646.418
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
aperfmperf pni monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch ibs skinit wdt
arat hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips	: 3294.03
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
-------------------

Modules informations /proc/modules

----------------
joydev 9991 0 - Live 0xffffffffa0090000
usbhid 36430 0 - Live 0xffffffffa009d000
hid 85285 1 usbhid, Live 0xffffffffa0076000
uas 9285 0 - Live 0xffffffffa069f000
ums_realtek 7391 0 - Live 0xffffffffa0699000
snd_hda_codec_idt 55508 1 - Live 0xffffffffa0684000
uvcvideo 69437 0 - Live 0xffffffffa066d000
snd_hda_codec_hdmi 23672 1 - Live 0xffffffffa0662000
snd_hda_intel 24053 7 - Live 0xffffffffa063e000
snd_hda_codec 94273 3
snd_hda_codec_idt,snd_hda_codec_hdmi,snd_hda_intel, Live
0xffffffffa05f0000
snd_hwdep 6300 1 snd_hda_codec, Live 0xffffffffa05e4000
snd_pcm 74958 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0xffffffffa05aa000
snd_page_alloc 7217 2 snd_hda_intel,snd_pcm, Live 0xffffffffa01f2000
videobuf2_vmalloc 2468 1 uvcvideo, Live 0xffffffffa0197000
fglrx 2619025 74 - Live 0xffffffffa02b6000 (PO)
videobuf2_memops 2246 1 videobuf2_vmalloc, Live 0xffffffffa010e000
usb_storage 44728 1 ums_realtek, Live 0xffffffffa0283000
snd_timer 18966 1 snd_pcm, Live 0xffffffffa01da000
videobuf2_core 20415 1 uvcvideo, Live 0xffffffffa01d4000
videodev 93086 1 uvcvideo, Live 0xffffffffa01a9000
i2c_piix4 8224 0 - Live 0xffffffffa00d7000
snd 58997 21 snd_hda_codec_idt,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa0175000
i2c_core 20369 2 videodev,i2c_piix4, Live 0xffffffffa014f000
r8169 49354 0 - Live 0xffffffffa00fe000
k10temp 2915 0 - Live 0xffffffffa00d3000
soundcore 5410 1 snd, Live 0xffffffffa00c7000
amd_iommu_v2 7359 1 fglrx, Live 0xffffffffa00c1000
mii 4123 1 r8169, Live 0xffffffffa00bc000
evdev 9754 6 - Live 0xffffffffa0099000
serio_raw 4653 0 - Live 0xffffffffa0094000
media 10213 2 uvcvideo,videodev, Live 0xffffffffa008c000
processor 26567 2 - Live 0xffffffffa0031000
wmi 8475 0 - Live 0xffffffffa002a000
microcode 12185 0 - Live 0xffffffffa001c000
button 4502 1 fglrx, Live 0xffffffffa02b0000
thermal 7959 0 - Live 0xffffffffa02aa000
video 11307 0 - Live 0xffffffffa02a2000
ac 2376 0 - Live 0xffffffffa029e000
battery 6517 0 - Live 0xffffffffa0299000
ext4 424175 3 - Live 0xffffffffa0216000
crc16 1359 1 ext4, Live 0xffffffffa0212000
jbd2 73919 1 ext4, Live 0xffffffffa01f5000
mbcache 5977 1 ext4, Live 0xffffffffa01ef000
sd_mod 29239 5 - Live 0xffffffffa01e2000
ohci_hcd 21720 0 - Live 0xffffffffa01c4000
ahci 20549 4 - Live 0xffffffffa0199000
libahci 20023 1 ahci, Live 0xffffffffa018f000
libata 167515 2 ahci,libahci, Live 0xffffffffa0120000
ehci_hcd 41154 0 - Live 0xffffffffa0110000
scsi_mod 132942 4 uas,usb_storage,sd_mod,libata, Live 0xffffffffa00dc000
usbcore 147533 8
usbhid,uas,ums_realtek,uvcvideo,usb_storage,ohci_hcd,ehci_hcd, Live
0xffffffffa003a000
usb_common 954 1 usbcore, Live 0xffffffffa0000000
-------------------------------

(Currently I have blacklisted)

# to use broadcom wl driver
blacklist b43
blacklist bcma
blacklist ssb

# I tried to blacklist all those module to test
blacklist hp_wmi
blacklist powernow_k8
blacklist lis3lv02d
blacklist hp_accel
blacklist lis3lv02d
blacklist bluetooth
blacklist btusb
blacklist rfkill

# Because I don't like this stuff
blacklist pcspkr

# because I don't want wifi enable be default
blacklist wl

# I tried this, it does not change anything
options psmouse proto=imps

# because I use the catalyst driver
blacklist radeon

# because it was slowing down boot with "mmio address already in use"
blacklist sp5100_tco
--------------------------------------------------------

I'm using the broadcom wl driver because the brcmsmac driver gives a
really slow signal strength (10% at 1 meter of the accespoint), but
issues appears with wl or brcmsmac module.

-----------------------------------------------------------------------------
cat /proc/ioports
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
  0380-0387 : pnp 00:09
  03c0-03df : vga+
  0400-04cf : pnp 00:09
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-0427 : ACPI GPE0_BLK
  04d0-04d1 : pnp 00:09
  04d6-04d6 : pnp 00:09
  0680-06ff : pnp 00:09
  077a-077a : pnp 00:09
  0800-0800 : ACPI PM2_CNT_BLK
  0b00-0b07 : piix4_smbus
  0c00-0c01 : pnp 00:09
  0c14-0c14 : pnp 00:09
  0c50-0c52 : pnp 00:09
  0c6c-0c6c : pnp 00:09
  0c6f-0c6f : pnp 00:09
  0cd0-0cdb : pnp 00:09
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1fff : PCI Bus 0000:01
  2000-2fff : PCI Bus 0000:07
    2000-20ff : 0000:07:00.0
      2000-20ff : r8169
  3000-3fff : PCI Bus 0000:03
  4000-40ff : 0000:00:01.0
  4100-410f : 0000:00:11.0
    4100-410f : ahci
  4110-4117 : 0000:00:11.0
    4110-4117 : ahci
  4118-411f : 0000:00:11.0
    4118-411f : ahci
  4120-4123 : 0000:00:11.0
    4120-4123 : ahci
  4124-4127 : 0000:00:11.0
    4124-4127 : ahci
------------------------------------------------------------

-------------------------------------------------------------
cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000ce3ff : Video ROM
  000c0000-000c3fff : PCI Bus 0000:00
  000c4000-000c7fff : PCI Bus 0000:00
  000c8000-000cbfff : PCI Bus 0000:00
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
  000e0000-000e3fff : PCI Bus 0000:00
  000e4000-000e7fff : PCI Bus 0000:00
  000e8000-000ebfff : PCI Bus 0000:00
  000ec000-000effff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-669befff : System RAM
  01000000-0146e6c2 : Kernel code
  0146e6c3-018a38bf : Kernel data
  01963000-01aa3fff : Kernel bss
669bf000-66abefff : reserved
66abf000-66bbefff : ACPI Non-volatile Storage
66bbf000-66bf4fff : ACPI Tables
66bf5000-66bfffff : System RAM
66c00000-7effffff : reserved
7f000000-f7ffffff : PCI Bus 0000:00
  7f000000-7f1fffff : PCI Bus 0000:01
  7f200000-7f3fffff : PCI Bus 0000:01
  80000000-8fffffff : 0000:00:01.0
  90000000-900fffff : PCI Bus 0000:03
  90100000-901fffff : PCI Bus 0000:07
    90100000-90103fff : 0000:07:00.0
      90100000-90103fff : r8169
    90104000-90104fff : 0000:07:00.0
      90104000-90104fff : r8169
  90200000-902fffff : PCI Bus 0000:03
    90200000-90203fff : 0000:03:00.0
  90300000-9033ffff : 0000:00:01.0
  90340000-90343fff : 0000:00:14.2
    90340000-90343fff : ICH HD audio
  90344000-90347fff : 0000:00:01.1
    90344000-90347fff : ICH HD audio
  90348000-903480ff : 0000:00:16.2
    90348000-903480ff : ehci_hcd
  90349000-90349fff : 0000:00:16.0
    90349000-90349fff : ohci_hcd
  9034a000-9034a0ff : 0000:00:13.2
    9034a000-9034a0ff : ehci_hcd
  9034b000-9034bfff : 0000:00:13.0
    9034b000-9034bfff : ohci_hcd
  9034c000-9034c0ff : 0000:00:12.2
    9034c000-9034c0ff : ehci_hcd
  9034d000-9034dfff : 0000:00:12.0
    9034d000-9034dfff : ohci_hcd
  9034e000-9034e3ff : 0000:00:11.0
    9034e000-9034e3ff : ahci
f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f8000000-fbffffff : reserved
fc000000-fed3ffff : PCI Bus 0000:00
  fec00000-fec00fff : reserved
    fec00000-fec003ff : IOAPIC 0
  fec10000-fec10fff : reserved
  fed00000-fed003ff : HPET 0
fed45000-ffffffff : PCI Bus 0000:00
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : reserved
      fee00000-fee00fff : pnp 00:01
  ffe00000-ffffffff : reserved
    ffe00000-ffffffff : pnp 00:0a
-------------------------------------------------

-------------------------------------------------
lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 14h Processor
Root Complex
	Subsystem: Advanced Micro Devices [AMD] Family 14h Processor Root Complex
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32

00:01.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
ATI Wrestler [Radeon HD 6320] (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at 80000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 4000 [size=256]
	Region 2: Memory at 90300000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4179
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: fglrx_pci

00:01.1 Audio device: Advanced Micro Devices [AMD] nee ATI Wrestler
HDMI Audio [Radeon HD 6250/6310]
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 42
	Region 0: Memory at 90344000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4181
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: snd_hda_intel

00:04.0 PCI bridge: Advanced Micro Devices [AMD] Family 14h Processor
Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 7f000000-7f1fffff
	Prefetchable memory behind bridge: 000000007f200000-000000007f3fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #247, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
			Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis+,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4159
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 1234
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 4118 [size=8]
	Region 1: I/O ports at 4124 [size=4]
	Region 2: I/O ports at 4110 [size=8]
	Region 3: I/O ports at 4120 [size=4]
	Region 4: I/O ports at 4100 [size=16]
	Region 5: Memory at 9034e000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] SATA HBA v1.0 InCfgSpace
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 9034d000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at 9034c000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 9034b000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at 9034a000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus
Controller (rev 42)
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: piix4_smbus

00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00
Azalia (Intel HDA) (rev 40)
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at 90340000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to
PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal
decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=06, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: 90200000-902fffff
	Prefetchable memory behind bridge: 0000000090000000-00000000900fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 0000
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: pcieport

00:15.1 PCI bridge: Advanced Micro Devices [AMD] nee ATI
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1) (prog-if 00 [Normal
decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 0000000090100000-00000000901fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 0000
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: pcieport

00:16.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at 90349000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:16.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at 90348000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 0 (rev 43)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 1
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 2
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 3
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 4
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 6
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h
Processor Function 7
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

03:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n
Wireless LAN Controller (rev 01)
	Subsystem: Hewlett-Packard Company Device 1795
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at 90200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L1, Latency L0 <4us, L1 <64us
			ClockPM+ Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-3d-ff-ff-68-e4-d5
	Capabilities: [16c v1] Power Budgeting <?>

07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
	Subsystem: Hewlett-Packard Company Device 3387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 41
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at 90104000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at 90100000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4169
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		No end tag found
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169
----------------------------------------------------------------------

Random facts which may be relevant:

- I'm unable to see any log anywhere. dmesg told nothing special,
nothing in /var/log/kernel.log...
- I can get the keyboard and mouse back if I "modprobe -r psmouse;
modprobe psmouse" over ssh. When removing the psmouse module, I get
back the keyboard (which appears blocked in a state where it repeats
some key, state which ends when I press any key). I got back the mouse
by modprobe psmouse.
- I can plug any USB keyboard/mouse and it works without any issue
(but the main keyboard and mouse are still blocked)
- Going in and out of sleep get me the mouse and keyboard back (it may
be related to the unload/load of psmouse module)
- I have the feeling that this issues appears more when the computer
is under heavy network usage, so I did a small python script that
generate network usage with another computer. The script is really
simple (its open a TCP socket between both hosts and write/read as
many bytes as possible in an infinite loop).
- I'm usually able to get a *freeze* in less than 5 minutes using the
network script. Without this script, it can freeze in a few seconds or
in many hours.
- I have been able to avoid any freeze for 10 hours of 100% cpu usage
if I unload the wifi (brcmsmac or wl) and ethernet driver (r8169). I
was still runing the small "network script", but on localhost
interface only.
- I allready discussed this issue on the arch linux forum
https://bbs.archlinux.org/viewtopic.php?pid=1108289 Different users
have the same issue (It seem to appears also on ubuntu or other linux
distribution but I have not tested them). The main issue with this
issue is that it is a bit hard and random to reproduce.
- This issue seems to appear to many people with this specific model
of laptop. Some people also complains about the same issue on windows
seven. Some thinks that it is an hardware issue. I tried to run my
network stress test on the pre-installed windows seven and it runs for
many hours without any issue. The only difference was that the
observed network speed on windows is less important than on Linux, so
perhaps (this is suposition, not a fact) that linux use the network
adapter in a "high speed mode" which result in this freeze when
windows use the adapter in "low speed mode".
- I tried to set the i8042 module in debug mode by using 'echo "Y" >
/sys/module/i8042/parameters/debug'. When the keyboard frooze, I
unloaded/loaded the psmouse module. Just after this, I got in dmesg:

-------------------------
[ 3487.059560] i8042: [1046791] d4 -> i8042 (command)
[ 3487.059624] i8042: [1046791] f2 -> i8042 (parameter)
[ 3487.258907] i8042: [1046851] 60 -> i8042 (command)
[ 3487.258976] i8042: [1046851] 45 -> i8042 (parameter)
[ 3487.259140] i8042: [1046851] 60 -> i8042 (command)
[ 3487.259252] i8042: [1046851] 47 -> i8042 (parameter)
[ 3487.259262] i8042: [1046851] fa <- i8042 (interrupt, 1, 0)
[ 3487.259776] i8042: [1046851] 00 <- i8042 (interrupt, 1, 12)
[ 3487.259841] i8042: [1046851] d4 -> i8042 (command)
[ 3487.260007] i8042: [1046851] f2 -> i8042 (parameter)
[ 3487.262602] i8042: [1046852] fa <- i8042 (interrupt, 1, 12)
[ 3487.263800] i8042: [1046852] 00 <- i8042 (interrupt, 1, 12)
[ 3487.263836] i8042: [1046852] 60 -> i8042 (command)
[ 3487.263898] i8042: [1046852] 45 -> i8042 (parameter)
[ 3487.264036] i8042: [1046852] 60 -> i8042 (command)
[ 3487.264147] i8042: [1046852] 47 -> i8042 (parameter)
[ 3487.264267] i8042: [1046852] d4 -> i8042 (command)
[ 3487.264378] i8042: [1046852] f2 -> i8042 (parameter)
[ 3487.266963] i8042: [1046853] fa <- i8042 (interrupt, 1, 12)
[ 3487.268178] i8042: [1046853] 00 <- i8042 (interrupt, 1, 12)
[ 3487.268248] i8042: [1046853] d4 -> i8042 (command)
[ 3487.268468] i8042: [1046853] f6 -> i8042 (parameter)
[ 3487.271087] i8042: [1046854] fa <- i8042 (interrupt, 1, 12)
[ 3487.271115] i8042: [1046854] d4 -> i8042 (command)
[ 3487.271227] i8042: [1046854] e8 -> i8042 (parameter)
[ 3487.273818] i8042: [1046855] fa <- i8042 (interrupt, 1, 12)
[ 3487.273884] i8042: [1046855] d4 -> i8042 (command)
[ 3487.274309] i8042: [1046855] 00 -> i8042 (parameter)
[ 3487.276897] i8042: [1046856] fa <- i8042 (interrupt, 1, 12)
[ 3487.276948] i8042: [1046856] d4 -> i8042 (command)
[ 3487.277216] i8042: [1046856] e8 -> i8042 (parameter)
[ 3487.279830] i8042: [1046857] fa <- i8042 (interrupt, 1, 12)
[ 3487.279863] i8042: [1046857] d4 -> i8042 (command)
[ 3487.279975] i8042: [1046857] 00 -> i8042 (parameter)
[ 3487.282565] i8042: [1046858] fa <- i8042 (interrupt, 1, 12)
[ 3487.282606] i8042: [1046858] d4 -> i8042 (command)
[ 3487.282877] i8042: [1046858] e8 -> i8042 (parameter)
[ 3487.285499] i8042: [1046859] fa <- i8042 (interrupt, 1, 12)
[ 3487.285543] i8042: [1046859] d4 -> i8042 (command)
[ 3487.285811] i8042: [1046859] 00 -> i8042 (parameter)
[ 3487.288401] i8042: [1046859] fa <- i8042 (interrupt, 1, 12)
[ 3487.288434] i8042: [1046859] d4 -> i8042 (command)
[ 3487.288545] i8042: [1046859] e8 -> i8042 (parameter)
[ 3487.291153] i8042: [1046860] fa <- i8042 (interrupt, 1, 12)
[ 3487.291274] i8042: [1046860] d4 -> i8042 (command)
[ 3487.291438] i8042: [1046860] 00 -> i8042 (parameter)
[ 3487.294059] i8042: [1046861] fa <- i8042 (interrupt, 1, 12)
[ 3487.294129] i8042: [1046861] d4 -> i8042 (command)
[ 3487.294504] i8042: [1046861] e9 -> i8042 (parameter)
[ 3487.297138] i8042: [1046862] fa <- i8042 (interrupt, 1, 12)
[ 3487.298320] i8042: [1046862] 05 <- i8042 (interrupt, 1, 12)
[ 3487.299507] i8042: [1046863] 47 <- i8042 (interrupt, 1, 12)
[ 3487.300707] i8042: [1046863] 17 <- i8042 (interrupt, 1, 12)
[ 3487.300740] i8042: [1046863] d4 -> i8042 (command)
[ 3487.300852] i8042: [1046863] e6 -> i8042 (parameter)
[ 3487.303436] i8042: [1046864] fa <- i8042 (interrupt, 1, 12)
[ 3487.303455] i8042: [1046864] d4 -> i8042 (command)
[ 3487.303566] i8042: [1046864] e8 -> i8042 (parameter)
[ 3487.306174] i8042: [1046865] fa <- i8042 (interrupt, 1, 12)
[ 3487.306195] i8042: [1046865] d4 -> i8042 (command)
[ 3487.306307] i8042: [1046865] 00 -> i8042 (parameter)
[ 3487.308894] i8042: [1046866] fa <- i8042 (interrupt, 1, 12)
[ 3487.309352] i8042: [1046866] d4 -> i8042 (command)
[ 3487.309568] i8042: [1046866] e8 -> i8042 (parameter)
[ 3487.312206] i8042: [1046867] fa <- i8042 (interrupt, 1, 12)
[ 3487.312602] i8042: [1046867] d4 -> i8042 (command)
[ 3487.312663] i8042: [1046867] 00 -> i8042 (parameter)
[ 3487.315320] i8042: [1046867] fa <- i8042 (interrupt, 1, 12)
[ 3487.315366] i8042: [1046867] d4 -> i8042 (command)
[ 3487.315634] i8042: [1046867] e8 -> i8042 (parameter)
[ 3487.318249] i8042: [1046868] fa <- i8042 (interrupt, 1, 12)
[ 3487.318280] i8042: [1046868] d4 -> i8042 (command)
[ 3487.318392] i8042: [1046868] 00 -> i8042 (parameter)
[ 3487.320979] i8042: [1046869] fa <- i8042 (interrupt, 1, 12)
[ 3487.321042] i8042: [1046869] d4 -> i8042 (command)
[ 3487.321311] i8042: [1046869] e8 -> i8042 (parameter)
[ 3487.323914] i8042: [1046870] fa <- i8042 (interrupt, 1, 12)
[ 3487.323960] i8042: [1046870] d4 -> i8042 (command)
[ 3487.324330] i8042: [1046870] 00 -> i8042 (parameter)
[ 3487.326934] i8042: [1046871] fa <- i8042 (interrupt, 1, 12)
[ 3487.326997] i8042: [1046871] d4 -> i8042 (command)
[ 3487.327264] i8042: [1046871] f3 -> i8042 (parameter)
[ 3487.329866] i8042: [1046872] fa <- i8042 (interrupt, 1, 12)
[ 3487.329890] i8042: [1046872] d4 -> i8042 (command)
[ 3487.330001] i8042: [1046872] 14 -> i8042 (parameter)
[ 3487.332588] i8042: [1046873] fa <- i8042 (interrupt, 1, 12)
[ 3487.332691] i8042: [1046873] d4 -> i8042 (command)
[ 3487.332906] i8042: [1046873] f6 -> i8042 (parameter)
[ 3487.335517] i8042: [1046874] fa <- i8042 (interrupt, 1, 12)
[ 3487.335956] i8042: [1046874] d4 -> i8042 (command)
[ 3487.336017] i8042: [1046874] ff -> i8042 (parameter)
[ 3487.338713] i8042: [1046874] fa <- i8042 (interrupt, 1, 12)
[ 3487.442971] i8042: [1046906] Interrupt 12, without any data
-----------------------------


I tried to follow the instructions on
http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html for this
report, so tell me if I missed something in this message.

Thank you.

-- 
Guillaume
