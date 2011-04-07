Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1DGToI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:44:08 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:37880 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab1DGToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:44:06 -0400
Date: Thu, 7 Apr 2011 15:44:03 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, autofs@linux.kernel.org
Cc: Ian Kent <raven@themaw.net>
Subject: Lockdep splat in autofs with 2.6.39-rc2
Message-ID: <20110407194403.GA29404@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just saw this on 2.6.39-rc2 after half a day or so of uptime.  I've
never seen it before today so it may be a regression from 2.6.38.
Nothing seems have failed as a result.  Please let me know if you
need any more info.

  =============================================
  [ INFO: possible recursive locking detected ]
  2.6.39-rc2 #177
  ---------------------------------------------
  automount/23324 is trying to acquire lock:
   (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa034ea28>] autofs4_expire_indirect+0x307/0x484 [autofs4]
  
  but task is already holding lock:
   (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa034ea28>] autofs4_expire_indirect+0x307/0x484 [autofs4]
  
  other info that might help us debug this:
  2 locks held by automount/23324:
   #0:  (&(&sbi->lookup_lock)->rlock){+.+...}, at: [<ffffffffa034e9aa>] autofs4_expire_indirect+0x289/0x484 [autofs4]
   #1:  (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa034ea28>] autofs4_expire_indirect+0x307/0x484 [autofs4]
  
  stack backtrace:
  Pid: 23324, comm: automount Not tainted 2.6.39-rc2 #177
  Call Trace:
   [<ffffffff81061dc7>] __lock_acquire+0xc83/0xcfa
   [<ffffffff8105f200>] ? static_obj+0x3d/0x4d
   [<ffffffff81062073>] ? lock_release_non_nested+0x1c8/0x227
   [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
   [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
   [<ffffffff81061e95>] lock_acquire+0x57/0x6d
   [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
   [<ffffffff8131f4e3>] _raw_spin_lock_nested+0x39/0x48
   [<ffffffffa034ea28>] ? autofs4_expire_indirect+0x307/0x484 [autofs4]
   [<ffffffff8131fb10>] ? _raw_spin_unlock+0x3e/0x4b
   [<ffffffffa034ea28>] autofs4_expire_indirect+0x307/0x484 [autofs4]
   [<ffffffffa034f184>] ? autofs_dev_ioctl_askumount+0x2d/0x2d [autofs4]
   [<ffffffffa034edbd>] autofs4_do_expire_multi+0x30/0xe9 [autofs4]
   [<ffffffffa034f184>] ? autofs_dev_ioctl_askumount+0x2d/0x2d [autofs4]
   [<ffffffffa034f184>] ? autofs_dev_ioctl_askumount+0x2d/0x2d [autofs4]
   [<ffffffffa034f19e>] autofs_dev_ioctl_expire+0x1a/0x1c [autofs4]
   [<ffffffffa034f738>] _autofs_dev_ioctl+0x2a3/0x348 [autofs4]
   [<ffffffffa034f7eb>] autofs_dev_ioctl+0xe/0x12 [autofs4]
   [<ffffffff810c750d>] do_vfs_ioctl+0x45f/0x4ae
   [<ffffffff810bab4e>] ? rcu_read_unlock+0x21/0x23
   [<ffffffff810c759e>] sys_ioctl+0x42/0x65
   [<ffffffff8132463b>] system_call_fastpath+0x16/0x1b

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
