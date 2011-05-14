Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab1ENStQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:49:16 -0400
Received: from wolff.to ([65.117.131.163]:33163 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753564Ab1ENStP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:49:15 -0400
Date: Sat, 14 May 2011 13:44:12 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: linux-kernel@vger.kernel.org
Cc: Bruno Wolff III <bruno@wolff.to>
Subject: PROBLEM: Motherboard sound + local network file transfer = hang
Message-ID: <20110514184412.GA7473@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Motherboard sound + file transfer on local network = hang.

When I have sound play through my onboard sound card (but not my usb
headset) while transfering files over the local network (typically it
doesn't happen when downloading files over my T1 connection) the system
will usually hang. This does not happen when I boot with only one CPU
active. I tried getting a kernel dump, but the system seems to hang
rather than crash and I can't get alt+sysrq+c to cause a crash once it
is hung. (It does cause crashes that result in dumps if I do it before
hanging the system.) I also tried using nmi_watchdog=1 and nmi_watchdog=2
and neither appeared to work. This is NOT new to the 2.6.38 kernel. I am
running luks encryption on top of software raid 1 for everything except
/boot.

networking sound

Linux version 2.6.38.6-26.rc1.fc15.i686.PAE (mockbuild@x86-14.phx2.fedoraproject
.org) (gcc version 4.6.0 20110428 (Red Hat 4.6.0-6) (GCC) ) #1 SMP Mon May 9 20:
36:50 UTC 2011

To test this I can usually get a hang scp'ing a large file to another machine
on the local network and hitting backspace in a terminal window to get a beep.
(I hear the beep before the system hangs.)

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux bruno.wolff.to 2.6.38.6-26.rc1.fc15.i686.PAE #1 SMP Mon May 9 20:36:50 UTC 2011 i686 i686 i386 GNU/Linux
 
Gnu C                  4.6.0
Gnu make               3.82
binutils               2.21.51.0.6
util-linux             2.19.1
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.14
jfsutils               1.1.13
reiserfsprogs          3.6.21
xfsprogs               3.1.4
pcmciautils            017
quota-tools            4.00-pre1.
PPP                    2.4.5
Linux C Library        2.13.90
Dynamic linker (ldd)   2.13.90
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
oprofile               0.9.6
Sh-utils               8.10
wireless-tools         29
Modules Loaded         fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc joydev analog xpp_usb xpp wctc4xxp dahdi_transcode wcb4xxp wctdm wcfxo wctdm24xxp wcte11xp wct1xxp wcte12xp dahdi_voicebus wct4xxp dahdi crc_ccitt ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_physdev ip6table_filter ip6_tables w83627hf hwmon_vid snd_cs4236 snd_intel8x0 snd_usb_audio snd_ac97_codec snd_wss_lib snd_usbmidi_lib snd_opl3_lib ac97_bus snd_hwdep snd_seq ppdev osst snd_pcm microcode snd_mpu401 parport_pc i2c_amd756 st snd_mpu401_uart 8139too e100 ns558 snd_rawmidi snd_seq_device snd_timer gameport parport mii snd amd_rng soundcore snd_page_alloc ipv6 sha256_generic dm_crypt raid1 pata_acpi ata_generic pata_hpt3x2n pata_pdc2027x sym53c8xx scsi_transport_spi pata_hpt37x pata_amd radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 8
model name	: AMD Athlon(tm) MP 2400+
stepping	: 1
cpu MHz		: 2000.189
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips	: 4000.37
clflush size	: 32
cache_alignment	: 32
address sizes	: 34 bits physical, 32 bits virtual
power management: ts

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 8
model name	: AMD Athlon(tm) MP
stepping	: 1
cpu MHz		: 2000.189
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips	: 3999.50
clflush size	: 32
cache_alignment	: 32
address sizes	: 34 bits physical, 32 bits virtual
power management: ts

fuse 53420 3 - Live 0xf7ead000
ebtable_nat 1463 0 - Live 0xf8ff2000
ebtables 12276 1 ebtable_nat, Live 0xf8fe0000
ipt_MASQUERADE 1716 3 - Live 0xf8fab000
iptable_nat 3782 1 - Live 0xf8f8e000
nf_nat 15509 2 ipt_MASQUERADE,iptable_nat, Live 0xf8f94000
xt_CHECKSUM 933 1 - Live 0xf8eda000
iptable_mangle 1267 1 - Live 0xf8ecb000
bridge 58981 0 - Live 0xf8e50000
stp 1399 1 bridge, Live 0xf8e33000
llc 3684 2 bridge,stp, Live 0xf8e2a000
joydev 7284 0 - Live 0xf8e1f000
analog 7130 0 - Live 0xf8e05000
xpp_usb 11973 0 - Live 0xf8df6000
xpp 136433 1 xpp_usb, Live 0xf8d93000
wctc4xxp 26986 0 - Live 0xf8d86000
dahdi_transcode 4849 1 wctc4xxp, Live 0xf8d1f000
wcb4xxp 25474 0 - Live 0xf8ce8000
wctdm 32652 3 - Live 0xf8c9d000
wcfxo 8603 0 - Live 0xf8c50000
wctdm24xxp 88780 0 - Live 0xf8735000
wcte11xp 13962 0 - Live 0xf872b000
wct1xxp 10398 0 - Live 0xf8723000
wcte12xp 19077 0 - Live 0xf8718000
dahdi_voicebus 34584 2 wctdm24xxp,wcte12xp, Live 0xf86c4000
wct4xxp 176975 0 - Live 0xf8609000
dahdi 181677 17 xpp,dahdi_transcode,wcb4xxp,wctdm,wcfxo,wctdm24xxp,wcte11xp,wct1xxp,wcte12xp,dahdi_voicebus,wct4xxp, Live 0xf85d5000
crc_ccitt 1253 2 wctdm24xxp,dahdi, Live 0xf8569000
ip6t_REJECT 3387 2 - Live 0xf855a000
nf_conntrack_ipv6 6637 2 - Live 0xf854f000
nf_defrag_ipv6 7574 1 nf_conntrack_ipv6, Live 0xf8543000
xt_physdev 1387 1 - Live 0xf8531000
ip6table_filter 1227 1 - Live 0xf8525000
ip6_tables 9798 1 ip6table_filter, Live 0xf8519000
w83627hf 19922 0 - Live 0xf8504000
hwmon_vid 1787 1 w83627hf, Live 0xf84ee000
snd_cs4236 24606 0 - Live 0xf7b40000
snd_intel8x0 23370 1 - Live 0xf7b2c000
snd_usb_audio 80961 0 - Live 0xf7ac2000
snd_ac97_codec 90719 1 snd_intel8x0, Live 0xf7ae7000
snd_wss_lib 18914 1 snd_cs4236, Live 0xf7a4f000
snd_usbmidi_lib 14806 1 snd_usb_audio, Live 0xf7a39000
snd_opl3_lib 7835 1 snd_cs4236, Live 0xf910b000
ac97_bus 934 1 snd_ac97_codec, Live 0xf90ff000
snd_hwdep 4986 2 snd_usb_audio,snd_opl3_lib, Live 0xf90f5000
snd_seq 43761 0 - Live 0xf90dd000
ppdev 6488 0 - Live 0xf90c4000
osst 42143 0 - Live 0xf90ae000
snd_pcm 63766 5 snd_cs4236,snd_intel8x0,snd_usb_audio,snd_ac97_codec,snd_wss_lib, Live 0xf9086000
microcode 11108 0 - Live 0xf905f000
snd_mpu401 5045 0 - Live 0xf902a000
parport_pc 18056 0 - Live 0xf903c000
i2c_amd756 5473 0 - Live 0xf901e000
st 27648 0 - Live 0xf900c000
snd_mpu401_uart 5100 2 snd_cs4236,snd_mpu401, Live 0xf8ff9000
8139too 22389 0 - Live 0xf8fe7000
e100 24136 0 - Live 0xf8fce000
ns558 1989 0 - Live 0xf8fbc000
snd_rawmidi 16651 2 snd_usbmidi_lib,snd_mpu401_uart, Live 0xf8fad000
snd_seq_device 5118 3 snd_opl3_lib,snd_seq,snd_rawmidi, Live 0xf8f9d000
snd_timer 15551 4 snd_wss_lib,snd_opl3_lib,snd_seq,snd_pcm, Live 0xf8f80000
gameport 7142 4 analog,ns558, Live 0xf8f90000
parport 26671 2 ppdev,parport_pc, Live 0xf8f69000
mii 3598 2 8139too,e100, Live 0xf8f4d000
snd 48042 17 snd_cs4236,snd_intel8x0,snd_usb_audio,snd_ac97_codec,snd_wss_lib,snd_usbmidi_lib,snd_opl3_lib,snd_hwdep,snd_seq,snd_pcm,snd_mpu401,snd_mpu401_uart,snd_rawmidi,snd_seq_device,snd_timer, Live 0xf8f0c000
amd_rng 1311 0 - Live 0xf8ef3000
soundcore 5039 1 snd, Live 0xf8edc000
snd_page_alloc 6176 3 snd_intel8x0,snd_wss_lib,snd_pcm, Live 0xf8ed0000
ipv6 234769 24 bridge,ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6, Live 0xf8e7e000
sha256_generic 11443 8 - Live 0xf84f2000
dm_crypt 12103 4 - Live 0xf84c8000
raid1 17242 5 - Live 0xf84b6000
pata_acpi 2363 0 - Live 0xf84a7000
ata_generic 2643 0 - Live 0xf849d000
pata_hpt3x2n 4472 0 - Live 0xf8179000
pata_pdc2027x 4860 0 - Live 0xf7eca000
sym53c8xx 59715 0 - Live 0xf7ee7000
scsi_transport_spi 17542 1 sym53c8xx, Live 0xf7ea6000
pata_hpt37x 9032 10 - Live 0xf7e98000
pata_amd 7892 0 - Live 0xf7e77000
radeon 624552 2 - Live 0xf7bb0000
ttm 46023 1 radeon, Live 0xf7ad9000
drm_kms_helper 24432 1 radeon, Live 0xf7aba000
drm 152647 4 radeon,ttm,drm_kms_helper, Live 0xf7a7b000
i2c_algo_bit 4214 1 radeon, Live 0xf7a42000
i2c_core 21344 5 i2c_amd756,radeon,drm_kms_helper,drm,i2c_algo_bit, Live 0xf7a31000

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
0170-0177 : 0000:00:07.1
  0170-0177 : pata_amd
01f0-01f7 : 0000:00:07.1
  01f0-01f7 : pata_amd
0200-0200 : ns558-isa
0201-0207 : ns558-pnp
0295-0296 : w83627hf
  0295-0296 : w83627hf
02f8-02ff : serial
0330-0331 : MPU401 UART
0376-0376 : 0000:00:07.1
  0376-0376 : pata_amd
0378-037a : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:07.1
  03f6-03f6 : pata_amd
03f8-03ff : serial
04d0-04d1 : pnp 00:02
0a78-0a7b : pnp 00:02
0b78-0b7b : pnp 00:02
0bbc-0bbf : pnp 00:02
0cf8-0cff : PCI conf1
0e78-0e7b : pnp 00:02
0f78-0f7b : pnp 00:02
0fbc-0fbf : pnp 00:02
5000-5003 : ACPI PM1a_EVT_BLK
5004-5005 : ACPI PM1a_CNT_BLK
5008-500b : ACPI PM_TMR
5020-5023 : ACPI GPE0_BLK
50e0-50ef : amd756_smbus
8000-afff : PCI Bus 0000:02
  8000-80ff : 0000:02:05.0
    8000-80ff : sym53c8xx
  8400-84ff : 0000:02:05.1
    8400-84ff : sym53c8xx
  8800-88ff : 0000:02:06.0
    8800-88ff : 8139too
  8c00-8c3f : 0000:02:07.0
    8c00-8c3f : e100
  9000-9007 : 0000:02:08.0
  9400-9403 : 0000:02:08.0
  9800-9807 : 0000:02:08.0
  9c00-9c03 : 0000:02:08.0
  a000-a00f : 0000:02:08.0
b000-bfff : PCI Bus 0000:01
  b000-b0ff : 0000:01:05.0
c000-c0ff : 0000:00:07.5
  c000-c0ff : AMD AMD768
c400-c43f : 0000:00:07.5
  c400-c43f : AMD AMD768
d000-d0ff : 0000:00:08.0
  d000-d0fe : wctdm
d400-d407 : 0000:00:09.0
  d400-d407 : pata_hpt37x
d800-d803 : 0000:00:09.0
  d800-d803 : pata_hpt37x
dc00-dc07 : 0000:00:09.0
  dc00-dc07 : pata_hpt37x
e000-e003 : 0000:00:09.0
  e000-e003 : pata_hpt37x
e400-e4ff : 0000:00:09.0
  e400-e4ff : pata_hpt37x
e800-e803 : 0000:00:00.0
f000-f00f : 0000:00:07.1
  f000-f00f : pata_amd

00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000d0000-000d21ff : Adapter ROM
000d3000-000d37ff : Adapter ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  00400000-007ef341 : Kernel code
  007ef342-00a71bff : Kernel data
  00b09000-00bfffff : Kernel bss
  18000000-1fffffff : Crash kernel
7fff0000-7fff2fff : ACPI Non-volatile Storage
7fff3000-7fffffff : ACPI Tables
80000000-800fffff : PCI Bus 0000:02
  80000000-8000ffff : 0000:02:05.0
  80010000-8001ffff : 0000:02:05.1
  80020000-8002ffff : 0000:02:07.0
80100000-8011ffff : 0000:00:09.0
d0000000-dfffffff : 0000:00:00.0
e0000000-efffffff : PCI Bus 0000:01
  e0000000-e7ffffff : 0000:01:05.0
  e8000000-efffffff : 0000:01:05.1
f0000000-f1ffffff : PCI Bus 0000:01
  f0000000-f001ffff : 0000:01:05.0
  f1000000-f100ffff : 0000:01:05.0
  f1010000-f101ffff : 0000:01:05.1
f3000000-f4ffffff : PCI Bus 0000:02
  f4000000-f401ffff : 0000:02:07.0
    f4000000-f401ffff : e100
  f4020000-f4023fff : 0000:02:08.0
    f4020000-f4023fff : pata_pdc2027x
  f4024000-f4024fff : 0000:02:00.0
    f4024000-f4024fff : ohci_hcd
  f4025000-f40250ff : 0000:02:05.1
    f4025000-f40250ff : sym53c8xx
  f4026000-f4026fff : 0000:02:05.1
    f4026000-f4026fff : sym53c8xx
  f4027000-f40270ff : 0000:02:06.0
    f4027000-f40270ff : 8139too
  f4028000-f4028fff : 0000:02:07.0
    f4028000-f4028fff : e100
  f4029000-f40290ff : 0000:02:05.0
    f4029000-f40290ff : sym53c8xx
  f402a000-f402afff : 0000:02:05.0
    f402a000-f402afff : sym53c8xx
f5000000-f5000fff : 0000:00:00.0
f5001000-f5001fff : 0000:00:08.0
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fee00000-fee00fff : Local APIC

00:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P] System Controller (rev 11)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 32
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 1: Memory at f5000000 (32-bit, prefetchable) [size=4K]
	Region 2: I/O ports at e800 [disabled] [size=4]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=16 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
	Kernel driver in use: agpgart-amdk7
	Kernel modules: amd76x_edac

00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P] AGP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: f0000000-f1ffffff
	Prefetchable memory behind bridge: e0000000-efffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ISA (rev 05)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-768 [Opus] IDE (rev 04) (prog-if 8a [Master SecP PriP])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at f000 [size=16]
	Kernel driver in use: pata_amd
	Kernel modules: pata_amd

00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ACPI (rev 03)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: amd756_smbus
	Kernel modules: i2c-amd756, amd-rng

00:07.5 Multimedia audio controller: Advanced Micro Devices [AMD] AMD-768 [Opus] Audio (rev 03)
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at c000 [size=256]
	Region 1: I/O ports at c400 [size=64]
	Kernel driver in use: Intel ICH
	Kernel modules: snd-intel8x0

00:08.0 Communication controller: Tiger Jet Network Inc. Tiger3XX Modem/ISDN interface
	Subsystem: Device b1d9:0003
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (250ns min, 32000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at d000 [size=256]
	Region 1: Memory at f5001000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2+ AuxCurrent=55mA PME(D0+,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: wctdm
	Kernel modules: wctdm, hisax, netjet

00:09.0 RAID bus controller: HighPoint Technologies, Inc. HPT302/302N (rev 01)
	Subsystem: HighPoint Technologies, Inc. Device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 120 (2000ns min, 2000ns max)
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at d400 [size=8]
	Region 1: I/O ports at d800 [size=4]
	Region 2: I/O ports at dc00 [size=8]
	Region 3: I/O ports at e000 [size=4]
	Region 4: I/O ports at e400 [size=256]
	[virtual] Expansion ROM at 80100000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_hpt37x
	Kernel modules: pata_hpt3x2n, pata_hpt37x

00:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] PCI (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 32
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 00008000-0000afff
	Memory behind bridge: f3000000-f4ffffff
	Prefetchable memory behind bridge: 80000000-800fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

01:05.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200] (rev 01) (prog-if 00 [VGA controller])
	Subsystem: C.P. Technology Co. Ltd Device 2062
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at b000 [size=256]
	Region 2: Memory at f1000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at f0000000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=80 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: radeon
	Kernel modules: radeon, radeonfb

01:05.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200] (Secondary) (rev 01)
	Subsystem: C.P. Technology Co. Ltd Device 2063
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at f1010000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

02:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-768 [Opus] USB (rev 07) (prog-if 10 [OHCI])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f4024000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

02:05.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 37)
	Subsystem: LSI Logic / Symbios Logic LSI22801 PCI to Dual Channel Ultra SCSI host adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 72 (4250ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 8000 [size=256]
	Region 1: Memory at f4029000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at f402a000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 80000000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sym53c8xx
	Kernel modules: sym53c8xx

02:05.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 37)
	Subsystem: LSI Logic / Symbios Logic LSI22801 PCI to Dual Channel Ultra SCSI host adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 72 (4250ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 18
	Region 0: I/O ports at 8400 [size=256]
	Region 1: Memory at f4025000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at f4026000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 80010000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sym53c8xx
	Kernel modules: sym53c8xx

02:06.0 Ethernet controller: D-Link System Inc RTL8139 Ethernet (rev 10)
	Subsystem: D-Link System Inc DFE-530TX+ 10/100 Ethernet Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 8800 [size=256]
	Region 1: Memory at f4027000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: 8139too
	Kernel modules: 8139too

02:07.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 0d)
	Subsystem: Intel Corporation EtherExpress PRO/100 Server Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f4028000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at 8c00 [size=64]
	Region 2: Memory at f4000000 (32-bit, non-prefetchable) [size=128K]
	[virtual] Expansion ROM at 80020000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: e100
	Kernel modules: e100

02:08.0 RAID bus controller: Promise Technology, Inc. PDC20276 (MBFastTrak133 Lite) (rev 01) (prog-if 85)
	Subsystem: Giga-byte Technology MBUltra 133
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 4500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 9000 [size=8]
	Region 1: I/O ports at 9400 [size=4]
	Region 2: I/O ports at 9800 [size=8]
	Region 3: I/O ports at 9c00 [size=4]
	Region 4: I/O ports at a000 [size=16]
	Region 5: Memory at f4020000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [60] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_pdc2027x
	Kernel modules: pata_pdc2027x

Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: IDE      Model: DVD-ROM 16X      Rev: 2.97
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 03 Lun: 00
  Vendor: HP       Model: HP35470A         Rev: T503
  Type:   Sequential-Access                ANSI  SCSI revision: 02
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: _NEC     Model: DVD_RW ND-1300A  Rev: 1.0C
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3200JB-00K Rev: 08.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3200JB-00K Rev: 08.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05

dahdi is built locally from source. The problem happens even if I don't
have dahdi loaded.
