Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1GQLfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 07:35:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:46571 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1GQLf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 07:35:28 -0400
Subject: [PATCH] mm: remove useless rcu lock-unlock from mapping_tagged()
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Sun, 17 Jul 2011 15:35:23 +0400
Message-ID: <20110717113522.17196.13682.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radix_tree_tagged() is lockless, it does not require any protection.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/page-writeback.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 31f6988..919b45e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1405,10 +1405,6 @@ EXPORT_SYMBOL(test_set_page_writeback);
  */
 int mapping_tagged(struct address_space *mapping, int tag)
 {
-	int ret;
-	rcu_read_lock();
-	ret = radix_tree_tagged(&mapping->page_tree, tag);
-	rcu_read_unlock();
-	return ret;
+	return radix_tree_tagged(&mapping->page_tree, tag);
 }
 EXPORT_SYMBOL(mapping_tagged);

