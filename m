Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1EJNNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:13:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61456 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab1EJNNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=ecGWubzkUXwSqpo6+y72E+ZjnimOmFoCWcyQBq1pH6dMGL3Hj5n/zXWNfraXrrG1SA
         51ak21XF4kuZl1befOzs/4/bY2UbgLu6uJSU86YXfFzjmR5o4JCMpKmYVCQRl/60N5uK
         2BMW9ll4RkIT1oV+YhemOOqnUAHzxFZVJqrSY=
Subject: [PATCH v2]mm/migrate.c: clean up comment
From: "Figo.zhang" <figo1802@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 10 May 2011 21:13:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 
Content-Transfer-Encoding: 7bit
Message-ID: <1305033196.6993.1.camel@figo-desktop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up comment. prepare cgroup return 0 or -ENOMEN, others return -EAGAIN.
avoid conflict meanings.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---

 mm/migrate.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 34132f8..5f137cd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -624,6 +624,11 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 /*
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
+ * Return values:
+ * 0       - success
+ * -ENOMEM - error code
+ * -EBUSY  - error code
+ * -EAGAIN - try again
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 			struct page *page, int force, bool offlining, bool sync)
@@ -647,7 +652,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		if (unlikely(split_huge_page(page)))
 			goto move_newpage;
 
-	/* prepare cgroup just returns 0 or -ENOMEM */
 	rc = -EAGAIN;
 
 	if (!trylock_page(page)) {


