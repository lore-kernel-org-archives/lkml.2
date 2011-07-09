Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1GITmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 15:42:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44980 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1GITmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 15:42:11 -0400
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
To: fengguang.wu@intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: [PATCH 3/3] mm/readahead: Move the check for ra_pages after VM_SequentialReadHint()
Date: Sun, 10 Jul 2011 01:11:20 +0530
Message-Id: <323ddfc402a7f7b94f0cb02bba15acb2acca786f.1310239575.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310239575.git.rprabhu@wnohang.net>
References: <cover.1310239575.git.rprabhu@wnohang.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_cache_sync_readahead checks for ra->ra_pages again, so moving the check after VM_SequentialReadHint.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 mm/filemap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 074c23d..748f720 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1566,8 +1566,6 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
 		return;
-	if (!ra->ra_pages)
-		return;
 
 	if (VM_SequentialReadHint(vma)) {
 		page_cache_sync_readahead(mapping, ra, file, offset,
@@ -1575,6 +1573,9 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
 		return;
 	}
 
+	if (!ra->ra_pages)
+		return;
+
 	/* Avoid banging the cache line if not needed */
 	if (ra->mmap_miss < MMAP_LOTSAMISS * 10)
 		ra->mmap_miss++;
-- 
1.7.6

