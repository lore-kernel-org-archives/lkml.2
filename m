Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2BAPb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:31:58 -0500
Received: from plane.gmane.org ([80.91.229.3]:60513 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab2BAPb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:31:57 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: cfq bug still not fixed on x86
Date: Wed, 01 Feb 2012 07:31:42 -0800
Message-ID: <jgblsv$54l$1@dough.gmane.org>
References: <4F286529.1060407@gmail.com> <CANejiEUVeqjgEHumtEaCTpLgdQ54DWa3HJF-3qj+7t8F2bTXeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-183-137.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20120106 Thunderbird/9.0
In-Reply-To: <CANejiEUVeqjgEHumtEaCTpLgdQ54DWa3HJF-3qj+7t8F2bTXeg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 07:18 PM, Shaohua Li wrote:
> can you try the debug patch from Tejun:
> 
> http://marc.info/?l=linux-kernel&m=132683711206544&w=2

udevd still segfaults during bootup, but the backtrace looks quite
different to me.  I've pasted it at the bottom:

> 2012/2/1 walt <w41ter@gmail.com>:
>> > Hi guys.  Linus recently commited this bugfix from Jens:
>> >
>> > commit 54b466e44b1c7809144bbd8cd6be3f85877ca46f
>> > Author: Jens Axboe
>> > Date:   Tue Jan 17 21:26:11 2012 +0100
>> >
>> >    cfq-iosched: fix use-after-free of cfqq
>> >
>> > That fixed the problem on my amd64x2 machine, but my old UP x86 amd
>> > machine is still producing the same backtrace when udevd segfaults
>> > during bootup.


Feb  1 07:17:52 k2 kernel: Pid: 951, comm: scsi_id Tainted: G        W    3.3.0-rc2-dirty #128
Feb  1 07:17:52 k2 kernel: Call Trace:
Feb  1 07:17:52 k2 kernel:  [<c10326c5>] __schedule_bug+0x50/0x55
Feb  1 07:17:52 k2 kernel:  [<c12aecb3>] __schedule+0x57/0x39a
Feb  1 07:17:52 k2 kernel:  [<c11bd5cf>] ? scsi_init_sgtable+0x56/0x6f
Feb  1 07:17:52 k2 kernel:  [<c11bd781>] ? scsi_init_io+0x17/0x80
Feb  1 07:17:52 k2 kernel:  [<c11bd8f4>] ? scsi_setup_blk_pc_cmnd+0x74/0xe4
Feb  1 07:17:52 k2 kernel:  [<c11ca734>] ? sd_prep_fn+0x73c/0x753
Feb  1 07:17:52 k2 kernel:  [<c11d2100>] ? ata_scsiop_mode_sense+0x25a/0x25a
Feb  1 07:17:52 k2 kernel:  [<c12af374>] schedule+0x47/0x49
Feb  1 07:17:52 k2 kernel:  [<c12ae112>] schedule_timeout+0x17/0x13d
Feb  1 07:17:52 k2 kernel:  [<c1148b73>] ? blk_peek_request+0x81/0x151
Feb  1 07:17:52 k2 kernel:  [<c11adeb3>] ? put_device+0xf/0x11
Feb  1 07:17:52 k2 kernel:  [<c12af23d>] wait_for_common+0xb4/0x121
Feb  1 07:17:52 k2 kernel:  [<c1032d93>] ? try_to_wake_up+0xe7/0xe7
Feb  1 07:17:52 k2 kernel:  [<c12af32b>] wait_for_completion+0x12/0x14
Feb  1 07:17:52 k2 kernel:  [<c114b7f4>] blk_execute_rq+0x73/0x8b
Feb  1 07:17:52 k2 kernel:  [<c114b694>] ? blk_rq_map_user+0x1b1/0x1b1
Feb  1 07:17:52 k2 kernel:  [<c114b96f>] ? blk_recount_segments+0x16/0x24
Feb  1 07:17:52 k2 kernel:  [<c10970cf>] ? bio_phys_segments+0x11/0x17
Feb  1 07:17:52 k2 kernel:  [<c1148ceb>] ? blk_rq_bio_prep+0x23/0x70
Feb  1 07:17:52 k2 kernel:  [<c114b3b4>] ? blk_rq_append_bio+0x14/0x3b
Feb  1 07:17:52 k2 kernel:  [<c114b615>] ? blk_rq_map_user+0x132/0x1b1
Feb  1 07:17:52 k2 kernel:  [<c114eb12>] sg_io+0x24c/0x339
Feb  1 07:17:52 k2 kernel:  [<c114f098>] scsi_cmd_ioctl+0x1a0/0x351
Feb  1 07:17:52 k2 kernel:  [<c1098d5b>] ? __blkdev_get+0x246/0x2da
Feb  1 07:17:52 k2 kernel:  [<c1099093>] ? blkdev_get+0x2a4/0x2a4
Feb  1 07:17:52 k2 kernel:  [<c1098fae>] ? blkdev_get+0x1bf/0x2a4
Feb  1 07:17:52 k2 kernel:  [<c10854b4>] ? _d_rehash+0x39/0x3c
Feb  1 07:17:52 k2 kernel:  [<c114f274>] scsi_cmd_blk_ioctl+0x2b/0x37
Feb  1 07:17:52 k2 kernel:  [<c11c881c>] sd_ioctl+0x78/0x98
Feb  1 07:17:52 k2 kernel:  [<c11c87a4>] ? sd_check_events+0xc0/0xc0
Feb  1 07:17:52 k2 kernel:  [<c114c803>] __blkdev_driver_ioctl+0x1f/0x2b
Feb  1 07:17:52 k2 kernel:  [<c114d191>] blkdev_ioctl+0x6af/0x6ce
Feb  1 07:17:52 k2 kernel:  [<c106809b>] ? handle_pte_fault+0x200/0x4a8
Feb  1 07:17:52 k2 kernel:  [<c1097d77>] block_ioctl+0x2c/0x34
Feb  1 07:17:52 k2 kernel:  [<c1097d77>] ? block_ioctl+0x2c/0x34
Feb  1 07:17:52 k2 kernel:  [<c1097d4b>] ? blkdev_get_block+0x35/0x35
Feb  1 07:17:52 k2 kernel:  [<c1082e2b>] do_vfs_ioctl+0x459/0x48f
Feb  1 07:17:52 k2 kernel:  [<c1016215>] ? do_page_fault+0x304/0x333
Feb  1 07:17:52 k2 kernel:  [<c1076180>] ? do_sys_open+0xac/0x170
Feb  1 07:17:52 k2 kernel:  [<c1082e8f>] sys_ioctl+0x2e/0x4b
Feb  1 07:17:52 k2 kernel:  [<c12b004c>] sysenter_do_call+0x12/0x22
Feb  1 07:17:52 k2 kernel: scsi_id[951]: segfault at b758b060 ip b758b060 sp bf8220f8 error 4
Feb  1 07:17:52 k2 kernel: note: scsi_id[951] exited with preempt_count 1


