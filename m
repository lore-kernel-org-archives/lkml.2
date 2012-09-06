Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2IFHdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:33:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56248 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2IFHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:33:09 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 15:33:09 +0800
Message-ID: <CAPgLHd-TqJzoPYcE8b=g=_v9fyc+7wtBJ3FtbWns_3Q1GUPm1Q@mail.gmail.com>
Subject: [PATCH] JFS: use list_move instead of list_del/list_add
From: Wei Yongjun <weiyj.lk@gmail.com>
To: shaggy@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, jfs-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/jfs/jfs_txnmgr.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index bb8b661..5fcc02e 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2977,12 +2977,9 @@ int jfs_sync(void *arg)
 				 * put back on the anon_list.
 				 */
 
-				/* Take off anon_list */
-				list_del(&jfs_ip->anon_inode_list);
-
-				/* Put on anon_list2 */
-				list_add(&jfs_ip->anon_inode_list,
-					 &TxAnchor.anon_list2);
+				/* Move from anon_list to anon_list2 */
+				list_move(&jfs_ip->anon_inode_list,
+					  &TxAnchor.anon_list2);
 
 				TXN_UNLOCK();
 				iput(ip);

