Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1FGMQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:16:02 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62765 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1FGMQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=D7IassbHyx30qsRcv8/Q87P3wknXP5oWAhCy1PJDgzIGkDtMN3APys9x75O4QeTGGw
         66Aj1aB9uik+PTXUpDdgFdhJ7FI7QqMuJC/G86wxRIdN3tPms6e3vm+VSJp/dvdFjqKk
         R1cg2w/0+fES6K66JNfArXDo+j+Go9CCBoabE=
MIME-Version: 1.0
In-Reply-To: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Tue, 7 Jun 2011 14:36:15 +0800
Message-ID: <BANLkTi=y2V4ZUyP02p_r_scqdSbprjbLsQ@mail.gmail.com>
Subject: Re: bug in xfs: can't recovery metadata log
To: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/7 Drunkard Zhang <gongfan193@gmail.com>:
> The log recovery failure happened after a hard reboot, I did "mount
> /dev/lg/log /mnt/temp/" twice, but the similar dmesg error.
>
> The xfs lives on LVM, with 4x2TB SATA II disk.
>
> The first time:
> [ 1479.130446] XFS mounting filesystem dm-0
> [ 1479.226525] Starting XFS recovery on filesystem: dm-0 (logdev: internal)
> [ 1506.217842] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000000f8
> [ 1506.218468] IP: [<ffffffff81235f9c>] xfs_cmn_err+0x6b/0x92
> [ 1506.218680] PGD 2175c4067 PUD 22f4ff067 PMD 0
> [ 1506.218887] Oops: 0000 [#1] PREEMPT SMP
> [ 1506.219138] last sysfs file: /sys/devices/virtual/block/dm-0/dev
> [ 1506.219345] CPU 1
> [ 1506.219353] Modules linked in:
> [ 1506.219732]
> [ 1506.219923] Pid: 21233, comm: mount Not tainted 2.6.38.5 #2 System
> manufacturer Sÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ/Z8NA-D6(C)
> [ 1506.220989] RIP: 0010:[<ffffffff81235f9c>]  [<ffffffff81235f9c>]
> xfs_cmn_err+0x6b/0x92
> [ 1506.221424] RSP: 0018:ffff88021752da08  EFLAGS: 00010246
> [ 1506.221627] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff816be16c
> [ 1506.221837] RDX: ffff88021752da28 RSI: ffffffff816bdced RDI: 0000000000000008
> [ 1506.222079] RBP: ffff88021752da88 R08: ffffffff816bdb79 R09: 00000000000005f6
> [ 1506.222289] R10: ffff8802177c32c0 R11: 00000530e8002000 R12: 0000000000000000
> [ 1506.222572] R13: ffffffff816be16c R14: ffff88021752db04 R15: 00000000000008e2
> [ 1506.222830] FS:  00007fa0c93d2740(0000) GS:ffff8800bf440000(0000)
> knlGS:0000000000000000
> [ 1506.223265] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1506.223471] CR2: 00000000000000f8 CR3: 000000021754e000 CR4: 00000000000006e0
> [ 1506.223728] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1506.223938] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1506.224190] Process mount (pid: 21233, threadinfo ffff88021752c000,
> task ffff88022e239440)
> [ 1506.224585] Stack:
> [ 1506.224776]  0000000000000020 ffff88021752da98 ffff88021752da38
> ffff88021752da48
> [ 1506.225216]  ffffffff816be16c ffff88021752da08 2d0100008de51400
> ffffffff8122922b
> [ 1506.225616]  ffff880202000000 ffff8802176e8af0 ffffffff816bdb79
> 00000000000005f6
> [ 1506.226058] Call Trace:
> [ 1506.226301]  [<ffffffff8122922b>] ? kmem_zone_zalloc+0x1f/0x30
> [ 1506.226549]  [<ffffffff812098b5>] xfs_error_report+0x39/0x40
> [ 1506.226805]  [<ffffffff811e8340>] ? xfs_free_extent+0x8e/0xae
> [ 1506.227056]  [<ffffffff811e75cf>] xfs_free_ag_extent+0x3e7/0x70b
> [ 1506.227306]  [<ffffffff811e8340>] xfs_free_extent+0x8e/0xae
> [ 1506.227514]  [<ffffffff81219fa2>] xlog_recover_process_efi+0x113/0x16c
> [ 1506.227724]  [<ffffffff81223c6e>] ? xfs_trans_ail_cursor_set+0x15/0x1c
> [ 1506.227934]  [<ffffffff8121a0ef>] xlog_recover_process_efis+0x64/0xad
> [ 1506.228182]  [<ffffffff8121a6a7>] xlog_recover_finish+0x15/0xb6
> [ 1506.228390]  [<ffffffff8121784b>] xfs_log_mount_finish+0x1b/0x1d
> [ 1506.228597]  [<ffffffff81220d3f>] xfs_mountfs+0x4ec/0x615
> [ 1506.228803]  [<ffffffff8123439a>] xfs_fs_fill_super+0x1e5/0x2e8
> [ 1506.229055]  [<ffffffff810fc149>] mount_bdev+0x13b/0x19e
> [ 1506.229259]  [<ffffffff812341b5>] ? xfs_fs_fill_super+0x0/0x2e8
> [ 1506.229467]  [<ffffffff812328e9>] xfs_fs_mount+0x10/0x12
> [ 1506.229672]  [<ffffffff810fb860>] vfs_kern_mount+0xb8/0x1f3
> [ 1506.229877]  [<ffffffff810fb9f9>] do_kern_mount+0x48/0xd8
> [ 1506.230127]  [<ffffffff811137d6>] do_mount+0x729/0x791
> [ 1506.230375]  [<ffffffff810c2588>] ? memdup_user+0x43/0x63
> [ 1506.230629]  [<ffffffff810c25e1>] ? strndup_user+0x39/0x4f
> [ 1506.230834]  [<ffffffff811138c1>] sys_mount+0x83/0xbe
> [ 1506.231080]  [<ffffffff810028fb>] system_call_fastpath+0x16/0x1b
> [ 1506.231285] Code: 31 e4 48 8d 45 80 48 8d 55 10 48 89 45 a8 48 89
> 55 88 31 c0 48 8d 55 b0 c7 45 80 20 00 00 00 48 89 55 90 4c 89 6d a0
> 48 8d 55 a0 <48> 8b b3 f8 00 00 00 48 c7 c7 78 14 6c 81 e8 1f ff 2b 00
> 45 85
> [ 1506.232093] RIP  [<ffffffff81235f9c>] xfs_cmn_err+0x6b/0x92
> [ 1506.232300]  RSP <ffff88021752da08>
> [ 1506.232498] CR2: 00000000000000f8
> [ 1506.233086] ---[ end trace 6ff9d0214348600a ]---
>
> The second time:
> [  725.637712] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000000f8
> [  725.638302] IP: [<ffffffff81235f9c>] xfs_cmn_err+0x6b/0x92
> [  725.638579] PGD 22b1d3067 PUD 22b21f067 PMD 0
> [  725.638787] Oops: 0000 [#1] PREEMPT SMP
> [  725.638993] last sysfs file: /sys/devices/virtual/block/dm-0/dev
> [  725.639202] CPU 0
> [  725.639210] Modules linked in:
> [  725.639664]
> [  725.639857] Pid: 2537, comm: mount Not tainted 2.6.38.5 #2 System
> manufacturer Sÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ/Z8NA-D6(C)
> [  725.640841] RIP: 0010:[<ffffffff81235f9c>]  [<ffffffff81235f9c>]
> xfs_cmn_err+0x6b/0x92
> [  725.641241] RSP: 0018:ffff88022b28ba08  EFLAGS: 00010246
> [  725.641512] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff816be16c
> [  725.641723] RDX: ffff88022b28ba28 RSI: ffffffff816bdced RDI: 0000000000000008
> [  725.641936] RBP: ffff88022b28ba88 R08: ffffffff816bdb79 R09: 00000000000005f6
> [  725.642148] R10: ffff8802217c9680 R11: 00000530e8002000 R12: 0000000000000000
> [  725.642428] R13: ffffffff816be16c R14: ffff88022b28bb04 R15: 00000000000008e2
> [  725.642641] FS:  00007f857cd34740(0000) GS:ffff8800bf400000(0000)
> knlGS:0000000000000000
> [  725.643041] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  725.643248] CR2: 00000000000000f8 CR3: 000000022b24a000 CR4: 00000000000006f0
> [  725.643565] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  725.643778] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  725.643990] Process mount (pid: 2537, threadinfo ffff88022b28a000,
> task ffff88022e4f2f40)
> [  725.644478] Stack:
> [  725.644671]  0000000000000020 ffff88022b28ba98 ffff88022b28ba38
> ffff88022b28ba48
> [  725.645072]  ffffffff816be16c ffff88022b28ba08 2d0100008de51400
> ffffffff8122922b
> [  725.645607]  ffff880202000000 ffff88022b2d28c0 ffffffff816bdb79
> 00000000000005f6
> [  725.646010] Call Trace:
> [  725.646211]  [<ffffffff8122922b>] ? kmem_zone_zalloc+0x1f/0x30
> [  725.646491]  [<ffffffff812098b5>] xfs_error_report+0x39/0x40
> [  725.646700]  [<ffffffff811e8340>] ? xfs_free_extent+0x8e/0xae
> [  725.646909]  [<ffffffff811e75cf>] xfs_free_ag_extent+0x3e7/0x70b
> [  725.647119]  [<ffffffff811e8340>] xfs_free_extent+0x8e/0xae
> [  725.647329]  [<ffffffff81219fa2>] xlog_recover_process_efi+0x113/0x16c
> [  725.647632]  [<ffffffff81223c6e>] ? xfs_trans_ail_cursor_set+0x15/0x1c
> [  725.647844]  [<ffffffff8121a0ef>] xlog_recover_process_efis+0x64/0xad
> [  725.648056]  [<ffffffff8121a6a7>] xlog_recover_finish+0x15/0xb6
> [  725.648266]  [<ffffffff8121784b>] xfs_log_mount_finish+0x1b/0x1d
> [  725.648539]  [<ffffffff81220d3f>] xfs_mountfs+0x4ec/0x615
> [  725.648747]  [<ffffffff8123439a>] xfs_fs_fill_super+0x1e5/0x2e8
> [  725.648958]  [<ffffffff810fc149>] mount_bdev+0x13b/0x19e
> [  725.649164]  [<ffffffff812341b5>] ? xfs_fs_fill_super+0x0/0x2e8
> [  725.649438]  [<ffffffff812328e9>] xfs_fs_mount+0x10/0x12
> [  725.649646]  [<ffffffff810fb860>] vfs_kern_mount+0xb8/0x1f3
> [  725.649854]  [<ffffffff810fb9f9>] do_kern_mount+0x48/0xd8
> [  725.650063]  [<ffffffff811137d6>] do_mount+0x729/0x791
> [  725.650271]  [<ffffffff810c2588>] ? memdup_user+0x43/0x63
> [  725.650545]  [<ffffffff810c25e1>] ? strndup_user+0x39/0x4f
> [  725.650753]  [<ffffffff811138c1>] sys_mount+0x83/0xbe
> [  725.650961]  [<ffffffff810028fb>] system_call_fastpath+0x16/0x1b
> [  725.651169] Code: 31 e4 48 8d 45 80 48 8d 55 10 48 89 45 a8 48 89
> 55 88 31 c0 48 8d 55 b0 c7 45 80 20 00 00 00 48 89 55 90 4c 89 6d a0
> 48 8d 55 a0 <48> 8b b3 f8 00 00 00 48 c7 c7 78 14 6c 81 e8 1f ff 2b 00
> 45 85
> [  725.652012] RIP  [<ffffffff81235f9c>] xfs_cmn_err+0x6b/0x92
> [  725.652221]  RSP <ffff88022b28ba08>
> [  725.652484] CR2: 00000000000000f8
> [  725.653295] ---[ end trace 1dadc2ff14d7c60f ]---
>

With 2.6.39.1 too, output not the same thing. Here's console output:
log1 ~ # mount /dev/lg/log /mnt/temp/ &
[1] 3911
log1 ~ # mount: Structure needs cleaning
[1]+  Exit 32                 mount /dev/lg/log /mnt/temp/

Here's related dmesg:
[  123.634533] XFS (dm-0): Mounting Filesystem
[  123.640180] XFS (dm-0): Starting recovery (logdev: internal)
[  138.583463] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line
1540 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff811eca7b
[  138.583465]
[  138.583470] Pid: 3911, comm: mount Not tainted 2.6.39.1 #1
[  138.583472] Call Trace:
[  138.583484]  [<ffffffff8120dfe8>] xfs_error_report+0x38/0x3a
[  138.583489]  [<ffffffff811eca7b>] ? xfs_free_extent+0xb8/0xdd
[  138.583493]  [<ffffffff811e999c>] ? xfs_alloc_lookup_eq+0x14/0x16
[  138.583497]  [<ffffffff811ebd2d>] xfs_free_ag_extent+0x3dc/0x6b3
[  138.583501]  [<ffffffff811eca7b>] xfs_free_extent+0xb8/0xdd
[  138.583506]  [<ffffffff8121e689>] xlog_recover_process_efi+0x113/0x16c
[  138.583511]  [<ffffffff8121e7d6>] xlog_recover_process_efis+0x64/0xad
[  138.583516]  [<ffffffff8121edb5>] xlog_recover_finish+0x15/0x8c
[  138.583520]  [<ffffffff8121bf6f>] xfs_log_mount_finish+0x1b/0x1d
[  138.583525]  [<ffffffff81225330>] xfs_mountfs+0x487/0x5ab
[  138.583531]  [<ffffffff812386f3>] xfs_fs_fill_super+0x1b3/0x2b6
[  138.583536]  [<ffffffff810fd37e>] mount_bdev+0x138/0x19b
[  138.583540]  [<ffffffff81238540>] ? xfs_mountfs_check_barriers+0x63/0x63
[  138.583546]  [<ffffffff811127e1>] ? alloc_vfsmnt+0xa6/0x18c
[  138.583550]  [<ffffffff81236d5d>] xfs_fs_mount+0x10/0x12
[  138.583553]  [<ffffffff810fcc3f>] mount_fs+0x6b/0x14f
[  138.583558]  [<ffffffff810c7800>] ? __alloc_percpu+0xb/0xd
[  138.583563]  [<ffffffff81112fe5>] vfs_kern_mount+0x60/0x98
[  138.583567]  [<ffffffff81113800>] do_kern_mount+0x48/0xd8
[  138.583571]  [<ffffffff81114de3>] do_mount+0x6e1/0x744
[  138.583575]  [<ffffffff810c3498>] ? memdup_user+0x43/0x63
[  138.583578]  [<ffffffff810c34f1>] ? strndup_user+0x39/0x4f
[  138.583582]  [<ffffffff81114ec9>] sys_mount+0x83/0xbd
[  138.583589]  [<ffffffff814e8d7b>] system_call_fastpath+0x16/0x1b
[  138.583669] XFS (dm-0): Failed to recover EFIs
[  138.583672] XFS (dm-0): log mount finish failed
