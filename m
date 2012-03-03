Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2CCMgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 07:36:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57320 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2CCMgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 07:36:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of marcos.mage@gmail.com designates 10.236.78.40 as permitted sender) smtp.mail=marcos.mage@gmail.com; dkim=pass header.i=marcos.mage@gmail.com
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH] fs/dcache.c: Fix parameter documentation of __d_lookup_rcu function
Date: Sat,  3 Mar 2012 09:33:04 -0300
Message-Id: <1330777984-19050-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 8966be90304b394fd6a2c5af7b6b3abe2df3889c renames the seq parameter to seqp of function
__d_lookup_rcu, and with this change the htmldocs tool gives the following warning:

       Warning(/mnt/dados/linux//fs/dcache.c:1723): No description found for parameter 'seqp'
       Warning(/mnt/dados/linux//fs/dcache.c:1723): Excess function parameter 'seq' description in '__d_lookup_rcu'

 This patch fix this small issue.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 fs/dcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 138be96..b87513c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1694,7 +1694,7 @@ EXPORT_SYMBOL(d_add_ci);
  * __d_lookup_rcu - search for a dentry (racy, store-free)
  * @parent: parent dentry
  * @name: qstr of name we wish to find
- * @seq: returns d_seq value at the point where the dentry was found
+ * @seqp: returns d_seq value at the point where the dentry was found
  * @inode: returns dentry->d_inode when the inode was found valid.
  * Returns: dentry, or NULL
  *
-- 
1.7.7.6

