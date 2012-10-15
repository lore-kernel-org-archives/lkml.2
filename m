Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2JOMcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:32:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab2JOMct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:32:49 -0400
Message-ID: <1350304367.25134.21.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: Fwd: PROBLEM: 3.6.0 kernel BUG at fs/dcache.c:967 during
 shutdown / restart
From: Miklos Szeredi <mszeredi@suse.cz>
To: Neil Salstrom <salstrom@paintedocean.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        miklos@szeredi.hu
Date: Mon, 15 Oct 2012 14:32:47 +0200
In-Reply-To: <CA+W8Zy+Q6T09+WRooiYghXoKorBHzcHdVfHygPSGWG_PkUz=fw@mail.gmail.com>
References: <CA+W8ZyK4NYGUtXce-dP69J8L6WJ81_fOOXWrMebK3BO_K7FozA@mail.gmail.com>
	 <CA+W8Zy+Q6T09+WRooiYghXoKorBHzcHdVfHygPSGWG_PkUz=fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 14:16 -0700, Neil Salstrom wrote:

> 
> I've not submitted a kernel bug before but I've read the bug reporting
> pages.  I'll try to do my best and if you need more information please
> let me know.
> 
> I'm using Linux Mint 13 (64 bit) on AMD hardware with a self compiled
> 3.6.0 kernel for my MythTV HTPC.
> 
> Kernel version: Linux version 3.6.0 (gcc version 4.6.3 (Ubuntu/Linaro
> 4.6.3-1ubuntu5) ) #1 SMP Tue Oct 2 15:34:46 PDT 2012
> 
> CPU: model name      : AMD A6-3500 APU with Radeon(tm) HD Graphics
> 
> If you need any other system variables please let me know and I can
> get those as well.
> 
> Upon shutdown or restart (from either the hard button on the case or a
> "sudo shutdown -r now" the system crashes and does not actually shut
> down.  I can ssh in to the system and a dmesg shows the following:

There should be a line before the "[ cut here ]" something like:

BUG: Dentry foobar still in use ...

Please send this information as well.

Thanks,
Miklos

> 
> [102792.710563] ------------[ cut here ]------------
> [102792.710564] kernel BUG at fs/dcache.c:967!
> [102792.710566] invalid opcode: 0000 [#1] SMP 
> [102792.710568] Modules linked in: nls_utf8 udf crc_itu_t nfsv4
> binfmt_misc nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc
> snd_hda_codec_hdmi xfs nvidia(PO) rc_imon_mce imon rc_core
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_seq_midi
> snd_hwdep snd_rawmidi snd_pcm psmouse snd_seq_midi_event snd_seq
> serio_raw snd_seq_device snd_timer snd soundcore snd_page_alloc
> f71882fg r8169 ahci libahci
> [102792.710587] CPU 0 
> [102792.710590] Pid: 29771, comm: umount Tainted: P           O 3.6.0
> #1 System manufacturer System Product Name/F1A55-M LX PLUS
> [102792.710592] RIP: 0010:[<ffffffff8116c606>]  [<ffffffff8116c606>]
> shrink_dcache_for_umount_subtree+0x1e6/0x1f0
> [102792.710598] RSP: 0018:ffff880118f6dd98  EFLAGS: 00010296
> [102792.710600] RAX: 000000000000005d RBX: ffff88011092acc0 RCX:
> 00000000000013ae
> [102792.710601] RDX: 0000000000004663 RSI: 0000000000000046 RDI:
> ffffffff81bbf9bc
> [102792.710602] RBP: ffff880118f6ddb8 R08: 000000000000000a R09:
> 0000000000000000
> [102792.710604] R10: 000000000000039a R11: 0000000000000399 R12:
> ffff880110a5c900
> [102792.710605] R13: ffff880118fa9d00 R14: ffff880118fa9d30 R15:
> ffff8801180c9000
> [102792.710607] FS:  00007f9cc4c16800(0000) GS:ffff88011ec00000(0000)
> knlGS:0000000000000000
> [102792.710608] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [102792.710609] CR2: 00007f9cc4241120 CR3: 0000000117993000 CR4:
> 00000000000007f0
> [102792.710611] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [102792.710612] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [102792.710614] Process umount (pid: 29771, threadinfo
> ffff880118f6c000, task ffff88007b8edb00)
> [102792.710614] Stack:
> [102792.710616]  ffff8801180c9350 ffff880110a5c6c0 ffff8801180c9000
> ffffffffa0d0f3c0
> [102792.710618]  ffff880118f6ddd8 ffffffff8116de93 0000000000000001
> ffff8801180c9000
> [102792.710620]  ffff880118f6de08 ffffffff811583bc ffff880110a5c760
> 0000000000000014
> [102792.710622] Call Trace:
> [102792.710626]  [<ffffffff8116de93>] shrink_dcache_for_umount
> +0x33/0x60
> [102792.710629]  [<ffffffff811583bc>] generic_shutdown_super+0x2c/0xf0
> [102792.710632]  [<ffffffff81158516>] kill_anon_super+0x16/0x30
> [102792.710634]  [<ffffffff81158557>] kill_litter_super+0x27/0x30
> [102792.710650]  [<ffffffffa0d094a9>] rpc_kill_sb+0x99/0xc0 [sunrpc]
> [102792.710653]  [<ffffffff8115877c>] deactivate_locked_super
> +0x3c/0xa0
> [102792.710655]  [<ffffffff8115938e>] deactivate_super+0x4e/0x70
> [102792.710658]  [<ffffffff81174416>] mntput_no_expire+0x106/0x160
> [102792.710661]  [<ffffffff8117543e>] sys_umount+0x6e/0x3b0
> [102792.710664]  [<ffffffff81583d96>] system_call_fastpath+0x1a/0x1f
> [102792.710665] Code: 00 00 48 8b 40 28 4c 8b 08 48 8b 43 30 48 85 c0
> 74 04 48 8b 50 40 48 89 34 24 48 c7 c7 48 69 7c 81 48 89 de 31 c0 e8
> 09 62 40 00 <0f> 0b 0f 0b 66 0f 1f 44 00 00 55 48 89 e5 41 54 53 66 66
> 66 66 
> [102792.710686] RIP  [<ffffffff8116c606>]
> shrink_dcache_for_umount_subtree+0x1e6/0x1f0
> [102792.710689]  RSP <ffff880118f6dd98>
> [102792.710705] ---[ end trace 6cebf99f8c65907b ]---
> 
> Thank you,
> 
> Neil
> 
> 


