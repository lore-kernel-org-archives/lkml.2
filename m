Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1H3JHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:07:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38215 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1H3JFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/15] lru_cache.h: fix comments referring to ts_ instead of lc_
Date: Tue, 30 Aug 2011 11:05:43 +0200
Message-Id: <1314695149-387-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

For some time we contemplated calling the "struct lru_cache"
a "struct tracked_set", and some comments kept the ts_ prefix.

Fix those to match the member field names.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 lib/lru_cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index 9f353f7..4f638b8 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -378,7 +378,7 @@ struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
 	/* it was not present in the active set.
 	 * we are going to recycle an unused (or even "free") element.
 	 * user may need to commit a transaction to record that change.
-	 * we serialize on flags & TF_DIRTY */
+	 * we serialize on flags & LC_DIRTY */
 	if (test_and_set_bit(__LC_DIRTY, &lc->flags)) {
 		++lc->dirty;
 		RETURN(NULL);
-- 
1.7.4.1

