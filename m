Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0IECwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 22:52:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:36890 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0IECwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 22:52:19 -0400
Date: Sun, 05 Sep 2010 11:52:12 +0900 (JST)
Message-Id: <20100905.115212.58895734.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 fix
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 05 Sep 2010 11:52:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a nilfs2 fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

This fixes a leak issue that occurs when recovery aborted.

Thanks,

Ryusuke Konishi
--
The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
  Linus Torvalds (1):
        Linux 2.6.36-rc3

Ryusuke Konishi (1):
      nilfs2: fix leak of shadow dat inode in error path of load_nilfs

 fs/nilfs2/the_nilfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 4317f17..ba7c10c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -446,6 +446,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	nilfs_mdt_destroy(nilfs->ns_cpfile);
 	nilfs_mdt_destroy(nilfs->ns_sufile);
 	nilfs_mdt_destroy(nilfs->ns_dat);
+	nilfs_mdt_destroy(nilfs->ns_gc_dat);
 
  failed:
 	nilfs_clear_recovery_info(&ri);
