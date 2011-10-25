Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab1JYMsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:48:11 -0400
Received: from krak.alatek.krakow.pl ([46.170.108.42]:4029 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab1JYMsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:48:08 -0400
From: Pawel Sikora <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, raven@themaw.net,
        arekm@pld-linux.org
Subject: INFO: possible recursive locking detected: autofs4_expire_indirect()
Date: Tue, 25 Oct 2011 14:48:01 +0200
Message-ID: <3620801.NcMcO2jnH8@pawels>
User-Agent: KMail/4.7.2 (Linux/3.0.6-2; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the nfs client/server with fresh 3.0.8 + vserver + enabled debug options reports attached info.
afaics, the vserver doesn't change autofs code, so it looks like a pure vanilla problem.

BR,
Paweł.

[ 3708.715749] =============================================
[ 3708.715940] [ INFO: possible recursive locking detected ]
[ 3708.716040] 3.0.8-vs2.3.1-dirty #6
[ 3708.716131] ---------------------------------------------
[ 3708.716230] automount/29215 is trying to acquire lock:
[ 3708.716301]  (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]
[ 3708.716301] but task is already holding lock:
[ 3708.716301]  (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]
[ 3708.716301] other info that might help us debug this:
[ 3708.716301]  Possible unsafe locking scenario:
[ 3708.716301]
[ 3708.716301]        CPU0
[ 3708.716301]        ----
[ 3708.716301]   lock(&(&dentry->d_lock)->rlock);
[ 3708.716301]   lock(&(&dentry->d_lock)->rlock);
[ 3708.716301]
[ 3708.716301]  *** DEADLOCK ***
[ 3708.716301]
[ 3708.716301]  May be due to missing lock nesting notation
[ 3708.716301]
[ 3708.716301] 2 locks held by automount/29215:
[ 3708.716301]  #0:  (&(&sbi->lookup_lock)->rlock){+.+...}, at: [<ffffffffa0214f61>] autofs4_expire_indirect+0x91/0x4e0 [autofs4]
[ 3708.716301]  #1:  (&(&dentry->d_lock)->rlock/1){+.+...}, at: [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]
[ 3708.716301] stack backtrace:
[ 3708.716301] Pid: 29215, comm: automount Not tainted 3.0.8-vs2.3.1-dirty #6
[ 3708.716301] Call Trace:
[ 3708.716301]  [<ffffffff810925d6>] __lock_acquire+0x1606/0x1b50
[ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]  [<ffffffff81092c6a>] ? lock_release_non_nested+0x14a/0x310
[ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]  [<ffffffff810930c5>] lock_acquire+0x85/0x110
[ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]  [<ffffffffa02151bd>] ? autofs4_expire_indirect+0x2ed/0x4e0 [autofs4]
[ 3708.716301]  [<ffffffff81453c1a>] _raw_spin_lock_nested+0x2a/0x40
[ 3708.716301]  [<ffffffffa0214fb0>] ? autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]  [<ffffffff81454386>] ? _raw_spin_unlock+0x26/0x30
[ 3708.716301]  [<ffffffff8110f830>] ? might_fault+0x40/0x90
[ 3708.716301]  [<ffffffffa0214fb0>] autofs4_expire_indirect+0xe0/0x4e0 [autofs4]
[ 3708.716301]  [<ffffffffa021568d>] autofs4_do_expire_multi+0xed/0x130 [autofs4]
[ 3708.716301]  [<ffffffffa0215a70>] ? autofs_dev_ioctl_askumount+0x30/0x30 [autofs4]
[ 3708.716301]  [<ffffffffa0215a8a>] autofs_dev_ioctl_expire+0x1a/0x20 [autofs4]
[ 3708.716301]  [<ffffffffa0216063>] _autofs_dev_ioctl+0x273/0x360 [autofs4]
[ 3708.716301]  [<ffffffffa021615e>] autofs_dev_ioctl+0xe/0x20 [autofs4]
[ 3708.716301]  [<ffffffff8115dc56>] do_vfs_ioctl+0x96/0x560
[ 3708.716301]  [<ffffffff8114c289>] ? fget_light+0x99/0x130
[ 3708.716301]  [<ffffffff8114c227>] ? fget_light+0x37/0x130
[ 3708.716301]  [<ffffffff8115e1b1>] sys_ioctl+0x91/0xa0
[ 3708.716301]  [<ffffffff8145bdbb>] system_call_fastpath+0x16/0x1b

