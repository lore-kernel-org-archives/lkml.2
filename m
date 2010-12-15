Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0LOWLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:11:25 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:39933 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab0LOWLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:11:24 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] rculist: fix borked __list_for_each_rcu() macro
Date: Wed, 15 Dec 2010 23:11:12 +0100
Message-Id: <1292451072-5095-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restores parentheses blance.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 include/linux/rculist.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index f31ef61..70d3ba5 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -244,7 +244,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 #define __list_for_each_rcu(pos, head) \
 	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
 		pos != (head); \
-		pos = rcu_dereference_raw(list_next_rcu((pos)))
+		pos = rcu_dereference_raw(list_next_rcu(pos)))
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
-- 
1.7.0.4

