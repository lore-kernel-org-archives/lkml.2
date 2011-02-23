Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1BWIAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:00:11 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:34700 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1BWIAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:00:09 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH] Unlock vfsmount_lock in do_mount
Date: Wed, 23 Feb 2011 16:59:49 +0900
Message-Id: <1298447989-12107-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the commit
	b3e19d9 2011-01-07 fs: scale mntget/mntput
vfsmount_lock was introduced around testing mnt_count.
Fix the mis-typed 'unlock'

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7b0b953..d1edf26 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1244,7 +1244,7 @@ static int do_umount(struct vfsmount *mnt, int flags)
 		 */
 		br_write_lock(vfsmount_lock);
 		if (mnt_get_count(mnt) != 2) {
-			br_write_lock(vfsmount_lock);
+			br_write_unlock(vfsmount_lock);
 			return -EBUSY;
 		}
 		br_write_unlock(vfsmount_lock);
-- 
1.6.6.1

