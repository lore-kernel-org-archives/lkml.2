Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0HXQCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:02:52 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932083Ab0HXQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:27 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154856.514927289@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:23 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 02/10] lib/list_sort: selftest: use more appropriate printk levels
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest_-use-more-appropriate-printk-levels-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Use KERN_NORM and KERN_ERR levels for test error messages.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Don Mullis <don.mullis@gmail.com>
---
 lib/list_sort.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.674177607 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:56.351052205 -0700
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

