Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2JDB0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:26:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39471 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2JDB0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:26:19 -0400
MIME-Version: 1.0
Date: Wed, 3 Oct 2012 21:26:17 -0400
Message-ID: <CAHFgRy_ju3ybBGyApRXhke6=DW9B=LOZUVrjV0KfZbFFcG4PZA@mail.gmail.com>
Subject: 3.6.0+ (GIT) -- BUG: sleeping function called from invalid context at
 kernel/mutex.c:269 in_atomic(): 0, irqs_disabled(): 1, pid: 3561, name: pm-suspend
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
numa_remove_cpu cpu 1 node 0: mask now 0
Broke affinity for irq 46
smpboot: CPU 1 is now offline
BUG: sleeping function called from invalid context at kernel/mutex.c:269
in_atomic(): 0, irqs_disabled(): 1, pid: 3561, name: pm-suspend
4 locks held by pm-suspend/3561:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8113cab6>]
sysfs_write_file+0x37/0x121
 #1:  (s_active#98){.+.+.+}, at: [<ffffffff8113cb50>]
sysfs_write_file+0xd1/0x121
 #2:  (autosleep_lock){+.+.+.}, at: [<ffffffff810616c2>]
pm_autosleep_lock+0x12/0x14
 #3:  (pm_mutex){+.+.+.}, at: [<ffffffff8105c06c>] pm_suspend+0x38/0x1b8
irq event stamp: 103458
hardirqs last  enabled at (103457): [<ffffffff81460461>]
__mutex_unlock_slowpath+0x101/0x125
hardirqs last disabled at (103458): [<ffffffff8105be25>]
arch_suspend_disable_irqs+0xa/0xc
softirqs last  enabled at (103196): [<ffffffff8103445d>]
__do_softirq+0x12a/0x155
softirqs last disabled at (103171): [<ffffffff8146836c>] call_softirq+0x1c/0x30
Pid: 3561, comm: pm-suspend Not tainted 3.6.0+ #26
Call Trace:
 [<ffffffff8106b64e>] ? print_irqtrace_events+0x9d/0xa1
 [<ffffffff8104efcd>] __might_sleep+0x19f/0x1a8
 [<ffffffff81460345>] mutex_lock_nested+0x20/0x3b
 [<ffffffff81391cbb>] ledtrig_cpu+0x3b/0x7b
 [<ffffffff81391d29>] ledtrig_cpu_syscore_suspend+0xe/0x15
 [<ffffffff813329e9>] syscore_suspend+0x78/0xfd
 [<ffffffff8105bf42>] suspend_devices_and_enter+0x10f/0x201
 [<ffffffff8105c133>] pm_suspend+0xff/0x1b8
 [<ffffffff8105b4fa>] state_store+0x43/0x6c
 [<ffffffff811c5ba6>] kobj_attr_store+0xf/0x1b
 [<ffffffff8113cb68>] sysfs_write_file+0xe9/0x121
 [<ffffffff810e48a3>] vfs_write+0x9b/0xfd
 [<ffffffff8106bc63>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810e4ac6>] sys_write+0x4d/0x7a
 [<ffffffff814672f4>] tracesys+0xdd/0xe2
