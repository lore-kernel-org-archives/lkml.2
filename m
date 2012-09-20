Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2ITRGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:06:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51859 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2ITRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:06:07 -0400
MIME-Version: 1.0
Date: Thu, 20 Sep 2012 19:06:04 +0200
Message-ID: <CAG3eYYRTm=ZgEJvjYLe4cN1VJr+Hia6pkSfSPgWO_UvXt1Dshg@mail.gmail.com>
Subject: PROBLEM: machine hung after a struggle with oom
From: =?UTF-8?B?UMOpdGVyIEFuZHLDoXMgRmVsdsOpZ2k=?= <petschy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b343db6794a3804ca252383
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b343db6794a3804ca252383
Content-Type: text/plain; charset=UTF-8

Hello,

my machine hung today after some serious disk trashing caused by out
of memory contition(s).

I didn't do anything unusual. There was an xtem window with a few
tabs, iceweasel/firefox, chromium and codelite running. I already
worked for some hours, started a build, then in the middle of it, the
disk (sdb, where the 2G swap partition is) started working real
intesively. This was unlikely, because the system and my home dir is
on ssd / btrfs (sda) for a few months now, so normally things go
quietly.

The system started struggling, the mouse moved really slow, pressing
the num-lock and seeing the results on the led had quite some lag
(3-14 secs). Tried to switch back to console via ctrl-alt-f1, after
quite a few seconds it did switch, where I saw an oops regarding some
btrfs extent function.

Switched back to X, took a few minutes to get back the title/border of
the topmost window. Meanwhile, 3 small windows appeared slowly (the
disk was still trashing like hell) notifying about an oops, and
waiting for action. The mouse moved pixel-by-pixel, was useless. Then,
after about 15 minutes, the disk stopped working, and silence set in.
Num-lock and the kb in general wasn't responding, nor the mouse. Tried
to unplug the kb and plug in an usb one, but no luck. Tried to ping
the machine, it was unreachable. After a few minutes I pulled the
plug. At reboot, I was informed about some orphaned inodes, but that
was all, the system is up and running since then.

I don't know what triggered the swapping. From the logs it seems that
the chromium processes were the first victims, but I wasn't using the
browser, I was compiling my project. I haven't experienced any similar
behaviour recently. I had plenty of free space on the btrfs partition
(22G used out of 200G). I attached the relevant part from the kern.log
(starting from the first oom and ending at the reboot), also I'm
providing the info required for bug reports, hope that helps.

Kind regards, Peter


$ sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux lobster 3.5.3 #10 SMP Thu Sep 6 12:25:33 CEST 2012 x86_64 GNU/Linux

Gnu C                  4.7
Gnu make               3.81
binutils               2.22
util-linux             scripts/ver_linux: 23: scripts/ver_linux:
fdformat: not found
mount                  support
module-init-tools      found
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.3.3
Kbd                    1.15.3
Sh-utils               8.13
Modules Loaded         snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq
crc32c_intel ghash_clmulni_intel snd_seq_device aesni_intel snd_timer
aes_x86_64 snd k10temp fam15h_power aes_generic cryptd edac_mce_amd
edac_core nouveau soundcore video i2c_piix4 mxm_wmi drm_kms_helper ttm
evdev wmi usbhid r8169 mii

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8120 Eight-Core Processor
stepping	: 2
microcode	: 0x6000626
cpu MHz		: 3624.392
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes
xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr
topoext perfctr_core arat cpb hw_pstate npt lbrv svm_lock nrip_save
tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7248.78
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm 100mhzsteps hwpstate cpb

[7 other cores omitted]

$ cat /proc/modules
snd_hda_codec_realtek 67064 1 - Live 0xffffffffa016c000
snd_hda_intel 30220 4 - Live 0xffffffffa0289000
snd_hda_codec 90583 2 snd_hda_codec_realtek,snd_hda_intel, Live
0xffffffffa0264000
snd_hwdep 13148 1 snd_hda_codec, Live 0xffffffffa0248000
snd_pcm_oss 44847 0 - Live 0xffffffffa0258000
snd_mixer_oss 22044 3 snd_pcm_oss, Live 0xffffffffa024d000
snd_pcm 75438 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xffffffffa022f000
snd_page_alloc 17065 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0212000
snd_seq_midi 12848 0 - Live 0xffffffffa0226000
snd_seq_midi_event 13316 1 snd_seq_midi, Live 0xffffffffa01fa000
snd_rawmidi 26914 1 snd_seq_midi, Live 0xffffffffa021e000
snd_seq 52897 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa0204000
crc32c_intel 12747 0 - Live 0xffffffffa0219000
ghash_clmulni_intel 12981 0 - Live 0xffffffffa01ff000
snd_seq_device 13132 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa01e7000
aesni_intel 50435 0 - Live 0xffffffffa01ec000
snd_timer 26606 2 snd_pcm,snd_seq, Live 0xffffffffa01df000
aes_x86_64 16796 1 aesni_intel, Live 0xffffffffa01d9000
snd 60845 15 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0xffffffffa01c9000
k10temp 12618 0 - Live 0xffffffffa01c4000
fam15h_power 12597 0 - Live 0xffffffffa01bf000
aes_generic 33026 2 aesni_intel,aes_x86_64, Live 0xffffffffa01ac000
cryptd 14560 2 ghash_clmulni_intel,aesni_intel, Live 0xffffffffa0067000
edac_mce_amd 21093 0 - Live 0xffffffffa0165000
edac_core 43036 0 - Live 0xffffffffa0159000
nouveau 843331 2 - Live 0xffffffffa006c000
soundcore 13026 3 snd, Live 0xffffffffa0154000
video 17631 1 nouveau, Live 0xffffffffa0061000
i2c_piix4 12536 0 - Live 0xffffffffa0017000
mxm_wmi 12473 1 nouveau, Live 0xffffffffa004d000
drm_kms_helper 35294 1 nouveau, Live 0xffffffffa0057000
ttm 61344 1 nouveau, Live 0xffffffffa003d000
evdev 17406 15 - Live 0xffffffffa0029000
wmi 17339 2 nouveau,mxm_wmi, Live 0xffffffffa0033000
usbhid 44463 0 - Live 0xffffffffa001d000
r8169 58988 0 - Live 0xffffffffa0007000
mii 12675 1 r8169, Live 0xffffffffa0000000

$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0073 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0220-0225 : pnp 00:01
  0228-022f : pnp 00:02
  0290-0294 : pnp 00:01
  03c0-03df : vga+
  03f8-03ff : serial
  040b-040b : pnp 00:02
  04d0-04d1 : pnp 00:01
  04d6-04d6 : pnp 00:02
  0800-08fe : pnp 00:02
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-0827 : ACPI GPE0_BLK
    0850-0850 : ACPI PM2_CNT_BLK
  0900-091f : pnp 00:02
  0a10-0a17 : pnp 00:02
  0b00-0b0f : pnp 00:02
  0b10-0b1f : pnp 00:02
  0b20-0b3f : pnp 00:02
  0c00-0c01 : pnp 00:02
  0c14-0c14 : pnp 00:02
  0c50-0c52 : pnp 00:02
  0c6c-0c6d : pnp 00:02
  0c6f-0c6f : pnp 00:02
  0cd0-0cd1 : pnp 00:02
  0cd2-0cd3 : pnp 00:02
  0cd4-0cdf : pnp 00:02
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  9000-9fff : PCI Bus 0000:06
  a000-afff : PCI Bus 0000:05
    af00-af7f : 0000:05:0e.0
  b000-bfff : PCI Bus 0000:01
  c000-cfff : PCI Bus 0000:04
  d000-dfff : PCI Bus 0000:03
    de00-deff : 0000:03:00.0
      de00-deff : r8169
  e000-efff : PCI Bus 0000:02
  fb00-fb0f : 0000:00:11.0
    fb00-fb0f : ahci
  fc00-fc03 : 0000:00:11.0
    fc00-fc03 : ahci
  fd00-fd07 : 0000:00:11.0
    fd00-fd07 : ahci
  fe00-fe03 : 0000:00:11.0
    fe00-fe03 : ahci
  ff00-ff07 : 0000:00:11.0
    ff00-ff07 : ahci

$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-00091fff : System RAM
00092000-0009f7ff : RAM buffer
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
  000c0000-000c7fff : Video ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cfd9ffff : System RAM
  01000000-01613166 : Kernel code
  01613167-01872b7f : Kernel data
  01902000-0198efff : Kernel bss
  c4000000-c7ffffff : GART
cfda0000-cfdd0fff : ACPI Non-volatile Storage
cfdd1000-cfdfffff : ACPI Tables
cfe00000-cfefffff : reserved
  cfe00000-cfefffff : pnp 00:0b
cff00000-cfffffff : RAM buffer
d0000000-febfffff : PCI Bus 0000:00
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:00.0
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : reserved
      e0000000-efffffff : pnp 00:0a
  fa000000-fcffffff : PCI Bus 0000:01
    fa000000-faffffff : 0000:01:00.0
    fb000000-fbffffff : 0000:01:00.0
    fc000000-fc01ffff : 0000:01:00.0
  fd500000-fd5fffff : PCI Bus 0000:03
  fd600000-fd6fffff : PCI Bus 0000:02
  fd700000-fd7fffff : PCI Bus 0000:06
  fd800000-fd8fffff : PCI Bus 0000:06
  fd900000-fd9fffff : PCI Bus 0000:02
    fd9f8000-fd9fffff : 0000:02:00.0
      fd9f8000-fd9fffff : xhci_hcd
  fda00000-fdafffff : PCI Bus 0000:05
  fdb00000-fdbfffff : PCI Bus 0000:05
    fdbff000-fdbff7ff : 0000:05:0e.0
  fdc00000-fdcfffff : PCI Bus 0000:04
  fdd00000-fddfffff : PCI Bus 0000:04
    fddf8000-fddfffff : 0000:04:00.0
      fddf8000-fddfffff : xhci_hcd
  fde00000-fdefffff : PCI Bus 0000:03
    fdef8000-fdefbfff : 0000:03:00.0
      fdef8000-fdefbfff : r8169
    fdeff000-fdefffff : 0000:03:00.0
      fdeff000-fdefffff : r8169
  fdff4000-fdff7fff : 0000:00:14.2
    fdff4000-fdff7fff : ICH HD audio
  fdff8000-fdff80ff : 0000:00:16.2
    fdff8000-fdff80ff : ehci_hcd
  fdff9000-fdff9fff : 0000:00:16.0
    fdff9000-fdff9fff : ohci_hcd
  fdffa000-fdffafff : 0000:00:14.5
    fdffa000-fdffafff : ohci_hcd
  fdffb000-fdffb0ff : 0000:00:13.2
    fdffb000-fdffb0ff : ehci_hcd
  fdffc000-fdffcfff : 0000:00:13.0
    fdffc000-fdffcfff : ohci_hcd
  fdffd000-fdffd0ff : 0000:00:12.2
    fdffd000-fdffd0ff : ehci_hcd
  fdffe000-fdffefff : 0000:00:12.0
    fdffe000-fdffefff : ohci_hcd
  fdfff000-fdfff3ff : 0000:00:11.0
    fdfff000-fdfff3ff : ahci
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fec30000-fec33fff : amd_iommu
  fed00000-fed003ff : HPET 0
  fed40000-fed44fff : PCI Bus 0000:00
  fee00000-fee00fff : Local APIC
    fee00400-fee00fff : pnp 00:02
  fff80000-fffeffff : pnp 00:0b
  ffff0000-ffffffff : pnp 00:0b
100000000-22effffff : System RAM
22f000000-22fffffff : RAM buffer

# lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to
PCI bridge (external gfx0 port B) (rev 02)
	Subsystem: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI
bridge (external gfx0 port B)
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Region 3: Memory at <ignored> (64-bit, non-prefetchable)
	Capabilities: [f0] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=20 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit
DwFcInEn- LWO=8bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: [d]
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [70] MSI: Enable- Count=1/4 Maskable- 64bit-
		Address: 00000000  Data: 0000

00:00.2 IOMMU: Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory
Management Unit (IOMMU)
	Subsystem: Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory
Management Unit (IOMMU)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx+
	Interrupt: pin A routed to IRQ 40
	Capabilities: [40] Secure device <?>
	Capabilities: [54] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 4151
	Capabilities: [64] HyperTransport: MSI Mapping Enable+ Fixed+

00:02.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to
PCI bridge (PCI express gpp port B) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fa000000-fcffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort+
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #2, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:04.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to
PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fd900000-fd9fffff
	Prefetchable memory behind bridge: 00000000fd600000-00000000fd6fffff
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
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:09.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to
PCI bridge (PCI express gpp port H) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fd500000-fd5fffff
	Prefetchable memory behind bridge: 00000000fde00000-00000000fdefffff
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
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #9, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to
PCI bridge (external gfx1 port A) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fdd00000-fddfffff
	Prefetchable memory behind bridge: 00000000fdc00000-00000000fdcfffff
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
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #10, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI Device 5a14
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [190 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
	Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40) (prog-if 01
[AHCI 1.0])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at ff00 [size=8]
	Region 1: I/O ports at fe00 [size=4]
	Region 2: I/O ports at fd00 [size=8]
	Region 3: I/O ports at fc00 [size=4]
	Region 4: I/O ports at fb00 [size=16]
	Region 5: Memory at fdfff000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] SATA HBA v1.0 InCfgSpace
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fdffe000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fdffd000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fdffc000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fdffb000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus
Controller (rev 42)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00
Azalia (Intel HDA) (rev 40)
	Subsystem: Giga-byte Technology Device a002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fdff4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
	Subsystem: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC
host controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to
PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fdb00000-fdbfffff
	Prefetchable memory behind bridge: fda00000-fdafffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fdffa000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal
decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: fd800000-fd8fffff
	Prefetchable memory behind bridge: 00000000fd700000-00000000fd7fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #247, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
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
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fdff9000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:16.2 USB controller: Advanced Micro Devices [AMD] nee ATI
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fdff8000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor
Function 0
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn+ ExtCTL- 64b+
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit
DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [d]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor
Function 1
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor
Function 2
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor
Function 3
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor
Function 4
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: fam15h_power

00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor
Function 5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: NVIDIA Corporation NV44 [GeForce
6200 TurboCache(TM)] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 81ae
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at fb000000 (64-bit, non-prefetchable) [size=16M]
	[virtual] Expansion ROM at fc000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<1us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Kernel driver in use: nouveau

02:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host
Controller (rev 01) (prog-if 30 [XHCI])
	Subsystem: Giga-byte Technology Device 5007
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at fd9f8000 (64-bit, non-prefetchable) [size=32K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable+ Count=1/4 Maskable+ 64bit+
		Address: 00000000feeff00c  Data: 4161
		Masking: 0000000e  Pending: 00000000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
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
	Capabilities: [190 v1] Device Serial Number 01-01-01-01-01-01-01-01
	Kernel driver in use: xhci_hcd

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
	Subsystem: Giga-byte Technology GA-EP45-DS5/GA-EG45M-DS2H Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: I/O ports at de00 [size=256]
	Region 2: Memory at fdeff000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at fdef8000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 4171
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
		Unknown small resource type 00, will not decode more.
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
	Capabilities: [160 v1] Device Serial Number 12-34-56-78-12-34-56-78
	Kernel driver in use: r8169

04:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host
Controller (rev 01) (prog-if 30 [XHCI])
	Subsystem: Giga-byte Technology Device 5007
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at fddf8000 (64-bit, non-prefetchable) [size=32K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable+ Count=1/4 Maskable+ 64bit+
		Address: 00000000feeff00c  Data: 4169
		Masking: 0000000e  Pending: 00000000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
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
	Capabilities: [190 v1] Device Serial Number 01-01-01-01-01-01-01-01
	Kernel driver in use: xhci_hcd

05:0e.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire
II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology GA-7VT600-1394 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at fdbff000 (32-bit, non-prefetchable) [size=2K]
	Region 1: I/O ports at af00 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

--047d7b343db6794a3804ca252383
Content-Type: application/x-gzip; name="20120920-kernel.log.gz"
Content-Disposition: attachment; filename="20120920-kernel.log.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7c3u7br0

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
--047d7b343db6794a3804ca252383--
