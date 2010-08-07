Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424Ab0HGILo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:11:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26663 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab0HGILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:11:04 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] lib/list_sort: test: use more reasonable printk levels
Date: Sat,  7 Aug 2010 11:10:41 +0300
Message-Id: <1281168645-18413-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 07 Aug 2010 08:10:56.0563 (UTC) FILETIME=[0FF65030:01CB3608]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

I do not see any reason to use KERN_WARN for normal messages
and KERN_EMERG for error messages in the lib_sort testing routine.
Let's use more reasonable KERN_NORM and KERN_ERR levels.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 9dd8d4a..e0c2ccb 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -166,7 +166,7 @@ static int __init list_sort_test(void)
 	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
 	struct list_head *cur;
 
-	printk(KERN_WARNING "testing list_sort()\n");
+	printk(KERN_DEBUG "testing list_sort()\n");
 
 	cur = head;
 	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
@@ -189,17 +189,17 @@ static int __init list_sort_test(void)
 		struct debug_el *el = container_of(cur, struct debug_el, l_h);
 		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
-			printk(KERN_EMERG "list_sort() returned "
-						"a corrupted list!\n");
+			printk(KERN_ERR "list_sort() returned "
+					"a corrupted list!\n");
 			return 1;
 		} else if (cmp_result > 0) {
-			printk(KERN_EMERG "list_sort() failed to sort!\n");
+			printk(KERN_ERR "list_sort() failed to sort!\n");
 			return 1;
 		} else if (cmp_result == 0 &&
 				el->serial >= container_of(cur->next,
 					struct debug_el, l_h)->serial) {
-			printk(KERN_EMERG "list_sort() failed to preserve order"
-						 " of equivalent elements!\n");
+			printk(KERN_ERR "list_sort() failed to preserve order "
+					"of equivalent elements!\n");
 			return 1;
 		}
 		kfree(cur->prev);
@@ -207,8 +207,8 @@ static int __init list_sort_test(void)
 	}
 	kfree(cur);
 	if (count != LIST_SORT_TEST_LENGTH) {
-		printk(KERN_EMERG "list_sort() returned list of"
-						"different length!\n");
+		printk(KERN_ERR "list_sort() returned list of "
+				"different length!\n");
 		return 1;
 	}
 	return 0;
-- 
1.7.1.1

