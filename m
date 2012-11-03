Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953Ab2KCAcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:32:25 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:47362 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab2KCAcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:32:23 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 2D05CCBE3D
Date: Sat, 3 Nov 2012 01:32:22 +0100 (CET)
From: kernelbug@arcor.de
To: linux-kernel@vger.kernel.org
Message-ID: <2080832685.322156.1351902742186.JavaMail.ngmail@webmail09.arcor-online.net>
Subject: PROBLEM: log: task flush-x:y:z blocked for more than 120 seconds:
 leading to unusable (stalled) machine
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 89.13.188.222
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: On a desktop machine running an ArchLinux stock kernel, after 1/2 day uptime, while working under KDE SC, two I/O intensive tasks running for hours, I get a log message like
"INFO: task flush-254:0:539 blocked for more than 120 seconds."
and afterwards, the machine starts getting unusable, making it even impossible to get a working console session.
The situation can be reproduced with different kernel versions, but needs lots of patience to do so.

# cat /proc/version
Linux version 3.6.4-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 (GCC) ) #1 SMP PREEMPT Mon Oct 29 09:49:00 CET 2012

Log output:
Oct 28 06:11:46 daywalker kernel: [15120.660024] INFO: task flush-254:0:539 blocked for more than 120 seconds.
Oct 28 06:11:46 daywalker kernel: [15120.660329] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 28 06:11:46 daywalker kernel: [15120.660675] flush-254:0     D ffffc900054b0000     0   539      2 0x00000000
Oct 28 06:11:46 daywalker kernel: [15120.660679]  ffff88011f3294f0 0000000000000046 ffff88011f329770 ffff880120c25f80
Oct 28 06:11:46 daywalker kernel: [15120.660682]  ffff88011f147710 ffff88011f329fd8 ffff88011f329fd8 ffff88011f329fd8
Oct 28 06:11:46 daywalker kernel: [15120.660685]  ffff8800828607f0 ffff88011f147710 ffff88011f3294b8 0000000000000000
Oct 28 06:11:46 daywalker kernel: [15120.660688] Call Trace:
Oct 28 06:11:46 daywalker kernel: [15120.660696]  [<ffffffff8117e1a7>] ? unlock_buffer+0x17/0x20
Oct 28 06:11:46 daywalker kernel: [15120.660699]  [<ffffffff8117e1ec>] ? ll_rw_block+0x3c/0xc0
Oct 28 06:11:46 daywalker kernel: [15120.660718]  [<ffffffffa00d8633>] ? search_by_key+0x103/0xfd0 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660723]  [<ffffffff81417381>] ? __mutex_lock_slowpath+0x211/0x2c0
Oct 28 06:11:46 daywalker kernel: [15120.660725]  [<ffffffff81415f5f>] schedule+0x3f/0x60
Oct 28 06:11:46 daywalker kernel: [15120.660730]  [<ffffffffa00dc3bc>] queue_log_writer+0x8c/0xd0 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660734]  [<ffffffff81051000>] ? try_to_wake_up+0x2d0/0x2d0
Oct 28 06:11:46 daywalker kernel: [15120.660739]  [<ffffffffa00e2298>] do_journal_begin_r+0x248/0x410 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660745]  [<ffffffffa00d954d>] ? search_for_position_by_key+0x4d/0xa0 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660750]  [<ffffffffa00e24f7>] journal_begin+0x97/0x160 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660755]  [<ffffffffa00e2636>] reiserfs_persistent_transaction+0x76/0xd0 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660760]  [<ffffffffa00c79ab>] reiserfs_get_block+0x85b/0x1120 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660767]  [<ffffffffa0e2ab68>] ? __map_bio+0x48/0x150 [dm_mod]
Oct 28 06:11:46 daywalker kernel: [15120.660772]  [<ffffffffa00d80d6>] ? search_for_position_by_key.part.14+0xc6/0x1f0 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660777]  [<ffffffffa00c846b>] map_block_for_writepage+0x13b/0x620 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660781]  [<ffffffff8113f4fc>] ? kmem_cache_alloc+0x10c/0x120
Oct 28 06:11:46 daywalker kernel: [15120.660786]  [<ffffffffa00c8a82>] reiserfs_writepage+0x132/0x5e0 [reiserfs]
Oct 28 06:11:46 daywalker kernel: [15120.660789]  [<ffffffff810fdaba>] __writepage+0x1a/0x50
Oct 28 06:11:46 daywalker kernel: [15120.660792]  [<ffffffff810fdf8e>] write_cache_pages+0x1de/0x490
Oct 28 06:11:46 daywalker kernel: [15120.660794]  [<ffffffff810fdaa0>] ? bdi_set_max_ratio+0x90/0x90
Oct 28 06:11:46 daywalker kernel: [15120.660797]  [<ffffffff810fe28d>] generic_writepages+0x4d/0x70
Oct 28 06:11:46 daywalker kernel: [15120.660799]  [<ffffffff810ff0bd>] do_writepages+0x3d/0x50
Oct 28 06:11:46 daywalker kernel: [15120.660802]  [<ffffffff81176ebf>] writeback_single_inode+0xef/0x270
Oct 28 06:11:46 daywalker kernel: [15120.660804]  [<ffffffff8117729f>] writeback_sb_inodes+0xef/0x1a0
Oct 28 06:11:46 daywalker kernel: [15120.660807]  [<ffffffff8117811c>] writeback_inodes_wb+0x8c/0x160
Oct 28 06:11:46 daywalker kernel: [15120.660809]  [<ffffffff811784f0>] wb_writeback+0x300/0x400
Oct 28 06:11:46 daywalker kernel: [15120.660811]  [<ffffffff81178808>] wb_do_writeback+0x218/0x220
Oct 28 06:11:46 daywalker kernel: [15120.660814]  [<ffffffff81178893>] bdi_writeback_thread+0x83/0x250
Oct 28 06:11:46 daywalker kernel: [15120.660816]  [<ffffffff81178810>] ? wb_do_writeback+0x220/0x220
Oct 28 06:11:46 daywalker kernel: [15120.660819]  [<ffffffff8107b99c>] kthread+0x8c/0xa0
Oct 28 06:11:46 daywalker kernel: [15120.660821]  [<ffffffff81421364>] kernel_thread_helper+0x4/0x10
Oct 28 06:11:46 daywalker kernel: [15120.660824]  [<ffffffff8107b910>] ? kthread_worker_fn+0x1b0/0x1b0
Oct 28 06:11:46 daywalker kernel: [15120.660826]  [<ffffffff81421360>] ? gs_change+0x13/0x13
Oct 28 06:11:46 daywalker kernel: [15120.660835] INFO: task kded4:710 blocked for more than 120 seconds.
...

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 3
cpu MHz         : 1000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 2009.71
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 3
cpu MHz         : 1000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 2009.71
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

# cat /proc/modules
vboxdrv 1823469 0 - Live 0xffffffffa0fe1000 (O)
cbc 2736 2 - Live 0xffffffffa014a000
xts 3101 1 - Live 0xffffffffa02d7000
gf128mul 6050 1 xts, Live 0xffffffffa0393000
dm_crypt 15799 3 - Live 0xffffffffa038b000
dm_mod 72105 7 dm_crypt, Live 0xffffffffa036f000
sha256_generic 10261 4 - Live 0xffffffffa02f6000
sha1_generic 2323 0 - Live 0xffffffffa025d000
aes_x86_64 7508 6 - Live 0xffffffffa0243000
aes_generic 26138 1 aes_x86_64, Live 0xffffffffa0365000
squashfs 27579 0 - Live 0xffffffffa029e000
uhci_hcd 23436 0 - Live 0xffffffffa0292000
snd_hda_codec_hdmi 24487 1 - Live 0xffffffffa0230000
nvidia 11215270 50 - Live 0xffffffffa052d000 (PO)
joydev 9991 0 - Live 0xffffffffa019e000
usb_storage 47320 0 - Live 0xffffffffa0358000
uas 11119 0 - Live 0xffffffffa00d8000
snd_hda_codec_realtek 61065 1 - Live 0xffffffffa02e1000
r8169 56839 0 - Live 0xffffffffa02c6000
forcedeth 56097 0 - Live 0xffffffffa02b7000
psmouse 71909 0 - Live 0xffffffffa027f000
mii 4091 1 r8169, Live 0xffffffffa0193000
i2c_nforce2 5071 0 - Live 0xffffffffa0258000
serio_raw 4689 0 - Live 0xffffffffa0240000
dcdbas 5520 0 - Live 0xffffffffa0238000
powernow_k8 13373 1 - Live 0xffffffffa018b000
mperf 1267 1 powernow_k8, Live 0xffffffffa000e000
thermal 8119 0 - Live 0xffffffffa00ca000
snd_hda_intel 26180 5 - Live 0xffffffffa0520000
snd_hda_codec 98033 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa04d2000
snd_hwdep 6300 1 snd_hda_codec, Live 0xffffffffa04cc000
snd_pcm 75167 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0xffffffffa048c000
fan 2618 0 - Live 0xffffffffa0488000
kvm_amd 52187 0 - Live 0xffffffffa0462000
k8temp 3378 0 - Live 0xffffffffa045e000
snd_page_alloc 7217 2 snd_hda_intel,snd_pcm, Live 0xffffffffa044d000
i2c_core 20707 2 nvidia,i2c_nforce2, Live 0xffffffffa043a000
snd_timer 18934 1 snd_pcm, Live 0xffffffffa0420000
edac_core 42566 0 - Live 0xffffffffa0404000
edac_mce_amd 12277 0 - Live 0xffffffffa03fd000
evdev 10266 21 - Live 0xffffffffa03ef000
kvm 373917 1 kvm_amd, Live 0xffffffffa02fb000
pcspkr 1899 0 - Live 0xffffffffa0195000
button 4662 0 - Live 0xffffffffa02f3000
processor 26855 1 powernow_k8, Live 0xffffffffa02d9000
snd 59989 17 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer, Live 0xffffffffa02a7000
soundcore 5442 1 snd, Live 0xffffffffa0154000
nfs 126943 0 - Live 0xffffffffa025f000
lockd 64840 1 nfs, Live 0xffffffffa0247000
sunrpc 186249 2 nfs,lockd, Live 0xffffffffa0201000
fscache 40995 1 nfs, Live 0xffffffffa01f5000
hid_generic 1113 0 - Live 0xffffffffa000a000
usbhid 36996 0 - Live 0xffffffffa01ea000
hid 85929 2 hid_generic,usbhid, Live 0xffffffffa01d4000
ohci_hcd 21784 0 - Live 0xffffffffa011c000
ehci_hcd 41816 0 - Live 0xffffffffa01c8000
usbcore 150398 6 uhci_hcd,usb_storage,uas,usbhid,ohci_hcd,ehci_hcd, Live 0xffffffffa01a2000
usb_common 954 1 usbcore, Live 0xffffffffa0006000
sr_mod 14823 0 - Live 0xffffffffa0145000
pata_amd 11502 0 - Live 0xffffffffa0118000
cdrom 35520 1 sr_mod, Live 0xffffffffa00ce000
sd_mod 29559 7 - Live 0xffffffffa00c1000
sata_nv 21327 5 - Live 0xffffffffa0197000
libata 167683 2 pata_amd,sata_nv, Live 0xffffffffa0158000
scsi_mod 133386 5 usb_storage,uas,sr_mod,sd_mod,libata, Live 0xffffffffa0123000
reiserfs 239918 2 - Live 0xffffffffa00dc000
btrfs 718537 1 - Live 0xffffffffa0010000
crc32c 1768 1 - Live 0xffffffffa000c000
libcrc32c 1002 1 btrfs, Live 0xffffffffa0008000
zlib_deflate 20436 1 btrfs, Live 0xffffffffa0000000



Klaus-J. Wolf
kernelbug@arcor.de
