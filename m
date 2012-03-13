Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684Ab2CMTkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:40:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43219 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759653Ab2CMTj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <CACbLGLK8ZLLHzykKb8LRZO+x+_Cqe6r_dna1=QC4nDGSyWrfNw@mail.gmail.com>
References: <CACbLGLK8ZLLHzykKb8LRZO+x+_Cqe6r_dna1=QC4nDGSyWrfNw@mail.gmail.com>
Date: Tue, 13 Mar 2012 20:39:56 +0100
X-Google-Sender-Auth: WTYu5yKgxu9dLS_2jjZNeC6mVUs
Message-ID: <CACbLGLJTzW-A=oW2hC1URLSCEeVX4RDg--eO=SS3kznXMdB4MQ@mail.gmail.com>
Subject: Fwd: ext4 extents.c bug
From: Frej Eriksson <frej.eriksson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8ff24c7b0b425304bb25064d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff24c7b0b425304bb25064d
Content-Type: text/plain; charset=ISO-8859-1

[1.]
Programs crash / segfault when accessing specific (broken?) files

[2.]
[  950.128885] ------------[ cut here ]------------
[  950.128893] kernel BUG at /build/buildd/linux-2.6.35/fs/ext4/extents.c:1971!

[  950.128898] invalid opcode: 0000 [#1] SMP
[  950.128903] last sysfs file:
/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-4/2-4:1.0/host6/target6:0:0/6:0:0:0/block/sdb/sdb1/uevent
[  950.128908] CPU 0
[  950.128910] Modules linked in: usb_storage cryptd aes_x86_64
aes_generic binfmt_misc rfcomm sco bnep l2cap i8k vmnet vmblock vsock
vmci vmmon parport_pc ppdev arc4 nvidia(P) joydev snd_hda_codec_idt
iwlagn iwlcore snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event mac80211 snd_seq pcmcia
vhba option snd_timer snd_seq_device btusb usb_wwan dell_wmi coretemp
bluetooth usbserial cfg80211 dell_laptop snd yenta_socket pcmcia_rsrc
psmouse pcmcia_core dcdbas serio_raw soundcore snd_page_alloc
intel_agp lp video output parport firewire_ohci ahci firewire_core
crc_itu_t tg3 libahci

[  950.128990]
[  950.128996] Pid: 4227, comm: rsync Tainted: P
2.6.35-30-generic #54-Ubuntu 0HN338/Latitude D830
[  950.129001] RIP: 0010:[<ffffffff8120d8f8>]  [<ffffffff8120d8f8>]
ext4_ext_put_in_cache+0x88/0x90

[  950.129014] RSP: 0018:ffff880109fb7808  EFLAGS: 00010246
[  950.129018] RAX: 0000000001000600 RBX: ffff880109fb7988 RCX: 0000000001000600
[  950.129022] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88010618ba68

[  950.129026] RBP: ffff880109fb7848 R08: 0000000000000002 R09: 0000000000000000
[  950.129030] R10: 0000000000000000 R11: 0000000001000600 R12: 0000000000000000
[  950.129034] R13: 0000000000000000 R14: 0000000001000600 R15: 0000000000000000

[  950.129039] FS:  00007f41d18b5700(0000) GS:ffff880001e00000(0000)
knlGS:0000000000000000
[  950.129043] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  950.129047] CR2: 00007febce3cf000 CR3: 0000000107e37000 CR4: 00000000000006f0

[  950.129052] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  950.129056] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  950.129061] Process rsync (pid: 4227, threadinfo ffff880109fb6000,
task ffff8800c8a08000)

[  950.129064] Stack:
[  950.129066]  ffff88010618ba68 ffff880110d4a180 ffff8801178f8a80
ffff880109fb7988
[  950.129073] <0> ffff88010618ba68 ffff880110d4a180 ffff88010618b9a8
0000000000000000
[  950.129080] <0> ffff880109fb7918 ffffffff812113c9 ffff880109fb7888
ffffffff810841c1

[  950.129088] Call Trace:
[  950.129097]  [<ffffffff812113c9>] ext4_ext_map_blocks+0x2b9/0x7c0
[  950.129104]  [<ffffffff810841c1>] ? lock_hrtimer_base+0x31/0x60
[  950.129112]  [<ffffffff8114e771>] ? __mem_cgroup_try_charge+0x71/0x450

[  950.129119]  [<ffffffff811f13e8>] ext4_map_blocks+0x68/0x200
[  950.129126]  [<ffffffff81036df9>] ? default_spin_lock_flags+0x9/0x10
[  950.129132]  [<ffffffff811f162b>] _ext4_get_block+0xab/0x160

[  950.129138]  [<ffffffff811f1746>] ext4_get_block+0x16/0x20
[  950.129143]  [<ffffffff81188988>] do_mpage_readpage+0x148/0x600
[  950.129150]  [<ffffffff81103658>] ? add_to_page_cache_locked+0xe8/0x160

[  950.129155]  [<ffffffff81188fb3>] mpage_readpages+0x103/0x150
[  950.129161]  [<ffffffff811f1730>] ? ext4_get_block+0x0/0x20
[  950.129167]  [<ffffffff8110a0fd>] ? __alloc_pages_nodemask+0xfd/0x1f0

[  950.129172]  [<ffffffff811f1730>] ? ext4_get_block+0x0/0x20
[  950.129179]  [<ffffffff8113c43a>] ? alloc_pages_current+0x9a/0x100
[  950.129185]  [<ffffffff811edabd>] ext4_readpages+0x1d/0x20

[  950.129191]  [<ffffffff8110d58b>] __do_page_cache_readahead+0x13b/0x210
[  950.129198]  [<ffffffff8110d681>] ra_submit+0x21/0x30
[  950.129203]  [<ffffffff8110da35>] ondemand_readahead+0x115/0x240

[  950.129209]  [<ffffffff8110dc61>] page_cache_sync_readahead+0x31/0x50
[  950.129214]  [<ffffffff8110441e>] T.859+0x31e/0x420
[  950.129221]  [<ffffffff81262eaf>] ? security_inode_permission+0x1f/0x30

[  950.129227]  [<ffffffff81104608>] generic_file_aio_read+0xe8/0x230
[  950.129233]  [<ffffffff8115499a>] do_sync_read+0xda/0x120
[  950.129240]  [<ffffffff81292b38>] ? apparmor_file_permission+0x18/0x20

[  950.129247]  [<ffffffff81261fb6>] ? security_file_permission+0x16/0x20
[  950.129252]  [<ffffffff81155215>] vfs_read+0xb5/0x1a0
[  950.129257]  [<ffffffff81155351>] sys_read+0x51/0x80
[  950.129264]  [<ffffffff8100a0f2>] system_call_fastpath+0x16/0x1b

[  950.129268] Code: 4d 89 b7 38 03 00 00 45 89 87 48 03 00 00 e8 c0
94 e2 ff 66 90 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b
7d f8 c9 c3 <0f> 0b eb fe eb 02 90 90 55 48 89 e5 41 57 41 56 41 55 41
54 53

[  950.129327] RIP  [<ffffffff8120d8f8>] ext4_ext_put_in_cache+0x88/0x90
[  950.129334]  RSP <ffff880109fb7808>
[  950.129339] ---[ end trace 12fa5170cd296b7a ]---

[3.]
ext4, extents.c, kernel, file, segfault


[4.]
Linux version 2.6.35-30-generic (buildd@crested) (gcc version 4.4.5
(Ubuntu/Linaro 4.4.4-14ubuntu5) ) #54-Ubuntu SMP Tue Jun 7 18:41:54
UTC 2011

[5.] Output of Oops.. message (if applicable) with symbolic information

     resolved (see Documentation/oops-tracing.txt)

[6.]
frej@frej-laptop:~/Documents/Parera/Parera Web/deployed/img/content$
cp klassrum.png bla.png
Segmentation fault

[7.] Environment
[7.1.] I am sorry i do not have that script at hand

[7.2.]
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz
stepping	: 6
cpu MHz		: 2492.973
cache size	: 6144 KB
physical id	: 0

siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm dts
tpr_shadow vnmi flexpriority

bogomips	: 4985.94
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23

model name	: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz
stepping	: 6
cpu MHz		: 2492.973
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1

fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm dts
tpr_shadow vnmi flexpriority

bogomips	: 4986.07
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
usb_storage 50788 1 - Live 0xffffffffa0c4a000

cryptd 8140 0 - Live 0xffffffffa0c31000
aes_x86_64 7936 1 - Live 0xffffffffa0c2a000
aes_generic 27631 1 aes_x86_64, Live 0xffffffffa0c21000
binfmt_misc 7984 1 - Live 0xffffffffa0bd0000
rfcomm 40787 4 - Live 0xffffffffa0c0f000

sco 9986 2 - Live 0xffffffffa0bc0000
bnep 11985 2 - Live 0xffffffffa0124000
l2cap 42304 16 rfcomm,bnep, Live 0xffffffffa0c02000
i8k 6074 0 - Live 0xffffffffa0109000
vmnet 47468 15 - Live 0xffffffffa0b4b000

vmblock 12995 1 - Live 0xffffffffa0b5e000
vsock 43307 0 - Live 0xffffffffa0bf5000
vmci 60490 2 vsock, Live 0xffffffffa0ba8000
vmmon 80183 8 - Live 0xffffffffa0bdf000
parport_pc 30086 0 - Live 0xffffffffa00ff000

ppdev 6804 0 - Live 0xffffffffa00b6000
arc4 1497 2 - Live 0xffffffffa0044000
nvidia 10221014 42 - Live 0xffffffffa0189000 (P)
joydev 11395 0 - Live 0xffffffffa009e000
snd_hda_codec_idt 64763 1 - Live 0xffffffffa0178000

iwlagn 202800 0 - Live 0xffffffffa0d5e000
iwlcore 146875 1 iwlagn, Live 0xffffffffa0d0d000
snd_hda_intel 26147 2 - Live 0xffffffffa0164000
snd_hda_codec 100919 2 snd_hda_codec_idt,snd_hda_intel, Live 0xffffffffa0d43000

snd_hwdep 6660 1 snd_hda_codec, Live 0xffffffffa00af000
snd_pcm 89104 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0139000
snd_seq_midi 5932 0 - Live 0xffffffffa0028000
snd_rawmidi 22207 1 snd_seq_midi, Live 0xffffffffa00cb000

snd_seq_midi_event 7291 1 snd_seq_midi, Live 0xffffffffa0024000
mac80211 267099 2 iwlagn,iwlcore, Live 0xffffffffa0b64000
snd_seq 57512 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa0cf5000
pcmcia 40944 0 - Live 0xffffffffa0bd3000

vhba 8925 2 - Live 0xffffffffa012d000
option 16661 0 - Live 0xffffffffa0bb9000
snd_timer 23850 2 snd_pcm,snd_seq, Live 0xffffffffa0bc8000
snd_seq_device 6912 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa0076000

btusb 12961 2 - Live 0xffffffffa0113000
usb_wwan 12201 1 option, Live 0xffffffffa00a8000
dell_wmi 3372 0 - Live 0xffffffffa0041000
coretemp 6442 0 - Live 0xffffffffa0066000
bluetooth 59245 9 rfcomm,sco,bnep,l2cap,btusb, Live 0xffffffffa0153000

usbserial 40364 2 option,usb_wwan, Live 0xffffffffa016c000
cfg80211 170581 3 iwlagn,iwlcore,mac80211, Live 0xffffffffa00d3000
dell_laptop 6722 0 - Live 0xffffffffa0120000
snd 64277 13 snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xffffffffa0082000

yenta_socket 24279 0 - Live 0xffffffffa0131000
pcmcia_rsrc 10357 1 yenta_socket, Live 0xffffffffa0128000
psmouse 62080 0 - Live 0xffffffffa00b9000
pcmcia_core 17677 3 pcmcia,yenta_socket,pcmcia_rsrc, Live 0xffffffffa010c000

dcdbas 6942 1 dell_laptop, Live 0xffffffffa0118000
serio_raw 4910 0 - Live 0xffffffffa00b2000
soundcore 1240 1 snd, Live 0xffffffffa00ac000
snd_page_alloc 8588 2 snd_hda_intel,snd_pcm, Live 0xffffffffa00a3000

intel_agp 32334 0 - Live 0xffffffffa0094000
lp 10201 0 - Live 0xffffffffa0056000
video 22176 0 - Live 0xffffffffa007a000
output 2527 1 video, Live 0xffffffffa0037000
parport 37032 3 parport_pc,ppdev,lp, Live 0xffffffffa006a000

firewire_ohci 24839 0 - Live 0xffffffffa005d000
ahci 22370 3 - Live 0xffffffffa0039000
firewire_core 54327 1 firewire_ohci, Live 0xffffffffa0046000
crc_itu_t 1739 1 firewire_core, Live 0xffffffffa0034000
tg3 135736 0 - Live 0xffffffffa0000000

libahci 26148 1 ahci, Live 0xffffffffa002b000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
frej@frej-laptop:~$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
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

  0170-0177 : 0000:00:1f.1
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:1f.1
    01f0-01f7 : ata_piix
  0376-0376 : 0000:00:1f.1
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.1

    03f6-03f6 : ata_piix
  03f8-03ff : serial
  04d0-04d1 : pnp 00:0b
  0809-0809 : pnp 00:0c
  0900-097f : pnp 00:0b
  0c80-0caf : pnp 00:05
  0cb0-0cbb : pnp 00:0a
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00

  1000-107f : 0000:00:1f.0
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK

  1080-10bf : 0000:00:1f.0
    1080-10bf : pnp 00:0c
  10c0-10df : 0000:00:1f.3
    10c0-10df : pnp 00:0c
  2000-2fff : PCI Bus 0000:0b
  3000-3fff : PCI Bus 0000:0c
  4000-4fff : PCI Bus 0000:09
  5000-5fff : PCI Bus 0000:03

    5000-50ff : PCI CardBus 0000:04
    5400-54ff : PCI CardBus 0000:04
  6eb0-6eb7 : 0000:00:1f.2
    6eb0-6eb7 : ahci
  6eb8-6ebb : 0000:00:1f.2
    6eb8-6ebb : ahci
  6ec0-6ec7 : 0000:00:1f.2
    6ec0-6ec7 : ahci

  6ec8-6ecb : 0000:00:1f.2
    6ec8-6ecb : ahci
  6ee0-6eff : 0000:00:1f.2
    6ee0-6eff : ahci
  6f00-6f1f : 0000:00:1a.1
    6f00-6f1f : uhci_hcd
  6f20-6f3f : 0000:00:1a.0
    6f20-6f3f : uhci_hcd

  6f40-6f5f : 0000:00:1d.2
    6f40-6f5f : uhci_hcd
  6f60-6f7f : 0000:00:1d.1
    6f60-6f7f : uhci_hcd
  6f80-6f9f : 0000:00:1d.0
    6f80-6f9f : uhci_hcd
  6fa0-6faf : 0000:00:1f.1
    6fa0-6faf : ata_piix

  d000-dfff : PCI Bus 0000:0d
  e000-efff : PCI Bus 0000:01
    ef00-ef7f : 0000:01:00.0
  f400-f4fe : pnp 00:0c

frej@frej-laptop:~$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
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

  0170-0177 : 0000:00:1f.1
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:1f.1
    01f0-01f7 : ata_piix
  0376-0376 : 0000:00:1f.1
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.1

    03f6-03f6 : ata_piix
  03f8-03ff : serial
  04d0-04d1 : pnp 00:0b
  0809-0809 : pnp 00:0c
  0900-097f : pnp 00:0b
  0c80-0caf : pnp 00:05
  0cb0-0cbb : pnp 00:0a
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00

  1000-107f : 0000:00:1f.0
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK

  1080-10bf : 0000:00:1f.0
    1080-10bf : pnp 00:0c
  10c0-10df : 0000:00:1f.3
    10c0-10df : pnp 00:0c
  2000-2fff : PCI Bus 0000:0b
  3000-3fff : PCI Bus 0000:0c
  4000-4fff : PCI Bus 0000:09
  5000-5fff : PCI Bus 0000:03

    5000-50ff : PCI CardBus 0000:04
    5400-54ff : PCI CardBus 0000:04
  6eb0-6eb7 : 0000:00:1f.2
    6eb0-6eb7 : ahci
  6eb8-6ebb : 0000:00:1f.2
    6eb8-6ebb : ahci
  6ec0-6ec7 : 0000:00:1f.2
    6ec0-6ec7 : ahci

  6ec8-6ecb : 0000:00:1f.2
    6ec8-6ecb : ahci
  6ee0-6eff : 0000:00:1f.2
    6ee0-6eff : ahci
  6f00-6f1f : 0000:00:1a.1
    6f00-6f1f : uhci_hcd
  6f20-6f3f : 0000:00:1a.0
    6f20-6f3f : uhci_hcd

  6f40-6f5f : 0000:00:1d.2
    6f40-6f5f : uhci_hcd
  6f60-6f7f : 0000:00:1d.1
    6f60-6f7f : uhci_hcd
  6f80-6f9f : 0000:00:1d.0
    6f80-6f9f : uhci_hcd
  6fa0-6faf : 0000:00:1f.1
    6fa0-6faf : ata_piix

  d000-dfff : PCI Bus 0000:0d
  e000-efff : PCI Bus 0000:01
    ef00-ef7f : 0000:01:00.0
  f400-f4fe : pnp 00:0c
frej@frej-laptop:~$ cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009efff : System RAM

0009f000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cffff : pnp 00:0d
000d0000-000dffff : PCI Bus 0000:00
000e0000-000fffff : pnp 00:0d
00100000-dfe5a7ff : System RAM
  01000000-01597892 : Kernel code

  01597893-01ad6c4f : Kernel data
  01bc3000-01d63a53 : Kernel bss
dfe5a800-dfffffff : reserved
  dfe5a800-dfefffff : pnp 00:0d
  dff00000-dfffffff : pnp 00:0d
e0000000-f7ffffff : PCI Bus 0000:00
  e0000000-efffffff : PCI Bus 0000:01

    e0000000-efffffff : 0000:01:00.0
  f0000000-f01fffff : PCI Bus 0000:0d
  f0200000-f03fffff : PCI Bus 0000:0b
  f0400000-f05fffff : PCI Bus 0000:0b
  f0600000-f07fffff : PCI Bus 0000:0c
  f0800000-f09fffff : PCI Bus 0000:09

  f0c00000-f0ffffff : PCI CardBus 0000:04
  f1000000-f13fffff : PCI CardBus 0000:04
  f1a00000-f1afffff : PCI Bus 0000:03
    f1a00000-f1a00fff : 0000:03:01.0
      f1a00000-f1a00fff : yenta_socket
    f1afe800-f1afefff : 0000:03:01.4

    f1aff000-f1afffff : 0000:03:01.4
      f1aff000-f1afffff : firewire_ohci
  f1b00000-f1bfffff : PCI Bus 0000:09
    f1bf0000-f1bfffff : 0000:09:00.0
      f1bf0000-f1bfffff : tg3
  f1c00000-f1efffff : PCI Bus 0000:0d

  f1f00000-f1ffffff : PCI Bus 0000:0c
    f1ffe000-f1ffffff : 0000:0c:00.0
      f1ffe000-f1ffffff : iwlagn
  f2000000-f6efffff : PCI Bus 0000:01
    f2000000-f3ffffff : 0000:01:00.0
    f4000000-f401ffff : 0000:01:00.0

    f5000000-f5ffffff : 0000:01:00.0
      f5000000-f5ffffff : nvidia
  f6ffb700-f6ffb7ff : 0000:00:1f.3
  f6ffb800-f6ffbfff : 0000:00:1f.2
    f6ffb800-f6ffbfff : ahci
  f6ffc000-f6ffffff : 0000:00:1b.0

    f6ffc000-f6ffffff : ICH HD audio
f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f8000000-fbffffff : reserved
    f8000000-fbffffff : pnp 00:0d
fc000000-febfffff : PCI Bus 0000:00
fec00000-fec0ffff : reserved

  fec00000-fec003ff : IOAPIC 0
fec10000-fecfffff : PCI Bus 0000:00
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : pnp 00:08
fed18000-fed1bfff : reserved
  fed18000-fed1bfff : pnp 00:0d
fed1c000-fed1ffff : PCI Bus 0000:00

  fed1c000-fed1c3ff : 0000:00:1d.7
    fed1c000-fed1c3ff : ehci_hcd
  fed1c400-fed1c7ff : 0000:00:1a.7
    fed1c400-fed1c7ff : ehci_hcd
fed20000-fed8ffff : reserved
  fed20000-fed3ffff : pnp 00:0d
  fed40000-fed44fff : PCI Bus 0000:00

    fed40000-fed44fff : pnp 00:0a
  fed45000-fed8ffff : pnp 00:0d
fed90000-fed9ffff : PCI Bus 0000:00
feda0000-feda5fff : reserved
  feda0000-feda3fff : pnp 00:0d
  feda4000-feda4fff : pnp 00:0d
  feda5000-feda5fff : pnp 00:0d

feda6000-feda6fff : pnp 00:0d
feda7000-fedfffff : PCI Bus 0000:00
fee00000-fee0ffff : reserved
  fee00000-fee0ffff : pnp 00:0d
    fee00000-fee00fff : Local APIC
fee10000-ff9fffff : PCI Bus 0000:00
ffa00000-ffbfffff : pnp 00:0d

ffc00000-ffdfffff : PCI Bus 0000:00
ffe00000-ffffffff : reserved
  ffe00000-ffffffff : pnp 00:0d
100002000-11fffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)
see attached file



[7.6.] SCSI information (from /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: DVD+-RW TS-L632H Rev: D400
  Type:   CD-ROM                           ANSI  SCSI revision: 05

Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Kingston SSDNow  Rev: B090
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: CDEmu    Model: Virt. CD/DVD-ROM Rev: 1.10

  Type:   CD-ROM                           ANSI  SCSI revision: 00
Host: scsi5 Channel: 00 Id: 01 Lun: 00
  Vendor: CDEmu    Model: Virt. CD/DVD-ROM Rev: 1.10
  Type:   CD-ROM                           ANSI  SCSI revision: 00

Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: WD       Model: Ext HDD 1021     Rev: 2002
  Type:   Direct-Access                    ANSI  SCSI revision: 02

[7.7.] Other information that might be relevant to the problem

       (please look in /proc and include all information that you
       think to be relevant):

[X.] Other notes, patches, fixes, workarounds:
I have not found any workaround. I have tried booting on latest
"www.sysresccd.org" in order to try on a later Kernel version. But the
error is the same. It seems like some files on my filesystem are
corrupt and trigger this when being read.

I have run fsck on my system and also from the sysresccd (v 1.42). No
errors are being reported.

I can run "mv" on a broken file if that is of any help to you, ls
shows file size.

Best regards,

Frej Eriksson

--e89a8ff24c7b0b425304bb25064d
Content-Type: application/octet-stream; name="out.fil"
Content-Disposition: attachment; filename="out.fil"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gzrbun0g0

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gTW9iaWxlIFBNOTY1L0dNOTY1
L0dMOTYwIE1lbW9yeSBDb250cm9sbGVyIEh1YiAocmV2IDBjKQoJU3Vic3lzdGVtOiBEZWxsIERl
dmljZSAwMWZlCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJ
TlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJ
U3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJ
Q2FwYWJpbGl0aWVzOiBbZTBdIFZlbmRvciBTcGVjaWZpYyBJbmZvcm1hdGlvbjogTGVuPTBhIDw/
PgoJS2VybmVsIG1vZHVsZXM6IGludGVsLWFncAoKMDA6MDEuMCBQQ0kgYnJpZGdlOiBJbnRlbCBD
b3Jwb3JhdGlvbiBNb2JpbGUgUE05NjUvR005NjUvR0w5NjAgUENJIEV4cHJlc3MgUm9vdCBQb3J0
IChyZXYgMGMpIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTysgTWVt
KyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBp
bmctIFNFUlIrIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VS
Ui0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglC
dXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMSwgc3Vib3JkaW5hdGU9MDEsIHNlYy1sYXRlbmN5
PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwZTAwMC0wMDAwZWZmZgoJTWVtb3J5IGJlaGluZCBi
cmlkZ2U6IGYyMDAwMDAwLWY2ZWZmZmZmCglQcmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlk
Z2U6IDAwMDAwMDAwZTAwMDAwMDAtMDAwMDAwMDBlZmZmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czog
NjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1B
Ym9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlIrIE5vSVNBLSBWR0Er
IE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJCVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NU
bXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2FwYWJpbGl0aWVzOiBbODhdIFN1YnN5c3RlbTogRGVs
bCBEZXZpY2UgMDFmZQoJQ2FwYWJpbGl0aWVzOiBbODBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lv
biAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCss
RDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJs
ZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzkwXSBNU0k6IEVuYWJsZSsg
Q291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiBmZWUwMzAwYyAgRGF0YTogNDE1
MQoJQ2FwYWJpbGl0aWVzOiBbYTBdIEV4cHJlc3MgKHYxKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJ
IDAwCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kg
TDBzIDw2NG5zLCBMMSA8MXVzCgkJCUV4dFRhZy0gUkJFKyBGTFJlc2V0LQoJCURldkN0bDoJUmVw
b3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQoJ
CQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQYXls
b2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnIrIFVu
Y29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyLSBUcmFuc1BlbmQtCgkJTG5rQ2Fw
OglQb3J0ICMyLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MTYsIEFTUE0gTDBzIEwxLCBMYXRlbmN5
IEwwIDwyNTZucywgTDEgPDR1cwoJCQlDbG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3Tm90
LQoJCUxua0N0bDoJQVNQTSBMMHMgTDEgRW5hYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBS
ZXRyYWluLSBDb21tQ2xrKwoJCQlFeHRTeW5jaC0gQ2xvY2tQTS0gQXV0V2lkRGlzLSBCV0ludC0g
QXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MTYsIFRyRXJyLSBUcmFp
bi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0KCQlTbHRDYXA6CUF0dG5CdG4t
IFB3ckN0cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnKyBTdXJwcmlzZS0KCQkJU2xv
dCAjMSwgUG93ZXJMaW1pdCA3NS4wMDBXOyBJbnRlcmxvY2stIE5vQ29tcGwrCgkJU2x0Q3RsOglF
bmFibGU6IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0LSBDbWRDcGx0LSBIUElycS0gTGlu
a0NoZy0KCQkJQ29udHJvbDogQXR0bkluZCBPZmYsIFB3ckluZCBPbiwgUG93ZXItIEludGVybG9j
ay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0gQ21kQ3BsdC0gUHJl
c0RldCsgSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQrIExpbmtTdGF0ZS0KCQlS
b290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50RW5h
LSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0YTogUE1FIFJlcUlE
IDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCUNhcGFiaWxpdGllczogWzEwMCB2MV0gVmly
dHVhbCBDaGFubmVsCgkJQ2FwczoJTFBFVkM9MCBSZWZDbGs9MTAwbnMgUEFURW50cnlCaXRzPTEK
CQlBcmI6CUZpeGVkKyBXUlIzMi0gV1JSNjQtIFdSUjEyOC0KCQlDdHJsOglBcmJTZWxlY3Q9Rml4
ZWQKCQlTdGF0dXM6CUluUHJvZ3Jlc3MtCgkJVkMwOglDYXBzOglQQVRPZmZzZXQ9MDAgTWF4VGlt
ZVNsb3RzPTEgUmVqU25vb3BUcmFucy0KCQkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIx
MjgtIFRXUlIxMjgtIFdSUjI1Ni0KCQkJQ3RybDoJRW5hYmxlKyBJRD0wIEFyYlNlbGVjdD1GaXhl
ZCBUQy9WQz0wMQoJCQlTdGF0dXM6CU5lZ29QZW5kaW5nLSBJblByb2dyZXNzLQoJQ2FwYWJpbGl0
aWVzOiBbMTQwIHYxXSBSb290IENvbXBsZXggTGluawoJCURlc2M6CVBvcnROdW1iZXI9MDIgQ29t
cG9uZW50SUQ9MDEgRWx0VHlwZT1Db25maWcKCQlMaW5rMDoJRGVzYzoJVGFyZ2V0UG9ydD0wMCBU
YXJnZXRDb21wb25lbnQ9MDEgQXNzb2NSQ1JCLSBMaW5rVHlwZT1NZW1NYXBwZWQgTGlua1ZhbGlk
KwoJCQlBZGRyOgkwMDAwMDAwMGZlZGE1MDAwCglLZXJuZWwgZHJpdmVyIGluIHVzZTogcGNpZXBv
cnQKCUtlcm5lbCBtb2R1bGVzOiBzaHBjaHAKCjAwOjFhLjAgVVNCIENvbnRyb2xsZXI6IEludGVs
IENvcnBvcmF0aW9uIDgyODAxSCAoSUNIOCBGYW1pbHkpIFVTQiBVSENJIENvbnRyb2xsZXIgIzQg
KHJldiAwMikgKHByb2ctaWYgMDAgW1VIQ0ldKQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZl
CglDb250cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBD
YXAtIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8
VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1
cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMjAKCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgNmYyMCBb
c2l6ZT0zMl0KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiB1aGNpX2hjZAoKMDA6MWEuMSBVU0IgQ29u
dHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kg
Q29udHJvbGxlciAjNSAocmV2IDAyKSAocHJvZy1pZiAwMCBbVUhDSV0pCglTdWJzeXN0ZW06IERl
bGwgRGV2aWNlIDAxZmUKCUNvbnRyb2w6IEkvTysgTWVtLSBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0g
TWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lO
VHgtCglTdGF0dXM6IENhcC0gNjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVk
aXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVu
Y3k6IDAKCUludGVycnVwdDogcGluIEIgcm91dGVkIHRvIElSUSAyMQoJUmVnaW9uIDQ6IEkvTyBw
b3J0cyBhdCA2ZjAwIFtzaXplPTMyXQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHVoY2lfaGNkCgow
MDoxYS43IFVTQiBDb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUggKElDSDggRmFt
aWx5KSBVU0IyIEVIQ0kgQ29udHJvbGxlciAjMiAocmV2IDAyKSAocHJvZy1pZiAyMCBbRUhDSV0p
CglTdWJzeXN0ZW06IERlbGwgRGV2aWNlIDAxZmUKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0
ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIr
IEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQisgUGFy
RXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVS
Ui0gSU5UeC0KCUxhdGVuY3k6IDAKCUludGVycnVwdDogcGluIEMgcm91dGVkIHRvIElSUSAyMgoJ
UmVnaW9uIDA6IE1lbW9yeSBhdCBmZWQxYzQwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBb
c2l6ZT0xS10KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJ
CUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTM3NW1BIFBNRShEMCssRDEt
LEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0g
RFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzU4XSBEZWJ1ZyBwb3J0OiBCQVI9
MSBvZmZzZXQ9MDBhMAoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGVoY2lfaGNkCgowMDoxYi4wIEF1
ZGlvIGRldmljZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgSEQgQXVk
aW8gQ29udHJvbGxlciAocmV2IDAyKQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZlCglDb250
cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2
TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0g
PE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXpl
OiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDQ2CglSZWdpb24gMDog
TWVtb3J5IGF0IGY2ZmZjMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10K
CUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQ
TUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTU1bUEgUE1FKEQwKyxEMS0sRDItLEQzaG90
KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNj
YWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNjBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFz
a2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwZmVlMDMwMGMgIERhdGE6IDQxYTEKCUNh
cGFiaWxpdGllczogWzcwXSBFeHByZXNzICh2MSkgUm9vdCBDb21wbGV4IEludGVncmF0ZWQgRW5k
cG9pbnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAw
LCBMYXRlbmN5IEwwcyB1bmxpbWl0ZWQsIEwxIHVubGltaXRlZAoJCQlFeHRUYWctIFJCRS0gRkxS
ZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZh
dGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0g
Tm9Tbm9vcCsKCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJ
RGV2U3RhOglDb3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisg
VHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3BlZWQgdW5rbm93biwgV2lkdGggeDAsIEFT
UE0gdW5rbm93biwgTGF0ZW5jeSBMMCA8NjRucywgTDEgPDF1cwoJCQlDbG9ja1BNLSBTdXJwcmlz
ZS0gTExBY3RSZXAtIEJ3Tm90LQoJCUxua0N0bDoJQVNQTSBEaXNhYmxlZDsgRGlzYWJsZWQtIFJl
dHJhaW4tIENvbW1DbGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBB
dXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIHVua25vd24sIFdpZHRoIHgwLCBUckVyci0gVHJhaW4t
IFNsb3RDbGstIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCglDYXBhYmlsaXRpZXM6IFsxMDAg
djFdIFZpcnR1YWwgQ2hhbm5lbAoJCUNhcHM6CUxQRVZDPTAgUmVmQ2xrPTEwMG5zIFBBVEVudHJ5
Qml0cz0xCgkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtCgkJQ3RybDoJQXJiU2Vs
ZWN0PUZpeGVkCgkJU3RhdHVzOglJblByb2dyZXNzLQoJCVZDMDoJQ2FwczoJUEFUT2Zmc2V0PTAw
IE1heFRpbWVTbG90cz0xIFJlalNub29wVHJhbnMtCgkJCUFyYjoJRml4ZWQtIFdSUjMyLSBXUlI2
NC0gV1JSMTI4LSBUV1JSMTI4LSBXUlIyNTYtCgkJCUN0cmw6CUVuYWJsZSsgSUQ9MCBBcmJTZWxl
Y3Q9Rml4ZWQgVEMvVkM9MDEKCQkJU3RhdHVzOglOZWdvUGVuZGluZy0gSW5Qcm9ncmVzcy0KCQlW
QzE6CUNhcHM6CVBBVE9mZnNldD0wMCBNYXhUaW1lU2xvdHM9MSBSZWpTbm9vcFRyYW5zLQoJCQlB
cmI6CUZpeGVkLSBXUlIzMi0gV1JSNjQtIFdSUjEyOC0gVFdSUjEyOC0gV1JSMjU2LQoJCQlDdHJs
OglFbmFibGUrIElEPTEgQXJiU2VsZWN0PUZpeGVkIFRDL1ZDPTgwCgkJCVN0YXR1czoJTmVnb1Bl
bmRpbmctIEluUHJvZ3Jlc3MtCglDYXBhYmlsaXRpZXM6IFsxMzAgdjFdIFJvb3QgQ29tcGxleCBM
aW5rCgkJRGVzYzoJUG9ydE51bWJlcj0wZiBDb21wb25lbnRJRD0wMiBFbHRUeXBlPUNvbmZpZwoJ
CUxpbmswOglEZXNjOglUYXJnZXRQb3J0PTAwIFRhcmdldENvbXBvbmVudD0wMiBBc3NvY1JDUkIt
IExpbmtUeXBlPU1lbU1hcHBlZCBMaW5rVmFsaWQrCgkJCUFkZHI6CTAwMDAwMDAwZmVkMTgwMDAK
CUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBIREEgSW50ZWwKCUtlcm5lbCBtb2R1bGVzOiBzbmQtaGRh
LWludGVsCgowMDoxYy4wIFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSCAoSUNI
OCBGYW1pbHkpIFBDSSBFeHByZXNzIFBvcnQgMSAocmV2IDAyKSAocHJvZy1pZiAwMCBbTm9ybWFs
IGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJ
TlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4KwoJ
U3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwg
Q2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MGIs
IHN1Ym9yZGluYXRlPTBiLCBzZWMtbGF0ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMDIw
MDAtMDAwMDJmZmYKCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBmMDIwMDAwMC1mMDNmZmZmZgoJUHJl
ZmV0Y2hhYmxlIG1lbW9yeSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGYwNDAwMDAwLTAwMDAwMDAw
ZjA1ZmZmZmYKCVNlY29uZGFyeSBzdGF0dXM6IDY2TUh6LSBGYXN0QjJCLSBQYXJFcnItIERFVlNF
TD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtIDxTRVJSLSA8UEVSUi0KCUJyaWRnZUN0
bDogUGFyaXR5LSBTRVJSKyBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQ
cmlEaXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzQwXSBFeHByZXNzICh2MSkgUm9vdCBQb3J0IChTbG90KyksIE1TSSAwMAoJCURl
dkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyB1bmxp
bWl0ZWQsIEwxIHVubGltaXRlZAoJCQlFeHRUYWctIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJl
cG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0K
CQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5
bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBV
bmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1cHBSZXEtIEF1eFB3cisgVHJhbnNQZW5kLQoJCUxua0Nh
cDoJUG9ydCAjMSwgU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIEFTUE0gTDBzIEwxLCBMYXRlbmN5
IEwwIDwxdXMsIEwxIDw0dXMKCQkJQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwKyBCd05vdC0K
CQlMbmtDdGw6CUFTUE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0g
Q29tbUNsay0KCQkJRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50
LQoJCUxua1N0YToJU3BlZWQgMi41R1QvcywgV2lkdGggeDAsIFRyRXJyLSBUcmFpbi0gU2xvdENs
aysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0KCQlTbHRDYXA6CUF0dG5CdG4tIFB3ckN0cmwt
IE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnKyBTdXJwcmlzZSsKCQkJU2xvdCAjMiwgUG93
ZXJMaW1pdCA2LjUwMFc7IEludGVybG9jay0gTm9Db21wbC0KCQlTbHRDdGw6CUVuYWJsZTogQXR0
bkJ0bi0gUHdyRmx0LSBNUkwtIFByZXNEZXQrIENtZENwbHQtIEhQSXJxLSBMaW5rQ2hnLQoJCQlD
b250cm9sOiBBdHRuSW5kIFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50ZXJsb2Nr
LQoJCVNsdFN0YToJU3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0LSBQcmVz
RGV0LSBJbnRlcmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRlLQoJCVJv
b3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJbnRFbmEt
IENSU1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQTUUgUmVxSUQg
MDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJQ2FwYWJpbGl0aWVzOiBbODBdIE1TSTogRW5h
YmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0LQoJCUFkZHJlc3M6IGZlZTAzMDBjICBEYXRh
OiA0MTU5CglDYXBhYmlsaXRpZXM6IFs5MF0gU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZlCglD
YXBhYmlsaXRpZXM6IFthMF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1F
Q2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQzaG90KyxE
M2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxl
PTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbMTAwIHYxXSBWaXJ0dWFsIENoYW5uZWwKCQlDYXBzOglM
UEVWQz0wIFJlZkNsaz0xMDBucyBQQVRFbnRyeUJpdHM9MQoJCUFyYjoJRml4ZWQrIFdSUjMyLSBX
UlI2NC0gV1JSMTI4LQoJCUN0cmw6CUFyYlNlbGVjdD1GaXhlZAoJCVN0YXR1czoJSW5Qcm9ncmVz
cy0KCQlWQzA6CUNhcHM6CVBBVE9mZnNldD0wMCBNYXhUaW1lU2xvdHM9MSBSZWpTbm9vcFRyYW5z
LQoJCQlBcmI6CUZpeGVkKyBXUlIzMi0gV1JSNjQtIFdSUjEyOC0gVFdSUjEyOC0gV1JSMjU2LQoJ
CQlDdHJsOglFbmFibGUrIElEPTAgQXJiU2VsZWN0PUZpeGVkIFRDL1ZDPWZmCgkJCVN0YXR1czoJ
TmVnb1BlbmRpbmctIEluUHJvZ3Jlc3MtCglDYXBhYmlsaXRpZXM6IFsxODAgdjFdIFJvb3QgQ29t
cGxleCBMaW5rCgkJRGVzYzoJUG9ydE51bWJlcj0wMSBDb21wb25lbnRJRD0wMiBFbHRUeXBlPUNv
bmZpZwoJCUxpbmswOglEZXNjOglUYXJnZXRQb3J0PTAwIFRhcmdldENvbXBvbmVudD0wMiBBc3Nv
Y1JDUkItIExpbmtUeXBlPU1lbU1hcHBlZCBMaW5rVmFsaWQrCgkJCUFkZHI6CTAwMDAwMDAwZmVk
MTgwMDEKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2VybmVsIG1vZHVsZXM6IHNo
cGNocAoKMDA6MWMuMSBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUggKElDSDgg
RmFtaWx5KSBQQ0kgRXhwcmVzcyBQb3J0IDIgKHJldiAwMikgKHByb2ctaWYgMDAgW05vcm1hbCBk
ZWNvZGVdKQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5W
LSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUisgRmFzdEIyQi0gRGlzSU5UeCsKCVN0
YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENh
Y2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5PTBjLCBz
dWJvcmRpbmF0ZT0wYywgc2VjLWxhdGVuY3k9MAoJSS9PIGJlaGluZCBicmlkZ2U6IDAwMDAzMDAw
LTAwMDAzZmZmCglNZW1vcnkgYmVoaW5kIGJyaWRnZTogZjFmMDAwMDAtZjFmZmZmZmYKCVByZWZl
dGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmMDYwMDAwMC0wMDAwMDAwMGYw
N2ZmZmZmCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9
ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA8U0VSUi0gPFBFUlItCglCcmlkZ2VDdGw6
IFBhcml0eS0gU0VSUisgTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkItCgkJUHJp
RGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJTRVJSRW4tCglDYXBhYmls
aXRpZXM6IFs0MF0gRXhwcmVzcyAodjEpIFJvb3QgUG9ydCAoU2xvdCspLCBNU0kgMDAKCQlEZXZD
YXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgdW5saW1p
dGVkLCBMMSB1bmxpbWl0ZWQKCQkJRXh0VGFnLSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBv
cnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJ
CVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3AtCgkJCU1heFBheWxv
YWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBieXRlcwoJCURldlN0YToJQ29yckVycisgVW5j
b3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5zUGVuZC0KCQlMbmtDYXA6
CVBvcnQgIzIsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBM
MCA8MjU2bnMsIEwxIDw0dXMKCQkJQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwKyBCd05vdC0K
CQlMbmtDdGw6CUFTUE0gTDBzIEwxIEVuYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0
cmFpbi0gQ29tbUNsaysKCQkJRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1
dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIFRyRXJyLSBUcmFpbi0g
U2xvdENsaysgRExBY3RpdmUrIEJXTWdtdC0gQUJXTWdtdC0KCQlTbHRDYXA6CUF0dG5CdG4tIFB3
ckN0cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVnKyBTdXJwcmlzZSsKCQkJU2xvdCAj
MywgUG93ZXJMaW1pdCA2LjUwMFc7IEludGVybG9jay0gTm9Db21wbC0KCQlTbHRDdGw6CUVuYWJs
ZTogQXR0bkJ0bi0gUHdyRmx0LSBNUkwtIFByZXNEZXQrIENtZENwbHQtIEhQSXJxLSBMaW5rQ2hn
LQoJCQlDb250cm9sOiBBdHRuSW5kIFVua25vd24sIFB3ckluZCBVbmtub3duLCBQb3dlci0gSW50
ZXJsb2NrLQoJCVNsdFN0YToJU3RhdHVzOiBBdHRuQnRuLSBQb3dlckZsdC0gTVJMLSBDbWRDcGx0
LSBQcmVzRGV0KyBJbnRlcmxvY2stCgkJCUNoYW5nZWQ6IE1STC0gUHJlc0RldC0gTGlua1N0YXRl
LQoJCVJvb3RDdGw6IEVyckNvcnJlY3RhYmxlLSBFcnJOb24tRmF0YWwtIEVyckZhdGFsLSBQTUVJ
bnRFbmEtIENSU1Zpc2libGUtCgkJUm9vdENhcDogQ1JTVmlzaWJsZS0KCQlSb290U3RhOiBQTUUg
UmVxSUQgMDAwMCwgUE1FU3RhdHVzLSBQTUVQZW5kaW5nLQoJQ2FwYWJpbGl0aWVzOiBbODBdIE1T
STogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0LQoJCUFkZHJlc3M6IGZlZTAzMDBj
ICBEYXRhOiA0MTYxCglDYXBhYmlsaXRpZXM6IFs5MF0gU3Vic3lzdGVtOiBEZWxsIERldmljZSAw
MWZlCglDYXBhYmlsaXRpZXM6IFthMF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFn
czogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwKyxEMS0sRDItLEQz
aG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAg
RFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbMTAwIHYxXSBWaXJ0dWFsIENoYW5uZWwKCQlD
YXBzOglMUEVWQz0wIFJlZkNsaz0xMDBucyBQQVRFbnRyeUJpdHM9MQoJCUFyYjoJRml4ZWQrIFdS
UjMyLSBXUlI2NC0gV1JSMTI4LQoJCUN0cmw6CUFyYlNlbGVjdD1GaXhlZAoJCVN0YXR1czoJSW5Q
cm9ncmVzcy0KCQlWQzA6CUNhcHM6CVBBVE9mZnNldD0wMCBNYXhUaW1lU2xvdHM9MSBSZWpTbm9v
cFRyYW5zLQoJCQlBcmI6CUZpeGVkKyBXUlIzMi0gV1JSNjQtIFdSUjEyOC0gVFdSUjEyOC0gV1JS
MjU2LQoJCQlDdHJsOglFbmFibGUrIElEPTAgQXJiU2VsZWN0PUZpeGVkIFRDL1ZDPTAxCgkJCVN0
YXR1czoJTmVnb1BlbmRpbmctIEluUHJvZ3Jlc3MtCglDYXBhYmlsaXRpZXM6IFsxODAgdjFdIFJv
b3QgQ29tcGxleCBMaW5rCgkJRGVzYzoJUG9ydE51bWJlcj0wMiBDb21wb25lbnRJRD0wMiBFbHRU
eXBlPUNvbmZpZwoJCUxpbmswOglEZXNjOglUYXJnZXRQb3J0PTAwIFRhcmdldENvbXBvbmVudD0w
MiBBc3NvY1JDUkItIExpbmtUeXBlPU1lbU1hcHBlZCBMaW5rVmFsaWQrCgkJCUFkZHI6CTAwMDAw
MDAwZmVkMTgwMDEKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2VybmVsIG1vZHVs
ZXM6IHNocGNocAoKMDA6MWMuMyBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUgg
KElDSDggRmFtaWx5KSBQQ0kgRXhwcmVzcyBQb3J0IDQgKHJldiAwMikgKHByb2ctaWYgMDAgW05v
cm1hbCBkZWNvZGVdKQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBN
ZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5U
eCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0
ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6
IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUJ1czogcHJpbWFyeT0wMCwgc2Vjb25kYXJ5
PTBkLCBzdWJvcmRpbmF0ZT0wZSwgc2VjLWxhdGVuY3k9MAoJSS9PIGJlaGluZCBicmlkZ2U6IDAw
MDBkMDAwLTAwMDBkZmZmCglNZW1vcnkgYmVoaW5kIGJyaWRnZTogZjFjMDAwMDAtZjFlZmZmZmYK
CVByZWZldGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmMDAwMDAwMC0wMDAw
MDAwMGYwMWZmZmZmCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQi0gUGFyRXJyLSBE
RVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA8U0VSUi0gPFBFUlItCglCcmlk
Z2VDdGw6IFBhcml0eS0gU0VSUisgTm9JU0EtIFZHQS0gTUFib3J0LSA+UmVzZXQtIEZhc3RCMkIt
CgkJUHJpRGlzY1Rtci0gU2VjRGlzY1Rtci0gRGlzY1RtclN0YXQtIERpc2NUbXJTRVJSRW4tCglD
YXBhYmlsaXRpZXM6IFs0MF0gRXhwcmVzcyAodjEpIFJvb3QgUG9ydCAoU2xvdCspLCBNU0kgMDAK
CQlEZXZDYXA6CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMg
dW5saW1pdGVkLCBMMSB1bmxpbWl0ZWQKCQkJRXh0VGFnLSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3Rs
OglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0
ZWQtCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3AtCgkJCU1h
eFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBieXRlcwoJCURldlN0YToJQ29yckVy
ci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5zUGVuZC0KCQlM
bmtDYXA6CVBvcnQgIzQsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0
ZW5jeSBMMCA8MXVzLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcCsgQndO
b3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJh
aW4tIENvbW1DbGstCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRC
V0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgwLCBUckVyci0gVHJhaW4tIFNs
b3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JD
dHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzUs
IFBvd2VyTGltaXQgNi41MDBXOyBJbnRlcmxvY2stIE5vQ29tcGwtCgkJU2x0Q3RsOglFbmFibGU6
IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0KyBDbWRDcGx0LSBIUElycS0gTGlua0NoZy0K
CQkJQ29udHJvbDogQXR0bkluZCBVbmtub3duLCBQd3JJbmQgVW5rbm93biwgUG93ZXItIEludGVy
bG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0gQ21kQ3BsdC0g
UHJlc0RldC0gSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQtIExpbmtTdGF0ZS0K
CQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50
RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0YTogUE1FIFJl
cUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCUNhcGFiaWxpdGllczogWzgwXSBNU0k6
IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiBmZWUwMzAwYyAg
RGF0YTogNDE2OQoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDFm
ZQoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6
IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hv
dCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERT
Y2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzEwMCB2MV0gVmlydHVhbCBDaGFubmVsCgkJQ2Fw
czoJTFBFVkM9MCBSZWZDbGs9MTAwbnMgUEFURW50cnlCaXRzPTEKCQlBcmI6CUZpeGVkKyBXUlIz
Mi0gV1JSNjQtIFdSUjEyOC0KCQlDdHJsOglBcmJTZWxlY3Q9Rml4ZWQKCQlTdGF0dXM6CUluUHJv
Z3Jlc3MtCgkJVkMwOglDYXBzOglQQVRPZmZzZXQ9MDAgTWF4VGltZVNsb3RzPTEgUmVqU25vb3BU
cmFucy0KCQkJQXJiOglGaXhlZCsgV1JSMzItIFdSUjY0LSBXUlIxMjgtIFRXUlIxMjgtIFdSUjI1
Ni0KCQkJQ3RybDoJRW5hYmxlKyBJRD0wIEFyYlNlbGVjdD1GaXhlZCBUQy9WQz1mZgoJCQlTdGF0
dXM6CU5lZ29QZW5kaW5nLSBJblByb2dyZXNzLQoJQ2FwYWJpbGl0aWVzOiBbMTgwIHYxXSBSb290
IENvbXBsZXggTGluawoJCURlc2M6CVBvcnROdW1iZXI9MDQgQ29tcG9uZW50SUQ9MDIgRWx0VHlw
ZT1Db25maWcKCQlMaW5rMDoJRGVzYzoJVGFyZ2V0UG9ydD0wMCBUYXJnZXRDb21wb25lbnQ9MDIg
QXNzb2NSQ1JCLSBMaW5rVHlwZT1NZW1NYXBwZWQgTGlua1ZhbGlkKwoJCQlBZGRyOgkwMDAwMDAw
MGZlZDE4MDAxCglLZXJuZWwgZHJpdmVyIGluIHVzZTogcGNpZXBvcnQKCUtlcm5lbCBtb2R1bGVz
OiBzaHBjaHAKCjAwOjFjLjUgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJ
Q0g4IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCA2IChyZXYgMDIpIChwcm9nLWlmIDAwIFtOb3Jt
YWwgZGVjb2RlXSkKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVt
V0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgr
CglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+
VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAw
LCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0w
OSwgc3Vib3JkaW5hdGU9MDksIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAw
NDAwMC0wMDAwNGZmZgoJTWVtb3J5IGJlaGluZCBicmlkZ2U6IGYxYjAwMDAwLWYxYmZmZmZmCglQ
cmVmZXRjaGFibGUgbWVtb3J5IGJlaGluZCBicmlkZ2U6IDAwMDAwMDAwZjA4MDAwMDAtMDAwMDAw
MDBmMDlmZmZmZgoJU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVW
U0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPFNFUlItIDxQRVJSLQoJQnJpZGdl
Q3RsOiBQYXJpdHktIFNFUlIrIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJ
CVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2Fw
YWJpbGl0aWVzOiBbNDBdIEV4cHJlc3MgKHYxKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJ
RGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIHVu
bGltaXRlZCwgTDEgdW5saW1pdGVkCgkJCUV4dFRhZy0gUkJFKyBGTFJlc2V0LQoJCURldkN0bDoJ
UmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVk
LQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlNYXhQ
YXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJFcnIt
IFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQtCgkJTG5r
Q2FwOglQb3J0ICM2LCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVu
Y3kgTDAgPDI1Nm5zLCBMMSA8NHVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcCsgQndO
b3QtCgkJTG5rQ3RsOglBU1BNIERpc2FibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJh
aW4tIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRC
V0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNs
b3RDbGsrIERMQWN0aXZlKyBCV01nbXQtIEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRuLSBQd3JD
dHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90UGx1ZysgU3VycHJpc2UrCgkJCVNsb3QgIzMs
IFBvd2VyTGltaXQgNi41MDBXOyBJbnRlcmxvY2stIE5vQ29tcGwtCgkJU2x0Q3RsOglFbmFibGU6
IEF0dG5CdG4tIFB3ckZsdC0gTVJMLSBQcmVzRGV0KyBDbWRDcGx0LSBIUElycS0gTGlua0NoZy0K
CQkJQ29udHJvbDogQXR0bkluZCBVbmtub3duLCBQd3JJbmQgVW5rbm93biwgUG93ZXItIEludGVy
bG9jay0KCQlTbHRTdGE6CVN0YXR1czogQXR0bkJ0bi0gUG93ZXJGbHQtIE1STC0gQ21kQ3BsdC0g
UHJlc0RldCsgSW50ZXJsb2NrLQoJCQlDaGFuZ2VkOiBNUkwtIFByZXNEZXQtIExpbmtTdGF0ZS0K
CQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJGYXRhbC0gUE1FSW50
RW5hLSBDUlNWaXNpYmxlLQoJCVJvb3RDYXA6IENSU1Zpc2libGUtCgkJUm9vdFN0YTogUE1FIFJl
cUlEIDAwMDAsIFBNRVN0YXR1cy0gUE1FUGVuZGluZy0KCUNhcGFiaWxpdGllczogWzgwXSBNU0k6
IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiBmZWUwMzAwYyAg
RGF0YTogNDE3MQoJQ2FwYWJpbGl0aWVzOiBbOTBdIFN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDFm
ZQoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6
IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMCssRDEtLEQyLSxEM2hv
dCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERT
Y2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzEwMCB2MV0gVmlydHVhbCBDaGFubmVsCgkJQ2Fw
czoJTFBFVkM9MCBSZWZDbGs9MTAwbnMgUEFURW50cnlCaXRzPTEKCQlBcmI6CUZpeGVkKyBXUlIz
Mi0gV1JSNjQtIFdSUjEyOC0KCQlDdHJsOglBcmJTZWxlY3Q9Rml4ZWQKCQlTdGF0dXM6CUluUHJv
Z3Jlc3MtCgkJVkMwOglDYXBzOglQQVRPZmZzZXQ9MDAgTWF4VGltZVNsb3RzPTEgUmVqU25vb3BU
cmFucy0KCQkJQXJiOglGaXhlZCsgV1JSMzItIFdSUjY0LSBXUlIxMjgtIFRXUlIxMjgtIFdSUjI1
Ni0KCQkJQ3RybDoJRW5hYmxlKyBJRD0wIEFyYlNlbGVjdD1GaXhlZCBUQy9WQz0wMQoJCQlTdGF0
dXM6CU5lZ29QZW5kaW5nLSBJblByb2dyZXNzLQoJQ2FwYWJpbGl0aWVzOiBbMTgwIHYxXSBSb290
IENvbXBsZXggTGluawoJCURlc2M6CVBvcnROdW1iZXI9MDYgQ29tcG9uZW50SUQ9MDIgRWx0VHlw
ZT1Db25maWcKCQlMaW5rMDoJRGVzYzoJVGFyZ2V0UG9ydD0wMCBUYXJnZXRDb21wb25lbnQ9MDIg
QXNzb2NSQ1JCLSBMaW5rVHlwZT1NZW1NYXBwZWQgTGlua1ZhbGlkKwoJCQlBZGRyOgkwMDAwMDAw
MGZlZDE4MDAxCglLZXJuZWwgZHJpdmVyIGluIHVzZTogcGNpZXBvcnQKCUtlcm5lbCBtb2R1bGVz
OiBzaHBjaHAKCjAwOjFkLjAgVVNCIENvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAx
SCAoSUNIOCBGYW1pbHkpIFVTQiBVSENJIENvbnRyb2xsZXIgIzEgKHJldiAwMikgKHByb2ctaWYg
MDAgW1VIQ0ldKQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZlCglDb250cm9sOiBJL08rIE1l
bS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBw
aW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBVREYtIEZh
c3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0
byBJUlEgMjAKCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgNmY4MCBbc2l6ZT0zMl0KCUtlcm5lbCBk
cml2ZXIgaW4gdXNlOiB1aGNpX2hjZAoKMDA6MWQuMSBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29y
cG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjMiAocmV2
IDAyKSAocHJvZy1pZiAwMCBbVUhDSV0pCglTdWJzeXN0ZW06IERlbGwgRGV2aWNlIDAxZmUKCUNv
bnRyb2w6IEkvTysgTWVtLSBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3At
IFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcC0g
NjZNSHotIFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJv
cnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAKCUludGVycnVwdDog
cGluIEIgcm91dGVkIHRvIElSUSAyMQoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCA2ZjYwIFtzaXpl
PTMyXQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHVoY2lfaGNkCgowMDoxZC4yIFVTQiBDb250cm9s
bGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUggKElDSDggRmFtaWx5KSBVU0IgVUhDSSBDb250
cm9sbGVyICMzIChyZXYgMDIpIChwcm9nLWlmIDAwIFtVSENJXSkKCVN1YnN5c3RlbTogRGVsbCBE
ZXZpY2UgMDFmZQoJQ29udHJvbDogSS9PKyBNZW0tIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1X
SU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0K
CVN0YXR1czogQ2FwLSA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1tZWRpdW0g
PlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTog
MAoJSW50ZXJydXB0OiBwaW4gQyByb3V0ZWQgdG8gSVJRIDIyCglSZWdpb24gNDogSS9PIHBvcnRz
IGF0IDZmNDAgW3NpemU9MzJdCglLZXJuZWwgZHJpdmVyIGluIHVzZTogdWhjaV9oY2QKCjAwOjFk
LjcgVVNCIENvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSCAoSUNIOCBGYW1pbHkp
IFVTQjIgRUhDSSBDb250cm9sbGVyICMxIChyZXYgMDIpIChwcm9nLWlmIDIwIFtFSENJXSkKCVN1
YnN5c3RlbTogRGVsbCBEZXZpY2UgMDFmZQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3Rlcisg
U3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUisgRmFz
dEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnIt
IERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJ
TlR4LQoJTGF0ZW5jeTogMAoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDIwCglSZWdp
b24gMDogTWVtb3J5IGF0IGZlZDFjMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXpl
PTFLXQoJQ2FwYWJpbGl0aWVzOiBbNTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxh
Z3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9Mzc1bUEgUE1FKEQwKyxEMS0sRDIt
LEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2Vs
PTAgRFNjYWxlPTAgUE1FKwoJQ2FwYWJpbGl0aWVzOiBbNThdIERlYnVnIHBvcnQ6IEJBUj0xIG9m
ZnNldD0wMGEwCglLZXJuZWwgZHJpdmVyIGluIHVzZTogZWhjaV9oY2QKCjAwOjFlLjAgUENJIGJy
aWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDEgTW9iaWxlIFBDSSBCcmlkZ2UgKHJldiBmMikg
KHByb2ctaWYgMDEgW1N1YnRyYWN0aXZlIGRlY29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVz
TWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBT
RVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkIt
IFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MDMsIHN1
Ym9yZGluYXRlPTA3LCBzZWMtbGF0ZW5jeT0zMgoJSS9PIGJlaGluZCBicmlkZ2U6IDAwMDA1MDAw
LTAwMDA1ZmZmCglNZW1vcnkgYmVoaW5kIGJyaWRnZTogZjFhMDAwMDAtZjFhZmZmZmYKCVByZWZl
dGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogMDAwMDAwMDBmZmYwMDAwMC0wMDAwMDAwMDAw
MGZmZmZmCglTZWNvbmRhcnkgc3RhdHVzOiA2Nk1Iei0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9
bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQrIDxTRVJSLSA8UEVSUisKCUJyaWRnZUN0
bDogUGFyaXR5LSBTRVJSKyBOb0lTQS0gVkdBLSBNQWJvcnQtID5SZXNldC0gRmFzdEIyQi0KCQlQ
cmlEaXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1RtclNFUlJFbi0KCUNhcGFi
aWxpdGllczogWzUwXSBTdWJzeXN0ZW06IERlbGwgRGV2aWNlIDAxZmUKCjAwOjFmLjAgSVNBIGJy
aWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIRU0gKElDSDhNKSBMUEMgSW50ZXJmYWNlIENv
bnRyb2xsZXIgKHJldiAwMikKCVN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDFmZQoJQ29udHJvbDog
SS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJy
LSBTdGVwcGluZy0gU0VSUisgRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0g
VURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1B
Ym9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMAoJQ2FwYWJpbGl0aWVzOiBbZTBd
IFZlbmRvciBTcGVjaWZpYyBJbmZvcm1hdGlvbjogTGVuPTBjIDw/PgoJS2VybmVsIG1vZHVsZXM6
IGlUQ09fd2R0CgowMDoxZi4xIElERSBpbnRlcmZhY2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAx
SEJNL0hFTSAoSUNIOE0vSUNIOE0tRSkgSURFIENvbnRyb2xsZXIgKHJldiAwMikgKHByb2ctaWYg
OGEgW01hc3RlciBTZWNQIFByaVBdKQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZlCglDb250
cm9sOiBJL08rIE1lbS0gQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQ
YXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2
TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0
LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBp
biBBIHJvdXRlZCB0byBJUlEgMTYKCVJlZ2lvbiAwOiBJL08gcG9ydHMgYXQgMDFmMCBbc2l6ZT04
XQoJUmVnaW9uIDE6IEkvTyBwb3J0cyBhdCAwM2Y0IFtzaXplPTFdCglSZWdpb24gMjogSS9PIHBv
cnRzIGF0IDAxNzAgW3NpemU9OF0KCVJlZ2lvbiAzOiBJL08gcG9ydHMgYXQgMDM3NCBbc2l6ZT0x
XQoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCA2ZmEwIFtzaXplPTE2XQoJS2VybmVsIGRyaXZlciBp
biB1c2U6IGF0YV9waWl4CgowMDoxZi4yIFNBVEEgY29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRp
b24gODI4MDFIQk0vSEVNIChJQ0g4TS9JQ0g4TS1FKSBTQVRBIEFIQ0kgQ29udHJvbGxlciAocmV2
IDAyKSAocHJvZy1pZiAwMSBbQUhDSSAxLjBdKQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZl
CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNu
b29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBD
YXArIDY2TUh6KyBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8
VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1
cHQ6IHBpbiBDIHJvdXRlZCB0byBJUlEgNDUKCVJlZ2lvbiAwOiBJL08gcG9ydHMgYXQgNmViMCBb
c2l6ZT04XQoJUmVnaW9uIDE6IEkvTyBwb3J0cyBhdCA2ZWI4IFtzaXplPTRdCglSZWdpb24gMjog
SS9PIHBvcnRzIGF0IDZlYzAgW3NpemU9OF0KCVJlZ2lvbiAzOiBJL08gcG9ydHMgYXQgNmVjOCBb
c2l6ZT00XQoJUmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCA2ZWUwIFtzaXplPTMyXQoJUmVnaW9uIDU6
IE1lbW9yeSBhdCBmNmZmYjgwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0yS10K
CUNhcGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS80IE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMzAwYyAgRGF0YTogNDE5OQoJQ2FwYWJpbGl0aWVzOiBbNzBdIFBv
d2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xkLSkKCQlTdGF0dXM6IEQw
IE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGll
czogW2E4XSBTQVRBIEhCQSB2MS4wIEJBUjQgT2Zmc2V0PTAwMDAwMDA0CglLZXJuZWwgZHJpdmVy
IGluIHVzZTogYWhjaQoJS2VybmVsIG1vZHVsZXM6IGFoY2kKCjAwOjFmLjMgU01CdXM6IEludGVs
IENvcnBvcmF0aW9uIDgyODAxSCAoSUNIOCBGYW1pbHkpIFNNQnVzIENvbnRyb2xsZXIgKHJldiAw
MikKCVN1YnN5c3RlbTogRGVsbCBEZXZpY2UgMDFmZQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01h
c3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VS
UisgRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwLSA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQ
YXJFcnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLSBJTlR4LQoJSW50ZXJydXB0OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDMKCVJlZ2lvbiAwOiBN
ZW1vcnkgYXQgZjZmZmI3MDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MjU2XQoJ
UmVnaW9uIDQ6IEkvTyBwb3J0cyBhdCAxMGMwIFtzaXplPTMyXQoJS2VybmVsIG1vZHVsZXM6IGky
Yy1pODAxCgowMTowMC4wIFZHQSBjb21wYXRpYmxlIGNvbnRyb2xsZXI6IG5WaWRpYSBDb3Jwb3Jh
dGlvbiBHODZNIFtRdWFkcm8gTlZTIDEzNU1dIChyZXYgYTEpIChwcm9nLWlmIDAwIFtWR0EgY29u
dHJvbGxlcl0pCglTdWJzeXN0ZW06IERlbGwgRGV2aWNlIDAxZmUKCUNvbnRyb2w6IEkvTysgTWVt
KyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBp
bmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VS
Ui0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJ
UlEgMTYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZjUwMDAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNo
YWJsZSkgW3NpemU9MTZNXQoJUmVnaW9uIDE6IE1lbW9yeSBhdCBlMDAwMDAwMCAoNjQtYml0LCBw
cmVmZXRjaGFibGUpIFtzaXplPTI1Nk1dCglSZWdpb24gMzogTWVtb3J5IGF0IGYyMDAwMDAwICg2
NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTMyTV0KCVJlZ2lvbiA1OiBJL08gcG9ydHMg
YXQgZWYwMCBbc2l6ZT0xMjhdCglbdmlydHVhbF0gRXhwYW5zaW9uIFJPTSBhdCBmNDAwMDAwMCBb
ZGlzYWJsZWRdIFtzaXplPTEyOEtdCglDYXBhYmlsaXRpZXM6IFs2MF0gUG93ZXIgTWFuYWdlbWVu
dCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEg
UE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQ
TUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNjhdIE1TSTog
RW5hYmxlLSBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0KwoJCUFkZHJlc3M6IDAwMDAwMDAwMDAw
MDAwMDAgIERhdGE6IDAwMDAKCUNhcGFiaWxpdGllczogWzc4XSBFeHByZXNzICh2MSkgRW5kcG9p
bnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBM
YXRlbmN5IEwwcyA8NTEybnMsIEwxIDw0dXMKCQkJRXh0VGFnKyBBdHRuQnRuLSBBdHRuSW5kLSBQ
d3JJbmQtIFJCRSsgRkxSZXNldC0KCQlEZXZDdGw6CVJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxl
LSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KCQkJUmx4ZE9yZCsgRXh0VGFnKyBQaGFu
dEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcCsKCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRS
ZXEgNTEyIGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBVbmNvcnJFcnItIEZhdGFsRXJyLSBVbnN1
cHBSZXEtIEF1eFB3ci0gVHJhbnNQZW5kLQoJCUxua0NhcDoJUG9ydCAjMCwgU3BlZWQgMi41R1Qv
cywgV2lkdGggeDE2LCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8NTEybnMsIEwxIDw0dXMKCQkJ
Q2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KCQlMbmtDdGw6CUFTUE0gTDBzIEwx
IEVuYWJsZWQ7IFJDQiAxMjggYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4
dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNw
ZWVkIDIuNUdUL3MsIFdpZHRoIHgxNiwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0g
QldNZ210LSBBQldNZ210LQoJQ2FwYWJpbGl0aWVzOiBbMTAwIHYxXSBWaXJ0dWFsIENoYW5uZWwK
CQlDYXBzOglMUEVWQz0wIFJlZkNsaz0xMDBucyBQQVRFbnRyeUJpdHM9MQoJCUFyYjoJRml4ZWQt
IFdSUjMyLSBXUlI2NC0gV1JSMTI4LQoJCUN0cmw6CUFyYlNlbGVjdD1GaXhlZAoJCVN0YXR1czoJ
SW5Qcm9ncmVzcy0KCQlWQzA6CUNhcHM6CVBBVE9mZnNldD0wMCBNYXhUaW1lU2xvdHM9MSBSZWpT
bm9vcFRyYW5zLQoJCQlBcmI6CUZpeGVkLSBXUlIzMi0gV1JSNjQtIFdSUjEyOC0gVFdSUjEyOC0g
V1JSMjU2LQoJCQlDdHJsOglFbmFibGUrIElEPTAgQXJiU2VsZWN0PUZpeGVkIFRDL1ZDPTAxCgkJ
CVN0YXR1czoJTmVnb1BlbmRpbmctIEluUHJvZ3Jlc3MtCglDYXBhYmlsaXRpZXM6IFsxMjggdjFd
IFBvd2VyIEJ1ZGdldGluZyA8Pz4KCUNhcGFiaWxpdGllczogWzYwMCB2MV0gVmVuZG9yIFNwZWNp
ZmljIEluZm9ybWF0aW9uOiBJRD0wMDAxIFJldj0xIExlbj0wMjQgPD8+CglLZXJuZWwgZHJpdmVy
IGluIHVzZTogbnZpZGlhCglLZXJuZWwgbW9kdWxlczogbnZpZGlhLWN1cnJlbnQsIG5vdXZlYXUs
IG52aWRpYWZiCgowMzowMS4wIENhcmRCdXMgYnJpZGdlOiBPMiBNaWNybywgSW5jLiBDYXJkYnVz
IGJyaWRnZSAocmV2IDIxKQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZlCglDb250cm9sOiBJ
L08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnIt
IFN0ZXBwaW5nKyBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBV
REYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPXNsb3cgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9y
dC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMTY4CglJbnRlcnJ1cHQ6IHBpbiBBIHJv
dXRlZCB0byBJUlEgMTkKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZjFhMDAwMDAgKDMyLWJpdCwgbm9u
LXByZWZldGNoYWJsZSkgW3NpemU9NEtdCglCdXM6IHByaW1hcnk9MDMsIHNlY29uZGFyeT0wNCwg
c3Vib3JkaW5hdGU9MDcsIHNlYy1sYXRlbmN5PTE3NgoJTWVtb3J5IHdpbmRvdyAwOiBmMGMwMDAw
MC1mMGZmZjAwMCAocHJlZmV0Y2hhYmxlKQoJTWVtb3J5IHdpbmRvdyAxOiBmMTAwMDAwMC1mMTNm
ZjAwMAoJSS9PIHdpbmRvdyAwOiAwMDAwNTAwMC0wMDAwNTBmZgoJSS9PIHdpbmRvdyAxOiAwMDAw
NTQwMC0wMDAwNTRmZgoJQnJpZGdlQ3RsOiBQYXJpdHktIFNFUlItIElTQS0gVkdBLSBNQWJvcnQt
ID5SZXNldCsgMTZiSW50KyBQb3N0V3JpdGUrCgkxNi1iaXQgbGVnYWN5IGludGVyZmFjZSBwb3J0
cyBhdCAwMDAxCglLZXJuZWwgZHJpdmVyIGluIHVzZTogeWVudGFfY2FyZGJ1cwoJS2VybmVsIG1v
ZHVsZXM6IHllbnRhX3NvY2tldAoKMDM6MDEuNCBGaXJlV2lyZSAoSUVFRSAxMzk0KTogTzIgTWlj
cm8sIEluYy4gRmlyZXdpcmUgKElFRUUgMTM5NCkgKHJldiAwMikgKHByb2ctaWYgMTAgW09IQ0ld
KQoJU3Vic3lzdGVtOiBEZWxsIERldmljZSAwMWZlCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFz
dGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYrIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJS
KyBGYXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBh
ckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBF
UlItIElOVHgrCglMYXRlbmN5OiA2NCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50ZXJy
dXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDE5CglSZWdpb24gMDogTWVtb3J5IGF0IGYxYWZmMDAw
ICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTRLXQoJUmVnaW9uIDE6IE1lbW9yeSBh
dCBmMWFmZTgwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0yS10KCUNhcGFiaWxp
dGllczogWzYwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERT
SS0gRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZCsp
CgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUr
CglLZXJuZWwgZHJpdmVyIGluIHVzZTogZmlyZXdpcmVfb2hjaQoJS2VybmVsIG1vZHVsZXM6IGZp
cmV3aXJlLW9oY2ksIG9oY2kxMzk0CgowOTowMC4wIEV0aGVybmV0IGNvbnRyb2xsZXI6IEJyb2Fk
Y29tIENvcnBvcmF0aW9uIE5ldFh0cmVtZSBCQ001NzU1TSBHaWdhYml0IEV0aGVybmV0IFBDSSBF
eHByZXNzIChyZXYgMDIpCglTdWJzeXN0ZW06IERlbGwgRGV2aWNlIDAxZmUKCUNvbnRyb2w6IEkv
Ty0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlIrIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHotIFVE
Ri0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5
dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgNDgKCVJlZ2lvbiAwOiBNZW1vcnkg
YXQgZjFiZjAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NjRLXQoJRXhwYW5z
aW9uIFJPTSBhdCA8aWdub3JlZD4gW2Rpc2FibGVkXQoJQ2FwYWJpbGl0aWVzOiBbNDhdIFBvd2Vy
IE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1
cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5v
U29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0xIFBNRS0KCUNhcGFiaWxpdGllczog
WzUwXSBWaXRhbCBQcm9kdWN0IERhdGEKCQlQcm9kdWN0IE5hbWU6IEJyb2FkY29tIE5ldFh0cmVt
ZSBHaWdhYml0IEV0aGVybmV0IENvbnRyb2xsZXIKCQlSZWFkLW9ubHkgZmllbGRzOgoJCQlbUE5d
IFBhcnQgbnVtYmVyOiBCQ005NTc1NW0KCQkJW0VDXSBFbmdpbmVlcmluZyBjaGFuZ2VzOiAwMUZF
LjAwNAoJCQlbU05dIFNlcmlhbCBudW1iZXI6IDAxMjM0NTY3ODkKCQkJW01OXSBNYW51ZmFjdHVy
ZSBJRDogMzEgMzQgNjUgMzQKCQkJW1JWXSBSZXNlcnZlZDogY2hlY2tzdW0gZ29vZCwgMjggYnl0
ZShzKSByZXNlcnZlZAoJCVJlYWQvd3JpdGUgZmllbGRzOgoJCQlbWUFdIEFzc2V0IHRhZzogWFla
MDEyMzQ1NjcKCQkJW1JXXSBSZWFkLXdyaXRlIGFyZWE6IDEwNyBieXRlKHMpIGZyZWUKCQlFbmQK
CUNhcGFiaWxpdGllczogWzU4XSBWZW5kb3IgU3BlY2lmaWMgSW5mb3JtYXRpb246IExlbj03OCA8
Pz4KCUNhcGFiaWxpdGllczogW2U4XSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2
NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTAzMDBjICBEYXRhOiA0MWIxCglDYXBhYmlsaXRp
ZXM6IFtkMF0gRXhwcmVzcyAodjEpIEVuZHBvaW50LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxv
YWQgMTI4IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgPDR1cywgTDEgdW5saW1pdGVk
CgkJCUV4dFRhZysgQXR0bkJ0bi0gQXR0bkluZC0gUHdySW5kLSBSQkUrIEZMUmVzZXQtCgkJRGV2
Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZhdGFsLSBGYXRhbC0gVW5zdXBw
b3J0ZWQtCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3AtCgkJ
CU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDQwOTYgYnl0ZXMKCQlEZXZTdGE6CUNv
cnJFcnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQt
CgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEs
IExhdGVuY3kgTDAgPDR1cywgTDEgPDY0dXMKCQkJQ2xvY2tQTSsgU3VycHJpc2UtIExMQWN0UmVw
LSBCd05vdC0KCQlMbmtDdGw6CUFTUE0gTDBzIEVuYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxl
ZC0gUmV0cmFpbi0gQ29tbUNsaysKCQkJRXh0U3luY2gtIENsb2NrUE0rIEF1dFdpZERpcy0gQldJ
bnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41R1QvcywgV2lkdGggeDEsIFRyRXJyLSBU
cmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0KCUNhcGFiaWxpdGllczog
WzEwMCB2MV0gQWR2YW5jZWQgRXJyb3IgUmVwb3J0aW5nCgkJVUVTdGE6CURMUC0gU0RFUy0gVExQ
LSBGQ1AtIENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YtIE1hbGZUTFAtIEVDUkMt
IFVuc3VwUmVxLSBBQ1NWaW9sLQoJCVVFTXNrOglETFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRP
LSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0gQUNT
VmlvbC0KCQlVRVN2cnQ6CURMUCsgU0RFUy0gVExQLSBGQ1ArIENtcGx0VE8tIENtcGx0QWJydC0g
VW54Q21wbHQtIFJ4T0YrIE1hbGZUTFArIEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9sLQoJCUNFU3Rh
OglSeEVycisgQmFkVExQLSBCYWRETExQLSBSb2xsb3Zlci0gVGltZW91dC0gTm9uRmF0YWxFcnIt
CgkJQ0VNc2s6CVJ4RXJyLSBCYWRUTFAtIEJhZERMTFAtIFJvbGxvdmVyLSBUaW1lb3V0LSBOb25G
YXRhbEVycisKCQlBRVJDYXA6CUZpcnN0IEVycm9yIFBvaW50ZXI6IDAwLCBHZW5DYXArIENHZW5F
bi0gQ2hrQ2FwKyBDaGtFbi0KCUNhcGFiaWxpdGllczogWzEzYyB2MV0gVmlydHVhbCBDaGFubmVs
CgkJQ2FwczoJTFBFVkM9MCBSZWZDbGs9MTAwbnMgUEFURW50cnlCaXRzPTEKCQlBcmI6CUZpeGVk
LSBXUlIzMi0gV1JSNjQtIFdSUjEyOC0KCQlDdHJsOglBcmJTZWxlY3Q9Rml4ZWQKCQlTdGF0dXM6
CUluUHJvZ3Jlc3MtCgkJVkMwOglDYXBzOglQQVRPZmZzZXQ9MDAgTWF4VGltZVNsb3RzPTEgUmVq
U25vb3BUcmFucy0KCQkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtIFRXUlIxMjgt
IFdSUjI1Ni0KCQkJQ3RybDoJRW5hYmxlKyBJRD0wIEFyYlNlbGVjdD1GaXhlZCBUQy9WQz0wMQoJ
CQlTdGF0dXM6CU5lZ29QZW5kaW5nLSBJblByb2dyZXNzLQoJQ2FwYWJpbGl0aWVzOiBbMTYwIHYx
XSBEZXZpY2UgU2VyaWFsIE51bWJlciAwMC0yMS03MC1mZi1mZS02ZC04ZC1kYQoJQ2FwYWJpbGl0
aWVzOiBbMTZjIHYxXSBQb3dlciBCdWRnZXRpbmcgPD8+CglLZXJuZWwgZHJpdmVyIGluIHVzZTog
dGczCglLZXJuZWwgbW9kdWxlczogdGczCgowYzowMC4wIE5ldHdvcmsgY29udHJvbGxlcjogSW50
ZWwgQ29ycG9yYXRpb24gUFJPL1dpcmVsZXNzIDQ5NjUgQUcgb3IgQUdOIFtLZWRyb25dIE5ldHdv
cmsgQ29ubmVjdGlvbiAocmV2IDYxKQoJU3Vic3lzdGVtOiBJbnRlbCBDb3Jwb3JhdGlvbiBEZXZp
Y2UgMTEyMQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5W
LSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUisgRmFzdEIyQi0gRGlzSU5UeC0KCVN0
YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENh
Y2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSA0
NwoJUmVnaW9uIDA6IE1lbW9yeSBhdCBmMWZmZTAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxl
KSBbc2l6ZT04S10KCUNhcGFiaWxpdGllczogW2M4XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24g
MwoJCUZsYWdzOiBQTUVDbGstIERTSSsgRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQx
LSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUt
IERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFtkMF0gTVNJOiBFbmFibGUrIENv
dW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDBmZWUwMzAwYyAgRGF0
YTogNDFhOQoJQ2FwYWJpbGl0aWVzOiBbZTBdIEV4cHJlc3MgKHYxKSBFbmRwb2ludCwgTVNJIDAw
CgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBz
IDw1MTJucywgTDEgdW5saW1pdGVkCgkJCUV4dFRhZy0gQXR0bkJ0bi0gQXR0bkluZC0gUHdySW5k
LSBSQkUrIEZMUmVzZXQtCgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9u
LUZhdGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJCVJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5j
LSBBdXhQd3ItIE5vU25vb3ArCgkJCU1heFBheWxvYWQgMTI4IGJ5dGVzLCBNYXhSZWFkUmVxIDEy
OCBieXRlcwoJCURldlN0YToJQ29yckVycisgVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVx
LSBBdXhQd3IrIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNwZWVkIDIuNUdUL3MsIFdp
ZHRoIHgxLCBBU1BNIEwwcyBMMSwgTGF0ZW5jeSBMMCA8MTI4bnMsIEwxIDw2NHVzCgkJCUNsb2Nr
UE0rIFN1cnByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5rQ3RsOglBU1BNIEwwcyBMMSBFbmFi
bGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIFJldHJhaW4tIENvbW1DbGsrCgkJCUV4dFN5bmNo
LSBDbG9ja1BNKyBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIu
NUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQt
IEFCV01nbXQtCglDYXBhYmlsaXRpZXM6IFsxMDAgdjFdIEFkdmFuY2VkIEVycm9yIFJlcG9ydGlu
ZwoJCVVFU3RhOglETFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENt
cGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlVRU1zazoJRExQ
LSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhDbXBsdC0gUnhPRi0gTWFs
ZlRMUC0gRUNSQy0gVW5zdXBSZXEtIEFDU1Zpb2wtCgkJVUVTdnJ0OglETFArIFNERVMtIFRMUC0g
RkNQKyBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GKyBNYWxmVExQKyBFQ1JDLSBV
bnN1cFJlcS0gQUNTVmlvbC0KCQlDRVN0YToJUnhFcnIrIEJhZFRMUC0gQmFkRExMUC0gUm9sbG92
ZXItIFRpbWVvdXQtIE5vbkZhdGFsRXJyLQoJCUNFTXNrOglSeEVyci0gQmFkVExQLSBCYWRETExQ
LSBSb2xsb3Zlci0gVGltZW91dC0gTm9uRmF0YWxFcnIrCgkJQUVSQ2FwOglGaXJzdCBFcnJvciBQ
b2ludGVyOiAwMCwgR2VuQ2FwLSBDR2VuRW4tIENoa0NhcC0gQ2hrRW4tCglDYXBhYmlsaXRpZXM6
IFsxNDAgdjFdIERldmljZSBTZXJpYWwgTnVtYmVyIDAwLTIxLTVjLWZmLWZmLTQwLTg1LTI1CglL
ZXJuZWwgZHJpdmVyIGluIHVzZTogaXdsYWduCglLZXJuZWwgbW9kdWxlczogaXdsYWduCgo=
--e89a8ff24c7b0b425304bb25064d--
