Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2CPTEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:04:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:12056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab2CPTBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140089251"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, xfs-masters@oss.sgi.com
Subject: [PATCH 05/11] XFS: Fix lock ASSERT on UP
Date: Fri, 16 Mar 2012 12:00:58 -0700
Message-Id: <1331924464-18023-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

ASSERT(!spin_is_locked()) doesn't work on UP builds. Replace with a standard
lockdep_assert_held()

Cc: xfs-masters@oss.sgi.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/xfs/xfs_iget.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 8c3e463..8654d78 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -76,7 +76,7 @@ xfs_inode_alloc(
 	}
 
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	lockdep_assert_held(&ip->i_flags_lock);
 	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
@@ -147,7 +147,7 @@ xfs_inode_free(
 
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	lockdep_assert_held(&ip->i_flags_lock);
 	ASSERT(!xfs_isiflocked(ip));
 
 	/*
-- 
1.7.7.6

