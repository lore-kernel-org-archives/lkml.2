Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3AFKad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 05:30:33 -0500
Received: from msa101.auone-net.jp ([61.117.18.161]:51514 "EHLO
	msa101.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3AFKab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 05:30:31 -0500
Date: Sun, 6 Jan 2013 19:30:28 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Replace goto with do-while
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20130106103029.28D5E3E403B@msa101.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 fs/namespace.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 55605c5..467ca80 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -71,15 +71,14 @@ static int mnt_alloc_id(struct mount *mnt)
 {
 	int res;
 
-retry:
-	ida_pre_get(&mnt_id_ida, GFP_KERNEL);
-	spin_lock(&mnt_id_lock);
-	res = ida_get_new_above(&mnt_id_ida, mnt_id_start, &mnt->mnt_id);
-	if (!res)
-		mnt_id_start = mnt->mnt_id + 1;
-	spin_unlock(&mnt_id_lock);
-	if (res == -EAGAIN)
-		goto retry;
+	do {
+		ida_pre_get(&mnt_id_ida, GFP_KERNEL);
+		spin_lock(&mnt_id_lock);
+		res = ida_get_new_above(&mnt_id_ida, mnt_id_start, &mnt->mnt_id);
+		if (!res)
+			mnt_id_start = mnt->mnt_id + 1;
+		spin_unlock(&mnt_id_lock);
+	} while (res == -EAGAIN);
 
 	return res;
 }
-- 
1.7.10.4

