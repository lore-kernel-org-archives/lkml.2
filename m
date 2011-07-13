Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab1GMGQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 02:16:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57112 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930Ab1GMGQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 02:16:06 -0400
MIME-Version: 1.0
X-Originating-IP: [109.41.186.195]
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Wed, 13 Jul 2011 08:15:44 +0200
Message-ID: <CANvSZQ8RQ30cX42kufjA65pTjKXyCw6iZieCb_8m2EQKjMGSpg@mail.gmail.com>
Subject: task khubd:25 blocked for more than 120 seconds (potential 3.0-rc4 regression)
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

the following dmesg output just caught my attention:

[ 7306.160699] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7306.160705] khubd           D ffff88021103c890     0    25      2 0x00000000
[ 7306.160716]  ffff88021110dae0 0000000000000046 ffffffff815e2844
ffff88021110dfd8
[ 7306.160725]  ffff88021110dae0 0000000000012a40 0000000000012a40
ffff88021110dfd8
[ 7306.160734]  ffff88021110dfd8 0000000000012a40 ffff88021103c4d0
ffff8801a81cdbc0
[ 7306.160743] Call Trace:
[ 7306.160758]  [<ffffffff815e2844>] ? _raw_spin_lock_irqsave+0x34/0x50
[ 7306.160802]  [<ffffffff81034f69>] ? default_spin_lock_flags+0x9/0x10
[ 7306.160810]  [<ffffffff815e2844>] ? _raw_spin_lock_irqsave+0x34/0x50
[ 7306.160820]  [<ffffffff815eb80e>] ? apic_timer_interrupt+0xe/0x20
[ 7306.160829]  [<ffffffff81448337>] ? hub_release+0x27/0x30
[ 7306.160838]  [<ffffffff815e1609>] __mutex_lock_slowpath+0xd9/0x150
[ 7306.160845]  [<ffffffff81448337>] ? hub_release+0x27/0x30
[ 7306.160852]  [<ffffffff815e128b>] mutex_lock+0x2b/0x50
[ 7306.160861]  [<ffffffff8145180b>] usb_set_interface+0x8b/0x280
[ 7306.160872]  [<ffffffff8107e625>] ? __cancel_work_timer+0x45/0x80
[ 7306.160881]  [<ffffffff814532a2>] usb_unbind_interface+0x122/0x170
[ 7306.160890]  [<ffffffff813cdf6c>] __device_release_driver+0x7c/0xe0
[ 7306.160896]  [<ffffffff813ce64d>] device_release_driver+0x2d/0x40
[ 7306.160903]  [<ffffffff813cd984>] bus_remove_device+0x74/0xa0
[ 7306.160912]  [<ffffffff813cb07f>] device_del+0x12f/0x1b0
[ 7306.160920]  [<ffffffff81450146>] usb_disable_device+0x76/0x180
[ 7306.160927]  [<ffffffff81448aac>] usb_disconnect+0x9c/0x120
[ 7306.160935]  [<ffffffff8144a13d>] hub_port_connect_change+0x37d/0x680
[ 7306.160943]  [<ffffffff81447255>] ? get_port_status+0x55/0xc0
[ 7306.160950]  [<ffffffff81447754>] ? hub_port_status+0x74/0xc0
[ 7306.160957]  [<ffffffff8144ad07>] hub_events+0x3e7/0x5b0
[ 7306.160967]  [<ffffffff8108ce2d>] ? refrigerator+0xed/0x130
[ 7306.160974]  [<ffffffff8144bb4d>] hub_thread+0x3d/0x160
[ 7306.160982]  [<ffffffff81084630>] ? wake_up_bit+0x40/0x40
[ 7306.160990]  [<ffffffff8144bb10>] ? usb_authorize_device+0x180/0x180
[ 7306.160997]  [<ffffffff81083f67>] kthread+0x97/0xa0
[ 7306.161006]  [<ffffffff815ebf64>] kernel_thread_helper+0x4/0x10
[ 7306.161015]  [<ffffffff81083ed0>] ? kthread_bind+0x80/0x80
[ 7306.161023]  [<ffffffff815ebf60>] ? gs_change+0x13/0x13

I do not remeber having seen it on 2.6.38, so it might be a regression
in 3.0-rc4, which I am currently running.

Some further details: Lenovo T420s (Sandy Bridge Core i5), x86_64

Attempting to run a lsusb hangs at the moment, I'll supply its output
later when I have had a chance to reboot.

Is there a way to figure out whether a specific device is causing the hang?

Thanks,
Thilo
