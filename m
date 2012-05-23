Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab2EWA05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:26:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab2EWA0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:26:52 -0400
Date: Tue, 22 May 2012 20:26:45 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@linux/intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: 3.4+ tty lockdep trace
Message-ID: <20120523002645.GA3490@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@linux/intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From v3.4-4413-gfb09baf

[   43.374948] =============================================
[   43.374991] [ INFO: possible recursive locking detected ]
[   43.375035] 3.4.0+ #24 Not tainted
[   43.375065] ---------------------------------------------
[   43.375108] sshd/639 is trying to acquire lock:
[   43.375157]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656d57>] tty_lock+0x37/0x80
[   43.375216] 
[   43.375216] but task is already holding lock:
[   43.375268]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656d57>] tty_lock+0x37/0x80
[   43.375327] 
[   43.375327] other info that might help us debug this:
[   43.375378]  Possible unsafe locking scenario:
[   43.375378] 
[   43.375425]        CPU0
[   43.375447]        ----
[   43.375471]   lock(&tty->legacy_mutex);
[   43.375504]   lock(&tty->legacy_mutex);
[   43.375536] 
[   43.375536]  *** DEADLOCK ***
[   43.375536] 
[   43.375583]  May be due to missing lock nesting notation
[   43.375583] 
[   43.375637] 2 locks held by sshd/639:
[   43.375675]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff813b0243>] tty_release+0x1c3/0x5d0
[   43.375740]  #1:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656d57>] tty_lock+0x37/0x80
[   43.375802] 
[   43.375802] stack backtrace:
[   43.375841] Pid: 639, comm: sshd Not tainted 3.4.0+ #24
[   43.375882] Call Trace:
[   43.377572]  [<ffffffff810b4604>] __lock_acquire+0x1584/0x1aa0
[   43.379286]  [<ffffffff810b51e2>] lock_acquire+0x92/0x1f0
[   43.380995]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
[   43.382700]  [<ffffffff816534f1>] mutex_lock_nested+0x71/0x3b0
[   43.384403]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
[   43.386094]  [<ffffffff81085521>] ? get_parent_ip+0x11/0x50
[   43.387794]  [<ffffffff81656d57>] ? tty_lock+0x37/0x80
[   43.389480]  [<ffffffff8165a68d>] ? sub_preempt_count+0x6d/0xd0
[   43.391176]  [<ffffffff813b0243>] ? tty_release+0x1c3/0x5d0
[   43.393003]  [<ffffffff81656d57>] tty_lock+0x37/0x80
[   43.394867]  [<ffffffff81656dc3>] tty_lock_pair+0x23/0x5c
[   43.396671]  [<ffffffff813b024e>] tty_release+0x1ce/0x5d0
[   43.398462]  [<ffffffff811a765c>] fput+0x12c/0x300
[   43.400292]  [<ffffffff811a23a9>] filp_close+0x69/0xa0
[   43.402084]  [<ffffffff811a2f2d>] sys_close+0xad/0x1a0
[   43.403871]  [<ffffffff8165e652>] system_call_fastpath+0x16/0x1b

