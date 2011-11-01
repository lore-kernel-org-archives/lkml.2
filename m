Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1KAWRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 18:17:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63874 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1KAWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 18:17:12 -0400
MIME-Version: 1.0
Date: Tue, 1 Nov 2011 15:17:12 -0700
Message-ID: <CA+Bv8Xaqih00xNdvSD61BF=+ZMB3ZLkc0HeiYhWnGQC3P-bB6g@mail.gmail.com>
Subject: BUG on bluetooth mouse attach
From: Russ Dill <russ.dill@gmail.com>
To: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a kernel BUG at bluetooth mouse enumeration time. The
below oops is from 3.1 on a Sony Viao SE, but I've also had the
problem on a AMD based Acer laptop and at least 3.0, and probably
several versions before that, but I don't remember exactly which one.
The crash is always with the same mouse, I don't currently have any
other ones to test with. The crash happens with 100% consistency.

[    0.000000] Linux version 3.1.0-2-generic (buildd@allspice) (gcc
version 4.6.2 (Ubuntu/Linaro 4.6.2-1ubuntu1) ) #3-Ubuntu SMP Sat Oct
29 00:48:30 UTC 2011 (Ubuntu 3.1.0-2.3-generic 3.1.0)
[...]
[ 3052.905871] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[ 3053.009370] VFS: Close: file count is 0
[ 3053.508389] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 3053.508432] IP: [<ffffffff8103b9b9>] __ticket_spin_lock+0x9/0x20
[ 3053.508464] PGD 0
[ 3053.508475] Oops: 0002 [#1] SMP
[ 3053.508492] CPU 2
[ 3053.508501] Modules linked in: hidp psmouse btrfs zlib_deflate
libcrc32c ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs
reiserfs msr rfcomm bnep kvm_intel kvm parport_pc ppdev lp parport
binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_realtek uvcvideo
videodev v4l2_compat_ioctl32 arc4 joydev snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm snd_seq_midi btusb iwlagn rts_pstor(C) snd_rawmidi
eeprom bluetooth snd_seq_midi_event snd_seq dm_multipath snd_timer
snd_seq_device sony_laptop tpm_infineon wmi serio_raw snd mac80211
sparse_keymap mei(C) pcspkr tpm_tis soundcore cfg80211 snd_page_alloc
firewire_sbp2 firewire_core crc_itu_t usbhid hid xhci_hcd ahci libahci
r8169 radeon i915 ttm drm_kms_helper drm i2c_algo_bit video [last
unloaded: psmouse]
[ 3053.508857]
[ 3053.508866] Pid: 8543, comm: khidpd_04580058 Tainted: G         C
3.1.0-2-generic #3-Ubuntu Sony Corporation VPCSE190X/VAIO
[ 3053.508913] RIP: 0010:[<ffffffff8103b9b9>]  [<ffffffff8103b9b9>]
__ticket_spin_lock+0x9/0x20
[ 3053.508952] RSP: 0018:ffff8801effa7da0  EFLAGS: 00010086
[ 3053.508976] RAX: 0000000000010000 RBX: 0000000000000286 RCX: 0000000000000002
[ 3053.509007] RDX: 0000000000000000 RSI: 0000000000000286 RDI: 0000000000000000
[ 3053.509037] RBP: ffff8801effa7da0 R08: ffff8801effa6000 R09: 0000000000000001
[ 3053.509067] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801effa7e80
[ 3053.509098] R13: ffff8801effa7e98 R14: ffff8801e86d6c70 R15: ffff8801e4fa6c00
[ 3053.509129] FS:  0000000000000000(0000) GS:ffff88025fa80000(0000)
knlGS:0000000000000000
[ 3053.509162] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3053.509187] CR2: 0000000000000000 CR3: 0000000252300000 CR4: 00000000000406e0
[ 3053.509217] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3053.509248] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3053.509279] Process khidpd_04580058 (pid: 8543, threadinfo
ffff8801effa6000, task ffff8801efe15c80)
[ 3053.509317] Stack:
[ 3053.509327]  ffff8801effa7db0 ffffffff8103ba59 ffff8801effa7dd0
ffffffff8161f30e
[ 3053.510999]  0000000000000000 ffff8801effa7e80 ffff8801effa7e00
ffffffff81087621
[ 3053.512670]  ffff880225bbc400 0000000000000000 ffff880225bbc400
ffff8801e4fa6c70
[ 3053.514350] Call Trace:
[ 3053.516044]  [<ffffffff8103ba59>] default_spin_lock_flags+0x9/0x10
[ 3053.517699]  [<ffffffff8161f30e>] _raw_spin_lock_irqsave+0x2e/0x40
[ 3053.519417]  [<ffffffff81087621>] finish_wait+0x41/0x80
[ 3053.521126]  [<ffffffffa067c0be>] hidp_session+0x35e/0x4b0 [hidp]
[ 3053.522815]  [<ffffffff81053a4a>] ? finish_task_switch+0x4a/0xf0
[ 3053.524418]  [<ffffffff8105c7e0>] ? try_to_wake_up+0x200/0x200
[ 3053.526113]  [<ffffffff8105c7e0>] ? try_to_wake_up+0x200/0x200
[ 3053.527814]  [<ffffffff81087550>] ? add_wait_queue+0x60/0x60
[ 3053.529513]  [<ffffffffa067bd60>] ? hidp_recv_ctrl_frame+0xf0/0xf0 [hidp]
[ 3053.531167]  [<ffffffff81086abc>] kthread+0x8c/0xa0
[ 3053.532841]  [<ffffffff81629674>] kernel_thread_helper+0x4/0x10
[ 3053.534526]  [<ffffffff81086a30>] ? flush_kthread_worker+0xa0/0xa0
[ 3053.536207]  [<ffffffff81629670>] ? gs_change+0x13/0x13
[ 3053.537881] Code: 00 00 48 c7 c1 c1 b7 03 81 48 c7 c2 be b7 03 81
e9 dd fe ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 55 b8 00 00 01
00 48 89 e5 <f0> 0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17
eb f5
[ 3053.539723] RIP  [<ffffffff8103b9b9>] __ticket_spin_lock+0x9/0x20
[ 3053.541497]  RSP <ffff8801effa7da0>
[ 3053.543233] CR2: 0000000000000000
[ 3053.606658] ---[ end trace 62991f0c110ba2c0 ]---
