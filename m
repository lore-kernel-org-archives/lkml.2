Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab0KHTb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:31:56 -0500
Received: from thunk.org ([69.25.196.29]:60130 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab0KHTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:31:55 -0500
Date: Mon, 08 Nov 2010 14:31:45 -0500
Message-Id: <E1PFXRR-0008CI-6M@tytso-glaptop>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 update for 2.6.37-rc2
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This provides a number of bug fixes, including some regressions that
were introduced in 2.6.37-rc1.  It also includes some new tracepoints
that I used to find the regressions.

					- Ted

Dmitry Monakhov (1):
      ext4: do not try to grab the s_umount semaphore in ext4_quota_off

Lukas Czerner (1):
      ext4: fix lazyinit hang after removing request

Theodore Ts'o (6):
      ext4: "ret" may be used uninitialized in ext4_lazyinit_thread()
      ext4: initialize the percpu counters before replaying the journal
      ext4: handle writeback of inodes which are being freed
      ext4: fix potential race when freeing ext4_io_page structures
      ext4: Don't call sb_issue_discard() in ext4_free_blocks()
      ext4: Add new ext4 inode tracepoints

 fs/ext4/ext4.h              |    4 +-
 fs/ext4/inode.c             |    3 +
 fs/ext4/mballoc.c           |    2 -
 fs/ext4/page-io.c           |   97 ++++++++++++++++++++--------------------
 fs/ext4/super.c             |  102 ++++++++++++++++++++++++++-----------------
 include/trace/events/ext4.h |   97 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 214 insertions(+), 91 deletions(-)
