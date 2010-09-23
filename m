Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0IWXle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:41:34 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:48983 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756407Ab0IWXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:41:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAPKBm0xLd/sX/2dsb2JhbAAHgxSYVr0AkkGBIoMtcwQ
X-IronPort-AV: E=Sophos;i="4.57,226,1283745600"; 
   d="scan'208";a="76484721"
Message-ID: <4C9BE5A8.1090002@teksavvy.com>
Date: Thu, 23 Sep 2010 19:41:28 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: "blocked for more than 120 secs" --> a valid situation, how to prevent?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's the purpose of this stack dump,
and how can it be prevented in this NORMAL situation??

The command was "hdparm --security-erase NULL /dev/sdb",
which takes about 66 minutes to complete on this particular drive.

I don't see any obvious way for the task to mark itself
as needing longer than 120 secs to complete the operation.

Thanks.

[ 1800.373281] INFO: task hdparm:1979 blocked for more than 120 seconds.
[ 1800.373288] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1800.373294] hdparm        D f64a4c00     0  1979   1718 0x00000000
[ 1800.373303]  f3065c38 00200086 c11be0e3 f64a4c00 c1439ac0 c1439ac0 c1439ac0 c1439ac0
[ 1800.373317]  f571bdb8 c1439ac0 c1439ac0 dbdc5ec7 00000163 dbdb0cfb 00000163 f571bb60
[ 1800.373329]  00000001 f3065d18 7fffffff f571bb60 f3065c64 c1270527 f684ca50 f684ca50
[ 1800.373341] Call Trace:
[ 1800.373355]  [<c11be0e3>] ? ata_scsi_queuecmd+0x6a/0x73
[ 1800.373366]  [<c1270527>] schedule_timeout+0x16/0xa5
[ 1800.373376]  [<c111a4a2>] ? __blk_run_queue+0x3d/0x5e
[ 1800.373383]  [<c1118626>] ? elv_insert+0x67/0x18f
[ 1800.373389]  [<c126fd6a>] wait_for_common+0x8a/0xd9
[ 1800.373399]  [<c1028b75>] ? default_wake_function+0x0/0xd
[ 1800.373406]  [<c126fe3a>] wait_for_completion+0x12/0x14
[ 1800.373413]  [<c111d02f>] blk_execute_rq+0x76/0x8f
[ 1800.373420]  [<c111cf1c>] ? blk_end_sync_rq+0x0/0x28
[ 1800.373428]  [<c111cc3f>] ? blk_rq_append_bio+0x14/0x3b
[ 1800.373434]  [<c111ce95>] ? blk_rq_map_user+0x12e/0x1b5
[ 1800.373442]  [<c11201f8>] sg_io+0x269/0x343
[ 1800.373450]  [<c11204be>] scsi_cmd_ioctl+0x1ec/0x396
[ 1800.373457]  [<c11993cf>] ? get_device+0x13/0x18
[ 1800.373464]  [<c11aeabd>] ? sd_open+0x45/0x104
[ 1800.373472]  [<c11aea0e>] sd_ioctl+0x6b/0x8c
[ 1800.373479]  [<c111e2fe>] __blkdev_driver_ioctl+0x66/0x87
[ 1800.373486]  [<c111ebb2>] blkdev_ioctl+0x5fe/0x62c
[ 1800.373495]  [<c1061e3f>] ? filemap_fault+0xb5/0x2fc
[ 1800.373503]  [<c10a7bde>] block_ioctl+0x2a/0x32
[ 1800.373509]  [<c10a7bde>] ? block_ioctl+0x2a/0x32
[ 1800.373518]  [<c109345a>] vfs_ioctl+0x27/0x91
[ 1800.373524]  [<c10a7bb4>] ? block_ioctl+0x0/0x32
[ 1800.373531]  [<c109398d>] do_vfs_ioctl+0x42a/0x45b
[ 1800.373538]  [<c10727b7>] ? handle_mm_fault+0x3d8/0x7c2
[ 1800.373547]  [<c1088e98>] ? fsnotify_modify+0x4f/0x5a
[ 1800.373555]  [<c101b8f9>] ? do_page_fault+0x1e4/0x243
[ 1800.373562]  [<c10939ec>] sys_ioctl+0x2e/0x48
[ 1800.373570]  [<c1002750>] sysenter_do_call+0x12/0x26

