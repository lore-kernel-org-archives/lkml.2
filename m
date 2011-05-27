Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1E0UmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:42:13 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43527 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab1E0Ulw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:41:52 -0400
From: Sage Weil <sage@newdream.net>
To: hch@infradead.org, viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/26] ncpfs: document dentry_unhash usage
Date: Fri, 27 May 2011 13:42:09 -0700
Message-Id: <1306528939-30636-17-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1306528939-30636-1-git-send-email-sage@newdream.net>
References: <1306528939-30636-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ncpfs returns EBUSY if there are any references to the directory.  The
dentry_unhash call only unhashes the dentry if there are no references.

CC: Petr Vandrovec <petr@vandrovec.name>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ncpfs/dir.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index e3e646b..81c287d 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1033,8 +1033,11 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
 	DPRINTK("ncp_rmdir: removing %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
+	/*
+	 * fail with EBUSY if there are still references to this
+	 * directory.
+	 */
 	dentry_unhash(dentry);
-
 	error = -EBUSY;
 	if (!d_unhashed(dentry))
 		goto out;
-- 
1.7.0

