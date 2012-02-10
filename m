Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2BJAlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:41:37 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57569 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767Ab2BJAlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:41:35 -0500
MIME-Version: 1.0
Date: Thu, 9 Feb 2012 21:41:33 -0300
Message-ID: <CAKvBQsstCwn4OJBY2idLv0t734UjJQTPFf8Pq2m=HW1gJuo=wg@mail.gmail.com>
Subject: OOPS: report for 3.2.5
From: Lima Union <limaunion@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear LKML: AFAIK this is the best place to report this kind of
problems. I don't know if my kernel is considered to be tainted or not
(vbox drivers?, sorry in advance if this is the case) but it may help
you to narrow some already known (or not) problem.

I've included all the requested information from 'reporting-bugs', let
me know if something else is required by e-mail (* I'm not subscribed
to the ML *).
Yours truly, a long time Linux lover.

[1.] One line summary of the problem:
I just got an oops after removing an unmounted Sandisk pendrive.

[2.] Full description of the problem/report:
I'm running Debian testing + GNOME3 (fall-back UI), upon removing a
pendrive I got the oops attached bellow. It wasn't mounted because a
couple of seconds before I issued a 'mount' and it wasn't listed. I
tried to reproduce the problem a couple of times without success.

[3.] Keywords (i.e., modules, networking, kernel):
$ uname -a
Linux debian1 3.2.5 #8 SMP Mon Feb 6 22:15:16 ART 2012 x86_64 GNU/Linux

$ lsmod
Module                  Size  Used by
vboxpci                12409  0
vboxnetadp              4883  0
vboxnetflt             13847  0
vboxdrv              1755604  3 vboxpci,vboxnetadp,vboxnetflt
binfmt_misc             6045  1
it87                   22696  0
hwmon_vid               1932  1 it87
kvm_amd                40865  0
kvm                   190992  1 kvm_amd
loop                   13549  0
dm_crypt               13248  0
crypto_hash             9725  1 dm_crypt
crypto_blkcipher       10570  1 dm_crypt
crypto_algapi           9855  3 dm_crypt,crypto_hash,crypto_blkcipher
dm_mod                 53895  1 dm_crypt
hid_logitech            6661  0
pl2303                 10309  0
usbhid                 15097  0
usbserial              25197  1 pl2303
tuner                  11148  1
tda8290                11147  1 tuner
tda18271               31183  2 tuner,tda8290
tda827x                 8454  1 tda8290
tda9887                 7813  1 tuner
tuner_simple           10364  1 tuner
tuner_types            10897  1 tuner_simple
tda7432                 3648  0
msp3400                23300  0
ir_lirc_codec           3467  0
bttv                   96421  0
videobuf_dma_sg         6424  1 bttv
videobuf_core          12540  2 bttv,videobuf_dma_sg
sr_mod                 11319  0
cdrom                  30114  1 sr_mod
ohci_hcd               16934  0
lirc_dev                7663  1 ir_lirc_codec
ir_mce_kbd_decoder      2806  0
btcx_risc               2683  1 bttv
rc_core                10367  3 ir_lirc_codec,bttv,ir_mce_kbd_decoder
tveeprom               12353  1 bttv
v4l2_common             4382  4 tuner,tda7432,msp3400,bttv
snd_hda_codec_realtek   176607  1
videodev               65835  5 tuner,tda7432,msp3400,bttv,v4l2_common
sata_via                7344  3
pata_amd                9788  0
nouveau               625239  2
ehci_hcd               32834  0
snd_hda_intel          19028  4
usbcore               112108  6 pl2303,usbhid,usbserial,ohci_hcd,ehci_hcd
snd_hda_codec          44540  2 snd_hda_codec_realtek,snd_hda_intel
snd_pcm_oss            29308  0
snd_mixer_oss          12308  1 snd_pcm_oss
k8temp                  2987  0
snd_pcm                54272  4 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_timer              15482  1 snd_pcm
ttm                    43389  1 nouveau
v4l2_compat_ioctl32     7372  1 videodev
drm_kms_helper         20774  1 nouveau
cfbcopyarea             2929  1 nouveau
forcedeth              43946  0
hwmon                   1169  3 it87,nouveau,k8temp
snd                    45281  14
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
8250_pnp                4495  0
soundcore               4274  1 snd
snd_page_alloc          5825  2 snd_hda_intel,snd_pcm
mxm_wmi                 1233  1 nouveau
evdev                   7994  8
wmi                     7259  1 mxm_wmi
8250                   18441  1 8250_pnp
cfbimgblt               1841  1 nouveau
cfbfillrect             2877  1 nouveau
usb_common               753  1 usbcore
serial_core            14197  1 8250
i2c_nforce2             4608  0
button                  4102  1 nouveau
processor              18459  0

[4.] Kernel version (from /proc/version):
$ cat /proc/version
Linux version 3.2.5 (limaunion@debian1) (gcc version 4.6.2 (Debian
4.6.2-12) ) #8 SMP Mon Feb 6 22:15:16 ART 2012

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
Feb  9 20:17:01 debian1 NTP: rdate: adjust local clock by -0.151191 seconds
Feb  9 20:54:54 debian1 kernel: [20824.017908] usb 1-2.2: USB
disconnect, device number 11
Feb  9 20:54:54 debian1 kernel: [20824.018241] scsi 9:0:0:0: killing request
Feb  9 20:54:54 debian1 kernel: [20824.019295] PGD 11d71b067 PUD
11d720067 PMD 0
Feb  9 20:54:54 debian1 kernel: [20824.019314] CPU 1
Feb  9 20:54:54 debian1 kernel: [20824.019317] Modules linked in:
nls_iso8859_1 nls_cp437 usb_storage hid_logitech pl2303 usbhid
usbserial vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
binfmt_misc it87 hwmon_vid kvm_amd kvm loop dm_crypt crypto_hash
crypto_blkcipher crypto_algapi dm_mod sr_mod cdrom tuner tda8290
tda18271 tda827x tda9887 tuner_simple tuner_types tda7432 msp3400 bttv
snd_hda_codec_realtek ir_lirc_codec sata_via lirc_dev pata_amd
ohci_hcd videobuf_dma_sg ir_mce_kbd_decoder videobuf_core nouveau
btcx_risc rc_core tveeprom ttm v4l2_common drm_kms_helper
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_timer 8250_pnp videodev cfbcopyarea mxm_wmi wmi ehci_hcd usbcore
8250 cfbimgblt evdev serial_core cfbfillrect i2c_nforce2 button snd
k8temp v4l2_compat_ioctl32 hwmon usb_common forcedeth soundcore
snd_page_alloc processor
Feb  9 20:54:54 debian1 kernel: [20824.019493]
Feb  9 20:54:54 debian1 kernel: [20824.019498] Pid: 3412, comm:
hald-addon-stor Tainted: G           O 3.2.5 #8 Gigabyte Technology
Co., Ltd. M61PME-S2P/M61PME-S2P
Feb  9 20:54:54 debian1 kernel: [20824.019515] RIP:
0010:[<ffffffff811d696f>]  [<ffffffff811d696f>]
sd_revalidate_disk+0x2f/0x1680
Feb  9 20:54:54 debian1 kernel: [20824.019529] RSP:
0018:ffff8801213b7af8  EFLAGS: 00010246
Feb  9 20:54:54 debian1 kernel: [20824.019536] RAX: 0000000000000000
RBX: ffff88012ac5b300 RCX: 0000000000000002
Feb  9 20:54:54 debian1 kernel: [20824.019544] RDX: 0000000000000000
RSI: ffff8800cea5e700 RDI: ffff880121e72400
Feb  9 20:54:54 debian1 kernel: [20824.019553] RBP: 0000000000000000
R08: 00000008ffffffff R09: 0000000000000005
Feb  9 20:54:54 debian1 kernel: [20824.019561] R10: 0000000000000000
R11: 0000000000000000 R12: ffff880121e72400
Feb  9 20:54:54 debian1 kernel: [20824.019570] R13: 0000000000000000
R14: 000000000000001d R15: ffff88012ac5b300
Feb  9 20:54:54 debian1 kernel: [20824.019579] FS:
00007f5339cd47a0(0000) GS:ffff88012fc80000(0000)
knlGS:0000000000000000
Feb  9 20:54:54 debian1 kernel: [20824.019588] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Feb  9 20:54:54 debian1 kernel: [20824.019595] CR2: 0000000000000008
CR3: 000000011dcc1000 CR4: 00000000000006e0
Feb  9 20:54:54 debian1 kernel: [20824.019604] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Feb  9 20:54:54 debian1 kernel: [20824.019613] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  9 20:54:54 debian1 kernel: [20824.019621] Process hald-addon-stor
(pid: 3412, threadinfo ffff8801213b6000, task ffff880120659900)
Feb  9 20:54:54 debian1 kernel: [20824.019635]  ffff8801213b7b70
ffffffff810bdc0f ffff880120659900 ffff880121e72448
Feb  9 20:54:54 debian1 kernel: [20824.019648]  0000000000000000
ffff880121e72400 ffff88012ac5b318 000000000000001d
Feb  9 20:54:54 debian1 kernel: [20824.019661]  ffff88012ac5b300
ffff880121e72400 ffff88012ac5b300 ffff88012ac5b300
Feb  9 20:54:54 debian1 kernel: [20824.019683]  [<ffffffff810bdc0f>] ?
bdev_test+0xf/0xf
Feb  9 20:54:54 debian1 kernel: [20824.019694]  [<ffffffff810dee32>] ?
rescan_partitions+0xac/0x41e
Feb  9 20:54:54 debian1 kernel: [20824.019703]  [<ffffffff810bed80>] ?
__blkdev_get+0x15f/0x337
Feb  9 20:54:54 debian1 kernel: [20824.019711]  [<ffffffff810bf1fb>] ?
blkdev_get+0x2a3/0x2a3
Feb  9 20:54:54 debian1 kernel: [20824.019720]  [<ffffffff810bf11d>] ?
blkdev_get+0x1c5/0x2a3
Feb  9 20:54:54 debian1 kernel: [20824.019728]  [<ffffffff810bf1fb>] ?
blkdev_get+0x2a3/0x2a3
Feb  9 20:54:54 debian1 kernel: [20824.019737]  [<ffffffff81098552>] ?
__dentry_open.isra.17+0x16b/0x294
Feb  9 20:54:54 debian1 kernel: [20824.019747]  [<ffffffff810a4c1a>] ?
do_last.isra.45+0x656/0x66a
Feb  9 20:54:54 debian1 kernel: [20824.019756]  [<ffffffff810a4dfa>] ?
path_openat+0xce/0x352
Feb  9 20:54:54 debian1 kernel: [20824.019765]  [<ffffffff810220d8>] ?
ttwu_do_wakeup+0xe/0x7d
Feb  9 20:54:54 debian1 kernel: [20824.019774]  [<ffffffff810a5147>] ?
do_filp_open+0x2a/0x6e
Feb  9 20:54:54 debian1 kernel: [20824.019783]  [<ffffffff810adef3>] ?
alloc_fd+0x64/0x108
Feb  9 20:54:54 debian1 kernel: [20824.019792]  [<ffffffff810991ed>] ?
do_sys_open+0xf7/0x185
Feb  9 20:54:54 debian1 kernel: [20824.019803]  [<ffffffff81284e3b>] ?
system_call_fastpath+0x16/0x1b
Feb  9 20:54:54 debian1 kernel: [20824.019926]  RSP <ffff8801213b7af8>
Feb  9 20:54:54 debian1 kernel: [20824.027179] ---[ end trace
059dc20bcd3666e8 ]---
Feb  9 20:56:02 debian1 shutdown[16240]: shutting down for system reboot

[6.] A small shell script or example program which triggers the
     problem (if possible)
None

[7.] Environment

[7.1.] Software (add the output of the ver_linux script here)
$ ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux debian1 3.2.5 #8 SMP Mon Feb 6 22:15:16 ART 2012 x86_64 GNU/Linux

Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      found
xfsprogs               3.1.7
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Console-tools          0.2.3
Sh-utils               8.13
Modules Loaded         vboxpci vboxnetadp vboxnetflt vboxdrv
binfmt_misc it87 hwmon_vid kvm_amd kvm loop dm_crypt crypto_hash
crypto_blkcipher crypto_algapi dm_mod hid_logitech pl2303 usbhid
usbserial tuner tda8290 tda18271 tda827x tda9887 tuner_simple
tuner_types tda7432 msp3400 ir_lirc_codec bttv videobuf_dma_sg
videobuf_core sr_mod cdrom ohci_hcd lirc_dev ir_mce_kbd_decoder
btcx_risc rc_core tveeprom v4l2_common snd_hda_codec_realtek videodev
sata_via pata_amd nouveau ehci_hcd snd_hda_intel usbcore snd_hda_codec
snd_pcm_oss snd_mixer_oss k8temp snd_pcm snd_timer ttm
v4l2_compat_ioctl32 drm_kms_helper cfbcopyarea forcedeth hwmon snd
8250_pnp soundcore snd_page_alloc mxm_wmi evdev wmi 8250 cfbimgblt
cfbfillrect usb_common serial_core i2c_nforce2 button processor

[7.2.] Processor information (from /proc/cpuinfo):
$ cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping	: 1
cpu MHz		: 2310.327
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm
cmp_legacy svm extapic cr8_legacy 3dnowprefetch lbrv
bogomips	: 4620.65
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping	: 1
cpu MHz		: 2310.327
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm
cmp_legacy svm extapic cr8_legacy 3dnowprefetch lbrv
bogomips	: 4620.67
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

[7.3.] Module information (from /proc/modules):
see above (#3)

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:06.0
    0170-0177 : pata_amd
  01f0-01f7 : 0000:00:06.0
    01f0-01f7 : pata_amd
  0290-0294 : pnp 00:02
  0295-0296 : it87
    0295-0296 : pnp 00:02
      0295-0296 : it87
  0376-0376 : 0000:00:06.0
    0376-0376 : pata_amd
  03c0-03df : vga+
  03f6-03f6 : 0000:00:06.0
    03f6-03f6 : pata_amd
  03f8-03ff : serial
  04d0-04d1 : pnp 00:02
  0800-087f : pnp 00:02
  0970-0977 : 0000:00:08.0
    0970-0977 : sata_nv
  09f0-09f7 : 0000:00:08.0
    09f0-09f7 : sata_nv
  0b70-0b73 : 0000:00:08.0
    0b70-0b73 : sata_nv
  0bf0-0bf3 : 0000:00:08.0
    0bf0-0bf3 : sata_nv
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-107f : pnp 00:01
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    101c-101c : ACPI PM2_CNT_BLK
    1020-1027 : ACPI GPE0_BLK
  1080-10ff : pnp 00:01
  1400-147f : pnp 00:01
  1480-14ff : pnp 00:01
    14a0-14af : ACPI GPE1_BLK
  1800-187f : pnp 00:01
  1880-18ff : pnp 00:01
  1c00-1c3f : 0000:00:01.1
    1c00-1c3f : nForce2_smbus
  a000-afff : PCI Bus 0000:02
  b000-cfff : PCI Bus 0000:01
    b800-b8ff : 0000:01:06.0
      b800-b8ff : sata_via
    bc00-bc1f : 0000:01:06.0
      bc00-bc1f : sata_via
    c000-c00f : 0000:01:06.0
      c000-c00f : sata_via
    c400-c40f : 0000:01:06.0
      c400-c40f : sata_via
    c800-c80f : 0000:01:06.0
      c800-c80f : sata_via
    cc00-cc0f : 0000:01:06.0
      cc00-cc0f : sata_via
  d800-d80f : 0000:00:08.0
    d800-d80f : sata_nv
  ec00-ec07 : 0000:00:07.0
    ec00-ec07 : forcedeth
  f000-f00f : 0000:00:06.0
    f000-f00f : pata_amd
  f400-f43f : 0000:00:01.1
    f400-f43f : nForce2_smbus
  fc00-fc3f : 0000:00:01.1

$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
  000c0000-000cebff : Video ROM
  000d0000-000d3fff : pnp 00:0b
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cffeffff : System RAM
  01000000-01288c13 : Kernel code
  01288c14-013b0ebf : Kernel data
  0141b000-01474fff : Kernel bss
  c4000000-c7ffffff : GART
cfff0000-cfff2fff : ACPI Non-volatile Storage
cfff3000-cfffffff : ACPI Tables
d0000000-febfffff : PCI Bus 0000:00
  d0000000-dfffffff : PCI Bus 0000:02
    d0000000-dfffffff : 0000:02:00.0
  e0000000-e7ffffff : PCI MMCONFIG 0000 [bus 00-7f]
    e0000000-e7ffffff : reserved
      e0000000-e7ffffff : pnp 00:0a
  fa000000-fcffffff : PCI Bus 0000:02
    fa000000-faffffff : 0000:02:00.0
    fb000000-fbffffff : 0000:02:00.0
    fc000000-fc01ffff : 0000:02:00.0
  fde00000-fdefffff : PCI Bus 0000:01
  fdf00000-fdffffff : PCI Bus 0000:01
    fdf00000-fdf0ffff : 0000:01:06.0
    fdffe000-fdffefff : 0000:01:07.1
    fdfff000-fdffffff : 0000:01:07.0
      fdfff000-fdffffff : bttv0
  fe028000-fe02bfff : 0000:00:05.0
    fe028000-fe02bfff : ICH HD audio
  fe02c000-fe02cfff : 0000:00:08.0
    fe02c000-fe02cfff : sata_nv
  fe02d000-fe02dfff : 0000:00:07.0
    fe02d000-fe02dfff : forcedeth
  fe02e000-fe02e0ff : 0000:00:02.1
    fe02e000-fe02e0ff : ehci_hcd
  fe02f000-fe02ffff : 0000:00:02.0
    fe02f000-fe02ffff : ohci_hcd
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0b
  fefe0000-fefe01ff : pnp 00:01
  fefe1000-fefe10ff : pnp 00:01
  feff0000-feff03ff : HPET 0
  ffff0000-ffffffff : pnp 00:0b
100000000-12fffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)
$ sudo lspci -vvv
00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
	Subsystem: Giga-byte Technology Device 5001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=17 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
	Subsystem: Giga-byte Technology Device 0c11
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
	Subsystem: Giga-byte Technology Device 0c11
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at fc00 [size=64]
	Region 4: I/O ports at 1c00 [size=64]
	Region 5: I/O ports at f400 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: nForce2_smbus

00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
	Subsystem: Giga-byte Technology Device 0c11
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 USB controller: nVidia Corporation MCP61 USB Controller (rev
a3) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd

00:02.1 USB controller: nVidia Corporation MCP61 USB Controller (rev
a3) (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 20
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000b000-0000cfff
	Memory behind bridge: fde00000-fdefffff
	Prefetchable memory behind bridge: fdf00000-fdffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: Giga-byte Technology Device 026f
	Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000

00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev a2)
	Subsystem: Giga-byte Technology Device a002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at fe028000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: snd_hda_intel

00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2) (prog-if
8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_amd

00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
	Subsystem: Giga-byte Technology Device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at ec00 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit+
		Address: 00000000fee0300c  Data: 4171
		Masking: 000000fe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: forcedeth

00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev
a2) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at d800 [size=16]
	Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: sata_nv

00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev
a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fa000000-fcffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: nVidia Corporation Device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4129
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=WRR32
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
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
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp

01:06.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID
Controller (rev 50)
	Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at cc00 [size=16]
	Region 1: I/O ports at c800 [size=16]
	Region 2: I/O ports at c400 [size=16]
	Region 3: I/O ports at c000 [size=16]
	Region 4: I/O ports at bc00 [size=32]
	Region 5: I/O ports at b800 [size=256]
	[virtual] Expansion ROM at fdf00000 [disabled] [size=64K]
	Capabilities: [e0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sata_via

01:07.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fdfff000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
		Not readable
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: bttv

01:07.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fdffe000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
		Not readable
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

02:00.0 VGA compatible controller: nVidia Corporation NV44 [GeForce
7100 GS] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: XFX Pine Group Inc. Device 2234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 16
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
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
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


[7.6.] SCSI information (from /proc/scsi/scsi)
$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3200AAKS-0 Rev: 12.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD10EARS-00Y Rev: 80.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD20EARS-00M Rev: 51.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 01 Lun: 00
  Vendor: HL-DT-ST Model: DVD-RAM GSA-H54N Rev: 1.00
  Type:   CD-ROM                           ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
really?
:)
