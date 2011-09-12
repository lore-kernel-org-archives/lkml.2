Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1ILOGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:06:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:50765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1ILOGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:06:14 -0400
Subject: [PATCH 6/5] llist: Add llist_next()
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 12 Sep 2011 16:05:48 +0200
In-Reply-To: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315836348.26517.41.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: llist: Add llist_next()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Sep 12 13:12:28 CEST 2011

So we don't have to expose the struct list_node members

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/llist.h |    5 +++++
 kernel/irq_work.c     |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)
Index: linux-2.6/include/linux/llist.h
===================================================================
--- linux-2.6.orig/include/linux/llist.h
+++ linux-2.6/include/linux/llist.h
@@ -144,6 +144,11 @@ static inline bool llist_empty(const str
 	return ACCESS_ONCE(head->first) == NULL;
 }
 
+static inline struct llist_node *llist_next(struct llist_node *node)
+{
+	return node->next;
+}
+
 /**
  * llist_add - add a new entry
  * @new:	new entry to be added
Index: linux-2.6/kernel/irq_work.c
===================================================================
--- linux-2.6.orig/kernel/irq_work.c
+++ linux-2.6/kernel/irq_work.c
@@ -110,7 +110,7 @@ void irq_work_run(void)
 	while (llnode != NULL) {
 		work = llist_entry(llnode, struct irq_work, llnode);
 
-		llnode = llnode->next;
+		llnode = llist_next(llnode);
 
 		/*
 		 * Clear the PENDING bit, after this point the @work

