Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab1COWyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:54:20 -0400
Received: from shutemov.name ([188.40.19.243]:49808 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab1COWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH 08/13] JFS: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:20 +0200
Message-Id: <1300229605-14499-8-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: jfs-discussion@lists.sourceforge.net
---
 fs/jfs/jfs_txnmgr.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 9466957..8cb7b92 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2979,12 +2979,9 @@ int jfs_sync(void *arg)
 				 * put back on the anon_list.
 				 */
 
-				/* Take off anon_list */
-				list_del(&jfs_ip->anon_inode_list);
-
-				/* Put on anon_list2 */
-				list_add(&jfs_ip->anon_inode_list,
-					 &TxAnchor.anon_list2);
+				/* Move anon_list -> anon_list2 */
+				list_move(&jfs_ip->anon_inode_list,
+					  &TxAnchor.anon_list2);
 
 				TXN_UNLOCK();
 				iput(ip);
-- 
1.7.4.1

