Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1DDVQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:16:12 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:42159 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab1DDVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:16:07 -0400
Date: Mon, 4 Apr 2011 22:16:05 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110404211604.GB6133@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following warning on 2.6.39-rc1-00220-g148086b when I was
inserting an SD card (which is attached to the USB port) and USB stick
with loads of kernel debug options on:

[    7.526172] ------------[ cut here ]------------
[    7.526191] WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
[    7.526197] Hardware name: 900
[    7.526205] Pid: 1112, comm: udisks-part-id Not tainted 2.6.39-rc1-00227-gd7c764c-dirty #352
[    7.526211] Call Trace:
[    7.526224]  [<b0127208>] warn_slowpath_common+0x68/0xa0
[    7.526232]  [<b0254e8c>] ? disk_clear_events+0xdc/0xf0
[    7.526240]  [<b0254e8c>] ? disk_clear_events+0xdc/0xf0
[    7.526248]  [<b012725b>] warn_slowpath_null+0x1b/0x20
[    7.526255]  [<b0254e8c>] disk_clear_events+0xdc/0xf0
[    7.526265]  [<b01c29c5>] check_disk_change+0x25/0x70
[    7.526274]  [<b0345647>] sd_open+0x97/0x180
[    7.526282]  [<b01c38ac>] __blkdev_get+0x7c/0x310
[    7.526289]  [<b01c3b86>] blkdev_get+0x46/0x2c0
[    7.526298]  [<b051206d>] ? _raw_spin_unlock+0x1d/0x20
[    7.526306]  [<b01c3e55>] blkdev_open+0x55/0x70
[    7.526316]  [<b0193262>] __dentry_open+0x112/0x290
[    7.526323]  [<b0193446>] nameidata_to_filp+0x66/0x70
[    7.526331]  [<b01c3e00>] ? blkdev_get+0x2c0/0x2c0
[    7.526340]  [<b01a04fd>] do_last+0x19d/0x770
[    7.526348]  [<b01a1730>] path_openat+0x90/0x310
[    7.526356]  [<b01a1abd>] do_filp_open+0x5d/0x80
[    7.526364]  [<b051206d>] ? _raw_spin_unlock+0x1d/0x20
[    7.526373]  [<b01aec54>] ? alloc_fd+0x164/0x1b0
[    7.526381]  [<b0194581>] do_sys_open+0xf1/0x1c0
[    7.526389]  [<b01952ac>] ? vfs_write+0xfc/0x140
[    7.526397]  [<b01946b9>] sys_open+0x29/0x40
[    7.526404]  [<b0512817>] sysenter_do_call+0x12/0x36
[    7.526410] ---[ end trace 1aec3f97d06611cd ]---

A quick Google also turns up the same report in
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/748166 .

-- 
Sitsofe | http://sucs.org/~sits/
