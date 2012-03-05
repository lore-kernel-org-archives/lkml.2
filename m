Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2CEVXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:23:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2CEVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:23:36 -0500
Date: Mon, 5 Mar 2012 13:23:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: Re: Linus GIT (3.3.0-rc6+) -- INFO: possible circular locking
 dependency detected
Message-Id: <20120305132334.e3fc92cb.akpm@linux-foundation.org>
In-Reply-To: <CAHFgRy-V3ZFK6QrC2++Rvyi4e_f-03Xdr9sj4PUJORVq21GiEw@mail.gmail.com>
References: <CAHFgRy-V3ZFK6QrC2++Rvyi4e_f-03Xdr9sj4PUJORVq21GiEw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012 16:08:55 -0500
Miles Lane <miles.lane@gmail.com> wrote:

> [  107.839605] [ INFO: possible circular locking dependency detected ]
> [  107.839608] 3.3.0-rc6+ #14 Not tainted
> [  107.839609] -------------------------------------------------------
> [  107.839611] gvfsd-metadata/2314 is trying to acquire lock:
> [  107.839612]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at:
> [<ffffffff810ae65a>] generic_file_aio_write+0x45/0xbc
> [  107.839622]
> [  107.839623] but task is already holding lock:
> [  107.839624]  (&mm->mmap_sem){++++++}, at: [<ffffffff810ca534>]
> sys_munmap+0x36/0x5b
> [  107.839630]
> [  107.839630] which lock already depends on the new lock.
> [  107.839631]
> [  107.839632]
> [  107.839632] the existing dependency chain (in reverse order) is:
> [  107.839634]
> [  107.839634] -> #1 (&mm->mmap_sem){++++++}:
> [  107.839638]        [<ffffffff8107402d>] lock_acquire+0x8a/0xa7
> [  107.839642]        [<ffffffff810c3363>] might_fault+0x7b/0x9e
> [  107.839646]        [<ffffffff810f5246>] filldir+0x6a/0xc2
> [  107.839649]        [<ffffffff81143b91>] call_filldir+0x91/0xb8
> [  107.839653]        [<ffffffff81143eb2>] ext4_readdir+0x1b2/0x519
> [  107.839656]        [<ffffffff810f548c>] vfs_readdir+0x76/0xac
> [  107.839658]        [<ffffffff810f559e>] sys_getdents+0x79/0xc9
> [  107.839661]        [<ffffffff813a1fb9>] system_call_fastpath+0x16/0x1b
> [  107.839665]
> [  107.839665] -> #0 (&sb->s_type->i_mutex_key#13){+.+.+.}:
> [  107.839669]        [<ffffffff81073918>] __lock_acquire+0xa81/0xd75
> [  107.839672]        [<ffffffff8107402d>] lock_acquire+0x8a/0xa7
> [  107.839675]        [<ffffffff8139acfe>] __mutex_lock_common+0x61/0x456
> [  107.839679]        [<ffffffff8139b1da>] mutex_lock_nested+0x36/0x3b
> [  107.839681]        [<ffffffff810ae65a>] generic_file_aio_write+0x45/0xbc
> [  107.839684]        [<ffffffff8114478e>] ext4_file_write+0x1e2/0x23a
> [  107.839687]        [<ffffffff810e5bb5>] do_sync_write+0xbd/0xfd
> [  107.839691]        [<ffffffff810e6333>] vfs_write+0xa7/0xee
> [  107.839694]        [<ffffffffa037f266>]
> ecryptfs_write_lower+0x4e/0x73 [ecryptfs]
> [  107.839700]        [<ffffffffa03803d3>]
> ecryptfs_encrypt_page+0x11c/0x182 [ecryptfs]
> [  107.839704]        [<ffffffffa037e967>]
> ecryptfs_writepage+0x31/0x73 [ecryptfs]
> [  107.839708]        [<ffffffff810b448b>] __writepage+0x12/0x31
> [  107.839710]        [<ffffffff810b4b25>] write_cache_pages+0x1e6/0x310
> [  107.839713]        [<ffffffff810b4c8d>] generic_writepages+0x3e/0x54
> [  107.839716]        [<ffffffff810b5e05>] do_writepages+0x26/0x28
> [  107.839719]        [<ffffffff810ae1e4>] __filemap_fdatawrite_range+0x4e/0x50
> [  107.839722]        [<ffffffff810aed55>] filemap_fdatawrite+0x1a/0x1c
> [  107.839725]        [<ffffffff810aed72>] filemap_write_and_wait+0x1b/0x36
> [  107.839727]        [<ffffffffa037c1bb>]
> ecryptfs_vma_close+0x17/0x19 [ecryptfs]
> [  107.839731]        [<ffffffff810c9374>] remove_vma+0x3b/0x71
> [  107.839733]        [<ffffffff810ca40c>] do_munmap+0x2ed/0x306
> [  107.839735]        [<ffffffff810ca542>] sys_munmap+0x44/0x5b
> [  107.839738]        [<ffffffff813a1fb9>] system_call_fastpath+0x16/0x1b
> [  107.839741]
> [  107.839741] other info that might help us debug this:
> [  107.839741]
> [  107.839743]  Possible unsafe locking scenario:
> [  107.839743]
> [  107.839744]        CPU0                    CPU1
> [  107.839746]        ----                    ----
> [  107.839747]   lock(&mm->mmap_sem);
> [  107.839749]                                lock(&sb->s_type->i_mutex_key#13);
> [  107.839753]                                lock(&mm->mmap_sem);
> [  107.839755]   lock(&sb->s_type->i_mutex_key#13);
> [  107.839758]
> [  107.839758]  *** DEADLOCK ***
> [  107.839759]
> [  107.839761] 1 lock held by gvfsd-metadata/2314:
> [  107.839762]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810ca534>]
> sys_munmap+0x36/0x5b
> [  107.839767]
> [  107.839767] stack backtrace:
> [  107.839769] Pid: 2314, comm: gvfsd-metadata Not tainted 3.3.0-rc6+ #14
> [  107.839771] Call Trace:
> [  107.839775]  [<ffffffff813956a2>] print_circular_bug+0x1f8/0x209
> [  107.839778]  [<ffffffff81073918>] __lock_acquire+0xa81/0xd75
> [  107.839781]  [<ffffffff81073bfd>] ? __lock_acquire+0xd66/0xd75
> [  107.839784]  [<ffffffff8107402d>] lock_acquire+0x8a/0xa7
> [  107.839787]  [<ffffffff810ae65a>] ? generic_file_aio_write+0x45/0xbc
> [  107.839790]  [<ffffffff8139acfe>] __mutex_lock_common+0x61/0x456
> [  107.839792]  [<ffffffff810ae65a>] ? generic_file_aio_write+0x45/0xbc
> [  107.839795]  [<ffffffff81071a96>] ? mark_lock+0x2d/0x258
> [  107.839798]  [<ffffffff810ae65a>] ? generic_file_aio_write+0x45/0xbc
> [  107.839801]  [<ffffffff8107299e>] ? lock_is_held+0x92/0x9d
> [  107.839803]  [<ffffffff8139b1da>] mutex_lock_nested+0x36/0x3b
> [  107.839806]  [<ffffffff810ae65a>] generic_file_aio_write+0x45/0xbc
> [  107.839810]  [<ffffffff811a013f>] ? scatterwalk_map+0x2b/0x5d
> [  107.839813]  [<ffffffff810570d4>] ? get_parent_ip+0xe/0x3e
> [  107.839816]  [<ffffffff8114478e>] ext4_file_write+0x1e2/0x23a
> [  107.839818]  [<ffffffff81071a96>] ? mark_lock+0x2d/0x258
> [  107.839821]  [<ffffffff810e5bb5>] do_sync_write+0xbd/0xfd
> [  107.839824]  [<ffffffff8139b2fd>] ? __mutex_unlock_slowpath+0x11e/0x152
> [  107.839828]  [<ffffffff81197092>] ? security_file_permission+0x29/0x2e
> [  107.839831]  [<ffffffff810e60b2>] ? rw_verify_area+0xab/0xc8
> [  107.839834]  [<ffffffff810e6333>] vfs_write+0xa7/0xee
> [  107.839838]  [<ffffffffa037f266>] ecryptfs_write_lower+0x4e/0x73 [ecryptfs]
> [  107.839842]  [<ffffffffa03803d3>] ecryptfs_encrypt_page+0x11c/0x182
> [ecryptfs]
> [  107.839846]  [<ffffffffa037e967>] ecryptfs_writepage+0x31/0x73 [ecryptfs]
> [  107.839849]  [<ffffffff810b448b>] __writepage+0x12/0x31
> [  107.839851]  [<ffffffff810b4b25>] write_cache_pages+0x1e6/0x310
> [  107.839854]  [<ffffffff810b4479>] ? bdi_set_max_ratio+0x6a/0x6a
> [  107.839857]  [<ffffffff813a03c1>] ? sub_preempt_count+0x90/0xa3
> [  107.839860]  [<ffffffff810b4c8d>] generic_writepages+0x3e/0x54
> [  107.839863]  [<ffffffff810b5e05>] do_writepages+0x26/0x28
> [  107.839866]  [<ffffffff810ae1e4>] __filemap_fdatawrite_range+0x4e/0x50
> [  107.839869]  [<ffffffff810aed55>] filemap_fdatawrite+0x1a/0x1c
> [  107.839871]  [<ffffffff810aed72>] filemap_write_and_wait+0x1b/0x36
> [  107.839875]  [<ffffffffa037c1bb>] ecryptfs_vma_close+0x17/0x19 [ecryptfs]
> [  107.839877]  [<ffffffff810c9374>] remove_vma+0x3b/0x71
> [  107.839879]  [<ffffffff810ca40c>] do_munmap+0x2ed/0x306
> [  107.839882]  [<ffffffff810ca542>] sys_munmap+0x44/0x5b
> [  107.839884]  [<ffffffff813a1fb9>] system_call_fastpath+0x16/0x1b

mmap_sem nests inside i_mutex.

On the path

	munmap
	->ecryptfs_vma_close
	  ->filemap_write_and_wait
	    ->generic_file_aio_write

we're taking i_mutex inside mmap_sem.  So the problem is triggered by
ecryptfs_vma_close() calling filemap_write_and_wait() inside munmap()'s
mmap_sem.

Question is: what did we recently change to cause this to happen?
