Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1FXIRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:17:41 -0400
Received: from smtpauth19.prod.mesa1.secureserver.net ([64.202.165.30]:49217
	"HELO smtpauth19.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753796Ab1FXIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:17:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 04:17:28 EDT
Message-ID: <4E044692.8010108@berkeleychurchill.com>
Date: Fri, 24 Jun 2011 01:10:58 -0700
From: Berkeley Churchill <berkeley@berkeleychurchill.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: system froze, "kernel BUG" in /var/log/kernel with core
 dump (/drivers/char/tty_ldisc.c)
Content-Type: multipart/mixed;
 boundary="------------070609010401050406000807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070609010401050406000807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Dear Developers:

     I would appreciate it if you would consider the following bug 
report, which I have taken time to write clearly.  Please let me know if 
you need anything more to troubleshoot the problem.

     [DESCRIPTION]

     I encountered this bug when running a poorly written serial 
terminal program.  I was attempting to read from a USB serial port 
/dev/ttyUSB0.  While running the program the system froze when I 
unplugged the device. The code that was running is attached (com.c), and 
was compiled using gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5), with no 
special command line options.  The actual hardware was a CanaKit USB 
RFID reader (with the ID-20 chip attached).

     [KEYWORDS]
     serial, usb, tty_ldisc, invalid opcode

     [KERNEL VERSION]
Linux version 2.6.32-22-generic (buildd@yellow) (gcc version 4.4.3 
(Ubuntu 4.4.3-4ubuntu5) ) #36-Ubuntu SMP Thu Jun 3 19:31:57 UTC 2010

     [CORE DUMP]
Jun 24 00:12:29 be-happy kernel: [50825.542759] ------------[ cut here 
]------------
Jun 24 00:12:29 be-happy kernel: [50825.542763] kernel BUG at 
/build/buildd/linux-2.6.32/drivers/char/tty_ldisc.c:707!
Jun 24 00:12:29 be-happy kernel: [50825.542767] invalid opcode: 0000 
[#1] SMP
Jun 24 00:12:29 be-happy kernel: [50825.542770] last sysfs file: 
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Jun 24 00:12:29 be-happy kernel: [50825.542773] CPU 3
Jun 24 00:12:29 be-happy kernel: [50825.542776] Modules linked in: 
ftdi_sio usbserial dummy rfcomm binfmt_misc ppdev sco bridge stp bnep 
l2cap kvm_intel kvm quota_v2 quota_tree dm_crypt nls_iso8859_1 nls_cp437 
vfat fat snd_hda_codec_nvhdmi snd_hda_codec_realtek iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack arc4 nf_defrag_ipv4 iptable_mangle 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss 
iptable_filter iwlagn snd_pcm iwlcore snd_timer sdhci_pci snd ip_tables 
sdhci mac80211 soundcore x_tables uvcvideo videodev v4l1_compat 
v4l2_compat_ioctl32 btusb led_class bluetooth cfg80211 snd_page_alloc 
nvidia(P) psmouse serio_raw lirc_ene0100 lirc_dev coretemp lp parport 
dm_raid45 xor usbhid hid ohci1394 video output r8169 ahci mii ieee1394 
fbcon tileblit font bitblit softcursor intel_agp vga16fb vgastate
Jun 24 00:12:29 be-happy kernel: [50825.542849] Pid: 44, comm: khubd 
Tainted: P   M       2.6.32-22-generic #36-Ubuntu GX720
Jun 24 00:12:29 be-happy kernel: [50825.542852] RIP: 
0010:[<ffffffff81331500>]  [<ffffffff81331500>] tty_ldisc_reinit+0x50/0x60
Jun 24 00:12:29 be-happy kernel: [50825.542862] RSP: 
0018:ffff88013ab51a90  EFLAGS: 00010202
Jun 24 00:12:29 be-happy kernel: [50825.542864] RAX: ffffffffffffffea 
RBX: ffff8800bf985000 RCX: 01000000000000c1
Jun 24 00:12:29 be-happy kernel: [50825.542868] RDX: 00000000000000bc 
RSI: ffffea00027c5b10 RDI: 00000000000000bf
Jun 24 00:12:29 be-happy kernel: [50825.542871] RBP: ffff88013ab51aa0 
R08: 0000000000000000 R09: 0000000000000000
Jun 24 00:12:29 be-happy kernel: [50825.542873] R10: 0000000000000005 
R11: 0000000000000001 R12: 00000000000000bf
Jun 24 00:12:29 be-happy kernel: [50825.542876] R13: ffff8800bf985020 
R14: 0000000000000000 R15: 0000000000000001
Jun 24 00:12:29 be-happy kernel: [50825.542880] FS:  
0000000000000000(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
Jun 24 00:12:29 be-happy kernel: [50825.542883] CS:  0010 DS: 0018 ES: 
0018 CR0: 000000008005003b
Jun 24 00:12:29 be-happy kernel: [50825.542886] CR2: 00007faefd78b000 
CR3: 0000000001001000 CR4: 00000000000426e0
Jun 24 00:12:29 be-happy kernel: [50825.542889] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Jun 24 00:12:29 be-happy kernel: [50825.542893] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 24 00:12:29 be-happy kernel: [50825.542896] Process khubd (pid: 44, 
threadinfo ffff88013ab50000, task ffff88013ab496f0)
Jun 24 00:12:29 be-happy kernel: [50825.542898] Stack:
Jun 24 00:12:29 be-happy kernel: [50825.542900]  ffff8800bf985000 
0000000000000000 ffff88013ab51ad0 ffffffff813316d0
Jun 24 00:12:29 be-happy kernel: [50825.542905] <0> ffff8800b9c05f00 
ffff8800bf985208 ffff8800bf985000 ffff8800bf9851d8
Jun 24 00:12:29 be-happy kernel: [50825.542910] <0> ffff88013ab51b30 
ffffffff81329146 ffff8800bf985208 ffffffff810397a9
Jun 24 00:12:29 be-happy kernel: [50825.542916] Call Trace:
Jun 24 00:12:29 be-happy kernel: [50825.542921]  [<ffffffff813316d0>] 
tty_ldisc_hangup+0x1c0/0x1f0
Jun 24 00:12:29 be-happy kernel: [50825.542926]  [<ffffffff81329146>] 
do_tty_hangup+0x146/0x400
Jun 24 00:12:29 be-happy kernel: [50825.542933]  [<ffffffff810397a9>] ? 
default_spin_lock_flags+0x9/0x10
Jun 24 00:12:29 be-happy kernel: [50825.542937]  [<ffffffff81329415>] 
tty_vhangup+0x15/0x20
Jun 24 00:12:29 be-happy kernel: [50825.542944]  [<ffffffffa0c2e6fd>] 
usb_serial_disconnect+0xad/0x1a0 [usbserial]
Jun 24 00:12:29 be-happy kernel: [50825.542950]  [<ffffffff813d9304>] 
usb_unbind_interface+0x124/0x170
Jun 24 00:12:29 be-happy kernel: [50825.542955]  [<ffffffff81368cbf>] 
__device_release_driver+0x6f/0xe0
Jun 24 00:12:29 be-happy kernel: [50825.542959]  [<ffffffff81368e2d>] 
device_release_driver+0x2d/0x40
Jun 24 00:12:29 be-happy kernel: [50825.542964]  [<ffffffff81367e4a>] 
bus_remove_device+0x9a/0xc0
Jun 24 00:12:29 be-happy kernel: [50825.542969]  [<ffffffff81365fa7>] 
device_del+0x127/0x1d0
Jun 24 00:12:29 be-happy kernel: [50825.542973]  [<ffffffff813d5ac8>] 
usb_disable_device+0xa8/0x130
Jun 24 00:12:29 be-happy kernel: [50825.542978]  [<ffffffff813cf862>] 
usb_disconnect+0xd2/0x170
Jun 24 00:12:29 be-happy kernel: [50825.542982]  [<ffffffff813cfedf>] 
hub_port_connect_change+0x8f/0x980
Jun 24 00:12:29 be-happy kernel: [50825.542987]  [<ffffffff813d11d2>] 
hub_events+0x3b2/0x5a0
Jun 24 00:12:29 be-happy kernel: [50825.542992]  [<ffffffff8153e798>] ? 
thread_return+0x48/0x420
Jun 24 00:12:29 be-happy kernel: [50825.542997]  [<ffffffff813d1415>] 
hub_thread+0x55/0x190
Jun 24 00:12:29 be-happy kernel: [50825.543002]  [<ffffffff81085320>] ? 
autoremove_wake_function+0x0/0x40
Jun 24 00:12:29 be-happy kernel: [50825.543006]  [<ffffffff813d13c0>] ? 
hub_thread+0x0/0x190
Jun 24 00:12:29 be-happy kernel: [50825.543010]  [<ffffffff81084fa6>] 
kthread+0x96/0xa0
Jun 24 00:12:29 be-happy kernel: [50825.543015]  [<ffffffff810141ea>] 
child_rip+0xa/0x20
Jun 24 00:12:29 be-happy kernel: [50825.543019]  [<ffffffff81084f10>] ? 
kthread+0x0/0xa0
Jun 24 00:12:29 be-happy kernel: [50825.543022]  [<ffffffff810141e0>] ? 
child_rip+0x0/0x20
Jun 24 00:12:29 be-happy kernel: [50825.543024] Code: c7 43 40 00 00 00 
00 44 89 e7 e8 7c fe ff ff 48 3d 00 f0 ff ff 77 14 48 89 43 40 44 89 e6 
48 89 df e8 15 fa ff ff 5b 41 5c c9 c3 <0f> 0b eb fe 66 66 66 2e 0f 1f 
84 00 00 00 00 00 55 48 89 e5 41
Jun 24 00:12:29 be-happy kernel: [50825.543066] RIP  
[<ffffffff81331500>] tty_ldisc_reinit+0x50/0x60
Jun 24 00:12:29 be-happy kernel: [50825.543071]  RSP <ffff88013ab51a90>
Jun 24 00:12:29 be-happy kernel: [50825.543074] ---[ end trace 
36b06e8ab880aa6c ]---


     [OTHER LOG MESSAGES]
     (show plugging in and unplugging the usb device)

Jun 23 23:41:54 be-happy kernel: [48991.070072] usb 4-2: new full speed 
USB device using uhci_hcd and address 3
Jun 23 23:41:54 be-happy kernel: [48991.276636] usb 4-2: configuration 
#1 chosen from 1 choice
Jun 23 23:41:54 be-happy kernel: [48991.321101] usbcore: registered new 
interface driver usbserial
Jun 23 23:41:54 be-happy kernel: [48991.321118] USB Serial support 
registered for generic
Jun 23 23:41:54 be-happy kernel: [48991.321155] usbcore: registered new 
interface driver usbserial_generic
Jun 23 23:41:54 be-happy kernel: [48991.321157] usbserial: USB Serial 
Driver core
Jun 23 23:41:54 be-happy kernel: [48991.328501] USB Serial support 
registered for FTDI USB Serial Device
Jun 23 23:41:54 be-happy kernel: [48991.328632] ftdi_sio 4-2:1.0: FTDI 
USB Serial Device converter detected
Jun 23 23:41:54 be-happy kernel: [48991.328674] usb 4-2: Detected FT232RL
Jun 23 23:41:54 be-happy kernel: [48991.328676] usb 4-2: Number of 
endpoints 2
Jun 23 23:41:54 be-happy kernel: [48991.328679] usb 4-2: Endpoint 1 
MaxPacketSize 64
Jun 23 23:41:54 be-happy kernel: [48991.328681] usb 4-2: Endpoint 2 
MaxPacketSize 64
Jun 23 23:41:54 be-happy kernel: [48991.328683] usb 4-2: Setting 
MaxPacketSize 64
Jun 23 23:41:54 be-happy kernel: [48991.330601] usb 4-2: FTDI USB Serial 
Device converter now attached to ttyUSB0
Jun 23 23:41:54 be-happy kernel: [48991.330628] usbcore: registered new 
interface driver ftdi_sio
Jun 23 23:41:54 be-happy kernel: [48991.330631] ftdi_sio: v1.5.0:USB 
FTDI Serial Converters Driver
Jun 23 23:58:15 be-happy kernel: [49972.042569] usb 4-2: USB disconnect, 
address 3
Jun 23 23:58:15 be-happy kernel: [49972.042786] ftdi_sio ttyUSB0: FTDI 
USB Serial Device converter now disconnected from ttyUSB0
Jun 23 23:58:15 be-happy kernel: [49972.042805] ftdi_sio 4-2:1.0: device 
disconnected
Jun 23 23:58:17 be-happy kernel: [49974.320082] usb 4-2: new full speed 
USB device using uhci_hcd and address 4
Jun 23 23:58:18 be-happy kernel: [49974.527427] usb 4-2: configuration 
#1 chosen from 1 choice
Jun 23 23:58:18 be-happy kernel: [49974.535361] ftdi_sio 4-2:1.0: FTDI 
USB Serial Device converter detected
Jun 23 23:58:18 be-happy kernel: [49974.535394] usb 4-2: Detected FT232RL
Jun 23 23:58:18 be-happy kernel: [49974.535397] usb 4-2: Number of 
endpoints 2
Jun 23 23:58:18 be-happy kernel: [49974.535399] usb 4-2: Endpoint 1 
MaxPacketSize 64
Jun 23 23:58:18 be-happy kernel: [49974.535402] usb 4-2: Endpoint 2 
MaxPacketSize 64
Jun 23 23:58:18 be-happy kernel: [49974.535404] usb 4-2: Setting 
MaxPacketSize 64
Jun 23 23:58:18 be-happy kernel: [49974.536530] usb 4-2: FTDI USB Serial 
Device converter now attached to ttyUSB0
Jun 24 00:11:07 be-happy kernel: [50744.042582] usb 4-2: USB disconnect, 
address 4
Jun 24 00:11:07 be-happy kernel: [50744.042798] ftdi_sio ttyUSB0: FTDI 
USB Serial Device converter now disconnected from ttyUSB0
Jun 24 00:11:07 be-happy kernel: [50744.042816] ftdi_sio 4-2:1.0: device 
disconnected
Jun 24 00:11:09 be-happy kernel: [50746.072581] usb 4-2: new full speed 
USB device using uhci_hcd and address 5
Jun 24 00:11:09 be-happy kernel: [50746.277649] usb 4-2: configuration 
#1 chosen from 1 choice
Jun 24 00:11:09 be-happy kernel: [50746.284554] ftdi_sio 4-2:1.0: FTDI 
USB Serial Device converter detected
Jun 24 00:11:09 be-happy kernel: [50746.284587] usb 4-2: Detected FT232RL
Jun 24 00:11:09 be-happy kernel: [50746.284590] usb 4-2: Number of 
endpoints 2
Jun 24 00:11:09 be-happy kernel: [50746.284593] usb 4-2: Endpoint 1 
MaxPacketSize 64
Jun 24 00:11:09 be-happy kernel: [50746.284595] usb 4-2: Endpoint 2 
MaxPacketSize 64
Jun 24 00:11:09 be-happy kernel: [50746.284597] usb 4-2: Setting 
MaxPacketSize 64
Jun 24 00:11:09 be-happy kernel: [50746.285667] usb 4-2: FTDI USB Serial 
Device converter now attached to ttyUSB0
Jun 24 00:12:29 be-happy kernel: [50825.542630] usb 4-2: USB disconnect, 
address 5


     [ENVIRONMENT DETAILS]
     [ver_linux]
Linux be-happy 2.6.32-22-generic #36-Ubuntu SMP Thu Jun 3 19:31:57 UTC 
2010 x86_64 GNU/Linux

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.11
reiserfsprogs          3.6.21
pcmciautils            014
quota-tools            3.17.
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
wireless-tools         30
Modules Loaded         ftdi_sio usbserial rfcomm sco binfmt_misc ppdev 
bridge stp bnep l2cap kvm_intel kvm quota_v2 quota_tree nls_iso8859_1 
nls_cp437 vfat fat dm_crypt snd_hda_codec_nvhdmi snd_hda_codec_realtek 
arc4 iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack snd_hda_intel 
snd_hda_codec nf_defrag_ipv4 snd_hwdep snd_pcm_oss snd_mixer_oss 
iptable_mangle snd_pcm iwlagn iptable_filter iwlcore snd_timer snd 
ip_tables mac80211 uvcvideo videodev soundcore x_tables v4l1_compat 
v4l2_compat_ioctl32 btusb sdhci_pci sdhci psmouse led_class serio_raw 
cfg80211 bluetooth snd_page_alloc nvidia lirc_ene0100 lirc_dev coretemp 
lp parport dm_raid45 xor usbhid hid fbcon tileblit font bitblit 
softcursor ohci1394 video output r8169 vga16fb mii intel_agp vgastate 
ahci ieee1394

     [/proc/cpuinfo]
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Quad  CPU   Q9000  @ 2.00GHz
stepping    : 10
cpu MHz        : 1600.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 4
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 
monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm 
ida tpr_shadow vnmi flexpriority
bogomips    : 3989.44
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Quad  CPU   Q9000  @ 2.00GHz
stepping    : 10
cpu MHz        : 1600.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 1
cpu cores    : 4
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 
monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm 
ida tpr_shadow vnmi flexpriority
bogomips    : 3989.99
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 2
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Quad  CPU   Q9000  @ 2.00GHz
stepping    : 10
cpu MHz        : 1600.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 2
cpu cores    : 4
apicid        : 2
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 
monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm 
ida tpr_shadow vnmi flexpriority
bogomips    : 3990.01
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 3
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Quad  CPU   Q9000  @ 2.00GHz
stepping    : 10
cpu MHz        : 1600.000
cache size    : 3072 KB
physical id    : 0
siblings    : 4
core id        : 3
cpu cores    : 4
apicid        : 3
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 
monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm 
ida tpr_shadow vnmi flexpriority
bogomips    : 3990.01
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

     [/proc/modules]
ftdi_sio 37981 0 - Live 0xffffffffa0c17000
usbserial 39067 1 ftdi_sio, Live 0xffffffffa0c0b000
rfcomm 40329 4 - Live 0xffffffffa0bff000
sco 9617 2 - Live 0xffffffffa0bc4000
binfmt_misc 7960 1 - Live 0xffffffffa0bfb000
ppdev 6375 0 - Live 0xffffffffa0bf4000
bridge 53152 0 - Live 0xffffffffa0bde000
stp 2171 1 bridge, Live 0xffffffffa00bb000
bnep 11820 2 - Live 0xffffffffa0bc9000
l2cap 34774 16 rfcomm,bnep, Live 0xffffffffa0bb9000
kvm_intel 46296 0 - Live 0xffffffffa0bcd000
kvm 286392 1 kvm_intel, Live 0xffffffffa0b71000
quota_v2 3262 1 - Live 0xffffffffa0b67000
quota_tree 8500 1 quota_v2, Live 0xffffffffa0b58000
nls_iso8859_1 4633 1 - Live 0xffffffffa0b6a000
nls_cp437 6351 1 - Live 0xffffffffa0b63000
vfat 10802 1 - Live 0xffffffffa0b5e000
fat 55350 1 vfat, Live 0xffffffffa0b48000
dm_crypt 13043 0 - Live 0xffffffffa0b42000
snd_hda_codec_nvhdmi 4760 1 - Live 0xffffffffa0c80000
snd_hda_codec_realtek 278890 1 - Live 0xffffffffa0e05000
arc4 1473 2 - Live 0xffffffffa0d47000
iptable_nat 5219 0 - Live 0xffffffffa0d6f000
nf_nat 19501 1 iptable_nat, Live 0xffffffffa0d68000
nf_conntrack_ipv4 12980 3 iptable_nat,nf_nat, Live 0xffffffffa0ce1000
nf_conntrack 73934 3 iptable_nat,nf_nat,nf_conntrack_ipv4, Live 
0xffffffffa0df0000
snd_hda_intel 25645 2 - Live 0xffffffffa0d93000
snd_hda_codec 85727 3 
snd_hda_codec_nvhdmi,snd_hda_codec_realtek,snd_hda_intel, Live 
0xffffffffa0dd9000
nf_defrag_ipv4 1481 1 nf_conntrack_ipv4, Live 0xffffffffa0c8a000
snd_hwdep 6924 1 snd_hda_codec, Live 0xffffffffa0cf8000
snd_pcm_oss 41394 0 - Live 0xffffffffa0d3a000
snd_mixer_oss 16299 2 snd_pcm_oss, Live 0xffffffffa0c9e000
iptable_mangle 3315 0 - Live 0xffffffffa008d000
snd_pcm 87850 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 
0xffffffffa0dc1000
iwlagn 121577 0 - Live 0xffffffffa0da1000
iptable_filter 2791 0 - Live 0xffffffffa0024000
iwlcore 124955 1 iwlagn, Live 0xffffffffa0d72000
snd_timer 23553 1 snd_pcm, Live 0xffffffffa0c51000
snd 70978 10 
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer, 
Live 0xffffffffa0d54000
ip_tables 18390 3 iptable_nat,iptable_mangle,iptable_filter, Live 
0xffffffffa0d49000
mac80211 238128 2 iwlagn,iwlcore, Live 0xffffffffa0cfd000
uvcvideo 62403 0 - Live 0xffffffffa0ce6000
videodev 40486 1 uvcvideo, Live 0xffffffffa0cd5000
soundcore 8052 2 snd, Live 0xffffffffa0cab000
x_tables 22429 2 iptable_nat,ip_tables, Live 0xffffffffa0cc3000
v4l1_compat 15495 2 uvcvideo,videodev, Live 0xffffffffa0cbd000
v4l2_compat_ioctl32 12020 1 videodev, Live 0xffffffffa004a000
btusb 12969 2 - Live 0xffffffffa0cb3000
sdhci_pci 6700 0 - Live 0xffffffffa0caf000
sdhci 17928 1 sdhci_pci, Live 0xffffffffa0ca4000
psmouse 64608 0 - Live 0xffffffffa0c8c000
led_class 3732 2 iwlcore,sdhci, Live 0xffffffffa0087000
serio_raw 4918 0 - Live 0xffffffffa006c000
cfg80211 148386 3 iwlagn,iwlcore,mac80211, Live 0xffffffffa0c59000
bluetooth 58621 9 rfcomm,sco,bnep,l2cap,btusb, Live 0xffffffffa0c40000
snd_page_alloc 8500 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0032000
nvidia 10832442 30 - Live 0xffffffffa00eb000 (P)
lirc_ene0100 7532 0 - Live 0xffffffffa00b7000
lirc_dev 11302 1 lirc_ene0100, Live 0xffffffffa009c000
coretemp 5345 0 - Live 0xffffffffa0083000
lp 9336 0 - Live 0xffffffffa005c000
parport 37160 2 ppdev,lp, Live 0xffffffffa00df000
dm_raid45 75436 0 - Live 0xffffffffa00ca000
xor 4685 1 dm_raid45, Live 0xffffffffa001d000
usbhid 40988 0 - Live 0xffffffffa00bd000
hid 83376 1 usbhid, Live 0xffffffffa00a0000
fbcon 39270 71 - Live 0xffffffffa0090000
tileblit 2487 1 fbcon, Live 0xffffffffa008a000
font 8053 1 fbcon, Live 0xffffffffa0053000
bitblit 5811 1 fbcon, Live 0xffffffffa0020000
softcursor 1565 1 bitblit, Live 0xffffffffa001a000
ohci1394 30260 0 - Live 0xffffffffa0079000
video 20623 0 - Live 0xffffffffa0071000
output 2503 1 video, Live 0xffffffffa003d000
r8169 39650 0 - Live 0xffffffffa0060000
vga16fb 12757 1 - Live 0xffffffffa0056000
mii 5237 1 r8169, Live 0xffffffffa004f000
intel_agp 29225 0 - Live 0xffffffffa0040000
vgastate 9857 1 vga16fb, Live 0xffffffffa0038000
ahci 37646 7 - Live 0xffffffffa0026000
ieee1394 94675 1 ohci1394, Live 0xffffffffa0000000

     [/proc/ioports]
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
004c-004f : enecir
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vga+
0400-041f : 0000:00:1f.3
04c0-04cf : pnp 00:08
04d0-04d1 : pnp 00:08
04d2-04ff : pnp 00:08
0500-053f : pnp 00:08
0800-087f : pnp 00:08
   0800-0803 : ACPI PM1a_EVT_BLK
   0804-0805 : ACPI PM1a_CNT_BLK
   0808-080b : ACPI PM_TMR
   0810-0815 : ACPI CPU throttle
   0820-082f : ACPI GPE0_BLK
   0850-0850 : ACPI PM2_CNT_BLK
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:05
2000-2fff : PCI Bus 0000:06
a400-a41f : 0000:00:1a.2
   a400-a41f : uhci_hcd
a480-a49f : 0000:00:1a.1
   a480-a49f : uhci_hcd
a800-a81f : 0000:00:1a.0
   a800-a81f : uhci_hcd
a880-a89f : 0000:00:1d.2
   a880-a89f : uhci_hcd
ac00-ac1f : 0000:00:1d.1
   ac00-ac1f : uhci_hcd
b000-b01f : 0000:00:1d.0
   b000-b01f : uhci_hcd
b400-b41f : 0000:00:1f.2
   b400-b41f : ahci
b480-b483 : 0000:00:1f.2
   b480-b483 : ahci
b800-b807 : 0000:00:1f.2
   b800-b807 : ahci
b880-b883 : 0000:00:1f.2
   b880-b883 : ahci
bc00-bc07 : 0000:00:1f.2
   bc00-bc07 : ahci
c000-cfff : PCI Bus 0000:02
d000-dfff : PCI Bus 0000:04
   d800-d8ff : 0000:04:00.0
     d800-d8ff : r8169
e000-efff : PCI Bus 0000:07
   ec00-ec7f : 0000:07:00.0

     [/proc/iomem]
00000000-0000ffff : reserved
00010000-00099bff : System RAM
00099c00-0009ffff : reserved
000c0000-000cffff : pnp 00:0f
000e4000-000fffff : reserved
00100000-bff8ffff : System RAM
   01000000-015484d6 : Kernel code
   015484d7-018305cf : Kernel data
   01919000-01a29e63 : Kernel bss
bff90000-bff9dfff : ACPI Tables
bff9e000-bffdffff : ACPI Non-volatile Storage
bffe0000-bfffffff : reserved
c0000000-c01fffff : PCI Bus 0000:05
c0200000-c03fffff : PCI Bus 0000:06
c0400000-c05fffff : PCI Bus 0000:06
cc000000-cfefffff : PCI Bus 0000:02
cff00000-cfffffff : PCI Bus 0000:04
   cfff0000-cfffffff : 0000:04:00.0
     cfff0000-cfffffff : r8169
d0000000-dfffffff : PCI Bus 0000:07
   d0000000-dfffffff : 0000:07:00.0
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
   e0000000-efffffff : pnp 00:0e
f8ef8000-f8efbfff : 0000:00:1b.0
   f8ef8000-f8efbfff : ICH HD audio
f8efec00-f8efefff : 0000:00:1a.7
   f8efec00-f8efefff : ehci_hcd
f8eff000-f8eff3ff : 0000:00:1d.7
   f8eff000-f8eff3ff : ehci_hcd
f8eff400-f8eff4ff : 0000:00:1f.3
f8eff800-f8efffff : 0000:00:1f.2
   f8eff800-f8efffff : ahci
f8f00000-f8ffffff : PCI Bus 0000:01
   f8ffd000-f8ffdfff : 0000:01:04.3
   f8ffe400-f8ffe4ff : 0000:01:04.2
     f8ffe400-f8ffe4ff : mmc0
   f8ffe800-f8ffefff : 0000:01:04.0
   f8fff000-f8ffffff : 0000:01:04.0
     f8fff000-f8fff7ff : ohci1394
f9000000-f9dfffff : PCI Bus 0000:02
f9e00000-f9efffff : PCI Bus 0000:04
   f9ec0000-f9edffff : 0000:04:00.0
   f9eff000-f9efffff : 0000:04:00.0
     f9eff000-f9efffff : r8169
f9f00000-f9ffffff : PCI Bus 0000:05
   f9ffe000-f9ffffff : 0000:05:00.0
     f9ffe000-f9ffffff : iwlagn
fa000000-febfffff : PCI Bus 0000:07
   fa000000-fbffffff : 0000:07:00.0
   fd000000-fdffffff : 0000:07:00.0
     fd000000-fdffffff : nvidia
   feb80000-febfffff : 0000:07:00.0
fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed10000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:08
fed20000-fed3ffff : pnp 00:08
fed40000-fed8ffff : pnp 00:08
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
     fee00000-fee00fff : pnp 00:0c
ffb00000-ffffffff : reserved
   ffc00000-ffefffff : pnp 00:0b
100000000-13fffffff : System RAM

     [sudo lspci -vvv]
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory 
Controller Hub (rev 07)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information <?>
     Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI 
Express Graphics Port (rev 07)
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
     I/O behind bridge: 0000e000-0000efff
     Memory behind bridge: fa000000-febfffff
     Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [88] Subsystem: Micro-Star International Co., Ltd. 
Device 7220
     Capabilities: [80] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
         Address: fee0f00c  Data: 4169
     Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Suprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise-
             Slot #  0, PowerLimit 0.000000; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Off, PwrInd On, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100] Virtual Channel <?>
     Capabilities: [140] Root Complex Link <?>
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 16
     Region 4: I/O ports at a800 [size=32]
     Capabilities: [50] PCIe advanced features <?>
     Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 21
     Region 4: I/O ports at a480 [size=32]
     Capabilities: [50] PCIe advanced features <?>
     Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin D routed to IRQ 19
     Region 4: I/O ports at a400 [size=32]
     Capabilities: [50] PCIe advanced features <?>
     Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 03) (prog-if 20)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 18
     Region 0: Memory at f8efec00 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME+
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCIe advanced features <?>
     Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio 
Controller (rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 22
     Region 0: Memory at f8ef8000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
         Address: 0000000000000000  Data: 0000
     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, 
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
             ClockPM- Suprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100] Virtual Channel <?>
     Capabilities: [130] Root Complex Link <?>
     Kernel driver in use: HDA Intel
     Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 03)
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=02, subordinate=03, sec-latency=0
     I/O behind bridge: 0000c000-0000cfff
     Memory behind bridge: f9000000-f9dfffff
     Prefetchable memory behind bridge: 00000000cc000000-00000000cfefffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Suprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+
             Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn+ PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
         Address: fee0f00c  Data: 4171
     Capabilities: [90] Subsystem: Micro-Star International Co., Ltd. 
Device 7220
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100] Virtual Channel <?>
     Capabilities: [180] Root Complex Link <?>
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 2 (rev 03)
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
     I/O behind bridge: 0000d000-0000dfff
     Memory behind bridge: f9e00000-f9efffff
     Prefetchable memory behind bridge: 00000000cff00000-00000000cfffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Suprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+
             Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq+ LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
         Address: fee0f00c  Data: 4179
     Capabilities: [90] Subsystem: Micro-Star International Co., Ltd. 
Device 7220
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100] Virtual Channel <?>
     Capabilities: [180] Root Complex Link <?>
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 3 (rev 03)
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
     I/O behind bridge: 00001000-00001fff
     Memory behind bridge: f9f00000-f9ffffff
     Prefetchable memory behind bridge: 00000000c0000000-00000000c01fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Suprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+
             Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq+ LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
         Address: fee0f00c  Data: 4181
     Capabilities: [90] Subsystem: Micro-Star International Co., Ltd. 
Device 7220
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100] Virtual Channel <?>
     Capabilities: [180] Root Complex Link <?>
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 4 (rev 03)
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: c0200000-c03fffff
     Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Suprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+
             Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq+ LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
         Address: fee0f00c  Data: 4189
     Capabilities: [90] Subsystem: Micro-Star International Co., Ltd. 
Device 7220
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100] Virtual Channel <?>
     Capabilities: [180] Root Complex Link <?>
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 4: I/O ports at b000 [size=32]
     Capabilities: [50] PCIe advanced features <?>
     Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 4: I/O ports at ac00 [size=32]
     Capabilities: [50] PCIe advanced features <?>
     Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 18
     Region 4: I/O ports at a880 [size=32]
     Capabilities: [50] PCIe advanced features <?>
     Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 03) (prog-if 20)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 0: Memory at f8eff000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCIe advanced features <?>
     Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) 
(prog-if 01)
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: f8f00000-f8ffffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR+
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Subsystem: Micro-Star International Co., Ltd. 
Device 7220

00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller 
(rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information <?>
     Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI 
Controller (rev 03) (prog-if 01)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 29
     Region 0: I/O ports at bc00 [size=8]
     Region 1: I/O ports at b880 [size=4]
     Region 2: I/O ports at b800 [size=8]
     Region 3: I/O ports at b480 [size=4]
     Region 4: I/O ports at b400 [size=32]
     Region 5: Memory at f8eff800 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/4 Enable+
         Address: fee0c00c  Data: 41a1
     Capabilities: [70] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a8] SATA HBA <?>
     Capabilities: [b0] PCIe advanced features <?>
     Kernel driver in use: ahci
     Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller 
(rev 03)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin C routed to IRQ 11
     Region 0: Memory at f8eff400 (64-bit, non-prefetchable) [size=256]
     Region 4: I/O ports at 0400 [size=32]
     Kernel modules: i2c-i801

01:04.0 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 
02) (prog-if 10)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx+
     Latency: 32, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at f8fff000 (32-bit, non-prefetchable) [size=4K]
     Region 1: Memory at f8ffe800 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [60] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME+
     Kernel driver in use: ohci1394
     Kernel modules: firewire-ohci, ohci1394

01:04.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller 
(rev 02) (prog-if 01)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at f8ffe400 (32-bit, non-prefetchable) [size=256]
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: sdhci-pci
     Kernel modules: sdhci-pci

01:04.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD 
Controller (rev 01)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin A routed to IRQ 10
     Region 0: Memory at f8ffd000 (32-bit, non-prefetchable) [size=4K]
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 30
     Region 0: I/O ports at d800 [size=256]
     Region 2: Memory at f9eff000 (64-bit, non-prefetchable) [size=4K]
     Region 4: Memory at cfff0000 (64-bit, prefetchable) [size=64K]
     Expansion ROM at f9ec0000 [disabled] [size=128K]
     Capabilities: [40] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable+
         Address: 00000000fee0200c  Data: 41a9
     Capabilities: [70] Express (v1) Endpoint, MSI 01
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <64us
             ClockPM+ Suprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
         Vector table: BAR=4 offset=00000000
         PBA: BAR=4 offset=00000800
     Capabilities: [d0] Vital Product Data <?>
     Capabilities: [100] Advanced Error Reporting <?>
     Capabilities: [140] Virtual Channel <?>
     Capabilities: [160] Device Serial Number 00-e0-4c-68-00-00-00-02
     Kernel driver in use: r8169
     Kernel modules: r8169

05:00.0 Network controller: Intel Corporation PRO/Wireless 5300 AGN 
[Shiloh] Network Connection
     Subsystem: Intel Corporation Device 1101
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 31
     Region 0: Memory at f9ffe000 (64-bit, non-prefetchable) [size=8K]
     Capabilities: [c8] Power Management version 3
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable+
         Address: 00000000fee0f00c  Data: 41b9
     Capabilities: [e0] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 unlimited
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <128ns, L1 <32us
             ClockPM+ Suprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100] Advanced Error Reporting <?>
     Capabilities: [140] Device Serial Number 9e-b3-58-ff-ff-6a-21-00
     Kernel driver in use: iwlagn
     Kernel modules: iwlagn

07:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600M 
GT] (rev a1)
     Subsystem: Micro-Star International Co., Ltd. Device 7220
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
     Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
     Region 3: Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
     Region 5: I/O ports at ec00 [size=128]
     [virtual] Expansion ROM at feb80000 [disabled] [size=512K]
     Capabilities: [60] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
         Address: 0000000000000000  Data: 0000
     Capabilities: [78] Express (v2) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<256ns, L1 <4us
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <256ns, L1 <1us
             ClockPM- Suprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [b4] Vendor Specific Information <?>
     Capabilities: [100] Virtual Channel <?>
     Capabilities: [128] Power Budgeting <?>
     Capabilities: [600] Vendor Specific Information <?>
     Kernel driver in use: nvidia
     Kernel modules: nvidia-current, nvidiafb, nouveau

     [/proc/scsi/scsi]
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST9500420ASG     Rev: 0002
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
   Vendor: TSSTcorp Model: CDDVDW TS-L633C  Rev: TM00
   Type:   CD-ROM                           ANSI  SCSI revision: 05

     [/proc/tty/ldiscs]
n_tty       0

     [/proc/tty/drivers]
/dev/tty             /dev/tty        5       0 system:/dev/tty
/dev/console         /dev/console    5       1 system:console
/dev/ptmx            /dev/ptmx       5       2 system
/dev/vc/0            /dev/vc/0       4       0 system:vtmaster
usbserial            /dev/ttyUSB   188 0-253 serial
rfcomm               /dev/rfcomm   216 0-255 serial
serial               /dev/ttyS       4 64-111 serial
pty_slave            /dev/pts      136 0-1048575 pty:slave
pty_master           /dev/ptm      128 0-1048575 pty:master
unknown              /dev/tty        4 1-63 console

     [/proc/tty/driver/serial]
serinfo:1.0 driver revision:
0: uart:unknown port:000003F8 irq:4
1: uart:unknown port:000002F8 irq:3
2: uart:unknown port:000003E8 irq:4
3: uart:unknown port:000002E8 irq:3

     [/proc/tty/driver/usbserial]
usbserinfo:1.0 driver:2.0
0: module:ftdi_sio name:"FTDI USB Serial Device" vendor:0403 
product:6001 num_ports:1 port:1 path:usb-0000:00:1a.1-2


Sincerely,
Berkeley Churchill



--------------070609010401050406000807
Content-Type: text/x-csrc;
 name="com.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="com.c"

#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/signal.h>
#include <sys/types.h>

#define BAUDRATE B38400
#define MODEMDEVICE "/dev/ttyS1"
#define _POSIX_SOURCE 1         //POSIX compliant source
#define FALSE 0
#define TRUE 1

volatile int STOP=FALSE;

void signal_handler_IO (int status);    //definition of signal handler
int wait_flag=TRUE;                     //TRUE while no signal received
char devicename[80];
long Baud_Rate = 38400;         // default Baud Rate (110 through 38400)
long BAUD;                      // derived baud rate from command line
long DATABITS;
long STOPBITS;
long PARITYON;
long PARITY;
int Data_Bits = 8;              // Number of data bits
int Stop_Bits = 1;              // Number of stop bits
int Parity = 0;                 // Parity as follows:
                  // 00 = NONE, 01 = Odd, 02 = Even, 03 = Mark, 04 = Space
int Format = 4;
FILE *input;
FILE *output;
int status;

main(int Parm_Count, char *Parms[])
{
   char version[80] = "       POSIX compliant Communications test program version 1.00 4-25-1999\r\n";
   char version1[80] = "          Copyright(C) Mark Zehner/Peter Baumann 1999\r\n";
   char version2[80] = " This code is based on a DOS based test program by Mark Zehner and a Serial\r\n";
   char version3[80] = " Programming POSIX howto by Peter Baumann, integrated by Mark Zehner\r\n";  
   char version4[80] = " This program allows you to send characters out the specified port by typing\r\n";
   char version5[80] = " on the keyboard.  Characters typed will be echoed to the console, and \r\n";
   char version6[80] = " characters received will be echoed to the console.\r\n";
   char version7[80] = " The setup parameters for the device name, receive data format, baud rate\r\n";
   char version8[80] = " and other serial port parameters must be entered on the command line \r\n";
   char version9[80] = " To see how to do this, just type the name of this program. \r\n";
   char version10[80] = " This program is free software; you can redistribute it and/or modify it\r\n";
   char version11[80] = " under the terms of the GNU General Public License as published by the \r\n";
   char version12[80] = " Free Software Foundation, version 2.\r\n";
   char version13[80] = " This program comes with ABSOLUTELY NO WARRANTY.\r\n";
   char instr[100] ="\r\nOn the command you must include six items in the following order, they are:\r\n";
   char instr1[80] ="   1.  The device name      Ex: ttyS0 for com1, ttyS1 for com2, etc\r\n";
   char instr2[80] ="   2.  Baud Rate            Ex: 38400 \r\n";
   char instr3[80] ="   3.  Number of Data Bits  Ex: 8 \r\n";
   char instr4[80] ="   4.  Number of Stop Bits  Ex: 0 or 1\r\n";
   char instr5[80] ="   5.  Parity               Ex: 0=none, 1=odd, 2=even\r\n";
   char instr6[80] ="   6.  Format of data received:  1=hex, 2=dec, 3=hex/asc, 4=dec/asc, 5=asc\r\n";
   char instr7[80] =" Example command line:  com ttyS0 38400 8 0 0 4 \r\n";
   char Param_strings[7][80];
   char message[90];

   int fd, tty, c, res, i, error;
   char In1, Key;
   struct termios oldtio, newtio;       //place for old and new port settings for serial port
   struct termios oldkey, newkey;       //place tor old and new port settings for keyboard teletype
   struct sigaction saio;               //definition of signal action
   char buf[255];                       //buffer for where data is put
   
   input = fopen("/dev/tty", "r");      //open the terminal keyboard
   output = fopen("/dev/tty", "w");     //open the terminal screen

   if (!input || !output)
   {
      fprintf(stderr, "Unable to open /dev/tty\n");
      exit(1);
   }

   error=0;
   fputs(version,output);               //display the program introduction
   fputs(version1,output);
   fputs(version2,output);
   fputs(version3,output);
   fputs(version4,output);
   fputs(version5,output);
   fputs(version6,output);
   fputs(version7,output);
   fputs(version8,output);
   fputs(version9,output);
   fputs(version10,output);
   fputs(version11,output); 
   fputs(version12,output);
   fputs(version13,output);
   //read the parameters from the command line
   if (Parm_Count==7)  //if there are the right number of parameters on the command line
   {
      for (i=1; i<Parm_Count; i++)  // for all wild search parameters
      {
         strcpy(Param_strings[i-1],Parms[i]);
      }
      i=sscanf(Param_strings[0],"%s",devicename);
      if (i != 1) error=1;
      i=sscanf(Param_strings[1],"%li",&Baud_Rate);
      if (i != 1) error=1;
      i=sscanf(Param_strings[2],"%i",&Data_Bits);
      if (i != 1) error=1;
      i=sscanf(Param_strings[3],"%i",&Stop_Bits);
      if (i != 1) error=1;
      i=sscanf(Param_strings[4],"%i",&Parity);
      if (i != 1) error=1;
      i=sscanf(Param_strings[5],"%i",&Format);
      if (i != 1) error=1;
      sprintf(message,"Device=%s, Baud=%li\r\n",devicename, Baud_Rate); //output the received setup parameters
      fputs(message,output);
      sprintf(message,"Data Bits=%i  Stop Bits=%i  Parity=%i  Format=%i\r\n",Data_Bits, Stop_Bits, Parity, Format);
      fputs(message,output);
   }  //end of if param_count==7
   if ((Parm_Count==7) && (error==0))  //if the command line entrys were correct
   {                                    //run the program
      tty = open("/dev/tty", O_RDWR | O_NOCTTY | O_NONBLOCK); //set the user console port up
      tcgetattr(tty,&oldkey); // save current port settings   //so commands are interpreted right for this program
      // set new port settings for non-canonical input processing  //must be NOCTTY
      newkey.c_cflag = BAUDRATE | CRTSCTS | CS8 | CLOCAL | CREAD;
      newkey.c_iflag = IGNPAR;
      newkey.c_oflag = 0;
      newkey.c_lflag = 0;       //ICANON;
      newkey.c_cc[VMIN]=1;
      newkey.c_cc[VTIME]=0;
      tcflush(tty, TCIFLUSH);
      tcsetattr(tty,TCSANOW,&newkey);

      switch (Baud_Rate)
      {
         case 38400:
         default:
            BAUD = B38400;
            break;
         case 19200:
            BAUD  = B19200;
            break;
         case 9600:
            BAUD  = B9600;
            break;
         case 4800:
            BAUD  = B4800;
            break;
         case 2400:
            BAUD  = B2400;
            break;
         case 1800:
            BAUD  = B1800;
            break;
         case 1200:
            BAUD  = B1200;
            break;
         case 600:
            BAUD  = B600;
            break;
         case 300:
            BAUD  = B300;
            break;
         case 200:
            BAUD  = B200;
            break;
         case 150:
            BAUD  = B150;
            break;
         case 134:
            BAUD  = B134;
            break;
         case 110:
            BAUD  = B110;
            break;
         case 75:
            BAUD  = B75;
            break;
         case 50:
            BAUD  = B50;
            break;
      }  //end of switch baud_rate
      switch (Data_Bits)
      {
         case 8:
         default:
            DATABITS = CS8;
            break;
         case 7:
            DATABITS = CS7;
            break;
         case 6:
            DATABITS = CS6;
            break;
         case 5:
            DATABITS = CS5;
            break;
      }  //end of switch data_bits
      switch (Stop_Bits)
      {
         case 1:
         default:
            STOPBITS = 0;
            break;
         case 2:
            STOPBITS = CSTOPB;
            break;
      }  //end of switch stop bits
      switch (Parity)
      {
         case 0:
         default:                       //none
            PARITYON = 0;
            PARITY = 0;
            break;
         case 1:                        //odd
            PARITYON = PARENB;
            PARITY = PARODD;
            break;
         case 2:                        //even
            PARITYON = PARENB;
            PARITY = 0;
            break;
      }  //end of switch parity
       
      //open the device(com port) to be non-blocking (read will return immediately)
      fd = open(devicename, O_RDWR | O_NOCTTY | O_NONBLOCK);
      if (fd < 0)
      {
         perror(devicename);
         exit(-1);
      }

      //install the serial handler before making the device asynchronous
      saio.sa_handler = signal_handler_IO;
      sigemptyset(&saio.sa_mask);   //saio.sa_mask = 0;
      saio.sa_flags = 0;
      saio.sa_restorer = NULL;
      sigaction(SIGIO,&saio,NULL);

      // allow the process to receive SIGIO
      fcntl(fd, F_SETOWN, getpid());
      // Make the file descriptor asynchronous (the manual page says only
      // O_APPEND and O_NONBLOCK, will work with F_SETFL...)
      fcntl(fd, F_SETFL, FASYNC);

      tcgetattr(fd,&oldtio); // save current port settings 
      // set new port settings for canonical input processing 
      newtio.c_cflag = BAUD | CRTSCTS | DATABITS | STOPBITS | PARITYON | PARITY | CLOCAL | CREAD;
      newtio.c_iflag = IGNPAR;
      newtio.c_oflag = 0;
      newtio.c_lflag = 0;       //ICANON;
      newtio.c_cc[VMIN]=1;
      newtio.c_cc[VTIME]=0;
      tcflush(fd, TCIFLUSH);
      tcsetattr(fd,TCSANOW,&newtio);

      // loop while waiting for input. normally we would do something useful here
      while (STOP==FALSE)
      {
         status = fread(&Key,1,1,input);
         if (status==1)  //if a key was hit
         {
            switch (Key)
            { /* branch to appropiate key handler */
               case 0x1b: /* Esc */
                  STOP=TRUE;
                  break;
               default:
                  fputc((int) Key,output);
//                  sprintf(message,"%x ",Key);  //debug
//                  fputs(message,output);
                  write(fd,&Key,1);          //write 1 byte to the port
                  break;
            }  //end of switch key
         }  //end if a key was hit
         // after receiving SIGIO, wait_flag = FALSE, input is available and can be read
         if (wait_flag==FALSE)  //if input is available
         {
            res = read(fd,buf,255);
            if (res>0)
            {
               for (i=0; i<res; i++)  //for all chars in string
               {
                  In1 = buf[i];
                  switch (Format)
                  {
                     case 1:         //hex
                        sprintf(message,"%x ",In1);
                        fputs(message,output);
                        break;
                     case 2:         //decimal
                        sprintf(message,"%d ",In1);
                        fputs(message,output);
                        break;
                     case 3:         //hex and asc
                        if ((In1<32) || (In1>125))
                        {
                           sprintf(message,"%x",In1);
                           fputs(message,output);
                        }
                        else fputc ((int) In1, output);
                        break;
                     case 4:         //decimal and asc
                     default:
                        if ((In1<32) || (In1>125))
                        {
                           sprintf(message,"%d",In1);
                           fputs(message,output);
                        }
                        else fputc ((int) In1, output);
                        break;
                     case 5:         //asc
                        fputc ((int) In1, output);
                        break;
                  }  //end of switch format
               }  //end of for all chars in string
            }  //end if res>0
//            buf[res]=0;
//            printf(":%s:%d\n", buf, res);
//            if (res==1) STOP=TRUE; /* stop loop if only a CR was input */
            wait_flag = TRUE;      /* wait for new input */
         }  //end if wait flag == FALSE

      }  //while stop==FALSE
      // restore old port settings
      tcsetattr(fd,TCSANOW,&oldtio);
      tcsetattr(tty,TCSANOW,&oldkey);
      close(tty);
      close(fd);        //close the com port
   }  //end if command line entrys were correct
   else  //give instructions on how to use the command line
   {
      fputs(instr,output);
      fputs(instr1,output);
      fputs(instr2,output);
      fputs(instr3,output);
      fputs(instr4,output);
      fputs(instr5,output);
      fputs(instr6,output);
      fputs(instr7,output);
   }
   fclose(input);
   fclose(output);
}  //end of main

/***************************************************************************
* signal handler. sets wait_flag to FALSE, to indicate above loop that     *
* characters have been received.                                           *
***************************************************************************/

void signal_handler_IO (int status)
{
//    printf("received SIGIO signal.\n");
   wait_flag = FALSE;
}


--------------070609010401050406000807--
