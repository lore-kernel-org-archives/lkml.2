Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2JBR6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:58:32 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:15845 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2JBR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:58:30 -0400
Message-ID: <1349200709.3141.30.camel@lorien2>
Subject: kernel NULL pointer dereference at rb_erase+0x1a3/0x370
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 02 Oct 2012 11:58:29 -0600
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

Related to lib/rbtree.c commits that went into September 21 perhaps.
I didn't get a chance to investigate this yet, thought I would share
just in case others have seen it.


[  346.676805] audit_printk_skb: 24 callbacks suppressed
[  346.676814] type=1400 audit(1349010919.383:28): apparmor="DENIED" operation="capable" parent=1 profile="/usr/sbin/cupsd" pid=905 comm="cupsd" pid=905 comm="cupsd" capability=36  capname="block_suspend"
[ 2219.660124] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 2219.660182] IP: [<ffffffff81323c93>] rb_erase+0x1a3/0x370
[ 2219.660209] PGD 73f2f067 PUD 67246067 PMD 0 
[ 2219.660235] Oops: 0000 [#1] SMP 
[ 2219.660257] Modules linked in: bnep arc4 iwldvm rfcomm bluetooth mac80211 coretemp radeon kvm_intel kvm snd_hda_codec_analog snd_hda_intel snd_hda_codec iwlwifi snd_hwdep snd_pcm snd_seq_midi snd_rawmidi ttm drm_kms_helper snd_seq_midi_event snd_seq drm pata_pcmcia cfg80211 psmouse snd_timer binfmt_misc pcmcia tpm_infineon hp_wmi snd_seq_device snd sparse_keymap joydev ppdev yenta_socket microcode hp_accel lis3lv02d soundcore wmi i2c_algo_bit parport_pc serio_raw pcmcia_rsrc pcmcia_core tpm_tis input_polldev snd_page_alloc lpc_ich mac_hid video lp parport firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci e1000e
[ 2219.660632] CPU 0 
[ 2219.660644] Pid: 1660, comm: recordmcount Not tainted 3.6.0-rc6-next-20120921+ #4 Hewlett-Packard HP EliteBook 6930p/30DC
[ 2219.660684] RIP: 0010:[<ffffffff81323c93>]  [<ffffffff81323c93>] rb_erase+0x1a3/0x370
[ 2219.660714] RSP: 0018:ffff880073f318e8  EFLAGS: 00010246
[ 2219.662042] RAX: ffff88007911ea80 RBX: 000000000000003b RCX: 0000000000000000
[ 2219.663345] RDX: 0000000000000000 RSI: ffff88007a4e1c08 RDI: 0000000000000001
[ 2219.664007] RBP: ffff880073f318e8 R08: ffff88007911ea40 R09: 0000000000000000
[ 2219.664007] R10: ffff88007911ea00 R11: 0000000000000018 R12: ffff88007a4e19a0
[ 2219.664007] R13: 0000000000000001 R14: 0000000000000001 R15: 000000000000003c
[ 2219.664007] FS:  00002b380a82bb40(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
[ 2219.664007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2219.664007] CR2: 0000000000000000 CR3: 0000000079428000 CR4: 00000000000407f0
[ 2219.664007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2219.664007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2219.664007] Process recordmcount (pid: 1660, threadinfo ffff880073f30000, task ffff88002fe9ada0)
[ 2219.664007] Stack:
[ 2219.664007]  ffff880073f31948 ffffffff8125af6e ffff88007911eaa0 ffff88007911ea80
[ 2219.664007]  ffff88002fe7c400 ffff88002fe7c400 0000000000000002 ffff88007a4e19a0
[ 2219.664007]  ffff88007aa4e6e8 ffff88002fe7c400 0000000000000001 000000000000003b
[ 2219.664007] Call Trace:
[ 2219.664007]  [<ffffffff8125af6e>] ext4_es_insert_extent+0x28e/0x2f0
[ 2219.664007]  [<ffffffff81219e1d>] ext4_da_get_block_prep+0x11d/0x3b0
[ 2219.664007]  [<ffffffff811afa63>] ? alloc_buffer_head+0x43/0x50
[ 2219.664007]  [<ffffffff811afbde>] ? alloc_page_buffers+0x7e/0xf0
[ 2219.664007]  [<ffffffff811b218e>] __block_write_begin+0x1ce/0x520
[ 2219.664007]  [<ffffffff81219d00>] ? do_journal_get_write_access+0xb0/0xb0
[ 2219.664007]  [<ffffffff81126b8f>] ? grab_cache_page_write_begin+0x8f/0xf0
[ 2219.664007]  [<ffffffff8121d778>] ext4_da_write_begin+0xc8/0x210
[ 2219.664007]  [<ffffffff81126082>] generic_file_buffered_write+0x112/0x290
[ 2219.664007]  [<ffffffff81127826>] __generic_file_aio_write+0x1b6/0x3b0
[ 2219.664007]  [<ffffffff81127a9f>] generic_file_aio_write+0x7f/0x100
[ 2219.664007]  [<ffffffff81216640>] ext4_file_write+0xa0/0x460
[ 2219.664007]  [<ffffffff8104a787>] ? pte_alloc_one+0x37/0x50
[ 2219.664007]  [<ffffffff8167f3be>] ? _raw_spin_lock+0xe/0x20
[ 2219.664007]  [<ffffffff8114c269>] ? __pte_alloc+0xa9/0x160
[ 2219.664007]  [<ffffffff8117eed3>] do_sync_write+0xa3/0xe0
[ 2219.664007]  [<ffffffff8117f563>] vfs_write+0xb3/0x180
[ 2219.664007]  [<ffffffff8117f88a>] sys_write+0x4a/0x90
[ 2219.664007]  [<ffffffff8168375e>] ? do_page_fault+0xe/0x10
[ 2219.664007]  [<ffffffff81687da9>] system_call_fastpath+0x16/0x1b
[ 2219.664007] Code: 10 f6 c2 01 0f 84 4e 01 00 00 48 83 e2 fc 0f 84 10 ff ff ff 48 89 c1 48 89 d0 48 8b 50 08 48 39 ca 0f 85 71 ff ff ff 48 8b 50 10 <f6> 02 01 75 3a 48 8b 7a 08 48 89 c1 48 83 c9 01 48 89 78 10 48 
[ 2219.664007] RIP  [<ffffffff81323c93>] rb_erase+0x1a3/0x370
[ 2219.664007]  RSP <ffff880073f318e8>
[ 2219.664007] CR2: 0000000000000000
[ 2219.724809] ---[ end trace dc0112a541a4c9dc ]---



