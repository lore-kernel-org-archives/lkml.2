Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab1KNXMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:12:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36658 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1KNXMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:12:49 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 0/3] pstore: pass allocated memory region back to caller
Date: Mon, 14 Nov 2011 15:12:35 -0800
Message-Id: <1321312358-11234-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pstore's buf_lock cannot be held while doing the VFS population,
these patches make it the backend's responsibility to pass up an allocated
buffer instead during reads.

[   59.691019] BUG: sleeping function called from invalid context at .../mm/slub.c:847
[   59.691019] in_atomic(): 0, irqs_disabled(): 1, pid: 1819, name: mount
[   59.691019] Pid: 1819, comm: mount Not tainted 3.0.8 #1
[   59.691019] Call Trace:
[   59.691019]  [<810252d5>] __might_sleep+0xc3/0xca
[   59.691019]  [<810a26e6>] kmem_cache_alloc+0x32/0xf3
[   59.691019]  [<810b53ac>] ? __d_lookup_rcu+0x6f/0xf4
[   59.691019]  [<810b68b1>] alloc_inode+0x2a/0x64
[   59.691019]  [<810b6903>] new_inode+0x18/0x43
[   59.691019]  [<81142447>] pstore_get_inode.isra.1+0x11/0x98
[   59.691019]  [<81142623>] pstore_mkfile+0xae/0x26f
[   59.691019]  [<810a2a66>] ? kmem_cache_free+0x19/0xb1
[   59.691019]  [<8116c821>] ? ida_get_new_above+0x140/0x158
[   59.691019]  [<811708ea>] ? __init_rwsem+0x1e/0x2c
[   59.691019]  [<810b67e8>] ? inode_init_always+0x111/0x1b0
[   59.691019]  [<8102127e>] ? should_resched+0xd/0x27
[   59.691019]  [<8137977f>] ? _cond_resched+0xd/0x21
[   59.691019]  [<81142abf>] pstore_get_records+0x52/0xa7
[   59.691019]  [<8114254b>] pstore_fill_super+0x7d/0x91
[   59.691019]  [<810a7ff5>] mount_single+0x46/0x82
[   59.691019]  [<8114231a>] pstore_mount+0x15/0x17
[   59.691019]  [<811424ce>] ? pstore_get_inode.isra.1+0x98/0x98
[   59.691019]  [<810a8199>] mount_fs+0x5a/0x12d
[   59.691019]  [<810b9174>] ? alloc_vfsmnt+0xa4/0x14a
[   59.691019]  [<810b9474>] vfs_kern_mount+0x4f/0x7d
[   59.691019]  [<810b9d7e>] do_kern_mount+0x34/0xb2
[   59.691019]  [<810bb15f>] do_mount+0x5fc/0x64a
[   59.691019]  [<810912fb>] ? strndup_user+0x2e/0x3f
[   59.691019]  [<810bb3cb>] sys_mount+0x66/0x99
[   59.691019]  [<8137b537>] sysenter_do_call+0x12/0x26



