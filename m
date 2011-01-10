Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1AJPWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:22:18 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56478 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab1AJPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:22:14 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Thread-Index: Acuw2h/2UfcNWK5vQyin+ahQsBtg2w==
Date: Mon, 10 Jan 2011 20:51:59 +0530
Message-ID: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
Subject: [REPORT] BUG: spinlock recursion on CPU#0, init/1
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On latest mainline commit I seeing a regression when rootfs
is mounted on NFS. Not sure if it's already known regression.

Anybody is aware of this one ?

--------------------------------------
Uncompressing Linux... done, booting the kernel.
Linux version 2.6.37-03766-g0390214 (a0393909@a0393909-desktop) (gcc
version 4.4.1 (Sourcery G++ Lite 2010q1-202) ) #44 SMP Mon Jan 10 20:41:27
IST 2011

[....]

VFS: Mounted root (nfs filesystem) on device 0:13.
Freeing init memory: 296K
BUG: spinlock recursion on CPU#0, init/1
 lock: ef5a1e0c, .magic: dead4ead, .owner: init/1, .owner_cpu: 0
[<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024ce90>]
(do_raw_spin_lock+0x48/0x158)
[<c024ce90>] (do_raw_spin_lock+0x48/0x158) from [<c012f4e0>]
(nameidata_dentry_drop_rcu+0x84/0x17c)
[<c012f4e0>] (nameidata_dentry_drop_rcu+0x84/0x17c) from [<c012f608>]
(d_revalidate+0x30/0x58)
[<c012f608>] (d_revalidate+0x30/0x58) from [<c0132120>]
(link_path_walk+0xb44/0xb64)
[<c0132120>] (link_path_walk+0xb44/0xb64) from [<c0132338>]
(do_path_lookup+0x44/0xcc)
[<c0132338>] (do_path_lookup+0x44/0xcc) from [<c0132f08>]
(do_filp_open+0xc8/0x56c)
[<c0132f08>] (do_filp_open+0xc8/0x56c) from [<c0124828>]
(do_sys_open+0x58/0xe4)
[<c0124828>] (do_sys_open+0x58/0xe4) from [<c005c240>]
(ret_fast_syscall+0x0/0x3c)
BUG: spinlock lockup on CPU#0, init/1, ef5a1e0c
[<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024cf84>]
(do_raw_spin_lock+0x13c/0x158)
[<c024cf84>] (do_raw_spin_lock+0x13c/0x158) from [<c012f4e0>]
(nameidata_dentry_drop_rcu+0x84/0x17c)
[<c012f4e0>] (nameidata_dentry_drop_rcu+0x84/0x17c) from [<c012f608>]
(d_revalidate+0x30/0x58)
[<c012f608>] (d_revalidate+0x30/0x58) from [<c0132120>]
(link_path_walk+0xb44/0xb64)
[<c0132120>] (link_path_walk+0xb44/0xb64) from [<c0132338>]
(do_path_lookup+0x44/0xcc)
[<c0132338>] (do_path_lookup+0x44/0xcc) from [<c0132f08>]
(do_filp_open+0xc8/0x56c)
[<c0132f08>] (do_filp_open+0xc8/0x56c) from [<c0124828>]
(do_sys_open+0x58/0xe4)
[<c0124828>] (do_sys_open+0x58/0xe4) from [<c005c240>]
(ret_fast_syscall+0x0/0x3c)
BUG: spinlock lockup on CPU#1, kworker/u:2/499, c05d3c80
[<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024cf84>]
(do_raw_spin_lock+0x13c/0x158)
[<c024cf84>] (do_raw_spin_lock+0x13c/0x158) from [<c014afac>]
(exit_fs+0x2c/0x84)
[<c014afac>] (exit_fs+0x2c/0x84) from [<c0098274>] (do_exit+0x254/0x674)
[<c0098274>] (do_exit+0x254/0x674) from [<c00b0944>] (kthread+0x88/0x8c)
[<c00b0944>] (kthread+0x88/0x8c) from [<c005d490>]
(kernel_thread_exit+0x0/0x8)

--------------------------------------

Regards,
Santosh
