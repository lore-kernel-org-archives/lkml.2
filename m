Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2J1VC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 17:02:28 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46572 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2J1VC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 17:02:26 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Subject: 3.6.0 ext4 dump/filemap_fault?
Date: Sun, 28 Oct 2012 17:02:17 -0400
Message-ID: <015201cdb54f$844487e0$8ccd97a0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac21T1su4AFmAffsTjaUcL9ELpApoA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Any idea what happened here (during a backup)?
Partition is ext4.

[116868.118797] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[116868.118798] dump            D ffff88003d32a5c0     0 21219  21214
0x00000000
[116868.118801]  ffff880584631d28 0000000000000082 ffff880584631d48
ffff880584631fd8
[116868.118803]  ffff880584631fd8 0000000000004000 ffffffff81a14420
ffff88003d32a5c0
[116868.118804]  ffff8807d41449c0 ffff88081bcea828 ffff880584631cb8
ffffffff810b88a7
[116868.118806] Call Trace:
[116868.118812]  [<ffffffff810b88a7>] ? filemap_fault+0x87/0x430
[116868.118814]  [<ffffffff8108786a>] ? __dequeue_entity+0x2a/0x50
[116868.118817]  [<ffffffff815fc734>] schedule+0x24/0x70
[116868.118820]  [<ffffffff815fadcc>] schedule_timeout+0x17c/0x1d0
[116868.118822]  [<ffffffff81082dd5>] ? check_preempt_curr+0x75/0xa0
[116868.118823]  [<ffffffff81082e12>] ? ttwu_do_wakeup+0x12/0x90
[116868.118824]  [<ffffffff81082f31>] ?
ttwu_do_activate.constprop.60+0x61/0x70
[116868.118826]  [<ffffffff815fbca2>] wait_for_common+0xc2/0x150
[116868.118827]  [<ffffffff81085a70>] ? try_to_wake_up+0x2d0/0x2d0
[116868.118829]  [<ffffffff8111bfe0>] ? fdatawrite_one_bdev+0x20/0x20
[116868.118830]  [<ffffffff815fc7a8>] wait_for_completion+0x18/0x20
[116868.118832]  [<ffffffff8111873e>] sync_inodes_sb+0x9e/0x1b0
[116868.118834]  [<ffffffff8111bfe0>] ? fdatawrite_one_bdev+0x20/0x20
[116868.118835]  [<ffffffff8111bff9>] sync_inodes_one_sb+0x19/0x20
[116868.118837]  [<ffffffff810f6cb1>] iterate_supers+0xe1/0xf0
[116868.118838]  [<ffffffff8111c120>] sys_sync+0x30/0x90
[116868.118839]  [<ffffffff815fe226>] system_call_fastpath+0x1a/0x1f

Justin.

