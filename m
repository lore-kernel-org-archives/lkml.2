Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1DEBwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:52:51 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60903 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1DEBwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:52:47 -0400
Message-ID: <4D9A7584.9040903@kernel.dk>
Date: Tue, 05 Apr 2011 03:51:00 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
References: <20110404211604.GB6133@sucs.org>
In-Reply-To: <20110404211604.GB6133@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-04 23:16, Sitsofe Wheeler wrote:
> I'm seeing the following warning on 2.6.39-rc1-00220-g148086b when I was
> inserting an SD card (which is attached to the USB port) and USB stick
> with loads of kernel debug options on:
> 
> [    7.526172] ------------[ cut here ]------------
> [    7.526191] WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
> [    7.526197] Hardware name: 900
> [    7.526205] Pid: 1112, comm: udisks-part-id Not tainted 2.6.39-rc1-00227-gd7c764c-dirty #352
> [    7.526211] Call Trace:
> [    7.526224]  [<b0127208>] warn_slowpath_common+0x68/0xa0
> [    7.526232]  [<b0254e8c>] ? disk_clear_events+0xdc/0xf0
> [    7.526240]  [<b0254e8c>] ? disk_clear_events+0xdc/0xf0
> [    7.526248]  [<b012725b>] warn_slowpath_null+0x1b/0x20
> [    7.526255]  [<b0254e8c>] disk_clear_events+0xdc/0xf0
> [    7.526265]  [<b01c29c5>] check_disk_change+0x25/0x70
> [    7.526274]  [<b0345647>] sd_open+0x97/0x180
> [    7.526282]  [<b01c38ac>] __blkdev_get+0x7c/0x310
> [    7.526289]  [<b01c3b86>] blkdev_get+0x46/0x2c0
> [    7.526298]  [<b051206d>] ? _raw_spin_unlock+0x1d/0x20
> [    7.526306]  [<b01c3e55>] blkdev_open+0x55/0x70
> [    7.526316]  [<b0193262>] __dentry_open+0x112/0x290
> [    7.526323]  [<b0193446>] nameidata_to_filp+0x66/0x70
> [    7.526331]  [<b01c3e00>] ? blkdev_get+0x2c0/0x2c0
> [    7.526340]  [<b01a04fd>] do_last+0x19d/0x770
> [    7.526348]  [<b01a1730>] path_openat+0x90/0x310
> [    7.526356]  [<b01a1abd>] do_filp_open+0x5d/0x80
> [    7.526364]  [<b051206d>] ? _raw_spin_unlock+0x1d/0x20
> [    7.526373]  [<b01aec54>] ? alloc_fd+0x164/0x1b0
> [    7.526381]  [<b0194581>] do_sys_open+0xf1/0x1c0
> [    7.526389]  [<b01952ac>] ? vfs_write+0xfc/0x140
> [    7.526397]  [<b01946b9>] sys_open+0x29/0x40
> [    7.526404]  [<b0512817>] sysenter_do_call+0x12/0x36
> [    7.526410] ---[ end trace 1aec3f97d06611cd ]---
> 
> A quick Google also turns up the same report in
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/748166 .

CC Tejun.

-- 
Jens Axboe

