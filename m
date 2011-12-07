Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab1LGXH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:07:58 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35333 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1LGXH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:07:57 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.2
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20111207230819.37403426DA7@whiskey.americas.sgi.com>
Date: Wed,  7 Dec 2011 17:08:19 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes for XFS for 3.2.

a99ebf4 fixes an overflow when converting allocation length to extent length,

c29f7d4 fixes export of 64 bit inode numbers on 32 bit kernels, and

9f9c19e fixes a log hang due to a race when granting log space.  It was
debugged and tested thoroughly by Chandra Seetharaman <sekharan@us.ibm.com>.

Thanks,
	Ben

The following changes since commit 77a7300abad7fe01891b400e88d746f97307ee5a:
  Anton Vorontsov (1):
        of/irq: Get rid of NO_IRQ usage

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: fix nfs export of 64-bit inodes numbers on 32-bit kernels
      xfs: fix the logspace waiting algorithm

Dave Chinner (1):
      xfs: fix allocation length overflow in xfs_bmapi_write()

 fs/xfs/xfs_bmap.c   |   20 +++-
 fs/xfs/xfs_export.c |    8 +-
 fs/xfs/xfs_log.c    |  348 +++++++++++++++++++++++++--------------------------
 fs/xfs/xfs_trace.h  |   12 +--
 4 files changed, 200 insertions(+), 188 deletions(-)
