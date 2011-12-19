Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1LSSC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:02:27 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50879 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1LSSCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:02:25 -0500
MIME-Version: 1.0
Date: Mon, 19 Dec 2011 20:02:23 +0200
Message-ID: <CALMby5ZnkekaoMfEke-3R6SmWU5Q=YJCW4k-t3EYk98+9WnyFQ@mail.gmail.com>
Subject: Bug
From: =?KOI8-U?B?98/Mz8TJzcnSIO/T1MHQ?= <volodymyr.ostap@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[1. ] copy data from USB flash drive hungs-up the PC or router

[2.] If user copy data from USB flash drive CPU load is going to 100% by kernel.

Test CPU usage, 1 core, router with USB
-------------------------------------
CPU idle: 98.0% user: 0.0% kernel: 2.0% [sys: 1.0% hardirq: 0.0%
softirq: 1.0%] iowait : 0.0% steal: 0.0% Period: 1.0
CPU idle: 99.0% user: 1.0% kernel: 0.0% [sys: 0.0% hardirq: 0.0%
softirq: 0.0%] iowait : 0.0% steal: 0.0% Period: 1.0
cat dev/sda > dev/null
CPU idle: 70.3% user: 1.0% kernel: 16.8% [sys: 13.9% hardirq: 0.0%
softirq: 3.0%] iowait : 11.9% steal: 0.0% Period: 1.0
CPU idle: 0.0% user: 2.0% kernel: 53.0% [sys: 45.0% hardirq: 1.0%
softirq: 7.0%] iowait : 45.0% steal: 0.0% Period: 1.0
CPU idle: 0.0% user: 1.0% kernel: 55.0% [sys: 47.0% hardirq: 1.0%
softirq: 7.0%] iowait : 44.0% steal: 0.0% Period: 1.0

It is OK if you don't like to work with this router.

But, If you try to work with some software in user space you will be
disappointed. Kernel doesn't free CPU for user space at all.

CPU is fully occupied by URB kernel mechanism.


Test CPU usage, 2 core, PC
-------------------------------------

06:57:10 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
06:57:11 PM     all      0.99      0.00      0.50      0.00      0.00     98.51
06:57:11 PM       0      1.01      0.00      0.00      0.00      0.00     98.99
06:57:11 PM       1      0.97      0.00      0.97      0.00      0.00     98.06

06:57:11 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
06:57:12 PM     all      2.96      0.00      2.96     10.84      0.00     83.25
06:57:12 PM       0      1.98      0.00      4.95     10.89      0.00     82.18
06:57:12 PM       1      3.92      0.00      0.98     11.76      0.00     83.33

cat dev/sda > dev/null

06:57:12 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
06:57:13 PM     all      1.96      0.00      4.41     45.10      0.00     48.53
06:57:13 PM       0      0.00      0.00      5.00     47.00      0.00     48.00
06:57:13 PM       1      3.85      0.00      4.81     42.31      0.00     49.04

06:57:13 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
06:57:14 PM     all      1.97      0.00      2.96     48.28      0.00     46.80
06:57:14 PM       0      2.00      0.00      2.00     22.00      0.00     74.00
06:57:14 PM       1      1.90      0.00      3.81     73.33      0.00     20.95

06:57:14 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
06:57:15 PM     all      7.32      0.00      6.34     42.44      0.00     43.90
06:57:15 PM       0     10.89      0.00      2.97     35.64      0.00     50.50
06:57:15 PM       1      3.88      0.00      9.71     49.51      0.00     36.89

06:57:15 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
06:57:16 PM     all      1.47      0.00      2.94     46.57      0.00     49.02
06:57:16 PM       0      2.02      0.00      2.02     60.61      0.00     35.35
06:57:16 PM       1      1.87      0.00      3.74     32.71      0.00     61.68

It seems like power of 1 core is occupied by URB mechanism.

[3. ] Keywords: URB, USB, kernel, driver:

[4.] Kernel version (from /proc/version):

1 core router:

Linux version 2.6.21.5 #1 Fri Dec 16 20:04:52 EET 2011

For 2 core router:

Linux version 2.6.32-5-686 (Debian 2.6.32-28) (ben@decadent.org.uk)
(gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Thu Nov 25 18:43:34 UTC
2010


[6.] A small shell script or example program which triggers the

- sar -P 1 100 in another console

- execute cat /dev/sda > /dev/null in one terminal

[7.] Environment

[7.1.] Software (add the output of the ver_linux script here)

1 Core CPU board: script cannot be executed.

2 Core CPU PC:

If some fields are empty or look unusual you may have an old version.

Compare to the current minimal requirements in Documentation/Changes.

Linux volodymyro 2.6.32-5-686 #1 SMP Thu Nov 25 18:43:34 UTC 2010 i686 GNU/Linux

Gnu C                  4.4.6-11)
Gnu make               3.81
binutils               Binutils
util-linux             2.17.2
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.12
reiserfsprogs          3.6.21
xfsprogs               3.1.4
Linux C Library        > libc.2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.5
wireless-tools         30
Modules Loaded         usb_storage vboxnetadp vboxnetflt vboxdrv
parport_pc ppdev lp parport sco bnep rfcomm l2cap crc16 bluetooth
rfkill nfs lockd fscache nfs_acl auth_rpcgss sunrpc uinput fuse ext3
jbd mbcache loop snd_hda_codec_intelhdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec uvcvideo snd_usb_audio videodev
snd_pcm_oss snd_mixer_oss snd_usb_lib v4l1_compat snd_pcm snd_hwdep
snd_seq_midi pl2303 snd_rawmidi usbserial snd_seq_midi_event i915
snd_seq drm_kms_helper drm snd_timer i2c_algo_bit snd_seq_device
i2c_core snd wmi button soundcore snd_page_alloc evdev psmouse pcspkr
serio_raw processor video output reiserfs usbhid hid sd_mod crc_t10dif
ehci_hcd ahci libata r8169 mii scsi_mod thermal thermal_sys usbcore
nls_base e1000e

[7.2.] Processor information (from /proc/cpuinfo):

1 Core router:

system type             : 96362ADVNgr
processor               : 0
cpu model               : Broadcom4350 V7.0
BogoMIPS                : 398.33
wait instruction        : yes
microsecond timers      : yes
tlb_entries             : 32
extra interrupt vector  : no
hardware watchpoint     : no
ASEs implemented        :
VCED exceptions         : not available
VCEI exceptions         : not available

2 Core PC:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 37
model name      : Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz
stepping        : 2
cpu MHz         : 3199.968
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc
aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 6399.93
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 37
model name      : Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz
stepping        : 2
cpu MHz         : 3199.968
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 2
cpu cores       : 2
apicid          : 4
initial apicid  : 4
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc
aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 6399.78
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):

2 Core PC

usb_storage 30541 0 - Live 0xfbfca000
vboxnetadp 5591 0 - Live 0xf7fa5000
vboxnetflt 15404 0 - Live 0xf7f7c000
vboxdrv 151314 2 vboxnetadp,vboxnetflt, Live 0xf7f2e000
parport_pc 15799 0 - Live 0xf7eb7000
ppdev 4058 0 - Live 0xf7ea6000
lp 5570 0 - Live 0xf7e9a000
parport 22554 3 parport_pc,ppdev,lp, Live 0xf7e87000
sco 5857 2 - Live 0xf7e72000
bnep 7444 2 - Live 0xf7e63000
rfcomm 25171 0 - Live 0xf7e4e000
l2cap 21705 6 bnep,rfcomm, Live 0xf7e29000
crc16 1027 1 l2cap, Live 0xf7e15000
bluetooth 36319 6 sco,bnep,rfcomm,l2cap, Live 0xf7dec000
rfkill 10264 2 bluetooth, Live 0xf7dc5000
nfs 206978 1 - Live 0xf7d78000
lockd 49437 1 nfs, Live 0xf7d13000
fscache 24662 1 nfs, Live 0xf7ced000
nfs_acl 1695 1 nfs, Live 0xf7cd7000
auth_rpcgss 25268 1 nfs, Live 0xf7cc5000
sunrpc 134748 8 nfs,lockd,nfs_acl,auth_rpcgss, Live 0xf7c49000
uinput 4796 1 - Live 0xf9a90000
fuse 43829 1 - Live 0xf9a77000
ext3 94204 1 - Live 0xf9a39000
jbd 32169 1 ext3, Live 0xf9a03000
mbcache 3762 1 ext3, Live 0xf99ec000
loop 9765 0 - Live 0xf99cd000
snd_hda_codec_intelhdmi 9027 1 - Live 0xf979c000
snd_hda_codec_realtek 163194 1 - Live 0xf9767000
snd_hda_intel 16787 2 - Live 0xf970d000
snd_hda_codec 46002 3
snd_hda_codec_intelhdmi,snd_hda_codec_realtek,snd_hda_intel, Live
0xf96ea000
uvcvideo 45342 0 - Live 0xf96c0000
snd_usb_audio 50670 0 - Live 0xf9695000
videodev 25545 1 uvcvideo, Live 0xf966c000
snd_pcm_oss 28671 0 - Live 0xf9652000
snd_mixer_oss 10461 1 snd_pcm_oss, Live 0xf963d000
snd_usb_lib 11156 1 snd_usb_audio, Live 0xf8f71000
v4l1_compat 10250 2 uvcvideo,videodev, Live 0xf8f5b000
snd_pcm 47226 4 snd_hda_intel,snd_hda_codec,snd_usb_audio,snd_pcm_oss,
Live 0xf8f3b000
snd_hwdep 4054 2 snd_hda_codec,snd_usb_audio, Live 0xf8f1e000
snd_seq_midi 3576 0 - Live 0xf8afd000
pl2303 11624 1 - Live 0xf8f0b000
snd_rawmidi 12513 2 snd_usb_lib,snd_seq_midi, Live 0xf8af2000
usbserial 21847 3 pl2303, Live 0xf8ab5000
snd_seq_midi_event 3684 1 snd_seq_midi, Live 0xf8aa1000
i915 222064 2 - Live 0xf884c000
snd_seq 35463 2 snd_seq_midi,snd_seq_midi_event, Live 0xf87eb000
drm_kms_helper 18301 1 i915, Live 0xf87ce000
drm 112088 3 i915,drm_kms_helper, Live 0xf8796000
snd_timer 12258 2 snd_pcm,snd_seq, Live 0xf875c000
i2c_algo_bit 3497 1 i915, Live 0xf874d000
snd_seq_device 3673 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8743000
i2c_core 12696 5 videodev,i915,drm_kms_helper,drm,i2c_algo_bit, Live 0xf8733000
snd 34375 17 snd_hda_codec_intelhdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_usb_audio,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_hwdep,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xf8716000
wmi 3575 0 - Live 0xf86fd000
button 3598 1 i915, Live 0xf86ed000
soundcore 3450 1 snd, Live 0xf86e1000
snd_page_alloc 5045 2 snd_hda_intel,snd_pcm, Live 0xf86d5000
evdev 5609 15 - Live 0xf86c8000
psmouse 44657 0 - Live 0xf86b0000
pcspkr 1207 0 - Live 0xf8697000
serio_raw 2916 0 - Live 0xf8688000
processor 26327 2 - Live 0xf85fa000
video 14605 1 i915, Live 0xf85df000
output 1204 1 video, Live 0xf85cf000
reiserfs 176190 1 - Live 0xf84d1000
usbhid 28008 0 - Live 0xf8449000
hid 50845 1 usbhid, Live 0xf8427000
sd_mod 25969 4 - Live 0xf8404000
crc_t10dif 1012 1 sd_mod, Live 0xf83f0000
ehci_hcd 27851 0 - Live 0xf83b8000
ahci 27270 3 - Live 0xf8391000
libata 115745 1 ahci, Live 0xf8352000
r8169 24860 0 - Live 0xf830f000
mii 2714 1 r8169, Live 0xf7ffe000
scsi_mod 101421 3 usb_storage,sd_mod,libata, Live 0xf824c000
thermal 9206 0 - Live 0xf8213000
thermal_sys 9378 3 processor,video,thermal, Live 0xf8202000
usbcore 98453 9
usb_storage,uvcvideo,snd_usb_audio,snd_usb_lib,pl2303,usbserial,usbhid,ehci_hcd,
Live 0xf7fc9000
nls_base 4541 1 usbcore, Live 0xf7c79000
e1000e 97725 0 - Live 0xf7f82000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)n

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vesafb
0400-041f : pnp 00:0b
0420-043f : pnp 00:0b
0440-045f : pnp 00:0b
0460-047f : pnp 00:0b
 0460-0461 : ACPI PM1b_CNT_BLK
0480-048f : pnp 00:0b
04d0-04d1 : pnp 00:0a
0cb0-0cbf : pnp 00:0a
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:30
 1100-11ff : 0000:30:00.0
   1100-11ff : r8169
2000-2fff : PCI Bus 0000:24
 2100-21ff : 0000:24:00.0
   2100-21ff : r8169
3100-311f : 0000:00:19.0
3120-313f : 0000:00:1f.2
 3120-313f : ahci
3170-3177 : 0000:00:02.0
3188-318f : 0000:00:16.3
 3188-318f : serial
3190-3197 : 0000:00:1f.2
 3190-3197 : ahci
3198-319f : 0000:00:1f.2
 3198-319f : ahci
31a8-31ab : 0000:00:1f.2
 31a8-31ab : ahci
31ac-31af : 0000:00:1f.2
 31ac-31af : ahci
4000-4fff : PCI Bus 0000:18
f800-f81f : pnp 00:0b
 f800-f803 : ACPI PM1a_EVT_BLK
 f804-f805 : ACPI PM1a_CNT_BLK
 f808-f80b : ACPI PM_TMR
 f810-f815 : ACPI CPU throttle
f820-f83f : pnp 00:0b
 f820-f82f : ACPI GPE0_BLK
f840-f85f : pnp 00:0b
f860-f87f : pnp 00:0b
fa00-fa3f : pnp 00:0b
fc00-fc7f : pnp 00:0b
fc80-fcff : pnp 00:0b
fe00-fe7f : pnp 00:0b
fe80-feff : pnp 00:0b

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Core Processor
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 36
        Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 3170 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 41d9
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915

00:16.0 Communication controller: Intel Corporation 5 Series/3400
Series Chipset HECI Controller (rev 06)
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at f042a000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000

00:16.3 Serial controller: Intel Corporation 5 Series/3400 Series
Chipset KT Controller (rev 06) (prog-if 02 [16550])
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 3188 [size=8]
        Region 1: Memory at f0424000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: serial

00:19.0 Ethernet controller: Intel Corporation 82578DM Gigabit Network
Connection (rev 05)
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 35
        Region 0: Memory at f0400000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at f0425000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at 3100 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 4142
        Capabilities: [e0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at f0427000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
High Definition Audio (rev 05)
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at f0420000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM
unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train-
SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable- ID=2 ArbSelect=Fixed TC/VC=04
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=0f ComponentID=00 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=00
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 1 (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=18, subordinate=18, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: f0700000-f08fffff
        Prefetchable memory behind bridge: 00000000f0900000-00000000f0afffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug+ Surprise+
                        Slot #0, PowerLimit 25.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4181
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 170b
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 5 (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=24, subordinate=24, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: f0600000-f06fffff
        Prefetchable memory behind bridge: 00000000f0b00000-00000000f0cfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug+ Surprise+
                        Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4189
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 170b
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport

00:1c.6 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
Express Root Port 7 (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=30, subordinate=30, sec-latency=0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: f0500000-f05fffff
        Prefetchable memory behind bridge: 00000000f0d00000-00000000f0efffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #7, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug+ Surprise+
                        Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4191
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device 170b
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at f0428000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a5)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=10, subordinate=10, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Hewlett-Packard Company Device 170b

00:1f.0 ISA bridge: Intel Corporation 3400 Series Chipset LPC
Interface Controller (rev 05)
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=10 <?>

00:1f.2 RAID bus controller: Intel Corporation 82801 SATA RAID
Controller (rev 05)
        Subsystem: Hewlett-Packard Company Device 170b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 34
        Region 0: I/O ports at 3190 [size=8]
        Region 1: I/O ports at 31a8 [size=4]
        Region 2: I/O ports at 3198 [size=8]
        Region 3: I/O ports at 31ac [size=4]
        Region 4: I/O ports at 3120 [size=32]
        Region 5: Memory at f0426000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 41c1
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
        Capabilities: [b0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ahci

24:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 32
        Region 0: I/O ports at 2100 [size=256]
        Region 2: Memory at f0600000 (64-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at f0b00000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
                Unknown small resource type 00, will not decode more.
        Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 41a9
        Capabilities: [60] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency
L0s <1us, L1 unlimited
                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal+
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
Latency L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [84] Vendor Specific Information: Len=4c <?>
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [12c v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [148 v1] Device Serial Number 6f-21-00-00-10-ec-81-68
        Capabilities: [154 v1] Power Budgeting <?>
        Kernel driver in use: r8169

30:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 33
        Region 0: I/O ports at 1100 [size=256]
        Region 2: Memory at f0500000 (64-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at f0d00000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
                Unknown small resource type 00, will not decode more.
        Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 41b9
        Capabilities: [60] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency
L0s <1us, L1 unlimited
                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal+
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
Latency L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [84] Vendor Specific Information: Len=4c <?>
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [12c v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [148 v1] Device Serial Number 29-22-00-00-10-ec-81-68
        Capabilities: [154 v1] Power Budgeting <?>
        Kernel driver in use: r8169

[7.6.] SCSI information (from /proc/scsi/scsi)

no such file
[7.7.] Other information that might be relevant to the problem

It seems that kernel URB mechanism took a lot of CPU performance as
iowait and in spin-locks.
As you see above the problem exist for new kernel too. Problem was
found on a router when I tried to copy data from connected USB flash
via Samba.
For testing I used cat /dev/sda > /dev/null to avoid influence from file system.
My suggestion is not decrease CPU Load but free a piece of CPU for user space.
This fix is important for routers and PC which has only one core and
USB handling is not main task.

[X.] Other notes, patches, fixes, workarounds:

Fix which helps to free CPU for user space if it is needed was made:

drivers/usb/core/message.c
void usb_sg_wait (struct usb_sg_request *io)
{
.......
for (i = 0; i < entries && !io->status; i++) {
.....
switch (retval) {
.....
case 0:
cpu_relax();
                yield (); // FIX
break;
....
It helps to decrease USB speed if user space software needs CPU but in
this case USB speed in idle CPU (no user space software is executed)
is decreased only less than 5%.

Copying the file via Samba from USB connected to the router router
(graph from Slurm)
-----------------------------------
Without fix
-----------------------------------
USB speed:
        copy  USB data                   executing a big user space
software       copy USB data
           start                                      start
                                    end
            |                                             |
                                         |
           V             x                             V
                                     V
            xxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx x xxxxxx
       x
            xxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxx
       x
           xxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxx
       x
           xxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
           xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

CPU is overloaded by 100% kernel usage. User space software is working
as turtle, cannot start properly.
USB speed is not decreased when user space software is executed (graph
above). User is


------------------------------------
With fix
------------------------------------
USB speed:
          executing user space sw                       copy USB data
        start
  end                                        end
     | d                              |                     |
     V                                V                     V
   x
xxxx                                   xxxxxxx xx  xxxxxx                    x
xxxx                                   xxxxxxx xxx xxxxxx                    x
xxxx                                   xxxxxxx xxx xxxxxxx                   x
xxxx                                   xxxxxxx xxx xxxxxxx x
xxxx                                   xxxxxxxxxxxxxxxxxxxxxx
xxxx                                   xxxxxxxxxxxxxxxxxxxxxx
xxxx                  x                xxxxxxxxxxxxxxxxxxxxxx
xxxx                  x          xx   xxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxx x   x  x  xxx xx x x  xxxxx xxxxxxxxxxxxxxxxxxxxxxxxx    xxx     xx

As we see, CPU is freed for user space and USB speed is decreased
(graph above) if it is needed.
So, user space is working as without any USB coping. User is  CPU is
divided between user space and kernel.
