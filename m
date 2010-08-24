Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0HXQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:02:56 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932084Ab0HXQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:28 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154858.588047317@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:26 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 05/10] lib/list_sort: selftest: improve printk wording
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-selftest_-improve-printk-wording-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Start boot printk's with "list_sort_test:" prefix to make it obvious
for users where the messages come from; other wording improvements.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Don Mullis <don.mullis@gmail.com>
---
 lib/list_sort.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.703177580 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:55.854177312 -0700
@@ -167,14 +167,14 @@ static int __init list_sort_test(void)
 	struct list_head head;
 	struct list_head *cur, *tmp;
 
-	printk(KERN_DEBUG "testing list_sort()\n");
+	printk(KERN_DEBUG "list_sort_test: starting\n");
 
 	cur = &head;
 	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
 		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
-			printk(KERN_ERR "cannot	allocate memory -- "
-					"testing aborted\n");
+			printk(KERN_ERR "list_sort_test: cannot	allocate memory"
+					" -- testing aborted\n");
 			goto exit;
 		}
 		 /* force some equivalencies */
@@ -195,26 +195,24 @@ static int __init list_sort_test(void)
 		struct debug_el *el_next;
 		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
-			printk(KERN_ERR "list_sort() returned "
-					"a corrupted list!\n");
+			printk(KERN_ERR "list_sort_test: list corrupted\n");
 			goto exit;
 		}
 		if (cmp_result > 0) {
-			printk(KERN_ERR "list_sort() failed to sort!\n");
+			printk(KERN_ERR "list_sort_test: failed to sort\n");
 			goto exit;
 		}
 		el = container_of(cur, struct debug_el, list);
 		el_next = container_of(cur->next, struct debug_el, list);
 		if (cmp_result == 0 && el->serial >= el_next->serial) {
-			printk(KERN_ERR "list_sort() failed to preserve order "
-					"of equivalent elements!\n");
+			printk(KERN_ERR "list_sort_test: failed to preserve"
+					" order of equivalent elements\n");
 			goto exit;
 		}
 		count++;
 	}
 	if (count != LIST_SORT_TEST_LENGTH) {
-		printk(KERN_ERR "list_sort() returned list of "
-				"different length!\n");
+		printk(KERN_ERR "list_sort_test: list length changed\n");
 		goto exit;
 	}
 	err = 0;

