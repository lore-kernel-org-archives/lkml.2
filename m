Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1J1MRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:17:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55548
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932535Ab1J1MQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:16:57 -0400
Date: Fri, 28 Oct 2011 08:16:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sage Weil <sage@newdream.net>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        ceph-devel@vger.kernel.org, rwheeler@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: add d_prune dentry operation
Message-ID: <20111028121652.GA23417@infradead.org>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
 <1317875170-9349-2-git-send-email-sage@newdream.net>
 <20111006212118.GA24109@infradead.org>
 <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net>
 <20111010051141.GV3159@dastard>
 <Pine.LNX.4.64.1110100850020.26361@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110100850020.26361@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variant seems to crash btrfs in xfstests 010:

010 0s ... 0s
[ 8093.504387] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 8093.505618] IP: [<          (null)>]           (null)
[ 8093.505930] PGD 196f5067 PUD 5507d067 PMD 0 
[ 8093.505930] Oops: 0010 [#1] SMP 
[ 8093.505930] CPU 0 
[ 8093.505930] Modules linked in:
[ 8093.505930] 
[ 8093.505930] Pid: 26328, comm: umount Not tainted 3.1.0+ #90 Bochs Bochs
[ 8093.505930] RIP: 0010:[<0000000000000000>]  [<          (null)>] (null)
[ 8093.505930] RSP: 0018:ffff880009f63dc0  EFLAGS: 00010206
[ 8093.505930] RAX: ffffffff81ae7780 RBX: ffff88002b93a840 RCX: 000000010023ad06
[ 8093.505930] RDX: ffff88002b93a8e0 RSI: ffffffff8114fef0 RDI: ffff88002b93a840
[ 8093.505930] RBP: ffff880009f63dd8 R08: 0000000000000000 R09: 002dffe1ea51a56d
[ 8093.505930] R10: ffff880058c7f680 R11: 0000000000000004 R12: ffff88002b93a8c0
[ 8093.505930] R13: 0000000000000000 R14: ffff88005a56d0c0 R15: ffff88001a896000
[ 8093.505930] FS:  0000000000000000(0000) GS:ffff88005d800000(0063) knlGS:00000000f75c6700
[ 8093.505930] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[ 8093.505930] CR2: 0000000000000000 CR3: 0000000041ddc000 CR4: 00000000000006f0
[ 8093.505930] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8093.505930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8093.505930] Process umount (pid: 26328, threadinfo ffff880009f62000, task ffff88003abd6500)
[ 8093.505930] Stack:
[ 8093.505930]  ffffffff8114efb7 ffff88002b93a840 ffff88005a3c4500 ffff880009f63e08
[ 8093.505930]  ffffffff811516ea ffff880009f63f08 0000000000000000 ffff88001a896000
[ 8093.505930]  ffffffff81ae40c0 ffff880009f63e28 ffffffff8115192e ffff880009f63e38
[ 8093.505930] Call Trace:
[ 8093.505930]  [<ffffffff8114efb7>] ? dentry_lru_prune+0x87/0x90
[ 8093.505930]  [<ffffffff811516ea>] shrink_dcache_for_umount_subtree+0x7a/0x1e0
[ 8093.505930]  [<ffffffff8115192e>] shrink_dcache_for_umount+0x2e/0x60
[ 8093.505930]  [<ffffffff8113d977>] generic_shutdown_super+0x27/0xd0
[ 8093.505930]  [<ffffffff8113dab1>] kill_anon_super+0x11/0x20
[ 8093.505930]  [<ffffffff8113de25>] deactivate_locked_super+0x45/0x70
[ 8093.505930]  [<ffffffff8113e7e9>] deactivate_super+0x49/0x70
[ 8093.505930]  [<ffffffff81157f7b>] mntput_no_expire+0xab/0xf0
[ 8093.505930]  [<ffffffff81158c1a>] sys_umount+0x6a/0x360
[ 8093.505930]  [<ffffffff81158f1b>] sys_oldumount+0xb/0x10
[ 8093.505930]  [<ffffffff819e2f05>] sysenter_dispatch+0x7/0x2b
[ 8093.505930] Code:  Bad RIP value.
[ 8093.505930] RIP  [<          (null)>]           (null)

