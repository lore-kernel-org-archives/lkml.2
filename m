Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2LOLCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 06:02:34 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49260 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2LOLCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 06:02:33 -0500
Message-ID: <50CC572E.8040305@gmail.com>
Date: Sat, 15 Dec 2012 11:55:42 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>,
        logfs@logfs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/21] logfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/logfs/readwrite.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index e1a3b6b..9a59cba 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -1887,9 +1887,15 @@ int logfs_truncate(struct inode *inode, u64 target)
 		logfs_put_wblocks(sb, NULL, 1);
 	}
 
-	if (!err)
-		err = vmtruncate(inode, target);
+	if (!err) {
+		err = inode_newsize_ok(inode, target);
+		if (err)
+			goto out;
+
+		truncate_setsize(inode, target);
+	}
 
+ out:
 	/* I don't trust error recovery yet. */
 	WARN_ON(err);
 	return err;
-- 
1.7.3.4
