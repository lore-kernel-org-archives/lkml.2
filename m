Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1IJRMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 13:12:33 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:57060 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759626Ab1IJRMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 13:12:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109101009120.27686@p34.internal.lan>
References: <alpine.DEB.2.02.1109101009120.27686@p34.internal.lan>
Date: Sun, 11 Sep 2011 01:12:26 +0800
Message-ID: <CAF1ivSbtLR4OXexX6BNg+Z_piwbLG3xFaMUCnxaOPSahCOG6mg@mail.gmail.com>
Subject: Re: kernel 3.1-rc4: BUG soft lockup (w/frame pointers enabled)
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 10:10 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> Still getting these every now and then:
>
> [490572.973022] BUG: soft lockup - CPU#21 stuck for 22s! [kswapd1:948]
> [490572.973026] Modules linked in: tcp_diag parport_pc ppdev lp parport
> inet_diag pl2303 ftdi_sio snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm
> snd_page_alloc snd_hwdep snd_usbmidi_lib snd_seq_dummy snd_seq_oss
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
> snd soundcore ub cdc_acm usbserial joydev serio_raw nouveau ttm
> drm_kms_helper drm agpgart i2c_algo_bit mxm_wmi wmi i7core_edac edac_core
> video
> [490572.973052] CPU 21 [490572.973053] Modules linked in: tcp_diag
> parport_pc ppdev lp parport inet_diag pl2303 ftdi_sio snd_usb_audio
> snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device snd soundcore ub cdc_acm usbserial joydev
> serio_raw nouveau ttm drm_kms_helper drm agpgart i2c_algo_bit mxm_wmi wmi
> i7core_edac edac_core video
> [490572.973070] [490572.973072] Pid: 948, comm: kswapd1 Not tainted
> 3.1.0-rc4 #1 Supermicro X8DTH-i/6/iF/6F/X8DTH
> [490572.973075] RIP: 0010:[<ffffffff810857de>]  [<ffffffff810857de>]
> find_get_pages+0x4e/0x130
> [490572.973086] RSP: 0018:ffff88062613baf0  EFLAGS: 00000246
> [490572.973087] RAX: ffff8809f7e98b98 RBX: 0000000000000000 RCX:
> 0000000000000000
> [490572.973089] RDX: ffff88062613bb90 RSI: 000000000000000e RDI:
> ffffea00025d50f8
> [490572.973090] RBP: ffff88062613bb40 R08: 0000000000000000 R09:
> ffff88062613bab0
> [490572.973092] R10: 0000000000000396 R11: 000000000000000d R12:
> ffffea0001ae52b8
> [490572.973094] R13: ffffffff8108b5ad R14: ffff88062613ba70 R15:
> dead000000100100
> [490572.973096] FS:  0000000000000000(0000) GS:ffff880c3fd20000(0000)
> knlGS:0000000000000000
> [490572.973097] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [490572.973099] CR2: ffffffffff600400 CR3: 0000000001845000 CR4:
> 00000000000006e0
> [490572.973100] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [490572.973102] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [490572.973104] Process kswapd1 (pid: 948, threadinfo ffff88062613a000, task
> ffff880626c85950)
> [490572.973105] Stack:
> [490572.973107]  ffffea0001ae2b58 ffffea0001ae5280 ffffea0001ae52b8
> 0000000000000000
> [490572.973112]  ffff88062613bb30 ffff88062613bb80 0000000000000273
> ffffffffffffffff
> [490572.973115]  ffff8808dca24e48 ffffea0001ae52b8 ffff88062613bb60
> ffffffff8108da0d
> [490572.973118] Call Trace:
> [490572.973125]  [<ffffffff8108da0d>] pagevec_lookup+0x1d/0x30
> [490572.973128]  [<ffffffff8108f7b0>] invalidate_mapping_pages+0x70/0x1b0
> [490572.973133]  [<ffffffff810de2b2>] prune_icache_sb+0x292/0x2e0
> [490572.973138]  [<ffffffff810c8413>] prune_super+0x193/0x1b0
> [490572.973140]  [<ffffffff81090211>] shrink_slab+0x121/0x1b0
> [490572.973143]  [<ffffffff81092f1a>] balance_pgdat+0x4fa/0x690
> [490572.973146]  [<ffffffff81093163>] kswapd+0xb3/0x250
> [490572.973150]  [<ffffffff81052b80>] ? abort_exclusive_wait+0xb0/0xb0
> [490572.973153]  [<ffffffff810930b0>] ? balance_pgdat+0x690/0x690
> [490572.973155]  [<ffffffff810523b7>] kthread+0x87/0x90
> [490572.973160]  [<ffffffff815dbdb4>] kernel_thread_helper+0x4/0x10
> [490572.973163]  [<ffffffff81052330>] ? kthread_worker_fn+0x130/0x130
> [490572.973165]  [<ffffffff815dbdb0>] ? gs_change+0xb/0xb
> [490572.973166] Code: 45 89 e8 4c 89 e1 4c 89 f7 e8 0f 6b 26 00 85 c0 89 c6
> 0f 84 c5 00 00 00 48 89 da 31 c9 45 31 ff 0f 1f 44 00 00 48 8b 02 48 8b 38
> [490572.973179]  85 ff 74 3e 40 f6 c7 03 75 5f 44 8b 47 1c 45 85 c0 74 ec 45
> [490572.973189] Call Trace:
> [490572.973191]  [<ffffffff8108da0d>] pagevec_lookup+0x1d/0x30
> [490572.973194]  [<ffffffff8108f7b0>] invalidate_mapping_pages+0x70/0x1b0
> [490572.973197]  [<ffffffff810de2b2>] prune_icache_sb+0x292/0x2e0
> [490572.973199]  [<ffffffff810c8413>] prune_super+0x193/0x1b0
> [490572.973202]  [<ffffffff81090211>] shrink_slab+0x121/0x1b0
> [490572.973204]  [<ffffffff81092f1a>] balance_pgdat+0x4fa/0x690
> [490572.973207]  [<ffffffff81093163>] kswapd+0xb3/0x250
> [490572.973209]  [<ffffffff81052b80>] ? abort_exclusive_wait+0xb0/0xb0
> [490572.973215]  [<ffffffff810930b0>] ? balance_pgdat+0x690/0x690
> [490572.973217]  [<ffffffff810523b7>] kthread+0x87/0x90
> [490572.973219]  [<ffffffff815dbdb4>] kernel_thread_helper+0x4/0x10
> [490572.973222]  [<ffffffff81052330>] ? kthread_worker_fn+0x130/0x130
> [490572.973224]  [<ffffffff815dbdb0>] ? gs_change+0xb/0xb

Hi,

I tried to reproduce this bug by running multi rsync to sync a lot of
files and kswap was woken up.
But it's still not reproducible on my box.

Could you tell how to reproduce this?

And would you please turn on more debug options to capture more info?

CONFIG_SLUB_DEBUG=y
CONFIG_SLUB_DEBUG_ON=y
CONFIG_DEBUG_VM=y

Lin Ming
