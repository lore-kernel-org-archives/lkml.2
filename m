Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab1GAMpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:45:44 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:50473 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1GAMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:45:42 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.9
Message-ID: <4E0DC172.9010504@tudelft.nl>
Date: Fri, 01 Jul 2011 14:45:38 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Regression 3.0-rc5+ : khubd blocked
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I've come across to what looks like a regression in the kernel a
few commits after 3.0-rc5.

When I turn off a usb hub, to which my mouse and keyboard are connected,
and then turn it on again, they are not detected again. After unplugging
it and waiting a few minutes I get a "task khubd:621 blocked for more
than 120 seconds."

I haven't investigated much. It seems reproducible here on my x86_64
laptop. It doesn't seem to happen on a 3.0-rc4. Maybe important, my
kernel already has commit 2e34b429a404675dc4fc4ad2ee339eea028da3ca
"Merge branch 'usb-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6"

Let me know if you need me to investigate more, or maybe there is
already a fix for that bug?

Below is the whole message of the hung. 

Cheers,
Éric


Jul  1 14:08:16 dutifh kernel: INFO: task khubd:621 blocked for more than 120 seconds.
Jul  1 14:08:16 dutifh kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  1 14:08:16 dutifh kernel: khubd           D ffff88013a30dfd8     0   621      2 0x00000000
Jul  1 14:08:16 dutifh kernel: ffff88013a30db00 0000000000000046 ffff88013a30da10 ffffffffa00dd852
Jul  1 14:08:16 dutifh kernel: ffff88013b954320 ffff88013a30dfd8 ffff88013a30dfd8 ffff88013a30dfd8
Jul  1 14:08:16 dutifh kernel: ffff88013b891660 ffff88013b954320 ffff8800bb0084c0 dead000000100100
Jul  1 14:08:16 dutifh kernel: Call Trace:
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00dd852>] ? usb_hcd_giveback_urb+0x72/0xe0 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffff8109e24f>] ? __rcu_read_unlock+0x2f/0x200
Jul  1 14:08:16 dutifh kernel: [<ffffffff81388634>] __mutex_lock_slowpath+0xf4/0x190
Jul  1 14:08:16 dutifh kernel: [<ffffffff8138806d>] mutex_lock+0x1d/0x40
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00e1e22>] usb_set_interface+0x62/0x250 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00e3b9f>] usb_unbind_interface+0x10f/0x180 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffff81269217>] __device_release_driver+0x77/0xd0
Jul  1 14:08:16 dutifh kernel: [<ffffffff81269297>] device_release_driver+0x27/0x40
Jul  1 14:08:16 dutifh kernel: [<ffffffff81268d83>] bus_remove_device+0x73/0xb0
Jul  1 14:08:16 dutifh kernel: [<ffffffff81266845>] device_del+0x125/0x1a0
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00e192c>] usb_disable_device+0x7c/0x1a0 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00d9f80>] usb_disconnect+0xa0/0x140 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00d9f5c>] usb_disconnect+0x7c/0x140 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00dbe6e>] hub_thread+0xa9e/0x1350 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffff8105ff70>] ? abort_exclusive_wait+0xb0/0xb0
Jul  1 14:08:16 dutifh kernel: [<ffffffffa00db3d0>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
Jul  1 14:08:16 dutifh kernel: [<ffffffff8105f7a7>] kthread+0x87/0x90
Jul  1 14:08:16 dutifh kernel: [<ffffffff8138b424>] kernel_thread_helper+0x4/0x10
Jul  1 14:08:16 dutifh kernel: [<ffffffff8105f720>] ? kthread_worker_fn+0x190/0x190
Jul  1 14:08:16 dutifh kernel: [<ffffffff8138b420>] ? gs_change+0x13/0x13
