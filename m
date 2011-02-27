Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1B0OIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 09:08:38 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:42785 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845Ab1B0OIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 09:08:35 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Feb 2011 09:08:35 EST
From: Matt Fleming <matt@console-pimps.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/locks.c: Remove stale FIXME left over from BKL conversion
Date: Sun, 27 Feb 2011 13:58:00 +0000
Message-Id: <1298815080-25733-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

The comment is no longer true as (now that the BKL conversion is
finished) a spinlock _is_ now used to protect file_lock_list,
blocked_list and inode->i_flock.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 fs/locks.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 0f39982..822c3d1 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -145,7 +145,6 @@ static DEFINE_SPINLOCK(file_lock_lock);
 
 /*
  * Protects the two list heads above, plus the inode->i_flock list
- * FIXME: should use a spinlock, once lockd and ceph are ready.
  */
 void lock_flocks(void)
 {
-- 
1.7.4

