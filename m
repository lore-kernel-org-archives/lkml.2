Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0HGILh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:11:37 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26667 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0HGILH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:11:07 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] lib/list_sort: test: unify test messages
Date: Sat,  7 Aug 2010 11:10:44 +0300
Message-Id: <1281168645-18413-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 07 Aug 2010 08:11:00.0556 (UTC) FILETIME=[125798C0:01CB3608]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch unifies 'list_sort_test()' messages a bit and makes sure
all of them start with the "list_sort_test:" prefix to make it obvious
for users where the messages come from.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index b9a9474..44dbdec 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -170,12 +170,12 @@ static int __init list_sort_test(void)
 	struct list_head *cur, *tmp;
 	LIST_HEAD(head);
 
-	printk(KERN_DEBUG "testing list_sort()\n");
+	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
-			printk(KERN_ERR "cancel list_sort() testing - cannot "
+			printk(KERN_ERR "list_sort_test: error: cannot "
 					"allocate memory\n");
 			goto exit;
 		}
@@ -192,30 +192,31 @@ static int __init list_sort_test(void)
 		int cmp_result;
 
 		if (cur->next->prev != cur) {
-			printk(KERN_ERR "list_sort() returned "
-					"a corrupted list!\n");
+			printk(KERN_ERR "list_sort_test: error: list is "
+					"corrupted\n");
 			goto exit;
 		}
 
 		cmp_result = cmp(NULL, cur, cur->next);
 		if (cmp_result > 0) {
-			printk(KERN_ERR "list_sort() failed to sort!\n");
+			printk(KERN_ERR "list_sort_test: error: list is not "
+					"sorted\n");
 			goto exit;
 		}
 
 		el = container_of(cur, struct debug_el, list);
 		el1 = container_of(cur->next, struct debug_el, list);
 		if (cmp_result == 0 && el->serial >= el1->serial) {
-			printk(KERN_ERR "list_sort() failed to preserve order "
-					"of equivalent elements!\n");
+			printk(KERN_ERR "list_sort_test: error: order of "
+					"equivalent elements not preserved\n");
 			goto exit;
 		}
 		count++;
 	}
 
 	if (count != TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort() returned list of "
-				"different length!\n");
+		printk(KERN_ERR "list_sort_test: error: bad list length %d",
+				count);
 		goto exit;
 	}
 
-- 
1.7.1.1

