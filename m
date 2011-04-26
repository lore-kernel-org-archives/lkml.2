Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab1DZAxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:53:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36026 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab1DZAxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:53:22 -0400
Date: Mon, 25 Apr 2011 19:53:15 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.39-rc5
Message-ID: <20110426005314.GA27036@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The first 3 patches below fix bugs when eCryptfs is mounted on top of
NFSv3 client mount points. The 4th patch fixes a bug that occurs when
the eCryptfs file metadata can't be read during lookup. The 5th patch
fixes a regression, introduced in 2.6.39-rc1, causing mtimes to not be
preserved when using `cp -p`.

The following changes since commit 5dd12af05ca6b7d052c06a9ca4ff755fdfa25ae4:

  Merge branch 'dcache-cleanup' (2011-04-24 08:51:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Tyler Hicks (5):
      eCryptfs: Remove extra d_delete in ecryptfs_rmdir
      eCryptfs: dput dentries returned from dget_parent
      eCryptfs: Add reference counting to lower files
      eCryptfs: Handle failed metadata read in lookup
      eCryptfs: Flush dirty pages in setattr

 fs/ecryptfs/crypto.c          |   21 ++++++++++++
 fs/ecryptfs/ecryptfs_kernel.h |    7 +++-
 fs/ecryptfs/file.c            |   25 +++++++-------
 fs/ecryptfs/inode.c           |   60 ++++++++++++++++++----------------
 fs/ecryptfs/kthread.c         |    6 ++--
 fs/ecryptfs/main.c            |   72 ++++++++++++++++++++++++++++------------
 fs/ecryptfs/super.c           |   16 ++-------
 7 files changed, 128 insertions(+), 79 deletions(-)
