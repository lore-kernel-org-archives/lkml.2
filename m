Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2JBSGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:06:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37362 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2JBSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:06:08 -0400
Message-ID: <1349201166.3141.37.camel@lorien2>
Subject: kernel null pointer dereference at kmem_cache_alloc+0x5b/0x140
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: shuahkhan@gmail.com
Date: Tue, 02 Oct 2012 12:06:06 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started seeing the following null pointer dereference on
a linux-next sept 21 git and still seeing it on linux-next 
Sep 27th git.

Can be reproduced easily. I have been able to reproduce every
time I do a complete build of a kernel on fresh checkout or
touch a header file that forces full build.

I didn't get a chance to investigate this yet, thought I would
share just in case others have seen it.

[   32.500078] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   34.561841] tty_init_dev: 48 callbacks suppressed
[   34.575258] init: plymouth-stop pre-start process (1436) terminated with status 1
[11478.881196] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[11478.881245] IP: [<ffffffff811742bb>] kmem_cache_alloc+0x5b/0x140
[11478.881277] PGD 74386067 PUD 5dfab067 PMD 0 
[11478.881302] Oops: 0000 [#2] SMP 
[11478.881324] Modules linked in: bnep rfcomm bluetooth snd_hda_codec_analog arc4 iwldvm radeon snd_hda_intel snd_hda_codec snd_hwdep mac80211 snd_pcm coretemp snd_seq_midi snd_rawmidi kvm_intel kvm snd_seq_midi_event ttm snd_seq drm_kms_helper iwlwifi drm snd_timer cfg80211 snd_seq_device pata_pcmcia tpm_infineon snd psmouse pcmcia binfmt_misc joydev ppdev hp_wmi soundcore snd_page_alloc mac_hid hp_accel yenta_socket sparse_keymap lis3lv02d input_polldev serio_raw parport_pc tpm_tis video(+) i2c_algo_bit microcode lpc_ich pcmcia_rsrc pcmcia_core wmi lp parport firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t e1000e
[11478.881705] CPU 0 
[11478.881717] Pid: 6399, comm: ld Tainted: G      D      3.6.0-rc7-next-20120927+ #1 Hewlett-Packard HP EliteBook 6930p/30DC
[11478.881762] RIP: 0010:[<ffffffff811742bb>]  [<ffffffff811742bb>] kmem_cache_alloc+0x5b/0x140
[11478.881797] RSP: 0018:ffff88005dec1898  EFLAGS: 00010202
[11478.881819] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000007735
[11478.881844] RDX: 0000000000007734 RSI: 0000000000000050 RDI: 0000000000018270
[11478.881869] RBP: ffff88005dec18e8 R08: ffff88007fa18270 R09: 0000000000001000
[11478.881894] R10: 0000000000000001 R11: 0000000000000246 R12: ffff880030206200
[11478.881918] R13: 0000000000000001 R14: ffffffff8125dab1 R15: 0000000000000050
[11478.883284] FS:  00002af25774fd00(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
[11478.884005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11478.884005] CR2: 0000000000000001 CR3: 000000005ded1000 CR4: 00000000000407f0
[11478.884005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[11478.884005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[11478.884005] Process ld (pid: 6399, threadinfo ffff88005dec0000, task ffff88007bf244a0)
[11478.884005] Stack:
[11478.884005]  ffff88005dec18c8 ffffffff811dcb71 ffff88007fcbb6c0 ffff880078d30440
[11478.884005]  ffff8800303df800 0000000000000000 ffff880078d30440 0000000000000001
[11478.884005]  ffff88007598c150 0000000000000001 ffff88005dec1948 ffffffff8125dab1
[11478.884005] Call Trace:
[11478.884005]  [<ffffffff811dcb71>] ? inode_add_rsv_space+0x41/0x60
[11478.884005]  [<ffffffff8125dab1>] ext4_es_insert_extent+0x1e1/0x2f0
[11478.900635]  [<ffffffff8121c9ad>] ext4_da_get_block_prep+0x11d/0x3b0
[11478.900635]  [<ffffffff811b16c3>] ? alloc_buffer_head+0x43/0x50
[11478.900635]  [<ffffffff811b183e>] ? alloc_page_buffers+0x7e/0xf0
[11478.900635]  [<ffffffff811b3dee>] __block_write_begin+0x1ce/0x520
[11478.900635]  [<ffffffff8121c890>] ? do_journal_get_write_access+0xb0/0xb0
[11478.900635]  [<ffffffff81127039>] ? grab_cache_page_write_begin+0x69/0xf0
[11478.900635]  [<ffffffff81220308>] ext4_da_write_begin+0xc8/0x210
[11478.900635]  [<ffffffff81220f80>] ? noalloc_get_block_write+0x30/0x30
[11478.900635]  [<ffffffff81126552>] generic_file_buffered_write+0x112/0x290
[11478.900635]  [<ffffffff81127cf6>] __generic_file_aio_write+0x1b6/0x3b0
[11478.900635]  [<ffffffff81127f6f>] generic_file_aio_write+0x7f/0x100
[11478.900635]  [<ffffffff812192b0>] ext4_file_write+0xa0/0x460
[11478.900635]  [<ffffffff81180103>] do_sync_write+0xa3/0xe0
[11478.900635]  [<ffffffff811809d3>] vfs_write+0xb3/0x180
[11478.900635]  [<ffffffff81180d12>] sys_write+0x52/0xa0
[11478.900635]  [<ffffffff8168c139>] system_call_fastpath+0x16/0x1b
[11478.900635] Code: 00 4d 8b 04 24 65 4c 03 04 25 08 dc 00 00 49 8b 50 08 4d 8b 28 4d 85 ed 0f 84 d3 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2 49 
[11478.900635] RIP  [<ffffffff811742bb>] kmem_cache_alloc+0x5b/0x140
[11478.900635]  RSP <ffff88005dec1898>
[11478.900635] CR2: 0000000000000001
[11478.936473] ---[ end trace b104c041ce1ebd2e ]---
[11479.001819] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[11479.003374] IP: [<ffffffff811742bb>] kmem_cache_alloc+0x5b/0x140
[11479.004947] PGD 771a4067 PUD 771a5067 PMD 0 
[11479.005662] Oops: 0000 [#3] SMP 
[11479.005662] Modules linked in: bnep rfcomm bluetooth snd_hda_codec_analog arc4 iwldvm radeon snd_hda_intel snd_hda_codec snd_hwdep mac80211 snd_pcm coretemp snd_seq_midi snd_rawmidi kvm_intel kvm snd_seq_midi_event ttm snd_seq drm_kms_helper iwlwifi drm snd_timer cfg80211 snd_seq_device pata_pcmcia tpm_infineon snd psmouse pcmcia binfmt_misc joydev ppdev hp_wmi soundcore snd_page_alloc mac_hid hp_accel yenta_socket sparse_keymap lis3lv02d input_polldev serio_raw parport_pc tpm_tis video(+) i2c_algo_bit microcode lpc_ich pcmcia_rsrc pcmcia_core wmi lp parport firewire_ohci firewire_core sdhci_pci sdhci crc_itu_t e1000e
[11479.005662] CPU 0 
[11479.005662] Pid: 816, comm: rs:main Q:Reg Tainted: G      D      3.6.0-rc7-next-20120927+ #1 Hewlett-Packard HP EliteBook 6930p/30DC
[11479.005662] RIP: 0010:[<ffffffff811742bb>]  [<ffffffff811742bb>] kmem_cache_alloc+0x5b/0x140
[11479.005662] RSP: 0018:ffff8800737d3898  EFLAGS: 00010202
[11479.005662] RAX: 0000000000000000 RBX: 00000000000000cf RCX: 0000000000007735
[11479.005662] RDX: 0000000000007734 RSI: 0000000000000050 RDI: 0000000000018270
[11479.005662] RBP: ffff8800737d38e8 R08: ffff88007fa18270 R09: 0000000000001000
[11479.005662] R10: ffffffff8124c27f R11: 685f646e73206e6f R12: ffff880030206200
[11479.005662] R13: 0000000000000001 R14: ffffffff8125dab1 R15: 0000000000000050
[11479.005662] FS:  00007fccbb887700(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
[11479.005662] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11479.005662] CR2: 0000000000000001 CR3: 0000000077037000 CR4: 00000000000407f0
[11479.005662] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[11479.005662] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[11479.005662] Process rs:main Q:Reg (pid: 816, threadinfo ffff8800737d2000, task ffff88002fe616e0)
[11479.005662] Stack:
[11479.005662]  ffff8800737d38c8 ffffffff811dcb71 ffff8800737d39f8 ffff88002ed2f290
[11479.005662]  ffff8800303df800 00000000000000cf ffff88002ed2f290 0000000000000001
[11479.005662]  ffff88002ed2f4f8 00000000000000d0 ffff8800737d3948 ffffffff8125dab1
[11479.005662] Call Trace:
[11479.005662]  [<ffffffff811dcb71>] ? inode_add_rsv_space+0x41/0x60
[11479.005662]  [<ffffffff8125dab1>] ext4_es_insert_extent+0x1e1/0x2f0
[11479.005662]  [<ffffffff8121c9ad>] ext4_da_get_block_prep+0x11d/0x3b0
[11479.005662]  [<ffffffff811b16c3>] ? alloc_buffer_head+0x43/0x50
[11479.005662]  [<ffffffff811b183e>] ? alloc_page_buffers+0x7e/0xf0
[11479.005662]  [<ffffffff811b3dee>] __block_write_begin+0x1ce/0x520
[11479.005662]  [<ffffffff8121c890>] ? do_journal_get_write_access+0xb0/0xb0
[11479.005662]  [<ffffffff8112705f>] ? grab_cache_page_write_begin+0x8f/0xf0
[11479.005662]  [<ffffffff81220308>] ext4_da_write_begin+0xc8/0x210
[11479.005662]  [<ffffffff81126552>] generic_file_buffered_write+0x112/0x290
[11479.005662]  [<ffffffff81127cf6>] __generic_file_aio_write+0x1b6/0x3b0
[11479.005662]  [<ffffffff81127f6f>] generic_file_aio_write+0x7f/0x100
[11479.005662]  [<ffffffff812192b0>] ext4_file_write+0xa0/0x460
[11479.005662]  [<ffffffff816836de>] ? _raw_spin_lock+0xe/0x20
[11479.005662]  [<ffffffff810b0a63>] ? futex_wake+0x113/0x130
[11479.005662]  [<ffffffff81180103>] do_sync_write+0xa3/0xe0
[11479.005662]  [<ffffffff811809d3>] vfs_write+0xb3/0x180
[11479.005662]  [<ffffffff81180d12>] sys_write+0x52/0xa0
[11479.005662]  [<ffffffff8168c139>] system_call_fastpath+0x16/0x1b
[11479.005662] Code: 00 4d 8b 04 24 65 4c 03 04 25 08 dc 00 00 49 8b 50 08 4d 8b 28 4d 85 ed 0f 84 d3 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2 49 
[11479.005662] RIP  [<ffffffff811742bb>] kmem_cache_alloc+0x5b/0x140
[11479.005662]  RSP <ffff8800737d3898>
[11479.005662] CR2: 0000000000000001
[11479.082628] ---[ end trace b104c041ce1ebd2f ]---



