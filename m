Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1GITmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 15:42:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44980 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1GITmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 15:42:05 -0400
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
To: fengguang.wu@intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: [PATCH 2/3] mm/readahead: Remove file_ra_state from arguments of count_history_pages.
Date: Sun, 10 Jul 2011 01:11:19 +0530
Message-Id: <a224acf18cff069f65e7e7eb10261e7dcfbb094f.1310239575.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310239575.git.rprabhu@wnohang.net>
References: <cover.1310239575.git.rprabhu@wnohang.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count_history_pages doesn't require readahead state to calculate the offset from history.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 mm/readahead.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 867f9dd..925d3b3 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -343,7 +343,6 @@ static unsigned long get_next_ra_size(struct file_ra_state *ra,
  * 	- thrashing threshold in memory tight systems
  */
 static pgoff_t count_history_pages(struct address_space *mapping,
-				   struct file_ra_state *ra,
 				   pgoff_t offset, unsigned long max)
 {
 	pgoff_t head;
@@ -366,7 +365,7 @@ static int try_context_readahead(struct address_space *mapping,
 {
 	pgoff_t size;
 
-	size = count_history_pages(mapping, ra, offset, max);
+	size = count_history_pages(mapping, offset, max);
 
 	/*
 	 * no history pages:
-- 
1.7.6

