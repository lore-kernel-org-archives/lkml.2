Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1HVNJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:09:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56421 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1HVNJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:09:15 -0400
MIME-Version: 1.0
In-Reply-To: <4E51CFD8.2090508@gmail.com>
References: <4E51CFD8.2090508@gmail.com>
Date: Mon, 22 Aug 2011 09:09:14 -0400
Message-ID: <CA+5PVA6KUMDEygjxrqwvpRDNfJ3WobUs7rwyP+pZrX9-atZUgw@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency detected 3.1.0-rc2-00190-g3210d19
From: Josh Boyer <jwboyer@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 11:41 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> yikes.. seems the latest Mainline doesnt like rhythmbox or vice versa.
>
> [   68.476921] =======================================================
> [   68.476926] [ INFO: possible circular locking dependency detected ]
> [   68.476929] 3.1.0-rc2-00190-g3210d19 #7
> [   68.476931] -------------------------------------------------------
> [   68.476934] rhythmbox/1597 is trying to acquire lock:
> [   68.476937]  (&sb->s_type->i_mutex_key#8){+.+.+.}, at:
> [<ffffffff8119702e>] ext4_evict_inode+0x76/0x33c
> [   68.476950]
> [   68.476950] but task is already holding lock:
> [   68.476953]  (&mm->mmap_sem){++++++}, at: [<ffffffff810fcb08>]
> sys_munmap+0x3b/0x60
> [   68.476960]
> [   68.476961] which lock already depends on the new lock.
> [   68.476962]
> [   68.476964]
> [   68.476965] the existing dependency chain (in reverse order) is:
> [   68.476968]
> [   68.476968] -> #1 (&mm->mmap_sem){++++++}:
> [   68.476973]        [<ffffffff810819d0>] lock_acquire+0x106/0x15b
> [   68.476979]        [<ffffffff810f5fa3>] might_fault+0x89/0xac
> [   68.476984]        [<ffffffff8113716b>] filldir+0x6f/0xc7
> [   68.476990]        [<ffffffff8118df2b>] call_filldir+0x96/0xbd
> [   68.476994]        [<ffffffff8118e258>] ext4_readdir+0x1b4/0x515
> [   68.476998]        [<ffffffff811373c0>] vfs_readdir+0x7b/0xb1
> [   68.477003]        [<ffffffff811374dc>] sys_getdents+0x7e/0xce
> [   68.477007]        [<ffffffff814c6042>] system_call_fastpath+0x16/0x1b
> [   68.477008]
> [   68.477008] -> #0 (&sb->s_type->i_mutex_key#8){+.+.+.}:
> [   68.477008]        [<ffffffff810811fa>] __lock_acquire+0xa06/0xce3
> [   68.477008]        [<ffffffff810819d0>] lock_acquire+0x106/0x15b
> [   68.477008]        [<ffffffff814bd955>] __mutex_lock_common+0x61/0x380
> [   68.477008]        [<ffffffff814bdd83>] mutex_lock_nested+0x40/0x45
> [   68.477008]        [<ffffffff8119702e>] ext4_evict_inode+0x76/0x33c
> [   68.477008]        [<ffffffff8113d249>] evict+0x99/0x153
> [   68.477008]        [<ffffffff8113d494>] iput+0x191/0x19a
> [   68.477008]        [<ffffffff8113a155>] dentry_kill+0x123/0x145
> [   68.477008]        [<ffffffff8113a564>] dput+0xf7/0x107
> [   68.477008]        [<ffffffff8112970c>] fput+0x1ce/0x1e6
> [   68.477008]        [<ffffffff810fb7cf>] remove_vma+0x56/0x87
> [   68.477008]        [<ffffffff810fc995>] do_munmap+0x2f2/0x30b
> [   68.477008]        [<ffffffff810fcb16>] sys_munmap+0x49/0x60
> [   68.477008]        [<ffffffff814c6042>] system_call_fastpath+0x16/0x1b
> [   68.477008]
> [   68.477008] other info that might help us debug this:
> [   68.477008]
> [   68.477008]  Possible unsafe locking scenario:
> [   68.477008]
> [   68.477008]        CPU0                    CPU1
> [   68.477008]        ----                    ----
> [   68.477008]   lock(&mm->mmap_sem);
> [   68.477008] lock(&sb->s_type->i_mutex_key);
> [   68.477008]                                lock(&mm->mmap_sem);
> [   68.477008]   lock(&sb->s_type->i_mutex_key);
> [   68.477008]
> [   68.477008]  *** DEADLOCK ***
> [   68.477008]
> [   68.477008] 1 lock held by rhythmbox/1597:
> [   68.477008]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810fcb08>]
> sys_munmap+0x3b/0x60
> [   68.477008]
> [   68.477008] stack backtrace:
> [   68.477008] Pid: 1597, comm: rhythmbox Not tainted
> 3.1.0-rc2-00190-g3210d19 #7

We've had a report of this on 3.0.1 as well.  Slightly different
scenario and fs, but the locks in question are the same.
https://bugzilla.redhat.com/show_bug.cgi?id=730998

It seems that with CONFIG_PROVE_LOCKING on, might_fault will always
attempt to grab mm->mmap_sem.  The common flow here is that getdents
calls filldir, which calls copy_to_user, which is what is calling
might_fault.

Beyond that, I'm a bit over my head at the moment because I don't know
if the VFS is right and we just need some more lockdep annotations or
if there really is a problem.

josh
