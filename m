Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2BMSG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:06:29 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35451 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755533Ab2BMSG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:06:28 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120213180629.527D4426DA7@whiskey.americas.sgi.com>
Date: Mon, 13 Feb 2012 12:06:29 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull the following two bugfixes in XFS for 3.3.  One fix passes
   KMEM_SLEEP to kmem_realloc instead of 0, and the other resolves a possible
   deadlock in xfs quotas.

Thanks,
	Ben

The following changes since commit 612b8507c5d545feed2437b3d2239929cac7688d:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: use a normal shrinker for the dquot freelist

Mitsuo Hayasaka (1):
      xfs: pass KM_SLEEP flag to kmem_realloc() in xlog_recover_add_to_cnt_trans()

 fs/xfs/kmem.h            |    6 -
 fs/xfs/xfs_dquot.c       |  103 ++++------------
 fs/xfs/xfs_log_recover.c |    2 +-
 fs/xfs/xfs_qm.c          |  291 ++++++++++++++++++----------------------------
 fs/xfs/xfs_qm.h          |   14 ---
 fs/xfs/xfs_qm_stats.c    |    4 +-
 fs/xfs/xfs_trace.h       |    5 +-
 7 files changed, 142 insertions(+), 283 deletions(-)
