Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0HXQDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:03:11 -0400
Received: from h-66-167-125-103.snvacaid.static.covad.net ([66.167.125.103]:59598
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755422Ab0HXQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:02:25 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 12:02:24 EDT
Message-Id: <20100824154901.393595624@gmail.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 Aug 2010 08:47:30 -0700
From: don.mullis@gmail.com
To: Artem.Bityutskiy@nokia.com, aelder@sgi.com, airlied@linux.ie
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Don Mullis <don.mullis@gmail.com>
Subject: [PATCH 09/10] lib/list_sort: improve list_sort() function documentation
References: <20100824154721.995117660@gmail.com>
Content-Disposition: inline; filename=lib_list_sort_-Improve-list_sort__-function-comment-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Remind users that degenerate callbacks to cmp(a, b), with a==b, are
normal.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Don Mullis <don.mullis@gmail.com>
---
 lib/list_sort.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-next/lib/list_sort.c
===================================================================
--- linux-next.orig/lib/list_sort.c	2010-08-23 22:51:19.761177595 -0700
+++ linux-next/lib/list_sort.c	2010-08-23 23:01:55.242052357 -0700
@@ -93,6 +93,13 @@ static void merge_and_restore_back_links
  * should sort before @b, and a positive value if @a should sort after
  * @b. If @a and @b are equivalent, and their original relative
  * ordering is to be preserved, @cmp must return 0.
+ *
+ * This function may be used in atomic context, and may be
+ * long-running, in which case @cmp must take care of calling
+ * 'cond_resched()' when needed. And 'list_sort()' will sometimes call
+ * @cmp with @a == @b, just to let the user call 'cond_resched()'.
+ * This "degenerate" callback comes from a loop that requires no
+ * actual comparison results, but nevertheless runs in O(n) time.
  */
 void list_sort(void *priv, struct list_head *head,
 		int (*cmp)(void *priv, struct list_head *a,

