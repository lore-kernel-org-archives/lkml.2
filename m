Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1JTQVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:21:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38053 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1JTQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:21:43 -0400
MIME-Version: 1.0
Date: Thu, 20 Oct 2011 18:21:42 +0200
Message-ID: <CAE2SPAYY+rmtRyBF=D0k+KTx=qj4wfFrgYa3MVf2=u+HvAux5Q@mail.gmail.com>
Subject: Ext4 crash nbd connection lost
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During umount the device after transient connection lost, the kernel crashed.

Oct 20 15:16:55 portablebastien kernel: [25846.149503] EXT4-fs warning
(device nbd0): ext4_end_bio:242: I/O error writing to inode 4334083
(offset 183906304 size 131072 starting block 15980418
)
Oct 20 15:16:55 portablebastien kernel: [25846.149630] EXT4-fs warning
(device nbd0): ext4_end_bio:242: I/O error writing to inode 4334083
(offset 184033280 size 131072 starting block 15980449
)
Oct 20 15:16:55 portablebastien kernel: [25846.149757] EXT4-fs warning
(device nbd0): ext4_end_bio:242: I/O error writing to inode 4334083
(offset 184160256 size 131072 starting block 15980480
)
Oct 20 15:16:55 portablebastien kernel: [25846.149882] EXT4-fs warning
(device nbd0): ext4_end_bio:242: I/O error writing to inode 4334083
(offset 184287232 size 131072 starting block 15980511
)
Oct 20 15:16:55 portablebastien kernel: [25846.150012] EXT4-fs warning
(device nbd0): ext4_end_bio:242: I/O error writing to inode 4334083
(offset 184414208 size 131072 starting block 15980542
)
Oct 20 15:16:55 portablebastien kernel: [25846.150039] EXT4-fs warning
(device nbd0): ext4_end_bio:242: I/O error writing to inode 4334083
(offset 184541184 size 8192 starting block 15980544)
Oct 20 15:16:55 portablebastien kernel: [25846.150055] JBD2: Detected
IO errors while flushing file data on nbd0-8
Oct 20 15:16:55 portablebastien kernel: [25846.150111] lost page write
due to I/O error on nbd0
Oct 20 15:16:55 portablebastien kernel: [25846.157576] lost page write
due to I/O error on nbd0
Oct 20 15:16:55 portablebastien kernel: [25846.157604] lost page write
due to I/O error on nbd0
Oct 20 15:16:55 portablebastien kernel: [25846.157624] lost page write
due to I/O error on nbd0
Oct 20 15:16:55 portablebastien kernel: [25846.286215] JBD2: Detected
IO errors while flushing file data on nbd0-8
Oct 20 15:18:17 portablebastien kernel: [25928.175834] CPU 1
Oct 20 15:18:17 portablebastien kernel: [25928.175847] Modules linked
in: ext4 jbd2 nbd snd_hrtimer acpi_cpufreq mperf cpufreq_powersave
cpufreq_stats cpufreq_userspace cpufreq_conservative parport_pc ppdev
lp parport cn rfcomm bnep binfmt_misc uinput fuse nfsd nfs lockd
fscache auth_rpcgss nfs_acl sunrpc tun ext3 jbd mbcache dm_crypt loop
btusb bluetooth joydev snd_hda_codec_idt i915 drm_kms_helper uvcvideo
drm crc16 videodev snd_hda_intel snd_hda_codec media i2c_i801
i2c_algo_bit arc4 snd_hwdep snd_pcm_oss snd_mixer_oss
v4l2_compat_ioctl32 snd_pcm b43 rng_core dell_laptop i2c_core
snd_seq_midi psmouse snd_rawmidi dcdbas pcspkr dell_wmi evdev
sparse_keymap serio_raw snd_seq_midi_event snd_seq video wmi ac
battery button mac80211 cfg80211 power_supply snd_timer snd_seq_device
snd soundcore snd_page_alloc rfkill processor reiserfs btrfs
zlib_deflate crc32c libcrc32c raid10 raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0
multipath linear md_mod dm_mirror dm_region_hash dm_log dm_
Oct 20 15:18:17 portablebastien kernel: mod usbhid hid sg sr_mod cdrom
sd_mod crc_t10dif ums_realtek usb_storage uas uhci_hcd ehci_hcd ahci
libahci thermal thermal_sys sky2 libata scsi_mod ssb mmc_core pcmcia
pcmcia_core usbcore [last unloaded: scsi_wait_scan]
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
Oct 20 15:18:17 portablebastien kernel: [25928.176011] Pid: 17767,
comm: umount Not tainted 3.0.0-1-amd64 #1 Dell Inc. Inspiron 1545
             /0G848F
Oct 20 15:18:17 portablebastien kernel: [25928.176011] RIP:
0010:[<ffffffff8111d243>]  [<ffffffff8111d243>] submit_bh+0x19/0x106
Oct 20 15:18:17 portablebastien kernel: [25928.176011] RSP:
0018:ffff88011129fd58  EFLAGS: 00010246
Oct 20 15:18:17 portablebastien kernel: [25928.176011] RAX:
0000000000040005 RBX: ffff880083f90f68 RCX: 0000000000000017
Oct 20 15:18:17 portablebastien kernel: [25928.176011] RDX:
0000000000000000 RSI: ffff880083f90f68 RDI: 0000000000000091
Oct 20 15:18:17 portablebastien kernel: [25928.176011] RBP:
0000000000000091 R08: 0000000000000200 R09: ffffffff81684680
Oct 20 15:18:17 portablebastien kernel: [25928.176011] R10:
0000000000000000 R11: 0000000000015608 R12: ffff880109b5c400
Oct 20 15:18:17 portablebastien kernel: [25928.176011] R13:
0000000000000001 R14: 00000000051efdea R15: 000000000022943a
Oct 20 15:18:17 portablebastien kernel: [25928.176011] FS:
00007f2d786a37e0(0000) GS:ffff88011fd00000(0000)
knlGS:0000000000000000
Oct 20 15:18:17 portablebastien kernel: [25928.176011] CS:  0010 DS:
0000 ES: 0000 CR0: 000000008005003b
Oct 20 15:18:17 portablebastien kernel: [25928.176011] CR2:
0000000000426ed0 CR3: 0000000111183000 CR4: 00000000000406e0
Oct 20 15:18:17 portablebastien kernel: [25928.176011] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 20 15:18:17 portablebastien kernel: [25928.176011] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 20 15:18:17 portablebastien kernel: [25928.176011] Process umount
(pid: 17767, threadinfo ffff88011129e000, task ffff880014e4e080)
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
ffff880083f90f68 0000000000000091 ffff880109b5c400 ffffffff8111e28b
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
000000000022943a ffffffff8111d91a ffff88003b738c00 ffff88003b738c00
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
ffff880083f90f68 ffffffffa072aea8 ffff88011129fe10 ffff88003b738c00
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff8111e28b>] ? __sync_dirty_buffer+0x52/0x87
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff8111d91a>] ? __set_page_dirty+0x83/0x94
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffffa072aea8>] ? ext4_commit_super+0x151/0x19e [ext4]
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffffa072c344>] ? __ext4_abort+0x26/0xf7 [ext4]
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff81060083>] ? wake_up_bit+0x23/0x23
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff810383fc>] ? need_resched+0x1a/0x23
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffffa072c891>] ? ext4_put_super+0xa6/0x31e [ext4]
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff810fd4e7>] ? generic_shutdown_super+0x65/0xe2
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff810fd584>] ? kill_block_super+0x20/0x63
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff8103840a>] ? should_resched+0x5/0x24
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff810fd7ab>] ? deactivate_locked_super+0x1e/0x48
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff81112aff>] ? sys_umount+0x2e5/0x313
Oct 20 15:18:17 portablebastien kernel: [25928.176011]
[<ffffffff8133bd12>] ? system_call_fastpath+0x16/0x1b
Oct 20 15:18:17 portablebastien kernel: [25928.181474]  RSP <ffff88011129fd58>
Oct 20 15:18:17 portablebastien kernel: [25928.199339] ---[ end trace
088431e597118363 ]---
Oct 20 15:18:17 portablebastien kernel: [25928.199343] ------------[
cut here ]------------
Oct 20 15:18:17 portablebastien kernel: [25928.199350] WARNING: at
/build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/kernel/exit.c:909
do_exit+0x3d/0x740()
Oct 20 15:18:17 portablebastien kernel: [25928.199354] Hardware name:
Inspiron 1545
Oct 20 15:18:17 portablebastien kernel: [25928.199356] Modules linked
in: ext4 jbd2 nbd snd_hrtimer acpi_cpufreq mperf cpufreq_powersave
cpufreq_stats cpufreq_userspace cpufreq_conservative parport_pc ppdev
lp parport cn rfcomm bnep binfmt_misc uinput fuse nfsd nfs lockd
fscache auth_rpcgss nfs_acl sunrpc tun ext3 jbd mbcache dm_crypt loop
btusb bluetooth joydev snd_hda_codec_idt i915 drm_kms_helper uvcvideo
drm crc16 videodev snd_hda_intel snd_hda_codec media i2c_i801
i2c_algo_bit arc4 snd_hwdep snd_pcm_oss snd_mixer_oss
v4l2_compat_ioctl32 snd_pcm b43 rng_core dell_laptop i2c_core
snd_seq_midi psmouse snd_rawmidi dcdbas pcspkr dell_wmi evdev
sparse_keymap serio_raw snd_seq_midi_event snd_seq video wmi ac
battery button mac80211 cfg80211 power_supply snd_timer snd_seq_device
snd soundcore snd_page_alloc rfkill processor reiserfs btrfs
zlib_deflate crc32c libcrc32c raid10 raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0
multipath linear md_mod dm_mirror dm_region_hash dm_log dm_
Oct 20 15:18:17 portablebastien kernel: mod usbhid hid sg sr_mod cdrom
sd_mod crc_t10dif ums_realtek usb_storage uas uhci_hcd ehci_hcd ahci
libahci thermal thermal_sys sky2 libata scsi_mod ssb mmc_core pcmcia
pcmcia_core usbcore [last unloaded: scsi_wait_scan]
Oct 20 15:18:17 portablebastien kernel: [25928.199467] Pid: 17767,
comm: umount Tainted: G      D      3.0.0-1-amd64 #1
Oct 20 15:18:17 portablebastien kernel: [25928.199470] Call Trace:
Oct 20 15:18:17 portablebastien kernel: [25928.199476]
[<ffffffff81046521>] ? warn_slowpath_common+0x78/0x8c
Oct 20 15:18:17 portablebastien kernel: [25928.199479]
[<ffffffff8104979f>] ? do_exit+0x3d/0x740
Oct 20 15:18:17 portablebastien kernel: [25928.199484]
[<ffffffff81336a64>] ? _raw_spin_lock_irqsave+0x9/0x25
Oct 20 15:18:17 portablebastien kernel: [25928.199487]
[<ffffffff81047af8>] ? kmsg_dump+0x40/0xcc
Oct 20 15:18:17 portablebastien kernel: [25928.199491]
[<ffffffff81337b7e>] ? oops_end+0xb1/0xb6
Oct 20 15:18:17 portablebastien kernel: [25928.199495]
[<ffffffff81009a21>] ? do_invalid_op+0x87/0x91
Oct 20 15:18:17 portablebastien kernel: [25928.199499]
[<ffffffff8111d243>] ? submit_bh+0x19/0x106
Oct 20 15:18:17 portablebastien kernel: [25928.199502]
[<ffffffff8104769e>] ? vprintk+0x39d/0x3df
Oct 20 15:18:17 portablebastien kernel: [25928.199506]
[<ffffffff8103bd47>] ? check_preempt_wakeup+0x133/0x19c
Oct 20 15:18:17 portablebastien kernel: [25928.199510]
[<ffffffff8133cc9b>] ? invalid_op+0x1b/0x20
Oct 20 15:18:17 portablebastien kernel: [25928.199513]
[<ffffffff8111d243>] ? submit_bh+0x19/0x106
Oct 20 15:18:17 portablebastien kernel: [25928.199517]
[<ffffffff813358d7>] ? _cond_resched+0x9/0x20
Oct 20 15:18:17 portablebastien kernel: [25928.199521]
[<ffffffff8111e28b>] ? __sync_dirty_buffer+0x52/0x87
Oct 20 15:18:17 portablebastien kernel: [25928.199524]
[<ffffffff8111d91a>] ? __set_page_dirty+0x83/0x94
Oct 20 15:18:17 portablebastien kernel: [25928.199539]
[<ffffffffa072aea8>] ? ext4_commit_super+0x151/0x19e [ext4]
Oct 20 15:18:17 portablebastien kernel: [25928.199551]
[<ffffffffa072c344>] ? __ext4_abort+0x26/0xf7 [ext4]
Oct 20 15:18:17 portablebastien kernel: [25928.199555]
[<ffffffff81060083>] ? wake_up_bit+0x23/0x23
Oct 20 15:18:17 portablebastien kernel: [25928.199559]
[<ffffffff810383fc>] ? need_resched+0x1a/0x23
Oct 20 15:18:17 portablebastien kernel: [25928.199571]
[<ffffffffa072c891>] ? ext4_put_super+0xa6/0x31e [ext4]
Oct 20 15:18:17 portablebastien kernel: [25928.199575]
[<ffffffff810fd4e7>] ? generic_shutdown_super+0x65/0xe2
Oct 20 15:18:17 portablebastien kernel: [25928.199578]
[<ffffffff810fd584>] ? kill_block_super+0x20/0x63
Oct 20 15:18:17 portablebastien kernel: [25928.199581]
[<ffffffff8103840a>] ? should_resched+0x5/0x24
Oct 20 15:18:17 portablebastien kernel: [25928.199585]
[<ffffffff810fd7ab>] ? deactivate_locked_super+0x1e/0x48
ct 20 15:18:17 portablebastien kernel: [25928.199589]
[<ffffffff81112aff>] ? sys_umount+0x2e5/0x313
Oct 20 15:18:17 portablebastien kernel: [25928.199593]
[<ffffffff8133bd12>] ? system_call_fastpath+0x16/0x1b
Oct 20 15:18:17 portablebastien kernel: [25928.199596] ---[ end trace
088431e597118364 ]---
