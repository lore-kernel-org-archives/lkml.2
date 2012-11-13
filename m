Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2KMQT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:19:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22131 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2KMQTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:19:24 -0500
Message-ID: <50A272E7.9080103@oracle.com>
Date: Tue, 13 Nov 2012 11:18:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: marcel@holtmann.org, gustavo@padovan.org,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: net, bluetooth: object debug warning in bt_host_release()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity on a KVM tools (lkvm) guest running latest -next kernel I've
stumbled on the following:

[ 1434.201149] ------------[ cut here ]------------
[ 1434.204998] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
[ 1434.208324] ODEBUG: free active (active state 0) object type: work_struct hint: hci_power_on+0x0/0x90
[ 1434.210386] Pid: 8564, comm: trinity-child25 Tainted: G        W    3.7.0-rc5-next-20121112-sasha-00018-g2f4ce0e #127
[ 1434.210760] Call Trace:
[ 1434.210760]  [<ffffffff819f3d6e>] ? debug_print_object+0x8e/0xb0
[ 1434.210760]  [<ffffffff8110b887>] warn_slowpath_common+0x87/0xb0
[ 1434.210760]  [<ffffffff8110b911>] warn_slowpath_fmt+0x41/0x50
[ 1434.210760]  [<ffffffff819f3d6e>] debug_print_object+0x8e/0xb0
[ 1434.210760]  [<ffffffff8376b750>] ? hci_dev_open+0x310/0x310
[ 1434.210760]  [<ffffffff83bf94e5>] ? _raw_spin_unlock_irqrestore+0x55/0xa0
[ 1434.210760]  [<ffffffff819f3ee5>] __debug_check_no_obj_freed+0xa5/0x230
[ 1434.210760]  [<ffffffff83785db0>] ? bt_host_release+0x10/0x20
[ 1434.210760]  [<ffffffff819f4d15>] debug_check_no_obj_freed+0x15/0x20
[ 1434.210760]  [<ffffffff8125eee7>] kfree+0x227/0x330
[ 1434.210760]  [<ffffffff83785db0>] bt_host_release+0x10/0x20
[ 1434.210760]  [<ffffffff81e539e5>] device_release+0x65/0xc0
[ 1434.210760]  [<ffffffff819d3975>] kobject_cleanup+0x145/0x190
[ 1434.210760]  [<ffffffff819d39cd>] kobject_release+0xd/0x10
[ 1434.210760]  [<ffffffff819d33cc>] kobject_put+0x4c/0x60
[ 1434.210760]  [<ffffffff81e548b2>] put_device+0x12/0x20
[ 1434.210760]  [<ffffffff8376a334>] hci_free_dev+0x24/0x30
[ 1434.210760]  [<ffffffff82fd8fe1>] vhci_release+0x31/0x60
[ 1434.210760]  [<ffffffff8127be12>] __fput+0x122/0x250
[ 1434.210760]  [<ffffffff811cab0d>] ? rcu_user_exit+0x9d/0xd0
[ 1434.210760]  [<ffffffff8127bf49>] ____fput+0x9/0x10
[ 1434.210760]  [<ffffffff81133402>] task_work_run+0xb2/0xf0
[ 1434.210760]  [<ffffffff8106cfa7>] do_notify_resume+0x77/0xa0
[ 1434.210760]  [<ffffffff83bfb0ea>] int_signal+0x12/0x17
[ 1434.210760] ---[ end trace a6d57fefbc8a8cc7 ]---

Not that the guest doesn't emulate anything that looks like a bluetooth device or
has bluetooth capabilities.


Thanks,
Sasha
