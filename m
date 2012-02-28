Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2B1JW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:22:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41713 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab2B1JWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:22:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.204.150.88 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
Message-ID: <1330420952.1589.1.camel@lappy>
Subject: rtc: INFO: possible circular locking dependency detected
From: Sasha Levin <levinsasha928@gmail.com>
To: "a.zummo" <a.zummo@towertech.it>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, rtc-linux <rtc-linux@googlegroups.com>
Date: Tue, 28 Feb 2012 11:22:32 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've stumbled on the following lockdep warning when running trinity under the KVM tool.

(Is it the case of missing rtc->ops_lock in rtc_device_unregister?)

[ 1635.602687] ======================================================
[ 1635.603017] [ INFO: possible circular locking dependency detected ]
[ 1635.603017] 3.3.0-rc4-next-20120224-sasha-00002-g6e53fa4-dirty #24 Not tainted
[ 1635.603017] -------------------------------------------------------
[ 1635.603017] trinity/29337 is trying to acquire lock:
[ 1635.603017]  (&rtc->ops_lock){+.+.+.}, at: [<ffffffff81e209fb>] rtc_read_time+0x2b/0x60
[ 1635.603017] 
[ 1635.603017] but task is already holding lock:
[ 1635.603017]  (s_active#19){++++.+}, at: [<ffffffff81254606>] sysfs_read_file+0xd6/0x1f0
[ 1635.603017] 
[ 1635.603017] which lock already depends on the new lock.
[ 1635.603017] 
[ 1635.603017] 
[ 1635.603017] the existing dependency chain (in reverse order) is:
[ 1635.603017] 
[ 1635.603017] -> #1 (s_active#19){++++.+}:
[ 1635.603017]        [<ffffffff81112a97>] validate_chain.clone.26+0x887/0x960
[ 1635.603017]        [<ffffffff8111563b>] __lock_acquire+0x3fb/0xb80
[ 1635.603017]        [<ffffffff81116473>] lock_acquire+0xc3/0x100
[ 1635.603017]        [<ffffffff81255657>] sysfs_deactivate+0x157/0x1b0
[ 1635.603017]        [<ffffffff812560db>] sysfs_addrm_finish+0x3b/0x70
[ 1635.603017]        [<ffffffff8125420b>] sysfs_hash_and_remove+0x5b/0xb0
[ 1635.603017]        [<ffffffff81254f14>] sysfs_remove_file+0x34/0x40
[ 1635.603017]        [<ffffffff81af4102>] device_remove_file+0x12/0x20
[ 1635.603017]        [<ffffffff81af413a>] device_remove_attributes+0x2a/0x50
[ 1635.603017]        [<ffffffff81af4241>] device_remove_attrs+0x51/0x70
[ 1635.603017]        [<ffffffff81af4bd5>] device_del+0x125/0x1c0
[ 1635.603017]        [<ffffffff81af4c8d>] device_unregister+0x1d/0x60
[ 1635.603017]        [<ffffffff81e2060f>] rtc_device_unregister+0x4f/0x80
[ 1635.603017]        [<ffffffff81e23e3e>] cmos_do_probe+0x26e/0x3f0
[ 1635.603017]        [<ffffffff8396a1dc>] cmos_platform_probe+0x46/0x4e
[ 1635.603017]        [<ffffffff81af9302>] platform_drv_probe+0x12/0x20
[ 1635.603017]        [<ffffffff81af79ae>] really_probe+0x6e/0x240
[ 1635.603017]        [<ffffffff81af7cd9>] driver_probe_device+0x49/0xa0
[ 1635.603017]        [<ffffffff81af7dd3>] __driver_attach+0xa3/0xb0
[ 1635.603017]        [<ffffffff81af611e>] bus_for_each_dev+0x5e/0x90
[ 1635.603017]        [<ffffffff81af7f19>] driver_attach+0x19/0x20
[ 1635.603017]        [<ffffffff81af6ad8>] bus_add_driver+0x148/0x2a0
[ 1635.603017]        [<ffffffff81af878f>] driver_register+0x6f/0x130
[ 1635.603017]        [<ffffffff81af9e81>] platform_driver_register+0x41/0x50
[ 1635.603017]        [<ffffffff8395e51e>] platform_driver_probe+0x1c/0x96
[ 1635.603017]        [<ffffffff8396a168>] cmos_init+0x3c/0x6a
[ 1635.603017]        [<ffffffff8391fca2>] do_one_initcall+0x7a/0x135
[ 1635.603017]        [<ffffffff8391fea6>] kernel_init+0x149/0x1df
[ 1635.603017]        [<ffffffff826e28b4>] kernel_thread_helper+0x4/0x10
[ 1635.603017] 
[ 1635.603017] -> #0 (&rtc->ops_lock){+.+.+.}:
[ 1635.603017]        [<ffffffff811121e1>] check_prev_add+0x6b1/0x6e0
[ 1635.603017]        [<ffffffff81112a97>] validate_chain.clone.26+0x887/0x960
[ 1635.603017]        [<ffffffff8111563b>] __lock_acquire+0x3fb/0xb80
[ 1635.603017]        [<ffffffff81116473>] lock_acquire+0xc3/0x100
[ 1635.603017]        [<ffffffff826dcd05>] __mutex_lock_common+0x65/0x5b0
[ 1635.603017]        [<ffffffff826dd380>] mutex_lock_interruptible_nested+0x40/0x50
[ 1635.603017]        [<ffffffff81e209fb>] rtc_read_time+0x2b/0x60
[ 1635.603017]        [<ffffffff81e22d75>] rtc_sysfs_show_time+0x15/0x40
[ 1635.603017]        [<ffffffff81af38c2>] dev_attr_show+0x22/0x50
[ 1635.603017]        [<ffffffff81254640>] sysfs_read_file+0x110/0x1f0
[ 1635.603017]        [<ffffffff811db283>] vfs_read+0xc3/0x180
[ 1635.603017]        [<ffffffff811db62f>] sys_read+0x4f/0xa0
[ 1635.603017]        [<ffffffff826e1479>] system_call_fastpath+0x16/0x1b
[ 1635.603017] 
[ 1635.603017] other info that might help us debug this:
[ 1635.603017] 
[ 1635.603017]  Possible unsafe locking scenario:
[ 1635.603017] 
[ 1635.603017]        CPU0                    CPU1
[ 1635.603017]        ----                    ----
[ 1635.603017]   lock(s_active#19);
[ 1635.603017]                                lock(&rtc->ops_lock);
[ 1635.603017]                                lock(s_active#19);
[ 1635.603017]   lock(&rtc->ops_lock);
[ 1635.603017] 
[ 1635.603017]  *** DEADLOCK ***
[ 1635.603017] 
[ 1635.603017] 2 locks held by trinity/29337:
[ 1635.603017]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81254571>] sysfs_read_file+0x41/0x1f0
[ 1635.603017]  #1:  (s_active#19){++++.+}, at: [<ffffffff81254606>] sysfs_read_file+0xd6/0x1f0
[ 1635.603017] 
[ 1635.603017] stack backtrace:
[ 1635.603017] Pid: 29337, comm: trinity Not tainted 3.3.0-rc4-next-20120224-sasha-00002-g6e53fa4-dirty #24
[ 1635.603017] Call Trace:
[ 1635.603017]  [<ffffffff81110ecf>] print_circular_bug+0x10f/0x120
[ 1635.603017]  [<ffffffff811121e1>] check_prev_add+0x6b1/0x6e0
[ 1635.603017]  [<ffffffff81112a97>] validate_chain.clone.26+0x887/0x960
[ 1635.603017]  [<ffffffff8111563b>] __lock_acquire+0x3fb/0xb80
[ 1635.603017]  [<ffffffff810e9115>] ? sched_clock_local+0x25/0x90
[ 1635.603017]  [<ffffffff8107a3a5>] ? pvclock_clocksource_read+0x55/0xd0
[ 1635.603017]  [<ffffffff81116473>] lock_acquire+0xc3/0x100
[ 1635.603017]  [<ffffffff81e209fb>] ? rtc_read_time+0x2b/0x60
[ 1635.603017]  [<ffffffff826dcd05>] __mutex_lock_common+0x65/0x5b0
[ 1635.603017]  [<ffffffff81e209fb>] ? rtc_read_time+0x2b/0x60
[ 1635.603017]  [<ffffffff81e209fb>] ? rtc_read_time+0x2b/0x60
[ 1635.603017]  [<ffffffff826dd380>] mutex_lock_interruptible_nested+0x40/0x50
[ 1635.603017]  [<ffffffff81e209fb>] rtc_read_time+0x2b/0x60
[ 1635.603017]  [<ffffffff81e22d75>] rtc_sysfs_show_time+0x15/0x40
[ 1635.603017]  [<ffffffff81af38c2>] dev_attr_show+0x22/0x50
[ 1635.603017]  [<ffffffff81254606>] ? sysfs_read_file+0xd6/0x1f0
[ 1635.603017]  [<ffffffff8117843f>] ? __get_free_pages+0xf/0x40
[ 1635.603017]  [<ffffffff81254640>] sysfs_read_file+0x110/0x1f0
[ 1635.603017]  [<ffffffff811db283>] vfs_read+0xc3/0x180
[ 1635.603017]  [<ffffffff811db62f>] sys_read+0x4f/0xa0
[ 1635.603017]  [<ffffffff826e1479>] system_call_fastpath+0x16/0x1b

