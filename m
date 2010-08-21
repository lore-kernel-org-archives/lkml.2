Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0HUKYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 06:24:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51634 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0HUKYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 06:24:22 -0400
Subject: Re: [PATCH 0/6] improve list_sort test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 13:22:35 +0300
Message-ID: <1282386155.2358.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Aug 2010 10:24:13.0235 (UTC) FILETIME=[00222030:01CB411B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 11:10 +0300, Artem Bityutskiy wrote:
> Hi,
> 
> while hunting a non-existing bug in 'list_sort()', I've improved the
> 'list_sort_test()' function which tests the 'list_sort()' library call. Although
> at the end I found a bug in my code, but not in 'list_sort()', I think my
> clean-ups and improvements are worth merging because they make the test function
> better.
> 
> Don, if you are ok with the patches, I'll send them to Andrew Morton.

Any feedback?

I'm also going to add this patch to the series:

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH 1/7] lib/list_sort: improve comments

Document the fact that 'list_sort()' can call the 'cmp()' function with
'a' == 'b' for the sake of 'cond_reshed()'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 lib/list_sort.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 4b5cb79..d134b41 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -93,6 +93,11 @@ static void merge_and_restore_back_links(void *priv,
  * should sort before @b, and a positive value if @a should sort after
  * @b. If @a and @b are equivalent, and their original relative
  * ordering is to be preserved, @cmp must return 0.
+ *
+ * This function can be used in atomic context. This means that @cmp has to
+ * take care of calling 'cond_resched()' when needed. And 'list_sort()' will
+ * sometimes call @cmp with @a equivalent to @b, just to let the user call
+ * 'cond_resched()'.
  */
 void list_sort(void *priv, struct list_head *head,
 		int (*cmp)(void *priv, struct list_head *a,
-- 
1.7.1.1

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

