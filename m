Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2HQO4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:56:02 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45259 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab2HQOzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:55:51 -0400
Date: Fri, 17 Aug 2012 10:55:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 3.6
Message-ID: <20120817145548.GA29433@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 89a4e48f8479f8145eca9698f39fe188c982212f:

  ext4: fix kernel BUG on large-scale rm -rf commands (2012-08-17 09:42:17 -0400)

----------------------------------------------------------------
The following are all bug fixes and regressions.  The most notable are
the ones which cause problems for ext4 on RAID --- a performance
problem when mounting very large filesystems, and a kernel OOPS when
doing an rm -rf on large directory hierarchies on fast devices.

----------------------------------------------------------------
Theodore Ts'o (5):
      ext4: make sure the journal sb is written in ext4_clear_journal_err()
      ext4: avoid kmemcheck complaint from reading uninitialized memory
      ext4: don't call ext4_error while block group is locked
      ext4: fix long mount times on very big file systems
      ext4: fix kernel BUG on large-scale rm -rf commands

 fs/ext4/balloc.c     | 62 +++++++++++++++++++++++++++++++---------------------
 fs/ext4/bitmap.c     |  1 -
 fs/ext4/extents.c    |  1 +
 fs/ext4/super.c      |  6 +++++
 fs/jbd2/journal.c    |  3 ++-
 include/linux/jbd2.h |  1 +
 6 files changed, 47 insertions(+), 27 deletions(-)
