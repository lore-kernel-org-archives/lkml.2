Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2F2D31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:29:27 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:36856 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab2F2D30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:29:26 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Use path_put instead of combination of two functions
Date: Fri, 29 Jun 2012 11:29:16 +0800
Message-Id: <1340940558-9893-1-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
x-cbid: 12062903-8878-0000-0000-0000031252E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/namei.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0e1b9c3..8dccfcc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -846,8 +846,7 @@ int follow_down_one(struct path *path)
 
 	mounted = lookup_mnt(path);
 	if (mounted) {
-		dput(path->dentry);
-		mntput(path->mnt);
+		path_put(path);
 		path->mnt = mounted;
 		path->dentry = dget(mounted->mnt_root);
 		return 1;
-- 
1.7.9.5

