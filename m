Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1A3AIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 19:08:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61535 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1A3AIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 19:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=UOUD+YQ3AUZAGoKZfezySwIBZNLn7D+fg9HnDyPfoqMs1XDhmzJb5+xYuHggtnxxVN
         DTzQQCFGqGz0WC9RAr/V8xv4kG5hY23bkOGQhVqecxmCsuehXAsEmxOF/aqgZrGq31Im
         bDOm3qf3ojaT5F3kKEarQWsmZM/0zPB72D+LA=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Reiserfs deadlock in 2.6.36
Date: Sun, 30 Jan 2011 01:08:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201011181650.00152.roucaries.bastien@gmail.com> <AANLkTik=+smaiGNwVw0pDBXexVd=trsz9aSawuqLZP6k@mail.gmail.com> <20101223034229.GF1739@nowhere>
In-Reply-To: <20101223034229.GF1739@nowhere>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AwKRNeHZ6CDpxnG"
Message-Id: <201101300108.32383.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_AwKRNeHZ6CDpxnG
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Le jeudi 23 d=E9cembre 2010 04:42:33, Frederic Weisbecker a =E9crit :
Hi,

I take me more than two days of testing to reporduce this bugs with trace e=
nabled. My filesystem was quite slow and this bugs seems=20
to be timing related.

One patern that trigger this bug is git. Doing a lot of git work of my desk=
top crash my machine.

Moreover, trying to reproduce this bug lead to data loss. I have rebuilded =
twice my / partition using --rebuild-tree, and restored=20
my home partition three times using backups.

My log is here.

Do you need more information?

Bastien

--Boundary-00=_AwKRNeHZ6CDpxnG
Content-Type: text/plain;
  charset="iso-8859-1";
  name="log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log"

Jan 29 23:47:26 portablebastien kernel: [19440.852298] INFO: task flush-8:0:1097 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.853685] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.855051] flush-8:0     D 0000000100488839     0  1097      2 0x00000000
Jan 29 23:47:26 portablebastien kernel: [19440.855057]  ffff88011e3759c0 0000000000000046 ffff88011c74bf80 0000000000000000
Jan 29 23:47:26 portablebastien kernel: [19440.855062]  ffff88011e374010 ffff88011e375fd8 ffff88011c74bf80 ffff88011c74c250
Jan 29 23:47:26 portablebastien kernel: [19440.855068]  ffff88011c74c248 0000000000014d80 0000000000014d80 ffff88011e375fd8
Jan 29 23:47:26 portablebastien kernel: [19440.855073] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.855082]  [<ffffffff810c3b55>] ? sync_page+0x0/0x4b
Jan 29 23:47:26 portablebastien kernel: [19440.855087]  [<ffffffff8134a9bc>] io_schedule+0x6e/0xb0
Jan 29 23:47:26 portablebastien kernel: [19440.855090]  [<ffffffff810c3b9c>] sync_page+0x47/0x4b
Jan 29 23:47:26 portablebastien kernel: [19440.855094]  [<ffffffff8134ae3e>] __wait_on_bit_lock+0x41/0x8a
Jan 29 23:47:26 portablebastien kernel: [19440.855098]  [<ffffffff810c3b41>] __lock_page+0x61/0x68
Jan 29 23:47:26 portablebastien kernel: [19440.855103]  [<ffffffff8106477b>] ? wake_bit_function+0x0/0x2e
Jan 29 23:47:26 portablebastien kernel: [19440.855108]  [<ffffffff810cbb8e>] write_cache_pages+0x1bf/0x3a4
Jan 29 23:47:26 portablebastien kernel: [19440.855111]  [<ffffffff810ca840>] ? __writepage+0x0/0x34
Jan 29 23:47:26 portablebastien kernel: [19440.855115]  [<ffffffff810cbd95>] generic_writepages+0x22/0x24
Jan 29 23:47:26 portablebastien kernel: [19440.855119]  [<ffffffff810cbdbd>] do_writepages+0x26/0x28
Jan 29 23:47:26 portablebastien kernel: [19440.855123]  [<ffffffff81120ffc>] writeback_single_inode+0xa7/0x214
Jan 29 23:47:26 portablebastien kernel: [19440.855127]  [<ffffffff8112153a>] writeback_sb_inodes+0xba/0x143
Jan 29 23:47:26 portablebastien kernel: [19440.855131]  [<ffffffff81121cdd>] writeback_inodes_wb+0x126/0x138
Jan 29 23:47:26 portablebastien kernel: [19440.855135]  [<ffffffff81121ee6>] wb_writeback+0x1f7/0x32e
Jan 29 23:47:26 portablebastien kernel: [19440.855140]  [<ffffffff8104f4e9>] ? _local_bh_enable_ip+0xc7/0xd2
Jan 29 23:47:26 portablebastien kernel: [19440.855144]  [<ffffffff8112218e>] wb_do_writeback+0x171/0x18f
Jan 29 23:47:26 portablebastien kernel: [19440.855148]  [<ffffffff810565df>] ? process_timeout+0x0/0xb
Jan 29 23:47:26 portablebastien kernel: [19440.855152]  [<ffffffff81122276>] bdi_writeback_thread+0xca/0x20c
Jan 29 23:47:26 portablebastien kernel: [19440.855156]  [<ffffffff811221ac>] ? bdi_writeback_thread+0x0/0x20c
Jan 29 23:47:26 portablebastien kernel: [19440.855160]  [<ffffffff810642ae>] kthread+0x8c/0x94
Jan 29 23:47:26 portablebastien kernel: [19440.855164]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Jan 29 23:47:26 portablebastien kernel: [19440.855169]  [<ffffffff8134cf10>] ? restore_args+0x0/0x30
Jan 29 23:47:26 portablebastien kernel: [19440.855173]  [<ffffffff81064222>] ? kthread+0x0/0x94
Jan 29 23:47:26 portablebastien kernel: [19440.855176]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Jan 29 23:47:26 portablebastien kernel: [19440.855179] 1 lock held by flush-8:0/1097:
Jan 29 23:47:26 portablebastien kernel: [19440.855181]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81121c7d>] writeback_inodes_wb+0xc6/0x138
Jan 29 23:47:26 portablebastien kernel: [19440.855217] INFO: task kglobalaccel:3305 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.856602] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.857990] kglobalaccel  D 0000000100488ba0     0  3305      1 0x00000000
Jan 29 23:47:26 portablebastien kernel: [19440.857995]  ffff8800d5fa7cc8 0000000000000046 fffffff500000001 0000000000000000
Jan 29 23:47:26 portablebastien kernel: [19440.858000]  ffff8800d5fa6010 ffff8800d5fa7fd8 ffff880116cb5f40 ffff880116cb6210
Jan 29 23:47:26 portablebastien kernel: [19440.858005]  ffff880116cb6208 0000000000014d80 0000000000014d80 ffff8800d5fa7fd8
Jan 29 23:47:26 portablebastien kernel: [19440.858010] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.858016]  [<ffffffff810c455c>] ? generic_file_aio_write+0x47/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.858020]  [<ffffffff8134b4ba>] __mutex_lock_common+0x23a/0x36f
Jan 29 23:47:26 portablebastien kernel: [19440.858024]  [<ffffffff810c455c>] ? generic_file_aio_write+0x47/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.858028]  [<ffffffff8134b6a4>] mutex_lock_nested+0x39/0x3e
Jan 29 23:47:26 portablebastien kernel: [19440.858032]  [<ffffffff810c455c>] generic_file_aio_write+0x47/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.858036]  [<ffffffff81103666>] do_sync_write+0xc6/0x103
Jan 29 23:47:26 portablebastien kernel: [19440.858040]  [<ffffffff81103769>] ? do_sync_read+0xc6/0x103
Jan 29 23:47:26 portablebastien kernel: [19440.858045]  [<ffffffff81172fef>] ? security_file_permission+0x29/0x2e
Jan 29 23:47:26 portablebastien kernel: [19440.858071]  [<ffffffffa018ffb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.858075]  [<ffffffff81103bcb>] vfs_write+0xa9/0x105
Jan 29 23:47:26 portablebastien kernel: [19440.858079]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Jan 29 23:47:26 portablebastien kernel: [19440.858083]  [<ffffffff81103cdd>] sys_write+0x45/0x69
Jan 29 23:47:26 portablebastien kernel: [19440.858088]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.858091] 1 lock held by kglobalaccel/3305:
Jan 29 23:47:26 portablebastien kernel: [19440.858092]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c455c>] generic_file_aio_write+0x47/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.858108] INFO: task akregator:3370 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.859487] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.860909] akregator     D ffffc90005a36178     0  3370      1 0x00000000
Jan 29 23:47:26 portablebastien kernel: [19440.860914]  ffff8800c73d3ae8 0000000000000046 0000000000000006 0000000000000001
Jan 29 23:47:26 portablebastien kernel: [19440.860919]  ffff8800c73d2010 ffff8800c73d3fd8 ffff8800c73d8000 ffff8800c73d82d0
Jan 29 23:47:26 portablebastien kernel: [19440.860924]  ffff8800c73d82c8 0000000000014d80 0000000000014d80 ffff8800c73d3fd8
Jan 29 23:47:26 portablebastien kernel: [19440.860929] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.860942]  [<ffffffffa01a4454>] queue_log_writer+0x7e/0xaf [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.860946]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.860958]  [<ffffffffa01a8450>] do_journal_begin_r+0x217/0x35d [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.860969]  [<ffffffffa01a8658>] journal_begin+0xc2/0x103 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.860980]  [<ffffffffa01964f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.860984]  [<ffffffff81121a14>] __mark_inode_dirty+0x2f/0x1d2
Jan 29 23:47:26 portablebastien kernel: [19440.860988]  [<ffffffff81116b88>] touch_atime+0x102/0x125
Jan 29 23:47:26 portablebastien kernel: [19440.860992]  [<ffffffff810c533d>] generic_file_aio_read+0x562/0x5b7
Jan 29 23:47:26 portablebastien kernel: [19440.860996]  [<ffffffff81103769>] do_sync_read+0xc6/0x103
Jan 29 23:47:26 portablebastien kernel: [19440.861000]  [<ffffffff8110404e>] ? generic_file_llseek+0x2a/0x5b
Jan 29 23:47:26 portablebastien kernel: [19440.861004]  [<ffffffff81172f92>] ? fsnotify_perm+0x45/0x4b
Jan 29 23:47:26 portablebastien kernel: [19440.861008]  [<ffffffff81172fef>] ? security_file_permission+0x29/0x2e
Jan 29 23:47:26 portablebastien kernel: [19440.861012]  [<ffffffff81103da7>] vfs_read+0xa6/0x102
Jan 29 23:47:26 portablebastien kernel: [19440.861015]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Jan 29 23:47:26 portablebastien kernel: [19440.861019]  [<ffffffff81103eb9>] sys_read+0x45/0x69
Jan 29 23:47:26 portablebastien kernel: [19440.861023]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.861026] no locks held by akregator/3370.
Jan 29 23:47:26 portablebastien kernel: [19440.861029] INFO: task kalarm:3371 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.862444] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.863860] kalarm        D 0000000100487819     0  3371      1 0x00000000
Jan 29 23:47:26 portablebastien kernel: [19440.863865]  ffff8800c3477a98 0000000000000046 ffff8800c3477a18 ffffffff00000001
Jan 29 23:47:26 portablebastien kernel: [19440.863870]  ffff8800c3476010 ffff8800c3477fd8 ffff8800c73d8fe0 ffff8800c73d92b0
Jan 29 23:47:26 portablebastien kernel: [19440.863875]  ffff8800c73d92a8 0000000000014d80 0000000000014d80 ffff8800c3477fd8
Jan 29 23:47:26 portablebastien kernel: [19440.863880] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.863892]  [<ffffffffa01a4454>] queue_log_writer+0x7e/0xaf [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.863897]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.863908]  [<ffffffffa01a8450>] do_journal_begin_r+0x217/0x35d [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.863919]  [<ffffffffa01a8658>] journal_begin+0xc2/0x103 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.863929]  [<ffffffffa01964f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.863941]  [<ffffffffa01ad4a0>] ? security_get+0x41/0x43 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.863945]  [<ffffffff81121a14>] __mark_inode_dirty+0x2f/0x1d2
Jan 29 23:47:26 portablebastien kernel: [19440.863949]  [<ffffffff81116a62>] file_update_time+0x104/0x128
Jan 29 23:47:26 portablebastien kernel: [19440.863996]  [<ffffffff8134b5ca>] ? __mutex_lock_common+0x34a/0x36f
Jan 29 23:47:26 portablebastien kernel: [19440.864017]  [<ffffffff810c43f8>] __generic_file_aio_write+0x162/0x27f
Jan 29 23:47:26 portablebastien kernel: [19440.864022]  [<ffffffff810c456f>] generic_file_aio_write+0x5a/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.864026]  [<ffffffff81103666>] do_sync_write+0xc6/0x103
Jan 29 23:47:26 portablebastien kernel: [19440.864030]  [<ffffffff81104885>] ? fget_light+0x41/0xcf
Jan 29 23:47:26 portablebastien kernel: [19440.864034]  [<ffffffff81172fef>] ? security_file_permission+0x29/0x2e
Jan 29 23:47:26 portablebastien kernel: [19440.864044]  [<ffffffffa018ffb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.864048]  [<ffffffff81103bcb>] vfs_write+0xa9/0x105
Jan 29 23:47:26 portablebastien kernel: [19440.864052]  [<ffffffff81104885>] ? fget_light+0x41/0xcf
Jan 29 23:47:26 portablebastien kernel: [19440.864056]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Jan 29 23:47:26 portablebastien kernel: [19440.864060]  [<ffffffff81103cdd>] sys_write+0x45/0x69
Jan 29 23:47:26 portablebastien kernel: [19440.864064]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.864067] 1 lock held by kalarm/3371:
Jan 29 23:47:26 portablebastien kernel: [19440.864068]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c455c>] generic_file_aio_write+0x47/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.864090] INFO: task pidgin:3984 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.865546] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.867014] pidgin        D ffffc90005a36178     0  3984   3320 0x00000000
Jan 29 23:47:26 portablebastien kernel: [19440.867019]  ffff8800c736ba98 0000000000000046 ffff8800c736ba18 ffffffff81074d94
Jan 29 23:47:26 portablebastien kernel: [19440.867024]  ffff8800c736a010 ffff8800c736bfd8 ffff880080980fe0 ffff8800809812b0
Jan 29 23:47:26 portablebastien kernel: [19440.867029]  ffff8800809812a8 0000000000014d80 0000000000014d80 ffff8800c736bfd8
Jan 29 23:47:26 portablebastien kernel: [19440.867034] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.867038]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Jan 29 23:47:26 portablebastien kernel: [19440.867051]  [<ffffffffa01a4454>] queue_log_writer+0x7e/0xaf [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.867055]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.867066]  [<ffffffffa01a8450>] do_journal_begin_r+0x217/0x35d [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.867078]  [<ffffffffa01a8658>] journal_begin+0xc2/0x103 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.867088]  [<ffffffffa01964f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.867099]  [<ffffffffa01ad4a0>] ? security_get+0x41/0x43 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.867103]  [<ffffffff81121a14>] __mark_inode_dirty+0x2f/0x1d2
Jan 29 23:47:26 portablebastien kernel: [19440.867107]  [<ffffffff81116a62>] file_update_time+0x104/0x128
Jan 29 23:47:26 portablebastien kernel: [19440.867111]  [<ffffffff8134b5ca>] ? __mutex_lock_common+0x34a/0x36f
Jan 29 23:47:26 portablebastien kernel: [19440.867115]  [<ffffffff810c43f8>] __generic_file_aio_write+0x162/0x27f
Jan 29 23:47:26 portablebastien kernel: [19440.867120]  [<ffffffff810c456f>] generic_file_aio_write+0x5a/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.867124]  [<ffffffff81103666>] do_sync_write+0xc6/0x103
Jan 29 23:47:26 portablebastien kernel: [19440.867127]  [<ffffffff811042d6>] ? do_readv_writev+0x10b/0x124
Jan 29 23:47:26 portablebastien kernel: [19440.867132]  [<ffffffff81172fef>] ? security_file_permission+0x29/0x2e
Jan 29 23:47:26 portablebastien kernel: [19440.867141]  [<ffffffffa018ffb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.867145]  [<ffffffff81103bcb>] vfs_write+0xa9/0x105
Jan 29 23:47:26 portablebastien kernel: [19440.867149]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Jan 29 23:47:26 portablebastien kernel: [19440.867153]  [<ffffffff81103cdd>] sys_write+0x45/0x69
Jan 29 23:47:26 portablebastien kernel: [19440.867157]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.867160] 1 lock held by pidgin/3984:
Jan 29 23:47:26 portablebastien kernel: [19440.867162]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c455c>] generic_file_aio_write+0x47/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.867183] INFO: task mc:9902 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.868680] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.870184] mc            D ffffc90005a36178     0  9902   9898 0x00000004
Jan 29 23:47:26 portablebastien kernel: [19440.870189]  ffff88006bab1cb8 0000000000000046 ffff88006bab1c38 ffffffff81074d94
Jan 29 23:47:26 portablebastien kernel: [19440.870194]  ffff88006bab0010 ffff88006bab1fd8 ffff880083dd0fe0 ffff880083dd12b0
Jan 29 23:47:26 portablebastien kernel: [19440.870199]  ffff880083dd12a8 0000000000014d80 0000000000014d80 ffff88006bab1fd8
Jan 29 23:47:26 portablebastien kernel: [19440.870204] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.870209]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Jan 29 23:47:26 portablebastien kernel: [19440.870221]  [<ffffffffa01a4454>] queue_log_writer+0x7e/0xaf [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.870226]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.870237]  [<ffffffffa01a8450>] do_journal_begin_r+0x217/0x35d [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.870248]  [<ffffffffa01a8658>] journal_begin+0xc2/0x103 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.870258]  [<ffffffffa01964f6>] reiserfs_dirty_inode+0x5f/0xa0 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.870262]  [<ffffffff8134b5de>] ? __mutex_lock_common+0x35e/0x36f
Jan 29 23:47:26 portablebastien kernel: [19440.870266]  [<ffffffff81121a14>] __mark_inode_dirty+0x2f/0x1d2
Jan 29 23:47:26 portablebastien kernel: [19440.870270]  [<ffffffff81116b88>] touch_atime+0x102/0x125
Jan 29 23:47:26 portablebastien kernel: [19440.870274]  [<ffffffff811118e8>] ? filldir+0x0/0xcb
Jan 29 23:47:26 portablebastien kernel: [19440.870278]  [<ffffffff81111af2>] vfs_readdir+0x8a/0xb1
Jan 29 23:47:26 portablebastien kernel: [19440.870282]  [<ffffffff81111c58>] sys_getdents+0x7c/0xcc
Jan 29 23:47:26 portablebastien kernel: [19440.870286]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.870289] 1 lock held by mc/9902:
Jan 29 23:47:26 portablebastien kernel: [19440.870291]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff81111ab9>] vfs_readdir+0x51/0xb1
Jan 29 23:47:26 portablebastien kernel: [19440.870305] INFO: task git:17243 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.871821] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.873388] git           D 000000010048594c     0 17243  17240 0x00000004
Jan 29 23:47:26 portablebastien kernel: [19440.873393]  ffff880050069a38 0000000000000046 ffff8800500699b8 ffffffff00000001
Jan 29 23:47:26 portablebastien kernel: [19440.873399]  ffff880050068010 ffff880050069fd8 ffff88011d8c1fc0 ffff88011d8c2290
Jan 29 23:47:26 portablebastien kernel: [19440.873404]  ffff88011d8c2288 0000000000014d80 0000000000014d80 ffff880050069fd8
Jan 29 23:47:26 portablebastien kernel: [19440.873409] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.873421]  [<ffffffffa01a4454>] queue_log_writer+0x7e/0xaf [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.873425]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.873437]  [<ffffffffa01a8450>] do_journal_begin_r+0x217/0x35d [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.873448]  [<ffffffffa01a8658>] journal_begin+0xc2/0x103 [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.873457]  [<ffffffffa018de0a>] reiserfs_write_end+0x141/0x29a [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.873467]  [<ffffffffa018dc29>] ? reiserfs_write_begin+0xec/0x18c [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.873472]  [<ffffffff810c2d2f>] ? iov_iter_copy_from_user_atomic+0x7c/0xec
Jan 29 23:47:26 portablebastien kernel: [19440.873476]  [<ffffffff810c309c>] generic_file_buffered_write+0x168/0x262
Jan 29 23:47:26 portablebastien kernel: [19440.873480]  [<ffffffff8104deed>] ? current_fs_time+0x22/0x29
Jan 29 23:47:26 portablebastien kernel: [19440.873485]  [<ffffffff810c44e0>] __generic_file_aio_write+0x24a/0x27f
Jan 29 23:47:26 portablebastien kernel: [19440.873490]  [<ffffffff810c456f>] generic_file_aio_write+0x5a/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.873494]  [<ffffffff81103666>] do_sync_write+0xc6/0x103
Jan 29 23:47:26 portablebastien kernel: [19440.873498]  [<ffffffff810a1d98>] ? __call_rcu+0x136/0x149
Jan 29 23:47:26 portablebastien kernel: [19440.873502]  [<ffffffff81172fef>] ? security_file_permission+0x29/0x2e
Jan 29 23:47:26 portablebastien kernel: [19440.873512]  [<ffffffffa018ffb2>] reiserfs_file_write+0x48/0x4a [reiserfs]
Jan 29 23:47:26 portablebastien kernel: [19440.873516]  [<ffffffff81103bcb>] vfs_write+0xa9/0x105
Jan 29 23:47:26 portablebastien kernel: [19440.873520]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Jan 29 23:47:26 portablebastien kernel: [19440.873523]  [<ffffffff81103cdd>] sys_write+0x45/0x69
Jan 29 23:47:26 portablebastien kernel: [19440.873527]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.873531] 1 lock held by git/17243:
Jan 29 23:47:26 portablebastien kernel: [19440.873532]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810c455c>] generic_file_aio_write+0x47/0xa8
Jan 29 23:47:26 portablebastien kernel: [19440.873541] INFO: task sync:17255 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.875082] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.876665] sync          D ffff8800722ede70     0 17255   3021 0x00000000
Jan 29 23:47:26 portablebastien kernel: [19440.876669]  ffff8800722edca8 0000000000000046 ffff880000000000 ffff880000000000
Jan 29 23:47:26 portablebastien kernel: [19440.876675]  ffff8800722ec010 ffff8800722edfd8 ffff880095cccf60 ffff880095ccd230
Jan 29 23:47:26 portablebastien kernel: [19440.876680]  ffff880095ccd228 0000000000014d80 0000000000014d80 ffff8800722edfd8
Jan 29 23:47:26 portablebastien kernel: [19440.876685] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.876689]  [<ffffffff8134acf2>] schedule_timeout+0x31/0xeb
Jan 29 23:47:26 portablebastien kernel: [19440.876693]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Jan 29 23:47:26 portablebastien kernel: [19440.876698]  [<ffffffff8134ca99>] ? _raw_spin_unlock_irq+0x2b/0x36
Jan 29 23:47:26 portablebastien kernel: [19440.876702]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Jan 29 23:47:26 portablebastien kernel: [19440.876705]  [<ffffffff81075045>] ? trace_hardirqs_on+0xd/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.876709]  [<ffffffff8134ab55>] wait_for_common+0xdb/0x155
Jan 29 23:47:26 portablebastien kernel: [19440.876713]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.876717]  [<ffffffff8134ca6a>] ? _raw_spin_unlock_bh+0x2f/0x33
Jan 29 23:47:26 portablebastien kernel: [19440.876721]  [<ffffffff8112553f>] ? sync_one_sb+0x0/0x1d
Jan 29 23:47:26 portablebastien kernel: [19440.876725]  [<ffffffff8134ac69>] wait_for_completion+0x18/0x1a
Jan 29 23:47:26 portablebastien kernel: [19440.876728]  [<ffffffff8112145c>] writeback_inodes_sb+0xea/0x10e
Jan 29 23:47:26 portablebastien kernel: [19440.876732]  [<ffffffff8134b11b>] ? mutex_unlock+0x9/0xb
Jan 29 23:47:26 portablebastien kernel: [19440.876736]  [<ffffffff81125512>] __sync_filesystem+0x51/0x7e
Jan 29 23:47:26 portablebastien kernel: [19440.876740]  [<ffffffff8112555a>] sync_one_sb+0x1b/0x1d
Jan 29 23:47:26 portablebastien kernel: [19440.876743]  [<ffffffff811059bd>] iterate_supers+0x6d/0xc8
Jan 29 23:47:26 portablebastien kernel: [19440.876747]  [<ffffffff81125586>] sys_sync+0x2a/0x57
Jan 29 23:47:26 portablebastien kernel: [19440.876751]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.876754] 1 lock held by sync/17255:
Jan 29 23:47:26 portablebastien kernel: [19440.876756]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff811059ad>] iterate_supers+0x5d/0xc8
Jan 29 23:47:26 portablebastien kernel: [19440.876764] INFO: task dpkg:17327 blocked for more than 120 seconds.
Jan 29 23:47:26 portablebastien kernel: [19440.878337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:47:26 portablebastien kernel: [19440.879920] dpkg          D 0000000100488831     0 17327  17227 0x00000000
Jan 29 23:47:26 portablebastien kernel: [19440.879924]  ffff880076ef7ca8 0000000000000046 ffff880000000000 ffff880000000000
Jan 29 23:47:26 portablebastien kernel: [19440.879930]  ffff880076ef6010 ffff880076ef7fd8 ffff880060e23f80 ffff880060e24250
Jan 29 23:47:26 portablebastien kernel: [19440.879935]  ffff880060e24248 0000000000014d80 0000000000014d80 ffff880076ef7fd8
Jan 29 23:47:26 portablebastien kernel: [19440.879940] Call Trace:
Jan 29 23:47:26 portablebastien kernel: [19440.879944]  [<ffffffff8134acf2>] schedule_timeout+0x31/0xeb
Jan 29 23:47:26 portablebastien kernel: [19440.879948]  [<ffffffff81074d94>] ? mark_held_locks+0x52/0x70
Jan 29 23:47:26 portablebastien kernel: [19440.879951]  [<ffffffff8134ca99>] ? _raw_spin_unlock_irq+0x2b/0x36
Jan 29 23:47:26 portablebastien kernel: [19440.879955]  [<ffffffff81075014>] ? trace_hardirqs_on_caller+0x111/0x135
Jan 29 23:47:26 portablebastien kernel: [19440.879959]  [<ffffffff81075045>] ? trace_hardirqs_on+0xd/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.879963]  [<ffffffff8134ab55>] wait_for_common+0xdb/0x155
Jan 29 23:47:26 portablebastien kernel: [19440.879967]  [<ffffffff81044430>] ? default_wake_function+0x0/0xf
Jan 29 23:47:26 portablebastien kernel: [19440.879971]  [<ffffffff8134ca6a>] ? _raw_spin_unlock_bh+0x2f/0x33
Jan 29 23:47:26 portablebastien kernel: [19440.879975]  [<ffffffff8112553f>] ? sync_one_sb+0x0/0x1d
Jan 29 23:47:26 portablebastien kernel: [19440.879978]  [<ffffffff8134ac69>] wait_for_completion+0x18/0x1a
Jan 29 23:47:26 portablebastien kernel: [19440.879982]  [<ffffffff8112145c>] writeback_inodes_sb+0xea/0x10e
Jan 29 23:47:26 portablebastien kernel: [19440.879986]  [<ffffffff8134b11b>] ? mutex_unlock+0x9/0xb
Jan 29 23:47:26 portablebastien kernel: [19440.879990]  [<ffffffff81125512>] __sync_filesystem+0x51/0x7e
Jan 29 23:47:26 portablebastien kernel: [19440.879993]  [<ffffffff8112555a>] sync_one_sb+0x1b/0x1d
Jan 29 23:47:26 portablebastien kernel: [19440.880013]  [<ffffffff811059bd>] iterate_supers+0x6d/0xc8
Jan 29 23:47:26 portablebastien kernel: [19440.880017]  [<ffffffff81125586>] sys_sync+0x2a/0x57
Jan 29 23:47:26 portablebastien kernel: [19440.880021]  [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b
Jan 29 23:47:26 portablebastien kernel: [19440.880024] 1 lock held by dpkg/17327:
Jan 29 23:47:26 portablebastien kernel: [19440.880026]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff811059ad>] iterate_supers+0x5d/0xc8
Jan 29 23:47:52 portablebastien kernel: [19467.764460] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Jan 29 23:47:57 portablebastien kernel: [19472.035699] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Jan 29 23:48:00 portablebastien kernel: [19475.684160] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
Jan 29 23:48:04 portablebastien kernel: [19479.286998] SysRq : Dump ftrace buffer
Jan 29 23:48:04 portablebastien kernel: [19479.288403] Dumping ftrace buffer:
Jan 29 23:48:04 portablebastien kernel: [19479.289902] ---------------------------------
Jan 29 23:48:04 portablebastien kernel: [19479.290087] CPU:1 [LOST 7965388 EVENTS]
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544905us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544918us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544918us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544925us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544926us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544986us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544986us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544996us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.290087]    <...>-2949    1..... 11523544996us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.290087]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545008us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545008us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545042us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545043us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_rename
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_rename
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_renameat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_rename
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545109us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545110us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_rename
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_rename
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_renameat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_rename
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545146us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545146us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dentry_iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => d_kill
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545184us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545185us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_delete_object
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dentry_iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545195us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545195us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_delete_object
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dentry_iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545215us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545216us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dentry_iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => d_kill
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545223us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545224us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => remove_save_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dentry_iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => d_kill
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545248us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2949    1..... 11523545249us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => remove_save_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => dentry_iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => d_kill
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549669us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549671us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549739us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549739us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549753us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549753us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549770us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2950    1..... 11523549770us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692064us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692066us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_create
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_create
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_last
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_filp_open
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sys_open
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_open
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692131us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692131us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_create
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_create
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_last
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_filp_open
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sys_open
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_open
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692158us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692159us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_setattr
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => notify_change
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_fchmod
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692170us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692170us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_setattr
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => notify_change
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_fchmod
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692231us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692232us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_persistent_transaction
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_get_block
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => block_prepare_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __block_write_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692275us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692275us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_end_persistent_transaction
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692301us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692301us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692317us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692317us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692339us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692339us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692354us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692355us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692383us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692384us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_linkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692415us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692415us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_linkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692450us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692451us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692458us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692459us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692467us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692467us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692482us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692483us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692492us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692492us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692504us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692504us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_truncate_file
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_file_release
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => fput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => filp_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_close
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692526us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692526us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692558us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692558us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692787us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692788us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692837us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692838us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692865us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692865us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692891us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692891us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_delete_object
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692900us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692900us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_do_truncate
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_delete_object
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692917us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692918us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692925us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692925us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => remove_save_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692946us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-3406    1..... 11523692946us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => remove_save_link
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_evict_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => evict
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => iput
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_unlinkat
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => sys_unlink
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2702    1..... 11526278612us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2702    1..... 11526278614us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => pipe_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => vfs_write
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2702    1..... 11526278665us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:04 portablebastien kernel: [19479.352011]    <...>-2702    1..... 11526278665us : <stack trace>
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:04 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => pipe_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => vfs_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-3534    1..... 11528243990us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-3534    1..... 11528243992us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => touch_atime
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => vfs_readdir
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => sys_getdents
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-3534    1..... 11528244021us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-3534    1..... 11528244022us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => touch_atime
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => vfs_readdir
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => sys_getdents
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => system_call_fastpath
Jan 29 23:48:05 portablebastien kernel: [19479.352011] CPU:0 [LOST 8126520 EVENTS]
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550662us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550677us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550678us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550701us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550701us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550716us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550716us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550728us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550728us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550743us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550743us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550762us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550763us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_persistent_transaction
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_get_block
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => block_prepare_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __block_write_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550818us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11528550819us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_end_persistent_transaction
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529811810us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529811812us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812215us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812216us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812231us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812231us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812252us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812252us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812300us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812301us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812315us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812316us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812327us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812328us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812343us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812343us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812366us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812367us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812381us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812381us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812393us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812394us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812408us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11529812408us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866165us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866167us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866216us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866217us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866232us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866233us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866248us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866248us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866273us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866274us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866289us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866289us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866303us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866304us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866318us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866319us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866336us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866336us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_persistent_transaction
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_get_block
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => block_prepare_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __block_write_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866402us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866403us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_end_persistent_transaction
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866428us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866429us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866444us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866444us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_dirty_inode
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __mark_inode_dirty
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => file_update_time
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866458us : do_journal_begin_r: begin ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866458us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_begin_r
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_begin
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866473us : do_journal_end: end ffff88011b72c800 ret=0
Jan 29 23:48:05 portablebastien kernel: [19479.352011]    <...>-17254   0..... 11530866473us : <stack trace>
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => journal_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_write_end
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_buffered_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => __generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => generic_file_aio_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => do_sync_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011]  => reiserfs_file_write
Jan 29 23:48:05 portablebastien kernel: [19479.352011] ---------------------------------
Jan 29 23:49:26 portablebastien kernel: [19560.880084] INFO: task flush-8:0:1097 blocked for more than 120 seconds.
Jan 29 23:49:26 portablebastien kernel: [19560.880089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 23:49:26 portablebastien kernel: [19560.880093] flush-8:0     D 0000000100488839     0  1097      2 0x00000000
Jan 29 23:49:26 portablebastien kernel: [19560.880100]  ffff88011e3759c0 0000000000000046 ffff88011c74bf80 0000000000000000
Jan 29 23:49:26 portablebastien kernel: [19560.880108]  ffff88011e374010 ffff88011e375fd8 ffff88011c74bf80 ffff88011c74c250
Jan 29 23:49:26 portablebastien kernel: [19560.880113]  ffff88011c74c248 0000000000014d80 0000000000014d80 ffff88011e375fd8
Jan 29 23:49:26 portablebastien kernel: [19560.880120] Call Trace:
Jan 29 23:49:26 portablebastien kernel: [19560.880131]  [<ffffffff810c3b55>] ? sync_page+0x0/0x4b
Jan 29 23:49:26 portablebastien kernel: [19560.880139]  [<ffffffff8134a9bc>] io_schedule+0x6e/0xb0
Jan 29 23:49:26 portablebastien kernel: [19560.880150]  [<ffffffff810c3b9c>] sync_page+0x47/0x4b
Jan 29 23:49:26 portablebastien kernel: [19560.880153]  [<ffffffff8134ae3e>] __wait_on_bit_lock+0x41/0x8a
Jan 29 23:49:26 portablebastien kernel: [19560.880156]  [<ffffffff810c3b41>] __lock_page+0x61/0x68
Jan 29 23:49:26 portablebastien kernel: [19560.880161]  [<ffffffff8106477b>] ? wake_bit_function+0x0/0x2e
Jan 29 23:49:26 portablebastien kernel: [19560.880165]  [<ffffffff810cbb8e>] write_cache_pages+0x1bf/0x3a4
Jan 29 23:49:26 portablebastien kernel: [19560.880168]  [<ffffffff810ca840>] ? __writepage+0x0/0x34
Jan 29 23:49:26 portablebastien kernel: [19560.880171]  [<ffffffff810cbd95>] generic_writepages+0x22/0x24
Jan 29 23:49:26 portablebastien kernel: [19560.880174]  [<ffffffff810cbdbd>] do_writepages+0x26/0x28
Jan 29 23:49:26 portablebastien kernel: [19560.880178]  [<ffffffff81120ffc>] writeback_single_inode+0xa7/0x214
Jan 29 23:49:26 portablebastien kernel: [19560.880181]  [<ffffffff8112153a>] writeback_sb_inodes+0xba/0x143
Jan 29 23:49:26 portablebastien kernel: [19560.880184]  [<ffffffff81121cdd>] writeback_inodes_wb+0x126/0x138
Jan 29 23:49:26 portablebastien kernel: [19560.880188]  [<ffffffff81121ee6>] wb_writeback+0x1f7/0x32e
Jan 29 23:49:26 portablebastien kernel: [19560.880192]  [<ffffffff8104f4e9>] ? _local_bh_enable_ip+0xc7/0xd2
Jan 29 23:49:26 portablebastien kernel: [19560.880195]  [<ffffffff8112218e>] wb_do_writeback+0x171/0x18f
Jan 29 23:49:26 portablebastien kernel: [19560.880199]  [<ffffffff810565df>] ? process_timeout+0x0/0xb
Jan 29 23:49:26 portablebastien kernel: [19560.880202]  [<ffffffff81122276>] bdi_writeback_thread+0xca/0x20c
Jan 29 23:49:26 portablebastien kernel: [19560.880205]  [<ffffffff811221ac>] ? bdi_writeback_thread+0x0/0x20c
Jan 29 23:49:26 portablebastien kernel: [19560.880209]  [<ffffffff810642ae>] kthread+0x8c/0x94
Jan 29 23:49:26 portablebastien kernel: [19560.880213]  [<ffffffff8100a964>] kernel_thread_helper+0x4/0x10
Jan 29 23:49:26 portablebastien kernel: [19560.880217]  [<ffffffff8134cf10>] ? restore_args+0x0/0x30
Jan 29 23:49:26 portablebastien kernel: [19560.880220]  [<ffffffff81064222>] ? kthread+0x0/0x94
Jan 29 23:49:26 portablebastien kernel: [19560.880223]  [<ffffffff8100a960>] ? kernel_thread_helper+0x0/0x10
Jan 29 23:49:26 portablebastien kernel: [19560.880226] 1 lock held by flush-8:0/1097:
Jan 29 23:49:26 portablebastien kernel: [19560.880227]  #0:  (&type->s_umount_key#30){+++++.}, at: [<ffffffff81121c7d>] writeback_inodes_wb+0xc6/0x138
--Boundary-00=_AwKRNeHZ6CDpxnG--
