Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1AQOgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:36:45 -0500
Received: from 84-16-211.226.3p.ntebredband.no ([84.16.211.226]:45851 "EHLO
	mail.aptomar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1AQOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:36:39 -0500
X-Greylist: delayed 2152 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 09:36:38 EST
Date: Mon, 17 Jan 2011 15:00:40 +0100 (CET)
From: Rune Saetre <rune.saetre@aptomar.com>
X-X-Sender: rst@pingle.local.rsnet
To: linux-kernel@vger.kernel.org
cc: Rune Saetre <rune.saetre@aptomar.com>
Message-ID: <Pine.LNX.4.64.1101171420420.15860@pingle.local.rsnet>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279707905-983658122-1295272839=:15860"
X-SA-Exim-Connect-IP: 84.16.211.227
X-SA-Exim-Mail-From: rune.saetre@aptomar.com
Subject: PROBLEM: kernel BUG at drivers/media/video/em28xx/em28xx-video.c:891
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on mail.aptomar.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279707905-983658122-1295272839=:15860
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

I am using a Pinnacle Dazzle DVC100 Rev 1.1 USB frame grabber card, and=20
each time I stop capturing video the driver crashes. This happens both in=
=20
an unpatched 2.6.37 kernel and in the debian 2.6.32-5 kernel.
The kernel says:
   kernel BUG at drivers/media/video/em28xx/em28xx-video.c:891

[1.] One line summary of the problem:
em28xx driver crashes and usb subsystem hangs when video capturing stops.

[2.] Full description of the problem/report:
em28xx driver crashes and usb subsystem hangs when video capturing stops.
This always happens when using memory mapped kernel buffers.

[3.] Keywords (i.e., modules, networking, kernel):
usb video em28xx v4l2

[4.] Kernel version (from /proc/version):
Linux version 2.6.37-rst (rst@mate) (gcc version 4.4.5 (Debian 4.4.5-6) ) #=
1 SMP PREEMPT Wed Jan 12 21:28:37 CET 2011

[5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
  - not Oops - kernel bug. Output:
Jan 17 12:31:36 mate kernel: [  500.463121] ------------[ cut here ]-------=
-----
Jan 17 12:31:36 mate kernel: [  500.463160] kernel BUG at drivers/media/vid=
eo/em28xx/em28xx-video.c:891!
Jan 17 12:31:36 mate kernel: [  500.463200] invalid opcode: 0000 [#1] PREEM=
PT SMP
Jan 17 12:31:36 mate kernel: [  500.463239] last sysfs file: /sys/devices/L=
NXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT1/status
Jan 17 12:31:36 mate kernel: [  500.463288] CPU 0
Jan 17 12:31:36 mate kernel: [  500.463302] Modules linked in: tuner saa711=
5 ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder snd_=
usb_audio snd_usbmidi_lib ir_rc5_decoder em28xx ir_nec_decoder v4l2_common =
ir_core videobuf_vmalloc videobuf_core tveeprom pl2303 usbserial acpi_cpufr=
eq mperf cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conserva=
tive ppdev lp nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs binfmt_misc fu=
se dummy bridge stp ext2 mbcache coretemp kvm_intel kvm loop firewire_sbp2 =
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd=
_mixer_oss snd_pcm snd_seq_dummy i915 drm_kms_helper snd_seq_oss drm snd_se=
q_midi arc4 snd_rawmidi ecb intel_agp i2c_algo_bit intel_gtt snd_seq_midi_e=
vent snd_seq joydev iwlagn iwlcore pcmcia uvcvideo videodev v4l1_compat v4l=
2_compat_ioctl32 parport_pc parport tpm_tis evdev tpm tpm_bios pcspkr snd_t=
imer snd_seq_device yenta_socket pcmcia_rsrc snd mac80211 cfg80211 irda rfk=
ill i2c_i801 i2c_core pcmcia_core soundcore psmou
Jan 17 12:31:36 mate kernel: e serio_raw video wmi snd_page_alloc crc_ccitt=
 output shpchp pci_hotplug battery processor ac button container reiserfs d=
m_mod raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor asyn=
c_memcpy async_tx raid1 raid0 multipath linear md_mod ide_cd_mod cdrom sd_m=
od crc_t10dif ata_generic pata_acpi ata_piix ide_pci_generic ahci libahci l=
ibata firewire_ohci firewire_core scsi_mod thermal uhci_hcd sdhci_pci sdhci=
 tg3 mmc_core crc_itu_t piix ide_core ehci_hcd thermal_sys [last unloaded: =
scsi_wait_scan]
Jan 17 12:31:36 mate kernel: [  500.464010]
Jan 17 12:31:36 mate kernel: [  500.464010] Pid: 3386, comm: camera_factory=
_ Not tainted 2.6.37-rst #1 Victoria        /TravelMate 6292
Jan 17 12:31:36 mate kernel: [  500.464010] RIP: 0010:[<ffffffffa07417f4>] =
 [<ffffffffa07417f4>] res_free+0x14/0x49 [em28xx]
Jan 17 12:31:36 mate kernel: [  500.464010] RSP: 0018:ffff880077d99c48  EFL=
AGS: 00010297
Jan 17 12:31:36 mate kernel: [  500.464010] RAX: 0000000000000001 RBX: ffff=
88006c84f800 RCX: 0000000000000000
Jan 17 12:31:36 mate kernel: [  500.464010] RDX: 0000000000000000 RSI: ffff=
880079cb0000 RDI: ffff88006c84f800
Jan 17 12:31:36 mate kernel: [  500.464010] RBP: ffff880079cb0000 R08: 0000=
000000000001 R09: 0000000000000d3a
Jan 17 12:31:36 mate kernel: [  500.464010] R10: 0000000000000000 R11: 0000=
000000000246 R12: 0000000000000000
Jan 17 12:31:36 mate kernel: [  500.464010] R13: ffffffffa0749920 R14: ffff=
880079ca2b40 R15: ffff88006c84f800
Jan 17 12:31:36 mate kernel: [  500.464010] FS:  00007f6a0950f820(0000) GS:=
ffff88007f400000(0000) knlGS:0000000000000000
Jan 17 12:31:36 mate kernel: [  500.464010] CS:  0010 DS: 0000 ES: 0000 CR0=
: 000000008005003b
Jan 17 12:31:36 mate kernel: [  500.464010] CR2: 00007fa16eb1fb88 CR3: 0000=
000066876000 CR4: 00000000000006f0
Jan 17 12:31:36 mate kernel: [  500.464010] DR0: 0000000000000000 DR1: 0000=
000000000000 DR2: 0000000000000000
Jan 17 12:31:36 mate kernel: [  500.464010] DR3: 0000000000000000 DR6: 0000=
0000ffff0ff0 DR7: 0000000000000400
Jan 17 12:31:36 mate kernel: [  500.464010] Process camera_factory_ (pid: 3=
386, threadinfo ffff880077d98000, task ffff88006c95e760)
Jan 17 12:31:36 mate kernel: [  500.464010] Stack:
Jan 17 12:31:36 mate kernel: [  500.464010]  ffff880079cb0000 ffffffffa0742=
6b9 0000000000000000 ffff88007f4135c0
Jan 17 12:31:36 mate kernel: [  500.464010]  ffff88006c95e760 0000000000000=
001 0000000000000000 0000000000000001
Jan 17 12:31:36 mate kernel: [  500.464010]  ffff8800669e1c00 ffffffffa0524=
2ff ffff88007f4135c0 ffffffff81047c12
Jan 17 12:31:36 mate kernel: [  500.464010] Call Trace:
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffffa07426b9>] ? vidioc_=
streamoff+0xa6/0xb6 [em28xx]
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffffa05242ff>] ? __video=
_do_ioctl+0x12e2/0x33a0 [videodev]
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81047c12>] ? ttwu_po=
st_activation+0x6e/0x10c
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff8132958e>] ? _raw_sp=
in_unlock_irqrestore+0x57/0x65
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81049261>] ? try_to_=
wake_up+0x1a8/0x1c3
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff8103a5fe>] ? __wake_=
up_common+0x41/0x78
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffffa05266f4>] ? video_i=
octl2+0x2ad/0x35d [videodev]
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81044d80>] ? add_pre=
empt_count+0x9e/0xa0
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff8132935c>] ? _raw_sp=
in_lock_irqsave+0x40/0x61
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81042cf3>] ? get_par=
ent_ip+0x9/0x1b
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81044cd1>] ? sub_pre=
empt_count+0x83/0x94
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81042cf3>] ? get_par=
ent_ip+0x9/0x1b
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81044cd1>] ? sub_pre=
empt_count+0x83/0x94
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81069c4d>] ? __srcu_=
read_unlock+0x39/0x59
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffffa0522342>] ? v4l2_io=
ctl+0x74/0x113 [videodev]
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81106f51>] ? do_vfs_=
ioctl+0x418/0x465
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81106fda>] ? sys_ioc=
tl+0x3c/0x5e
Jan 17 12:31:36 mate kernel: [  500.464010]  [<ffffffff81009c52>] ? system_=
call_fastpath+0x16/0x1b
Jan 17 12:31:36 mate kernel: [  500.464010] Code: 03 4c 39 e3 0f 18 08 75 d=
4 31 c0 eb 05 b8 ea ff ff ff 5b 5d 41 5c c3 48 83 ec 08 8b 57 0c 89 f0 89 c=
1 48 8b 37 21 d1 39 c1 74 04 <0f> 0b eb fe 89 c8 f7 d0 21 c2 89 57 0c 21 86=
 d0 09 00 00 83 3d
Jan 17 12:31:36 mate kernel: [  500.464010] RIP  [<ffffffffa07417f4>] res_f=
ree+0x14/0x49 [em28xx]
Jan 17 12:31:36 mate kernel: [  500.464010]  RSP <ffff880077d99c48>
Jan 17 12:31:36 mate kernel: [  500.488362] ---[ end trace ff9e44b94c6ba441=
 ]---


[6.] A small shell script or example program which triggers the problem (if=
 possible)

No shell script exists.
Start capturing video using memory mapped kernel buffers, then stop=20
capturing. Driver crashes immediately.

[7.] Environment

[7.1.] Software (add the output of the ver_linux script here)

rst@mate:/usr/src/linux-2.6.37$ sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux mate 2.6.37-rst #1 SMP PREEMPT Wed Jan 12 21:28:37 CET 2011 x86_64 GN=
U/Linux

Gnu C                  4.4.5
Gnu make               3.81
binutils               2.20.1
util-linux             scripts/ver_linux: line 23: fdformat: command not fo=
und
mount                  support
module-init-tools      found
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Console-tools          0.2.3
Sh-utils               8.5
Modules Loaded         r8169 mii tuner saa7115 ir_lirc_codec lirc_dev ir_so=
ny_decoder ir_jvc_decoder ir_rc6_decoder snd_usb_audio snd_usbmidi_lib ir_r=
c5_decoder em28xx ir_nec_decoder v4l2_common ir_core videobuf_vmalloc video=
buf_core tveeprom pl2303 usbserial acpi_cpufreq mperf cpufreq_powersave cpu=
freq_stats cpufreq_userspace cpufreq_conservative ppdev lp nfsd lockd nfs_a=
cl auth_rpcgss sunrpc exportfs binfmt_misc fuse dummy bridge stp ext2 mbcac=
he coretemp kvm_intel kvm loop firewire_sbp2 snd_hda_codec_realtek snd_hda_=
intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dum=
my i915 drm_kms_helper snd_seq_oss drm snd_seq_midi arc4 snd_rawmidi ecb in=
tel_agp i2c_algo_bit intel_gtt snd_seq_midi_event snd_seq joydev iwlagn iwl=
core pcmcia uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 parport_pc pa=
rport tpm_tis evdev tpm tpm_bios pcspkr snd_timer snd_seq_device yenta_sock=
et pcmcia_rsrc snd mac80211 cfg80211 irda rfkill i2c_i801 i2c_core pcmcia_c=
ore soundcore psmouse serio_raw video wmi snd_page_alloc crc_ccitt output s=
hpchp pci_hotplug battery processor ac button container reiserfs dm_mod rai=
d10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy =
async_tx raid1 raid0 multipath linear md_mod ide_cd_mod cdrom sd_mod crc_t1=
0dif ata_generic pata_acpi ata_piix ide_pci_generic ahci libahci libata fir=
ewire_ohci firewire_core scsi_mod thermal uhci_hcd sdhci_pci sdhci tg3 mmc_=
core crc_itu_t piix ide_core ehci_hcd thermal_sys


[7.2.] Processor information (from /proc/cpuinfo):

rst@mate:/usr/src/linux-2.6.37$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx l=
m constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 mo=
nitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vn=
mi flexpriority
bogomips        : 3989.75
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx l=
m constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 mo=
nitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vn=
mi flexpriority
bogomips        : 3989.81
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

rst@mate:/usr/src/linux-2.6.37$ cat /proc/modules
r8169 30626 0 - Live 0xffffffffa07eb000
mii 3266 1 r8169, Live 0xffffffffa07e5000
tuner 15968 0 - Live 0xffffffffa07db000
saa7115 12265 1 - Live 0xffffffffa07d2000
ir_lirc_codec 3491 0 - Live 0xffffffffa07cc000
lirc_dev 8553 1 ir_lirc_codec, Live 0xffffffffa07c3000
ir_sony_decoder 1963 0 - Live 0xffffffffa07bd000
ir_jvc_decoder 2073 0 - Live 0xffffffffa07b7000
ir_rc6_decoder 2473 0 - Live 0xffffffffa07b1000
snd_usb_audio 75270 0 - Live 0xffffffffa0790000
snd_usbmidi_lib 15474 1 snd_usb_audio, Live 0xffffffffa0786000
ir_rc5_decoder 2025 0 - Live 0xffffffffa0780000
em28xx 78115 1 - Live 0xffffffffa0741000
ir_nec_decoder 2265 0 - Live 0xffffffffa073e000
v4l2_common 6203 3 tuner,saa7115,em28xx, Live 0xffffffffa070e000
ir_core 12978 7=20
ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,=
em28xx,ir_nec_decoder, Live 0xffffffffa06fe000
videobuf_vmalloc 3805 1 em28xx, Live 0xffffffffa05e9000
videobuf_core 13188 2 em28xx,videobuf_vmalloc, Live 0xffffffffa05c9000
tveeprom 12449 1 em28xx, Live 0xffffffffa0569000
pl2303 10450 0 - Live 0xffffffffa0549000
usbserial 26425 1 pl2303, Live 0xffffffffa0532000
acpi_cpufreq 5479 1 - Live 0xffffffffa050c000
mperf 1291 1 acpi_cpufreq, Live 0xffffffffa0506000
cpufreq_powersave 942 0 - Live 0xffffffffa049a000
cpufreq_stats 2630 0 - Live 0xffffffffa047c000
cpufreq_userspace 1920 0 - Live 0xffffffffa03fc000
cpufreq_conservative 7646 0 - Live 0xffffffffa0402000
ppdev 5123 0 - Live 0xffffffffa03f8000
lp 7950 0 - Live 0xffffffffa0330000
nfsd 255488 11 - Live 0xffffffffa06b7000
lockd 57671 1 nfsd, Live 0xffffffffa0558000
nfs_acl 2055 1 nfsd, Live 0xffffffffa02a9000
auth_rpcgss 34333 1 nfsd, Live 0xffffffffa0484000
sunrpc 160227 12 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xffffffffa068d000
exportfs 3082 1 nfsd, Live 0xffffffffa0276000
binfmt_misc 6429 1 - Live 0xffffffffa025f000
fuse 54873 1 - Live 0xffffffffa0456000
dummy 2032 0 - Live 0xffffffffa0251000
bridge 59600 0 - Live 0xffffffffa0445000
stp 1480 1 bridge, Live 0xffffffffa01fb000
ext2 53329 1 - Live 0xffffffffa0431000
mbcache 5232 1 ext2, Live 0xffffffffa01ef000
coretemp 4952 0 - Live 0xffffffffa01dd000
kvm_intel 41951 0 - Live 0xffffffffa0378000
kvm 245116 1 kvm_intel, Live 0xffffffffa064f000
loop 14014 0 - Live 0xffffffffa0229000
firewire_sbp2 11375 0 - Live 0xffffffffa0224000
snd_hda_codec_realtek 275762 1 - Live 0xffffffffa04a0000
snd_hda_intel 18776 0 - Live 0xffffffffa01ae000
snd_hda_codec 60870 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa=
03e7000
snd_hwdep 5586 2 snd_usb_audio,snd_hda_codec, Live 0xffffffffa0171000
snd_pcm_oss 32004 0 - Live 0xffffffffa0157000
snd_mixer_oss 12821 1 snd_pcm_oss, Live 0xffffffffa0126000
snd_pcm 60701 4 snd_usb_audio,snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live=
 0xffffffffa03d6000
snd_seq_dummy 1335 0 - Live 0xffffffffa010c000
i915 294393 2 - Live 0xffffffffa0605000
drm_kms_helper 22053 1 i915, Live 0xffffffffa00b2000
snd_seq_oss 24329 0 - Live 0xffffffffa0072000
drm 153130 3 i915,drm_kms_helper, Live 0xffffffffa02d3000
snd_seq_midi 4534 0 - Live 0xffffffffa006b000
arc4 1330 2 - Live 0xffffffffa005e000
snd_rawmidi 15807 2 snd_usbmidi_lib,snd_seq_midi, Live 0xffffffffa0053000
ecb 1881 2 - Live 0xffffffffa0023000
intel_agp 10232 1 i915, Live 0xffffffffa05f3000
i2c_algo_bit 4105 1 i915, Live 0xffffffffa05ec000
intel_gtt 13403 3 i915,intel_agp, Live 0xffffffffa05d8000
snd_seq_midi_event 4834 2 snd_seq_oss,snd_seq_midi, Live 0xffffffffa05d0000
snd_seq 42268 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, =
Live 0xffffffffa05bc000
joydev 9080 0 - Live 0xffffffffa05b4000
iwlagn 130416 0 - Live 0xffffffffa0586000
iwlcore 46724 1 iwlagn, Live 0xffffffffa056e000
pcmcia 29649 0 - Live 0xffffffffa054e000
uvcvideo 51912 0 - Live 0xffffffffa053a000
videodev 53766 6 tuner,saa7115,em28xx,v4l2_common,uvcvideo, Live 0xffffffff=
a0522000
v4l1_compat 11702 2 uvcvideo,videodev, Live 0xffffffffa051a000
v4l2_compat_ioctl32 8219 1 videodev, Live 0xffffffffa0512000
parport_pc 28526 1 - Live 0xffffffffa04fd000
parport 26002 3 ppdev,lp,parport_pc, Live 0xffffffffa04e5000
tpm_tis 7141 0 - Live 0xffffffffa049c000
evdev 7987 21 - Live 0xffffffffa0480000
tpm 10153 1 tpm_tis, Live 0xffffffffa0440000
tpm_bios 4741 1 tpm, Live 0xffffffffa0416000
pcspkr 1739 0 - Live 0xffffffffa0410000
snd_timer 16372 2 snd_pcm,snd_seq, Live 0xffffffffa0405000
snd_seq_device 4531 5=20
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffff=
a03fe000
yenta_socket 18257 0 - Live 0xffffffffa03cf000
pcmcia_rsrc 7721 1 yenta_socket, Live 0xffffffffa02a2000
snd 47578 14=20
snd_usb_audio,snd_usbmidi_lib,snd_hda_codec_realtek,snd_hda_intel,snd_hda_c=
odec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,sn=
d_seq,snd_timer,snd_seq_device, Live 0xffffffffa03b7000
mac80211 141404 2 iwlagn,iwlcore, Live 0xffffffffa0385000
cfg80211 112773 3 iwlagn,iwlcore,mac80211, Live 0xffffffffa035a000
irda 87883 0 - Live 0xffffffffa0335000
rfkill 13614 1 cfg80211, Live 0xffffffffa032a000
i2c_i801 7366 0 - Live 0xffffffffa027d000
i2c_core 16640 11=20
tuner,saa7115,em28xx,v4l2_common,tveeprom,i915,drm_kms_helper,drm,i2c_algo_=
bit,videodev,i2c_i801, Live 0xffffffffa031d000
pcmcia_core 10413 3 pcmcia,yenta_socket,pcmcia_rsrc, Live 0xffffffffa029b00=
0
soundcore 4844 1 snd, Live 0xffffffffa0270000
psmouse 45928 0 - Live 0xffffffffa02c5000
serio_raw 3710 0 - Live 0xffffffffa01cc000
video 11203 1 i915, Live 0xffffffffa0207000
wmi 7268 0 - Live 0xffffffffa01e8000
snd_page_alloc 6257 2 snd_hda_intel,snd_pcm, Live 0xffffffffa01d5000
crc_ccitt 1331 1 irda, Live 0xffffffffa01c1000
output 1796 1 video, Live 0xffffffffa0179000
shpchp 21955 0 - Live 0xffffffffa01b6000
pci_hotplug 19807 1 shpchp, Live 0xffffffffa012b000
battery 5758 0 - Live 0xffffffffa010f000
processor 25841 3 acpi_cpufreq, Live 0xffffffffa00ba000
ac 2328 0 - Live 0xffffffffa007e000
button 4754 1 i915, Live 0xffffffffa0005000
container 2477 0 - Live 0xffffffffa0068000
reiserfs 192484 10 - Live 0xffffffffa00d5000
dm_mod 56452 40 - Live 0xffffffffa0013000
raid10 18539 0 - Live 0xffffffffa02be000
raid456 43785 0 - Live 0xffffffffa02ac000
async_raid6_recov 4803 1 raid456, Live 0xffffffffa02a5000
async_pq 3263 2 raid456,async_raid6_recov, Live 0xffffffffa029f000
raid6_pq 77474 2 async_raid6_recov,async_pq, Live 0xffffffffa0286000
async_xor 2209 3 raid456,async_raid6_recov,async_pq, Live 0xffffffffa028000=
0
xor 4628 1 async_xor, Live 0xffffffffa0279000
async_memcpy 1348 2 raid456,async_raid6_recov, Live 0xffffffffa0273000
async_tx 1742 5 raid456,async_raid6_recov,async_pq,async_xor,async_memcpy, =
Live 0xffffffffa026d000
raid1 18001 0 - Live 0xffffffffa0262000
raid0 7033 0 - Live 0xffffffffa025b000
multipath 5703 0 - Live 0xffffffffa0254000
linear 3399 0 - Live 0xffffffffa024e000
md_mod 79805 6 raid10,raid456,raid1,raid0,multipath,linear, Live 0xffffffff=
a022e000
ide_cd_mod 25097 1 - Live 0xffffffffa021b000
cdrom 29753 1 ide_cd_mod, Live 0xffffffffa020c000
sd_mod 28384 6 - Live 0xffffffffa01fe000
crc_t10dif 1300 1 sd_mod, Live 0xffffffffa01f8000
ata_generic 3151 0 - Live 0xffffffffa01f2000
pata_acpi 2976 0 - Live 0xffffffffa01ec000
ata_piix 20887 0 - Live 0xffffffffa01e0000
ide_pci_generic 2860 0 - Live 0xffffffffa01da000
ahci 19409 5 - Live 0xffffffffa01ce000
libahci 15861 1 ahci, Live 0xffffffffa01c3000
libata 142725 5 ata_generic,pata_acpi,ata_piix,ahci,libahci, Live 0xfffffff=
fa0189000
firewire_ohci 22074 0 - Live 0xffffffffa017d000
firewire_core 41534 2 firewire_sbp2,firewire_ohci, Live 0xffffffffa0136000
scsi_mod 159194 3 firewire_sbp2,sd_mod,libata, Live 0xffffffffa0027000
thermal 7586 0 - Live 0xffffffffa0064000
uhci_hcd 18138 0 - Live 0xffffffffa016a000
sdhci_pci 6551 0 - Live 0xffffffffa0175000
sdhci 14745 1 sdhci_pci, Live 0xffffffffa0160000
tg3 104211 0 - Live 0xffffffffa0096000
mmc_core 53815 1 sdhci, Live 0xffffffffa00c5000
crc_itu_t 1331 1 firewire_core, Live 0xffffffffa00c2000
piix 4608 1 - Live 0xffffffffa0118000
ide_core 79668 3 ide_cd_mod,ide_pci_generic,piix, Live 0xffffffffa0080000
ehci_hcd 30590 0 - Live 0xffffffffa0009000
thermal_sys 11764 3 video,processor,thermal, Live 0xffffffffa0000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

rst@mate:/usr/src/linux-2.6.37$ cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0062-0062 : EC data
0064-0064 : keyboard
0066-0066 : EC cmd
0070-0077 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
   0170-0177 : piix
01f0-01f7 : 0000:00:1f.1
   01f0-01f7 : piix
02f8-02ff : serial
0376-0376 : 0000:00:1f.1
   0376-0376 : piix
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
   03f6-03f6 : piix
03f8-03ff : serial
0680-069f : pnp 00:06
0778-077a : parport0
0800-080f : pnp 00:06
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
   1000-107f : pnp 00:06
     1000-1003 : ACPI PM1a_EVT_BLK
     1004-1005 : ACPI PM1a_CNT_BLK
     1008-100b : ACPI PM_TMR
     1010-1015 : ACPI CPU throttle
     1020-1020 : ACPI PM2_CNT_BLK
     1028-102f : ACPI GPE0_BLK
1180-11bf : 0000:00:1f.0
   1180-11bf : pnp 00:06
1640-164f : pnp 00:06
1800-1807 : 0000:00:02.0
1810-181f : 0000:00:1f.1
   1810-181f : piix
1820-183f : 0000:00:1a.0
   1820-183f : uhci_hcd
1840-185f : 0000:00:1a.1
   1840-185f : uhci_hcd
1860-187f : 0000:00:1d.0
   1860-187f : uhci_hcd
1880-189f : 0000:00:1d.1
   1880-189f : uhci_hcd
18a0-18bf : 0000:00:1d.2
   18a0-18bf : uhci_hcd
18d0-18d3 : 0000:00:1f.2
   18d0-18d3 : ahci
18d4-18d7 : 0000:00:1f.2
   18d4-18d7 : ahci
18d8-18df : 0000:00:1f.2
   18d8-18df : ahci
18e0-18ff : 0000:00:1f.2
   18e0-18ff : ahci
1c00-1c07 : 0000:00:1f.2
   1c00-1c07 : ahci
1c20-1c3f : 0000:00:1f.3
2000-2fff : PCI Bus 0000:02
3000-3fff : PCI Bus 0000:04
4000-4fff : PCI Bus 0000:05
5000-5fff : PCI Bus 0000:0a
   5000-50ff : PCI CardBus 0000:0b
     5000-50ff : 0000:0b:00.0
       5000-50ff : r8169
   5400-54ff : PCI CardBus 0000:0b
fe00-fe00 : pnp 00:06


rst@mate:/usr/src/linux-2.6.37$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000d2000-000d3fff : reserved
000e0000-000fffff : reserved
00100000-7f6cffff : System RAM
   01000000-0132c3d5 : Kernel code
   0132c3d6-0167b4ef : Kernel data
   0171c000-017eafef : Kernel bss
7f6d0000-7f6e0fff : ACPI Non-volatile Storage
7f6e1000-7fffffff : reserved
80000000-83ffffff : PCI Bus 0000:0a
   80000000-83ffffff : PCI CardBus 0000:0b
     80000000-8001ffff : 0000:0b:00.0
84000000-841fffff : PCI Bus 0000:02
84200000-843fffff : PCI Bus 0000:02
84400000-845fffff : PCI Bus 0000:04
   84400000-8440ffff : 0000:04:00.0
     84400000-8440ffff : tg3
84600000-847fffff : PCI Bus 0000:04
84800000-849fffff : PCI Bus 0000:05
   84800000-84801fff : 0000:05:00.0
     84800000-84801fff : iwlagn
84a00000-84bfffff : PCI Bus 0000:05
84c00000-84c000ff : 0000:00:1f.3
84c01000-84c01fff : Intel Flush Page
88000000-8bffffff : PCI CardBus 0000:0b
   88000000-880000ff : 0000:0b:00.0
     88000000-880000ff : r8169
d0000000-dfffffff : 0000:00:02.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
   e0000000-efffffff : reserved
     e0000000-efffffff : pnp 00:01
f0000000-f00fffff : 0000:00:02.0
f0100000-f01fffff : 0000:00:02.1
f0400000-f04fffff : PCI Bus 0000:0a
   f0400000-f0403fff : 0000:0a:09.0
   f0404000-f0404fff : 0000:0a:01.0
     f0404000-f0404fff : yenta_socket
   f0405000-f04057ff : 0000:0a:09.0
     f0405000-f04057ff : firewire_ohci
   f0405800-f040587f : 0000:0a:02.0
   f0405900-f04059ff : 0000:0a:02.3
     f0405900-f04059ff : mmc1
   f0405c00-f0405cff : 0000:0a:02.1
     f0405c00-f0405cff : mmc0
   f0406000-f040607f : 0000:0a:02.2
f0500000-f0503fff : 0000:00:1b.0
   f0500000-f0503fff : ICH HD audio
f0704000-f07047ff : 0000:00:1f.2
   f0704000-f07047ff : ahci
f0704800-f0704bff : 0000:00:1a.7
   f0704800-f0704bff : ehci_hcd
f0704c00-f0704fff : 0000:00:1d.7
   f0704c00-f0704fff : ehci_hcd
fec00000-fec0ffff : reserved
   fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
   fed00000-fed003ff : reserved
     fed00000-fed003ff : pnp 00:04
fed14000-fed19fff : reserved
   fed14000-fed17fff : pnp 00:01
   fed18000-fed18fff : pnp 00:01
   fed19000-fed19fff : pnp 00:01
fed1c000-fed8ffff : reserved
   fed1c000-fed1ffff : pnp 00:01
   fed20000-fed3ffff : pnp 00:01
   fed40000-fed44fff : pnp 00:01
   fed45000-fed8ffff : pnp 00:01
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ff000000-ffffffff : reserved


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Cont=
roller Hub (rev 03)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR+ FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort+ >SERR- <PERR- INTx-
 =09Latency: 0
 =09Capabilities: [e0] Vendor Specific Information: Len=3D0a <?>
 =09Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Int=
egrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx+
 =09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin A routed to IRQ 42
 =09Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=3D1M]
 =09Region 2: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
 =09Region 4: I/O ports at 1800 [size=3D8]
 =09Expansion ROM at <unassigned> [disabled]
 =09Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
 =09=09Address: fee0300c  Data: 4181
 =09Capabilities: [d0] Power Management version 3
 =09=09Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,=
D3cold-)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09=09Bridge: PM- B3+
 =09Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated=
 Graphics Controller (rev 03)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Region 0: Memory at f0100000 (64-bit, non-prefetchable) [size=3D1M]
 =09Capabilities: [d0] Power Management version 3
 =09=09Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,=
D3cold-)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09=09Bridge: PM- B3+

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Con=
troller #4 (rev 03) (prog-if 00 [UHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin A routed to IRQ 16
 =09Region 4: I/O ports at 1820 [size=3D32]
 =09Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Con=
troller #5 (rev 03) (prog-if 00 [UHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin B routed to IRQ 21
 =09Region 4: I/O ports at 1840 [size=3D32]
 =09Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Co=
ntroller #2 (rev 03) (prog-if 20 [EHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin C routed to IRQ 18
 =09Region 0: Memory at f0704800 (32-bit, non-prefetchable) [size=3D1K]
 =09Capabilities: [50] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot=
+,D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
 =09Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Contr=
oller (rev 03)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx+
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0, Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 43
 =09Region 0: Memory at f0500000 (64-bit, non-prefetchable) [size=3D16K]
 =09Capabilities: [50] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+=
,D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
 =09=09Address: 00000000fee0300c  Data: 4191
 =09Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 0=
0
 =09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <=
1us
 =09=09=09ExtTag- RBE- FLReset-
 =09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 =09=09=09RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
 =09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
 =09=09DevSta:=09CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend=
-
 =09=09LnkCap:=09Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0=
 <64ns, L1 <1us
 =09=09=09ClockPM- Surprise- LLActRep- BwNot-
 =09=09LnkCtl:=09ASPM Disabled; Disabled- Retrain- CommClk-
 =09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 =09=09LnkSta:=09Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- =
BWMgmt- ABWMgmt-
 =09Capabilities: [100 v1] Virtual Channel
 =09=09Caps:=09LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
 =09=09Arb:=09Fixed- WRR32- WRR64- WRR128-
 =09=09Ctrl:=09ArbSelect=3DFixed
 =09=09Status:=09InProgress-
 =09=09VC0:=09Caps:=09PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
 =09=09=09Arb:=09Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
 =09=09=09Ctrl:=09Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
 =09=09=09Status:=09NegoPending- InProgress-
 =09=09VC1:=09Caps:=09PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
 =09=09=09Arb:=09Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
 =09=09=09Ctrl:=09Enable+ ID=3D1 ArbSelect=3DFixed TC/VC=3D80
 =09=09=09Status:=09NegoPending- InProgress-
 =09Capabilities: [130 v1] Root Complex Link
 =09=09Desc:=09PortNumber=3D0f ComponentID=3D02 EltType=3DConfig
 =09=09Link0:=09Desc:=09TargetPort=3D00 TargetComponent=3D02 AssocRCRB- Lin=
kType=3DMemMapped LinkValid+
 =09=09=09Addr:=0900000000fed1c000
 =09Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port=
 1 (rev 03) (prog-if 00 [Normal decode])
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0, Cache Line Size: 64 bytes
 =09Bus: primary=3D00, secondary=3D02, subordinate=3D03, sec-latency=3D0
 =09I/O behind bridge: 00002000-00002fff
 =09Memory behind bridge: 84000000-841fffff
 =09Prefetchable memory behind bridge: 0000000084200000-00000000843fffff
 =09Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- <SERR- <PERR-
 =09BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 =09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 =09Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
 =09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, =
L1 unlimited
 =09=09=09ExtTag- RBE+ FLReset-
 =09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 =09=09=09RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 =09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
 =09=09DevSta:=09CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend=
-
 =09=09LnkCap:=09Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 =
<1us, L1 <4us
 =09=09=09ClockPM- Surprise- LLActRep+ BwNot-
 =09=09LnkCtl:=09ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
 =09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 =09=09LnkSta:=09Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-
 =09=09SltCap:=09AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
 =09=09=09Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
 =09=09SltCtl:=09Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- Lin=
kChg-
 =09=09=09Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 =09=09SltSta:=09Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interloc=
k-
 =09=09=09Changed: MRL- PresDet- LinkState-
 =09=09RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisib=
le-
 =09=09RootCap: CRSVisible-
 =09=09RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 =09Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
 =09=09Address: 00000000  Data: 0000
 =09Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 011b
 =09Capabilities: [a0] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,=
D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Capabilities: [100 v1] Virtual Channel
 =09=09Caps:=09LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
 =09=09Arb:=09Fixed+ WRR32- WRR64- WRR128-
 =09=09Ctrl:=09ArbSelect=3DFixed
 =09=09Status:=09InProgress-
 =09=09VC0:=09Caps:=09PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
 =09=09=09Arb:=09Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
 =09=09=09Ctrl:=09Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
 =09=09=09Status:=09NegoPending- InProgress-
 =09Capabilities: [180 v1] Root Complex Link
 =09=09Desc:=09PortNumber=3D01 ComponentID=3D02 EltType=3DConfig
 =09=09Link0:=09Desc:=09TargetPort=3D00 TargetComponent=3D02 AssocRCRB- Lin=
kType=3DMemMapped LinkValid+
 =09=09=09Addr:=0900000000fed1c001

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port=
 3 (rev 03) (prog-if 00 [Normal decode])
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0, Cache Line Size: 64 bytes
 =09Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0
 =09I/O behind bridge: 00003000-00003fff
 =09Memory behind bridge: 84400000-845fffff
 =09Prefetchable memory behind bridge: 0000000084600000-00000000847fffff
 =09Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- <SERR- <PERR-
 =09BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 =09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 =09Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
 =09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, =
L1 unlimited
 =09=09=09ExtTag- RBE+ FLReset-
 =09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 =09=09=09RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 =09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
 =09=09DevSta:=09CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend=
-
 =09=09LnkCap:=09Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 =
<256ns, L1 <4us
 =09=09=09ClockPM- Surprise- LLActRep+ BwNot-
 =09=09LnkCtl:=09ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommC=
lk+
 =09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 =09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ =
BWMgmt- ABWMgmt-
 =09=09SltCap:=09AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
 =09=09=09Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
 =09=09SltCtl:=09Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- Lin=
kChg-
 =09=09=09Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 =09=09SltSta:=09Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interloc=
k-
 =09=09=09Changed: MRL- PresDet- LinkState-
 =09=09RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisib=
le-
 =09=09RootCap: CRSVisible-
 =09=09RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 =09Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
 =09=09Address: 00000000  Data: 0000
 =09Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 011b
 =09Capabilities: [a0] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,=
D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Capabilities: [100 v1] Virtual Channel
 =09=09Caps:=09LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
 =09=09Arb:=09Fixed+ WRR32- WRR64- WRR128-
 =09=09Ctrl:=09ArbSelect=3DFixed
 =09=09Status:=09InProgress-
 =09=09VC0:=09Caps:=09PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
 =09=09=09Arb:=09Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
 =09=09=09Ctrl:=09Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
 =09=09=09Status:=09NegoPending- InProgress-
 =09Capabilities: [180 v1] Root Complex Link
 =09=09Desc:=09PortNumber=3D03 ComponentID=3D02 EltType=3DConfig
 =09=09Link0:=09Desc:=09TargetPort=3D00 TargetComponent=3D02 AssocRCRB- Lin=
kType=3DMemMapped LinkValid+
 =09=09=09Addr:=0900000000fed1c001

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port=
 4 (rev 03) (prog-if 00 [Normal decode])
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0, Cache Line Size: 64 bytes
 =09Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D0
 =09I/O behind bridge: 00004000-00004fff
 =09Memory behind bridge: 84800000-849fffff
 =09Prefetchable memory behind bridge: 0000000084a00000-0000000084bfffff
 =09Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- <SERR- <PERR-
 =09BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 =09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 =09Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
 =09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, =
L1 unlimited
 =09=09=09ExtTag- RBE+ FLReset-
 =09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 =09=09=09RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 =09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
 =09=09DevSta:=09CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend=
-
 =09=09LnkCap:=09Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 =
<256ns, L1 <4us
 =09=09=09ClockPM- Surprise- LLActRep+ BwNot-
 =09=09LnkCtl:=09ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommC=
lk+
 =09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 =09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ =
BWMgmt- ABWMgmt-
 =09=09SltCap:=09AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
 =09=09=09Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
 =09=09SltCtl:=09Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- Lin=
kChg-
 =09=09=09Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
 =09=09SltSta:=09Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interloc=
k-
 =09=09=09Changed: MRL- PresDet- LinkState-
 =09=09RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisib=
le-
 =09=09RootCap: CRSVisible-
 =09=09RootSta: PME ReqID 0000, PMEStatus- PMEPending-
 =09Capabilities: [80] MSI: Enable- Count=3D1/1 Maskable- 64bit-
 =09=09Address: 00000000  Data: 0000
 =09Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 011b
 =09Capabilities: [a0] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,=
D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Capabilities: [100 v1] Virtual Channel
 =09=09Caps:=09LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
 =09=09Arb:=09Fixed+ WRR32- WRR64- WRR128-
 =09=09Ctrl:=09ArbSelect=3DFixed
 =09=09Status:=09InProgress-
 =09=09VC0:=09Caps:=09PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
 =09=09=09Arb:=09Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
 =09=09=09Ctrl:=09Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
 =09=09=09Status:=09NegoPending- InProgress-
 =09Capabilities: [180 v1] Root Complex Link
 =09=09Desc:=09PortNumber=3D04 ComponentID=3D02 EltType=3DConfig
 =09=09Link0:=09Desc:=09TargetPort=3D00 TargetComponent=3D02 AssocRCRB- Lin=
kType=3DMemMapped LinkValid+
 =09=09=09Addr:=0900000000fed1c001

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Con=
troller #1 (rev 03) (prog-if 00 [UHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin A routed to IRQ 23
 =09Region 4: I/O ports at 1860 [size=3D32]
 =09Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Con=
troller #2 (rev 03) (prog-if 00 [UHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin B routed to IRQ 19
 =09Region 4: I/O ports at 1880 [size=3D32]
 =09Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Con=
troller #3 (rev 03) (prog-if 00 [UHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin C routed to IRQ 18
 =09Region 4: I/O ports at 18a0 [size=3D32]
 =09Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Co=
ntroller #1 (rev 03) (prog-if 20 [EHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin A routed to IRQ 23
 =09Region 0: Memory at f0704c00 (32-bit, non-prefetchable) [size=3D1K]
 =09Capabilities: [50] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot=
+,D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME+
 =09Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
 =09Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (pro=
g-if 01 [Subtractive decode])
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Bus: primary=3D00, secondary=3D0a, subordinate=3D0e, sec-latency=3D32
 =09I/O behind bridge: 00005000-00005fff
 =09Memory behind bridge: f0400000-f04fffff
 =09Prefetchable memory behind bridge: 0000000080000000-0000000083ffffff
 =09Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort+ <SERR- <PERR-
 =09BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 =09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 =09Capabilities: [50] Subsystem: Gammagraphx, Inc. (or missing ID) Device =
0000

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Contro=
ller (rev 03)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE C=
ontroller (rev 03) (prog-if 8a [Master SecP PriP])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin A routed to IRQ 19
 =09Region 0: I/O ports at 01f0 [size=3D8]
 =09Region 1: I/O ports at 03f4 [size=3D1]
 =09Region 2: I/O ports at 0170 [size=3D8]
 =09Region 3: I/O ports at 0374 [size=3D1]
 =09Region 4: I/O ports at 1810 [size=3D16]
 =09Kernel driver in use: PIIX_IDE

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SAT=
A AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx+
 =09Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0
 =09Interrupt: pin B routed to IRQ 40
 =09Region 0: I/O ports at 1c00 [size=3D8]
 =09Region 1: I/O ports at 18d4 [size=3D4]
 =09Region 2: I/O ports at 18d8 [size=3D8]
 =09Region 3: I/O ports at 18d0 [size=3D4]
 =09Region 4: I/O ports at 18e0 [size=3D32]
 =09Region 5: Memory at f0704000 (32-bit, non-prefetchable) [size=3D2K]
 =09Capabilities: [80] MSI: Enable+ Count=3D1/4 Maskable- 64bit-
 =09=09Address: fee0300c  Data: 4171
 =09Capabilities: [70] Power Management version 3
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,=
D3cold-)
 =09=09Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
 =09Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev=
 03)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Interrupt: pin C routed to IRQ 19
 =09Region 0: Memory at 84c00000 (32-bit, non-prefetchable) [size=3D256]
 =09Region 4: I/O ports at 1c20 [size=3D32]

04:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M Gigabit =
Ethernet PCI Express (rev 02)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx+
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0, Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 44
 =09Region 0: Memory at 84400000 (64-bit, non-prefetchable) [size=3D64K]
 =09Expansion ROM at <ignored> [disabled]
 =09Capabilities: [48] Power Management version 3
 =09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,=
D3cold+)
 =09=09Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D1 PME-
 =09Capabilities: [50] Vital Product Data
 =09=09Product Name: Broadcom NetLink Gigabit Ethernet Controller
 =09=09Read-only fields:
 =09=09=09[PN] Part number: BCM95787m
 =09=09=09[EC] Engineering changes: 106679-15
 =09=09=09[SN] Serial number: 0123456789
 =09=09=09[MN] Manufacture ID: 31 34 65 34
 =09=09=09[RV] Reserved: checksum good, 29 byte(s) reserved
 =09=09Read/write fields:
 =09=09=09[YA] Asset tag: XYZ01234567
 =09=09=09[RW] Read-write area: 107 byte(s) free
 =09=09End
 =09Capabilities: [58] Vendor Specific Information: Len=3D78 <?>
 =09Capabilities: [e8] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
 =09=09Address: 00000000fee0300c  Data: 4199
 =09Capabilities: [d0] Express (v1) Endpoint, MSI 00
 =09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 un=
limited
 =09=09=09ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 =09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 =09=09=09RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 =09=09=09MaxPayload 128 bytes, MaxReadReq 4096 bytes
 =09=09DevSta:=09CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend=
-
 =09=09LnkCap:=09Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 =
<4us, L1 <64us
 =09=09=09ClockPM+ Surprise- LLActRep- BwNot-
 =09=09LnkCtl:=09ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommC=
lk+
 =09=09=09ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
 =09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-
 =09Capabilities: [100 v1] Advanced Error Reporting
 =09=09UESta:=09DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- Ma=
lfTLP- ECRC- UnsupReq+ ACSViol-
 =09=09UEMsk:=09DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- Ma=
lfTLP- ECRC- UnsupReq- ACSViol-
 =09=09UESvrt:=09DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ M=
alfTLP+ ECRC- UnsupReq- ACSViol-
 =09=09CESta:=09RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr+
 =09=09CEMsk:=09RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 =09=09AERCap:=09First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
 =09Capabilities: [13c v1] Virtual Channel
 =09=09Caps:=09LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
 =09=09Arb:=09Fixed- WRR32- WRR64- WRR128-
 =09=09Ctrl:=09ArbSelect=3DFixed
 =09=09Status:=09InProgress-
 =09=09VC0:=09Caps:=09PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
 =09=09=09Arb:=09Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
 =09=09=09Ctrl:=09Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
 =09=09=09Status:=09NegoPending- InProgress-
 =09Capabilities: [160 v1] Device Serial Number 00-1b-24-ff-fe-7d-07-69
 =09Capabilities: [16c v1] Power Budgeting <?>
 =09Kernel driver in use: tg3

05:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [=
Kedron] Network Connection (rev 61)
 =09Subsystem: Intel Corporation PRO/Wireless 4965 AG or AGN
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 0, Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 41
 =09Region 0: Memory at 84800000 (64-bit, non-prefetchable) [size=3D8K]
 =09Capabilities: [c8] Power Management version 3
 =09=09Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,=
D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Capabilities: [d0] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
 =09=09Address: 00000000fee0300c  Data: 4179
 =09Capabilities: [e0] Express (v1) Endpoint, MSI 00
 =09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 =
unlimited
 =09=09=09ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 =09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 =09=09=09RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
 =09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
 =09=09DevSta:=09CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend=
-
 =09=09LnkCap:=09Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 =
<128ns, L1 <64us
 =09=09=09ClockPM+ Surprise- LLActRep- BwNot-
 =09=09LnkCtl:=09ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommC=
lk+
 =09=09=09ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
 =09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- =
BWMgmt- ABWMgmt-
 =09Capabilities: [100 v1] Advanced Error Reporting
 =09=09UESta:=09DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- Ma=
lfTLP- ECRC- UnsupReq+ ACSViol-
 =09=09UEMsk:=09DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- Ma=
lfTLP- ECRC- UnsupReq- ACSViol-
 =09=09UESvrt:=09DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ M=
alfTLP+ ECRC- UnsupReq- ACSViol-
 =09=09CESta:=09RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 =09=09CEMsk:=09RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 =09=09AERCap:=09First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
 =09Capabilities: [140 v1] Device Serial Number 00-13-e8-ff-ff-67-64-23
 =09Kernel driver in use: iwlagn

0a:01.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 0=
1)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 168, Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 16
 =09Region 0: Memory at f0404000 (32-bit, non-prefetchable) [size=3D4K]
 =09Bus: primary=3D0a, secondary=3D0b, subordinate=3D0e, sec-latency=3D176
 =09Memory window 0: 80000000-83fff000 (prefetchable)
 =09Memory window 1: 88000000-8bfff000
 =09I/O window 0: 00005000-000050ff
 =09I/O window 1: 00005400-000054ff
 =09BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
 =0916-bit legacy interface ports at 0001
 =09Kernel driver in use: yenta_cardbus

0a:02.0 FLASH memory: ENE Technology Inc ENE PCI Memory Stick Card Reader C=
ontroller
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 32 (250ns min, 1000ns max), Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 11
 =09Region 0: Memory at f0405800 (32-bit, non-prefetchable) [size=3D128]
 =09Capabilities: [80] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,=
D3cold-)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-

0a:02.1 SD Host controller: ENE Technology Inc ENE PCI SmartMedia / xD Card=
 Reader Controller (prog-if 01)
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 32 (8000ns min, 18000ns max), Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 17
 =09Region 0: Memory at f0405c00 (32-bit, non-prefetchable) [size=3D256]
 =09Capabilities: [80] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,=
D3cold-)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Kernel driver in use: sdhci-pci

0a:02.2 FLASH memory: ENE Technology Inc Memory Stick Card Reader Controlle=
r
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 32 (250ns min, 1000ns max), Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 255
 =09Region 0: Memory at f0406000 (32-bit, non-prefetchable) [size=3D128]
 =09Capabilities: [80] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,=
D3cold-)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-

0a:02.3 FLASH memory: ENE Technology Inc ENE PCI Secure Digital / MMC Card =
Reader Controller
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Interrupt: pin A routed to IRQ 17
 =09Region 0: Memory at f0405900 (32-bit, non-prefetchable) [size=3D256]
 =09Capabilities: [80] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,=
D3cold-)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Kernel driver in use: sdhci-pci

0a:09.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 C=
ontroller (PHY/Link) (prog-if 10 [OHCI])
 =09Subsystem: Acer Incorporated [ALI] Device 011b
 =09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
 =09Interrupt: pin A routed to IRQ 20
 =09Region 0: Memory at f0405000 (32-bit, non-prefetchable) [size=3D2K]
 =09Region 1: Memory at f0400000 (32-bit, non-prefetchable) [size=3D16K]
 =09Capabilities: [44] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,=
D3cold-)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME+
 =09Kernel driver in use: firewire_ohci

0b:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigab=
it Ethernet (rev 10)
 =09Subsystem: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet
 =09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Ste=
pping- SERR- FastB2B- DisINTx-
 =09Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAb=
ort- <MAbort- >SERR- <PERR- INTx-
 =09Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
 =09Interrupt: pin A routed to IRQ 16
 =09Region 0: I/O ports at 5000 [size=3D256]
 =09Region 1: Memory at 88000000 (32-bit, non-prefetchable) [size=3D256]
 =09[virtual] Expansion ROM at 80000000 [disabled] [size=3D128K]
 =09Capabilities: [dc] Power Management version 2
 =09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0-,D1+,D2+,D3hot=
+,D3cold+)
 =09=09Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
 =09Kernel driver in use: r8169


[7.6.] SCSI information (from /proc/scsi/scsi)

rst@mate:/usr/src/linux-2.6.37$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: Hitachi HTS54161 Rev: SB4O
   Type:   Direct-Access                    ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):

sudo lsusb -v # after reboot (not working after driver crash):

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.37-rst uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1a.1
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 007 Device 002: ID 2304:021a Pinnacle Systems, Inc. Dazzle DVC100 Audio=
 Device
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x2304 Pinnacle Systems, Inc.
   idProduct          0x021a Dazzle DVC100 Audio Device
   bcdDevice            1.00
   iManufacturer           2 Pinnacle Systems GmbH
   iProduct                1 DVC100
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          521
     bNumInterfaces          3
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              300mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       2
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0ad4  2x 724 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       3
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0c00  2x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       4
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1300  3x 768 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       5
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x135c  3x 860 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       6
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x13c4  3x 964 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       7
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0001  1x 1 bytes
         bInterval              11
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      1 Control Device
       bInterfaceProtocol      0
       iInterface              0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      1 (HEADER)
         bcdADC               1.00
         wTotalLength           39
         bInCollection           1
         baInterfaceNr( 0)       2
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             1
         wTerminalType      0x0603 Line Connector
         bAssocTerminal          0
         bNrChannels             2
         wChannelConfig     0x0003
           Left Front (L)
           Right Front (R)
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      6 (FEATURE_UNIT)
         bUnitID                 2
         bSourceID               1
         bControlSize            1
         bmaControls( 0)      0x03
           Mute
           Volume
         bmaControls( 1)      0x00
         iFeature                0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             3
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bSourceID               2
         iTerminal               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        48000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x001c  1x 28 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       2
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        44100
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0018  1x 24 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       3
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        32000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0014  1x 20 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       4
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        22050
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x000c  1x 12 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       5
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           3
         bDelay                  1 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]         8000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
         AudioControl Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x00
           bLockDelayUnits         0 Undefined
           wLockDelay              0 Undefined
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

Bus 007 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0002 2.0 root hub
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.37-rst ehci_hcd
   iProduct                2 EHCI Host Controller
   iSerial                 1 0000:00:1d.7
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              12
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             6
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood       10 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0503 highspeed power enable connect
    Port 3: 0000.0100 power
    Port 4: 0000.0100 power
    Port 5: 0000.0100 power
    Port 6: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.37-rst uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1d.2
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 002 Device 002: ID 147e:2016 Upek Biometric Touchchip/Touchstrip Finger=
print Sensor
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x147e Upek
   idProduct          0x2016 Biometric Touchchip/Touchstrip Fingerprint Sen=
sor
   bcdDevice            0.01
   iManufacturer           1 TouchStrip
   iProduct                2 Fingerprint Sensor
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           39
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)

Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.37-rst uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1a.0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0103 power enable connect
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.37-rst uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1d.0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.37-rst uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1d.1
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

Bus 001 Device 003: ID 064e:a101 Suyin Corp. Acer CrystalEye Webcam
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass          239 Miscellaneous Device
   bDeviceSubClass         2 ?
   bDeviceProtocol         1 Interface Association
   bMaxPacketSize0        64
   idVendor           0x064e Suyin Corp.
   idProduct          0xa101 Acer CrystalEye Webcam
   bcdDevice            1.00
   iManufacturer           2 SuYin
   iProduct                1 Acer CrystalEye webcam
   iSerial                 3 CN0314-OV03-VA-R02.00.00
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          543
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Association:
       bLength                 8
       bDescriptorType        11
       bFirstInterface         0
       bInterfaceCount         2
       bFunctionClass         14 Video
       bFunctionSubClass       3 Video Interface Collection
       bFunctionProtocol       0
       iFunction               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      1 Video Control
       bInterfaceProtocol      0
       iInterface              0
       VideoControl Interface Descriptor:
         bLength                13
         bDescriptorType        36
         bDescriptorSubtype      1 (HEADER)
         bcdUVC               1.00
         wTotalLength           77
         dwClockFrequency       15.000000MHz
         bInCollection           1
         baInterfaceNr( 0)       1
       VideoControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             2
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bSourceID               4
         iTerminal               0
       VideoControl Interface Descriptor:
         bLength                26
         bDescriptorType        36
         bDescriptorSubtype      6 (EXTENSION_UNIT)
         bUnitID                 4
         guidExtensionCode         {7033f028-1163-2e4a-ba2c-6890eb334016}
         bNumControl             1
         bNrPins                 1
         baSourceID( 0)          3
         bControlSize            1
         bmControls( 0)       0x01
         iExtension              0
       VideoControl Interface Descriptor:
         bLength                18
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             1
         wTerminalType      0x0201 Camera Sensor
         bAssocTerminal          0
         iTerminal               0
         wObjectiveFocalLengthMin      0
         wObjectiveFocalLengthMax      0
         wOcularFocalLength            0
         bControlSize                  3
         bmControls           0x00000000
       VideoControl Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      5 (PROCESSING_UNIT)
       Warning: Descriptor too short
         bUnitID                 3
         bSourceID               1
         wMaxMultiplier          0
         bControlSize            2
         bmControls     0x0000053f
           Brightness
           Contrast
           Hue
           Saturation
           Sharpness
           Gamma
           Backlight Compensation
           Power Line Frequency
         iProcessing             0
         bmVideoStandards     0x 0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval               6
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              0
       VideoStreaming Interface Descriptor:
         bLength                            14
         bDescriptorType                    36
         bDescriptorSubtype                  1 (INPUT_HEADER)
         bNumFormats                         1
         wTotalLength                      323
         bEndPointAddress                  129
         bmInfo                              0
         bTerminalLink                       2
         bStillCaptureMethod                 2
         bTriggerSupport                     1
         bTriggerUsage                       0
         bControlSize                        1
         bmaControls( 0)                    27
       VideoStreaming Interface Descriptor:
         bLength                            27
         bDescriptorType                    36
         bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
         bFormatIndex                        1
         bNumFrameDescriptors                5
         guidFormat                            {59555932-0000-1000-8000-00a=
a00389b71}
         bBitsPerPixel                      16
         bDefaultFrameIndex                  1
         bAspectRatioX                       0
         bAspectRatioY                       0
         bmInterlaceFlags                 0x00
           Interlaced stream or variable: No
           Fields per frame: 1 fields
           Field 1 first: No
           Field pattern: Field 1 only
           bCopyProtect                      0
       VideoStreaming Interface Descriptor:
         bLength                            50
         bDescriptorType                    36
         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
         bFrameIndex                         1
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            640
         wHeight                           480
         dwMinBitRate                   614400
         dwMaxBitRate                 18432000
         dwMaxVideoFrameBufferSize      614400
         dwDefaultFrameInterval         333333
         bFrameIntervalType                  6
         dwFrameInterval( 0)            333333
         dwFrameInterval( 1)            500000
         dwFrameInterval( 2)            666666
         dwFrameInterval( 3)           1000000
         dwFrameInterval( 4)           2000000
         dwFrameInterval( 5)          10000000
       VideoStreaming Interface Descriptor:
         bLength                            50
         bDescriptorType                    36
         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
         bFrameIndex                         2
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            352
         wHeight                           288
         dwMinBitRate                   202752
         dwMaxBitRate                  6082560
         dwMaxVideoFrameBufferSize      202752
         dwDefaultFrameInterval         333333
         bFrameIntervalType                  6
         dwFrameInterval( 0)            333333
         dwFrameInterval( 1)            500000
         dwFrameInterval( 2)            666666
         dwFrameInterval( 3)           1000000
         dwFrameInterval( 4)           2000000
         dwFrameInterval( 5)          10000000
       VideoStreaming Interface Descriptor:
         bLength                            50
         bDescriptorType                    36
         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
         bFrameIndex                         3
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            320
         wHeight                           240
         dwMinBitRate                   153600
         dwMaxBitRate                  4608000
         dwMaxVideoFrameBufferSize      153600
         dwDefaultFrameInterval         333333
         bFrameIntervalType                  6
         dwFrameInterval( 0)            333333
         dwFrameInterval( 1)            500000
         dwFrameInterval( 2)            666666
         dwFrameInterval( 3)           1000000
         dwFrameInterval( 4)           2000000
         dwFrameInterval( 5)          10000000
       VideoStreaming Interface Descriptor:
         bLength                            50
         bDescriptorType                    36
         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
         bFrameIndex                         4
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            176
         wHeight                           144
         dwMinBitRate                    50688
         dwMaxBitRate                  1520640
         dwMaxVideoFrameBufferSize       50688
         dwDefaultFrameInterval         333333
         bFrameIntervalType                  6
         dwFrameInterval( 0)            333333
         dwFrameInterval( 1)            500000
         dwFrameInterval( 2)            666666
         dwFrameInterval( 3)           1000000
         dwFrameInterval( 4)           2000000
         dwFrameInterval( 5)          10000000
       VideoStreaming Interface Descriptor:
         bLength                            50
         bDescriptorType                    36
         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
         bFrameIndex                         5
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            160
         wHeight                           120
         dwMinBitRate                    38400
         dwMaxBitRate                  1152000
         dwMaxVideoFrameBufferSize       38400
         dwDefaultFrameInterval         333333
         bFrameIntervalType                  6
         dwFrameInterval( 0)            333333
         dwFrameInterval( 1)            500000
         dwFrameInterval( 2)            666666
         dwFrameInterval( 3)           1000000
         dwFrameInterval( 4)           2000000
         dwFrameInterval( 5)          10000000
       VideoStreaming Interface Descriptor:
         bLength                            26
         bDescriptorType                    36
         bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
         bEndpointAddress                    0
         bNumImageSizePatterns               5
         wWidth( 0)                        640
         wHeight( 0)                       480
         wWidth( 1)                        352
         wHeight( 1)                       288
         wWidth( 2)                        320
         wHeight( 2)                       240
         wWidth( 3)                        176
         wHeight( 3)                       144
         wWidth( 4)                        160
         wHeight( 4)                       120
         bNumCompressionPatterns             5
       VideoStreaming Interface Descriptor:
         bLength                             6
         bDescriptorType                    36
         bDescriptorSubtype                 13 (COLORFORMAT)
         bColorPrimaries                     1 (BT.709,sRGB)
         bTransferCharacteristics            1 (BT.709)
         bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0080  1x 128 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       2
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0100  1x 256 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       3
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0320  1x 800 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       4
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x0b20  2x 800 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       5
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x1320  3x 800 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       6
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x13e8  3x 1000 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass          239 Miscellaneous Device
   bDeviceSubClass         2 ?
   bDeviceProtocol         1 Interface Association
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0002 2.0 root hub
   bcdDevice            2.06
   iManufacturer           3 Linux 2.6.37-rst ehci_hcd
   iProduct                2 EHCI Host Controller
   iSerial                 1 0000:00:1a.7
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              12
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             4
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood       10 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
    Port 3: 0000.0503 highspeed power enable connect
    Port 4: 0000.0100 power
Device Status:     0x0003
   Self Powered
   Remote Wakeup Enabled

[X.] Other notes, patches, fixes, workarounds:

This has been working well with earlier kernels, but I am not sure it=20
worked with preemption enabled.

Regards
Rune
--=20
Rune S=E6tre <rune.saetre@aptomar.com>
aptomar as

www.aptomar.com

--279707905-983658122-1295272839=:15860--
