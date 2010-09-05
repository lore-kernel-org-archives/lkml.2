Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0IELba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 07:31:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36226 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0IELb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 07:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BQ5EH+IWoXjzmN/pmPl9jpLO+PptqwWBzXRAmrnNsZ1X2JP1h5d/lbsNA4BfDoC13P
         9y2YipvRPu6zglaL4+MELpGTAlEObR3BoAu4tryxZMrO7jr4TDPKOTFwZWhTXrV+ZAwr
         18oIOFtDUnweM0TOLtlhNblWfTaoc0sQ6nPsY=
Date: Sun, 5 Sep 2010 13:31:21 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Subject: [Bug] possible circular locking in reiserfs_unpack
Message-ID: <20100905113121.GA1876@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I get this warning on every lilo write with 2.6.35.4 and a bit/git
later too.

Jarek P.

[   92.766639] =======================================================
[   92.767222] [ INFO: possible circular locking dependency detected ]
[   92.767222] 2.6.35c #13
[   92.767222] -------------------------------------------------------
[   92.767222] lilo/1606 is trying to acquire lock:
[   92.767222]  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<d0329450>] reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222] 
[   92.767222] but task is already holding lock:
[   92.767222]  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a268>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222] 
[   92.767222] which lock already depends on the new lock.
[   92.767222] 
[   92.767222] 
[   92.767222] the existing dependency chain (in reverse order) is:
[   92.767222] 
[   92.767222] -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
[   92.767222]        [<c1056347>] lock_acquire+0x67/0x80
[   92.767222]        [<c12f083d>] __mutex_lock_common+0x4d/0x410
[   92.767222]        [<c12f0c58>] mutex_lock_nested+0x18/0x20
[   92.767222]        [<d032a268>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222]        [<d0329e9a>] reiserfs_lookup_privroot+0x2a/0x90 [reiserfs]
[   92.767222]        [<d0316b81>] reiserfs_fill_super+0x941/0xe60 [reiserfs]
[   92.767222]        [<c10b7d17>] get_sb_bdev+0x117/0x170
[   92.767222]        [<d0313e21>] get_super_block+0x21/0x30 [reiserfs]
[   92.767222]        [<c10b74ba>] vfs_kern_mount+0x6a/0x1b0
[   92.767222]        [<c10b7659>] do_kern_mount+0x39/0xe0
[   92.767222]        [<c10cebe0>] do_mount+0x340/0x790
[   92.767222]        [<c10cf0b4>] sys_mount+0x84/0xb0
[   92.767222]        [<c12f25cd>] syscall_call+0x7/0xb
[   92.767222] 
[   92.767222] -> #0 (&sb->s_type->i_mutex_key#8){+.+.+.}:
[   92.767222]        [<c1056186>] __lock_acquire+0x1026/0x1180
[   92.767222]        [<c1056347>] lock_acquire+0x67/0x80
[   92.767222]        [<c12f083d>] __mutex_lock_common+0x4d/0x410
[   92.767222]        [<c12f0c58>] mutex_lock_nested+0x18/0x20
[   92.767222]        [<d0329450>] reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]        [<d0329772>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   92.767222]        [<c10c3228>] vfs_ioctl+0x28/0xa0
[   92.767222]        [<c10c3c5d>] do_vfs_ioctl+0x32d/0x5c0
[   92.767222]        [<c10c3f53>] sys_ioctl+0x63/0x70
[   92.767222]        [<c12f25cd>] syscall_call+0x7/0xb
[   92.767222] 
[   92.767222] other info that might help us debug this:
[   92.767222] 
[   92.767222] 1 lock held by lilo/1606:
[   92.767222]  #0:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a268>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222] 
[   92.767222] stack backtrace:
[   92.767222] Pid: 1606, comm: lilo Not tainted 2.6.35c #13
[   92.767222] Call Trace:
[   92.767222]  [<c12ef64a>] ? printk+0x18/0x1e
[   92.767222]  [<c1054212>] print_circular_bug+0xd2/0xe0
[   92.767222]  [<c1056186>] __lock_acquire+0x1026/0x1180
[   92.767222]  [<c1089489>] ? __generic_file_aio_write+0x1c9/0x550
[   92.767222]  [<c1056347>] lock_acquire+0x67/0x80
[   92.767222]  [<d0329450>] ? reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<c12f083d>] __mutex_lock_common+0x4d/0x410
[   92.767222]  [<d0329450>] ? reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<c12f0b08>] ? __mutex_lock_common+0x318/0x410
[   92.767222]  [<d032a268>] ? reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222]  [<c12f0c58>] mutex_lock_nested+0x18/0x20
[   92.767222]  [<d0329450>] ? reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<d0329450>] reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<c12f0c58>] ? mutex_lock_nested+0x18/0x20
[   92.767222]  [<d0329772>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   92.767222]  [<d0329500>] ? reiserfs_ioctl+0x0/0x320 [reiserfs]
[   92.767222]  [<c10c3228>] vfs_ioctl+0x28/0xa0
[   92.767222]  [<c10c3c5d>] do_vfs_ioctl+0x32d/0x5c0
[   92.767222]  [<c109a428>] ? might_fault+0x88/0x90
[   92.767222]  [<c109a3e2>] ? might_fault+0x42/0x90
[   92.767222]  [<c10b6638>] ? fget_light+0xf8/0x2f0
[   92.767222]  [<c10c3f53>] sys_ioctl+0x63/0x70
[   92.767222]  [<c12f25cd>] syscall_call+0x7/0xb
