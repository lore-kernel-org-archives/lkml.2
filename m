Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3ACM0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:26:08 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:34225 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab3ACM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:26:03 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -v2 05/26] lib/: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:01 +0900
Message-Id: <1357215562-6288-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---

No change from v1

 lib/fault-inject.c | 2 +-
 lib/list_sort.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index f7210ad..c5c7a76 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -122,7 +122,7 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 			return false;
 	}
 
-	if (attr->probability <= random32() % 100)
+	if (attr->probability <= prandom_u32() % 100)
 		return false;
 
 	if (!fail_stacktrace(attr))
diff --git a/lib/list_sort.c b/lib/list_sort.c
index d7325c6..1183fa7 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -229,7 +229,7 @@ static int __init list_sort_test(void)
 			goto exit;
 		}
 		 /* force some equivalencies */
-		el->value = random32() % (TEST_LIST_LEN/3);
+		el->value = prandom_u32() % (TEST_LIST_LEN / 3);
 		el->serial = i;
 		el->poison1 = TEST_POISON1;
 		el->poison2 = TEST_POISON2;
-- 
1.7.11.7

