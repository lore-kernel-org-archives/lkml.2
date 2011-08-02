Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1HBKgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:36:43 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59150 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab1HBKfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:18 -0400
From: Julia Lawall <julia@diku.dk>
To: Chris Mason <chris.mason@oracle.com>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/11] fs/btrfs/volumes.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:35:01 +0200
Message-Id: <1312281304-11847-9-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..275be0f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1983,8 +1983,8 @@ again:
 						   found_key.offset);
 			if (ret == -ENOSPC)
 				failed++;
-			else if (ret)
-				BUG();
+			else
+				BUG_ON(ret);
 		}
 
 		if (found_key.offset == 0)

