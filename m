Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2KCJgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:36:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42544 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2KCJgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:36:11 -0400
Message-ID: <5094E3FE.4050408@gmail.com>
Date: Sat, 03 Nov 2012 10:29:34 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
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
