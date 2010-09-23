Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0IWBAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:00:49 -0400
Received: from wh01.wirehydrant.com ([74.207.240.231]:59378 "EHLO
	wh01.wirehydrant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab0IWBAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:00:47 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2010 21:00:47 EDT
Message-ID: <4C9AA4EB.70407@innovacomputing.com>
Date: Wed, 22 Sep 2010 19:52:59 -0500
From: Alex Adriaanse <alex@innovacomputing.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, drbd-user@lists.linbit.com
Subject: Hanging kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

I'm administering a server that has frozen three times over the past two 
days.  During these times, it seemed that most processes would all of a 
sudden start hanging, and I couldn't SSH into the server or even log 
into the console.  I would start seeing messages like "INFO: task 
kswapd0:28 blocked for more than 120 seconds" on the console shortly 
after the processes hung.  The only way I could get the server to 
respond again was by resetting it.

I've posted screenshots of one of the kernel messages that would be 
displayed on the console during each of the three freezes at:
http://innovacomputing.com/kernel-hangs/20100921-1442.png
http://innovacomputing.com/kernel-hangs/20100922-1442.png
http://innovacomputing.com/kernel-hangs/20100922-1720.png

Only the errors from the second freeze above got logged to the 
filesystem, which I'm pasting here:

[85324.832015] INFO: task kswapd0:28 blocked for more than 120 seconds.
[85324.870132] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85324.917059] kswapd0       D ffff880005515780     0    28      2 0x00000000
[85324.964614]  ffff8800aa60e9f0 0000000000000046 0000000000000000 0000000000000246
[85325.009245]  000112008144ac20 000000000000f9e0 ffff88012e94ffd8 0000000000015780
[85325.053915]  0000000000015780 ffff88012fab3f90 ffff88012fab4288 000000012e94f6a0
[85325.098533] Call Trace:
[85325.113218]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85325.149714]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85325.188836]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85325.223764]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85325.262348]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85325.306149]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85325.342114]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85325.380703]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85325.422404]  [<ffffffff8103555f>] ? flush_tlb_page+0x5a/0x7b
[85325.456309]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85325.494384]  [<ffffffff8118fe6c>] ? radix_tree_delete+0xbf/0x1ba
[85325.530374]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85325.562193]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85325.594019]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85325.633646]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85325.671715]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85325.706139]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85325.742129]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85325.775503]  [<ffffffff810b953c>] ? determine_dirtyable_memory+0xd/0x1d
[85325.815129]  [<ffffffff810b95b4>] ? get_dirty_limits+0x1d/0x259
[85325.850624]  [<ffffffff810592d8>] ? try_to_del_timer_sync+0x63/0x6c
[85325.888214]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85325.921634]  [<ffffffffa015c226>] ? mb_cache_shrink_fn+0x26/0x129 [mbcache]
[85325.963343]  [<ffffffff810bda68>] ? shrink_slab+0x141/0x153
[85325.996711]  [<ffffffff810be28a>] ? kswapd+0x4b9/0x683
[85326.027508]  [<ffffffff810bddd1>] ? kswapd+0x0/0x683
[85326.057264]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85326.094266]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85326.132862]  [<ffffffff810397f6>] ? __wake_up_common+0x44/0x73
[85326.167806]  [<ffffffff810bddd1>] ? kswapd+0x0/0x683
[85326.197548]  [<ffffffff810635cd>] ? kthread+0x79/0x81
[85326.227801]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[85326.258593]  [<ffffffff81063554>] ? kthread+0x0/0x81
[85326.288330]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[85326.319121] INFO: task kjournald:2223 blocked for more than 120 seconds.
[85326.359274] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85326.406243] kjournald     D 0000000000000002     0  2223      2 0x00000000
[85326.447615]  ffff88012c0f4db0 0000000000000046 0000000000000001 0000000000000286
[85326.492332]  0000000000000003 000000000000f9e0 ffff88012962dfd8 0000000000015780
[85326.536943]  0000000000015780 ffff88012c935bd0 ffff88012c935ec8 00000000a01362ec
[85326.581609] Call Trace:
[85326.596282]  [<ffffffff81016539>] ? read_tsc+0xa/0x20
[85326.626562]  [<ffffffff8110c2bc>] ? sync_buffer+0x0/0x40
[85326.658382]  [<ffffffff812f7ae8>] ? io_schedule+0x73/0xb7
[85326.690733]  [<ffffffff8110c2f7>] ? sync_buffer+0x3b/0x40
[85326.723063]  [<ffffffff812f7ff5>] ? __wait_on_bit+0x41/0x70
[85326.756446]  [<ffffffff8110c2bc>] ? sync_buffer+0x0/0x40
[85326.788268]  [<ffffffff812f808f>] ? out_of_line_wait_on_bit+0x6b/0x77
[85326.826867]  [<ffffffff810638c8>] ? wake_bit_function+0x0/0x23
[85326.861803]  [<ffffffffa01661cd>] ? journal_commit_transaction+0x508/0xe2b [jbd]
[85326.906115]  [<ffffffff81059250>] ? lock_timer_base+0x26/0x4b
[85326.940544]  [<ffffffffa0169413>] ? kjournald+0xdf/0x226 [jbd]
[85326.975474]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85327.014066]  [<ffffffffa0169334>] ? kjournald+0x0/0x226 [jbd]
[85327.048489]  [<ffffffff810635cd>] ? kthread+0x79/0x81
[85327.078746]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[85327.109533]  [<ffffffff81063554>] ? kthread+0x0/0x81
[85327.139276]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[85327.170061] INFO: task flush-147:3:2224 blocked for more than 120 seconds.
[85327.211245] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85327.258168] flush-147:3   D ffff88000550fb30     0  2224      2 0x00000000
[85327.299553]  ffff88012c930000 0000000000000046 ffff88012d601720 ffff88012d60171c
[85327.344264]  0000000000000000 000000000000f9e0 ffff88012d601fd8 0000000000015780
[85327.388932]  0000000000015780 ffff88012c930710 ffff88012c930a08 0000000100015780
[85327.433545] Call Trace:
[85327.448216]  [<ffffffff812f7dcb>] ? schedule_timeout+0x2e/0xdd
[85327.483187]  [<ffffffff812f7c83>] ? wait_for_common+0xde/0x15b
[85327.518108]  [<ffffffff81048ecd>] ? default_wake_function+0x0/0x9
[85327.554658]  [<ffffffffa02278a9>] ? drbd_al_begin_io+0x13f/0x195 [drbd]
[85327.594335]  [<ffffffffa02288ca>] ? w_al_write_transaction+0x0/0x2d6 [drbd]
[85327.636061]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85327.671008]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85327.714853]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85327.750830]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85327.789414]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85327.831109]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85327.869172]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85327.900993]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85327.932830]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85327.972460]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85328.010518]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85328.044932]  [<ffffffff810b8c22>] ? __writepage+0xa/0x25
[85328.076771]  [<ffffffff810b92a9>] ? write_cache_pages+0x20b/0x327
[85328.113263]  [<ffffffff810b8c18>] ? __writepage+0x0/0x25
[85328.145109]  [<ffffffff8110606e>] ? writeback_single_inode+0xe7/0x2da
[85328.183675]  [<ffffffff81106d74>] ? writeback_inodes_wb+0x424/0x4ff
[85328.221243]  [<ffffffff81106f7b>] ? wb_writeback+0x12c/0x1ab
[85328.255131]  [<ffffffff81107115>] ? wb_do_writeback+0x73/0x165
[85328.290071]  [<ffffffff81107238>] ? bdi_writeback_task+0x31/0xaa
[85328.326061]  [<ffffffff810c744e>] ? bdi_start_fn+0x0/0xd2
[85328.358396]  [<ffffffff810c74be>] ? bdi_start_fn+0x70/0xd2
[85328.391259]  [<ffffffff810c744e>] ? bdi_start_fn+0x0/0xd2
[85328.423604]  [<ffffffff810635cd>] ? kthread+0x79/0x81
[85328.453884]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[85328.484659]  [<ffffffff81063554>] ? kthread+0x0/0x81
[85328.514397]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[85328.545207] INFO: task postgres:10183 blocked for more than 120 seconds.
[85328.585329] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85328.632232] postgres      D ffff880005515780     0 10183   2958 0x00000000
[85328.673576]  ffff880069902a60 0000000000000082 ffff88010c0913c8 ffff88010c0913c8
[85328.718186]  ffff88010c0913d8 000000000000f9e0 ffff88010c091fd8 0000000000015780
[85328.762802]  0000000000015780 ffff88010a488710 ffff88010a488a08 0000000100016640
[85328.807424] Call Trace:
[85328.822094]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85328.858600]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85328.897700]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85328.932668]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85328.971245]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85329.015094]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85329.051076]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85329.089657]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85329.131365]  [<ffffffff8103555f>] ? flush_tlb_page+0x5a/0x7b
[85329.165258]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85329.203329]  [<ffffffff8118fe6c>] ? radix_tree_delete+0xbf/0x1ba
[85329.239330]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85329.271179]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85329.302999]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85329.342623]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85329.380689]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85329.415112]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85329.451113]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85329.484484]  [<ffffffff810b95b4>] ? get_dirty_limits+0x1d/0x259
[85329.519954]  [<ffffffff81046cfc>] ? finish_task_switch+0x3a/0xaf
[85329.555938]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85329.589320]  [<ffffffffa015c226>] ? mb_cache_shrink_fn+0x26/0x129 [mbcache]
[85329.631032]  [<ffffffff810bda68>] ? shrink_slab+0x141/0x153
[85329.664409]  [<ffffffff810be929>] ? try_to_free_pages+0x232/0x38e
[85329.700911]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85329.737937]  [<ffffffff810c6938>] ? congestion_wait+0x74/0x80
[85329.772380]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85329.810955]  [<ffffffff810b8a03>] ? __alloc_pages_nodemask+0x3bb/0x5d0
[85329.850067]  [<ffffffff810ba06d>] ? __do_page_cache_readahead+0x9b/0x1b4
[85329.890214]  [<ffffffff810ba1a2>] ? ra_submit+0x1c/0x20
[85329.921502]  [<ffffffff810b2f3a>] ? filemap_fault+0x17d/0x2f6
[85329.955941]  [<ffffffff810c8cae>] ? __do_fault+0x54/0x3c3
[85329.988286]  [<ffffffff810caf66>] ? handle_mm_fault+0x351/0x7a5
[85330.023738]  [<ffffffff8106ad6d>] ? ktime_get_ts+0x68/0xb2
[85330.056624]  [<ffffffff812fb286>] ? do_page_fault+0x2e0/0x2fc
[85330.091043]  [<ffffffff812f9125>] ? page_fault+0x25/0x30
[85330.122857] INFO: task postgres:12592 blocked for more than 120 seconds.
[85330.163009] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85330.209962] postgres      D ffff880005515780     0 12592   2958 0x00000000
[85330.251291]  ffff88010a489530 0000000000000082 ffff88010cf19458 ffff88010cf19454
[85330.295909]  ffffffff8144ac20 000000000000f9e0 ffff88010cf19fd8 0000000000015780
[85330.340577]  0000000000015780 ffff88010c0469f0 ffff88010c046ce8 000000010cf19448
[85330.385189] Call Trace:
[85330.399863]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85330.436371]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85330.475475]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85330.510425]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85330.549008]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85330.592790]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85330.634906]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85330.673496]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85330.715202]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85330.753266]  [<ffffffff8118fe6c>] ? radix_tree_delete+0xbf/0x1ba
[85330.789269]  [<ffffffff810d2638>] ? page_referenced_one+0x8c/0x10d
[85330.826296]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85330.858123]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85330.889942]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85330.929569]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85330.967636]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85331.002055]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85331.038035]  [<ffffffff8103ebd6>] ? update_curr+0xa6/0x147
[85331.070898]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85331.104281]  [<ffffffff810b953c>] ? determine_dirtyable_memory+0xd/0x1d
[85331.143911]  [<ffffffff810b95b4>] ? get_dirty_limits+0x1d/0x259
[85331.179373]  [<ffffffff810592d8>] ? try_to_del_timer_sync+0x63/0x6c
[85331.216918]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85331.250298]  [<ffffffffa015c226>] ? mb_cache_shrink_fn+0x26/0x129 [mbcache]
[85331.292000]  [<ffffffff810bda68>] ? shrink_slab+0x141/0x153
[85331.325379]  [<ffffffff810be929>] ? try_to_free_pages+0x232/0x38e
[85331.361886]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85331.398909]  [<ffffffff810c6938>] ? congestion_wait+0x74/0x80
[85331.433345]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85331.471929]  [<ffffffff810b8a03>] ? __alloc_pages_nodemask+0x3bb/0x5d0
[85331.511035]  [<ffffffff812f7b08>] ? io_schedule+0x93/0xb7
[85331.543384]  [<ffffffff810ba06d>] ? __do_page_cache_readahead+0x9b/0x1b4
[85331.583531]  [<ffffffff810638c8>] ? wake_bit_function+0x0/0x23
[85331.618469]  [<ffffffff810ba1a2>] ? ra_submit+0x1c/0x20
[85331.649793]  [<ffffffff810b2f3a>] ? filemap_fault+0x17d/0x2f6
[85331.684247]  [<ffffffff810c8cae>] ? __do_fault+0x54/0x3c3
[85331.716594]  [<ffffffff810caf66>] ? handle_mm_fault+0x351/0x7a5
[85331.752082]  [<ffffffff812fb286>] ? do_page_fault+0x2e0/0x2fc
[85331.786542]  [<ffffffff812f9125>] ? page_fault+0x25/0x30
[85331.818400] INFO: task apache2:2174 blocked for more than 120 seconds.
[85331.857551] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85331.904471] apache2       D ffff880005515780     0  2174   3161 0x00000000
[85331.945809]  ffff88010cf4a350 0000000000000086 0000000000000000 ffffffff810b4254
[85331.990468]  00011200ffffffff 000000000000f9e0 ffff8800c49fdfd8 0000000000015780
[85332.035034]  0000000000015780 ffff880069902a60 ffff880069902d58 00000001810b4254
[85332.079599] Call Trace:
[85332.094271]  [<ffffffff810b4254>] ? mempool_alloc+0x55/0x106
[85332.128177]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85332.164682]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85332.203788]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85332.238741]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85332.277321]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85332.321119]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85332.357097]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85332.395683]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85332.437377]  [<ffffffff8103555f>] ? flush_tlb_page+0x5a/0x7b
[85332.471299]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85332.509363]  [<ffffffff8118feaf>] ? radix_tree_delete+0x102/0x1ba
[85332.545862]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85332.577686]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85332.609510]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85332.649152]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85332.687193]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85332.721633]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85332.757604]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85332.791068]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85332.824557]  [<ffffffff810c6938>] ? congestion_wait+0x74/0x80
[85332.859099]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85332.897765]  [<ffffffff810be929>] ? try_to_free_pages+0x232/0x38e
[85332.934415]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85332.971471]  [<ffffffff810b8a03>] ? __alloc_pages_nodemask+0x3bb/0x5d0
[85333.010691]  [<ffffffff810ba06d>] ? __do_page_cache_readahead+0x9b/0x1b4
[85333.050909]  [<ffffffff810ba1a2>] ? ra_submit+0x1c/0x20
[85333.082239]  [<ffffffff810b2f3a>] ? filemap_fault+0x17d/0x2f6
[85333.116716]  [<ffffffff810c8cae>] ? __do_fault+0x54/0x3c3
[85333.149102]  [<ffffffff810caf66>] ? handle_mm_fault+0x351/0x7a5
[85333.184615]  [<ffffffff81287718>] ? tcp_write_xmit+0x883/0x96c
[85333.219701]  [<ffffffff8106ad6d>] ? ktime_get_ts+0x68/0xb2
[85333.252673]  [<ffffffff812fb286>] ? do_page_fault+0x2e0/0x2fc
[85333.287174]  [<ffffffff812f9125>] ? page_fault+0x25/0x30
[85333.319101] INFO: task apache2:2311 blocked for more than 120 seconds.
[85333.358301] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85333.405303] apache2       D ffff880005415780     0  2311   3161 0x00000000
[85333.446968]  ffff8800ac920710 0000000000000086 0000000000000000 ffff8800998b2000
[85333.491588]  0000000000000010 000000000000f9e0 ffff8800998b3fd8 0000000000015780
[85333.536158]  0000000000015780 ffff88004e4de2e0 ffff88004e4de5d8 000000008118c2ae
[85333.580723] Call Trace:
[85333.595411]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85333.631902]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85333.671002]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85333.705948]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85333.744534]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85333.788329]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85333.824310]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85333.862890]  [<ffffffffa0260ab9>] ? ipt_do_table+0x5ee/0x621 [ip_tables]
[85333.903050]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85333.944755]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85333.982819]  [<ffffffff8118feaf>] ? radix_tree_delete+0x102/0x1ba
[85334.019319]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85334.051131]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85334.082960]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85334.122585]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85334.160647]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85334.195071]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85334.231063]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85334.264439]  [<ffffffff810b953c>] ? determine_dirtyable_memory+0xd/0x1d
[85334.304064]  [<ffffffff810b95b4>] ? get_dirty_limits+0x1d/0x259
[85334.339532]  [<ffffffff8105232e>] ? _local_bh_enable_ip+0x7d/0x8f
[85334.376048]  [<ffffffff8127bd33>] ? tcp_recvmsg+0x98b/0xa9e
[85334.409419]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85334.442835]  [<ffffffffa015c226>] ? mb_cache_shrink_fn+0x26/0x129 [mbcache]
[85334.484639]  [<ffffffff810bda68>] ? shrink_slab+0x141/0x153
[85334.518003]  [<ffffffff810be929>] ? try_to_free_pages+0x232/0x38e
[85334.554522]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85334.591553]  [<ffffffff810b8a03>] ? __alloc_pages_nodemask+0x3bb/0x5d0
[85334.630645]  [<ffffffff8123df1d>] ? sockfd_lookup_light+0x1a/0x51
[85334.667155]  [<ffffffff810cae28>] ? handle_mm_fault+0x213/0x7a5
[85334.702604]  [<ffffffff810d00ce>] ? do_brk+0x227/0x307
[85334.733388]  [<ffffffff812fb286>] ? do_page_fault+0x2e0/0x2fc
[85334.767817]  [<ffffffff812f9125>] ? page_fault+0x25/0x30
[85334.799650] INFO: task apache2:2318 blocked for more than 120 seconds.
[85334.838751] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85334.885650] apache2       D ffff880005515780     0  2318   3161 0x00000008
[85334.927038]  ffff880095c8d4c0 0000000000000086 ffff8800aa0955e8 ffff8800aa0955e4
[85334.971651]  00011200ffffffff 000000000000f9e0 ffff8800aa095fd8 0000000000015780
[85335.016273]  0000000000015780 ffff8800aa60e9f0 ffff8800aa60ece8 00000001810b4254
[85335.060992] Call Trace:
[85335.075680]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85335.112209]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85335.151351]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85335.186337]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85335.224919]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85335.268757]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85335.304740]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85335.343329]  [<ffffffff8118c2ae>] ? cpumask_next_and+0x2a/0x3a
[85335.378267]  [<ffffffff810394f7>] ? scale_rt_power+0x1f/0x64
[85335.412174]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85335.453885]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85335.491935]  [<ffffffff8118fe6c>] ? radix_tree_delete+0xbf/0x1ba
[85335.527929]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85335.559746]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85335.591580]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85335.631193]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85335.669253]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85335.703680]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85335.739663]  [<ffffffff810bce8f>] ? shrink_active_list+0x2b4/0x2d9
[85335.776689]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85335.810071]  [<ffffffff810b95b4>] ? get_dirty_limits+0x1d/0x259
[85335.845554]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85335.878936]  [<ffffffff810c6938>] ? congestion_wait+0x74/0x80
[85335.913361]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85335.951940]  [<ffffffff810be929>] ? try_to_free_pages+0x232/0x38e
[85335.988456]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85336.025475]  [<ffffffff810c6938>] ? congestion_wait+0x74/0x80
[85336.059889]  [<ffffffff810b8a03>] ? __alloc_pages_nodemask+0x3bb/0x5d0
[85336.099005]  [<ffffffff810baac1>] ? ____pagevec_lru_add+0x160/0x176
[85336.136549]  [<ffffffff810cae28>] ? handle_mm_fault+0x213/0x7a5
[85336.172016]  [<ffffffff81046cfc>] ? finish_task_switch+0x3a/0xaf
[85336.207999]  [<ffffffff812fb286>] ? do_page_fault+0x2e0/0x2fc
[85336.242421]  [<ffffffff812f9125>] ? page_fault+0x25/0x30
[85336.274263] INFO: task apache2:2711 blocked for more than 120 seconds.
[85336.313345] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85336.360250] apache2       D ffff880005415780     0  2711   3161 0x00000000
[85336.401637]  ffff88000961e2e0 0000000000000086 0000000000000000 0000000000000246
[85336.446250]  00011200ffffffff 000000000000f9e0 ffff88011193ffd8 0000000000015780
[85336.490814]  0000000000015780 ffff88000961bf90 ffff88000961c288 00000000810e2aaf
[85336.535431] Call Trace:
[85336.556189]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85336.592697]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85336.631797]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85336.666753]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85336.705341]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85336.749190]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85336.785159]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85336.823754]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85336.865452]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85336.903519]  [<ffffffff8118fe6c>] ? radix_tree_delete+0xbf/0x1ba
[85336.939503]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85336.971335]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85337.003140]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85337.042800]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85337.080911]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85337.115362]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85337.151354]  [<ffffffff810bce8f>] ? shrink_active_list+0x2b4/0x2d9
[85337.188381]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85337.221758]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85337.255140]  [<ffffffffa015c226>] ? mb_cache_shrink_fn+0x26/0x129 [mbcache]
[85337.296874]  [<ffffffff810bda68>] ? shrink_slab+0x141/0x153
[85337.330325]  [<ffffffff810be929>] ? try_to_free_pages+0x232/0x38e
[85337.366851]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85337.403878]  [<ffffffff81046cfc>] ? finish_task_switch+0x3a/0xaf
[85337.439867]  [<ffffffff810b8a03>] ? __alloc_pages_nodemask+0x3bb/0x5d0
[85337.478961]  [<ffffffff8103ef85>] ? check_preempt_wakeup+0x1cd/0x268
[85337.517030]  [<ffffffff810ba06d>] ? __do_page_cache_readahead+0x9b/0x1b4
[85337.557165]  [<ffffffff810ba1a2>] ? ra_submit+0x1c/0x20
[85337.588466]  [<ffffffff810b2f3a>] ? filemap_fault+0x17d/0x2f6
[85337.622930]  [<ffffffff810c8cae>] ? __do_fault+0x54/0x3c3
[85337.655291]  [<ffffffff8104088c>] ? pick_next_task_fair+0xcd/0xd8
[85337.691811]  [<ffffffff8103f2bb>] ? set_next_entity+0x34/0x56
[85337.726229]  [<ffffffff810caf66>] ? handle_mm_fault+0x351/0x7a5
[85337.761681]  [<ffffffff812fb286>] ? do_page_fault+0x2e0/0x2fc
[85337.796124]  [<ffffffff812f9125>] ? page_fault+0x25/0x30
[85337.827976] INFO: task apache2:4934 blocked for more than 120 seconds.
[85337.867100] "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[85337.914054] apache2       D ffff880005415780     0  4934   3161 0x00000000
[85337.955436]  ffff88004e4de2e0 0000000000000082 0000000000000000 ffff88001043937c
[85338.000051]  0001120074736f70 000000000000f9e0 ffff880010439fd8 0000000000015780
[85338.044721]  0000000000015780 ffff88000961e2e0 ffff88000961e5d8 0000000010439370
[85338.089385] Call Trace:
[85338.104059]  [<ffffffffa01c2519>] ? lc_get+0x4c/0x1de [lru_cache]
[85338.140567]  [<ffffffffa022783d>] ? drbd_al_begin_io+0xd3/0x195 [drbd]
[85338.179666]  [<ffffffff8110f58b>] ? bio_alloc_bioset+0x45/0xb7
[85338.214623]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85338.253221]  [<ffffffffa0225004>] ? drbd_make_request_common+0x2dc/0xc52 [drbd]
[85338.297042]  [<ffffffffa0223b71>] ? inc_ap_bio+0x6a/0x12e [drbd]
[85338.333018]  [<ffffffff8106389a>] ? autoremove_wake_function+0x0/0x2e
[85338.371606]  [<ffffffffa0225bb0>] ? drbd_make_request_26+0x236/0x34e [drbd]
[85338.413325]  [<ffffffff8117c64b>] ? generic_make_request+0x299/0x2f9
[85338.451374]  [<ffffffff8118feaf>] ? radix_tree_delete+0x102/0x1ba
[85338.487890]  [<ffffffff8117c781>] ? submit_bio+0xd6/0xf2
[85338.519709]  [<ffffffff8110b18b>] ? submit_bh+0xf5/0x115
[85338.551529]  [<ffffffff8110d701>] ? __block_write_full_page+0x1d6/0x2ac
[85338.591154]  [<ffffffff8110c486>] ? end_buffer_async_write+0x0/0x13b
[85338.629217]  [<ffffffff8110f744>] ? blkdev_get_block+0x0/0x57
[85338.663643]  [<ffffffff810bc92d>] ? shrink_page_list+0x375/0x623
[85338.699638]  [<ffffffff810bd2fe>] ? shrink_list+0x44a/0x731
[85338.733025]  [<ffffffff810b953c>] ? determine_dirtyable_memory+0xd/0x1d
[85338.772639]  [<ffffffff810b95b4>] ? get_dirty_limits+0x1d/0x259
[85338.808113]  [<ffffffff810bd865>] ? shrink_zone+0x280/0x342
[85338.841490]  [<ffffffffa015c226>] ? mb_cache_shrink_fn+0x26/0x129 [mbcache]
[85338.883193]  [<ffffffff810bda68>] ? shrink_slab+0x141/0x153
[85338.916598]  [<ffffffff810be929>] ? try_to_free_pages+0x232/0x38e
[85338.953083]  [<ffffffff810bb957>] ? isolate_pages_global+0x0/0x20f
[85338.990107]  [<ffffffff810b8a03>] ? __alloc_pages_nodemask+0x3bb/0x5d0
[85339.029218]  [<ffffffff81034c35>] ? pte_alloc_one+0xe/0x31
[85339.062080]  [<ffffffff810cab65>] ? __pte_alloc+0x16/0xc6
[85339.094423]  [<ffffffff810d7760>] ? __swap_duplicate+0x50/0x140
[85339.129904]  [<ffffffff810cc8df>] ? copy_page_range+0x30d/0x711
[85339.165353]  [<ffffffff8104ad59>] ? dup_mm+0x2c5/0x3f3
[85339.196136]  [<ffffffff8104b8e2>] ? copy_process+0xa26/0x11ad
[85339.230560]  [<ffffffff8104c1c0>] ? do_fork+0x157/0x31e
[85339.261866]  [<ffffffff810ffe69>] ? alloc_fd+0x67/0x10c
[85339.293170]  [<ffffffff810eb2f3>] ? fd_install+0x2e/0x5a
[85339.324994]  [<ffffffff81010e63>] ? stub_clone+0x13/0x20
[85339.356822]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

These hangs seemed to coincide with times when there was a large spike 
in memory consumption and much of the server's physical memory was used 
up, resulting in a significant increase in swapping.  The server has 4GB 
of RAM and 3GB of swap space.  The most swap space I've seen in use was 
0.9GB (during the periods of heavy memory consumption).  However, I 
wasn't able to measure actual swap usage during these freezes, so I 
can't confirm this correlation or the exact swap usage during the freezes.

Some background information: the /usr, /var, /var/log, /home, and /srv 
filesystems run off various DRBD devices, which use LVM logical volumes 
as the underlying storage, which in turn uses two hard drives mirrored 
using MD RAID1 as its physical volumes.  The DRBD devices are configured 
as Primary role, with the Secondary server being connected over a long 
distance link.  The root filesystem, /tmp, and swap bypass DRBD and use 
LVM logical volume directly.  These logical volumes reside on the same 
physical volume as the logical volumes that back the DRBD devices 
mentioned above.

I've been running this server under the same configuration for the past 
two weeks with no problems - until yesterday.

This server is running Debian 5.0.5 with the Debian 2.6.32-bpo.5-amd64 
kernel (supplied by the linux-image-2.6.32-bpo.5-amd64-2.6.32-20~bpo50+1 
package).

Any ideas as to what might be the root cause behind this problem?  
Please let me know if there is any additional information I should provide.

Thanks!

Alex
