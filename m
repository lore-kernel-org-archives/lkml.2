Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1LAHAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:00:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45422 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1LAHAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:00:44 -0500
X-AuditID: cbfee61a-b7b62ae0000030b0-1d-4ed7261bb806
Date: Thu, 01 Dec 2011 16:00:52 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: tytso@mit.edu, tm@tao.ma
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Set the initial TRIM information as TRIMMED
Message-id: <20111201070052.GA29708@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Now trim information doesn't stored at disk so every boot time. it's cleared.
and do the trim all disk groups.
But assume that it's already trimmed at previous time so don't need to trim it again. So set the intial state as trimmed.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..97ef342 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
 		goto err;
 	}
 	mark_page_accessed(page);
+
+	/*
+	 * TRIM information is not stored at disk so set the initial
+	 * state as trimmed. Since previous time it's already trimmed all
+	 */
+	EXT4_MB_GRP_SET_TRIMMED(this_grp);
 err:
 	ext4_mb_put_buddy_page_lock(&e4b);
 	return ret;
