Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab1KKPz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:55:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50750 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab1KKPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:55:24 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH] fs : remove unneeded plug in mpage_readpages.
Date: Sat, 12 Nov 2011 00:54:13 +0900
Message-Id: <1321026853-16388-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block plug in mpage_readpages is duplicated with plug of read_pages. So block plug is not needed in mpage_readpages.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/mpage.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index fdfae9f..643e9f5 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -371,9 +371,6 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
-	struct blk_plug plug;
-
-	blk_start_plug(&plug);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
@@ -395,7 +392,6 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		mpage_bio_submit(READ, bio);
-	blk_finish_plug(&plug);
 	return 0;
 }
 EXPORT_SYMBOL(mpage_readpages);
-- 
1.7.4.4

