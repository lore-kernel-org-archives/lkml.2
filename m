Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2BFMYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:24:47 -0500
Received: from krak.alatek.krakow.pl ([46.170.108.42]:57942 "HELO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754889Ab2BFMYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:24:14 -0500
X-Greylist: delayed 1326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 07:24:13 EST
From: Pawel Sikora <pawel.sikora@agmk.net>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, arekm@pld-linux.org, neilb@suse.de
Subject: [3.2.2] tasks blocked during matrix auto checking.
Date: Mon, 06 Feb 2012 13:02 +0100
Message-ID: <2156863.jdbU24e2Kr@pawels>
User-Agent: KMail/4.8.0 (Linux/3.0.19-1; KDE/4.8.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on heavy loaded opterons i've noticed some blocked tasks during matrix auto checking.
is it a known issue?

(...)
[401836.109354] md: data-check of RAID array md0
[401836.109364] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[401836.109368] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[401836.109388] md: using 128k window, over a total of 8000256k.
[401836.111441] md: delaying data-check of md2 until md0 has finished (they share one or more physical units)
[401914.274728] md: md0: data-check done.
[401914.293562] md: data-check of RAID array md2
[401914.293566] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[401914.293569] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[401914.293589] md: using 128k window, over a total of 849514496k.
[402723.026480] INFO: task kjournald:1546 blocked for more than 120 seconds.
[402723.026484] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[402723.026488] kjournald       D 0000000107312539     0  1546      2 0x00000000
[402723.026494]  ffff88030ae67cd0 0000000000000046 ffff880f00000000 ffffffffa00768b1
[402723.026503]  ffff88030b81bd40 ffff88030ae67fd8 ffff88030ae67fd8 ffff88030ae67fd8
[402723.026509]  ffff88030bcb4c90 ffff88030b81bd40 ffff88030ae67ce0 0000000104dd2828
[402723.026515] Call Trace:
[402723.026544]  [<ffffffffa00768b1>] ? journal_commit_transaction+0x151/0x13d0 [jbd]
[402723.026552]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[402723.026560]  [<ffffffffa00768b6>] journal_commit_transaction+0x156/0x13d0 [jbd]
[402723.026567]  [<ffffffff8106f9ed>] ? try_to_del_timer_sync+0x8d/0x130
[402723.026572]  [<ffffffff814a1f7a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[402723.026577]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[402723.026582]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[402723.026587]  [<ffffffff8106fa90>] ? try_to_del_timer_sync+0x130/0x130
[402723.026594]  [<ffffffffa007ad2b>] kjournald+0xeb/0x250 [jbd]
[402723.026598]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[402723.026606]  [<ffffffffa007ac40>] ? commit_timeout+0x10/0x10 [jbd]
[402723.026610]  [<ffffffff810826e2>] kthread+0xa2/0xb0
[402723.026613]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[402723.026618]  [<ffffffff814ac304>] kernel_thread_helper+0x4/0x10
[402723.026622]  [<ffffffff814a2534>] ? retint_restore_args+0x13/0x13
[402723.026626]  [<ffffffff81082640>] ? __init_kthread_worker+0x70/0x70
[402723.026630]  [<ffffffff814ac300>] ? gs_change+0x13/0x13
[402723.026632] no locks held by kjournald/1546.
[402723.026642] INFO: task nscd:3037 blocked for more than 120 seconds.
[402723.026645] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[402723.026647] nscd            D 0000000107312a90     0  3037      1 0x00000000
[402723.026652]  ffff880f04fb7df8 0000000000000046 ffff880300000000 ffffffff814a18e6
[402723.026658]  ffff880f04c49ea0 ffff880f04fb7fd8 ffff880f04fb7fd8 ffff880f04fb7fd8
[402723.026663]  ffff88030bce0f50 ffff880f04c49ea0 ffff880f04fb7dd8 0000000100000006
[402723.026668] Call Trace:
[402723.026672]  [<ffffffff814a18e6>] ? rwsem_down_failed_common+0xa6/0x150
[402723.026677]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[402723.026681]  [<ffffffff814a18f5>] rwsem_down_failed_common+0xb5/0x150
[402723.026686]  [<ffffffff814a19a3>] rwsem_down_write_failed+0x13/0x20
[402723.026692]  [<ffffffff8126a9e3>] call_rwsem_down_write_failed+0x13/0x20
[402723.026696]  [<ffffffff814a110d>] ? down_write+0x4d/0x60
[402723.026701]  [<ffffffff81132de5>] ? sys_mmap_pgoff+0x125/0x230
[402723.026707]  [<ffffffff814aa0ca>] ? sysret_check+0x2e/0x69
[402723.026710]  [<ffffffff81132de5>] sys_mmap_pgoff+0x125/0x230
[402723.026714]  [<ffffffff8126aa7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[402723.026720]  [<ffffffff8101754d>] sys_mmap+0x1d/0x20
[402723.026724]  [<ffffffff814aa092>] system_call_fastpath+0x16/0x1b
[402723.026727] 1 lock held by nscd/3037:
[402723.026729]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81132de5>] sys_mmap_pgoff+0x125/0x230
[402723.026737] INFO: task nscd:3039 blocked for more than 120 seconds.
[402723.026740] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[402723.026742] nscd            D 0000000107311eb7     0  3039      1 0x00000000
[402723.026746]  ffff880f047cd8b8 0000000000000046 ffffffff00000000 ffff880f047cd970
[402723.026752]  ffff880f04c4dbe0 ffff880f047cdfd8 ffff880f047cdfd8 ffff880f047cdfd8
[402723.026757]  ffffffff8180d020 ffff880f04c4dbe0 ffff880f047cd8b8 000000018108c4a8
[402723.026762] Call Trace:
[402723.026767]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[402723.026771]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[402723.026774]  [<ffffffff8149f42a>] io_schedule+0x8a/0xd0
[402723.026777]  [<ffffffff81196049>] sleep_on_buffer+0x9/0x10
[402723.026781]  [<ffffffff8149fb02>] __wait_on_bit_lock+0x52/0xb0
[402723.026785]  [<ffffffff8109973b>] ? __lock_acquire+0x4cb/0x1ce0
[402723.026788]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[402723.026793]  [<ffffffff8149fbd7>] out_of_line_wait_on_bit_lock+0x77/0x90
[402723.026797]  [<ffffffff81082ff0>] ? autoremove_wake_function+0x40/0x40
[402723.026801]  [<ffffffff8119607e>] __lock_buffer+0x2e/0x30
[402723.026808]  [<ffffffffa007603c>] do_get_write_access+0x49c/0x500 [jbd]
[402723.026812]  [<ffffffff81196ac6>] ? __find_get_block+0xc6/0x220
[402723.026819]  [<ffffffffa0074358>] ? start_this_handle+0x358/0x450 [jbd]
[402723.026822]  [<ffffffff81196c47>] ? __getblk+0x27/0x280
[402723.026837]  [<ffffffffa009aa69>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[402723.026844]  [<ffffffffa007623b>] journal_get_write_access+0x2b/0x50 [jbd]
[402723.026857]  [<ffffffffa00ad078>] __ext3_journal_get_write_access+0x28/0x60 [ext3]
[402723.026866]  [<ffffffffa00976d3>] ext3_reserve_inode_write+0x73/0xa0 [ext3]
[402723.026876]  [<ffffffffa009773f>] ext3_mark_inode_dirty+0x3f/0xc0 [ext3]
[402723.026882]  [<ffffffffa00746c7>] ? journal_start+0x117/0x190 [jbd]
[402723.026891]  [<ffffffffa009aa69>] ext3_dirty_inode+0x59/0x90 [ext3]
[402723.026897]  [<ffffffff8118f087>] __mark_inode_dirty+0x37/0x240
[402723.026902]  [<ffffffff8117f9af>] file_update_time+0xcf/0x130
[402723.026906]  [<ffffffff81195ec4>] ? __set_page_dirty_buffers+0xc4/0xe0
[402723.026910]  [<ffffffff8112a9ac>] do_wp_page+0x39c/0x6c0
[402723.026914]  [<ffffffff8112c29d>] handle_pte_fault+0x26d/0xa00
[402723.026919]  [<ffffffff8115db26>] ? mem_cgroup_count_vm_event+0x16/0xb0
[402723.026923]  [<ffffffff8115db8a>] ? mem_cgroup_count_vm_event+0x7a/0xb0
[402723.026927]  [<ffffffff8112cdc8>] handle_mm_fault+0x1d8/0x2e0
[402723.026932]  [<ffffffff814a5bd5>] do_page_fault+0x145/0x500
[402723.026938]  [<ffffffff81183a0c>] ? vfsmount_lock_local_unlock+0x1c/0x30
[402723.026942]  [<ffffffff8118511b>] ? mntput_no_expire+0x2b/0xe0
[402723.026947]  [<ffffffff811851ea>] ? mntput+0x1a/0x30
[402723.026952]  [<ffffffff81168651>] ? fput+0x191/0x270
[402723.026956]  [<ffffffff8126aabd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[402723.026960]  [<ffffffff814a27b5>] page_fault+0x25/0x30
[402723.026964] 2 locks held by nscd/3039:
[402723.026965]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff814a5b70>] do_page_fault+0xe0/0x500
[402723.026971]  #1:  (jbd_handle){+.+...}, at: [<ffffffffa0074358>] start_this_handle+0x358/0x450 [jbd]
[403443.026433] INFO: task kjournald:1546 blocked for more than 120 seconds.
[403443.026437] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[403443.026441] kjournald       D 000000010734d6f2     0  1546      2 0x00000000
[403443.026447]  ffff88030ae67cd0 0000000000000046 ffff880f00000000 ffffffffa00768b1
[403443.026456]  ffff88030b81bd40 ffff88030ae67fd8 ffff88030ae67fd8 ffff88030ae67fd8
[403443.026461]  ffffffff8180d020 ffff88030b81bd40 ffff88030ae67ce0 0000000104dd2828
[403443.026467] Call Trace:
[403443.026496]  [<ffffffffa00768b1>] ? journal_commit_transaction+0x151/0x13d0 [jbd]
[403443.026504]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[403443.026512]  [<ffffffffa00768b6>] journal_commit_transaction+0x156/0x13d0 [jbd]
[403443.026519]  [<ffffffff8106f9ed>] ? try_to_del_timer_sync+0x8d/0x130
[403443.026524]  [<ffffffff814a1f7a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[403443.026529]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[403443.026535]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[403443.026539]  [<ffffffff8106fa90>] ? try_to_del_timer_sync+0x130/0x130
[403443.026547]  [<ffffffffa007ad2b>] kjournald+0xeb/0x250 [jbd]
[403443.026551]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[403443.026558]  [<ffffffffa007ac40>] ? commit_timeout+0x10/0x10 [jbd]
[403443.026562]  [<ffffffff810826e2>] kthread+0xa2/0xb0
[403443.026565]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[403443.026571]  [<ffffffff814ac304>] kernel_thread_helper+0x4/0x10
[403443.026575]  [<ffffffff814a2534>] ? retint_restore_args+0x13/0x13
[403443.026578]  [<ffffffff81082640>] ? __init_kthread_worker+0x70/0x70
[403443.026582]  [<ffffffff814ac300>] ? gs_change+0x13/0x13
[403443.026585] no locks held by kjournald/1546.
[403443.026594] INFO: task nscd:3039 blocked for more than 120 seconds.
[403443.026596] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[403443.026599] nscd            D 000000010734d0dc     0  3039      1 0x00000000
[403443.026604]  ffff880f047cd8b8 0000000000000046 ffffffff00000000 ffff880f047cd970
[403443.026610]  ffff880f04c4dbe0 ffff880f047cdfd8 ffff880f047cdfd8 ffff880f047cdfd8
[403443.026615]  ffffffff8180d020 ffff880f04c4dbe0 ffff880f047cd8b8 000000018108c4a8
[403443.026620] Call Trace:
[403443.026625]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[403443.026629]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[403443.026633]  [<ffffffff8149f42a>] io_schedule+0x8a/0xd0
[403443.026636]  [<ffffffff81196049>] sleep_on_buffer+0x9/0x10
[403443.026640]  [<ffffffff8149fb02>] __wait_on_bit_lock+0x52/0xb0
[403443.026644]  [<ffffffff8109973b>] ? __lock_acquire+0x4cb/0x1ce0
[403443.026647]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[403443.026651]  [<ffffffff8149fbd7>] out_of_line_wait_on_bit_lock+0x77/0x90
[403443.026655]  [<ffffffff81082ff0>] ? autoremove_wake_function+0x40/0x40
[403443.026659]  [<ffffffff8119607e>] __lock_buffer+0x2e/0x30
[403443.026666]  [<ffffffffa007603c>] do_get_write_access+0x49c/0x500 [jbd]
[403443.026670]  [<ffffffff81196ac6>] ? __find_get_block+0xc6/0x220
[403443.026677]  [<ffffffffa0074358>] ? start_this_handle+0x358/0x450 [jbd]
[403443.026681]  [<ffffffff81196c47>] ? __getblk+0x27/0x280
[403443.026696]  [<ffffffffa009aa69>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[403443.026703]  [<ffffffffa007623b>] journal_get_write_access+0x2b/0x50 [jbd]
[403443.026715]  [<ffffffffa00ad078>] __ext3_journal_get_write_access+0x28/0x60 [ext3]
[403443.026725]  [<ffffffffa00976d3>] ext3_reserve_inode_write+0x73/0xa0 [ext3]
[403443.026734]  [<ffffffffa009773f>] ext3_mark_inode_dirty+0x3f/0xc0 [ext3]
[403443.026741]  [<ffffffffa00746c7>] ? journal_start+0x117/0x190 [jbd]
[403443.026750]  [<ffffffffa009aa69>] ext3_dirty_inode+0x59/0x90 [ext3]
[403443.026755]  [<ffffffff8118f087>] __mark_inode_dirty+0x37/0x240
[403443.026760]  [<ffffffff8117f9af>] file_update_time+0xcf/0x130
[403443.026763]  [<ffffffff81195ec4>] ? __set_page_dirty_buffers+0xc4/0xe0
[403443.026768]  [<ffffffff8112a9ac>] do_wp_page+0x39c/0x6c0
[403443.026772]  [<ffffffff8112c29d>] handle_pte_fault+0x26d/0xa00
[403443.026777]  [<ffffffff8115db26>] ? mem_cgroup_count_vm_event+0x16/0xb0
[403443.026780]  [<ffffffff8115db8a>] ? mem_cgroup_count_vm_event+0x7a/0xb0
[403443.026785]  [<ffffffff8112cdc8>] handle_mm_fault+0x1d8/0x2e0
[403443.026789]  [<ffffffff814a5bd5>] do_page_fault+0x145/0x500
[403443.026794]  [<ffffffff81183a0c>] ? vfsmount_lock_local_unlock+0x1c/0x30
[403443.026799]  [<ffffffff8118511b>] ? mntput_no_expire+0x2b/0xe0
[403443.026803]  [<ffffffff811851ea>] ? mntput+0x1a/0x30
[403443.026808]  [<ffffffff81168651>] ? fput+0x191/0x270
[403443.026814]  [<ffffffff8126aabd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[403443.026818]  [<ffffffff814a27b5>] page_fault+0x25/0x30
[403443.026821] 2 locks held by nscd/3039:
[403443.026823]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff814a5b70>] do_page_fault+0xe0/0x500
[403443.026830]  #1:  (jbd_handle){+.+...}, at: [<ffffffffa0074358>] start_this_handle+0x358/0x450 [jbd]
[403563.026391] INFO: task kjournald:1546 blocked for more than 120 seconds.
[403563.026395] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[403563.026399] kjournald       D 000000010734d6f2     0  1546      2 0x00000000
[403563.026406]  ffff88030ae67cd0 0000000000000046 ffff880f00000000 ffffffffa00768b1
[403563.026416]  ffff88030b81bd40 ffff88030ae67fd8 ffff88030ae67fd8 ffff88030ae67fd8
[403563.026424]  ffffffff8180d020 ffff88030b81bd40 ffff88030ae67ce0 0000000104dd2828
[403563.026432] Call Trace:
[403563.026461]  [<ffffffffa00768b1>] ? journal_commit_transaction+0x151/0x13d0 [jbd]
[403563.026471]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[403563.026479]  [<ffffffffa00768b6>] journal_commit_transaction+0x156/0x13d0 [jbd]
[403563.026488]  [<ffffffff8106f9ed>] ? try_to_del_timer_sync+0x8d/0x130
[403563.026494]  [<ffffffff814a1f7a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[403563.026501]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[403563.026507]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[403563.026512]  [<ffffffff8106fa90>] ? try_to_del_timer_sync+0x130/0x130
[403563.026521]  [<ffffffffa007ad2b>] kjournald+0xeb/0x250 [jbd]
[403563.026525]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[403563.026533]  [<ffffffffa007ac40>] ? commit_timeout+0x10/0x10 [jbd]
[403563.026537]  [<ffffffff810826e2>] kthread+0xa2/0xb0
[403563.026541]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[403563.026546]  [<ffffffff814ac304>] kernel_thread_helper+0x4/0x10
[403563.026550]  [<ffffffff814a2534>] ? retint_restore_args+0x13/0x13
[403563.026556]  [<ffffffff81082640>] ? __init_kthread_worker+0x70/0x70
[403563.026560]  [<ffffffff814ac300>] ? gs_change+0x13/0x13
[403563.026564] no locks held by kjournald/1546.
[403563.026575] INFO: task nscd:3039 blocked for more than 120 seconds.
[403563.026579] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[403563.026583] nscd            D 000000010734d0dc     0  3039      1 0x00000000
[403563.026590]  ffff880f047cd8b8 0000000000000046 ffffffff00000000 ffff880f047cd970
[403563.026598]  ffff880f04c4dbe0 ffff880f047cdfd8 ffff880f047cdfd8 ffff880f047cdfd8
[403563.026605]  ffffffff8180d020 ffff880f04c4dbe0 ffff880f047cd8b8 000000018108c4a8
[403563.026613] Call Trace:
[403563.026619]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[403563.026624]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[403563.026629]  [<ffffffff8149f42a>] io_schedule+0x8a/0xd0
[403563.026632]  [<ffffffff81196049>] sleep_on_buffer+0x9/0x10
[403563.026637]  [<ffffffff8149fb02>] __wait_on_bit_lock+0x52/0xb0
[403563.026641]  [<ffffffff8109973b>] ? __lock_acquire+0x4cb/0x1ce0
[403563.026645]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[403563.026650]  [<ffffffff8149fbd7>] out_of_line_wait_on_bit_lock+0x77/0x90
[403563.026655]  [<ffffffff81082ff0>] ? autoremove_wake_function+0x40/0x40
[403563.026659]  [<ffffffff8119607e>] __lock_buffer+0x2e/0x30
[403563.026667]  [<ffffffffa007603c>] do_get_write_access+0x49c/0x500 [jbd]
[403563.026672]  [<ffffffff81196ac6>] ? __find_get_block+0xc6/0x220
[403563.026680]  [<ffffffffa0074358>] ? start_this_handle+0x358/0x450 [jbd]
[403563.026684]  [<ffffffff81196c47>] ? __getblk+0x27/0x280
[403563.026700]  [<ffffffffa009aa69>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[403563.026707]  [<ffffffffa007623b>] journal_get_write_access+0x2b/0x50 [jbd]
[403563.026722]  [<ffffffffa00ad078>] __ext3_journal_get_write_access+0x28/0x60 [ext3]
[403563.026733]  [<ffffffffa00976d3>] ext3_reserve_inode_write+0x73/0xa0 [ext3]
[403563.026743]  [<ffffffffa009773f>] ext3_mark_inode_dirty+0x3f/0xc0 [ext3]
[403563.026752]  [<ffffffffa00746c7>] ? journal_start+0x117/0x190 [jbd]
[403563.026762]  [<ffffffffa009aa69>] ext3_dirty_inode+0x59/0x90 [ext3]
[403563.026769]  [<ffffffff8118f087>] __mark_inode_dirty+0x37/0x240
[403563.026774]  [<ffffffff8117f9af>] file_update_time+0xcf/0x130
[403563.026778]  [<ffffffff81195ec4>] ? __set_page_dirty_buffers+0xc4/0xe0
[403563.026784]  [<ffffffff8112a9ac>] do_wp_page+0x39c/0x6c0
[403563.026789]  [<ffffffff8112c29d>] handle_pte_fault+0x26d/0xa00
[403563.026794]  [<ffffffff8115db26>] ? mem_cgroup_count_vm_event+0x16/0xb0
[403563.026798]  [<ffffffff8115db8a>] ? mem_cgroup_count_vm_event+0x7a/0xb0
[403563.026803]  [<ffffffff8112cdc8>] handle_mm_fault+0x1d8/0x2e0
[403563.026808]  [<ffffffff814a5bd5>] do_page_fault+0x145/0x500
[403563.026815]  [<ffffffff81183a0c>] ? vfsmount_lock_local_unlock+0x1c/0x30
[403563.026820]  [<ffffffff8118511b>] ? mntput_no_expire+0x2b/0xe0
[403563.026826]  [<ffffffff811851ea>] ? mntput+0x1a/0x30
[403563.026832]  [<ffffffff81168651>] ? fput+0x191/0x270
[403563.026839]  [<ffffffff8126aabd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[403563.026843]  [<ffffffff814a27b5>] page_fault+0x25/0x30
[403563.026847] 2 locks held by nscd/3039:
[403563.026850]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff814a5b70>] do_page_fault+0xe0/0x500
[403563.026859]  #1:  (jbd_handle){+.+...}, at: [<ffffffffa0074358>] start_this_handle+0x358/0x450 [jbd]
[403683.026369] INFO: task kjournald:1546 blocked for more than 120 seconds.
[403683.026373] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[403683.026377] kjournald       D 000000010734d6f2     0  1546      2 0x00000000
[403683.026383]  ffff88030ae67cd0 0000000000000046 ffff880f00000000 ffffffffa00768b1
[403683.026392]  ffff88030b81bd40 ffff88030ae67fd8 ffff88030ae67fd8 ffff88030ae67fd8
[403683.026397]  ffffffff8180d020 ffff88030b81bd40 ffff88030ae67ce0 0000000104dd2828
[403683.026403] Call Trace:
[403683.026432]  [<ffffffffa00768b1>] ? journal_commit_transaction+0x151/0x13d0 [jbd]
[403683.026441]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[403683.026448]  [<ffffffffa00768b6>] journal_commit_transaction+0x156/0x13d0 [jbd]
[403683.026455]  [<ffffffff8106f9ed>] ? try_to_del_timer_sync+0x8d/0x130
[403683.026460]  [<ffffffff814a1f7a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[403683.026465]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[403683.026471]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[403683.026475]  [<ffffffff8106fa90>] ? try_to_del_timer_sync+0x130/0x130
[403683.026483]  [<ffffffffa007ad2b>] kjournald+0xeb/0x250 [jbd]
[403683.026486]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[403683.026494]  [<ffffffffa007ac40>] ? commit_timeout+0x10/0x10 [jbd]
[403683.026498]  [<ffffffff810826e2>] kthread+0xa2/0xb0
[403683.026501]  [<ffffffff8109836d>] ? trace_hardirqs_on+0xd/0x10
[403683.026506]  [<ffffffff814ac304>] kernel_thread_helper+0x4/0x10
[403683.026510]  [<ffffffff814a2534>] ? retint_restore_args+0x13/0x13
[403683.026514]  [<ffffffff81082640>] ? __init_kthread_worker+0x70/0x70
[403683.026518]  [<ffffffff814ac300>] ? gs_change+0x13/0x13
[403683.026521] no locks held by kjournald/1546.
[403683.026530] INFO: task nscd:3039 blocked for more than 120 seconds.
[403683.026532] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[403683.026535] nscd            D 000000010734d0dc     0  3039      1 0x00000000
[403683.026540]  ffff880f047cd8b8 0000000000000046 ffffffff00000000 ffff880f047cd970
[403683.026545]  ffff880f04c4dbe0 ffff880f047cdfd8 ffff880f047cdfd8 ffff880f047cdfd8
[403683.026551]  ffffffff8180d020 ffff880f04c4dbe0 ffff880f047cd8b8 000000018108c4a8
[403683.026556] Call Trace:
[403683.026561]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[403683.026565]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[403683.026568]  [<ffffffff8149f42a>] io_schedule+0x8a/0xd0
[403683.026572]  [<ffffffff81196049>] sleep_on_buffer+0x9/0x10
[403683.026576]  [<ffffffff8149fb02>] __wait_on_bit_lock+0x52/0xb0
[403683.026579]  [<ffffffff8109973b>] ? __lock_acquire+0x4cb/0x1ce0
[403683.026583]  [<ffffffff81196040>] ? __wait_on_buffer+0x30/0x30
[403683.026587]  [<ffffffff8149fbd7>] out_of_line_wait_on_bit_lock+0x77/0x90
[403683.026591]  [<ffffffff81082ff0>] ? autoremove_wake_function+0x40/0x40
[403683.026594]  [<ffffffff8119607e>] __lock_buffer+0x2e/0x30
[403683.026602]  [<ffffffffa007603c>] do_get_write_access+0x49c/0x500 [jbd]
[403683.026606]  [<ffffffff81196ac6>] ? __find_get_block+0xc6/0x220
[403683.026612]  [<ffffffffa0074358>] ? start_this_handle+0x358/0x450 [jbd]
[403683.026616]  [<ffffffff81196c47>] ? __getblk+0x27/0x280
[403683.026631]  [<ffffffffa009aa69>] ? ext3_dirty_inode+0x59/0x90 [ext3]
[403683.026638]  [<ffffffffa007623b>] journal_get_write_access+0x2b/0x50 [jbd]
[403683.026651]  [<ffffffffa00ad078>] __ext3_journal_get_write_access+0x28/0x60 [ext3]
[403683.026660]  [<ffffffffa00976d3>] ext3_reserve_inode_write+0x73/0xa0 [ext3]
[403683.026670]  [<ffffffffa009773f>] ext3_mark_inode_dirty+0x3f/0xc0 [ext3]
[403683.026677]  [<ffffffffa00746c7>] ? journal_start+0x117/0x190 [jbd]
[403683.026686]  [<ffffffffa009aa69>] ext3_dirty_inode+0x59/0x90 [ext3]
[403683.026691]  [<ffffffff8118f087>] __mark_inode_dirty+0x37/0x240
[403683.026696]  [<ffffffff8117f9af>] file_update_time+0xcf/0x130
[403683.026699]  [<ffffffff81195ec4>] ? __set_page_dirty_buffers+0xc4/0xe0
[403683.026704]  [<ffffffff8112a9ac>] do_wp_page+0x39c/0x6c0
[403683.026708]  [<ffffffff8112c29d>] handle_pte_fault+0x26d/0xa00
[403683.026713]  [<ffffffff8115db26>] ? mem_cgroup_count_vm_event+0x16/0xb0
[403683.026716]  [<ffffffff8115db8a>] ? mem_cgroup_count_vm_event+0x7a/0xb0
[403683.026720]  [<ffffffff8112cdc8>] handle_mm_fault+0x1d8/0x2e0
[403683.026725]  [<ffffffff814a5bd5>] do_page_fault+0x145/0x500
[403683.026730]  [<ffffffff81183a0c>] ? vfsmount_lock_local_unlock+0x1c/0x30
[403683.026735]  [<ffffffff8118511b>] ? mntput_no_expire+0x2b/0xe0
[403683.026739]  [<ffffffff811851ea>] ? mntput+0x1a/0x30
[403683.026744]  [<ffffffff81168651>] ? fput+0x191/0x270
[403683.026750]  [<ffffffff8126aabd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[403683.026754]  [<ffffffff814a27b5>] page_fault+0x25/0x30
[403683.026757] 2 locks held by nscd/3039:
[403683.026759]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff814a5b70>] do_page_fault+0xe0/0x500
[403683.026766]  #1:  (jbd_handle){+.+...}, at: [<ffffffffa0074358>] start_this_handle+0x358/0x450 [jbd]
[403683.026782] INFO: task syslog-ng:4035 blocked for more than 120 seconds.
[403683.026785] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[403683.026788] syslog-ng       D 000000010735714a     0  4035   4034 0x00000000
[403683.026793]  ffff880451e43c88 0000000000000046 ffff880f00000000 ffffffffa0074223
[403683.026799]  ffff880704028000 ffff880451e43fd8 ffff880451e43fd8 ffff880451e43fd8
[403683.026805]  ffff88030bce6b30 ffff880704028000 ffff880451e43c98 0000000104dd2828
[403683.026811] Call Trace:
[403683.026822]  [<ffffffffa0074223>] ? start_this_handle+0x223/0x450 [jbd]
[403683.026827]  [<ffffffff8149f38a>] schedule+0x3a/0x50
[403683.026834]  [<ffffffffa0074228>] start_this_handle+0x228/0x450 [jbd]
[403683.026840]  [<ffffffff810a8ec9>] ? is_module_address+0x9/0x20
[403683.026844]  [<ffffffff81095f4a>] ? static_obj+0x5a/0x70
[403683.026848]  [<ffffffff81082fb0>] ? __init_waitqueue_head+0x60/0x60
[403683.026855]  [<ffffffffa00746c7>] journal_start+0x117/0x190 [jbd]
[403683.026865]  [<ffffffffa00ae6cc>] ? ext3_xattr_get+0xdc/0x290 [ext3]
[403683.026876]  [<ffffffffa00a83d1>] ext3_journal_start_sb+0x31/0x60 [ext3]
[403683.026885]  [<ffffffffa009aa45>] ext3_dirty_inode+0x35/0x90 [ext3]
[403683.026889]  [<ffffffff8118f087>] __mark_inode_dirty+0x37/0x240
[403683.026898]  [<ffffffffa009a178>] ext3_setattr+0x158/0x360 [ext3]
[403683.026902]  [<ffffffff81181e52>] notify_change+0x1a2/0x340
[403683.026906]  [<ffffffff81164968>] chown_common+0x98/0xc0
[403683.026911]  [<ffffffff814aa0ca>] ? sysret_check+0x2e/0x69
[403683.026915]  [<ffffffff81165b25>] sys_fchown+0x95/0xb0
[403683.026919]  [<ffffffff814aa092>] system_call_fastpath+0x16/0x1b
[403683.026922] 1 lock held by syslog-ng/4035:
[403683.026924]  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff81164946>] chown_common+0x76/0xc0
[409637.741265] md: md2: data-check done.
(...)

