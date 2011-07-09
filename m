Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1GITlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 15:41:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44495 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1GITlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 15:41:50 -0400
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
To: fengguang.wu@intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: [PATCH 1/3] mm/readahead: Change the check for PageReadahead into an else-if
Date: Sun, 10 Jul 2011 01:11:18 +0530
Message-Id: <5a2186efeb299af150b1bef10f1c3a428722b3de.1310239575.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310239575.git.rprabhu@wnohang.net>
References: <cover.1310239575.git.rprabhu@wnohang.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 51daa88ebd8e0d437289f589af29d4b39379ea76, page_sync_readahead coalesces
async readahead into its readahead window, so another checking for that again is
not required.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 mm/filemap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a8251a8..074c23d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1115,8 +1115,7 @@ find_page:
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
-		}
-		if (PageReadahead(page)) {
+		} else if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping,
 					ra, filp, page,
 					index, last_index - index);
-- 
1.7.6

