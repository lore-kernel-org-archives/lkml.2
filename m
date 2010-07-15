Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0GOD1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:27:30 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4367 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0GOD1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:27:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave.bueso@gmail.com>,
        Davidlohr Bueso <dave@gnu.org>, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/4] omfs: fix memory leak
Date: Wed, 14 Jul 2010 23:26:18 -0400
Message-Id: <1279164381-9247-2-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279164381-9247-1-git-send-email-me@bobcopeland.com>
References: <1279164381-9247-1-git-send-email-me@bobcopeland.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave.bueso@gmail.com>

In the error path of omfs_fill_super(), the FS super block info
(sbi) is not being freed.  Correct this.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 089839a..b5d6380 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -529,6 +529,8 @@ out_brelse_bh2:
 out_brelse_bh:
 	brelse(bh);
 end:
+	if (ret)
+		kfree(sbi);
 	return ret;
 }
 
-- 
1.5.6.5


