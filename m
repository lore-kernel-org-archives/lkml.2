Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1DBOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 10:09:56 -0400
Received: from relay.parallels.com ([195.214.232.42]:34883 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1DBOJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 10:09:55 -0400
Subject: [PATCH] vfs: remove rcu lock-unlock from mapping_tagged()
To: Alexander Viro <viro@zeniv.linux.org.uk>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: <linux-kernel@vger.kernel.org>
Date: Sat, 2 Apr 2011 18:09:53 +0400
Message-ID: <20110402140953.14374.69840.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radix_tree_tagged() does not require any locking.

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

