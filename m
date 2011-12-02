Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1LBOxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:53:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35670 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1LBOxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:53:12 -0500
MIME-Version: 1.0
Date: Fri, 2 Dec 2011 15:53:11 +0100
Message-ID: <CAC9WiBjsYJf_amRbBHUbJ-93V-cqAo++r+vNoGv7fdwc=4Y3Zg@mail.gmail.com>
Subject: Hung task with kernel 3.1.4
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's a trace I got when dumping a file image into an SD card.

I thought it worths to report:

[ 1320.254094] INFO: task udisks-daemon:3402 blocked for more than 120 seconds.
[ 1320.254099] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.254104] udisks-daemon   D ffff880115cd5ee8     0  3402   3400 0x00000000
[ 1320.254111]  ffff880115f77af8 0000000000000082 0000000000000000
0000000000000000
[ 1320.254117]  ffff880115cd5b40 0000000000012e80 ffff880115f77fd8
ffff880115f76010
[ 1320.254124]  ffff880115f77fd8 0000000000012e80 ffff880130e996d0
ffff880115cd5b40
[ 1320.254130] Call Trace:
[ 1320.254144]  [<ffffffff8144386f>] schedule+0x3f/0x60
[ 1320.254151]  [<ffffffff81444494>] __mutex_lock_slowpath+0xf4/0x160
[ 1320.254156]  [<ffffffff8144436e>] ? mutex_lock+0x1e/0x50
[ 1320.254184]  [<ffffffff8144437b>] mutex_lock+0x2b/0x50
[ 1320.254193]  [<ffffffff8119994b>] __blkdev_get+0x6b/0x420
[ 1320.254198]  [<ffffffff81199d54>] blkdev_get+0x54/0x340
[ 1320.254203]  [<ffffffff8119a040>] ? blkdev_get+0x340/0x340
[ 1320.254208]  [<ffffffff8119a0a2>] blkdev_open+0x62/0x80
[ 1320.254215]  [<ffffffff8116237e>] __dentry_open+0x1ee/0x300
[ 1320.254222]  [<ffffffff811fe4bc>] ? security_inode_permission+0x1c/0x30
[ 1320.254228]  [<ffffffff811625fd>] nameidata_to_filp+0xad/0xb0
[ 1320.254235]  [<ffffffff811714cc>] do_last+0x1cc/0x7d0
[ 1320.254240]  [<ffffffff811724e5>] path_openat+0xd5/0x410
[ 1320.254246]  [<ffffffff81236e67>] ? kobject_put+0x27/0x60
[ 1320.254256]  [<ffffffff81172939>] do_filp_open+0x49/0xa0
[ 1320.254264]  [<ffffffff8117f583>] ? alloc_fd+0x53/0x140
[ 1320.254269]  [<ffffffff81163647>] do_sys_open+0x107/0x1e0
[ 1320.254274]  [<ffffffff81163760>] sys_open+0x20/0x30
[ 1320.254281]  [<ffffffff8144d942>] system_call_fastpath+0x16/0x1b
[ 1320.254295] INFO: task hald-addon-stor:4240 blocked for more than
120 seconds.
[ 1320.254298] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.254302] hald-addon-stor D ffff88008d05dee8     0  4240   1594 0x00000000
[ 1320.254308]  ffff8800af3f5af8 0000000000000086 00000110b4d43095
ffffffff00000000
[ 1320.254314]  ffff88008d05db40 0000000000012e80 ffff8800af3f5fd8
ffff8800af3f4010
[ 1320.254319]  ffff8800af3f5fd8 0000000000012e80 ffff880130e796d0
ffff88008d05db40
[ 1320.254325] Call Trace:
[ 1320.254331]  [<ffffffff8144386f>] schedule+0x3f/0x60
[ 1320.254336]  [<ffffffff81444494>] __mutex_lock_slowpath+0xf4/0x160
[ 1320.254342]  [<ffffffff8144436e>] ? mutex_lock+0x1e/0x50
[ 1320.254350]  [<ffffffff8144437b>] mutex_lock+0x2b/0x50
[ 1320.254355]  [<ffffffff8119994b>] __blkdev_get+0x6b/0x420
[ 1320.254360]  [<ffffffff81199d54>] blkdev_get+0x54/0x340
[ 1320.254365]  [<ffffffff8119a040>] ? blkdev_get+0x340/0x340
[ 1320.254370]  [<ffffffff8119a0a2>] blkdev_open+0x62/0x80
[ 1320.254375]  [<ffffffff8116237e>] __dentry_open+0x1ee/0x300
[ 1320.254380]  [<ffffffff811fe4bc>] ? security_inode_permission+0x1c/0x30
[ 1320.254385]  [<ffffffff811625fd>] nameidata_to_filp+0xad/0xb0
[ 1320.254390]  [<ffffffff811714cc>] do_last+0x1cc/0x7d0
[ 1320.254395]  [<ffffffff811724e5>] path_openat+0xd5/0x410
[ 1320.254400]  [<ffffffff81236e67>] ? kobject_put+0x27/0x60
[ 1320.254405]  [<ffffffff81172939>] do_filp_open+0x49/0xa0
[ 1320.254411]  [<ffffffff8117f583>] ? alloc_fd+0x53/0x140
[ 1320.254416]  [<ffffffff81163647>] do_sys_open+0x107/0x1e0
[ 1320.254421]  [<ffffffff81163760>] sys_open+0x20/0x30
[ 1320.254426]  [<ffffffff8144d942>] system_call_fastpath+0x16/0x1b
[ 1320.254434] INFO: task blkid:7284 blocked for more than 120 seconds.
[ 1320.254437] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.254440] blkid           D ffff88012d844818     0  7284   4211 0x00000000
[ 1320.254446]  ffff88005019daf8 0000000000000082 ffffffff37c96080
ffffffff00000000
[ 1320.254452]  ffff88012d844470 0000000000012e80 ffff88005019dfd8
ffff88005019c010
[ 1320.254458]  ffff88005019dfd8 0000000000012e80 ffff880130e616d0
ffff88012d844470
[ 1320.254464] Call Trace:
[ 1320.254469]  [<ffffffff8144386f>] schedule+0x3f/0x60
[ 1320.254474]  [<ffffffff81444494>] __mutex_lock_slowpath+0xf4/0x160
[ 1320.254482]  [<ffffffff8144437b>] mutex_lock+0x2b/0x50
[ 1320.254487]  [<ffffffff8119994b>] __blkdev_get+0x6b/0x420
[ 1320.254492]  [<ffffffff81199d54>] blkdev_get+0x54/0x340
[ 1320.254497]  [<ffffffff8119a040>] ? blkdev_get+0x340/0x340
[ 1320.254502]  [<ffffffff8119a0a2>] blkdev_open+0x62/0x80
[ 1320.254507]  [<ffffffff8116237e>] __dentry_open+0x1ee/0x300
[ 1320.254512]  [<ffffffff811fe4bc>] ? security_inode_permission+0x1c/0x30
[ 1320.254517]  [<ffffffff811625fd>] nameidata_to_filp+0xad/0xb0
[ 1320.254522]  [<ffffffff811714cc>] do_last+0x1cc/0x7d0
[ 1320.254528]  [<ffffffff811724e5>] path_openat+0xd5/0x410
[ 1320.254533]  [<ffffffff81172939>] do_filp_open+0x49/0xa0
[ 1320.254538]  [<ffffffff8117f583>] ? alloc_fd+0x53/0x140
[ 1320.254543]  [<ffffffff81163647>] do_sys_open+0x107/0x1e0
[ 1320.254548]  [<ffffffff81163760>] sys_open+0x20/0x30
[ 1320.254554]  [<ffffffff8144d942>] system_call_fastpath+0x16/0x1b


-- 
Francis
