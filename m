Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1E2UBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:01:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41672 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1E2UBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:01:40 -0400
Date: Sun, 29 May 2011 15:01:35 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] More eCryptfs fixes
Message-ID: <20110529200135.GA9787@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The first 2 patches are code cleanups to pave the way for the 3rd patch,
which fixes a race condition around the i_size field of new eCryptfs
inodes. The last 3 patches are more fs/ecryptfs/inode.c code cleanups
that I couldn't resist doing after I was done fixing the race condition.

Sorry for the late pull request. The reporter of the i_size race
condition was nice enough to test the fix yesterday, but I haven't had
access to a computer until this afternoon.

The following changes since commit 139f37f5e14cd883eee2a8a36289f544b5390a44:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin (2011-05-28 23:12:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Tyler Hicks (6):
      eCryptfs: Consolidate inode functions into inode.c
      eCryptfs: Cleanup inode initialization code
      eCryptfs: Fix new inode race condition
      eCryptfs: Return useful code from contains_ecryptfs_marker
      eCryptfs: Cleanup and optimize ecryptfs_lookup_interpose()
      eCryptfs: Remove ecryptfs_header_cache_2

 fs/ecryptfs/crypto.c          |   74 +++++------
 fs/ecryptfs/ecryptfs_kernel.h |   26 ++---
 fs/ecryptfs/file.c            |    2 +-
 fs/ecryptfs/inode.c           |  281 +++++++++++++++++++++++++----------------
 fs/ecryptfs/main.c            |   84 +------------
 fs/ecryptfs/super.c           |   16 ---
 6 files changed, 220 insertions(+), 263 deletions(-)
