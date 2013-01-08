Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3AHWAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:00:23 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:60191
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3AHWAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:00:22 -0500
Date: Tue, 8 Jan 2013 23:00:15 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1892620313.20130108230015@eikelenboom.it>
To: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        <linux-serial@vger.kernel.org>
CC: marcel@holtmann.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Bluetooth / TTY: [ 1806.484970] INFO: task kworker/0:1:25023 blocked for more than 120 seconds.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to use a USB bluetooth dongle to connect to a bluetooth to serial device with RFCOMM.
It's able to work fine for some time, but tt consistently fails after some time.

This is sometimes right on the start when connecting to the /dev/rfcomm0, but it can also require several hours of running fine while connected and exchanging data.

This is the stacktrace i get:

[ 1806.484970] INFO: task kworker/0:1:25023 blocked for more than 120 seconds.
[ 1806.503488] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1806.521864] kworker/0:1     D 0000000000000201     0 25023      2 0x00000000
[ 1806.540026]  ffff88000baa7be8 0000000000000216 ffff880037079148 ffff880037079148
[ 1806.557926]  ffff8800386fa0e0 0000000000013040 ffff88000baa7fd8 ffff88000baa6010
[ 1806.575622]  0000000000013040 0000000000013040 ffff88000baa7fd8 0000000000013040
[ 1806.592981] Call Trace:
[ 1806.610066]  [<ffffffff810b5bd7>] ? lock_release+0x117/0x250
[ 1806.627150]  [<ffffffff810b5748>] ? lock_acquire+0xd8/0x100
[ 1806.643901]  [<ffffffff819ba2fe>] ? tty_lock_nested+0x3e/0x80
[ 1806.660460]  [<ffffffff819b8a14>] schedule+0x24/0x70
[ 1806.676724]  [<ffffffff819b8ef3>] schedule_preempt_disabled+0x13/0x20
[ 1806.692780]  [<ffffffff819b73bb>] mutex_lock_nested+0x1ab/0x450
[ 1806.708582]  [<ffffffff819ba2fe>] ? tty_lock_nested+0x3e/0x80
[ 1806.724140]  [<ffffffff819ba2fe>] tty_lock_nested+0x3e/0x80
[ 1806.739421]  [<ffffffff819ba34b>] tty_lock+0xb/0x10
[ 1806.754418]  [<ffffffff81449495>] __tty_hangup+0x65/0x3c0
[ 1806.769153]  [<ffffffff81080bf8>] ? process_one_work+0x158/0x4b0
[ 1806.783648]  [<ffffffff81449800>] do_tty_hangup+0x10/0x20
[ 1806.797905]  [<ffffffff81080c60>] process_one_work+0x1c0/0x4b0
[ 1806.811958]  [<ffffffff81080bf8>] ? process_one_work+0x158/0x4b0
[ 1806.825752]  [<ffffffff814497f0>] ? __tty_hangup+0x3c0/0x3c0
[ 1806.839332]  [<ffffffff8108134e>] worker_thread+0x11e/0x3d0
[ 1806.852654]  [<ffffffff81081230>] ? manage_workers+0x2e0/0x2e0
[ 1806.865719]  [<ffffffff81088a36>] kthread+0xd6/0xe0
[ 1806.878518]  [<ffffffff81088960>] ? __init_kthread_worker+0x70/0x70
[ 1806.891064]  [<ffffffff819baebc>] ret_from_fork+0x7c/0xb0
[ 1806.903376]  [<ffffffff81088960>] ? __init_kthread_worker+0x70/0x70
[ 1806.939888] INFO: lockdep is turned off.
[ 1806.951766] INFO: task zabbix_slimmeme:27798 blocked for more than 120 seconds.
[ 1806.963521] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1806.975059] zabbix_slimmeme D ffff88002a619070     0 27798  27355 0x00000000
[ 1806.986497]  ffff880000bb7818 0000000000000216 ffff880000000002 ffffffff8202ae38
[ 1806.997893]  ffff88002a619070 0000000000013040 ffff880000bb7fd8 ffff880000bb6010
[ 1807.008944]  0000000000013040 0000000000013040 ffff880000bb7fd8 0000000000013040
[ 1807.019692] Call Trace:
[ 1807.030165]  [<ffffffff810be1ad>] ? __module_text_address+0xd/0x60
[ 1807.040524]  [<ffffffff810be1ad>] ? __module_text_address+0xd/0x60
[ 1807.050568]  [<ffffffff810be40b>] ? is_module_text_address+0x2b/0x60
[ 1807.060389]  [<ffffffff81085958>] ? __kernel_text_address+0x58/0x80
[ 1807.069996]  [<ffffffff81070087>] ? local_bh_disable+0x17/0x20
[ 1807.079383]  [<ffffffff810b5748>] ? lock_acquire+0xd8/0x100
[ 1807.088467]  [<ffffffff819b8a14>] schedule+0x24/0x70
[ 1807.097296]  [<ffffffff819b5c7d>] schedule_timeout+0x1bd/0x220
[ 1807.105884]  [<ffffffff810b5748>] ? lock_acquire+0xd8/0x100
[ 1807.114211]  [<ffffffff819b7f11>] ? wait_for_common+0x31/0x170
[ 1807.122301]  [<ffffffff810b5bd7>] ? lock_release+0x117/0x250
[ 1807.130156]  [<ffffffff819b7fe1>] wait_for_common+0x101/0x170
[ 1807.137804]  [<ffffffff810986f0>] ? try_to_wake_up+0x310/0x310
[ 1807.145193]  [<ffffffff819b80f8>] wait_for_completion+0x18/0x20
[ 1807.152350]  [<ffffffff81083385>] flush_work+0x195/0x250
[ 1807.159275]  [<ffffffff810833a0>] ? flush_work+0x1b0/0x250
[ 1807.165957]  [<ffffffff81080400>] ? cwq_dec_nr_in_flight+0xd0/0xd0
[ 1807.172401]  [<ffffffff81451748>] tty_ldisc_flush_works+0x18/0x40
[ 1807.178634]  [<ffffffff8145198e>] tty_ldisc_release+0x2e/0x90
[ 1807.184586]  [<ffffffff8144ba07>] tty_release+0x3c7/0x590
[ 1807.190264]  [<ffffffff810b19ed>] ? trace_hardirqs_on+0xd/0x10
[ 1807.195910]  [<ffffffff819b60b9>] ? __mutex_unlock_slowpath+0x149/0x1d0
[ 1807.201455]  [<ffffffff810986f0>] ? try_to_wake_up+0x310/0x310
[ 1807.206927]  [<ffffffff8144bf94>] tty_open+0x3c4/0x5f0
[ 1807.212366]  [<ffffffff81150c88>] chrdev_open+0x98/0x170
[ 1807.217803]  [<ffffffff8109128d>] ? lg_local_unlock+0x3d/0x70
[ 1807.223255]  [<ffffffff81150bf0>] ? cdev_put+0x30/0x30
[ 1807.228678]  [<ffffffff8114b46e>] do_dentry_open+0x25e/0x310
[ 1807.234040]  [<ffffffff8114b630>] finish_open+0x30/0x50
[ 1807.239445]  [<ffffffff8115aa0e>] do_last+0x30e/0xe90
[ 1807.244805]  [<ffffffff81157d2a>] ? link_path_walk+0x9a/0x9f0
[ 1807.250170]  [<ffffffff8115b63e>] path_openat+0xae/0x4e0
[ 1807.255503]  [<ffffffff810b5bd7>] ? lock_release+0x117/0x250
[ 1807.260835]  [<ffffffff811602d4>] ? do_select+0x3f4/0x6d0
[ 1807.266174]  [<ffffffff8115bba4>] do_filp_open+0x44/0xa0
[ 1807.271504]  [<ffffffff81169453>] ? __alloc_fd+0xb3/0x150
[ 1807.276904]  [<ffffffff8114af83>] do_sys_open+0x103/0x1f0
[ 1807.282262]  [<ffffffff8114b0ac>] sys_open+0x1c/0x20
[ 1807.287579]  [<ffffffff819baf69>] system_call_fastpath+0x16/0x1b
[ 1807.292892] INFO: lockdep is turned off.

