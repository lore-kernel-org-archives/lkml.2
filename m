Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1EBGt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:49:29 -0400
Received: from eazy.amigager.de ([213.239.192.238]:41187 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1EBGtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:49:24 -0400
Date: Mon, 2 May 2011 08:49:45 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: unable to handle kernel paging request when inserting FAT32
 formatted flash media
Message-ID: <20110502064945.GA12197@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

when I insert a CF or SD card from my cameras into the USB card reader,
I get the attached kernel oops. This is reproducible and did not happen
with 2.6.38.

The cards use FAT32.

Regards,
Tino


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=oop

usb 5-1: new full speed USB device number 16 using uhci_hcd
usb 5-1: New USB device found, idVendor=05ac, idProduct=8205
usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
sd 6:0:0:0: [sdb] 32014080 512-byte logical blocks: (16.3 GB/15.2 GiB)
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
BUG: unable to handle kernel paging request at ffffffffa0142264
IP: [<ffffffffa0138661>] fat_build_inode+0x2a1/0x4b0 [fat]
PGD 1635067 PUD 1639063 PMD b930d067 PTE 0
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5.2/speed
CPU 1 
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat dvb_usb_vp7045 dvb_usb dvb_core rc_core cpufreq_stats ipv6 loop btusb bluetooth usblp snd_hda_codec_idt arc4 snd_hda_intel snd_hda_codec ecb snd_pcm_oss snd_pcm ath5k ath snd_timer mac80211 snd_page_alloc sky2 evdev cfg80211 ata_piix [last unloaded: rc_core]

Pid: 22745, comm: gvfs-gdu-volume Not tainted 2.6.39-rc5-00001-g1beb336-dirty #22 Apple Inc. Macmini2,1/Mac-F4208EAA
RIP: 0010:[<ffffffffa0138661>]  [<ffffffffa0138661>] fat_build_inode+0x2a1/0x4b0 [fat]
RSP: 0018:ffff88000e4dbbd8  EFLAGS: 00010202
RAX: 000000004dbaff8f RBX: ffff880053a21848 RCX: 0000000000000012
RDX: 00000000000001b6 RSI: 0000000000000001 RDI: ffffffff81632340
RBP: 000000000001ea64 R08: 0000000000000073 R09: ffffffffa0146dc0
R10: 0000000000000000 R11: 0000000000000004 R12: ffff88001df60c80
R13: ffff88009c4f3000 R14: ffffffffa01391d8 R15: ffff880053a217f8
FS:  00007fac4c9877a0(0000) GS:ffff8800bed00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa0142264 CR3: 00000000840b3000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gvfs-gdu-volume (pid: 22745, threadinfo ffff88000e4da000, task ffff8800b3e647c0)
Stack:
 ffff8800b5e40af0 02ff880097e9b8c0 0000000000000001 ffff880096146cc0
 ffff880087b37400 0000000000000000 0000000000000001 ffff88000e4dbd68
 ffff880042174c80 ffffffffa013e692 ffff88000e4dbce8 ffff88000e4dbde8
Call Trace:
 [<ffffffffa013e692>] ? vfat_lookup+0x82/0x180 [vfat]
 [<ffffffff810ccedc>] ? d_alloc_and_lookup+0x3c/0x90
 [<ffffffff810d907e>] ? d_lookup+0x2e/0x60
 [<ffffffff810cedbb>] ? do_lookup+0xcb/0x2a0
 [<ffffffff810cfabd>] ? path_lookupat+0x15d/0x7f0
 [<ffffffffa013204b>] ? __fat_readdir.clone.14+0x12b/0xc60 [fat]
 [<ffffffff810d017b>] ? do_path_lookup+0x2b/0x90
 [<ffffffff810d02cc>] ? user_path_at+0x5c/0xc0
 [<ffffffff810c7247>] ? cp_new_stat+0xe7/0x100
 [<ffffffff810c70e0>] ? vfs_fstatat+0x40/0x80
 [<ffffffff810c755f>] ? sys_newlstat+0x1f/0x50
 [<ffffffff814a7d15>] ? device_not_available+0x15/0x20
 [<ffffffff814a71fb>] ? system_call_fastpath+0x16/0x1b
Code: fd ff ff 0f 1f 80 00 00 00 00 83 ca 01 89 93 10 02 00 00 ba ff 01 00 00 41 f6 85 96 00 00 00 02 74 51 49 c7 c6 d8 91 13 a0 b2 b6 
 3d fc 9b 00 00 00 74 3f 49 8d 44 24 08 48 89 44 24 08 eb 18 
RIP  [<ffffffffa0138661>] fat_build_inode+0x2a1/0x4b0 [fat]
 RSP <ffff88000e4dbbd8>
CR2: ffffffffa0142264
---[ end trace ea722c87b144bb1d ]---
------------[ cut here ]------------
WARNING: at kernel/exit.c:910 do_exit+0x715/0x7b0()
Hardware name: Macmini2,1
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat dvb_usb_vp7045 dvb_usb dvb_core rc_core cpufreq_stats ipv6 loop btusb bluetooth usblp snd_hda_codec_idt arc4 snd_hda_intel snd_hda_codec ecb snd_pcm_oss snd_pcm ath5k ath snd_timer mac80211 snd_page_alloc sky2 evdev cfg80211 ata_piix [last unloaded: rc_core]
Pid: 22745, comm: gvfs-gdu-volume Tainted: G      D     2.6.39-rc5-00001-g1beb336-dirty #22
Call Trace:
 [<ffffffff8103a01b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8103dcf5>] ? do_exit+0x715/0x7b0
 [<ffffffff814a40d2>] ? printk+0x40/0x46
 [<ffffffff8103ba00>] ? kmsg_dump+0x40/0xf0
 [<ffffffff81005cca>] ? oops_end+0x9a/0xe0
 [<ffffffff81022edd>] ? no_context+0xfd/0x270
 [<ffffffff81023856>] ? do_page_fault+0x376/0x410
 [<ffffffffa0130b96>] ? fat_parse_long+0x1d6/0x280 [fat]
 [<ffffffffa0131ebb>] ? fat_search_long+0x7fb/0x860 [fat]
 [<ffffffff814a6e1f>] ? page_fault+0x1f/0x30
 [<ffffffffa0138661>] ? fat_build_inode+0x2a1/0x4b0 [fat]
 [<ffffffffa0138490>] ? fat_build_inode+0xd0/0x4b0 [fat]
 [<ffffffffa013e692>] ? vfat_lookup+0x82/0x180 [vfat]
 [<ffffffff810ccedc>] ? d_alloc_and_lookup+0x3c/0x90
 [<ffffffff810d907e>] ? d_lookup+0x2e/0x60
 [<ffffffff810cedbb>] ? do_lookup+0xcb/0x2a0
 [<ffffffff810cfabd>] ? path_lookupat+0x15d/0x7f0
 [<ffffffffa013204b>] ? __fat_readdir.clone.14+0x12b/0xc60 [fat]
 [<ffffffff810d017b>] ? do_path_lookup+0x2b/0x90
 [<ffffffff810d02cc>] ? user_path_at+0x5c/0xc0
 [<ffffffff810c7247>] ? cp_new_stat+0xe7/0x100
 [<ffffffff810c70e0>] ? vfs_fstatat+0x40/0x80
 [<ffffffff810c755f>] ? sys_newlstat+0x1f/0x50
 [<ffffffff814a7d15>] ? device_not_available+0x15/0x20
 [<ffffffff814a71fb>] ? system_call_fastpath+0x16/0x1b
---[ end trace ea722c87b144bb1e ]---


--YZ5djTAD1cGYuMQK--
