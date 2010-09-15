Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0IOXqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 19:46:39 -0400
Received: from newpeace.netnation.com ([204.174.223.7]:58276 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754154Ab0IOXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 19:46:37 -0400
Date: Wed, 15 Sep 2010 16:46:33 -0700
From: Simon Kirby <sim@hostway.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [linux-pm] [2.6.36-rc4/HEAD] unable to handle kernel NULL
	pointer dereference?(plist_add)
Message-ID: <20100915234633.GW23979@hostway.ca>
References: <20100913070034.GA4820@hostway.ca> <201009142238.25840.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009142238.25840.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 10:38:25PM +0200, Rafael J. Wysocki wrote:

> Hmm, interesting.  This looks like a plist corruption to me, but can you please
> check (using gdb) what line of code corresponds to the address
> plist_add+0x36/0xa0 ?

I ended up rebuilding since then, and I enabled a bunch of debugging
stuff.  Does this help make it more obvious?  I'll try your other patch
tonight, but I still don't get what's wrong with the existing code.

Simon-

[51198.357666] ICE1724 0000:01:06.0: PCI INT A disabled
[51198.380010] ICE1724 0000:01:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[51199.893821] ------------[ cut here ]------------
[51199.893821] WARNING: at lib/plist.c:40 plist_check_list+0x62/0xe0()
[51199.893821] Hardware name: System Product Name
[51199.893821] top: ffffffff819c7da0, n: ffff8801ac029288, p: ffff8801ac029288
[51199.893821] prev: ffffffff819c7da0, n: ffff8801ac029288, p: ffff8801ac029288
[51199.893821] next: ffff8801ac029288, n: 6b6b6b6b6b6b6b6b, p: 6b6b6b6b6b6b6b6b
[51199.893821] Modules linked in: snd_ice1724 sco bnep rfcomm l2cap bluetooth ppdev hwmon_vid usb_storage tun i2c_viapro snd_rawmidi snd_ice17xx_ak4xxx snd_ac97_codec ac97_bus snd_ak4xxx_adda snd_ak4114 snd_pt2258 parport_pc snd_i2c parport snd_ak4113 k10temp r8169 [last unloaded: snd_ice1724]
[51199.893821] Pid: 4392, comm: mplayer Not tainted 2.6.36-rc4-oofdbg+ #8
[51199.893821] Call Trace:
[51199.893821]  [<ffffffff8103ffca>] warn_slowpath_common+0x7a/0xb0
[51199.893821]  [<ffffffff810400a1>] warn_slowpath_fmt+0x41/0x50
[51199.893821]  [<ffffffff813a2632>] plist_check_list+0x62/0xe0
[51199.893821]  [<ffffffff813a26ec>] plist_check_head+0x3c/0xa0
[51199.893821]  [<ffffffff813a280d>] plist_add+0x1d/0xb0
[51199.893821]  [<ffffffff81067376>] update_target+0x146/0x160
[51199.893821]  [<ffffffff810675ca>] pm_qos_add_request+0x5a/0x90
[51199.893821]  [<ffffffff815b1c64>] snd_pcm_hw_params+0x2e4/0x3b0
[51199.893821]  [<ffffffff815b2121>] snd_pcm_common_ioctl1+0xb1/0xbe0
[51199.893821]  [<ffffffff8106798b>] ? local_clock+0x4b/0x60
[51199.893821]  [<ffffffff81073115>] ? lock_release_holdtime+0x35/0x180
[51199.893821]  [<ffffffff815b2f5d>] snd_pcm_playback_ioctl1+0x3d/0x280
[51199.893821]  [<ffffffff81065fce>] ? up_read+0x1e/0x40
[51199.893821]  [<ffffffff816dbd0c>] ? do_page_fault+0x18c/0x450
[51199.893821]  [<ffffffff815b390d>] snd_pcm_playback_ioctl+0x3d/0x50
[51199.893821]  [<ffffffff81101d71>] do_vfs_ioctl+0xa1/0x5a0
[51199.893821]  [<ffffffff810f2b84>] ? fget_light+0x124/0x2d0
[51199.893821]  [<ffffffff811022ba>] sys_ioctl+0x4a/0x80
[51199.893821]  [<ffffffff81002d6b>] system_call_fastpath+0x16/0x1b
[51199.893821] ---[ end trace 6aefebd043d8473f ]---
[51199.893821] general protection fault: 0000 [#1] SMP
[51199.893821] last sysfs file: /sys/devices/pci0000:00/0000:00:14.4/0000:01:06.0/sound/card0/uevent
[51199.893821] CPU 1
[51199.893821] Modules linked in: snd_ice1724 sco bnep rfcomm l2cap bluetooth ppdev hwmon_vid usb_storage tun i2c_viapro snd_rawmidi snd_ice17xx_ak4xxx snd_ac97_codec ac97_bus snd_ak4xxx_adda snd_ak4114 snd_pt2258 parport_pc snd_i2c parport snd_ak4113 k10temp r8169 [last unloaded: snd_ice1724]
[51199.893821]
[51199.893821] Pid: 4392, comm: mplayer Tainted: G        W   2.6.36-rc4-oofdbg+ #8 M4A79T Deluxe/System Product Name
[51199.893821] RIP: 0010:[<ffffffff813a2647>]  [<ffffffff813a2647>] plist_check_list+0x77/0xe0
[51199.893821] RSP: 0018:ffff880179309c58  EFLAGS: 00010016
[51199.893821] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
[51199.893821] RDX: ffff880008800000 RSI: 0000000000000001 RDI: 0000000000000009
[51199.893821] RBP: ffff880179309ca8 R08: 0000000000000001 R09: 0000000000000000
[51199.893821] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8801ac029288
[51199.893821] R13: ffffffff819c7da0 R14: ffff8801a5550040 R15: ffffffff819c7db0
[51199.893821] FS:  00007f559b19c860(0000) GS:ffff880008800000(0000) knlGS:00000000f76066c0
[51199.893821] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[51199.893821] CR2: 00007f55994f6030 CR3: 00000001a3b5a000 CR4: 00000000000006e0
[51199.893821] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[51199.893821] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[51199.893821] Process mplayer (pid: 4392, threadinfo ffff880179308000, task ffff8801a8525000)
[51199.893821] Stack:
[51199.893821]  ffffffff819c7da0 ffff8801ac029288 ffff8801ac029288 ffff8801ac029288
[51199.893821] <0> 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b ffff880179309ca8 ffffffff819c7da0
[51199.893821] <0> ffff8801a5550040 ffff8801a5550058 ffff880179309cc8 ffffffff813a26ec
[51199.893821] Call Trace:
[51199.893821]  [<ffffffff813a26ec>] plist_check_head+0x3c/0xa0
[51199.893821]  [<ffffffff813a280d>] plist_add+0x1d/0xb0
[51199.893821]  [<ffffffff81067376>] update_target+0x146/0x160
[51199.893821]  [<ffffffff810675ca>] pm_qos_add_request+0x5a/0x90
[51199.893821]  [<ffffffff815b1c64>] snd_pcm_hw_params+0x2e4/0x3b0
[51199.893821]  [<ffffffff815b2121>] snd_pcm_common_ioctl1+0xb1/0xbe0
[51199.893821]  [<ffffffff8106798b>] ? local_clock+0x4b/0x60
[51199.893821]  [<ffffffff81073115>] ? lock_release_holdtime+0x35/0x180
[51199.893821]  [<ffffffff815b2f5d>] snd_pcm_playback_ioctl1+0x3d/0x280
[51199.893821]  [<ffffffff81065fce>] ? up_read+0x1e/0x40
[51199.893821]  [<ffffffff816dbd0c>] ? do_page_fault+0x18c/0x450
[51199.893821]  [<ffffffff815b390d>] snd_pcm_playback_ioctl+0x3d/0x50
[51199.893821]  [<ffffffff81101d71>] do_vfs_ioctl+0xa1/0x5a0
[51199.893821]  [<ffffffff810f2b84>] ? fget_light+0x124/0x2d0
[51199.893821]  [<ffffffff811022ba>] sys_ioctl+0x4a/0x80
[51199.893821]  [<ffffffff81002d6b>] system_call_fastpath+0x16/0x1b
[51199.893821] Code: 4c 89 4c 24 10 48 89 44 24 20 31 c0 4c 89 64 24 08 e8 2e da c9 ff 4d 39 e5 75 0c eb 66 0f 1f 80 00 00 00 00 49 89 dc 49 8b 1c 24 <48> 8b 43 08 49 39 c4 74 4a 48 89 44 24 28 48 8b 03 4c 89 e9 48
[51199.893821] RIP  [<ffffffff813a2647>] plist_check_list+0x77/0xe0
[51199.893821]  RSP <ffff880179309c58>
[51199.893821] ---[ end trace 6aefebd043d84740 ]---
[51938.896002] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

incidentally, kmemleak output:

unreferenced object 0xffff8801aea4a000 (size 232):
  comm "swapper", pid 1, jiffies 4294893947 (age 78417.732s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816c02d5>] kmemleak_alloc+0x25/0x50
    [<ffffffff810ea042>] kmem_cache_alloc+0x112/0x1a0
    [<ffffffff815d1495>] __alloc_skb+0x45/0x160
    [<ffffffff81c5e139>] llc_station_init+0xf1/0x13f
    [<ffffffff81c5dfa7>] llc2_init+0x2b/0xcc
    [<ffffffff810001de>] do_one_initcall+0x3e/0x170
    [<ffffffff81c316cc>] kernel_init+0x143/0x1cc
    [<ffffffff81003b14>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801ac658ff8 (size 512):
  comm "swapper", pid 1, jiffies 4294893947 (age 78417.736s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816c02d5>] kmemleak_alloc+0x25/0x50
    [<ffffffff810ea86b>] __kmalloc_track_caller+0x12b/0x250
    [<ffffffff815d14c2>] __alloc_skb+0x72/0x160
    [<ffffffff81c5e139>] llc_station_init+0xf1/0x13f
    [<ffffffff81c5dfa7>] llc2_init+0x2b/0xcc
    [<ffffffff810001de>] do_one_initcall+0x3e/0x170
    [<ffffffff81c316cc>] kernel_init+0x143/0x1cc
    [<ffffffff81003b14>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801a8c5af18 (size 1024):
  comm "mplayer", pid 4392, jiffies 4307692268 (age 27224.632s)
  hex dump (first 32 bytes):
    00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816c02d5>] kmemleak_alloc+0x25/0x50
    [<ffffffff810ea86b>] __kmalloc_track_caller+0x12b/0x250
    [<ffffffff810cd75b>] memdup_user+0x2b/0x90
    [<ffffffff815b20ff>] snd_pcm_common_ioctl1+0x8f/0xbe0
    [<ffffffff815b2f5d>] snd_pcm_playback_ioctl1+0x3d/0x280
    [<ffffffff815b390d>] snd_pcm_playback_ioctl+0x3d/0x50
    [<ffffffff81101d71>] do_vfs_ioctl+0xa1/0x5a0
    [<ffffffff811022ba>] sys_ioctl+0x4a/0x80
    [<ffffffff81002d6b>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
