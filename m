Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1I1Su2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:50:28 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:49260 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab1I1SuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:50:25 -0400
Subject: Re: Oops in ecryptfs (apparently) with 3.1-rc6
From: Luciano Coelho <coelho@ti.com>
To: ecryptfs@vger.kernel.org
Cc: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1316781869.4051.7.camel@cumari>
References: <1316781869.4051.7.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 21:50:15 +0300
Message-ID: <1317235816.2171.158.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 15:44 +0300, Luciano Coelho wrote: 
> I just got this oops on my PC, while running 3.1-rc6 normally:
> 
> [255264.517298] Oops: 0000 [#1] SMP 
> [255264.517301] CPU 4 
> [255264.517303] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat dm_crypt pl2303 ftdi_sio usbserial cryptd aes_x86_64 aes_generic binfmt_misc snd_hda_codec_analog nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi psmouse snd_rawmidi snd_seq_midi_event snd_seq snd_timer dell_wmi nfsd exportfs snd_seq_device serio_raw nfs sparse_keymap snd soundcore snd_page_alloc i7core_edac edac_core ppdev lp dcdbas lockd fscache auth_rpcgss nfs_acl sunrpc parport_pc parport usb_storage usbhid hid tg3
> [255264.517341] 
> [255264.517343] Pid: 18110, comm: cat Tainted: P            3.1.0-rc6-custom #2 Dell Inc. Precision WorkStation T3500  /09KPNV
> [255264.517348] RIP: 0010:[<ffffffff8125dddd>]  [<ffffffff8125dddd>] ecryptfs_decrypt_extent+0x13d/0x360
> [255264.517353] RSP: 0018:ffff88031c03db78  EFLAGS: 00010246
> [255264.517356] RAX: 0000000000000000 RBX: ffff88031c03db88 RCX: 0000000000000000
> [255264.517358] RDX: 0000000000000010 RSI: ffff880170bd1ae0 RDI: 0000000000000000
> [255264.517361] RBP: ffff88031c03dc38 R08: 0000000000000000 R09: ffff88031c03db88
> [255264.517363] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880170bd1a70
> [255264.517366] R13: 0000000000001000 R14: ffffea0008351cc0 R15: ffff880170bd1b60
> [255264.517369] FS:  00002b38b966bb20(0000) GS:ffff880333280000(0000) knlGS:0000000000000000
> [255264.517372] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [255264.517374] CR2: 0000000000000010 CR3: 000000010b9e6000 CR4: 00000000000006e0
> [255264.517377] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [255264.517379] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [255264.517382] Process cat (pid: 18110, threadinfo ffff88031c03c000, task ffff88005f920000)
> [255264.517385] Stack:
> [255264.517386]  0000000000000000 0000000000000000 ffffea0008351cc2 0000100000000000
> [255264.517391]  0000000000000000 0000000000000000 ffffea000964c302 0000100000000000
> [255264.517395]  0000000000000000 0000000000000000 0000000000000000 ffff88031c03dbe8
> [255264.517399] Call Trace:
> [255264.517406]  [<ffffffff81163f35>] ? vfs_read+0xc5/0x190
> [255264.517409]  [<ffffffff8125e0b2>] ecryptfs_decrypt_page+0xb2/0x190
> [255264.517413]  [<ffffffff8125bb08>] ecryptfs_readpage+0xd8/0x120
> [255264.517418]  [<ffffffff8110daf4>] generic_file_aio_read+0x234/0x740
> [255264.517424]  [<ffffffff8125863c>] ecryptfs_read_update_atime+0x1c/0x60
> [255264.517428]  [<ffffffff811637fa>] do_sync_read+0xda/0x120
> [255264.517434]  [<ffffffff81286a3b>] ? security_file_permission+0x8b/0x90
> [255264.517438]  [<ffffffff81163f35>] vfs_read+0xc5/0x190
> [255264.517441]  [<ffffffff81164101>] sys_read+0x51/0x90
> [255264.517446]  [<ffffffff815dc082>] system_call_fastpath+0x16/0x1b
> [255264.517448] Code: 98 41 0f af c5 89 85 58 ff ff ff 49 8b 44 24 40 48 89 45 90 e8 c5 4d 37 00 49 8b 44 24 40 49 8b 54 24 20 49 8d 74 24 70 48 89 c7 <ff> 50 10 85 c0 0f 85 40 01 00 00 31 c0 44 89 ea 48 c7 c6 50 cf 
> [255264.517481] RIP  [<ffffffff8125dddd>] ecryptfs_decrypt_extent+0x13d/0x360
> [255264.517485]  RSP <ffff88031c03db78>
> [255264.517487] CR2: 0000000000000010
> [255264.517490] ---[ end trace 6beaa9aa4bd67546 ]---

Did anyone else get a similar oops? Or does anyone have any clue what
this is about? I haven't seen any fix that could be related to this, so
I'm still really wary of using 3.1-rc*. ;)

-- 
Cheers,
Luca.

