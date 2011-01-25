Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1AYRfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:35:03 -0500
Received: from sh.osrg.net ([192.16.179.4]:57968 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab1AYRfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:35:00 -0500
Date: Wed, 26 Jan 2011 02:34:09 +0900 (JST)
Message-Id: <20110126.023409.246150501.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 fix 
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 26 Jan 2011 02:34:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following bugfix for a reported kernel oops.

Thanks,

Ryusuke Konishi
--
The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Ryusuke Konishi (1):
      nilfs2: fix crash after one superblock became unavailable

 fs/nilfs2/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


commit 0ca7a5b9ac5d301845dd6382ff25a699b6263a81
Author: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date:   Fri Jan 21 16:40:31 2011 +0900

    nilfs2: fix crash after one superblock became unavailable
    
    Fixes the following kernel oops in nilfs_setup_super() which could
    arise if one of two super-blocks is unavailable.
    
    > BUG: unable to handle kernel NULL pointer dereference at   (null)
    > Pid: 3529, comm: mount.nilfs2 Not tainted 2.6.37 #1 /
    > EIP: 0060:[<c03196bc>] EFLAGS: 00010202 CPU: 3
    > EIP is at memcpy+0xc/0x1b
    > Call Trace:
    >  [<f953720e>] ? nilfs_setup_super+0x6c/0xa5 [nilfs2]
    >  [<f95369e9>] ? nilfs_get_root_dentry+0x81/0xcb [nilfs2]
    >  [<f9537a08>] ? nilfs_mount+0x4f9/0x62c [nilfs2]
    >  [<c02745cf>] ? kstrdup+0x36/0x3f
    >  [<f953750f>] ? nilfs_mount+0x0/0x62c [nilfs2]
    >  [<c0293940>] ? vfs_kern_mount+0x4d/0x12c
    >  [<c02a5100>] ? get_fs_type+0x76/0x8f
    >  [<c0293a68>] ? do_kern_mount+0x33/0xbf
    >  [<c02a784a>] ? do_mount+0x2ed/0x714
    >  [<c02a6171>] ? copy_mount_options+0x28/0xfc
    >  [<c02a7ce3>] ? sys_mount+0x72/0xaf
    >  [<c0473085>] ? syscall_call+0x7/0xb
    
    Reported-by: Wakko Warner <wakko@animx.eu.org>
    Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
    Tested-by: Wakko Warner <wakko@animx.eu.org>
    Cc: stable <stable@kernel.org> [2.6.37, 2.6.36]
    LKML-Reference: <20110121024918.GA29598@animx.eu.org>
