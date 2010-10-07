Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0JGE2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:28:01 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54138 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750770Ab0JGE15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:27:57 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201010070427.o974RmcC012153@stout.americas.sgi.com>
Date: Wed, 06 Oct 2010 23:27:48 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS fix for 2.6.36
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm hoping this XFS change can make it in to 2.6.36.  It fixes a bug
that causes allocation groups to be needlessly scanned for reclaim,
because some reclaim state in XFS is never properly cleared when an
inode gets reclaimed.  The result can make filesystems appear to
have an ever-increasing number of reclaimable objects, even if there
is nothing to do.

					-Alex

The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:

  Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Johannes Weiner (1):
      xfs: properly account for reclaimed inodes

 fs/xfs/linux-2.6/xfs_sync.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)
