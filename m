Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2LESHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:07:05 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49699 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2LESHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:07:02 -0500
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
In-Reply-To: <20121126183538.GA18590@kroah.com>
References: <CACaajQux0owmraiWmRbMLiO1oxFefP+PdiQKs1zgzrj7kcD=AA@mail.gmail.com>
 <20121126183538.GA18590@kroah.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Wed, 5 Dec 2012 22:06:45 +0400
X-Google-Sender-Auth: EN3YVJaPnWmKC7MXsqebFXVy-X4
Message-ID: <CACaajQsqKDNkMQ6+1bPNgVf6A7DAfC1ZiMBVwQKODHnq2yS-OA@mail.gmail.com>
Subject: Re: sles 11 sp2 srp and multipath issues
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/26 Greg KH <gregkh@linuxfoundation.org>:
>
> If you use a kernel.org released kernel, then we can help you out.
>
> Best of luck,

Okay. I'm use kernel from you git tree (3.0.53 stable branch). But
have no luck. Ahen i'm force reboot storage server multipath -ll on
initiator side locked.
echo w > /proc/sysrq-trigger says:

[  729.936560] SysRq : Show Blocked State
[  729.936669]   task                        PC stack   pid father
[  729.936704] multipathd      D 0000000000000083     0  8152      1
0x00000000
[  729.936709]  ffff880115b97a68 0000000000000282 0000000100000000
ffff880115b979e8
[  729.936713]  ffff880115b96010 ffff880115b97a30 ffff880115b94400
ffff880115b94400
[  729.936718]  ffff880115b94400 ffff880115b97fd8 ffff880115b97fd8
ffff880115b94400
[  729.936722] Call Trace:
[  729.936760]  [<ffffffffa017b2ad>]
scsi_block_when_processing_errors+0xcd/0xf0 [scsi_mod]
[  729.936776]  [<ffffffffa04b7cf8>] sd_open+0xb8/0x1f0 [sd_mod]
[  729.936797]  [<ffffffff80160bb8>] __blkdev_get+0x388/0x460
[  729.936803]  [<ffffffff8016113a>] blkdev_get+0x5a/0x1f0
[  729.936808]  [<ffffffff80161303>] blkdev_get_by_dev+0x33/0x70
[  729.936819]  [<ffffffffa00ffe43>] open_dev+0x33/0xb0 [dm_mod]
[  729.936835]  [<ffffffffa01000f1>] __table_get_device+0x231/0x2c0 [dm_mod]
[  729.936849]  [<ffffffffa03719d7>] parse_path+0xe7/0x380 [dm_multipath]
[  729.936859]  [<ffffffffa0371de1>] parse_priority_group+0x171/0x220
[dm_multipath]
[  729.936868]  [<ffffffffa03720c2>] multipath_ctr+0x232/0x32c [dm_multipath]
[  729.936879]  [<ffffffffa0100a63>] dm_table_add_target+0x193/0x260 [dm_mod]
[  729.936895]  [<ffffffffa0102cb9>] table_load+0xc9/0x2c0 [dm_mod]
[  729.936914]  [<ffffffffa0103f8d>] ctl_ioctl+0x1ed/0x270 [dm_mod]
[  729.936934]  [<ffffffffa010401e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
[  729.936950]  [<ffffffff8013b613>] do_vfs_ioctl+0x93/0x3f0
[  729.936955]  [<ffffffff8013ba11>] sys_ioctl+0xa1/0xb0
[  729.936962]  [<ffffffff80402233>] system_call_fastpath+0x16/0x1b
[  729.936970]  [<00007f73a8679fa7>] 0x7f73a8679fa6
[  729.936981] scsi_eh_2       D 0000000000000000     0 30416      2 0x00000000
[  729.936985]  ffff880120ff3b70 0000000000000246 0000000000000026
ffff880120ff3af0
[  729.936989]  ffff880120ff2010 ffff880120ff3b38 ffff88011f616480
ffff88011f616480
[  729.936993]  ffff88011f616480 ffff880120ff3fd8 ffff880120ff3fd8
ffff88011f616480
[  729.936997] Call Trace:
[  729.937004]  [<ffffffff803f804d>] schedule_timeout+0x21d/0x2c0
[  729.937010]  [<ffffffff803f6f35>] wait_for_common+0xe5/0x210
[  729.937018]  [<ffffffffa037b75c>] srp_disconnect_target+0x18c/0x210 [ib_srp]
[  729.937029]  [<ffffffffa037cbe0>] srp_reconnect_target+0x110/0x3a0 [ib_srp]
[  729.937042]  [<ffffffffa037cea9>] srp_reset_host+0x39/0x50 [ib_srp]
[  729.937059]  [<ffffffffa017898d>] scsi_try_host_reset+0x4d/0x120 [scsi_mod]
[  729.937077]  [<ffffffffa017a604>] scsi_eh_host_reset+0x44/0x170 [scsi_mod]
[  729.937096]  [<ffffffffa017ab81>] scsi_eh_ready_devs+0x91/0x130 [scsi_mod]
[  729.937115]  [<ffffffffa017aefd>] scsi_unjam_host+0xfd/0x200 [scsi_mod]
[  729.937134]  [<ffffffffa017b188>] scsi_error_handler+0x188/0x1e0 [scsi_mod]
[  729.937147]  [<ffffffff80067ae6>] kthread+0x96/0xa0
[  729.937153]  [<ffffffff80402bd4>] kernel_thread_helper+0x4/0x10
[  729.937156] scsi_eh_3       D 0000000000000000     0 30421      2 0x00000000
[  729.937161]  ffff88010d0d3b70 0000000000000246 0000000000000000
ffff88010d0d3af0
[  729.937165]  ffff88010d0d2010 ffff88010d0d3b38 ffff88011166a180
ffff88011166a180
[  729.937169]  ffff88011166a180 ffff88010d0d3fd8 ffff88010d0d3fd8
ffff88011166a180
[  729.937173] Call Trace:

[  729.937173] Call Trace:
[  729.937178]  [<ffffffff803f804d>] schedule_timeout+0x21d/0x2c0
[  729.937183]  [<ffffffff803f6f35>] wait_for_common+0xe5/0x210
[  729.937190]  [<ffffffffa037b75c>] srp_disconnect_target+0x18c/0x210 [ib_srp]
[  729.937201]  [<ffffffffa037cbe0>] srp_reconnect_target+0x110/0x3a0 [ib_srp]
[  729.937213]  [<ffffffffa037cea9>] srp_reset_host+0x39/0x50 [ib_srp]
[  729.937230]  [<ffffffffa017898d>] scsi_try_host_reset+0x4d/0x120 [scsi_mod]
[  729.937248]  [<ffffffffa017a604>] scsi_eh_host_reset+0x44/0x170 [scsi_mod]
[  729.937267]  [<ffffffffa017ab81>] scsi_eh_ready_devs+0x91/0x130 [scsi_mod]
[  729.937286]  [<ffffffffa017aefd>] scsi_unjam_host+0xfd/0x200 [scsi_mod]
[  729.937306]  [<ffffffffa017b188>] scsi_error_handler+0x188/0x1e0 [scsi_mod]
[  729.937317]  [<ffffffff80067ae6>] kthread+0x96/0xa0
[  729.937322]  [<ffffffff80402bd4>] kernel_thread_helper+0x4/0x10
[  729.937333] multipath       D 0000000000000001     0  5230   5056 0x00000004
[  729.937337]  ffff880128467c18 0000000000000246 0000000000000001
ffff880128467b98
[  729.937341]  ffff880128466010 ffff880128467be0 ffff8800a297a5c0
ffff8800a297a5c0
[  729.937345]  ffff8800a297a5c0 ffff880128467fd8 ffff880128467fd8
ffff8800a297a5c0
[  729.937349] Call Trace:
[  729.937354]  [<ffffffff803f7c1c>] io_schedule+0x9c/0xf0
[  729.937361]  [<ffffffff8016ff7f>] wait_for_all_aios+0xff/0x180
[  729.937366]  [<ffffffff80170396>] exit_aio+0x46/0xb0
[  729.937372]  [<ffffffff80042edd>] mmput+0x1d/0x100
[  729.937378]  [<ffffffff8004768c>] exit_mm+0x12c/0x170
[  729.937384]  [<ffffffff80048aca>] do_exit+0x18a/0x440
[  729.937389]  [<ffffffff8004911f>] do_group_exit+0x3f/0xe0
[  729.937395]  [<ffffffff8005b4f3>] get_signal_to_deliver+0x2a3/0x530
[  729.937403]  [<ffffffff80006d81>] do_signal+0x71/0x1b0
[  729.937408]  [<ffffffff80006f48>] do_notify_resume+0x88/0xa0
[  729.937413]  [<ffffffff804024c3>] int_signal+0x12/0x17
[  729.937421]  [<00007fb5b9e5e6a4>] 0x7fb5b9e5e6a3
[  729.937426] Sched Debug Version: v0.10, 3.0.53 #1



--
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
