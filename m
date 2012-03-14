Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2CNPiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:38:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33964 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab2CNPiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:38:05 -0400
MIME-Version: 1.0
Date: Wed, 14 Mar 2012 16:38:04 +0100
Message-ID: <CAC9WiBiZ9oOaDaYjow-ZryZ8i=7uLixTAfm48YKVpbwQfLfayQ@mail.gmail.com>
Subject: Getting oops with 3.2.10 when removing a SD card
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting this oops (pretty often) after writing to a SD card and
removing the card.

Here's the oops:

[17610.371580] usb 1-1.6: new high-speed USB device number 14 using ehci_hcd
[17610.469928] usb 1-1.6: New USB device found, idVendor=0bda, idProduct=0159
[17610.469935] usb 1-1.6: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[17610.469939] usb 1-1.6: Product: USB2.0-CRW
[17610.469942] usb 1-1.6: Manufacturer: Generic
[17610.469946] usb 1-1.6: SerialNumber: 20071114173400000
[17610.485966] scsi16 : usb-storage 1-1.6:1.0
[17611.489253] scsi 16:0:0:0: Direct-Access     Generic- Multi-Card
   1.00 PQ: 0 ANSI: 0 CCS
[17611.489556] sd 16:0:0:0: Attached scsi generic sg2 type 0
[17612.177470] sd 16:0:0:0: [sdb] 7744512 512-byte logical blocks:
(3.96 GB/3.69 GiB)
[17612.178347] sd 16:0:0:0: [sdb] Write Protect is off
[17612.178355] sd 16:0:0:0: [sdb] Mode Sense: 03 00 00 00
[17612.179333] sd 16:0:0:0: [sdb] No Caching mode page present
[17612.179338] sd 16:0:0:0: [sdb] Assuming drive cache: write through
[17612.182988] sd 16:0:0:0: [sdb] No Caching mode page present
[17612.182993] sd 16:0:0:0: [sdb] Assuming drive cache: write through
[17612.214565]  sdb: sdb1
[17612.218666] sd 16:0:0:0: [sdb] No Caching mode page present
[17612.218672] sd 16:0:0:0: [sdb] Assuming drive cache: write through
[17612.218677] sd 16:0:0:0: [sdb] Attached SCSI removable disk
[17620.408767] usb 1-1.6: USB disconnect, device number 14
[17620.410224] scsi 16:0:0:0: killing request
[17620.410512] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[17620.411480] IP: [<ffffffffa01e08ef>] sd_revalidate_disk+0x3f/0x1a10 [sd_mod]
[17620.411501] PGD 286a3067 PUD aef9f067 PMD 0
[17620.411507] Oops: 0000 [#1] SMP
[17620.411512] CPU 0
[17620.411514] Modules linked in: uas ums_realtek usb_storage fuse
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc af_packet ipv6
coretemp binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod
cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq
freq_table mperf nvram kvm_intel pl2303 usbserial kvm usbhid
snd_hda_codec_hdmi hid snd_hda_codec_idt snd_hda_intel snd_hda_codec
snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device dell_wmi sparse_keymap iTCO_wdt arc4 wmi intel_ips
snd_pcm_oss snd_pcm brcmsmac joydev battery dell_laptop
iTCO_vendor_support snd_timer snd_mixer_oss snd ehci_hcd mei(C)
soundcore dcdbas i2c_i801 evdev r8169 mii mac80211 brcmutil
snd_page_alloc sr_mod cfg80211 rfkill sg crc8 cordic usbcore
usb_common ata_piix ahci libahci libata sd_mod scsi_mod crc_t10dif
ext4 jbd2 crc16 i915 drm_kms_helper drm i2c_algo_bit i2c_core video
[last unloaded: scsi_wait_scan]
[17620.411600]
[17620.411604] Pid: 5850, comm: hald-addon-stor Tainted: G         C
3.2.10 #1 Dell Inc. Vostro 3500/
[17620.411610] RIP: 0010:[<ffffffffa01e08ef>]  [<ffffffffa01e08ef>]
sd_revalidate_disk+0x3f/0x1a10 [sd_mod]
[17620.411621] RSP: 0018:ffff880090a35a28  EFLAGS: 00010246
[17620.411624] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
[17620.411627] RDX: 0000000000000003 RSI: 0000000000000002 RDI: ffff8800903bb400
[17620.411630] RBP: ffff880090a35b18 R08: 0000000000000002 R09: 0000000800000000
[17620.411633] R10: 00000008ffffffff R11: 0000000000000000 R12: ffff8800903bb400
[17620.411636] R13: 00000000ffffff85 R14: ffff88012c099d58 R15: ffff8800903bb400
[17620.411640] FS:  00007f08fa284700(0000) GS:ffff880137c00000(0000)
knlGS:0000000000000000
[17620.411644] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17620.411647] CR2: 0000000000000008 CR3: 0000000028490000 CR4: 00000000000006f0
[17620.411650] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[17620.411653] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[17620.411657] Process hald-addon-stor (pid: 5850, threadinfo
ffff880090a34000, task ffff88002845db40)
[17620.411660] Stack:
[17620.411662]  ffff8800903b8410 ffff88013340cc00 0000000000000000
ffffc900005f7c20
[17620.411667]  ffff880090a35ac4 ffffffff811a23b0 ffff880090a35aa8
ffffffff811878d2
[17620.411671]  ffff88003780d3c0 ffffffff811a23d0 ffff880090a35aa8
ffff8800903bb400
[17620.411675] Call Trace:
[17620.411684]  [<ffffffff811a23b0>] ? blkdev_get_blocks+0xc0/0xc0
[17620.411689]  [<ffffffff811878d2>] ? iget5_locked+0x72/0x1c0
[17620.411693]  [<ffffffff811a23d0>] ? bdev_test+0x20/0x20
[17620.411700]  [<ffffffff8116fa58>] ? get_super+0x28/0xd0
[17620.411703]  [<ffffffff8118704b>] ? iput+0x4b/0x220
[17620.411709]  [<ffffffff811dacfa>] rescan_partitions+0xaa/0x4f0
[17620.411726]  [<ffffffffa01953a4>] ? scsi_device_put+0x44/0x60 [scsi_mod]
[17620.411736]  [<ffffffffa01def20>] ? sd_open+0x120/0x1f0 [sd_mod]
[17620.411743]  [<ffffffff811a3f2e>] __blkdev_get+0x2ae/0x420
[17620.411748]  [<ffffffff811a40f4>] blkdev_get+0x54/0x340
[17620.411752]  [<ffffffff811a43e0>] ? blkdev_get+0x340/0x340
[17620.411756]  [<ffffffff811a4442>] blkdev_open+0x62/0x80
[17620.411761]  [<ffffffff8116b553>] __dentry_open+0x213/0x340
[17620.411766]  [<ffffffff8116b6ba>] vfs_open+0x3a/0x40
[17620.411772]  [<ffffffff8116b700>] nameidata_to_filp+0x40/0x50
[17620.411778]  [<ffffffff8117a9c8>] do_last+0x3d8/0x7a0
[17620.411783]  [<ffffffff8117b7a5>] path_openat+0xd5/0x410
[17620.411787]  [<ffffffff81177fd2>] ? getname_flags+0x42/0x290
[17620.411791]  [<ffffffff8117bbf9>] do_filp_open+0x49/0xa0
[17620.411796]  [<ffffffff811889c3>] ? alloc_fd+0x53/0x140
[17620.411801]  [<ffffffff8116c7e7>] do_sys_open+0x107/0x1e0
[17620.411805]  [<ffffffff8116c900>] sys_open+0x20/0x30
[17620.411811]  [<ffffffff81466e02>] system_call_fastpath+0x16/0x1b
[17620.411814] Code: 66 66 66 66 90 65 48 8b 04 25 28 00 00 00 48 89
45 c8 31 c0 48 89 bd 68 ff ff ff 8b 05 bb c5 fd ff 48 8b 9f 30 03 00
00 c1 e8 15 <48> 8b 4b 08 83 e0 07 83 f8 03 48 89 8d 60 ff ff ff 0f 87
b3 18
[17620.411845] RIP  [<ffffffffa01e08ef>] sd_revalidate_disk+0x3f/0x1a10 [sd_mod]
[17620.411853]  RSP <ffff880090a35a28>
[17620.411855] CR2: 0000000000000008
[17620.797740] ---[ end trace 4ddfc5e258da101b ]---

Could anyone have a look please ?
-- 
Francis
