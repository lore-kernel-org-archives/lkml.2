Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1ABVW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 16:22:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59866 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1ABVW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 16:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sByqK2Hc3d+TMOSFWLNEiNEvySLR2qiy86DsHHXlX++6W+QRZ4Z6WUAb7+F02QZ5ps
         rzs+1q+dELo9Kt6QHEEACfNQzGpVZuW2gjFWSnVs1OXLapmtWZtuSxI9ppvwFRHPnmbw
         +Y7GFJhpNehMZceHiw1FUDZXaEASgbf8RHogg=
MIME-Version: 1.0
Date: Sun, 2 Jan 2011 21:22:27 +0000
Message-ID: <AANLkTinpoM8FuG8UkF88xs_V37dz_wgE8t-s0JPzaS-w@mail.gmail.com>
Subject: [LogFS] [2.6.37-rc8+] Kernel BUG at logfs/readwrite.c:297!
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 8648.358867] stack at c280dbfc
[ 8648.432175] ------------[ cut here ]------------
[ 8648.432175] kernel BUG at /home/prasad/logfs/readwrite.c:297!
[ 8648.432175] invalid opcode: 0000 [#1] SMP
[ 8648.432175] last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0A:00/power_supply/BAT0/voltage_now
[ 8648.432175] Modules linked in: logfs nls_utf8 isofs binfmt_misc
nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer joydev snd_seq_device ppdev
usbhid snd psmouse hid e1000 serio_raw i2c_piix4 parport_pc lp
soundcore snd_page_alloc parport
[ 8648.432175]
[ 8648.432175] Pid: 10482, comm: flush-8:32 Not tainted 2.6.37-rc8+ #2
/VirtualBox
[ 8648.432175] EIP: 0060:[<e097937c>] EFLAGS: 00010286 CPU: 0
[ 8648.432175] EIP is at logfs_lock_write_page+0x6c/0x70 [logfs]
[ 8648.432175] EAX: 00000027 EBX: dffae200 ECX: c07b44fc EDX: 00000000
[ 8648.432175] ESI: 90000055 EDI: fffffff4 EBP: c280dc00 ESP: c280dbf0
[ 8648.432175]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 8648.432175] Process flush-8:32 (pid: 10482, ti=c280c000
task=c9d2a4f0 task.ti=c280c000)
[ 8648.432175] Stack:
[ 8648.432175]  e097f014 c280dbfc dffae200 00001002 c280dc28 e0979445
00000000 0000aa14
[ 8648.432175]  d76596a0 0000aa14 00000000 0000aa14 00000000 fffffff4
c280dc7c e0979c28
[ 8648.432175]  00000001 c280dc54 d76595e8 dfd29802 00000055 00000340
dfca8060 c280dc64
[ 8648.432175] Call Trace:
[ 8648.432175]  [<e0979445>] ? logfs_get_write_page+0xc5/0xf0 [logfs]
[ 8648.432175]  [<e0979c28>] ? __logfs_write_rec+0x58/0x2d0 [logfs]
[ 8648.432175]  [<e0979cbd>] ? __logfs_write_rec+0xed/0x2d0 [logfs]
[ 8648.432175]  [<e0979f10>] ? logfs_write_rec+0x70/0xe0 [logfs]
[ 8648.432175]  [<e097a07e>] ? __logfs_write_buf+0xfe/0x2a0 [logfs]
[ 8648.432175]  [<e097a260>] ? logfs_write_buf+0x40/0x60 [logfs]
[ 8648.432175]  [<e0973e0d>] ? __logfs_writepage+0x1d/0x70 [logfs]
[ 8648.432175]  [<e097409d>] ? logfs_writepage+0xad/0xf0 [logfs]
[ 8648.432175]  [<c01df1a0>] ? __writepage+0x10/0x40
[ 8648.432175]  [<c01e01b0>] ? write_cache_pages+0x130/0x380
[ 8648.432175]  [<c01df190>] ? __writepage+0x0/0x40
[ 8648.432175]  [<e0973ff0>] ? logfs_writepage+0x0/0xf0 [logfs]
[ 8648.432175]  [<c01e0424>] ? generic_writepages+0x24/0x30
[ 8648.432175]  [<c01e044c>] ? do_writepages+0x1c/0x40
[ 8648.432175]  [<c02363c5>] ? writeback_single_inode+0x85/0x200
[ 8648.432175]  [<c0236a08>] ? writeback_sb_inodes+0xa8/0x140
[ 8648.432175]  [<c0236eea>] ? writeback_inodes_wb+0x8a/0x120
[ 8648.432175]  [<c0237193>] ? wb_writeback+0x213/0x310
[ 8648.432175]  [<c02373df>] ? wb_do_writeback+0x14f/0x190
[ 8648.432175]  [<c02374b1>] ? bdi_writeback_thread+0x91/0x1f0
[ 8648.432175]  [<c0237420>] ? bdi_writeback_thread+0x0/0x1f0
[ 8648.432175]  [<c0168d84>] ? kthread+0x74/0x80
[ 8648.432175]  [<c0168d10>] ? kthread+0x0/0x80
[ 8648.432175]  [<c01036be>] ? kernel_thread_helper+0x6/0x10
[ 8648.432175] Code: 6b 6d c4 df 8b 45 f8 3e 0f ba 28 00 19 d2 85 d2
74 ca eb d0 0f 0b eb fe 8d 45 fc 89 44 24 04 c7 04 24 14 f0 97 e0 e8
94 6b c4 df <0f> 0b eb fe 55 89 e5 57 56 53 83 ec 14 3e 8d 74 26 00 89
55 ec
[ 8648.432175] EIP: [<e097937c>] logfs_lock_write_page+0x6c/0x70
[logfs] SS:ESP 0068:c280dbf0
[ 8648.684763] ---[ end trace 4ab2d4e484fb2d7a ]---
