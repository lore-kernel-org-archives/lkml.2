Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2KSUxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:53:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2KSUxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:53:49 -0500
Date: Mon, 19 Nov 2012 21:53:47 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
Subject: [PULL] Reiserfs fixes and ext3 fix for 3.7-rc6
Message-ID: <20121119205347.GE20532@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

You will get fixes of reiserfs deadlocks when quotas are enabled (locking
there was completely busted by BKL conversion) and also one small ext3 fix
in the trim interface.

Top of the tree is ae49eee. The full shortlog is:

Jan Kara (4):
      reiserfs: Fix lock ordering during remount
      reiserfs: Protect reiserfs_quota_on() with write lock
      reiserfs: Protect reiserfs_quota_write() with write lock
      reiserfs: Move quota calls out of write lock

Lukas Czerner (1):
      ext3: Avoid underflow of in ext3_trim_fs()

The diffstat is

 fs/ext3/balloc.c    |    5 ++-
 fs/reiserfs/inode.c |   10 ++++++--
 fs/reiserfs/stree.c |    4 +++
 fs/reiserfs/super.c |   60
+++++++++++++++++++++++++++++++++++++++------------
 4 files changed, 60 insertions(+), 19 deletions(-)

							Thanks
								Honza


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
