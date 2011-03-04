Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab1CDRPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:15:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39229 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759978Ab1CDRPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:15:19 -0500
Date: Fri, 4 Mar 2011 17:15:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: check link counter overflow in link(2)
Message-ID: <20110304171518.GB26708@ZenIV.linux.org.uk>
References: <20110304171353.GU22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304171353.GU22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/btrfs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 099d64c..8a6df03 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4826,6 +4826,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
 		return -EPERM;
 
+	if (inode->i_nlink == ~0U)
+		return -EMLINK;
+
 	btrfs_inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME;
 
-- 
1.7.2.5

