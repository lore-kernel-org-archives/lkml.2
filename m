Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0F0Ouu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 10:50:50 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35643 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0F0Ous (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 10:50:48 -0400
X-Authority-Analysis: v=1.1 cv=HJGB64tDiXfNBeA9z3R11jssoLv0dHjfv/jiYneYhOY= c=1 sm=0 a=Y7PYEMsxwwIA:10 a=ADBQPqJMlbwA:10 a=kj9zAlcOel0A:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=pGLkceISAAAA:8 a=D19gQVrFAAAA:8 a=hGzw-44bAAAA:8 a=x5Rw-nCv-94dA8QN2X8A:9 a=h04VH1iDLhtkj_7PGngA:7 a=1PioMtF5Sb9fdmSGilvJE-WxyaAA:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Sun, 27 Jun 2010 10:52:53 -0400
From: Jeff Layton <jlayton@samba.org>
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc3 oops trying to suspend.
Message-ID: <20100627105253.656d4d44@corrin.poochiereds.net>
In-Reply-To: <AANLkTinUH2p33-AWxOVDrLsNkn9rgEVrlwn5mfK7P8NH@mail.gmail.com>
References: <AANLkTinUH2p33-AWxOVDrLsNkn9rgEVrlwn5mfK7P8NH@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010 22:40:52 +1000
Andrew Hendry <andrew.hendry@gmail.com> wrote:

> Happened while trying to suspend system.
> Ubuntu 10.04 64 bit userspace, config attached.
> Can't easily reproduce, I hit this while unsuccessfully trying to
> reproduce another issue http://lkml.org/lkml/2010/6/26/28
> 
> [  116.451221] CIFS VFS: No response to cmd 113 mid 206
> [  126.606110] PM: Syncing filesystems ...
> [  126.698725] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000004
> [  126.698730] IP: [<ffffffff81520776>] rwsem_down_failed_common+0x66/0x200
> [  126.698737] PGD 230e17067 PUD 230e16067 PMD 0
> [  126.698740] Oops: 0002 [#1] PREEMPT SMP
> [  126.698743] last sysfs file: /sys/power/state
> [  126.698746] CPU 6
> [  126.698747] Modules linked in: nls_cp437 cifs fbcon tileblit font
> bitblit softcursor binfmt_misc kvm_intel kvm snd_hda_codec_via
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
> snd_pcm snd_seq_dummy nouveau snd_seq_oss snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse snd
> serio_raw ttm soundcore snd_page_alloc drm_kms_helper drm asus_atk0110
> i2c_algo_bit usbhid hid ahci pata_jmicron r8169 mii libahci
> [  126.698776]
> [  126.698778] Pid: 3196, comm: pm-suspend Not tainted 2.6.35-rc3 #6
> P7P55D-E PRO/System Product Name
> [  126.698780] RIP: 0010:[<ffffffff81520776>]  [<ffffffff81520776>]
> rwsem_down_failed_common+0x66/0x200
> [  126.698784] RSP: 0018:ffff8801f4f17ca0  EFLAGS: 00010006
> [  126.698786] RAX: 0000000000000004 RBX: ffff8801f4c50c68 RCX: ffff8801f4c50c78
> [  126.698788] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801f4c50c70
> [  126.698790] RBP: ffff8801f4f17d00 R08: ffff8801f4f16000 R09: 00000000ffffffff
> [  126.698792] R10: 00000000ffffffff R11: 0000000000000000 R12: ffff8801f4f17d10
> [  126.698793] R13: ffff880210c3ad00 R14: ffff8801f4c50c70 R15: fffffffeffffffff
> [  126.698796] FS:  00007f1da0641700(0000) GS:ffff880001ec0000(0000)
> knlGS:0000000000000000
> [  126.698798] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  126.698800] CR2: 0000000000000004 CR3: 00000001ef9dd000 CR4: 00000000000006e0
> [  126.698802] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  126.698803] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  126.698806] Process pm-suspend (pid: 3196, threadinfo
> ffff8801f4f16000, task ffff880210c3ad00)
> [  126.698807] Stack:
> [  126.698809]  ffffffff8115f2d3 ffff8801f4f17cd8 ffff880234e64000
> ffff880234e64068
> [  126.698812] <0> ffffffff811642e0 0000000000000000 ffffffff8116062f
> ffff8801f4c50c68
> [  126.698816] <0> ffff8801f4c50800 ffff8801f4c50c68 ffffffff811642e0
> ffff8801f4f17df4
> [  126.698821] Call Trace:
> [  126.698825]  [<ffffffff8115f2d3>] ? bdi_queue_work+0xa3/0xe0
> [  126.698828]  [<ffffffff811642e0>] ? sync_one_sb+0x0/0x30
> [  126.698831]  [<ffffffff8116062f>] ? bdi_sync_writeback+0x6f/0x80
> [  126.698833]  [<ffffffff811642e0>] ? sync_one_sb+0x0/0x30
> [  126.698835]  [<ffffffff81520966>] rwsem_down_read_failed+0x26/0x30
> [  126.698839]  [<ffffffff81286054>] call_rwsem_down_read_failed+0x14/0x30
> [  126.698842]  [<ffffffff8151fad7>] ? down_read+0x17/0x20
> [  126.698846]  [<ffffffff8113ee34>] iterate_supers+0x74/0xd0
> [  126.698848]  [<ffffffff81164355>] sys_sync+0x45/0x70
> [  126.698852]  [<ffffffff810984eb>] enter_state+0x6b/0x150
> [  126.698855]  [<ffffffff81097b09>] state_store+0x99/0x110
> [  126.698859]  [<ffffffff8127c7f7>] kobj_attr_store+0x17/0x20
> [  126.698863]  [<ffffffff811a33a5>] sysfs_write_file+0xe5/0x170
> [  126.698866]  [<ffffffff8113d218>] vfs_write+0xb8/0x180
> [  126.698870]  [<ffffffff815245fa>] ? do_page_fault+0x15a/0x3d0
> [  126.698872]  [<ffffffff8113d3c1>] sys_write+0x51/0x90
> [  126.698877]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> [  126.698879] Code: 48 8b 45 c8 4c 89 f7 e8 09 05 00 00 4d 89 6c 24
> 10 f0 41 ff 45 10 48 8b 43 18 48 8d 4b 10 4c 89 63 18 49 89 44 24 08
> 49 89 0c 24 <4c> 89 20 4c 89 f8 f0 48 0f c1 03 46 8d 3c 38 45 85 ff 74
> 56 4c
> [  126.698920] RIP  [<ffffffff81520776>] rwsem_down_failed_common+0x66/0x200
> [  126.698923]  RSP <ffff8801f4f17ca0>
> [  126.698925] CR2: 0000000000000004
> [  126.698927] ---[ end trace cede871d1b0cf586 ]---

Hmm...doesn't look directly related to CIFS at all this time. I think
there must be some sort of race with the suspend/resume code and
umounts. It looks like the s_umount rwsem was bad while walking the
list of sb's.

I don't see recent changes that stand out at me however...

-- 
Jeff Layton <jlayton@samba.org>
