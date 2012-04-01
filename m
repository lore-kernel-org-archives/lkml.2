Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2DANRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:17:21 -0400
Received: from adamg.eu ([91.192.224.99]:57493 "EHLO adamg.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab2DANRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:17:18 -0400
X-Greylist: delayed 1683 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2012 09:17:17 EDT
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arekm@pld-linux.org
Subject: [PING] Re: [3.2.2] tasks blocked during matrix auto checking.
Date: Sun, 01 Apr 2012 14:49:03 +0200
Message-ID: <1404353.BmjcZtneqB@localhost>
User-Agent: KMail/4.8.0 (Linux/3.3.0-3; KDE/4.8.2; x86_64; ; )
In-Reply-To: <4142598.MA7Zy4QWhf@vmx>
References: <2156863.jdbU24e2Kr@pawels> <20120207094751.51e5321a@notabene.brown> <4142598.MA7Zy4QWhf@vmx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 of February 2012 06:58:39 Paweł Sikora wrote:
> On Tuesday 07 of February 2012 09:47:51 NeilBrown wrote:
> > On Mon, 06 Feb 2012 13:02 +0100 Pawel Sikora <pawel.sikora@agmk.net> wrote:
> > 
> > > Hi,
> > > 
> > > on heavy loaded opterons i've noticed some blocked tasks during matrix auto checking.
> > > is it a known issue?
> > 
> > No.... maybe not too surprising though.
> > The data-check will pause to let other IO through, but if there is lots of IO
> > queued up it could cause some longish delays...
> > 
> > 2 minutes does seem a bit long though, so maybe there is a bug somewhere. 
> > 
> > And had 3 consecutive timeouts, so that makes it 6 minutes which really is
> > too long.
> > 
> > What sort of array was this?  RAID1? RAID5 ??
> 
> ~810GB in raid-10:
> 
> md2 : active raid10 sda4[0] sdd4[3] sdc4[2] sdb4[1]
>       849514496 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]

any news? 3.2.13 still blocks my systems for few minutes.

[316118.098442] md: data-check of RAID array md0
[316118.098550] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[316118.098651] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[316118.098808] md: using 128k window, over a total of 8000256k.
[316118.105344] md: delaying data-check of md2 until md0 has finished (they share one or more physical units)
[316238.881071] md: md0: data-check done.
[316238.899775] md: data-check of RAID array md2
[316238.899884] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[316238.899985] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[316238.900142] md: using 128k window, over a total of 849514496k.
[318603.174883] INFO: task kjournald:1544 blocked for more than 120 seconds.
[318603.174994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.175128] kjournald       D 0000000105b02cce     0  1544      2 0x00000000
[318603.175351]  ffff880404d45cd0 0000000000000046 0000000000000000 ffff8808057bb270
[318603.175712]  ffff880405853d40 ffff880404d45fd8 ffff880404d45fd8 ffff880404d45fd8
[318603.176068]  ffff880405cbeb30 ffff880405853d40 ffff880404d45ce0 00000001057bb028
[318603.176423] Call Trace:
[318603.176523]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.176646]  [<ffffffffa00768b6>] journal_commit_transaction+0x156/0x13d0 [jbd]
[318603.176783]  [<ffffffff814a2ec1>] ? _raw_spin_lock_irqsave+0x51/0x60
[318603.176893]  [<ffffffff8106ee33>] ? lock_timer_base.isra.28+0x33/0x70
[318603.177001]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[318603.177107]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[318603.177213]  [<ffffffff8106fa90>] ? try_to_del_timer_sync+0x130/0x130
[318603.177324]  [<ffffffffa007ad9b>] kjournald+0xeb/0x250 [jbd]
[318603.177428]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[318603.177537]  [<ffffffffa007acb0>] ? commit_timeout+0x10/0x10 [jbd]
[318603.177643]  [<ffffffff810826e2>] kthread+0xa2/0xb0
[318603.177745]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[318603.177853]  [<ffffffff814acf44>] kernel_thread_helper+0x4/0x10
[318603.177957]  [<ffffffff814a3134>] ? retint_restore_args+0x13/0x13
[318603.178064]  [<ffffffff81082640>] ? __init_kthread_worker+0x70/0x70
[318603.178192]  [<ffffffff814acf40>] ? gs_change+0x13/0x13
[318603.178292] INFO: lockdep is turned off.
[318603.178389] INFO: task jbd2/md1-8:2146 blocked for more than 120 seconds.
[318603.178495] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.178628] jbd2/md1-8      D 0000000105b026fc     0  2146      2 0x00000000
[318603.178844]  ffff880405681c90 0000000000000046 0000000000000000 ffff881004673a70
[318603.179196]  ffff880405f99ea0 ffff880405681fd8 ffff880405681fd8 ffff880405681fd8
[318603.179547]  ffff880405d50f50 ffff880405f99ea0 ffff880405681ca0 0000000104673828
[318603.179902] Call Trace:
[318603.179995]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.180099]  [<ffffffffa02adabc>] jbd2_journal_commit_transaction+0x19c/0x15f0 [jbd2]
[318603.180236]  [<ffffffff814a2ec1>] ? _raw_spin_lock_irqsave+0x51/0x60
[318603.181768]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[318603.181871]  [<ffffffff8106f9ed>] ? try_to_del_timer_sync+0x8d/0x130
[318603.181977]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[318603.182083]  [<ffffffff8106fa90>] ? try_to_del_timer_sync+0x130/0x130
[318603.182191]  [<ffffffffa02b270f>] kjournald2+0xbf/0x220 [jbd2]
[318603.182294]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[318603.182402]  [<ffffffffa02b2650>] ? commit_timeout+0x10/0x10 [jbd2]
[318603.182506]  [<ffffffff810826e2>] kthread+0xa2/0xb0
[318603.182605]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[318603.182709]  [<ffffffff814acf44>] kernel_thread_helper+0x4/0x10
[318603.182814]  [<ffffffff814a3134>] ? retint_restore_args+0x13/0x13
[318603.182918]  [<ffffffff81082640>] ? __init_kthread_worker+0x70/0x70
[318603.183023]  [<ffffffff814acf40>] ? gs_change+0x13/0x13
[318603.183123] INFO: lockdep is turned off.
[318603.183224] INFO: task nscd:3084 blocked for more than 120 seconds.
[318603.183328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.183462] nscd            D 0000000105b07655     0  3084      1 0x00000000
[318603.183685]  ffff880404f01df8 0000000000000046 ffff880400000000 0000000000000246
[318603.184049]  ffff880405845be0 ffff880404f01fd8 ffff880404f01fd8 ffff880404f01fd8
[318603.184414]  ffff880405d08000 ffff880405845be0 ffff881004cc7a20 0000000104cc7a20
[318603.184776] Call Trace:
[318603.184880]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.184985]  [<ffffffff814a2505>] rwsem_down_failed_common+0xb5/0x150
[318603.185094]  [<ffffffff814a25b3>] rwsem_down_write_failed+0x13/0x20
[318603.185202]  [<ffffffff8126b1b3>] call_rwsem_down_write_failed+0x13/0x20
[318603.185310]  [<ffffffff814a1d1d>] ? down_write+0x4d/0x60
[318603.185415]  [<ffffffff81132f55>] ? sys_mmap_pgoff+0x125/0x230
[318603.185519]  [<ffffffff81132f55>] sys_mmap_pgoff+0x125/0x230
[318603.185627]  [<ffffffff8126b24e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[318603.185737]  [<ffffffff8101759d>] sys_mmap+0x1d/0x20
[318603.185840]  [<ffffffff814aacd2>] system_call_fastpath+0x16/0x1b
[318603.185943] INFO: lockdep is turned off.
[318603.186040] INFO: task nscd:3086 blocked for more than 120 seconds.
[318603.186143] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.186283] nscd            D 0000000105b03039     0  3086      1 0x00000000
[318603.186502]  ffff880403d9bdf8 0000000000000046 ffff880400000000 0000000000000246
[318603.186858]  ffff880405846b30 ffff880403d9bfd8 ffff880403d9bfd8 ffff880403d9bfd8
[318603.187212]  ffff880405cbeb30 ffff880405846b30 ffff881004cc7a20 0000000104cc7a20
[318603.187565] Call Trace:
[318603.187656]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.187756]  [<ffffffff814a2505>] rwsem_down_failed_common+0xb5/0x150
[318603.187861]  [<ffffffff814a25b3>] rwsem_down_write_failed+0x13/0x20
[318603.187965]  [<ffffffff8126b1b3>] call_rwsem_down_write_failed+0x13/0x20
[318603.188070]  [<ffffffff814a1d1d>] ? down_write+0x4d/0x60
[318603.188184]  [<ffffffff81132f55>] ? sys_mmap_pgoff+0x125/0x230
[318603.188289]  [<ffffffff81132f55>] sys_mmap_pgoff+0x125/0x230
[318603.188391]  [<ffffffff8126b24e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[318603.188496]  [<ffffffff8101759d>] sys_mmap+0x1d/0x20
[318603.188597]  [<ffffffff814aacd2>] system_call_fastpath+0x16/0x1b
[318603.188700] INFO: lockdep is turned off.
[318603.188797] INFO: task nscd:3087 blocked for more than 120 seconds.
[318603.188901] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.189035] nscd            D 0000000105b025c8     0  3087      1 0x00000000
[318603.189256]  ffff880402ddb8b8 0000000000000046 ffff880400000000 0000000000000046
[318603.189615]  ffff880405840000 ffff880402ddbfd8 ffff880402ddbfd8 ffff880402ddbfd8
[318603.189973]  ffff880405d08f50 ffff880405840000 ffff880402ddb8b8 000000018108c4a8
[318603.190332] Call Trace:
[318603.190426]  [<ffffffff81196310>] ? __wait_on_buffer+0x30/0x30
[318603.190530]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.190631]  [<ffffffff814a003a>] io_schedule+0x8a/0xd0
[318603.190733]  [<ffffffff81196319>] sleep_on_buffer+0x9/0x10
[318603.190836]  [<ffffffff814a0712>] __wait_on_bit_lock+0x52/0xb0
[318603.190940]  [<ffffffff81196310>] ? __wait_on_buffer+0x30/0x30
[318603.191044]  [<ffffffff814a07e7>] out_of_line_wait_on_bit_lock+0x77/0x90
[318603.191156]  [<ffffffff81082ff0>] ? autoremove_wake_function+0x40/0x40
[318603.191264]  [<ffffffff8119634e>] __lock_buffer+0x2e/0x30
[318603.191372]  [<ffffffffa007603c>] do_get_write_access+0x49c/0x500 [jbd]
[318603.191492]  [<ffffffff81196d96>] ? __find_get_block+0xc6/0x220
[318603.191597]  [<ffffffff81196f17>] ? __getblk+0x27/0x280
[318603.191706]  [<ffffffffa009aa69>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[318603.191815]  [<ffffffffa007623b>] journal_get_write_access+0x2b/0x50 [jbd]
[318603.191930]  [<ffffffffa00ad078>] __ext3_journal_get_write_access+0x28/0x60 [ext3]
[318603.192071]  [<ffffffffa00976d3>] ext3_reserve_inode_write+0x73/0xa0 [ext3]
[318603.192183]  [<ffffffffa009773f>] ext3_mark_inode_dirty+0x3f/0xc0 [ext3]
[318603.192294]  [<ffffffffa00746c7>] ? journal_start+0x117/0x190 [jbd]
[318603.192405]  [<ffffffffa009aa69>] ext3_dirty_inode+0x59/0x90 [ext3]
[318603.192511]  [<ffffffff8118f317>] __mark_inode_dirty+0x37/0x240
[318603.192615]  [<ffffffff8117fbff>] file_update_time+0xcf/0x130
[318603.192717]  [<ffffffff81196194>] ? __set_page_dirty_buffers+0xc4/0xe0
[318603.192824]  [<ffffffff8112ab0c>] do_wp_page+0x39c/0x6c0
[318603.192928]  [<ffffffff8112c3fd>] handle_pte_fault+0x26d/0xa00
[318603.193033]  [<ffffffff8115dd36>] ? mem_cgroup_count_vm_event+0x16/0xb0
[318603.193141]  [<ffffffff8112cf28>] handle_mm_fault+0x1d8/0x2e0
[318603.193245]  [<ffffffff814a67d5>] do_page_fault+0x145/0x500
[318603.193348]  [<ffffffff8126b28d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[318603.193455]  [<ffffffff814a33b5>] page_fault+0x25/0x30
[318603.193558] INFO: lockdep is turned off.
[318603.193667] INFO: task flush-9:1:30825 blocked for more than 120 seconds.
[318603.193772] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.193908] flush-9:1       D 0000000105b02afd     0 30825      2 0x00000000
[318603.194128]  ffff880401593840 0000000000000046 0000000000000000 ffff881004673908
[318603.194493]  ffff8804015deb30 ffff880401593fd8 ffff880401593fd8 ffff880401593fd8
[318603.194866]  ffff880405c92df0 ffff8804015deb30 ffff880401593850 0000000104673828
[318603.195232] Call Trace:
[318603.195326]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.195432]  [<ffffffffa02ab2b5>] start_this_handle+0x2b5/0x570 [jbd2]
[318603.195541]  [<ffffffff81095f4a>] ? static_obj+0x5a/0x70
[318603.195645]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[318603.195754]  [<ffffffffa02ab692>] jbd2__journal_start+0x122/0x1a0 [jbd2]
[318603.195867]  [<ffffffffa02ab71e>] jbd2_journal_start+0xe/0x10 [jbd2]
[318603.195990]  [<ffffffffa038e16e>] ext4_journal_start_sb+0x7e/0x1d0 [ext4]
[318603.196107]  [<ffffffffa0373bd4>] ? ext4_da_writepages+0x314/0x620 [ext4]
[318603.196222]  [<ffffffffa036d155>] ? ext4_meta_trans_blocks+0xa5/0xb0 [ext4]
[318603.196337]  [<ffffffffa0373bd4>] ext4_da_writepages+0x314/0x620 [ext4]
[318603.196446]  [<ffffffff8118eb60>] ? writeback_single_inode+0x1c0/0x3d0
[318603.196554]  [<ffffffff8118eb60>] ? writeback_single_inode+0x1c0/0x3d0
[318603.196663]  [<ffffffff81112aef>] do_writepages+0x1f/0x40
[318603.196767]  [<ffffffff8118eadd>] writeback_single_inode+0x13d/0x3d0
[318603.196874]  [<ffffffff8118f168>] writeback_sb_inodes+0x1a8/0x260
[318603.196979]  [<ffffffff8118f2b6>] __writeback_inodes_wb+0x96/0xc0
[318603.197084]  [<ffffffff8118f9db>] wb_writeback+0x26b/0x320
[318603.197187]  [<ffffffff8106ee33>] ? lock_timer_base.isra.28+0x33/0x70
[318603.197294]  [<ffffffff81181812>] ? get_nr_dirty_inodes+0x52/0x80
[318603.197399]  [<ffffffff8118fb27>] wb_check_old_data_flush+0x97/0xa0
[318603.197506]  [<ffffffff81190a01>] wb_do_writeback+0x141/0x1c0
[318603.197610]  [<ffffffff81190b03>] bdi_writeback_thread+0x83/0x2a0
[318603.197715]  [<ffffffff81190a80>] ? wb_do_writeback+0x1c0/0x1c0
[318603.197818]  [<ffffffff810826e2>] kthread+0xa2/0xb0
[318603.197918]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[318603.198022]  [<ffffffff814acf44>] kernel_thread_helper+0x4/0x10
[318603.198128]  [<ffffffff8104e147>] ? finish_task_switch+0x77/0x110
[318603.198245]  [<ffffffff814a298b>] ? _raw_spin_unlock_irq+0x2b/0x40
[318603.198350]  [<ffffffff814a3134>] ? retint_restore_args+0x13/0x13
[318603.198459]  [<ffffffff81082640>] ? __init_kthread_worker+0x70/0x70
[318603.198565]  [<ffffffff814acf40>] ? gs_change+0x13/0x13
[318603.198665] INFO: lockdep is turned off.
[318603.198768] INFO: task map:25641 blocked for more than 120 seconds.
[318603.198873] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.199009] map             D 0000000105b024e0     0 25641  25638 0x00020000
[318603.199234]  ffff880872c93998 0000000000000046 ffff880800000000 0000000000000046
[318603.199594]  ffff88084fadeb30 ffff880872c93fd8 ffff880872c93fd8 ffff880872c93fd8
[318603.199953]  ffff880405d0cc90 ffff88084fadeb30 ffff880872c93958 0000000172c93958
[318603.200312] Call Trace:
[318603.200407]  [<ffffffff81107030>] ? __lock_page+0x70/0x70
[318603.200510]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.200611]  [<ffffffff814a003a>] io_schedule+0x8a/0xd0
[318603.200714]  [<ffffffff81107039>] sleep_on_page+0x9/0x10
[318603.200816]  [<ffffffff814a0857>] __wait_on_bit+0x57/0x80
[318603.200919]  [<ffffffff81107180>] wait_on_page_bit+0x70/0x80
[318603.201021]  [<ffffffff81082ff0>] ? autoremove_wake_function+0x40/0x40
[318603.201135]  [<ffffffff81108050>] grab_cache_page_write_begin+0x90/0xe0
[318603.201242]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[318603.201355]  [<ffffffffa0370248>] ext4_da_write_begin+0x98/0x210 [ext4]
[318603.201463]  [<ffffffff8118f41b>] ? __mark_inode_dirty+0x13b/0x240
[318603.201581]  [<ffffffff81107502>] generic_file_buffered_write+0x112/0x290
[318603.201687]  [<ffffffff814a29c6>] ? _raw_spin_unlock+0x26/0x30
[318603.201793]  [<ffffffff81108bb9>] __generic_file_aio_write+0x229/0x440
[318603.201899]  [<ffffffff81108e3f>] generic_file_aio_write+0x6f/0xe0
[318603.202005]  [<ffffffff8104cf96>] ? task_rq_lock+0x56/0xa0
[318603.202118]  [<ffffffffa0369eaf>] ext4_file_write+0xbf/0x270 [ext4]
[318603.202226]  [<ffffffff8104cf96>] ? task_rq_lock+0x56/0xa0
[318603.202330]  [<ffffffff8116621a>] do_sync_write+0xca/0x110
[318603.202433]  [<ffffffff811292a0>] ? might_fault+0x40/0x90
[318603.202537]  [<ffffffff811f7077>] ? security_file_permission+0x27/0xb0
[318603.202644]  [<ffffffff8116679c>] ? rw_verify_area+0x5c/0xf0
[318603.202748]  [<ffffffff81166aee>] vfs_write+0xae/0x180
[318603.202849]  [<ffffffff81166e05>] sys_write+0x45/0x90
[318603.202951]  [<ffffffff814ad4d0>] cstar_dispatch+0x7/0x33
[318603.203051] INFO: lockdep is turned off.
[318603.204635] INFO: task map:26039 blocked for more than 120 seconds.
[318603.204738] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.204884] map             D 0000000105b026a2     0 26039  26036 0x00020000
[318603.205104]  ffff880435c57868 0000000000000046 ffff880400000000 0000000000000046
[318603.205462]  ffff880805085be0 ffff880435c57fd8 ffff880435c57fd8 ffff880435c57fd8
[318603.205822]  ffff880405d56b30 ffff880805085be0 ffff880435c57828 0000000135c57828
[318603.206179] Call Trace:
[318603.206272]  [<ffffffff81196310>] ? __wait_on_buffer+0x30/0x30
[318603.206376]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.206475]  [<ffffffff814a003a>] io_schedule+0x8a/0xd0
[318603.206576]  [<ffffffff81196319>] sleep_on_buffer+0x9/0x10
[318603.206678]  [<ffffffff814a0712>] __wait_on_bit_lock+0x52/0xb0
[318603.206783]  [<ffffffff814a29c6>] ? _raw_spin_unlock+0x26/0x30
[318603.206887]  [<ffffffff81196310>] ? __wait_on_buffer+0x30/0x30
[318603.206990]  [<ffffffff814a07e7>] out_of_line_wait_on_bit_lock+0x77/0x90
[318603.207096]  [<ffffffff81082ff0>] ? autoremove_wake_function+0x40/0x40
[318603.207200]  [<ffffffff8119634e>] __lock_buffer+0x2e/0x30
[318603.207304]  [<ffffffffa02ad04b>] do_get_write_access+0x4ab/0x530 [jbd2]
[318603.207408]  [<ffffffff81196f17>] ? __getblk+0x27/0x280
[318603.207511]  [<ffffffffa02ab503>] ? start_this_handle+0x503/0x570 [jbd2]
[318603.207620]  [<ffffffffa02ab4b1>] ? start_this_handle+0x4b1/0x570 [jbd2]
[318603.207731]  [<ffffffffa02ad22b>] jbd2_journal_get_write_access+0x2b/0x50 [jbd2]
[318603.207874]  [<ffffffffa039b449>] __ext4_journal_get_write_access+0x39/0x80 [ext4]
[318603.208016]  [<ffffffffa0371db8>] ext4_reserve_inode_write+0x78/0xa0 [ext4]
[318603.208131]  [<ffffffffa0371e2e>] ext4_mark_inode_dirty+0x4e/0x210 [ext4]
[318603.208259]  [<ffffffffa0374357>] ? ext4_dirty_inode+0x37/0x60 [ext4]
[318603.208376]  [<ffffffffa0374357>] ext4_dirty_inode+0x37/0x60 [ext4]
[318603.208487]  [<ffffffff8118f317>] __mark_inode_dirty+0x37/0x240
[318603.208593]  [<ffffffff8117fbff>] file_update_time+0xcf/0x130
[318603.208698]  [<ffffffff81108b88>] __generic_file_aio_write+0x1f8/0x440
[318603.208810]  [<ffffffff81108e3f>] generic_file_aio_write+0x6f/0xe0
[318603.208916]  [<ffffffff8104cf96>] ? task_rq_lock+0x56/0xa0
[318603.209026]  [<ffffffffa0369eaf>] ext4_file_write+0xbf/0x270 [ext4]
[318603.209135]  [<ffffffff811a3a12>] ? fsnotify+0x82/0x2e0
[318603.209238]  [<ffffffff8116621a>] do_sync_write+0xca/0x110
[318603.209342]  [<ffffffff811f7077>] ? security_file_permission+0x27/0xb0
[318603.209451]  [<ffffffff8116679c>] ? rw_verify_area+0x5c/0xf0
[318603.209559]  [<ffffffff81166aee>] vfs_write+0xae/0x180
[318603.209663]  [<ffffffff81166e05>] sys_write+0x45/0x90
[318603.209765]  [<ffffffff814ad4d0>] cstar_dispatch+0x7/0x33
[318603.209867] INFO: lockdep is turned off.
[318603.209964] INFO: task map:26075 blocked for more than 120 seconds.
[318603.210069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.210203] map             D 0000000105b0291b     0 26075  26072 0x00020000
[318603.210424]  ffff880c02f0d9d8 0000000000000046 0000000000000000 ffff881004673908
[318603.210782]  ffff880c03739ea0 ffff880c02f0dfd8 ffff880c02f0dfd8 ffff880c02f0dfd8
[318603.211140]  ffff880405d0eb30 ffff880c03739ea0 ffff880c02f0d9e8 0000000104673828
[318603.211510] Call Trace:
[318603.211606]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.211713]  [<ffffffffa02ab2b5>] start_this_handle+0x2b5/0x570 [jbd2]
[318603.211822]  [<ffffffff81095f4a>] ? static_obj+0x5a/0x70
[318603.211926]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[318603.212034]  [<ffffffffa02ab692>] jbd2__journal_start+0x122/0x1a0 [jbd2]
[318603.212144]  [<ffffffffa02ab71e>] jbd2_journal_start+0xe/0x10 [jbd2]
[318603.212259]  [<ffffffffa038e16e>] ext4_journal_start_sb+0x7e/0x1d0 [ext4]
[318603.212374]  [<ffffffffa0374341>] ? ext4_dirty_inode+0x21/0x60 [ext4]
[318603.212482]  [<ffffffff8115fc28>] ? __mem_cgroup_try_charge+0x2b8/0x5d0
[318603.212596]  [<ffffffffa0374341>] ext4_dirty_inode+0x21/0x60 [ext4]
[318603.212702]  [<ffffffff8118f317>] __mark_inode_dirty+0x37/0x240
[318603.212807]  [<ffffffff8117fbff>] file_update_time+0xcf/0x130
[318603.212911]  [<ffffffff81108b88>] __generic_file_aio_write+0x1f8/0x440
[318603.213018]  [<ffffffff81108e3f>] generic_file_aio_write+0x6f/0xe0
[318603.213123]  [<ffffffff8104cf96>] ? task_rq_lock+0x56/0xa0
[318603.213232]  [<ffffffffa0369eaf>] ext4_file_write+0xbf/0x270 [ext4]
[318603.213337]  [<ffffffff8104cf96>] ? task_rq_lock+0x56/0xa0
[318603.213440]  [<ffffffff8116621a>] do_sync_write+0xca/0x110
[318603.213542]  [<ffffffff811292a0>] ? might_fault+0x40/0x90
[318603.213645]  [<ffffffff811f7077>] ? security_file_permission+0x27/0xb0
[318603.213752]  [<ffffffff8116679c>] ? rw_verify_area+0x5c/0xf0
[318603.213855]  [<ffffffff81166aee>] vfs_write+0xae/0x180
[318603.213958]  [<ffffffff81166e05>] sys_write+0x45/0x90
[318603.214063]  [<ffffffff814ad4d0>] cstar_dispatch+0x7/0x33
[318603.214164] INFO: lockdep is turned off.
[318603.214262] INFO: task map:26081 blocked for more than 120 seconds.
[318603.214367] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[318603.214507] map             D 0000000105b043b2     0 26081  26078 0x00020000
[318603.214731]  ffff880c043af9d8 0000000000000046 0000000000000000 ffff881004673908
[318603.215112]  ffff880c051bcc90 ffff880c043affd8 ffff880c043affd8 ffff880c043affd8
[318603.215481]  ffff880405cbcc90 ffff880c051bcc90 ffff880c043af9e8 0000000104673828
[318603.215845] Call Trace:
[318603.215937]  [<ffffffff8149ff9a>] schedule+0x3a/0x50
[318603.216041]  [<ffffffffa02ab2b5>] start_this_handle+0x2b5/0x570 [jbd2]
[318603.216155]  [<ffffffff81095f4a>] ? static_obj+0x5a/0x70
[318603.216258]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[318603.216365]  [<ffffffffa02ab692>] jbd2__journal_start+0x122/0x1a0 [jbd2]
[318603.216475]  [<ffffffffa02ab71e>] jbd2_journal_start+0xe/0x10 [jbd2]
[318603.216590]  [<ffffffffa038e16e>] ext4_journal_start_sb+0x7e/0x1d0 [ext4]
[318603.216703]  [<ffffffffa0374341>] ? ext4_dirty_inode+0x21/0x60 [ext4]
[318603.216808]  [<ffffffff8115fc28>] ? __mem_cgroup_try_charge+0x2b8/0x5d0
[318603.216924]  [<ffffffffa0374341>] ext4_dirty_inode+0x21/0x60 [ext4]
[318603.217030]  [<ffffffff8118f317>] __mark_inode_dirty+0x37/0x240
[318603.217135]  [<ffffffff8117fbff>] file_update_time+0xcf/0x130
[318603.217239]  [<ffffffff81108b88>] __generic_file_aio_write+0x1f8/0x440
[318603.217346]  [<ffffffff81108e3f>] generic_file_aio_write+0x6f/0xe0
[318603.217452]  [<ffffffff8104cf96>] ? task_rq_lock+0x56/0xa0
[318603.217562]  [<ffffffffa0369eaf>] ext4_file_write+0xbf/0x270 [ext4]
[318603.217670]  [<ffffffff8104cf96>] ? task_rq_lock+0x56/0xa0
[318603.217773]  [<ffffffff8116621a>] do_sync_write+0xca/0x110
[318603.217878]  [<ffffffff811292a0>] ? might_fault+0x40/0x90
[318603.217981]  [<ffffffff811f7077>] ? security_file_permission+0x27/0xb0
[318603.218088]  [<ffffffff8116679c>] ? rw_verify_area+0x5c/0xf0
[318603.218207]  [<ffffffff81166aee>] vfs_write+0xae/0x180
[318603.218311]  [<ffffffff81166e05>] sys_write+0x45/0x90
[318603.218414]  [<ffffffff814ad4d0>] cstar_dispatch+0x7/0x33
[318603.218515] INFO: lockdep is turned off.
[324567.341610] md: md2: data-check done.

$ cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10]
md2 : active raid10 sda4[0] sdd4[3] sdc4[2] sdb4[1]
      849514496 blocks super 1.2 512K chunks 2 far-copies [4/4] [UUUU]

md1 : active raid0 sda3[0] sdd3[3] sdc3[2] sdb3[1]
      2047993856 blocks super 1.2 512k chunks

md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
      8000256 blocks [4/4] [UUUU]

