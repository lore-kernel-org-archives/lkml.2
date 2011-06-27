Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1F0OBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:01:06 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46449 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab1F0OBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:01:01 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201106271400.p5RE0u38026164@stout.americas.sgi.com>
Date: Mon, 27 Jun 2011 09:00:56 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.0-rc5
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following three XFS changes for 3.0-rc5:
- The first fixes a problem where certain XFS inode fields were
  not getting re-initialized when they were recycled.
- The second ensures a flag related to speculatively preallocating
  space beyond EOF gets reset when a file is truncated.
- The third properly sets a flag indicating that a lookup failure
  is allowed for user-supplied attribute names.  This was causing
  a failed assertion when running a test that attempts to remove
  a non-existent selinux-related attribute.

Thank you.

  					-Alex

The following changes since commit 258e43fdb00c73d424b114ae3850accd55b27cbb:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2011-06-26 19:40:31 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (3):
      xfs: reset inode per-lifetime state when recycling it
      xfs: clear XFS_IDIRTY_RELEASE on truncate down
      xfs: prevent bogus assert when trying to remove non-existent attribute

 fs/xfs/xfs_attr.c     |    7 +++++++
 fs/xfs/xfs_iget.c     |   13 +++++++++----
 fs/xfs/xfs_inode.h    |   10 ++++++++++
 fs/xfs/xfs_vnodeops.c |    7 +++++--
 4 files changed, 31 insertions(+), 6 deletions(-)
