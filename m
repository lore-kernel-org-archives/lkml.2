Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2LVDQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:16:54 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40144 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2LVDQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:16:52 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/5] f2fs: remove unneeded initialization of nr_dirty in dirty_seglist_info
Date: Sat, 22 Dec 2012 12:09:58 +0900
Message-Id: <1356145798-20014-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, the memory for the object of dirty_seglist_info is allocated
using kzalloc - which returns zeroed out memory. So, there is no need
to initialize the nr_dirty values with zeroes.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/segment.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index ffacee4..b0ec996 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1573,7 +1573,6 @@ static int build_dirty_segmap(struct f2fs_sb_info *sbi)
 
 	for (i = 0; i < NR_DIRTY_TYPE; i++) {
 		dirty_i->dirty_segmap[i] = kzalloc(bitmap_size, GFP_KERNEL);
-		dirty_i->nr_dirty[i] = 0;
 		if (!dirty_i->dirty_segmap[i])
 			return -ENOMEM;
 	}
-- 
1.7.9.5

