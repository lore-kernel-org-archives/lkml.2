Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1FMKUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:20:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:54976 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1FMKUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:20:31 -0400
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jun 2011 06:20:31 EDT
Subject: 2.6.39.1: NULL pointer dereference in sd_revalidate_disk
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jun 2011 11:49:22 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307958565.6818.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 2982.023370] usb 1-1.4: USB disconnect, device number 7
[ 2982.031714] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[ 2982.031772] IP: [<ffffffff81499fb4>] sd_revalidate_disk+0x34/0x1990
[ 2982.031815] PGD 1968a4067 PUD 1968a3067 PMD 0 
[ 2982.031847] Oops: 0000 [#1] PREEMPT SMP 
[ 2982.031875] last sysfs file: /sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.4/speed
[ 2982.031922] CPU 1 
[ 2982.031935] Modules linked in: snd_usb_audio snd_usbmidi_lib pwc videodev rndis_wlan v4l2_compat_ioctl32 8250_pnp sp5100_tco 8250 serial_core floppy radeon ttm drm_kms_helper [last unloaded: scsi_wait_scan]
[ 2982.032065] 
[ 2982.032077] Pid: 4715, comm: udisks-daemon Not tainted 2.6.39.1 #3 BIOSTAR Group TA785GE 128M/TA785GE 128M
[ 2982.032137] RIP: 0010:[<ffffffff81499fb4>]  [<ffffffff81499fb4>] sd_revalidate_disk+0x34/0x1990
[ 2982.032190] RSP: 0018:ffff880196965a78  EFLAGS: 00010246
[ 2982.032222] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
[ 2982.032263] RDX: 0000000000000001 RSI: ffff88015ba82980 RDI: ffff88017d75f400
[ 2982.032305] RBP: ffff880196965b28 R08: 0000000800000000 R09: 00000008ffffffff
[ 2982.032346] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88017d75f400
[ 2982.032387] R13: 00000000ffffff85 R14: ffff8801a974e718 R15: ffff88017d75f400
[ 2982.032429] FS:  00007f5fb75ec7c0(0000) GS:ffff8801afc40000(0000) knlGS:0000000000000000
[ 2982.032476] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2982.032510] CR2: 0000000000000008 CR3: 00000001968a5000 CR4: 00000000000006e0
[ 2982.032543] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2982.032543] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2982.032543] Process udisks-daemon (pid: 4715, threadinfo ffff880196964000, task ffff8801ad1c9a80)
[ 2982.032543] Stack:
[ 2982.032543]  ffff88017d75f400 00000000ffffff85 ffff88017d75f478 ffff88017d75f400
[ 2982.032543]  ffff880196965ac8 ffffffff8111d249 ffff880196965ab8 ffff8801a974e7d8
[ 2982.032543]  ffff88017d75f400 ffffffff81133f3d ffff8801a974e700 ffff880196965b60
[ 2982.032543] Call Trace:
[ 2982.032543]  [<ffffffff8111d249>] ? get_super+0x69/0xc0
[ 2982.032543]  [<ffffffff81133f3d>] ? iput+0x3d/0x1a0
[ 2982.032543]  [<ffffffff8117f422>] rescan_partitions+0xa2/0x4b0
[ 2982.032543]  [<ffffffff8114c416>] __blkdev_get+0x2b6/0x3e0
[ 2982.032543]  [<ffffffff8114c830>] ? blkdev_get+0x2f0/0x2f0
[ 2982.032543]  [<ffffffff8114c58e>] blkdev_get+0x4e/0x2f0
[ 2982.032543]  [<ffffffff8114c830>] ? blkdev_get+0x2f0/0x2f0
[ 2982.032543]  [<ffffffff8114c88b>] blkdev_open+0x5b/0x80
[ 2982.032543]  [<ffffffff811190a5>] __dentry_open+0x175/0x320
[ 2982.032543]  [<ffffffff8111a5b9>] nameidata_to_filp+0x69/0x80
[ 2982.032543]  [<ffffffff81127df4>] do_last+0x4f4/0x9b0
[ 2982.032543]  [<ffffffff81129bb6>] path_openat+0xc6/0x3c0
[ 2982.032543]  [<ffffffff81440302>] ? put_device+0x12/0x20
[ 2982.032543]  [<ffffffff810c5834>] ? force_qs_rnp+0x104/0x130
[ 2982.032543]  [<ffffffff81129eed>] do_filp_open+0x3d/0xa0
[ 2982.032543]  [<ffffffff811360a4>] ? alloc_fd+0xe4/0x130
[ 2982.032543]  [<ffffffff8111a6c2>] do_sys_open+0xf2/0x1d0
[ 2982.032543]  [<ffffffff810bcd68>] ? audit_syscall_entry+0x2f8/0x320
[ 2982.032543]  [<ffffffff8111a7bb>] sys_open+0x1b/0x20
[ 2982.032543]  [<ffffffff81862efb>] system_call_fastpath+0x16/0x1b
[ 2982.032543] Code: 55 41 54 53 48 81 ec 88 00 00 00 48 8b 9f f8 02 00 00 48 89 7d 90 65 48 8b 04 25 28 00 00 00 48 89 45 c8 31 c0 8b 05 8c ed 8f 00 <4c> 8b 7b 08 c1 e8 15 83 e0 07 83 f8 03 0f 87 4d 16 00 00 41 8b 
[ 2982.032543] RIP  [<ffffffff81499fb4>] sd_revalidate_disk+0x34/0x1990
[ 2982.032543]  RSP <ffff880196965a78>
[ 2982.032543] CR2: 0000000000000008
[ 2982.055798] ---[ end trace 3eb9a7b3380fa5bc ]---



