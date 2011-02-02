Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1BBR56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:57:58 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56505 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1BBR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:57:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=LCPG42ds9T8R/7BENFSYee9CswXBVWDKwGgzb19ldFV1aKUYTdGE6uO07SDmrMqFnM
         kQGMOoeeARW+OvfVJfvDBbM42BxYoPziWDj6Qe6Jknf184es/EvYUBbXGAPP/fic7LPq
         Xh8gFBuwOvX8Vle2YJvm8cwM+rqFD8xxcZ4hw=
MIME-Version: 1.0
In-Reply-To: <20110202042347.GA3870@maclin>
References: <1296595418-2457-1-git-send-email-abogani@kernel.org>
	<20110202042347.GA3870@maclin>
Date: Wed, 2 Feb 2011 18:57:55 +0100
X-Google-Sender-Auth: -NnH-6FwpBnyGcnzLLkJYzSiUYs
Message-ID: <AANLkTimGHPtSVKhBaLhN_DJYNaoBMAb4SUaG3O-ieQTK@mail.gmail.com>
Subject: Re: [PATCH] ufs: Check if page has buffers before calling page_buffers()
From: Alessio Igor Bogani <abogani@kernel.org>
To: Evgeniy Dushistov <dushistov@mail.ru>,
        Alessio Igor Bogani <abogani@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy,

2011/2/2 Evgeniy Dushistov <dushistov@mail.ru>:
[...]
> So in our case we reach (during realocation) point when
> !page_has_buffers(page) (how?)
[...]

kernel BUG at fs/ufs/balloc.c:279!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/uevent
CPU 1
Modules linked in: ufs aes_generic fbcon tileblit font bitblit
softcursor rfcomm sco nouveau bridge arc4 iwlagn binfmt_misc iwlcore
snd_hda_codec_idt ppdev stp bnep l2cap snd_hda_intel mac80211
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm ttm
snd_seq_dummy drm_kms_helper snd_seq_oss drm joydev snd_seq_midi_event
snd_seq cfg80211 btusb psmouse snd_timer snd_seq_device bluetooth
uvcvideo videodev v4l2_compat_ioctl32 i2c_algo_bit video snd
sony_laptop tifm_7xx1 lp tifm_core output serio_raw intel_agp parport
intel_gtt soundcore snd_page_alloc usbhid hid ahci libahci sky2 [last
unloaded: v4l2_compat_ioctl32]

Pid: 1679, comm: fsstress Not tainted 2.6.37 #244 VAIO/VGN-FZ21M
RIP: 0010:[<ffffffffa042a2f9>]  [<ffffffffa042a2f9>]
ufs_new_fragments+0xed9/0xf20 [ufs]
RSP: 0018:ffff88005a91f808  EFLAGS: 00010246
RAX: 010000000000002d RBX: ffff88000ef0e2c0 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000146 RDI: ffffffff8176b26e
RBP: ffff88005a91f928 R08: 0000000000000000 R09: ffff88005a9986f8
R10: 0000000000000008 R11: 0000000000000000 R12: ffffea0000d8efd0
R13: 0000000000000004 R14: 0000000000000008 R15: 000000000000000e
FS:  00007fa2891ae700(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f54e12410d8 CR3: 000000006e229000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsstress (pid: 1679, threadinfo ffff88005a91e000, task ffff88005a998000)
Stack:
 ffff88005a91f828 0000000000000020 ffff88006a0d3000 0000000000000000
 00000008000001bc 0000000000000008 000000085a91f858 0000000000000008
 ffff88000ef0e228 0000000e7f5d31d0 0000000000000001 0000000281082d75
Call Trace:
 [<ffffffffa042ee8c>] ufs_inode_getfrag+0x23c/0x650 [ufs]
 [<ffffffffa042f7a8>] ufs_getfrag_block+0x508/0x710 [ufs]
 [<ffffffff815309f5>] ? _raw_spin_unlock+0x35/0x60
 [<ffffffff81188de4>] __block_write_begin+0x204/0x640
 [<ffffffffa042f2a0>] ? ufs_getfrag_block+0x0/0x710 [ufs]
 [<ffffffff8110291c>] ? grab_cache_page_write_begin+0x9c/0xc0
 [<ffffffffa042f2a0>] ? ufs_getfrag_block+0x0/0x710 [ufs]
 [<ffffffff81189386>] block_write_begin+0x56/0x90
 [<ffffffffa042d404>] ufs_write_begin+0x44/0x80 [ufs]
 [<ffffffff81104104>] generic_file_buffered_write+0x114/0x2a0
 [<ffffffff815348dd>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff811044eb>] __generic_file_aio_write+0x25b/0x490
 [<ffffffff81104774>] ? generic_file_aio_write+0x54/0xd0
 [<ffffffff81104787>] generic_file_aio_write+0x67/0xd0
 [<ffffffff811587ca>] do_sync_write+0xda/0x120
 [<ffffffff81044e51>] ? get_parent_ip+0x11/0x50
 [<ffffffff8152e425>] ? __mutex_unlock_slowpath+0xf5/0x170
 [<ffffffff8126ab63>] ? security_file_permission+0x23/0x90
 [<ffffffff81158af0>] vfs_write+0xd0/0x1a0
 [<ffffffff811594f4>] sys_write+0x54/0x90
 [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
Code: 48 8d 7c 90 34 e8 78 d0 ff ff 44 8b 9d f8 fe ff ff 4c 8b 95 e8
fe ff ff 4c 8b 8d e0 fe ff ff 4c 8b 85 f0 fe ff ff e9 52 f7 ff ff <0f>
0b eb fe 48 8b bb 50 02 00 00 4c 89 e9 48 c7 c2 00 6b 43 a0
RIP  [<ffffffffa042a2f9>] ufs_new_fragments+0xed9/0xf20 [ufs]
 RSP <ffff88005a91f808>

Ciao,
Alessio
