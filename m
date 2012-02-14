Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab2BNI74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:59:56 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50781 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab2BNI7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:59:55 -0500
Message-ID: <4F3A2285.7060700@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 16:59:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] prio_tree: remove unnecessary code in prio_tree_replace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021322-9264-0000-0000-000000D3D670
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the code since 'node' has already been initialized in the
begin of the function

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 lib/prio_tree.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index ccfd850..423eba8 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -151,7 +151,6 @@ struct prio_tree_node *prio_tree_replace(struct prio_tree_root *root,
 		 * We can reduce root->index_bits here. However, it is complex
 		 * and does not help much to improve performance (IMO).
 		 */
-		node->parent = node;
 		root->prio_tree_node = node;
 	} else {
 		node->parent = old->parent;
-- 
1.7.7.6

