Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2INCHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:07:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41705 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab2INCH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:07:28 -0400
X-AuditID: cbfee60b-b7f6c6d000001802-77-5052915c5fe5
Date: Fri, 14 Sep 2012 02:07:24 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: WARNING: at kernel/workqueue.c:1066 try_to_grab_pending
To: linux-kernel@vger.kernel.org
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20120914020257075@jongman.heo
Msgkey: 20120914020257075@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120914020257075@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <11797276.450191347588444054.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/tmboxE4MCDF50c1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mt9eWsRcccapo3vOSqYHxiUMXIyeHkICaxM3PhxhBbAkBE4mH
	DS9YIWwxiQv31rN1MXIB1cxnlDjZ9gusiEVAVWLX65lsIDabgI5Ex//9YA3CAg4SDZ93gNki
	QDU7zq5gh1igKHFt6WKwel4BQYmTM5+wQCxQkTh17hVUXFXi8pv9UEeIS1yYe4kdwuaVmNH+
	FKpeTmLa1zXMELa0xPlZGxhhDl38/TFUnF/i2O0dTF2MHGC9T+4Hw4zZvfkLG4QtIDH1zEGo
	Vk2JGzuXQ9l8EmsWvmWBGbPr1HJmmN77W+YygdjMQK9M6X7IDjKeGah3/S59dF/xCjhJ7Gt/
	yT6BUXYWktQsJN2zELqRlSxgZFnFKJpakFxQnJSeaqhXnJhbXJqXrpecn7uJERzLz7h3MM5q
	sDjEKMDBqMTDmyEcFCDEmlhWXJl7iFGCg1lJhNdWGyjEm5JYWZValB9fVJqTWnyIUZqDRUmc
	99XHwAAhgfTEktTs1NSC1CKYLBMHp1QDI9/PYycevO46pGeybENz9pUe3R83uNVb/5+dW9l9
	9MS0taEvVFv2bQ7lKHpptFRP3uLzRGbltcJiqg7Tb8/Vb5k+XX7enZs5TxlSHftj9025ZsQk
	3CDF/EWUwfnogdY7uTZiHYUzFf/NZJ2lfuz9Z4PKqMz5ZTFC+S2OPf+4OzRvab93VJ4UpMRS
	nJFoqMVcVJwIAAVzctThAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8E27dmp007640


Hi Guys,

I hit this warning with current linus + for-next branch of wq.git, running Fedora 17 on VMWare linux guest.

[89449.738642] ------------[ cut here ]------------
[89453.060422] WARNING: at kernel/workqueue.c:1066 try_to_grab_pending+0x38/0x112()
[89454.328625] Hardware name: VMware Virtual Platform
[89454.328635] Modules linked in: vmwgfx ttm drm
[89455.530576] Pid: 327, comm: jbd2/sda3-8 Not tainted 3.6.0-rc5+ #27
[89455.530582] Call Trace:
[89455.530730]  [<c042c5ba>] warn_slowpath_common+0x77/0x8c
[89456.608291]  [<c04414b6>] ? try_to_grab_pending+0x38/0x112
[89456.608306]  [<c04414b6>] ? try_to_grab_pending+0x38/0x112
[89456.608314]  [<c042c5ec>] warn_slowpath_null+0x1d/0x1f
[89456.608320]  [<c04414b6>] try_to_grab_pending+0x38/0x112
[89456.608325]  [<c0441688>] mod_delayed_work_on+0x1f/0x51
[89456.608331]  [<c04416d1>] mod_delayed_work+0x17/0x19
[89457.699645]  [<c0826a31>] linkwatch_schedule_work+0x57/0x66
[89457.699656]  [<c0826ac6>] linkwatch_fire_event+0x86/0x8b
[89458.723637]  [<c082c844>] netif_carrier_on+0x22/0x33
[89458.764724]  [<c07322ff>] vmxnet3_check_link+0x7d/0x13b
[89458.764743]  [<c07323f8>] vmxnet3_process_events+0x3b/0x10c
[89458.764748]  [<c0732509>] vmxnet3_msix_event+0x40/0x5c
[89458.765129]  [<c047f29a>] handle_irq_event_percpu+0x44/0x18b
[89458.765261]  [<c046e834>] ? arch_local_irq_save+0x12/0x17
[89458.765387]  [<c0481306>] ? unmask_irq+0x1e/0x1e
[89458.765393]  [<c047f406>] handle_irq_event+0x25/0x3f
[89458.765397]  [<c0481306>] ? unmask_irq+0x1e/0x1e
[89458.765401]  [<c0481388>] handle_edge_irq+0x82/0x9d
[89458.765403]  <IRQ>  [<c0403ed1>] ? do_IRQ+0x37/0x8d
[89458.795193]  [<c06f5e7d>] ? scsi_finish_command+0xd2/0xda
[89458.795210]  [<c06fa58b>] ? scsi_decide_disposition+0xfd/0x188
[89458.795219]  [<c0432a8a>] ? ftrace_define_fields_irq_handler_entry+0x71/0x71
[89460.964638]  [<c08e7a30>] ? common_interrupt+0x30/0x38
[89460.964657]  [<c0432a8a>] ? ftrace_define_fields_irq_handler_entry+0x71/0x71
[89462.112729]  [<c06300d8>] ? des3_ede_setkey+0x3bf/0x754
[89462.112750]  [<c043212f>] ? arch_local_irq_enable+0x7/0xb
[89462.112756]  [<c0432ae3>] ? __do_softirq+0x59/0x18d
[89462.112763]  [<c0432a8a>] ? ftrace_define_fields_irq_handler_entry+0x71/0x71
[89462.112766]  <IRQ>  [<c0432d79>] ? irq_exit+0x35/0x86
[89462.115903]  [<c041c8c5>] ? smp_apic_timer_interrupt+0x64/0x71
[89462.115965]  [<c06fc56e>] ? scsi_setup_fs_cmnd+0x6e/0x73
[89462.115980]  [<c08e260d>] ? apic_timer_interrupt+0x31/0x38
[89462.115989]  [<c046e811>] ? arch_local_irq_restore+0x5/0xb
[89462.115995]  [<c08e20e6>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[89462.116002]  [<c0741dad>] ? mptspi_qcmd+0x9f/0xa8
[89462.116010]  [<c06f5e85>] ? scsi_finish_command+0xda/0xda
[89462.116016]  [<c06f6f09>] ? scsi_dispatch_cmd+0x150/0x1f7
[89463.216101]  [<c063a38b>] ? blk_add_timer+0x6f/0x91
[89463.216122]  [<c06fc2e0>] ? scsi_request_fn+0x452/0x47a
[89464.329451]  [<c04d1168>] ? kmem_cache_alloc+0x73/0xd7
[89465.360988]  [<c04a5f1f>] ? mempool_alloc_slab+0xe/0x10
[89465.361007]  [<c0631af1>] ? __blk_run_queue+0x14/0x16
[89465.361013]  [<c06345e9>] ? queue_unplugged+0x5b/0x80
[89465.361018]  [<c0407156>] ? read_tsc+0x9/0x26
[89465.361023]  [<c0636f2c>] ? blk_flush_plug_list+0x153/0x163
[89465.361095]  [<c08e190c>] ? io_schedule+0x38/0x62
[89465.361101]  [<c04a423d>] ? sleep_on_page+0x8/0xc
[89465.361105]  [<c08e0a7f>] ? __wait_on_bit+0x34/0x5b
[89465.376234]  [<c04a4235>] ? lock_page+0x20/0x20
[89465.376252]  [<c04a43ad>] ? wait_on_page_bit+0x59/0x60
[89465.376259]  [<c04451c2>] ? autoremove_wake_function+0x34/0x34
[89465.376263]  [<c04a4487>] ? filemap_fdatawait_range+0x73/0x123
[89465.376339]  [<c04f985f>] ? bio_alloc_bioset+0x37/0x97
[89466.049333]  [<c058649d>] ? jbd2_journal_write_metadata_buffer+0x26a/0x27d
[89466.049352]  [<c04a4568>] ? filemap_fdatawait+0x31/0x3b
[89466.049359]  [<c058034a>] ? jbd2_journal_commit_transaction+0x9b7/0x12f1
[89466.049366]  [<c0583ff5>] ? kjournald2+0xa1/0x1f7
[89466.049373]  [<c044518e>] ? remove_wait_queue+0x27/0x27
[89466.049377]  [<c0444cd8>] ? kthread+0x59/0x5e
[89466.049382]  [<c0583f54>] ? commit_timeout+0xa/0xa
[89466.049387]  [<c0444c7f>] ? kthread_freezable_should_stop+0x3b/0x3b
[89466.049394]  [<c08e7a3e>] ? kernel_thread_helper+0x6/0xd
[89466.049398] ---[ end trace 1311b68903c57261 ]---
[89510.373372] eth0: NIC Link is Down
[89515.678226] eth0: NIC Link is Up 10000 Mbps
[95685.119369] eth0: NIC Link is Down
[95693.639798] eth0: NIC Link is Up 10000 Mbps
[95770.746511] eth0: NIC Link is Down
[95775.963195] eth0: NIC Link is Up 10000 Mbps
[167185.224550] BUG: soft lockup - CPU#1 stuck for 21s! [nmbd:753]
[167185.435684] Modules linked in: vmwgfx ttm drm
[167185.754011] Pid: 753, comm: nmbd Tainted: G        W    3.6.0-rc5+ #27 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[167185.840437] EIP: 0060:[<c046437f>] EFLAGS: 00000207 CPU: 1
[167185.982084] EIP is at getnstimeofday+0x5b/0x72
[167185.982089] EAX: 3cf05455 EBX: f3d77f88 ECX: 3b18b135 EDX: 03d26bac
[167185.982091] ESI: 50528949 EDI: b8fc2c60 EBP: f3d77f80 ESP: f3d77f78
[167185.982093]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[167185.982095] CR0: 80050033 CR2: 4805b29a CR3: 33da4000 CR4: 000007d0
[167186.045565] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[167186.045591] DR6: ffff0ff0 DR7: 00000400
[167186.045596] Process nmbd (pid: 753, ti=f3d76000 task=f50c8000 task.ti=f3d76000)
[167186.045599] Stack:
[167186.045601]  f3d77f9c 00000000 f3d77f94 c04643cc 50528949 89a62655 bfeb5ce8 f3d77fac
[167186.045609]  c0431ec9 11b4c5f2 b8fc38d0 bfeb5ce8 bfeb5ce8 f3d76000 c08e74e3 bfeb5ce8
[167186.045615]  00000000 b77cbff4 bfeb5ce8 b8fc2c60 00000001 0000004e 0000007b 0000007b
[167186.045621] Call Trace:
[167186.045633]  [<c04643cc>] do_gettimeofday+0x11/0x29
[167186.045687]  [<c0431ec9>] sys_gettimeofday+0x1a/0x5b
[167186.211345]  [<c08e74e3>] sysenter_do_call+0x12/0x2c
[167186.211354] Code: ee a1 e8 72 c7 c0 89 03 e8 5f ff ff ff 89 43 04 39 35 2c 73 c7 c0 75 d7 8b 43 04 31 c9 8b 33 99 eb 09 05 00 36 65 c4 83 d2 ff 41 <83> fa 00 77 f2 3d ff c9 9a 3b 77 eb 01 f1 89 0b 89 43 04 5b 5eˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
