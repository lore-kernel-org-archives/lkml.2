Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2AaWm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:42:59 -0500
Received: from [206.117.179.246] ([206.117.179.246]:39640 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753671Ab2AaWm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:42:58 -0500
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] udf: Remove unnecessary OOM messages
Date: Tue, 31 Jan 2012 14:42:10 -0800
Message-Id: <49874be55a105675b5878a0381920f27d5717341.1328049542.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1328049542.git.joe@perches.com>
References: <cover.1328049542.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per call site OOM messages are unnecessary.
k.alloc and v.alloc failures use dump_stack().

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/super.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index c09a84d..19111f9 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -948,11 +948,8 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 	else
 		bitmap = vzalloc(size); /* TODO: get rid of vzalloc */
 
-	if (bitmap == NULL) {
-		udf_err(sb, "Unable to allocate space for bitmap and %d buffer_head pointers\n",
-			nr_groups);
+	if (bitmap == NULL)
 		return NULL;
-	}
 
 	bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
 	bitmap->s_nr_groups = nr_groups;
-- 
1.7.8.111.gad25c.dirty

