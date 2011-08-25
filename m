Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1HYPc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:32:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33048 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1HYPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 027/118] idr: idr_for_each_entry() macro
Date: Thu, 25 Aug 2011 17:07:23 +0200
Message-Id: <1314284934-17999-28-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by the list_for_each_entry() macro
---
 include/linux/idr.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 255491c..52a9da2 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -152,4 +152,15 @@ void ida_simple_remove(struct ida *ida, unsigned int id);
 
 void __init idr_init_cache(void);
 
+/**
+ * idr_for_each_entry - iterate over an idr's elements of a given type
+ * @idp:     idr handle
+ * @entry:   the type * to use as cursor
+ * @id:      id entry's key
+ */
+#define idr_for_each_entry(idp, entry, id)				\
+	for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
+	     entry != NULL;                                             \
+	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+
 #endif /* __IDR_H__ */
-- 
1.7.4.1

