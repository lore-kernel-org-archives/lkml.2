Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1BFRQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 12:16:24 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56518 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1BFRQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 12:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SHyyvRI6fUpRp1zRzIVbVd3MIgetIlQjG7af0DEojlgDjuDl2WtlxcWhqMz4ruSanp
         OWiBSr3E5METpNH4zoVvtuIpq68ZGEpmYxtfMPdZzKmUGbVAb+CAb+Ef3CChtuyC1IIf
         ot5c2Ht2sfEDqz9E6ErjGA3Bwu/qsUspEtjhY=
MIME-Version: 1.0
Date: Sun, 6 Feb 2011 20:16:21 +0300
Message-ID: <AANLkTin7YeKtH_=M0w_R=AE9OGmckgqp7nEsEzhsz_7M@mail.gmail.com>
Subject: 2.6.38-rc3: reiserfs: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Does it make sense?

[ INFO: inconsistent lock state ]
2.6.38-rc3-00201-g44f2c5c #1
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/411 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c1119a88>]
reiserfs_write_lock_once+0x28/0x50
{RECLAIM_FS-ON-W} state was registered at:
  [<c10537a6>] mark_held_locks+0x56/0x80
  [<c1053e8c>] lockdep_trace_alloc+0x9c/0xd0
  [<c1099978>] kmem_cache_alloc+0x28/0xe0
  [<c1100443>] reiserfs_alloc_inode+0x13/0x40
  [<c10b2bec>] alloc_inode+0x1c/0x80
  [<c10b2e77>] iget5_locked+0x77/0x180
  [<c11024e3>] reiserfs_fill_super+0x543/0xaa0
  [<c109f5fb>] mount_bdev+0x17b/0x1c0
  [<c11003aa>] get_super_block+0x1a/0x20
  [<c109e7a3>] vfs_kern_mount+0x53/0x170
  [<c109e919>] do_kern_mount+0x39/0xd0
  [<c10b6ec8>] do_mount+0x348/0x6a0
  [<c10b74c6>] sys_mount+0x66/0xa0
  [<c16358ff>] mount_block_root+0xc1/0x234
  [<c1635acb>] mount_root+0x59/0x5f
  [<c1635be2>] prepare_namespace+0x111/0x14b
  [<c163577d>] kernel_init+0x113/0x120
  [<c100307a>] kernel_thread_helper+0x6/0x1c
irq event stamp: 116110169
hardirqs last  enabled at (116110169): [<c1065859>] __call_rcu.clone.5+0x39/0x60
hardirqs last disabled at (116110168): [<c1065846>] __call_rcu.clone.5+0x26/0x60
softirqs last  enabled at (116106756): [<c10304c1>] __do_softirq+0xc1/0x110
softirqs last disabled at (116106719): [<c1004136>] do_softirq+0x86/0xd0

other info that might help us debug this:
2 locks held by kswapd0/411:
 #0:  (shrinker_rwsem){++++..}, at: [<c107bfe4>] shrink_slab+0x24/0x160
 #1:  (&type->s_umount_key#17){++++..}, at: [<c10ae769>]
shrink_dcache_memory+0xe9/0x180

stack backtrace:
Pid: 411, comm: kswapd0 Not tainted 2.6.38-rc3-00201-g44f2c5c #1
Call Trace:
 [<c1053120>] ? print_usage_bug+0x160/0x1a0
 [<c10534ea>] ? mark_lock+0x38a/0x5f0
 [<c1052630>] ? check_usage_forwards+0x0/0xd0
 [<c105533c>] ? __lock_acquire+0x5ac/0x19a0
 [<c10551d0>] ? __lock_acquire+0x440/0x19a0
 [<c1056cca>] ? lock_acquire+0x7a/0xa0
 [<c1119a88>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1364d5f>] ? mutex_lock_nested+0x5f/0x2a0
 [<c1119a88>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1119a88>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1050f5b>] ? trace_hardirqs_off+0xb/0x10
 [<c1119a88>] ? reiserfs_write_lock_once+0x28/0x50
 [<c10f593c>] ? reiserfs_evict_inode+0x3c/0x110
 [<c136612c>] ? _raw_spin_lock+0x5c/0x70
 [<c10b23af>] ? iput+0x19f/0x270
 [<c10b1a97>] ? evict+0x17/0xa0
 [<c10b23b6>] ? iput+0x1a6/0x270
 [<c10addb7>] ? d_kill+0xa7/0xf0
 [<c10ae4d7>] ? shrink_dentry_list+0x1e7/0x210
 [<c10ae44d>] ? shrink_dentry_list+0x15d/0x210
 [<c10ae654>] ? __shrink_dcache_sb+0x154/0x180
 [<c10ae791>] ? shrink_dcache_memory+0x111/0x180
 [<c107c0d0>] ? shrink_slab+0x110/0x160
 [<c107e04a>] ? kswapd+0x49a/0x7f0
 [<c107dbb0>] ? kswapd+0x0/0x7f0
 [<c1041fa4>] ? kthread+0x74/0x80
 [<c1041f30>] ? kthread+0x0/0x80
 [<c100307a>] ? kernel_thread_helper+0x6/0x1c
